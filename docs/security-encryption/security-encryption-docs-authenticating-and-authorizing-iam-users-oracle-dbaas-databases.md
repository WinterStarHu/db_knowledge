# Authenticating and Authorizing IAM Users for Oracle DBaaS Databases

Identity and Access Management (IAM) users can be configured to connect to an Oracle Database as a service (Oracle DBaaS) instance.
**Note:**   Oracle Cloud Infrastructure (OCI) IAM authentication is only available for OCI Database services, such as Oracle Base Database Service, Oracle Exadata Database Service, and Oracle Autonomous Database, that operate in a PDB/CDB (multitenant) configuration. It is not available for 19c databases configured in single-container mode, nor is it available on-premises or for databases operating on OCI compute instances.
- Introduction to Authenticating and Authorizing IAM Users for Oracle DBaaS Before you begin authenticating and authorizing IAM users for an Oracle DBaaS instance, you should understand the overall process.
- Configuring Oracle DBaaS for IAM To configure Oracle DBaaS to work with IAM, an Oracle DBaaS database administrator must first enable the IAM integration and then authorize IAM users and roles for Oracle DBaaS.
- Configuring IAM for Oracle DBaaS To configure IAM to work with the Oracle DBaaS instance, an IAM administrator may need to create an IAM policy and have users create an IAM database password.
- Accessing the Database Using an Instance Principal or a Resource Principal An Oracle Cloud Infrastructure (OCI) application or function can connect to the database instance using its own instance or resource principal.
- Configuring the Database Client Connection Configuring the IAM client connection controls the authentication of IAM users to the Oracle DBaaS instance.
- Accessing a Database Cross-Tenancy Using an IAM Integration Users and groups in one tenancy can access DBaaS database instances in another tenancy if policies in both tenancies allow this.
- Database Links in an Oracle DBaaS-to-IAM Integration The use of database links when accessing the Oracle DBaaS database using IAM credentials is supported.
- Troubleshooting IAM Connections The ORA-01017: invalid username/password; logon denied error can be caused by several different issues throughout the Oracle DBaaS integration with Identity and Access Management (IAM).
