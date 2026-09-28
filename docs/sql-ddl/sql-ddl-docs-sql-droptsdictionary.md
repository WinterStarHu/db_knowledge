# PostgreSQL: Documentation: 18: DROP TEXT SEARCH DICTIONARY

PostgreSQL: Documentation: 18: DROP TEXT SEARCH DICTIONARY Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP TEXT SEARCH DICTIONARY Prev Up SQL Commands Home Next DROP TEXT SEARCH DICTIONARY DROP TEXT SEARCH DICTIONARY — remove a text search dictionary Synopsis DROP TEXT SEARCH DICTIONARY [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP TEXT SEARCH DICTIONARY drops an existing text search dictionary. To execute this command you must be the owner of the dictionary.
Parameters IF EXISTS Do not throw an error if the text search dictionary does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an existing text search dictionary.
CASCADE Automatically drop objects that depend on the text search dictionary, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the text search dictionary if any objects depend on it. This is the default.
Examples Remove the text search dictionary english:
DROP TEXT SEARCH DICTIONARY english;
This command will not succeed if there are any existing text search configurations that use the dictionary. Add CASCADE to drop such configurations along with the dictionary.
Compatibility There is no DROP TEXT SEARCH DICTIONARY statement in the SQL standard.
See AlsoALTER TEXT SEARCH DICTIONARY, CREATE TEXT SEARCH DICTIONARY Prev Up Next DROP TEXT SEARCH CONFIGURATION Home DROP TEXT SEARCH PARSER Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
