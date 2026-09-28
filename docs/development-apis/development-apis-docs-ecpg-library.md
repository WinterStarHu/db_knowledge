# PostgreSQL: Documentation: 18: 34.11. Library Functions

PostgreSQL: Documentation: 18: 34.11. Library Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
34.11. Library Functions
Prev Up Chapter 34. ECPG — Embedded SQL in C Home Next
34.11. Library Functions #
The libecpg library primarily contains “hidden” functions that are used to implement the functionality expressed by the embedded SQL commands. But there are some functions that can usefully be called directly. Note that this makes your code unportable.
ECPGdebug(int on, FILE *stream) turns on debug logging if called with the first argument non-zero. Debug logging is done on stream. The log contains all SQL statements with all the input variables inserted, and the results from the PostgreSQL server. This can be very useful when searching for errors in your SQL statements.
Note On Windows, if the ecpg libraries and an application are compiled with different flags, this function call will crash the application because the internal representation of the FILE pointers differ. Specifically, multithreaded/single-threaded, release/debug, and static/dynamic flags should be the same for the library and all applications using that library.
ECPGget_PGconn(const char *connection_name) returns the library database connection handle identified by the given name. If connection_name is set to NULL, the current connection handle is returned. If no connection handle can be identified, the function returns NULL. The returned connection handle can be used to call any other functions from libpq, if necessary.
Note It is a bad idea to manipulate database connection handles made from ecpg directly with libpq routines.
ECPGtransactionStatus(const char *connection_name) returns the current transaction status of the given connection identified by connection_name. See Section 32.2 and libpq's PQtransactionStatus for details about the returned status codes.
ECPGstatus(int lineno, const char* connection_name) returns true if you are connected to a database and false if not. connection_name can be NULL if a single connection is being used.
Prev Up Next
34.10. Processing Embedded SQL Programs
Home
34.12. Large Objects
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
