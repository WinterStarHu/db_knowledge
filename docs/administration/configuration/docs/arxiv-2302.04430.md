# A Comparison of Decision Forest Inference Platforms from A Database Perspective

> 来源: https://arxiv.org/pdf/2302.04430

A Comparison of Decision Forest Inference Platforms from A
Database Perspective
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
1 Arizona State University, 2 IBM T. J. Watson Research Center, 3 Rensselaer Polytechnic Institute
ABSTRACT
Decision forest, including RandomForest, XGBoost, and LightGBM,
is one of the most popular machine learning techniques used in
many industrial scenarios, such as credit card fraud detection, rank-
ing, and business intelligence. Because the inference process is
usually performance-critical, a number of frameworks were devel-
oped and dedicated for decision forest inference, such as ONNX,
TreeLite from Amazon, TensorFlow Decision Forest from Google,
HummingBird from Microsoft, Nvidia FIL, and lleaves. However,
these frameworks are all decoupled with data management frame-
works. It is unclear whether in-database inference will improve the
overall performance. In addition, these frameworks used different
algorithms, optimization techniques, and parallelism models. It
is unclear how these implementations will affect the overall perfor-
mance and how to make design decisions for an in-database inference
framework. In this work, we investigated the above questions by
comprehensively comparing the end-to-end performance of the
aforementioned inference frameworks and netsDB, an in-database
inference framework we implemented. Through this study, we iden-
tified that netsDB is best suited for handling small-scale models on
large-scale datasets and all-scale models on small-scale datasets,
for which it achieved up to hundreds of times of speedup. In addi-
tion, the relation-centric representation we proposed significantly
improved netsDB’s performance in handling large-scale models,
while the model reuse optimization we proposed further improved
netsDB’s performance in handling small-scale datasets.
ACM Reference Format:
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong
Min2, Lei Yu3, Jia Zou1. 2018. A Comparison of Decision Forest Inference
Platforms from A Database Perspective. In Woodstock ’18: ACM Symposium
on Neural Gaze Detection, June 03–05, 2018, Woodstock, NY. ACM, New York,
NY, USA, 14 pages. https://doi.org/10.1145/1122445.1122456
1
INTRODUCTION
Decision forest models, such as RandomForest [18], XGBoost [22],
and LightGBM [37] are widely used machine learning algorithms
for classification and regression tasks in production scenarios, such
as search ranking in Microsoft Bing [40, 61], Alta Vista, Yahoo! [57],
and Yandex [39, 52], advertising in Facebook [32], credit-card fraud
*These authors contributed equally to this work
Permission to make digital or hard copies of all or part of this work for personal or
classroom use is granted without fee provided that copies are not made or distributed
for profit or commercial advantage and that copies bear this notice and the full citation
on the first page. Copyrights for components of this work owned by others than ACM
must be honored. Abstracting with credit is permitted. To copy otherwise, or republish,
to post on servers or to redistribute to lists, requires prior specific permission and/or a
fee. Request permissions from permissions@acm.org.
Woodstock ’18, June 03–05, 2018, Woodstock, NY
© 2018 Association for Computing Machinery.
ACM ISBN 978-1-4503-XXXX-X/18/06...$15.00
https://doi.org/10.1145/1122445.1122456
prediction, healthcare, business intelligence. Compared to deep
neural network models that are considered opaque, decision forest
models are easier to identify and explain the significant variables in
the data [13], which is important when applied to business decision
processes that have compliance and audit requirements. They are
popular for their robustness, scalability, and their abilities to handle
a large number of features, handle missing data, and work well
with both linear and non-linear relationships [17, 21, 28, 35, 48].
Given the importance of decision forest models, there are many
systems engineered recently to support and optimize the infer-
ence process of such models. Several highly cited examples of
open-source systems include Scikit-Learn [46], ONNX [16], Tensor-
Flow Decision Forest (TFDF) [31], TreeLite [25], HummingBird [43],
lleaves [4], and Nvidia FIL [9, 10]. However, we observed two sig-
nificant gaps in these systems and related performance studies:
The data management gap. All of these systems decouple the
inference computation and data management and thus introduce
additional latency for loading data from/to external data stores.
Existing databases, such as IBM Infosphere Data Warehouse, AT-
LAS [53], Oracle Data Mining, GLADE [24], MauveDB [27], have
support for “traditional ML” workloads based on Predictive Model
Markup Language (PMML), stored procedures, user-defined func-
tions (UDFs) and user-defined aggregates (UDAs), and views. How-
ever, there is little documentation discussing how these systems
implement and optimize for decision forest workloads. It is unclear
whether in-database inference will achieve lower end-to-end latency
than the standalone inference platforms.
The performance understanding gap. We identified key perfor-
mance factors that cover the main architectural differences among
the aforementioned decision forest inference frameworks. It is un-
clear how these design decisions will affect the end-to-end performance
and how to make such design decisions for an in-database inference
framework. These key performance factors include:
F1. Algorithm. There exist multiple algorithms for serving de-
cision forest models, including: (1) Naive tree traversal, which
traverses each decision tree from the root to the leaf, as illustrated
in Fig. 1(a) and Fig. 2(a). (2) Compiled tree traveral, which un-
rolls the naive tree traversal process into nested if-else blocks,
as illustrated in Fig. 2(b), to generate code that has conditional
branches optimized [4, 25, 47]. (3) Predicated tree traveral [15],
which replaces conditional branches by predicates to avoid branch
mis-predictions, as illustrated in Fig. 2(c). (4) Hummingbird [43],
which converts the decision tree inference into matrix computa-
tions, as illustrated in Fig. 1(b) to leverage tensor computing li-
braries such as TVM [23], TorchScript [45], and PyTorch [45]. (5)
QuickScorer [41, 42], which encodes each tree node into a bit vec-
tor and converts tree traversal into bit-wise AND operations of the
arXiv:2302.04430v1  [cs.DB]  9 Feb 2023

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
bit vectors of all FALSE nodes (i.e., tree nodes that are evaluated as
False for the current testing sample), as illustrated in Fig. 1(c).
F2. Parallelism. If using data parallelism, each thread runs the
entire decision forest inference computation on a different data
partition. When using model parallelism, each thread is respon-
sible for running the inference of a partition of trees over the input
data. Then the partial prediction results from all threads need to be
aggregated to generate the final prediction.
F3. Batching. Batching of testing samples for inferences is critical
in balancing resource utilization and the overall latency. Different
platforms and workloads desire different batch sizes to fully utilize
the system resources.
F4. Vectorization. Platforms such as lleaves, netsDB, Scikit-learn
(only the RandomForest and XGBoost), and TFDF, applied vector-
ization, as illustrated in Fig. 2(d), to their inference functions, so
that SIMD instructions can be leveraged to accelerate the inference.
1.1
Our Contributions
1. An in-database decision forest inference framework. To
address the data management gap, we implemented a prototype
of in-database decision forest inference in netsDB1, which is an
object-oriented relational database management system (RDBMS)
based on the PlinyCompute object model and query compilation
framework implemented in C/C++ [33, 34, 51, 58, 60, 62–66].
We explored different representations of the decision forest in-
ference in RDBMS. The UDF-centric representation encapsulates
the entire inference computation into a single UDF. We found that
when the size of the model increases, the cache locality worsens
quickly using this approach. The relation-centric representation
breaks down the inference computation into a flow of relational
operators, including a cross-product operator that pairs up each
decision tree and a block of testing samples. Then, for each pair,
the prediction function from the decision tree is invoked to pre-
dict for each sample in the block. This operator is followed by an
aggregate operator that aggregates all partial prediction results.
Both representations support batching and vectorization. In ad-
dition, the UDF-centric representation adopts data parallelism so
that each thread invokes the UDF on a data partition. The relation-
centric representation adopts model parallelism, e.g., the cross-
product operator is launched in multiple threads, with each thread
responsible for a model partition (i.e., a subset of decision trees).
The relation-centric representation requires a model partitioning
job stage. Once this job stage gets executed, its output can be reused
for inferring different datasets. We thus proposed the model-reuse
technique so that this job stage’s output is materialized to accelerate
executing different inference queries.
2. A comprehensive performance comparison. To address the
performance understanding gap, we compared the dedicated de-
cision forest inference frameworks and our proposed in-database
inference framework on a broad class of workloads at all scales us-
ing RandomForest, XGBoost, and LightGBM. The types of datasets
range from sparse to dense and narrow to wide. We compared the
1https://github.com/asu-cactus/netsdb
end-to-end latency of the decision forest inference process, includ-
ing data loading, inference, and result writing. The benchmarking
framework is fully automated and open-sourced2.
3. A series of interesting observations that may benefit fu-
ture database and AI/ML systems design, such as:
• Data loading is a major performance bottleneck, particularly for
(1) Workloads that infer large-scale datasets using small to medium
forest models that have tens to hundreds of trees; and (2) Workloads
that infer small-scale or wide-and-short datasets using all-scale
models. For these workloads, our in-database inference framework
achieved up to hundreds of times speedup.
• Cache locality is crucial to the performance of large-scale forest
models. Therefore, model parallelism, which reduces the memory
footprint of each thread/partition, outperformed data parallelism,
where each thread needs to access the whole model in memory.
• The relation-centric representation significantly improved netsDB’s
performance in handling large-scale models, while the UDF-centric
representation achieved the best performance for small-scale mod-
els. In addition, the model reuse optimization significantly improved
the performance of the relation-centric representation for handling
small-scale datasets.
• GPU platforms achieved lower costs than CPU platforms for
medium and large-scale forest models and large batches of data.
But CPU platforms outperformed GPU platforms in other cases
where data loading becomes the performance bottleneck.
• If only inference computation time is considered, the QuickScorer
algorithm achieved the best single-thread latency. The compilation-
based approach combined with other optimizations, as implemented
in lleaves, achieved the best inference latency among CPU platforms
for large-scale (LightGBM) models. Nevertheless, such an approach
required tremendous compilation latency, as detailed in Sec. 6.4.
2
SURVEY OF EXISTING PLATFORMS
A brief introduction about decision forest. RandomForest [18],
XGBoost [22], and LightGBM [37] are three different decision forest
training algorithms. Even training on the same dataset, with the
same number of trees and the same maximum depth of each tree,
the trained models could have different shapes using these training
algorithms [43]. The inference processes of the three decision forest
models share the same first phase, which is to obtain the exit leaf
for each tree in the forest. The second phase is slightly different.
Taking Scikit-learn implementations of binary classification as an
example, in the second phase, the RandomForest algorithm aver-
ages all trees’ exit labels and then applies a sigmoid function to
convert the averaged value to a probability score. For XGBoost and
LightGBM, the second phase sums up the weights of all exit labels
and then obtains the final prediction using a sigmoid function.
Platforms. Due to the popularity and importance of the decision
forest inference workloads, a number of platforms have been devel-
oped and dedicated for decision forest inferences. Next, we provide
a survey about the most popular platforms:
Scikit-learn [46] It implements its own RandomForest algorithm
but invokes the XGBoost [22] and LightGBM [37] libraries to train
and make inferences using XGBoost and LightGBM models. They
2https://github.com/asu-cactus/DFInferBench

