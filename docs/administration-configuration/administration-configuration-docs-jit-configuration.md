# PostgreSQL: Documentation: 18: 30.3. Configuration

PostgreSQL: Documentation: 18: 30.3. Configuration Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
30.3. Configuration
Prev Up Chapter 30. Just-in-Time Compilation (JIT) Home Next
30.3. Configuration #
The configuration variable jit determines whether JIT compilation is enabled or disabled. If it is enabled, the configuration variables jit_above_cost, jit_inline_above_cost, and jit_optimize_above_cost determine whether JIT compilation is performed for a query, and how much effort is spent doing so.
jit_provider determines which JIT implementation is used. It is rarely required to be changed. See Section 30.4.2.
For development and debugging purposes a few additional configuration parameters exist, as described in Section 19.17.
Prev Up Next
30.2. When to JIT?
Home
30.4. Extensibility
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
