# XMLSERIALIZE

## Syntax
Description of the illustration xmlserialize.gif Description of the illustration xmlserialize.eps
## Purpose
`XMLSerialize` creates a string or LOB containing the contents of *value_expr*.
Any lob returned by `XMLSERIALIZE` will be read-only.
**
- If you specify DOCUMENT, then the value_expr must be a valid XML document.
**
- If you specify CONTENT, then the value_expr need not be a singly rooted XML document. However it must be valid XML content.
**````````````
- The datatype specified can be a string type (VARCHAR2 or VARCHAR, but not NVARCHAR2), BLOB, or CLOB. The default is CLOB.
**````**
- If datatype is BLOB, then you can specify the ENCODING clause to use the specified encoding in the prolog. The xml_encoding_spec is an XML encoding declaration (encoding="...").
**
- Specify the VERSION clause to use the version you provide as string_literal in the XML declaration ().
``````********``````
- Specify NO INDENT to strip all insignificant whitespace from the output. Specify INDENT SIZE = N, where N is a whole number, for output that is pretty-printed using a relative indentation of N spaces. If N is 0, then pretty-printing inserts a newline character after each element, placing each element on a line by itself, but omitting all other insignificant whitespace in the output. If INDENT is present without a SIZE specification, then 2-space indenting is used. If you omit this clause, then the behavior (pretty-printing or not) is indeterminate.
``````````
- HIDE DEFAULTS and SHOW DEFAULTS apply only to XML schema-based data. If you specify SHOW DEFAULTS and the input data is missing any optional elements or attributes for which the XML schema defines default values, then those elements or attributes are included in the output with their default values. If you specify HIDE DEFAULTS, then no such elements or attributes are included in the output. HIDE DEFAULTS is the default behavior.
**See Also:** **
- Oracle XML DB Developer’s Guide for more information on this function
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of XMLSERIALIZE
## Examples
The following statement uses the `DUAL` table to illustrate the syntax of `XMLSerialize`:
```
SELECT XMLSERIALIZE(CONTENT XMLTYPE('Grandco')) AS xmlserialize_doc
   FROM DUAL;
XMLSERIALIZE_DOC
----------------
Grandco
```
