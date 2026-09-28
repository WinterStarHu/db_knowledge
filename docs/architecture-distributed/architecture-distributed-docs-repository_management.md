# 知识库管理

GaussMaster提供了上传文档构建自定义知识库的功能，通过知识库与数据源两层结构，实现文档级别的知识管理，使得用户可以方便快捷的定制化知识库范围，进行问答。其中，构建知识库的功能包括知识库的管理，以及文档的加载与切分等。

>[!NOTE]说明
>
>1. 当前版本仅支持上传markdown、docx格式文件，不支持其他格式，支持文档格式的范围为：\["md", "markdown", "docx"\]；
>2. 当前版本自定义知识库不支持使用版本信息进行过滤；
>3. 用户自定义文档未经过质量评估与模型训练，对比openGauss默认知识库问答效果会变差，针对于答案存在于上传文档中的情况，简单问题回答成功率 60% 以上。

## 知识库管理约束

1. GaussMaster依赖向量化功能，且仅支持单机版，需要提供模型服务（包括向量模型、重排序模型与大模型）来支持向量功能；
2. openGauss默认知识库会构建索引，用户构建的自定义知识库默认仅构建文本索引，如果用户需要构建向量索引，可在数据库后台自动构建，创建方法见主成功场景；
3. openGauss默认知识库无法进行增删改查；
4. GaussMaster当前版本单次上传文档个数限制为10个，所有文档的大小限制为128M。

## API接口说明

本节将介绍知识库管理模块提供的RESTful API接口。

### API: /v1/api/serve/knowledge\_base/add

功能描述：上传文档构建自定义知识库，用于对应文档的智能问答。

请求方式：POST

参数及其解释：如下表所示：

**表 1**  接口参数说明

参数名 是否必填 name str 知识库名称。
user_id str 知识库用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。
file List[UploadFile] 上传的数据源列表。
kb_type str 否，默认为QA，支持范围[QA, OM] 知识库类型。
description
str 否，默认为"" 知识库描述。
context str 否，默认为"" 知识库参数上下文。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/serve/knowledge_base/add?name=kb1&user_id=test&kb_type=QA&description=kbfile&context=123'  -H 'accept: application/json' -H "Content-Type: multipart/form-data" -F "file=@tmp.md" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"add knowledge success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/knowledge\_base/update

功能描述：更新知识库的名称、描述与参数信息。

请求方式：PUT

参数及其解释：如下表所示：

**表 2**  接口参数说明

参数名 是否必填 kb_id int 知识库ID。
user_id str 知识库用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。
name str 更新后知识库名称。
description
str 否，默认为"" 更新后知识库描述。
context str 否，默认为"" 更新后知识库参数上下文。

接口示例：

```
curl -X 'PUT' 'https://host:port/v1/api/serve/knowledge_base/update'  -H 'accept: application/json' -H "Content-Type: application/json" -d '{"kb_id": 2, "user_id": "test", "name": "kb2", "description": "kb2file", "context": "1234"}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"update knowledge success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/server/knowledge\_base/delete

功能描述：删除指定知识库。

请求方式：DELETE

参数及其解释：如下表所示：

**表 3**  接口参数说明

参数名 是否必填 kb_id int 知识库ID。
user_id str 知识库用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。

接口示例：

```
curl -X 'DELETE' 'https://host:port/v1/api/serve/knowledge_base/delete?kb_id=2&user_id=test'  -H 'accept: application/json' -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"delete knowledge success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/knowledge\_base/get

功能描述：查询指定知识库。

请求方式：GET

参数及其解释：如下表所示：

**表 4**  接口参数说明

参数名 是否必填 kb_id int 知识库ID。
user_id str 知识库用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。

接口示例：

```
curl -X 'GET' 'https://host:port/v1/api/serve/knowledge_base/get?kb_id=2&user_id=test'  -H 'accept: application/json' -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":[{"context":"123","create_time":"2024-09-11 17:09:55.266541","description":"kbfile","kb_id":1,"kb_type":"QA","name":"kb1","update_time":"2024-09-11 17:09:55.266541","user_id":"test"}],"success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/knowledge\_base/list

功能描述：展示用户下所有知识库。

请求方式：GET

参数及其解释：如下表所示：

**表 5**  接口参数说明

参数名 是否必填 user_id: str str 知识库用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。

接口示例：

```
curl -X 'GET' 'https://host:port/v1/api/serve/knowledge_base/list?user_id=test'  -H 'accept: application/json' -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":[{"context":"123","create_time":"2024-09-11 17:09:55.266541","description":"kbfile","kb_id":1,"kb_type":"QA","name":"kb1","update_time":"2024-09-11 17:09:55.266541","user_id":"test"}],"success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/datasource/add

