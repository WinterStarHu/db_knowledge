# 智能问答

GaussMaster依据用户查询，使用检索模块从知识库中召回相关上下文，随后拼接prompt传递给大模型，由大模型判断是否存在风险信息并选择是否回答。当原始查询无法召回相关上下文时，可进行查询优化，识别用户真实意图，再进行检索与生成，给出解答；如果仍没有相关内容，则进行拒答，提示用户重新输入查询。当GaussMaster智能问答给出回答后，用户可根据回答内容与上下文判断回答效果，当回答正确无误时，可进行点赞操作；当回答错误时，可进行点踩操作；当回答不友好时，可进行举报操作等。此类信息会记录下来帮助后续GaussMaster智能问答进行改进与优化。

>[!NOTE]说明
>
>1. GaussMaster仅提供智能问答（检索+推理/端到端问答）接口，不提供模型服务，不提供前端页面；
>2. GaussMaster依赖openGauss提供向量检索功能，且仅支持单机版，需要提供模型服务（包括向量模型、重排序模型与大模型）来支持向量化与答案生成功能；
>3. GaussMaster仅支持 openGauss 相关问题解答，当前版本支持基础问题、功能介绍、使用方法、特性支持、参数配置、告警解决六类问题的解答，不支持多跳问题（需要串联多个信息片段来组成答案，如openGauss 最新版本新增哪些特性）、比较问题（如openGauss中不同版本中索引推荐的差异）、涉及多个章节总结归纳答案的单点问题等复杂问题，待后续版本进行迭代解决；针对答案存在于openGauss 文档中的情况，简单问题（如shared\_buffer参数应该如何设置？）回答成功率 80% 以上。

## 智能问答约束

1. GaussMaster对于涉政涉恐问题拒答依赖于大模型本身能力。基于pangu-38b模型，初步评估拒答准确率在70%以上，最终生成的结果由下游云侧进行敏感信息过滤后返回给用户；
2. GaussMaster内部测试条件：大模型服务可通过远程接口调用公司盘古API，或在昇腾NPU服务器上部署大模型服务；向量模型与重排序模型服务可通过远程接口调用openGauss提供的API，或在昇腾NPU服务器上部署向量与重排序模型服务；需在配置文件中添加对应API保证服务正常运行；
3. 性能规格约束：以大模型服务为例，不考虑网络时延与并发情况，在8卡910B单并发条件下，pangu-38b推理性能为首字 1s，增量每字100ms。实际使用中推理速度受网络时延与多并发阻塞影响；
4. 问答功能只支持中文和英文，本版本以中文为主，服务农行客户，模型微调也仅支持中文；对于默认知识库，中文/英文会检索不同的知识库。对于自定义知识库，则不进行区分，直接进行检索；英文问答准确率不保证达到 80%；
5. 问答接口中历史对话记录默认长度为1，表示会提取上一次对话内容；当历史对话的语言参数与本次对话语言参数不同时（如上一次为中文对话，此次为英文对话），会丢弃对应历史对话信息；
6. 由于大模型存在输入输出长度限制，因此当查询过长/检索到对应的上下文过长时，无法生成回答。以盘古大模型为例，输入输出的长度限制为4096。

## API接口说明

本节将介绍智能问答模块提供的RESTful API接口。

### API: /v1/api/search

功能描述：提供检索功能，包括向量检索+文本检索+重排序。

请求方式：POST

参数及其解释：如下表所示：

**表 1**  接口参数说明

