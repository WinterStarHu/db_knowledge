# PostgreSQL: Documentation: 18: 38.2. Writing Event Trigger Functions in C

PostgreSQL: Documentation: 18: 38.2. Writing Event Trigger Functions in C Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
38.2. Writing Event Trigger Functions in C
Prev Up Chapter 38. Event Triggers Home Next
38.2. Writing Event Trigger Functions in C #
This section describes the low-level details of the interface to an event trigger function. This information is only needed when writing event trigger functions in C. If you are using a higher-level language then these details are handled for you. In most cases you should consider using a procedural language before writing your event triggers in C. The documentation of each procedural language explains how to write an event trigger in that language.
Event trigger functions must use the “version 1” function manager interface.
When a function is called by the event trigger manager, it is not passed any normal arguments, but it is passed a “context” pointer pointing to a EventTriggerData structure. C functions can check whether they were called from the event trigger manager or not by executing the macro:
CALLED_AS_EVENT_TRIGGER(fcinfo) which expands to:
((fcinfo)->context != NULL && IsA((fcinfo)->context, EventTriggerData)) If this returns true, then it is safe to cast fcinfo->context to type EventTriggerData * and make use of the pointed-to EventTriggerData structure. The function must not alter the EventTriggerData structure or any of the data it points to.
struct EventTriggerData is defined in commands/event_trigger.h:
typedef struct EventTriggerData { NodeTag     type;
const char *event;      /* event name */ Node       *parsetree;  /* parse tree */ CommandTag  tag;        /* command tag */ } EventTriggerData;
where the members are defined as follows:
type Always T_EventTriggerData.
event Describes the event for which the function is called, one of "login", "ddl_command_start", "ddl_command_end", "sql_drop", "table_rewrite". See Section 38.1 for the meaning of these events.
parsetree A pointer to the parse tree of the command. Check the PostgreSQL source code for details. The parse tree structure is subject to change without notice.
tag The command tag associated with the event for which the event trigger is run, for example "CREATE FUNCTION".
An event trigger function must return a NULL pointer (not an SQL null value, that is, do not set isNull true).
Prev Up Next
38.1. Overview of Event Trigger Behavior
Home
38.3. A Complete Event Trigger Example
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
