# Transport Layer Security Connections in an Oracle Real Application Clusters Environment

You can configure Transport Layer Security (TLS) connections in an Oracle Real Application Clusters (Oracle RAC) environment by using Oracle RAC tools and modifying Oracle Database configuration files.
Configure all Oracle RAC nodes that participate in TLS with the same cryptographic provider behavior. If you use the next-generation cryptographic provider, configure TLS 1.2 or TLS 1.3 and ensure that all wallets and certificates use algorithms supported by the next-generation provider. If you use the legacy provider, configure TLS 1.0, TLS 1.1, or TLS 1.2 as appropriate for the environment.
- Step 1: Configure TCPS Protocol Endpoints In Oracle Real Application Clusters (Oracle RAC), clients access one of three scan listeners and are then routed to database listeners. To support Transport Layer Security (TLS), all of these listeners must have TCPS protocol endpoints.
- Step 2: Ensure That the LOCAL_LISTENER Parameter Is Correctly Set on Each Node The Oracle Agent automatically sets the LOCAL_LISTENER parameter on each node, but you should double-check to ensure that it is correct.
- Step 3: Create Transport Layer Security Wallets and Certificates You must create Transport Layer Security (TLS) wallets and certificates for the cluster and also for clients that will connect to the cluster over TLS.
- Step 4: Create a Wallet in Each Node of the Oracle RAC Cluster After you have created the cluster wallet, you can copy it to each node of the Oracle Real Applications (Oracle RAC) cluster.
````
- Step 5: Define Wallet Locations in the listener.ora and sqlnet.ora Files To enable the database server and listeners to access the wallets, you must define the wallet locations in the listener.ora and sqlnet.ora files.
- Step 6: Restart the Database Instances and Listeners With the wallets in place and the *.ora files edited, you must restart the database server and listener processes so that they pick up the new settings.
- Step 7: Test the Cluster Node Configuration To test the cluster node configuration, you can create a connect descriptor for the node and then try to connect to this node.
- Step 8: Test the Remote Client Configuration After you have tested the wallet on the Oracle Real Applications (Oracle RAC) cluster nodes, you area ready to test the remote client configuration.
## Step 1: Configure TCPS Protocol Endpoints
In Oracle Real Application Clusters (Oracle RAC), clients access one of three scan listeners and are then routed to database listeners. To support Transport Layer Security (TLS), all of these listeners must have TCPS protocol endpoints.
- Log in to the cluster that hosts the Oracle RAC database.
```
$ srvctl config listener -h
```
```
Name: LISTENER Subnet: 192.0.2.195 Type: type Owner: pfitch Home: Grid_home End points: TCP:1521
```
```
$ srvctl config scan_listener -h
```
```
SCAN Listener LISTENER_SCAN1 exists. Port: TCP:1529 Registration invited nodes:
Registration invited subnets:
SCAN Listener is enabled.
SCAN Listener is individually enabled on nodes:
SCAN Listener is individually disabled on nodes:
```
- Check the listener resources to find if they support TCP endpoints. For example: Output similar to the following appears: The following command displays information about the scan listener: Output similar to the following appears:
```
$ srvctl modify listener -endpoints "TCP:port_1/TCPS:port_2"
```
- Add TCPS endpoints to the database listeners. For example:
```
$ srvctl config listener Name: LISTENER Network: 1, Owner: oracle Home: CRS_home End points: TCP:port_1/TCPS:port_2 $ lsnrctl status Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER))) (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=IP_address)(PORT=port_2))) (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=IP_address)(PORT=port_1)))
```
- Check the listener configuration. For example:
```
$ srvctl modify scan_listener -endpoints "TCP:port_1/TCPS:port_2"
```
- Add TCPS endpoints to the scan listeners. For example:
```
$ srvctl config scan_listener SCAN Listener LISTENER_SCAN1 exists. Port: TCP:port_1/TCPS:port_2 SCAN Listener LISTENER_SCAN2 exists. Port: TCP:port_1/TCPS:port_2 SCAN Listener LISTENER_SCAN3 exists. Port: TCP:port_1/TCPS:port_2 $ lsnrctl status listener_scan3 Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN3))) (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=IP_address)(PORT=port_1))) (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=IP_address)(PORT=port_2)))
```
- Check the scan listener configuration. For example:
## Step 2: Ensure That the LOCAL_LISTENER Parameter Is Correctly Set on Each Node
The Oracle Agent automatically sets the `LOCAL_LISTENER` parameter on each node, but you should double-check to ensure that it is correct.
- Log in any Oracle Real Application Clusters (Oracle RAC) node.
````
```
show parameter local_listener;
```
```
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
local_listener                       string      (DESCRIPTION=(ADDRESS_LIST=
                                                 (ADDRESS=(PROTOCOL=TCPS)(HOST=IP_address)
                                                 (PORT=port_2))))
```
- In SQL*Plus, as a user with the SYSDBA administrative privilege, check the LOCAL_LISTENER parameter. Output similar to the following appears:
- If the output is not what you want, then restart each Oracle RAC instance.
## Step 3: Create Transport Layer Security Wallets and Certificates
You must create Transport Layer Security (TLS) wallets and certificates for the cluster and also for clients that will connect to the cluster over TLS.
- Oracle Real Application Clusters Components That Need Certificates Specific components in Oracle Real Application Clusters (Oracle RAC) need certificates when you configure Transport Layer Security (TLS) connections.
- Creating Transport Layer Security Wallets and Certificates To create the Transport Layer Security wallets and certificates, you first create the root CA certificate, followed by the cluster and client wallets.
### Oracle Real Application Clusters Components That Need Certificates
Specific components in Oracle Real Application Clusters (Oracle RAC) need certificates when you configure Transport Layer Security (TLS) connections.
- Each cluster node (server) and listener must have a wallet with the user certificate and CA certificates.
- The client only needs CA certificates of the listeners and servers (either in wallet or system’s certificate store) if one-way TLS is configured.
- The client needs a wallet with its user certificate and CA certificates of the listeners and servers if mTLS is configured.
### Creating Transport Layer Security Wallets and Certificates
To create the Transport Layer Security wallets and certificates, you first create the root CA certificate, followed by the cluster and client wallets.
  - Log in to any Oracle Real Application Clusters (Oracle RAC) cluster node.
