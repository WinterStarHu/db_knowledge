# PostgreSQL: Documentation: 18: 52.28. pg_init_privs

PostgreSQL: Documentation: 18: 52.28. pg_init_privs Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
52.28. pg_init_privs
Prev Up Chapter 52. System Catalogs Home Next
52.28. pg_init_privs #
The catalog pg_init_privs records information about the initial privileges of objects in the system. There is one entry for each object in the database which has a non-default (non-NULL) initial set of privileges.
Objects can have initial privileges either by having those privileges set when the system is initialized (by initdb) or when the object is created during a CREATE EXTENSION and the extension script sets initial privileges using the GRANT system. Note that the system will automatically handle recording of the privileges during the extension script and that extension authors need only use the GRANT and REVOKE statements in their script to have the privileges recorded. The privtype column indicates if the initial privilege was set by initdb or during a CREATE EXTENSION command.
Objects which have initial privileges set by initdb will have entries where privtype is 'i', while objects which have initial privileges set by CREATE EXTENSION will have entries where privtype is 'e'.
Table 52.28. pg_init_privs Columns Column Type Description objoid oid (references any OID column) The OID of the specific object classoid oid (references pg_class.oid) The OID of the system catalog the object is in objsubid int4 For a table column, this is the column number (the objoid and classoid refer to the table itself). For all other object types, this column is zero.
privtype char A code defining the type of initial privilege of this object; see text initprivs aclitem[] The initial access privileges; see Section 5.8 for details Prev Up Next
52.27. pg_inherits
Home
52.29. pg_language
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
