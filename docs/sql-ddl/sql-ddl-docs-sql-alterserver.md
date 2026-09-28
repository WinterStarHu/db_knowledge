# PostgreSQL: Documentation: 18: ALTER SERVER

PostgreSQL: Documentation: 18: ALTER SERVER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER SERVER Prev Up SQL Commands Home Next ALTER SERVER ALTER SERVER — change the definition of a foreign server Synopsis ALTER SERVER name [ VERSION 'new_version' ] [ OPTIONS ( [ ADD | SET | DROP ] option ['value'] [, ... ] ) ] ALTER SERVER name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER SERVER name RENAME TO new_name Description ALTER SERVER changes the definition of a foreign server. The first form changes the server version string or the generic options of the server (at least one clause is required). The second form changes the owner of the server.
To alter the server you must be the owner of the server. Additionally to alter the owner, you must be able to SET ROLE to the new owning role, and you must have USAGE privilege on the server's foreign-data wrapper. (Note that superusers satisfy all these criteria automatically.) Parameters name The name of an existing server.
new_version New server version.
OPTIONS ( [ ADD | SET | DROP ] option ['value'] [, ... ] ) Change options for the server. ADD, SET, and DROP specify the action to be performed. ADD is assumed if no operation is explicitly specified. Option names must be unique; names and values are also validated using the server's foreign-data wrapper library.
new_owner The user name of the new owner of the foreign server.
new_name The new name for the foreign server.
Examples Alter server foo, add connection options:
ALTER SERVER foo OPTIONS (host 'foo', dbname 'foodb');
Alter server foo, change version, change host option:
ALTER SERVER foo VERSION '8.4' OPTIONS (SET host 'baz');
Compatibility ALTER SERVER conforms to ISO/IEC 9075-9 (SQL/MED). The OWNER TO and RENAME forms are PostgreSQL extensions.
See AlsoCREATE SERVER, DROP SERVER Prev Up Next ALTER SEQUENCE Home ALTER STATISTICS Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