---

A Comparison of Decision Forest Inference Platforms from A Database Perspective
Woodstock ’18, June 03–05, 2018, Woodstock, NY
N0
N1
N2
N3
N4
N5
N6
L0
L1
L2
L3
L4
L5
L6
L7
Threshold
N0
f[2] < 0.7
N1
f[0] < 0.9
N2
f[3] < 0.5
N3
f[2] < 0.3
N4
f[1] < 0.5
N5
f[2] < 0.1
N6
f[0] < 0.2
f = [0.4, 0.2, 0.8, 0.3]
L5 is the exit leaf
Class
L0
0
L1
1
L2
0
L3
1
L4
0
L5
1
L6
0
L7
1
Internal nodes
Leaf nodes
(a) Naive Tree Traversal
f = [0.4, 0.2, 0.8, 0.3]
0
1
0
0
0
0
1
0
0
0
0
1
0
0
1
0
0
1
0
1
0
0
0
1
0
0
0
0
×
< [0.7, 0.9, 0.5, 0.3, 0.5, 0.1, 0.2]
= [0.8, 0.4, 0.3, 0.8, 0.2, 0.8, 0.4]
= [0, 1, 1, 0, 1, 0, 0]
1
1
1
1
−1
−1
−1
−1
1
1
−1
−1
0
0
0
0
0
0
0
0
1
1
−1
−1
1
−1
0
0
0
0
0
0
0
0
1
−1
0
0
0
0
0
0
0
0
1
−1
0
0
0
0
0
0
0
0
1
−1
×
= [1, 1, 0, -2, 1, 1, -1, -1]
== [3, 2, 2, 1, 2, 1, 1, 0]
= [0, 0, 0, 0, 0, 1, 0, 0]
L5 is the 
exit leaf
A
C
(b) HummingBird
f[0]=0.4: 
N1
N6
f[1]=0.2: 
N4
f[2]=0.8: 
N0
N3
N5
f[3]=0.3: 
N2
True nodes
False nodes
code
N0
00001111
N1
00111111
N2
11110011
N3
01111111
N4
11011111
N5
11110111
N6
11111101
00001111 ∧01111111 ∧11110111 ∧11111101
= 00000101
L5 is the exit leaf 
(first non-zero bit)
(c) QuickScorer
Figure 1: Illustration of Decision Forest Algorithms.
float predict (float * f) {
int nodeIdx =0; //root node
while (! isLeaf(nodeIdx)) {
Node node = tree[nodeIdx];
if (f[node.featureIndex]< node.threshold) 
nodeIdx = leftChild(nodeIdx);
else
nodeIdx = rightChild(nodeIdx);
}
return tree[nodeIdx].label;
}
(a) Naive Prediction
float compiledPredict (float * f) {
if (f[2] < 0.7)
if (f[0] < 0.9)
if (f[2] < 0.3)
return 0;
else …
else  …
else … 
}
(b) Compiled Prediction
float predPredict (float * f) {
int nodeIdx =0; //root node
while (! isLeaf(nodeIdx)) {
Node node = tree[nodeIdx];
nodeIdx = leftChild(nodeIdx) +
(f[node.featureIndex]< 
node.threshold); 
}
return tree[nodeIdx].label;
}
(c) Predicated Prediction
float vectorizedPredict (
vector<float *> block)  {
for (f : block) {
// prediction logic as described
// in the body of  predict(), 
// compiledPredict(), 
// and predPredict()
}
}
(d) Vectorized Prediction
Figure 2:
Illustration of Different Tree-Traversal Implementa-
tions.
all implement the naive tree traversal algorithm for inference, as
illustrated in Fig. 1(a). Scikit-learn used model parallelism for ran-
dom forest prediction, each thread runs the inferences of a partition
of trees over the input data, and the results will be used to update
a shared result vector protected by a lock. The predict function is
vectorized by taking a batch of samples as input. Both XGBoost and
LightGBM libraries adopt data parallelism. The XGBoost library
also uses vectorization, while the LightGBM does not.
ONNX [16] It also uses the naive tree traversal algorithm. It
chooses data parallelism or model parallelism based on the number
of input samples and the number of trees in the forest. It does not
exploit vectorization, and the underlying tree traversal function
takes a single sample as input at a time.
HummingBird [43] It transforms the tree traversal process into
tensor computations, as illustrated in Fig. 1(b). It first converts the
decision tree structure to two main tensors: (1) A tensor A that
represents the relationships between each internal node and each
feature; (2) A tensor C that captures the parent-child relationships
among each pair of internal nodes. Then, the tensor of input samples
is multiplied with tensor A to obtain the input path tensor. After
that, the input path tensor is multiplied with tensor C to obtain the
output path tensor. This way, existing tensor libraries on the CPU
and GPU can be leveraged to accelerate the prediction process.
TensorFlow Decision Forest (TFDF) [11] It wraps a C++-based
Yggdrasil library [31], which implements the QuickScorer algo-
rithm [41, 42, 56] as well as the naive tree traversal algorithm. It
will benchmark and select the best algorithm at the model compila-
tion stage. The QuickScorer algorithm is illustrated in Fig. 1(c). It
first encodes every tree node into a bit vector, with each bit corre-
sponding to a leaf node. If the bit is set to 0, it means the leaf node
is impossible to be the exit leaf if the current node is a FALSE node
(i.e., evaluated to False). For a given input sample, the prediction of
one decision tree can be obtained by applying the bit-wise AND
operation to the bit vectors of all FALSE nodes. To identify FALSE
nodes, the algorithm first groups the nodes from all trees in the
model by features so that nodes regarding the same feature from
different trees are stored together and sorted by their predicate
thresholds. Given an input sample, it quickly determines all FALSE
nodes using binary searches.
TreeLite [25] It imports external models and partitions the trees
into several compilation units. These compilation units will be trans-
formed to C source functions in parallel. Each C source function
corresponds to a compilation unit. As illustrated in Fig. 2(b), it takes
a single sample as input, runs a series of nested if-else blocks, and
outputs the final predictions for trees belonging to the compilation
unit. Then, these C source code functions will be further compiled
into a shared library (i.e., a .so file). At prediction time, the shared
library will be loaded to perform the prediction.
Nvidia FIL [9, 10] FIL implements a GPU version of the predicated
tree traversal algorithm. Each GPU thread is responsible for infer-
ring a batch of samples on one tree. To optimize the GPU cache local-
ity, it exploits a reorganized dense tree representation in GPU mem-
ory, where the nodes at the same level but from different trees will
be stored together to improve the cache locality. It also implements a
sparse tree storage format, where the nodes from all trees are stored
in one flat array. While nodes from one tree are stored together,
sibling nodes that share the same parent node are always stored
adjacently. For both cases, because the left child and right child are
stored adjacently, it can use a predicate to replace the conditional
branch. As illustrated in Fig. 2(c), the conditional branch: if (cond)

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
write
transform
scan
sample
blocks
(a) UDF-Centric
cross-product
scan
scan
transform
aggregate
write
trees
sample
blocks
(b) Relation-Centric
cross-product
w/ model reused
scan
transform
aggregate
write
sample
blocks
(c) Model Reuse
Figure 3:
Computation graph for various database representa-
tions.
returnleft(node_idx) else return right(node_idx), is re-
placed by return left(node_idx) + cond, which avoided branches
in GPU computation.
lleaves [4] It also compiles trees to nested if-else blocks. How-
ever, instead of translating the model into C source codes for com-
pilation, lleaves designs an intermediate representation to describe
the models and leverages the LLVM framework for code genera-
tion. Notably, lleaves is more optimized than TreeLite. For example,
the functions generated by lleaves support vectorization. Lleaves
currently only supports the LightGBM model on CPU.
3
OUR IN-DATABASE INFERENCE DESIGN
3.1
Key Design Decisions
Algorithm. We found that the naive tree traversal algorithm and
the predicated tree traversal algorithm are best suited for RDBMS.
The compiled tree traversal algorithm requires code generation
for UDFs such as the predict function, which is not supported in
many RDBMS. The HummingBird algorithm relies on optimization
for expensive matrix computations, and it is not suitable for most
RDBMS designed for CPU platforms. The QuickScorer algorithm
is hard to be represented in a relation-centric style. One reason
is that the QuickScorer model groups all nodes by features; thus,
the model is essentially a collection of feature groups. Because the
sizes of feature groups are not well-balanced, it is challenging to
partition the model evenly. In addition, C++ lacks a good library for
large bit vectors that have more than 64 bits, which limits the num-
ber of leaf nodes to 64 in a decision tree. For example, the TFDF’s
implementation of QuickScorer is single-threaded and only sup-
ports a maximum tree depth of 6 (i.e., 𝑙𝑜𝑔64
2 ). We thus implemented
both naive tree traversal and predicated tree traversal algorithms
in netsDB, but we did not observe any significant difference in the
inference time for most of the workloads.
Storage of Input Samples. Physically, the input samples are stored
as a collection of tensor blocks, called sample blocks. Each block is
a 2D tensor that represents a vector of feature vectors.
Batching. The application can specify a batch size to control the
number of sample blocks in one batch. Then, the application can
iteratively issue an inference query to process one batch until all
batches are processed.
Scheduling and Parallelism. In netsDB, similar to other dataflow
frameworks such as Apache Spark [14, 59], the users develop their
applications as dataflow graphs, where every node represents a
relational operator (which should be customized using UDFs) and
every edge represents a dataset. At runtime, a dataflow graph is split
into multiple pipeline (job) stages. A pipeline stage is a series of
atomic operators (e.g., scan, transform, hash, partition, probe,
join, cross-product, aggregate, write) with the last operator
being a pipeline breaker that materializes the output data (e.g., hash,
partition, aggregate, write). For example, a cross-product re-
lational operator will be split into multiple atomic operators be-
longing to different pipeline stages as described in Sec. 3.3. Each
pipeline stage is executed with multiple threads. These threads run
the same logic but with different input data. Usually, we configure
the number of threads for each pipeline stage to be the number
of CPU cores. As we will detail in Sec. 3.2 and Sec. 3.3, the UDF-
centric representation of decision forest inference implements data
parallelism, and the relation-centric representation implements
model-parallel inferences.
Vectorization. When executing a pipeline stage, each thread it-
eratively fetches a vector of sample blocks and runs a series of
atomic operators to process the vector. Each atomic operator in the
pipeline stage is vectorized. It takes in a vector of sample blocks
and outputs a vector of result blocks to the next atomic operator.
3.2
The UDF-Centric Representation
With the UDF-centric representation, the decision forest inference
logic is encapsulated in a single UDF that customizes a transform
operator (i.e., like a map function). The UDF contains a forest object,
which is a vector of trees, and each tree is stored as a vector of tree
nodes. The UDF has a prediction function that takes a sample block
as input and outputs a block of predictions. The prediction function
iteratively processes each sample in the block by traversing each
tree and aggregating the prediction of all trees.
As illustrated in Fig. 3(a), the corresponding dataflow graph for
a simple example of UDF-centric inference consists of a transform
operator that is customized by a UDF, which takes a sample block
as input and outputs a result block. After compilation, the dataflow
graph is scheduled as one pipeline stage. Each thread iteratively
fetches a vector of sample blocks, runs the prediction UDF over it,
and writes the final predictions to an output dataset. The UDF is
initialized by parsing a pre-trained scikit-learn model.
The benefit of this approach is in its simplicity, e.g., the inference
process is compiled to a single pipeline stage. The encapsulation
also facilitates extending the UDF to invoke functions from popular
libraries, including GPU libraries. The shortcoming is that each
CPU core needs to access the whole forest model, which leads to
significant cache misses for large-scale models.
3.3
The Relation-Centric Representation
To reduce the cache misses for inferences with large-scale models,
we propose a relation-centric representation that facilitates model
parallelism. As illustrated in Fig. 3(b), we represent the decision
forest inference process as a dataflow graph that uses two key oper-
ators: (1) A cross-product operator, which performs a Cartesian
product between the collection of trees and the collection of input
sample blocks, and enumerates all possible pairs of tree and sample
block. Each pair is further converted into a block of prediction
results (e.g., the return class or weight associated with the exit leaf)

