# PostgreSQL: Documentation: 18: 35.2. Data Types

PostgreSQL: Documentation: 18: 35.2. Data Types Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.2. Data Types
Prev Up Chapter 35. The Information Schema Home Next
35.2. Data Types #
The columns of the information schema views use special data types that are defined in the information schema. These are defined as simple domains over ordinary built-in types. You should not use these types for work outside the information schema, but your applications must be prepared for them if they select from the information schema.
These types are:
cardinal_number A nonnegative integer.
character_data A character string (without specific maximum length).
sql_identifier A character string. This type is used for SQL identifiers, the type character_data is used for any other kind of text data.
time_stamp A domain over the type timestamp with time zone yes_or_no A character string domain that contains either YES or NO. This is used to represent Boolean (true/false) data in the information schema. (The information schema was invented before the type boolean was added to the SQL standard, so this convention is necessary to keep the information schema backward compatible.) Every column in the information schema has one of these five types.
Prev Up Next
35.1. The Schema
Home
35.3. information_schema_catalog_name
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
