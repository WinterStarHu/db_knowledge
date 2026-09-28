# XMLPARSE

## Syntax
Description of the illustration xmlparse.gif Description of the illustration xmlparse.eps
## Purpose
`XMLParse` parses and generates an XML instance from the evaluated result of *value_expr*. The *value_expr* must resolve to a string. If *value_expr* resolves to null, then the function returns null.
**
- If you specify DOCUMENT, then value_expr must resolve to a singly rooted XML document.
**
- If you specify CONTENT, then value_expr must resolve to a valid XML value.
********
- When you specify WELLFORMED, you are guaranteeing that value_expr resolves to a well-formed XML document, so the database does not perform validity checks to ensure that the input is well formed. See Also: Oracle XML DB Developer’s Guide for more information on this function
## Examples
The following example uses the `DUAL` table to illustrate the syntax of `XMLParse`:
```
SELECT XMLPARSE(CONTENT '124
Acme Enterprises
32987457
WELLFORMED) AS PO FROM DUAL;
PO
-----------------------------------------------------------------
124
Acme Enterprises
32987457
```
