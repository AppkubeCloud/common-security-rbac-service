/**
 *
 */
package com.synectiks.security.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.synectiks.security.config.IDBConsts;
import com.synectiks.security.domain.PSqlEntity;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * @author Rajesh
 */
@Entity
@Table(name = IDBConsts.Tbl_USERS)
public class User extends PSqlEntity {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
//	public static User ADMIN = create(IConsts.ADMIN, Arrays.asList(Role.ROLE_ADMIN));
//	public static String ADMIN_UUID = "7afb71b8-2db0-4fc0-b66f-47f34d10a5a3";

//	public static enum Types {
//		CUSTOMER, USER, SUPER;
//	}

	@Column(nullable = true)
	private String type;
	private String username;
	private String password;
	private boolean active;
	private String email;
	@ManyToMany(targetEntity = Role.class, fetch = FetchType.EAGER)
	private List<Role> roles;

	@OneToOne(targetEntity = Organization.class, fetch = FetchType.EAGER)
    @JsonIgnoreProperties(value = "organizations", allowSetters = true)
    private Organization organization;

	@OneToOne(cascade=CascadeType.ALL)
    private User owner;

	@Column(nullable = true)
	private String googleMfaKey;

	@Column(nullable = true)
	private String isMfaEnable;

	@Column(nullable = true)
	private String mfaQrImageFilePath;

	@Column(nullable = true)
	private String inviteStatus;

	@Column(length = 1000, nullable = true)
	private String inviteLink;

	@Column(nullable = true)
	private String inviteCode;

	@Column(nullable = true)
	private Date inviteSentOn;

	@Column(nullable = true)
	private String tempPassword;

    @Column(nullable = true)
    private String encPassword;

    @Column(nullable = true)
    private Integer loginCount;

    @Column(nullable = true)
    private Date lastLoginAt;

    @Transient
    @JsonProperty
	private byte[] mfaQrCode;

    @Transient
    @JsonProperty
	private List<User> pendingInviteList;

    @Transient
    @JsonProperty
	private List<User> teamList;

//    @Transient
//	@JsonProperty
//	private List<Document> documentList;

    @Transient
	@JsonProperty
	private byte[] profileImage;

    @Transient
    @JsonProperty
	private boolean isAuthenticatedByUserName = false;

    @Column(nullable = true)
    private String firstName;

    @Column(nullable = true)
    private String middleName;

    @Column(nullable = true)
    private String lastName;

    @Column(nullable = true)
    private String fileName;

    @Column(nullable = true)
    private String fileStorageLocationType;

    @Column(nullable = true)
    private String status;

    @Column(nullable = true)
    private String requestType;

    @Column(nullable = true)
    private String comments;


//	public User() {
//		super();
//	}
//
//    public User(String username) {
//		this();
//		this.setUsername(username);
//	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public List<Role> getRoles() {
		return roles;
	}

	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

//	/**
//	 * Method to create a user object with username and roles
//	 * @param username
//	 * @param asList
//	 * @return
//	 */
//	private static User create(String username, List<Role> asList) {
//		User user = new User();
//		user.setUsername(username);
//		user.setType(Constants.USER_TYPE_ADMIN);
//		user.setRoles(asList);
//		return user;
//	}

	@Override
	public String toString() {
		return "User [type=" + type + ", username=" + username + ", active=" + active
				+ ", email=" + email + ", roles=" + roles + ", organization=" + organization
				+ "]";
	}

	public Organization getOrganization() {
		return organization;
	}

	public void setOrganization(Organization organization) {
		this.organization = organization;
	}


	public String getGoogleMfaKey() {
		return googleMfaKey;
	}

	public void setGoogleMfaKey(String googleMfaKey) {
		this.googleMfaKey = googleMfaKey;
	}

	public String getMfaQrImageFilePath() {
		return mfaQrImageFilePath;
	}

	public void setMfaQrImageFilePath(String mfaQrImageFilePath) {
		this.mfaQrImageFilePath = mfaQrImageFilePath;
	}

	public User getOwner() {
		return owner;
	}

	public void setOwner(User owner) {
		this.owner = owner;
	}

	public String getInviteStatus() {
		return inviteStatus;
	}

	public void setInviteStatus(String inviteStatus) {
		this.inviteStatus = inviteStatus;
	}

	public String getInviteLink() {
		return inviteLink;
	}

	public void setInviteLink(String inviteLink) {
		this.inviteLink = inviteLink;
	}

	public String getInviteCode() {
		return inviteCode;
	}

	public void setInviteCode(String inviteCode) {
		this.inviteCode = inviteCode;
	}

	public Date getInviteSentOn() {
		return inviteSentOn;
	}

	public void setInviteSentOn(Date inviteSentOn) {
		this.inviteSentOn = inviteSentOn;
	}

	public byte[] getMfaQrCode() {
		return mfaQrCode;
	}

	public void setMfaQrCode(byte[] mfaQrCode) {
		this.mfaQrCode = mfaQrCode;
	}

	public List<User> getPendingInviteList() {
		return pendingInviteList;
	}

	public void setPendingInviteList(List<User> pendingInviteList) {
		this.pendingInviteList = pendingInviteList;
	}

	public List<User> getTeamList() {
		return teamList;
	}

	public void setTeamList(List<User> teamList) {
		this.teamList = teamList;
	}

	public String getTempPassword() {
		return tempPassword;
	}

	public void setTempPassword(String tempPassword) {
		this.tempPassword = tempPassword;
	}

	public String getIsMfaEnable() {
		return isMfaEnable;
	}

	public void setIsMfaEnable(String isMfaEnable) {
		this.isMfaEnable = isMfaEnable;
	}

	public boolean isAuthenticatedByUserName() {
		return isAuthenticatedByUserName;
	}

	public void setAuthenticatedByUserName(boolean isAuthenticatedByUserName) {
		this.isAuthenticatedByUserName = isAuthenticatedByUserName;
	}

	public byte[] getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(byte[] profileImage) {
		this.profileImage = profileImage;
	}

//	public List<Document> getDocumentList() {
//		return documentList;
//	}
//
//	public void setDocumentList(List<Document> documentList) {
//		this.documentList = documentList;
//	}

    public String getEncPassword() {
        return encPassword;
    }

    public void setEncPassword(String encPassword) {
        this.encPassword = encPassword;
    }

    public Integer getLoginCount() {
        return loginCount;
    }

    public void setLoginCount(Integer loginCount) {
        this.loginCount = loginCount;
    }

    public Date getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(Date lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        User otherObject = (User) obj;

        return this.id == otherObject.id;
    }
}
