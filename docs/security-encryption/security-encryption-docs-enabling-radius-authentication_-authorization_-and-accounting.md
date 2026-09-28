# Enabling RADIUS Authentication, Authorization, and Accounting

You can enable RADIUS authentication, authorization, and accounting from the command line. RADIUS authentication can either by configured through the modern configuration introduced in Oracle Database 19.28 or the legacy configuration.
Oracle AI Database 26ai introduces an updated RADIUS API based on RFC 6613 and RFC 6614 and has backported this to Oracle Database 19.28. Oracle recommends that you start planning on migrating to use the new RADIUS API as soon as possible. The new API is available by default. These parameters associated with the older RADIUS API are also deprecated:` SQLNET.RADIUS_ALTERNATE`, `SQLNET.RADIUS_ALTERNATE_PORT`, `SQLNET.RADIUS_AUTHENTICATION`, and `SQLNET.RADIUS_AUTHENTICATION_PORT`. Refer to the Radius API documentation for information on changing the default to use the newer RADIUS API.
Modern Configuration: This configuration is available by default. It is recommended to use this configuration method.
Legacy Configuration: This configuration is enabled by default, but the API based on Request for Comments (RFC) 2138 is deprecated starting with Oracle AI Database 26ai.
To use the deprecated legacy configuration, add the following parameters to the `sqlnet.ora` file: `SQLNET.RADIUS_ALLOW_WEAK_CLIENTS=TRUE` and `SQLNET.RADIUS_ALLOW_WEAK_PROTOCOL=TRUE`.
- Modern Configuration Learn how to configure RADIUS authentication using the modern configuration. It is recommended to use this configuration method.
- Legacy Configuration Learn how to configure RADIUS authentication using the legacy configuration. The API based on Request for Comments (RFC) 2138 is deprecated starting with Oracle AI Database 26ai.
