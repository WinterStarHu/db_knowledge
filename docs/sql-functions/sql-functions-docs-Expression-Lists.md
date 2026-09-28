# Expression Lists

An expression list is a combination of other expressions.
## *expression_list*::=
Description of the illustration expression_list.gif Description of the illustration expression_list.eps Expression lists can appear in comparison and membership conditions and in `GROUP` `BY` clauses of queries and subqueries. An expression lists in a comparision or membership condition is sometimes referred to as a **row value constructor** or **row constructor**.
Comparison and membership conditions appear in the conditions of `WHERE` clauses. They can contain either one or more comma-delimited expressions or one or more sets of expressions where each set contains one or more comma-delimited expressions. In the latter case (multiple sets of expressions):
- Each set is bounded by parentheses
- Each set must contain the same number of expressions
- The number of expressions in each set must match the number of expressions before the operator in the comparison condition or before the IN keyword in the membership condition.
A comma-delimited list of expressions can contain no more than 1000 expressions. A comma-delimited list of sets of expressions can contain any number of sets, but each set can contain no more than 1000 expressions.
The following are some valid expression lists in conditions:
```
(10, 20, 40)
('SCOTT', 'BLAKE', 'TAYLOR')
( ('Guy', 'Himuro', 'GHIMURO'),('Karen', 'Colmenares', 'KCOLMENA') )
```
In the third example, the number of expressions in each set must equal the number of expressions in the first part of the condition. For example:
```
SELECT * FROM employees
  WHERE (**first_name, last_name, email**) IN
  **(('Guy', 'Himuro', 'GHIMURO'),('Karen', 'Colmenares', 'KCOLMENA'))**
```
**See Also:**   Comparison Conditions and IN Condition conditions In a simple `GROUP` `BY` clause, you can use either the upper or lower form of expression list:
```
SELECT department_id, MIN(salary) min, MAX(salary) max FROM employees
   GROUP BY department_id, salary
   ORDER BY department_id, min, max;
SELECT department_id, MIN(salary) min, MAX(salary) max FROM employees
   GROUP BY (department_id, salary)
   ORDER BY department_id, min, max;
```
In `ROLLUP`, `CUBE`, and `GROUPING` `SETS` clauses of `GROUP` `BY` clauses, you can combine individual expressions with sets of expressions in the same expression list. The following example shows several valid grouping sets expression lists in one SQL statement:
```
SELECT
prod_category, prod_subcategory, country_id, cust_city, count(*)
   FROM  products, sales, customers
   WHERE sales.prod_id = products.prod_id
   AND sales.cust_id=customers.cust_id
   AND sales.time_id = '01-oct-00'
   AND customers.cust_year_of_birth BETWEEN 1960 and 1970
GROUP BY GROUPING SETS
  (
   (**prod_category, prod_subcategory, country_id, cust_city**),
   (**prod_category, prod_subcategory, country_id**),
   (**prod_category, prod_subcategory**),
    **country_id**
  )
ORDER BY prod_category, prod_subcategory, country_id, cust_city;
```
**See Also:**   SELECT
