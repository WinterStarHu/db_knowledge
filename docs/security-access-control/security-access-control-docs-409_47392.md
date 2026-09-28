# Querying People Nearby with One SQL Statement

> 来源: https://www.tencentcloud.com/document/product/409/47392

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases Querying People Nearby with One SQL Statement Querying People Nearby with One SQL Statement Download Focus Mode Font Size Last updated: 2024-01-24 11:20:59 PostGIS is an extension of the PostgreSQL relational database. It follows the specifications of OpenGIS and provides the following spatial information service features: spatial objects, indexes, operation functions, and operators.
PostGIS supports all spatial data types, including POINT, LINESTRING, POLYGON, MULTIPOINT, MULTILINESTRING, MULTIPOLYGON, and GEOMETRYCOLLECTION.
PostGIS is also the most comprehensive and powerful spatial and geographic database engine in the industry. Many business use cases nowadays require the "XXX nearby" feature. PostGIS and PostgreSQL can work together to implement this feature quickly.
This document describes how to implement the "objects nearby" feature with PostGIS.
Prerequisites You have a PostgreSQL instance.
This instance supports the PostGIS extension.
Step 1. Create the extension Log in to the business database instance and run the following commands. For the login methods, see Connecting to TencentDB for PostgreSQL Instance.
\c test CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
Step 2. Create a test table and an index Run the following commands in the business database. You can customize the name after TABLE.
CREATE TABLE t_user(uid int PRIMARY KEY,name varchar(20),location geometry);
CREATE INDEX t_user_location on t_user USING GIST(location);
Step 3. Insert test data
## Create an automatic name generation function
create or replace function random_string(length integer) returns text as $$ declare chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
result text := '';
i integer := 0;
length2 integer := (select trunc(random() * length + 1));
begin if length2 < 0 then raise exception 'Given length cannot be less than 0';
end if;
for i in 1..length2 loop result := result || chars[1+random()*(array_length(chars, 1)-1)];
end loop;
return result;
end;
$$ language plpgsql;
﻿

## Insert ten million rows of test data
insert into t_user select generate_series(1,10000000), random_string(20),st_setsrid(st_makepoint(150-random()*100, 90-random()*100), 4326);
Step 4. Query people nearby
1.
Select a random coordinate here. The coordinate of Tiananmen Square (116.404177,39.909652) is used as an example.
2.
Use it as the coordinate for query to find the five objects closest to it in the database, and then output the distances of these objects from it (in 00' km).
Note:
WGS 84 is the most popular geographic coordinate system. Internationally, each coordinate system is assigned an EPSG code, which is 4326 for WGS 84. GPS is based on WGS 84, so the coordinate data obtained is usually in WGS 84 and generally stored as WGS 84.
Run the following command:
select uid, name, ST_AsText(location), ST_Distance(ST_GeomFromText('POINT(116.404177 39.909652)',4326), location) from t_user order by location <-> 'SRID=4326;POINT(116.404177 39.909652)'::geometry limit 5;
3.
View all objects within 1000 meters of this coordinate object and their distances.
select uid, name, ST_AsText(location),ST_Distance(ST_GeomFromText('POINT(116.404177 39.909652)',4326), location) from t_user where ST_DWithin(location::geography, ST_GeographyFromText('POINT(116.404177 39.909652)'), 1000.0);
Previous Topic: Searching in High Numbers of Tags Based on pg_roaringbitmap Next Topic: Configuring TencentDB for PostgreSQL as GitLab's External Data Source Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Prerequisites Step 1. Create the extension Step 2. Create a test table and an index Step 3. Insert test data Step 4. Query people nearby Search AllCurrent Product Search titles only Enter keywords to search documentation
