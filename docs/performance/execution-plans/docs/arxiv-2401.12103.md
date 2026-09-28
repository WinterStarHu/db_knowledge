# LearnedWMP: Workload Memory Prediction Using Distribution of Query Templates

> 来源: https://arxiv.org/pdf/2401.12103

LearnedWMP: Workload Memory Prediction Using
Distribution of Query Templates
Shaikh Quader
York University, Canada
Andres Jaramillo
York University, Canada
Sumona Mukhopadhyay
California Polytechnic State Univ., USA
Ghadeer Abuoda
York University, Canada
Calisto Zuzarte
IBM Canada Ltd.
David Kalmuk
IBM Canada Ltd.
Marin Litoiu
York University, Canada
Manos Papagelis
York University, Canada
Abstract—In a modern DBMS, working memory is frequently the
limiting factor when processing in-memory analytic query operations
such as joins, sorting, and aggregation. Existing resource estimation
approaches for a DBMS estimate the resource consumption of
a query by computing an estimate of each individual database
operator in the query execution plan. Such an approach is slow
and error-prone as it relies upon simplifying assumptions, such as
uniformity and independence of the underlying data. Additionally,
the existing approach focuses on individual queries separately
and does not factor in other queries in the workload that may be
executed concurrently. In this research, we are interested in query
performance optimization under concurrent execution of a batch of
queries (a workload). Specifically, we focus on predicting the memory
demand for a workload rather than providing separate estimates for
each query within it. We introduce the problem of workload memory
prediction and formalize it as a distribution regression problem. We
propose Learned Workload Memory Prediction (LearnedWMP) to
improve and simplify estimating the working memory demands
of workloads. The LearnedWMP model groups queries based
on their similarity in query plans. Each query group is referred
to as a query template. For an input workload, LearnedWMP
generates a histogram representation of the query templates of
all queries in the workload and uses a distribution regressor to
predict the workload’s memory demand. Through a comprehensive
experimental evaluation, we show that LearnedWMP reduces the
memory estimation error of the state-of-the-practice method by up
to 47.6%. Compared to an alternative single-query model, during
training and inferencing, the LearnedWMP model and its variants
were 3x to 10x faster. Moreover, LearnedWMP-based models were
at least 50% smaller in most cases. Overall, the results demonstrate
the advantages of the LearnedWMP approach and its potential for
a broader impact on query performance optimization.
Index Terms—Memory Prediction, Query Performance Prediction
I. INTRODUCTION
Estimating resource usage of database queries is critical to
many database operations and decision-making tasks, such
as admission control, workload management, and capacity
planning [16]. Working memory is a region of the system
memory where DBMS performs in-memory operations, such as
sort and aggregation while executing queries. Using a limited
system memory, the DBMS can only execute a finite number of
in-memory operations (i.e., queries) simultaneously. Inaccurate
estimation of a query’s working memory requirement causes
the DBMS to either under- or over-commit the memory. This
hinders the DBMS from achieving optimal query performance,
which includes faster query execution and higher throughput, and
could potentially result in query failures as well. To achieve high
query performance, the DBMS needs accurate query working
memory estimations before admitting them for execution.
The State of the Practice & Limitations. In modern DBMS, the
query optimizer’s cost model tends to derive estimations for each
query independently, missing the opportunity to leverage insights
from batches of queries that collectively stress specific resource
utilization, such as memory [16]. For example, concurrently
processing two queries with each including a group by
operation can require higher working memory than executing
each query separately. If this collective memory requirement
surpasses available system memory, it can lead to increased
query execution times, decreasing the DBMS’s throughput and
query failure. As another option, creating a general cost model
that is not tied to specific resources and workloads poses a
challenge because of the diverse varieties in the database schema,
query structures, and data distributions. Despite dedicated efforts
over the past decade, the complexity arising from these variations
makes the task difficult (e.g., [7], [33], [45], [51], [53], [57],
[58], [60]). In current practice, human experts traditionally define
features and rules for calculating runtime metrics of queries, but
this is an expensive and non-generalizable approach [40]. To our
knowledge, there is currently no practical engine or optimizer
capable of predicting with high accuracy memory requirement
for a batch of queries. Predicting memory needs for a batch of
queries simultaneously carries the premise of delivering a more
precise estimate of the overall memory demand, helping to avoid
excessive or insufficient memory resource allocation, thereby
enhancing system stability and performance. This necessitates
the development of specialized memory prediction techniques
designed for query batches, enabling the generation of precise
memory estimates suitable for integration into the DBMS [17].
Our Approach. We propose a novel approach for estimating the
memory demand of a batch of database queries, a workload.
Our approach is a departure from the existing approach of
estimating the resource usage of each query separately [17], [21],
especially for cardinality estimation [18], [21], [24], [26], [36],
[59], which is a distinct task from working memory estimation,
but often lead to inaccuracies, contributing to imprecise memory
estimations [30], [31]. We exploit the observation that DBMS
executes queries in batches and that workload queries often have
competitive resource demands. By modeling the resource demand
arXiv:2401.12103v1  [cs.DB]  22 Jan 2024

---

of a batch of queries, we expect to achieve higher accuracy
in estimating resources. Also, we expect our approach will
reduce the development and maintenance costs of the DBMS’s
resource estimator and speed up the computation of resource
estimations. As an embodiment of our idea, we initially focused
on estimating the working memory of database workloads. We
design a Learned Workload Memory Prediction (LearnedWMP)
model in three steps. First, we use an intuition that queries
with similar plan characteristics and estimated cardinalities
have similar memory demand. Based on this intuition, we use
historical queries to learn query templates that serve as groups
for queries with similar memory demands. Second, we randomly
divide training queries into fixed-size training workloads and
represent each workload as a histogram – a distribution of query
templates. A histogram-based representation allows capturing the
underlying statistical distribution of the queries by grouping
them into bins or templates. Histograms have been used in
different domains to aggregate multiple observations and obtain
approximate data distributions [27]. To simplify the experiment
setup, the current design of LearnedWMP uses fixed-length
workloads. However, the design can easily be extended to work
with variable-length workloads. In the final step, using training
workloads and their historical collective actual memory usage,
we train a regression model that learns to estimate the working
memory usage of an unseen workload based on the distribution
of query templates. As the model learns from diverse training
workloads, its accuracy at estimating the working memory of
workloads will improve with time.
Contributions. We summarize our key contributions as follows:
• We propose LearnedWMP, a novel prediction model that can
estimate the working memory demand of a batch of SQL
queries in a workload at once. This is a departure from the
state of the practice and the state-of-the-art methods, which
estimate the memory demand of each query separately. To
the best of our knowledge, this is the first attempt to predict
memory demand at the workload level using machine learning
(ML) techniques.
• We formulate the problem of workload memory prediction as
a distribution regression problem, which learns a regressor
function from workloads represented as distributions of query
templates. We use ML to learn the regressor without relying
on hand-crafted query-level or operator-level features.
• We devise unsupervised ML methods to group queries of
similar memory needs to reduce the computational overhead
of workload memory usage estimation significantly.
• We extensively evaluate our LearnedWMP model employing
three database benchmarks. These experimental results
demonstrate the merit of our proposed technique in workload-
based query processing and resource estimation.
Summary of Experimental Results. Our extensive experiments
demonstrate that LearnedWMP substantially decreased memory
estimation errors when compared to the current state-of-the-art
practices, achieving an impressive improvement of 47.6%. Our
experiments are conducted over transactional and analytical
database benchmarks that are used to train and evaluate our
model. LearnedWMP accepts as input a workload and returns the
workload’s estimated working memory demand for the workload.
Our findings indicate that, during training and inferencing, the
LearnedWMP model and its variant models were 3x to 10x faster
compared to alternative ML models. Also, LearnedWMP-based
models were at least 50% smaller in most cases. Furthermore,
our study delved into the performance and impact assessment of
different components and parameters within the model. These
included various learning models, workload sizes, numbers of
query templates, and techniques for learning query templates
(such as query plan-based and rule-based approaches).
DBMS Integration & Broader Impact. A DBMS vendor
can pre-train a LearnedWMP model using sample training
workloads and ship the model into the DBMS product. With
the deployment of the DBMS on an operational site, the pre-
trained LearnedWMP model can immediately generate memory
estimations, which may not be highly accurate initially. DBMS
can collect training workloads from its operational environment
and use them to re-train the LearnedWMP model to improve the
model’s estimation accuracy. Major DBMS products now include
ML infrastructure, which they can use for hosting, training, and
serving the LearnedWMP model in the database [2], [4], [5].
Paper Organization. The rest of the paper is organized as follows.
Section II introduces key terminology, notations, and the problem
formally. Section III provides an overview of LearnedWMP,
including details of the training and inference stages. Section IV
presents an experimental evaluation of LearnedWMP. Section V
reviews the related work. Section VI concludes the paper.
II. PRELIMINARIES AND THE PROBLEM
In this section, we introduce notation and preliminaries to
assist in defining the workload memory prediction problem.
Next, we formally present our novel approach to representing
and solving the problem as a distribution regression problem.
Query Let q = (e, p, m) be a single SQL query where (i) e is a
query expression received from a database user, (ii) p is a query
execution plan generated by the DBMS optimizer for evaluating
e, and (iii) m is the actual highest working memory usage of
the query for p. m is available only for training queries that the
DBMS has already executed. For unseen queries, m is unknown.
Workload Let w = (Q, y) be a workload, which consists of (i)
Q, a set of queries where qi ∈Q is a tuple (ei, pi, mi), as per
def. 2.1, and (ii) y is the sum of the actual highest working
memory utilization of all queries in Q after the DBMS executes
them.
y =
|Q|
max
i=1 mi
(1)
y value of a workload (eq. 1 1) is only present for the training
workloads executed by the DBMS. In the inference phase,
LearnedWMP receives only Q, a collection of queries without y.
Workload Memory Prediction Let us assume a training corpus
of n workloads as follows:
{(w1, y1), . . . , (wn, yn)}
(2)

