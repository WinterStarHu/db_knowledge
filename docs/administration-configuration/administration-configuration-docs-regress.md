# PostgreSQL: Documentation: 18: Chapter 31. Regression Tests

PostgreSQL: Documentation: 18: Chapter 31. Regression Tests Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 31. Regression Tests Prev Up Part III. Server Administration Home Next Chapter 31. Regression Tests Table of Contents
31.1. Running the Tests
31.1.1. Running the Tests Against a Temporary Installation
31.1.2. Running the Tests Against an Existing Installation
31.1.3. Additional Test Suites
31.1.4. Locale and Encoding
31.1.5. Custom Server Settings
31.1.6. Extra Tests
31.2. Test Evaluation
31.2.1. Error Message Differences
31.2.2. Locale Differences
31.2.3. Date and Time Differences
31.2.4. Floating-Point Differences
31.2.5. Row Ordering Differences
31.2.6. Insufficient Stack Depth
31.2.7. The “random” Test
31.2.8. Configuration Parameters
31.3. Variant Comparison Files
31.4. TAP Tests
31.4.1. Environment Variables
31.5. Test Coverage Examination
31.5.1. Coverage with Autoconf and Make
31.5.2. Coverage with Meson
The regression tests are a comprehensive set of tests for the SQL implementation in PostgreSQL. They test standard SQL operations as well as the extended capabilities of PostgreSQL.
Prev Up Next
30.4. Extensibility
Home
31.1. Running the Tests
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
