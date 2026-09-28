# PostgreSQL: Documentation: 18: 2.8. Updates

PostgreSQL: Documentation: 18: 2.8. Updates Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
2.8. Updates
Prev Up Chapter 2. The SQL Language Home Next
2.8. Updates #
You can update existing rows using the UPDATE command. Suppose you discover the temperature readings are all off by 2 degrees after November 28. You can correct the data as follows:
UPDATE weather SET temp_hi = temp_hi - 2,  temp_lo = temp_lo - 2 WHERE date > '1994-11-28';
Look at the new state of the data:
SELECT * FROM weather;
city      | temp_lo | temp_hi | prcp |    date
---------------+---------+---------+------+------------
San Francisco |      46 |      50 | 0.25 | 1994-11-27 San Francisco |      41 |      55 |    0 | 1994-11-29 Hayward       |      35 |      52 |      | 1994-11-29 (3 rows) Prev Up Next
2.7. Aggregate Functions
Home
2.9. Deletions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
