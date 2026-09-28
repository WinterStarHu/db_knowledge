# parallel_clause                  document.write(''); document.write('body > .noscript, body > .noscript ~ * { opacity: 0; }'); document.write('');    if (window.require === undefined) { document.write(''); document.write(''); }

# *parallel_clause*
## Purpose
The *parallel_clause* lets you parallelize the creation of a database object and set the default degree of parallelism for subsequent queries of and DML operations on the object.
You can specify the *parallel_clause* in the following statements:
````
- CREATE TABLE: to set parallelism for the table (see CREATE TABLE).
````
  - To change parallelism for the table
  - To parallelize the operations of adding, coalescing, exchanging, merging, splitting, truncating, dropping, or moving a table partition
````````
- CREATE CLUSTER and ALTER CLUSTER: to set or alter parallelism for a cluster (see CREATE CLUSTER and ALTER CLUSTER).
````
- CREATE INDEX: to set parallelism for the index (see CREATE INDEX).
````
  - To change parallelism for the index
  - To parallelize the rebuilding of the index or the splitting of an index partition
``````
- CREATE MATERIALIZED VIEW: to set parallelism for the materialized view (see CREATE MATERIALIZED VIEW).
``````
  - To change parallelism for the materialized view
  - To parallelize the operations of adding, coalescing, exchanging, merging, splitting, truncating, dropping, or moving a materialized view partition
  - To parallelize the operations of adding or moving materialized view subpartitions
````````
- CREATE MATERIALIZED VIEW LOG: to set parallelism for the materialized view log (see CREATE MATERIALIZED VIEW LOG).
````````
  - To change parallelism for the materialized view log
  - To parallelize the operations of adding, coalescing, exchanging, merging, splitting, truncating, dropping, or moving a materialized view log partition
``````
- ALTER DATABASE ... RECOVER: to recover the database (see ALTER DATABASE).
````**
- ALTER DATABASE ... standby_database_clauses: to parallelize operations on the standby database (see ALTER DATABASE).
**See Also:**   *Oracle Database PL/SQL Packages and Types Reference* for information on the `DBMS_PARALLEL_EXECUTE` package, which provides methods to apply table changes in chunks of rows. Changes to each chunk are independently committed when there are no errors.
## Syntax
## *parallel_clause*::=
Description of the illustration parallel_clause.eps
## Semantics
This section describes the semantics of the *parallel_clause*. For additional information, refer to the SQL statement in which you set or reset parallelism for a particular database object or operation.
**Note:**   The syntax of the *parallel_clause* supersedes syntax appearing in earlier releases of Oracle. The superseded syntax is still supported for backward compatibility, but may result in slightly different behavior from that documented.
The database interprets the *parallel_clause* based on the setting of the `PARALLEL_DEGREE_POLICY` initialization parameter. When that parameter is set to `AUTO`, the *parallel_clause* is ignored entirely, and the optimizer determines the best degree of parallelism for all statements. When `PARALLEL_DEGREE_POLICY` is set to either `MANUAL` or `LIMITED`, the *parallel_clause* is interpreted as follows:
**NOPARALLEL**
Specify `NOPARALLEL` for serial execution. This is the default.
**PARALLEL**
Specify `PARALLEL` for parallel execution.
``````
- If PARALLEL_DEGREE_POLICY is set to MANUAL, then the optimizer calculates a degree of parallelism equal to the number of CPUs available on all participating instances times the value of the PARALLEL_THREADS_PER_CPU initialization parameter.
````
- If PARALLEL_DEGREE_POLICY is set to LIMITED, then the optimizer determines the best degree of parallelism.
**PARALLEL** ***integer***
Specification of *integer* indicates the **degree of parallelism**, which is the number of parallel threads used in the parallel operation. Each parallel thread may use one or two parallel execution servers.
## Notes on the*parallel_clause*
The following notes apply to the *parallel_clause*:
- Parallelism is disabled for DML operations on tables on which you have defined a trigger or referential integrity constraint.
````
- Parallelism is not supported for UPDATE or DELETE operations on index-organized tables.
**````````
- When you specify the parallel_clause during creation of a table, if the table contains any columns of LOB or user-defined object type, then subsequent INSERT, UPDATE, DELETE or MERGE operations that modify the LOB or object type column are executed serially without notification. Subsequent queries, however, will be executed in parallel.
**
- A parallel hint overrides the effect of the parallel_clause.
````````
- DML statements and CREATE TABLE ... AS SELECT statements that reference remote objects can run in parallel. However, the remote object must really be on a remote database. The reference cannot loop back to an object on the local database, for example, by way of a synonym on the remote database pointing back to an object on the local database.
******
- DML operations on tables with LOB columns can be parallelized. However, intrapartition parallelism is not supported. See Also: Oracle Database VLDB and Partitioning Guide for more information on parallelized operations, and “Creating a Table: Parallelism Examples”
