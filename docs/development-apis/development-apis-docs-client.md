---
sidebarTitle: 'Client'
keywords: ['clickhouse', 'java', 'client', 'integrate']
description: 'Java ClickHouse Connector'
slug: /integrations/language-clients/java/client
title: 'Java client'
doc_type: 'reference'
integration:
  - support_level: 'core'
  - category: 'language_client'
---

import WideTableWrapper from "/snippets/components/WideTableWrapper/WideTableWrapper.jsx";

Java client library to communicate with a DB server through its protocols. The current implementation only supports the [HTTP interface](/concepts/features/interfaces/http).
The library provides its own API to send requests to a server. The library also provides tools to work with different binary data formats (RowBinary* & Native*).

## Setup {#setup}

- Maven Central (project web page): https://mvnrepository.com/artifact/com.clickhouse/client-v2
- Nightly builds (repository link): https://central.sonatype.com/repository/maven-snapshots/

## Initialization {#initialization}

The Client object is initialized by `com.clickhouse.client.api.Client.Builder#build()`. Each client has its own context and no objects are shared between them.
The Builder has configuration methods for convenient setup.

Example:
```java showLineNumbers
 Client client = new Client.Builder()
                .addEndpoint("https://clickhouse-cloud-instance:8443/")
                .setUsername(user)
                .setPassword(password)
                .build();
```

`Client` is `AutoCloseable` and should be closed when not needed anymore.

### Authentication {#authentication}

Authentication is configured per client at the initialization phase. There are three authentication methods supported: by password, by access token, by SSL Client Certificate.

Authentication by a password requires setting user name password by calling `setUsername(String)` and `setPassword(String)`:
```java showLineNumbers
 Client client = new Client.Builder()
        .addEndpoint("https://clickhouse-cloud-instance:8443/")
        .setUsername(user)
        .setPassword(password)
        .build();
```

Authentication by an access token requires setting access token by calling `setAccessToken(String)`:
```java showLineNumbers
 Client client = new Client.Builder()
        .addEndpoint("https://clickhouse-cloud-instance:8443/")
        .setAccessToken(userAccessToken)
        .build();
```

Authentication by a SSL Client Certificate require setting username, enabling SSL Authentication, setting a client certificate and a client key by calling `setUsername(String)`,  `useSSLAuthentication(boolean)`, `setClientCertificate(String)` and `setClientKey(String)` accordingly:
```java showLineNumbers
Client client = new Client.Builder()
        .useSSLAuthentication(true)
        .setUsername("some_user")
        .setClientCertificate("some_user.crt")
        .setClientKey("some_user.key")
```

## Configuration {#configuration}

All settings are defined by instance methods (a.k.a configuration methods) that make the scope and context of each value clear.
Major configuration parameters are defined in one scope (client or operation) and don't override each other.

Configuration is defined during client creation. See `com.clickhouse.client.api.Client.Builder`.

## Client Configuration {#client-configuration}

### Client Identification {#client-identification}

There are two fields in a query log that identify application originated a request: `client_name` and `http_user_agent`. Native TCP protocol uses `client_name` to identify application. HTTP protocol uses `http_user_agent` to identify application. Client builder has method `setClientName` correct values for both protocols.
The field `http_user_agent` is set according to `User-Agent` header common format: `application-name[/version] [(operating-system; architecture; ...)]`.
This set of values is repeated for each layer: application, client library, http client library. What is set by `setClientName` method comes first in the list.

For example:
```java showLineNumbers
client.setClientName("my-app-01/1.0");
```
will result in the following `http_user_agent` value:
```
my-app-01/1.0 clickhouse-java-v2/0.9.6-SNAPSHOT (Linux; jvm:17.0.17) Apache-HttpClient/5.4.4
```

Application can set own http header `User-Agent` to identify itself. But part `clickhouse-java-v2/0.9.6-SNAPSHOT` will be appended to the end of the header.

### Operation Identification {#operation-identification}

Query log has another two fields `query_id` and `log_comment` that can be used to identify an operation and add additional information to the query log.

`query_id` is a unique identifier of an operation. It can be set by application by calling `setQueryId` method of the `QuerySettings` class.
```java showLineNumbers
QuerySettings querySettings = new QuerySettings();
querySettings.setQueryId("some-query-id");
```

`log_comment` is a comment that can be added to the query log. It can be set by application by calling `logComment` method of the `QuerySettings` class.
```java showLineNumbers
QuerySettings querySettings = new QuerySettings();
querySettings.logComment("some-comment");
```

### Server Settings {#server-settings}

Server side settings can be set on the client level once while creation (see `serverSetting` method of the `Builder`) and on operation level (see `serverSetting` for operation settings class).

```java showLineNumbers
 try (Client client = new Client.Builder().addEndpoint(Protocol.HTTP, "localhost", mockServer.port(), false)
        .setUsername("default")
        .setPassword(ClickHouseServerForTest.getPassword())
        .compressClientRequest(true)

        // Client level
        .serverSetting("max_threads", "10")
        .serverSetting("async_insert", "1")
        .serverSetting("roles", Arrays.asList("role1", "role2"))

        .build()) {

	// Operation level
	QuerySettings querySettings = new QuerySettings();
	querySettings.serverSetting("session_timezone", "Europe/Zurich");

	...
}
```
⚠️ When options are set via `setOption` method (either the `Client.Builder` or operation settings class) then server settings name should be prefixed with `clickhouse_setting_`. The `com.clickhouse.client.api.ClientConfigProperties#serverSetting()` may be handy in this case.

### Custom HTTP Header

Custom HTTP headers can be set for all operations (client level) or a single one (operation level).
```java showLineNumbers

QuerySettings settings = new QuerySettings()
    .httpHeader(HttpHeaders.REFERER, clientReferer)
    .setQueryId(qId);

```

When options are set via `setOption` method (either the `Client.Builder` or operation settings class) then custom header name should be prefixed with `http_header_`. Method `com.clickhouse.client.api.ClientConfigProperties#httpHeader()` may be handy in this case.

