# PostgreSQL: Documentation: 18: dblink_connect_u

PostgreSQL: Documentation: 18: dblink_connect_u Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_connect_u Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_connect_u dblink_connect_u — opens a persistent connection to a remote database, insecurely Synopsis dblink_connect_u(text connstr) returns text dblink_connect_u(text connname, text connstr) returns text Description dblink_connect_u() is identical to dblink_connect(), except that it will allow non-superusers to connect using any authentication method.
If the remote server selects an authentication method that does not involve a password, then impersonation and subsequent escalation of privileges can occur, because the session will appear to have originated from the user as which the local PostgreSQL server runs. Also, even if the remote server does demand a password, it is possible for the password to be supplied from the server environment, such as a ~/.pgpass file belonging to the server's user. This opens not only a risk of impersonation, but the possibility of exposing a password to an untrustworthy remote server. Therefore, dblink_connect_u() is initially installed with all privileges revoked from PUBLIC, making it un-callable except by superusers. In some situations it may be appropriate to grant EXECUTE permission for dblink_connect_u() to specific users who are considered trustworthy, but this should be done with care. It is also recommended that any ~/.pgpass file belonging to the server's user not contain any records specifying a wildcard host name.
For further details see dblink_connect().
Prev Up Next dblink_connect Home dblink_disconnect Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
