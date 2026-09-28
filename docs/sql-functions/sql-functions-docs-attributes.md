---
description: 'Dictionary key and attribute configuration'
sidebarTitle: 'Attributes'
slug: /sql-reference/statements/create/dictionary/attributes
title: 'Dictionary attributes'
doc_type: 'reference'
---

import CloudDetails from '/snippets/_snippet_dictionary_in_cloud.mdx';

The `structure` clause describes the dictionary key and fields available for queries.

XML description:

```xml

        ...

```

Attributes are described in the elements:

- `` — Key column
- `` — Data column: there can be a multiple number of attributes.

DDL query:

```sql
CREATE DICTIONARY dict_name (
    Id UInt64,
    -- attributes
)
PRIMARY KEY Id
...
```

Attributes are described in the query body:

- `PRIMARY KEY` — Key column
- `AttrName AttrType` — Data column. There can be a multiple number of attributes.

## Key {#key}

ClickHouse supports the following types of keys:

- Numeric key. `UInt64`. Defined in the `` tag or using `PRIMARY KEY` keyword.
- Composite key. Set of values of different types. Defined in the tag `` or `PRIMARY KEY` keyword.

An xml structure can contain either `` or ``. DDL-query must contain single `PRIMARY KEY`.

### Numeric Key {#numeric-key}

Type: `UInt64`.

Configuration example:

```xml
```

Configuration fields:

- `name` – The name of the column with keys.

For DDL-query:

```sql
CREATE DICTIONARY (
    Id UInt64,
    ...
)
PRIMARY KEY Id
...
```

- `PRIMARY KEY` – The name of the column with keys.

### Composite Key {#composite-key}

The key can be a `tuple` from any types of fields. The [layout](/reference/statements/create/dictionary/layouts/overview) in this case must be `complex_key_hashed` or `complex_key_cache`.

A composite key can consist of a single element. This makes it possible to use a string as the key, for instance.

The key structure is set in the element ``. Key fields are specified in the same format as the dictionary [attributes](#attributes). Example:

```xml
field1
String
field2
UInt32
        ...
...
```

or

```sql
CREATE DICTIONARY (
    field1 String,
    field2 UInt32
    ...
)
PRIMARY KEY field1, field2
...
```

For a query to the `dictGet*` function, a tuple is passed as the key. Example: `dictGetString('dict_name', 'attr_name', tuple('string for field1', num_for_field2))`.

When the composite key consists of a single attribute, the key value can be passed directly, without wrapping it in `tuple`. For example, both `dictGetString('dict_name', 'attr_name', 'key')` and `dictGetString('dict_name', 'attr_name', tuple('key'))` are valid.

## Attributes {#attributes}

Configuration example:

```xml
    ...
Name
ClickHouseDataType
rand64()
true
true
true
```

or

```sql
CREATE DICTIONARY somename (
    Name ClickHouseDataType DEFAULT '' EXPRESSION rand64() HIERARCHICAL INJECTIVE IS_OBJECT_ID
)
```

Configuration fields:

| Tag                                                  | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Required |
|------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `name`                                               | Column name.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Yes      |
| `type`                                               | ClickHouse data type: [UInt8](/reference/data-types/int-uint), [UInt16](/reference/data-types/int-uint), [UInt32](/reference/data-types/int-uint), [UInt64](/reference/data-types/int-uint), [Int8](/reference/data-types/int-uint), [Int16](/reference/data-types/int-uint), [Int32](/reference/data-types/int-uint), [Int64](/reference/data-types/int-uint), [Float32](/reference/data-types/float), [Float64](/reference/data-types/float), [UUID](/reference/data-types/uuid), [Decimal32](/reference/data-types/decimal), [Decimal64](/reference/data-types/decimal), [Decimal128](/reference/data-types/decimal), [Decimal256](/reference/data-types/decimal),[Date](/reference/data-types/date), [Date32](/reference/data-types/date32), [DateTime](/reference/data-types/datetime), [DateTime64](/reference/data-types/datetime64), [String](/reference/data-types/string), [Array](/reference/data-types/array).
ClickHouse tries to cast value from dictionary to the specified data type. For example, for MySQL, the field might be `TEXT`, `VARCHAR`, or `BLOB` in the MySQL source table, but it can be uploaded as `String` in ClickHouse.
[Nullable](/reference/data-types/nullable) is currently supported for [Flat](/reference/statements/create/dictionary/layouts/flat), [Hashed](/reference/statements/create/dictionary/layouts/hashed), [ComplexKeyHashed](/reference/statements/create/dictionary/layouts/hashed#complex_key_hashed), [Direct](/reference/statements/create/dictionary/layouts/direct), [ComplexKeyDirect](/reference/statements/create/dictionary/layouts/direct#complex_key_direct), [RangeHashed](/reference/statements/create/dictionary/layouts/range-hashed), Polygon, [Cache](/reference/statements/create/dictionary/layouts/cache), [ComplexKeyCache](/reference/statements/create/dictionary/layouts/cache), [SSDCache](/reference/statements/create/dictionary/layouts/ssd-cache), [SSDComplexKeyCache](/reference/statements/create/dictionary/layouts/ssd-cache#complex_key_ssd_cache) dictionaries. In [IPTrie](/reference/statements/create/dictionary/layouts/ip-trie) dictionaries `Nullable` types are not supported. | Yes      |
| `null_value`                                         | Default value for a non-existing element.
In the example, it is an empty string. [NULL](/reference/syntax#null) value can be used only for the `Nullable` types (see the previous line with types description).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Yes      |
| `expression`                                         | [Expression](/reference/syntax#expressions) that ClickHouse executes on the value.
The expression can be a column name in the remote SQL database. Thus, you can use it to create an alias for the remote column.

Default value: no expression.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | No       |
|  `hierarchical` | If `true`, the attribute contains the value of a parent key for the current key. See [Hierarchical Dictionaries](/reference/statements/create/dictionary/layouts/hierarchical).

Default value: `false`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | No       |
| `injective`                                          | Flag that shows whether the `id -> attribute` image is [injective](https://en.wikipedia.org/wiki/Injective_function).
If `true`, ClickHouse can automatically place after the `GROUP BY` clause the requests to dictionaries with injection. Usually it significantly reduces the amount of such requests.

Default value: `false`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | No       |
| `is_object_id`                                       | Flag that shows whether the query is executed for a MongoDB document by `ObjectID`.

Default value: `false`.
