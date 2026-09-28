# PostgreSQL: Documentation: 18: 30.2. When to JIT?

PostgreSQL: Documentation: 18: 30.2. When to JIT?
Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11
30.2. When to JIT?
Prev Up Chapter 30. Just-in-Time Compilation (JIT) Home Next
30.2. When to JIT? #
JIT compilation is beneficial primarily for long-running CPU-bound queries. Frequently these will be analytical queries. For short queries the added overhead of performing JIT compilation will often be higher than the time it can save.
To determine whether JIT compilation should be used, the total estimated cost of a query (see Chapter 69 and Section 19.7.2) is used. The estimated cost of the query will be compared with the setting of jit_above_cost. If the cost is higher, JIT compilation will be performed. Two further decisions are then needed. Firstly, if the estimated cost is more than the setting of jit_inline_above_cost, short functions and operators used in the query will be inlined. Secondly, if the estimated cost is more than the setting of jit_optimize_above_cost, expensive optimizations are applied to improve the generated code. Each of these options increases the JIT compilation overhead, but can reduce query execution time considerably.
These cost-based decisions will be made at plan time, not execution time. This means that when prepared statements are in use, and a generic plan is used (see PREPARE), the values of the configuration parameters in effect at prepare time control the decisions, not the settings at execution time.
Note If jit is set to off, or if no JIT implementation is available (for example because the server was compiled without --with-llvm), JIT will not be performed, even if it would be beneficial based on the above criteria. Setting jit to off has effects at both plan and execution time.
EXPLAIN can be used to see whether JIT is used or not. As an example, here is a query that is not using JIT:
=# EXPLAIN ANALYZE SELECT SUM(relpages) FROM pg_class;
QUERY PLAN
-------------------------------------------------------------------​------------------------------------------
Aggregate  (cost=16.27..16.29 rows=1 width=8) (actual time=0.303..0.303 rows=1.00 loops=1) Buffers: shared hit=14 ->  Seq Scan on pg_class  (cost=0.00..15.42 rows=342 width=4) (actual time=0.017..0.111 rows=356.00 loops=1) Buffers: shared hit=14 Planning Time: 0.116 ms Execution Time: 0.365 ms Given the cost of the plan, it is entirely reasonable that no JIT was used; the cost of JIT would have been bigger than the potential savings. Adjusting the cost limits will lead to JIT use:
=# SET jit_above_cost = 10;
SET =# EXPLAIN ANALYZE SELECT SUM(relpages) FROM pg_class;
QUERY PLAN
-------------------------------------------------------------------​------------------------------------------
Aggregate  (cost=16.27..16.29 rows=1 width=8) (actual time=6.049..6.049 rows=1.00 loops=1) Buffers: shared hit=14 ->  Seq Scan on pg_class  (cost=0.00..15.42 rows=342 width=4) (actual time=0.019..0.052 rows=356.00 loops=1) Buffers: shared hit=14 Planning Time: 0.133 ms JIT:
Functions: 3 Options: Inlining false, Optimization false, Expressions true, Deforming true Timing: Generation 1.259 ms (Deform 0.000 ms), Inlining 0.000 ms, Optimization 0.797 ms, Emission 5.048 ms, Total 7.104 ms Execution Time: 7.416 ms As visible here, JIT was used, but inlining and expensive optimization were not. If jit_inline_above_cost or jit_optimize_above_cost were also lowered, that would change.
Prev Up Next
30.1. What Is JIT compilation?
Home
30.3. Configuration
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
