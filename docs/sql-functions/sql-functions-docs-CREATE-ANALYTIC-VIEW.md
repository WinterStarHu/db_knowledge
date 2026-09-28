# CREATE ANALYTIC VIEW

## Purpose
Use the `CREATE` `ANALYTIC` `VIEW` statement to create an analytic view. An analytic view specifies the source of its fact data and defines measures that describe calculations or other analytic operations to perform on the data. An analytic view also specifies the attribute dimensions and hierarchies that define the rows of the analytic view.
## Prerequisites
To create an analytic view in your own schema, you must have the `CREATE` `ANALYTIC` `VIEW` system privilege. To create an analytic view in another user’s schema, you must have the `CREATE` `ANY` `ANALYTIC` `VIEW` system privilege.
## Syntax
## *create_analytic_view*::=
Description of the illustration create_analytic_view.eps
## *classification_clause*::=
Description of the illustration classification_clause.eps
## *using_clause*::=
Description of the illustration using_clause.eps
## *dim_by_clause*::=
Description of the illustration dim_by_clause.eps
## *dim_key*::=
Description of the illustration dim_key.eps
## *dim_ref*::=
Description of the illustration dim_ref.eps
## *hier_ref*::=
Description of the illustration hier_ref.eps
## *measures_clause*::=
Description of the illustration measures_clause.eps
## *av_measure*::=
Description of the illustration av_measure.eps
## *base_measure_clause*::=
Description of the illustration base_measure_clause.eps
## *calc_measure_clause*::=
Description of the illustration calc_measure_clause.eps
## *meas_aggregate_clause*::=
Description of the illustration meas_aggregate_clause.eps
## *default_measure_clause*::=
Description of the illustration default_measure_clause.eps
## *default_aggregate_clause*::=
Description of the illustration default_aggregate_clause.eps
## *cache_clause*::=
Description of the illustration cache_clause.eps
## *cache_specification*::=
Description of the illustration cache_specification.eps
## *levels_clause*::=
Description of the illustration levels_clause.eps
## *level_specification*::=
Description of the illustration level_specification.eps
## Semantics
## OR REPLACE
Specify `OR` `REPLACE` to replace an existing definition of an analytic view with a different definition.
## FORCE and NOFORCE
Specify `FORCE` to force the creation of the analytic view even if it does not successfully compile. If you specify `NOFORCE`, then the analytic view must compile successfully, otherwise an error occurs. The default is `NOFORCE`.
## *schema*
Specify the schema in which to create the analytic view. If you do not specify a schema, then Oracle Database creates the analytic view in your own schema.
## IF NOT EXISTS
Specifying `IF NOT EXISTS` has the following effects:
- If the analytic view does not exist, a new one is created at the end of the statement.
- If the analytic view exists, it is detected and a new one is not created.
You can only specify `OR REPLACE` or `IF NOT EXISTS` in a statement at a time. Using both `OR REPLACE` with `IF NOT EXISTS` in the very same statement results in an error.
You cannot specify `IF EXISTS` with `CREATE` statements.
**Note:**   You can use `IF [NOT] EXISTS` only from Release 19.28 and up.
## *analytic_view*
Specify a name for the analytic view.
## SHARING
Use the sharing clause if you want to create the object in an application root in the context of an application maintenance. This type of object is called an application common object and it can be shared with the application PDBs that belong to the application root.
You can specify how the object is shared using one of the following sharing attributes:
- METADATA - A metadata link shares the metadata, but its data is unique to each container. This type of object is referred to as a metadata-linked application common object.
- NONE - The object is not shared and can only be accessed in the application root.
## *classification_clause*
Use the classification clause to specify values for the `CAPTION` or `DESCRIPTION` classifications and to specify user-defined classifications. Classifications provide descriptive metadata that applications may use to provide information about analytic views and their components.
You may specify any number of classifications for the same object. A classification can have a maximum length of 4000 bytes.
For the `CAPTION` and `DESCRIPTION` classifications, you may use the DDL shortcuts `CAPTION` `'`*caption*`'` and `DESCRIPTION` `'`*description*`'` or the full classification syntax.
You may vary the classification values by language. To specify a language for the `CAPTION` or `DESCRIPTION` classification, you must use the full syntax. If you do not specify a language, then the language value for the classification is `NULL`. The language value must either be `NULL` or a valid `NLS_LANGUAGE` value.
## *using_clause*
Specify a fact table or view. External and remote tables are permitted. You may specify a table or view in another schema. You can specify an alias for the table or view.
## *dim_by_clause*
Specify the attribute dimensions of the analytic view.
## *dim_key*
Specify an attribute dimension, columns of the fact table, columns of the attribute dimension, and hierarchies that are related in the analytic view.
With the `KEY` keyword, specify one or more columns in the fact table.
With the `REFERENCES` keyword, specify attributes of the attribute dimensions that the analytic view is dimensioned by. Each attribute must be a level key. The `DISTINCT` keyword supports the use of denormalized fact tables, in which the attribute dimension and fact data are in the same table. Use `REFERENCES` `DISTINCT` when an attribute dimension is defined using the fact table.
With the `HIERARCHIES` keyword, specify the hierarchies in the analytic view that use the attribute dimension.
## *dim_ref*
Specify an attribute dimension. You can specify an alias for an attribute dimension, which is required if you use the same dimension more than once or if you use multiple dimensions with the same name from different schemas.
## *hier_ref*
Specify a hierarchy. You can specify an alias for a hierarchy. You can specify one of the hierarchies in the list as the default. If you do not specify a default, the first hierarchy in the list is the default.
## *measures_clause*
Specify the measures for the analytic view.
## *av_measure*
Define a measure using either a single fact column or an expression over measures in this analytic view. A measure can be either a base measure or a calculated measure.
## *base_measure_clause*
Define a base measure by optionally specifying a fact column or a *meas_aggregate_clause*, or both. If you do not specify a fact column, then the analytic view uses the column of the fact table that has the same name as the measure. If a column by the same name does not exist, an error is raised.
## *calc_measure_clause*
Define a calculated measure by specifying an analytic view expression. The expression may reference other measures in the analytic view, but may not reference fact columns. Calculated measures do not have an aggregate clause because they’re computed over the aggregated base measures.
For the syntax and descriptions of analytic view expressions, see Analytic View Expressions.
## *default_measure_clause*
Specify a measure to use as the default measure for the analytic view. If you do not specify a measure, the first measure defined is the default.
## *meas_aggregate_clausè*
Specify a default aggregation operator for a base measure. If you do not specify an aggregation operator, then the operator specified by the *default_aggregate_clause* is used.
## *default_aggregate_clause*
Specify a default aggregation for all base measures in the analytic view. If you do not specify a default aggregation, then the default value is `SUM`.
## *cache_clause*
Specify a cache clause to improve query response time when an appropriate materialized view is available. You can specify one or more cache specifications.
## *cache_specification*
Specify one or more measure groups for a cache clause. To include all measure groups, specify `ALL`. Each measure group can contain one or more measures and one or more level groupings. A level grouping can contain one or more level specifications.
## *level_specification*
Specify one or more levels for a level grouping of a measure group for a cache specification. Specify only one level per hierarchy. A materialized view must exist that contains the aggregated values for the hierarchy level.
## Examples
The following is a description of the `SALES_FACT` table:
```
desc SALES_FACT
Name              Null? Type
----------------- ----- -------------
MONTH_ID                VARCHAR2(10)
CATEGORY_ID             NUMBER(6)
STATE_PROVINCE_ID       VARCHAR2(120)
UNITS                   NUMBER(6)
SALES                   NUMBER(12,2)
```
The following example creates the `SALES_AV` analytic view using the `SALES_FACT` table:
```
CREATE OR REPLACE ANALYTIC VIEW sales_av
USING sales_fact
DIMENSION BY
  (time_attr_dim                         -- An attribute dimension of time data
    KEY month_id REFERENCES month_id
    HIERARCHIES (
      time_hier DEFAULT),
   product_attr_dim                      -- An attribute dimension of product data
    KEY category_id REFERENCES category_id
    HIERARCHIES (
      product_hier DEFAULT),
   geography_attr_dim                    -- An attribute dimension of store data
    KEY state_province_id
    REFERENCES state_province_id HIERARCHIES (
      geography_hier DEFAULT)
   )
MEASURES
 (sales FACT sales,                      -- A base measure
  units FACT units,                      -- A base measure
  sales_prior_period AS                  -- Calculated measures
    (LAG(sales) OVER (HIERARCHY time_hier OFFSET 1)),
  sales_year_ago AS
    (LAG(sales) OVER (HIERARCHY time_hier OFFSET 1
     ACROSS ANCESTOR AT LEVEL year)),
  chg_sales_year_ago AS
    (LAG_DIFF(sales) OVER (HIERARCHY time_hier OFFSET 1
     ACROSS ANCESTOR AT LEVEL year)),
  pct_chg_sales_year_ago AS
    (LAG_DIFF_PERCENT(sales) OVER (HIERARCHY time_hier OFFSET 1
     ACROSS ANCESTOR AT LEVEL year)),
  sales_qtr_ago AS
    (LAG(sales) OVER (HIERARCHY time_hier OFFSET 1
     ACROSS ANCESTOR AT LEVEL quarter)),
  chg_sales_qtr_ago AS
    (LAG_DIFF(sales) OVER (HIERARCHY time_hier OFFSET 1
     ACROSS ANCESTOR AT LEVEL quarter)),
  pct_chg_sales_qtr_ago AS
    (LAG_DIFF_PERCENT(sales) OVER (HIERARCHY time_hier OFFSET 1
     ACROSS ANCESTOR AT LEVEL quarter))
  )
DEFAULT MEASURE SALES;
```
