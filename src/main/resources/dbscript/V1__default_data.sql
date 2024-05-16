-- public.psql_seq definition

-- DROP SEQUENCE public.psql_seq;

CREATE SEQUENCE public.psql_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;


-- public.sequence_generator definition

-- DROP SEQUENCE public.sequence_generator;

CREATE SEQUENCE public.sequence_generator
	INCREMENT BY 50
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- public.organization definition

-- Drop table

-- DROP TABLE public.organization;

CREATE TABLE public.organization (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	address varchar(255) NULL,
	cmdb_org_id int8 NULL,
	date_of_establishment timestamp NULL,
	description varchar(5000) NULL,
	email varchar(255) NULL,
	fax varchar(255) NULL,
	"name" varchar(255) NULL,
	phone varchar(255) NULL,
	status varchar(255) NULL,
	CONSTRAINT organization_pkey PRIMARY KEY (id)
);


-- public.policy_assigned_permissions definition

-- Drop table

-- DROP TABLE public.policy_assigned_permissions;

CREATE TABLE public.policy_assigned_permissions (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	permission_category_id int8 NULL,
	permission_category_name varchar(255) NULL,
	permission_id int8 NULL,
	permission_name varchar(255) NULL,
	policy_id int8 NULL,
	policy_name varchar(255) NULL,
	CONSTRAINT policy_assigned_permissions_pkey PRIMARY KEY (id)
);


-- public."result" definition

-- Drop table

-- DROP TABLE public."result";

CREATE TABLE public."result" (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	policy_id int8 NOT NULL,
	rule_id int8 NOT NULL,
	scroll_id varchar(255) NULL,
	terminated_early bool NOT NULL,
	time_out bool NOT NULL,
	took_in_millis int8 NOT NULL,
	total_hits int8 NOT NULL,
	CONSTRAINT result_pkey PRIMARY KEY (id)
);


-- public.user_session definition

-- Drop table

-- DROP TABLE public.user_session;

CREATE TABLE public.user_session (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	expiration_time timestamp NULL,
	session_id varchar(255) NULL,
	username varchar(255) NULL,
	CONSTRAINT user_session_pkey PRIMARY KEY (id)
);





-- public."permission" definition

-- Drop table

-- DROP TABLE public."permission";

CREATE TABLE public."permission" (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	description varchar(255) NULL,
	"name" varchar(255) NULL,
	status varchar(255) NULL,
	"version" int8 NULL,
	organization_id int8 NULL,
	CONSTRAINT permission_pkey PRIMARY KEY (id),
	CONSTRAINT fkodqlqlhjgsfwnq418388o4vy7 FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);


-- public.permission_category definition

-- Drop table

-- DROP TABLE public.permission_category;

CREATE TABLE public.permission_category (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	description varchar(255) NULL,
	"name" varchar(255) NULL,
	status varchar(255) NULL,
	"version" int8 NULL,
	organization_id int8 NULL,
	CONSTRAINT permission_category_pkey PRIMARY KEY (id),
	CONSTRAINT fk6cecfm9olmucgpwtkxtd1nmim FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);


-- public.permission_category_permissions definition

-- Drop table

-- DROP TABLE public.permission_category_permissions;

CREATE TABLE public.permission_category_permissions (
	permission_category_id int8 NOT NULL,
	permissions_id int8 NOT NULL,
	CONSTRAINT fk6yy1xp4swjfqrocky6pbwvepn FOREIGN KEY (permission_category_id) REFERENCES public.permission_category(id),
	CONSTRAINT fkfwqcah846enn37rtxssckh6b3 FOREIGN KEY (permissions_id) REFERENCES public."permission"(id)
);


-- public."policy" definition

-- Drop table

-- DROP TABLE public."policy";