---

Here, each tuple, (wi, yi) corresponds to the highest historical
working memory utilization yi of all queries in the workload wi.
Now, given an unseen workload w, we wish to learn a predictor
function fˆ(·) that can accurately estimate the workload w’s
highest working memory usage y:
fˆ(w) = y
(3)
Working Memory is a memory region used to store intermediate
results, temporary data structures, and execution context
information while executing database operations such as sorting
and aggregation. A query may use the working memory up to a
limit that is controlled by a DBMS setting. Working memory
size in a DBMS varies based on system configuration, workload,
and available resources. In the rest of this paper, for brevity, we
may refer to working memory as only memory.
We formulate estimating memory usage of an unseen workload as
a distribution regression problem [46], [54], where the estimate is
computed from an input probability distribution - the distribution
of queries Q among templates T .
Query Templates Let T = {t1,...,tk} be a set of k query
templates. A query template ti ∈T represents a class of queries
with similar plan characteristics and memory requirements. Any
query q can be mapped to a query template ti ∈T .
Workload Histogram Let w be a workload consisting of a
set of Q queries. ci is the number of queries in Q that can be
mapped to query template ti ∈T . The counts of queries in Q
that map to different query templates in T are recorded in a
1-d vector of length k = |T |. We call this vector a workload
histogram H. Here, H = [c1, ..., ck] and
k
∑︂
i=1
ci = |Q|
(4)
From such an input distribution, encoded in a workload histogram,
a distribution regression function computes as estimated memory
usage for the workload. Assume we have a training corpus of n
workload histograms, one histogram per workload, as follows:
{(H1, y1), . . . , (Hn, yn)}
(5)
Here, each tuple, (Hi, yi), corresponds to a single workload;
Hi is the workload histogram, and yi is the collective historical
memory utilization of all queries in the workload. On the
workload histogram, we assume the following:
1) The distribution of queries among the query templates (i.e.,
the workload histogram bins) is uniform.
2) Query templates are independently and identically distributed.
3) An underlying function, f(·), exists that can accurately
compute any workload’s memory usage, y, from the workload
histogram, H.
f(H) = y
(6)
We, however, neither know f(·) nor have access to the set of all
possible workload examples to derive f(·). We wish to learn a
function, fˆ(·), an approximation of f(·), using the distribution
of regression. From the input workload histogram, H, of a
TABLE I: Summary of key notations
Symbol
Description
w
A workload.
Q
The set of queries in a workload.
T
The set of query templates in the DBMS.
H
H ∈Rk is a workload histogram, representing the distribution of
queries in a workload w over the k query templates T .
f(H)
ˆ
The learned function (predictor) that predicts the memory demand
of an input workload histogram H.
ci
The number of queries in a workload w that are mapped to a query
template ti ∈T .
y
The actual collective historical memory utilization of all queries Q
in a workload w.
yˆ
The predicted collective memory demand of all queries Q in an
unseen workload w as estimated by f(·)
ˆ .
workload, fˆ(·) can compute yˆ, an accurate estimate of the actual
memory usage y.
fˆ(H) = yˆ
(7)
Using training workloads labeled with their actual memory usage,
f(·)
ˆ
learns to estimate the memory usage of unseen workloads.
We expect that the larger and more diverse the training data set
of workload examples is, the more precise the predictor f(·)
ˆ
will be. Table I provides a summary of the key notations.
III. THE LEARNEDWMP MODEL
LearnedWMP comprises two stages: training and inference.
The training stage employs an ML pipeline and dataset to build
the model, while the inference stage utilizes the trained model
to predict memory usage for unseen workloads. Fig. 1 offers an
overview of the workflow, and we subsequently outline and
delve into the technical details of each step.
A. Overview of the LearnedWMP’s pipeline
Users and the Database. The top left section of Fig. 1 illustrates
user-database interaction, with the database interacting with two
LearnedWMP stages. The users and applications send SQL
queries to the database. To calculate the memory utilization of a
workload, we sum the highest memory usage for queries in that
workload. The LearnedWMP training pipeline (right of Fig. 1)
periodically retrains the model using the latest query log dump.
Training Stage. In Fig. 1 (top), TR1 through TR6 are the steps
of the training pipeline. Training begins with a set of training
queries, Qtrain, collected from a dump of the DBMS query log.
At TR1, from Qtrain, the pipeline extracts training queries, their
final execution plans, and the actual highest working memory
usage from the past execution. At TR2, from the query plans, the
pipeline generates a set of m features to represent the training
queries as a |Qtrain| × m feature matrix. At TR3, the pipeline
learns T , a set of k query templates, from the query feature
matrix. the value of k can be determined experimentally (cf.
section III-B). At TR4, the pipeline equally divides the training
queries of Qtrain into a set of n workloads, W = |Qtrain|/s.
Each workload contains s, a constant, queries. We found a
value of s experimentally (cf. subsection IV-C). At TR5, the
pipeline generates a workload histogram H for each training
workload w = (Q, y) in W. H represents the distribution of

---

