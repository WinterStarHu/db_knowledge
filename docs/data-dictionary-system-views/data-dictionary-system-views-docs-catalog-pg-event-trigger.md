# PostgreSQL: Documentation: 18: 52.21. pg_event_trigger

PostgreSQL: Documentation: 18: 52.21. pg_event_trigger Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
52.21. pg_event_trigger
Prev Up Chapter 52. System Catalogs Home Next
52.21. pg_event_trigger #
The catalog pg_event_trigger stores event triggers. See Chapter 38 for more information.
Table 52.21. pg_event_trigger Columns Column Type Description oid oid Row identifier evtname name Trigger name (must be unique) evtevent name Identifies the event for which this trigger fires evtowner oid (references pg_authid.oid) Owner of the event trigger evtfoid oid (references pg_proc.oid) The function to be called evtenabled char Controls in which session_replication_role modes the event trigger fires. O = trigger fires in “origin” and “local” modes, D = trigger is disabled, R = trigger fires in “replica” mode, A = trigger fires always.
evttags text[] Command tags for which this trigger will fire. If NULL, the firing of this trigger is not restricted on the basis of the command tag.
Prev Up Next
52.20. pg_enum
Home
52.22. pg_extension
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
