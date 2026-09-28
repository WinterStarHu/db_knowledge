# TREAT

## Syntax
Description of the illustration treat.gif Description of the illustration treat.eps
## Purpose
You can use the `TREAT` function to change the declared type of an expression.
Use the keywords `AS JSON` when you want the expression to return JSON data. This is useful when you want to force some text to be interpreted as JSON data. For example, you can use it to interpret a `VARCHAR2` value of {} as an empty JSON object instead of a string.
You must have the `EXECUTE` object privilege on *type* to use this function.
****
- In expr AS JSON ,expr is a SQL data type containing JSON, for example CLOB.
******
- In expr AS type ,expr and type must be a user-defined object types, excluding top-level collections.
******************````
- type must be some supertype or subtype of the declared type of expr. If the most specific type of expr is type (or some subtype of type), then TREAT returns expr. If the most specific type of expr is not type (or some subtype of type), then TREAT returns NULL.
**
- You can specify REF only if the declared type of expr is a REF type.
**********************````
- If the declared type of expr is a REF to a source type of expr, then type must be some subtype or supertype of the source type of expr. If the most specific type of DEREF(expr) is type (or a subtype of type), then TREAT returns expr. If the most specific type of DEREF(expr) is not type (or a subtype of type), then TREAT returns NULL.
**See Also:**    “Data Type Comparison Rules” for more information
## Examples
The following statement uses the table `oe.persons`, which is created in “Substitutable Table and Column Examples”. The example retrieves the salary attribute of all people in the `persons` table, the value being null for instances of people that are not employees.
```
SELECT name, TREAT(VALUE(p) AS employee_t).salary salary
   FROM persons p;
NAME                          SALARY
------------------------- ----------
Bob
Joe                           100000
Tim                             1000
```
You can use the `TREAT` function to create an index on the subtype attributes of a substitutable column. For an example, see “Indexing on Substitutable Columns: Examples”.
