# SINH

## Syntax
Description of the illustration sinh.gif Description of the illustration sinh.eps
## Purpose
`SINH` returns the hyperbolic sine of *n*.
This function takes as an argument any numeric data type or any nonnumeric data type that can be implicitly converted to a numeric data type. If the argument is `BINARY_FLOAT`, then the function returns `BINARY_DOUBLE`. Otherwise the function returns the same numeric data type as the argument.
**See Also:**   Table 2-8 for more information on implicit conversion
## Examples
The following example returns the hyperbolic sine of 1:
```
SELECT SINH(1) "Hyperbolic sine of 1" FROM DUAL;
Hyperbolic sine of 1
--------------------
          1.17520119
```
