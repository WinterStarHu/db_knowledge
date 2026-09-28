# PostgreSQL: Documentation: 18: CREATE ACCESS METHOD

PostgreSQL: Documentation: 18: CREATE ACCESS METHOD Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
CREATE ACCESS METHOD Prev Up SQL Commands Home Next CREATE ACCESS METHOD CREATE ACCESS METHOD — define a new access method Synopsis CREATE ACCESS METHOD name TYPE access_method_type HANDLER handler_function Description CREATE ACCESS METHOD creates a new access method.
The access method name must be unique within the database.
Only superusers can define new access methods.
Parameters name The name of the access method to be created.
access_method_type This clause specifies the type of access method to define. Only TABLE and INDEX are supported at present.
handler_function handler_function is the name (possibly schema-qualified) of a previously registered function that represents the access method. The handler function must be declared to take a single argument of type internal, and its return type depends on the type of access method; for TABLE access methods, it must be table_am_handler and for INDEX access methods, it must be index_am_handler. The C-level API that the handler function must implement varies depending on the type of access method. The table access method API is described in Chapter 62 and the index access method API is described in Chapter 63.
Examples Create an index access method heptree with handler function heptree_handler:
CREATE ACCESS METHOD heptree TYPE INDEX HANDLER heptree_handler;
Compatibility CREATE ACCESS METHOD is a PostgreSQL extension.
See AlsoDROP ACCESS METHOD, CREATE OPERATOR CLASS, CREATE OPERATOR FAMILY Prev Up Next COPY Home CREATE AGGREGATE Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
