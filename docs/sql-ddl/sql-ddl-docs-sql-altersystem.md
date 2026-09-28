# PostgreSQL: Documentation: 18: ALTER SYSTEM

PostgreSQL: Documentation: 18: ALTER SYSTEM Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
ALTER SYSTEM Prev Up SQL Commands Home Next ALTER SYSTEM ALTER SYSTEM — change a server configuration parameter Synopsis ALTER SYSTEM SET configuration_parameter { TO | = } { value [, ...] | DEFAULT } ALTER SYSTEM RESET configuration_parameter ALTER SYSTEM RESET ALL Description ALTER SYSTEM is used for changing server configuration parameters across the entire database cluster. It can be more convenient than the traditional method of manually editing the postgresql.conf file. ALTER SYSTEM writes the given parameter setting to the postgresql.auto.conf file, which is read in addition to postgresql.conf. Setting a parameter to DEFAULT, or using the RESET variant, removes that configuration entry from the postgresql.auto.conf file. Use RESET ALL to remove all such configuration entries.
Values set with ALTER SYSTEM will be effective after the next server configuration reload, or after the next server restart in the case of parameters that can only be changed at server start. A server configuration reload can be commanded by calling the SQL function pg_reload_conf(), running pg_ctl reload, or sending a SIGHUP signal to the main server process.
Only superusers and users granted ALTER SYSTEM privilege on a parameter can change it using ALTER SYSTEM. Also, since this command acts directly on the file system and cannot be rolled back, it is not allowed inside a transaction block or function.
Parameters configuration_parameter Name of a settable configuration parameter. Available parameters are documented in Chapter 19.
value New value of the parameter. Values can be specified as string constants, identifiers, numbers, or comma-separated lists of these, as appropriate for the particular parameter. Values that are neither numbers nor valid identifiers must be quoted. DEFAULT can be written to specify removing the parameter and its value from postgresql.auto.conf.
For some list-accepting parameters, quoted values will produce double-quoted output to preserve whitespace and commas; for others, double-quotes must be used inside single-quoted strings to get this effect.
Notes This command can't be used to set data_directory, allow_alter_system, nor parameters that are not allowed in postgresql.conf (e.g., preset options).
See Section 19.1 for other ways to set the parameters.
ALTER SYSTEM can be disabled by setting allow_alter_system to off, but this is not a security mechanism (as explained in detail in the documentation for this parameter).
Examples Set the wal_level:
ALTER SYSTEM SET wal_level = replica;
Undo that, restoring whatever setting was effective in postgresql.conf:
ALTER SYSTEM RESET wal_level;
Compatibility The ALTER SYSTEM statement is a PostgreSQL extension.
See AlsoSET, SHOW Prev Up Next ALTER SUBSCRIPTION Home ALTER TABLE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
