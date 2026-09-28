# PostgreSQL: Documentation: 18: 53.33. pg_timezone_abbrevs

PostgreSQL: Documentation: 18: 53.33. pg_timezone_abbrevs Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
53.33. pg_timezone_abbrevs
Prev Up Chapter 53. System Views Home Next
53.33. pg_timezone_abbrevs #
The view pg_timezone_abbrevs provides a list of time zone abbreviations that are currently recognized by the datetime input routines. The contents of this view change when the TimeZone or timezone_abbreviations run-time parameters are modified.
Table 53.33. pg_timezone_abbrevs Columns Column Type Description abbrev text Time zone abbreviation utc_offset interval Offset from UTC (positive means east of Greenwich) is_dst bool True if this is a daylight-savings abbreviation While most timezone abbreviations represent fixed offsets from UTC, there are some that have historically varied in value (see Section B.4 for more information). In such cases this view presents their current meaning.
Prev Up Next
53.32. pg_tables
Home
53.34. pg_timezone_names
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
