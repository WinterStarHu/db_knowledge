# PostgreSQL: Documentation: 18: CALL

PostgreSQL: Documentation: 18: CALL Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 CALL Prev Up SQL Commands Home Next CALL CALL — invoke a procedure Synopsis CALL name ( [ argument ] [, ...] ) Description CALL executes a procedure.
If the procedure has any output parameters, then a result row will be returned, containing the values of those parameters.
Parameters name The name (optionally schema-qualified) of the procedure.
argument An argument expression for the procedure call.
Arguments can include parameter names, using the syntax name => value. This works the same as in ordinary function calls; see Section 4.3 for details.
Arguments must be supplied for all procedure parameters that lack defaults, including OUT parameters. However, arguments matching OUT parameters are not evaluated, so it's customary to just write NULL for them. (Writing something else for an OUT parameter might cause compatibility problems with future PostgreSQL versions.) Notes The user must have EXECUTE privilege on the procedure in order to be allowed to invoke it.
To call a function (not a procedure), use SELECT instead.
If CALL is executed in a transaction block, then the called procedure cannot execute transaction control statements. Transaction control statements are only allowed if CALL is executed in its own transaction.
PL/pgSQL handles output parameters in CALL commands differently; see Section 41.6.3.
Examples CALL do_db_maintenance();
Compatibility CALL conforms to the SQL standard, except for the handling of output parameters. The standard says that users should write variables to receive the values of output parameters.
See AlsoCREATE PROCEDURE Prev Up Next BEGIN Home CHECKPOINT Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
