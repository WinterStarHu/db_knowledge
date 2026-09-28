# SOUNDEX

## Syntax
Description of the illustration soundex.gif Description of the illustration soundex.eps
## Purpose
`SOUNDEX` returns a character string containing the phonetic representation of *char*. This function lets you compare words that are spelled differently, but sound alike in English.
The phonetic representation is defined in *The Art of Computer Programming*, Volume 3: Sorting and Searching, by Donald E. Knuth, as follows:
- Retain the first letter of the string and remove all other occurrences of the following letters: a, e, h, i, o, u, w, y.
- Assign numbers to the remaining letters (after the first) as follows:
```
b, f, p, v = 1
c, g, j, k, q, s, x, z = 2
d, t = 3
l = 4
m, n = 5
r = 6
```
- If two or more letters with the same number were adjacent in the original name (before step 1), or adjacent except for any intervening h and w, then retain the first letter and omit rest of all the adjacent letters with same number.
- Return the first four bytes padded with 0.
*char* can be of any of the data types `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. The return value is the same data type as *char*.
This function does not support `CLOB` data directly. However, `CLOB`s can be passed in as arguments through implicit data conversion.
```

```
## Examples
The following example returns the employees whose last names are a phonetic representation of “Smyth”:
```
SELECT last_name, first_name
     FROM hr.employees
     WHERE SOUNDEX(last_name)
         = SOUNDEX('SMYTHE')
     ORDER BY last_name, first_name;
LAST_NAME  FIRST_NAME
---------- ----------
Smith      Lindsey
Smith      William
```
