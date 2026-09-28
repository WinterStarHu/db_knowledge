# 解析器

文本搜索解析器负责将原文档文本分解为多个token，并标识每个token的类型。这里的类型集由解析器本身定义。注意，解析器并不修改文本，它只是确定合理的单词边界。由于这一限制，人们更需要定制词典，而不是为每个应用程序定制解析器。

目前openGauss提供了三个内置的解析器，分别为pg\_catalog.default/pg\_catalog.ngram/pg\_catalog.pound，其中pg\_catalog.default适用于英文分词场景，pg\_catalog.ngram/pg\_catalog.pound是为了支持中文全文检索功能新增的两种解析器，适用于中文及中英混合分词场景。

内置解析器pg\_catalog.default，它能识别23种token类型，显示在[表1](#zh-cn_topic_0283137134_zh-cn_topic_0237122032_zh-cn_topic_0059778480_t0a8cd80932c5462fbea1e45540d72aea)中。

**表 1**  默认解析器类型

asciiword Word, all ASCII letters elephant word Word, all letters ma&ntilde;ana numword Word, letters and digits beta1 asciihword Hyphenated word, all ASCII up-to-date hword Hyphenated word, all letters l&oacute;gico-matem&aacute;tica numhword Hyphenated word, letters and digits openGauss-beta1 hword_asciipart Hyphenated word part, all ASCII openGauss in the context openGauss-beta1 hword_part Hyphenated word part, all letters l&oacute;gico or matem&aacute;tica in the context l&oacute;gico-matem&aacute;tica hword_numpart Hyphenated word part, letters and digits beta1 in the context openGauss-beta1 email Email address foo@example.com protocol Protocol head http:// url URL example.com/stuff/index.html host Host example.com url_path URL path /stuff/index.html, in the context of a URL file File or path name /usr/local/foo.txt, if not within a URL sfloat Scientific notation -1.23E+56 float Decimal notation -1.234 int Signed integer -1234 uint Unsigned integer 1234 version Version number
8.3.0
tag XML tag &lt;a href="dictionaries.html"&gt;
entity XML entity &amp;amp;
blank Space symbols (any whitespace or punctuation not otherwise recognized)

注意：对于解析器来说，一个“字母”的概念是由数据库的语言区域设置，即lc\_ctype设置决定的。只包含基本ASCII字母的词被报告为一个单独的token类型，因为这类词有时需要被区分出来。大多数欧洲语言中，对token类型word和asciiword的处理方法是类似的。

email不支持某些由RFC 5322定义的有效电子邮件字符。具体来说，可用于email用户名的非字母数字字符仅包含句号、破折号和下划线。

解析器可能对同一内容进行重叠token。例如，包含连字符的单词将作为一个整体进行报告，其组件也会分别被报告：

```
openGauss=# SELECT alias, Description, token FROM ts_debug('english','foo-bar-beta1');
      alias      |               Description                |     token
-----------------+------------------------------------------+---------------
 numhword        | Hyphenated word, letters and digits      | foo-bar-beta1
 hword_asciipart | Hyphenated word part, all ASCII          | foo
 blank           | Space symbols                            | -
 hword_asciipart | Hyphenated word part, all ASCII          | bar
 blank           | Space symbols                            | -
 hword_numpart   | Hyphenated word part, letters and digits | beta1
```

这种行为是有必要的，因为它支持搜索整个复合词和各组件。这里是另一个例子：

```
openGauss=# SELECT alias, Description, token FROM ts_debug('english','http://example.com/stuff/index.html');
  alias   |  Description  |            token
----------+---------------+------------------------------
 protocol | Protocol head | http://
 url      | URL           | example.com/stuff/index.html
 host     | Host          | example.com
 url_path | URL path      | /stuff/index.html
```

N-gram是一种机械分词方法，适用于无语义中文分词场景。N-gram分词法可以保证分词的完备性，但是为了照顾所有可能，把很多不必要的词也加入到索引中，导致索引项增加。N-gram支持中文编码包括GBK、UTF-8。内置6种token类型，如[表2](#zh-cn_topic_0283137134_zh-cn_topic_0237122032_zh-cn_topic_0059778480_t1ca85b79b4344a59a8aca574c9fdc12f)所示。

**表 2**  token类型

zh_words chinese words en_word english word numeric numeric data alnum alnum string grapsymbol graphic symbol multisymbol multiple symbol

Pound是一种固定格式分词方法，适用于无语意但待解析文本以固定分隔符分割开来的中英文分词场景。支持中文编码包括GBK、UTF8，支持英文编码包括ASCII。内置6种token类型，如[表3](#zh-cn_topic_0283137134_zh-cn_topic_0237122032_table18356541133518)所示；支持5种分隔符，如[表4](#zh-cn_topic_0283137134_zh-cn_topic_0237122032_table14245115444310)所示，在用户不进行自定义设置的情况下分隔符默认为“\#”。Pound限制单个token长度不能超过256个字符。

**表 3**  token类型

zh_words chinese words en_word english word numeric numeric data alnum alnum string grapsymbol graphic symbol multisymbol multiple symbol

**表 4**  分隔符类型

分隔符 Special character Special character Special character Special character Special character
