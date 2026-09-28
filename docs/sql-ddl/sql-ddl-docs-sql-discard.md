# PostgreSQL: Documentation: 18: DISCARD

PostgreSQL: Documentation: 18: DISCARD Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DISCARD Prev Up SQL Commands Home Next DISCARD DISCARD — discard session state Synopsis DISCARD { ALL | PLANS | SEQUENCES | TEMPORARY | TEMP } Description DISCARD releases internal resources associated with a database session. This command is useful for partially or fully resetting the session's state. There are several subcommands to release different types of resources; the DISCARD ALL variant subsumes all the others, and also resets additional state.
Parameters PLANS Releases all cached query plans, forcing re-planning to occur the next time the associated prepared statement is used.
SEQUENCES Discards all cached sequence-related state, including currval()/lastval() information and any preallocated sequence values that have not yet been returned by nextval(). (See CREATE SEQUENCE for a description of preallocated sequence values.) TEMPORARY or TEMP Drops all temporary tables created in the current session.
ALL Releases all temporary resources associated with the current session and resets the session to its initial state. Currently, this has the same effect as executing the following sequence of statements:
CLOSE ALL;
SET SESSION AUTHORIZATION DEFAULT;
RESET ALL;
DEALLOCATE ALL;
UNLISTEN *;
SELECT pg_advisory_unlock_all();
DISCARD PLANS;
DISCARD TEMP;
DISCARD SEQUENCES;
Notes DISCARD ALL cannot be executed inside a transaction block.
Compatibility DISCARD is a PostgreSQL extension.
Prev Up Next DELETE Home DO Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