参数名 是否必填 question str 需要检索的查询。
user_id str 唯一标识的用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。
session_id str 唯一标识的会话ID，要求长度大于等于2，只能由字符、数字和下划线组成。
vector_topk int 否，默认为6，支持范围[1-10] 向量检索返回的结果数。
text_topk int 否，默认为6，支持范围[1-10] 文本检索返回的结果数。
rerank_topk int 否，默认为3，支持范围[1-10] 重排序后返回的结果数。
kb_id int 否，默认为0， 表示gauss基础知识库 知识库，查询的搜索空间。
version str 否，默认为None（空），表示查询所有版本，当前版本支持的版本列表为：[24.7.30.10] 版本，进行知识库文档的版本过滤。
lang str 否，默认为zh，表示中文，当前支持zh与en 当前支持的语言。
history_len int 否，默认为1，表示历史信息长度，支持范围[0, 3] 历史信息长度，表示支持一轮对话，若历史信息过长，会进行截取，保证满足模型输入长度限制。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/search'  -H 'accept: application/json'  -H "Content-Type: application/json" -d '{"question": "介绍一下DBMind", "user_id": "123", "session_id": "123"}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{
    "data":
        {
            "question_id": "98b21d51-9565-4dd4-9b0a-2854260de9cb",
            "rerank_search_time": 0.561,
            "search_res": [
                {
                    "Top No.": "xxx",
                    "confidence": "xxx",
                    "content": "xxx",
                    "context": "xxx",
                    "doc_location": "xxx",
                    "field": "xxx",
                    "keyword": "xxx",
                    "knowledge_id": "xxx",
                    "link": "xxx",
                    "media": "xxx",
                    "product_format": "xxx",
                    "score": 1.1,
                    "source": "xxx",
                    "sub_field": "xxx",
                    "title": "xxx",
                    "version": "xxx",
                    "visualize": "xxx"
               }
            ],
            "text_search_time": 0.006,
            "total_time": 1.1461763381958008,
            "vector_search_time": 0.015
        },
    "success":true
}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
{"detail":[{"loc":["body","session_id"],"msg":"field required","type":"value_error.missing"}]}
```

### API: /v1/api/infer

功能描述：提供答案生成功能，结合查询与上下文生成答案。

请求方式：POST

参数及其解释：如下表所示：

**表 2**  接口参数说明

参数名 是否必填 question str 需要回答的查询。
question_id str 是，可通过search接口获得 查询ID。
user_id str 唯一标识的用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。
session_id str 唯一标识的会话ID，要求长度大于等于2，只能由字符、数字和下划线组成。
switch bool 否，默认为True 是否开启检索，预留。
search_res list 否，默认为[]，表示无检索结果 检索接口返回的相关上下文结果。
model_name str 否，默认为盘古智子模型 用于生成结果的大模型名称。
model_config dict 否，默认为{} 大模型超参。
lang str 否，默认为zh，表示中文，当前支持zh与en 当前支持的语言。
history_len int 否，默认为1，表示历史信息长度，支持范围[0, 3] 历史信息长度，表示支持一轮对话，若历史信息过长，会进行截取，保证满足模型输入长度限制。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/infer'  -H 'accept: text/event-stream'  -H "Content-Type: application/json" -d '{"question": "介绍一下DBMind", "question_id": "1555fc9d-d098-4191-9875-9ae45df08e22", "user_id": "123", "session_id": "123", "search_res": [{"Top No.":0,"confidence":"unknown","content":"xxx","context":"{\"\",\"8eddee07-72fc-4564-a36e-78ee52eb4ec9\",\"d33fc937-76f1-4c39-a445-1bf551f64e5d\"}","doc_location":"xxx.md","field":"openGauss","keyword":"{\"\"}","knowledge_id":"8eddee07-72fc-4564-a36e-78ee52eb4ec9","link":null,"media":"","product_format":"unknown","score":17.537734985351562,"source":"unknown","sub_field":"kernel","title":"xxx.md","version":"unknown","visualize":null},{"Top No.":1,"confidence":"unknown","content":"xxx","context":"{\"d740dd69-b662-45a3-ad65-253906c84246\",\"a12e517e-fa66-411f-8045-04960d8623ee\",\"\"}","doc_location":"xxx.md","field":"openGauss","keyword":"{\"\"}","knowledge_id":"a12e517e-fa66-411f-8045-04960d8623ee","link":null,"media":"","product_format":"unknown","score":14.618561744689941,"source":"unknown","sub_field":"kernel","title":"xxx.md","version":"unknown","visualize":null},{"Top No.":2,"confidence":"1","content":"xxx","context":"{\"228fc140-9fc9-49ed-bd21-100d7dbbd625\",\"b98d692c-bf4b-434c-86a1-0593aa6f204a\",\"9e9314f9-a047-4168-8149-8e1fd7447398\"}","doc_location":"xxx.md","field":"openGauss","keyword":"{\"\"}","knowledge_id":"b98d692c-bf4b-434c-86a1-0593aa6f204a","link":null,"media":"","product_format":"centralized","score":13.396706581115723,"source":"idp","sub_field":"kernel","title":"xxx.md","version":"24.7.30.10","visualize":null}]}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
data:{"data":{"data":"D","type":"answer"},"success":true}\n\n
data:{"data":{"data":"DB","type":"answer"},"success":true}\n\n
...
data:{"data":{"data":{"answer_id":xxx,"time": 0.15}, "type":"complete",},"success":true}\n\n
```

错误示例：

```
data:{"msg":"Internal server error.","success":false}\n\n
```

### API: /v1/api/ask\_gauss

功能描述：进行流程编排，结合查询优化、融合检索等技术，提供端到端的问答功能。

请求方式：POST

参数及其解释：如下表所示：

**表 3**  接口参数说明

