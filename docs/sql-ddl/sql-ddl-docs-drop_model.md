# DROP MODEL

## 功能描述

删除一个已训练完成保存的模型对象。

## 注意事项

所删除模型可在系统表gs\_model\_warehouse中查看到。

## 语法格式

```
DROP MODEL model_name;
```

## 参数说明

model\_name

模型名称

取值范围：字符串，需要符合标识符的命名规范。

## 相关链接

[CREATE MODEL](create_model.md)，[PREDICT BY](predict_by.md)
