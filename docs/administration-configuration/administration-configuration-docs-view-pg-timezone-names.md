# PostgreSQL: Documentation: 18: 53.34. pg_timezone_names

PostgreSQL: Documentation: 18: 53.34. pg_timezone_names Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.34. pg_timezone_names
Prev Up Chapter 53. System Views Home Next
53.34. pg_timezone_names #
The view pg_timezone_names provides a list of time zone names that are recognized by SET TIMEZONE, along with their associated abbreviations, UTC offsets, and daylight-savings status. (Technically, PostgreSQL does not use UTC because leap seconds are not handled.) Unlike the abbreviations shown in pg_timezone_abbrevs, many of these names imply a set of daylight-savings transition date rules. Therefore, the associated information changes across local DST boundaries. The displayed information is computed based on the current value of CURRENT_TIMESTAMP.
Table 53.34. pg_timezone_names Columns Column Type Description name text Time zone name abbrev text Time zone abbreviation utc_offset interval Offset from UTC (positive means east of Greenwich) is_dst bool True if currently observing daylight savings Prev Up Next
53.33. pg_timezone_abbrevs
Home
53.35. pg_user
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
