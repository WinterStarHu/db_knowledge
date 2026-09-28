# SET CONSTRAINT[S]

## Purpose
Use the `SET` `CONSTRAINTS` statement to specify, for a particular transaction, whether a deferrable constraint is checked following each DML statement (`IMMEDIATE`) or when the transaction is committed (`DEFERRED`). You can use this statement to set the mode for a list of constraint names or for `ALL` constraints.
The `SET` `CONSTRAINTS` mode lasts for the duration of the transaction or until another `SET` `CONSTRAINTS` statement resets the mode.
**Note:**   You can also use an `ALTER` `SESSION` statement with the `SET` `CONSTRAINTS` clause to set *all* deferrable constraints. This is equivalent to making issuing a `SET` `CONSTRAINTS` statement at the start of each transaction in the current session.
You cannot specify this statement inside of a trigger definition.
`SET` `CONSTRAINTS` can be a distributed statement. Existing database links that have transactions in process are notified when a `SET` `CONSTRAINTS` `ALL` statement is issued, and new links are notified that it was issued as soon as they start a transaction.
## Prerequisites
To specify when a deferrable constraint is checked, you must have the `READ` or `SELECT` privilege on the table to which the constraint is applied unless the table is in your schema.
## Syntax
## *set_constraints*::=
Description of the illustration set_constraints.eps
## Semantics
## *constraint*
Specify the name of one or more integrity constraints.
## ALL
Specify `ALL` to set all deferrable constraints for this transaction.
## IMMEDIATE
Specify `IMMEDIATE` to cause the specified constraints to be checked immediately on execution of each constrained DML statement. Oracle Database first checks any constraints that were deferred earlier in the transaction and then continues immediately checking constraints of any further statements in that transaction, as long as all the checked constraints are consistent and no other `SET` `CONSTRAINTS` statement is issued. If any constraint fails the check, then an error is signaled. At that point, a `COMMIT` statement causes the whole transaction to undo.
Making constraints immediate at the end of a transaction is a way of checking whether `COMMIT` can succeed. You can avoid unexpected rollbacks by setting constraints to `IMMEDIATE` as the last statement in a transaction. If any constraint fails the check, you can then correct the error before committing the transaction.
## DEFERRED
Specify `DEFERRED` to indicate that the conditions specified by the deferrable constraint are checked when the transaction is committed.
**Note:**   You can verify the success of deferrable constraints prior to committing them by issuing a `SET` `CONSTRAINTS` `ALL` `IMMEDIATE` statement.
## Examples
**Setting Constraints: Examples** The following statement sets all deferrable constraints in this transaction to be checked immediately following each DML statement:
```
SET CONSTRAINTS ALL IMMEDIATE;
```
The following statement checks three deferred constraints when the transaction is committed. This example fails if the constraints were specified to be `NOT` `DEFERRABLE`.
```
SET CONSTRAINTS emp_job_nn, emp_salary_min,
   hr.jhist_dept_fk@remote DEFERRED;
```
