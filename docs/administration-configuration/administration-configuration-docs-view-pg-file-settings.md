# PostgreSQL: Documentation: 18: 53.8. pg_file_settings

PostgreSQL: Documentation: 18: 53.8. pg_file_settings Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
53.8. pg_file_settings
Prev Up Chapter 53. System Views Home Next
53.8. pg_file_settings #
The view pg_file_settings provides a summary of the contents of the server's configuration file(s). A row appears in this view for each “name = value” entry appearing in the files, with annotations indicating whether the value could be applied successfully. Additional row(s) may appear for problems not linked to a “name = value” entry, such as syntax errors in the files.
This view is helpful for checking whether planned changes in the configuration files will work, or for diagnosing a previous failure. Note that this view reports on the current contents of the files, not on what was last applied by the server. (The pg_settings view is usually sufficient to determine that.) By default, the pg_file_settings view can be read only by superusers.
Table 53.8. pg_file_settings Columns Column Type Description sourcefile text Full path name of the configuration file sourceline int4 Line number within the configuration file where the entry appears seqno int4 Order in which the entries are processed (1..n) name text Configuration parameter name setting text Value to be assigned to the parameter applied bool True if the value can be applied successfully error text If not null, an error message indicating why this entry could not be applied If the configuration file contains syntax errors or invalid parameter names, the server will not attempt to apply any settings from it, and therefore all the applied fields will read as false. In such a case there will be one or more rows with non-null error fields indicating the problem(s). Otherwise, individual settings will be applied if possible. If an individual setting cannot be applied (e.g., invalid value, or the setting cannot be changed after server start) it will have an appropriate message in the error field. Another way that an entry might have applied = false is that it is overridden by a later entry for the same parameter name; this case is not considered an error so nothing appears in the error field.
See Section 19.1 for more information about the various ways to change run-time parameters.
Prev Up Next
53.7. pg_cursors
Home
53.9. pg_group
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
