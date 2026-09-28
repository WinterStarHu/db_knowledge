---
sidebarTitle: 'Stored procedures & query parameters'
keywords: ['clickhouse', 'stored procedures', 'prepared statements', 'query parameters', 'UDF', 'parameterized views']
description: 'Guide on stored procedures, prepared statements, and query parameters in ClickHouse'
slug: /guides/developer/stored-procedures-and-prepared-statements
title: 'Stored procedures and query parameters in ClickHouse'
doc_type: 'guide'
---

If you're coming from a traditional relational database, you may be looking for stored procedures and prepared statements in ClickHouse.
This guide explains ClickHouse's approach to these concepts and provides recommended alternatives.

## Alternatives to stored procedures in ClickHouse {#alternatives-to-stored-procedures}

ClickHouse doesn't support traditional stored procedures with control flow logic (`IF`/`ELSE`, loops, etc.).
This is an intentional design decision based on ClickHouse's architecture as an analytical database.
Loops are discouraged for analytical databases because processing O(n) simple queries is usually slower than processing fewer complex queries.

ClickHouse is optimized for:
- **Analytical workloads** - Complex aggregations over large datasets
- **Batch processing** - Handling large data volumes efficiently
- **Declarative queries** - SQL queries that describe what data to retrieve, not how to process it

Stored procedures with procedural logic work against these optimizations. Instead, ClickHouse provides alternatives that align with its strengths.

### User-Defined Functions (UDFs) {#user-defined-functions}

User-Defined Functions let you encapsulate reusable logic without control flow. ClickHouse supports two types:

#### Lambda-based UDFs {#lambda-based-udfs}

Create functions using SQL expressions and lambda syntax:

```sql
-- Create the products table
CREATE TABLE products (
    product_id UInt32,
    product_name String,
    price Decimal(10, 2)
)
ENGINE = MergeTree()
ORDER BY product_id;

-- Insert sample data
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 899.99),
(2, 'Wireless Mouse', 24.99),
(3, 'USB-C Cable', 12.50),
(4, 'Monitor', 299.00),
(5, 'Keyboard', 79.99),
(6, 'Webcam', 54.95),
(7, 'Desk Lamp', 34.99),
(8, 'External Hard Drive', 119.99),
(9, 'Headphones', 149.00),
(10, 'Phone Stand', 15.99);
```

```sql
-- Simple calculation function
CREATE FUNCTION calculate_tax AS (price, rate) -> price * rate;

SELECT
    product_name,
    price,
    calculate_tax(price, 0.08) AS tax
FROM products;
```

```sql
-- Conditional logic using if()
CREATE FUNCTION price_tier AS (price) ->
    if(price < 100, 'Budget',
       if(price < 500, 'Mid-range', 'Premium'));

SELECT
    product_name,
    price,
    price_tier(price) AS tier
FROM products;
```

```sql
-- String manipulation
CREATE FUNCTION format_phone AS (phone) ->
    concat('(', substring(phone, 1, 3), ') ',
           substring(phone, 4, 3), '-',
           substring(phone, 7, 4));

SELECT format_phone('5551234567');
-- Result: (555) 123-4567
```

**Limitations:**
- No loops or complex control flow
- Can't modify data (`INSERT`/`UPDATE`/`DELETE`)
- Recursive functions not allowed

See [`CREATE FUNCTION`](/reference/statements/create/function) for complete syntax.

#### Executable UDFs {#executable-udfs}

For more complex logic, use executable UDFs that call external programs:

```xml
executable
sentiment_score
Float32
String
TabSeparated
python3 /opt/scripts/sentiment.py
```

```sql
-- Use the executable UDF
SELECT
    review_text,
    sentiment_score(review_text) AS score
FROM customer_reviews;
```

Executable UDFs can implement arbitrary logic in any language (Python, Node.js, Go, etc.).

See [Executable UDFs](/reference/functions/regular-functions/udf) for details.

### Parameterized views {#parameterized-views}

Parameterized views act like functions that return datasets.
They're ideal for reusable queries with dynamic filtering:

