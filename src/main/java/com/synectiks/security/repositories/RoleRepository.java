/**
 *
 */
package com.synectiks.security.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.synectiks.security.entities.Role;

import java.util.List;

/**
 * @author Rajesh
 */
@Repository
public interface RoleRepository extends JpaRepository<Role, Long>{// CrudRepository<Role, String> {

	public String findIdByName(String name);
    List<Role> findByCreatedByAndGrp(String createdBy, boolean grp);
    List<Role> findByOrganizationIdAndGrp(Long organizationId, boolean grp);
    Role findByNameAndGrpAndOrganizationId(String name, boolean grp, Long organizationId);
    List<Role> findByGrpAndIsDefault(boolean grp, boolean isDefault);
    List<Role> findByOrganizationIdAndIsDefault(Long organizationId, boolean isDefault);
}
