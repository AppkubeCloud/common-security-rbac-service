/**
 *
 */
package com.synectiks.security.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.SequenceGenerator;

/**
 * @author Rajesh
 */
@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class PSqlEntity implements Serializable {

	private static final long serialVersionUID = -6637412247017015975L;

	private static final String ATTR_ID_SEQ = "psqlSeq";

	@Id
	@SequenceGenerator(name = ATTR_ID_SEQ,
		sequenceName = ATTR_ID_SEQ,
		initialValue = 1,
		allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE,
		generator = ATTR_ID_SEQ)
	protected Long id;

	protected Date createdAt;
	protected Date updatedAt;
	protected String createdBy;
	protected String updatedBy;

	public Long getId() {
		return id;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public String getUpdatedBy() {
		return updatedBy;
	}

	public void setId(Long id) {
		this.id = id;
	}

//	public void setId(String id) {
//		if (!IUtils.isNullOrEmpty(id) && id.trim().matches("^\\d+$")) {
//			this.id = Long.parseLong(id.trim());
//		}
//	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public void setUpdatedBy(String updatedBy) {
		this.updatedBy = updatedBy;
	}
}
