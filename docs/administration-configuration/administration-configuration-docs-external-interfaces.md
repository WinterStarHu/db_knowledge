# PostgreSQL: Documentation: 18: H.1. Client Interfaces

PostgreSQL: Documentation: 18: H.1. Client Interfaces Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
H.1. Client Interfaces Prev Up Appendix H. External Projects Home Next H.1. Client Interfaces # There are only two client interfaces included in the base PostgreSQL distribution:
libpq is included because it is the primary C language interface, and because many other client interfaces are built on top of it.
ECPG is included because it depends on the server-side SQL grammar, and is therefore sensitive to changes in PostgreSQL itself.
All other language interfaces are external projects and are distributed separately. A list of language interfaces is maintained on the PostgreSQL wiki. Note that some of these packages are not released under the same license as PostgreSQL. For more information on each language interface, including licensing terms, refer to its website and documentation.
https://wiki.postgresql.org/wiki/List_of_drivers Prev Up Next Appendix H. External Projects Home H.2. Administration Tools Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
