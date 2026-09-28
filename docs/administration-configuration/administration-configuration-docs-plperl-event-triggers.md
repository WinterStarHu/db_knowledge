# PostgreSQL: Documentation: 18: 43.7. PL/Perl Event Triggers

PostgreSQL: Documentation: 18: 43.7. PL/Perl Event Triggers Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
43.7. PL/Perl Event Triggers
Prev Up Chapter 43. PL/Perl — Perl Procedural Language Home Next
43.7. PL/Perl Event Triggers #
PL/Perl can be used to write event trigger functions. In an event trigger function, the hash reference $_TD contains information about the current trigger event. $_TD is a global variable, which gets a separate local value for each invocation of the trigger. The fields of the $_TD hash reference are:
$_TD->{event} The name of the event the trigger is fired for.
$_TD->{tag} The command tag for which the trigger is fired.
The return value of the trigger function is ignored.
Here is an example of an event trigger function, illustrating some of the above:
CREATE OR REPLACE FUNCTION perlsnitch() RETURNS event_trigger AS $$ elog(NOTICE, "perlsnitch: " . $_TD->{event} . " " . $_TD->{tag} . " ");
$$ LANGUAGE plperl;
CREATE EVENT TRIGGER perl_a_snitch ON ddl_command_start EXECUTE FUNCTION perlsnitch();
Prev Up Next
43.6. PL/Perl Triggers
Home
43.8. PL/Perl Under the Hood
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
