# PostgreSQL: Documentation: 18: 35.50. sql_parts

PostgreSQL: Documentation: 18: 35.50. sql_parts Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.50. sql_parts
Prev Up Chapter 35. The Information Schema Home Next
35.50. sql_parts #
The table sql_parts contains information about which of the several parts of the SQL standard are supported by PostgreSQL.
Table 35.48. sql_parts Columns Column Type Description feature_id character_data An identifier string containing the number of the part feature_name character_data Descriptive name of the part is_supported yes_or_no YES if the part is fully supported by the current version of PostgreSQL, NO if not is_verified_by character_data Always null, since the PostgreSQL development group does not perform formal testing of feature conformance comments character_data Possibly a comment about the supported status of the part Prev Up Next
35.49. sql_implementation_info
Home
35.51. sql_sizing
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
