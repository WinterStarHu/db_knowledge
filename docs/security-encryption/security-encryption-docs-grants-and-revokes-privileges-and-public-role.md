# Grants and Revokes of Privileges to and from the PUBLIC Role

You can grant and revoke privileges and roles from the role `PUBLIC`.
Because `PUBLIC` is accessible to every database user, all privileges and roles granted to `PUBLIC` are accessible to every database user. By default, `PUBLIC` does not have privileges granted to it.
Security administrators and database users should grant a privilege or role to `PUBLIC` only if every database user requires the privilege or role. This recommendation reinforces the general rule that, at any given time, each database user should have only the privileges required to accomplish the current group tasks successfully.
Revoking a privilege from the `PUBLIC` role can cause significant cascading effects. If any privilege related to a DML operation is revoked from `PUBLIC` (for example, `SELECT` `ANY TABLE` or `UPDATE ON` `emp`), then all procedures in the database, including functions and packages, must be *reauthorized* before they can be used again. Therefore, be careful when you grant and revoke DML-related privileges to or from `PUBLIC`.
**Caution:**  `PUBLIC` is a role, not an object-owning schema. Do not qualify object creation statements with `PUBLIC`, such as `CREATE TYPE public.type_name`. To make an object available broadly, create it in an application schema and grant the required privileges to users, roles, or `PUBLIC` only when appropriate.
## Related Topics
  - Guidelines for Securing Data
**- Oracle Database Administrator’s Guide
