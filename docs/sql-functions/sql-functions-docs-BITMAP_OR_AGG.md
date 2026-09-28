# BITMAP_OR_AGG

## Syntax
Description of the illustration bitmap_or_agg.gif Description of the illustration bitmap_or_agg.eps
## Purpose
`BITMAP_OR_AGG` is an aggregation function that operates on bitmaps and computes the OR of its inputs.
The argument `expr` must be of type `BLOB`.
The return type is of type `BLOB`. It returns the bitmap representing the OR of all the bitmaps it has aggregated.
The output of `BITMAP_OR_AGG` is not human-readable. It is meant to be processed by further aggregations via `BITMAP_OR_AGG` or by the scalar function `BITMAP_COUNT`.
If `expr` is NULL, the function returns NULL.
**Restrictions** The argument must be of type `BLOB`type. The argument is expected to be a bitmap produced by `BITMAP_CONSTRUCT_AGG` or, recursively, by `BITMAP_OR_AGG`.Any other input results in `ORA-62578`:
```
62578, 00000, "The input is not a valid bitmap produced by BITMAP COUNT DISTINCT related operators."
// *Cause: An attempt was made to pass a bitmap that was not produced by one of the BITMAP COUNT DISTINCT operators.
// *Action: Only pass bitmaps constructed via BITMAP_CONSTRUCT_AGG or BITMAP_OR_AGG to BITMAP COUNT DISTINCT related operators.
```