---

A Comparison of Decision Forest Inference Platforms from A Database Perspective
Woodstock ’18, June 03–05, 2018, Woodstock, NY
using a transform UDF that performs tree traversal over each sam-
ple in the block iteratively. (2) An aggregate operator is used to
aggregate all prediction results for the same sample using different
aggregation logic for different types of models.
To reduce the cache misses, we implement the cross-product
operator in a model-parallel fashion. It partitions the model into
many subsets of decision trees and allocates each partition to a
thread. Then, a pointer to each page from the inference dataset
is sent to all threads for generating the cross-product and partial
prediction results. Using this approach, each thread only needs
to access a partition of trees. It significantly reduces the cache
misses and shortens the inference latency for large-scale models,
as observed in our experiments.
Model Reuse. While the relation-centric representation works
well for inferring large datasets, it brings significant overheads
for processing small datasets. That is because compared to the
UDF-centric representation that only requires one pipeline stage,
the relation-centric representation is compiled to multiple pipeline
stages because there exist multiple pipeline breakers in the dataflow
graph. For example, one stage partitions the model, one stage runs
the cross-product and groups partial prediction results by tree
IDs, one stage aggregates the prediction results from all trees, and
one stage post-processes the aggregated result (e.g., applying the
sigmoid function) and writes the final output to a dataset. To reduce
the overheads, we identified that the model-partitioning stage can
be reused by different inference applications as long as they use
the same model. Therefore, we can materialize the results of this
pipeline stage and directly reuse the materialized results to simplify
the dataflow graph, as illustrated in Fig. 3(c).
4
BENCHMARK WORKLOAD DESCRIPTION
We evaluated the performance of various decision forest models at
all scales on well-known classification datasets, as shown in Tab. 1.
Table 1: Statistics of the Datasets
Dataset
NumRows
NumFeatures
Prediction Type
Testing Ratio
Epsilon
100K
2000
Classification
20%
Fraud
285K
28
Classification
20%
Year
515K
90
Regression
20%
Bosch
1.184M
968
Classification
20%
Higgs
11M
28
Classification
20%
Criteo
51M
1M
Classification
11%
Airline
115M
13
Classification/Regression
20%
TPCx-AI (SF=30)
131M
7
Classification
100%
Most of the platforms investigated in this work, such as ONNX,
HummingBird, TreeLite, lleaves, and netsDB, can not directly train
a model. Therefore, we use Scikit-learn to train models using Ran-
domForest, XGBoost, and LightGBM algorithms on each evaluation
dataset in Tab. 1. For each type of model, we used a different number
of trees, ranging from 10 to 1, 600, with each tree having a maxi-
mum depth of 8. These are all widely used hyper-parameters [43].
We then convert these models to be loaded to each platform for
inferences. The performance of the model conversion and loading
process is discussed in Sec. 6.4.
For most datasets except TPCx-AI [12] and Criteo [1], we used
80% of samples to train models. Then we convert the trained model
to run inferences against the 20% remaining samples on each target
platform. For TPCx-AI, we used the fraud detection scenario [12].
We trained the model on a smaller dataset with scale factor (SF) 1,
then tested the model on the dataset with SF 30, which is described
in Tab. 1. For Criteo, the training and testing data was pre-split by
the data provider [1, 3], as illustrated in Tab. 1.
Target Scenarios. In this work, we focused on the end-to-end la-
tency of inference pipelines that ran all types of models to make
inferences for datasets that are managed by native or external data
stores. In practice, features are extracted from databases in many
industrial scenarios, such as fraud detection and recommendation
based on transaction records [38]. Therefore, for netsDB, the test-
ing datasets were stored natively. For other platforms, the testing
datasets, except for Epsilon and Criteo, were stored in tabular for-
mat in a PostgreSQL database installed on the same machine, with
the database connection accelerated using the state-of-art Connec-
torX library [54]. Besides, Epsilon has 2000 features, and Criteo
has 1 million features, but PostgreSQL only supports up to 1600
columns [8]. Therefore, for Epsilon, we stored each tuple in Array
type in PostgreSQL, which turned out to be slower than the tabular
format in data loading as detailed in Sec. 6.3.2. For Criteo, we simply
loaded it from a LIBSVM file in sparse storage format [20].
We measured data loading time, inferences time, and data writing
time in an end-to-end inference process. We did not consider the
model conversion and model loading time as part of the end-to-end
latency because these times can be amortized to multiple inference
queries. We will discuss such one-time costs in Sec. 6.4.
5
EXPERIMENTAL CONFIGURATION
Software Configuration. We used version Scikit-learn v1.1.2, ONNX
v1.12.0, Hummingbird v0.4.5, Nvidia Rapids-FIL v22.08, TreeLite
v2.3.0, TFDF v0.2.7, PostgreSQL v14. For lleaves, netsDB, and Con-
nectorX, we used the code download from their Github master
repositories. For all platforms, we carefully tune the number of
threads to fully use the computational resources.
We ran the HummingBird models in several different backends,
including Pytorch v1.13.1, TorchScript (within Pytorch v1.13.1), and
TVM v0.10.0, with and without GPU acceleration.
Nvidia FIL provides multiple options for inferences: (1) Auto,
which automatically estimates and selects the best-performing strat-
egy; (2) Batch Tree Reorganization for the dense forest storage for-
mat; (3) Using the sparse forest storage format. We used the Auto
option by default.
The TFDF platform only supported the loading from Scikit-learn
RandomForest models [11]. With the help of Google TFDF engi-
neers, we developed a converter to import XGBoost models to TFDF
models. To this point, there is no API available for parallelizing the
TFDF inference process, and it is slower than other platforms in
most cases, and we omit the TFDF results in the overall evaluation
(Sec. 6) and only discuss them in the detailed analysis (Sec. 7).
Hardware Configuration. For CPU experiments, we used the
AWS EC2 r4.2xlarge instance with 8 CPU cores and 62 gigabytes of
memory. All instances are installed with Linux Ubuntu 20 and 200
gigabytes SSD storage. The cost of the instance is $0.532 per hour.
For the GPU experiments, we used an AWS g4dn.2xlarge instance,
which has an NVIDIA T4 Tensor Core GPU with 16 gigabytes
memory and an eight-core CPU with 32 gigabytes host memory.
Its cost is $0.752 per hour.

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
To resolve the performance variations in cloud environments,
we repeated each experiment multiple times. In total, we used more
than 10,000 hours of the AWS EC2 platform for the evaluation.
Profiling We monitored the various system resource utilization
for CPU, memory, and disk I/O. In addition, we used Linux Perf to
profile the elapsed time as well as cache misses. We used gpustat,
a wrapper built on nvidia-smi, for profiling the GPU performance
and memory utilization.
6
OVERALL EVALUATION RESULTS
We first describe the overall evaluation results in three categories:
small-scale dense datasets, medium to large-scale dense datasets,
and sparse and/or wide datasets. For each case/measurement, the
batch size is carefully tuned for each platform to achieve the lowest
latency. We will discuss how batch size affects the overall perfor-
mance in the detailed analysis (Sec. 7). Finally, we will discuss the
model conversion and loading overheads which are not counted in
the overall evaluation results.
6.1
Small-Scale Dense Datasets
In this section, we will summarize the results on two relatively
smaller datasets: Fraud and Year, as described in Tab. 1.
The overall benchmark results for Fraud and Year are illustrated
in Tab. 2 and Tab. 3. It showed that among all CPU/GPU plat-
forms, netsDB with the UDF-centric representation (netsDB-UDF)
achieved the lowest latency for small models that have 10 trees.
NetsDB with the model reuse optimization (netsDB-OPT) signifi-
cantly reduced the latency for the relation-centric representation
(netsDB-Rel) and achieved the lowest latency for medium to large
models with 500 and 1600 trees across all platforms. That is because
inference on such small datasets is significantly faster than data
transfer, and data transfer thus becomes the major bottleneck. This
bottleneck gets avoided using in-database inference.
6.1.1
Fraud. We have the following key observations on this work-
load. First, netsDB outperformed other CPU/GPU platforms. That is
because data transfer is the major bottleneck of the Fraud workload,
as illustrated in Fig. 4. When applying 10-tree models to the Fraud
dataset, data transfer accounts for 90% of overall latency on ON-
NXCPU, 95% on lleaves, and 97% on HB-TVM. However, the ratio
of data transfer latency to the overall latency decreases with the
increase in model sizes. For example, for 1600-tree models, the afore-
mentioned ratios dropped to 65%, 76%, and 88% respectively. Second,
netsDB-Rel performed significantly worse than other CPU/GPU
platforms for models with 500 and 1, 600 trees. That is mainly be-
cause it runs multiple pipeline stages, including partitioning the
model to prepare for the cross-product operation. The schedul-
ing and materialization overheads are significant compared to the
inference latency. The model reuse technique, as in netsDB-OPT,
resolved the issue and improved the performance. Third, netsDB,
ONNX, and lleaves achieved better monetary costs than GPU plat-
forms (see Sec. 5 for AWS cost information). It indicates that GPU
may not be very helpful for the inferences on small datasets, which
is ubiquitous in real-time applications where testing samples are
batched in small-size buffers to guarantee low buffering latency.
0
1
2
3
4
5
netsDB
ONNX
GPU-HB-TVM
netsDB
ONNX
GPU-HB-TVM
netsDB
lleaves
GPU-HB-TVM
netsDB
ONNX
GPU-HB-TVM
netsDB
ONNX
GPU-HB-TVM
netsDB
lleaves
GPU-HB-TVM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
Fraud
Year
Latency (seconds)
data loading
inference
data writing
(a) 10 trees
0
1
2
3
4
5
netsDB
ONNX
GPU-HB-TVM
netsDB
ONNX
GPU-HB-TVM
netsDB
lleaves
GPU-HB-TVM
netsDB
ONNX
GPU-HB-TVM
netsDB
ONNX
GPU-HB-TVM
netsDB
lleaves
GPU-HB-TVM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
Fraud
Year
Latency (seconds)
data loading
inference
data writing
(b) 500 trees
0
2
4
6
netsDB
CPU-ONNX
GPU-HB-TVM
netsDB
CPU-ONNX
GPU-HB-TVM
netsDB
CPU-lleaves
GPU-HB-TVM
netsDB
CPU-ONNX
GPU-HB-TVM
netsDB
CPU-ONNX
GPU-HB-TVM
netsDB
CPU-lleaves
GPU-HB-TVM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
Fraud
Year
Latency (seconds)
data loading
inference
data writing
(c) 1600 trees
Figure 4: Latency breakdown for netsDB, the fastest of the rest
CPU platforms, and the fastest GPU platform on small datasets.
6.1.2
Year. The observations for the Year workload are similar to
Fraud, except that netsDB achieved significantly higher speedups
on the Year dataset. For example, as illustrated in Tab. 3, for small
models with 10 trees, netsDB-UDF achieved 7.6× speedup compared
to the best GPU platform, and 9.4× speedup compared to the best
of the rest CPU platform. But the corresponding speedups achieved
on the Fraud dataset were merely 1.8× and 2×, respectively. Then,
for 500-tree models, netsDB-OPT achieved 3× speedup compared
to the best GPU platform and 4× speedup compared to the second-
best CPU platforms, while the corresponding speedups achieved
on the Fraud dataset was merely 1.1 to 1.3× for CPU and 1.1 to
1.5× for GPU. In addition, for the case of 1, 600-tree models, for the
Year dataset, netsDB-OPT achieved 1.7 to 2.5× speedup compared
to the best GPU platform and 1.5 to 2.7× speedup compared to the
second-best CPU platforms. However, for the same case, there was
no significant speedup achieved on the Fraud dataset by netsDB-
OPT compared to GPU platforms, and the speedup compared to
the second-best CPU platforms was merely 1.1 to 1.4×.
As illustrated in Fig. 4, the data loading and writing times ac-
counted for 96%, 96%, and 98% on ONNXCPU, lleaves, and HB-TVM,
respectively, which were even higher than the corresponding ratios
for the Fraud workload. This explained the better speedup achieved
on Year. Similar to Fraud, the ratio of data loading latency to the
overall end-to-end latency decreased with the increase in model

