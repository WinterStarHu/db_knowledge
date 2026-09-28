# PostgreSQL: Documentation: 18: DESCRIBE

PostgreSQL: Documentation: 18: DESCRIBE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DESCRIBE Prev Up
34.14. Embedded SQL Commands
Home Next DESCRIBE DESCRIBE — obtain information about a prepared statement or result set Synopsis DESCRIBE [ OUTPUT ] prepared_name USING [ SQL ] DESCRIPTOR descriptor_name DESCRIBE [ OUTPUT ] prepared_name INTO [ SQL ] DESCRIPTOR descriptor_name DESCRIBE [ OUTPUT ] prepared_name INTO sqlda_name Description DESCRIBE retrieves metadata information about the result columns contained in a prepared statement, without actually fetching a row.
Parameters prepared_name # The name of a prepared statement. This can be an SQL identifier or a host variable.
descriptor_name # A descriptor name. It is case sensitive. It can be an SQL identifier or a host variable.
sqlda_name # The name of an SQLDA variable.
Examples EXEC SQL ALLOCATE DESCRIPTOR mydesc;
EXEC SQL PREPARE stmt1 FROM :sql_stmt;
EXEC SQL DESCRIBE stmt1 INTO SQL DESCRIPTOR mydesc;
EXEC SQL GET DESCRIPTOR mydesc VALUE 1 :charvar = NAME;
EXEC SQL DEALLOCATE DESCRIPTOR mydesc;
Compatibility DESCRIBE is specified in the SQL standard.
See AlsoALLOCATE DESCRIPTOR, GET DESCRIPTOR Prev Up Next DECLARE STATEMENT Home DISCONNECT Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
