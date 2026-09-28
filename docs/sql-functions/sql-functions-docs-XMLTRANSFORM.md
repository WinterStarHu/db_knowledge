# XMLTRANSFORM

## Syntax
Description of the illustration xmltransform.gif Description of the illustration xmltransform.eps
## Purpose
`XMLTransform` takes as arguments an `XMLType` instance and an XSL style sheet, which is itself a form of `XMLType` instance. It applies the style sheet to the instance and returns an `XMLType`.
This function is useful for organizing data according to a style sheet as you are retrieving it from the database.
**See Also:**   *Oracle XML DB Developer’s Guide* for more information on this function
## Examples
The `XMLTransform` function requires the existence of an XSL style sheet. Here is an example of a very simple style sheet that alphabetizes elements within a node:
```
CREATE TABLE xsl_tab (col1 XMLTYPE);
INSERT INTO xsl_tab VALUES (
   XMLTYPE.createxml(
   '
'));
1 row created.
```
The next example uses the `xsl_tab` XSL style sheet to alphabetize the elements in one `warehouse_spec` of the sample table `oe.warehouses`:
```
SELECT XMLTRANSFORM(w.warehouse_spec, x.col1).GetClobVal()
   FROM warehouses w, xsl_tab x
   WHERE w.warehouse_name = 'San Francisco';
XMLTRANSFORM(W.WAREHOUSE_SPEC,X.COL1).GETCLOBVAL()
--------------------------------------------------------------------------------
50000
Rented
Side load
Lot
12 ft
```