Fig. 1: Overview of the LearnedWMP model. Left: Users send queries to a DBMS; the DBMS processes and sends responses
to the queries. Right-upper: the training steps of the LearnedWMP model. Right-bottom: the steps of the inference stage.
queries of Q among k query templates of T . In addition, the
collective actual highest memory utilization y of the workload
w is computed by summing up the working memory utilization
of each query qi ∈Q. Each (H, y) pair represents a supervised
training example for training a regression model. At TR6, the
model receives as input a collection of training examples of the
form (H, y). From these examples, the model learns a regression
function fˆ(H) to map an input histogram H to its working
memory demand, y. At the end of TR6, the training pipeline
produces a trained LearnedWMP model.
Inference Stage. In Fig. 1 (bottom), IN1 through IN5 are the
steps of the LearnedWMP inference pipeline, which generates
estimated memory usage of an unseen workload w, consisting
of Q queries. Step IN1 collects the query plans of the queries
Q in w; step IN2 generates the feature vectors for these plans.
Step IN3 assigns each query qi ∈Q to a template ti ∈T , from
which IN4 constructs a workload histogram H. The final step,
IN5, uses the histogram H as input to the LearnedWMP model
and predicts the memory usage yˆ of the workload, w.
B. LearnedWMP: Training Stage
The LearnedWMP model is trained in six steps (TR1 - TR6),
which we can semantically group in three phases (see Fig. 1).
The first phase uses historical queries from a DBMS’s query log
to learn a set of query templates. The second phase prepares the
training dataset for the learning algorithm. The third phase
uses the training dataset to train a regression model, which can
predict the memory usage of an input workload.
1) Phase 1: Learning Query Templates: We assign queries
to templates based on the intuition that queries with similar
query-plan characteristics and cardinality estimates have similar
execution-time memory usage. In each workload, by grouping
similar queries in the same templates or clusters, we expect to
model the memory requirements of the queries more efficiently
and speed up the computation of training and inference stages.
We are not looking for an optimal template assignment for each
query, which will require computation of operator-level features,
increase computation overhead, and outweigh the acceleration
we hope to gain from compressing queries into templates. Also,
estimating the cost of individual queries is a separate research
problem [16], [33] that we are not addressing in our current
research. Instead, we rely on a best-effort algorithmic principle
for assigning each query to a template. The template assignment
needs to be just good enough, not highly accurate. This allows
for designing simple but efficient methods for assigning queries
to templates that neither jeopardize the runtime cost nor the ML
approach. This is not an algorithmic simplification but rather an
algorithmic design choice.
To assign queries to templates we use standard k-means
clustering algorithm [38]. Algorithm 1 describes the steps
of GETTEMPLATES function that uses training queries of Qtrain
to learn a set of k query templates, T . For each query in Qtrain,
GETTEMPLATES() first extracts the query plan (line 5). A query
plan is a tree-like structure where each node corresponds to a
database operator. The plan’s execution begins at the leaf nodes
and completes at the root node. The output of the root is the
result of executing the entire query. Each node has an input and
an output. When applicable, a node includes statistics, such as
estimated pre-cardinality and post-cardinality of the operator. For
each operator type in a query plan, GETTEMPLATES() counts its
frequency and aggregate cardinalities of all its instances. The
frequency count and aggregated cardinality of each operator
type are retrieved (line 6) and used to represent the query
features. Finally, the k-means algorithm [38] uses these query
feature vectors to learn k clusters, each one representing a query
template ti ∈T (line 8). We use the elbow method [47] to
tune the value of k. Fig. 2 provides an illustrative example
query, where its associated query plan tree (below) has five
unique operators: TBSCAN, HSJOIN, INDEX SCAN, SORT,
and GROUP BY. Since each operator type provides a (count,
cardinality) pair of features (# of operators, total cardinality),
this sample query plan has 10 features - 2 features for each of
the 5 operators. GETTEMPLATES() encodes these features in a
1-d vector as follows: [4, 139532.48, 3, 50224.6, 1, 3201, 1,
134179, 1, 48873.6]. We borrowed this approach to featurizing
queries from [16], who found this set of features to be a good
choice for predicting query performance.

---

Algorithm 1 Learning query templates with k-means clustering
1: Qtrain ←{q1, q2, ..., qn} ▷Qtrain is a set of historical
training queries collected from a DBMS.
2: function GETTEMPLATES(Qtrain)
3:
Array Z ←[][]
▷feature matrix for Qtrain
4:
for qi ∈Qtrain do
5:
plani = getQueryPlan(qi)
6:
featuresi = getFeatures(plani)
7:
Z.insert(featuresi)
8:
end for
9:
T ←kmeans(Z, k) ▷learns templates using kmeans
return T
▷k learned query templates
10: end function
2) Phase 2: Constructing Histograms from Workloads: In
this phase, LearnedWMP performs two tasks: (i) partitions
training queries of Qtrain into a set workloads, W and (ii)
from each training workload, wi ∈W, constructs a histogram
that represents the distribution of its queries among the query
templates set T . Histograms have played a significant role in
estimating query plans cost [8]. LearnedWMP randomly divides
training queries from Qtrain into m training workloads, where
m = |Qtrain|/s with s being a constant number of training
queries per workload. The value for s depends on the application
domain and can be empirically found (cf. subsection IV-C).
As defined in definition 2.2, each training workload, wi, is a
tuple (Q, y), where Q is a collection of queries and y is their
collective memory usage from the past execution.
Algorithm 2 describes the steps of phase 2. It takes as input a
training workload, w, and a set of query templates, T , which
were learned in phase 1. In lines 6-7, for each query qi ∈Q,
the algorithm extracts the query execution plan and the features
from the plan. Since phase 1 already computed these features,
line 7 reuses the values from the previous computation. Using
these features, line 8 looks up the query template, tj ∈T ,
for qi. After assigning each query, qi ∈Q, to a template, the
algorithm counts the number of queries in Q in each template,
tj ∈T (line 10) and stores the counts in a histogram, a
1-d count vector, H = [c1, ..., ck=|T |]. The length of H is k,
corresponding to the number of query templates in T . Each
count cj ∈H is the number of queries in w that are associated
with the query template tj ∈T . These counts add up to s = |Q|,
the workload batch size:
k=|T |
∑︂
j=1
cj = s
(8)
The histogram H is the distribution of queries in workload
w among the query templates set T . The histogram will be
sparse with many zeros as a workload is not expected to contain
queries that belong to each query template of T . At the final
step (line 11), the algorithm returns a pair (H, y), where y
is the collective memory usage of all q ∈Q. (H, y) becomes a
labeled example for training a supervised ML model in Phase 3.
Fig. 3 shows an example of constructing a histogram H of
4 bins, k = |T | = 4. The example uses an input workload,
Fig. 2: Extracting query features from a query. An example
query (top) is executed by the query plan (left), leading
to the extraction of the query features (right). The query
features are used to learn a set of query templates T , of
size k.
w, with 9 queries, s = |Q| = 9. 3 of 4 histogram bins are
populated with nonzero values. The remaining bin has a zero
value as its corresponding query template has no queries in w.
The histogram vector is [3, 4, 0, 2]. The value of y is
the total actual memory usage of the historical memory usage of
all 9 queries in w. Let’s assume y = 125 MB. The output pair
for this example workload is ([3, 4, 0, 2], 125).
3) Phase 3: Training a Distribution Regression Deep Learning
Model: In this phase, we train a regression model for predicting
workload memory usage. The trained model takes an input
workload, represented as a histogram of query templates, and
computes the workload’s memory usage. We explored several
ML and deep learning (DL) techniques to train the model. In this
subsection, we will present the design and implementation of a
DL model for our regression model. Section III-B4 describes
the other ML algorithms we explored for the model training. DL
recently had several algorithmic breakthroughs and has been
highly successful with many learning tasks over unstructured
data. For example, DL models for image recognition and
language translation are now highly accurate [50]. Additionally,
DL can be useful in learning a non-linear mapping function
between input and output without requiring low-level feature
engineering. In our case, we have dual complexities: the input
is a complex distribution of query templates, and there is a
complex relationship between the distribution of query templates
and its collective memory demand. We wanted to explore the
effectiveness of deep learning for the problem.
Multilayer Perceptron (MLP) Model. Various deep learning
networks have been developed for unstructured data, such as
convolution neural network (CNN) [29] for images; recurrent
neural network (RNN) [48] and transformers [56] for sequential
data, and graph neural networks (GNN) for graphs [42].
Unstructured data often has variable-length input vectors with
individual elements lacking meaning in isolation [42]. However,
in our case, the input vector for each workload is structured
and has a fixed length corresponding to the number of query
templates. Each vector element represents the workload queries

---

