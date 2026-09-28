# DROP CONTEXT

## Purpose
Use the `DROP` `CONTEXT` statement to remove a context namespace from the database.
Removing a context namespace does not invalidate any context under that namespace that has been set for a user session. However, the context will be invalid when the user next attempts to set that context.
**See Also:**   CREATE CONTEXT and *Oracle Database Security Guide* for more information on contexts
## Prerequisites
You must have the `DROP` `ANY` `CONTEXT` system privilege.
## Syntax
## *drop_context*::=
Description of the illustration drop_context.eps
## Semantics
## *namespace*
Specify the name of the context namespace to drop. You cannot drop the built-in namespace `USERENV`.
**See Also:**   SYS_CONTEXT for information on the `USERENV` namespace
## Examples
**Dropping an Application Context: Example** The following statement drops the context created in CREATE CONTEXT:
```
DROP CONTEXT hr_context;
```
