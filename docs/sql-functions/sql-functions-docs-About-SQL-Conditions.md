# About SQL Conditions

Conditions can have several forms, as shown in the following syntax.
## *condition*::=
Description of the illustration condition.gif Description of the illustration condition.eps If you have installed Oracle Text, then you can create conditions with the built-in operators that are part of that product, including `CONTAINS`, `CATSEARCH`, and `MATCHES`. For more information on these Oracle Text elements, refer to *Oracle Text Reference*.
The sections that follow describe the various forms of conditions. You must use appropriate condition syntax whenever *condition* appears in SQL statements.
You can use a condition in the `WHERE` clause of these statements:
- DELETE
- SELECT
- UPDATE
You can use a condition in any of these clauses of the `SELECT` statement:
- WHERE
````
- START WITH
````
- CONNECT BY
- HAVING
A condition could be said to be of a logical data type, although Oracle Database does not formally support such a data type.
The following simple condition always evaluates to `TRUE`:
```
1 = 1
```
The following more complex condition adds the `salary` value to the `commission_pct` value (substituting the value 0 for null) and determines whether the sum is greater than the number constant 25000:
```
NVL(salary, 0) + NVL(salary + (salary*commission_pct, 0) > 25000)
```
Logical conditions can combine multiple conditions into a single condition. For example, you can use the `AND` condition to combine two conditions:
```
(1 = 1) AND (5 < 7)
```
Here are some valid conditions:
```
name = 'SMITH'
employees.department_id = departments.department_id
hire_date > '01-JAN-08'
job_id IN ('SA_MAN', 'SA_REP')
salary BETWEEN 5000 AND 10000
commission_pct IS NULL AND salary = 2100
```
Oracle Database does not accept all conditions in all parts of all SQL statements. Refer to the section devoted to a particular SQL statement in this book for information on restrictions on the conditions in that statement.
## Condition Precedence
**Precedence** is the order in which Oracle Database evaluates different conditions in the same expression. When evaluating an expression containing multiple conditions, Oracle evaluates conditions with higher precedence before evaluating those with lower precedence. Oracle evaluates conditions with equal precedence from left to right within an expression, with the following exceptions:
- Left to right evaluation is not guaranteed for multiple conditions connected using AND
- Left to right evaluation is not guaranteed for multiple conditions connected using OR
Table 6-1 lists the levels of precedence among SQL condition from high to low. Conditions listed on the same line have the same precedence. As the table indicates, Oracle evaluates operators before conditions.
Table 1 SQL Condition Precedence

| Type of Condition | Purpose |
|---|---|
| SQL operators are evaluated before SQL conditions | See Operator Precedence |
| =, !=, , =, | comparison |
| IS [NOT] NULL, LIKE, [NOT] BETWEEN, [NOT] IN, EXISTS, IS OFtype | comparison |
| NOT | exponentiation, logical negation |
| AND | conjunction |
| OR | disjunction |
