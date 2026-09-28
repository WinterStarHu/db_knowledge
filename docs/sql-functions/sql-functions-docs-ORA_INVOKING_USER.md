# ORA_INVOKING_USER

## Syntax
Description of the illustration ora_invoking_user.gif Description of the illustration ora_invoking_user.eps
## Purpose
`ORA_INVOKING_USER` returns the name of the database user who invoked the current statement or view. This function takes into account the `BEQUEATH` property of intervening views referenced in the statement. If this function is invoked from within a definer’s rights context, then it returns the name of the owner of the definer’s rights object. If the invoking user is a Real Application Security user, then it returns user `XS$NULL`.
This function returns a `VARCHAR2` value.
**See Also:**
````
- BEQUEATH clause of the CREATE VIEW statement
**
- Oracle Database 2 Day + Security Guide for more information on user XS$NULL
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of ORA_INVOKING_USER
## Examples
The following example returns the name of the database user who invoked the statement:
```
SELECT ORA_INVOKING_USER FROM DUAL;
```