CREATE TABLE public."policy" (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	description varchar(255) NULL,
	"name" varchar(255) NULL,
	status varchar(255) NULL,
	"version" int8 NULL,
	organization_id int8 NULL,
	CONSTRAINT policy_pkey PRIMARY KEY (id),
	CONSTRAINT fksqtsvf9afdq1es23w3pvxwgg6 FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);


-- public.policy_permissions definition

-- Drop table

-- DROP TABLE public.policy_permissions;

CREATE TABLE public.policy_permissions (
	policy_id int8 NOT NULL,
	permissions_id int8 NOT NULL,
	CONSTRAINT fkn3ubhdfsb86h66cyocgfoabgk FOREIGN KEY (policy_id) REFERENCES public."policy"(id),
	CONSTRAINT fkthth1u869ladvoywpfiosw50y FOREIGN KEY (permissions_id) REFERENCES public.policy_assigned_permissions(id)
);


-- public.policy_rule_result_hits definition

-- Drop table

-- DROP TABLE public.policy_rule_result_hits;

CREATE TABLE public.policy_rule_result_hits (
	policy_rule_result_id int8 NOT NULL,
	hits varchar(255) NULL,
	CONSTRAINT fktgfw2q551t5fwvtav8uataand FOREIGN KEY (policy_rule_result_id) REFERENCES public."result"(id)
);


-- public.roles definition

-- Drop table

-- DROP TABLE public.roles;

CREATE TABLE public.roles (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	description varchar(255) NULL,
	grp bool NOT NULL,
	is_default bool DEFAULT false NOT NULL,
	"name" varchar(255) NULL,
	"version" int8 NULL,
	organization_id int8 NULL,
	CONSTRAINT roles_pkey PRIMARY KEY (id),
	CONSTRAINT fka5o1wded95yft05nr1ik1592 FOREIGN KEY (organization_id) REFERENCES public.organization(id)
);


-- public.roles_policies definition

-- Drop table

-- DROP TABLE public.roles_policies;

CREATE TABLE public.roles_policies (
	role_id int8 NOT NULL,
	policies_id int8 NOT NULL,
	CONSTRAINT fk1uny2l7d06h1pt72a2nwkanrj FOREIGN KEY (role_id) REFERENCES public.roles(id),
	CONSTRAINT fkmfsrcwnq74agqwf23tnvhd59h FOREIGN KEY (policies_id) REFERENCES public."policy"(id)
);


-- public.roles_roles definition

-- Drop table

-- DROP TABLE public.roles_roles;

CREATE TABLE public.roles_roles (
	role_id int8 NOT NULL,
	roles_id int8 NOT NULL,
	CONSTRAINT roles_roles_pkey PRIMARY KEY (role_id, roles_id),
	CONSTRAINT fkh0er2qrwpns8hej8uk95j4f6h FOREIGN KEY (role_id) REFERENCES public.roles(id),
	CONSTRAINT fkqao0vjvqum05dlyy56wc7r5mi FOREIGN KEY (roles_id) REFERENCES public.roles(id)
);


-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
	id int8 NOT NULL,
	created_at timestamp NULL,
	created_by varchar(255) NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	active bool NOT NULL,
	email varchar(255) NULL,
	enc_password varchar(255) NULL,
	google_mfa_key varchar(255) NULL,
	invite_code varchar(255) NULL,
	invite_link varchar(1000) NULL,
	invite_sent_on timestamp NULL,
	invite_status varchar(255) NULL,
	is_mfa_enable varchar(255) NULL,
	last_login_at timestamp NULL,
	login_count int4 NULL,
	mfa_qr_image_file_path varchar(255) NULL,
	"password" varchar(255) NULL,
	temp_password varchar(255) NULL,
	"type" varchar(255) NULL,
	username varchar(255) NULL,
	organization_id int8 NULL,
	owner_id int8 NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT fk9q8fdenwsqjwrjfivd5ovv5k3 FOREIGN KEY (organization_id) REFERENCES public.organization(id),
	CONSTRAINT fkntyuh06i5y3y6ir598luxy3k9 FOREIGN KEY (owner_id) REFERENCES public.users(id)
);


