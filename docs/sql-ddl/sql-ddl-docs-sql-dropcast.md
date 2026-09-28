# PostgreSQL: Documentation: 18: DROP CAST

PostgreSQL: Documentation: 18: DROP CAST Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP CAST Prev Up SQL Commands Home Next DROP CAST DROP CAST — remove a cast Synopsis DROP CAST [ IF EXISTS ] (source_type AS target_type) [ CASCADE | RESTRICT ] Description DROP CAST removes a previously defined cast.
To be able to drop a cast, you must own the source or the target data type. These are the same privileges that are required to create a cast.
Parameters IF EXISTS Do not throw an error if the cast does not exist. A notice is issued in this case.
source_type The name of the source data type of the cast.
target_type The name of the target data type of the cast.
CASCADERESTRICT These key words do not have any effect, since there are no dependencies on casts.
Examples To drop the cast from type text to type int:
DROP CAST (text AS int);
Compatibility The DROP CAST command conforms to the SQL standard.
See AlsoCREATE CAST Prev Up Next DROP AGGREGATE Home DROP COLLATION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