Algorithm 2 Histogram construction from training workloads
1:
w ←(Q, y)
▷A training workload
2: T ←{t1, ..., tk}
▷A set of k query templates
3: function BINWORKLOAD(w, T )
4:
Array H[0 ... (k −1)] ←0
5:
for qi in Q do
6:
plani = getQueryPlan(qi)
7:
featuresi = getFeatures(plani)
8:
qi.template = findTemplate(featuresi)
9:
end for
10:
for tj in T do
11:
H[j] = countTemplateInstances(tj, w)
12:
end for
13:
return (H, y)
14: end function
of a specific template. Since we want to learn a regression
function from fixed-length input vectors, the multilayer perceptron
(MLP) is a suitable choice for learning a regression function
from fixed-length input vectors due to its assumption of fixed
input dimension and flexibility in architecture [42], [52]. MLP
architecture consists of input, hidden, and output layers, and
the optimal number of hidden layer neurons is determined
through trial and error since there is no analytical method
to precisely determine the ideal number crucial to prevent
overfitting and ensure generalization [19]. In our case, from
n training examples (H1, y1), (H2, y2), . . . , (Hn, yn), a MLP
model learns a function f(·) : Rk →Ro, where k is the number
of dimensions for input H = [c1, ..., ck=|T |] and Ro is the
scalar output y.
Activation Function. The activation function in each hidden
layer determines how the input is transformed. We explored two
options: linear and Rectified Linear Unit (ReLU). For simpler
datasets with fewer query templates, linear activation performed
better, while ReLU proved more effective for complex datasets
with more query templates. ReLU enables improved optimization
with Stochastic Gradient Descent and efficient computation and
is scale-invariant.
Loss Function. Depending on the problem type, an MLP uses
different loss functions. For the regression task, we use the
mean squared error loss function as follows:
Loss(yˆ, y, W) =
1
2N
N
∑︂
i=1
||yˆi −yi||2
2 + α
2N ||W||2
2
(9)
where yi is the target value; yˆi is the estimated value produced
by the MLP model; α||W||2
2 is an L2-regularization term (i.e.,
penalty) that penalizes complex models; and α > 0 is a non-
negative hyperparameter that controls the magnitude of the
penalty. The MLP begins with random weights and iteratively
updates them to minimize the loss by propagating the loss
backward from the output layer to the preceding layers and
updating the weights in each layer. The training uses stochastic
gradient descent (SGD), where the gradient ∇LossW of the
loss with respect to the weights is computed and subtracted
Fig. 3: An example of generating a histogram H from a
training workload w = (Q, y), where |Q| = 9 and k = 4.
from W. More formally,
W i+1 = W i −ϵ∇Lossi
W
(10)
where i is the iteration step, and ϵ is the learning rate with
a value larger than 0. The algorithm stops after completing a
preset number of iterations or when the loss doesn’t improve
beyond a threshold.
Optimizer. We compared L-BFGS [35] and Adam [25] optimizers
using two datasets — a small dataset and a relatively large one.
For the small dataset, L-BFGS was more effective than Adam as
it ran faster and learned better model coefficients. In contrast,
Adam worked better with the large dataset. Our observation is
consistent with scikit-learn’s MLPRegressor [1].
Hyperparameter Tuning of the MLP Model. We tuned
hyperparameters, including the number of hidden layers, the
number of nodes in each layer, the optimizer, and the dropout
rate. Given the large dataset and parameter search space, we
employed randomized search using scikit-learn library
[3]. We found a neural network architecture with eight layers
(input, six hidden, and output), and the hidden layers contained
48, 39, 27, 16, 7, and 5 nodes from left to right, while the input
layer received workload histograms or query distribution, and
the output layer provided estimated memory demand.
Model Complexity. Assume n training samples, k features, l
hidden layers, each containing h neurons — for simplicity, and
o output neurons. The time complexity of backpropagation is
O(n · k · hl · o · i), where i is the number of iterations.
4) Other machine learning methods: Besides deep learning
networks, for a comparative analysis, we explored four additional
ML techniques to train LearnedWMP models. They include a
linear and three tree-based techniques. For the linear model, we
picked Ridge, a popular method for learning regularized linear
regression models [47], which can help reduce the overfitting of
the linear regression models. From the tree-based approaches, we
used Decision Tree (DT), Random Forest (RF), and XGBoost
(XGB). DT uses a single tree for predictions, while Random
Forest employs an ensemble of trees that consider random feature
subsets, resulting in better generalization and outlier handling
capabilities [47]. Our final tree-based model was XGBoost [10], a
gradient boosting tree technique that has achieved state-of-the-art
performance for many ML tasks based on tabular data [50].
C. LearnedWMP: Inference Stage
Algorithm 3 describes the steps of PREDICTMEMORY()
function that estimates the memory demand of an unseen
workload, w. The function operates with two models: a trained
k-means clustering model, T , which represents a set of learned
query templates, and a trained predictive model for estimating

---

Algorithm 3 Predict workload memory by rained MLP
1: T ←{t1, ..., tk}
▷A set of k query templates
2: fˆ
▷a workload memory estimation function
3: w ←(Q)
▷An unseen input workload
4: function PREDICTMEMORY(w, T , fˆ)
5:
H = BinWorkload(w, T )
6:
yˆ = fˆ(H)
7:
return yˆ
8: end function
workload memory demand. PREDICTMEMORY() receives as
input an unseen workload whose memory demand needs to
be estimated. At line 5, the function generates a histogram
vector, H, a distribution of query templates. This step reuses
the BINWORKLOAD() function of algorithm 2. Next, line 6
estimates working memory demand yˆ of w using H.
IV. EXPERIMENTAL EVALUATION
We would like to reiterate that LearnedWMP is an innovative
model addressing the novel problem of predicting memory
for a workload. In this section, we experimentally evaluate
LearnedWMP through this prism. In our first set of experiments,
we demonstrate how LearnedWMP estimates memory for a
workload using different ML models and metrics, revealing a
significant reduction in estimation error compared to alternative
baselines for predicting query memory demand. Second, we
show that LearnedWMP is more efficient in terms of training,
inference time, and model size when compared to single-based
query models. Finally, we conduct an analysis to study the
impact of the major parameters of the LearnedWMP model and
the choice of the template learning method.
Baselines. In the workload memory prediction problem, we aim
to estimate the aggregate memory demand for a query batch
(i.e., workload). As there are no existing libraries or methods for
this novel problem, we develop and evaluate different variants
of LearnedWMP and compare them with the state-of-the-art
single-based models for predicting query memory demand and
assessing their performance.
• LearnedWMP-based Methods. LearnedWMP accepts as
input a workload w and returns the workload’s estimated
working memory demand, yˆ. As described in section III-B4,
besides the proposed MLP-based deep neural network (DNN)
method, we can use other ML techniques to learn the memory
estimation regression function. Thus, we explored additional
ML techniques, such as Ridge, DT, RF, and XGB, in this
experiment. We refer to the LearnedWMP-based models
trained with different ML techniques as LearnedWMP-DNN,
LearnedWMP-Ridge, LearnedWMP-DT, LearnedWMP-RF, and
LearnedWMP-XGB.
• SingleWMP-based Methods. An alternative approach to
estimate the working memory demand of a workload is to rely
on single-query-based methods for memory prediction. In this
approach, first, the highest working memory requirement for
each query in the workload is estimated separately. Then, these
individual estimates are summed up to produce the aggregate
working memory estimation for the workload. We refer to this
method as Single-query based Workload Memory Prediction
(SingleWMP). Formally, given a workload w, consisting of a
set of Q queries, the estimated memory demand yˆ of w is:
yˆ =
|Q|
∑︂
i=1
yˆqi
(11)
where yˆqi is the estimated memory demand of a single query
qi ∈Q. In this approach, we use query plan features of each
query as direct input to an ML algorithm. During the training
phase, the algorithm additionally receives the historical memory
usage of each training query. Using the pairs of query plan
features and memory usage of many individual training queries,
the algorithm learns a function to estimate the memory demand
of individual queries. Unlike the LearnedWMP approach,
the SingleWMP approach does not learn query templates
from historical queries. Similar to LearnedWMP, we use
DNN, Ridge, DT, RF, and XGB techniques to train five
variations of the SingleWMP ML models. We refer to these
variants of SingleWMP as SingleWMP-DNN, SingleWMP-
Ridge, SingleWMP-DT, SingleWMP-RF, and SingleWMP-
XGB. An additional method of the SingleWMP approach
is SingleWMP-DBMS, which obtains the estimated memory
usage for each query directly from a DBMS’s query optimizer.
SingleWMP-DBMS doesn’t use ML in the memory estimation;
instead, it relies on heuristics written by database experts.
SingleWMP-DBMS represents the current state of practice in
the commercial database management systems.
Datasets. We used three popular database benchmarks: TCP-DS
[43] Join Order Benchmark or JOB [30], and TPC-C [32].
TPC-DS and JOB are benchmarks for analytical workloads,
whereas TPC-C is for transactional workloads. We used either
its query generation toolkit or the seed query templates for each
benchmark to generate queries for our experiment. We generated
93000 queries for TPC-DS, 2300 queries for JOB, and 3958
queries for TPC-C. For each benchmark, we randomly divided
the queries into training (Qtrain) and test (Qtest) partitions,
with 80% of the queries belonging to Qtrain and the remaining
20% to Qtest. We grouped queries into workload batches from
training and test partitions. We experimented with different
batch sizes and found 10 to be a decent size to improve the
memory estimation of our experimental workloads. We discuss
our experiment with batch size parameter in section IV-C.
Evaluation metrics. To evaluate the accuracy performance of
various models, we use two accuracy metrics:
• Root Mean Squared Error (RMSE): For measuring the accuracy
performance of the LearnedWMP and SingleWMP models. We
use L2 loss or root mean squared error (RMSE), as follows:
RMSE =
√︄∑︁N
i=1 (yi −yiˆ )2
N
(12)
We seek to find an estimator that minimizes the RMSE.
• IQR and Error Distribution: While RMSE is convenient to use,
it doesn’t provide insights into the distribution of prediction

