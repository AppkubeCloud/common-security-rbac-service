/**
 *
 */
package com.synectiks.security.controllers;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.synectiks.security.config.Constants;
import com.synectiks.security.config.IConsts;
import com.synectiks.security.config.IDBConsts;
import com.synectiks.security.entities.*;
import com.synectiks.security.interfaces.IApiController;
import com.synectiks.security.mfa.GoogleMultiFactorAuthenticationService;
import com.synectiks.security.repositories.*;
import com.synectiks.security.service.*;
import com.synectiks.security.util.*;
import com.warrenstrange.googleauth.GoogleAuthenticator;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authc.credential.DefaultPasswordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author Rajesh
 */
@RestController
@RequestMapping(path = IApiController.SEC_API + IApiController.URL_USER, method = RequestMethod.POST)
@CrossOrigin
public class UserController implements IApiController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    //	@Value("${synectiks.cmdb.organization.url}")
//	private String cmdbOrgUrl;
    private final DefaultPasswordService shiroPasswordService = new DefaultPasswordService();

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PolicyRepository policyRepository;

    @Autowired
    private PermissionRepository permissionRepository;

    @Autowired
    private PermissionCategoryRepository permissionCategoryRepository;

    @Autowired
    private MailService mailService;

    @Autowired
    private TemplateReader templateReader;

    @Autowired
    private GoogleMultiFactorAuthenticationService googleMultiFactorAuthenticationService;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private AppkubeAwsEmailService appkubeAwsEmailService;

    @Autowired
    private AppkubeAwsS3Service appkubeAwsS3Service;

    @Autowired
    private ConfigService configService;

    @Autowired
    private OrganizationService organizationService;

    @Autowired
    private EmailQueueService emailQueueService;


    @Override
    @RequestMapping(path = IConsts.API_FIND_ALL, method = RequestMethod.GET)
    public ResponseEntity<Object> findAll(HttpServletRequest request) {
        logger.info("Request to get all the users irrespective of organization");
        List<User> entities = userRepository.findAll();
        for (User user : entities) {
            if (!StringUtils.isBlank(user.getFileName()) && "S3".equalsIgnoreCase(user.getFileStorageLocationType())) {
                user.setProfileImage(downloadFileFromS3(user.getFileName()));
            }
        }
        return ResponseEntity.status(HttpStatus.OK).body(entities);
    }

    @RequestMapping(path = IConsts.API_FIND_BY_OWNER, method = RequestMethod.GET)
    public ResponseEntity<Object> findByOwnerId(@RequestParam(name = "ownerId", required = true) Long ownerId,
                                                HttpServletRequest request) {
        logger.info("Request to get all the users of a given owner. Owner id: {}", ownerId);
        List<User> entities = userRepository.findByOwnerId(ownerId);
        for (User user : entities) {
            if (!StringUtils.isBlank(user.getFileName()) && "S3".equalsIgnoreCase(user.getFileStorageLocationType())) {
                user.setProfileImage(downloadFileFromS3(user.getFileName()));
            }
        }
        return ResponseEntity.status(HttpStatus.OK).body(entities);
    }

    /**
     * type - SUPER_ADMIN, ADMIN, USER etc..
     * targetService - cmdb etc...
     * If targetService provided, API tries to push the newly created organization to the given service
     * using POST API of target service.
     * organization - A name, if not found API tries to push it into the organization table and this will become
     * organization of user
     * roleId - comma separated list of role id. e.g. 1,2,3
     * errorOnOrgFound - boolean flag to allow second organization admin. true - not allow, false - allow
     *
     * @param type
     * @param organizationName
     * @param username
     * @param password
     * @param email
     * @param ownerId
     * @param targetService
     * @param roleId
     * @param errorOnOrgFound
     * @param firstName
     * @param middleName
     * @param lastName
     * @param userProfileImage
     * @param request
     * @return
     */
    @RequestMapping(IConsts.API_CREATE)
    public ResponseEntity<Object> create(@RequestParam(name = "type", required = false) String type,
                                         @RequestParam(name = "organization", required = false) String organizationName,
                                         @RequestParam("username") String username,
                                         @RequestParam(name = "password", required = false) String password,
                                         @RequestParam(name = "email", required = false) String email,
                                         @RequestParam(name = "ownerId", required = false) Long ownerId,
                                         @RequestParam(name = "targetService", required = false) String targetService,
                                         @RequestParam(name = "roleId", required = false) String roleId,
                                         @RequestParam(name = "errorOnOrgFound", required = true) boolean errorOnOrgFound,
                                         @RequestParam(name = "firstName", required = false) String firstName,
                                         @RequestParam(name = "middleName", required = false) String middleName,
                                         @RequestParam(name = "lastName", required = false) String lastName,
                                         @RequestParam(name = "file", required = false) MultipartFile userProfileImage,
                                         @RequestParam(name = "orgProfileFile", required = false) MultipartFile orgProfileFile,
                                         HttpServletRequest request) {
        logger.info("Request to create new user. user name: {}", username);
        // check if user already exists
        User user = this.userRepository.findByUsername(username);
        if (user != null) {
            logger.error("User name/Login id already exists. user name: {}", username);
            Status st = setMessage(HttpStatus.valueOf(421).value(), "ERROR", "User name/Login id already exist", null);
            return ResponseEntity.status(HttpStatus.valueOf(421)).body(st);
        }
        // check for duplicate email
        user = userRepository.findByEmail(email);
        if (user != null) {
            logger.error("Email already registered. email: {}", email);
            Status st = setMessage(HttpStatus.valueOf(422).value(), "ERROR", "Email already registered", null);
            return ResponseEntity.status(HttpStatus.valueOf(422)).body(st);
        }
        user = new User();
        createUser(user, type, username, password, ownerId, email, firstName, middleName, lastName, Constants.USER_REQUEST_TYPE_APPKUBE, Constants.STATUS_ACCEPTED);

        if (!StringUtils.isBlank(organizationName)) {
            Organization existingOrg = organizationService.getOrganizationByName(organizationName);
            if (existingOrg != null) {
                if (errorOnOrgFound) {
                    Status st = setMessage(HttpStatus.valueOf(418).value(), "ERROR", "Organization already exists. Please contact organization administrator to get your login credentials", null);
                    return ResponseEntity.status(HttpStatus.valueOf(418)).body(st);
                }
                //if errorOnOrgFound flag is false, no need to throw error, silently add the organization to the user
                user.setOrganization(existingOrg);
            } else {
                logger.info("Given organization not present. Organization: {}", organizationName);
                organizationService.saveOrUpdateOrganization(orgProfileFile, organizationName, user, targetService, appkubeAwsS3Service);
            }
        }

        //this statement executes when user created with the create user functionality of UI.
        if (!StringUtils.isBlank(roleId) && Constants.USER_TYPE_USER.equalsIgnoreCase(type)) {
            logger.info("Assigning role groups to user");
            List<Role> roleList = new ArrayList<>();
            StringTokenizer token = new StringTokenizer(roleId, ",");
            while (token.hasMoreTokens()) {
                Optional<Role> oRole = roleRepository.findById(Long.parseLong(token.nextToken()));
                if (oRole.isPresent()) {
                    logger.debug("Role found. Role name: {}, is group: {}", oRole.get().getName(), oRole.get().isGrp());
                    roleList.add(oRole.get());
                }
            }
            if (roleList.size() > 0) {
                user.setRoles(roleList);
            }
        }

        //this statement executes when user created with the sign-up page.
        if (StringUtils.isBlank(roleId) && Constants.USER_TYPE_ADMIN.equalsIgnoreCase(type) && ownerId == null) {
            logger.debug("Assigning default role group for organization admin");
//            List<Role> roleList = (List<Role>) roleRepository.findByCreatedByAndGrp(Constants.SYSTEM_ACCOUNT, true);
            List<Role> roleList = (List<Role>) roleRepository.findByGrpAndIsDefault(true, true);
            if (roleList.size() > 0) {
                user.setRoles(roleList);
            }
        }
        if (userProfileImage != null) {
            logger.debug("Saving user profile image to aws s3");
            try {
                uploadUserProfileImageToS3(userProfileImage, user);
            } catch (Throwable th) {
                logger.error("Exception in uploading user profile image to aws s3: ", th);
            }
        }

        user = userRepository.save(user);
        logger.info("User created successfully. User id: {}", user.getId());

        if (!StringUtils.isBlank(email)) {
            logger.info("Pushing new user registration mail to email_queue");
            setNewUserMailToQueue(user, Constants.TYPE_NEW_USER);
        }

        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    private void setNewUserMailToQueue(User user, String type) {
        Organization organization = organizationService.getOrganizationByName(Constants.DEFAULT_ORGANIZATION);
        Config configEmailFrom = configService.findByKeyAndOrganizationId(Constants.GLOBAL_APPKUBE_EMAIL_SENDER, organization.getId());
        EmailQueue emailQueue = new EmailQueue();
        emailQueue.setCreatedAt(user.getCreatedAt());
        emailQueue.setCreatedBy(user.getCreatedBy());
        emailQueue.setStatus(Constants.STATUS_PENDING);
        emailQueue.setMailTo(user.getEmail());
        emailQueue.setMailFrom(configEmailFrom.getValue());
        emailQueue.setMailType(type);
        emailQueue.setUserName(user.getUsername());
        emailQueue.setOrganization(user.getOrganization());
        emailQueueService.save(emailQueue);
    }

    @RequestMapping("/new-org-user")
    public ResponseEntity<Object> createNewOrgUser(@RequestParam(name = "organization", required = true) String organizationName,
                                                   @RequestParam(name = "email", required = true) String email,
                                                   HttpServletRequest request) {
        logger.info("Request to create new user in organization. Organization: {}", organizationName);

        // Check email already registered with any user
        logger.info("Checking user email already registered with any user");
        User user = userRepository.findByEmail(email);
        if (user != null) {
            logger.error("Email already exist");
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Email already exist", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        user = this.userRepository.findByUsername(email);
        if (user != null) {
            logger.error("User name/Login id already exists. user name: {}", email);
            Status st = setMessage(HttpStatus.valueOf(421).value(), "ERROR", "User name/Login id already exist", null);
            return ResponseEntity.status(HttpStatus.valueOf(421)).body(st);
        }

        user = new User();
        createUser(user, Constants.USER_TYPE_USER, email, null, null, email, null, null, null, Constants.USER_REQUEST_TYPE_ONLINE, Constants.STATUS_NEW);
        user.setActive(false);
        if (!StringUtils.isBlank(organizationName)) {
            Organization organization = organizationService.getOrganizationByName(organizationName);
            if (organization == null) {
                logger.error("Given organization: {} not found", organizationName);
                Status st = setMessage(HttpStatus.valueOf(425).value(), "ERROR", "Organization not found. Given organization name: " + organizationName, null);
                return ResponseEntity.status(HttpStatus.valueOf(425)).body(st);
            }
            user.setOrganization(organization);
        }

        logger.info("Saving new org user request: " + user);

        user = userRepository.save(user);
        logger.info("Pushing new org user request mail to email_queue");
        setNewUserMailToQueue(user, Constants.USER_REQUEST_TYPE_ONLINE);
        Status st = setMessage(HttpStatus.CREATED.value(), Constants.SUCCESS, "New org user request saved.", null);
        return ResponseEntity.status(HttpStatus.CREATED).body(st);
    }

    private void uploadUserProfileImageToS3(MultipartFile multipartFile, User user) throws IOException {
        if (multipartFile != null) {
            String orgFileName = org.springframework.util.StringUtils.cleanPath(multipartFile.getOriginalFilename());
            String ext = "";
            if (orgFileName.lastIndexOf(".") != -1) {
                ext = orgFileName.substring(orgFileName.lastIndexOf(".") + 1);
            }
            String filename = user.getUsername() + "." + ext;
            Organization organization = organizationService.getOrganizationByName(Constants.DEFAULT_ORGANIZATION);
            Config configAwsBucket = configService.findByKeyAndOrganizationId(Constants.GLOBAL_AWS_S3_BUCKET_NAME_FOR_USER_IMAGES, organization.getId());
            Config configAwsBucketFolderLocation = configService.findByKeyAndOrganizationId(Constants.GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_USER_IMAGES, organization.getId());
            File file = new File(System.getProperty("java.io.tmpdir") + File.separatorChar + filename);
            try (OutputStream os = new FileOutputStream(file)) {
                os.write(multipartFile.getBytes());
            }
            file.deleteOnExit();
            boolean isSuccess = appkubeAwsS3Service.uploadToS3(configAwsBucket.getValue(), configAwsBucketFolderLocation.getValue(), filename, file);
            if (isSuccess) {
                user.setProfileImage(multipartFile.getBytes());
                user.setFileName(filename);
                user.setFileStorageLocationType("S3");
            }

            file.delete();

            logger.debug("user profile image saved successfully");
        }
    }

    private byte[] downloadFileFromS3(String fileName) {
        if (StringUtils.isBlank(fileName)) {
            logger.warn("File name not provided. File cannot be downloaded from s3");
            return null;
        }
        Organization organization = organizationService.getOrganizationByName(Constants.DEFAULT_ORGANIZATION);
        Config configAwsBucket = configService.findByKeyAndOrganizationId(Constants.GLOBAL_AWS_S3_BUCKET_NAME_FOR_USER_IMAGES, organization.getId());

        Config configAwsBucketFolderLocation = configService.findByKeyAndOrganizationId(Constants.GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_USER_IMAGES, organization.getId());
        File f = appkubeAwsS3Service.downloadFromS3(configAwsBucket.getValue(), configAwsBucketFolderLocation.getValue(), fileName);
        return IUtils.convertFileToByteArray(f);
    }

    @Override
    @RequestMapping(path = IConsts.API_FIND_ID, method = RequestMethod.GET)
    public ResponseEntity<Object> findById(@PathVariable("id") Long id) {
        logger.info("Request to get user by id: {}", id);
        Optional<User> oEntity = userRepository.findById(id);
        if (!oEntity.isPresent()) {
            logger.error("User not found. user id: {}", id);
            Status st = setMessage(HttpStatus.NOT_FOUND.value(), "ERROR", "User not found. User id: " + id, null);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(st);
        }
        User user = oEntity.get();
        if (!StringUtils.isBlank(user.getFileName()) && "S3".equalsIgnoreCase(user.getFileStorageLocationType())) {
            user.setProfileImage(downloadFileFromS3(oEntity.get().getFileName()));
        }
        return ResponseEntity.status(HttpStatus.OK).body(user);
    }

    @Override
    @RequestMapping(IConsts.API_DELETE_ID)
    public ResponseEntity<Object> deleteById(@PathVariable("id") Long id) {
        try {
            Optional<User> oUser = userRepository.findById(id);
            userRepository.deleteById(id);
        } catch (Throwable th) {
            logger.error(th.getMessage(), th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th);
        }
        return ResponseEntity.status(HttpStatus.OK).body("User deleted Successfully");
    }

    @RequestMapping(IConsts.API_UPDATE)
    public ResponseEntity<Object> update(@RequestParam(name = "id", required = true) Long id,
                                         @RequestParam(name = "type", required = false) String type,
                                         @RequestParam(name = "organization", required = false) String organizationName,
                                         @RequestParam(name = "password", required = false) String password,
                                         @RequestParam(name = "email", required = false) String email,
                                         @RequestParam(name = "ownerId", required = false) Long ownerId,
                                         @RequestParam(name = "roleId", required = false) String roleId,
                                         @RequestParam(name = "firstName", required = false) String firstName,
                                         @RequestParam(name = "middleName", required = false) String middleName,
                                         @RequestParam(name = "lastName", required = false) String lastName,
                                         @RequestParam(name = "file", required = false) MultipartFile file,
                                         HttpServletRequest request) {
        logger.debug("Request to update user. Id: {}", id);

        if (!userRepository.existsById(id)) {
            Status st = setMessage(HttpStatus.valueOf(423).value(), "ERROR", "User with the given id not found. Given user id: " + id, null);
            return ResponseEntity.status(HttpStatus.valueOf(423)).body(st);
        }
        if (!StringUtils.isBlank(email)) {
            User userWithMail = userRepository.findByEmail(email);
            if (userWithMail != null && id.compareTo(userWithMail.getId()) != 0) {
                Status st = setMessage(HttpStatus.valueOf(424).value(), "ERROR", "Email registered with some other user", null);
                return ResponseEntity.status(HttpStatus.valueOf(424)).body(st);
            }
        }

        User existingUser = userRepository.findById(id).get();

        if (!StringUtils.isBlank(organizationName)) {
            Organization organization = organizationService.getOrganizationByName(organizationName);
            if (organization == null) {
                Status st = setMessage(HttpStatus.valueOf(425).value(), "ERROR", "Organization not found. Given organization name: " + organizationName, null);
                return ResponseEntity.status(HttpStatus.valueOf(425)).body(st);
            }
            existingUser.setOrganization(organization);
        }

        existingUser.setEmail(email);

        if (!StringUtils.isBlank(type)) {
            existingUser.setType(type);
        }

        if (!StringUtils.isBlank(password)) {
            existingUser.setPassword(shiroPasswordService.encryptPassword(password));
            existingUser.setEncPassword((EncryptionDecription.encrypt(password)));
        }

        if (ownerId != null) {
            Optional<User> oOwner = userRepository.findById(ownerId);
            if (oOwner.isPresent()) {
                existingUser.setOwner(oOwner.get());
                existingUser.setUpdatedBy(oOwner.get().getUsername());
            } else {
                existingUser.setUpdatedBy(existingUser.getUsername());
            }
        }

        if (!StringUtils.isBlank(roleId)) {
            List<Role> roleList = new ArrayList<>();
            StringTokenizer token = new StringTokenizer(roleId, ",");
            while (token.hasMoreTokens()) {
                Optional<Role> oRole = roleRepository.findById(Long.parseLong(token.nextToken()));
                if (oRole.isPresent()) {
                    logger.debug("Role found. Role name: {}, is group: {}", oRole.get().getName(), oRole.get().isGrp());
                    roleList.add(oRole.get());
                }
            }
            if (roleList.size() > 0) {
                existingUser.setRoles(roleList);
            }
        }

        if (!StringUtils.isBlank(firstName)) {
            existingUser.setFirstName(firstName);
        }
        if (!StringUtils.isBlank(middleName)) {
            existingUser.setMiddleName(middleName);
        }
        if (!StringUtils.isBlank(lastName)) {
            existingUser.setLastName(lastName);
        }

        Date currentDate = new Date();
        existingUser.setUpdatedAt(currentDate);
        try {
            uploadUserProfileImageToS3(file, existingUser);
        } catch (Throwable th) {
            logger.error("Exception in uploading file to aws s3: ", th);
        }
        logger.info("Updating user: ");
        userRepository.save(existingUser);
        Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "User updated successfully", existingUser);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }

    @Override
    @RequestMapping(IConsts.API_DELETE)
    public ResponseEntity<Object> delete(@RequestBody ObjectNode entity) {
        if (!IUtils.isNull(entity.get(IDBConsts.Col_ID))) {
            return deleteById(entity.get(IDBConsts.Col_ID).asLong());
        }
        return ResponseEntity.status(HttpStatus.PRECONDITION_FAILED).body("Not a valid entity");
    }

    @RequestMapping(method = RequestMethod.GET, path = IApiController.URL_SEARCH)
    public ResponseEntity<Object> search(@RequestBody ObjectNode reqObj) {
        boolean isFilter = false;
        User user = null;
        List<User> list = null;
        try {
            if (reqObj.get("isExternalSecurityEnable ") != null
                && reqObj.get("isExternalSecurityEnable ").asBoolean() == false) {
                list = this.userRepository.findAll(Sort.by(Direction.ASC, "username"));
                logger.debug("Getting all the users");
                return ResponseEntity.status(HttpStatus.OK).body(list);
            }

            if (reqObj.get("id") != null) {
                user.setId(Long.parseLong(reqObj.get("id").asText()));
                isFilter = true;
            }
            if (reqObj.get("username") != null) {
                user.setUsername(reqObj.get("username").asText());
                isFilter = true;
            }
            if (reqObj.get("email") != null) {
                user.setEmail(reqObj.get("email").asText());
                isFilter = true;
            }
            if (reqObj.get("type") != null) {
                user.setType(reqObj.get("type").asText());
                isFilter = true;
            }
            if (reqObj.get("organization") != null) {
                Organization organization = organizationService.getOrganizationByName(reqObj.get("organization").asText());
//				organization.setName(reqObj.get("organization").asText().toUpperCase());
//				Optional<Organization> oOrg = this.organizationRepository.findOne(Example.of(organization));

                if (organization != null) {
                    user.setOrganization(organization);
                }
                isFilter = true;
            }

            if (reqObj.get("active") != null) {
                user.setActive(reqObj.get("active").asBoolean());
                isFilter = true;
            }

            if (reqObj.get("ownerId") != null) {
                Optional<User> parent = this.userRepository.findById(reqObj.get("ownerId").asLong());
                if (parent.isPresent()) {
                    user.setOwner(parent.get());
                }
                isFilter = true;
            }

            if (isFilter) {
                list = this.userRepository.findAll(Example.of(user), Sort.by(Direction.ASC, "username"));
            } else {
                list = this.userRepository.findAll(Sort.by(Direction.ASC, "username"));
            }
            for (User obj : list) {
                if (!StringUtils.isBlank(obj.getFileName()) && "S3".equalsIgnoreCase(obj.getFileStorageLocationType())) {
                    obj.setProfileImage(downloadFileFromS3(obj.getFileName()));
                }
            }
        } catch (Throwable th) {
            logger.error(th.getMessage(), th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th);
        }
        return ResponseEntity.status(HttpStatus.OK).body(list);
    }

    private void createUser(User user, String type, String username, String password, Long ownerId, String email, String firstName, String middleName, String lastName, String requestType, String status) {
        if (user == null) {
            user = new User();
        }
        if (!StringUtils.isBlank(status)) {
            user.setStatus(status);
        }
        if (!StringUtils.isBlank(requestType)) {
            user.setRequestType(requestType);
        }
        if (!StringUtils.isBlank(type)) {
            user.setType(type.toUpperCase());
        }
        if (!StringUtils.isBlank(username)) {
            user.setUsername(username);
        }
        if (!IUtils.isNullOrEmpty(password) && !password.startsWith("$shiro1$")) {
            user.setPassword(shiroPasswordService.encryptPassword(password));
            user.setEncPassword((EncryptionDecription.encrypt(password)));
        } else {
            //set default password
            String tempPwd = RandomGenerator.getTemporaryPassword();
            user.setPassword(shiroPasswordService.encryptPassword(tempPwd));
            user.setEncPassword(EncryptionDecription.encrypt(tempPwd));
        }

        Date currentDate = new Date();
        user.setCreatedAt(currentDate);
        user.setUpdatedAt(currentDate);

        user.setActive(true);

        if (!StringUtils.isBlank(email)) {
            user.setEmail(email);
        }
        if (ownerId != null) {
            Optional<User> parent = this.userRepository.findById(ownerId);
            if (parent.isPresent()) {
                user.setOwner(parent.get());
                user.setCreatedBy(parent.get().getUsername());
                user.setUpdatedBy(parent.get().getUsername());
//            user.setOwnerId(reqObj.get("ownerId") != null ? reqObj.get("ownerId").asLong() : null);
            }
        } else {
            user.setCreatedBy(Constants.SYSTEM_ACCOUNT);
            user.setUpdatedBy(Constants.SYSTEM_ACCOUNT);
        }
        if (!StringUtils.isBlank(firstName)) {
            user.setFirstName(firstName);
        }
        if (!StringUtils.isBlank(middleName)) {
            user.setMiddleName(middleName);
        }
        if (!StringUtils.isBlank(lastName)) {
            user.setLastName(lastName);
        }
    }

    @RequestMapping(path = "/updateOrganization", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> updateOrganization(@RequestBody Map<String, String> reqObj) {
        logger.info("Request to update user's organization. User: " + reqObj.get("userName") + ", Organization: "
            + reqObj.get("organizationName"));
        User user = new User();
        user.setUsername(reqObj.get("userName"));
        Optional<User> oUser = this.userRepository.findOne(Example.of(user));
        if (oUser.isPresent()) {
            user = oUser.get();
        }

        Date currentDate = new Date();

        Organization organization = organizationService.getOrganizationByName(reqObj.get("organizationName"));
//		organization.setName(reqObj.get("organizationName").toUpperCase());
//		Optional<Organization> oOrg = this.organizationRepository.findOne(Example.of(organization));
        if (organization != null) {
            logger.info("Organization with the given name found. Assigning existing organization to user");
            user.setOrganization(organization);
        } else {
            logger.info("Organization no found. Creating new organization");
            organization.setCreatedAt(currentDate);
            organization.setUpdatedAt(currentDate);
            organization.setCreatedBy(reqObj.get("userName"));
            organization.setUpdatedBy(reqObj.get("userName"));
            organization = organizationService.save(organization);
            user.setOrganization(organization);
        }

        try {
            user.setUpdatedAt(currentDate);
            user.setUpdatedBy(reqObj.get("userName"));
            userRepository.save(user);
            logger.info("User's organization updated: " + user);

        } catch (Throwable th) {
            logger.error("Update organization failed. Exception: ", th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th);
        }
        return ResponseEntity.status(HttpStatus.OK).body(user);
    }

    @RequestMapping(path = "/updateAssignedRoleGroups", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> updateAssignedRoleGroups(@RequestBody User user) {
        logger.info("Request to update user's role group");
        try {
            userRepository.save(user);
        } catch (Exception e) {
            logger.error("Assign role groups to user failed. Exception: ", e);
            Status st = new Status();
            st.setCode(HttpStatus.EXPECTATION_FAILED.value());
            st.setType("ERROR");
            st.setMessage("Assign role groups to user failed");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(e);
        }
        return ResponseEntity.status(HttpStatus.OK).body(user);
    }

    @RequestMapping(path = "/updateUserRoles")
    public ResponseEntity<Object> updateUserRoles(@RequestParam String userName, @RequestParam String roleId) {
        logger.info("Request to update user's role");
        Status st = new Status();
        try {
            User user = this.userRepository.findByUsername(userName);

            List<Role> roleList = new ArrayList<>();
            StringTokenizer token = new StringTokenizer(roleId, ",");
            while (token.hasMoreTokens()) {
                Optional<Role> oRole = roleRepository.findById(Long.parseLong(token.nextToken()));
                if (oRole.isPresent()) {
                    roleList.add(oRole.get());
                }
            }
            user.setRoles(roleList);
            userRepository.save(user);

            st.setCode(HttpStatus.OK.value());
            st.setType("SUCCESS");
            st.setMessage("User's role updated successfully");
            st.setObject(user);
            return ResponseEntity.status(HttpStatus.OK).body(st);
        } catch (Exception e) {
            logger.error("Updating user's role failed. Exception: ", e);
            st.setCode(HttpStatus.EXPECTATION_FAILED.value());
            st.setType("ERROR");
            st.setMessage("Updating user's role failed");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(e);
        }
    }

    @RequestMapping(path = "/assingRoleGroupToUsers")
    public ResponseEntity<Object> assingRoleGroupToUsers(@RequestBody ObjectNode reqObj, HttpServletRequest request) {
        Status st = null;
        if (reqObj.get("roleId") == null) {
            st = new Status();
            st.setCode(HttpStatus.EXPECTATION_FAILED.value());
            st.setType("ERROR");
            st.setMessage("Role id not provided");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if (reqObj.get("userIds") == null) {
            st = new Status();
            st.setCode(HttpStatus.EXPECTATION_FAILED.value());
            st.setType("ERROR");
            st.setMessage("User id not provided");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        Long roleId = reqObj.get("roleId").asLong();
        Optional<Role> oRole = roleRepository.findById(roleId);
        if (!oRole.isPresent()) {
            logger.error("Role not found. Role id: {}", roleId);
            st = new Status();
            st.setCode(HttpStatus.EXPECTATION_FAILED.value());
            st.setType("ERROR");
            st.setMessage("Role not found");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        String userIds = reqObj.get("userIds").asText();
        logger.info("Request to add user's to role group. Role group: {}", oRole.get().getName());
        StringTokenizer token = new StringTokenizer(userIds, ",");
        while (token.hasMoreTokens()) {
            Optional<User> oUser = this.userRepository.findById(Long.parseLong(token.nextToken()));
            if (oUser.isPresent()) {
                User user = oUser.get();
                if (!user.getRoles().contains(oRole.get())) {
                    logger.debug("Adding user: {} to role group: {}", user.getUsername(), oRole.get().getName());
                    user.getRoles().add(oRole.get());
                    userRepository.save(user);

                }
            }
        }
        String msg = "User's added to role group successfully";
        st = new Status();
        st.setCode(HttpStatus.OK.value());
        st.setType("SUCCESS");
        st.setMessage(msg);
        logger.info(msg);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }

    @RequestMapping(path = "/inviteUser")
    public ResponseEntity<Object> createUserInvite(@RequestParam String username, @RequestParam String inviteeEmail) {
        logger.info("Request to create a new user invite");
        User user = this.userRepository.findByUsername(inviteeEmail);
        if (user != null) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", inviteeEmail + " already exists. Please choose a different user id", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        try {
            user = new User();
            user.setEmail(inviteeEmail);
            user.setActive(true);
            Optional<User> oUser = this.userRepository.findOne(Example.of(user));
            if (oUser.isPresent()) {
                logger.warn("Another user with email id: " + inviteeEmail + " already exists");
                Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Email id: " + inviteeEmail + " already exists", null);
                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
            }
            user.setActive(false);
            oUser = this.userRepository.findOne(Example.of(user));
            if (oUser.isPresent()) {
                logger.warn("Another user with email id: " + inviteeEmail + " already exists");
                Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Email id: " + inviteeEmail + " already exists", null);
                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
            }
        } catch (Exception e) {
            logger.warn("Email id: " + inviteeEmail + " already exists", e.getMessage());
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Email already exists", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        String invitationCode = RandomGenerator.getRandomValue();
        String activationLink = "http://" + Constants.HOST + ":" + Constants.PORT
            + "/inviteaccept.html?activation_code=" + invitationCode;
        User invitee = new User();
        try {
            User owner = new User();
            owner.setUsername(username);
            owner.setActive(true);
            Optional<User> oOwner = userRepository.findOne(Example.of(owner));
            if (!oOwner.isPresent()) {
                Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Owner not found. Please check owner's email id", null);
                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
            }
//
            Date currentDate = new Date();

            invitee.setUsername(inviteeEmail);
            invitee.setEmail(inviteeEmail);
            invitee.setOwner(oOwner.get());
            invitee.setInviteStatus(Constants.USER_INVITE_ACCEPTENCE_PENDING);
            invitee.setInviteSentOn(currentDate);
            invitee.setActive(true);
            invitee.setOrganization(oOwner.get().getOrganization());
            invitee.setIsMfaEnable(Constants.NO);
            invitee.setInviteCode(invitationCode);
            invitee.setTempPassword(RandomGenerator.getTemporaryPassword());
            invitee.setCreatedAt(currentDate);
            invitee.setUpdatedAt(currentDate);
            invitee.setCreatedBy(oOwner.get().getUsername());
            invitee.setUpdatedBy(oOwner.get().getUsername());
            invitee.setInviteLink(activationLink);
            invitee = userRepository.save(invitee);
            logger.info("User invite saved in db");

            String templateData = this.templateReader.readTemplate("/userinvite.ftl");
            logger.debug("Injecting dynamic data in user invite template");
            templateData = templateData.replace("${ownerName}", username);
            templateData = templateData.replace("${inviteLink}", activationLink);
            String subject = "User invitation to join Synectiks";
            MimeMessage mimeMessage = this.mailService.createHtmlMailMessage(templateData, inviteeEmail, subject);
            this.mailService.sendEmail(mimeMessage);
            logger.info("User invitation mail send");
            Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Invitation link sent to user's email: " + inviteeEmail, invitee);
            return ResponseEntity.status(HttpStatus.OK).body(st);

        } catch (Exception e) {
            logger.error("User invite failed. Exception: ", e);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User invite failed", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
    }

    @RequestMapping(path = "/acceptInvite")
    public ResponseEntity<Object> acceptInvite(@RequestParam String inviteCode) {
        logger.info("Request to accept user invite");
        try {
            User invitee = new User();
            invitee.setInviteCode(inviteCode);
            invitee.setActive(true);
            invitee.setInviteStatus(Constants.USER_INVITE_ACCEPTENCE_PENDING);

            Optional<User> oInvitee = userRepository.findOne(Example.of(invitee));
            if (!oInvitee.isPresent()) {
                Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User authentication failed. Invitation cannot be accepted", null);
                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
            }
            invitee = oInvitee.get();

            Date currentDate = new Date();

            invitee.setInviteStatus(Constants.USER_INVITE_ACCEPTED);
            invitee.setActive(true);
            invitee.setUpdatedAt(currentDate);
            invitee.setUpdatedBy(invitee.getUsername());
            invitee.setPassword(shiroPasswordService.encryptPassword(invitee.getTempPassword()));
            invitee = userRepository.save(invitee);
            logger.info("User invite accepted and saved in db");

            User discardUsers = new User();
            discardUsers.setActive(false);
            discardUsers.setOwner(invitee.getOwner());
            discardUsers.setOrganization(invitee.getOrganization());
            discardUsers.setInviteStatus(Constants.USER_INVITE_ACCEPTENCE_PENDING);
            logger.info("Deleting all the additional invitation requests for the same user");
            List<User> discardUsersList = userRepository.findAll(Example.of(discardUsers));
            for (User us : discardUsersList) {
                userRepository.delete(us);
            }

            String templateData = this.templateReader.readTemplate("/usercredential.ftl");
            templateData = templateData.replace("${loginId}", invitee.getUsername());
            templateData = templateData.replace("${password}", invitee.getTempPassword());
            String subject = "Login credentials of Synectiks cloud monitoring application";
            MimeMessage mimeMessage = this.mailService.createHtmlMailMessage(templateData, invitee.getEmail(), subject);
            this.mailService.sendEmail(mimeMessage);
            logger.info("User credential mail send");
            Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Invitation accepted. Login id and password sent to user's email: " + invitee.getEmail(), invitee);
            return ResponseEntity.status(HttpStatus.OK).body(st);

        } catch (Exception e) {
            logger.error("User invite acceptance failed. Exception: ", e);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User invite acceptance failed", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
    }

    @RequestMapping(method = RequestMethod.GET, path = "/getTeam")
    public ResponseEntity<Object> getTeam(@RequestParam Map<String, String> reqObj) {
        logger.info("Request to get list of team members");
        User user = new User();
        try {

            if (reqObj.get("organization") != null) {
                Organization organization = organizationService.getOrganizationByName(reqObj.get("organization"));
//				organization.setName(reqObj.get("organization").toUpperCase());
//				Optional<Organization> oOrg = this.organizationRepository.findOne(Example.of(organization));
                if (organization != null) {
                    user.setOrganization(organization);
                }
            }

            if (reqObj.get("userName") != null) {
                user.setUsername(reqObj.get("userName"));
            }

            user.setActive(true);

            Optional<User> oOwner = userRepository.findOne(Example.of(user));
            if (oOwner.isPresent()) {
                user.setId(oOwner.get().getId());
                user.setEmail(oOwner.get().getEmail());
                user.setPassword(oOwner.get().getPassword());
                user.setActive(oOwner.get().isActive());
                user.setCreatedAt(oOwner.get().getCreatedAt());
                user.setCreatedBy(oOwner.get().getCreatedBy());
                user.setUpdatedAt(oOwner.get().getUpdatedAt());
                user.setUpdatedBy(oOwner.get().getUpdatedBy());
                user.setType(oOwner.get().getType());
                user.setGoogleMfaKey(oOwner.get().getGoogleMfaKey());
                user.setIsMfaEnable(oOwner.get().getIsMfaEnable());
                user.setMfaQrImageFilePath(oOwner.get().getMfaQrImageFilePath());
                user.setInviteCode(oOwner.get().getInviteCode());
                user.setInviteLink(oOwner.get().getInviteLink());
                user.setInviteSentOn(oOwner.get().getInviteSentOn());
                user.setInviteStatus(oOwner.get().getInviteStatus());
                user.setTempPassword(oOwner.get().getTempPassword());

                List<User> allUserList = this.userRepository.findAll(Sort.by(Direction.ASC, "username"));
                List<User> activeUserList = new ArrayList<>();
                List<User> pendingUsersList = new ArrayList<>();
                for (User acUser : allUserList) {
                    if (!StringUtils.isBlank(acUser.getIsMfaEnable())
                        && Constants.YES.equalsIgnoreCase(acUser.getIsMfaEnable())) {
                        acUser.setIsMfaEnable("Enabled");
                    } else {
                        acUser.setIsMfaEnable("Disabled");
                    }
                    if (!StringUtils.isBlank(acUser.getMfaQrImageFilePath())) {
                        File qrFile = new File(acUser.getMfaQrImageFilePath());
                        if (qrFile.exists() && qrFile.isFile()) {
                            acUser.setMfaQrCode(Files.readAllBytes(qrFile.toPath()));
                        }
                    }

                    if (acUser.getOwner() != null && acUser.getOwner().getId().equals(user.getId())
                        && (!StringUtils.isBlank(acUser.getInviteStatus())
                        && Constants.USER_INVITE_ACCEPTED.equals(acUser.getInviteStatus()))) {
                        acUser.setInviteStatus("Invite Accepted");
                        if (oOwner.get().getRoles() != null && oOwner.get().getRoles().size() > 0) {
                            acUser.setRoles(oOwner.get().getRoles());
                        }
                        activeUserList.add(acUser);
                    }
                    if (acUser.getOwner() != null && acUser.getOwner().getId().equals(user.getId())
                        && (!StringUtils.isBlank(acUser.getInviteStatus())
                        && Constants.USER_INVITE_ACCEPTENCE_PENDING.equals(acUser.getInviteStatus()))) {
                        acUser.setInviteStatus("Acceptance Pending");

                        if (oOwner.get().getRoles() != null && oOwner.get().getRoles().size() > 0) {
                            acUser.setRoles(oOwner.get().getRoles());
                        }

                        pendingUsersList.add(acUser);
                    }

                }
                user.setTeamList(activeUserList);
                user.setPendingInviteList(pendingUsersList);
            }

        } catch (Throwable th) {
            logger.error("Exception in getTeam: ", th);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Due to some error, team list cannot be retrieved", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Team list", user);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }

    @RequestMapping(path = "/mfaCode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> getMfaCode(@RequestBody ObjectNode reqObj) {
        logger.info("Request to get google mfa for user: {}", reqObj.get("userName").asText());
        if (StringUtils.isBlank(reqObj.get("userName").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User name not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if (StringUtils.isBlank(reqObj.get("password").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Password not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        try {
            UsernamePasswordToken token = new UsernamePasswordToken();
            token.setUsername(reqObj.get("userName").asText());
            token.setPassword(reqObj.get("password").asText().toCharArray());
            AuthenticationInfo info = SecurityUtils.getSecurityManager().authenticate(token);

            String mfaKey = googleMultiFactorAuthenticationService.getGoogleAuthenticationKey(reqObj.get("userName").asText());
            int size = 125;
            String fileType = "png";
            String keyUri = googleMultiFactorAuthenticationService.generateGoogleAuthenticationUri(reqObj.get("userName").asText(),
                "Synectiks ", mfaKey);

            File tempFile = File.createTempFile(reqObj.get("userName").asText(), "." + fileType);
            googleMultiFactorAuthenticationService.createQRImage(tempFile, keyUri, size, fileType);
            Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Google MFA QR code created successfully", Files.readAllBytes(tempFile.toPath()));
            st.setMfaKey(mfaKey);
            tempFile.deleteOnExit();
            return ResponseEntity.status(HttpStatus.OK).body(st);
        } catch (Exception e) {
            String errMsg = "Exception in getting mfa";
            logger.error(errMsg + ": ", e);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", errMsg, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
    }

    @RequestMapping(value = "/authenticateMfa", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> authenticateGoogleMfa(@RequestBody ObjectNode reqObj) {
        logger.error("Request to authenticate google MFA token");

        if (StringUtils.isBlank(reqObj.get("userName").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User name not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if (StringUtils.isBlank(reqObj.get("token").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "MFA token not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        try {
            User user = this.userRepository.findByUsername(reqObj.get("userName").asText());
            if (user == null) {
                Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User name : " + reqObj.get("userName").asText(), null);
                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
            }
            GoogleAuthenticator gAuth = new GoogleAuthenticator();
            boolean matches = false;
            if (!StringUtils.isBlank(user.getIsMfaEnable()) && Constants.YES.equalsIgnoreCase(user.getIsMfaEnable())) {
                matches = gAuth.authorize(user.getGoogleMfaKey(), Integer.parseInt(reqObj.get("token").asText()));
                if (matches) {
                    logger.debug("Google mfa authentication successful");
                } else {
                    logger.warn("Google mfa authentication failed");
                }
            } else {
                matches = gAuth.authorize(reqObj.get("mfaKey").asText(), Integer.parseInt(reqObj.get("token").asText()));
                if (matches) {
                    logger.info("Google MFA authentication successful for user {}", reqObj.get("userName").asText());
                    user.setIsMfaEnable(Constants.YES);
                    user.setGoogleMfaKey(reqObj.get("mfaKey").asText());
                    user = userRepository.save(user);
                    logger.info("Google MFA is enabled for user: {}", reqObj.get("userName").asText());
                } else {
                    logger.warn("Google MFA token authentication failed while setting up MFA for user: {}", reqObj.get("userName").asText());
                }

            }
            Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", matches == true ? "Google MFA token authenticated" : "Google MFA token authentication failed", matches);
            return ResponseEntity.status(HttpStatus.OK).body(st);
        } catch (Exception e) {
            logger.error("Exception in MFA authentication: ", e);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Exception in MFA authentication", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
    }

    @RequestMapping(value = "/disableMfaByToken", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> disableGoogleMfaByToken(@RequestBody ObjectNode reqObj) {
        logger.error("Request to disable google MFA");

        if (StringUtils.isBlank(reqObj.get("userName").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User name not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if (StringUtils.isBlank(reqObj.get("token").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "MFA token not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        try {
            User user = this.userRepository.findByUsername(reqObj.get("userName").asText());
            if (user == null) {
                Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User name : " + reqObj.get("userName").asText(), null);
                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
            }
            GoogleAuthenticator gAuth = new GoogleAuthenticator();
            boolean matches = false;
            Status st = null;
            if (!StringUtils.isBlank(user.getIsMfaEnable()) && Constants.YES.equalsIgnoreCase(user.getIsMfaEnable())) {
                matches = gAuth.authorize(user.getGoogleMfaKey(), Integer.parseInt(reqObj.get("token").asText()));
                if (matches) {
                    logger.info("Google MFA authentication successful. Disabling MFA for user {}", reqObj.get("userName").asText());
                    user.setIsMfaEnable(Constants.NO);
                    user.setGoogleMfaKey(null);
                    user = userRepository.save(user);
                    logger.info("Google MFA is disabled for user: {}", reqObj.get("userName").asText());
                    st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Google MFA token disabled", matches);
                } else {
                    logger.warn("Google mfa authentication failed");
                    st = setMessage(HttpStatus.OK.value(), "ERROR", "Google MFA token authentication failed. MFA could not be disabled", matches);
                }
            } else {
                logger.info("Google MFA is already disabled for user: {}", reqObj.get("userName").asText());
                st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Google MFA is already disabled", null);
            }
            return ResponseEntity.status(HttpStatus.OK).body(st);
        } catch (Exception e) {
            logger.error("Exception while disabling MFA token: ", e);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Exception while disabling MFA token", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
    }

    @RequestMapping(value = "/disableMfa", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> disableGoogleMfa(@RequestBody ObjectNode reqObj) {
        logger.error("Request to disable google MFA");

        if (StringUtils.isBlank(reqObj.get("userName").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User name not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if (StringUtils.isBlank(reqObj.get("password").asText())) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Password not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        UsernamePasswordToken token = new UsernamePasswordToken();
        token.setUsername(reqObj.get("userName").asText());
        token.setPassword(reqObj.get("password").asText().toCharArray());

        Status st = null;
        try {
            AuthenticationInfo info = SecurityUtils.getSecurityManager().authenticate(token);
            User user = this.userRepository.findByUsername(reqObj.get("userName").asText());
            user.setIsMfaEnable(Constants.NO);
            user.setGoogleMfaKey(null);

            user.setUpdatedBy(user.getUsername());
            user.setUpdatedAt(new Date());
            if (reqObj.get("updatedBy") != null && !StringUtils.isBlank(reqObj.get("updatedBy").asText())) {
                User updatedBy = this.userRepository.findByUsername(reqObj.get("updatedBy").asText());
                if (updatedBy != null) {
                    user.setUpdatedBy(updatedBy.getUsername());
                }
            }
            user = userRepository.save(user);
            logger.info("Google MFA is disabled for user: {}", reqObj.get("userName").asText());
            st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Google MFA disabled", null);
        } catch (UnknownAccountException th) {
            //username wasn't in the system, show them an error message?
            logger.error(th.getMessage(), th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th.getLocalizedMessage());
        } catch (IncorrectCredentialsException th) {
            //password didn't match, try again?
            logger.error(th.getMessage(), th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th.getLocalizedMessage());
        } catch (LockedAccountException th) {
            //account for that username is locked - can't login.  Show them a message?
            logger.error(th.getMessage(), th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th.getLocalizedMessage());
        } catch (AuthenticationException th) {
            // General exception thrown due to an error during the Authentication process
            logger.error(th.getMessage(), th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(th.getLocalizedMessage());
        }

        return ResponseEntity.status(HttpStatus.OK).body(st);

    }


    @RequestMapping(value = "/reset-password-by-otp")
    public ResponseEntity<Object> resetPasswordByOtp(@RequestBody ObjectNode reqObje) throws IOException {
        String userName = reqObje.get("userName").asText();
        User user = this.userRepository.findByUsername(userName);
        if (user == null) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User Name: " + userName, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        String ourToken = Token.get(userName);
        if (StringUtils.isBlank(ourToken)) {
            logger.error("Token not found");
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Invalid token: ", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        String token = reqObje.get("token").asText();
        if (StringUtils.isBlank(token) || !ourToken.equals(token)) {
            logger.error("Invalid token");
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Invalid token: ", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }

        String newPassword = reqObje.get("newPassword").asText();
        user.setPassword(shiroPasswordService.encryptPassword(newPassword));
        user.setEncPassword((EncryptionDecription.encrypt(newPassword)));
        user.setUpdatedBy(user.getUsername());
        user.setUpdatedAt(new Date());

        userRepository.save(user);
        Token.remove(userName);
        Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Password changed successfully: ", null);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }

    @RequestMapping(value = "/reset-password")
    public ResponseEntity<Object> resetPassword(@RequestBody ObjectNode reqObje) throws IOException {
        String userName = reqObje.get("userName").asText();
        User user = this.userRepository.findByUsername(userName);
        if (user == null) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User Name: " + userName, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        String oldPassword = reqObje.get("oldPassword").asText();

        UsernamePasswordToken usernamePasswordToken = new UsernamePasswordToken();
        usernamePasswordToken.setUsername(user.getUsername());
        usernamePasswordToken.setPassword(oldPassword.toCharArray());

        try {
            SecurityUtils.getSecurityManager().authenticate(usernamePasswordToken);
        } catch (UnknownAccountException th) {
            Token.remove(userName);
            logger.error(th.getMessage(), th);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "UnknownAccountException: ", th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        } catch (IncorrectCredentialsException th) {
            Token.remove(userName);
            logger.error(th.getMessage(), th);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "IncorrectCredentialsException: ", th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        } catch (LockedAccountException th) {
            Token.remove(userName);
            logger.error(th.getMessage(), th);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "LockedAccountException: ", th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        } catch (AuthenticationException th) {
            Token.remove(userName);
            logger.error(th.getMessage(), th);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "AuthenticationException: ", th);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        user.setUpdatedBy(user.getUsername());
        user.setUpdatedAt(new Date());

        String newPassword = reqObje.get("newPassword").asText();
        user.setPassword(shiroPasswordService.encryptPassword(newPassword));
        user.setEncPassword((EncryptionDecription.encrypt(newPassword)));
        userRepository.save(user);
        Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Password changed successfully: ", null);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }

    @RequestMapping(value = "/reset-password-by-admin")
    public ResponseEntity<Object> resetPasswordByAdmin(@RequestBody ObjectNode reqObje) throws IOException {
        String userName = reqObje.get("userName").asText();
        User user = this.userRepository.findByUsername(userName);
        if (user == null) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User Name: " + userName, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        Optional<User> oOwner = this.userRepository.findById(reqObje.get("ownerId").asLong());
        if (!oOwner.isPresent()) {
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Owner not found. Owner id: " + reqObje.get("ownerId").asLong(), null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        user.setUpdatedBy(oOwner.get().getUsername());
        user.setUpdatedAt(new Date());
        String newPassword = reqObje.get("newPassword").asText();
        user.setPassword(shiroPasswordService.encryptPassword(newPassword));
        user.setEncPassword((EncryptionDecription.encrypt(newPassword)));

        userRepository.save(user);
        Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "Password changed successfully: ", null);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }


//	@RequestMapping(path = "/enableGoogleMfa")
//	public ResponseEntity<Object> enableGoogleMfa(@RequestParam final String userName,
//			@RequestParam final String organizationName) {
//		logger.info("Request to enable google mfa for user: {}", userName);
//		try {
//			User user = userRepository.findByUsername(userName);
//			if (user == null) {
//				logger.error("User not found. User: {}, Organization: {}", userName, organizationName);
//				Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR","User not found", null);
//                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
//			}
//
//			user.setIsMfaEnable("YES");
//			String mfaKey = googleMultiFactorAuthenticationService.getGoogleAuthenticationKey(userName);
//			user.setGoogleMfaKey(mfaKey);
//
//			String directory = "qrimages/" + organizationName;
//			File dir = new File(directory);
//			if (!dir.exists()) {
//				dir.mkdirs();
//			}
//			String fileName = userName + ".png";
//			String filePath = directory + "/" + fileName;
//			int size = 125;
//			String fileType = "png";
//			File qrFile = new File(filePath);
//			String keyUri = googleMultiFactorAuthenticationService.generateGoogleAuthenticationUri(userName,
//					"Synectiks ", mfaKey);
//			googleMultiFactorAuthenticationService.createQRImage(qrFile, keyUri, size, fileType);
//
//			user.setMfaQrCode(Files.readAllBytes(qrFile.toPath()));
//			user.setMfaQrImageFilePath(qrFile.getAbsolutePath());
//			user = userRepository.save(user);
//
//			logger.info("Google mfa is enabled for user: {}", userName);
//
//			String templateData = this.templateReader.readTemplate("/enablegooglemfa.ftl");
//			logger.debug("Injecting dynamic data in enable google mfa template");
//			templateData = templateData.replace("${userName}", userName);
//			templateData = templateData.replace("${mfaKey}", mfaKey);
//
//			String subject = "Dear " + userName + ". Google multifactor authentication security enabled";
//
//			MimeMessage mimeMessage = this.mailService.getJavaMailSender().createMimeMessage();
//			MimeMessageHelper helper = this.mailService.createHtmlMailMessageWithImage(mimeMessage, templateData,
//					user.getEmail(), subject);
//			helper.addInline("qrImage", qrFile);
//			this.mailService.sendEmail(mimeMessage);
//			logger.info("Google mfa enabled. Access key sent in mail.");
//			Status st = setMessage(HttpStatus.OK.value(), "SUCCESS","Google mfa is enabled for user: " + userName, user);
//            return ResponseEntity.status(HttpStatus.OK).body(st);
//		} catch (Exception e) {
//			logger.error("Exception in enabling google mfa: ", e);
//			Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR","Exception in enabling google mfa", null);
//            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
//		}
//	}

//	@RequestMapping(path = "/disableGoogleMfa")
//	public ResponseEntity<Object> disableGoogleMfa(@RequestParam final String userName,
//			@RequestParam final String organizationName) {
//		logger.info("Request to disable google mfa for user: {}", userName);
//		try {
//
//			User user = userRepository.findByUsername(userName);
//			if (user == null) {
//				logger.error("User not found. User: {}, Organization: {}", userName, organizationName);
//				Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR","User not found", null);
//                return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
//			}
//
//			user.setIsMfaEnable("NO");
//			user.setGoogleMfaKey(null);
//			user.setMfaQrImageFilePath(null);
//			user = userRepository.save(user);
//
//			String fileName = userName + ".png";
//			String filePath = "qrimages/" + organizationName + "/" + fileName;
//			File file = new File(filePath);
//
//			if (file.exists()) {
//				file.delete();
//			}
//
//			logger.info("Google mfa is disable for user: {}", userName);
//			Status st = setMessage(HttpStatus.OK.value(), "SUCCESS","Google mfa is disabled for user: " + userName, user);
//			return ResponseEntity.status(HttpStatus.OK).body(st);
//		} catch (Exception e) {
//			logger.error("Exception in disabling google mfa: ", e);
//			Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR","Exception in disabling google mfa", null);
//			return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
//		}
//	}


    private Status setMessage(int stqtusCode, String stausType, String msg, Object obj) {
        Status st = new Status();
        st.setCode(stqtusCode);
        st.setType(stausType);
        st.setMessage(msg);
        st.setObject(obj);
        return st;
    }

    @RequestMapping(path = "/get-user-hierarchy", method = RequestMethod.GET)
    public ResponseEntity<Object> getUserHierarchy(@RequestParam String userName) {
        logger.info("Request to get user hierarchy");
        User user = this.userRepository.findByUsername(userName);
        if (user == null) {
            logger.error("User not found. user name: {}", userName);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User name : " + userName, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        Map<String, Object> userData = new HashMap<>();
        List<Role> roleList = new ArrayList<>();
        List<Role> roleGrpList = new ArrayList<>();
        List<User> userList = new ArrayList<>();
        List<Policy> policyList = new ArrayList<>();
        List<PermissionCategory> permissionCategoryList = new ArrayList<>();
        boolean isAdmin = false;
        for (Role role : user.getRoles()) {
            if (Constants.USER_TYPE_SUPER_ADMIN.equalsIgnoreCase(role.getName()) && role.isDefault() && role.isGrp()) {
                isAdmin = true;
                break;
            }
        }
        if (isAdmin) {
            logger.info("User type is {}", user.getType());
//            roleGrpList.addAll(roleRepository.findByCreatedByAndGrp(Constants.SYSTEM_ACCOUNT, true));
//            roleList.addAll(roleRepository.findByCreatedByAndGrp(Constants.SYSTEM_ACCOUNT, false));

            roleGrpList.addAll(roleRepository.findByOrganizationIdAndGrp(user.getOrganization().getId(), true));
            roleList.addAll(roleRepository.findByOrganizationIdAndGrp(user.getOrganization().getId(), false));

            userList = userRepository.findByOrganizationId(user.getOrganization().getId());
            for (User obj : userList) {
                if (!StringUtils.isBlank(obj.getFileName()) && "S3".equalsIgnoreCase(obj.getFileStorageLocationType())) {
                    obj.setProfileImage(downloadFileFromS3(obj.getFileName()));
                }
            }
//            policyList.addAll(policyRepository.findByCreatedBy(Constants.SYSTEM_ACCOUNT));
            policyList.addAll(policyRepository.findByOrganizationId(user.getOrganization().getId()));

//            permissionCategoryList.addAll(permissionCategoryRepository.findByCreatedBy(Constants.SYSTEM_ACCOUNT));
            permissionCategoryList.addAll(permissionCategoryRepository.findByOrganizationId(user.getOrganization().getId()));

            addUsersToRoleGroup(roleGrpList, userList);

            addAllowedAndDisAllowedPermissions(roleGrpList);
        } else {
            logger.info("User role is not admin");
            Map<Long, PermissionCategory> pMap = new HashMap<>();
            for (Role roleGrp : user.getRoles()) {
                roleGrpList.add(roleGrp);
                for (Role role : roleGrp.getRoles()) {
                    roleList.add(role);
                    for (Policy policy : role.getPolicies()) {
                        policyList.add(policy);
                        Set<Long> permissionCategorySet = policy.getPermissions().stream().map(pap -> pap.getPermissionCategoryId()).collect(Collectors.toSet());
                        for (Long papId : permissionCategorySet) {
                            Optional<PermissionCategory> oPc = permissionCategoryRepository.findById(papId);
                            if (oPc.isPresent()) {
                                pMap.put(papId, oPc.get());
                            }
                        }
                    }
                }
            }
            if (!StringUtils.isBlank(user.getFileName()) && "S3".equalsIgnoreCase(user.getFileStorageLocationType())) {
                user.setProfileImage(downloadFileFromS3(user.getFileName()));
            }
            for (Long papId : pMap.keySet()) {
                permissionCategoryList.add(pMap.get(papId));
            }
            userList.add(user);
        }

        userData.put("isAdmin", isAdmin);
        userData.put("roleGroups", roleGrpList);
        userData.put("roles", roleList);
        userData.put("policies", policyList);
        userData.put("users", userList);
        userData.put("permissionCategories", permissionCategoryList);
        return ResponseEntity.status(HttpStatus.OK).body(userData);
    }


    private void addAllowedAndDisAllowedPermissions(List<Role> roleGrpList) {
        Map<Long, Permission> allPermissions = new HashMap<>();

        Permission permission = new Permission();
        permission.setStatus(Constants.ACTIVE);
        List<Permission> permissionList = permissionRepository.findAll(Example.of(permission));
        for (Permission obj : permissionList) {
            allPermissions.put(obj.getId(), obj);
        }

        // get role-group->role->policy-permission
        for (Role roleGrp : roleGrpList) {
            Map<Long, Permission> allowedPermissions = new HashMap<>();
            // union all the permission from each role
            for (Role role : roleGrp.getRoles()) {
                for (Policy policy : role.getPolicies()) {
                    for (PolicyAssignedPermissions pap : policy.getPermissions()) {
                        Optional<Permission> op = permissionRepository.findById(pap.getPermissionId());
                        if (op.isPresent()) {
                            allowedPermissions.put(pap.getPermissionId(), op.get());
                        }
                    }
                }
            }
            roleGrp.setAllowedPermissions(allowedPermissions.keySet().stream().map(key -> allowedPermissions.get(key)).collect(Collectors.toList()));
            for (Long key : allowedPermissions.keySet()) {
                if (allPermissions.containsKey(key)) {
                    allPermissions.remove(key);
                }
            }
            roleGrp.setDisAllowedPermissions(allPermissions.keySet().stream().map(key -> allPermissions.get(key)).collect(Collectors.toList()));
            for (Permission obj : permissionList) {
                allPermissions.put(obj.getId(), obj);
            }
        }
    }

    private void addUsersToRoleGroup(List<Role> roleGrpList, List<User> userList) {
        Map<Long, List<Role>> userRolesMap = new HashMap<>();
        Map<Long, User> userMap = new HashMap<>();

        for (User user1 : userList) {
//            userRolesMap.put(user1.getId(), user1.getRoles());
            for (Role roleGrp : user1.getRoles()) {
                if (!userRolesMap.containsKey(user1.getId())) {
                    List<Role> temp = new ArrayList<>();
                    temp.add(roleGrp);
                    userRolesMap.put(user1.getId(), temp);
                } else {
                    userRolesMap.get(user1.getId()).add(roleGrp);
                }
            }
            userMap.put(user1.getId(), user1);
        }

        for (Long key : userRolesMap.keySet()) {
            List<Role> values = userRolesMap.get(key);
            for (Role tempRole : values) {
                ObjectNode node = IUtils.OBJECT_MAPPER.createObjectNode();
                node.put("id", userMap.get(key).getId());
                node.put("userName", userMap.get(key).getUsername());
                node.put("eMail", userMap.get(key).getEmail());
                node.put("numberOfGroups", values.size());
                if (tempRole.getUsers() == null) {
                    List<ObjectNode> tempList = new ArrayList<>();
                    tempList.add(node);
                    tempRole.setUsers(tempList);
                } else {
                    tempRole.getUsers().add(node);
                }
            }
            for (Role tempRole : values) {
                for (Role grp : roleGrpList) {
                    if (tempRole.getId().compareTo(grp.getId()) == 0) {
                        grp.setUsers(tempRole.getUsers());
                    }
                }
            }
        }
    }

    @RequestMapping(path = "/get-pending-user-requests", method = RequestMethod.GET)
    public ResponseEntity<Object> getPendingUserRequests(@RequestParam Long organizationId) {
        logger.info("Request to get all users who are waiting to get approved");
        if (organizationId == null) {
            logger.error("Organization id not provided");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body("Organization id not provided");
        }
        List<User> userList = userRepository.findByOrganizationIdAndActiveAndRequestType(organizationId, false, Constants.USER_REQUEST_TYPE_ONLINE);

        Map<String, Object> result = new HashMap<>();
        result.put("organizationId", organizationId);
        result.put("pendingUsers", userList);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    @RequestMapping(path = "/get-pending-user-request-count", method = RequestMethod.GET)
    public ResponseEntity<Object> getPendingUserRequestCount(@RequestParam Long organizationId) {
        logger.info("Request to get total number of users who are waiting to get approved");
        if (organizationId == null) {
            logger.error("Organization id not provided");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body("Organization id not provided");
        }
        List<User> userList = userRepository.findByOrganizationIdAndActiveAndRequestType(organizationId, false, Constants.USER_REQUEST_TYPE_ONLINE);
        Map<String, Object> result = new HashMap<>();
        result.put("organizationId", organizationId);
        result.put("pendingUsersCount", userList.size());
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }

    @RequestMapping(path = "/pending-user-request-action", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> updatePendingUserRequest(@RequestBody ObjectNode reqObj) {
        logger.info("Request to approve/reject user request");
        if(reqObj.get("userName") == null){
            logger.error("User name not provided");
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User name not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        String userName = reqObj.get("userName").asText();
        User user = this.userRepository.findByUsername(userName);
        if (user == null) {
            logger.error("User not found. User Name: {}", userName);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User Name: " + userName, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if(reqObj.get("ownerId") == null){
            logger.error("Owner id not provided");
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Owner id not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        Optional<User> oOwner = this.userRepository.findById(reqObj.get("ownerId").asLong());
        if (!oOwner.isPresent()) {
            logger.error("Owner not found. Owner id: {}", reqObj.get("ownerId").asLong());
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Owner not found. Owner id: " + reqObj.get("ownerId").asLong(), null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        if(reqObj.get("status") == null){
            logger.error("Status id not provided");
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Status not provided", null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        String status = reqObj.get("status").asText();
        if(!Constants.APPROVE.equalsIgnoreCase(status) && !Constants.DENY.equalsIgnoreCase(status)){
            logger.error("Status can be DENY/APPROVE. Provided status is not acceptable. Provided status: {}",status);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "Status can be DENY/APPROVE. Provided status is not acceptable. Status: "+status, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        user.setUpdatedBy(oOwner.get().getUsername());
        user.setUpdatedAt(new Date());
        if(Constants.APPROVE.equalsIgnoreCase(status)) {
            user.setStatus(Constants.STATUS_ACCEPTED);
            user.setActive(true);
        }
        if(Constants.DENY.equalsIgnoreCase(status)) {
            user.setStatus(Constants.STATUS_REJECTED);
            if(reqObj.get("comments") != null){
                user.setComments(reqObj.get("comments").asText());
            }
        }
        user.setOwner(oOwner.get());
        Organization organization = organizationService.getOrganizationByName(Constants.DEFAULT_ORGANIZATION);
        Role role = roleRepository.findByNameAndGrpAndOrganizationId(Constants.ROLE_DEFAULT_USERS,true,organization.getId());
        List<Role> roleGrpList = new ArrayList<>();
        roleGrpList.add(role);
        user.setRoles(roleGrpList);
        userRepository.save(user);
        Status st = setMessage(HttpStatus.OK.value(), "SUCCESS", "User status updated", null);
        return ResponseEntity.status(HttpStatus.OK).body(st);
    }

    @RequestMapping(path = "/get-confirmed-user-requests", method = RequestMethod.GET)
    public ResponseEntity<Object> getConfirmedUserRequests(@RequestParam Long organizationId) {
        logger.info("Request to get all users whose request have been accepted to get approved");
        if (organizationId == null) {
            logger.error("Organization id not provided");
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body("Organization id not provided");
        }
        List<User> userList = userRepository.findByOrganizationIdAndActiveAndRequestTypeAndStatus(organizationId, true, Constants.USER_REQUEST_TYPE_ONLINE, Constants.STATUS_ACCEPTED);
        Map<String, Object> result = new HashMap<>();
        result.put("organizationId", organizationId);
        result.put("confirmedUsers", userList);
        return ResponseEntity.status(HttpStatus.OK).body(result);
    }


    @RequestMapping(path = "/get-user-password", method = RequestMethod.GET)
    public ResponseEntity<Object> getUserPassword(@RequestParam String userName) {
        User user = this.userRepository.findByUsername(userName);
        if (user == null) {
            logger.error("User not found. User Name: {}", userName);
            Status st = setMessage(HttpStatus.EXPECTATION_FAILED.value(), "ERROR", "User not found. User Name: " + userName, null);
            return ResponseEntity.status(HttpStatus.EXPECTATION_FAILED).body(st);
        }
        Map<String, String> data = new HashMap<>();
        data.put("user", userName);
        data.put("isActive", String.valueOf(user.isActive()));
        data.put("password", EncryptionDecription.decrypt(user.getEncPassword()));
        return ResponseEntity.status(HttpStatus.OK).body(data);
    }
}
