# LTRIM

## Syntax
Description of the illustration ltrim.gif Description of the illustration ltrim.eps
## Purpose
`LTRIM` removes from the left end of *char* all of the characters contained in *set*. If you do not specify *set*, then it defaults to a single blank. Oracle Database begins scanning *char* from its first character and removes all characters that appear in *set* until reaching a character not in *set* and then returns the result.
Both *char* and *set* can be any of the data types `CHAR`, `VARCHAR2`, `NCHAR`, `NVARCHAR2`, `CLOB`, or `NCLOB`. The string returned is of `VARCHAR2` data type if *char* is a character data type, `NVARCHAR2` if *char* is a national character data type, and a LOB if *char* is a LOB data type.
**See Also:**
- RTRIM
******
- in Oracle Database Globalization Support Guide for the collation determination rules, which define the collation LTRIM uses to compare characters from set with characters from char, and for the collation derivation rules, which define the collation assigned to the character return value of this function
## Examples
The following example trims all the left-most occurrences of less than sign (``) , and equal sign (`=`) from a string:
```
SELECT LTRIM('BROWNING', '<>=') "LTRIM Example"
  FROM DUAL;
LTRIM Example
---------------
BROWNING
```
