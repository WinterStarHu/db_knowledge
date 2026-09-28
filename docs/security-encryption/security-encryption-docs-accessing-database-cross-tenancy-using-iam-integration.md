# Accessing a Database Cross-Tenancy Using an IAM Integration

Users and groups in one tenancy can access DBaaS database instances in another tenancy if policies in both tenancies allow this.
- About Cross-Tenancy Access for IAM Users to DBaaS Instances Cross-tenancy access to an Oracle Cloud Infrastructure (OCI) DBaaS instance is similar to a single tenancy scenario except that tenancy information is required for mappings and token requests and a policy is required in both tenancies to allow this cross tenancy database resource access.
- Configuring Policies You must create policies in both the user tenancy and the database resource tenancy to allow cross-tenancy database access.
- Mapping Database Schemas and Roles to Users and Groups in Another Tenancy When you perform this type of mapping, you must add the tenancy OCID to the mapping information so the database knows it is cross-tenancy access.
- Configuring Database Clients for Cross-Tenancy Access You can configure some database clients directly.
````
- Requesting Cross-Tenancy Tokens Using the OCI Command-Line Interface You must add the --scope parameter to the Oracle Cloud Infrastructure (OCI) command-line interface command to get a db-token for a cross-tenancy request.
## About Cross-Tenancy Access for IAM Users to DBaaS Instances
Cross-tenancy access to an Oracle Cloud Infrastructure (OCI) DBaaS instance is similar to a single tenancy scenario except that tenancy information is required for mappings and token requests and a policy is required in both tenancies to allow this cross tenancy database resource access.
The following figure illustrates the process for a cross-tenancy access to an OCI DBaaS instance.
Description of the illustration db_cross_tenancy.png
The cross-tenancy process is as follows:
- The policy is required in both tenancies to endorse and admit access cross tenancy.
- The IAM principal (user or application) requests a db-token for a cross-tenancy resource.
- The db-token is returned and is used to access the database in a different tenancy
- The database will make a cross-tenancy group query for the user’s groups and map principal to global schema and optional global roles.
You must subscribe the user tenancy to the same regions in which the databases are located. For example, if the databases in the database tenancy are in the `PHX` and `IAD` regions, then you must subscribe the user tenancy to these regions. This is not the home region, just the additional subscribed regions in the user tenancy.
## Configuring Policies
You must create policies in both the user tenancy and the database resource tenancy to allow cross-tenancy database access.
- Configuring the Source User Tenancy Two policies are required to allow cross-tenancy access in the user tenancy.
- Configuring the Target Database Resource Tenancy The database tenancy will need matching policies to enable access to the users from the user tenancy as well as allow its own databases to query group information in the user tenancy
- Policy Examples for Cross-Tenancy Access Examples include using a WHERE clause to refine the cross-tenancy configuration, and other methods of performing this type of configuration.
### Configuring the Source User Tenancy
Two policies are required to allow cross-tenancy access in the user tenancy.
The first policy is to allow a user tenancy group to access a database in a different tenancy. The second policy allows a database in the database tenancy to query group information in the user tenancy.
****
- In the OCI console, select Identity & Security.
********
- Under Identity, select Policies.
********
- Click Create Policy and in the Policy Builder select Show manual editor.
```
DEFINE tenancy database_tenancy as ocid1.tenancy.OCID
```
- Use the DEFINE statement to make it easier to read the actual policies. For example:
````
``````
```
ENDORSE group domainA/xt_db_users to use database-connections in tenancy database_tenancy
```
- Endorse the tenancy group domainA/xt_db_users to use database_connections in tenancy database_tenancy. This allows users of the xt_db_users group in domainA to access any database in tenancy database_tenancy.
```
ADMIT any-user of tenancy database_tenancy to {GROUP_MEMBERSHIP_INSPECT, AUTHENTICATION_INSPECT} in tenancy
```
- Use the ADMIT statement to create an Admit policy to allow any database in the database tenancy to query group information for specific IAM users in the user tenancy.
### Configuring the Target Database Resource Tenancy
The database tenancy will need matching policies to enable access to the users from the user tenancy as well as allow its own databases to query group information in the user tenancy
****
- In the OCI console, select Identity & Security.
********
- Under Identity, select Policies.
********
- Click Create Policy and in the Policy Builder select Show manual editor.
```
DEFINE tenancy user_tenancy as ocid1.tenancy.OCID DEFINE group xt_db_users as ocid1.group.defg
```
- Use DEFINE to make it easier to troubleshoot and read the policies.
````
```
ADMIT group xt_db_users of tenancy user_tenancy to use database-connections in tenancy
```
- Use ADMIT to create an Admit policy in the tenancy to match the Endorse policy from the user tenancy. The Admit policy must match the ENDORSE policy in the user tenancy so that it can enable users from the user_tenancy to access databases in this tenancy.
```
ENDORSE any-user to {GROUP_MEMBERSHIP_INSPECT, AUTHENTICATION_INSPECT} in tenancy user_tenancy
```
- Create an Endorse policy, which will match the Admit policy created in the User tenancy. The Endorse policy will enable databases in the database tenancy to query group information from the user_tenancy.
While using `any-user` makes it easy to understand the required policies, Oracle recommends that you use stronger constraints in addition to or instead of using `any-user`. The `any-user` option will allow any principal or resource to query user groups in the `user_tenancy`. Ideally, you should limit this to just allowing the database resources (resource principals) to make the group queries. You can do this by adding a `WHERE` clause to the policies or by adding a dynamic group that limits it to the members of the dynamic group. Defining every possible way to specify dynamic groups and policies is outside the scope of this topic. You can find more information from these sources:
- Managing Dynamic Groups
- Managing Policies
### Policy Examples for Cross-Tenancy Access
Examples include using a `WHERE` clause to refine the cross-tenancy configuration, and other methods of performing this type of configuration.
You can add a `WHERE` clause to limit the database resources allowed to make the cross-tenancy group query:
```
ADMIT any-user of tenancy db_tenancy to {GROUP_MEMBERSHIP_INSPECT, AUTHENTICATION_INSPECT} in tenancy where request.principal.type = 'dbsystem'
```
This Admit policy allows any Base Database Service (resource type: `dbsystem`) in the `db_tenancy` to query a user’s group information from the user tenancy. Resource type names are in the table below.
A similar method can be done by putting the same resource type into a dynamic group:
```
dynamic group: db_principals
any {resource.type = 'dbsystem', resource.type = 'vmcluster', resource.type = 'cloudvmcluster'}
```
The dynamic group in the preceding example includes database instances for Oracle Base Database Service (`dbsystem`), Oracle Exadata Cloud@Customer (`vmcluster`), and Oracle Exadata Database Service (`cloudvmcluster`).
This example uses a dynamic group instead of `any-user`:
```
ADMIT dynamic group db_principals of tenancy db_tenancy to {GROUP_MEMBERSHIP_INSPECT, AUTHENTICATION_INSPECT} in tenancy
```
You can also add all resource principals in a compartment using `resource.compartment.id`. However, this might also allow other non-database resource principals to make the cross-tenancy group query. The following table provides a mapping of the various resource types with the DBaaS platform name:

