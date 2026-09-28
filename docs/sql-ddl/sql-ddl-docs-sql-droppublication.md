# PostgreSQL: Documentation: 18: DROP PUBLICATION

PostgreSQL: Documentation: 18: DROP PUBLICATION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 DROP PUBLICATION Prev Up SQL Commands Home Next DROP PUBLICATION DROP PUBLICATION — remove a publication Synopsis DROP PUBLICATION [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP PUBLICATION removes an existing publication from the database.
A publication can only be dropped by its owner or a superuser.
Parameters IF EXISTS Do not throw an error if the publication does not exist. A notice is issued in this case.
name The name of an existing publication.
CASCADERESTRICT These key words do not have any effect, since there are no dependencies on publications.
Examples Drop a publication:
DROP PUBLICATION mypublication;
Compatibility DROP PUBLICATION is a PostgreSQL extension.
See AlsoCREATE PUBLICATION, ALTER PUBLICATION Prev Up Next DROP PROCEDURE Home DROP ROLE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
