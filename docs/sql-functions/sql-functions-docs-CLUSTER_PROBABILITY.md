# CLUSTER_PROBABILITY

## Syntax
## *cluster_probability*::=
Description of the illustration cluster_probability.gif Description of the illustration cluster_probability.eps
## Analytic Syntax
## *cluster_prob_analytic*::=
Description of the illustration cluster_prob_analytic.gif Description of the illustration cluster_prob_analytic.eps
## *mining_attribute_clause*::=
Description of the illustration mining_attribute_clause.gif Description of the illustration mining_attribute_clause.eps
## *mining_analytic_clause*::=
Description of the illustration mining_analytic_clause.gif Description of the illustration mining_analytic_clause.eps **See Also:**   Analytic Functions for information on the syntax, semantics, and restrictions of *mining_analytic_clause*
## Purpose
`CLUSTER_PROBABILITY` returns a probability for each row in the selection. The probability refers to the highest probability cluster or to the specified *cluster_id*. The cluster probability is returned as `BINARY_DOUBLE`.
## Syntax Choice
`CLUSTER_PROBABILITY` can score the data in one of two ways: It can apply a mining model object to the data, or it can dynamically mine the data by executing an analytic clause that builds and applies one or more transient mining models. Choose **Syntax** or **Analytic Syntax**:
****
- Syntax — Use the first syntax to score the data with a pre-defined model. Supply the name of a clustering model.
**************
- Analytic Syntax — Use the analytic syntax to score the data without a pre-defined model. Include INTO n, where n is the number of clusters to compute, and mining_analytic_clause, which specifies if the data should be partitioned for multiple model builds. The mining_analytic_clause supports a query_partition_clause and an order_by_clause. (See analytic_clause::=.)
The syntax of the `CLUSTER_PROBABILITY` function can use an optional `GROUPING` hint when scoring a partitioned model. See GROUPING Hint.
## mining_attribute_clause
*mining_attribute_clause* identifies the column attributes to use as predictors for scoring. When the function is invoked with the analytic syntax, these predictors are also used for building the transient models. The *mining_attribute_clause* behaves as described for the `PREDICTION` function. (See mining_attribute_clause::=.) **See Also:** **
- Oracle Data Mining User’s Guide for information about scoring.
**
- Oracle Data Mining Concepts for information about clustering.
**Note:**   The following example is excerpted from the Data Mining sample programs. For more information about the sample programs, see in *Oracle Data Mining User’s Guide*.
## Example
The following example lists the ten most representative customers, based on likelihood, of cluster 2.
```
rank
```