| DBaaS Platform Name | Resource Type Name |
|---|---|
| ADB-S | autonomousdatabase |
| ADB-D (OPC) | cloudautonomousvmcluster* |
| Base DBS | dbsystem |
| ExaCS | cloudvmcluster |
| ExaCC | vmcluster |

  - Older ADBD instances may still be using the autonomousexainfrastructure resource type.
## Mapping Database Schemas and Roles to Users and Groups in Another Tenancy
When you perform this type of mapping, you must add the tenancy OCID to the mapping information so the database knows it is cross-tenancy access.
Use a full colon to separate the tenancy OCID when you use the `CREATE USER` and `CREATE ROLE` statements in SQL*Plus.
```
CREATE USER schema1 IDENTIFIED GLOBALLY
AS 'IAM_PRINCIPAL_NAME=ocid1.tenancy.OCID:example_domain/peter.fitch@oracle.com';
CREATE USER schema2 IDENTIFIED GLOBALLY
AS 'IAM_PRINCIPAL_NAME=ocid1.tenancy.OCID:peter.fitch@oracle.com';
CREATE USER qa_db_user_group IDENTIFIED GLOBALLY
AS 'IAM_GROUP_NAME=ocid1.tenancy.OCID:example_domain/xt_db_users';
CREATE USER qa_sales_user_group IDENTIFIED GLOBALLY
AS 'IAM_GROUP_NAME=ocid1.tenancy.OCID:sales_users';
CREATE USER xt_ip_user IDENTIFIED GLOBALLY
AS 'IAM_PRINCIPAL_OCID=ocid1.instance.region1.sea.OCID';
GRANT CREATE SESSION TO xt_ip_user;
CREATE USER xt_iam_dg IDENTIFIED GLOBALLY
AS 'IAM_GROUP_NAME=ocid1.tenancy.region1.OCID:sales_principals';
GRANT CREATE SESSION TO xt_iam_dg;
```
- To use the CREATE USER statement to perform the mapping: The following examples show exclusive and shared schema mapping with principals and groups in default and non-default domains. When using default domains, you do not need to include a domain name.
```
CREATE ROLE globalrole1 IDENTIFIED GLOBALLY
AS 'IAM_GROUP_NAME=ocid1.tenancy.abcdef:example_domain/xt_db_users';
CREATE ROLE globalrole2 IDENTIFIED GLOBALLY
AS 'IAM_GROUP_NAME=ocid1.tenancy.abcdef:sales_users';
```
- To use the CREATE ROLE statement to perform the mapping: The following examples show global role mapping with groups in default and non-default domains. When using default domains, you do not need to include a domain name.
## Configuring Database Clients for Cross-Tenancy Access
You can configure some database clients directly.
The database tenancy must be identified in either the connect string or in `sqlnet.ora` if the client is configured to directly get the access token from OCI IAM. Review client-specific documentation for specific parameter values (JDBC-thin, ODP.NET-core, managed).
## Requesting Cross-Tenancy Tokens Using the OCI Command-Line Interface
You must add the `--scope` parameter to the Oracle Cloud Infrastructure (OCI) command-line interface command to get a `db-token` for a cross-tenancy request.
See Optional Parameters for more details about using the optional parameters of the `oci get` command.
You can scope it for the entire tenancy or scope it to a compartment or database in the tenancy. When scoping for cross tenancy compartment or database, you do not need to also add the tenancy information because the compartment and database OCIDs are unique across OCI.
Certain clients can request the tokens directly from MSEI. Refer to their documentation on setting the parameters to get the MSEI `OAuth2` access tokens.