---

A Comparison of Decision Forest Inference Platforms from A Database Perspective
Woodstock ’18, June 03–05, 2018, Woodstock, NY
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
netsDB-OPT
HB-Pytorch
HB-TS
HB-TVM
FIL
RandomForest
10 Trees
1.0
1.0
1.0
1.3
1.0
1.0
-
0.5
2.1
0.6
0.9
1.4
0.9
1.0
500 Trees
1.3
1.1
4.4
4.0
1.5
1.2
-
1.3
2.3
0.7
1.0
1.4
0.9
1.0
1600 Trees
2.2
1.4
13.0
11.0
2.8
1.8
-
3.5
2.6
1.0
1.2
1.6
1.0
1.0
XGBoost
10 Trees
1.0
1.0
1.0
1.3
1.0
1.0
-
0.5
2.1
0.7
0.9
1.7
0.9
1.0
500 Trees
1.1
1.1
4.5
4.1
1.7
1.2
-
1.0
2.3
0.8
1.0
1.7
0.9
1.0
1600 Trees
1.3
1.4
13.0
11.0
2.5
1.4
-
2.1
2.6
1.0
1.2
1.7
1.0
1.0
LightGBM
10 Trees
1.0
1.0
1.0
1.4
1.0
1.0
1.0
0.5
2.1
0.6
0.9
1.7
0.9
1.0
500 Trees
1.5
1.2
4.4
4.0
1.7
1.5
1.0
1.1
2.3
0.8
1.0
1.7
0.9
1.0
1600 Trees
2.5
1.6
12.8
10.7
2.5
2.6
1.2
1.7
2.8
1.1
1.2
1.7
0.9
1.0
Table 2: End-to-End Latency Comparison for Fraud. (Unit: seconds)
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
netsDB-OPT
HB-Pytorch
HB-TS
HB-TVM
FIL
RandomForest
10 Trees
4.7
4.7
4.8
5.1
4.7
4.7
-
0.5
2.3
0.8
3.8
4.3
3.8
3.9
500 Trees
5.5
5.2
11.5
10.4
5.9
6.4
-
1.4
2.9
1.3
3.9
4.4
3.9
4.0
1600 Trees
7.3
6.5
27.4
23.1
7.7
10.8
-
4.8
4.2
2.6
4.3
4.6
4.0
4.0
XGBoost
10 Trees
4.6
4.7
4.7
5.2
4.7
4.7
-
0.5
2.3
0.8
3.8
4.6
3.8
3.9
500 Trees
5.1
5.1
11.2
10.3
6.2
6.1
-
1.6
2.8
1.2
4.0
5.0
3.8
3.9
1600 Trees
6.1
5.9
26.7
23.2
7.1
9.7
-
4.8
3.8
2.3
4.3
5.3
4.0
4.0
LightGBM
10 Trees
4.7
4.7
4.8
5.1
4.7
4.7
4.7
0.5
2.3
0.8
3.8
4.3
3.8
3.9
500 Trees
6.3
5.2
11.3
10.3
6.1
6.1
5.0
1.5
2.7
1.2
4.0
4.4
3.8
4.0
1600 Trees
10.2
6.1
26.5
22.7
7.4
9.9
5.9
5.0
3.7
2.2
4.3
4.6
4.0
4.1
Table 3: End-to-End Latency Comparison for Year. (Unit: seconds)
sizes. For 1600-tree models, the aforementioned ratios dropped to
69%, 77%, and 94% for the Year case.
6.1.3
Summary of Findings. The key findings are as follows:
(1) The in-database inferences outperformed all CPU/GPU plat-
forms for small datasets because the data loading process is always
a major performance bottleneck.
(2) NetsDB achieved lower costs than GPU platforms in all cases,
and GPU is not very helpful for the inferences over small datasets,
which are insufficient to fully utilize GPU resources. The inference
computation time is insufficient to compensate for the overheads
of transferring data between CPU and GPU.
6.2
Medium to Large-Scale Dense Datasets
This section mainly investigates the performance of three work-
loads, Higgs, Airline, and TPCx-AI. The overall benchmark results
for these datasets are illustrated in Tab. 4, Tab. 5, and Tab. 6. When
processing those larger-scale datasets, the latency difference be-
tween netsDB-Rel and netsDB-OPT is insignificant compared to
the overall latency, so we omitted netsDB-OPT in the results.
6.2.1
Higgs. As illustrated in Tab. 4, when only using CPU pro-
cessors, for a 10-trees model, netsDB-UDF achieved 8 to 10 times
speedup compared to the fastest of the rest CPU platforms. When us-
ing 500 trees, netsDB-Rel achieved 1.3× to 1.6× speedup compared
to the fastest of the rest CPU platforms. For large-scale decision
forest models with 1, 600 trees, netsDB is slightly worse than the
lleaves for LightGBM, but it is still slightly better than the Scikit-
learn (XGBoost) and ONNX platforms and significantly better than
all other CPU platforms. When serving 500 to 1, 600 trees, utiliz-
ing GPU significantly accelerated the decision forest prediction at
even lower costs. Nvidia FIL and HummingBird with TVM as the
backend achieved the best end-to-end performance on GPU.
As illustrated in Fig. 5(a), most of the performance gain when
using netsDB was contributed by the avoidance of the data transfer
time, which is the major bottleneck for serving small-scale models.
However, when the number of trees increases to 1600 trees, infer-
ence, instead of data transfer, becomes the primary bottleneck, as
illustrated in Fig. 5(a). This explained the drop in the performance
gain brought by netsDB with the increase in model sizes.
6.2.2
Airline. As illustrated in Tab. 5, the speedup achieved by
netsDB on this workload is even higher than the Higgs workload.
In terms of end-to-end time, for 10-tree models, the netsDB-UDF
achieved 18×-21× speedup compared to the fastest of the rest of
the CPU platforms. For 500-tree models, netsDB-Rel achieved 1.3×
to 1.9× speedup compared to the fastest of the rest CPU platforms.
Similar to Higgs, the performance gain shrinks with the increase
in model size. For RandomForest and XGBoost 1, 600-tree models,
netsDB-Rel achieved 1.3× speedup. For LightGBM with 1, 600 trees,
lleaves still performed slightly better than netsDB. In addition,
similar to Higgs, the GPU platforms achieved significantly lower
monetary costs than the CPU platforms in most cases.
As illustrated in Tab. 1, the size of the Airline testing dataset
is five times larger than Higgs. As a result, the time spent in data
transfer accounts for a significantly higher proportion in the end-
to-end latency than Higgs, as observed in Fig. 5(b). This explained
the increased performance gain of netsDB for the Airline case.

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
HB-Pytorch
HB-TS
HB-TVM
FIL
RandomForest
10 Trees
8.3
9.3
8.5
8.9
8.5
7.8
-
0.9
2.7
7.7
8.6
7.8
8.4
500 Trees
28.2
20.3
60.6
48.4
29.3
42.4
-
24.4
14.2
11.7
10.6
9.4
8.7
1600 Trees
70.8
45.2
205.5
167.1
80.8
130.4
-
98.6
42.0
20.6
16.1
11.0
11.1
XGBoost
10 Trees
8.1
9.3
8.7
8.8
8.8
8.3
-
0.6
2.3
8.0
8.6
7.8
8.0
500 Trees
19.1
20.8
57.5
47.5
33.0
35.3
-
25.9
13.1
11.6
11.0
8.4
8.3
1600 Trees
35.9
37.6
Failed
Failed
61.5
99.1
-
98.51
34.7
20.3
16.1
10.1
8.8
LightGBM
10 Trees
8.5
9.3
8.8
9.1
8.8
8.5
8.1
0.9
2.7
7.8
8.6
7.8
8.2
500 Trees
39.6
18.9
56.8
47.6
32.8
34.6
14.5
26.4
14.2
11.6
11.1
8.5
8.5
1600 Trees
113.2
39.2
202.8
183.3
61.1
102.8
29.5
119
38
20.3
16.1
9.1
9.0
Table 4: End-to-End Latency Comparison for Higgs. (Unit: seconds)
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
HB-Pytorch
HB-TS
HB-TVM
FIL
RandomForest
10 Trees
60.7
74.2
77.5
71.8
63.5
55.1
-
3.3
17.6
45.7
45.7
45.3
46.9
500 Trees
210.6
146.2
1502.2
1229.5
273.1
336.3
-
302.3
82.4
86.0
70.8
52.0
50.3
1600 Trees
543.5
305.5
5206.3
4144.7
760.8
1052.0
-
1120.6
239.4
177.7
126.4
70.6
62.5
XGBoost
10 Trees
59.2
73.3
77.9
69.8
63.8
59.8
-
2.9
18.6
45.7
45.8
45.3
46.1
500 Trees
143.4
137.8
1468.9
1212.8
305.2
264.7
-
272.3
80.1
85.3
70.7
51.3
47.5
1600 Trees
340.2
287.1
5130.3
4232.3
613.1
862.0
-
1071.1
220.0
175.8
125.0
68.4
51.9
LightGBM
10 Trees
60.5
74.7
77.5
71.8
64.3
59.4
58.8
2.8
18.6
45.7
45.8
45.3
46.7
500 Trees
339.7
144.1
1421.2
1142.6
306.4
224.5
98.8
96.9
76.5
85.2
70.9
51.4
49.8
1600 Trees
1039.2
296.5
4909.6
4198.1
614.0
654.8
185.0
914.8
220.7
176.1
125.1
68.5
59.5
Table 5: End-to-End Latency Comparison for Airline. (Unit: seconds)
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
HB-Pytorch
HB-TS
HB-TVM
FIL
RandomForest
10 Trees
449.4
513.3
462.6
469.9
448.3
450.1
-
3.2
56.2
444.5
442.6
442.3
448.2
500 Trees
1233.9
865.1
4521.1
3087.0
1635.4
1061.0
-
1391.7
363.7
678.3
584.6
480.7
465.6
1600 Trees
3386.0
1649.3
15302.0
10482.5
4311.0
3153.7
-
5000.7
1551.4
1201.4
906.5
605.7
526.7
XGBoost
10 Trees
438.4
485.5
438.4
441.9
461.3
441.5
-
2.3
22.2
444.6
443.1
447.6
444.6
500 Trees
925.7
883.4
3821.6
2967.8
1835.4
1560.1
-
1328.1
369.9
678.3
583.5
476.6
451.9
1600 Trees
2014.7
1614.1
14093.3
11509.2
3590.2
4928.4
-
4735.7
1612.9
1193.0
895.1
578.6
479.6
LightGBM
10 Trees
445.1
509.9
434.1
436.7
447.0
434.2
434.7
2.8
22.2
443.3
442.8
445.7
447.7
500 Trees
2069.0
916.7
3711.0
3023.6
1876.2
1070.9
586.9
1122.0
366.2
672.9
580.5
478.4
463.3
1600 Trees
6146.0
1739.3
12196.5
11143.7
3646.8
3388.8
997.2
4623.6
1599.5
1186.2
890.1
573.6
529.5
Table 6: End-to-End Latency Comparison for TPCx-AI. (Unit: seconds).
6.2.3
TPCx-AI. This workload used all 131 million of samples for
inferences. With the increase in input dataset size, the data transfer
time accounts for an even higher proportion in the overall latency
than Higgs and Airline, as illustrated in Fig. 5. Correspondingly,
the speedup achieved by netsDB also increased compared to Higgs
and Airline, as illustrated in Tab. 6.
NetsDB-UDF achieved more than 100× speedup compared to all
other CPU/GPU platforms for the 10-tree models. Moreover, for
models with 500 trees, netsDB-Rel achieved more than 1.6× to 2.4×
speedup compared to the fastest of other CPU platforms, and it
achieved 1.2× to 1.3× speedup compared to the fastest of the GPU
platforms. Even for 1, 600-tree models, netsDB-Rel outperformed
all other CPU platforms for RandomForest and XGBoost, though
it is slower than lleaves for LightGBM. However, netsDB is slower
than most of the GPU platforms in that case due to the increased
GPU utilization. Compared to GPU platforms, the CPU platforms
can reduce the monetary costs for models with 10 trees and 500
trees by 99% and 44%, respectively. However, for serving models
with 1, 600 trees, GPU can achieve better overall costs.
6.2.4
Summary of Findings. The key findings are:
(1) On the CPU platforms, the in-database analytics outperformed
other platforms in most cases, except that it is slightly worse than
lleaves for large-scale model sizes (e.g., 1, 600 trees). That is because,
when model size decreases, the data loading process becomes a more
severe performance bottleneck.

