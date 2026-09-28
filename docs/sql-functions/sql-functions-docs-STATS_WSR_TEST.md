# STATS_WSR_TEST

## Syntax
Description of the illustration stats_wsr_test.gif Description of the illustration stats_wsr_test.eps
## Purpose
`STATS_WSR_TEST` is a Wilcoxon Signed Ranks test of paired samples to determine whether the median of the differences between the samples is significantly different from zero. The absolute values of the differences are ordered and assigned ranks. Then the null hypothesis states that the sum of the ranks of the positive differences is equal to the sum of the ranks of the negative differences.
This function takes two required arguments: *expr1* and *expr2* are the two samples being analyzed. The optional third argument lets you specify the meaning of the `NUMBER` value returned by this function, as shown in Table 7-10. For this argument, you can specify a text literal, or a bind variable or expression that evaluates to a constant character value. If you omit the third argument, then the default is `'TWO_SIDED_SIG'`.
Table 10 STATS_WSR_TEST_* Return Values

| Argument | Return Value Meaning |
|---|---|
| 'STATISTIC' | The observed value of Z |
| 'ONE_SIDED_SIG' | One-tailed significance of Z |
| 'TWO_SIDED_SIG' | Two-tailed significance of Z |

One-sided significance is always with respect to the upper tail. The high value (the value whose rejection region is the upper tail) is *expr1*.
