# PostgreSQL: Documentation: 18: ALTER OPERATOR CLASS

PostgreSQL: Documentation: 18: ALTER OPERATOR CLASS Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER OPERATOR CLASS Prev Up SQL Commands Home Next ALTER OPERATOR CLASS ALTER OPERATOR CLASS — change the definition of an operator class Synopsis ALTER OPERATOR CLASS name USING index_method RENAME TO new_name ALTER OPERATOR CLASS name USING index_method OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER OPERATOR CLASS name USING index_method SET SCHEMA new_schema Description ALTER OPERATOR CLASS changes the definition of an operator class.
You must own the operator class to use ALTER OPERATOR CLASS. To alter the owner, you must be able to SET ROLE to the new owning role, and that role must have CREATE privilege on the operator class's schema. (These restrictions enforce that altering the owner doesn't do anything you couldn't do by dropping and recreating the operator class. However, a superuser can alter ownership of any operator class anyway.) Parameters name The name (optionally schema-qualified) of an existing operator class.
index_method The name of the index method this operator class is for.
new_name The new name of the operator class.
new_owner The new owner of the operator class.
new_schema The new schema for the operator class.
Compatibility There is no ALTER OPERATOR CLASS statement in the SQL standard.
See AlsoCREATE OPERATOR CLASS, DROP OPERATOR CLASS, ALTER OPERATOR FAMILY Prev Up Next ALTER OPERATOR Home ALTER OPERATOR FAMILY Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
