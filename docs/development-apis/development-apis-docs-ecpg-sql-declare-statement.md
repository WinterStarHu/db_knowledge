# PostgreSQL: Documentation: 18: DECLARE STATEMENT

PostgreSQL: Documentation: 18: DECLARE STATEMENT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel DECLARE STATEMENT Prev Up
34.14. Embedded SQL Commands
Home Next DECLARE STATEMENT DECLARE STATEMENT — declare SQL statement identifier Synopsis EXEC SQL [ AT connection_name ] DECLARE statement_name STATEMENT Description DECLARE STATEMENT declares an SQL statement identifier. SQL statement identifier can be associated with the connection. When the identifier is used by dynamic SQL statements, the statements are executed using the associated connection. The namespace of the declaration is the precompile unit, and multiple declarations to the same SQL statement identifier are not allowed. Note that if the precompiler runs in Informix compatibility mode and some SQL statement is declared, "database" can not be used as a cursor name.
Parameters connection_name # A database connection name established by the CONNECT command.
AT clause can be omitted, but such statement has no meaning.
statement_name # The name of an SQL statement identifier, either as an SQL identifier or a host variable.
Notes This association is valid only if the declaration is physically placed on top of a dynamic statement.
Examples EXEC SQL CONNECT TO postgres AS con1;
EXEC SQL AT con1 DECLARE sql_stmt STATEMENT;
EXEC SQL DECLARE cursor_name CURSOR FOR sql_stmt;
EXEC SQL PREPARE sql_stmt FROM :dyn_string;
EXEC SQL OPEN cursor_name;
EXEC SQL FETCH cursor_name INTO :column1;
EXEC SQL CLOSE cursor_name;
Compatibility DECLARE STATEMENT is an extension of the SQL standard, but can be used in famous DBMSs.
See AlsoCONNECT, DECLARE, OPEN Prev Up Next DECLARE Home DESCRIBE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
