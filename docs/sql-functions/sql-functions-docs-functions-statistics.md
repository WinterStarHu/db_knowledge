# PostgreSQL: Documentation: 18: 9.31. Statistics Information Functions

PostgreSQL: Documentation: 18: 9.31. Statistics Information Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12
9.31. Statistics Information Functions
Prev Up Chapter 9. Functions and Operators Home Next
9.31. Statistics Information Functions #
9.31.1. Inspecting MCV Lists
PostgreSQL provides a function to inspect complex statistics defined using the CREATE STATISTICS command.
9.31.1. Inspecting MCV Lists #
pg_mcv_list_items ( pg_mcv_list ) → setof record pg_mcv_list_items returns a set of records describing all items stored in a multi-column MCV list. It returns the following columns:
Name Type Description index integer index of the item in the MCV list values text[] values stored in the MCV item nulls boolean[] flags identifying NULL values frequency double precision frequency of this MCV item base_frequency double precision base frequency of this MCV item The pg_mcv_list_items function can be used like this:
SELECT m.* FROM pg_statistic_ext join pg_statistic_ext_data on (oid = stxoid), pg_mcv_list_items(stxdmcv) m WHERE stxname = 'stts';
Values of the pg_mcv_list type can be obtained only from the pg_statistic_ext_data.stxdmcv column.
Prev Up Next
9.30. Event Trigger Functions
Home Chapter 10. Type Conversion Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
