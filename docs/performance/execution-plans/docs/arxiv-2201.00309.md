# Optimizing Machine Learning Inference Queries with Correlative Proxy Models

> 来源: https://arxiv.org/pdf/2201.00309

Optimizing Machine Learning Inference Queries
with Correlative Proxy Models
Zhihui Yang1
Fudan University, Shanghai, China
zhyang14@fudan.edu.cn
Zuozhi Wang
UC Irvine, CA, USA
zuozhiw@ics.uci.edu
Yicong Huang
UC Irvine, CA, USA
yicongh1@ics.uci.edu
Yao Lu
Microsoft Research, WA, USA
luyao@microsoft.com
Chen Li
UC Irvine, CA, USA
chenli@ics.uci.edu
X. Sean Wang
Fudan University, Shanghai, China
xywangcs@fudan.edu.cn
ABSTRACT
We consider accelerating machine learning (ML) inference queries
on unstructured datasets. Expensive operators such as feature
extractors and classifiers are deployed as user-defined functions
(UDFs), which are not penetrable with classic query optimiza-
tion techniques such as predicate push-down. Recent optimization
schemes (e.g., Probabilistic Predicates or PP) assume independence
among the query predicates, build a proxy model for each predicate
offline, and rewrite a new query by injecting these cheap proxy
models in the front of the expensive ML UDFs. In such a manner,
unlikely inputs that do not satisfy query predicates are filtered early
to bypass the ML UDFs. We show that enforcing the independence
assumption in this context may result in sub-optimal plans. In this
paper, we propose CORE, a query optimizer that better exploits the
predicate correlations and accelerates ML inference queries. Our so-
lution builds the proxy models online for a new query and leverages
a branch-and-bound search process to reduce the building costs.
Results on three real-world text, image and video datasets show
that CORE improves the query throughput by up to 63% compared
to PP and up to 80% compared to running the queries as it is.
PVLDB Reference Format:
Zhihui Yang1, Zuozhi Wang, Yicong Huang, Yao Lu, Chen Li, and X. Sean
Wang. Optimizing Machine Learning Inference Queries
with Correlative Proxy Models . PVLDB, XX(X): XXX-XXX, 20XX.
doi:XX.XX/XXX.XX
1
INTRODUCTION
Modern DBMS systems apply machine learning (ML) inference
as user-defined functions (UDFs) for complex analytics over un-
structured texts, images, and videos [4, 11, 22, 23]. Example models
include those extracting user sentiments from product reviews
for market analysis [39] and those estimating vehicle counts from
surveillance videos for traffic planning [13]. Consider the following
query, where input tweets are processed by two ML UDFs, namely
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. XX, No. X ISSN 2150-8097.
doi:XX.XX/XXX.XX
1 Part of the work was done during a visit to UC Irvine.
Input
ℱ!:
Geotagger
ℱ":
Sentiment
Output
𝜎!:
state=‘CA’
𝜎":
sentiment
=positive
Input
ℱ!
Output
𝜎!
𝜎"
𝜎$!:
state=‘CA’
𝜎$":
sentiment
= positive
proxy model
proxy model
ℱ"
(a)
(b)
Figure 1: (a) An example query plan for tweet analysis. (b) An opti-
mized query plan with proxy models.
a geographic tagger (F1) and a sentiment analyzer (F2), to gen-
erate the predicate columns. These queries enable downstream
visualization and statistics, such as analytics of election results.
SELECT F1(t) AS state, F2(t) AS sentiment
FROM Tweets AS t
WHERE state = ‘CA’ ∧sentiment = positive;
Figure 1(a) demonstrates the plan of the above query, where
𝜎1 and 𝜎2 are the predicates state = ‘CA’ and sentiment =
positive, respectively. ML queries are costly due to the expensive
ML UDFs; improving the efficiency for ML inference has been a
recent research focus [4, 11, 17, 21, 29]. In our example, classic query
optimization techniques such as predicate push-down cannot help
much because 𝜎1 and 𝜎2 are stuck behind their corresponding ML
UDFs regardless of their selectivity.
To optimize such ML inference queries, recent works [17, 29]
propose to rewrite the query and insert a set of light-weight filters
in front of the expensive ML UDFs, thus forming a proxy model [38].
Figure 1(b) demonstrates an example plan with two proxy models
ˆ𝜎1 and ˆ𝜎2; they quickly discard input records that are unlikely to
satisfy the predicates and thus improve the query performance.
In [29], a proxy model (i.e., “Probabilistic Predicate” or “PP”) is
specific to a predicate c𝜙v, where c is a predicate column, 𝜙is a
comparison (e.g., > or =), and v is a constant value. An indepen-
dence assumption is made to train filters among different predicates
directly using the raw input, regardless of the fact that each may
have a different input relation. When ad-hoc queries with multiple
predicates arrive, a query optimizer (QO) rewrites and accelerates
the query by assembling individual filters and using them also in
an independent manner. In many applications, query predicates are
often correlated. In our example, sentiments may vary in different
states – the sentiment in California can be different from that in
Texas. As Section 2.2 will show, the QO in [29] overestimates the
arXiv:2201.00309v1  [cs.DB]  2 Jan 2022

---

reduction when building the filters on the raw input and thus yields
sub-optimal plans for a new query with correlated predicates.
Inspired by [17, 29] to optimize ML inference using proxy models,
we intend to relax the independence assumption among different
predicates. A proxy model hence is specific not only to a predicate
but also to its input relation, i.e., prefix 𝜎’s and ˆ𝜎’s, as well as pa-
rameter choices of prefix ˆ𝜎’s. In Figure 1(b), ˆ𝜎2 learns upon filtering
the raw input by ˆ𝜎1 ∧𝜎11. Unlike [29] that builds a small number of
independent filters, it is easy to see that relaxing the independence
assumption may result in an untenable number of filters to build
by enumerating their order and parameter choices.
We propose an optimizer called “CORE” that better exploits pred-
icate correlations in ML inference. Given an ad-hoc query, CORE
builds the proxy models online to avoid exhaustive offline filter con-
struction. We describe a novel technique to accelerate such process
at a small overhead (e.g., a few percent of the query processing) and
a user-specified accuracy target. Extensive experiments for queries
over datasets of tweets, images, and videos indicate that CORE
improves the ML inference execution costs by up to 63% compared
to [29] and up to 80% compared to running the workload as it is.
Various downstream applications, such as interactive data explo-
ration, can benefit from CORE due to a better resource utilization
and a faster decision making.
To summarize, our key contributions are as follows:
• We show that correlations in predicates may harm the perfor-
mance of a prior optimization scheme for ML inference [29].
• We propose CORE to accelerate ML inference and relax the
independence assumption enforced by prior work. Our QO
scheme prunes the space of candidate filters to build and
incurs only a small computing overhead.
• Experiments on real-world ML-inference workloads and
datasets show that CORE can achieve significant query-
throughput improvements.
1.1
Related Work
Operator reordering in database optimization. [7, 10] studied
the problem of reordering select-project-join operators in data-
base systems. [3] studied how to order correlated predicates in
streaming systems. It used a greedy algorithm for selection order-
ing and collected samples at runtime to estimate selectivity. Our
query optimization algorithm gives an optimal solution and uses
a branch-and-bound search to quickly prune plans in the space of
proxy models. [34] studied various optimization techniques of com-
plex user-defined functions on map-reduce-style big data systems,
such as predicate simplification and UDF semantic inference. These
techniques were orthogonal to our solution. Sampling-based ap-
proximate query processing techniques [6] provided approximate
answers to queries by running queries on a small sampling subset
of data. Our approach provides approximate answers by exploiting
the accuracy of ML inference predicates.
Proxy models (a.k.a. cascaded filters) in machine learning.
One of the first proxy models [38] cascaded a sequence of light-
weight classifiers to discard background regions of an image to
accelerate object detection. Later, proxy models were studied to
1F1 is a row processor and does not filter as 𝜎1 and ˆ𝜎1 do.
improve the performance of classification [31], detection [5, 25],
semantic image segmentation [26], and pose estimation [36]. Differ-
ent from [5, 25, 26, 38] that used a cascade of classifiers to quickly
reject sub-regions of an image, our CORE uses proxy models to re-
duce the size of records to be processed by ML UDFs. Unlike [31, 36]
that integrated proxy models into DNN models to improve the per-
formance during the training phase, our CORE uses proxy models
as separate operators to accelerate ML inference.
Proxy models in databases. Recently proxy models have been
applied in big-data systems to accelerate ML inference-based anal-
ysis tasks [12, 16–19, 29, 40]. NoScope [17] firstly cascaded a cheap
specialized model before expensive DNNs to accelerate selection
video queries. After it, certain classes of video queries including
selection without guarantees [12], selection with statistical guar-
antees [18], aggregation [16] and limit queries [16] was optimized
using proxy models. A general index solution in [19] was proposed
to accelerate these video queries over the schema induced by the
target DNN. Probabilistic predicates (PP’s) [29] optimized various
domain queries by inserting multiple offline-built proxy models
before expensive ML UDFs with an assumption of independence
between predicates. Different from [12, 16–18, 40], PP and our pro-
posed CORE cascade general proxy models, which are applicable
to a variety of domains. CORE follows this line of work and further
relaxes the independence assumption of the predicates.
2
PROXY MODELS
We briefly review the background of proxy models and then study
the impact of correlations to proxy models.
2.1
Background
Proxy models have been studied for decades to accelerate ML
inference. Jones et al. [38] cascade weak classifiers as proxy models
to speed-up face detection in images. Recently, accelerating ML
inference with proxy models has attracted attention in relational
big-data systems. We briefly review two related solutions [17, 29]
and refer the readers to their papers for more details.
NoScope (NS) [17] aims to process video queries such as “finding
video frames with vehicles” and “finding video frames with pedes-
trians” using an object-detector UDF. It builds and applies a proxy
model, i.e., a cheaper object detector using shallow Neural Networks
(NNs), which has the same semantics as the object-detector UDF.
NoScope has to train for each query predicate and thus has large
building costs when the query predicates are ad-hoc or complex.
Probabilistic Predicate (PP) [29], as mentioned earlier, is another
form of proxy models. Each PP is a cheap classifier to predict the
likelihood of an input record matching a predicate clause. Easy
inputs with a small likelihood will be discarded immediately, while
hard inputs will be processed further by subsequent ML UDFs.
For ad-hoc queries with complex predicates, a query optimizer as-
sembles multiple PPs built offline, and a dynamic programming
algorithm is leveraged to achieve a maximum reduction, under
the independence assumption in queries. However, this assump-
tion made in PP limits its use to broader applications. Dependency
between columns is the rule, rather than the exception, in the real
2

---