## Common Definitions {#common-definitions}

### ClickHouseFormat {#clickhouseformat}

Enum of [supported formats](/reference/formats/index). It includes all formats that ClickHouse supports.

* `raw` - user should transcode raw data
* `full` - the client can transcode data by itself and accepts a raw data stream
* `-` - operation not supported by ClickHouse for this format

This client version supports:

| Format                                                                                                                        | Input  | Output  |
|-------------------------------------------------------------------------------------------------------------------------------|:------:|:-------:|
| [TabSeparated](/reference/formats/TabSeparated/TabSeparated)                                                                      | raw    | raw     |
| [TabSeparatedRaw](/reference/formats/TabSeparated/TabSeparatedRaw)                                                                | raw    | raw     |
| [TabSeparatedWithNames](/reference/formats/TabSeparated/TabSeparatedWithNames)                                                    | raw    | raw     |
| [TabSeparatedWithNamesAndTypes](/reference/formats/TabSeparated/TabSeparatedWithNamesAndTypes)                                    | raw    | raw     |
| [TabSeparatedRawWithNames](/reference/formats/TabSeparated/TabSeparatedRawWithNames)                                              | raw    | raw     |
| [TabSeparatedRawWithNamesAndTypes](/reference/formats/TabSeparated/TabSeparatedRawWithNamesAndTypes)                              | raw    | raw     |
| [Template](/reference/formats/Template/Template)                                                                       | raw    | raw     |
| [TemplateIgnoreSpaces](/reference/formats/Template/TemplateIgnoreSpaces)                                                      | raw    |  -      |
| [CSV](/reference/formats/CSV/CSV)                                                                                        | raw    | raw     |
| [CSVWithNames](/reference/formats/CSV/CSVWithNames)                                                                      | raw    | raw     |
| [CSVWithNamesAndTypes](/reference/formats/CSV/CSVWithNamesAndTypes)                                                      | raw    | raw     |
| [CustomSeparated](/reference/formats/CustomSeparated/CustomSeparated)                                                         | raw    | raw     |
| [CustomSeparatedWithNames](/reference/formats/CustomSeparated/CustomSeparatedWithNames)                                              | raw    | raw     |
| [CustomSeparatedWithNamesAndTypes](/reference/formats/CustomSeparated/CustomSeparatedWithNamesAndTypes)                              | raw    | raw     |
| [SQLInsert](/reference/formats/SQLInsert)                                                                            | -      | raw     |
| [Values](/reference/formats/Values)                                                                      | raw    | raw     |
| [Vertical](/reference/formats/Vertical)                                                                              | -      | raw     |
| [JSON](/reference/formats/JSON/JSON)                                                                                      | raw    | raw     |
| [JSONAsString](/reference/formats/JSON/JSONAsString)                                                                      | raw    | -       |
| [JSONAsObject](/reference/formats/JSON/JSONAsObject)                                                                      | raw    | -       |
| [JSONStrings](/reference/formats/JSON/JSONStrings)                                                                        | raw    | raw     |
| [JSONColumns](/reference/formats/JSON/JSONColumns)                                                                        | raw    | raw     |
| [JSONColumnsWithMetadata](/reference/formats/JSON/JSONColumnsWithMetadata)                                                   | raw    | raw     |
| [JSONCompact](/reference/formats/JSON/JSONCompact)                                                                        | raw    | raw     |
| [JSONCompactStrings](/reference/formats/JSON/JSONCompactStrings)                                                          | -      | raw     |
| [JSONCompactColumns](/reference/formats/JSON/JSONCompactColumns)                                                          | raw    | raw     |
| [JSONEachRow](/reference/formats/JSON/JSONEachRow)                                                                        | raw    | raw     |
| [PrettyJSONEachRow](/reference/formats/JSON/PrettyJSONEachRow)                                                            | -      | raw     |
| [JSONEachRowWithProgress](/reference/formats/JSON/JSONEachRowWithProgress)                                                | -      | raw     |
| [JSONStringsEachRow](/reference/formats/JSON/JSONStringsEachRow)                                                          | raw    | raw     |
| [JSONStringsEachRowWithProgress](/reference/formats/JSON/JSONStringsEachRowWithProgress)                                  | -      | raw     |
| [JSONCompactEachRow](/reference/formats/JSON/JSONCompactEachRow)                                                          | raw    | raw     |
| [JSONCompactEachRowWithNames](/reference/formats/JSON/JSONCompactEachRowWithNames)                                        | raw    | raw     |
| [JSONCompactEachRowWithNamesAndTypes](/reference/formats/JSON/JSONCompactEachRowWithNamesAndTypes)                        | raw    | raw     |
| [JSONCompactStringsEachRow](/reference/formats/JSON/JSONCompactStringsEachRow)                                            | raw    | raw     |
| [JSONCompactStringsEachRowWithNames](/reference/formats/JSON/JSONCompactStringsEachRowWithNames)                          | raw    | raw     |
| [JSONCompactStringsEachRowWithNamesAndTypes](/reference/formats/JSON/JSONCompactStringsEachRowWithNamesAndTypes)          | raw    | raw     |
| [JSONObjectEachRow](/reference/formats/JSON/JSONObjectEachRow)                                                            | raw    | raw     |
| [BSONEachRow](/reference/formats/BSONEachRow)                                                                        | raw    | raw     |
| [TSKV](/reference/formats/TabSeparated/TSKV)                                                                                      | raw    | raw     |
| [Pretty](/reference/formats/Pretty/Pretty)                                                                                  | -      | raw     |
| [PrettyNoEscapes](/reference/formats/Pretty/PrettyNoEscapes)                                                                | -      | raw     |
| [PrettyMonoBlock](/reference/formats/Pretty/PrettyMonoBlock)                                                                | -      | raw     |
| [PrettyNoEscapesMonoBlock](/reference/formats/Pretty/PrettyNoEscapesMonoBlock)                                              | -      | raw     |
| [PrettyCompact](/reference/formats/Pretty/PrettyCompact)                                                                    | -      | raw     |
| [PrettyCompactNoEscapes](/reference/formats/Pretty/PrettyCompactNoEscapes)                                                  | -      | raw     |
| [PrettyCompactMonoBlock](/reference/formats/Pretty/PrettyCompactMonoBlock)                                                  | -      | raw     |
| [PrettyCompactNoEscapesMonoBlock](/reference/formats/Pretty/PrettyCompactNoEscapesMonoBlock)                                | -      | raw     |
| [PrettySpace](/reference/formats/Pretty/PrettySpace)                                                                        | -      | raw     |
| [PrettySpaceNoEscapes](/reference/formats/Pretty/PrettySpaceNoEscapes)                                                      | -      | raw     |
| [PrettySpaceMonoBlock](/reference/formats/Pretty/PrettySpaceMonoBlock)                                                      | -      | raw     |
| [PrettySpaceNoEscapesMonoBlock](/reference/formats/Pretty/PrettySpaceNoEscapesMonoBlock)                                    | -      | raw     |
| [Prometheus](/reference/formats/Prometheus)                                                                          | -      | raw     |
| [Protobuf](/reference/formats/Protobuf/Protobuf)                                                                              | raw    | raw     |
| [ProtobufSingle](/reference/formats/Protobuf/ProtobufSingle)                                                                  | raw    | raw     |
| [ProtobufList](/reference/formats/Protobuf/ProtobufList)                                                                                                      | raw    | raw     |
| [Avro](/reference/formats/Avro/Avro)                                                                          | raw    | raw     |
| [AvroConfluent](/reference/formats/Avro/AvroConfluent)                                                       | raw    | -       |
| [Parquet](/reference/formats/Parquet/Parquet)                                                                    | raw    | raw     |
| [ParquetMetadata](/reference/formats/Parquet/ParquetMetadata)                                                   | raw    | -       |
| [Arrow](/reference/formats/Arrow/Arrow)                                                                        | raw    | raw     |
| [ArrowStream](/reference/formats/Arrow/ArrowStream)                                                           | raw    | raw     |
| [ORC](/reference/formats/ORC)                                                                            | raw    | raw     |
| [One](/reference/formats/One)                                                                            | raw    | -       |
| [Npy](/reference/formats/Npy)                                                                            | raw    | raw     |
| [RowBinary](/reference/formats/RowBinary/RowBinary)                                                                            | full   | full    |
| [RowBinaryWithNames](/reference/formats/RowBinary/RowBinaryWithNamesAndTypes)                                                  | full   | full    |
| [RowBinaryWithNamesAndTypes](/reference/formats/RowBinary/RowBinaryWithNamesAndTypes)                                          | full   | full    |
| [RowBinaryWithDefaults](/reference/formats/RowBinary/RowBinaryWithDefaults)                                                    | full   | -       |
| [Native](/reference/formats/Native)                                                                                  | full   | raw     |
| [Null](/reference/formats/Null)                                                                                      | -      | raw     |
| [XML](/reference/formats/XML)                                                                                        | -      | raw     |
| [CapnProto](/reference/formats/CapnProto)                                                                            | raw    | raw     |
| [LineAsString](/reference/formats/LineAsString/LineAsString)                                                                      | raw    | raw     |
| [Regexp](/reference/formats/Regexp)                                                                      | raw    | -       |
| [RawBLOB](/reference/formats/RawBLOB)                                                                                | raw    | raw     |
| [MsgPack](/reference/formats/MsgPack)                                                                                | raw    | raw     |
| [MySQLDump](/reference/formats/MySQLDump)                                                                            | raw    | -       |
| [DWARF](/reference/formats/DWARF)                                                                                    | raw    | -       |
| [Markdown](/reference/formats/Markdown)                                                                              | -      | raw     |
| [Form](/reference/formats/Form)                                                                                      | raw    | -       |

