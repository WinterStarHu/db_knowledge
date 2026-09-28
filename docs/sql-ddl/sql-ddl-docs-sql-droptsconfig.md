# PostgreSQL: Documentation: 18: DROP TEXT SEARCH CONFIGURATION

PostgreSQL: Documentation: 18: DROP TEXT SEARCH CONFIGURATION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP TEXT SEARCH CONFIGURATION Prev Up SQL Commands Home Next DROP TEXT SEARCH CONFIGURATION DROP TEXT SEARCH CONFIGURATION — remove a text search configuration Synopsis DROP TEXT SEARCH CONFIGURATION [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP TEXT SEARCH CONFIGURATION drops an existing text search configuration. To execute this command you must be the owner of the configuration.
Parameters IF EXISTS Do not throw an error if the text search configuration does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an existing text search configuration.
CASCADE Automatically drop objects that depend on the text search configuration, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the text search configuration if any objects depend on it. This is the default.
Examples Remove the text search configuration my_english:
DROP TEXT SEARCH CONFIGURATION my_english;
This command will not succeed if there are any existing indexes that reference the configuration in to_tsvector calls. Add CASCADE to drop such indexes along with the text search configuration.
Compatibility There is no DROP TEXT SEARCH CONFIGURATION statement in the SQL standard.
See AlsoALTER TEXT SEARCH CONFIGURATION, CREATE TEXT SEARCH CONFIGURATION Prev Up Next DROP TABLESPACE Home DROP TEXT SEARCH DICTIONARY Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
