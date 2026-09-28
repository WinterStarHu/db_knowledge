# NLS_LOWER

## Syntax
Description of the illustration nls_lower.gif Description of the illustration nls_lower.eps
## Purpose
`NLS_LOWER` returns *char*, with all letters lowercase.
Both *char* and *‘nlsparam’* can be any of the data types `CHAR`, `VARCHAR2`, `NCHAR`, `NVARCHAR2`, `CLOB`, or `NCLOB`. The string returned is of `VARCHAR2` data type if *char* is a character data type and a LOB if *char* is a LOB data type. The return string is in the same character set as *char*.
The *‘nlsparam’* can have the same form and serve the same purpose as in the `NLS_INITCAP` function.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation determination rules for `NLS_LOWER`, and for the collation derivation rules, which define the collation assigned to the character return value of this function
## Examples
The following statement returns the lowercase form of the character string ‘`NOKTASINDA`’ using the XTurkish linguistic sort sequence. The Turkish uppercase I becoming a small, dotless i.
```
SELECT NLS_LOWER('NOKTASINDA', 'NLS_SORT = XTurkish') "Lowercase"
  FROM DUAL;
```
