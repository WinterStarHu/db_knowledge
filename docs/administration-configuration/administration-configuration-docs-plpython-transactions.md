# PostgreSQL: Documentation: 18: 44.8. Transaction Management

PostgreSQL: Documentation: 18: 44.8. Transaction Management Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
44.8. Transaction Management
Prev Up Chapter 44. PL/Python — Python Procedural Language Home Next
44.8. Transaction Management #
In a procedure called from the top level or an anonymous code block (DO command) called from the top level it is possible to control transactions. To commit the current transaction, call plpy.commit(). To roll back the current transaction, call plpy.rollback(). (Note that it is not possible to run the SQL commands COMMIT or ROLLBACK via plpy.execute or similar. It has to be done using these functions.) After a transaction is ended, a new transaction is automatically started, so there is no separate function for that.
Here is an example:
CREATE PROCEDURE transaction_test1() LANGUAGE plpython3u AS $$ for i in range(0, 10):
plpy.execute("INSERT INTO test1 (a) VALUES (%d)" % i) if i % 2 == 0:
plpy.commit() else:
plpy.rollback() $$;
CALL transaction_test1();
Transactions cannot be ended when an explicit subtransaction is active.
Prev Up Next
44.7. Explicit Subtransactions
Home
44.9. Utility Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
