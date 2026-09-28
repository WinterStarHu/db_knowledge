# PostgreSQL: Documentation: 18: 18.7. Preventing Server Spoofing

PostgreSQL: Documentation: 18: 18.7. Preventing Server Spoofing Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
18.7. Preventing Server Spoofing
Prev Up Chapter 18. Server Setup and Operation Home Next
18.7. Preventing Server Spoofing #
While the server is running, it is not possible for a malicious user to take the place of the normal database server. However, when the server is down, it is possible for a local user to spoof the normal server by starting their own server. The spoof server could read passwords and queries sent by clients, but could not return any data because the PGDATA directory would still be secure because of directory permissions. Spoofing is possible because any user can start a database server; a client cannot identify an invalid server unless it is specially configured.
One way to prevent spoofing of local connections is to use a Unix domain socket directory (unix_socket_directories) that has write permission only for a trusted local user. This prevents a malicious user from creating their own socket file in that directory. If you are concerned that some applications might still reference /tmp for the socket file and hence be vulnerable to spoofing, during operating system startup create a symbolic link /tmp/.s.PGSQL.5432 that points to the relocated socket file. You also might need to modify your /tmp cleanup script to prevent removal of the symbolic link.
Another option for local connections is for clients to use requirepeer to specify the required owner of the server process connected to the socket.
To prevent spoofing on TCP connections, either use SSL certificates and make sure that clients check the server's certificate, or use GSSAPI encryption (or both, if they're on separate connections).
To prevent spoofing with SSL, the server must be configured to accept only hostssl connections (Section 20.1) and have SSL key and certificate files (Section 18.9). The TCP client must connect using sslmode=verify-ca or verify-full and have the appropriate root certificate file installed (Section 32.19.1). Alternatively the system CA pool, as defined by the SSL implementation, can be used using sslrootcert=system; in this case, sslmode=verify-full is forced for safety, since it is generally trivial to obtain certificates which are signed by a public CA.
To prevent server spoofing from occurring when using scram-sha-256 password authentication over a network, you should ensure that you connect to the server using SSL and with one of the anti-spoofing methods described in the previous paragraph. Additionally, the SCRAM implementation in libpq cannot protect the entire authentication exchange, but using the channel_binding=require connection parameter provides a mitigation against server spoofing. An attacker that uses a rogue server to intercept a SCRAM exchange can use offline analysis to potentially determine the hashed password from the client.
To prevent spoofing with GSSAPI, the server must be configured to accept only hostgssenc connections (Section 20.1) and use gss authentication with them. The TCP client must connect using gssencmode=require.
Prev Up Next
18.6. Upgrading a PostgreSQL Cluster
Home
18.8. Encryption Options
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