```sql
-- Create the sales table
CREATE TABLE sales (
  date Date,
  product_id UInt32,
  product_name String,
  category String,
  quantity UInt32,
  revenue Decimal(10, 2),
  sales_amount Decimal(10, 2)
)
ENGINE = MergeTree()
ORDER BY (date, product_id);

-- Insert sample data
INSERT INTO sales VALUES
('2024-01-05', 12345, 'Laptop Pro', 'Electronics', 2, 1799.98, 1799.98),
('2024-01-06', 12345, 'Laptop Pro', 'Electronics', 1, 899.99, 899.99),
('2024-01-10', 12346, 'Wireless Mouse', 'Electronics', 5, 124.95, 124.95),
('2024-01-15', 12347, 'USB-C Cable', 'Accessories', 10, 125.00, 125.00),
('2024-01-20', 12345, 'Laptop Pro', 'Electronics', 3, 2699.97, 2699.97),
('2024-01-25', 12348, 'Monitor 4K', 'Electronics', 2, 598.00, 598.00),
('2024-02-01', 12345, 'Laptop Pro', 'Electronics', 1, 899.99, 899.99),
('2024-02-05', 12349, 'Keyboard Mechanical', 'Accessories', 4, 319.96, 319.96),
('2024-02-10', 12346, 'Wireless Mouse', 'Electronics', 8, 199.92, 199.92),
('2024-02-15', 12350, 'Webcam HD', 'Electronics', 3, 164.85, 164.85);
```
```sql
-- Create a parameterized view
CREATE VIEW sales_by_date AS
SELECT
    date,
    product_id,
    sum(quantity) AS total_quantity,
    sum(revenue) AS total_revenue
FROM sales
WHERE date BETWEEN {start_date:Date} AND {end_date:Date}
GROUP BY date, product_id;
```

```sql
-- Query the view with parameters
SELECT *
FROM sales_by_date(start_date='2024-01-01', end_date='2024-01-31')
WHERE product_id = 12345;
```

#### Common use cases {#common-use-cases}
- Dynamic date range filtering
- User-specific data slicing
- [Multi-tenant data access](/products/cloud/guides/best-practices/multitenancy)
- Report templates
- [Data masking](/products/cloud/guides/security/data-masking)

```sql
-- More complex parameterized view
CREATE VIEW top_products_by_category AS
SELECT
    category,
    product_name,
    revenue,
    rank
FROM (
    SELECT
        category,
        product_name,
        revenue,
        rank() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank
    FROM (
        SELECT
            category,
            product_name,
            sum(sales_amount) AS revenue
        FROM sales
        WHERE category = {category:String}
            AND date >= {min_date:Date}
        GROUP BY category, product_name
    )
)
WHERE rank <= {top_n:UInt32};

-- Use it
SELECT * FROM top_products_by_category(
    category='Electronics',
    min_date='2024-01-01',
    top_n=10
);
```

