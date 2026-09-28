# PostgreSQL: Documentation: 18: 35.20. data_type_privileges

PostgreSQL: Documentation: 18: 35.20. data_type_privileges Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
35.20. data_type_privileges
Prev Up Chapter 35. The Information Schema Home Next
35.20. data_type_privileges #
The view data_type_privileges identifies all data type descriptors that the current user has access to, by way of being the owner of the described object or having some privilege for it. A data type descriptor is generated whenever a data type is used in the definition of a table column, a domain, or a function (as parameter or return type) and stores some information about how the data type is used in that instance (for example, the declared maximum length, if applicable). Each data type descriptor is assigned an arbitrary identifier that is unique among the data type descriptor identifiers assigned for one object (table, domain, function). This view is probably not useful for applications, but it is used to define some other views in the information schema.
Table 35.18. data_type_privileges Columns Column Type Description object_catalog sql_identifier Name of the database that contains the described object (always the current database) object_schema sql_identifier Name of the schema that contains the described object object_name sql_identifier Name of the described object object_type character_data The type of the described object: one of TABLE (the data type descriptor pertains to a column of that table), DOMAIN (the data type descriptors pertains to that domain), ROUTINE (the data type descriptor pertains to a parameter or the return data type of that function).
dtd_identifier sql_identifier The identifier of the data type descriptor, which is unique among the data type descriptors for that same object.
Prev Up Next
35.19. constraint_table_usage
Home
35.21. domain_constraints
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
