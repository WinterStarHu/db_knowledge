# PostgreSQL: Documentation: 18: Chapter 34. ECPG — Embedded SQL in C

PostgreSQL: Documentation: 18: Chapter 34. ECPG — Embedded SQL in C Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 34. ECPG — Embedded SQL in C Prev Up Part IV. Client Interfaces Home Next Chapter 34. ECPG — Embedded SQL in C Table of Contents
34.1. The Concept
34.2. Managing Database Connections
34.2.1. Connecting to the Database Server
34.2.2. Choosing a Connection
34.2.3. Closing a Connection
34.3. Running SQL Commands
34.3.1. Executing SQL Statements
34.3.2. Using Cursors
34.3.3. Managing Transactions
34.3.4. Prepared Statements
34.4. Using Host Variables
34.4.1. Overview
34.4.2. Declare Sections
34.4.3. Retrieving Query Results
34.4.4. Type Mapping
34.4.5. Handling Nonprimitive SQL Data Types
34.4.6. Indicators
34.5. Dynamic SQL
34.5.1. Executing Statements without a Result Set
34.5.2. Executing a Statement with Input Parameters
34.5.3. Executing a Statement with a Result Set
34.6. pgtypes Library
34.6.1. Character Strings
34.6.2. The numeric Type
34.6.3. The date Type
34.6.4. The timestamp Type
34.6.5. The interval Type
34.6.6. The decimal Type
34.6.7. errno Values of pgtypeslib
34.6.8. Special Constants of pgtypeslib
34.7. Using Descriptor Areas
34.7.1. Named SQL Descriptor Areas
34.7.2. SQLDA Descriptor Areas
34.8. Error Handling
34.8.1. Setting Callbacks
34.8.2. sqlca
34.8.3. SQLSTATE vs. SQLCODE
34.9. Preprocessor Directives
34.9.1. Including Files
34.9.2. The define and undef Directives
34.9.3. ifdef, ifndef, elif, else, and endif Directives
34.10. Processing Embedded SQL Programs
34.11. Library Functions
34.12. Large Objects
34.13. C++ Applications
34.13.1. Scope for Host Variables
34.13.2. C++ Application Development with External C Module
34.14. Embedded SQL Commands
ALLOCATE DESCRIPTOR — allocate an SQL descriptor area CONNECT — establish a database connection DEALLOCATE DESCRIPTOR — deallocate an SQL descriptor area DECLARE — define a cursor DECLARE STATEMENT — declare SQL statement identifier DESCRIBE — obtain information about a prepared statement or result set DISCONNECT — terminate a database connection EXECUTE IMMEDIATE — dynamically prepare and execute a statement GET DESCRIPTOR — get information from an SQL descriptor area OPEN — open a dynamic cursor PREPARE — prepare a statement for execution SET AUTOCOMMIT — set the autocommit behavior of the current session SET CONNECTION — select a database connection SET DESCRIPTOR — set information in an SQL descriptor area TYPE — define a new data type VAR — define a variable WHENEVER — specify the action to be taken when an SQL statement causes a specific class condition to be raised
34.15. Informix Compatibility Mode
34.15.1. Additional Types
34.15.2. Additional/Missing Embedded SQL Statements
34.15.3. Informix-compatible SQLDA Descriptor Areas
34.15.4. Additional Functions
34.15.5. Additional Constants
34.16. Oracle Compatibility Mode
34.17. Internals
This chapter describes the embedded SQL package for PostgreSQL. It was written by Linus Tolke () and Michael Meskes (). Originally it was written to work with C. It also works with C++, but it does not recognize all C++ constructs yet.
This documentation is quite incomplete. But since this interface is standardized, additional information can be found in many resources about SQL.
Prev Up Next
33.5. Example Program
Home
34.1. The Concept
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