## Insert API {#insert-api}

### insert(String tableName, InputStream data, ClickHouseFormat format) {#insertstring-tablename-inputstream-data-clickhouseformat-format}

Accepts data as an `InputStream` of bytes in the specified format. It is expected that `data` is encoded in the `format`.

**Signatures**

```java
CompletableFuture insert(String tableName, InputStream data, ClickHouseFormat format, InsertSettings settings)
CompletableFuture insert(String tableName, InputStream data, ClickHouseFormat format)
```

**Parameters**

`tableName` - a target table name.

`data` - an input stream of an encoded data.

`format` - a format in which the data is encoded.

`settings` - request settings.

**Return value**

Future of `InsertResponse` type - result of the operation and additional information like server side metrics.

**Examples**

```java showLineNumbers
try (InputStream dataStream = getDataStream()) {
    try (InsertResponse response = client.insert(TABLE_NAME, dataStream, ClickHouseFormat.JSONEachRow,
            insertSettings).get(3, TimeUnit.SECONDS)) {

        log.info("Insert finished: {} rows written", response.getMetrics().getMetric(ServerMetrics.NUM_ROWS_WRITTEN).getLong());
    } catch (Exception e) {
        log.error("Failed to write JSONEachRow data", e);
        throw new RuntimeException(e);
    }
}

```

### insert(String tableName, List&lt;?> data, InsertSettings settings) {#insertstring-tablename-listlt-data-insertsettings-settings}

Sends a write request to database. The list of objects is converted into an efficient format and then is sent to a server. The class of the list items should be registered up-front using `register(Class, TableSchema)` method.

**Signatures**
```java
client.insert(String tableName, List data, InsertSettings settings)
client.insert(String tableName, List data)
```

**Parameters**

`tableName` - name of the target table.

`data` - collection DTO (Data Transfer Object) objects.

`settings` - request settings.

**Return value**

Future of `InsertResponse` type - the result of the operation and additional information like server side metrics.

**Examples**

