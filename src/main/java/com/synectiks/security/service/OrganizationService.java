package com.synectiks.security.service;


import com.synectiks.security.config.Constants;
import com.synectiks.security.entities.Config;
import com.synectiks.security.entities.Organization;
import com.synectiks.security.entities.User;
import com.synectiks.security.repositories.OrganizationRepository;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class OrganizationService {

	private static final Logger logger = LoggerFactory.getLogger(OrganizationService.class);

    private final Environment env;

    @Autowired
    private OrganizationRepository organizationRepository;

    @Autowired
    private ConfigService configService;

    @Autowired
    private RestTemplate restTemplate;

    public OrganizationService(Environment env){this.env = env;}
    public Organization save(Organization organization) {
    	logger.debug("Save organization : {}", organization);
        return organizationRepository.save(organization);
    }

//    @Transactional(readOnly = true)
    public List<Organization> findAll(){
    	logger.debug("Get all organizations");
        return organizationRepository.findAll();
    }

//    @Transactional(readOnly = true)
    public Optional<Organization> findOne(Long id) {
    	logger.debug("Get an organization : {}", id);
        return organizationRepository.findById(id);
    }

    public void delete(Long id) {
    	logger.debug("Request to delete an organization : {}", id);
        organizationRepository.deleteById(id);
    }

//    @Transactional(readOnly = true)
    public List<Organization> search(Organization organization) {
    	logger.debug("Search organizations on given filters");
        return organizationRepository.findAll(Example.of(organization), Sort.by(Sort.Direction.DESC, "name"));
    }

//    @Transactional(readOnly = true)
    public Organization getOrganizationByName(String orgName) {
        logger.debug("Get an organization by name: {}", orgName);
        return organizationRepository.getOrganizationByName(orgName);
    }

    public void saveOrUpdateOrganization(MultipartFile multipartFile, String localOrganizationName, User user, String targetService, AppkubeAwsS3Service appkubeAwsS3Service) {
        logger.info("Creating new organization: " + localOrganizationName);
        if (!StringUtils.isBlank(localOrganizationName)) {
            Organization organization = new Organization();
            organization.setName(localOrganizationName.toUpperCase());
            organization.setCreatedAt(user.getCreatedAt());
            organization.setCreatedBy(user.getCreatedBy());
            organization.setStatus(Constants.ACTIVE);
            organization = save(organization);

            try {
                uploadUserProfileImageToS3(multipartFile, user, organization, appkubeAwsS3Service );
            } catch (IOException e) {
                logger.error("Exception. Organization profile image could not be saved in s3", e);
            }
            syncOrgWithCmdb(organization);
            user.setOrganization(organization);
        }
    }

//    public String resolveTargetServiceUrl(String targetService){
//        if(!StringUtils.isBlank(targetService)){
//            if(Constants.DEFAULT_TARGET_SERVICE.equalsIgnoreCase(targetService)){
//                Organization organization = this.getOrganizationByName(Constants.DEFAULT_ORGANIZATION);
//                Config config = configService.findByKeyAndOrganizationId(Constants.CMDB_ORGANIZATION_URL, organization.getId());
//                return config.getValue();
//            }
//        }
//        return null;
//    }

    private void uploadUserProfileImageToS3(MultipartFile multipartFile, User user, Organization organization, AppkubeAwsS3Service appkubeAwsS3Service) throws IOException {
        if (multipartFile != null) {
            String orgFileName = org.springframework.util.StringUtils.cleanPath(multipartFile.getOriginalFilename());
            String ext = "";
            if (orgFileName.lastIndexOf(".") != -1) {
                ext = orgFileName.substring(orgFileName.lastIndexOf(".") + 1);
            }
            String filename = organization.getName()+"."+ext;
            Organization defaultOrganization = getOrganizationByName(Constants.DEFAULT_ORGANIZATION);
            Config configAwsBucket = configService.findByKeyAndOrganizationId(Constants.GLOBAL_AWS_S3_BUCKET_NAME_FOR_ORG_PROFILE_IMAGES, defaultOrganization.getId());
            Config configAwsBucketFolderLocation = configService.findByKeyAndOrganizationId(Constants.GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_ORG_PROFILE_IMAGES, defaultOrganization.getId());
            File file = new File(System.getProperty("java.io.tmpdir")+File.separatorChar+filename);
            try (OutputStream os = new FileOutputStream(file)) {
                os.write(multipartFile.getBytes());
            }
            file.deleteOnExit();
            boolean isSuccess = appkubeAwsS3Service.uploadToS3(configAwsBucket.getValue(),configAwsBucketFolderLocation.getValue(), filename, file);
            if(isSuccess){
                organization.setFileName(filename);
                organization.setFileStorageLocationType("S3");
            }

            file.delete();

            logger.debug("user profile image saved successfully");
        }
    }


    @PostConstruct
    @Scheduled(cron = "0 */2 * ? * *") // runs every two mins
    public void syncOrgWithCmdbAfterServerStart() {
        logger.info("Synchronizing organizations with cmdb at application start-up");
        List<Organization> organizationList = findAll().stream().filter(obj -> obj.getCmdbOrgId() == null).collect(Collectors.toList());
        for(Organization organization: organizationList){
            syncOrgWithCmdb(organization);
        }
    }

    public void syncOrgWithCmdb(Organization organization){
        String baseUrl = env.getProperty("synectiks-cmdb-service.url")+"/organization";
        String getByNameUrl = baseUrl+"/get-by-name/"+organization.getName().toUpperCase();
        logger.info("Getting list of organization from remote service. Remote service url: {}", getByNameUrl);
        Organization remoteOrg = null;
        try{
            ResponseEntity<Organization> response = restTemplate.exchange( getByNameUrl, HttpMethod.GET,null, new ParameterizedTypeReference<Organization>(){});
            if(response != null && response.getBody() != null){
                logger.debug("Checking url response");
                remoteOrg = response.getBody();
            }
        }catch (Exception e){
            logger.warn("Organization not found in remote CMDB service");
        }

        if(remoteOrg != null){
            logger.debug("Given organization found in CMDB, saving its reference in local organization. Remote organization id: {}",remoteOrg.getId());
            //keep cmdb reference in local organization
            organization.setCmdbOrgId(remoteOrg.getId());
            organization = save(organization);
            try{
                logger.debug("Passing local organization reference to remote cmdb service");
                //update cmdb organization with local organization reference
                remoteOrg.setSecurityServiceOrgId(organization.getId());
                restTemplate.patchForObject(baseUrl, remoteOrg, Organization.class);
            }catch(Exception e){
                logger.warn("Due to some exception, cannot pass local organization reference to update remote cmdb organization service. Error: {}",e.getMessage());
            }

        }else {
            logger.info("Given organization not found at remote service. Adding this organization to the remote service. Remote service URL: {}", baseUrl);
            try{
                Organization org = new Organization();
                org.setName(organization.getName());
                org.setSecurityServiceOrgId(organization.getId());
                ResponseEntity<Organization> result = restTemplate.postForEntity(baseUrl, org, Organization.class);
                if(result != null && result.getBody() != null){
                    // if successfully pushed, keep its reference in local organization
                    remoteOrg = result.getBody();
                    logger.debug("Saving remote reference of remote organization in local organization. Remote organization id: {}",remoteOrg.getId());
                    organization.setCmdbOrgId(remoteOrg.getId());
                    organization = save(organization);
                }
            }catch (Exception e){
                logger.warn("Due to some exception, cannot pass local organization reference to add to remote cmdb organization service. Error: {}",e.getMessage());
            }
        }

    }
}
