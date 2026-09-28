# XMLFOREST

## Syntax
Description of the illustration xmlforest.gif Description of the illustration xmlforest.eps
## Purpose
`XMLForest` converts each of its argument parameters to XML, and then returns an XML fragment that is the concatenation of these converted arguments.
**
- If value_expr is a scalar expression, then you can omit the AS clause, and Oracle Database uses the column name as the element name.
** ****````````````
- If value_expr is an object type or collection, then the AS clause is mandatory, and Oracle uses the specified expression as the enclosing tag. You can do this by specifying c_alias, which is a string literal, or by specifying EVALNAME value_expr. In the latter case, the value expression is evaluated and the result, which must be a string literal, is used as the identifier. The identifier does not have to be a column name or column reference. It cannot be an expression or null. It can be up to 4000 characters if the initialization parameter MAX_STRING_SIZE = STANDARD, and 32767 characters if MAX_STRING_SIZE = EXTENDED. See “Extended Data Types” for more information.
****
- If value_expr is null, then no element is created for that value_expr.
## Examples
The following example creates an `Emp` element for a subset of employees, with nested `employee_id`, `last_name`, and `salary` elements as the contents of `Emp`:
```
SELECT XMLELEMENT("Emp",
   XMLFOREST(e.employee_id, e.last_name, e.salary))
   "Emp Element"
   FROM employees e WHERE employee_id = 204;
Emp Element
----------------------------------------------------------------
204
Baer
10000
```
Refer to the example for XMLCOLATTVAL to compare the output of these two functions.