---

(a) TPC-DS
(b) JOB
(c) TPC-C
Fig. 4: Root Mean Squared Errors (smaller is better)
errors of a model. Two models can have similar RMSE scores
but different distributions of errors. For each benchmark, we
compute the signed differences between the actual and the
predicted memory estimates - the residuals of errors. We use
the residuals to generate violin plots, which help us compare
the interquartile ranges (IQR) and the error distributions of
different models. IQR is defined as follows [13].
IQR = qn(0.75) −qn(0.25)
(13)
Here, qn(0.75) is the 75th percentile or the upper quartile,
and the qn(0.25) is the 25th percentile or the lower quartile.
The range of values that fall between these two quartiles is
called the interquartile range (IQR). IQR is shown as a thick
line inside the violin in a violin plot. A white circle on the
IQR represents the median. When a model’s violin is closer
to zero and has a smaller violin, it is more accurate.
In addition to computing accuracy, for each ML-based Learned-
WMP and SingleWMP model, we measured the model size in
kilobyte (kB), the training time in millisecond (ms), and the
inference time in microsecond (µ).
Experiments Design. In SectionIV-A, we evaluate the per-
formance of LearnedWMP-based models compared to that of
SingleWMP-based models. The computational overhead of the
LearnedWMP model is discussed in Section IV-B. This includes
the model size and runtime cost of training and inference of
LearnedWMP-based models and how it compares to SingleWMP-
based models’. Section IV-C performs a sensitive study for the
parameters and design choices of the LearnedWMP model. We
conducted the experiments using a commercial DBMS instance
running on a Linux system with 8 CPU cores, 32 GB of memory,
and 500 GB of disk space.
A. LearnedWMP Accuracy Performance
We report on LearnedWMP’s accuracy performance in terms
of RMSE and the distribution of error residuals presented as
violin plots for completeness.
RMSE. Fig. 4 reports the RMSEs of SingleWMP-based and
LearnedWMP-based models. SingleWMP-DBMS represents the
state of practice in commercial DBMSs. LearnedWMP models
and ML-based SingleWMP models significantly outperformed
the SingleWMP-DBMS model. For the TPC-DS, SingleWMP-
DBMS’s RMSE was 1868. In comparison, LearnedWMP-DNN
and LearnedWMP-Ridge, the two best ML models, had an
RMSE of 169, which was a 90.95%
On RMSE, ML-based methods — LearnedWMP-based models
and SingleWMP-based ML models — were significantly more
accurate than SingleWMP-DBMS method. Using heuristics,
SingleWMP-DBMS couldn’t accurately capture the complex
interactions between database operators within a query plan
and produced large estimation errors. In contrast, using ML,
LearnedWMP-based, and SingleWMP-based ML models learned
to estimate the memory requirements of complex database
workloads more accurately.
IQR and Error Distribution. Fig. 5 compares the violin plots
of different models. The violins of the SingleWMP-DBMS are
wider and far from zero. DBMS’s estimations are skewed towards
either underestimation or overestimation and span a larger region.
In contrast, ML-based estimates are balanced between over and
under-estimations and are not skewed. The violins of ML-based
models span a smaller range than SingleWMP-DBMS’s. For
TCP-DS, LearnedWMP-DNN’s violin is centered at zero and
small. For the same dataset, SingleWMP-DBMS’s violin is
skewed toward underestimation and larger when compared
to the IQR of LearnedWMP-DNN. We see a similar pattern
when comparing the violins of SingleWMP-DBMS models
with the violins of other ML models. Using human-crafted
rules, SingleWMP-DBMS’s estimation errors are not distributed
between overestimations and underestimations. These static
rules skew the estimations toward one direction. In contrast,
ML-based models learn from real-world workloads — which
include examples of both overestimation and underestimation —
and learn to compute memory predictions that are not skewed in
one direction. For instance, the memory estimation errors of the
DNN and XGboost methods for both SingleWMP-based and
LearnedWMP-based models are smaller and balanced.
B. Computational Overhead
We evaluate the LearnedWMP-based and SingleWMP-based
models overhead in terms of training time, inference time, and
model size. All these metrics are important when considering
embedding an ML model into the DBMS.
Training and Inference Time. Fig. 6 reports the training time
of all models1. For each benchmark dataset, LearnedWMP-
1Note that for this set of experiments, we do not consider LearnedWMP-DBMS
as it is not an ML model, and it doesn’t have a training and an inference cost.

---

(a) TPC-DS
(b) JOB
(c) TPC-C
Fig. 5: Estimation Error Residuals Distributions
based and SingleWMP-based methods use the same set of
training queries as input. The singleWMP-based method uses
individual training queries directly as input to the model.
LearnedWMP batches the training queries into workloads,
represents workloads as histograms, and uses the histograms as
input to the models. Compared to SingleWMP-based models,
the training of LearnedWMP-based models was significantly
faster. For instance, with the TPC-DS dataset, SingleWMP-XGB
was trained in 912.7 ms, whereas LearnedWMP-XGB was
trained in 404 ms — which is more than 2x faster. For all three
benchmark datasets, we observe a similar trend: the training of a
LearnedWMP-based model was faster than that of the equivalent
SingleWMP-based model. The Ridge is the only algorithm
that didn’t demonstrate a significant difference in training time
between the LearnedWMP and SingleWMP approaches. This is
expected as Ridge is a linear algorithm that doesn’t involve a
sophisticated learning method.
Fig. 7 compares the inference time of SingleWMP-based
and LearnedWMP-based models. The LearnedWMP-based
models achieved between 3x and 10x acceleration compared
to their equivalent SingleWMP-based models. As an example,
for inference of TPC-DS workloads, LearnedWMP-DNN took
87.3 µs as compared to 870.5 µs needed by SingleWMP-DNN.
Similarly, with JOB, LearnedWMP-XGB needed 313.3 µs for
inference, while SingleWMP-XGB took 1115.6 µs. Accelerated
training and inference performance of the LearnedWMP models
can be attributed to our approach of formulating the training
and inference task at the level of workloads, not at the level of
individual queries. LearnedWMP-based models process batches of
queries at the same time and, therefore, speed up the computation
during both training and inference. In contrast, SingleWMP-based
models require a longer time for training and inference as they
work one query at a time.
Model Size. The model size largely depends on the learning
algorithm and the feature space complexity of the training set. Fig.
8 shows the size of LearnedWMP-based and SingleWMP-based
models. LearnedWMP-based models were significantly smaller
when compared with equivalent SingleWMP-based models. For
example, when compared with SingleWMP-DNN, LearnedWMP-
DNN is 59% TPC-DS, 72% JOB, and 97% TPC-C smaller than
SingleWMP-DNN. We see a similar pattern with XGBoost, RF,
and DT when comparing their LearnedWMP-based models with
equivalent SingleWMP-based models. Batching training queries
as workloads compress the information a LearnedWMP model
needs to process during training. This compression helps the
LearnedWMP approach produce smaller models as compared
with models of the SingleWMP approach. Ridge is an exception
to this observation. The size of a LearnedWMP-Ridge model is
larger than its equivalent SingleWMP-Ridge model. This was
expected as Ridge learns a set of coefficients, one for each input
feature in the training dataset. In our training datasets, each
LearnedWMP training example has more input features, one per
query template, than the number of features in a SingleWMP
training example. As a result, LearnedWMP-Ridge learns more
coefficients during training and produces larger models.
C. Sensitivity Analysis
In the next set of experiments, we investigate the impact of
various parameters of LearnedWMP, such as the batch size
parameter s, the number of query templates K, the choice of
the learning query templates techniques, and their effect on the
memory prediction accuracy
Learning Query Templates. In the first phase of LearnedWMP,
queries are assigned to templates based on their similarity in
query plan characteristics and estimates, with the expectation
that queries in the same template exhibit similar memory usage
(See SectionIII-B1). We evaluated our method against four other
approaches for learning query templates:
1) Query plan based: Our proposed LearnedWMP model
assigns queries to query templates by extracting features from
the query plan and then employing a k-means clustering
algorithm. Details can be found in section III-B1.
2) Rule based: We create a set of rules, one per template, to
classify a query statement into one of the pre-defined query
templates. Subject matter experts, such as DBAs, may need
to be involved in defining these rules [61].
3) Bag of Words based: We extract unique keywords from
the entire training query corpus to build a vocabulary. Each
query expression generates a feature vector representing the
count of each vocabulary word in the query. The k-means
clustering algorithm then assigns these feature vectors to
different query templates.
4) Text mining based: This is a variation of the bag of words
approach, which indiscriminately extracts unique keywords
from the training corpus. In contrast, in this approach, the
vocabulary includes only those keywords that are either

