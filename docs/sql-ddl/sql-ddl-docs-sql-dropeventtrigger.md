# PostgreSQL: Documentation: 18: DROP EVENT TRIGGER

PostgreSQL: Documentation: 18: DROP EVENT TRIGGER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DROP EVENT TRIGGER Prev Up SQL Commands Home Next DROP EVENT TRIGGER DROP EVENT TRIGGER — remove an event trigger Synopsis DROP EVENT TRIGGER [ IF EXISTS ] name [ CASCADE | RESTRICT ] Description DROP EVENT TRIGGER removes an existing event trigger. To execute this command, the current user must be the owner of the event trigger.
Parameters IF EXISTS Do not throw an error if the event trigger does not exist. A notice is issued in this case.
name The name of the event trigger to remove.
CASCADE Automatically drop objects that depend on the trigger, and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the trigger if any objects depend on it. This is the default.
Examples Destroy the trigger snitch:
DROP EVENT TRIGGER snitch;
Compatibility There is no DROP EVENT TRIGGER statement in the SQL standard.
See AlsoCREATE EVENT TRIGGER, ALTER EVENT TRIGGER Prev Up Next DROP DOMAIN Home DROP EXTENSION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
