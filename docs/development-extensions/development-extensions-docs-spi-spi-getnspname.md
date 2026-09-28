# PostgreSQL: Documentation: 18: SPI_getnspname

PostgreSQL: Documentation: 18: SPI_getnspname Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_getnspname Prev Up
45.2. Interface Support Functions
Home Next SPI_getnspname SPI_getnspname — return the namespace of the specified relation Synopsis char * SPI_getnspname(Relation rel) Description SPI_getnspname returns a copy of the name of the namespace that the specified Relation belongs to. This is equivalent to the relation's schema. You should pfree the return value of this function when you are finished with it.
Arguments Relation rel input relation Return Value The name of the specified relation's namespace.
Prev Up Next SPI_getrelname Home SPI_result_code_string Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
