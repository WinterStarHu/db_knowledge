# DBTIMEZONE

## Syntax
Description of the illustration dbtimezone.gif Description of the illustration dbtimezone.eps
## Purpose
`DBTIMEZONE` returns the value of the database time zone. The return type is a time zone offset (a character type in the format `'[+|-]TZH:TZM'`) or a time zone region name, depending on how the user specified the database time zone value in the most recent `CREATE` `DATABASE` or `ALTER` `DATABASE` statement.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation derivation rules, which define the collation assigned to the character return value of `DBTIMEZONE`
## Examples
The following example assumes that the database time zone is set to UTC time zone:
```
SELECT DBTIMEZONE
  FROM DUAL;
DBTIME
------
+00:00
```
