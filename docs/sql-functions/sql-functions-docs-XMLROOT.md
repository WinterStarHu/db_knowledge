# XMLROOT

**Note:**   The `XMLROOT` function is deprecated. It is still supported for backward compatibility. However, Oracle recommends that you instead use the SQL/XML function `XMLSERIALIZE` with a version number. See *Oracle XML DB Developer’s Guide* for more information on the `XMLSERIALIZE` function.
## Syntax
Description of the illustration xmlroot.gif Description of the illustration xmlroot.eps
## Purpose
`XMLROOT` lets you create a new XML value by providing version and standalone properties in the XML root information (prolog) of an existing XML value. If the *value_expr* already has a prolog, then the database returns an error. If the input is null, then the function returns null.
The value returned takes the following form:
```
```
**
- The first value_expr specifies the XML value for which you are providing prolog information.
**``````
- In the VERSION clause, value_expr must resolve to a string representing a valid XML version. If you specify NO VALUE for VERSION, then the version defaults to 1.0.
``````
- If you omit the optional STANDALONE clause, or if you specify it with NO VALUE, then the standalone property is absent from the value returned by the function.
## Examples
The following statement uses the `DUAL` table to illustrate the syntax of `XMLROOT`:
```
SELECT XMLROOT ( XMLType('143598'), VERSION '1.0', STANDALONE YES) AS "XMLROOT" FROM DUAL;
XMLROOT
--------------------------------------------------------------------------------
143598
```