---

(a) TPC-DS
(b) JOB
(c) TPC-C
Fig. 6: ML model training time
(a) TPC-DS
(b) JOB
(c) TPC-C
Fig. 7: ML model inference time
(a) TPC-DS
(b) JOB
(c) TPC-C
Fig. 8: ML model size
database object names (e.g., a Table name) or SQL clauses
(e.g., group by). Other keywords are ignored. After vocabulary
building, we apply similar steps to the bag of words approach
to generate a feature vector for each query and then apply
k-means clustering to assign them to templates.
5) Word embeddings based: Word Embeddings address two
limitations of bag-of-words methods: dealing with numerous
keywords and capturing keyword proximity [11]. Using
word embeddings, With word embeddings, we construct a
vocabulary from the training query corpus and generate a
feature vector for each query expression. Applying k-means
clustering assigns these feature vectors to templates.
To evaluate the performance of the five alternative methods for
learning templates, we used the LearnedWMP-XGB model with
JOB workloads. We trained five LearnedWMP-XGB models,
each using a different method for learning templates. Fig. 9
compares the accuracy of these five models. The model— labeled
query plan (ours) in the figure—that uses our original method
for learning query templates outperformed the four alternatives.
Compared with the alternatives, the LearnedWMP method uses
Fig. 9: LearnedWMP’s accuracy performance achieved by
different methods for learning query templates.
features from the query plan. The query plans include estimates
that are strong indicators of the resource usage of the queries.
A prior research [16] made a similar observation. In contrast,
the alternative methods extract features directly from the query
expression, which does not provide insights into the query’s
memory usage. A major limitation of the rules-based method is
that coming up with effective rules requires the knowledge of
human experts, which can be both a difficult and a slow process.
Effect of the number of query templates. As described in
section III-B1, LearnedWMP assigns queries into templates, such
as queries with similar query plan characteristics in the same

---

(a) TPC-DS
(b) JOB
(c) TPC-C
Fig. 10: MAPE at different template sizes with LearnedWMP XGBoost Model for the three evaluation datasets (a) TPC-DS,
(b) JOB, and (c) TPC-C
groups. This experiment aimed to assess the effects of the number
of templates on the LearnedWMP model’s accuracy. In the
experiment, we tested the performance of the LearnedWMP-XGB
model on three datasets using 10 to 100 templates, comparing
the model’s performance across different template sizes.
We used the Mean Absolute Percent Error (MAPE) [12] to
evaluate and compare these models, each using a different
number of templates. The scale of the error can vary significantly
when changing the number of templates. MAPE is unaffected by
changes in the error scale when comparing models trained with
different numbers of templates because it calculates a relative
error. We used equation (14) to compute the MAPE of the
LearnedWMP-XGB model.
MAPE = 1
N
N
∑︂
i=1
|yi −yiˆ |
yi
× 100
(14)
We computed the relative estimation error between the actual
and predicted memory usage by dividing the absolute difference
between them by the actual value and then averaged the relative
estimation errors across all test workloads. The resulting average
was multiplied by 100 to obtain the MAPE, ranging from 0 to
100 percent. Fig. 11 shows the performance of LearnedWMP-
XGB as a factor of the number of templates. Fig 10 shows the
performance of the LearnedWMP-XGB model for each template
size for the three datasets. In the case of the TPC-DS dataset,
performance improved gradually with an increasing number of
templates. The best performance was observed at 100 templates.
However, for the JOB and TPC-C datasets, performance varied
as the number of templates increased, with optimal performance
achieved within the range of 20 to 40 templates. We argue that
this correlation between the number of queries and the optimal
number of templates is due to the characteristics of each dataset.
The larger TPC-DS dataset benefits from a greater diversity
of queries (93,000) queries generated from (99) templates,
which allows clustering with a higher number of templates.
However, the smaller JOB and TPC-C datasets do not possess
the same level of query variation, which explains why the best
performance was achieved with a moderate number of templates.
Effect of the batch size parameter The experiments we
discussed so far used a constant workload batch size of 10. The
batch size, s, is a tunable hyperparameter of the LearnedWMP
model. We tried different workload batch sizes and compared
their impact on the LearnedWMP model’s accuracy. We used
the TPC-DS dataset and the LearnedWMP-XGB model for
this experiment. We used 12 values for the batch size: [1, 2,
3, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]. For each value, we
created TPC-DS training and test workloads, which we used
for training and evaluating a LearnedWMP-XGB model. We
computed and used MAPE to compare the relative accuracy
performance of these models. Fig. 11 shows the performance of
LearnedWMP-XGB as a factor of the batch size. We can see
that with increasing batch size, the accuracy of the memory
estimation improves. The improvement is more rapid initially,
gradually slowing down, which is expected of any learning
algorithm as it reaches the perfect prediction. For example, at
batch size 2, the estimation error was 10.4%. At batch size
10, the error was reduced to 3.8%. We have seen a similar
improvement in prediction accuracy with the remaining two
experimental datasets. This observation substantiates our position
that batch estimation of workload memory is more accurate
than estimating one query’s memory at a time. Additionally, we
compared the MAPE of the LearnedWMP model with batch
size 1 with the SingleWMP model’s MAPE. At batch size 1,
LearnedWMP’s MAPE is 10.2, whereas SingleWMP’s MAPE is
3.6. The SingleWMP model outperformed the LearnedWMP
batch 1 model, which was expected since SingleWMP was
directly trained with query plan features, providing strong signals
for individual query memory usage. In contrast, the LearnedWMP
model mapped queries into templates and generated predictions
based on collective memory usage, lacking the ability to learn
from individual query features. While LearnedWMP had weaker
signals for single query predictions, it demonstrated higher
accuracy than SingleWMP when generating predictions for
query batches. However, as we have seen in IV-A, LearnedWMP
generates more accurate predictions than SingleWMP when
generating predictions for batches of queries.
V. RELATED WORK
Our research relates to ML methods for (i) database query
optimization [9], [22], [23], (ii) database query resource estimation
[33], (iii) query-based workload analysis [37], and (iv) distribution
regression problems. Each of these areas has extensive research
literature, and we discuss some of the most significant ones.
ML for Database Query Optimization In the broader query
optimization topic, besides query resource estimation, many
recent works explored ML techniques to learn different tasks
related to query optimization. Some of the key tasks include
cardinality estimation [17], [24], [36], query latency prediction [7],
[61], index selection [14], [49]. A recent cardinality estimation
benchmark [17] evaluated eight ML-based cardinality estimation
methods—MSCN, LW-XGB, LW-NN, UAE-Q, NeuroCard,
BayesCard, DeepDB, and FLAT. Zhou et al. [61] proposed a
graph-based deep learning method to predict the execution time
of concurrent queries. Akdere et al. [7] used support vector

---

