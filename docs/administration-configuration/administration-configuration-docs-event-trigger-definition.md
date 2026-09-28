# PostgreSQL: Documentation: 18: 38.1. Overview of Event Trigger Behavior

PostgreSQL: Documentation: 18: 38.1. Overview of Event Trigger Behavior Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
38.1. Overview of Event Trigger Behavior
Prev Up Chapter 38. Event Triggers Home Next
38.1. Overview of Event Trigger Behavior #
38.1.1. login
38.1.2. ddl_command_start
38.1.3. ddl_command_end
38.1.4. sql_drop
38.1.5. table_rewrite
38.1.6. Event Triggers in Aborted Transactions
38.1.7. Creating Event Triggers
An event trigger fires whenever the event with which it is associated occurs in the database in which it is defined. Currently, the supported events are login, ddl_command_start, ddl_command_end, table_rewrite and sql_drop. Support for additional events may be added in future releases.
38.1.1. login #
The login event occurs when an authenticated user logs into the system. Any bug in a trigger procedure for this event may prevent successful login to the system. Such bugs may be worked around by setting event_triggers to false either in a connection string or configuration file. Alternatively, you can restart the system in single-user mode (as event triggers are disabled in this mode). See the postgres reference page for details about using single-user mode. The login event will also fire on standby servers. To prevent servers from becoming inaccessible, such triggers must avoid writing anything to the database when running on a standby. Also, it's recommended to avoid long-running queries in login event triggers. Note that, for instance, canceling a connection in psql will not cancel the in-progress login trigger.
For an example on how to use the login event trigger, see Section 38.5.
38.1.2. ddl_command_start #
The ddl_command_start event occurs just before the execution of a DDL command. DDL commands in this context are:
CREATE ALTER DROP COMMENT GRANT IMPORT FOREIGN SCHEMA REINDEX REFRESH MATERIALIZED VIEW REVOKE SECURITY LABEL ddl_command_start also occurs just before the execution of a SELECT INTO command, since this is equivalent to CREATE TABLE AS.
As an exception, this event does not occur for DDL commands targeting shared objects:
databases roles (role definitions and role memberships) tablespaces parameter privileges ALTER SYSTEM This event also does not occur for commands targeting event triggers themselves.
No check whether the affected object exists or doesn't exist is performed before the event trigger fires.
38.1.3. ddl_command_end #
The ddl_command_end event occurs just after the execution of the same set of commands as ddl_command_start. To obtain more details on the DDL operations that took place, use the set-returning function pg_event_trigger_ddl_commands() from the ddl_command_end event trigger code (see Section 9.30). Note that the trigger fires after the actions have taken place (but before the transaction commits), and thus the system catalogs can be read as already changed.
38.1.4. sql_drop #
The sql_drop event occurs just before the ddl_command_end event trigger for any operation that drops database objects. Note that besides the obvious DROP commands, some ALTER commands can also trigger an sql_drop event.
To list the objects that have been dropped, use the set-returning function pg_event_trigger_dropped_objects() from the sql_drop event trigger code (see Section 9.30). Note that the trigger is executed after the objects have been deleted from the system catalogs, so it's not possible to look them up anymore.
38.1.5. table_rewrite #
The table_rewrite event occurs just before a table is rewritten by some actions of the commands ALTER TABLE and ALTER TYPE. While other control statements are available to rewrite a table, like CLUSTER and VACUUM, the table_rewrite event is not triggered by them. To find the OID of the table that was rewritten, use the function pg_event_trigger_table_rewrite_oid(), to discover the reason(s) for the rewrite, use the function pg_event_trigger_table_rewrite_reason() (see Section 9.30).
38.1.6. Event Triggers in Aborted Transactions #
Event triggers (like other functions) cannot be executed in an aborted transaction. Thus, if a DDL command fails with an error, any associated ddl_command_end triggers will not be executed. Conversely, if a ddl_command_start trigger fails with an error, no further event triggers will fire, and no attempt will be made to execute the command itself. Similarly, if a ddl_command_end trigger fails with an error, the effects of the DDL statement will be rolled back, just as they would be in any other case where the containing transaction aborts.
38.1.7. Creating Event Triggers #
Event triggers are created using the command CREATE EVENT TRIGGER. In order to create an event trigger, you must first create a function with the special return type event_trigger. This function need not (and may not) return a value; the return type serves merely as a signal that the function is to be invoked as an event trigger.
If more than one event trigger is defined for a particular event, they will fire in alphabetical order by trigger name.
A trigger definition can also specify a WHEN condition so that, for example, a ddl_command_start trigger can be fired only for particular commands which the user wishes to intercept. A common use of such triggers is to restrict the range of DDL operations which users may perform.
Prev Up Next Chapter 38. Event Triggers Home
38.2. Writing Event Trigger Functions in C
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
