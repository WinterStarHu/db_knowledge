# PostgreSQL: Documentation: 18: 35.47. sequences

PostgreSQL: Documentation: 18: 35.47. sequences Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.47. sequences
Prev Up Chapter 35. The Information Schema Home Next
35.47. sequences #
The view sequences contains all sequences defined in the current database. Only those sequences are shown that the current user has access to (by way of being the owner or having some privilege).
Table 35.45. sequences Columns Column Type Description sequence_catalog sql_identifier Name of the database that contains the sequence (always the current database) sequence_schema sql_identifier Name of the schema that contains the sequence sequence_name sql_identifier Name of the sequence data_type character_data The data type of the sequence.
numeric_precision cardinal_number This column contains the (declared or implicit) precision of the sequence data type (see above). The precision indicates the number of significant digits. It can be expressed in decimal (base 10) or binary (base 2) terms, as specified in the column numeric_precision_radix.
numeric_precision_radix cardinal_number This column indicates in which base the values in the columns numeric_precision and numeric_scale are expressed. The value is either 2 or 10.
numeric_scale cardinal_number This column contains the (declared or implicit) scale of the sequence data type (see above). The scale indicates the number of significant digits to the right of the decimal point. It can be expressed in decimal (base 10) or binary (base 2) terms, as specified in the column numeric_precision_radix.
start_value character_data The start value of the sequence minimum_value character_data The minimum value of the sequence maximum_value character_data The maximum value of the sequence increment character_data The increment of the sequence cycle_option yes_or_no YES if the sequence cycles, else NO Note that in accordance with the SQL standard, the start, minimum, maximum, and increment values are returned as character strings.
Prev Up Next
35.46. schemata
Home
35.48. sql_features
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