-- public.users_roles definition

-- Drop table

-- DROP TABLE public.users_roles;

CREATE TABLE public.users_roles (
	user_id int8 NOT NULL,
	roles_id int8 NOT NULL,
	CONSTRAINT fk2o0jvgh89lemvvo17cbqvdxaa FOREIGN KEY (user_id) REFERENCES public.users(id),
	CONSTRAINT fka62j07k5mhgifpp955h37ponj FOREIGN KEY (roles_id) REFERENCES public.roles(id)
);

INSERT INTO public.organization (id, created_at, created_by, updated_at, description, "name", status)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Default organization', 'DEFAULT', 'ACTIVE');

-- insert in permission_category
INSERT INTO permission_category (id, created_at, created_by, updated_at, description, "name", status, "version", organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Environment', 'Environment', 'ACTIVE', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO permission_category (id, created_at, created_by, updated_at, description, "name", status, "version", organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Product', 'Product', 'ACTIVE', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO permission_category (id, created_at, created_by, updated_at, description, "name", status, "version", organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'SRE', 'SRE', 'ACTIVE', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO permission_category (id, created_at, created_by, updated_at, description, "name", status, "version", organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'DevSecOps', 'DevSecOps', 'ACTIVE', 1, (select id from organization where name = 'DEFAULT'));
---- insert in permission table
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Create Landing Zone', 'Create Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Landing Zone', 'Edit Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Clone Landing Zone', 'Clone Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Migrate Landing Zone', 'Migrate Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Landing Zone', 'Delete Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Replicate Landing Zone', 'Replicate Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Create Product Enclave', 'Create Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Product Enclave', 'Edit Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Clone Product Enclave', 'Clone Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Migrate Product Enclave', 'Migrate Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Product Enclave', 'Delete Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Replicate Product Enclave', 'Replicate Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Add Service Mesh in Product Enclave', 'Add Service Mesh in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Service Mesh in Product Enclave', 'Edit Service Mesh in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Service Mesh in Product Enclave', 'Delete Service Mesh in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Add Api Gateway in Product Enclave', 'Add Api Gateway in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Api Gateway in Product Enclave', 'Edit Api Gateway in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Api Gateway in Product Enclave', 'Delete Api Gateway in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Add firewall in Product Enclave', 'Add firewall in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit firewall in Product Enclave', 'Edit firewall in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete firewall in Product Enclave', 'Delete firewall in Product Enclave', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Create Container Cluster', 'Create Container Cluster', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Container Cluster', 'Edit Container Cluster', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Clone Container Cluster', 'Clone Container Cluster', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Migrate Container Cluster', 'Migrate Container Cluster', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Container Cluster', 'Delete Container Cluster', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Replicate Container Cluster', 'Replicate Container Cluster', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Create Product Environment', 'Create Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Product Environment', 'Edit Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Clone Product Environment', 'Clone Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Migrate Product Environment', 'Migrate Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Product Environment', 'Delete Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Replicate Product Environment', 'Replicate Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Add Service in Product Environment', 'Add Service in Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Edit Service in Product Environment', 'Edit Service in Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Delete Service in Product Environment', 'Delete Service in Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Replicate Service in Product Environment', 'Replicate Service in Product Environment', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Enable SLA monitoring for Service', 'Enable SLA monitoring for Service', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Disable SLA monitoring for Service', 'Disable SLA monitoring for Service', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Enable Log for Cloud Element', 'Enable Log for Cloud Element', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Enable Trace for Cloud Element', 'Enable Trace for Cloud Element', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Enable complaince audits for Landing Zone', 'Enable complaince audits for Landing Zone', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Generate Service from Template', 'Generate Service from Template', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Perform code security audit for service', 'Perform code security audit for service', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Perform code scanning for sonar complaince', 'Perform code scanning for sonar complaince', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Perform bdd tests on service', 'Perform bdd tests on service', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
INSERT INTO public."permission" (id, created_at, created_by, updated_at, description, "name", "version", status, organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Perform atp tests on service', 'Perform atp tests on service', 1, 'ACTIVE', (select id from organization where name = 'DEFAULT'));
--- insert in permission_category_permissions table
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Create Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Clone Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Migrate Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Replicate Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Create Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Clone Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Migrate Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Replicate Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Add Service Mesh in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Service Mesh in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Service Mesh in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Add Api Gateway in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Api Gateway in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Api Gateway in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Add firewall in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit firewall in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete firewall in Product Enclave'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Create Container Cluster'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Container Cluster'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Clone Container Cluster'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Migrate Container Cluster'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Container Cluster'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Environment'),(select id from permission where name ='Replicate Container Cluster'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Create Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Edit Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Clone Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Migrate Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Delete Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Replicate Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Add Service in Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Edit Service in Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Delete Service in Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'Product'),(select id from permission where name ='Replicate Service in Product Environment'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable SLA monitoring for Service'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'SRE'),(select id from permission where name ='Disable SLA monitoring for Service'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable Log for Cloud Element'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable Trace for Cloud Element'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable complaince audits for Landing Zone'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Generate Service from Template'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform code security audit for service'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform code scanning for sonar complaince'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform bdd tests on service'));
insert into permission_category_permissions (permission_category_id, permissions_id) values ((select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform atp tests on service'));
-- create default policy
INSERT INTO public."policy"(id, created_at, created_by, updated_at, updated_by, description, "name", status, "version", organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, NULL, 'All Access Policy', 'All Access', 'ACTIVE', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO public."policy"(id, created_at, created_by, updated_at, updated_by, description, "name", status, "version", organization_id) VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, NULL, 'No Access Policy', 'No Access', 'ACTIVE', 1, (select id from organization where name = 'DEFAULT'));
-- assign all permissions to all access policy
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Create Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Clone Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Migrate Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Replicate Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Create Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Clone Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Migrate Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Replicate Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Add Service Mesh in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Service Mesh in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Service Mesh in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Add Api Gateway in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Api Gateway in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Api Gateway in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Add firewall in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit firewall in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete firewall in Product Enclave'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Create Container Cluster'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Edit Container Cluster'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Clone Container Cluster'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Migrate Container Cluster'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Delete Container Cluster'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Environment'),(select id from permission where name ='Replicate Container Cluster'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Create Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Edit Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Clone Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Migrate Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Delete Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Replicate Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Add Service in Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Edit Service in Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Delete Service in Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'Product'),(select id from permission where name ='Replicate Service in Product Environment'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable SLA monitoring for Service'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'SRE'),(select id from permission where name ='Disable SLA monitoring for Service'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable Log for Cloud Element'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable Trace for Cloud Element'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'SRE'),(select id from permission where name ='Enable complaince audits for Landing Zone'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Generate Service from Template'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform code security audit for service'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform code scanning for sonar complaince'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform bdd tests on service'), (select id from policy p2 where p2.name = 'All Access'));
insert into policy_assigned_permissions (id, created_by, permission_category_id, permission_id, policy_id) values ((SELECT nextval('psql_seq')), 'System', (select id from permission_category where name = 'DevSecOps'),(select id from permission where name ='Perform atp tests on service'), (select id from policy p2 where p2.name = 'All Access'));
-- insert into policy_permissions
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Create Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Clone Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Migrate Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Replicate Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Create Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Clone Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Migrate Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Replicate Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Add Service Mesh in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Service Mesh in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Service Mesh in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Add Api Gateway in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Api Gateway in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Api Gateway in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Add firewall in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit firewall in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete firewall in Product Enclave')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Create Container Cluster')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Container Cluster')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Clone Container Cluster')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Migrate Container Cluster')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Container Cluster')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Environment')
		and pap.permission_id = (select id from "permission" p where p.name = 'Replicate Container Cluster')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Create Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Clone Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Migrate Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Replicate Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Add Service in Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Edit Service in Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Delete Service in Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'Product')
		and pap.permission_id = (select id from "permission" p where p.name = 'Replicate Service in Product Environment')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'SRE')
		and pap.permission_id = (select id from "permission" p where p.name = 'Enable SLA monitoring for Service')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'SRE')
		and pap.permission_id = (select id from "permission" p where p.name = 'Disable SLA monitoring for Service')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'SRE')
		and pap.permission_id = (select id from "permission" p where p.name = 'Enable Log for Cloud Element')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'SRE')
		and pap.permission_id = (select id from "permission" p where p.name = 'Enable Trace for Cloud Element')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'SRE')
		and pap.permission_id = (select id from "permission" p where p.name = 'Enable complaince audits for Landing Zone')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'DevSecOps')
		and pap.permission_id = (select id from "permission" p where p.name = 'Generate Service from Template')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'DevSecOps')
		and pap.permission_id = (select id from "permission" p where p.name = 'Perform code security audit for service')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'DevSecOps')
		and pap.permission_id = (select id from "permission" p where p.name = 'Perform code scanning for sonar complaince')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'DevSecOps')
		and pap.permission_id = (select id from "permission" p where p.name = 'Perform bdd tests on service')));
