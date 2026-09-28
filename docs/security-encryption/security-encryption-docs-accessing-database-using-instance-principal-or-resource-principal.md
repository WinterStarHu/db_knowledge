# Accessing the Database Using an Instance Principal or a Resource Principal

An Oracle Cloud Infrastructure (OCI) application or function can connect to the database instance using its own instance or resource principal.
You can map instance principals and resource principals exclusively to a database global schema or to a shared schema using a mapping to a dynamic group. When mapping instance principals and resource principals exclusively to a database global schema, you must use the principal OCID. For example:
```
CREATE USER widget IDENTIFIED GLOBALLY
AS 'IAM_PRINCIPAL_OCID=ocid1.instance.region1.sea.1234567890abcdef';
```
When using shared schemas, you must add instance principals and resource principals to a dynamic group, and map the dynamic group to the shared schema.
## Related Topics
  - Managing Dynamic Groups
  - Calling Services from an Instance
  - Accessing Other Oracle Cloud Infrastructure Resources from Running Functions
  - Accessing the Oracle Cloud Infrastructure API Using Instance Principals
**- Using Oracle Autonomous Database Serverless
