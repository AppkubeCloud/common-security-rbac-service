package com.synectiks.security.entities;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.synectiks.security.config.IDBConsts;
import com.synectiks.security.domain.PSqlEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

/**
 * @author Rajesh
 */
@Entity
@Table(name = IDBConsts.Tbl_PERMISSION)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Permission extends PSqlEntity {

	private static final long serialVersionUID = 8069169541347906220L;

	@Column(nullable = true)
    private Long version;
    private String name;

    @Column(nullable = true)
    private String description;

    @Column(nullable = true)
    private String status;

    @OneToOne(targetEntity = Organization.class, fetch = FetchType.EAGER)
    @JsonIgnoreProperties(value = "organizations", allowSetters = true)
    private Organization organization;

    public Long getVersion() {
        return version;
    }

    public void setVersion(Long version) {
        this.version = version;
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

	@Override
	public String toString() {
		return "{\"" + (version != null ? "version\": \"" + version + "\", " : "")
				+ (name != null ? "name\": \"" + name + "\", " : "")
				+ (description != null ? "description\": \"" + description + "\", " : "")
                + (status != null ? "status\": \"" + status + "\", " : "")
				+ ( (id!=null && id > 0) ? "id\": \"" + id + "\", " : "")
				+ (createdAt != null ? "createdAt\": \"" + createdAt + "\", " : "")
				+ (updatedAt != null ? "updatedAt\": \"" + updatedAt + "\", " : "")
				+ (createdBy != null ? "createdBy\": \"" + createdBy + "\", " : "")
				+ (updatedBy != null ? "updatedBy\": \"" + updatedBy : "") + "}";
	}

    public static Permission build(Permission oldPermission, Organization organization){
        Permission permission = Permission.builder()
            .name(oldPermission.getName())
            .description(oldPermission.getDescription())
            .status(oldPermission.getStatus())
            .version(oldPermission.getVersion())
            .organization(organization)
            .build();
        return permission;
    }
}
