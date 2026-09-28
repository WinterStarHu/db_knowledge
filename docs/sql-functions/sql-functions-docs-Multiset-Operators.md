# Multiset Operators

Multiset operators combine the results of two nested tables into a single nested table.
The examples related to multiset operators require that two nested tables be created and loaded with data as follows:
First, make a copy of the `oe.customers` table called `customers_demo`:
```
CREATE TABLE customers_demo AS
  SELECT * FROM customers;
```
Next, create a table type called `cust_address_tab_typ`. This type will be used when creating the nested table columns.
```
CREATE TYPE cust_address_tab_typ AS
  TABLE OF cust_address_typ;
/
```
Now, create two nested table columns in the `customers_demo` table:
```
ALTER TABLE customers_demo
  ADD (cust_address_ntab cust_address_tab_typ,
       cust_address2_ntab cust_address_tab_typ)
    NESTED TABLE cust_address_ntab STORE AS cust_address_ntab_store
    NESTED TABLE cust_address2_ntab STORE AS cust_address2_ntab_store;
```
Finally, load data into the two new nested table columns using data from the `cust_address` column of the `oe.customers` table:
```
UPDATE customers_demo cd
  SET cust_address_ntab =
    CAST(MULTISET(SELECT cust_address
                    FROM customers c
                    WHERE c.customer_id =
                          cd.customer_id) as cust_address_tab_typ);
UPDATE customers_demo cd
  SET cust_address2_ntab =
    CAST(MULTISET(SELECT cust_address
                    FROM customers c
                    WHERE c.customer_id =
                          cd.customer_id) as cust_address_tab_typ);
```
## MULTISET EXCEPT
`MULTISET` `EXCEPT` takes as arguments two nested tables and returns a nested table whose elements are in the first nested table but not in the second nested table. The two input nested tables must be of the same type, and the returned nested table is of the same type as well.
Description of the illustration multiset_except.gif Description of the illustration multiset_except.eps ******************
- The ALL keyword instructs Oracle to return all elements in nested_table1 that are not in nested_table2. For example, if a particular element occurs m times in nested_table1 and n times in nested_table2, then the result will have (m-n) occurrences of the element if m >n and 0 occurrences if m<=n. ALL is the default.
****
- The DISTINCT keyword instructs Oracle to eliminate any element in nested_table1 which is also in nested_table2, regardless of the number of occurrences.
- The element types of the nested tables must be comparable. Refer to Comparison Conditions for information on the comparability of nonscalar types.
**Example** The following example compares two nested tables and returns a nested table of those elements found in the first nested table but not in the second nested table:
```
SELECT customer_id, cust_address_ntab
  MULTISET EXCEPT DISTINCT cust_address2_ntab multiset_except
  FROM customers_demo
  ORDER BY customer_id;
CUSTOMER_ID MULTISET_EXCEPT(STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID)
----------- --------------------------------------------------------------------------------
        101 CUST_ADDRESS_TAB_TYP()
        102 CUST_ADDRESS_TAB_TYP()
        103 CUST_ADDRESS_TAB_TYP()
        104 CUST_ADDRESS_TAB_TYP()
        105 CUST_ADDRESS_TAB_TYP()
. . .
```
The preceding example requires the table `customers_demo` and two nested table columns containing data. Refer to Multiset Operators to create this table and nested table columns.
## MULTISET INTERSECT
`MULTISET` `INTERSECT` takes as arguments two nested tables and returns a nested table whose values are common in the two input nested tables. The two input nested tables must be of the same type, and the returned nested table is of the same type as well.
Description of the illustration multiset_intersect.gif Description of the illustration multiset_intersect.eps
``````****````
- The ALL keyword instructs Oracle to return all common occurrences of elements that are in the two input nested tables, including duplicate common values and duplicate common NULL occurrences. For example, if a particular value occurs m times in nested_table1 and n times in nested_table2, then the result would contain the element min(m,n) times. ALL is the default.
````
- The DISTINCT keyword instructs Oracle to eliminate duplicates from the returned nested table, including duplicates of NULL, if they exist.
- The element types of the nested tables must be comparable. Refer to Comparison Conditions for information on the comparability of nonscalar types.
**Example** The following example compares two nested tables and returns a nested table of those elements found in both input nested tables:
```
SELECT customer_id, cust_address_ntab
  MULTISET INTERSECT DISTINCT cust_address2_ntab multiset_intersect
  FROM customers_demo
  ORDER BY customer_id;
CUSTOMER_ID MULTISET_INTERSECT(STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID
----------- -----------------------------------------------------------------------------------
        101 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('514 W Superior St', '46901', 'Kokomo', 'IN', 'US'))
        102 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('2515 Bloyd Ave', '46218', 'Indianapolis', 'IN', 'US'))
        103 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('8768 N State Rd 37', '47404', 'Bloomington', 'IN', 'US'))
        104 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('6445 Bay Harbor Ln', '46254', 'Indianapolis', 'IN', 'US'))
        105 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('4019 W 3Rd St', '47404', 'Bloomington', 'IN', 'US'))
. . .
```
The preceding example requires the table `customers_demo` and two nested table columns containing data. Refer to Multiset Operators to create this table and nested table columns.
## MULTISET UNION
`MULTISET` `UNION` takes as arguments two nested tables and returns a nested table whose values are those of the two input nested tables. The two input nested tables must be of the same type, and the returned nested table is of the same type as well.
Description of the illustration multiset_union.gif Description of the illustration multiset_union.eps
````
- The ALL keyword instructs Oracle to return all elements that are in the two input nested tables, including duplicate values and duplicate NULL occurrences. This is the default.
````
- The DISTINCT keyword instructs Oracle to eliminate duplicates from the returned nested table, including duplicates of NULL, if they exist.
- The element types of the nested tables must be comparable. Refer to Comparison Conditions for information on the comparability of nonscalar types.
**Example** The following example compares two nested tables and returns a nested table of elements from both input nested tables:
```
SELECT customer_id, cust_address_ntab
  MULTISET UNION cust_address2_ntab multiset_union
  FROM customers_demo
  ORDER BY customer_id;
CUSTOMER_ID MULTISET_UNION(STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID)
----------- -------------------------------------------------------------------------------
        101 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('514 W Superior St', '46901', 'Kokomo', 'IN', 'US'),
                                 CUST_ADDRESS_TYP('514 W Superior St', '46901', 'Kokomo', 'IN', 'US'))
        102 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('2515 Bloyd Ave', '46218', 'Indianapolis', 'IN', 'US'),
                                 CUST_ADDRESS_TYP('2515 Bloyd Ave', '46218', 'Indianapolis', 'IN','US'))
        103 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('8768 N State Rd 37', '47404', 'Bloomington', 'IN', 'US'),
                                 CUST_ADDRESS_TYP('8768 N State Rd 37', '47404', 'Bloomington', 'IN', 'US'))
        104 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('6445 Bay Harbor Ln', '46254', 'Indianapolis', 'IN', 'US'),
                                 CUST_ADDRESS_TYP('6445 Bay Harbor Ln', '46254', 'Indianapolis', 'IN', 'US'))
        105 CUST_ADDRESS_TAB_TYP(CUST_ADDRESS_TYP('4019 W 3Rd St', '47404', 'Bloomington', 'IN', 'US'),
                                 CUST_ADDRESS_TYP('4019 W 3Rd St', '47404', 'Bloomington', 'IN', 'US'))
. . .
```
The preceding example requires the table `customers_demo` and two nested table columns containing data. Refer to Multiset Operators to create this table and nested table columns.
