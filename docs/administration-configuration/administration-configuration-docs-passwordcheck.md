# PostgreSQL: Documentation: 18: F.24. passwordcheck — verify password strength

PostgreSQL: Documentation: 18: F.24. passwordcheck — verify password strength Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
F.24. passwordcheck — verify password strength Prev Up Appendix F. Additional Supplied Modules and Extensions Home Next F.24. passwordcheck — verify password strength # F.24.1. Configuration Parameters The passwordcheck module checks users' passwords whenever they are set with CREATE ROLE or ALTER ROLE. If a password is considered too weak, it will be rejected and the command will terminate with an error.
To enable this module, add '$libdir/passwordcheck' to shared_preload_libraries in postgresql.conf, then restart the server.
You can adapt this module to your needs by changing the source code. For example, you can use CrackLib to check passwords — this only requires uncommenting two lines in the Makefile and rebuilding the module. (We cannot include CrackLib by default for license reasons.) Without CrackLib, the module enforces a few simple rules for password strength, which you can modify or extend as you see fit.
Caution To prevent unencrypted passwords from being sent across the network, written to the server log or otherwise stolen by a database administrator, PostgreSQL allows the user to supply pre-encrypted passwords. Many client programs make use of this functionality and encrypt the password before sending it to the server.
This limits the usefulness of the passwordcheck module, because in that case it can only try to guess the password. For this reason, passwordcheck is not recommended if your security requirements are high. It is more secure to use an external authentication method such as GSSAPI (see Chapter 20) than to rely on passwords within the database.
Alternatively, you could modify passwordcheck to reject pre-encrypted passwords, but forcing users to set their passwords in clear text carries its own security risks.
F.24.1. Configuration Parameters # passwordcheck.min_password_length (integer) The minimum acceptable password length in bytes. The default is 8. Only superusers can change this setting.
Note This parameter has no effect if a user supplies a pre-encrypted password.
In ordinary usage, this parameter is set in postgresql.conf, but superusers can alter it on-the-fly within their own sessions. Typical usage might be:
# postgresql.conf
passwordcheck.min_password_length = 12 Prev Up Next F.23. pageinspect — low-level inspection of database pages Home F.25. pg_buffercache — inspect PostgreSQL buffer cache state Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
