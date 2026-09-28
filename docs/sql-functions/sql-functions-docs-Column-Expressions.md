# Column Expressions

A column expression, which is designated as *column_expression* in subsequent syntax diagrams, is a limited form of *expr*. A column expression can be a simple expression, compound expression, function expression, or expression list, but it can contain only the following forms of expression:
- Columns of the subject table — the table being created, altered, or indexed
- Constants (strings or numbers)
- Deterministic functions — either SQL built-in functions or user-defined functions
No other expression forms described in this chapter are valid. In addition, compound expressions using the `PRIOR` keyword are not supported, nor are aggregate functions.
You can use a column expression for these purposes:
- To create a function-based index.
**
- To explicitly or implicitly define a virtual column. When you define a virtual column, the defining column_expression must refer only to columns of the subject table that have already been defined, in the current statement or in a prior statement.
The combined components of a column expression must be deterministic. That is, the same set of input values must return the same set of output values.
**See Also:**   Simple Expressions, Compound Expressions, Function Expressions, and Expression Lists for information on these forms of *expr*
