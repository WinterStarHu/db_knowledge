# PostgreSQL: Documentation: 18: SET CONNECTION

PostgreSQL: Documentation: 18: SET CONNECTION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SET CONNECTION Prev Up
34.14. Embedded SQL Commands
Home Next SET CONNECTION SET CONNECTION — select a database connection Synopsis SET CONNECTION [ TO | = ] connection_name Description SET CONNECTION sets the “current” database connection, which is the one that all commands use unless overridden.
Parameters connection_name # A database connection name established by the CONNECT command.
CURRENT # Set the connection to the current connection (thus, nothing happens).
Examples EXEC SQL SET CONNECTION TO con2;
EXEC SQL SET CONNECTION = con1;
Compatibility SET CONNECTION is specified in the SQL standard.
See AlsoCONNECT, DISCONNECT Prev Up Next SET AUTOCOMMIT Home SET DESCRIPTOR Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
