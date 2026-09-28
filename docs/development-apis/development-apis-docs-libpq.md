# PostgreSQL: Documentation: 18: Chapter 32. libpq — C Library

PostgreSQL: Documentation: 18: Chapter 32. libpq — C Library Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 32. libpq — C Library Prev Up Part IV. Client Interfaces Home Next Chapter 32. libpq — C Library Table of Contents
32.1. Database Connection Control Functions
32.1.1. Connection Strings
32.1.2. Parameter Key Words
32.2. Connection Status Functions
32.3. Command Execution Functions
32.3.1. Main Functions
32.3.2. Retrieving Query Result Information
32.3.3. Retrieving Other Result Information
32.3.4. Escaping Strings for Inclusion in SQL Commands
32.4. Asynchronous Command Processing
32.5. Pipeline Mode
32.5.1. Using Pipeline Mode
32.5.2. Functions Associated with Pipeline Mode
32.5.3. When to Use Pipeline Mode
32.6. Retrieving Query Results in Chunks
32.7. Canceling Queries in Progress
32.7.1. Functions for Sending Cancel Requests
32.7.2. Obsolete Functions for Sending Cancel Requests
32.8. The Fast-Path Interface
32.9. Asynchronous Notification
32.10. Functions Associated with the COPY Command
32.10.1. Functions for Sending COPY Data
32.10.2. Functions for Receiving COPY Data
32.10.3. Obsolete Functions for COPY
32.11. Control Functions
32.12. Miscellaneous Functions
32.13. Notice Processing
32.14. Event System
32.14.1. Event Types
32.14.2. Event Callback Procedure
32.14.3. Event Support Functions
32.14.4. Event Example
32.15. Environment Variables
32.16. The Password File
32.17. The Connection Service File
32.18. LDAP Lookup of Connection Parameters
32.19. SSL Support
32.19.1. Client Verification of Server Certificates
32.19.2. Client Certificates
32.19.3. Protection Provided in Different Modes
32.19.4. SSL Client File Usage
32.19.5. SSL Library Initialization
32.20. OAuth Support
32.20.1. Authdata Hooks
32.20.2. Debugging and Developer Settings
32.21. Behavior in Threaded Programs
32.22. Building libpq Programs
32.23. Example Programs
libpq is the C application programmer's interface to PostgreSQL. libpq is a set of library functions that allow client programs to pass queries to the PostgreSQL backend server and to receive the results of these queries.
libpq is also the underlying engine for several other PostgreSQL application interfaces, including those written for C++, Perl, Python, Tcl and ECPG. So some aspects of libpq's behavior will be important to you if you use one of those packages. In particular, Section 32.15, Section 32.16 and Section 32.19 describe behavior that is visible to the user of any application that uses libpq.
Some short programs are included at the end of this chapter (Section 32.23) to show how to write programs that use libpq. There are also several complete examples of libpq applications in the directory src/test/examples in the source code distribution.
Client programs that use libpq must include the header file libpq-fe.h and must link with the libpq library.
Prev Up Next Part IV. Client Interfaces Home
32.1. Database Connection Control Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
