# PostgreSQL: Documentation: 18: dblink_get_pkey

PostgreSQL: Documentation: 18: dblink_get_pkey Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
dblink_get_pkey Prev Up F.11. dblink — connect to other PostgreSQL databases Home Next dblink_get_pkey dblink_get_pkey — returns the positions and field names of a relation's primary key fields Synopsis dblink_get_pkey(text relname) returns setof dblink_pkey_results Description dblink_get_pkey provides information about the primary key of a relation in the local database. This is sometimes useful in generating queries to be sent to remote databases.
Arguments relname Name of a local relation, for example foo or myschema.mytab. Include double quotes if the name is mixed-case or contains special characters, for example "FooBar"; without quotes, the string will be folded to lower case.
Return Value Returns one row for each primary key field, or no rows if the relation has no primary key. The result row type is defined as CREATE TYPE dblink_pkey_results AS (position int, colname text);
The position column simply runs from 1 to N; it is the number of the field within the primary key, not the number within the table's columns.
Examples CREATE TABLE foobar ( f1 int, f2 int, f3 int, PRIMARY KEY (f1, f2, f3) );
CREATE TABLE SELECT * FROM dblink_get_pkey('foobar');
position | colname
----------+---------
1 | f1 2 | f2 3 | f3 (3 rows) Prev Up Next dblink_cancel_query Home dblink_build_sql_insert Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
