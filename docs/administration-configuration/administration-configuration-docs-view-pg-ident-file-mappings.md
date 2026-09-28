# PostgreSQL: Documentation: 18: 53.11. pg_ident_file_mappings

PostgreSQL: Documentation: 18: 53.11. pg_ident_file_mappings Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 Development Versions:
19 / devel
53.11. pg_ident_file_mappings
Prev Up Chapter 53. System Views Home Next
53.11. pg_ident_file_mappings #
The view pg_ident_file_mappings provides a summary of the contents of the client user name mapping configuration file, pg_ident.conf. A row appears in this view for each non-empty, non-comment line in the file, with annotations indicating whether the map could be applied successfully.
This view can be helpful for checking whether planned changes in the authentication configuration file will work, or for diagnosing a previous failure. Note that this view reports on the current contents of the file, not on what was last loaded by the server.
By default, the pg_ident_file_mappings view can be read only by superusers.
Table 53.11. pg_ident_file_mappings Columns Column Type Description map_number int4 Number of this map, in priority order, if valid, otherwise NULL file_name text Name of the file containing this map line_number int4 Line number of this map in file_name map_name text Name of the map sys_name text Detected user name of the client pg_username text Requested PostgreSQL user name error text If not NULL, an error message indicating why this line could not be processed Usually, a row reflecting an incorrect entry will have values for only the line_number and error fields.
See Chapter 20 for more information about client authentication configuration.
Prev Up Next
53.10. pg_hba_file_rules
Home
53.12. pg_indexes
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