See the [Parameterized Views](/reference/statements/create/view#parameterized-view) section for more information.

### Materialized views {#materialized-views}

Materialized views are ideal for pre-computing expensive aggregations that would traditionally be done in stored procedures. If you're coming from a traditional database, think of a materialized view as an **INSERT trigger** that automatically transforms and aggregates data as it's inserted into the source table:

```sql
-- Source table
CREATE TABLE page_views (
    user_id UInt64,
    page String,
    timestamp DateTime,
    session_id String
)
ENGINE = MergeTree()
ORDER BY (user_id, timestamp);

-- Materialized view that maintains aggregated statistics
CREATE MATERIALIZED VIEW daily_user_stats
ENGINE = SummingMergeTree()
ORDER BY (date, user_id)
AS SELECT
    toDate(timestamp) AS date,
    user_id,
    count() AS page_views,
    uniq(session_id) AS sessions,
    uniq(page) AS unique_pages
FROM page_views
GROUP BY date, user_id;

-- Insert sample data into source table
INSERT INTO page_views VALUES
(101, '/home', '2024-01-15 10:00:00', 'session_a1'),
(101, '/products', '2024-01-15 10:05:00', 'session_a1'),
(101, '/checkout', '2024-01-15 10:10:00', 'session_a1'),
(102, '/home', '2024-01-15 11:00:00', 'session_b1'),
(102, '/about', '2024-01-15 11:05:00', 'session_b1'),
(101, '/home', '2024-01-16 09:00:00', 'session_a2'),
(101, '/products', '2024-01-16 09:15:00', 'session_a2'),
(103, '/home', '2024-01-16 14:00:00', 'session_c1'),
(103, '/products', '2024-01-16 14:05:00', 'session_c1'),
(103, '/products', '2024-01-16 14:10:00', 'session_c1'),
(102, '/home', '2024-01-17 10:30:00', 'session_b2'),
(102, '/contact', '2024-01-17 10:35:00', 'session_b2');

-- Query pre-aggregated data
SELECT
    user_id,
    sum(page_views) AS total_views,
    sum(sessions) AS total_sessions
FROM daily_user_stats
WHERE date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY user_id;
```

#### Refreshable materialized views {#refreshable-materialized-views}

For scheduled batch processing (like nightly stored procedures):

```sql
-- Automatically refresh every day at 2 AM
CREATE MATERIALIZED VIEW monthly_sales_report
REFRESH EVERY 1 DAY OFFSET 2 HOUR
AS SELECT
    toStartOfMonth(order_date) AS month,
    region,
    product_category,
    count() AS order_count,
    sum(amount) AS total_revenue,
    avg(amount) AS avg_order_value
FROM orders
WHERE order_date >= today() - INTERVAL 13 MONTH
GROUP BY month, region, product_category;

-- Query always has fresh data
SELECT * FROM monthly_sales_report
WHERE month = toStartOfMonth(today());
```

See [Cascading Materialized Views](/concepts/features/materialized-views/cascading-materialized-views) for advanced patterns.

### External orchestration {#external-orchestration}

For complex business logic, ETL workflows, or multi-step processes, it's always possible to implement logic outside ClickHouse, using language clients.

#### Using application code {#using-application-code}

Here's a side-by-side comparison showing how a MySQL stored procedure translates to application code with ClickHouse:

#### Key differences {#key-differences}

1. **Control flow** - MySQL stored procedure uses `IF/ELSE`, `WHILE` loops. In ClickHouse, implement this logic in your application code (Python, Java, etc.)
2. **Transactions** - MySQL supports `BEGIN/COMMIT/ROLLBACK` for ACID transactions. ClickHouse is an analytical database optimized for append-only workloads, not transactional updates
3. **Updates** - MySQL uses `UPDATE` statements. ClickHouse prefers `INSERT` with [ReplacingMergeTree](/reference/engines/table-engines/mergetree-family/replacingmergetree) or [CollapsingMergeTree](/reference/engines/table-engines/mergetree-family/collapsingmergetree) for mutable data
4. **Variables and state** - MySQL stored procedures can declare variables (`DECLARE v_discount`). With ClickHouse, manage state in your application code
5. **Error handling** - MySQL supports `SIGNAL` and exception handlers. In application code, use your language's native error handling (try/catch)

**When to use each approach:**

- **OLTP workloads** (orders, payments, user accounts) → Use MySQL or PostgreSQL for application transactions and stored procedures. [ClickHouse Managed Postgres](/products/managed-postgres/overview) is available in ClickHouse Cloud.
- **Analytics workloads** (reporting, aggregations, time-series) → Use ClickHouse with application orchestration
- **Hybrid architecture** → Keep application transactions in Postgres and replicate committed changes to ClickHouse for analytics. See [how Postgres and ClickHouse work together](/products/managed-postgres/overview#transactions-and-analytics) and the [integration quickstart](/products/managed-postgres/quickstart#part-2).

#### Using workflow orchestration tools {#using-workflow-orchestration-tools}

- **Apache Airflow** - Schedule and monitor complex DAGs of ClickHouse queries
- **dbt** - Transform data with SQL-based workflows
- **Prefect/Dagster** - Modern Python-based orchestration
- **Custom schedulers** - Cron jobs, Kubernetes CronJobs, etc.

**Benefits of external orchestration:**
- Full programming language capabilities
- Better error handling and retry logic
- Integration with external systems (APIs, other databases)
- Version control and testing
- Monitoring and alerting
- More flexible scheduling

## Alternatives to prepared statements in ClickHouse {#alternatives-to-prepared-statements-in-clickhouse}

While ClickHouse doesn't have traditional "prepared statements" in the RDBMS sense, it provides **query parameters** that serve the same purpose: safe, parameterized queries that prevent SQL injection.

### Syntax {#query-parameters-syntax}

There are two ways to define query parameters:

#### Method 1: using `SET` {#method-1-using-set}

```sql
-- Create the user_events table (ClickHouse syntax)
CREATE TABLE user_events (
    event_id UInt32,
    user_id UInt64,
    event_name String,
    event_date Date,
    event_timestamp DateTime
) ENGINE = MergeTree()
ORDER BY (user_id, event_date);

-- Insert sample data for multiple users and events
INSERT INTO user_events (event_id, user_id, event_name, event_date, event_timestamp) VALUES
(1, 12345, 'page_view', '2024-01-05', '2024-01-05 10:30:00'),
(2, 12345, 'page_view', '2024-01-05', '2024-01-05 10:35:00'),
(3, 12345, 'add_to_cart', '2024-01-05', '2024-01-05 10:40:00'),
(4, 12345, 'page_view', '2024-01-10', '2024-01-10 14:20:00'),
(5, 12345, 'add_to_cart', '2024-01-10', '2024-01-10 14:25:00'),
(6, 12345, 'purchase', '2024-01-10', '2024-01-10 14:30:00'),
(7, 12345, 'page_view', '2024-01-15', '2024-01-15 09:15:00'),
(8, 12345, 'page_view', '2024-01-15', '2024-01-15 09:20:00'),
(9, 12345, 'page_view', '2024-01-20', '2024-01-20 16:45:00'),
(10, 12345, 'add_to_cart', '2024-01-20', '2024-01-20 16:50:00'),
(11, 12345, 'purchase', '2024-01-25', '2024-01-25 11:10:00'),
(12, 12345, 'page_view', '2024-01-28', '2024-01-28 13:30:00'),
(13, 67890, 'page_view', '2024-01-05', '2024-01-05 11:00:00'),
(14, 67890, 'add_to_cart', '2024-01-05', '2024-01-05 11:05:00'),
(15, 67890, 'purchase', '2024-01-05', '2024-01-05 11:10:00'),
(16, 12345, 'page_view', '2024-02-01', '2024-02-01 10:00:00'),
(17, 12345, 'add_to_cart', '2024-02-01', '2024-02-01 10:05:00');
```

```sql
SET param_user_id = 12345;
SET param_start_date = '2024-01-01';
SET param_end_date = '2024-01-31';

SELECT
    event_name,
    count() AS event_count
FROM user_events
WHERE user_id = {user_id: UInt64}
    AND event_date BETWEEN {start_date: Date} AND {end_date: Date}
GROUP BY event_name;
```

#### Method 2: using CLI parameters {#method-2-using-cli-parameters}

```bash
clickhouse-client \
    --param_user_id=12345 \
    --param_start_date='2024-01-01' \
    --param_end_date='2024-01-31' \
    --query="SELECT count() FROM user_events
             WHERE user_id = {user_id: UInt64}
             AND event_date BETWEEN {start_date: Date} AND {end_date: Date}"
```

### Parameter syntax {#parameter-syntax}

Parameters are referenced using: `{parameter_name: DataType}`

- `parameter_name` - The name of the parameter (without the `param_` prefix)
- `DataType` - The ClickHouse data type to cast the parameter to

### Data type examples {#data-type-examples}

```sql
-- 1. Create a table for string and number tests
CREATE TABLE IF NOT EXISTS users (
    name String,
    age UInt8,
    salary Float64
) ENGINE = Memory;

INSERT INTO users VALUES
    ('John Doe', 25, 75000.50),
    ('Jane Smith', 30, 85000.75),
    ('Peter Jones', 20, 50000.00);

-- 2. Create a table for date and timestamp tests
CREATE TABLE IF NOT EXISTS events (
    event_date Date,
    event_timestamp DateTime
) ENGINE = Memory;

INSERT INTO events VALUES
    ('2024-01-15', '2024-01-15 14:30:00'),
    ('2024-01-15', '2024-01-15 15:00:00'),
    ('2024-01-16', '2024-01-16 10:00:00');

-- 3. Create a table for array tests
CREATE TABLE IF NOT EXISTS products (
    id UInt32,
    name String
) ENGINE = Memory;

INSERT INTO products VALUES (1, 'Laptop'), (2, 'Monitor'), (3, 'Mouse'), (4, 'Keyboard');

-- 4. Create a table for Map (struct-like) tests
CREATE TABLE IF NOT EXISTS accounts (
    user_id UInt32,
    status String,
    type String
) ENGINE = Memory;

INSERT INTO accounts VALUES
    (101, 'active', 'premium'),
    (102, 'inactive', 'basic'),
    (103, 'active', 'basic');

-- 5. Create a table for Identifier tests
CREATE TABLE IF NOT EXISTS sales_2024 (
    value UInt32
) ENGINE = Memory;

INSERT INTO sales_2024 VALUES (100), (200), (300);
```

For use of query parameters in [language clients](/integrations/language-clients/index), refer to the documentation for the specific language client you're interested in.

### Limitations of query parameters {#limitations-of-query-parameters}

Query parameters are **not general text substitutions**. They have specific limitations:

1. They're **primarily intended for SELECT statements** - the best support is in SELECT queries
2. They **work as identifiers or literals** - they can't substitute arbitrary SQL fragments
3. They have **limited DDL support** - they're supported in `CREATE TABLE`, but not in `ALTER TABLE`

**What WORKS:**
```sql
-- ✓ Values in WHERE clause
SELECT * FROM users WHERE id = {user_id: UInt64};

-- ✓ Table/database names
SELECT * FROM {db: Identifier}.{table: Identifier};

-- ✓ Values in IN clause
SELECT * FROM products WHERE id IN {ids: Array(UInt32)};

-- ✓ CREATE TABLE
CREATE TABLE {table_name: Identifier} (id UInt64, name String) ENGINE = MergeTree() ORDER BY id;
```

**What DOESN'T work:**
```sql
-- ✗ Column names in SELECT (use Identifier carefully)
SELECT {column: Identifier} FROM users;  -- Limited support

-- ✗ Arbitrary SQL fragments
SELECT * FROM users {where_clause: String};  -- NOT SUPPORTED

-- ✗ ALTER TABLE statements
ALTER TABLE {table: Identifier} ADD COLUMN new_col String;  -- NOT SUPPORTED

-- ✗ Multiple statements
{statements: String};  -- NOT SUPPORTED
```

### Security best practices {#security-best-practices}

**Always use query parameters for user input:**

```python
# ✓ SAFE - Uses parameters
user_input = request.get('user_id')
result = client.query(
    "SELECT * FROM orders WHERE user_id = {uid: UInt64}",
    parameters={'uid': user_input}
)

# ✗ DANGEROUS - SQL injection risk!
user_input = request.get('user_id')
result = client.query(f"SELECT * FROM orders WHERE user_id = {user_input}")
```

**Validate input types:**

```python
def get_user_orders(user_id: int, start_date: str):
    # Validate types before querying
    if not isinstance(user_id, int) or user_id <= 0:
        raise ValueError("Invalid user_id")

    # Parameters enforce type safety
    return client.query(
        """
        SELECT * FROM orders
        WHERE user_id = {uid: UInt64}
            AND order_date >= {start: Date}
        """,
        parameters={'uid': user_id, 'start': start_date}
    )
```

### MySQL protocol prepared statements {#mysql-protocol-prepared-statements}

ClickHouse's [MySQL interface](/concepts/features/interfaces/mysql) includes minimal support for prepared statements (`COM_STMT_PREPARE`, `COM_STMT_EXECUTE`, `COM_STMT_CLOSE`), primarily to enable connectivity with tools like Tableau Online that wrap queries in prepared statements.

**Key limitations:**

- **Parameter binding isn't supported** - You can't use `?` placeholders with bound parameters
- Queries are stored but not parsed during `PREPARE`
- Implementation is minimal and designed for specific BI tool compatibility

**Example of what doesn't work:**

```sql
-- This MySQL-style prepared statement with parameters does NOT work in ClickHouse
PREPARE stmt FROM 'SELECT * FROM users WHERE id = ?';
EXECUTE stmt USING @user_id;  -- Parameter binding not supported
```

**Use ClickHouse's native query parameters instead.** They provide full parameter binding support, type safety, and SQL injection prevention across all ClickHouse interfaces:

```sql
-- ClickHouse native query parameters (recommended)
SET param_user_id = 12345;
SELECT * FROM users WHERE id = {user_id: UInt64};
```

For more details, see the [MySQL Interface documentation](/concepts/features/interfaces/mysql) and the [blog post on MySQL support](https://clickhouse.com/blog/mysql-support-in-clickhouse-the-journey).

## Summary {#summary}

### ClickHouse alternatives to stored procedures {#summary-stored-procedures}

| Traditional Stored Procedure Pattern | ClickHouse Alternative                                                      |
|--------------------------------------|-----------------------------------------------------------------------------|
| Simple calculations and transformations | User-Defined Functions (UDFs)                                               |
| Reusable parameterized queries | Parameterized Views                                                         |
| Pre-computed aggregations | Materialized Views                                                          |
| Scheduled batch processing | Refreshable Materialized Views                                              |
| Complex multi-step ETL | Chained materialized views or external orchestration (Python, Airflow, dbt) |
| Business logic with control flow | Application code                                                            |

### Use of query parameters {#summary-query-parameters}

Query parameters can be used for:
- Preventing SQL injection
- Parameterized queries with type safety
- Dynamic filtering in applications
- Reusable query templates

## Related documentation {#related-documentation}

- [`CREATE FUNCTION`](/reference/statements/create/function) - User-Defined Functions
- [`CREATE VIEW`](/reference/statements/create/view) - Views including parameterized and materialized
- [SQL Syntax - Query Parameters](/reference/syntax#defining-and-using-query-parameters) - Complete parameter syntax
- [Cascading Materialized Views](/concepts/features/materialized-views/cascading-materialized-views) - Advanced materialized view patterns
- [Executable UDFs](/reference/functions/regular-functions/udf) - External function execution
