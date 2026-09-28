# PostgreSQL: Documentation: 18: ALTER STATISTICS

PostgreSQL: Documentation: 18: ALTER STATISTICS Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 ALTER STATISTICS Prev Up SQL Commands Home Next ALTER STATISTICS ALTER STATISTICS — change the definition of an extended statistics object Synopsis ALTER STATISTICS name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER STATISTICS name RENAME TO new_name ALTER STATISTICS name SET SCHEMA new_schema ALTER STATISTICS name SET STATISTICS { new_target | DEFAULT } Description ALTER STATISTICS changes the parameters of an existing extended statistics object. Any parameters not specifically set in the ALTER STATISTICS command retain their prior settings.
You must own the statistics object to use ALTER STATISTICS. To change a statistics object's schema, you must also have CREATE privilege on the new schema. To alter the owner, you must be able to SET ROLE to the new owning role, and that role must have CREATE privilege on the statistics object's schema. (These restrictions enforce that altering the owner doesn't do anything you couldn't do by dropping and recreating the statistics object. However, a superuser can alter ownership of any statistics object anyway.) Parameters name The name (optionally schema-qualified) of the statistics object to be altered.
new_owner The user name of the new owner of the statistics object.
new_name The new name for the statistics object.
new_schema The new schema for the statistics object.
new_target The statistic-gathering target for this statistics object for subsequent ANALYZE operations. The target can be set in the range 0 to 10000. Set it to DEFAULT to revert to using the system default statistics target (default_statistics_target). (Setting to a value of -1 is an obsolete way spelling to get the same outcome.) For more information on the use of statistics by the PostgreSQL query planner, refer to Section 14.2.
Compatibility There is no ALTER STATISTICS command in the SQL standard.
See AlsoCREATE STATISTICS, DROP STATISTICS Prev Up Next ALTER SERVER Home ALTER SUBSCRIPTION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
