# FEATURE_DETAILS

## Syntax
## *feature_details*::=
Description of the illustration feature_details.gif Description of the illustration feature_details.eps
## Analytic Syntax
## *feature_details_analytic*::=
Description of the illustration feature_details_analytic.gif Description of the illustration feature_details_analytic.eps
## *mining_attribute_clause*::=
Description of the illustration mining_attribute_clause.gif Description of the illustration mining_attribute_clause.eps
## *mining_analytic_clause*::=
Description of the illustration mining_analytic_clause.gif Description of the illustration mining_analytic_clause.eps **See Also:**   “Analytic Functions” for information on the syntax, semantics, and restrictions of *mining_analytic_clause*
## Purpose
`FEATURE_DETAILS` returns feature details for each row in the selection. The return value is an XML string that describes the attributes of the highest value feature or the specified *feature_id*.
## topN
If you specify a value for *topN*, the function returns the *N* attributes that most influence the feature value. If you do not specify *topN*, the function returns the 5 most influential attributes.
## DESC, ASC, or ABS
The returned attributes are ordered by weight. The weight of an attribute expresses its positive or negative impact on the value of the feature. A positive weight indicates a higher feature value. A negative weight indicates a lower feature value.
By default, `FEATURE_DETAILS` returns the attributes with the highest positive weight (`DESC`). If you specify `ASC`, the attributes with the highest negative weight are returned. If you specify `ABS`, the attributes with the greatest weight, whether negative or positive, are returned. The results are ordered by absolute value from highest to lowest. Attributes with a zero weight are not included in the output.
## Syntax Choice
`FEATURE_DETAILS` can score the data in one of two ways: It can apply a mining model object to the data, or it can dynamically mine the data by executing an analytic clause that builds and applies one or more transient mining models. Choose **Syntax** or **Analytic Syntax**:
****
- Syntax — Use the first syntax to score the data with a pre-defined model. Supply the name of a feature extraction model.
****************
- Analytic Syntax — Use the analytic syntax to score the data without a pre-defined model. Include INTO n, where n is the number of features to extract, and mining_analytic_clause, which specifies if the data should be partitioned for multiple model builds. The mining_analytic_clause supports a query_partition_clause and an order_by_clause. (See “analytic_clause::=”.)
The syntax of the `FEATURE_DETAILS` function can use an optional `GROUPING` hint when scoring a partitioned model. See GROUPING Hint.
## mining_attribute_clause
*mining_attribute_clause* identifies the column attributes to use as predictors for scoring. When the function is invoked with the analytic syntax, these predictors are also used for building the transient models. The *mining_attribute_clause* behaves as described for the `PREDICTION` function. (See “mining_attribute_clause::=”.) **See Also:** **
- Oracle Data Mining User’s Guide for information about scoring.
**
- Oracle Data Mining Concepts for information about feature extraction.
**Note:**   The following examples are excerpted from the Data Mining sample programs. For more information about the sample programs, see in *Oracle Data Mining User’s Guide*.
## Example
This example uses the feature extraction model `nmf_sh_sample` to score the data. The query returns the three features that best represent customer 100002 and the attributes that most affect those features.
```
SELECT S.feature_id fid, value val,
       FEATURE_DETAILS(nmf_sh_sample, S.feature_id, 5 using T.*) det
   FROM
     (SELECT v.*, FEATURE_SET(nmf_sh_sample, 3 USING *) fset
         FROM mining_data_apply_v v
         WHERE cust_id = 100002) T,
   TABLE(T.fset) S
ORDER BY 2 DESC;
 FID    VAL  DET
---- ------  ------------------------------------------------------------------------------------
   5  3.492
   3  1.928
   8   .816
```
## Analytic Example
This example dynamically maps customer attributes into six features and returns the feature mapping for customer 100001.
```
SELECT feature_id, value
  FROM (
     SELECT cust_id, feature_set(INTO 6 USING *) OVER () fset
        FROM mining_data_apply_v),
  TABLE (fset)
  WHERE cust_id = 100001
  ORDER BY feature_id;
FEATURE_ID    VALUE
---------- --------
         1    2.670
         2     .000
         3    1.792
         4     .000
         5     .000
         6    3.379
```
