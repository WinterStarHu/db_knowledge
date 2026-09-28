# PostgreSQL: Documentation: 18: 35.49. sql_implementation_info

PostgreSQL: Documentation: 18: 35.49. sql_implementation_info Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.49. sql_implementation_info
Prev Up Chapter 35. The Information Schema Home Next
35.49. sql_implementation_info #
The table sql_implementation_info contains information about various aspects that are left implementation-defined by the SQL standard. This information is primarily intended for use in the context of the ODBC interface; users of other interfaces will probably find this information to be of little use. For this reason, the individual implementation information items are not described here; you will find them in the description of the ODBC interface.
Table 35.47. sql_implementation_info Columns Column Type Description implementation_info_id character_data Identifier string of the implementation information item implementation_info_name character_data Descriptive name of the implementation information item integer_value cardinal_number Value of the implementation information item, or null if the value is contained in the column character_value character_value character_data Value of the implementation information item, or null if the value is contained in the column integer_value comments character_data Possibly a comment pertaining to the implementation information item Prev Up Next
35.48. sql_features
Home
35.50. sql_parts
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
