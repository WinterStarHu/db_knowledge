# PostgreSQL: Documentation: 18: ALTER EVENT TRIGGER

PostgreSQL: Documentation: 18: ALTER EVENT TRIGGER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER EVENT TRIGGER Prev Up SQL Commands Home Next ALTER EVENT TRIGGER ALTER EVENT TRIGGER — change the definition of an event trigger Synopsis ALTER EVENT TRIGGER name DISABLE ALTER EVENT TRIGGER name ENABLE [ REPLICA | ALWAYS ] ALTER EVENT TRIGGER name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER EVENT TRIGGER name RENAME TO new_name Description ALTER EVENT TRIGGER changes properties of an existing event trigger.
You must be superuser to alter an event trigger.
Parameters name The name of an existing trigger to alter.
new_owner The user name of the new owner of the event trigger.
new_name The new name of the event trigger.
DISABLE/ENABLE [ REPLICA | ALWAYS ] These forms configure the firing of event triggers. A disabled trigger is still known to the system, but is not executed when its triggering event occurs. See also session_replication_role.
Compatibility There is no ALTER EVENT TRIGGER statement in the SQL standard.
See AlsoCREATE EVENT TRIGGER, DROP EVENT TRIGGER Prev Up Next ALTER DOMAIN Home ALTER EXTENSION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