world [14]. In the following, we conduct a controlled experiment
to study the impact of correlations to proxy models.
2.2
Impact of Correlations
To better understand the impact of correlations in processing ML
inference queries, we leverage the correlation score provided by
CORDS [14]. Specifically, let 𝑑1 and 𝑑2 be the distinct counts in a
pair of columns. The correlation score is computed by a chi-squared
test upon a sample of 𝑛-rows:
ˆ𝜅2 =
1
𝑛(min(𝑑1,𝑑2) −1)
𝑑1
∑︁
𝑖=1
𝑑2
∑︁
𝑗=1
(𝑛𝑖𝑗−𝑛𝑖·𝑛·𝑗)2
𝑛𝑖·𝑛·𝑗
,
where 𝑛𝑖𝑗is the frequency of distinct tuple 𝑖, 𝑗, and 𝑛𝑖·, 𝑛·𝑗are the
marginal frequency. A larger ˆ𝜅2 value indicates a stronger correla-
tion between the columns. For example, we can follow CORDS to
use a sample of 10K rows and normalize the correlations scores by
the maximum number in all the predicate pairs. All other algorith-
mic details follow the CORDS paper [14].
90
92
94
96
98
100
Accuracy (%)
0
10
20
30
40
50
Reduction (%)
Estimated
Empirical
(a) Strongly correlated query 𝑞.
90
92
94
96
98
100
Accuracy (%)
0
2
4
6
8
10
12
Reduction (%)
Estimated
Empirical
(b) Weakly correlated query 𝑞′.
Figure 2: The estimated and empirical accuracy-reduction curves of
the second PP filters in a strongly correlated query 𝑞and a weakly
correlated query𝑞′. Correlation results in overestimated reductions
offline in PP.
Why correlation matters for PP? We explain the reason using
the Twitter dataset and two queries, 𝑞and 𝑞′, each with two pred-
icates.2 The correlation between the 𝑞predicates is stronger (2.5
×) than that of the 𝑞′ predicates. The PP filters are trained offline
for each predicate without considering the context in which the
predicate is applied. The accuracy-reduction curves are estimated
during the training as shown in Figure 2. Two proxy models ˆ𝜎1 and
ˆ𝜎2 are connected for the predicate 𝜎1 ∧𝜎2.
When there is a strong correlation between 𝜎1 and 𝜎2 and ˆ𝜎1
discards a row that matches 𝜎1, it is easy to see that, the discarded
row is also likely to match 𝜎2 because of the correlation. As shown
in Figure 2, the empirical reduction produced by ˆ𝜎2 is less than
the estimate, because there are fewer input rows for 𝜎2 after ˆ𝜎1.
On the contrary, when there is a weak correlation, the reductions
are less likely to be overestimated. For example, as shown by 𝑞
with a strong correlation in Figure 2, when the accuracy is 95%, the
estimated data reduction is 40%, and the empirical value is 15%. At
the same accuracy, the difference of the reduction ratio for 𝑞′ with
a weak correlation is most 2%. As a result, with strong correlations,
2More details of the datasets and queries used in the experiments can be found in
Section 6.1.
PP unnecessarily routes more inputs to the expensive ML UDFs and
thus yields a lower performance speedup. This example shows that
the optimizer in previous work overestimates the reduction of the
proxy models built offline, thus yielding suboptimal query plans
and less performance improvement for a new query with correlated
predicates; this limits the use of PPs to broader applications.
3
CORE OVERVIEW
In this section we give an overview of CORE and formally define
its optimization problem.
3.1
System Architecture
In Figure 3, the input of CORE is a query that includes multiple ML
inference UDFs. These UDFs, as seen in the previous section, depict
row manipulators; they produce one output row per input row. ML
UDFs wrap operations such as feature extraction or classification.
CORE optimizes the input query by building proxy models online
and generates a more efficient plan 𝑞∗. We build proxy models for
predicates of the form c𝜙v. Meanwhile, a query can have one or
more predicate clauses in conjunction: Ó c𝜙v. A small portion of
the input data (e.g., 𝑘%) is used to build proxy models, and the
remaining data is processed by the optimized plan 𝑞∗.
ℱ! →𝜎! →ℱ" →𝜎"
CORE
Input query plan 𝑞
𝜎%" →ℱ" →𝜎" →𝜎%! →ℱ! →𝜎!
Modified query plan 𝑞∗
Input data
𝑘%
1 −𝑘%
Output data
Figure 3: Given a query plan 𝑞, CORE generates an optimized plan
𝑞∗by applying proxy models. Part of the input data (𝑘%) is used for
building proxy models, and the remaining data is processed by 𝑞∗.
Definition 1. A proxy model ˆ𝜎is characterized by a tuple
{𝑑, 𝜎, 𝑀, 𝐿, 𝑅},
where 𝑑is an input relation (i.e., applying a sequence of prefix
filters on the raw input), and 𝜎is a target predicate that ˆ𝜎aims to
improve; 𝑀is a regression model used by ˆ𝜎to produce a scoring
function for each input record; 𝐿is a labeled sample from the input
relation 𝑑to build 𝑀; and 𝑅is a mapping from an accuracy 𝛼to a
reduction 𝑟. For the example in Figure 1(b), ˆ𝜎1 is built for the input
relation 𝑑1 = ∅(raw input) and the predicate 𝜎1 : state=‘CA’,
while ˆ𝜎2 is built for 𝑑2 = ( ˆ𝜎1, 𝜎1) and 𝜎2 : sentiment=positive.
The mapping 𝑅will be explained shortly.
Building proxy models online consists of collecting 𝐿and then
training 𝑀. We leverage the initial stream of the input data for 𝐿
(e.g., a few thousand rows). The labeled sample 𝐿is obtained by
applying the filters specified in 𝑑upon the raw input and then
labeling by predicate 𝜎. The label is +1 if 𝜎is satisfied, and -1 oth-
erwise. Next, we use light-weight regression models such as linear
SVMs [15] or shallow NNs [24] to train 𝑀. Once 𝑀is constructed,
our developed query optimizer injects ˆ𝜎into the query plan right
before the corresponding ML UDF that generates the 𝜎predicate
column (Figure 1(b)) for the remaining input records.
3

---

M(𝑥) →
0
1
𝜃= 0.3
28%
100%
44%
90%
𝜃= 0.4
Accuracy 𝛼
Reduction 𝑟
+1
-1
Figure 4: Relationship between an accuracy 𝛼and a reduction ra-
tio 𝑟in a proxy model. Records are ranked in the ascending order
according to their 𝑀(𝑥) score along with 𝑥-axis. White and dark cir-
cles represent records with -1 and +1 labels, respectively.
Given an input record x, a proxy model predicts a score 𝑀(x). For
example, for linear SVM, 𝑀(x) = w𝑇x + 𝑏, where w is a weighted
matrix and 𝑏is a bias term. Record x will be discarded if 𝑀(x) < 𝜃
(for a threshold 𝜃), and in this case the record is called a negative
example. It is clear that such early filtering is a trade-off between
accuracy and data reduction by setting a proper 𝜃, as shown in
Figure 4. A higher 𝜃yields a lower accuracy and a higher data
reduction. Note that the mapping between 𝛼and 𝑟given 𝜃can be
evaluated using a validation set. In the rest of the paper we denote
such a relationship as 𝑅. We can compute it by evaluating ˆ𝜎on a
validation set from the initial stream of the input records.
Query optimization by applying proxy models. We borrow
the AQP-style query interface in [29]. Specifically, the user issues a
query and specifies a global target accuracy Athat depicts the level
of false negatives of the proxy models in addition to those caused
by the UDF. Note that the UDFs themselves produce false positives
and negatives and we do not intend to break the black boxes to
improve their accuracy and performance. Asets the trade-off goals
between additional errors and query-processing speedups. Our QO
builds the proxy models, considers their combinations, allocates
their accuracy parameters, and injects them into the modified query
plan 𝑞∗(Figure 3). To reduce the computing overhead and latency of
building the proxy models before the input query can be accelerated,
the QO reuses intermediate results during the filter construction
and prunes candidate plans using a branch-and-bound search.
3.2
Formulation of Optimization Problem
Given an ML query𝑞with UDFs F1, . . . , F𝑛, predicate filters 𝜎1, . . . ,
𝜎𝑛, and a query-level target accuracy A, we aim to build proxy
models ˆ𝜎1, . . . , ˆ𝜎𝑛with their accuracy parameters 𝛼1, . . . , 𝛼𝑛so that
Ais met. Let the execution costs of applying ˆ𝜎𝑖and the ML UDF F𝑖
be ˆ𝑐𝑖and 𝑐𝑖, respectively. The execution cost 𝐶of a pair of a proxy
model ˆ𝜎𝑖and an ML UDF F𝑖is
𝐶( ˆ𝜎𝑖, 𝛼𝑖) = (
𝑖−1
Ö
𝑗=1
𝑠𝑗· 𝛼𝑗) · (ˆ𝑐𝑖+ (1 −𝑟𝑖) · 𝑐𝑖),
(3.1)
where 𝛼𝑖is the accuracy of ˆ𝜎𝑖, 𝑟𝑖is the reduction of ˆ𝜎𝑖, and 𝑠𝑖is the
conditional selectivity of predicate 𝜎𝑖with prior filters ˆ𝜎1, . . . , ˆ𝜎𝑖−1,
𝜎1, . . . , 𝜎𝑖−1. When building proxy models, their accuracy parame-
ters and Asatisfy
Ö
𝑖
𝛼𝑖· 𝛿𝑖= A,
(3.2)
where 𝛿𝑖= 𝑠𝑖/¯𝑠𝑖, and ¯𝑠𝑖is the conditional selectivity of 𝜎𝑖with prior
𝜎1, . . . , 𝜎𝑖−1 in the original query. The derivation of Equation 3.2
can be found in our technical report [32].
Example. We demonstrate the number of passing records by each
filter for the example query in Figure 5. According to Equation 3.2,
in Figure 5(a), 𝛿2 = 𝑠2/¯𝑠2, where ¯𝑠2 = 60/100 is the conditional
selectivity of predicate sentiment = positive with a prior condi-
tional predicate state = “CA” (i.e., 𝜎1); 𝑠2 = 56/96 is the conditional
selectivity of the same predicate with a prior condition ˆ𝜎1 ∧𝜎1 in
Figure 5(b). Hence, 𝛿2 = 𝑠2/¯𝑠2 = (56/96)/(60/100) = 0.972, which
measures the changes of the input of 𝜎2 after adding its prefix proxy
model ˆ𝜎1. This proxy model changes the input data size of 𝜎2 from
100 to 96 because ˆ𝜎1 discards 4 tweets satisfying state=“CA". Sim-
ilarly, 𝛿1 = 𝑠1/¯𝑠1 = (100/200)/(100/200) = 1, since 𝜎1 is the first
filter and there is no prefix proxy model changing the input of 𝜎1.
To this end, the right side of Equation 3.2 (i.e., the target accuracy
A) is calculated as A = 54/60 = 0.9, which is the percentage of the
output of the original query in Figure 5(a) (i.e., 60 tweets) kept by
its optimized plan in Figure 5(c) (i.e., 54 tweets). We then consider
the left side of Equation 3.2. For each proxy model ˆ𝜎𝑖, 𝛼𝑖is the
percentage of the output by 𝜎𝑖kept by ˆ𝜎𝑖∧𝜎𝑖. In Figure 5(b),
𝛼1 = 96/100 = 0.96, as ˆ𝜎1 ∧𝜎1 keeps 96 tweets in Figure 5(b) and 𝜎1
keeps 100 tweets in Figure 5(a). Similarly, 𝛼2 = 54/56 = 0.964. As
mentioned before, 𝛿1 = 1 and 𝛿2 = 0.972. Both of them measure the
input relation changes for 𝜎1 and 𝜎2 respectively when applying
proxy models. Finally, we have 𝛼1 ·𝛿1 ·𝛼2 ·𝛿2 = 0.9 = A. In general,
relaxing the independence assumption among different predicates
results in introducing a input relation change factor 𝛿caused by its
prefix proxy model. For simplicity, we use 𝛼𝑖to refer 𝛼𝑖·𝛿𝑖later on.
Problem Statement. Let 𝜋be an order of the ML UDFs and pred-
icate filters. Let ˆ𝜎𝜋𝑖denote the 𝜋𝑖-th proxy model. Our QO finds
the following optimal query plan in the order space 𝜋∈H and the
accuracy space A:
arg
min
𝜋∈H,𝛼∈A
∑︁
𝑖
𝐶( ˆ𝜎𝜋𝑖, 𝛼𝜋𝑖),𝑠.𝑡.
Ö
𝑖
𝛼𝜋𝑖= A.
(3.3)
Finding an optimal order 𝜋of ˆ𝜎and allocating their parame-
ter 𝛼simultaneously is NP-hard. Its full proof can be found in the
Appendix in our technical report [32]. Since both 𝑟and 𝑠depend
on 𝑑and the input relation of ˆ𝜎(i.e., prefix 𝜎, ˆ𝜎, and 𝛼choices),
building ˆ𝜎offline by enumerating possible𝑑incurs large computing
costs. We seek a solution such that each ˆ𝜎is built on-the-fly on a
materialized sample 𝐿of its input relation 𝑑. A main challenge is
that, given the accuracy target, how to efficiently build ˆ𝜎with a
small computing overhead with taking its input relation into ac-
count. We describe our solution to find an optimal set of accuracy
parameters 𝛼∈A given an order 𝜋in Section 4, and study how to
find an optimal order 𝜋∈H in Section 5. Both sub-problems exhibit
unique structures that can be leveraged for acceleration. Table 1
summarizes the notations used in the paper.
4
CORE: ACCURACY ALLOCATION
In this section, we present an efficient algorithm in CORE for de-
riving an optimal accuracy allocation 𝛼𝜋1, . . . , 𝛼𝜋𝑛among different
ˆ𝜎𝜋𝑖for a given order 𝜋to achieve a minimum cost Í
𝑖𝐶( ˆ𝜎𝜋𝑖, 𝛼𝜋𝑖).
4

