# PostgreSQL: Documentation: 18: ALTER OPERATOR

PostgreSQL: Documentation: 18: ALTER OPERATOR Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
ALTER OPERATOR Prev Up SQL Commands Home Next ALTER OPERATOR ALTER OPERATOR — change the definition of an operator Synopsis ALTER OPERATOR name ( { left_type | NONE } , right_type ) OWNER TO { new_owner | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ALTER OPERATOR name ( { left_type | NONE } , right_type ) SET SCHEMA new_schema ALTER OPERATOR name ( { left_type | NONE } , right_type ) SET ( {  RESTRICT = { res_proc | NONE }
| JOIN = { join_proc | NONE }
| COMMUTATOR = com_op
| NEGATOR = neg_op
| HASHES
| MERGES
} [, ... ] ) Description ALTER OPERATOR changes the definition of an operator.
You must own the operator to use ALTER OPERATOR. To alter the owner, you must be able to SET ROLE to the new owning role, and that role must have CREATE privilege on the operator's schema. (These restrictions enforce that altering the owner doesn't do anything you couldn't do by dropping and recreating the operator. However, a superuser can alter ownership of any operator anyway.) Parameters name The name (optionally schema-qualified) of an existing operator.
left_type The data type of the operator's left operand; write NONE if the operator has no left operand.
right_type The data type of the operator's right operand.
new_owner The new owner of the operator.
new_schema The new schema for the operator.
res_proc The restriction selectivity estimator function for this operator; write NONE to remove existing selectivity estimator.
join_proc The join selectivity estimator function for this operator; write NONE to remove existing selectivity estimator.
com_op The commutator of this operator. Can only be changed if the operator does not have an existing commutator.
neg_op The negator of this operator. Can only be changed if the operator does not have an existing negator.
HASHES Indicates this operator can support a hash join. Can only be enabled and not disabled.
MERGES Indicates this operator can support a merge join. Can only be enabled and not disabled.
Notes Refer to Section 36.14 and Section 36.15 for further information.
Since commutators come in pairs that are commutators of each other, ALTER OPERATOR SET COMMUTATOR will also set the commutator of the com_op to be the target operator. Likewise, ALTER OPERATOR SET NEGATOR will also set the negator of the neg_op to be the target operator. Therefore, you must own the commutator or negator operator as well as the target operator.
Examples Change the owner of a custom operator a @@ b for type text:
ALTER OPERATOR @@ (text, text) OWNER TO joe;
Change the restriction and join selectivity estimator functions of a custom operator a && b for type int[]:
ALTER OPERATOR && (int[], int[]) SET (RESTRICT = _int_contsel, JOIN = _int_contjoinsel);
Mark the && operator as being its own commutator:
ALTER OPERATOR && (int[], int[]) SET (COMMUTATOR = &&);
Compatibility There is no ALTER OPERATOR statement in the SQL standard.
See AlsoCREATE OPERATOR, DROP OPERATOR Prev Up Next ALTER MATERIALIZED VIEW Home ALTER OPERATOR CLASS Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
