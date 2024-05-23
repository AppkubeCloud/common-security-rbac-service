CREATE TABLE public.config (
	id int8 NOT NULL,
	"key" varchar(255) NULL,
	value varchar(255) NULL,
	status varchar(255) NULL,
	is_encrypted boolean DEFAULT false,
	created_at timestamp NULL,
	updated_at timestamp NULL,
	updated_by varchar(255) NULL,
	created_by varchar(255) NULL,
	organization_id int8 NULL,
	CONSTRAINT config_pkey PRIMARY KEY (id)
);
-- public.config foreign keys
ALTER TABLE public.config ADD CONSTRAINT fk_config__organization_id FOREIGN KEY (organization_id) REFERENCES public.organization(id);
-- public.config unique constraint
ALTER TABLE public.config ADD constraint unique_config_key UNIQUE (key,organization_id);
-- insert SYNECTIKS data
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id, is_encrypted)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_ACCESS_KEY', 'W0zVdGPUe1Z4ZXhSL0ntddfUOd4AFk1x5Olazj9Xo2E=', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'), true);
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id, is_encrypted)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_SECRET_KEY', 'bRayimaXosughPPMGpNgrDFULcpZIo9nWStZwk/lbHHEws7YPKMKWQkxfkXUpoCt', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'), true);
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_REGION', 'us-east-1', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_S3_BUCKET_NAME_FOR_USER_IMAGES', 'appkube', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_USER_IMAGES', 'security-service/user_profile_image/', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_EMAIL_END_POINT', 'email.us-east-1.amazonaws.com', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_APPKUBE_EMAIL_SENDER', 'manoj.sharma@synectiks.com', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));

