# PostgreSQL: Documentation: 18: Chapter 59. Writing a Table Sampling Method

PostgreSQL: Documentation: 18: Chapter 59. Writing a Table Sampling Method Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
Chapter 59. Writing a Table Sampling Method Prev Up Part VII. Internals Home Next Chapter 59. Writing a Table Sampling Method Table of Contents
59.1. Sampling Method Support Functions
PostgreSQL's implementation of the TABLESAMPLE clause supports custom table sampling methods, in addition to the BERNOULLI and SYSTEM methods that are required by the SQL standard. The sampling method determines which rows of the table will be selected when the TABLESAMPLE clause is used.
At the SQL level, a table sampling method is represented by a single SQL function, typically implemented in C, having the signature method_name(internal) RETURNS tsm_handler The name of the function is the same method name appearing in the TABLESAMPLE clause. The internal argument is a dummy (always having value zero) that simply serves to prevent this function from being called directly from an SQL command. The result of the function must be a palloc'd struct of type TsmRoutine, which contains pointers to support functions for the sampling method. These support functions are plain C functions and are not visible or callable at the SQL level. The support functions are described in Section 59.1.
In addition to function pointers, the TsmRoutine struct must provide these additional fields:
List *parameterTypes This is an OID list containing the data type OIDs of the parameter(s) that will be accepted by the TABLESAMPLE clause when this sampling method is used. For example, for the built-in methods, this list contains a single item with value FLOAT4OID, which represents the sampling percentage. Custom sampling methods can have more or different parameters.
bool repeatable_across_queries If true, the sampling method can deliver identical samples across successive queries, if the same parameters and REPEATABLE seed value are supplied each time and the table contents have not changed. When this is false, the REPEATABLE clause is not accepted for use with the sampling method.
bool repeatable_across_scans If true, the sampling method can deliver identical samples across successive scans in the same query (assuming unchanging parameters, seed value, and snapshot). When this is false, the planner will not select plans that would require scanning the sampled table more than once, since that might result in inconsistent query output.
The TsmRoutine struct type is declared in src/include/access/tsmapi.h, which see for additional details.
The table sampling methods included in the standard distribution are good references when trying to write your own. Look into the src/backend/access/tablesample subdirectory of the source tree for the built-in sampling methods, and into the contrib subdirectory for add-on methods.
Prev Up Next
58.5. Row Locking in Foreign Data Wrappers
Home
59.1. Sampling Method Support Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
