# PostgreSQL: Documentation: 18: CREATE TABLESPACE

PostgreSQL: Documentation: 18: CREATE TABLESPACE Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
CREATE TABLESPACE Prev Up SQL Commands Home Next CREATE TABLESPACE CREATE TABLESPACE — define a new tablespace Synopsis CREATE TABLESPACE tablespace_name [ OWNER { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ] LOCATION 'directory' [ WITH ( tablespace_option = value [, ... ] ) ] Description CREATE TABLESPACE registers a new cluster-wide tablespace. The tablespace name must be distinct from the name of any existing tablespace in the database cluster.
A tablespace allows superusers to define an alternative location on the file system where the data files containing database objects (such as tables and indexes) can reside.
A user with appropriate privileges can pass tablespace_name to CREATE DATABASE, CREATE TABLE, CREATE INDEX or ADD CONSTRAINT to have the data files for these objects stored within the specified tablespace.
Warning A tablespace cannot be used independently of the cluster in which it is defined; see Section 22.6.
Parameters tablespace_name The name of a tablespace to be created. The name cannot begin with pg_, as such names are reserved for system tablespaces.
user_name The name of the user who will own the tablespace. If omitted, defaults to the user executing the command. Only superusers can create tablespaces, but they can assign ownership of tablespaces to non-superusers.
directory The directory that will be used for the tablespace. The directory must exist (CREATE TABLESPACE will not create it), should be empty, and must be owned by the PostgreSQL system user. The directory must be specified by an absolute path name.
tablespace_option A tablespace parameter to be set or reset. Currently, the only available parameters are seq_page_cost, random_page_cost, effective_io_concurrency and maintenance_io_concurrency. Setting these values for a particular tablespace will override the planner's usual estimate of the cost of reading pages from tables in that tablespace, and how many concurrent I/Os are issued, as established by the configuration parameters of the same name (see seq_page_cost, random_page_cost, effective_io_concurrency, maintenance_io_concurrency). This may be useful if one tablespace is located on a disk which is faster or slower than the remainder of the I/O subsystem.
Notes CREATE TABLESPACE cannot be executed inside a transaction block.
Examples To create a tablespace dbspace at file system location /data/dbs, first create the directory using operating system facilities and set the correct ownership:
mkdir /data/dbs chown postgres:postgres /data/dbs Then issue the tablespace creation command inside PostgreSQL:
CREATE TABLESPACE dbspace LOCATION '/data/dbs';
To create a tablespace owned by a different database user, use a command like this:
CREATE TABLESPACE indexspace OWNER genevieve LOCATION '/data/indexes';
Compatibility CREATE TABLESPACE is a PostgreSQL extension.
See AlsoCREATE DATABASE, CREATE TABLE, CREATE INDEX, DROP TABLESPACE, ALTER TABLESPACE Prev Up Next CREATE TABLE AS Home CREATE TEXT SEARCH CONFIGURATION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
