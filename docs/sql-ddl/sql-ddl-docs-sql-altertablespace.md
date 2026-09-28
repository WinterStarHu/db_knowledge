# PostgreSQL: Documentation: 18: ALTER TABLESPACE

PostgreSQL: Documentation: 18: ALTER TABLESPACE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER TABLESPACE Prev Up SQL Commands Home Next ALTER TABLESPACE ALTER TABLESPACE — change the definition of a tablespace Synopsis ALTER TABLESPACE name RENAME TO new_name ALTER TABLESPACE name OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER TABLESPACE name SET ( tablespace_option = value [, ... ] ) ALTER TABLESPACE name RESET ( tablespace_option [, ... ] ) Description ALTER TABLESPACE can be used to change the definition of a tablespace.
You must own the tablespace to change the definition of a tablespace. To alter the owner, you must also be able to SET ROLE to the new owning role. (Note that superusers have these privileges automatically.) Parameters name The name of an existing tablespace.
new_name The new name of the tablespace. The new name cannot begin with pg_, as such names are reserved for system tablespaces.
new_owner The new owner of the tablespace.
tablespace_option A tablespace parameter to be set or reset. Currently, the only available parameters are seq_page_cost, random_page_cost, effective_io_concurrency and maintenance_io_concurrency. Setting these values for a particular tablespace will override the planner's usual estimate of the cost of reading pages from tables in that tablespace, and how many concurrent I/Os are issued, as established by the configuration parameters of the same name (see seq_page_cost, random_page_cost, effective_io_concurrency, maintenance_io_concurrency). This may be useful if one tablespace is located on a disk which is faster or slower than the remainder of the I/O subsystem.
Examples Rename tablespace index_space to fast_raid:
ALTER TABLESPACE index_space RENAME TO fast_raid;
Change the owner of tablespace index_space:
ALTER TABLESPACE index_space OWNER TO mary;
Compatibility There is no ALTER TABLESPACE statement in the SQL standard.
See AlsoCREATE TABLESPACE, DROP TABLESPACE Prev Up Next ALTER TABLE Home ALTER TEXT SEARCH CONFIGURATION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