参数名 是否必填 question str 需要检索的查询。
user_id str 唯一标识的用户ID，要求长度大于等于2，只能由字符、数字和下划线组成。
session_id str 唯一标识的会话ID，要求长度大于等于2，只能由字符、数字和下划线组成。
switch bool 否，默认为True 是否开启检索，预留，当前仅支持True。
vector_topk int 否，默认为6，支持范围[1-10] 向量检索返回的结果数。
text_topk int 否，默认为6，支持范围[1-10] 文本检索返回的结果数。
rerank_topk int 否，默认为3，支持范围[1-10] 重排序后返回的结果数。
kb_id int 否，默认为0， 表示gauss基础知识库 知识库，查询的搜索空间。
version str 否，默认为None（空），表示查询所有版本，当前版本支持的版本列表为：[24.7.30.10] 版本，进行知识库文档的版本过滤。
model_name str 否，默认为盘古智子模型 用于生成结果的大模型名称。
model_config dict 否，默认为{} 大模型超参。
lang str 否，默认为zh，表示中文，当前支持zh与en 当前支持的语言。
history_len int 否，默认为1，表示历史信息长度，支持范围[0, 3] 历史信息长度，表示支持一轮对话，若历史信息过长，会进行截取，保证满足模型输入长度限制。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/ask_gauss'  -H 'accept: text/event-stream'  -H "Content-Type: application/json" -d '{"question": "介绍一下DBMind", "user_id": "123", "session_id": "123"}' --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
data:{"data":{"data":"检索中...","type":"progress"},"success":true}\n\n
data:{"data":{"data":"检索完成","type":"progress"},"success":true}\n\n
data:{"data":{"data":"答案生成中...',"type":"progress"},"success":true}\n\n
data:{"data":{"data":"h","type":"answer"},"success":true}\n\n
data:{"data":{"data":"he","type":"answer"},"success":true}\n\n
...
data:{"data":{"data":"答案生成完成", "type": "progress"},"success":true}\n\n
data:{"data":{"data":{"answer_id":xxx,"question_id":xxx,"time":0.15 },"type":"complete"},"success":true}\n\n
```

错误示例：

```
data:{"msg":"Internal server error.","success":false}\n\n
```

### API: /v1/api/feedback/like

功能描述：答案正确时，反馈对答案的认可。

请求方式：POST

参数及其解释：如下表所示：

**表 4**  接口参数说明

参数名 是否必填 answer_id str 答案对应的ID。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/feedback/like?answer_id=e1a19c1e-8c3f-49ae-b476-8a21434e5f9e'  -H 'accept: text/event-stream'  -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"feedback like success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/feedback/hate

功能描述：答案错误时，反馈对错误的标注。

请求方式：POST

参数及其解释：如下表所示：

**表 5**  接口参数说明

参数名 是否必填 answer_id str 答案对应的ID。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/feedback/hate?answer_id=e1a19c1e-8c3f-49ae-b476-8a21434e5f9e'  -H 'accept: text/event-stream'  -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"feedback hate success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/feedback

功能描述：针对答案，给出用户反馈的建议等。

请求方式：POST

参数及其解释：如下表所示：

**表 6**  接口参数说明

参数名 是否必填 answer_id str 答案对应的ID。
feedback_info str 反馈的信息。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/feedback?answer_id=e1a19c1e-8c3f-49ae-b476-8a21434e5f9e&feedback_info=notuseful'  -H 'accept: text/event-stream'  -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"feedback info success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```

### API: /v1/api/feedback/report

功能描述：答案不友好时，可进行举报反馈。

请求方式：POST

参数及其解释：如下表所示：

**表 7**  接口参数说明

参数名 是否必填 answer_id str 答案对应的ID。
report_type str 举报类型，取值范围为：["低俗色情", "账号违规", "敏感信息", "暴力恐怖", "造谣诽谤", "侮辱英烈", "谩骂攻击", "民族宗教", "赌博诈骗", "危害未成年", "违法违禁品", "其他"]。
report_info str 举报的信息。

接口示例：

```
curl -X 'POST' 'https://host:port/v1/api/feedback/report?answer_id=e1a19c1e-8c3f-49ae-b476-8a21434e5f9e&report_type=%E4%BD%8E%E4%BF%97%E8%89%B2%E6%83%85&report_info=notfriendly'  -H 'accept: text/event-stream'  -H "Content-Type: application/json" --cacert /path/xxx.crt --key /path/xxx.key --cert /path/xxx.crt --pass "***"
```

参考返回结果：

```
{"data":"feedback report success.","success":true}
```

错误示例：

```
{"msg":"Internal server error.","success":false}
```
