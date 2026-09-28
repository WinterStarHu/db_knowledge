# COLUMN_VALUE Pseudocolumn

When you refer to an `XMLTable` construct without the `COLUMNS` clause, or when you use the `TABLE` collection expression to refer to a scalar nested table type, the database returns a virtual table with a single column. This name of this pseudocolumn is `COLUMN_VALUE`.
In the context of `XMLTable`, the value returned is of data type `XMLType`. For example, the following two statements are equivalent, and the output for both shows `COLUMN_VALUE` as the name of the column being returned:
```
SELECT *
  FROM XMLTABLE('123');
COLUMN_VALUE
---------------------------------------
123
SELECT COLUMN_VALUE
  FROM (XMLTable('123'));
COLUMN_VALUE
----------------------------------------
123
```
In the context of a `TABLE` collection expression, the value returned is the data type of the collection element. The following statements create the two levels of nested tables illustrated in Creating a Table: Multilevel Collection Example to show the uses of `COLUMN_VALUE` in this context:
```
CREATE TYPE phone AS TABLE OF NUMBER;
/
CREATE TYPE phone_list AS TABLE OF phone;
/
```
The next statement uses `COLUMN_VALUE` to select from the `phone` type:
```
SELECT t.COLUMN_VALUE
  FROM TABLE(phone(1,2,3)) t;
COLUMN_VALUE
------------
           1
           2
           3
```
In a nested type, you can use the `COLUMN_VALUE` pseudocolumn in both the select list and the `TABLE` collection expression:
```
SELECT t.COLUMN_VALUE
  FROM TABLE(phone_list(phone(1,2,3))) p, TABLE(p.COLUMN_VALUE) t;
COLUMN_VALUE
------------
           1
           2
           3
```
The keyword `COLUMN_VALUE` is also the name that Oracle Database generates for the scalar value of an inner nested table without a column or attribute name, as shown in the example that follows. In this context, `COLUMN_VALUE` is not a pseudocolumn, but an actual column name.
```
CREATE TABLE my_customers (
    cust_id       NUMBER,
    name          VARCHAR2(25),
    phone_numbers phone_list,
    credit_limit  NUMBER)
  NESTED TABLE phone_numbers STORE AS outer_ntab
  (NESTED TABLE **COLUMN_VALUE** STORE AS inner_ntab);
```
**See Also:**
- XMLTABLE for information on that function
**
- table_collection_expression::= for information on the TABLE collection expression
````
- ALTER TABLE examples in Nested Tables: Examples
**
- in Oracle Database Globalization Support Guide for the collation derivation rules for values of the COLUMN_VALUE pseudocolumn
