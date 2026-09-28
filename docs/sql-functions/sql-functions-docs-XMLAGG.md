# XMLAGG

## Syntax
Description of the illustration xmlagg.gif Description of the illustration xmlagg.eps
## Purpose
`XMLAgg` is an aggregate function. It takes a collection of XML fragments and returns an aggregated XML document. Any arguments that return null are dropped from the result.
`XMLAgg` is similar to `SYS_XMLAgg` except that `XMLAgg` returns a collection of nodes but it does not accept formatting using the `XMLFormat` object. Also, `XMLAgg` does not enclose the output in an element tag as does `SYS_XMLAgg`.
Within the *order_by_clause*, Oracle Database does not interpret number literals as column positions, as it does in other uses of this clause, but simply as number literals.
**See Also:**   XMLELEMENT and SYS_XMLAGG
## Examples
The following example produces a `Department` element containing `Employee` elements with employee job ID and last name as the contents of the elements:
```
SELECT XMLELEMENT("Department",
   XMLAGG(XMLELEMENT("Employee",
   e.job_id||' '||e.last_name)
   ORDER BY last_name))
   as "Dept_list"
   FROM employees e
   WHERE e.department_id = 30;
Dept_list
-------------------------------------------------------------
PU_CLERK Baida
PU_CLERK Colmenares
PU_CLERK Himuro
PU_CLERK Khoo
PU_MAN Raphaely
PU_CLERK Tobias
```
The result is a single row, because `XMLAgg` aggregates the rows. You can use the `GROUP` `BY` clause to group the returned set of rows into multiple groups:
```
SELECT XMLELEMENT("Department",
      XMLAGG(XMLELEMENT("Employee", e.job_id||' '||e.last_name)))
   AS "Dept_list"
   FROM employees e
   GROUP BY e.department_id;
Dept_list
---------------------------------------------------------
AD_ASST Whalen
MK_MAN Hartstein
MK_REP Fay
PU_MAN Raphaely
PU_CLERK Khoo
PU_CLERK Tobias
PU_CLERK Baida
PU_CLERK Colmenares
PU_CLERK Himuro
. . .
```
