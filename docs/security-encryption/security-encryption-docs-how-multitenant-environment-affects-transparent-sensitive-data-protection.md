# How a Multitenant Environment Affects Transparent Sensitive Data Protection

In a multitenant environment, you can apply Transparent Sensitive Data Protection policies to the current PDB or current application PDB only.
If you are using Enterprise Manager Cloud Control Application Data Model, then you can find sensitive columns that belong to both local and common application objects (that is, common objects that are visible and accessible in the current PDB) inside the PDB. This enables you to use a TSDP policy to protect both local objects to the PDB and common objects that are accessible from the PDB.
In an application root:
````  - When you create scripts for application install, upgrade, patch, or uninstall operations, you can include SQL statements within the ALTER PLUGGABLE DATABASE app_name BEGIN INSTALL and ALTER PLUGGABLE DATABASE app_name END INSTALL blocks to perform various operations. If you include TSDP statements within these blocks, then the TSDP statements will fail. You can, however, include TSDP statements outside these blocks in the script.
  - You can perform TSDP operations in both application common objects and application root local objects.
  - A TSDP policy that is defined in the application root container behaves as if it is a local policy to the application root. That is, the policy is effective only in the application root container.
In an application PDB:
- The security policies that protect an application PDB apply to TSDP operations that are performed on local application objects.
- The security policies that protect an application PDB apply to TSDP operations that are performed on application common objects that are accessed from the PDB. However, access to the application common object outside the application PDB is not governed by the security policy that protects the application PDB.
You can find a listing of TSDP policies and the security features that are associated with them by querying the DBA_TSDP_POLICY_FEATURE data dictionary views. To find all PDBs, query the DBA_PDBS view.
