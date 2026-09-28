# PostgreSQL: Documentation: 18: DROP OPERATOR FAMILY

PostgreSQL: Documentation: 18: DROP OPERATOR FAMILY Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP OPERATOR FAMILY Prev Up SQL Commands Home Next DROP OPERATOR FAMILY DROP OPERATOR FAMILY — remove an operator family Synopsis DROP OPERATOR FAMILY [ IF EXISTS ] name USING index_method [ CASCADE | RESTRICT ] Description DROP OPERATOR FAMILY drops an existing operator family. To execute this command you must be the owner of the operator family.
DROP OPERATOR FAMILY includes dropping any operator classes contained in the family, but it does not drop any of the operators or functions referenced by the family. If there are any indexes depending on operator classes within the family, you will need to specify CASCADE for the drop to complete.
Parameters IF EXISTS Do not throw an error if the operator family does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an existing operator family.
index_method The name of the index access method the operator family is for.
CASCADE Automatically drop objects that depend on the operator family, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the operator family if any objects depend on it. This is the default.
Examples Remove the B-tree operator family float_ops:
DROP OPERATOR FAMILY float_ops USING btree;
This command will not succeed if there are any existing indexes that use operator classes within the family. Add CASCADE to drop such indexes along with the operator family.
Compatibility There is no DROP OPERATOR FAMILY statement in the SQL standard.
See AlsoALTER OPERATOR FAMILY, CREATE OPERATOR FAMILY, ALTER OPERATOR CLASS, CREATE OPERATOR CLASS, DROP OPERATOR CLASS Prev Up Next DROP OPERATOR CLASS Home DROP OWNED Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
