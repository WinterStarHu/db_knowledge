# PostgreSQL: Documentation: 18: 44.5. Trigger Functions

PostgreSQL: Documentation: 18: 44.5. Trigger Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
44.5. Trigger Functions
Prev Up Chapter 44. PL/Python — Python Procedural Language Home Next
44.5. Trigger Functions #
When a function is used as a trigger, the dictionary TD contains trigger-related values:
TD["event"] contains the event as a string: INSERT, UPDATE, DELETE, or TRUNCATE.
TD["when"] contains one of BEFORE, AFTER, or INSTEAD OF.
TD["level"] contains ROW or STATEMENT.
TD["new"]TD["old"] For a row-level trigger, one or both of these fields contain the respective trigger rows, depending on the trigger event.
TD["name"] contains the trigger name.
TD["table_name"] contains the name of the table on which the trigger occurred.
TD["table_schema"] contains the schema of the table on which the trigger occurred.
TD["relid"] contains the OID of the table on which the trigger occurred.
TD["args"] If the CREATE TRIGGER command included arguments, they are available in TD["args"][0] to TD["args"][n-1].
If TD["when"] is BEFORE or INSTEAD OF and TD["level"] is ROW, you can return None or "OK" from the Python function to indicate the row is unmodified, "SKIP" to abort the event, or if TD["event"] is INSERT or UPDATE you can return "MODIFY" to indicate you've modified the new row. Otherwise the return value is ignored.
Prev Up Next
44.4. Anonymous Code Blocks
Home
44.6. Database Access
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
