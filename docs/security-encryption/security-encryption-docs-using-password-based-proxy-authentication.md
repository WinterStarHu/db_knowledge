# Using Password-Based Proxy Authentication

When you use password-based proxy authentication, Oracle Database passes the password of the client to the middle-tier server.
The middle-tier server then passes the password as an attribute to the data server for verification.
The main advantage to this type of authentication is that the client computer does not have to have Oracle software installed on it to perform database operations.
  ````- To pass the password of the client, configure the the middle-tier server to call the OCIAttrSet() function as follows, passing OCI_ATTR_PASSWORD as the type of the attribute being set.
```
OCIAttrSet( session_handle,    /* Pointer to a handle whose attribute gets modified. */ OCI_HTYPE_SESSION, /* Handle type: OCI user session handle. */ password_ptr,      /* Pointer to the value of the password attribute. */ 0,                 /* The size of the password attribute value is already known by the OCI library. */ OCI_ATTR_PASSWORD, /* The attribute type. */ error_handle);     /* An error handle used to retrieve diagnostic information in the event of an error. */
```
