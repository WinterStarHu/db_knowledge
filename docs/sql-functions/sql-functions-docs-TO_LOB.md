# TO_LOB

## Syntax
Description of the illustration to_lob.gif Description of the illustration to_lob.eps
## Purpose
`TO_LOB` converts `LONG` or `LONG` RAW values in the column *long_column* to LOB values. You can apply this function only to a `LONG` or `LONG` `RAW` column, and only in the select list of a subquery in an `INSERT` statement.
Before using this function, you must create a LOB column to receive the converted `LONG` values. To convert `LONG` values, create a `CLOB` column. To convert `LONG` RAW values, create a `BLOB` column.
You cannot use the `TO_LOB` function to convert a `LONG` column to a LOB column in the subquery of a `CREATE` `TABLE` … `AS` `SELECT` statement if you are creating an index-organized table. Instead, create the index-organized table without the `LONG` column, and then use the `TO_LOB` function in an `INSERT` … `AS` `SELECT` statement.
You cannot use this function within a PL/SQL package. Instead use the `TO_CLOB` (character) or `TO_BLOB` (raw) functions.
**See Also:** **
- the modify_col_properties clause of ALTER TABLE for an alternative method of converting LONG columns to LOB
- INSERT for information on the subquery of an INSERT statement
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of this function
## Examples
The following syntax shows how to use the `TO_LOB` function on your `LONG` data in a hypothetical table *old_table*:
```
CREATE TABLE new_table (col1, col2, ... lob_col CLOB);
INSERT INTO new_table (select o.col1, o.col2, ... TO_LOB(o.old_long_col)
   FROM old_table o;
```
