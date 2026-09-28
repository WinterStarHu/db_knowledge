# PostgreSQL: Documentation: 18: Chapter 38. Event Triggers

PostgreSQL: Documentation: 18: Chapter 38. Event Triggers Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 38. Event Triggers Prev Up Part V. Server Programming Home Next Chapter 38. Event Triggers Table of Contents
38.1. Overview of Event Trigger Behavior
38.1.1. login
38.1.2. ddl_command_start
38.1.3. ddl_command_end
38.1.4. sql_drop
38.1.5. table_rewrite
38.1.6. Event Triggers in Aborted Transactions
38.1.7. Creating Event Triggers
38.2. Writing Event Trigger Functions in C
38.3. A Complete Event Trigger Example
38.4. A Table Rewrite Event Trigger Example
38.5. A Database Login Event Trigger Example
To supplement the trigger mechanism discussed in Chapter 37, PostgreSQL also provides event triggers. Unlike regular triggers, which are attached to a single table and capture only DML events, event triggers are global to a particular database and are capable of capturing DDL events.
Like regular triggers, event triggers can be written in any procedural language that includes event trigger support, or in C, but not in plain SQL.
Prev Up Next
37.4. A Complete Trigger Example
Home
38.1. Overview of Event Trigger Behavior
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
