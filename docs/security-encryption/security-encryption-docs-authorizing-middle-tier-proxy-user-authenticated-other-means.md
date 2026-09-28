# Authorizing a Middle Tier to Proxy a User Authenticated by Other Means

You can authorize a middle tier to proxy a user that has been authenticated by other means.
Currently, `PASSWORD` is the only means supported.
  ````- Use the AUTHENTICATION REQURED clause of the ALTER USER ... GRANT CONNECT THROUGH statement to authorize a user to be proxied, but not authenticated, by a middle tier.
For example:
```
ALTER USER mary GRANT CONNECT THROUGH midtier AUTHENTICATION REQUIRED;
```
In the preceding statement, middle-tier server `midtier` is authorized to connect as user `mary`, and `midtier` must also pass the user password to the database server for authorization.