```
$ orapki wallet create -wallet CA_home_wallet_file_directory
```
  - Use the orapki utility to create the CA wallet in a directory for the CA.
```
$ orapki wallet add -wallet CA_home_wallet_file_directory -self_signed -dn "CN=test CA,O=test,C=c" -keysize 2048 -validity 3650 -sign_alg sha256
Enter wallet password: password
```
  - Create a self-signed root certificate for the CA wallet. For example:
```
$ orapki wallet export -wallet CA_home_wallet_file_directory -dn "CN=test CA,O=test,C=c" -cert testCAroot.cer
Enter wallet password: password
```
``````
```
$ orapki wallet display -wallet CA_home_wallet_file_directory -summary
```
```
Requested Certificates:
User Certificates:
Subject:        CN=test CA,O=test,C=c Trusted Certificates:
Subject:        CN=test CA,O=test,C=c
```
  - Extract the root CA certificate from the wallet. This root certificate will be used as the trusted CA certificate in cluster and client wallets and can be distributed or published for users who are building PKCS#12 wallets. For example: At this stage, the CA_home_wallet_file_directory directory will contain the new wallet (ewallet.p12) and certificate (testCAroot.cer). To check the configuration: Output similar to the following appears:
```
$ orapki wallet create -wallet cluster_wallet_file_directory Enter password: password Enter password again: password
```
  - Create a wallet that is in a different location from the from the CA home directory. For example:
```
$ orapki wallet add -wallet cluster_wallet_file_directory -dn "CN=testuser" -keysize 2048 Enter wallet password: password $ orapki wallet export -wallet cluster_wallet_file_directory -dn "CN=testuser" -request cluster_wallet_file_directory/testuser.req Enter wallet password: password
```
````````
```
$ orapki cert create -wallet cluster_wallet_file_directory -request cluster_wallet_file_directory/testuser.req -cert user_wallet_file_directory/testuser.cer -validity 3650 -sign_alg sha256
Enter wallet password: password
```
````
  - Create a user identity (user dn) and then a certificate request. For example: At this stage, the cluster_wallet_file_directory directory will contain the SSO wallet (cwallet.sso), the wallet (ewallet.p12) and the certificate request (testuser.req). The certificate request can be signed by the CA generated above. For example: The cluster_wallet_file_directory directory now has the testuser.req certificate request file.
````
```
$ orapki wallet add -wallet cluster_wallet_file_directory -trusted_cert -cert CA_home_wallet_file_directory/testCAroot.cer -pwd
Enter wallet password: user_password
$ orapki wallet add -wallet cluster_wallet_file_directory -user_cert -cert cluster_wallet_file_directory/testuser.cer
Enter wallet password: user_password
```
  - Import the root certificate (testCAroot.cer) and the signed user certificate (testuser.cer) into the user wallet. For example:
```
$ orapki wallet display -wallet cluster_wallet_file_directory -summary
Requested Certificates:
User Certificates:
Subject:        CN=testuser
Trusted Certificates:
Subject:        CN=test CA,O=test,C=c
```
  - Check the finished cluster wallet. For example: At this point, you are ready to copy the finished cluster wallet to each node of the cluster.
