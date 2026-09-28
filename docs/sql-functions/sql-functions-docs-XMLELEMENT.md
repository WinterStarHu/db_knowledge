# XMLELEMENT

## Syntax
Description of the illustration xmlelement.gif Description of the illustration xmlelement.eps
## *XML_attributes_clause*::=
Description of the illustration xml_attributes_clause.gif Description of the illustration xml_attributes_clause.eps
## Purpose
`XMLElement` takes an element name for *identifier* or evaluates an element name for `EVALNAME` *value_expr*, an optional collection of attributes for the element, and arguments that make up the content of the element. It returns an instance of type `XMLType`. `XMLElement` is similar to `SYS_XMLGen` except that `XMLElement` can include attributes in the XML returned, but it does not accept formatting using the `XMLFormat` object.
The `XMLElement` function is typically nested to produce an XML document with a nested structure, as in the example in the following section.
For an explanation of the `ENTITYESCAPING` and `NONENTITYESCAPING` keywords, refer to *Oracle XML DB Developer’s Guide*.
You must specify a value for Oracle Database to use an the enclosing tag. You can do this by specifying *identifier*, which is a string literal, or by specifying `EVALNAME` *value_expr*. In the latter case, the value expression is evaluated and the result, which must be a string literal, is used as the identifier. The identifier does not have to be a column name or column reference. It cannot be an expression or null. It can be up to 4000 characters if the initialization parameter `MAX_STRING_SIZE` `=` `STANDARD`, and 32767 characters if `MAX_STRING_SIZE` `=` `EXTENDED`.
The objects that make up the element content follow the `XMLATTRIBUTES` keyword. In the *XML_attributes_clause*, if the *value_expr* is null, then no attribute is created for that value expression. The type of *value_expr* cannot be an object type or collection. If you specify an alias for *value_expr* using the `AS` clause, then the *c_alias* or the evaluated value expression (`EVALNAME` *value_expr*) can be up to 4000 characters if the initialization parameter `MAX_STRING_SIZE` `=` `STANDARD`, and 32767 characters if `MAX_STRING_SIZE` `=` `EXTENDED`.
**See Also:**   “Extended Data Types” for more information on `MAX_STRING_SIZE` For the optional *value_expr* that follows the *XML_attributes_clause* in the diagram:
**
- If value_expr is a scalar expression, then you can omit the AS clause, and Oracle uses the column name as the element name.
****
- If value_expr is an object type or collection, then the AS clause is mandatory, and Oracle uses the specified c_alias as the enclosing tag.
** ****
- If value_expr is null, then no element is created for that value expression. See Also: SYS_XMLGEN
## Examples
The following example produces an `Emp` element for a series of employees, with nested elements that provide the employee’s name and hire date:
```
SELECT XMLELEMENT("Emp", XMLELEMENT("Name",
   e.job_id||' '||e.last_name),
   XMLELEMENT("Hiredate", e.hire_date)) as "Result"
   FROM employees e WHERE employee_id > 200;
Result
-------------------------------------------------------------------
MK_MAN Hartstein
2004-02-17
MK_REP Fay
2005-08-17
HR_REP Mavris
2002-06-07
PR_REP Baer
2002-06-07
AC_MGR Higgins
2002-06-07
AC_ACCOUNT Gietz
2002-06-07
6 rows selected.
```
The following similar example uses the `XMLElement` function with the *XML_attributes_clause* to create nested XML elements with attribute values for the top-level element:
```
SELECT XMLELEMENT("Emp",
      XMLATTRIBUTES(e.employee_id AS "ID", e.last_name),
      XMLELEMENT("Dept", e.department_id),
      XMLELEMENT("Salary", e.salary)) AS "Emp Element"
   FROM employees e
   WHERE e.employee_id = 206;
Emp Element
---------------------------------------------------------------
110
8300
```
Notice that the `AS` *identifier* clause was not specified for the `last_name` column. As a result, the XML returned uses the column name `last_name` as the default.
Finally, the next example uses a subquery within the *XML_attributes_clause* to retrieve information from another table into the attributes of an element:
```
SELECT XMLELEMENT("Emp", XMLATTRIBUTES(e.employee_id, e.last_name),
   XMLELEMENT("Dept", XMLATTRIBUTES(e.department_id,
   (SELECT d.department_name FROM departments d
   WHERE d.department_id = e.department_id) as "Dept_name")),
   XMLELEMENT("salary", e.salary),
   XMLELEMENT("Hiredate", e.hire_date)) AS "Emp Element"
   FROM employees e
   WHERE employee_id = 205;
Emp Element
-------------------------------------------------------------------

12008
2002-06-07
```
