# Arithmetic Operators

You can use an arithmetic operator with one or two arguments to negate, add, subtract, multiply, and divide numeric values. Some of these operators are also used in datetime and interval arithmetic. The arguments to the operator must resolve to numeric data types or to any data type that can be implicitly converted to a numeric data type.
Unary arithmetic operators return the same data type as the numeric data type of the argument. For binary arithmetic operators, Oracle determines the argument with the highest numeric precedence, implicitly converts the remaining arguments to that data type, and returns that data type. Table 4-2 lists arithmetic operators.
**See Also:**   Table 2-8 for more information on implicit conversion, Numeric Precedence for information on numeric precedence, and Datetime/Interval Arithmetic Table 2 Arithmetic Operators

| Operator | Purpose | Example |
|---|---|---|
| + - | When these denote a positive or negative expression, they are unary operators. | SELECT * FROM order_items WHERE quantity = -1 ORDER BY order_id, line_item_id, product_id; SELECT * FROM employees WHERE -salary < 0 ORDER BY employee_id; |
| + - | When they add or subtract, they are binary operators. | SELECT hire_date FROM employees WHERE SYSDATE - hire_date > 365 ORDER BY hire_date; |
| * / | Multiply, divide. These are binary operators. | UPDATE employees SET salary = salary * 1.1; |

Do not use two consecutive minus signs (–) in arithmetic expressions to indicate double negation or the subtraction of a negative value. The characters – are used to begin comments within SQL statements. You should separate consecutive minus signs with a space or parentheses. Refer to Comments for more information on comments within SQL statements.
