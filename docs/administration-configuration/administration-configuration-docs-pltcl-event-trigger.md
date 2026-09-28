# PostgreSQL: Documentation: 18: 42.7. Event Trigger Functions in PL/Tcl

PostgreSQL: Documentation: 18: 42.7. Event Trigger Functions in PL/Tcl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
42.7. Event Trigger Functions in PL/Tcl
Prev Up Chapter 42. PL/Tcl — Tcl Procedural Language Home Next
42.7. Event Trigger Functions in PL/Tcl #
Event trigger functions can be written in PL/Tcl. PostgreSQL requires that a function that is to be called as an event trigger must be declared as a function with no arguments and a return type of event_trigger.
The information from the trigger manager is passed to the function body in the following variables:
$TG_event The name of the event the trigger is fired for.
$TG_tag The command tag for which the trigger is fired.
The return value of the trigger function is ignored.
Here's a little example event trigger function that simply raises a NOTICE message each time a supported command is executed:
CREATE OR REPLACE FUNCTION tclsnitch() RETURNS event_trigger AS $$ elog NOTICE "tclsnitch: $TG_event $TG_tag" $$ LANGUAGE pltcl;
CREATE EVENT TRIGGER tcl_a_snitch ON ddl_command_start EXECUTE FUNCTION tclsnitch();
Prev Up Next
42.6. Trigger Functions in PL/Tcl
Home
42.8. Error Handling in PL/Tcl
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
