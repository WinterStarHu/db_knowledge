# PostgreSQL: Documentation: 18: ALTER USER

PostgreSQL: Documentation: 18: ALTER USER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
ALTER USER Prev Up SQL Commands Home Next ALTER USER ALTER USER — change a database role Synopsis ALTER USER role_specification [ WITH ] option [ ... ] where option can be:
SUPERUSER | NOSUPERUSER
| CREATEDB | NOCREATEDB
| CREATEROLE | NOCREATEROLE
| INHERIT | NOINHERIT
| LOGIN | NOLOGIN
| REPLICATION | NOREPLICATION
| BYPASSRLS | NOBYPASSRLS
| CONNECTION LIMIT connlimit
| [ ENCRYPTED ] PASSWORD 'password' | PASSWORD NULL
| VALID UNTIL 'timestamp'
ALTER USER name RENAME TO new_name ALTER USER { role_specification | ALL } [ IN DATABASE database_name ] SET configuration_parameter { TO | = } { value | DEFAULT } ALTER USER { role_specification | ALL } [ IN DATABASE database_name ] SET configuration_parameter FROM CURRENT ALTER USER { role_specification | ALL } [ IN DATABASE database_name ] RESET configuration_parameter ALTER USER { role_specification | ALL } [ IN DATABASE database_name ] RESET ALL where role_specification can be:
role_name
| CURRENT_ROLE
| CURRENT_USER
| SESSION_USER
Description ALTER USER is now an alias for ALTER ROLE.
Compatibility The ALTER USER statement is a PostgreSQL extension. The SQL standard leaves the definition of users to the implementation.
See AlsoALTER ROLE Prev Up Next ALTER TYPE Home ALTER USER MAPPING Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
