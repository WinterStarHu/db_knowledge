# TAN

## Syntax
Description of the illustration tan.gif Description of the illustration tan.eps
## Purpose
`TAN` returns the tangent of *n* (an angle expressed in radians).
This function takes as an argument any numeric data type or any nonnumeric data type that can be implicitly converted to a numeric data type. If the argument is `BINARY_FLOAT`, then the function returns `BINARY_DOUBLE`. Otherwise the function returns the same numeric data type as the argument.
**See Also:**   Table 2-8 for more information on implicit conversion
## Examples
The following example returns the tangent of 135 degrees:
```
SELECT TAN(135 * 3.14159265359/180)
   "Tangent of 135 degrees"  FROM DUAL;
Tangent of 135 degrees
----------------------
                   - 1
```
