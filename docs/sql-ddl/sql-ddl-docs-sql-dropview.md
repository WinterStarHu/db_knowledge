# PostgreSQL: Documentation: 18: DROP VIEW

PostgreSQL: Documentation: 18: DROP VIEW Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.3
/
7.2
/
7.1
DROP VIEW Prev Up SQL Commands Home Next DROP VIEW DROP VIEW — remove a view Synopsis DROP VIEW [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP VIEW drops an existing view. To execute this command you must be the owner of the view.
Parameters IF EXISTS Do not throw an error if the view does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of the view to remove.
CASCADE Automatically drop objects that depend on the view (such as other views), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the view if any objects depend on it. This is the default.
Examples This command will remove the view called kinds:
DROP VIEW kinds;
Compatibility This command conforms to the SQL standard, except that the standard only allows one view to be dropped per command, and apart from the IF EXISTS option, which is a PostgreSQL extension.
See AlsoALTER VIEW, CREATE VIEW Prev Up Next DROP USER MAPPING Home END Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