---

A Comparison of Decision Forest Inference Platforms from A Database Perspective
Woodstock ’18, June 03–05, 2018, Woodstock, NY
0
10
20
30
40
50
netsDB
TreeLite
GPU-HB-Pytorch
netsDB
Sklearn
GPU-HB-TVM
netsDB
lleaves
GPU-HB-TVM
netsDB
ONNX
GPU-FIL
netsDB
Sklearn
GPU-FIL
netsDB
lleaves
GPU-FIL
netsDB
ONNX
GPU-HB-TVM
netsDB
Sklearn
GPU-FIL
netsDB
lleaves
GPU-FIL
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
10 Trees
500 Trees
1600 Trees
Latency (seconds)
data loading
inference
data writing
(a) Higgs
0
100
200
300
netsDB
TreeLite
GPU-HB-TVM
netsDB
TreeLite
GPU-HB-TVM
netsDB
lleaves
GPU-HB-TVM
netsDB
ONNX
GPU-FIL
netsDB
ONNX
GPU-FIL
netsDB
lleaves
GPU-FIL
netsDB
ONNX
GPU-FIL
netsDB
ONNX
GPU-FIL
netsDB
lleaves
GPU-FIL
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
10 Trees
500 Trees
1600 Trees
Latency (seconds)
data loading
inference
data writing
(b) Airline
0
600
1200
1800
netsDB
TreeLite
GPU-HB-TVM
netsDB
TreeLite
GPU-HB-TS
netsDB
TreeLite
GPU-HB-TS
netsDB
ONNX
GPU-FIL
netsDB
ONNX
GPU-FIL
netsDB
lleaves
GPU-FIL
netsDB
ONNX
GPU-FIL
netsDB
ONNX
GPU-FIL
netsDB
lleaves
GPU-FIL
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
10 Trees
500 Trees
1600 Trees
Latency (seconds)
data loading
inference
data writing
(c) TPCx-AI
Figure 5: Latency breakdown for the netsDB, the fastest of the rest CPU platforms, and the fastest GPU platform for medium to large
datasets.
(2) GPU platforms outperformed netsDB on TPCx-AI using large
models and Higgs and Airline using medium to large models. How-
ever, netsDB outperformed most GPU platforms in all other cases.
(3) NetsDB-Rel significantly improved the performance of medium
to large-scale decision forest models compared to the netsDB-UDF.
That is because model parallelism reduced the memory footprint
and cache misses compared to data parallelism.
(4) Lleaves, which compiles decision trees to partitioned and vector-
ized functions that consist of nested if-else blocks, achieved the
best performance among CPU platforms for the LightGBM models.
6.3
Wide and/or Sparse Datasets
We also found that many popular datasets are wide and/or sparse.
For example, in Bosch, Epsilon, and Criteo, each tuple has 968,
2, 000, and 1M features, respectively. Among these datasets, Bosch
and Criteo are sparse datasets that contain missing values. The
overall results are illustrated in Tab. 7, Tab. 8, and Tab. 9, which are
explained in detail as follows.
6.3.1
Bosch. Bosch data in PostgreSQL contains NULL values.
At the inference time, it is loaded from PostgreSQL as a Pandas
DataFrame that contains nan values. Such sparse data is not directly
supported in Scikit-learn for training a RandomForest model, which
is needed by other dedicated inference platforms. Therefore, the
RandomForest results are unavailable for this workload in Tab. 7.
For models trained on top of sparse data, each tree node specifies
a default branch to follow if the feature of the tree node is missing
in the input sample.
As illustrated in Tab. 7, for ten trees, netsDB-UDF achieved
37× and 31× speedup compared to the second-best CPU platform
and the best GPU platform, respectively. For 500 trees, netsDB-
UDF achieved 8× speedup on CPU and 6× speedup on GPU. For
1, 600 trees, netsDB-OPT has better performance than netsDB-UDF,
achieving 2.8× speedup on CPU and 2.1× speedup on GPU.
We found that wide and short datasets were inferred much faster
than narrow and tall datasets of similar sizes. For example, the
total size of Bosch is similar to Airline; however, the inference time
of Bosch is significantly lower than Airline. That is because the
number of tuples in Bosch is only 1% of the number of tuples in
the Airline dataset. (The computational complexity of the decision
forest inference workload is mainly impacted by the number of
tuples in the inference dataset, the number of trees, and the number
of nodes in each tree.)
Moreover, because Bosch and Airline datasets have similar sizes,
their data transfer overheads are similar. As a result, for Bosch,
the ratio of the data transfer latency to the end-to-end latency

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
netsDB-OPT
HB-Pytorch
HB-TS
HB-TVM
FIL
XGBoost
10 Trees
22.8
23.0
22.6
23.7
23.8
23.6
-
0.6
4.2
2.4
19.0
20.0
19.5
19.6
500 Trees
23.4
24.9
28.4
27.1
26.1
26.2
-
3.4
8.0
6.2
19.4
19.9
19.6
19.7
1600 Trees
28.2
28.4
48.1
46.5
31.8
32.1
-
11.6
11.7
10.1
20.6
20.9
19.8
19.7
LightGBM
10 Trees
22.9
22.6
22.9
23.2
23.2
23.3
23.3
0.6
4.2
2.4
19.0
19.9
19.5
19.9
500 Trees
26.1
24.5
28.2
27.3
26.9
24.4
24.5
3.2
8.8
7.1
19.4
20.3
19.5
20.0
1600 Trees
35.3
29.1
43.8
44.2
32.7
29.7
27.1
9.8
11.9
9.5
20.6
20.9
19.8
20.1
Table 7: End-to-End Latency Comparison for the Bosch. (Unit: seconds)
CPU
GPU
Sklearn
ONNX
HB-Pytorch
HB-TS
HB-TVM
TreeLite
lleaves
netsDB-UDF
netsDB-Rel
HB-Pytorch
HB-TS
HB-TVM
FIL
RandomForest
10 Trees
133.6
132.2
132.5
135.2
132.8
141.7
-
0.4
4.0
131.0
131.5
131.3
131.8
500 Trees
135.5
135.4
137.7
136.5
135.0
142.4
-
3.1
5.7
131.2
131.7
131.5
131.8
1600 Trees
138.1
135.1
141.8
141.6
135.9
-
-
9.7
9.2
131.6
132.1
131.5
131.9
XGBoost
10 Trees
132.3
132.3
132.8
132.4
134.4
132.6
-
0.5
3.9
131.0
131.9
131.3
131.5
500 Trees
132.6
135.2
135.4
141.1
135.7
134.6
-
3.1
5.7
131.2
132.4
131.5
131.6
1600 Trees
133.1
135.0
140.5
139.4
137.2
136.6
-
9.6
9.0
131.6
132.6
131.6
131.6
LightGBM
10 Trees
132.7
132.4
132.2
133.9
133.6
133.0
132.9
0.5
3.9
131.0
131.9
131.3
131.8
500 Trees
134.0
134.0
135.0
135.7
134.3
134.2
135.0
3.1
5.4
131.2
132.1
131.5
131.8
1600 Trees
136.2
135.2
139.2
137.4
135.8
143.1
-
9.1
8.6
131.6
132.3
133.4
132.0
Table 8: End-to-End Latency Comparison for Epsilon. (Unit: seconds)
Sklearn
TreeLite
netsDB-UDF
RandomForest
10 Trees
130.8
124.7
2.2
500 Trees
409.0
152.1
79.4
1600 Trees
1061.7
216.3
277.9
XGBoost
10 Trees
125.2
126.2
3.99
500 Trees
209.8
191.9
193.1
1600 Trees
412.3
326.7
642.2
LightGBM
10 Trees
132.0
126.6
4.0
500 Trees
290.6
141.7
172.3
1600 Trees
645.7
216.2
564.6
Table 9: End-to-End Latency for Criteo. (Unit: seconds)
is significantly higher than the Airline workload. It explains the
increased speedup of netsDB on the Bosch dataset compared to
the Airline dataset. It also indicates that netsDB can achieve better
speedup compared to other platforms for wide and short datasets.
0
10
20
30
netsDB
HB-Pytorch
GPU-HB-Pytorch
netsDB
ONNX
GPU-HB-Pytorch
netsDB
Sklearn
GPU-HB-Pytorch
netsDB
TreeLite
GPU-HB-Pytorch
netsDB
Sklearn
GPU-FIL
netsDB
lleaves
GPU-HB-TVM
XGBoost
LightGBM
XGBoost
LightGBM
XGBoost
LightGBM
10 trees
500 trees
1600 trees
Latency (seconds)
data loading
inference
Figure 6:
Comparison of Latency breakdown on netsDB, the
second-best CPU platform, and the best GPU platform for Bosch
6.3.2
Epsilon. As aforementioned, Epsilon is a wide and dense
dataset with 2, 000 features. Because PostgreSQL does not support
more than 1, 600 columns, we store each sample as one column on
PostgreSQL in array type for all platforms except netsDB. In netsDB,
the dataset is stored as a collection of tensor blocks in pages, and
the page size can be flexibly configured. As illustrated in Tab. 8,
netsDB achieved more than 300×, 40×, 10× speedup for models
with 10, 500, and 1600 trees, respectively, compared to the fastest
of the rest of CPU platforms and all GPU platforms. There are two
reasons contributing to such huge performance gains. First, it turns
out that it is expensive to convert a PostgreSQL array type back to
a NumPy array, which becomes the bottleneck at the inference time
in all platforms except netsDB. Second, this dataset contains fewer
tuples than other datasets investigated in the paper. Therefore, the
inference complexity is significantly lower than other narrower
workloads of similar sizes (e.g., Higgs), given the same number of
trees and the same depth of each tree.
As illustrated in Fig. 7, 99% of time is spent in data loading
(including converting the data received from the PostgreSQL array
column into a NumPy array). This explained (1) the performance
benefits brought by the in-database inference in netsDB compared
to other platforms; (2)why all other platforms have similar latency
(i.e., the data loading overhead, which becomes the bottleneck, is
similar for all platforms except netsDB).
6.3.3
Criteo. Criteo is stored in LIBSVM file format [3, 20], where
each row contains a row index and a list of <column-index, non-
zero-value> pairs, which reduced 80% of storage space. Among
the platforms studied in this work, sparse storage formats such as
LIBSVM are only supported by Scikit-learn, TreeLite, and netsDB.
Therefore, results for other platforms are unavailable. (Using dense
format with other platforms failed due to out-of-memory errors.)

