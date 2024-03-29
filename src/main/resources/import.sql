INSERT INTO public.organization (id, created_at, created_by, updated_at, description, "name", status)
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'System', current_timestamp, 'Default organization', 'DEFAULT', 'ACTIVE');

-- insert in permission_category
INSERT INTO permission_category (id, description, "name", status, "version") VALUES((SELECT nextval('psql_seq')), 'Environment', 'Environment', 'ACTIVE', 1);
INSERT INTO permission_category (id, description, "name", status, "version") VALUES((SELECT nextval('psql_seq')), 'Product', 'Product', 'ACTIVE', 1);
INSERT INTO permission_category (id, description, "name", status, "version") VALUES((SELECT nextval('psql_seq')), 'SRE', 'SRE', 'ACTIVE', 1);
INSERT INTO permission_category (id, description, "name", status, "version") VALUES((SELECT nextval('psql_seq')), 'DevSecOps', 'DevSecOps', 'ACTIVE', 1);
---- insert in permission table
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Create Landing Zone', 'Create Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Landing Zone', 'Edit Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Clone Landing Zone', 'Clone Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Migrate Landing Zone', 'Migrate Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Landing Zone', 'Delete Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Replicate Landing Zone', 'Replicate Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Create Product Enclave', 'Create Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Product Enclave', 'Edit Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Clone Product Enclave', 'Clone Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Migrate Product Enclave', 'Migrate Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Product Enclave', 'Delete Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Replicate Product Enclave', 'Replicate Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Add Service Mesh in Product Enclave', 'Add Service Mesh in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Service Mesh in Product Enclave', 'Edit Service Mesh in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Service Mesh in Product Enclave', 'Delete Service Mesh in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Add Api Gateway in Product Enclave', 'Add Api Gateway in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Api Gateway in Product Enclave', 'Edit Api Gateway in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Api Gateway in Product Enclave', 'Delete Api Gateway in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Add firewall in Product Enclave', 'Add firewall in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit firewall in Product Enclave', 'Edit firewall in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete firewall in Product Enclave', 'Delete firewall in Product Enclave', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Create Container Cluster', 'Create Container Cluster', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Container Cluster', 'Edit Container Cluster', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Clone Container Cluster', 'Clone Container Cluster', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Migrate Container Cluster', 'Migrate Container Cluster', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Container Cluster', 'Delete Container Cluster', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Replicate Container Cluster', 'Replicate Container Cluster', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Create Product Environment', 'Create Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Product Environment', 'Edit Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Clone Product Environment', 'Clone Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Migrate Product Environment', 'Migrate Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Product Environment', 'Delete Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Replicate Product Environment', 'Replicate Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Add Service in Product Environment', 'Add Service in Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Edit Service in Product Environment', 'Edit Service in Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Delete Service in Product Environment', 'Delete Service in Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Replicate Service in Product Environment', 'Replicate Service in Product Environment', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Enable SLA monitoring for Service', 'Enable SLA monitoring for Service', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Disable SLA monitoring for Service', 'Disable SLA monitoring for Service', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Enable Log for Cloud Element', 'Enable Log for Cloud Element', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Enable Trace for Cloud Element', 'Enable Trace for Cloud Element', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Enable complaince audits for Landing Zone', 'Enable complaince audits for Landing Zone', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Generate Service from Template', 'Generate Service from Template', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Perform code security audit for service', 'Perform code security audit for service', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Perform code scanning for sonar complaince', 'Perform code scanning for sonar complaince', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Perform bdd tests on service', 'Perform bdd tests on service', 1);
INSERT INTO public."permission" (id, description, "name", "version") VALUES((SELECT nextval('psql_seq')), 'Perform atp tests on service', 'Perform atp tests on service', 1);
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
INSERT INTO public."policy"(id, created_at, created_by, updated_at, updated_by, description, "name", status, "version") VALUES((SELECT nextval('psql_seq')), NULL, 'System', NULL, NULL, 'All Access Policy', 'All Access', NULL, 1);
INSERT INTO public."policy"(id, created_at, created_by, updated_at, updated_by, description, "name", status, "version") VALUES((SELECT nextval('psql_seq')), NULL, 'System', NULL, NULL, 'No Access Policy', 'No Access', NULL, 1);
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
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version")
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'admin', current_timestamp, 'Administrator role', false, false, 'Administrator', 1);
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version")
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'admin', current_timestamp, 'Basic User role', false, false, 'Basic User', 1);
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version")
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'admin', current_timestamp, 'Super Admins Role Group', true, false, 'Super Admins', 1);
INSERT INTO roles (id, created_at, created_by, updated_at, description, grp, is_default, "name", "version")
VALUES((SELECT nextval('psql_seq')), current_timestamp, 'admin', current_timestamp, 'Default Users Role Group', true, false, 'Default Users', 1);

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
