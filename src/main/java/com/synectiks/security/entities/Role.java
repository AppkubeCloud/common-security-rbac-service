package com.synectiks.security.entities;

import java.util.List;
import java.util.Set;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.synectiks.security.config.IDBConsts;
import com.synectiks.security.domain.PSqlEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

/**
 * @author Rajesh
 */
@Entity
@Table(name = IDBConsts.Tbl_ROLES)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Role extends PSqlEntity {

	private static final long serialVersionUID = 2619620405443093727L;
//	public static final Role ROLE_ADMIN = create(IConsts.ADMIN);

	private String name;
	@Column(nullable = true)
	private Long version;
	private boolean grp;

    @ColumnDefault(value = "false")
    private boolean isDefault;

    @OneToOne(targetEntity = Organization.class, fetch = FetchType.EAGER)
    @JsonIgnoreProperties(value = "organizations", allowSetters = true)
    private Organization organization;

    @Column(nullable = true)
	private String description;

    @ManyToMany(targetEntity = Role.class, fetch = FetchType.EAGER)
	private Set<Role> roles;

    @ManyToMany(targetEntity = Policy.class, fetch = FetchType.LAZY)
    private List<Policy> policies;

    @Transient
    @JsonProperty
    private List<ObjectNode> users;

    @Transient
    @JsonProperty
    private List<Permission> disAllowedPermissions;

    @Transient
    @JsonProperty
    private List<Permission> allowedPermissions;

    public List<Policy> getPolicies() {
        return policies;
    }

    public void setPolicies(List<Policy> policies) {
        this.policies = policies;
    }

    public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}


	public Set<Role> getRoles() {
		return roles;
	}

	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}

	public boolean isGrp() {
		return grp;
	}

	public void setGrp(boolean grp) {
		this.grp = grp;
	}

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public List<ObjectNode> getUsers() {
        return users;
    }

    public void setUsers(List<ObjectNode> users) {
        this.users = users;
    }

    public List<Permission> getDisAllowedPermissions() {
        return disAllowedPermissions;
    }

    public void setDisAllowedPermissions(List<Permission> disAllowedPermissions) {
        this.disAllowedPermissions = disAllowedPermissions;
    }

    public List<Permission> getAllowedPermissions() {
        return allowedPermissions;
    }

    public void setAllowedPermissions(List<Permission> allowedPermissions) {
        this.allowedPermissions = allowedPermissions;
    }

    @Override
	public String toString() {
		return "{" + (version != null ? "\"version\": \"" + version + "\", " : "")
				+ (name != null ? "\"name\": \"" + name + "\", " : "")
				+ (description != null ? "\"description\": \"" + description + "\", " : "")
//				+ (permissions != null ? "\"permissions\": " + permissions + ", " : "")
				+ (roles != null ? "\"roles\": " + roles + ", " : "")
				+ ((id!=null &&id > 0) ? "\"id\": " + id + ", " : "")
				+ ("\"grp\": " + grp + ", ")
                + ("\"isDefault\": " + isDefault + ", ")
				+ (createdAt != null ? "\"createdAt\": \"" + createdAt + "\", " : "")
				+ (updatedAt != null ? "\"updatedAt\": \"" + updatedAt + "\", " : "")
				+ (createdBy != null ? "\"createdBy\": \"" + createdBy + "\", " : "")
				+ (updatedBy != null ? "\"updatedBy\": \"" + updatedBy + "\"" : "")
				+ "}";
	}

//	private static Role create(String roleName) {
//		Role role = new Role();
//		role.setName("ROLE_" + roleName);
//		return role;
//	}

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        Role otherObject = (Role) obj;

        return this.id == otherObject.id;
    }

    public static Role build(Role oldRole, Organization organization){
        Role role = Role.builder()
            .name(oldRole.getName())
            .version(oldRole.getVersion())
            .grp(oldRole.isGrp())
            .isDefault(oldRole.isDefault())
            .description(oldRole.getDescription())
            .organization(organization)
            .build();
        return role;
    }
}
