# PostgreSQL: Documentation: 18: 51.2. How Connections Are Established

PostgreSQL: Documentation: 18: 51.2. How Connections Are Established Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
7.2
/
7.1
51.2. How Connections Are Established
Prev Up Chapter 51. Overview of PostgreSQL Internals Home Next
51.2. How Connections Are Established #
PostgreSQL implements a “process per user” client/server model. In this model, every client process connects to exactly one backend process. As we do not know ahead of time how many connections will be made, we have to use a “supervisor process” that spawns a new backend process every time a connection is requested. This supervisor process is called postmaster and listens at a specified TCP/IP port for incoming connections. Whenever it detects a request for a connection, it spawns a new backend process. Those backend processes communicate with each other and with other processes of the instance using semaphores and shared memory to ensure data integrity throughout concurrent data access.
The client process can be any program that understands the PostgreSQL protocol described in Chapter 54. Many clients are based on the C-language library libpq, but several independent implementations of the protocol exist, such as the Java JDBC driver.
Once a connection is established, the client process can send a query to the backend process it's connected to. The query is transmitted using plain text, i.e., there is no parsing done in the client. The backend process parses the query, creates an execution plan, executes the plan, and returns the retrieved rows to the client by transmitting them over the established connection.
Prev Up Next
51.1. The Path of a Query
Home
51.3. The Parser Stage
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
