# TO_TIMESTAMP_TZ

## Syntax
Description of the illustration to_timestamp_tz.gif Description of the illustration to_timestamp_tz.eps
## Purpose
`TO_TIMESTAMP_TZ` converts *char* to a value of `TIMESTAMP` `WITH` `TIME` `ZONE` data type.
For *char*, you can specify any expression that evaluates to a character string of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type.
**Note:**   This function does not convert character strings to `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE`. To do this, use a `CAST` function, as shown in CAST.
The optional `DEFAULT` *return_value* `ON` `CONVERSION` `ERROR` clause allows you to specify the value this function returns if an error occurs while converting *char* to `TIMESTAMP` `WITH` `TIME` `ZONE`. This clause has no effect if an error occurs while evaluating *char*. The *return_value* can be an expression or a bind variable, and it must evaluate to a character string of `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2` data type, or null. The function converts *return_value* to `TIMESTAMP` `WITH` `TIME` `ZONE` using the same method it uses to convert *char* to `TIMESTAMP` `WITH` `TIME` `ZONE`. If *return_value* cannot be converted to `TIMESTAMP` `WITH` `TIME` `ZONE`, then the function returns an error.
The optional *fmt* specifies the format of *char*. If you omit *fmt*, then *char* must be in the default format of the `TIMESTAMP` `WITH` `TIME` `ZONE` data type. The optional *‘nlsparam’* has the same purpose in this function as in the `TO_CHAR` function for date conversion.
## Examples
The following example converts a character string to a value of `TIMESTAMP` `WITH` `TIME` `ZONE`:
```
SELECT TO_TIMESTAMP_TZ('1999-12-01 11:00:00 -8:00',
   'YYYY-MM-DD HH:MI:SS TZH:TZM') FROM DUAL;
TO_TIMESTAMP_TZ('1999-12-0111:00:00-08:00','YYYY-MM-DDHH:MI:SSTZH:TZM')
--------------------------------------------------------------------
01-DEC-99 11.00.00.000000000 AM -08:00
```
The following example casts a null column in a `UNION` operation as `TIMESTAMP` `WITH` `LOCAL` `TIME` `ZONE` using the sample tables `oe.order_items` and `oe.orders`:
```
SELECT order_id, line_item_id,
   CAST(NULL AS TIMESTAMP WITH LOCAL TIME ZONE) order_date
   FROM order_items
UNION
SELECT order_id, to_number(null), order_date
   FROM orders;
  ORDER_ID LINE_ITEM_ID ORDER_DATE
---------- ------------ -----------------------------------
      2354            1
      2354            2
      2354            3
      2354            4
      2354            5
      2354            6
      2354            7
      2354            8
      2354            9
      2354           10
      2354           11
      2354           12
      2354           13
      2354              14-JUL-00 05.18.23.234567 PM
      2355            1
      2355            2
. . .
```
The following example returns the default value of NULL because the specified expression cannot be converted to a `TIMESTAMP` `WITH` `TIME` `ZONE` value, due to an invalid month specification:
```
SELECT TO_TIMESTAMP_TZ('1999-13-01 11:00:00 -8:00'
       DEFAULT NULL ON CONVERSION ERROR,
       'YYYY-MM-DD HH:MI:SS TZH:TZM') "Value"
  FROM DUAL;
```