Fig. 11: TPC-DS MAPE at different batch sizes with
LearnedWMP XGBoost Model.
machine (SVM) and linear regression to predict the execution
time of analytical queries. Marcus and Papaemmanouil [40]
proposed a plan-structured neural network architecture, which
uses custom neural units designed at the level of query plan
operators to predict query execution time. Ahmad et al. [6]
proposed an ML-based method for predicting the execution time
of batch query workloads. They relied upon DBAs to define a
set of query types used to create simulated workloads and model
interactions among queries. Contender [15] is a framework for
predicting the execution time of concurrent analytical queries
that compete for I/O. Ding et al. [14] applied classification
techniques to compare the relative cost of a pair of query plans
and use that insight in index recommendations.
ML for Database Query Resource Estimation Closer to our
problem are methods that estimate computing resources—such
as memory, CPU, and I/O—for executing database queries.
Tang et al. used ML to classify queries into low, medium, and
high resource consumption. They employed separate models
for memory and CPU, utilizing a bag-of-words approach to
extract query keywords as input features. XGBoost proved
the most accurate among the three compared algorithms [55].
Ganapathi et al. [16] tried five ML techniques to predict run-
time resource consumption metrics of individual queries. They
achieved the best results with the kernel canonical correlation
analysis (KCCA) algorithm. Li et al. [33] applied boosted
regression trees to predict individual queries’ CPU and I/O
costs. They modeled the resource requirements of each database
operator separately by computing a different set of features for
each operator type. All the above three approaches [16], [33],
[55] generate resource predictions at the level of individual
queries. In contrast, our proposed method estimates memory at
the level of workload query batches, which we found more
accurate and computationally efficient.
ML for Query-based Workload Analysis There is a line of
research that considers query-based workload analysis. Higginson
et al. [20] have applied time series analysis, using ARIMA and
Seasonal ARIMA (SARIMA), on database workload monitoring
data to identify patterns such as seasonality (reoccurring patterns),
trends, and shocks. They used these time series patterns in
database capacity planning. Kipf et al. [26] use Multi-Set
Convolutional Network (MSCN) for workload cardinality
estimation, representing query features as sets of tables, joins,
and predicates. Similar methods have been used for constructing
query-based cardinality estimators (e.g., . [44]]. However, these
approaches involve significant sampling overhead or rely on static
data featurization, unsuitable for modern databases. Additionally,
they lack explanations for the relationships between data, queries,
and actual cardinalities. DBSeer [41] employs ML to predict
resource metrics in OLTP workloads, using DBSCAN for
transaction type learning and linear regression, decision trees, and
neural networks for CPU, I/O, and memory demand prediction. In
contrast, our approach does not cluster transactions or use query
expressions for clustering. Instead, we learn query templates
based on simple features in the query plan, showing a stronger
correlation with runtime memory usage. In our experiments, we
compared DBSCAN-based templates with k-means and found
the latter more accurate for resource prediction.
ML for Distribution Regression Problems Distribution
regression has emerged as a popular ML approach for mapping
complex input probability distributions to real-valued responses,
particularly in supervised tasks that require handling input and
model uncertainty [28], emerging as a promising alternative to
traditional techniques like random forests and neural networks
[34]. To the best of our knowledge, we are the first to apply
distribution regression to model resource demand forecasting of
database workloads. Outside the database domain, some of the
illustrative use cases of distribution regression include predicting
health indicators from a patient’s list of blood tests [39], solar
energy forecasting, and traffic prediction [34]. Many recent
papers have offered approaches and optimization techniques for
solving distribution regression tasks (e.g., [28], [34], [39]).
VI. CONCLUSIONS
We proposed a novel approach to predicting memory usage of
database queries in batches. Our approach is a paradigm shift
from the state of the practice and the state-of-the-art methods
designed to estimate resource demand for single queries. As an
embodiment of our approach, we presented LearnedWMP, a
method for estimating the working memory demand of a batch of
queries, a workload. The LearnedWMP method operates in three
phases. First, it learns query templates from historical queries.
Second, it constructs histograms from the training workloads.
Third, using training workloads, it trains a regression model
to predict the memory requirements of unseen workloads. We
model the prediction task as a distribution regression problem.
We performed a comprehensive experimental evaluation of the
LearnedWMP model against the state-of-the-practice method
of a contemporary DBMS, multiple sensible baselines, and
state-of-the-art methods. Our analysis demonstrates that our
proposed method significantly improves the memory estimation
of the current state of the practice. Additionally, LearnedWMP
matches the performance of advanced ML-based methods trained
with a single-query approach. It generates smaller models,
enabling faster training and quicker memory usage predictions.
We conducted parameter sensitivity analysis and explored various
strategies for learning query templates from historical DBMS
queries. Our novel LearnedWMP model presents an alternative
perspective on a crucial DBMS problem, easily integratable with
major DBMS products.

---