insert into policy_permissions (policy_id, permissions_id)
values((select id from policy where name = 'All Access'),(select pap.id from policy_assigned_permissions pap where pap.permission_category_id = (select id from permission_category pc where pc.name = 'DevSecOps')
		and pap.permission_id = (select id from "permission" p where p.name = 'Perform atp tests on service')));

-- insert into roles
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version", organization_id)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Administrator is the highest level of administrative authority within a system', false, true, 'Administrator', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version", organization_id)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'A basic user', false, true, 'Basic User', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version", organization_id)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Super Admins is the highest level of administrative authority within a system', true, true, 'Super Admins', 1, (select id from organization where name = 'DEFAULT'));
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version", organization_id)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'A basic user role group', true, true, 'Default Users', 1, (select id from organization where name = 'DEFAULT'));

-- insert into roles_policies
insert into roles_policies(role_id, policies_id) values ((select id from roles where name = 'Administrator'),(select id from policy where name = 'All Access'));
insert into roles_policies(role_id, policies_id) values ((select id from roles where name = 'Basic User'),(select id from policy where name = 'No Access'));

-- insert into roles_roles
insert into roles_roles(role_id, roles_id) values ((select id from roles where name = 'Super Admins' and grp = true),(select id from roles where name = 'Administrator' and grp = false));
insert into roles_roles(role_id, roles_id) values ((select id from roles where name = 'Default Users' and grp = true),(select id from roles where name = 'Basic User' and grp = false));

-- insert into users
INSERT INTO users (id, created_at, created_by, updated_at, updated_by, active, enc_password, "password", temp_password, "type", username, organization_id)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'System', true, 'BzqrSR6r4qnx3TURlr4M3w==', '$shiro1$SHA-256$500000$gmsw0Pw/9KjOYsKGI0seJQ==$BWCzd2tuiNT8kMfMVhQm2OJnICWqVvIioFU2VUnb+h4=', NULL, 'SUPER ADMIN', 'admin', (select id from organization where name = 'DEFAULT'));

-- insert into users_roles
INSERT INTO users_roles (user_id, roles_id)
VALUES((select id from users where username= 'admin' and type = 'SUPER ADMIN' and owner_id is null),(select id from roles where name = 'Super Admins' and grp = true));
INSERT INTO users_roles (user_id, roles_id)
VALUES((select id from users where username= 'admin' and type = 'SUPER ADMIN' and owner_id is null),(select id from roles where name = 'Default Users' and grp = true));
