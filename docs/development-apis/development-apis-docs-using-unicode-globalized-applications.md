# Using Unicode in Globalized Applications

You can insert and retrieve Unicode data. Data is transparently converted among the database and client programs, which ensures that client programs are independent of the database character set and national character set.
**See Also:** **
- Oracle Database Globalization Support Guide for more information about SQL and PL/SQL programming with Unicode
**
- Oracle Database Globalization Support Guide for general information about programming with Unicode
## Representing Unicode String Literals in SQL and PL/SQL
There are three ways to represent a Unicode string literal in SQL or PL/SQL, as shown in the following examples.
**** ****
- N'string' Example: N'résumé'. Limitations: See “Avoiding Data Loss During Character-Set Conversion”.
**** ****
- NCHR(number) The SQL function NCHR returns the character whose binary equivalent is number in the national character set. The character returned has data type NVARCHAR2. Example: NCHR(36) represents $ in the default national character set, AL16UTF16. Limitations: Portability of the value of NCHR(number) is limited to applications that use the same national character set.
****
- UNISTR('string') The SQL function UNISTR converts string to the national character set. For portability and data preservation, Oracle recommends that string contain only ASCII characters and Unicode encoding values. A Unicode encoding value has the form \xxxx, where xxxx is the hexadecimal value of a character code value in UCS-2 encoding format. Example: UNISTR('G\0061ry') represents 'Gary' ASCII characters are converted to the database character set and then to the national character set. Unicode encoding values are converted directly to the national character set.
**See Also:** **
- Oracle Database Globalization Support Guide for more information about Unicode string literals
**
- Oracle Database SQL Language Reference for more information about the NCHR function
**
- Oracle Database SQL Language Reference for more information about the UNISTR function
## Avoiding Data Loss During Character-Set Conversion
As part of a SQL or PL/SQL statement, a literal (with or without the prefix N) is encoded in the same character set as the rest of the statement. On the client side, the statement is encoded in the client character set, which is determined by the NLS_LANG parameter. On the server side, the statement is encoded in the database character set.
When the SQL or PL/SQL statement is transferred from the client to the database, its character set is converted accordingly. If the database character set does not contain all characters that the client used in the text literals, then data is lost in this conversion. NCHAR string literals are more vulnerable than CHAR text literals, because they are designed to be independent of the database character set.
To avoid data loss in conversion to an incompatible database character set, you can activate the NCHAR literal replacement functionality. For more information, see *Oracle Database Globalization Support Guide*.
