# PostgreSQL: Documentation: 18: CREATE SERVER

PostgreSQL: Documentation: 18: CREATE SERVER Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
CREATE SERVER Prev Up SQL Commands Home Next CREATE SERVER CREATE SERVER — define a new foreign server Synopsis CREATE SERVER [ IF NOT EXISTS ] server_name [ TYPE 'server_type' ] [ VERSION 'server_version' ] FOREIGN DATA WRAPPER fdw_name [ OPTIONS ( option 'value' [, ... ] ) ] Description CREATE SERVER defines a new foreign server. The user who defines the server becomes its owner.
A foreign server typically encapsulates connection information that a foreign-data wrapper uses to access an external data resource. Additional user-specific connection information may be specified by means of user mappings.
The server name must be unique within the database.
Creating a server requires USAGE privilege on the foreign-data wrapper being used.
Parameters IF NOT EXISTS Do not throw an error if a server with the same name already exists. A notice is issued in this case. Note that there is no guarantee that the existing server is anything like the one that would have been created.
server_name The name of the foreign server to be created.
server_type Optional server type, potentially useful to foreign-data wrappers.
server_version Optional server version, potentially useful to foreign-data wrappers.
fdw_name The name of the foreign-data wrapper that manages the server.
OPTIONS ( option 'value' [, ... ] ) This clause specifies the options for the server. The options typically define the connection details of the server, but the actual names and values are dependent on the server's foreign-data wrapper.
Notes When using the dblink module, a foreign server's name can be used as an argument of the dblink_connect function to indicate the connection parameters. It is necessary to have the USAGE privilege on the foreign server to be able to use it in this way.
If the foreign server supports sort pushdown, it is necessary for it to have the same sort ordering as the local server.
Examples Create a server myserver that uses the foreign-data wrapper postgres_fdw:
CREATE SERVER myserver FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'foo', dbname 'foodb', port '5432');
See postgres_fdw for more details.
Compatibility CREATE SERVER conforms to ISO/IEC 9075-9 (SQL/MED).
See AlsoALTER SERVER, DROP SERVER, CREATE FOREIGN DATA WRAPPER, CREATE FOREIGN TABLE, CREATE USER MAPPING Prev Up Next CREATE SEQUENCE Home CREATE STATISTICS Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
