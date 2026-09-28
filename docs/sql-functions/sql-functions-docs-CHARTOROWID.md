# CHARTOROWID

## Syntax
Description of the illustration chartorowid.gif Description of the illustration chartorowid.eps
## Purpose
`CHARTOROWID` converts a value from `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type to `ROWID` data type.
This function does not support `CLOB` data directly. However, `CLOB`s can be passed in as arguments through implicit data conversion.
**See Also:**    Data Type Comparison Rules for more information.
## Examples
The following example converts a character rowid representation to a rowid. (The actual rowid is different for each database instance.)
```
SELECT last_name
  FROM employees
  WHERE ROWID = CHARTOROWID('AAAFd1AAFAAAABSAA/');
LAST_NAME
-------------------------
Greene
```
