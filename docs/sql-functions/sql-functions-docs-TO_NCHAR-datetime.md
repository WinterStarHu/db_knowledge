# TO_NCHAR (datetime)

## Syntax
## *to_nchar_date*::=
Description of the illustration to_nchar_date.gif Description of the illustration to_nchar_date.eps
## Purpose
`TO_NCHAR` (datetime) converts a datetime or interval value of `DATE`, `TIMESTAMP`, `TIMESTAMP` `WITH` `TIME` `ZONE`, `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`, `INTERVAL` `MONTH` `TO` `YEAR`, or `INTERVAL` `DAY` `TO` `SECOND` data type from the database character set to the national character set.
**See Also:**
- “Security Considerations for Data Conversion”
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of this function
## Examples
The following example converts the `order_date` of all orders whose status is `9` to the national character set:
```
SELECT TO_NCHAR(ORDER_DATE) AS order_date
   FROM ORDERS
   WHERE ORDER_STATUS > 9
   ORDER BY order_date;
ORDER_DATE
--------------------------------------------------------------------------
06-DEC-99 02.22.34.225609 PM
13-SEP-99 10.19.00.654279 AM
14-SEP-99 09.53.40.223345 AM
26-JUN-00 10.19.43.190089 PM
27-JUN-00 09.53.32.335522 PM
```
