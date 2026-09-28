# NLSSORT

## Syntax
Description of the illustration nlssort.gif Description of the illustration nlssort.eps
## Purpose
`NLSSORT` returns a collation key for the character value *char* and an explicitly or implicitly specified collation. A collation key is a string of bytes used to sort *char* according to the specified collation. The property of the collation keys is that mutual ordering of two such keys generated for the given collation when compared according to their binary order is the same as mutual ordering of the source character values when compared according to the given collation.
Both *char* and ‘*nlsparam*’ can be any of the data types `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`.
The value of ‘*nlsparam*’ must have the form
```
'NLS_SORT = collation'
```
where *collation* is the name of a linguistic collation or `BINARY`. `NLSSORT` uses the specified collation to generate the collation key. If you omit ‘*nlsparam*’, then this function uses the derived collation of the argument *char*. If you specify `BINARY`, then this function returns the *char* value itself cast to `RAW` and possibly truncated as described below.
If you specify ‘*nlsparam*’, then you can append to the linguistic collation name the suffix `_ai` to request an accent-insensitive collation or `_ci` to request a case-insensitive collation. Refer to *Oracle Database Globalization Support Guide* for more information on accentand case-insensitive sorting. Using accent-insensitive or case-insensitive collations with the `ORDER` `BY` query clause is not recommended as it leads to a nondeterministic sort order.
The returned collation key is of `RAW` data type. The length of the collation key resulting from a given *char* value for a given collation may exceed the maximum length of the `RAW` value returned by `NLSSORT`. In this case, the behavior of `NLSSORT` depends on the value of the initialization parameter `MAX_STRING_SIZE`. If `MAX_STRING_SIZE` `=` `EXTENDED`, then the maximum length of the return value is 32767 bytes. If the collation key exceeds this limit, then the function fails with the error “ORA-12742: unable to create the collation key”. This error may also be reported for short input strings if they contain a high percentage of Unicode characters with very high decomposition ratios.
**See Also:**   *Oracle Database Globalization Support Guide* for details of when the `ORA-12742` error is reported and how to prevent application availability issues that the error could cause If `MAX_STRING_SIZE` `=` `STANDARD`, then the maximum length of the return value is 2000 bytes. If the value to be returned exceeds the limit, then `NLSSORT` calculates the collation key for a maximum prefix, or initial substring, of *char* so that the calculated result does not exceed the maximum length. For monolingual collations, for example `FRENCH`, the prefix length is typically 1000 characters. For multilingual collations, for example `GENERIC_M`, the prefix is typically 500 characters. For Unicode Collation Algorithm (UCA) collations, for example `UCA0610_DUCET`, the prefix is typically 285 characters. The exact length may be lower or higher depending on the collation and the characters contained in *char*.
The behavior when `MAX_STRING_SIZE` `=` `STANDARD` implies that two character values whose collation keys (`NLSSORT` results) are compared to find the linguistic ordering are considered equal if they do not differ in the prefix even though they may differ at some further character position. Because the `NLSSORT` function is used implicitly to find linguistic ordering for comparison conditions, the `BETWEEN` condition, the `IN` condition, `ORDER` `BY`, `GROUP` `BY`, and `COUNT(DISTINCT)`, those operations may return results that are only approximate for long character values. If you want guarantee that the results of those operations are exact, then migrate your database to use `MAX_STRING_SIZE` `=` `EXTENDED`.
Refer to “Extended Data Types” for more information on the `MAX_STRING_SIZE` initialization parameter.
This function does not support `CLOB` data directly. However, `CLOB`s can be passed in as arguments through implicit data conversion.
**See Also:**
- “Data Type Comparison Rules” for more information.
**
- in Oracle Database Globalization Support Guide for the collation determination rules for NLSSORT
## Examples
This function can be used to specify sorting and comparison operations based on a linguistic sort sequence rather than on the binary value of a string. The following example creates a test table containing two values and shows how the values returned can be ordered by the `NLSSORT` function:
```
CREATE TABLE test (name VARCHAR2(15));
INSERT INTO test VALUES ('Gaardiner');
INSERT INTO test VALUES ('Gaberd');
INSERT INTO test VALUES ('Gaasten');
SELECT *
  FROM test
  ORDER BY name;
NAME
---------------
Gaardiner
Gaasten
Gaberd
SELECT *
  FROM test
  ORDER BY NLSSORT(name, 'NLS_SORT = XDanish');
NAME
---------------
Gaberd
Gaardiner
Gaasten
```
The following example shows how to use the `NLSSORT` function in comparison operations:
```
SELECT *
  FROM test
  WHERE name > 'Gaberd'
  ORDER BY name;
no rows selected
SELECT *
  FROM test
  WHERE NLSSORT(name, 'NLS_SORT = XDanish') >
        NLSSORT('Gaberd', 'NLS_SORT = XDanish')
  ORDER BY name;
NAME
---------------
Gaardiner
Gaasten
```
If you frequently use `NLSSORT` in comparison operations with the same linguistic sort sequence, then consider this more efficient alternative: Set the `NLS_COMP` parameter (either for the database or for the current session) to `LINGUISTIC`, and set the `NLS_SORT` parameter for the session to the desired sort sequence. Oracle Database will use that sort sequence by default for all sorting and comparison operations during the current session:
```
ALTER SESSION SET NLS_COMP = 'LINGUISTIC';
ALTER SESSION SET NLS_SORT = 'XDanish';
SELECT *
  FROM test
  WHERE name > 'Gaberd'
  ORDER BY name;
NAME
---------------
Gaardiner
Gaasten
```
**See Also:**   *Oracle Database Globalization Support Guide* for information on sort sequences
