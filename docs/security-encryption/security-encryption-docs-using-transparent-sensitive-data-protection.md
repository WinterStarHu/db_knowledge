# Using Transparent Sensitive Data Protection

Transparent sensitive data protection enables you to find all table columns in a database that hold sensitive data.
- About Transparent Sensitive Data Protection Transparent sensitive data protection is a way to find and classify table columns that hold sensitive information.
- General Steps for Using Transparent Sensitive Data Protection To use TSDP with Oracle Data Redaction, you must follow a set of general steps.
- Use Cases for Transparent Sensitive Data Protection Policies Transparent sensitive data protection has several benefits.
- Privileges Required for Using Transparent Sensitive Data Protection To use transparent sensitive data protection, you must have the EXECUTE privilege for several PL/SQL packages.
- How a Multitenant Environment Affects Transparent Sensitive Data Protection In a multitenant environment, you can apply Transparent Sensitive Data Protection policies to the current PDB or current application PDB only.
- Creating Transparent Sensitive Data Protection Policies You must create a sensitive type, find the sensitive columns to be protected, and then import these columns from ADM into your database.
- Altering Transparent Sensitive Data Protection Policies The DBMS_TSDP_PROTECT.ALTER_POLICY procedure can alter a TSDP policy.
- Disabling Transparent Sensitive Data Protection Policies The DBMS_TSDP_PROTECT.DISABLE_PROTECTION_COLUMN procedure disables one or all TSDP policies.
- Dropping Transparent Sensitive Data Protection Policies You can drop an entire TSDP policy or a condition-enable-options combination from the policy.
- Using the Predefined REDACT_AUDIT Policy to Mask Bind Values The predefined REDACT_AUDIT policy masks bind values, which can appear in trace files when an event is set.
- Transparent Sensitive Data Protection Policies with Data Redaction Oracle Data Redaction features work with transparent sensitive data protection policies.
- Using Transparent Sensitive Data Protection Policies with Oracle VPD Policies You can combine protections from TSDP and Oracle Virtual Private Database into one policy.
- Using Transparent Sensitive Data Protection Policies with Unified Auditing The transparent sensitive data protection and unified auditing procedures can combine the protections of these two features.
- Using Transparent Sensitive Data Protection Policies with Fine-Grained Auditing The transparent sensitive data protection and fine-grained auditing procedures can combine the protections of these two features.
- Using Transparent Sensitive Data Protection Policies with TDE Column Encryption The TSDP procedures and Transparent Data Encryption column encryption statements can combine the protections of these two features.
- Transparent Sensitive Data Protection Data Dictionary Views Oracle Database provides data dictionary views that list information about transparent sensitive data protection policies.