---

A Comparison of Decision Forest Inference Platforms from A Database Perspective
Woodstock ’18, June 03–05, 2018, Woodstock, NY
0
60
120
180
netsDB
ONNX
GPU-HB-Pytorch
netsDB
ONNX
GPU-HB-Pytorch
netsDB
HB-Pytorch
GPU-HB-Pytorch
netsDB
HB-TVM
GPU-HB-Pytorch
netsDB
Sklearn
GPU-HB-Pytorch
netsDB
Sklearn
GPU-HB-Pytorch
netsDB
ONNX
GPU-HB-TVM
netsDB
Sklearn
GPU-HB-TVM
netsDB
HB-TVM
GPU-HB-Pytorch
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
RandomForest
XGBoost
LightGBM
10 Trees
500 Trees
1600 Trees
Latency (seconds)
data loading
inference
data writing
Figure 7: Comparison of Latency breakdown on netsDB, the second best CPU platform, and the best GPU platform for Epsilon
According to our observation, using such a sparse format signifi-
cantly reduced the end-to-end latency by reducing the data transfer
overheads and the memory footprint. However, as a side effect, the
ratio of the data transfer latency to the overall latency is also signif-
icantly reduced. As a result, less performance gain can be achieved
via in-database inference compared to other workloads that used
the dense storage format. As illustrated in Tab. 9, although netsDB-
UDF achieved 30× to 60× speedup for 10 trees compared to Sklearn
and TreeLite, the performance of netsDB-UDF is significantly worse
than TreeLite for 500 and 1, 600 trees.
6.3.4
Summary of Findings. The key takeaways are:
(1) The in-database inferences represented by netsDB outperformed
all CPU/GPU platforms if the wide dataset is stored in dense format
with missing values represented as nan. That is because the data
loading process is more of a performance bottleneck for dense
datasets that are short-and-wide than tall-and-narrow datasets of
similar sizes.
(2) GPU is less helpful for the inferences over short and wide
datasets than tall and narrow datasets of similar sizes. That is be-
cause the short and wide datasets contain fewer testing samples,
reducing the workload’s computational complexity.
(3) In-database inferences significantly outperformed dedicated
ML platforms if the data loading process involves a complicated
transformation between the source format in data stores and the
target format in ML platforms.
(4) If a large dataset is extremely sparse (e.g., Criteo), a sparse
storage format will significantly reduce the storage costs. However,
the performance benefits of in-database inferences will diminish
correspondingly. That is because the dataset becomes significantly
smaller, which incurs less overhead for data transfer.
6.4
Model Conversion
It is necessary to convert Scikit-learn models to other dedicated
inference platforms such as ONNX, HummingBird, netsDB, TreeL-
ite, and lleaves. Then the converted models must be loaded into
corresponding platforms before running any inference tasks.
In the results presented in previous sections, we did not consider
the model conversion time and the model loading time because
these are one-time costs and can be amortized to all inference tasks
that use the same model. Here, we discuss the model conversion
and loading overheads.
As illustrated in Fig. 8(a), the platforms using the compiled tree
traversal algorithm, such as TreeLite and lleaves, need more than
one day to convert a 1, 600-tree model, which may hinder the adop-
tion of such platforms. The conversion overheads for other plat-
forms are around tens of seconds.
As illustrated in Fig. 8(b), most of the converted models can be
loaded in a short time that can be neglected. However, because the
converted HummingBird model cannot be persisted, we convert
the model during the loading process. That is why HummingBird’s
loading process took significantly more time than other platforms.
0
50000
100000
ONNX
TreeLite
netsDB
lleaves
TPCX-AI_Fraud
Higgs
Year
Bosch
Fraud
(a) Model conversion (Unit: seconds)
0
50000
100000
ONNX
TreeLite
netsDB
lleaves
HB-Pytorch
HB-TS
HB-TVM
TPCX-AI_Fraud
Higgs
Year
Bosch
Fraud
(b) Model loading (Unit: milli-seconds)
Figure 8: Comparison of model conversion and loading overheads
for 1600-tree LightGBM models.
7
DETAILED ANALYSIS
In this section, we summarize and discuss the impacts of the various
performance factors.
Single-Thread Comparison TFDF is the only framework that im-
plements the Quick-Scorer algorithm. However, it does not support
multiple threads for inferences; and it incurs significant overheads
when invoking the underlying C++-based decision forest library,
called Yggdrasil [31], by copying data multiple times. Therefore, we
did not consider it in Sec. 6 for fairness. Instead, we compared its
performance of XGBoost to various CPU platforms here, all using
a single thread. As illustrated in Tab. 10, the results showed that
QuickScorer achieved the best inference latency in the single-thread
setting. Note that only inference time is measured, and the maxi-
mum tree depth is 6 due to the leaf number limit in the QuickScorer
implementation, as aforementioned in Sec. 3.1.
Further Discussions about CPU Platforms. When using multi-
threading, as illustrated in Sec. 6, Lleaves, which adopts the compilation-
based algorithm and only supports LightGBM, achieved the best
performance among most CPU platforms for LightGBM for large-
scale models and large-scale inference data. Although both TreeLite
and lleaves use similar code-generation ideas, lleaves significantly

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
#trees
Yggdrasil
TFDF
Sklearn
ONNX
TreeLite
HB-TVM
Higgs
10
0.7
2.1
1.3
1.3
0.7
1.9
500
29.0
45.4
31.9
34.8
87.6
98.4
1600
96.5
140.5
98.9
105.0
340.5
298.1
Fraud
10
0.01
0.31
0.03
0.02
0.01
0.03
500
0.26
0.63
0.87
0.73
1.34
0.51
1600
0.48
1.01
1.67
1.81
3.12
1.44
Year
10
0.002
0.23
0.12
0.06
0.05
0.11
500
1.27
2.86
1.58
1.60
4.08
0.90
1600
4.14
7.08
4.93
4.87
17.80
2.61
Table
10:
XGBoost
inference
time
using
single
thread.(Unit:seconds)
outperformed TreeLite because it employed LLVM and used more
optimization techniques such as vectorization [4].
Further Discussions about GPU Platforms. On GPU, the latest
version of FIL achieved similar performance with HB-TVM (i.e.,
HummingBird using TVM as the backend). FIL is slightly better
than HB-TVM for large decision forest models. We observed that the
memory consumption of FIL is significantly lower than HB-TVM
because the tensors used for replacing tree traversal required larger
storage space. In addition, the performance results of HummingBird
using different backends vary significantly, which indicates that
the performance of the same algorithm is significantly impacted by
the implementation.
Parallelism Model When the model size increases to 500 to 1, 600
trees, we found that model parallelism significantly outperformed
data parallelism. For example, for 500 and 1, 600 trees, netsDB-UDF,
which uses data parallelism, is significantly slower than netsDB-Rel,
which uses model parallelism, as explained in Sec. 6. Model paral-
lelism is preferred for large-scale models because after partitioning
the model, each thread only requires access to a subset of trees,
which greatly improves the cache locality. This is also proved by
our profiling of cache misses.
Platforms that use data parallelism could also benefit from model
partitioning. For example, In Yggdrasil, the underlying library of
TF-DF, its optimized tree traversal algorithm, each thread will pro-
cess 𝑘trees at each iteration until all trees finish inference on the
data partition. It achieved better performance than the naive tree
traversal algorithm. Lleaves used similar ideas.
Batching On most of the platforms, the performance improved
with the increase in batch size until the processing of the batch
exceeded available (memory) resources. For example, for TPCx-AI,
netsDB-Rel achieved the best performance if we partitioned the
TPCx-AI dataset into five batches. For HummingBird platforms
using Pytorch and TorchScript as backends on the CPU, the optimal
batch size is around 1, 000, while the TVM backend usually achieved
the best performance with a batch size of around 100, 000.
Vectorization In netsDB-UDF and netsDB-Rel, we tuned vector-
ization granularity, which is the number of sample blocks that can
be processed by each operator and the number of samples in each
block. The results showed that the number of samples in a block
will more significantly impact the performance than the number
of sample blocks. It showed that in addition to vectorizing the re-
lational processing operators (i.e., atomic operators), vectorizing
underlying UDFs is even more important.
8
RELATED WORKS
Decision Forest Benchmark. There are several benchmark frame-
works for boosting-based tree algorithms. Microsoft Fast Retrain-
ing [5, 30] focused on the training time and accuracy of the two
boosting-based algorithms, LightGBM and XGBoost, on CPU and
GPU. GBM-perf [2] compared the classification of the Airline dataset
using H2O, XGBoost, LightGBM, and Catboost. Microsoft further
developed the LightGBM benchmark suite [6] to provide tooling
for comparing implementations of boosting-based algorithms for
both training and inferencing. Nvidia gbm-bench [7] made Fast
Retraining more scriptable and added support for the CatBoosting
and RandomForest algorithm to the benchmark framework. They
also ensure that hyperparameters are consistent for each training
framework [29]. While we leveraged these benchmarks a lot, we
found that they did not consider data management and end-to-
end latency. None of the existing studies explored the key design
decisions of the end-to-end inference pipeline.
Other Related Works. Raven [36] proposed two techniques to
co-optimize decision tree inference and SQL queries. The first tech-
nique is to prune the decision tree based on the selection queries.
The second technique is to inline single and simple decision trees
into UDFs leveraging the Froid framework [49]. However, Raven
executes ensemble tree inferences (e.g., random forest) in ONNX
runtime. Clipper [26] proposed various techniques to improve the
performance of model serving (including decision forest models),
such as inference result caching, dynamic batching, and model se-
lection. Browne et al. [19] proposed memory packing techniques
and a novel tree traversal method to overcome the random memory
access overheads. A recent work, TreeBeard [47], proposed an opti-
mizing compiler based on the Multi-level Intermediate Representa-
tion. It achieved significant speedup compared to baselines such as
TreeLite, HummingBird, and XGBoost. Tahoe [55] and Sharp [50]
optimized decision forest inferences for GPU, and Owaida et al. [44]
proposed a decision forest inference framework for FPGA.
9
CONCLUSION
Decision forest, including RandomForest and boosting-based algo-
rithms (e.g., XGBoost and LightGBM), is widely used in a variety
of applications such as finance, healthcare, marketing, and search
ranking, because of its robustness, scalability to large-scale datasets,
model interpretability, etc. However, most existing benchmarks and
evaluations did not consider the management of the inference data
and the data transfer to/from external data stores, which signifi-
cantly impacts the overall performance, as shown in this study.
In this work, we have conducted a comprehensive comparison
study for the end-to-end inference performance of decision for-
est models at different scales on eight platforms (15 platforms if
consider variance in hardware, backends, etc.). We implemented
our own in-database decision forest inference solution on netsDB,
using two representations: UDF-Centric and Relation-Centric.
Our study showed that in-database inferences will save signifi-
cant data loading/conversion time for runtime inferences. This is
particularly important for two broad classes of workloads, where

