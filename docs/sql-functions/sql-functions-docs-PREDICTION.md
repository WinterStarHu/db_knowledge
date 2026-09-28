# PREDICTION

## Syntax
## *prediction*::=
Description of the illustration prediction.eps
## Analytic Syntax
## *prediction_analytic*::=
Description of the illustration prediction_analytic.gif Description of the illustration prediction_analytic.eps
## *cost_matrix_clause*::=
Description of the illustration cost_matrix_clause.gif Description of the illustration cost_matrix_clause.eps
## *mining_attribute_clause*::=
Description of the illustration mining_attribute_clause.gif Description of the illustration mining_attribute_clause.eps
## *mining_analytic_clause*::=
Description of the illustration mining_analytic_clause.gif Description of the illustration mining_analytic_clause.eps **See Also:**   “Analytic Functions” for information on the syntax, semantics, and restrictions of *mining_analytic_clause*
## Purpose
`PREDICTION` returns a prediction for each row in the selection. The data type of the returned prediction depends on whether the function performs Regression, Classification, or Anomaly Detection.
****
- Regression: Returns the expected target value for each row. The data type of the return value is the data type of the target.
****
- Classification: Returns the most probable target class (or lowest cost target class, if costs are specified) for each row. The data type of the return value is the data type of the target.
****````
  - Rows that differ significantly from the rest of the data are classified as 0.
## cost_matrix_clause
Costs are a biasing factor for minimizing the most harmful kinds of misclassifications. You can specify *cost_matrix_clause* for Classification or Anomaly Detection. Costs are not relevant for Regression. The *cost_matrix_clause* behaves as described for “PREDICTION_COST”.
## Syntax Choice
`PREDICTION` can score data in one of two ways: It can apply a mining model object to the data, or it can dynamically score the data by executing an analytic clause that builds and applies one or more transient mining models. Choose **Syntax** or **Analytic Syntax**:
****
- Syntax: Use this syntax to score the data with a pre-defined model. Supply the name of a model that performs Classification, Regression, or Anomaly Detection.
************ ****
  - For Regression, specify FOR expr, where expr is an expression that identifies a target column that has a numeric data type.
****
  - For Classification, specify FOR expr, where expr is an expression that identifies a target column that has a character data type.
  - For Anomaly Detection, specify the keywords OF ANOMALY.
The syntax of the `PREDICTION` function can use an optional `GROUPING` hint when scoring a partitioned model. See GROUPING Hint.
## mining_attribute_clause
*mining_attribute_clause* identifies the column attributes to use as predictors for scoring.
- If you specify USING *, all the relevant attributes present in the input row are used.
**
- If you invoke the function with the analytic syntax, the mining_attribute_clause is used both for building the transient models and for scoring.
** **
  - If mining_attribute_clause includes an attribute with the same name but a different data type from the one that was used to create the model, then the data type is converted to the type expected by the model.
  - If you specify more attributes for scoring than were used to create the model, then the extra attributes are silently ignored.
**** **
  - Oracle Data Mining User’s Guide for information about scoring.
**
  - Oracle Data Mining Concepts for information about predictive data mining.
**
  - in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the return value of PREDICTION when it is a character value
**Note:**   The following examples are excerpted from the Data Mining sample programs. For more information about the sample programs, see in *Oracle Data Mining User’s Guide*.
## Example
In this example, the model `dt_sh_clas_sample` predicts the gender and age of customers who are most likely to use an affinity card (target = 1). The `PREDICTION` function takes into account the cost matrix associated with the model and uses marital status, education, and household size as predictors.
```
SELECT cust_gender, COUNT(*) AS cnt, ROUND(AVG(age)) AS avg_age
   FROM mining_data_apply_v
   WHERE PREDICTION(dt_sh_clas_sample COST MODEL
      USING cust_marital_status, education, household_size) = 1
   GROUP BY cust_gender
   ORDER BY cust_gender;
CUST_GENDER         CNT    AVG_AGE
------------ ---------- ----------
F                   170         38
M                   685         42
```
The cost matrix associated with the model `dt_sh_clas_sample` is stored in the table `dt_sh_sample_costs`. The cost matrix specifies that the misclassification of 1 is 8 times more costly than the misclassification of 0.
```
SQL> select * from dt_sh_sample_cost;
ACTUAL_TARGET_VALUE PREDICTED_TARGET_VALUE         COST
------------------- ---------------------- ------------
                  0                      0   .000000000
                  0                      1  1.000000000
                  1                      0  8.000000000
                  1                      1   .000000000
```
## Analytic Example
In this example, dynamic regression is used to predict the age of customers who are likely to use an affinity card. The query returns the 3 customers whose predicted age is most different from the actual. The query includes information about the predictors that have the greatest influence on the prediction.
```
SELECT cust_id, age, pred_age, age-pred_age age_diff, pred_det FROM
   (SELECT cust_id, age, pred_age, pred_det,
          RANK() OVER (ORDER BY ABS(age-pred_age) desc) rnk FROM
   (SELECT cust_id, age,
           PREDICTION(FOR age USING *) OVER () pred_age,
           PREDICTION_DETAILS(FOR age ABS USING *) OVER () pred_det
    FROM mining_data_apply_v))
  WHERE rnk <= 3;
CUST_ID  AGE PRED_AGE AGE_DIFF PRED_DET
------- ---- -------- -------- -------- ----------------------------------------------------------
 100910   80    40.67    39.33
 101285    79   42.18    36.82
 100694     77  41.04    35.96
```
