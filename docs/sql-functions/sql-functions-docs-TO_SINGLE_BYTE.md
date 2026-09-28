# TO_SINGLE_BYTE

## Syntax
Description of the illustration to_single_byte.gif Description of the illustration to_single_byte.eps
## Purpose
`TO_SINGLE_BYTE` returns *char* with all of its multibyte characters converted to their corresponding single-byte characters. *char* can be of data type `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. The value returned is in the same data type as *char*.
Any multibyte characters in *char* that have no single-byte equivalents appear in the output as multibyte characters. This function is useful only if your database character set contains both single-byte and multibyte characters.
This function does not support `CLOB` data directly. However, `CLOB`s can be passed in as arguments through implicit data conversion.
**See Also:**
- “Data Type Comparison Rules” for more information.
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of TO_SINGLE_BYTE
## Examples
The following example illustrates going from a multibyte `A` in UTF8 to a single byte ASCII `A`:
```
SELECT TO_SINGLE_BYTE( CHR(15711393)) FROM DUAL;
T
-
A
```
