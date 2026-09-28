# Sequence Pseudocolumns

A **sequence** is a schema object that can generate unique sequential values. These values are often used for primary and unique keys. You can refer to sequence values in SQL statements with these pseudocolumns:
- CURRVAL: Returns the current value of a sequence
- NEXTVAL: Increments the sequence and returns the next value
You must qualify `CURRVAL` and `NEXTVAL` with the name of the sequence:
```
sequence.CURRVAL
sequence.NEXTVAL
```
To refer to the current or next value of a sequence in the schema of another user, you must have been granted either `SELECT` object privilege on the sequence or `SELECT` `ANY` `SEQUENCE` system privilege, and you must qualify the sequence with the schema containing it:
```
schema.sequence.CURRVAL
schema.sequence.NEXTVAL
```
To refer to the value of a sequence on a remote database, you must qualify the sequence with a complete or partial name of a database link:
```
schema.sequence.CURRVAL@dblink
schema.sequence.NEXTVAL@dblink
```
A sequence can be accessed by many users concurrently with no waiting or locking.
**See Also:**   References to Objects in Remote Databases for more information on referring to database links
## Where to Use Sequence Values
You can use `CURRVAL` and `NEXTVAL` in the following locations:
- The select list of a SELECT statement that is not contained in a subquery, materialized view, or view
- The select list of a subquery in an INSERT statement
````
- The VALUES clause of an INSERT statement
````
- The SET clause of an UPDATE statement
**Restrictions on Sequence Values** You cannot use `CURRVAL` and `NEXTVAL` in the following constructs:
``````
- A subquery in a DELETE, SELECT, or UPDATE statement
- A query of a view or of a materialized view
````
- A SELECT statement with the DISTINCT operator
``````````
- A SELECT statement with a GROUP BY clause or ORDER BY clause
``````````
- A SELECT statement that is combined with another SELECT statement with the UNION, INTERSECT, or MINUS set operator
````
- The WHERE clause of a SELECT statement
- The condition of a CHECK constraint
Within a single SQL statement that uses `CURRVAL` or `NEXTVAL`, all referenced `LONG` columns, updated tables, and locked tables must be located on the same database.
## How to Use Sequence Values
When you create a sequence, you can define its initial value and the increment between its values. The first reference to `NEXTVAL` returns the initial value of the sequence. Subsequent references to `NEXTVAL` increment the sequence value by the defined increment and return the new value. Any reference to `CURRVAL` always returns the current value of the sequence, which is the value returned by the last reference to `NEXTVAL`.
Before you use `CURRVAL` for a sequence in your session, you must first initialize the sequence with `NEXTVAL`. Refer to CREATE SEQUENCE for information on sequences.
Within a single SQL statement containing a reference to `NEXTVAL`, Oracle increments the sequence once:
  - A top-level SELECT statement
``````````
  - An INSERT ... SELECT statement (either single-table or multitable). For a multitable insert, the reference to NEXTVAL must appear in the VALUES clause, and the sequence is updated once for each row returned by the subquery, even though NEXTVAL may be referenced in multiple branches of the multitable insert.
````````
  - A CREATE TABLE ... AS SELECT statement
``````````
  - A CREATE MATERIALIZED VIEW ... AS SELECT statement
- For each row updated in an UPDATE statement
````
- For each INSERT statement containing a VALUES clause
``````````````````
- For each INSERT ... [ALL \ FIRST] statement (multitable insert). A multitable insert is considered a single SQL statement. Therefore, a reference to the NEXTVAL of a sequence will increase the sequence only once for each input record coming from the SELECT portion of the statement. If NEXTVAL is specified more than once in any part of the INSERT ... [ALL \ FIRST ] statement, then the value will be the same for all insert branches, regardless of how often a given record might be inserted.
````****``````
- For each row merged by a MERGE statement. The reference to NEXTVAL can appear in the merge_insert_clause or the merge_update_clause or both. The NEXTVALUE value is incremented for each row updated and for each row inserted, even if the sequence number is not actually used in the update or insert operation. If NEXTVAL is specified more than once in any of these locations, then the sequence is incremented once for each row and returns the same value for all occurrences of NEXTVAL for that row.
``````**
- For each input row in a multitable INSERT ALL statement. NEXTVAL is incremented once for each row returned by the subquery, regardless of how many occurrences of the insert_into_clause map to each row.
If any of these locations contains more than one reference to `NEXTVAL`, then Oracle increments the sequence once and returns the same value for all occurrences of `NEXTVAL`.
If any of these locations contains references to both `CURRVAL` and `NEXTVAL`, then Oracle increments the sequence and returns the same value for both `CURRVAL` and `NEXTVAL`.
**Finding the next value of a sequence: Example** This example selects the next value of the employee sequence in the sample schema `hr`:
```
SELECT employees_seq.nextval
  FROM DUAL;
```
**Inserting sequence values into a table: Example** This example increments the employee sequence and uses its value for a new employee inserted into the sample table `hr.employees`:
```
INSERT INTO employees
  VALUES (employees_seq.nextval, 'John', 'Doe', 'jdoe', '555-1212',
          TO_DATE(SYSDATE), 'PU_CLERK', 2500, null, null, 30);
```
**Reusing the current value of a sequence: Example** This example adds a new order with the next order number to the master order table. It then adds suborders with this number to the detail order table:
```
INSERT INTO orders (order_id, order_date, customer_id)
  VALUES (orders_seq.nextval, TO_DATE(SYSDATE), 106);
INSERT INTO order_items (order_id, line_item_id, product_id)
  VALUES (orders_seq.currval, 1, 2359);
INSERT INTO order_items (order_id, line_item_id, product_id)
  VALUES (orders_seq.currval, 2, 3290);
INSERT INTO order_items (order_id, line_item_id, product_id)
  VALUES (orders_seq.currval, 3, 2381);
```
