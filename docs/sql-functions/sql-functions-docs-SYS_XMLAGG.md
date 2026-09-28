# SYS_XMLAGG

## Syntax
Description of the illustration sys_xmlagg.gif Description of the illustration sys_xmlagg.eps
## Purpose
`SYS_XMLAgg` aggregates all of the XML documents or fragments represented by *expr* and produces a single XML document. It adds a new enclosing element with a default name `ROWSET`. If you want to format the XML document differently, then specify *fmt*, which is an instance of the `XMLFormat` object.
**See Also:**   SYS_XMLGEN and “XML Format Model” for using the attributes of the `XMLFormat` type to format `SYS_XMLAgg` results
## Examples
The following example uses the `SYS_XMLGen` function to generate an XML document for each row of the sample table `employees` where the employee’s last name begins with the letter R, and then aggregates all of the rows into a single XML document in the default enclosing element `ROWSET`:
```
SELECT SYS_XMLAGG(SYS_XMLGEN(last_name)) XMLAGG
   FROM employees
   WHERE last_name LIKE 'R%'
   ORDER BY xmlagg;
XMLAGG
--------------------------------------------------------------------------------
Rajs
Raphaely
Rogers
Russell
```
