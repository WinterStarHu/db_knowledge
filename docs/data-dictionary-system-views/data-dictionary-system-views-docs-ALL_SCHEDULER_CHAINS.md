# ALL_SCHEDULER_CHAINS

`ALL_SCHEDULER_CHAINS` displays information about the chains accessible to the current user (that is, those chains that the user has `ALTER` or `EXECUTE` privileges for).
Related Views
- DBA_SCHEDULER_CHAINS displays information about all chains in the database.

- USER_SCHEDULER_CHAINS displays information about the chains owned by the current user. This view does not display the OWNER column.

| Column | Datatype | NULL | Description |
|---|---|---|---|
| OWNER | VARCHAR2(128) | NOT NULL | Owner of the Scheduler chain |
| CHAIN_NAME | VARCHAR2(128) | NOT NULL | Name of the Scheduler chain |
| RULE_SET_OWNER | VARCHAR2(128) |  | Owner of the rule set describing the dependencies |
| RULE_SET_NAME | VARCHAR2(128) |  | Name of the rule set describing the dependencies |
| NUMBER_OF_RULES | NUMBER |  | Number of rules in the chain |
| NUMBER_OF_STEPS | NUMBER |  | Number of defined steps in the chain |
| ENABLED | VARCHAR2(5) |  | Indicates whether the chain is enabled (TRUE) or disabled (FALSE) |
| EVALUATION_INTERVAL | INTERVAL DAY(3) TO SECOND(0) |  | Periodic interval at which to reevaluate rules for the chain |
| USER_RULE_SET | VARCHAR2(5) |  | Indicates whether the chain uses a user-specified rule set (TRUE) or not (FALSE) |
| COMMENTS | VARCHAR2(4000) |  | Comments on the chain |

See Also:
- "DBA_SCHEDULER_CHAINS"
- "USER_SCHEDULER_CHAINS"