---

A Comparison of Decision Forest Inference Platforms from A Database Perspective
Woodstock ’18, June 03–05, 2018, Woodstock, NY
data transfer becomes a significant bottleneck. The first type of
workloads serves large-scale datasets using small to medium-scale
forest models with tens to hundreds of trees. The second type of
workloads infers small-scale or wide-and-short datasets using all-
scale models. These workloads argue for an in-database inference
solution such as netsDB. However, for workloads that exploit large-
scale models, where inference rather than data transfer becomes
the major performance bottleneck, in-database inference may not
be an ideal solution due to its sub-optimal inference performance.
Therefore, improving in-database inference performance for large-
scale models by integrating with high-performance libraries and
hardware acceleration could be a helpful direction.
We believe these observations shed some light on the integration
of database and AI/ML and may benefit the design of future systems.
ACKNOWLEDGMENTS
ASU students Jiaqing Chen and Yuze Liao have contributed to the
work at the early stages of the benchmark development.
REFERENCES
[1] [n.d.]. Criteo Display Ad Challenge. ([n. d.]). https://www.kaggle.com/c/criteo-
display-ad-challenge/
[2] [n.d.]. GBM-Perf. ([n. d.]). https://github.com/szilard/GBM-perf
[3] [n.d.]. LIBSVM Data: Classification, Regression, and Multi-label. ([n. d.]). https:
//www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/
[4] [n.d.]. lleaves github repository. ([n. d.]). https://github.com/siboehm/lleaves
[5] [n.d.]. Microsoft Fast Retraining. ([n. d.]).
https://github.com/Azure/fast_
retraining/
[6] [n.d.]. Microsoft LightGBM Benchmark Suite. ([n. d.]).
https://github.com/
microsoft/lightgbm-benchmark
[7] [n.d.]. Nvidia GBM-Bench. ([n. d.]). https://github.com/NVIDIA/gbm-bench
[8] [n.d.]. PostgreSQL Limits. ([n. d.]). https://www.postgresql.org/docs/current/
limits.html
[9] [n.d.]. RAPIDS Forest Inference Library. ([n. d.]). https://github.com/rapidsai/
cuml
[10] [n.d.]. RAPIDS Forest Inference Library: Prediction at 100 million rows per
second. ([n. d.]). https://medium.com/rapids-ai/rapids-forest-inference-library-
prediction-at-100-million-rows-per-second-19558890bc35"
[11] [n.d.]. TensorFlow Decision Forests (TF-DF). ([n. d.]).
https://github.com/
tensorflow/decision-forests
[12] [n.d.]. TPCx-AI Express Benchmark. ([n. d.]).
https://www.tpc.org/tpcx-ai/
default5.asp
[13] Sercan Ö Arik and Tomas Pfister. 2021. Tabnet: Attentive interpretable tabular
learning. In Proceedings of the AAAI Conference on Artificial Intelligence, Vol. 35.
6679–6687.
[14] Michael Armbrust, Reynold S Xin, Cheng Lian, Yin Huai, Davies Liu, Joseph K
Bradley, Xiangrui Meng, Tomer Kaftan, Michael J Franklin, Ali Ghodsi, et al. 2015.
Spark sql: Relational data processing in spark. In Proceedings of the 2015 ACM
SIGMOD International Conference on Management of Data. ACM, 1383–1394.
[15] Nima Asadi, Jimmy Lin, and Arjen P De Vries. 2013. Runtime optimizations for
tree-based machine learning models. IEEE transactions on Knowledge and Data
Engineering 26, 9 (2013), 2281–2292.
[16] Junjie Bai, Fang Lu, Ke Zhang, et al. [n.d.]. Onnx: Open neural network exchange.
([n. d.]). https://github.com/onnx
[17] Shivam Bansal. 2020. Data Science Trends on Kaggle. (2020).
https://www.
kaggle.com/code/shivamb/data-science-trends-on-kaggle/notebook
[18] Leo Breiman. 2001. Random forests. Machine learning 45 (2001), 5–32.
[19] James Browne, Disa Mhembere, Tyler M Tomita, Joshua T Vogelstein, and Randal
Burns. 2019. Forest packing: fast parallel, decision forests. In Proceedings of the
2019 SIAM International Conference on Data Mining. SIAM, 46–54.
[20] Chih-Chung Chang and Chih-Jen Lin. 2011. LIBSVM: A library for support vector
machines. ACM Transactions on Intelligent Systems and Technology 2 (2011), 27:1–
27:27. Issue 3. Software available at http://www.csie.ntu.edu.tw/~cjlin/libsvm.
[21] Olivier Chapelle and Yi Chang. 2011. Yahoo! learning to rank challenge overview.
In Proceedings of the learning to rank challenge. PMLR, 1–24.
[22] Tianqi Chen and Carlos Guestrin. 2016. Xgboost: A scalable tree boosting system.
In Proceedings of the 22nd acm sigkdd international conference on knowledge
discovery and data mining. 785–794.
[23] Tianqi Chen, Thierry Moreau, Ziheng Jiang, Lianmin Zheng, Eddie Yan, Meghan
Cowan, Haichen Shen, Leyuan Wang, Yuwei Hu, Luis Ceze, et al. 2018. TVM:
An automated end-to-end optimizing compiler for deep learning. arXiv preprint
arXiv:1802.04799 (2018).
[24] Yu Cheng, Chengjie Qin, and Florin Rusu. 2012. GLADE: big data analytics
made easy. Proceedings of the 2012 ACM SIGMOD International Conference on
Management of Data (2012).
[25] Hyunsu Cho and Mu Li. 2018. Treelite: toolbox for decision tree deployment. In
Proc. Conf. Syst. Mach. Learn.(SysML).
[26] Daniel Crankshaw, Xin Wang, Guilio Zhou, Michael J Franklin, Joseph E Gonzalez,
and Ion Stoica. 2017. Clipper: A {Low-Latency} Online Prediction Serving System.
In 14th USENIX Symposium on Networked Systems Design and Implementation
(NSDI 17). 613–627.
[27] Amol Deshpande and Samuel Madden. 2006. MauveDB: Supporting model-based
user views in database systems. Proceedings of the ACM SIGMOD International
Conference on Management of Data, 73–84.
https://doi.org/10.1145/1142473.
1142483
[28] Weishan Dong, Jian Li, Renjie Yao, Changsheng Li, Ting Yuan, and Lanjun
Wang. 2016. Characterizing driving styles with deep learning. arXiv preprint
arXiv:1607.03611 (2016).
[29] Anna Veronika Dorogush, Vasily Ershov, and Dmitriy Kruchinin. 2018. Why
every GBDT speed benchmark is wrong. arXiv preprint arXiv:1810.10380 (2018).
[30] Miguel Fierro, Mathew Salvaris, Guolin Ke, and Tao Wu. [n.d.].
Lessons
Learned From Benchmarking Fast Machine Learning Algorithms.
([n. d.]).
https://learn.microsoft.com/en-us/archive/blogs/machinelearning/lessons-
learned-benchmarking-fast-machine-learning-algorithms
[31] Mathieu Guillame-Bert, Sebastian Bruch, Richard Stotz, and Jan Pfeifer. 2022.
Yggdrasil Decision Forests: A Fast and Extensible Decision Forests Library. arXiv
preprint arXiv:2212.02934 (2022).
[32] Xinran He, Junfeng Pan, Ou Jin, Tianbing Xu, Bo Liu, Tao Xu, Yanxin Shi, Antoine
Atallah, Ralf Herbrich, Stuart Bowers, et al. 2014. Practical lessons from predicting
clicks on ads at facebook. In Proceedings of the eighth international workshop on
data mining for online advertising. 1–9.
[33] Dimitrije Jankov, Shangyu Luo, Binhang Yuan, Zhuhua Cai, Jia Zou, Chris Jer-
maine, and Zekai J Gao. 2019. Declarative Recursive Computation on an RDBMS.
Proceedings of the VLDB Endowment 12, 7 (2019).
[34] Dimitrije Jankov, Shangyu Luo, Binhang Yuan, Zhuhua Cai, Jia Zou, Chris Jer-
maine, and Zekai J Gao. 2020. Declarative recursive computation on an RDBMS:
or, why you should use a database for distributed machine learning. ACM SIG-
MOD Record 49, 1 (2020), 43–50.
[35] Rie Johnson and Tong Zhang. 2013. Learning nonlinear functions using regular-
ized greedy forest. IEEE transactions on pattern analysis and machine intelligence
36, 5 (2013), 942–954.
[36] Konstantinos Karanasos, Matteo Interlandi, Doris Xin, Fotis Psallidas, Rathijit Sen,
Kwanghyun Park, Ivan Popivanov, Supun Nakandal, Subru Krishnan, Markus
Weimer, et al. 2019. Extending relational query processing with ML inference.
arXiv preprint arXiv:1911.00231 (2019).
[37] Guolin Ke, Qi Meng, Thomas Finley, Taifeng Wang, Wei Chen, Weidong Ma,
Qiwei Ye, and Tie-Yan Liu. 2017. Lightgbm: A highly efficient gradient boosting
decision tree. Advances in neural information processing systems 30 (2017).
[38] Hoang Thanh Lam, Beat Buesser, Hong Min, Tran Ngoc Minh, Martin Wistuba,
Udayan Khurana, Gregory Bramble, Theodoros Salonidis, Dakuo Wang, and
Horst Samulowitz. 2021. Automated data science for relational data. In 2021 IEEE
37th International Conference on Data Engineering (ICDE). IEEE, 2689–2692.
[39] Damien Lefortier, Pavel Serdyukov, and Maarten De Rijke. 2014. Online ex-
ploration for detecting shifts in fresh intent. In Proceedings of the 23rd ACM
international conference on conference on information and knowledge management.
589–598.
[40] Xiaoliang Ling, Weiwei Deng, Chen Gu, Hucheng Zhou, Cui Li, and Feng Sun.
2017. Model ensemble for click prediction in bing search ads. In Proceedings of
the 26th international conference on world wide web companion. 689–698.
[41] Claudio Lucchese, Franco Maria Nardini, Salvatore Orlando, Raffaele Perego,
Nicola Tonellotto, and Rossano Venturini. 2015. Quickscorer: A fast algorithm
to rank documents with additive ensembles of regression trees. In Proceedings
of the 38th International ACM SIGIR Conference on Research and Development in
Information Retrieval. 73–82.
[42] Claudio Lucchese, Franco Maria Nardini, Salvatore Orlando, Raffaele Perego,
Nicola Tonellotto, and Rossano Venturini. 2017. Quickscorer: Efficient traversal
of large ensembles of decision trees. In Joint European Conference on Machine
Learning and Knowledge Discovery in Databases. Springer, 383–387.
[43] Supun Nakandala, Karla Saur, Gyeong-In Yu, Konstantinos Karanasos, Carlo
Curino, Markus Weimer, and Matteo Interlandi. 2020. A tensor compiler for
unified machine learning prediction serving. In 14th USENIX Symposium on
Operating Systems Design and Implementation (OSDI 20). 899–917.
[44] Muhsen Owaida, Hantian Zhang, Ce Zhang, and Gustavo Alonso. 2017. Scalable
inference of decision tree ensembles: Flexible design for CPU-FPGA platforms. In
2017 27th International Conference on Field Programmable Logic and Applications
(FPL). IEEE, 1–8.

