package com.synectiks.security.entities;


import com.fasterxml.jackson.annotation.JsonProperty;
import com.synectiks.security.domain.PSqlEntity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.time.Instant;

/**
 * A Organization.
 */
@Entity
@Table(name = "organization")
public class Organization extends PSqlEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    private String name;

    @Size(max = 5000)
    @Column(name = "description", length = 5000, nullable = true)
    private String description;

    @Column(nullable = true)
    private String phone;

    @Column(nullable = true)
    private String email;

    @Column(nullable = true)
    private String address;

    @Column(nullable = true)
    private String fax;

    @Column(nullable = true)
    private Instant dateOfEstablishment;

    @Column(nullable = true)
    private String status;


    @Column(name = "cmdb_org_id", nullable = true)
    private Long cmdbOrgId;

    @Column(nullable = true)
    private String fileName;

    @Column(nullable = true)
    private String fileStorageLocationType;

    @Transient
    @JsonProperty
    private byte[] profileImage;

    public Long getCmdbOrgId() {
        return cmdbOrgId;
    }

    public void setCmdbOrgId(Long cmdbOrgId) {
        this.cmdbOrgId = cmdbOrgId;
    }

    @Transient
    @JsonProperty
    private Long securityServiceOrgId;

    public void setSecurityServiceOrgId(Long securityServiceOrgId) {
        this.securityServiceOrgId = securityServiceOrgId;
    }

    public Long getSecurityServiceOrgId() {
        return securityServiceOrgId;
    }

    public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public Instant getDateOfEstablishment() {
		return dateOfEstablishment;
	}

	public void setDateOfEstablishment(Instant dateOfEstablishment) {
		this.dateOfEstablishment = dateOfEstablishment;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileStorageLocationType() {
        return fileStorageLocationType;
    }

    public void setFileStorageLocationType(String fileStorageLocationType) {
        this.fileStorageLocationType = fileStorageLocationType;
    }

    public byte[] getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(byte[] profileImage) {
        this.profileImage = profileImage;
    }

    @Override
	public String toString() {
		return "Organization [name=" + name + ", description=" + description + ", phone=" + phone + ", email=" + email
				+ ", address=" + address + ", fax=" + fax + ", dateOfEstablishment=" + dateOfEstablishment + ", status="
				+ status + "]";
	}


}
