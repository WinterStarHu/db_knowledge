# PostgreSQL: Documentation: 18: 42.9. Explicit Subtransactions in PL/Tcl

PostgreSQL: Documentation: 18: 42.9. Explicit Subtransactions in PL/Tcl Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10
42.9. Explicit Subtransactions in PL/Tcl
Prev Up Chapter 42. PL/Tcl — Tcl Procedural Language Home Next
42.9. Explicit Subtransactions in PL/Tcl #
Recovering from errors caused by database access as described in Section 42.8 can lead to an undesirable situation where some operations succeed before one of them fails, and after recovering from that error the data is left in an inconsistent state. PL/Tcl offers a solution to this problem in the form of explicit subtransactions.
Consider a function that implements a transfer between two accounts:
CREATE FUNCTION transfer_funds() RETURNS void AS $$ if [catch { spi_exec "UPDATE accounts SET balance = balance - 100 WHERE account_name = 'joe'" spi_exec "UPDATE accounts SET balance = balance + 100 WHERE account_name = 'mary'" } errormsg] { set result [format "error transferring funds: %s" $errormsg] } else { set result "funds transferred successfully" } spi_exec "INSERT INTO operations (result) VALUES ('[quote $result]')" $$ LANGUAGE pltcl;
If the second UPDATE statement results in an exception being raised, this function will log the failure, but the result of the first UPDATE will nevertheless be committed. In other words, the funds will be withdrawn from Joe's account, but will not be transferred to Mary's account. This happens because each spi_exec is a separate subtransaction, and only one of those subtransactions got rolled back.
To handle such cases, you can wrap multiple database operations in an explicit subtransaction, which will succeed or roll back as a whole. PL/Tcl provides a subtransaction command to manage this. We can rewrite our function as:
CREATE FUNCTION transfer_funds2() RETURNS void AS $$ if [catch { subtransaction { spi_exec "UPDATE accounts SET balance = balance - 100 WHERE account_name = 'joe'" spi_exec "UPDATE accounts SET balance = balance + 100 WHERE account_name = 'mary'" } } errormsg] { set result [format "error transferring funds: %s" $errormsg] } else { set result "funds transferred successfully" } spi_exec "INSERT INTO operations (result) VALUES ('[quote $result]')" $$ LANGUAGE pltcl;
Note that use of catch is still required for this purpose. Otherwise the error would propagate to the top level of the function, preventing the desired insertion into the operations table. The subtransaction command does not trap errors, it only assures that all database operations executed inside its scope will be rolled back together when an error is reported.
A rollback of an explicit subtransaction occurs on any error reported by the contained Tcl code, not only errors originating from database access. Thus a regular Tcl exception raised inside a subtransaction command will also cause the subtransaction to be rolled back. However, non-error exits out of the contained Tcl code (for instance, due to return) do not cause a rollback.
Prev Up Next
42.8. Error Handling in PL/Tcl
Home
42.10. Transaction Management
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