功能描述：上传文档，增加新数据源到自定义知识库，扩充智能问答检索空间。

请求方式：POST

参数及其解释：如下表所示：

**表 6**  接口参数说明

参数名 是否必填 related_kb_id int 数据源对应知识库ID。
file List[UploadFile] 上传的数据源列表。
name str 否，默认为文件名（无后缀） 数据源名称。
description
str 否，默认为"" 数据源描述。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/serve/datasource/add?related_kb_id=2&name=ds_test&description=kbfile' -H 'accept: application/json' -H "Content-Type: multipart/form-data" -F "file=@tmp.md" -F "file=@tmp2.md" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"add datasource success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/datasource/update

功能描述：更新数据源的名称与描述。

请求方式：PUT

参数及其解释：如下表所示：

**表 7**  接口参数说明

参数名 是否必填 ds_id int 数据源ID。
related_kb_id int 数据源对应知识库ID。
name str 更新后数据源名称。
description
str 否，默认为"" 更新后数据源描述。

接口示例：

```
curl -X 'PUT' 'https://host:port/v1/api/serve/datasource/update' -H 'accept: application/json' -H "Content-Type: application/json" -d '{"ds_id": 3, "name": "ds3", "related_kb_id": 2, "description": "ds3file"}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"update datasource success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/datasource/delete

功能描述：删除指定数据源。

请求方式：DELETE

参数及其解释：如下表所示：

**表 8**  接口参数说明

参数名 是否必填 ds_id int 数据源ID。
related_kb_id int 数据源对应知识库ID。

接口示例：

```
curl -X 'DELETE' 'https://host:port/v1/api/serve/datasource/delete?ds_id=3&related_kb_id=2'  -H 'accept: application/json' -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"delete datasource success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/datasource/get

功能描述：查询指定数据源。

请求方式：GET

参数及其解释：如下表所示：

**表 9**  接口参数说明

参数名 是否必填 ds_id int 数据源ID。
related_kb_id int 数据源对应知识库ID。

接口示例：

```
curl -X 'GET' 'https://host:port/v1/api/serve/datasource/get?ds_id=3&related_kb_id=2' -H 'accept: application/json' -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":[{"create_time":"2024-09-12 16:34:58.054142","description":"ds3file","ds_id":3,"file_name":"xxx.md","name":"ds3","related_kb_id":2,"update_time":"2024-09-12 16:34:58.054142"}],"success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/datasource/list

功能描述：展示知识库下的所有数据源。

请求方式：GET

参数及其解释：如下表所示：

**表 10**  接口参数说明

参数名 是否必填 related_kb_id int 数据源对应知识库ID。

接口示例：

```
curl -X 'GET' 'https://host:port/v1/api/serve/datasource/list?related_kb_id=2'  -H 'accept: application/json' -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":[{"create_time":"2024-09-12 16:34:58.054142","description":"ds3file","ds_id":3,"file_name":"xxx.md","name":"ds3","related_kb_id":2,"update_time":"2024-09-12 16:34:58.054142"}],"success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/knowledge\_base/batch\_delete

功能描述：批量删除指定知识库。

请求方式：POST

参数及其解释：如下表所示：

**表 11**  接口参数说明

参数名 是否必填 kb_id_list List[int] 知识库ID列表。
user_id str 知识库用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/serve/knowledge_base/batch_delete?user_id=test'  -H 'accept: application/json' -H "Content-Type: application/json" -d '[3, 4]' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"batch delete knowledge success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/serve/datasource/batch\_delete

功能描述：批量删除指定数据源。

请求方式：POST

参数及其解释：如下表所示：

**表 12**  接口参数说明

参数名 是否必填 ds_id_list List[int] 数据源ID列表。
related_kb_id: int int 数据源对应知识库ID。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/serve/datasource/batch_delete?related_kb_id=2' -H 'accept: application/json' -H "Content-Type: application/json" -d '[4, 5]' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"batch delete datasource success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```
