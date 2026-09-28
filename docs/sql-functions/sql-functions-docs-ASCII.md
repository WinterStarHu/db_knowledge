# ASCII

## Syntax
Description of the illustration ascii.gif Description of the illustration ascii.eps
## Purpose
`ASCII` returns the decimal representation in the database character set of the first character of *char*.
*char* can be of data type `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. The value returned is of data type `NUMBER`. If your database character set is 7-bit ASCII, then this function returns an ASCII value. If your database character set is EBCDIC Code, then this function returns an EBCDIC value. There is no corresponding EBCDIC character function.
This function does not support `CLOB` data directly. However, `CLOB`s can be passed in as arguments through implicit data conversion.
**See Also:**    Data Type Comparison Rules for more information
## Examples
The following example returns employees whose last names begin with the letter L, whose ASCII equivalent is 76:
```
SELECT last_name
  FROM employees
  WHERE ASCII(SUBSTR(last_name, 1, 1)) = 76
  ORDER BY last_name;
LAST_NAME
-------------------------
Ladwig
Landry
Lee
Livingston
Lorentz
```
