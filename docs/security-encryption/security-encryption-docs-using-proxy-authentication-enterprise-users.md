# Using Proxy Authentication with Enterprise Users

How the middle-tier responds for proxy authentication depends on how the user is authenticated, either as an enterprise user or a password-authenticated user.
If the middle tier connects to the database as a client who is an enterprise user, then either the distinguished name, or the X.509 certificate containing the distinguished name is passed over instead of the database user name. If the user is a password-authenticated enterprise user, then the middle tier must provide, as a minimum, a globally unique name for the user. The database uses this name to look up the user in Oracle Internet Directory.
````  - To pass over the distinguished name of the client, configure the application server to call the Oracle Call Interface method OCIAttrSet() with OCI_ATTR_DISTINGUISHED_NAME as the attribute type, as follows:
```
OCIAttrSet(session_handle, OCI_HTYPE_SESSION, distinguished_name, 0, OCI_ATTR_DISTINGUISHED_NAME, error_handle);
```
  ````- To pass over the entire certificate, configure the middle tier to call OCIAttrSet() with OCI_ATTR_CERTIFICATE as the attribute type, as follows:
```
OCIAttrSet(session_handle,
           OCI_HTYPE_SESSION,
           certificate,
           certificate_length,
           OCI_ATTR_CERTIFICATE,
           error_handle);
```
If the type is not specified, then the database uses its default certificate type of X.509.
**Note:**
- OCI_ATTR_CERTIFICATE is Distinguished Encoding Rules (DER) encoded.
``````
- Certificate based proxy authentication using OCI_ATTR_CERTIFICATE will not be supported in future Oracle Database releases. Use the OCI_ATTR_DISTINGUISHED_NAME or OCI_ATTR_USERNAME attribute instead
If you are using proxy authentication for password-authenticated enterprise users, then use the same OCI attributes as for database users authenticated by password (`OCI_ATTR_USERNAME`). Oracle Database first checks the user name against the database. If it finds no user, then the database checks the user name in the directory. This user name must be globally unique.
