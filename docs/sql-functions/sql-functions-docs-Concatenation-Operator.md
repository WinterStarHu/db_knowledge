# Concatenation Operator

The concatenation operator manipulates character strings and `CLOB` data. Table 4-4 describes the concatenation operator.
Table 4 Concatenation Operator

| Operator | Purpose | Example |  |  |
|---|---|---|---|---|
| \|\| | Concatenates character strings and CLOB data. | {::nomarkdown}SELECT ‘Name is ‘ |  | last_name FROM employees ORDER BY last_name; {:/} |

The result of concatenating two character strings is another character string. If both character strings are of data type `CHAR`, then the result has data type `CHAR` and is limited to 2000 characters. If either string is of data type `VARCHAR2`, then the result has data type `VARCHAR2` and is limited to 32767 characters if the initialization parameter `MAX_STRING_SIZE` `=` `EXTENDED` and 4000 characters if `MAX_STRING_SIZE` `=` `STANDARD`. Refer to Extended Data Types for more information. If either argument is a `CLOB`, the result is a temporary `CLOB`. Trailing blanks in character strings are preserved by concatenation, regardless of the data types of the string or `CLOB`.
On most platforms, the concatenation operator is two solid vertical bars, as shown in Table 4-4. However, some IBM platforms use broken vertical bars for this operator. When moving SQL script files between systems having different character sets, such as between ASCII and EBCDIC, vertical bars might not be translated into the vertical bar required by the target Oracle Database environment. Oracle provides the `CONCAT` character function as an alternative to the vertical bar operator for cases when it is difficult or impossible to control translation performed by operating system or network utilities. Use this function in applications that will be moved between environments with differing character sets.
Although Oracle treats zero-length character strings as nulls, concatenating a zero-length character string with another operand always results in the other operand, so null can result only from the concatenation of two null strings. However, this may not continue to be true in future versions of Oracle Database. To concatenate an expression that might be null, use the `NVL` function to explicitly convert the expression to a zero-length string.
**See Also:**
````
- Character Data Types for more information on the differences between the CHAR and VARCHAR2 data types
- The functions CONCAT and NVL
**
- Oracle Database SecureFiles and Large Objects Developer’s Guide for more information about CLOBs
**
- Oracle Database Globalization Support Guide for the collation derivation rules for the concatenation operator
## Concatenation Example
This example creates a table with both `CHAR` and `VARCHAR2` columns, inserts values both with and without trailing blanks, and then selects these values and concatenates them. Note that for both `CHAR` and `VARCHAR2` columns, the trailing blanks are preserved.
```
CREATE TABLE tab1 (col1 VARCHAR2(6), col2 CHAR(6), col3 VARCHAR2(6), col4 CHAR(6));
INSERT INTO tab1 (col1,  col2,     col3,     col4) VALUES ('abc', 'def   ', 'ghi   ', 'jkl');
SELECT col1 || col2 || col3 || col4 "Concatenation" FROM tab1;
Concatenation
------------------------
abcdef   ghi   jkl
```
