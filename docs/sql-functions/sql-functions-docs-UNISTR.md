# UNISTR

## Syntax
Description of the illustration unistr.gif Description of the illustration unistr.eps
## Purpose
`UNISTR` takes as its argument a text literal or an expression that resolves to character data and returns it in the national character set. The national character set of the database can be either AL16UTF16 or UTF8. `UNISTR` provides support for Unicode string literals by letting you specify the Unicode encoding value of characters in the string. This is useful, for example, for inserting data into `NCHAR` columns.
The Unicode encoding value has the form ‘\xxxx’ where ‘xxxx’ is the hexadecimal value of a character in UCS-2 encoding format. Supplementary characters are encoded as two code units, the first from the high-surrogates range (U+D800 to U+DBFF), and the second from the low-surrogates range (U+DC00 to U+DFFF). To include the backslash in the string itself, precede it with another backslash ().
For portability and data preservation, Oracle recommends that in the `UNISTR` string argument you specify only ASCII characters and the Unicode encoding values.
**See Also:** **
- Oracle Database Globalization Support Guide for information on Unicode and national character sets
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of UNISTR
## Examples
The following example passes both ASCII characters and Unicode encoding values to the `UNISTR` function, which returns the string in the national character set:
```
SELECT UNISTR('abc\00e5\00f1\00f6') FROM DUAL;
UNISTR
------
abcåñö
```