```java showLineNumbers
// Important step (done once) - register class to pre-compile object serializer according to the table schema.
client.register(ArticleViewEvent.class, client.getTableSchema(TABLE_NAME));

List events = loadBatch();

try (InsertResponse response = client.insert(TABLE_NAME, events).get()) {
    // handle response, then it will be closed and connection that served request will be released.
}
```

### InsertSettings {#insertsettings}

Configuration options for insert operations.

**Configuration methods**

| Method                                       | Description                                                                                                                |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `setQueryId(String queryId)`                 | Sets query ID that will be assigned to the operation. Default: `null`.                                                     |
| `setDeduplicationToken(String token)`        | Sets the deduplication token. This token will be sent to the server and can be used to identify the query. Default: `null`. |
| `setInputStreamCopyBufferSize(int size)`     | Copy buffer size. The buffer is used during write operations to copy data from user-provided input stream to an output stream. Default: `8196`. |
| `serverSetting(String name, String value)`   | Sets individual server settings for an operation.                                                                          |
| `serverSetting(String name, Collection values)` | Sets individual server settings with multiple values for an operation. Items of the collection should be `String` values.  |
| `setDBRoles(Collection dbRoles)`             | Sets DB roles to be set before executing an operation. Items of the collection should be `String` values.                  |
| `setOption(String option, Object value)`     | Sets a configuration option in raw format. This isn't a server setting.                                                  |

### InsertResponse {#insertresponse}

Response object that holds result of insert operation. It is only available if the client got response from a server.

| Method                      | Description                                                                                          |
|-----------------------------|------------------------------------------------------------------------------------------------------|
| `OperationMetrics getMetrics()` | Returns object with operation metrics.                                                           |
| `String getQueryId()`       | Returns query ID assigned for the operation by the application (through operation settings or by server). |

## Query API {#query-api}

### query(String sqlQuery) {#querystring-sqlquery}

Sends `sqlQuery` as is. Response format is set by query settings. `QueryResponse` will hold a reference to the response stream that should be consumed by a reader for the supportig format.

**Signatures**

```java
CompletableFuture query(String sqlQuery, QuerySettings settings)
CompletableFuture query(String sqlQuery)
```

**Parameters**

`sqlQuery` - a single SQL statement. The Query is sent as is to a server.

`settings` - request settings.

**Return value**

Future of `QueryResponse` type - a result dataset and additional information like server side metrics. The Response object should be closed after consuming the dataset.

**Examples**

```java
final String sql = "select * from " + TABLE_NAME + " where title <> '' limit 10";

// Default format is RowBinaryWithNamesAndTypesFormatReader so reader have all information about columns
try (QueryResponse response = client.query(sql).get(3, TimeUnit.SECONDS);) {

    // Create a reader to access the data in a convenient way
    ClickHouseBinaryFormatReader reader = client.newBinaryFormatReader(response);

    while (reader.hasNext()) {
        reader.next(); // Read the next record from stream and parse it

        // get values
        double id = reader.getDouble("id");
        String title = reader.getString("title");
        String url = reader.getString("url");

        // collecting data
    }
} catch (Exception e) {
    log.error("Failed to read data", e);
}

// put business logic outside of the reading block to release http connection asap.
```

### query(String sqlQuery, Map&lt;String, Object> queryParams, QuerySettings settings) {#querystring-sqlquery-mapltstring-object-queryparams-querysettings-settings}

Sends `sqlQuery` as is. Additionally will send query parameters so the server can compile the SQL expression.

**Signatures**
```java
CompletableFuture query(String sqlQuery, Map queryParams, QuerySettings settings)
```

**Parameters**

`sqlQuery` - sql expression with placeholders `{}`.

`queryParams` - map of variables to complete the sql expression on server.

`settings` - request settings.

**Return value**

Future of `QueryResponse` type - a result dataset and additional information like server side metrics. The Response object should be closed after consuming the dataset.

**Examples**

```java showLineNumbers

// define parameters. They will be sent to the server along with the request.
Map queryParams = new HashMap<>();
queryParams.put("param1", 2);

try (QueryResponse response =
        client.query("SELECT * FROM " + table + " WHERE col1 >= {param1:UInt32}", queryParams, new QuerySettings()).get()) {

    // Create a reader to access the data in a convenient way
    ClickHouseBinaryFormatReader reader = client.newBinaryFormatReader(response);

    while (reader.hasNext()) {
        reader.next(); // Read the next record from stream and parse it

        // reading data
    }

} catch (Exception e) {
    log.error("Failed to read data", e);
}

```

### queryAll(String sqlQuery) {#queryallstring-sqlquery}

Queries a data in `RowBinaryWithNamesAndTypes` format. Returns the result as a collection. Read performance is the same as with the reader but more memory is required to hold the whole dataset.

**Signatures**
```java
List queryAll(String sqlQuery)
```

**Parameters**

`sqlQuery` - sql expression to query data from a server.

**Return value**

Complete dataset represented by a list of `GenericRecord` objects that provide access in row style for the result data.

**Examples**

```java showLineNumbers
try {
    log.info("Reading whole table and process record by record");
    final String sql = "select * from " + TABLE_NAME + " where title <> ''";

    // Read whole result set and process it record by record
    client.queryAll(sql).forEach(row -> {
        double id = row.getDouble("id");
        String title = row.getString("title");
        String url = row.getString("url");

        log.info("id: {}, title: {}, url: {}", id, title, url);
    });
} catch (Exception e) {
    log.error("Failed to read data", e);
}
```

### QuerySettings {#querysettings}

Configuration options for query operations.

**Configuration methods**

