# GS\_MODEL\_WAREHOUSE

GS\_MODEL\_WAREHOUSE系统表用于存储AI引擎训练模型，其中包含模型，训练过程的详细描述。

**表 1**  GS\_MODEL\_WAREHOUSE字段

数据类型 oid oid 隐含列。
modelname name 唯一约束。
modelowner oid 模型拥有者的OID。
createtime timestamp 模型创建的时间。
processedtuples int 训练涉及的元组数。
discardedtuples int 未参加训练的不合格元组数。
preprocesstime real 数据预处理时长。
exectime real 训练时长。
iterations int 迭代轮次。
outputtype oid 模型输出的数据类型OID。
modeltype text AI算子的类型名称。
query text 创建模型所执行的query语句。
modeldata bytea 保存的二进制模型信息。
weight real[] 目前只适用于GD算子模型。
hyperparametersnames text[] 涉及的超参名称。
hyperparametersvalues text[] 超参所对应的取值。
hyperparametersoids oid[] 超参对应的数据类型OID。
coefnames text[] 模型参数名称。
coefvalues text[] 模型参数对应的取值。
coefoids oid[] 模型参数对应的数据类型OID。
trainingscoresname text[] 度量模型性能方法的名称。
trainingscoresvalue real[] 度量模型性能方法的数值。
modeldescribe text[] 模型的描述信息。