---

Selectivity (𝑠̅!) = 100/200
Selectivity (𝑠̅") = 60/100
Input
ℱ!:
Geotagger
ℱ":
Sentiment
𝜎!:
state=‘CA’
Output
𝜎":
sentiment
=positive
60
200
100
Selectivity (𝑠") = 56/96
Input
ℱ!:
Geotagger
ℱ": 
Sentiment
Output
𝜎!:
state=‘CA’
𝜎":
sentiment
= positive
𝜎%!:
state=‘CA’
56
200
120
96
Accuracy (𝛼!) = 96/100
Reduction (𝑟!) = (200 −120)/200
Input
ℱ!:
Geotagger
ℱ":
Sentiment
Output
𝜎!:
state=‘CA’
𝜎":
sentiment
= positive
𝜎%!:
state=‘CA’
𝜎%":
sentiment
= positive
54
200
120
Reduction (𝑟") = (96−66)/96
96
66
Accuracy (𝛼") = 54/56
(a)
(b)
(c)
Figure 5: Step-by-step demonstration of inserting two proxy models to optimize a query. (a) An original query plan; (b) A query plan with ˆ𝜎1
inserted; (c) A query plan with ˆ𝜎1 and ˆ𝜎2 inserted. Each edge depicts the number of passing tweets. Selectivity (i.e., ¯𝑠𝑖,𝑠𝑖), reduction (i.e., 𝑟𝑖),
and accuracy (i.e., 𝛼𝑖) values are illustrated. The overall query accuracy is A = 54/60.
Notation
Meaning
𝜎
A filter predicate after an ML UDF.
ˆ𝜎
A cheap proxy model that has the same semantics as 𝜎.
𝑑
The input relation of a proxy model ˆ𝜎.
𝐿, 𝑀, 𝑅
The labeled sample, trained classifier, and accuracy-reduction curve
for a proxy model, respectively.
𝛼,𝑟
A proxy model’s accuracy and the achieved reduction ratio.
𝑞, A
A query and a query-level target accuracy specified by a user.
𝑠𝑖
The selectivity of 𝜎𝑖on the condition of prefix ˆ𝜎1, . . . , ˆ𝜎𝑖−1 and 𝜎1,
. . . , 𝜎𝑖−1, i.e., 𝜎𝑖|( ˆ𝜎1, . . . , ˆ𝜎𝑖−1, 𝜎1, . . . , 𝜎𝑖−1).
ˆ𝑐𝑖,𝑐
The execution cost for ˆ𝜎and an ML UDF F.
𝜋
An order of proxy models.
𝐶𝑙
𝑖,𝐶𝑢
𝑖
Lower and upper bounds of execution cost for a pair ( ˆ𝜎𝑖, F𝑖).
Table 1: Notations used in this paper.
4.1
A Basic Approach and its Challenge
One approach to allocating the accuracy is as follows. We first
discretize A with a fixed step size. For each candidate 𝛼𝜋𝑖satisfying
Î
𝑖𝛼𝜋𝑖≥A, we build a proxy model in the order of 𝜋. We obtain a
labeled sample given its input relation, train a classifier, and derive
reduction as mentioned in Section 3. After building ˆ𝜎𝜋𝑖, we compute
its cost using Equation 3.1, and find an optimal 𝛼for a minimal
cost. A main challenge is that building proxy models online is time-
consuming for two reasons. (i) There are an exponential number
of candidate ˆ𝜎𝜋𝑖s. (ii) For each proxy model, generating an labeled
sample and training a classifier can be computationally costly.
To solve this problem, we present Algorithm 1, which accelerates
the construction given input relations specified in 𝜋by reusing
previously materialized samples and trained models. Next we will
present the details of the algorithm.
4.2
Search Framework
As shown in Lemma 1, the objective function (the cost Í
𝑖𝐶( ˆ𝜎𝜋𝑖, 𝛼𝜋𝑖)
subject to 𝛼) is non-convex, which means there could be multiple
locally optimal solutions. In order to find a globally optimal so-
lution, we use an exhaustive search framework in the algorithm
(lines 3 ∼4). If a locally optimal solution is acceptable by the user,
the algorithm can be easily extended to other search frameworks,
such as hill climbing, by replacing lines 3 ∼4.
Lemma 1. There exists a non-convex function of the cost Í
𝑖𝐶( ˆ𝜎𝑖, 𝛼𝑖),
𝑠.𝑡. Î
𝑖𝛼𝑖= A.
Algorithm 1: Accuracy allocation
1: procedure Accuracy_Allocation(𝜋, A)
2:
𝐿′𝜋0 ←raw input;
3:
for 𝛼= ⟨𝛼𝜋1, . . . , 𝛼𝜋𝑛⟩in discretized A, s.t. Î
𝑖𝛼𝜋𝑖= A:
4:
for 𝑖∈{1, . . . ,𝑛}:
5:
if 𝐿′𝜋𝑖is not materialized:
6:
𝐿′𝜋𝑖←Apply 𝜎𝜋𝑖on 𝐿′𝜋𝑖−1;
7:
𝐿𝜋𝑖←Apply ˆ𝜎𝜋1, . . . , ˆ𝜎𝜋𝑖−1 on 𝐿′𝜋𝑖with 𝛼;
8:
Reuse ˆ𝜎∗𝜋𝑖if 𝜖-approx on 𝐿𝜋𝑖else retrain;
9:
Compute 𝐶( ˆ𝜎𝜋𝑖, 𝛼𝜋𝑖);
10:
Compute cost Í
𝑖𝐶( ˆ𝜎𝜋𝑖, 𝛼𝜋𝑖);
11:
Pick 𝛼∗in A with a minimum cost;
12:
Retrain ˆ𝜎𝜋1, . . . , ˆ𝜎𝜋𝑛with 𝛼∗;
13:
return ˆ𝜎𝜋1, . . . , ˆ𝜎𝜋𝑛and 𝛼∗𝜋1, . . . , 𝛼∗𝜋𝑛.
Proof. The cost of applying each proxy model before its corre-
sponding ML UDF could be any non-decreasing function over its
accuracy, as the reduction decreases with the increase of accuracy.
shown in [29]. We prove the lemma by constructing the following
example with 𝑛= 2.
𝐶( ˆ𝜎1, 𝛼1) = 1 −(𝛼1 −1)2, 𝛼1 ∈[0, 1].
𝐶( ˆ𝜎2, 𝛼2) = 𝑒−(2A/𝛼2−1)3, 𝛼2 ∈[0, 1].
Both 𝐶( ˆ𝜎1, 𝛼1) and 𝐶( ˆ𝜎2, 𝛼2) increase monotonically when 𝛼1 ∈
[0, 1] and 𝛼2 ∈[0, 1]. The cost function 𝑓= Í𝐶is
𝑒−(2𝑥−1)3 + 1 −(𝑥−1)2,𝑥∈[0, 1].
If the function 𝑓is convex on an interval [0, 1], by definition [9],
for any two points 𝑥1 and 𝑥2 in [0, 1] and any 𝜆where 0 < 𝜆< 1,
𝑓(𝜆𝑥1 + (1 −𝜆)𝑥2) ≤𝜆𝑓(𝑥1) + (1 −𝜆)𝑓(𝑥2).
However, when 𝑥1 = 0.1,𝑥2 = 0.5 and 𝜆= 1/2, 𝑓( 𝑥1+𝑥2
2
) =
1.17; 𝑓(𝑥1)+𝑓(𝑥2)
2
= 1.12. So 𝑓does not satisfy 𝑓(𝜆𝑥1 + (1 −𝜆)𝑥2) ≤
𝜆𝑓(𝑥1) + (1 −𝜆)𝑓(𝑥2). Thus 𝑓is not convex.
□
4.3
Reusing Samples to Reduce Labeling Costs
We first give a theorem about the proxy models, then show how
the algorithm leverages the theorem to reuse samples.
5

---

4.3.1
Commutative proxy models. We note that the order of prefix
filters is interchangeable as shown in Theorem 1. In Figure 5(b),
the 96 output tweets after ˆ𝜎1 ∧𝜎1 with 𝛼1 = 0.96 are the same as
the output tweets of applying ˆ𝜎1 with 𝛼1 = 0.96 on the 100 output
tweets after 𝜎1 in Figure 5(a). That is, with 𝛼1 = 0.96, applying
𝜎1 ∧ˆ𝜎1 and applying ˆ𝜎1 ∧𝜎1 have the same results. To prove the
theorem, we introduce Lemma 2 to prove a base case that a pair of
ˆ𝜎∧𝜎are commutative, and Lemma 3 to prove an inductive case
that two pairs of ˆ𝜎∧𝜎are still commutative with the same prefix
filter and the same suffix filter, respectively.
Lemma 2. Given a list of records 𝐿, a filter 𝜎, and a proxy model ˆ𝜎
with a parameter 𝛼, 𝜎and ˆ𝜎with 𝛼are commutative, i.e., the results
after applying ˆ𝜎∧𝜎are the same as that after applying 𝜎∧ˆ𝜎. That
is, ˆ𝜎∧𝜎= 𝜎∧ˆ𝜎.
Proof. According to Definition 1, a proxy model ˆ𝜎is built based
on its input relation 𝑑and a target predicate. After building ˆ𝜎and
allocating an accuracy 𝛼, ˆ𝜎is a selection predicate with fixed values
of 𝛼, 𝑟, and 𝑀. When applying ˆ𝜎, any input record cannot change
ˆ𝜎. ˆ𝜎predicts the same output for a record in different orders (e.g.,
𝜎∧ˆ𝜎and ˆ𝜎∧𝜎). For 𝜎∧ˆ𝜎, an unseen record 𝑥for ˆ𝜎is the one
passed by 𝜎. If ˆ𝜎passes 𝑥, then 𝑥is in the output of 𝜎∧ˆ𝜎and also
in the output of ˆ𝜎∧𝜎. Otherwise, 𝑥is not in their outputs. For
ˆ𝜎∧𝜎, ˆ𝜎takes more input records, compared to 𝜎∧ˆ𝜎. There is no
unseen record for ˆ𝜎. As selection predicates are commutative in
general, 𝜎and ˆ𝜎with 𝛼are commutative.
□
Lemma 3. Given a list of records 𝐿, two filters 𝜎𝑖and 𝜎𝑗, and a
proxy model ˆ𝜎𝑘with a specific parameter 𝛼𝑘, we have
ˆ𝜎𝑘∧𝜎𝑖∧𝜎𝑗= 𝜎𝑖∧ˆ𝜎𝑘∧𝜎𝑗,
(4.1)
and
𝜎𝑖∧ˆ𝜎𝑘∧𝜎𝑗= 𝜎𝑖∧𝜎𝑗∧ˆ𝜎𝑘.
(4.2)
Proof. We first prove ˆ𝜎𝑘and 𝜎𝑖are commutative with the same
suffix 𝜎𝑗(i.e., Equation 4.1). According to Lemma 2, ˆ𝜎𝑘and 𝜎𝑖are
commutative (i.e., ˆ𝜎𝑘∧𝜎𝑖= 𝜎𝑖∧ˆ𝜎𝑘). ˆ𝜎𝑘∧𝜎𝑖and 𝜎𝑖∧ˆ𝜎𝑘followed
by the same suffix 𝜎𝑗produce the same outputs, i.e., ˆ𝜎𝑘∧𝜎𝑖∧𝜎𝑗=
𝜎𝑖∧ˆ𝜎𝑘∧𝜎𝑗.
Next, we prove ˆ𝜎𝑘and 𝜎𝑗are commutative with the same prefix
𝜎𝑖(i.e., Equation 4.2). For 𝜎𝑖∧ˆ𝜎𝑘∧𝜎𝑗and 𝜎𝑖∧𝜎𝑗∧ˆ𝜎𝑘, the input
of ˆ𝜎𝑘∧𝜎𝑗and that of 𝜎𝑗∧ˆ𝜎𝑘are the same because of the same
input list of records 𝐿and the same prefix 𝜎𝑖. Based on Lemma 2,
𝜎𝑖∧ˆ𝜎𝑘∧𝜎𝑗= 𝜎𝑖∧𝜎𝑗∧ˆ𝜎𝑘.
□
Theorem 1. Given a sample of records 𝐿, filters 𝜎1, . . . , 𝜎𝑛, and
proxy models ˆ𝜎1, . . . , ˆ𝜎𝑛with specific parameters 𝛼1, . . . , 𝛼𝑛, we have:
𝑛
Û
𝑖=1
( ˆ𝜎𝑖∧𝜎𝑖) = (
𝑛
Û
𝑖=1
𝜎𝑖) ∧(
𝑛
Û
𝑖=1
ˆ𝜎𝑖).
Proof. We prove the claim by induction.
Base case: 𝑛= 1. According to Lemma 2, ˆ𝜎1 ∧𝜎1 = 𝜎1 ∧ˆ𝜎1.
Inductive case: 𝑛= 𝑚+ 1. Assume that Ó𝑚
𝑖=1( ˆ𝜎𝑖∧𝜎𝑖) = (Ó𝑚
𝑖=1 𝜎𝑖) ∧
(Ó𝑚
𝑖=1 ˆ𝜎𝑖) with 𝑛= 𝑚. Next, we prove that the claim is also true for
𝑛= 𝑚+ 1.
First, according to the assumption for 𝑛= 𝑚, Expression 4.3
equals to Expression 4.4. Next, based on Lemma 3, a proxy model
and a filter are commutative when they have the same prefix fil-
ters. Expression 4.4 equals to Expression 4.5. Additionally, a proxy
model and a filter are commutative when they have same suffix
filters according to Lemma 3. We exchange 𝜎𝑚+1 in Expression 4.5
with prefix 𝑚proxy models in turn using Lemma 3. Therefore,
Expression 4.5 equals to Expression 4.6.
( ˆ𝜎1 ∧𝜎1 ∧· · · ∧ˆ𝜎𝑚∧𝜎𝑚) ∧ˆ𝜎𝑚+1 ∧𝜎𝑚+1
(4.3)
=(𝜎1 ∧· · · ∧𝜎𝑚∧ˆ𝜎1 ∧· · · ∧ˆ𝜎𝑚) ∧ˆ𝜎𝑚+1 ∧𝜎𝑚+1
(4.4)
=(𝜎1 ∧· · · ∧𝜎𝑚∧ˆ𝜎1 ∧· · · ∧ˆ𝜎𝑚) ∧𝜎𝑚+1 ∧ˆ𝜎𝑚+1
(4.5)
=(𝜎1 ∧· · · ∧𝜎𝑚∧𝜎𝑚+1) ∧( ˆ𝜎1 ∧· · · ∧ˆ𝜎𝑚∧ˆ𝜎𝑚+1).
(4.6)
Therefore, Ó𝑛
𝑖=1( ˆ𝜎𝑖∧𝜎𝑖) = (Ó𝑛
𝑖=1 𝜎𝑖) ∧(Ó𝑛
𝑖=1 ˆ𝜎𝑖).
□
4.3.2
Reusing samples. The algorithm improves the performance
by reusing early samples (lines 5 to 7). 𝐿𝜋𝑖is the sampled input to
build ˆ𝜎𝜋𝑖by applying predicate 𝜎𝜋𝑖on the input relation 𝑑𝜋𝑖. In
Figure 5(b), the labeled sample 𝐿2 for ˆ𝜎2 has 96 tweets, which are
filtered by ˆ𝜎1∧𝜎1 on the raw input and then labeled using the predi-
cate sentiment=positive. It is easy to see that 𝐿𝜋𝑖changes when
accuracies assigned to its prefix proxy models (i.e., 𝛼𝜋1, . . . , 𝛼𝜋𝑖−1)
change. For example, in Figure 5(b), 𝐿2 changes from 97 tweets to
96 tweets when the accuracy parameter of its prefix ˆ𝜎1 changes
from 𝛼1 = 0.97 to 𝛼1 = 0.96.
By leveraging Theorem 1, we can improve the performance by
materializing samples 𝐿′ after 𝜎, and applying ˆ𝜎on 𝐿′ during the
search, since common 𝐿′ can be shared for different 𝛼choices. 𝐿𝜋𝑖
can be obtained by applying ˆ𝜎𝜋1, . . . , ˆ𝜎𝜋𝑖−1 on a pre-computed sam-
ple 𝐿′𝜋𝑖that is computed by applying 𝜎𝜋1, . . . , 𝜎𝜋𝑖−1 on the raw input.
Lines 5 to 7 illustrate this process of quickly deriving 𝐿for each 𝛼
search. For the proxy model ˆ𝜎2, we materialize its corresponding
sample 𝐿′
2 containing 100 tweets filtered by 𝜎1 in Figure 5(a) to be
reused. When 𝛼1 = 0.97, the labeled sample 𝐿2 can be obtained by
applying prefix ˆ𝜎1 with 𝛼1 = 0.97 on the 100 materialized tweets
and producing 97 tweets. Similarly, when 𝛼1 changes to 0.96 in Fig-
ure 5(b), the labeled sample 𝐿2 can be obtained by applying ˆ𝜎1 with
𝛼1 = 0.96 on the already materialized sample 𝐿′
2 of 100 tweets and
producing 96 tweets. This solution is simple but effective, since ap-
plying ˆ𝜎is cheap and doing so allows us to evaluate each expensive
Fand 𝜎only once.
4.4
Reusing Classifiers to Reduce Training
Costs
The algorithm adopts a classifier-reusing scheme (line 8) to avoid
repeated training when the prefix proxy models change their accu-
racy assignments. Specifically, let ˆ𝜎∗trained on 𝐿∗with 𝛼from a
previous iteration (line 3) be 𝜖-approximate [2] to ˆ𝜎trained on 𝐿.
That is:
(1 −𝜖)𝜙∗(𝐿∗) ≤𝜙∗𝐿≤(1 + 𝜖)𝜙∗𝐿∗,
(4.7)
where 𝜙is the objective function of the regressor model used by the
proxy model. 𝜙can be computed using a scoring function, such as
F1 score or coreset [2]. Take the F1 scoring function as an example.
We efficiently compute 𝜙by evaluating ˆ𝜎∗from a previous iteration
and measuring its F1 score on its labeled sample 𝐿∗and current
𝐿[2]. ˆ𝜎∗can be reused if it is 𝜖-approximate under the current
accuracy setting. In Figure 5(b), suppose we want to build the proxy
model ˆ𝜎2 for the predicate sentiment=positive on its 96 labeled
6

---

tweets with prefix 𝛼1 = 0.96. If there is a proxy model ˆ𝜎∗
2 trained
on 97 tweets with prefix 𝛼1 = 0.97 satisfying Equation 4.7, we reuse
the classifier in ˆ𝜎∗
2 (i.e., 𝑀∗
2) without training a new classifier on the
96 tweets. In Equation 4.7, we compute 𝜙∗(𝐿∗) by evaluating the
F1 score of 𝑀∗
2 on the 97 tweets, while 𝜙∗(𝐿) is on the 96 tweets.
We next discuss how to compute 𝐶( ˆ𝜎𝑖, 𝛼𝑖) (line 9). The per-
row cost ˆ𝑐for ˆ𝜎and 𝑐for Fcan be profiled during training or by
counting the FLOPS of the ML model, while 𝑟can be obtained from
𝑅, and𝑠can be measured by applying the prefix filters on a sample of
the raw input. Since applying the proxy models is computationally
cheap, 𝐶can be computed efficiently. In Figure 5, the cost of the ML
UDF Geotagger is 20ms per tweet in our experiments, while that
of the proxy model ˆ𝜎1 is 0.01ms per tweet. The proxy model ˆ𝜎1 with
𝛼1 = 0.96 pays the cost of processing 200 tweets and saves the cost
of the 80 discarded tweets, which no longer need to be processed by
the ML UDF Geotagger. Therefore, using Equation 3.1, we have
𝐶( ˆ𝜎1, 𝛼1) = ˆ𝑐1 + (1 −𝑟1) · 𝑐1 = 0.01 + (1 −80/200) · 20 = 12.01.
5
CORE: REORDERING PROXY MODELS
In this section we study how to reorder proxy models to find an
optimal order 𝜋∈H to minimize the cost Í𝐶. For different or-
ders, proxy models built on input relations and predicates are dif-
ferent and they have different costs. For instance, in Figure 5(c),
for the order state = “CA”∧sentiment = positive, the proxy
model for predicate state = “CA” is built on the original input
data. For the order sentiment = positive∧state = “CA”, the
proxy model for the same predicate is built on records satisfying the
predicate sentiment = positive. Because different orderings af-
fect the input data to the proxy model, these two proxy models
have different execution costs for the same ML UDF Geotagger.
The number of query plans in H is exponential in terms of the
number of UDFs and filters. We construct a search tree to represent
them by merging common prefixes of query plans. For example,
let 𝑋, 𝑌, and 𝑍be three ML UDFs. There are six potential plans
in H (e.g., 𝑋𝑌𝑍and 𝑋𝑍𝑌). Figure 6 shows a snippet of the search
tree starting from node 𝑋, where each tree node represents an ML
UDF Fand its corresponding ˆ𝜎and 𝜎. In general, building all proxy
models for the plans can be computationally prohibitive. To find an
optimal order 𝜋efficiently, we propose a search algorithm based
on branch-and-bound [20, 28] to prune candidate plans.
5.1
Bounded Cost
For a specific order of proxy models, we can compute a lower
bound and an upper bound of the cost Í𝐶. Intuitively, an initial
lower bound corresponds to the case when all proxy models discard
everything. An initial upper bound corresponds to the case when
all proxy models discard nothing. For example, for the order 𝑋𝑌𝑍
in Figure 6, the cost function reaches a lower bound when the first
proxy model ˆ𝜎𝑋discards all its input records. It reaches an upper
bound when all proxy models ˆ𝜎𝑋, ˆ𝜎𝑌, and ˆ𝜎𝑍discard nothing.
Let 𝐶𝑙and 𝐶𝑢be the lower and upper bounds of the cost for a
node, respectively. As shown in Equation 3.1, the cost 𝐶of a proxy
model ˆ𝜎is bounded by accuracy 𝛼, reduction 𝑟, and selectivity 𝑠,
where (i) 𝛼∈[A, 1], (ii) 𝑠∈[0, 1] and (iii) 𝑟∈[0, 1]. 𝐶increases
when 𝑠and 𝛼increase and 𝑟decreases. To calculate a lower bound
of node 𝑡at depth 𝑖assuming the depth of the root is 0, we use the
minimal value of the accuracy 𝛼𝑙
𝑖= A, the minimal value of the
selectivity 𝑠𝑙
𝑖= 0, and the maximum value of the reduction 𝑟𝑢
𝑖= 1.
Similarly, to compute an upper bound of 𝑡, we use the maximum
value of the accuracy 𝛼𝑢
𝑖= 1, the maximum value of the selectivity
𝑠𝑢
𝑖= 1, and the minimal value of the reduction 𝑟𝑙
𝑖= 0. Based on the
analysis, we present a lower bound and an upper bound of the cost
𝐶of a node 𝑡in Lemma 4. Additionally, a lower bound of the cost
for a plan is the sum of the lower bound of the cost for each node
in the plan, and an upper bound for a plan is the sum of the upper
bound for each node in the plan. That is, the bounds of Í𝐶for a
plan are Í𝐶𝑙and Í𝐶𝑢, respectively.
Lemma 4. For a tree node 𝑡of depth 𝑖, a lower bound of its cost 𝐶𝑡
is
(
𝑖−1
Ö
𝑗=1
𝑠𝑙
𝑗· 𝛼𝑙
𝑗) ·  ˆ𝑐𝑖+ (1 −𝑟𝑢
𝑖) · 𝑐𝑖
.
(5.1)
An upper bound is
(
𝑖−1
Ö
𝑗=1
𝑠𝑢
𝑗· 𝛼𝑢
𝑗) ·  ˆ𝑐𝑖+ (1 −𝑟𝑙
𝑖) · 𝑐𝑖
.
(5.2)
Example. In Figure 6, the lower bound of node 1 is the cost of
applying a proxy model.𝐶𝑙
𝑋= ˆ𝑐𝑋using Expression 5.1 with𝛼𝑙
𝑋= A,
𝑠𝑙
𝑋= 0, and 𝑟𝑢
𝑋= 1. The upper bound 𝐶𝑢
𝑋is the cost of a proxy
model ˆ𝑐𝑋plus that of the ML UDF 𝑐𝑋with 𝛼𝑢
𝑋= 1, 𝑠𝑢
𝑋= 1, and
𝑟𝑙
𝑋= 0. For the plan 𝑋𝑌𝑍in Figure 6, the lower bound of the plan
is 𝐶𝑙
𝑋+ 𝐶𝑙
𝑌+ 𝐶𝑙
𝑍, and the upper bound is 𝐶𝑢
𝑋+ 𝐶𝑢
𝑌+ 𝐶𝑢
𝑍.
X
𝛼!
" = 𝛼!
# = 0.92
Y
Z
Y
Z
𝛼$
" = 𝛼$
# = 0.98
𝛼%
" = 1.0, 𝛼%
# = 0.9
1
2
4
3
5
X
𝛼!
" = 𝛼!
# = 0.92
Y
Z
Y
Z
𝛼$
" = 𝛼$
# = 0.93
𝛼%
" = 𝛼%
# = 0.95
1
2
4
3
5
Order XYZ:
∑𝐶∈[6, 8]
Order XZY:
∑𝐶∈[2, 8]
Visited
Current
Order XYZ:
∑𝐶∈[6, 8]
Order XZY:
∑𝐶∈[5, 5]
✄
(a) The 𝑖&' iteration.
(b) The 𝑖+ 1(& iteration.
Pruned
Figure 6: Two iterations in branch-and-bound search on a tree start-
ing from node 1 with A = 0.9. The blue text is updated information
such as accuracies, lower bounds, and upper bounds after calling
the function update_node().
5.2
Branch-and-bound Search
We present a general pruning framework in Algorithm 2. Its main
idea is that the upper and lower bounds can be improved as we col-
lect information during the search process, such as selectivity and
reduction. The search builds necessary proxy models and prunes
the search tree to reduce the optimization overhead. For each node
𝑡, according to Lemma 4, we initialize the lower and upper bounds
of ˆ𝜎using 𝐶𝑙and 𝐶𝑢, respectively (lines 4∼5). We then progres-
sively build proxy models (lines 6∼11). For each search step, we
find optimal 𝛼parameters for 𝑡and prefix nodes using Algorithm 1.
We compute the cost Í𝐶of these nodes after using Algorithm 1,
7

---

Algorithm 2: QO by branch-and-bound pruning
1: procedure bb_pruning(𝑞, A)
2:
Construct a search tree based on H from 𝑞;
3:
𝑄= {𝑞𝜋|∀𝜋∈H}; visited=∅;
4:
for each node 𝑡in the search tree:
5:
𝐶𝑙,𝐶𝑢←initialize(𝑡);
6:
while |𝑄| > 1:
7:
𝑡←pop_unvisited(𝑄, visited);
8:
ˆ𝜎∗, 𝛼∗←accuracy_allocation(𝑡, A);
9:
update_node(𝑡, ˆ𝜎∗, 𝛼∗);
10:
visited = visited ∪{𝑡};
11:
sort_and_prune(𝑄, Í𝐶𝑙, Í𝐶𝑢);
12:
return (𝜋, 𝛼) that minimizes Í𝐶.
and tighten the bounds of costs for 𝑡’s leaf nodes. The search yields
an order 𝜋that minimizes the overall cost Í
𝑖𝐶( ˆ𝜎𝜋𝑖, 𝛼𝜋𝑖). We next
explain several specific functions used in the algorithm.
Initialization (line 5): We initialize the lower and upper bounds
for each node according to Lemma 4. The query accuracy Î𝛼in
Equation 3.3 is within [A𝑛, 1]. For example, for the plan 𝑋𝑌𝑍in
Figure 6, we initialize the lower and upper bounds for each node
with 𝛼𝑙= A, 𝑠𝑙= 0, 𝑟𝑢= 1 and 𝛼𝑢= 1, 𝑠𝑢= 1, 𝑟𝑙= 0, respectively.
The query accuracy Î𝛼is within [0.93, 1] initially, where 0.9 is
the query target accuracy A.
Choosing the next candidate node. (line 7): We find the first
unvisited tree node 𝑡from 𝜋that is in the front of the queue. In Fig-
ure 6(a), 𝜋= 𝑋𝑍𝑌is in the front of the queue 𝑄according to sort_-
and_prune(), which will be explained later. pop_unvisited()
yields 𝜋= 𝑋𝑍𝑌and node 3, since node 1 has been visited. Similarly,
pop_unvisited() yields 𝜋= 𝑋𝑍𝑌and node 5 in Figure 6(b). If
all the nodes for the head plan in the queue have been visited, we
look for the next 𝜋∈𝑄.
Tightening cost bounds. (line 8∼line 9): We first call accuracy_-
allocation() to build an optimal proxy models ˆ𝜎∗with an opti-
mal 𝛼∗from the root till the current node 𝑡at depth 𝑖. The update_-
node() function updates 𝛼𝑙= 𝛼𝑢= 𝛼∗for nodes from the root till
𝑡. Similarly, 𝑠𝑙= 𝑠𝑢= 𝑠∗, and 𝑟𝑙= 𝑟𝑢= 𝑟∗. This process improves
the bounds of Í𝐶for plans under node 𝑡(with untrained ˆ𝜎s) and in
turn tightens the query accuracy Î𝛼to [A𝑛−𝑖+1, A]. In Figure 6(a),
for node 3, we call accuracy_allocation() for the sub-query
𝑋𝑍and find the optimal 𝛼𝑙
𝑋= 𝛼𝑢
𝑋= 0.92 and 𝛼𝑙
𝑍= 𝛼𝑢
𝑍= 0.98 for
node 1 and node 3, respectively. The update_node() tightens the
query accuracy Î𝛼for the plan 𝑋𝑍𝑌from [0.93, 1] to [0.92, 0.9],
and tightens the lower and upper bounds of Í𝐶to [2, 8].
Pruning plans. (line 11): After the bounds are updated, we sort
and prune 𝜋∈𝑄. The following rules are used to determine the
sort order of 𝜋as well as to prune unnecessary plans.
• When [Í𝐶𝑙, Í𝐶𝑢] for two 𝜋’s have overlap, the one with a
lower mean cost
Í𝐶𝑙+Í𝐶𝑢
2
has a higher priority and is likely
to yield more gains. Such a plan should be explored first. In
Figure 6(a), the mean cost for the plan 𝑋𝑍𝑌is 5, which is
less than that of the plan 𝑋𝑌𝑍. Therefore, the plan 𝑋𝑍𝑌has
a higher priority than the plan 𝑋𝑌𝑍.
• When [Í𝐶𝑙, Í𝐶𝑢] for two 𝜋’s have no overlap, we prune
the one with a higher value range from the search tree, since
it provides greater cost. In Figure 6(b), [Í𝐶𝑙, Í𝐶𝑢] for the
plan 𝑋𝑍𝑌is lower than that of the plan 𝑋𝑌𝑍, and they have
no overlap. Then the plan 𝑋𝑌𝑍is removed from 𝑄, i.e., the
edge connecting node 2 and node 4 is deleted.
The above comparisons are done for each pair of 𝜋’s until 𝑄is
fully sorted. The lower bound and upper bound are equal to the
exact cost once ˆ𝜎is built. Pruned 𝜋’s are removed from 𝑄.
5.3
Improvement Using a Fine-grained Tree
The branch-and-bound search discussed above involves generating
labeled samples 𝐿, followed by training classifiers 𝑀and deriving
𝐶for each node in H. To further speedup the search, we split one
node into two: an 𝐿-node to generate labeled samples, and an 𝑀-
node to train classifiers 𝑀and derive 𝑅and 𝐶. An 𝐿-node has to
be placed before its corresponding 𝑀-node, i.e., labeling happens
before training. For instance, the node 𝑋in Figure 7(a) is split into
an 𝐿𝑋node to generate the labeled sample for ˆ𝜎𝑋and an 𝑀𝑋node
to train the classifier for ˆ𝜎𝑋in Figure 7(b). We call this new tree a
fine-grained search tree H+.
Compared to the original search tree discussed in the previous
section, H+ provides more opportunities to tighten the cost bounds.
For example, we can prune the search tree at an 𝐿-node without
executing its corresponding 𝑀-node. The search algorithm is similar
to Algorithm 2, except a new update_node() function. Its update
scheme now depends on the type of node 𝑡, discussed below.
X
𝐿!
Y
Z
𝑀!
𝐿"
𝐿#
𝑀!
𝐿#
1
2
3
1
2
3
4
5
6
…
…
(a)
(b)
𝐿#
7
Figure 7: (a) A snippet of the search tree in Figure 6; (b) A fine-
grained tree of (a).
𝐿-node. We update the lower and upper bounds of selectivity 𝑠
because we generate labeled samples and compute 𝑠at 𝐿-node.
For an 𝐿-node 𝑡, a proxy model ˆ𝜎is called available for 𝑡if its
corresponding 𝑀-node is an ancestor of 𝑡; otherwise, ˆ𝜎is called
unavailable for 𝑡. We compute lower and upper bounds of 𝑠𝑡by
applying all available prefix ˆ𝜎and 𝜎on the raw input to obtain a
labeled sample 𝐿∗
𝑡, and its selectivity is denoted as 𝑠∗
𝑡. In Figure 7(b),
ˆ𝜎𝑋is available for node 5 because we build ˆ𝜎𝑋at node 2, which is
an ancestor of node 5, while it is unavailable for node 3 because
𝑀𝑋is not an ancestor of node 3. The labeled sample 𝐿∗
𝑌for node
3 is labeled by 𝜎𝑌after 𝜎𝑋on the raw input without applying ˆ𝜎𝑋.
Let the selectivity on 𝐿∗
𝑌be 𝑠∗
𝑌. We compute 𝐶𝑙
𝑡and 𝐶𝑢
𝑡as follows:
• A lower bound 𝐶𝑙
𝑡can be computed when its unavailable
proxy models have 𝛼𝑙= Aand discard records that satisfy 𝜎𝑡
from 𝐿∗
𝑡. In this case, the selectivity𝑠becomes (𝑠∗
𝑡−(1 −A)𝑘)
/A𝑘, where 𝑘is the number of unavailable prefix proxy
8

---

models. This selectivity is used to estimate 𝐶𝑙
𝑡using Expres-
sion 5.1. For node 3 in Figure 7(b), we compute 𝐶𝑙
𝑌using
𝑠𝑙
𝑌= (𝑠∗
𝑌−(1 −A))/Awhen the unavailable ˆ𝜎𝑋with 𝛼= A
discards records satisfying 𝜎𝑌from 𝐿∗
𝑌.
• An upper bound 𝐶𝑢
𝑡can be computed when unavailable
proxy models do not discard any records in 𝐿∗
𝑡(i.e., 𝛼= 1.0).
Its selectivity is 𝑠∗
𝑡in this case. We compute 𝐶𝑢
𝑡using 𝑠𝑢
𝑡=
𝑠∗
𝑡in Expression 5.2. In Figure 7(b), at node 3, when ˆ𝜎𝑋is
unavailable and we use 𝛼= 1.0, the selectivity 𝑠𝑢
𝑌= 𝑠∗
𝑌is
used to estimate 𝐶𝑢
𝑌.
𝑀-node. As in Section 5.2, we call Algorithm 1 to compute 𝛼∗, train
ˆ𝜎, and estimate 𝐶. We also update the bounds for all its ancestor
nodes. In Figure 7(b), after we train ˆ𝜎𝑋for node 5, we update the
selectivity of node 3 by applying ˆ𝜎𝑙
𝑋on its labeled sample 𝐿′
𝑌.
The above search on the fine-grained tree is efficient, as illus-
trated in our experiments. For a query on the Twitter dataset, the
search algorithm prunes 37% of the nodes on the original search
tree, and 85% of the nodes on the fine-grained tree.
6
EXPERIMENTS
We have conducted a thorough evaluation of CORE and compared
it with state-of-the-art solutions.
6.1
Setup
Datasets. We used three datasets with text, images, and videos.
Twitter text dataset. It contained 2M tweets from January 2017 to
September 2017 in the United States randomly sampled using the
Twitter sampled stream API [37]. Each tweet was a string with
a maximum of 140 characters. This dataset supported text analy-
sis and retrieval by utilizing various NLP modules such as entity
recognition, sentiment analysis, and part-of-speech (PoS) tagger.
COCO image dataset. COCO [27] was a public dataset collected
online. It contained 123K images and 80 object classes such as
“person”, “bicycle”, and “dog”. Each image was labeled with multiple
objects for their class labels and bounding box positions. The dataset
was used for retrieving images that contained one or more object
classes specified in user queries.
UCF101 video dataset. The UCF101 activity recognition dataset [35]
contained 13K videos collected from YouTube. Each video was la-
beled with one of 101 action categories such as “applying lipstick”
and “baby crawling”. It supported video retrieval using labels gen-
erated by object detection and action recognition models.
Workloads. To our best knowledge, there is no off-the-shelf bench-
mark for ML inference with comprehensive ML operators and pred-
icates. To solve the problem, we generated 10 queries for each
dataset in the experiments. Table 2 illustrates some of them, and
Figure 8 shows some sample workflows. The workloads retrieved
texts, images, and videos that matched given query predicates,
which were conjunctions of multiple clauses with different selectiv-
ity values. Each predicate clause was an equality condition on an
ML-generated label column. We refer the readers to a full list of the
queries as well as snapshots of the datasets in [8]. Each query also
specified a target query accuracy A, indicating how much accuracy
loss the user was willing to pay relatively to the original query.
Dataset Q# Query semantics
Selectivity Correlation
Twitter q1
Sentiment(’negative’ or ’neutral’) & PoS Tag-
ger(’VBD’ or ’WRB’ or ’IN’)
0.49
0.55
q2
Sentiment(’negative’ or ’neutral’) & PoS Tag-
ger(’PRP’)
0.35
0.41
COCO q2
Object detection (person) & (car or chair or
cup or dog or handbag or . . . )
0.20
0.98
q6
Object detection (person) & (car or chair or
cup or tv or bed or . . . )
0.13
0.99
UCF101 q2
Activity Recognition (archery or balance beam
or biking or . . . ) & Object detection (chair or
sports ball or bird or . . . )
0.17
1.00
q9
Object detection (chair or sports ball or cup
or . . . ) & Activity Recognition (archery or
balance beam or basketball dunk or . . . )
0.22
0.82
Table 2: Some of ML queries used in the experiments.
Input
Sentiment
PoS 
Tagger
Output
sentiment= 
(‘negative’ or 
‘neutral’)
tagger =
(‘VBD’or ‘IN’)
(a) 𝑞1 on the Twitter dataset.
Input
Object 
detection 
Output
object = 
person
object=(car or 
chair or cup or dog
or handbag or …)
(b) 𝑞2 on the COCO dataset.
Figure 8: Sample ML workflows.
Metrics. We measured (1) the end-to-end total processing time that
included the query optimization, training of necessary models, and
processing the query given an optimized plan; (2) the accuracy of
our query processing relatively to the original ML inference queries;
(3) the query execution cost (milliseconds per record); and (4) the
decomposition of the optimization costs (minutes).
CORE. We implemented a query execution engine and the CORE
optimizer in Python that enabled ML inference queries on various
unstructured texts, images, and videos. We also implemented sev-
eral ML UDFs using the Stanford NLP [30] and spaCy packages for
text analysis, YOLOv3 [33] for object detection in images, and an
activity recognition model [1] for recognizing activities in videos.
Baselines. We compared CORE against the following baseline
approaches. (i) ORIG was a baseline that ran the original query as it
is. (ii) NS was a baseline based on NoScope [17]. It trained a single
light-weight model and inserted it early in a plan to quickly filter
input records that did not match the query predicate so that the
entire query could be accelerated. (iii) PP (short for Probabilistic
Predicates [29]) built a light-weight filter for each predicate offline
and injected them early in a plan with an independence assumption
of predicates, given an ad-hoc query.
The experiments were run on a c5.4xlarge AWS instance with
280GB SSD storage, 16 vCPUs, and 32GB memory, running a Ubuntu
Linux 16.04.
9

---

6.2
Effect of Predicate Correlation
To understand the effect of correlation of UDFs in a query, we
leveraged the Twitter dataset and 20 test queries with two or three
predicates. The queries were divided by their correlation score ˆ𝜅2 at
a cutoff score of 0.2. As a result, each query was classified as weakly
or strongly correlated among the predicates according to ˆ𝜅2. Table 3
shows the correlation scores of these queries. We collected the
execution costs of these weakly and strongly correlated queries with
a query accuracy A = 90%. We ran these queries using ORIG, NS,
PP, and CORE to generate optimal plans, and tested the execution
cost of an optimal plan by executing the plan on a sample of data.
Figure 9 shows the execution costs. From Figure 9, we can see
that (i) NS, PP, and CORE reduced the execution cost compared to
ORIG, and (ii) compared to PP, CORE reduced the execution cost
more on strongly correlated queries than weakly correlated queries.
In general, NS improved over ORIG using cheap filters to quickly
discard irrelevant inputs, and PP further boosted the performance
by decomposing the filters according to the predicate clauses. Note
that there was still room for improvements for queries with more
correlations and CORE filled this gap as expected.
𝑞′
1
𝑞′
2
𝑞′
3
𝑞′
4
𝑞′
5
𝑞′
6
𝑞′
7
𝑞′
8
𝑞′
9
𝑞′
10
Weak
0.15
0.15
0.15
0.15
0.16
0.16
0.16
0.16
0.16
0.16
𝑞1
𝑞2
𝑞3
𝑞4
𝑞5
𝑞6
𝑞7
𝑞8
𝑞9
𝑞10
Strong
0.55
0.41
0.55
0.42
0.41
1.00
0.80
0.96
0.80
0.93
Table 3: The correlation scores for ten strongly correlated queries
𝑞1 ∼𝑞10 (marked as “Strong”) and ten weakly correlated queries
𝑞′
1 ∼𝑞′
10 (marked as “Weak”) on the Twitter dataset.
      Weak Correlation
      Strong Correlation
0
10
20
30
40
50
60
Execution Cost (ms/record)
ORIG
NS
PP
CORE
Figure 9: Average execution costs over two sets of queries 𝑞1 ∼𝑞10
and 𝑞′
1 ∼𝑞′
10 with strong and weak correlations, respectively.
6.3
Time Reduction of CORE
To study the performance improvements of CORE over existing
solutions, we tested the total times of strongly correlated queries
with A = 90% on the three datasets. For query optimization to
generate an optimal query plan, we used 0.34% of the input data on
the Twitter dataset, 0.84% of the input data on the COCO dataset,
and 14.86% of the input on the UCF101 dataset (due to its smaller
size). After generating the optimal plan, we ran it on the rest of the
input. The total time included the optimization time and the time
of processing all the records. We used the same setting for NS and
PP, which built proxy models online.
ORIG
NS
PP
CORE
0
200
400
600
800
1000
1200
1400
Total Time (min)
ORIG
NS
PP
CORE
(a) Total time (Twitter).
NS
PP
CORE
0%
10%
20%
30%
40%
50%
Total Time Reduction
(b) Time reduction (Twitter).
ORIG
NS
PP
CORE
0
100
200
300
400
500
Total Time (min)
ORIG
NS
PP
CORE
(c) Total time (COCO).
NS
PP
CORE
0%
10%
20%
30%
40%
50%
60%
Total Time Reduction
(d) Time reduction (COCO).
ORIG
NS
PP
CORE
0
50
100
150
200
Total Time (min)
ORIG
NS
PP
CORE
(e) Total time (UCF101).
NS
PP
CORE
0%
10%
20%
30%
40%
Total Time Reduction
(f) Time reduction (UCF101).
Figure 10: The total time over ten queries for each dataset using
CORE and baseline approaches. A = 90%. For (a), (c), and (e), we show
the 1𝑠𝑡and 99𝑡ℎpercentiles on the bars and 1𝑠𝑡quartile, median, and
3𝑟𝑑quartile on the boxes. For (b), (d) and (f), we present the average
total time reductions relative to ORIG.
Figures 10a, 10c and 10e show the total times of ten queries
in each dataset, and Figures 10b, 10d and 10f show the average
total-time reductions for the ten queries using NS, PP, and CORE
compared to ORIG. We also presented the total time of each indi-
vidual query in the Twitter dataset in Figure 11. These results show
that CORE had a better performance than the baseline approaches
in general. Specifically, CORE achieved up to a 61% reduction on
the Twitter dataset compared to ORIG. For NS and PP, the reduc-
tions were about 44% and 50%, respectively. We observe similar
reductions on other datasets as well. For example, on the COCO
dataset, CORE had a reduction of up to 73% compared to ORIG,
while NS and PP achieved a reduction of 35% and 44%, respectively.
In addition, the average/variance correlation scores for strongly
correlated queries were 0.68/0.6 on the Twitter dataset, 0.99/0.01
on the COCO dataset, and 0.94/0.01 on the UCF101 dataset. As
discussed in Section 2.2, CORE achieved more gains over PP when
the queries had predicates with a stronger correlation.
6.4
Optimization Cost of CORE
To better understand the detailed optimization cost of CORE, we
collected the time to generate labeled samples, the time to train
classifiers, and the time of search frameworks for each query. The
10

---

q1
q2
q3
q4
q5
q6
q7
q8
q9
q10
0
200
400
600
800
1000
1200
1400
Total Time (min)
ORIG
NS
PP
CORE
Figure 11: The total time of each query in the Twitter dataset using ORIG, NS, PP, and CORE.
optimizer CORE used multiple threads to label training samples.
Each ML model processing unstructured texts used ten threads in
parallel. The YOLOv3 model and the image feature model used two
processes in parallel, and the activity recognition model used six
processes in parallel. During the phase of building proxy models, the
size of labeled sample 𝐿was empirically set to 1, 000. The training
set, testing set, and validation set were split in a 6:2:2 ratio. We also
re-sampled the training data to ensure a label balance. We used
scikit-learn to train a linear SVM classifier 𝑀on the labeled sample
for text analytic queries, and used keras to train a shallow NN
classifier for analytic queries on images and videos. During training,
we leveraged a grid-search on the F1-score to decide the best set of
hyper-parameters and a cross-validation to train a classifier using
the set of hyper-parameters. Additionally, a hill climbing search
framework was adopted to find an optimal solution.
Labeling Training Searching
QO
QO
Total Total Time
Dataset
ID
#preds
Time
Time
Time
Time
Time
Time Reduction
(min)
(min)
(min)
(min)
pct.
(min)
(%)
Twitter
q1
2
0.93
0.10
0.17
1.20
0.16%
763
45.56
Twitter
q2
2
1.22
0.09
0.14
1.46
0.25%
581
60.99
Twitter
q8
3
1.53
0.75
3.28
5.58
0.73%
764
44.77
Twitter
q10
3
1.76
0.75
2.93
5.47
0.77%
712
48.26
Twitter Avg.
2.5
1.84
0.44
2.61
4.91
0.70%
700
49.87
COCO Avg.
2
6.00
2.06
0.24
8.30
5.67%
173
66.07
UCF101 Avg.
2
23.40
0.08
0.20
23.68 21.80%
110
49.49
Table 4: Optimization costs and the total processing time for ten
queries over each dataset using CORE with A = 90%. The “labeling
time” is the time to generate labeled samples. The “training time”
is the time to train classifiers. The “searching time” is the elapsed
time for the search framework. The “QO time” is the total time of
the labeling, training and searching times. The “QO Time pct.” is
the percentage of the QO time over the total processing time. Total
Time Reduction = (ORIG-CORE)/ORIG.
Table 4 shows the results of the ten queries over each dataset,
including the time reduction compared to ORIG. On the Twitter
dataset, the optimization time was 0.70% of the total time, and the
total time reduction was 49.87% on the average. On the COCO
dataset, the optimization time was 5.67% of the total time, and the
total time reduction was 66.07% on the average. UCF101 was rela-
tively smaller, and 14.86% of the data was used for optimization. The
optimization time was 21.80% of the total time, and the total time
reduction was 49.49% on the average. Overall, the query optimiza-
tion cost of CORE was a small portion of the total processing time,
and it achieved significant performance improvement compared
to ORIG. When the dataset was small (e.g., the UDF101 dataset) or
queries had many ML operators and predicates (e.g., 𝑞8 and 𝑞10 on
the Twitter dataset), the query optimization costs were larger.
6.5
Effectiveness of CORE Components
CORE searched an optimal query plan in both the accuracy space
A and the order space H. We evaluated the effectiveness of differ-
ent components in CORE using two variants, namely CORE-a and
CORE-h. CORE-a represented the setting with the reordering step
disabled during optimization and constrained the search space to
solely A (Section 4). It used the input-query order and derived an
optimal set of accuracy values in A using Algorithm 1. CORE-h ap-
plied Algorithm 1, and exhaustively searched an optimal order in H
instead of performing the brand-and-bound pruning in Algorithm 2.
We ran ten queries for each dataset using CORE-a, CORE-h,
and CORE with A = 90%, and collected the execution costs for
optimized plans and the average optimization costs to generate
optimal plans. Figure 12 shows the results. We can see that CORE-a
had the worse execution cost compared to CORE because CORE-a
did not use the optimal order. CORE had similar execution costs to
CORE-h, but CORE-h had much larger query optimization costs.
Table 5, shows the average optimization cost including labeling,
training, and searching using CORE-a, CORE-h, and CORE. We
can see that CORE reduced the labeling, training and searching
times compared to CORE-h. This result indicated that the branch-
and-bound search algorithm in CORE successfully pruned some
nodes in the tree and reduced the optimization overhead. In gen-
eral, the branch-and-bound search algorithm found the optimal
order. Therefore, both the Algorithm 1 for A and Algorithm 2 for
H successfully accelerated the ML inference process.
Labeling
Training
Searching
QO
QO
Time
Time
Time
Time
Time
(min)
(min)
(min)
(min)
pct.(%)
CORE-a
1.37
0.15
1.78
3.30
0.38
CORE-h
6.51
0.57
4.69
11.78
1.74
CORE
1.84
0.44
2.61
4.91
0.70
Table 5: Optimization costs of CORE variants on the Twitter dataset.
6.6
Scalability
We evaluated the scalability of CORE by increasing the number of
records in the Twitter dataset. We started with 0.2 million tweets
and gradually increased the data size to 2 million tweets. We ran
the ten queries with A = 90% using ORIG, NS, PP, and CORE,
11

---

CORE-a
CORE-h
CORE
0
5
10
15
20
25
30
Execution Cost (ms/record)
(a) Execution cost (Twitter).
CORE-a
CORE-h
CORE
0
2
4
6
8
10
12
Optimization Cost (min)
(b) Optimization cost (Twitter).
CORE-a
CORE-h
CORE
0
20
40
60
80
100
120
140
Execution Cost (ms/record)
(c) Execution cost (COCO).
CORE-a
CORE-h
CORE
0
2
5
8
10
12
15
18
20
Optimization Cost (min)
(d) Optimization cost (COCO).
CORE-a
CORE-h
CORE
0
100
200
300
400
500
600
700
800
Execution Cost (ms/record)
(e) Execution cost (UCF101).
CORE-a
CORE-h
CORE
0
5
10
15
20
25
30
Optimization Cost (min)
(f) Optimization cost (UCF101).
Figure 12: The execution costs and average optimization costs for
queries over three datasets using CORE, CORE-a and CORE-h.
and collected the total processing times at different data sizes. Fig-
ure 13 shows the average total processing time using ORIG, NS,
PP, and CORE. We also presented the total times for two example
queries using CORE at different data sizes. The results show that
CORE scaled up well, and outperformed the other three baseline
approaches at all data sizes.
0.4
0.8
1.2
1.6
2.0
# of tweets (million)
0
200
400
600
800
1000
1200
1400
1600
Total Time (min)
ORIG
NS
PP
CORE
(a)
0.4
0.8
1.2
1.6
2.0
# of tweets (million)
0
100
200
300
400
500
600
700
800
Total Time (min)
q1
q2
(b)
Figure 13: (a) The average total processing time (including optimiza-
tion cost) using CORE, ORIG, NS, and PP on ten queries over the
Twitter dataset with different input sizes. (b) The total times of two
sample queries: 𝑞1 and 𝑞2, with different input sizes.
6.7
Effect of Query Accuracy
We evaluated the impact of the target accuracy A on CORE by
increasing A. We started from A = 90%, and linearly increased it to
A = 98%. We collected the execution costs of optimized plans for
the ten queries over the Twitter dataset using ORIG, NS, PP, and
CORE with different target accuracy values.
Figure 14a shows the average execution costs for the ten queries
using ORIG, NS, PP, and CORE. We also presented the execution
costs for three example queries using CORE with different target
accuracy values in Figure 14b. The results indicated that CORE out-
performed ORIG, NS, and PP in different accuracy settings. More-
over, the execution costs increased for all the baselines when the
target accuracy increased. In addition, Table 6 shows the percentage
of the query optimization time relative to the total processing time
in the same setting. Similar to the observations in Section 6.3, the
query optimization in CORE with different accuracy targets still
had a smaller overhead relative to the total processing time.
90
92
94
96
98
Query Accuracy (%)
0
5
10
15
20
25
30
35
Execution Cost (ms/record)
ORIG
NS
PP
CORE
(a)
90
92
94
96
98
Query Accuracy (%)
0
5
10
15
20
Execution Cost (ms/record)
q6
q4
q2
(b)
Figure 14: (a) The average execution costs of optimized plans for
ten queries over the Twitter dataset with different Avalues. (b) The
execution costs of three sample queries:𝑞2,𝑞4, and𝑞6, with different
target accuracies.
QO cost (min)
/ pct(%)
A = 90%
A = 92%
A = 94%
A = 96%
A = 98%
𝑞2
1.50/0.11
1.54/0.11
1.50/0.11
1.48/0.11
1.48/0.11
𝑞4
1.79/0.14
1.60/0.13
1.46/0.12
1.52/0.12
1.50/0.12
𝑞6
4.73/0.35
5.28/0.39
8.31/0.61
6.03/0.45
3.83/0.28
avg.
4.57/0.36
4.83/0.38
5.07/0.40
4.30/0.34
3.24/0.25
Table 6: The optimization costs for𝑞2,𝑞4 and𝑞6 with different target
accuracy parameters (A). Each cell contains the QO costs in minutes
and the percentage relative to the total query processing cost.
7
CONCLUSIONS
In this paper we proposed a novel query optimizer, CORE, to accel-
erate ML inference queries. It improved state-of-the-art techniques
by relaxing the assumption about independence of query predi-
cates. CORE uses a small computation overhead and leverages a
branch-and-bound searching algorithm for finding an optimal order
of proxy models with parameters for each predicate. It reduced the
overhead by reusing intermediate results during the proxy model
construction and pruning candidate plans. We conducted a thor-
ough experimental evaluation and showed that CORE significantly
reduced the ML inference execution cost.
12

---

REFERENCES
[1] Activity recognition. https://github.com/chen0040/keras-video-classifier.
[2] P. K. Agarwal, S. Har-Peled, and K. R. Varadarajan. Geometric approximation
via coresets. Combinatorial and computational geometry, 52:1–30, 2005.
[3] S. Babu, R. Motwani, K. Munagala, I. Nishizawa, and J. Widom. Adaptive ordering
of pipelined stream filters. In G. Weikum, A. C. König, and S. Deßloch, editors,
Proceedings of the ACM SIGMOD International Conference on Management of Data,
Paris, France, June 13-18, 2004, pages 407–418. ACM, 2004.
[4] S. Cai, G. Chen, B. C. Ooi, and J. Gao. Model slicing for supporting complex
analytics with elastic inference cost and resource constraints. Proceedings of the
VLDB Endowment, 13(2):86–99, 2019.
[5] Z. Cai, M. J. Saberian, and N. Vasconcelos. Learning complexity-aware cascades
for deep pedestrian detection. In 2015 IEEE International Conference on Computer
Vision, ICCV 2015, Santiago, Chile, December 7-13, 2015, pages 3361–3369. IEEE
Computer Society, 2015.
[6] S. Chaudhuri, B. Ding, and S. Kandula. Approximate query processing: No silver
bullet. In S. Salihoglu, W. Zhou, R. Chirkova, J. Yang, and D. Suciu, editors,
Proceedings of the 2017 ACM International Conference on Management of Data,
SIGMOD Conference 2017, Chicago, IL, USA, May 14-19, 2017, pages 511–519. ACM,
2017.
[7] S. Chaudhuri and K. Shim. Optimization of queries with user-defined predicates.
ACM Trans. Database Syst., 24(2):177–228, 1999.
[8] Correlative proxy models. https://github.com/ZhihuiYangCS/CorrProxies/wiki/
Queries-and-Datasets.
[9] I. S. Gradshteyn and I. M. Ryzhik. Table of integrals, series, and products. Academic
press, 2014.
[10] J. M. Hellerstein and M. Stonebraker. Predicate migration: Optimizing queries
with expensive predicates. In P. Buneman and S. Jajodia, editors, Proceedings of the
1993 ACM SIGMOD International Conference on Management of Data, Washington,
DC, USA, May 26-28, 1993, pages 267–276. ACM Press, 1993.
[11] B. Hilprecht, A. Schmidt, M. Kulessa, A. Molina, K. Kersting, and C. Binnig.
Deepdb: Learn from data, not from queries! arXiv preprint arXiv:1909.00607, 2019.
[12] K. Hsieh, G. Ananthanarayanan, P. Bodík, S. Venkataraman, P. Bahl, M. Philipose,
P. B. Gibbons, and O. Mutlu. Focus: Querying large video datasets with low
latency and low cost. In A. C. Arpaci-Dusseau and G. Voelker, editors, 13th
USENIX Symposium on Operating Systems Design and Implementation, OSDI 2018,
Carlsbad, CA, USA, October 8-10, 2018, pages 269–286. USENIX Association, 2018.
[13] N. Ihaddadene and C. Djeraba. Real-time crowd motion analysis. In 2008 19th
International Conference on Pattern Recognition, pages 1–4. IEEE, 2008.
[14] I. F. Ilyas, V. Markl, P. Haas, P. Brown, and A. Aboulnaga. Cords: automatic
discovery of correlations and soft functional dependencies. In Proceedings of
the 2004 ACM SIGMOD international conference on Management of data, pages
647–658, 2004.
[15] T. Joachims. Training linear svms in linear time. In Proceedings of the 12th ACM
SIGKDD international conference on Knowledge discovery and data mining, pages
217–226, 2006.
[16] D. Kang, P. Bailis, and M. Zaharia. Blazeit: Optimizing declarative aggregation
and limit queries for neural network-based video analytics. Proc. VLDB Endow.,
13(4):533–546, 2019.
[17] D. Kang, J. Emmons, F. Abuzaid, P. Bailis, and M. Zaharia. Noscope: Optimizing
deep cnn-based queries over video streams at scale. PVLDB, 10(11):1586–1597,
2017.
[18] D. Kang, E. Gan, P. Bailis, T. Hashimoto, and M. Zaharia. Approximate selection
with guarantees using proxies. Proc. VLDB Endow., 13(11):1990–2003, 2020.
[19] D. Kang, J. Guibas, P. Bailis, T. Hashimoto, and M. Zaharia. Task-agnostic indexes
for deep learning-based queries over unstructured data. CoRR, abs/2009.04540,
2020.
[20] W. H. Kohler and K. Steiglitz. Characterization and theoretical comparison of
branch-and-bound algorithms for permutation problems. Journal of the ACM
(JACM), 21(1):140–156, 1974.
[21] S. Krishnan, A. Dziedzic, and A. J. Elmore. Deeplens: Towards a visual data
management system. arXiv preprint arXiv:1812.07607, 2018.
[22] A. Kunft, A. Katsifodimos, S. Schelter, S. Breß, T. Rabl, and V. Markl. An interme-
diate representation for optimizing machine learning pipelines. Proceedings of
the VLDB Endowment, 12(11):1553–1567, 2019.
[23] Y. LeCun, Y. Bengio, and G. Hinton. Deep learning. nature, 521(7553):436–444,
2015.
[24] Y. LeCun, B. E. Boser, J. S. Denker, D. Henderson, R. E. Howard, W. E. Hubbard,
and L. D. Jackel. Handwritten digit recognition with a back-propagation network.
In Advances in neural information processing systems, pages 396–404, 1990.
[25] H. Li, Z. Lin, X. Shen, J. Brandt, and G. Hua. A convolutional neural network
cascade for face detection. In IEEE Conference on Computer Vision and Pattern
Recognition, CVPR 2015, Boston, MA, USA, June 7-12, 2015, pages 5325–5334. IEEE
Computer Society, 2015.
[26] X. Li, Z. Liu, P. Luo, C. C. Loy, and X. Tang. Not all pixels are equal: Difficulty-
aware semantic segmentation via deep layer cascade. In 2017 IEEE Conference
on Computer Vision and Pattern Recognition, CVPR 2017, Honolulu, HI, USA, July
21-26, 2017, pages 6459–6468. IEEE Computer Society, 2017.
[27] T.-Y. Lin, M. Maire, S. Belongie, J. Hays, P. Perona, D. Ramanan, P. Dollár, and
C. L. Zitnick. Microsoft coco: Common objects in context. In European conference
on computer vision, pages 740–755. Springer, 2014.
[28] J. D. Little, K. G. Murty, D. W. Sweeney, and C. Karel. An algorithm for the
traveling salesman problem. Operations research, 11(6):972–989, 1963.
[29] Y. Lu, A. Chowdhery, S. Kandula, and S. Chaudhuri. Accelerating machine learn-
ing inference with probabilistic predicates. In Proceedings of the 2018 International
Conference on Management of Data, pages 1493–1508. ACM, 2018.
[30] C. D. Manning, M. Surdeanu, J. Bauer, J. R. Finkel, S. Bethard, and D. McClosky.
The stanford corenlp natural language processing toolkit. In Proceedings of the
52nd Annual Meeting of the Association for Computational Linguistics, ACL 2014,
June 22-27, 2014, Baltimore, MD, USA, System Demonstrations, pages 55–60. The
Association for Computer Linguistics, 2014.
[31] V. N. Murthy, V. Singh, T. Chen, R. Manmatha, and D. Comaniciu. Deep decision
network for multi-class image classification. In 2016 IEEE Conference on Computer
Vision and Pattern Recognition, CVPR 2016, Las Vegas, NV, USA, June 27-30, 2016,
pages 2240–2248. IEEE Computer Society, 2016.
[32] Optimizing machine learning inference queries with correlative proxy models
(technical report). http://texera.ics.uci.edu/pdf/proxymodel/proxymodel-tech-
report.pdf.
[33] J. Redmon and A. Farhadi. Yolov3: An incremental improvement. arXiv, 2018.
[34] A. Rheinländer, U. Leser, and G. Graefe. Optimization of complex dataflows with
user-defined functions. ACM Comput. Surv., 50(3):38:1–38:39, 2017.
[35] K. Soomro, A. R. Zamir, and M. Shah. Ucf101: A dataset of 101 human actions
classes from videos in the wild. arXiv preprint arXiv:1212.0402, 2012.
[36] A. Toshev and C. Szegedy. Deeppose: Human pose estimation via deep neural net-
works. In 2014 IEEE Conference on Computer Vision and Pattern Recognition, CVPR
2014, Columbus, OH, USA, June 23-28, 2014, pages 1653–1660. IEEE Computer
Society, 2014.
[37] Twitter api. https://developer.twitter.com/en/docs/twitter-api.
[38] P. Viola and M. Jones. Rapid object detection using a boosted cascade of simple
features. In Proceedings of the 2001 IEEE computer society conference on computer
vision and pattern recognition. CVPR 2001, volume 1, pages I–I. IEEE, 2001.
[39] W. Wang, J. Gao, M. Zhang, S. Wang, G. Chen, T. K. Ng, B. C. Ooi, J. Shao, and
M. Reyad. Rafiki: machine learning as an analytics service system. Proceedings
of the VLDB Endowment, 12(2):128–140, 2018.
[40] X. Wang et al. IDK Cascades: Fast Deep Learning by Learning not to Overthink.
Preprint arXiv:1706.00885, 2017.
13

---

