# POWERMULTISET_BY_CARDINALITY

## Syntax
Description of the illustration powermultiset_by_cardnlty.gif Description of the illustration powermultiset_by_cardnlty.eps
## Purpose
`POWERMULTISET_BY_CARDINALITY` takes as input a nested table and a cardinality and returns a nested table of nested tables containing all nonempty subsets (called submultisets) of the nested table of the specified cardinality.
**
- expr can be any expression that evaluates to a nested table.
**
- cardinality can be any positive integer.
**
- If expr resolves to null, then Oracle Database returns NULL.
**
- If expr resolves to a nested table that is empty, then Oracle returns an error.
****
- The element types of the nested table must be comparable. Refer to “Comparison Conditions” for information on the comparability of nonscalar types. Note: This function is not supported in PL/SQL.
## Examples
First, create a data type that is a nested table of the `cust_address_tab_type` data type:
```
CREATE TYPE cust_address_tab_tab_typ
  AS TABLE OF cust_address_tab_typ;
/
```
Next, duplicate the elements in all the nested table rows to increase the cardinality of the nested table rows to 2:
```
UPDATE customers_demo
  SET cust_address_ntab = cust_address_ntab MULTISET UNION cust_address_ntab;
```
Now, select the nested table column `cust_address_ntab` from the `customers_demo` table using the `POWERMULTISET_BY_CARDINALITY` function:
```
SELECT CAST(POWERMULTISET_BY_CARDINALITY(cust_address_ntab, 2)
         AS cust_address_tab_tab_typ)
  FROM customers_demo;
```
```
CAST(POWERMULTISET_BY_CARDINALITY(CUST_ADDRESS_NTAB,2) AS CUST_ADDRESS_TAB_TAB_TYP)
  (STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID)
----------------------------------------------------------------------------------------
CUST_ADDRESS_TAB_TAB_TYP(CUST_ADDRESS_TAB_TYP
  (CUST_ADDRESS_TYP('514 W Superior St', '46901', 'Kokomo', 'IN', 'US'),
   CUST_ADDRESS_TYP('514 W Superior St', '46901', 'Kokomo', 'IN', 'US')))
CUST_ADDRESS_TAB_TAB_TYP(CUST_ADDRESS_TAB_TYP
  (CUST_ADDRESS_TYP('2515 Bloyd Ave', '46218', 'Indianapolis', 'IN', 'US'),
   CUST_ADDRESS_TYP('2515 Bloyd Ave', '46218', 'Indianapolis', 'IN', 'US')))
CUST_ADDRESS_TAB_TAB_TYP(CUST_ADDRESS_TAB_TYP
  (CUST_ADDRESS_TYP('8768 N State Rd 37', '47404', 'Bloomington', 'IN', 'US'),
   CUST_ADDRESS_TYP('8768 N State Rd 37', '47404', 'Bloomington', 'IN', 'US')))
. . .
```
The preceding example requires the `customers_demo` table and a nested table column containing data. Refer to “Multiset Operators” to create this table and nested table columns.
