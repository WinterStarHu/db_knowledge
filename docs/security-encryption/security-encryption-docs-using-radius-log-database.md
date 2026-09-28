# Using RADIUS to Log in to a Database

You can use RADIUS to log into a database by using either synchronous authentication mode or challenge-response mode.
  - If you are using the synchronous authentication mode, first ensure that challenge-response mode is not turned to ON, and then enter the following command:
```
CONNECT username@database_alias
Enter password: password
```
  - If you are using the challenge-response mode, ensure that challenge-response mode is set to ON and then enter the following command:
```
CONNECT /@database_alias
```
The challenge-response mode can be configured for all login cases.
