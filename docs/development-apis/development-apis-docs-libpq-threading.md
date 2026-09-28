# PostgreSQL: Documentation: 18: 32.21. Behavior in Threaded Programs

PostgreSQL: Documentation: 18: 32.21. Behavior in Threaded Programs Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
32.21. Behavior in Threaded Programs
Prev Up Chapter 32. libpq — C Library Home Next
32.21. Behavior in Threaded Programs #
As of version 17, libpq is always reentrant and thread-safe. However, one restriction is that no two threads attempt to manipulate the same PGconn object at the same time. In particular, you cannot issue concurrent commands from different threads through the same connection object. (If you need to run concurrent commands, use multiple connections.) PGresult objects are normally read-only after creation, and so can be passed around freely between threads. However, if you use any of the PGresult-modifying functions described in Section 32.12 or Section 32.14, it's up to you to avoid concurrent operations on the same PGresult, too.
In earlier versions, libpq could be compiled with or without thread support, depending on compiler options. This function allows the querying of libpq's thread-safe status:
PQisthreadsafe # Returns the thread safety status of the libpq library.
int PQisthreadsafe();
Returns 1 if the libpq is thread-safe and 0 if it is not. Always returns 1 on version 17 and above.
The deprecated functions PQrequestCancel and PQoidStatus are not thread-safe and should not be used in multithread programs. PQrequestCancel can be replaced by PQcancelBlocking. PQoidStatus can be replaced by PQoidValue.
If you are using Kerberos inside your application (in addition to inside libpq), you will need to do locking around Kerberos calls because Kerberos functions are not thread-safe. See function PQregisterThreadLock in the libpq source code for a way to do cooperative locking between libpq and your application.
Similarly, if you are using Curl inside your application, and you do not already initialize libcurl globally before starting new threads, you will need to cooperatively lock (again via PQregisterThreadLock) around any code that may initialize libcurl. This restriction is lifted for more recent versions of Curl that are built to support thread-safe initialization; those builds can be identified by the advertisement of a threadsafe feature in their version metadata.
Prev Up Next
32.20. OAuth Support
Home
32.22. Building libpq Programs
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
