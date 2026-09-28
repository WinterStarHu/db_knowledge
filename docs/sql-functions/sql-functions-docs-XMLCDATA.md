# XMLCDATA

## Syntax
Description of the illustration xmlcdata.gif Description of the illustration xmlcdata.eps
## Purpose
`XMLCData` generates a CDATA section by evaluating *value_expr*. The *value_expr* must resolve to a string. The value returned by the function takes the following form:
```
```
If the resulting value is not a valid XML CDATA section, then the function returns an error.The following conditions apply to `XMLCData`:
**
- The value_expr cannot contain the substring ]]>.
********
- If value_expr evaluates to null, then the function returns null. See Also: Oracle XML DB Developer’s Guide for more information on this function
## Examples
The following statement uses the `DUAL` table to illustrate the syntax of `XMLCData`:
```
SELECT XMLELEMENT("PurchaseOrder",
   XMLAttributes(dummy as "pono"),
   XMLCdata('<!DOCTYPE po_dom_group [
   ]>')) "XMLCData" FROM DUAL;
XMLCData
----------------------------------------------------------
<![CDATA[
<!DOCTYPE po_dom_group [
   ]>
  ]]>
```
