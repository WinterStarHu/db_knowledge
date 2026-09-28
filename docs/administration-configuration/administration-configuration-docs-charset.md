# PostgreSQL: Documentation: 18: Chapter 23. Localization

PostgreSQL: Documentation: 18: Chapter 23. Localization Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 23. Localization Prev Up Part III. Server Administration Home Next Chapter 23. Localization Table of Contents
23.1. Locale Support
23.1.1. Overview
23.1.2. Behavior
23.1.3. Selecting Locales
23.1.4. Locale Providers
23.1.5. ICU Locales
23.1.6. Problems
23.2. Collation Support
23.2.1. Concepts
23.2.2. Managing Collations
23.2.3. ICU Custom Collations
23.3. Character Set Support
23.3.1. Supported Character Sets
23.3.2. Setting the Character Set
23.3.3. Automatic Character Set Conversion Between Server and Client
23.3.4. Available Character Set Conversions
23.3.5. Further Reading
This chapter describes the available localization features from the point of view of the administrator. PostgreSQL supports two localization facilities:
Using the locale features of the operating system to provide locale-specific collation order, number formatting, translated messages, and other aspects. This is covered in Section 23.1 and Section 23.2.
Providing a number of different character sets to support storing text in all kinds of languages, and providing character set translation between client and server. This is covered in Section 23.3.
Prev Up Next
22.6. Tablespaces
Home
23.1. Locale Support
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
