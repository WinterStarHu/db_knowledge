# PostgreSQL: Documentation: 18: DROP STATISTICS

PostgreSQL: Documentation: 18: DROP STATISTICS Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 DROP STATISTICS Prev Up SQL Commands Home Next DROP STATISTICS DROP STATISTICS — remove extended statistics Synopsis DROP STATISTICS [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP STATISTICS removes statistics object(s) from the database. Only the statistics object's owner, the schema owner, or a superuser can drop a statistics object.
Parameters IF EXISTS Do not throw an error if the statistics object does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of the statistics object to drop.
CASCADERESTRICT These key words do not have any effect, since there are no dependencies on statistics.
Examples To destroy two statistics objects in different schemas, without failing if they don't exist:
DROP STATISTICS IF EXISTS accounting.users_uid_creation, public.grants_user_role;
Compatibility There is no DROP STATISTICS command in the SQL standard.
See AlsoALTER STATISTICS, CREATE STATISTICS Prev Up Next DROP SERVER Home DROP SUBSCRIPTION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
