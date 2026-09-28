# PostgreSQL: Documentation: 18: 45.5. Visibility of Data Changes

PostgreSQL: Documentation: 18: 45.5. Visibility of Data Changes Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.3
/
7.2
/
7.1
45.5. Visibility of Data Changes
Prev Up Chapter 45. Server Programming Interface Home Next
45.5. Visibility of Data Changes #
The following rules govern the visibility of data changes in functions that use SPI (or any other C function):
During the execution of an SQL command, any data changes made by the command are invisible to the command itself. For example, in:
INSERT INTO a SELECT * FROM a;
the inserted rows are invisible to the SELECT part.
Changes made by a command C are visible to all commands that are started after C, no matter whether they are started inside C (during the execution of C) or after C is done.
Commands executed via SPI inside a function called by an SQL command (either an ordinary function or a trigger) follow one or the other of the above rules depending on the read/write flag passed to SPI. Commands executed in read-only mode follow the first rule: they cannot see changes of the calling command. Commands executed in read-write mode follow the second rule: they can see all changes made so far.
All standard procedural languages set the SPI read-write mode depending on the volatility attribute of the function. Commands of STABLE and IMMUTABLE functions are done in read-only mode, while commands of VOLATILE functions are done in read-write mode. While authors of C functions are able to violate this convention, it's unlikely to be a good idea to do so.
The next section contains an example that illustrates the application of these rules.
Prev Up Next SPI_start_transaction Home
45.6. Examples
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
