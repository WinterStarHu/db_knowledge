# PostgreSQL: Documentation: 18: 58.1. Foreign Data Wrapper Functions

PostgreSQL: Documentation: 18: 58.1. Foreign Data Wrapper Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
58.1. Foreign Data Wrapper Functions
Prev Up Chapter 58. Writing a Foreign Data Wrapper Home Next
58.1. Foreign Data Wrapper Functions #
The FDW author needs to implement a handler function, and optionally a validator function. Both functions must be written in a compiled language such as C, using the version-1 interface. For details on C language calling conventions and dynamic loading, see Section 36.10.
The handler function simply returns a struct of function pointers to callback functions that will be called by the planner, executor, and various maintenance commands. Most of the effort in writing an FDW is in implementing these callback functions. The handler function must be registered with PostgreSQL as taking no arguments and returning the special pseudo-type fdw_handler. The callback functions are plain C functions and are not visible or callable at the SQL level. The callback functions are described in Section 58.2.
The validator function is responsible for validating options given in CREATE and ALTER commands for its foreign data wrapper, as well as foreign servers, user mappings, and foreign tables using the wrapper. The validator function must be registered as taking two arguments, a text array containing the options to be validated, and an OID representing the type of object the options are associated with. The latter corresponds to the OID of the system catalog the object would be stored in, one of:
AttributeRelationId ForeignDataWrapperRelationId ForeignServerRelationId ForeignTableRelationId UserMappingRelationId If no validator function is supplied, options are not checked at object creation time or object alteration time.
Prev Up Next Chapter 58. Writing a Foreign Data Wrapper Home
58.2. Foreign Data Wrapper Callback Routines
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
