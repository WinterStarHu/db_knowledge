# PostgreSQL: Documentation: 18: Chapter 36. Extending SQL

PostgreSQL: Documentation: 18: Chapter 36. Extending SQL Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 36. Extending SQL Prev Up Part V. Server Programming Home Next Chapter 36. Extending SQL Table of Contents
36.1. How Extensibility Works
36.2. The PostgreSQL Type System
36.2.1. Base Types
36.2.2. Container Types
36.2.3. Domains
36.2.4. Pseudo-Types
36.2.5. Polymorphic Types
36.3. User-Defined Functions
36.4. User-Defined Procedures
36.5. Query Language (SQL) Functions
36.5.1. Arguments for SQL Functions
36.5.2. SQL Functions on Base Types
36.5.3. SQL Functions on Composite Types
36.5.4. SQL Functions with Output Parameters
36.5.5. SQL Procedures with Output Parameters
36.5.6. SQL Functions with Variable Numbers of Arguments
36.5.7. SQL Functions with Default Values for Arguments
36.5.8. SQL Functions as Table Sources
36.5.9. SQL Functions Returning Sets
36.5.10. SQL Functions Returning TABLE
36.5.11. Polymorphic SQL Functions
36.5.12. SQL Functions with Collations
36.6. Function Overloading
36.7. Function Volatility Categories
36.8. Procedural Language Functions
36.9. Internal Functions
36.10. C-Language Functions
36.10.1. Dynamic Loading
36.10.2. Base Types in C-Language Functions
36.10.3. Version 1 Calling Conventions
36.10.4. Writing Code
36.10.5. Compiling and Linking Dynamically-Loaded Functions
36.10.6. Server API and ABI Stability Guidance
36.10.7. Composite-Type Arguments
36.10.8. Returning Rows (Composite Types)
36.10.9. Returning Sets
36.10.10. Polymorphic Arguments and Return Types
36.10.11. Shared Memory
36.10.12. LWLocks
36.10.13. Custom Wait Events
36.10.14. Injection Points
36.10.15. Custom Cumulative Statistics
36.10.16. Using C++ for Extensibility
36.11. Function Optimization Information
36.12. User-Defined Aggregates
36.12.1. Moving-Aggregate Mode
36.12.2. Polymorphic and Variadic Aggregates
36.12.3. Ordered-Set Aggregates
36.12.4. Partial Aggregation
36.12.5. Support Functions for Aggregates
36.13. User-Defined Types
36.13.1. TOAST Considerations
36.14. User-Defined Operators
36.15. Operator Optimization Information
36.15.1. COMMUTATOR
36.15.2. NEGATOR
36.15.3. RESTRICT
36.15.4. JOIN
36.15.5. HASHES
36.15.6. MERGES
36.16. Interfacing Extensions to Indexes
36.16.1. Index Methods and Operator Classes
36.16.2. Index Method Strategies
36.16.3. Index Method Support Routines
36.16.4. An Example
36.16.5. Operator Classes and Operator Families
36.16.6. System Dependencies on Operator Classes
36.16.7. Ordering Operators
36.16.8. Special Features of Operator Classes
36.17. Packaging Related Objects into an Extension
36.17.1. Extension Files
36.17.2. Extension Relocatability
36.17.3. Extension Configuration Tables
36.17.4. Extension Updates
36.17.5. Installing Extensions Using Update Scripts
36.17.6. Security Considerations for Extensions
36.17.7. Extension Example
36.18. Extension Building Infrastructure
In the sections that follow, we will discuss how you can extend the PostgreSQL SQL query language by adding:
functions (starting in Section 36.3) aggregates (starting in Section 36.12) data types (starting in Section 36.13) operators (starting in Section 36.14) operator classes for indexes (starting in Section 36.16) packages of related objects (starting in Section 36.17) Prev Up Next Part V. Server Programming Home
36.1. How Extensibility Works
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
