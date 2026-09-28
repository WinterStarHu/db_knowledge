# Upgraded Applications That Depend on Packages That Use External Network Services

Upgraded applications may have `ORA-24247` network access errors.
If you have upgraded from a release before Oracle Database 11*g* Release 1 (11.1), and your applications depend on PL/SQL network utility packages (`UTL_TCP`, `UTL_SMTP`, `UTL_MAIL`, `UTL_HTTP`, `UTL_INADDR`, and `DBMS_LDAP`) or the `HttpUriType` type, then the `ORA-24247` error may occur when you try to run the application.
The error message is as follows:
```
ORA-24247: network access denied by access control list (ACL)
```
Use the procedures in this chapter to reconfigure the network access for the application.
## Related Topics
**- Oracle Database Upgrade Guide for compatibility issues for applications that depend on the PL/SQL network utility packages
