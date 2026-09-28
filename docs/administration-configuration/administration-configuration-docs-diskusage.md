# PostgreSQL: Documentation: 18: 27.6. Monitoring Disk Usage

PostgreSQL: Documentation: 18: 27.6. Monitoring Disk Usage Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
27.6. Monitoring Disk Usage
Prev Up Chapter 27. Monitoring Database Activity Home Next
27.6. Monitoring Disk Usage #
27.6.1. Determining Disk Usage
27.6.2. Disk Full Failure
This section discusses how to monitor the disk usage of a PostgreSQL database system.
27.6.1. Determining Disk Usage #
Each table has a primary heap disk file where most of the data is stored. If the table has any columns with potentially-wide values, there also might be a TOAST file associated with the table, which is used to store values too wide to fit comfortably in the main table (see Section 66.2). There will be one valid index on the TOAST table, if present. There also might be indexes associated with the base table. Each table and index is stored in a separate disk file — possibly more than one file, if the file would exceed one gigabyte. Naming conventions for these files are described in Section 66.1.
You can monitor disk space in three ways: using the SQL functions listed in Table 9.102, using the oid2name module, or using manual inspection of the system catalogs. The SQL functions are the easiest to use and are generally recommended. The remainder of this section shows how to do it by inspection of the system catalogs.
Using psql on a recently vacuumed or analyzed database, you can issue queries to see the disk usage of any table:
SELECT pg_relation_filepath(oid), relpages FROM pg_class WHERE relname = 'customer';
pg_relation_filepath | relpages
----------------------+----------
base/16384/16806     |       60 (1 row) Each page is typically 8 kilobytes. (Remember, relpages is only updated by VACUUM, ANALYZE, and a few DDL commands such as CREATE INDEX.) The file path name is of interest if you want to examine the table's disk file directly.
To show the space used by TOAST tables, use a query like the following:
SELECT relname, relpages FROM pg_class, (SELECT reltoastrelid FROM pg_class WHERE relname = 'customer') AS ss WHERE oid = ss.reltoastrelid OR oid = (SELECT indexrelid FROM pg_index WHERE indrelid = ss.reltoastrelid) ORDER BY relname;
relname        | relpages
----------------------+----------
pg_toast_16806       |        0 pg_toast_16806_index |        1 You can easily display index sizes, too:
SELECT c2.relname, c2.relpages FROM pg_class c, pg_class c2, pg_index i WHERE c.relname = 'customer' AND c.oid = i.indrelid AND c2.oid = i.indexrelid ORDER BY c2.relname;
relname      | relpages
-------------------+----------
customer_id_index |       26 It is easy to find your largest tables and indexes using this information:
SELECT relname, relpages FROM pg_class ORDER BY relpages DESC;
relname        | relpages
----------------------+----------
bigtable             |     3290 customer             |     3144
27.6.2. Disk Full Failure #
The most important disk monitoring task of a database administrator is to make sure the disk doesn't become full. A filled data disk will not result in data corruption, but it might prevent useful activity from occurring. If the disk holding the WAL files grows full, database server panic and consequent shutdown might occur.
If you cannot free up additional space on the disk by deleting other things, you can move some of the database files to other file systems by making use of tablespaces. See Section 22.6 for more information about that.
Tip Some file systems perform badly when they are almost full, so do not wait until the disk is completely full to take action.
If your system supports per-user disk quotas, then the database will naturally be subject to whatever quota is placed on the user the server runs as. Exceeding the quota will have the same bad effects as running out of disk space entirely.
Prev Up Next
27.5. Dynamic Tracing
Home Chapter 28. Reliability and the Write-Ahead Log Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
