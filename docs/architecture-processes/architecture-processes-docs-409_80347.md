# Overview of AI Capabilities for TencentDB for PostgreSQL

> 来源: https://www.tencentcloud.com/document/product/409/80347

TencentDB for PostgreSQL Release Notes and Announcements Release Notes Product Announcements Product Introduction Overview Features Strengths Scenarios Regions and AZs Product Feature List Major Version Lifecycle Description MSSQL Compatible Version Billing Billing Overview Instance Type and Specification Purchase Methods Overdue Payments Refund Backup Space Billing Database Audit Billing Overview Getting Started Creating TencentDB for PostgreSQL Instance Connecting to TencentDB for PostgreSQL Instance Managing TencentDB for PostgreSQL Instance Importing Data Migrating Data with DTS Kernel Version Introduction Kernel Version Overview Kernel Version Release Notes Viewing Kernel Version Proprietary Kernel Features Database Audit Audit Service Description Enabling the Audit Service View Audit Logs Modify audit services Audit Performance Description User Guide Instance Management Upgrading Instance CPU Elastic Scaling Read-Only Instance Account Management Database Management Database Proxy Parameter Management Log Management and Analysis Backup and Restoration Extension Management Network Management Access Management Data Security Tenant and Resource Isolation Security Groups Monitoring and Alarms Tag AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Automatic Vectorization AI Large Model Invocation Vector and Graph Search Multi-Agent Long-Term Memory AI for DB Intelligent Ops AI Vibe Coding Supabase Practical Tutorial Branch Capabilities Cloud Disk Edition Overview of PostgreSQL Cloud Disk Edition Viewing Instance Backups Migrating to Cloud Disk Edition Use Cases Cross-Database Access Automatically Creating Partition in PostgreSQL Searching in High Numbers of Tags Based on pg_roaringbitmap Querying People Nearby with One SQL Statement Configuring TencentDB for PostgreSQL as GitLab's External Data Source Supporting Tiered Storage Based on cos_fdw Extension Implement Read/Write Separation via pgpool Implementing Slow SQL Analysis Using the Auto_explain Plugin Using pglogical for Logical Replication Using Debezium to Collect PostgreSQL Data Set Up a Remote Disaster Recovery Environment for PostgreSQL Locally on CVM Read-Only Instance and Read-Only Group Practical Tutorial How to use failover slot for logical replication How to Use SCF for Scheduled Database Operations Fix Table Bloat Migration Guide DTS-Based Logical Migration Physical migration based on DTS DTS-Based Data Sync Performance White Paper Test Methods Test Results ​​API Reference History Introduction API Category Making API Requests Instance APIs Read-Only Instance APIs Backup and Recovery APIs Parameter Management APIs Security Group APIs Performance Optimization APIs Account APIs Database APIs Specification APIs Task APIs Other APIs Database Audit APIs Network APIs Data Types Error Codes Security and Compliance Information Security Standards and Certifications FAQs Agreements Service Level Agreement Terms of Service Glossary Contact Us Documentation TencentDB for PostgreSQL AI Capabilities Overview of AI Capabilities for TencentDB for PostgreSQL Overview of AI Capabilities for TencentDB for PostgreSQL Download Focus Mode Font Size Last updated: 2026-06-08 10:32:12 AI-Translated This document provides an overview of TencentDB for PostgreSQL's AI capabilities.
Product Positioning TencentDB for PostgreSQL provides a data foundation capability for the AI era. Centered around the two major directions of DB for AI (database empowering AI applications) and AI for DB (AI empowering database Ops), it offers a one-stop solution for enterprises to build AI-native applications.
Capability Landscape DB for AI (Database Empowering AI) Capability Module

Core Feature

Typical Scenario

Large Model Invocation

Directly invoke large language models in SQL via the tencentdb_ai plugin.

Text Classification, Sentiment Analysis, Intelligent Summarization

Vector Search

Based on pgvector (HNSW/IVFFlat) and pgvectorscale (DiskANN)

RAG search, semantic search, image search

Graph Database

Attribute graph storage and Cypher query based on Apache AGE

Knowledge Graph, GraphRAG, Relationship Reasoning

Agent Memory

Long-term memory storage for multiple agents, integrating vector + graph + relational data in a unified architecture

Long-term memory for AI agents, multi-agent collaboration

REST API

HTTP interface based on PostgREST

Frontend-backend separation, Serverless applications AI for DB (AI Empowering Ops) Capability Module

Core Feature

Typical Scenario

Intelligent Index Recommendation

tencentdb_index_advisor automatically analyzes workloads and recommends optimal indexes.

Performance tuning, new service launch assessment

AI Slow SQL Diagnosis

Automatically diagnoses slow queries and provides optimization suggestions by leveraging AI large models.

Routine Ops, performance troubleshooting Quick Start If you are using TencentDB for PostgreSQL's AI capabilities for the first time, we recommend following the path below to get started:
1.
To call a large model in SQL, see tencentdb_ai plugin feature introduction.
2.
To perform vector semantic search, see pgvector vector extension usage guide.
3.
To build a knowledge graph, see Apache AGE graph database usage guide.
4.
To enable an AI Agent to use a database, see Agent Long-term Memory Feature Overview.
5.
To optimize database performance, see Intelligent Index Recommendation.
Previous Topic: Editing Tag Next Topic: Automatic Vectorization Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Product Positioning Capability Landscape DB for AI (Database Empowering AI) AI for DB (AI Empowering Ops) Quick Start Search AllCurrent Product Search titles only Enter keywords to search documentation
