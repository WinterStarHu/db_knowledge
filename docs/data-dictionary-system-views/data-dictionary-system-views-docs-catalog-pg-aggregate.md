# PostgreSQL: Documentation: 18: 52.2. pg_aggregate

PostgreSQL: Documentation: 18: 52.2. pg_aggregate Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
52.2. pg_aggregate
Prev Up Chapter 52. System Catalogs Home Next
52.2. pg_aggregate #
The catalog pg_aggregate stores information about aggregate functions. An aggregate function is a function that operates on a set of values (typically one column from each row that matches a query condition) and returns a single value computed from all these values. Typical aggregate functions are sum, count, and max. Each entry in pg_aggregate is an extension of an entry in pg_proc. The pg_proc entry carries the aggregate's name, input and output data types, and other information that is similar to ordinary functions.
Table 52.2. pg_aggregate Columns Column Type Description aggfnoid regproc (references pg_proc.oid) pg_proc OID of the aggregate function aggkind char Aggregate kind: n for “normal” aggregates, o for “ordered-set” aggregates, or h for “hypothetical-set” aggregates aggnumdirectargs int2 Number of direct (non-aggregated) arguments of an ordered-set or hypothetical-set aggregate, counting a variadic array as one argument. If equal to pronargs, the aggregate must be variadic and the variadic array describes the aggregated arguments as well as the final direct arguments. Always zero for normal aggregates.
aggtransfn regproc (references pg_proc.oid) Transition function aggfinalfn regproc (references pg_proc.oid) Final function (zero if none) aggcombinefn regproc (references pg_proc.oid) Combine function (zero if none) aggserialfn regproc (references pg_proc.oid) Serialization function (zero if none) aggdeserialfn regproc (references pg_proc.oid) Deserialization function (zero if none) aggmtransfn regproc (references pg_proc.oid) Forward transition function for moving-aggregate mode (zero if none) aggminvtransfn regproc (references pg_proc.oid) Inverse transition function for moving-aggregate mode (zero if none) aggmfinalfn regproc (references pg_proc.oid) Final function for moving-aggregate mode (zero if none) aggfinalextra bool True to pass extra dummy arguments to aggfinalfn aggmfinalextra bool True to pass extra dummy arguments to aggmfinalfn aggfinalmodify char Whether aggfinalfn modifies the transition state value: r if it is read-only, s if the aggtransfn cannot be applied after the aggfinalfn, or w if it writes on the value aggmfinalmodify char Like aggfinalmodify, but for the aggmfinalfn aggsortop oid (references pg_operator.oid) Associated sort operator (zero if none) aggtranstype oid (references pg_type.oid) Data type of the aggregate function's internal transition (state) data aggtransspace int4 Approximate average size (in bytes) of the transition state data, or zero to use a default estimate aggmtranstype oid (references pg_type.oid) Data type of the aggregate function's internal transition (state) data for moving-aggregate mode (zero if none) aggmtransspace int4 Approximate average size (in bytes) of the transition state data for moving-aggregate mode, or zero to use a default estimate agginitval text The initial value of the transition state. This is a text field containing the initial value in its external string representation. If this field is null, the transition state value starts out null.
aggminitval text The initial value of the transition state for moving-aggregate mode. This is a text field containing the initial value in its external string representation. If this field is null, the transition state value starts out null.
New aggregate functions are registered with the CREATE AGGREGATE command. See Section 36.12 for more information about writing aggregate functions and the meaning of the transition functions, etc.
Prev Up Next
52.1. Overview
Home
52.3. pg_am
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
