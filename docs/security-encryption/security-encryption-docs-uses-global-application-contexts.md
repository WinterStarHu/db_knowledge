# Uses for Global Application Contexts

There are three general uses for global application contexts.
These uses are as follows:
****
- You must share application values globally for all database users. For example, you may need to disable access to an application based on a specific situation. In this case, the values the application context sets are not user-specific, nor are they based on the private data of a user. The application context defines a situation, for example, to indicate the version of application module that is running.
****
- You have database users who must move from one application to another. In this case, the second application the user is moving to has different access requirements from the first application.
****
- You must authenticate nondatabase users, that is, users who are not known to the database. This type of user, who does not have a database account, typically connects through a Web application by using a connection pool. These types of applications connect users to the database as single user, using the One Big Application User authentication model. To authenticate this type of user, you use the client session ID of the user.