REFERENCES
[1] Sklearn.neural network.MLPRegressor, 2022. Accessed on 2023-11-21.
[2] SQL machine learning documentation, 2022. Accessed on 2023-11-21.
[3] Comparing randomized search and grid search for hyperparameter estimation,
2023. Accessed on 2023-11-21.
[4] In-database machine learning, 2023. Accessed on 2023-11-21.
[5] Machine Learning in Oracle Database, 2023. Accessed on 2023-11-21.
[6] M. Ahmad, S. Duan, A. Aboulnaga, and S. Babu. Predicting completion
times of batch query workloads using interaction-aware models and
simulation. In Proceedings of the 14th International Conference on
Extending Database Technology, pages 449–460, 2011.
[7] M. Akdere, U. C¸ etintemel, M. Riondato, E. Upfal, and S. B. Zdonik.
Learning-based query performance modeling and prediction. In 2012 IEEE
28th International Conference on Data Engineering, pages 390–401. IEEE,
2012.
[8] N. Bruno and S. Chaudhuri. Exploiting statistics on query expressions for
optimization. In Proceedings of the 2002 ACM SIGMOD international
conference on Management of data, pages 263–274, 2002.
[9] S. Chaudhuri. An overview of query optimization in relational systems. In
Proceedings of the seventeenth ACM SIGACT-SIGMOD-SIGART symposium
on Principles of database systems, pages 34–43, 1998.
[10] T. Chen and C. Guestrin. Xgboost: A scalable tree boosting system. In
Proceedings of the 22nd acm sigkdd international conference on knowledge
discovery and data mining, pages 785–794, 2016.
[11] F. Chollet. Deep learning with Python. Simon and Schuster, 2021.
[12] A. De Myttenaere, B. Golden, B. Le Grand, and F. Rossi. Mean absolute
percentage error for regression models. Neurocomputing, 192:38–48, 2016.
[13] F. M. Dekking, C. Kraaikamp, H. P. Lopuha¨a, and L. E. Meester. A
Modern Introduction to Probability and Statistics: Understanding why and
how, volume 488. Springer, 2005.
[14] B. Ding, S. Das, R. Marcus, W. Wu, S. Chaudhuri, and V. R. Narasayya. Ai
meets ai: Leveraging query executions to improve index recommendations.
In Proceedings of the 2019 International Conference on Management of
Data, pages 1241–1258, 2019.
[15] J. Duggan, O. Papaemmanouil, U. Cetintemel, and E. Upfal. Contender: A
resource modeling approach for concurrent query performance prediction.
In EDBT, pages 109–120, 2014.
[16] A. Ganapathi, H. Kuno, U. Dayal, J. L. Wiener, A. Fox, M. Jordan, and
D. Patterson. Predicting multiple metrics for queries: Better decisions
enabled by machine learning. In 2009 IEEE 25th International Conference
on Data Engineering, pages 592–603. IEEE, 2009.
[17] Y. Han, Z. Wu, P. Wu, R. Zhu, J. Yang, L. W. Tan, K. Zeng, G. Cong,
Y. Qin, A. Pfadler, et al. Cardinality estimation in dbms: A comprehensive
benchmark evaluation. arXiv preprint arXiv:2109.05877, 2021.
[18] S. Hasan, S. Thirumuruganathan, J. Augustine, N. Koudas, and G. Das.
Deep learning models for selectivity estimation of multi-attribute queries.
In Proceedings of the 2020 ACM SIGMOD International Conference on
Management of Data, pages 1035–1050, 2020.
[19] S. Haykin. Neural networks and learning machines, 3/E. Pearson Education
India, 2009.
[20] A. S. Higginson, M. Dediu, O. Arsene, N. W. Paton, and S. M. Embury.
Database workload capacity planning using time series analysis and
machine learning. In Proceedings of the 2020 ACM SIGMOD International
Conference on Management of Data, pages 769–783, 2020.
[21] B. Hilprecht, A. Schmidt, M. Kulessa, A. Molina, K. Kersting, and
C. Binnig. Deepdb: Learn from data, not from queries! arXiv preprint
arXiv:1909.00607, 2019.
[22] Y. E. Ioannidis. Query optimization. ACM Computing Surveys (CSUR),
28(1):121–123, 1996.
[23] M. Jarke and J. Koch. Query optimization in database systems. ACM
Computing surveys (CsUR), 16(2):111–152, 1984.
[24] K. Kim, J. Jung, I. Seo, W.-S. Han, K. Choi, and J. Chong. Learned
cardinality estimation: An in-depth study. In Proceedings of the 2022
International Conference on Management of Data, pages 1214–1227, 2022.
[25] D. P. Kingma and J. Ba. Adam: A method for stochastic optimization.
arXiv preprint arXiv:1412.6980, 2014.
[26] A. Kipf, T. Kipf, B. Radke, V. Leis, P. Boncz, and A. Kemper. Learned
cardinalities: Estimating correlated joins with deep learning. arXiv preprint
arXiv:1809.00677, 2018.
[27] G. Koloniari, Y. Petrakis, E. Pitoura, and T. Tsotsos. Query workload-aware
overlay construction using histograms. In Proceedings of the 14th ACM
International Conference on Information and Knowledge Management,
CIKM ’05, page 640–647, New York, NY, USA, 2005. Association for
Computing Machinery.
[28] H. C. L. Law, D. J. Sutherland, D. Sejdinovic, and S. Flaxman. Bayesian
approaches to distribution regression. In International Conference on
Artificial Intelligence and Statistics, pages 1167–1176. PMLR, 2018.
[29] Y. LeCun, B. Boser, J. S. Denker, D. Henderson, R. E. Howard, W. Hubbard,
and L. D. Jackel. Backpropagation applied to handwritten zip code
recognition. Neural computation, 1(4):541–551, 1989.
[30] V. Leis, A. Gubichev, A. Mirchev, P. Boncz, A. Kemper, and T. Neumann.
How good are query optimizers, really? Proceedings of the VLDB
Endowment, 9(3):204–215, 2015.
[31] V. Leis, B. Radke, A. Gubichev, A. Kemper, and T. Neumann. Cardinality
estimation done right: Index-based join sampling. In Cidr, 2017.
[32] S. T. Leutenegger and D. Dias. A modeling study of the tpc-c benchmark.
ACM Sigmod Record, 22(2):22–31, 1993.
[33] J. Li, A. C. K¨onig, V. Narasayya, and S. Chaudhuri. Robust estimation of
resource consumption for sql queries using statistical techniques. arXiv
preprint arXiv:1208.0278, 2012.
[34] R. Li, H. D. Bondell, and B. J. Reich. Deep distribution regression. arXiv
preprint arXiv:1903.06023, 2019.
[35] D. C. Liu and J. Nocedal. On the limited memory bfgs method for large
scale optimization. Mathematical programming, 45(1):503–528, 1989.
[36] H. Liu, M. Xu, Z. Yu, V. Corvinelli, and C. Zuzarte. Cardinality estimation
using neural networks. In Proceedings of the 25th Annual International
Conference on Computer Science and Software Engineering, pages 53–59,
2015.
[37] L. Ma, D. Van Aken, A. Hefny, G. Mezerhane, A. Pavlo, and G. J.
Gordon. Query-based workload forecasting for self-driving database
management systems. In Proceedings of the 2018 International Conference
on Management of Data, pages 631–645, 2018.
[38] J. MacQueen. Classification and analysis of multivariate observations. In
5th Berkeley Symp. Math. Statist. Probability, pages 281–297, 1967.
[39] Y. Mao, L. Shi, and Z.-C. Guo. Coefficient-based regularized distribution
regression. arXiv preprint arXiv:2208.12427, 2022.
[40] R. Marcus and O. Papaemmanouil. Plan-structured deep neural network
models for query performance prediction. arXiv preprint arXiv:1902.00132,
2019.
[41] B. Mozafari, C. Curino, A. Jindal, and S. Madden. Performance and
resource modeling in highly-concurrent oltp workloads. In Proceedings of
the 2013 acm sigmod international conference on management of data,
pages 301–312, 2013.
[42] K. P. Murphy. Probabilistic machine learning: an introduction. MIT press,
2022.
[43] R. O. Nambiar and M. Poess. The making of tpc-ds. In VLDB, volume 6,
pages 1049–1058, 2006.
[44] P. Negi, Z. Wu, A. Kipf, N. Tatbul, R. Marcus, S. Madden, T. Kraska, and
M. Alizadeh. Robust query driven cardinality estimation under changing
workloads. Proceedings of the VLDB Endowment, 16(6):1520–1533, 2023.
[45] D. Paul, J. Cao, F. Li, and V. Srikumar. Database workload characterization
with query plan encoders. arXiv preprint arXiv:2105.12287, 2021.
[46] B. Poczos, A. Singh, A. Rinaldo, and L. Wasserman. Distribution-free
distribution regression. In Artificial Intelligence and Statistics, pages
507–515, 2013.
[47] S. Raschka. Python Machine Learning Ed. 3. Packt Publishing, 2019.
[48] H. Salehinejad, S. Sankar, J. Barfett, E. Colak, and S. Valaee. Recent
advances in recurrent neural networks. arXiv preprint arXiv:1801.01078,
2017.
[49] A. Sharma, F. M. Schuhknecht, and J. Dittrich. The case for automatic
database administration using deep reinforcement learning. arXiv preprint
arXiv:1801.05643, 2018.
[50] R. Shwartz-Ziv and A. Armon. Tabular data: Deep learning is not all you
need. arXiv preprint arXiv:2106.03253, 2021.
[51] T. Siddiqui, A. Jindal, S. Qiao, H. Patel, and W. Le. Cost models for
big data query processing: Learning, retrofitting, and our findings. In
Proceedings of the 2020 ACM SIGMOD International Conference on
Management of Data, pages 99–113, 2020.
[52] A. Subasi. Eeg signal classification using wavelet feature extraction
and a mixture of expert model.
Expert Systems with Applications,
32(4):1084–1093, 2007.
[53] J. Sun and G. Li. An end-to-end learning-based cost estimator. arXiv
preprint arXiv:1906.02560, 2019.
[54] Z. Szab´o, B. K. Sriperumbudur, B. P´oczos, and A. Gretton. Learning
theory for distribution regression. J. Mach. Learn. Res., 17(1):5272–5311,
Jan. 2016.

---

[55] C. Tang, B. Wang, Z. Luo, H. Wu, S. Dasan, M. Fu, Y. Li, M. Ghosh,
R. Kabra, N. K. Navadiya, et al. Forecasting sql query cost at twitter. In
2021 IEEE International Conference on Cloud Engineering (IC2E), pages
154–160. IEEE, 2021.
[56] A. Vaswani, N. Shazeer, N. Parmar, J. Uszkoreit, L. Jones, A. N. Gomez,
Ł. Kaiser, and I. Polosukhin. Attention is all you need. Advances in
neural information processing systems, 30, 2017.
[57] W. Wu, Y. Chi, H. Hac´ıg¨um¨us¸, and J. F. Naughton. Towards predicting
query execution time for concurrent and dynamic database workloads.
Proceedings of the VLDB Endowment, 6(10):925–936, 2013.
[58] W. Wu, X. Wu, H. Hacıg¨um¨us¸, and J. F. Naughton. Uncertainty aware
query execution time prediction. arXiv preprint arXiv:1408.6589, 2014.
[59] Z. Yang, A. Kamsetty, S. Luan, E. Liang, Y. Duan, X. Chen, and
I. Stoica. Neurocard: one cardinality estimator for all tables. arXiv preprint
arXiv:2006.08109, 2020.
[60] Y. Zhao, G. Cong, J. Shi, and C. Miao. Queryformer: a tree transformer
model for query plan representation. Proceedings of the VLDB Endowment,
15(8):1658–1670, 2022.
[61] X. Zhou, J. Sun, G. Li, and J. Feng. Query performance prediction
for concurrent queries using graph embedding. Proc. VLDB Endow.,
13(9):1416–1428, 2020.

---

