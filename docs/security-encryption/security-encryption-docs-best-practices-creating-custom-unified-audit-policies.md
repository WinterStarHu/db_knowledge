# Best Practices for Creating Custom Unified Audit Policies

You can enable multiple policies at a time in the database, but ideally, limit the number of enabled policies.
The unified audit policy syntax is designed so that you can write one policy that covers all the audit settings that your database needs. A good practice is to group related options into a single policy instead of creating multiple small policies. This enables you to manage the policies much easier. As an example, each predefined audit policies contains multiple audit settings within one unified audit policy.
Limiting the number of enabled audit policies for a user session has the following benefits:
- It reduces the logon overhead that is associated with loading the audit policy’s details into the session’s UGA memory. If the enabled policy count is less, then less time is spent in loading the policy information.
- It reduces the session’s UGA memory consumption, because a fewer number of policies are required to be cached in UGA memory.
- It makes the internal audit check functionality more efficient, which determines whether to generate an audit record for its associated event.
``````
- If you have configured a unified audit policy for LOGON statements, then audit records for both direct logins as well as ALTER SESSION and SET CONTAINER statements are generated.
## Related Topics
  - Auditing Activities with the Predefined Unified Audit Policies
