package com.synectiks.security.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.synectiks.security.config.IDBConsts;
import com.synectiks.security.domain.PSqlEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

/**
 * @author Manoj
 */
@Entity
@Table(name = IDBConsts.Tbl_PERMISSION_CATEGORY)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PermissionCategory extends PSqlEntity {

	private static final long serialVersionUID = 2619620405443093733L;

    private String name;

    @Column(nullable = true)
	private String description;

    @Column(nullable = true)
    private Long version;

    @Column(nullable = true)
//    @ColumnDefault(value = "ACTIVE")
    private String status;

    @OneToOne(targetEntity = Organization.class, fetch = FetchType.EAGER)
    @JsonIgnoreProperties(value = "organizations", allowSetters = true)
    private Organization organization;


    @ManyToMany(targetEntity = Permission.class, fetch = FetchType.LAZY)
	private List<Permission> permissions;

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public List<Permission> getPermissions() {
		return permissions;
	}

	public void setPermissions(List<Permission> permissions) {
		this.permissions = permissions;
	}


    @Override
	public String toString() {
		return "{" + (version != null ? "\"version\": \"" + version + "\", " : "")
				+ (name != null ? "\"name\": \"" + name + "\", " : "")
				+ (description != null ? "\"description\": \"" + description + "\", " : "")
                + (status != null ? "\"status\": \"" + status + "\", " : "")
//				+ (permissions != null ? "\"permissions\": " + permissions + ", " : "")
				+ ((id!=null &&id > 0) ? "\"id\": " + id + ", " : "")
				+ (createdAt != null ? "\"createdAt\": \"" + createdAt + "\", " : "")
				+ (updatedAt != null ? "\"updatedAt\": \"" + updatedAt + "\", " : "")
				+ (createdBy != null ? "\"createdBy\": \"" + createdBy + "\", " : "")
				+ (updatedBy != null ? "\"updatedBy\": \"" + updatedBy + "\"" : "")
				+ "}";
	}

    public static PermissionCategory build(PermissionCategory oldPermCatg, Organization organization){
        PermissionCategory permissionCategory = PermissionCategory.builder()
            .name(oldPermCatg.getName())
            .status(oldPermCatg.getStatus())
            .description(oldPermCatg.getDescription())
            .version(oldPermCatg.getVersion())
            .organization(organization)
            .build();
        return permissionCategory;
    }
}