| Method                                       | Description                                                                                                                |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `setQueryId(String queryId)`                 | Sets query ID that will be assigned to the operation.                                                                      |
| `setFormat(ClickHouseFormat format)`         | Sets response format. See `RowBinaryWithNamesAndTypes` for the full list.                                                  |
| `setMaxExecutionTime(Integer maxExecutionTime)` | Sets operation execution time on server. Won't affect read timeout.                                                    |
| `waitEndOfQuery(Boolean waitEndOfQuery)`     | Requests the server to wait for the end of the query before sending a response.                                            |
| `setUseServerTimeZone(Boolean useServerTimeZone)` | Server timezone (see client config) will be used to parse date/time types in the result of an operation. Default `false`.  |
| `setUseTimeZone(String timeZone)`            | Requests server to use `timeZone` for time conversion. See [session_timezone](/reference/settings/session-settings/other#session_timezone). |
| `serverSetting(String name, String value)`   | Sets individual server settings for an operation.                                                                          |
| `serverSetting(String name, Collection values)` | Sets individual server settings with multiple values for an operation. Items of the collection should be `String` values.  |
| `setDBRoles(Collection dbRoles)`             | Sets DB roles to be set before executing an operation. Items of the collection should be `String` values.                  |
| `setOption(String option, Object value)`     | Sets a configuration option in raw format. This isn't a server setting.                                                  |

### QueryResponse {#queryresponse}

Response object that holds result of query execution. It is only available if the client got a response from a server.

| Method                              | Description                                                                                          |
|-------------------------------------|------------------------------------------------------------------------------------------------------|
| `ClickHouseFormat getFormat()`      | Returns a format in which data in the response is encoded.                                           |
| `InputStream getInputStream()`      | Returns uncompressed byte stream of data in the specified format.                                    |
| `OperationMetrics getMetrics()`     | Returns object with operation metrics.                                                              |
| `String getQueryId()`               | Returns query ID assigned for the operation by the application (through operation settings or by server). |
| `TimeZone getTimeZone()`            | Returns timezone that should be used for handling Date/DateTime types in the response.               |

### Examples {#examples}

- Example code is available in [repo](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/client-v2)
- Reference Spring Service [implementation](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/demo-service)

## Common API {#common-api}

### getTableSchema(String table) {#gettableschemastring-table}

Fetches table schema for the `table`.

**Signatures**

```java
TableSchema getTableSchema(String table)
TableSchema getTableSchema(String table, String database)
```

**Parameters**

`table` - table name for which schema data should be fetched.

`database` - database where the target table is defined.

**Return value**

Returns a `TableSchema` object with list of table columns.

### getTableSchemaFromQuery(String sql) {#gettableschemafromquerystring-sql}

Fetches schema from a SQL statement.

**Signatures**

```java
TableSchema getTableSchemaFromQuery(String sql)
```

**Parameters**

`sql` - "SELECT" SQL statement which schema should be returned.

**Return value**

Returns a `TableSchema` object with columns matching the `sql` expression.

### TableSchema {#tableschema}

### register(Class&lt;?> clazz, TableSchema schema) {#registerclasslt-clazz-tableschema-schema}

Compiles serialization and deserialization layer for the Java Class to use for writing/reading data with `schema`. The method will create a serializer and deserializer for the pair getter/setter and corresponding column.
Column match is found by extracting its name from a method name. For example, `getFirstName` will be for the column `first_name` or `firstname`.

**Signatures**

```java
void register(Class clazz, TableSchema schema)
```

**Parameters**

`clazz` - Class representing the POJO used to read/write data.

`schema` - Data schema to use for matching with POJO properties.

**Examples**

```java showLineNumbers
client.register(ArticleViewEvent.class, client.getTableSchema(TABLE_NAME));
```

## Usage Examples {#usage-examples}

Complete examples code is stored in the repo in a 'example` [folder](https://github.com/ClickHouse/clickhouse-java/tree/main/examples):

- [client-v2](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/client-v2) - main set of examples.
- [demo-service](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/demo-service) - example of how to use the client in a Spring Boot application.
- [demo-kotlin-service](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/demo-kotlin-service) - example of how to use the client in Ktor (Kotlin) application.

## Reading Data {#reading-data}

There are two common ways to read data:

- `query()` method that returns low-level `QueryResponse` object that contains `InputStream` with data. Usually combined with `ClickHouseBinaryFormatReader` for streaming reads but
can be used with any other custom reader implementation. `QueryResponse` also provides access to the result set metadata and metrics.
- `queryAll()` method and using `GenericRecord` for convenient row access. In this case the whole result set is loaded into memory.
- `queryRecords()` method that returns `com.clickhouse.client.api.query.Records` - an iterator for `GenericRecord` objects. This method uses streaming approach
(no data is loaded into memory) and utilises `GenericRecord` to access data.

**Note:** streaming approach requires fast read otherwise it may cause server write timeout because data is read directly from the network stream.

### Reading Arrays {#reading-arrays}

**`ClickHouseBinaryFormatReader` Methods**

- `getList(...)` - reads any `Array(...)` as `List`. Good default for flexible typed reads. Supports nested arrays.
- `getByteArray(...)`, `getShortArray(...)`, `getIntArray(...)`, `getLongArray(...)`, `getFloatArray(...)`, `getDoubleArray(...)`, `getBooleanArray(...)` - best for 1D arrays of primitive-compatible values.
- `getStringArray(...)` - for `Array(String)` (and enum values represented as names).
- `getObjectArray(...)` - generic option for any `Array(...)` element type, including nested arrays. Use to read arrays with nullable values and nested arrays.

Index-based and name-based overloads are available for all methods. Index is 1-based. Index-based do dirrect access to a column.
Name-based methods require index lookup each time.

```java
try (QueryResponse response = client.query("SELECT * FROM my_table").get()) {
    ClickHouseBinaryFormatReader reader = client.newBinaryFormatReader(response);
    while (reader.next() != null) {

        Object[] uint64 = reader.getObjectArray("uint64_arr"); // Array(UInt64) -> BigInteger[]
        Object[] arr2d = reader.getObjectArray("arr2d");       // Array(Array(Int64)) -> Object[]

        // nested arrays are returned as nested Object[]:
        Object[] firstInner = (Object[]) arr2d[0];
        Long firstValue = (Long) firstInner[0];
    }
}
```

**`GenericRecord` Methods**

- `getList(...)` - reads any `Array(...)` as `List`. Good default for flexible typed reads. Supports nested arrays.
- `getByteArray(...)`, `getShortArray(...)`, `getIntArray(...)`, `getLongArray(...)`, `getFloatArray(...)`, `getDoubleArray(...)`, `getBooleanArray(...)` - best for 1D arrays of primitive-compatible values.
- `getStringArray(...)` - for `Array(String)` (and enum values represented as names).
- `getObjectArray(...)` - generic option for any `Array(...)` element type, including nested arrays. Use to read arrays with nullable values and nested arrays.

Index-based and name-based overloads are available for all methods. Index is 1-based. Index-based do dirrect access to a column.
Name-based methods require index lookup each time.

```java
try (QueryResponse response = client.query("SELECT * FROM my_table").get()) {
    List rows = client.queryAll(
        "SELECT int_arr, arr2d_nullable FROM test_arrays ORDER BY id");

    for (GenericRecord row : rows) {
        Object[] intArr = row.getObjectArray("int_arr");                 // Array(Int32) -> Integer[]
        Object[] arr2d = row.getObjectArray("arr2d_nullable");           // Array(Array(Nullable(Int32)))

        Object[] inner = (Object[]) arr2d[0];
        Object maybeNull = inner[1]; // may be null
    }
}
```

## Migration Guide {#migration_guide}

Old client (V1) was using `com.clickhouse.client.ClickHouseClient#builder` as start point. The new client (V2) uses similar pattern with `com.clickhouse.client.api.Client.Builder`. Main differences are:
- no service loader is used to grab implementation. The `com.clickhouse.client.api.Client` is facade class for all kinds of implementation in the future.
- a fewer sources of configuration: one is provided to the builder and one is with operation settings (`QuerySettings`, `InsertSettings`). Previous version had configuration per node and was loading
env. variables in some cases.

### Configuration Parameters Match {#migration_from_v1_config}

There are 3 enum classes related to configuration in V1:
- `com.clickhouse.client.config.ClickHouseDefaults` - configuration parameters that supposed to be set in most use cases. Like `USER` and `PASSWORD`.
- `com.clickhouse.client.config.ClickHouseClientOption` - configuration parameters specific for the client. Like `HEALTH_CHECK_INTERVAL`.
- `com.clickhouse.client.http.config.ClickHouseHttpOption` - configuration parameters specific for HTTP interface. Like `RECEIVE_QUERY_PROGRESS`.

They were designed to group parameters and provide clear separation. However in some cases it lead to a confusion (is there a difference between `com.clickhouse.client.config.ClickHouseDefaults#ASYNC` and `com.clickhouse.client.config.ClickHouseClientOption#ASYNC`). The new V2 client uses `com.clickhouse.client.api.Client.Builder` as single dictionary of all possible client configuration options.There is `com.clickhouse.client.api.ClientConfigProperties` where all configuration parameter names are listed.

Table below shows what old options are supported in the new client and their new meaning.

**Legend:** ✔ = supported, ✗ = dropped

### General Differences

- Client V2 uses less proprietary classes to increase portability. For example, V2 works with any implementation of `java.io.InputStream` for
writing data to a server.
- Client V2 `async` settings is `off` by default. It means no extra threads and more application control over client. This setting should be `off` for majority of use cases. Enabling `async` will create a separate thread for a request. It only make sense when using application controlled
executor (see `com.clickhouse.client.api.Client.Builder#setSharedOperationExecutor`)

### Writing Data

- use any implementation of `java.io.InputStream`. V1 `com.clickhouse.data.ClickHouseInputStream` is supported but NOT recommended.
- once end of input stream is detected it handled accordingly. Previously output stream of a request should be closed.

__V1 Insert TSV formatted data.__
```java
InputStream inData = getInData();
ClickHouseRequest.Mutation request = client.read(server)
        .write()
        .table(tableName)
        .format(ClickHouseFormat.TSV);
ClickHouseConfig config = request.getConfig();
CompletableFuture future;
try (ClickHousePipedOutputStream requestBody = ClickHouseDataStreamFactory.getInstance()
        .createPipedOutputStream(config)) {
    // start the worker thread which transfer data from the input into ClickHouse
    future = request.data(requestBody.getInputStream()).execute();

    // Copy data from inData stream to requestBody stream

    // We need to close the stream before getting a response
    requestBody.close();

    try (ClickHouseResponse response = future.get()) {
        ClickHouseResponseSummary summary = response.getSummary();
        Assert.assertEquals(summary.getWrittenRows(), numRows, "Num of written rows");
    }
}

```

__V2 Insert TSV formatted data.__

```java
InputStream inData = getInData();
InsertSettings settings = new InsertSettings().setInputStreamCopyBufferSize(8198 * 2); // set copy buffer size
try (InsertResponse response = client.insert(tableName, inData, ClickHouseFormat.TSV, settings).get(30, TimeUnit.SECONDS)) {

  // Insert is complete at this point

} catch (Exception e) {
 // Handle exception
}
```
- there is a single method to call. No need to create an additional request object.
- request body stream is closed automatically when all data is copied.
- new low-level API is available `com.clickhouse.client.api.Client#insert(java.lang.String, java.util.List, com.clickhouse.client.api.DataStreamWriter, com.clickhouse.data.ClickHouseFormat, com.clickhouse.client.api.insert.InsertSettings)`. `com.clickhouse.client.api.DataStreamWriter` is designed to implement custom data writing logic. For instance, reading data from a
queue.

### Reading Data

- Data is read in `RowBinaryWithNamesAndTypes` format by default. Currently only this format is supported when data binding is required.
- Data can be read as a collection of records using `List com.clickhouse.client.api.Client#queryAll(java.lang.String)` method. It will read data to a memory and release connection. No need for extra handling. `GenericRecord` gives access to data, implements some conversions.

```java
Collection records = client.queryAll("SELECT * FROM table");
for (GenericRecord record : records) {
    int rowId = record.getInteger("rowID");
    String name = record.getString("name");
    LocalDateTime ts = record.getLocalDateTime("ts");
}

```

Java client library to communicate with a DB server through its protocols. Current implementation supports only [HTTP interface](/concepts/features/interfaces/http). The library provides own API to send requests to a server.

**Deprecation**

This library will be deprecated soon. Use the latest [Java Client](/integrations/language-clients/java/client) for new projects

## Setup {#v1-setup}

Since version `0.5.0`, the driver uses a new client http library that needs to be added as a dependency.

## Initialization {#v1-initialization}

Connection URL Format: `protocol://host[:port][/database][?param[=value][&param[=value]][#tag[,tag]]`, for example:

- `http://localhost:8443?ssl=true&sslmode=NONE`
- `https://(https://explorer@play.clickhouse.com:443`

Connect to a single node:

```java showLineNumbers
ClickHouseNode server = ClickHouseNode.of("http://localhost:8123/default?compress=0");
```
Connect to a cluster with multiple nodes:

```java showLineNumbers
ClickHouseNodes servers = ClickHouseNodes.of(
    "jdbc:ch:http://server1.domain,server2.domain,server3.domain/my_db"
    + "?load_balancing_policy=random&health_check_interval=5000&failover=2");
```

## Query API {#v1-query-api}

```java showLineNumbers
try (ClickHouseClient client = ClickHouseClient.newInstance(ClickHouseProtocol.HTTP);
     ClickHouseResponse response = client.read(servers)
        .format(ClickHouseFormat.RowBinaryWithNamesAndTypes)
        .query("select * from numbers limit :limit")
        .params(1000)
        .executeAndWait()) {
            ClickHouseResponseSummary summary = response.getSummary();
            long totalRows = summary.getTotalRowsToRead();
}
```

## Streaming Query API {#v1-streaming-query-api}

```java showLineNumbers
try (ClickHouseClient client = ClickHouseClient.newInstance(ClickHouseProtocol.HTTP);
     ClickHouseResponse response = client.read(servers)
        .format(ClickHouseFormat.RowBinaryWithNamesAndTypes)
        .query("select * from numbers limit :limit")
        .params(1000)
        .executeAndWait()) {
            for (ClickHouseRecord r : response.records()) {
            int num = r.getValue(0).asInteger();
            // type conversion
            String str = r.getValue(0).asString();
            LocalDate date = r.getValue(0).asDate();
        }
}
```

See [complete code example](https://github.com/ClickHouse/clickhouse-java/blob/main/examples/client/src/main/java/com/clickhouse/examples/jdbc/Main.java#L73) in the [repo](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/client).

## Insert API {#v1-insert-api}

```java showLineNumbers

try (ClickHouseClient client = ClickHouseClient.newInstance(ClickHouseProtocol.HTTP);
     ClickHouseResponse response = client.read(servers).write()
        .format(ClickHouseFormat.RowBinaryWithNamesAndTypes)
        .query("insert into my_table select c2, c3 from input('c1 UInt8, c2 String, c3 Int32')")
        .data(myInputStream) // `myInputStream` is source of data in RowBinary format
        .executeAndWait()) {
            ClickHouseResponseSummary summary = response.getSummary();
            summary.getWrittenRows();
}
```

See [complete code example](https://github.com/ClickHouse/clickhouse-java/blob/main/examples/client/src/main/java/com/clickhouse/examples/jdbc/Main.java#L39) in the [repo](https://github.com/ClickHouse/clickhouse-java/tree/main/examples/client).

**RowBinary Encoding**

RowBinary format is described on its [page](/reference/formats/RowBinary/RowBinaryWithNamesAndTypes).

There is an example of [code](https://github.com/ClickHouse/clickhouse-kafka-connect/blob/main/src/main/java/com/clickhouse/kafka/connect/sink/db/ClickHouseWriter.java#L622).

## Features {#v1-features}
### Compression {#v1-compression}

The client will by default use LZ4 compression, which requires this dependency:

You can choose to use gzip instead by setting `compress_algorithm=gzip` in the connection URL.

Alternatively, you can disable compression a few ways.

1. Disable by setting `compress=0` in the connection URL: `http://localhost:8123/default?compress=0`
2. Disable via the client configuration:

```java showLineNumbers
ClickHouseClient client = ClickHouseClient.builder()
   .config(new ClickHouseConfig(Map.of(ClickHouseClientOption.COMPRESS, false)))
   .nodeSelector(ClickHouseNodeSelector.of(ClickHouseProtocol.HTTP))
   .build();
```

See the [compression documentation](/guides/clickhouse/data-modelling/compression/compression-modes) to learn more about different compression options.

### Multiple queries {#v1-multiple-queries}

Execute multiple queries in a worker thread one after another within same session:

```java showLineNumbers
CompletableFuture> future = ClickHouseClient.send(servers.apply(servers.getNodeSelector()),
    "create database if not exists my_base",
    "use my_base",
    "create table if not exists test_table(s String) engine=Memory",
    "insert into test_table values('1')('2')('3')",
    "select * from test_table limit 1",
    "truncate table test_table",
    "drop table if exists test_table");
List results = future.get();
```

### Named Parameters {#v1-named-parameters}

You can pass parameters by name rather than relying solely on their position in the parameter list. This capability is available using `params` function.

```java showLineNumbers
try (ClickHouseClient client = ClickHouseClient.newInstance(ClickHouseProtocol.HTTP);
     ClickHouseResponse response = client.read(servers)
        .format(ClickHouseFormat.RowBinaryWithNamesAndTypes)
        .query("select * from my_table where name=:name limit :limit")
        .params("Ben", 1000)
        .executeAndWait()) {
            //...
        }
}
```

**Parameters**

All `params` signatures involving `String` type (`String`, `String[]`, `Map`) assume the keys being passed are valid ClickHouse SQL strings. For instance:

```java showLineNumbers
try (ClickHouseClient client = ClickHouseClient.newInstance(ClickHouseProtocol.HTTP);
     ClickHouseResponse response = client.read(servers)
        .format(ClickHouseFormat.RowBinaryWithNamesAndTypes)
        .query("select * from my_table where name=:name")
        .params(Map.of("name","'Ben'"))
        .executeAndWait()) {
            //...
        }
}
```

If you prefer not to parse String objects to ClickHouse SQL manually, you can use the helper function `ClickHouseValues.convertToSqlExpression` located at `com.clickhouse.data`:

```java showLineNumbers
try (ClickHouseClient client = ClickHouseClient.newInstance(ClickHouseProtocol.HTTP);
     ClickHouseResponse response = client.read(servers)
        .format(ClickHouseFormat.RowBinaryWithNamesAndTypes)
        .query("select * from my_table where name=:name")
        .params(Map.of("name", ClickHouseValues.convertToSqlExpression("Ben's")))
        .executeAndWait()) {
            //...
        }
}
```

In the example above, `ClickHouseValues.convertToSqlExpression` will escape the inner single quote, and surround the variable with a valid single quotes.

Other types, such as `Integer`, `UUID`, `Array` and `Enum` will be converted automatically inside `params`.

## Node Discovery {#v1-node-discovery}

Java client provides the ability to discover ClickHouse nodes automatically. Auto-discovery is disabled by default. To manually enable it, set `auto_discovery`  to `true`:

```java
properties.setProperty("auto_discovery", "true");
```

Or in the connection URL:

```plaintext
jdbc:ch://my-server/system?auto_discovery=true
```

If auto-discovery is enabled, there is no need to specify all ClickHouse nodes in the connection URL. Nodes specified in the URL will be treated as seeds, and the Java client will automatically discover more nodes from system tables and/or clickhouse-keeper or zookeeper.

The following options are responsible for auto-discovery configuration:

| Property                | Default | Description                                                                                           |
|-------------------------|---------|-------------------------------------------------------------------------------------------------------|
| auto_discovery          | `false` | Whether the client should discover more nodes from system tables and/or clickhouse-keeper/zookeeper.  |
| node_discovery_interval | `0`     | Node discovery interval in milliseconds, zero or negative value means one-time discovery.             |
| node_discovery_limit    | `100`   | Maximum number of nodes that can be discovered at a time; zero or negative value means no limit.           |

### Load Balancing {#v1-load-balancing}

The Java client chooses a ClickHouse node to send requests to, according to the load-balancing policy. In general, the load-balancing policy is responsible for the following things:

1. Get a node from a managed node list.
2. Managing node's status.
3. Optionally schedule a background process for node discovery (if auto-discovery is enabled) and run a health check.

Here is a list of options to configure load balancing:

| Property              | Default                                   | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|-----------------------|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| load_balancing_policy | `""`                                      | The load-balancing policy can be one of: `firstAlive` - request is sent to the first healthy node from the managed node list`random` - request is sent to a random node from the managed node list `roundRobin` - request is sent to each node from the managed node list, in turn.full qualified class name implementing `ClickHouseLoadBalancingPolicy` - custom load balancing policyIf it isn't specified the request is sent to the first node from the managed node list |
| load_balancing_tags   | `""`                                      | Load balancing tags for filtering out nodes. Requests are sent only to nodes that have the specified tags                                                                                                                                                                                                                                                                                                                                                                                                      |
| health_check_interval | `0`                                       | Health check interval in milliseconds, zero or negative value means one-time.                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| health_check_method   | `ClickHouseHealthCheckMethod.SELECT_ONE`  | Health check method. Can be one of: `ClickHouseHealthCheckMethod.SELECT_ONE` - check with `select 1` query `ClickHouseHealthCheckMethod.PING` - protocol-specific check, which is generally faster                                                                                                                                                                                                                                                                                          |
| node_check_interval   | `0`                                       | Node check interval in milliseconds, negative number is treated as zero. The node status is checked if the specified amount of time has passed since the last check.
The difference between `health_check_interval` and `node_check_interval` is that the `health_check_interval` option schedules the background job, which checks the status for the list of nodes (all or faulty), but `node_check_interval` specifies the amount of time has passed since the last check for the particular node                |
| check_all_nodes       | `false`                                   | Whether to perform a health check against all nodes or just faulty ones.                                                                                                                                                                                                                                                                                                                                                                                                                                         |

### Failover and retry {#v1-failover-and-retry}

Java client provides configuration options to set up failover and retry behavior for failed queries:

| Property                | Default | Description                                                                                                                                                                                                                        |
|-------------------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| failover                | `0`     | Maximum number of times a failover can happen for a request. Zero or a negative value means no failover. Failover sends the failed request to a different node (according to the load-balancing policy) in order to recover from failover. |
| retry                   | `0`     | Maximum number of times retry can happen for a request. Zero or a negative value means no retry. Retry sends a request to the same node and only if the ClickHouse server returns the `NETWORK_ERROR` error code                               |
| repeat_on_session_lock  | `true`  | Whether to repeat execution when the session is locked until timed out(according to `session_timeout` or `connect_timeout`). The failed request is repeated if the ClickHouse server returns the `SESSION_IS_LOCKED` error code               |

### Adding custom http headers {#v1-adding-custom-http-headers}

Java client support HTTP/S transport layer in case we want to add custom HTTP headers to the request.
We should use the custom_http_headers property, and the headers need to be `,` separated. The header key/value should be divided using `=`

## Java Client support {#v1-java-client-support}

```java
options.put("custom_http_headers", "X-ClickHouse-Quota=test, X-ClickHouse-Test=test");
```

## JDBC Driver {#v1-jdbc-driver}

```java
properties.setProperty("custom_http_headers", "X-ClickHouse-Quota=test, X-ClickHouse-Test=test");
```
