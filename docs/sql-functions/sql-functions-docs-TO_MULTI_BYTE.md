# TO_MULTI_BYTE

## Syntax
Description of the illustration to_multi_byte.gif Description of the illustration to_multi_byte.eps
## Purpose
`TO_MULTI_BYTE` returns *char* with all of its single-byte characters converted to their corresponding multibyte characters. *char* can be of data type `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. The value returned is in the same data type as *char*.
Any single-byte characters in *char* that have no multibyte equivalents appear in the output string as single-byte characters. This function is useful only if your database character set contains both single-byte and multibyte characters.
This function does not support `CLOB` data directly. However, `CLOB`s can be passed in as arguments through implicit data conversion.
**See Also:**
- “Data Type Comparison Rules” for more information.
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of TO_MULTI_BYTE
## Examples
The following example illustrates converting from a single byte `A` to a multibyte `A` in UTF8:
```
SELECT dump(TO_MULTI_BYTE( 'A')) FROM DUAL;
DUMP(TO_MULTI_BYTE('A'))
------------------------
Typ=1 Len=3: 239,188,161
```
