# RAWTONHEX

## Syntax
Description of the illustration rawtonhex.gif Description of the illustration rawtonhex.eps
## Purpose
`RAWTONHEX` converts *raw* to a character value containing its hexadecimal representation. `RAWTONHEX(`*raw*`)` is equivalent to `TO_NCHAR(RAWTOHEX(`*raw*`))`. The value returned is always in the national character set.
**Note:**   `RAWTONHEX` functions differently when used as a PL/SQL built-in function. Refer to *Oracle Database Development Guide* for more information.
## Examples
The following hypothetical example returns the hexadecimal equivalent of a `RAW` column value:
```
SELECT RAWTONHEX(raw_column),
   DUMP ( RAWTONHEX (raw_column) ) "DUMP"
   FROM graphics;
RAWTONHEX(RA)           DUMP
----------------------- ------------------------------
7D                      Typ=1 Len=4: 0,55,0,68
```
