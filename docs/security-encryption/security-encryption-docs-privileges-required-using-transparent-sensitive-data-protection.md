# Privileges Required for Using Transparent Sensitive Data Protection

To use transparent sensitive data protection, you must have the `EXECUTE` privilege for several PL/SQL packages.
These privileges are as follows:
- DBMS_TSDP_MANAGE, which enables you to import and manage sensitive columns and sensitive types into your database. The procedures in this package execute with invoker’s rights. Typically, an application database administrator will be granted privileges for this package.
- DBMS_TSDP_PROTECT, which you use to create the TSDP policy. The procedures in this package execute with invoker’s rights. Typically, a security database administrator will be granted privileges for this package.
- DBMS_REDACT, if you plan to create Data Redaction policies. Typically, a security database administrator will be granted privileges for this package.
- DBMS_RLS, if you plan to incorporate Oracle Virtual Private Database functionality into your TSDP policies. Typically, a security database administrator will be granted privileges for this package.
For better separation of duty, these packages are designed so that either an application database administrator has control over one area of the TSDP policy creation (as in the case of the `DBMS_TSDP_MANAGE` package) or a security database administrator (for the `DBMS_TSDP_PROTECT`, `DBMS_REDACT`, and `DBMS_RLS` packages).
