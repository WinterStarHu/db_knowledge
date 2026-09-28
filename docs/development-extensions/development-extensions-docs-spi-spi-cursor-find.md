# PostgreSQL: Documentation: 18: SPI_cursor_find

PostgreSQL: Documentation: 18: SPI_cursor_find Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SPI_cursor_find Prev Up
45.1. Interface Functions
Home Next SPI_cursor_find SPI_cursor_find — find an existing cursor by name Synopsis Portal SPI_cursor_find(const char * name) Description SPI_cursor_find finds an existing portal by name. This is primarily useful to resolve a cursor name returned as text by some other function.
Arguments const char * name name of the portal Return Value pointer to the portal with the specified name, or NULL if none was found Notes Beware that this function can return a Portal object that does not have cursor-like properties; for example it might not return tuples. If you simply pass the Portal pointer to other SPI functions, they can defend themselves against such cases, but caution is appropriate when directly inspecting the Portal.
Prev Up Next SPI_cursor_parse_open Home SPI_cursor_fetch Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