```
$ orapki wallet create -wallet client_wallet_file_directory -auto_login
$ orapki wallet add -wallet client_wallet_file_directory -trusted_cert -cert CA_home_wallet_file_directory/testCAroot.cer
```
  - Create a client wallet with the root certificate (testCAroot.cer). To make a successful TLS connection, the client only requires the CA certificates of the server’s certificate. For example:
```
$ orapki wallet display -wallet client_wallet_file_directory -summary
Requested Certificates:
User Certificates:
Trusted Certificates:
Subject:        CN=test CA,O=test,C=c
```
  - Check the finished client wallet. For example:
## Step 4: Create a Wallet in Each Node of the Oracle RAC Cluster
After you have created the cluster wallet, you can copy it to each node of the Oracle Real Applications (Oracle RAC) cluster.
Ensure that each node is accessible by both the Oracle Real Application Clusters (Oracle RAC) database server (process monitor) and by the scan and local listeners that normally run from the GI home.
- Copy the PKCS#12 wallet (ewallet.p12) file that you created in the previous section to each node in the cluster.
``````````````
```
$ orapki wallet create -wallet wallet_file_location -auto_login Enter wallet password: ewallet_password
```
- In each node, create an auto-login wallet (cwallet.sso). The cwallet.sso file is an obfuscated mirror copy of the ewallet.p12 and is the file that the database server and its listeners accesses. If you create the cwallet.sso on the Oracle RAC cluster, then you can copy it along with the ewallet.p12 file to the wallet directory on each node. You can also create the cwallet.sso file on each node separately if ewallet.p12 file is already in place. Run the following command in the same location as the ewallet.p12 file:
## Step 5: Define Wallet Locations in the listener.ora and sqlnet.ora Files
To enable the database server and listeners to access the wallets, you must define the wallet locations in the `listener.ora` and `sqlnet.ora` files.
**Note:** To bring Oracle parameters in accord with the actual encryption and authentication methods for network connections, Oracle is deprecating all connect parameters prefixed with `SSL_` in favor of parameters prefixed with `TLS_`. During this deprecation period, if both `TLS_CLIENT_AUTHENTICATION` and `SSL_CLIENT_AUTHENTICATION` parameters are configured, then the `SSL_CLIENT_AUTHENTICATION` parameter is ignored.
```
TLS_CLIENT_AUTHENTICATION = FALSE WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = wallet_file_location)
```
- Modify the listener.ora file in the Grid home of every node.
```
SQLNET.AUTHENTICATION_SERVICES = (BEQ, TCP, TCPS) TLS_CLIENT_AUTHENTICATION = FALSE WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = wallet_file_location) ) )
```
- In the sqlnet.ora file in the Oracle Database home, and the Grid home, of each cluster node, add the following information:
## Step 6: Restart the Database Instances and Listeners
With the wallets in place and the `*.ora` files edited, you must restart the database server and listener processes so that they pick up the new settings.
The restart process will also enable the Oracle Real Application Clusters (Oracle RAC) instances where you set the `LOCAL_LISTENER` parameter earlier.
```
$ srvctl stop listener $ srvctl start listener $ srvctl stop scan_listener $ srvctl start scan_listener $ srvctl stop database -d db_name $ srvctl start database -d db_name
```
- In any cluster node, use the srvctl utility to restart the database server and listener processes. For example:
## Step 7: Test the Cluster Node Configuration
To test the cluster node configuration, you can create a connect descriptor for the node and then try to connect to this node.
```
DBSSL = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCPS)(HOST = scan_name)(PORT = port_2)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = service_name) ) )
```
- In any cluster node, create a connect descriptor in the tnsnames.ora file that uses the scan listener TCPS endpoint. For example, for a TCPS endpoint called dbssl:
```
sqlplus user_name/@dbssl Enter password: password
```
- Use SQL*Plus to try to connect to this TCPS endpoint. For example:
## Step 8: Test the Remote Client Configuration
After you have tested the wallet on the Oracle Real Applications (Oracle RAC) cluster nodes, you area ready to test the remote client configuration.
```
WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = wallet_file_location) ) )
```
- In every remote client sqlnet.ora file on the cluster node, define a wallet directory.
```
$ wallet create -wallet wallet_file_location -auto_login Enter wallet password: password
```
``````
- Move the client wallet that you created earlier, when you created the SSL wallets and certificates, to the client wallet directory. The wallet_file_location should have an ewallet.p12 file and a cwallet.sso file.
```
DBSSL =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCPS)(HOST = scan_name)(PORT = port_2))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = service_name)
    )
  )
```
- In the tnsnames.ora file, create a connect descriptor that uses the scan listener TCPS endpoint. For example:
```
sqlplus user_name/@dbssl
Enter password: password
```
- Use SQL*Plus to try to connect to this TCPS endpoint. For example:
## Related Topics
  - Oracle Real Application Clusters Components That Need Certificates
