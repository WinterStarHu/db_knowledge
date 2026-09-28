# PostgreSQL: Documentation: 18: DROP MATERIALIZED VIEW

PostgreSQL: Documentation: 18: DROP MATERIALIZED VIEW Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP MATERIALIZED VIEW Prev Up SQL Commands Home Next DROP MATERIALIZED VIEW DROP MATERIALIZED VIEW — remove a materialized view Synopsis DROP MATERIALIZED VIEW [ IF EXISTS ] name [, ...] [ CASCADE | RESTRICT ] Description DROP MATERIALIZED VIEW drops an existing materialized view. To execute this command you must be the owner of the materialized view.
Parameters IF EXISTS Do not throw an error if the materialized view does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of the materialized view to remove.
CASCADE Automatically drop objects that depend on the materialized view (such as other materialized views, or regular views), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the materialized view if any objects depend on it. This is the default.
Examples This command will remove the materialized view called order_summary:
DROP MATERIALIZED VIEW order_summary;
Compatibility DROP MATERIALIZED VIEW is a PostgreSQL extension.
See AlsoCREATE MATERIALIZED VIEW, ALTER MATERIALIZED VIEW, REFRESH MATERIALIZED VIEW Prev Up Next DROP LANGUAGE Home DROP OPERATOR Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
