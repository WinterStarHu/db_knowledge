# PostgreSQL: Documentation: 18: 2.9. Deletions

PostgreSQL: Documentation: 18: 2.9. Deletions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
2.9. Deletions
Prev Up Chapter 2. The SQL Language Home Next
2.9. Deletions #
Rows can be removed from a table using the DELETE command. Suppose you are no longer interested in the weather of Hayward. Then you can do the following to delete those rows from the table:
DELETE FROM weather WHERE city = 'Hayward';
All weather records belonging to Hayward are removed.
SELECT * FROM weather;
city      | temp_lo | temp_hi | prcp |    date
---------------+---------+---------+------+------------
San Francisco |      46 |      50 | 0.25 | 1994-11-27 San Francisco |      41 |      55 |    0 | 1994-11-29 (2 rows) One should be wary of statements of the form DELETE FROM tablename;
Without a qualification, DELETE will remove all rows from the given table, leaving it empty. The system will not request confirmation before doing this!
Prev Up Next
2.8. Updates
Home Chapter 3. Advanced Features Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
