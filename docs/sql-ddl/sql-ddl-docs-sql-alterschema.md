# PostgreSQL: Documentation: 18: ALTER SCHEMA

PostgreSQL: Documentation: 18: ALTER SCHEMA Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER SCHEMA Prev Up SQL Commands Home Next ALTER SCHEMA ALTER SCHEMA — change the definition of a schema Synopsis ALTER SCHEMA name RENAME TO new_name ALTER SCHEMA name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } Description ALTER SCHEMA changes the definition of a schema.
You must own the schema to use ALTER SCHEMA. To rename a schema you must also have the CREATE privilege for the database. To alter the owner, you must be able to SET ROLE to the new owning role, and that role must have the CREATE privilege for the database. (Note that superusers have all these privileges automatically.) Parameters name The name of an existing schema.
new_name The new name of the schema. The new name cannot begin with pg_, as such names are reserved for system schemas.
new_owner The new owner of the schema.
Compatibility There is no ALTER SCHEMA statement in the SQL standard.
See AlsoCREATE SCHEMA, DROP SCHEMA Prev Up Next ALTER RULE Home ALTER SEQUENCE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
