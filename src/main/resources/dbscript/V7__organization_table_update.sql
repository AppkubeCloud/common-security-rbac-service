alter table users drop column file_storage_location;
alter table organization add column file_name varchar(255);
alter table organization add column file_storage_location_type varchar(255);
alter table organization add column file_storage_location varchar(255);
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_S3_BUCKET_NAME_FOR_ORG_PROFILE_IMAGES', 'appkube', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));
INSERT INTO public.config
(id, "key", value, status, created_at, updated_at, updated_by, created_by, organization_id)
VALUES((SELECT nextval('psql_seq')), 'GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_ORG_PROFILE_IMAGES', 'security-service/org_profile_image/', 'ACTIVE', current_timestamp, current_timestamp, 'System', 'System', (select id from organization where name = 'SYNECTIKS'));

