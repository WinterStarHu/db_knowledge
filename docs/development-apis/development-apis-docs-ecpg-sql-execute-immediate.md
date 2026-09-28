# PostgreSQL: Documentation: 18: EXECUTE IMMEDIATE

PostgreSQL: Documentation: 18: EXECUTE IMMEDIATE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
EXECUTE IMMEDIATE Prev Up
34.14. Embedded SQL Commands
Home Next EXECUTE IMMEDIATE EXECUTE IMMEDIATE — dynamically prepare and execute a statement Synopsis EXECUTE IMMEDIATE string Description EXECUTE IMMEDIATE immediately prepares and executes a dynamically specified SQL statement, without retrieving result rows.
Parameters string # A literal string or a host variable containing the SQL statement to be executed.
Notes In typical usage, the string is a host variable reference to a string containing a dynamically-constructed SQL statement. The case of a literal string is not very useful; you might as well just write the SQL statement directly, without the extra typing of EXECUTE IMMEDIATE.
If you do use a literal string, keep in mind that any double quotes you might wish to include in the SQL statement must be written as octal escapes (\042) not the usual C idiom \". This is because the string is inside an EXEC SQL section, so the ECPG lexer parses it according to SQL rules not C rules. Any embedded backslashes will later be handled according to C rules; but \" causes an immediate syntax error because it is seen as ending the literal.
Examples Here is an example that executes an INSERT statement using EXECUTE IMMEDIATE and a host variable named command:
sprintf(command, "INSERT INTO test (name, amount, letter) VALUES ('db: ''r1''', 1, 'f')");
EXEC SQL EXECUTE IMMEDIATE :command;
Compatibility EXECUTE IMMEDIATE is specified in the SQL standard.
Prev Up Next DISCONNECT Home GET DESCRIPTOR Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
