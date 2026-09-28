# PostgreSQL: Documentation: 18: ALTER LARGE OBJECT

PostgreSQL: Documentation: 18: ALTER LARGE OBJECT Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER LARGE OBJECT Prev Up SQL Commands Home Next ALTER LARGE OBJECT ALTER LARGE OBJECT — change the definition of a large object Synopsis ALTER LARGE OBJECT large_object_oid OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } Description ALTER LARGE OBJECT changes the definition of a large object.
You must own the large object to use ALTER LARGE OBJECT. To alter the owner, you must also be able to SET ROLE to the new owning role. (However, a superuser can alter any large object anyway.) Currently, the only functionality is to assign a new owner, so both restrictions always apply.
Parameters large_object_oid OID of the large object to be altered new_owner The new owner of the large object Compatibility There is no ALTER LARGE OBJECT statement in the SQL standard.
See AlsoChapter 33 Prev Up Next ALTER LANGUAGE Home ALTER MATERIALIZED VIEW Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
