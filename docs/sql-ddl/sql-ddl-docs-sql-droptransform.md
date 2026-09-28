# PostgreSQL: Documentation: 18: DROP TRANSFORM

PostgreSQL: Documentation: 18: DROP TRANSFORM Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
DROP TRANSFORM Prev Up SQL Commands Home Next DROP TRANSFORM DROP TRANSFORM — remove a transform Synopsis DROP TRANSFORM [ IF EXISTS ] FOR type_name LANGUAGE lang_name [ CASCADE | RESTRICT ] Description DROP TRANSFORM removes a previously defined transform.
To be able to drop a transform, you must own the type and the language. These are the same privileges that are required to create a transform.
Parameters IF EXISTS Do not throw an error if the transform does not exist. A notice is issued in this case.
type_name The name of the data type of the transform.
lang_name The name of the language of the transform.
CASCADE Automatically drop objects that depend on the transform, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the transform if any objects depend on it. This is the default.
Examples To drop the transform for type hstore and language plpython3u:
DROP TRANSFORM FOR hstore LANGUAGE plpython3u;
Compatibility This form of DROP TRANSFORM is a PostgreSQL extension. See CREATE TRANSFORM for details.
See AlsoCREATE TRANSFORM Prev Up Next DROP TEXT SEARCH TEMPLATE Home DROP TRIGGER Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
