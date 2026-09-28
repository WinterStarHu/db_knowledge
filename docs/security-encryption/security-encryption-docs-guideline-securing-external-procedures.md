# Guideline for Securing External Procedures

The `ENFORCE_CREDENTIAL` environment variable controls how an `extproc` process authenticates user credentials and callout functions.
You can specify this variable in the `extproc.ora` file. Before modifying this variable, review your site’s security requirements for the handling of external libraries. For maximum security, set the `ENFORCE_CREDENTIAL` variable to `TRUE`. The default setting is `FALSE`.
## Related Topics
  - Securing External Procedures
