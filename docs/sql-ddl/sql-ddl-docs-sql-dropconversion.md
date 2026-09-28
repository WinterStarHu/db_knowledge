# PostgreSQL: Documentation: 18: DROP CONVERSION

PostgreSQL: Documentation: 18: DROP CONVERSION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP CONVERSION Prev Up SQL Commands Home Next DROP CONVERSION DROP CONVERSION — remove a conversion Synopsis DROP CONVERSION [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP CONVERSION removes a previously defined conversion. To be able to drop a conversion, you must own the conversion.
Parameters IF EXISTS Do not throw an error if the conversion does not exist. A notice is issued in this case.
name The name of the conversion. The conversion name can be schema-qualified.
CASCADERESTRICT These key words do not have any effect, since there are no dependencies on conversions.
Examples To drop the conversion named myname:
DROP CONVERSION myname;
Compatibility There is no DROP CONVERSION statement in the SQL standard, but a DROP TRANSLATION statement that goes along with the CREATE TRANSLATION statement that is similar to the CREATE CONVERSION statement in PostgreSQL.
See AlsoALTER CONVERSION, CREATE CONVERSION Prev Up Next DROP COLLATION Home DROP DATABASE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
