# Automatically Creating Partition in PostgreSQL

> 来源: https://www.tencentcloud.com/document/product/409/47394

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL Use Cases Automatically Creating Partition in PostgreSQL Automatically Creating Partition in PostgreSQL Download Focus Mode Font Size Last updated: 2024-01-24 11:20:59 In earlier versions of PostgreSQL, the table partitioning feature can be supported through inheritance; for example, a table partition can be created monthly by time, and data can be recorded in particular partitions. PostgreSQL 10 and later support declarative partitioning. This document describes how to create partitions in advance or in real time based on the written data.
The following are several common schemes for PostgreSQL to automatically create partitioned tables.
Use Cases In practical use cases of partitioned tables, the time field is generally used as the partition key; for example, if the partition field type is timestamp, the partitioning method can be "list of values".
The table structure is as follows:
CREATE TABLE tab ( id   bigint GENERATED ALWAYS AS IDENTITY, ts   timestamp NOT NULL, data text ) PARTITION BY LIST ((ts::date));
CREATE TABLE tab_def PARTITION OF tab DEFAULT;
Partition creation is generally divided into the following two scenarios:
1. Scheduled partition creation
You can create partitions in advance with the help of a task scheduling tool. Common tools and partition creation methods are as follows:
Using system schedulers such as Crontab (Linux, Unix, etc.) and Task Scheduler (Windows) Taking Linux as an example, create a partitioned table at 14:00 every day for the next day:
cat > /tmp/create_part.sh <<EOF dateStr=\\$(date -d '+1 days' +%Y%m%d);
psql -c "CREATE TABLE tab_\\$dateStr (LIKE tab INCLUDING INDEXES); ALTER TABLE tab ATTACH PARTITION tab_\\$dateStr FOR VALUES IN ('\\$dateStr')";
EOF (crontab -l 2>/dev/null; echo "0 14 * * * bash /tmp/create_part.sh ") | crontab - Using built-in schedulers such as pg_cron and pg_timetable Taking pg_cron as an example, create a partitioned table at 14:00 every day for the next day:
CREATE OR REPLACE FUNCTION create_tab_part() RETURNS integer LANGUAGE plpgsql AS $$ DECLARE dateStr varchar;
BEGIN SELECT to_char(DATE 'tomorrow', 'YYYYMMDD') INTO dateStr;
EXECUTE format('CREATE TABLE tab_%s (LIKE tab INCLUDING INDEXES)', dateStr);
EXECUTE format('ALTER TABLE tab ATTACH PARTITION tab_%s FOR VALUES IN (%L)', dateStr, dateStr);
RETURN 1;
END;
$$;
﻿

CREATE EXTENSION pg_cron;
﻿

SELECT cron.schedule('0 14 * * *', $$SELECT create_tab_part();$$);
Using dedicated partition management extensions such as pg_partman Taking pg_partman as an example, create a partitioned table every day for the next day:
CREATE EXTENSION pg_partman;
﻿

SELECT partman.create_parent(p_parent_table => 'public.tab', p_control => 'ts', p_type => 'native', p_interval=> 'daily', p_premake => 1);
2. On-demand real-time partition creation
If you want to create partitions according to the need of data insertion, so you can determine whether there is data in a time range based on whether a partition exists, this generally can be implemented with triggers.
Note that there are two problems with this method:
Only PostgreSQL 13 and later provide BEFORE/FOR EACH ROW triggers for partitioned tables.
ERROR:  "tab" is a partitioned table DETAIL:  Partitioned tables cannot have BEFORE / FOR EACH ROW triggers.
When data is inserted, the partitioned table definition cannot be modified due to the table lock; that is, child tables cannot be attached. Therefore, another connection must be used to perform the ATTACH operation. Here, the LISTEN/NOTIFY mechanism can be used to ask another connection to modify the partition definition.
ERROR:  cannot CREATE TABLE .. PARTITION OF "tab" because it is being used by active queries in this session Or ERROR:  cannot ALTER TABLE "tab" because it is being used by active queries in this session Trigger (implementing child table creation and NOTIFY) CREATE FUNCTION part_trig() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN BEGIN /* try to create a table for the new partition */ EXECUTE format('CREATE TABLE %I (LIKE tab INCLUDING INDEXES)', 'tab_' || to_char(NEW.ts, 'YYYYMMDD'));
﻿

/*
  * tell listener to attach the partition
  * (only if a new table was created)
*/ EXECUTE format('NOTIFY tab, %L', to_char(NEW.ts, 'YYYYMMDD'));
EXCEPTION WHEN duplicate_table THEN NULL; -- ignore END;
﻿

/* insert into the new partition */ EXECUTE format('INSERT INTO %I VALUES ($1.*)', 'tab_' || to_char(NEW.ts, 'YYYYMMDD')) USING NEW;
﻿

/* skip insert into the partitioned table */ RETURN NULL;
END;
$$;
﻿

CREATE TRIGGER part_trig BEFORE INSERT ON TAB FOR EACH ROW WHEN (pg_trigger_depth() < 1) EXECUTE FUNCTION part_trig();
Code (implementing LISTEN and ATTACH for child tables)
#!/usr/bin/env python3.9
# encoding:utf8
import asyncio
﻿

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT ﻿

conn = psycopg2.connect('application_name=listener') conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT) cursor = conn.cursor() cursor.execute(f'LISTEN tab;') ﻿

﻿

def attach_partition(table, date):
with conn.cursor() as cs:
cs.execute('ALTER TABLE "%s" ATTACH PARTITION "%s_%s" FOR VALUES IN (\\'%s\\')' % (table, table, date, date)) ﻿

﻿

def handle_notify():
conn.poll() for notify in conn.notifies:
print(notify.payload) attach_partition(notify.channel, notify.payload) conn.notifies.clear() ﻿

loop = asyncio.get_event_loop() loop.add_reader(conn, handle_notify) loop.run_forever() Summary This document describes two schemes for automatic partition creation as summarized below:
The solutions in the scheduled partition creation scenario are simple and easy to understand, but they depend on the schedule management mechanism of the system or extension and incur additional management costs during Ops and migration.
In the on-demand real-time partition creation scenario, the number of unnecessary partitions can be reduced according to the actual data pattern, but a later version (≥13) and an additional connection are required, making the scheme more complicated.
You can choose an appropriate automatic partition creation method based on your business conditions.
Scenario

Version

Implementation

Need of System Scheduler or Extension Required

Need of Additional Connection Mechanism Required

Cost

Scheduled partition creation

PostgreSQL 10

Easy

Yes

No

High

On-demand real-time partition creation

PostgreSQL 13 or later

Complicated

No

Yes

Low ﻿

Previous Topic: Cross-Database Access Next Topic: Searching in High Numbers of Tags Based on pg_roaringbitmap Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Use Cases
1. Scheduled partition creation
2. On-demand real-time partition creation
Summary Search AllCurrent Product Search titles only Enter keywords to search documentation
