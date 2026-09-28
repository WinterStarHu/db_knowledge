# PostgreSQL: Documentation: 18: 53.16. pg_prepared_statements

PostgreSQL: Documentation: 18: 53.16. pg_prepared_statements Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.16. pg_prepared_statements
Prev Up Chapter 53. System Views Home Next
53.16. pg_prepared_statements #
The pg_prepared_statements view displays all the prepared statements that are available in the current session. See PREPARE for more information about prepared statements.
pg_prepared_statements contains one row for each prepared statement. Rows are added to the view when a new prepared statement is created and removed when a prepared statement is released (for example, via the DEALLOCATE command).
Table 53.16. pg_prepared_statements Columns Column Type Description name text The identifier of the prepared statement statement text The query string submitted by the client to create this prepared statement. For prepared statements created via SQL, this is the PREPARE statement submitted by the client. For prepared statements created via the frontend/backend protocol, this is the text of the prepared statement itself.
prepare_time timestamptz The time at which the prepared statement was created parameter_types regtype[] The expected parameter types for the prepared statement in the form of an array of regtype. The OID corresponding to an element of this array can be obtained by casting the regtype value to oid.
result_types regtype[] The types of the columns returned by the prepared statement in the form of an array of regtype. The OID corresponding to an element of this array can be obtained by casting the regtype value to oid. If the prepared statement does not provide a result (e.g., a DML statement), then this field will be null.
from_sql bool true if the prepared statement was created via the PREPARE SQL command; false if the statement was prepared via the frontend/backend protocol generic_plans int8 Number of times generic plan was chosen custom_plans int8 Number of times custom plan was chosen The pg_prepared_statements view is read-only.
Prev Up Next
53.15. pg_policies
Home
53.17. pg_prepared_xacts
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