---

Woodstock ’18, June 03–05, 2018, Woodstock, NY
Hong Guan1, Mahidhar Reddy Dwarampudi*1, Venkatesh Gunda*1, Hong Min2, Lei Yu3, Jia Zou1
[45] Adam Paszke, Sam Gross, Francisco Massa, Adam Lerer, James Bradbury, Gregory
Chanan, Trevor Killeen, Zeming Lin, Natalia Gimelshein, Luca Antiga, Alban Des-
maison, Andreas Kopf, Edward Yang, Zachary DeVito, Martin Raison, Alykhan
Tejani, Sasank Chilamkurthy, Benoit Steiner, Lu Fang, Junjie Bai, and Soumith
Chintala. 2019. PyTorch: An Imperative Style, High-Performance Deep Learning
Library. In Advances in Neural Information Processing Systems 32, H. Wallach,
H. Larochelle, A. Beygelzimer, F. d’Alché Buc, E. Fox, and R. Garnett (Eds.). Cur-
ran Associates, Inc., 8024–8035. http://papers.neurips.cc/paper/9015-pytorch-
an-imperative-style-high-performance-deep-learning-library.pdf
[46] Fabian Pedregosa, Gaël Varoquaux, Alexandre Gramfort, Vincent Michel,
Bertrand Thirion, Olivier Grisel, Mathieu Blondel, Peter Prettenhofer, Ron Weiss,
Vincent Dubourg, et al. 2011. Scikit-learn: Machine learning in Python. the
Journal of machine Learning research 12 (2011), 2825–2830.
[47] Ashwin Prasad, Sampath Rajendra, Kaushik Rajan, R Govindarajan, and Uday
Bondhugula. 2022. Treebeard: An Optimizing Compiler for Decision Tree Based
ML Inference. In 2022 55th IEEE/ACM International Symposium on Microarchitec-
ture (MICRO). IEEE, 494–511.
[48] Zhen Qin, Le Yan, Honglei Zhuang, Yi Tay, Rama Kumar Pasumarthi, Xuan-
hui Wang, Mike Bendersky, and Marc Najork. 2021. Are Neural Rankers still
Outperformed by Gradient Boosted Decision Trees? (2021).
[49] Karthik Ramachandra, Kwanghyun Park, K Venkatesh Emani, Alan Halverson,
César Galindo-Legaria, and Conor Cunningham. 2017. Froid: Optimization of
imperative programs in a relational database. Proceedings of the VLDB Endowment
11, 4 (2017), 432–444.
[50] Toby Sharp. 2008. Implementing decision trees and forests on a GPU. In European
conference on computer vision. Springer, 595–608.
[51] Juwei Shi, Jia Zou, Jiaheng Lu, Zhao Cao, Shiqiang Li, and Chen Wang. 2014.
MRTuner: a toolkit to enable holistic optimization for mapreduce jobs. Proceedings
of the VLDB Endowment 7, 13 (2014), 1319–1330.
[52] Andrey Styskin, Fedor Romanenko, Fedor Vorobyev, and Pavel Serdyukov. 2011.
Recency ranking by diversification of result set. In Proceedings of the 20th ACM
international conference on Information and knowledge management. 1949–1952.
[53] Haixun Wang, Carlo Zaniolo, and Chang Richard Luo. 2003. ATLAS: A small but
complete SQL extension for data mining and data streams. In Proceedings 2003
VLDB Conference. Elsevier, 1113–1116.
[54] Xiaoying Wang, Weiyuan Wu, Jinze Wu, Yizhou Chen, Nick Zrymiak, Changbo
Qu, Lampros Flokas, George Chow, Jiannan Wang, Tianzheng Wang, et al. 2022.
ConnectorX: accelerating data loading from databases to dataframes. Proceedings
of the VLDB Endowment 15, 11 (2022), 2994–3003.
[55] Zhen Xie, Wenqian Dong, Jiawen Liu, Hang Liu, and Dong Li. 2021. Tahoe: tree
structure-aware high performance inference engine for decision tree ensemble
on GPU. In Proceedings of the Sixteenth European Conference on Computer Systems.
426–440.
[56] Ting Ye, Hucheng Zhou, Will Y Zou, Bin Gao, and Ruofei Zhang. 2018. Rapid-
scorer: fast tree ensemble evaluation by maximizing compactness in data level
parallelization. In Proceedings of the 24th ACM SIGKDD International Conference
on Knowledge Discovery & Data Mining. 941–950.
[57] Dawei Yin, Yuening Hu, Jiliang Tang, Tim Daly, Mianwei Zhou, Hua Ouyang,
Jianhui Chen, Changsung Kang, Hongbo Deng, Chikashi Nobata, et al. 2016.
Ranking relevance in yahoo search. In Proceedings of the 22nd ACM SIGKDD
International Conference on Knowledge Discovery and Data Mining. 323–332.
[58] Binhang Yuan, Dimitrije Jankov, Jia Zou, Yuxin Tang, Daniel Bourgeois, and
Chris Jermaine. 2020. Tensor Relational Algebra for Machine Learning System
Design. arXiv preprint arXiv:2009.00524 (2020).
[59] Matei Zaharia, Mosharaf Chowdhury, Michael J Franklin, Scott Shenker, and Ion
Stoica. 2010. Spark: cluster computing with working sets. In USENIX HotCloud.
1–10.
[60] Lixi Zhou, Jiaqing Chen, Amitabh Das, Hong Min, Lei Yu, Ming Zhao, and Jia
Zou. 2022. Serving Deep Learning Models with Deduplication from Relational
Databases. Proc. VLDB Endow. 15, 10 (2022), 2230–2243. https://www.vldb.org/
pvldb/vol15/p2230-zou.pdf
[61] Jie Zhu, Ying Shan, JC Mao, Dong Yu, Holakou Rahmanian, and Yi Zhang. 2017.
Deep embedding forest: Forest-based serving with deep embedding features.
In Proceedings of the 23rd ACM SIGKDD international conference on knowledge
discovery and data mining. 1703–1711.
[62] Jia Zou, R Matthew Barnett, Tania Lorido-Botran, Shangyu Luo, Carlos Mon-
roy, Sourav Sikdar, Kia Teymourian, Binhang Yuan, and Chris Jermaine. 2018.
PlinyCompute: A platform for high-performance, distributed, data-intensive tool
development. In Proceedings of the 2018 International Conference on Management
of Data. ACM, 1189–1204.
[63] Jia Zou, Amitabh Das, Pratik Barhate, Arun Iyengar, Binhang Yuan, Dimitrije
Jankov, and Chris Jermaine. 2021. Lachesis: Automated Partitioning for UDF-
Centric Analytics. Proc. VLDB Endow. 14, 8 (2021), 1262–1275. https://doi.org/10.
14778/3457390.3457392
[64] Jia Zou, Arun Iyengar, and Chris Jermaine. 2019. Pangea: monolithic distributed
storage for data analytics. Proceedings of the VLDB Endowment 12, 6 (2019),
681–694.
[65] Jia Zou, Arun Iyengar, and Chris Jermaine. 2020. Architecture of a distributed
storage that combines file system, memory and computation in a single layer.
The VLDB Journal (2020), 1–25.
[66] Jia Zou, Ming Zhao, Juwei Shi, and Chen Wang. [n.d.]. WATSON: A Workflow-
based Data Storage Optimizer for Analytics. In Proceedings of the 36th Interna-
tional Conference on Massive Storage Systems and Technology (MSST 2020).

---

