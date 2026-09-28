# PostgreSQL: Documentation: 18: Chapter 50. OAuth Validator Modules

PostgreSQL: Documentation: 18: Chapter 50. OAuth Validator Modules Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) Development Versions:
19 / devel Chapter 50. OAuth Validator Modules Prev Up Part V. Server Programming Home Next Chapter 50. OAuth Validator Modules Table of Contents
50.1. Safely Designing a Validator Module
50.1.1. Validator Responsibilities
50.1.2. General Coding Guidelines
50.1.3. Authorizing Users (Usermap Delegation)
50.2. Initialization Functions
50.3. OAuth Validator Callbacks
50.3.1. Startup Callback
50.3.2. Validate Callback
50.3.3. Shutdown Callback
PostgreSQL provides infrastructure for creating custom modules to perform server-side validation of OAuth bearer tokens. Because OAuth implementations vary so wildly, and bearer token validation is heavily dependent on the issuing party, the server cannot check the token itself; validator modules provide the integration layer between the server and the OAuth provider in use.
OAuth validator modules must at least consist of an initialization function (see Section 50.2) and the required callback for performing validation (see Section 50.3.2).
Warning Since a misbehaving validator might let unauthorized users into the database, correct implementation is crucial for server safety. See Section 50.1 for design considerations.
Prev Up Next
49.2. Archive Module Callbacks
Home
50.1. Safely Designing a Validator Module
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
