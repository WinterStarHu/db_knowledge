# PostgreSQL: Documentation: 18: DISCONNECT

PostgreSQL: Documentation: 18: DISCONNECT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DISCONNECT Prev Up
34.14. Embedded SQL Commands
Home Next DISCONNECT DISCONNECT — terminate a database connection Synopsis DISCONNECT connection_name DISCONNECT [ CURRENT ] DISCONNECT ALL Description DISCONNECT closes a connection (or all connections) to the database.
Parameters connection_name # A database connection name established by the CONNECT command.
CURRENT # Close the “current” connection, which is either the most recently opened connection, or the connection set by the SET CONNECTION command. This is also the default if no argument is given to the DISCONNECT command.
ALL # Close all open connections.
Examples int main(void) { EXEC SQL CONNECT TO testdb AS con1 USER testuser;
EXEC SQL CONNECT TO testdb AS con2 USER testuser;
EXEC SQL CONNECT TO testdb AS con3 USER testuser;
EXEC SQL DISCONNECT CURRENT;  /* close con3          */ EXEC SQL DISCONNECT ALL;      /* close con2 and con1 */ return 0;
} Compatibility DISCONNECT is specified in the SQL standard.
See AlsoCONNECT, SET CONNECTION Prev Up Next DESCRIBE Home EXECUTE IMMEDIATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
