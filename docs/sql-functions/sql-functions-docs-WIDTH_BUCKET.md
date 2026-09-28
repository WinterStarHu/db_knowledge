# WIDTH_BUCKET

## Syntax
Description of the illustration width_bucket.gif Description of the illustration width_bucket.eps
## Purpose
`WIDTH_BUCKET` lets you construct equiwidth histograms, in which the histogram range is divided into intervals that have identical size. (Compare this function with `NTILE`, which creates equiheight histograms.) Ideally each bucket is a closed-open interval of the real number line. For example, a bucket can be assigned to scores between 10.00 and 19.999 … to indicate that 10 is included in the interval and 20 is excluded. This is sometimes denoted [10, 20).
For a given expression, `WIDTH_BUCKET` returns the bucket number into which the value of this expression would fall after being evaluated.
****
- expr is the expression for which the histogram is being created. This expression must evaluate to a numeric or datetime value or to a value that can be implicitly converted to a numeric or datetime value. If expr evaluates to null, then the expression returns null.
******
- min_value and max_value are expressions that resolve to the end points of the acceptable range for expr. Both of these expressions must also evaluate to numeric or datetime values, and neither can evaluate to null.
** ****
- num_buckets is an expression that resolves to a constant indicating the number of buckets. This expression must evaluate to a positive integer. See Also: Table 2-8 for more information on implicit conversion
When needed, Oracle Database creates an underflow bucket numbered 0 and an overflow bucket numbered *num_buckets*+1. These buckets handle values less than *min_value* and more than *max_value* and are helpful in checking the reasonableness of endpoints.
## Examples
The following example creates a ten-bucket histogram on the `credit_limit` column for customers in Switzerland in the sample table `oe.customers` and returns the bucket number (“Credit Group”) for each customer. Customers with credit limits greater than or equal to the maximum value are assigned to the overflow bucket, 11:
```
SELECT customer_id, cust_last_name, credit_limit,
   WIDTH_BUCKET(credit_limit, 100, 5000, 10) "Credit Group"
   FROM customers WHERE nls_territory = 'SWITZERLAND'
   ORDER BY "Credit Group", customer_id, cust_last_name, credit_limit;
CUSTOMER_ID CUST_LAST_NAME       CREDIT_LIMIT Credit Group
----------- -------------------- ------------ ------------
        825 Dreyfuss                      500            1
        826 Barkin                        500            1
        827 Siegel                        500            1
        853 Palin                         400            1
        843 Oates                         700            2
        844 Julius                        700            2
        835 Eastwood                     1200            3
        836 Berenger                     1200            3
        837 Stanton                      1200            3
        840 Elliott                      1400            3
        841 Boyer                        1400            3
        842 Stern                        1400            3
        848 Olmos                        1800            4
        849 Kaurusmdki                   1800            4
        828 Minnelli                     2300            5
        829 Hunter                       2300            5
        850 Finney                       2300            5
        851 Brown                        2300            5
        852 Tanner                       2300            5
        830 Dutt                         3500            7
        831 Bel Geddes                   3500            7
        832 Spacek                       3500            7
        833 Moranis                      3500            7
        834 Idle                         3500            7
        838 Nicholson                    3500            7
        839 Johnson                      3500            7
        845 Fawcett                      5000           11
        846 Brando                       5000           11
        847 Streep                       5000           11
```
