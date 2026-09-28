# PairwiseHist: Fast, Accurate and Space-Efficient Approximate Query Processing wi

> 来源: https://arxiv.org/pdf/2401.12018

PairwiseHist: Fast, Accurate and Space-Efficient Approximate Query
Processing with Data Compression
Aaron Hurst, Daniel E. Lucani and Qi Zhang
DIGIT & Department of Electrical and Computer Engineering
Aarhus University, Denmark
{ah, daniel.lucani, qz}@ece.au.dk
January 23, 2024
Abstract
Exponential growth in data collection is creating signif-
icant challenges for data storage and analytics latency.
Approximate Query Processing (AQP) has long been
touted as a solution for accelerating analytics on large
datasets, however, there is still room for improvement
across all key performance criteria. In this paper, we
propose a novel histogram-based data synopsis called
PairwiseHist that uses recursive hypothesis testing to
ensure accurate histograms and can be built on top
of data compressed using Generalized Deduplication
(GD). We thus show that GD data compression can
contribute to AQP. Compared to state-of-the-art AQP
approaches, PairwiseHist achieves better performance
across all key metrics, including 2.6× higher accuracy,
3.5× lower latency, 24× smaller synopses and 1.5–4×
faster construction time.
1
Introduction
Rapidly advancing digital transformation is driving ex-
ponential growth in data volumes across many sectors.
This poses significant challenges for current infrastruc-
ture and data management solutions, which must han-
dle swelling data workloads increasingly advanced an-
alytics. Efficient data storage and analytics techniques
are therefore crucial.
Approximate Query Processing (AQP) is a well-
established field that focuses on enabling fast analyt-
ics on Big Data by sacrificing some degree of accu-
racy [1, 2].
AQP techniques are typically based on
either sampling or data synopses, or a hybrid of the
two [1, 3–5].
In general, small samples or compact
synopses enable analytics to be performed over large
datasets within required latency constraints. However,
all AQP approaches exhibit a distinct trade-off between
accuracy, latency and synopsis size.
In this paper, we propose a novel histogram-based
data synopsis for AQP called PairwiseHist that consists
Latency
Accuracy
Query bounds
Construction
time
Total storage
requirements
Synopsis size
PairwiseHist
DeepDB
DBEst++
Figure
1:
Relative
performance
comparison
of
PairwiseHist, DeepDB and DBEst++ summarising
Figs. 8, 10 and 11 and Table 6. Outer rings indicate
better performance. Each interval represents approxi-
mately 2× improvement.
of three key components: i) one-dimensional histograms
that capture within-column data distributions, ii) two-
dimensional histograms that capture relationships be-
tween each pair of columns (hence, PairwiseHist), and
iii) small metadata for each histogram bin that enhance
query precision, including the minimum, maximum
and number of unique values.
By using histograms,
PairwiseHist inherits desirable properties including ac-
curate query bounds and effective outlier recall, while
the small number of histograms minimises synopsis size.
All histograms within PairwiseHist are constructed us-
ing recursive hypothesis testing that ensures each bin
contains uniformly distributed data, leading to high
query accuracy. Low query execution latency is realised
by novel methods for resolving multi-predicate queries
that require only a few relatively small matrix multi-
plications. Overall, PairwiseHist delivers all-round su-
perior performance across accuracy, latency, synopsis
size, synopsis construction time and query bounds com-
1
arXiv:2401.12018v1  [cs.DB]  22 Jan 2024

---

pared to state-of-the-art AQP techniques, as illustrated
in Fig. 1.
PairwiseHist takes inspiration from recent works in
data compression that demonstrate (approximate) data
clustering can be performed directly on compressed
data without decompression [6–8]. That is, by using
Generalized Deduplication (GD) data compression [9–
12], part of the compressed data known as bases can
serve as a data synopsis on which analytics tasks can be
performed efficiently. Compared to GD bases, Pairwise-
Hist significantly reduces storage requirements and im-
proves accuracy by using low-dimensional histograms
with variable precision.
While PairwiseHist is a stand-alone AQP technique
in its own right, we also propose implementing it along-
side data compression, as illustrated in Fig. 2. Specif-
ically, we use GreedyGD [8], a recent version of GD,
which is a lossless data compression algorithm that of-
fers state-of-the-art compression ratios and low random
access cost. While originally designed for IoT, GD has
also proved effective in several other domains [8, 13–16].
In our proposed AQP framework, GreedyGD both re-
duces overall storage requirements and accelerates syn-
opsis construction.
Due to its small synopsis size and low query la-
tency, our approach also enables Edge analytics, even
on resource-constrained devices. This comes with many
benefits, including low (communication) latency, scal-
ability, privacy, energy savings and mobility [17–19].
Meanwhile, PairwiseHist’s fast construction and low
storage requirements reduce Cloud storage and com-
puting costs and enable more frequent updates.
In summary, the key contributions of this paper in-
clude:
1. A novel histogram-based AQP technique called
PairwiseHist that uses a combination of one- and
two-dimensional histograms and an efficient stor-
age encoding to deliver data synopses that are 24×
smaller and up to 4× faster to construct than
state-of-the-art AQP methods DeepDB [20] and
DBEst++ [21],
2. Query execution techniques for seven common ag-
gregation functions that deliver at least 2.6× bet-
ter accuracy (0.28% median error vs. 0.73–28.9%),
3.5× lower latency and more accurate bounds than
the state-of-the-art,
3. A novel AQP framework that integrates data com-
pression to reduce overall storage requirements by
up to 4.3×, and
4. A
comprehensive
performance
evaluation
of
PairwiseHist in comparison to the state-of-the-art
across 11 real-world datasets and two datasets
scaled-up using IDEBench [22].
The remainder of this paper is structured as follows.
Section 2 describes related work. Section 3 provides our
system overview. Section 4 outlines the PairwiseHist
data structure and construction algorithm. Section 5
defines the theory and mathematical formulations for
query execution. Section 6 evaluates the performance
of PairwiseHist. Finally, Section 7 concludes the paper.
2
Related Work
AQP
methods
are
typically
classified
as
either
sampling-based or synopses-based [2].
Sampling ap-
proaches can be either offline or online [23].
Online
methods select samples at query time and attempt to
minimise the amount of data that must be accessed to
achieve a desired accuracy.
Gapprox [24], for exam-
ple, uses cluster sampling to reduce processing. Offline
approaches, on the other hand, attempt to prepare in
advance the most representative sample for the most
queries. For example, Babcock et al. [25] use biased
sampling and BlinkDB [26] uses stratified sampling.
More recent offline sampling work has focused on addi-
tional features, such as integration middleware [5] and
increasing sample re-usability [27]. However, sampling
methods generally struggle with skewed data and may
support limited aggregation functions [1].
Synopsis-based approaches focus on building a com-
pact summary of the data using statistical or machine
learning techniques. Histograms are a classical synopsis
approach that is widely used in selectivity estimation,
which involves estimating the number of tuples that a
query will access. This is an important step in database
query optimisers and is equivalent to AQP for COUNT
queries.
Many histogram algorithms exist, including
simple equi-width and equi-depth histograms, as well as
advanced methods, such as V-optimal histograms [28],
entropy-based histograms [29] and others [30–32]. Most
approaches, however, are limited to one dimension.
Multi-dimensional histograms are notoriously challeng-
ing to construct and their storage scales exponentially
with the number of dimensions [33, 34].
Nonethe-
less, some multi-dimensional histograms for selectiv-
ity estimation are available, including DigitHist [35],
DMMH [34] and STHoles [36]. To avoid the pitfalls of
high dimensionality, DigitHist uses lossy compression,
DMMH uses density modelling and STHoles uses pre-
vious query results. Cormode et al. [33] also discuss
using collections of histograms, which is the approach
we have taken with PairwiseHist. Common to all his-
tograms is that accuracy depends on ensuring a uniform
distribution of tuples within each bin. To the best of
our knowledge, our approach is the first to utilise hy-
pothesis testing for this purpose.
Most recent synopsis-based AQP works focus on ma-
chine learning. These can be classified as either genera-
tive, which create synthetic data for evaluating queries,
2

---

SQL Parser
Weightings
Aggregation
Transform
GreedyGD Pre-processor
PairwiseHist
2-d histograms
1-d histograms
Metadata:
• Bin edges & centre
• Min & max values
• Bin count
• Unique value count
Compressed Data
GreedyGD
Deviations
Bases
New data
0.3,AB,. . .
Database
SELECT AVG(delay) FROM . . .
109.3
Figure 2: Our proposed AQP framework with compression, including data ingestion and PairwiseHist construction
(black arrows), query execution (blue) and data updates (red).
or inferential, which directly predict AQP results [37].
In [38, 39], a generative model that captures the joint
probability distribution of a database using Mixed Sum-
Product Networks (MSPNs) is proposed.
This ap-
proach can evaluate simple queries directly using the
MSPN weights or generate (synthetic) samples to an-
swer more complex queries. While this provides high
accuracy, low latency and compact summaries, it re-
quires significant construction time (hours for just 106
samples).
DeepDB [20] proposes Relational Sum Product Net-
works (RSPNs), which are purely inferential and extend
(M)SPNs to support multiple database tables, complex
queries and model updates.
In comparison to [38],
DeepDB achieves much faster construction, but has
poor latency with multi-predicate queries, higher stor-
age requirements and can give imprecise bounds. Our
evaluation also revealed that DeepDB does not support
OR relationships between predicates, despite claiming
to, and performs poorly on real-world data.
DBEst [40] is an inferential approach that uses a
combination of model types.
Kernel density estima-
tors model individual columns, while regression models
capture relationships between pairs of columns. This
is similar to PairwiseHist with the density and regres-
sion models corresponding to one- and two-dimensional
histograms, respectively.
A significant limitation of
DBEst is that a new model is required for every query
template, which limits flexibility and exponentially in-
creases synopsis storage requirements.
DBEst++ [21] improves DBEst by switching to mix-
ture density networks for both regression and density
modelling. This significantly reduces storage require-
ments, delivers better accuracy and latency, and sup-
ports data updates.
However, storage requirements
for DBEst++ are misleading due to each model tem-
plate requiring its own model. Our tests also revealed
that DBEst++ does not support queries involving more
than two columns, OR relationships between predi-
cates, queries on only categorical columns or inequality
predicates on date/time columns.
Other
machine
learning
approaches
include
LAQP
[41],
which
combines
an
error
prediction
model with sampling, Electra [42], which focuses on
queries with many-predicates, NeuroSketch [43], which
is a bounded inferential model trained on queries, and
Generative Adversarial Networks [44]. Typically, ma-
chine learning methods are constructed from samples
and exhibit similar limitations as sampling-based AQP
methods, namely vulnerability to skewed data and
limited aggregation function support.
A small number of unified approaches that com-
bine online sampling and synopses have also been pro-
posed. For example, AQP++ [4] generates a set of pre-
computed aggregations known as a prefix cube and an-
swers queries by supplementing relevant prefix cube ele-
ments with sampling. A similar approach has also been
proposed for selectivity estimation [45]. More recently,
[3] proposed PASS, which has a more flexible synopsis
design, reminiscent of DigitHist [35], that consists of a
hierarchical set of pre-computed aggregates at different
resolutions that guide online stratified sampling. Un-
like other sampling-based approaches, PASS provides
both probabilistic and deterministic bounds. However,
a significant limitation is nearly 30× slower construc-
tion than AQP++ [3], which itself requires over 20 min-
utes for just a 50 MB sample [4].
Many AQP approaches provide query error bounds,
which give analysts an indication of the confidence that
they can place in AQP results. Bounds are typically
based on probabilistic confidence intervals [1, 46], but
can also be deterministic [24, 26, 47]. Unfortunately,
probabilistic bounds can often be incorrect [48] while
deterministic bounds may be too broad to be useful.
The overall performance of state-of-the-art AQP
techniques is summarised in Table 1, in which versatil-
3

---

Table 1: PairwiseHist compared to previous AQP works.
Accuracy Latency Bounds
Size
Build
Versatility
PairwiseHist
<1%
sub-ms
yes
sub-MB
secs
very high
VerdictDB [5]
1%
seconds
yes
GBs
?
very high
Gapprox [24]
<5%
seconds
yes
n/a
n/a
low
BlinkDB [26]
<10 %
seconds
yes
GBs
n/a
high
DigitHist [35]
1%
sub-ms
yes
MBs
mins
very low
DMMH [34]
1–2%
ms
no
sub-MB
secs
very low
STHoles [36]
10%
?
no
sub-MB
?
very low
DeepDB [20]
1%
ms
yes
MBs
mins
high
DBEst++ [21]
1%∗
ms
no
MBs
hours
low
NeuroSketch [43]
5%
sub-ms
yes
sub-MB
mins
very high
LAQP [41]
10%
ms
no
sub-MB
?
very high
Electra [42]
10%
?
no
?
?
low
PASS [3]
<1%
ms
yes
MBs
mins
high
AQP++ [4]
<1%
seconds
yes
MBs
mins
high
“?” indicates not reported by the authors. ∗Much larger error observed in practice.
ity refers to the variety of supported query templates.
As can be seen, PairwiseHist delivers comprehensively
superior performance. Moreover, by using data com-
pression, it uniquely offers significant overall storage
reduction.
3
System Overview
Problem Definition. Consider a dataset D with N
rows and d attributes X1, . . . , Xd and queries of the
form:
SELECT F(Xi) FROM D WHERE P1 AND/OR P2 . . .
GROUP BY . . . ;
where F
is an aggregation function (e.g.
AVG),
P1, P2, . . .
are
predicate
conditions
of
the
form
“Xj OP LITERAL”, where OP is a binary logical op-
erator (i.e., <, >, ≤, ≥, =
or̸
=) and LITERAL is a
valid value for column Xj, and GROUP BY can be
applied to any categorical column. It is assumed that
D is large enough such that exact query execution is
prohibitively expensive. Therefore, the task is to de-
sign a framework such that bounded approximate query
results can be obtained with high accuracy and low
latency, while minimising synopsis size, synopsis con-
struction time and overall storage requirements. Miss-
ing values must also be supported.
Data Compression. In our proposed AQP frame-
work, PairwiseHist is applied on top of compressed
data, which reduces storage requirements. As shown in
Fig. 2, GreedyGD compresses incoming data, which in-
cludes pre-processing to improve compressability. Pre-
processing is applied to each column independently
based on its data type and includes minimum value
subtraction, floating point to integer conversion (e.g.
10.22 to 1022), frequency-ranked categorical value en-
coding (i.e., most common encoded as 0, second most
as 1, etc.) and encoding missing values. Importantly,
pre-processing does not require additional storage or
memory and datasets can be processed in arbitrarily-
sized batches, which allows processing of datasets that
are too large to fit in memory.
GreedyGD splits data chunks into bases and devia-
tions. Bases contain the majority of the information
and are deduplicated, while deviations are stored ver-
batim with IDs linking them to the appropriate bases,
as illustrated in Fig. 3. Compression is achieved when
there are few bases compared to the number of data
chunks. In our framework, a chunk corresponds to a
row in a relational database table and bases contain the
most significant bits from each attribute. New rows can
be added incrementally to the compressed data.
PairwiseHist.
Once the data is compressed,
PairwiseHist is built on top of the compressed data
by taking (a sample of) the bases as input for the ini-
tial histogram bin edges. The histograms are then re-
fined using hypothesis testing to ensure that the dis-
tributions of tuples within individual bins are approx-
imately uniform. This process is described in detail in
Section 4. As illustrated in Fig. 2, PairwiseHist con-
sists of one-dimensional histograms for each column,
two-dimensional histograms for every pair of columns
and various metadata for each histogram bin.
This
collection of histograms enables rapid query aggrega-
tion on any column subject to arbitrary combinations
of predicate conditions.
Furthermore, compared to
a na¨ıve multi-dimensional histogram, for which stor-
age increases exponentially with the number of dimen-
sions [34], our approach reduces storage requirements
4

---

chunk 1
chunk 2
chunk 3
. . .
chunk n
Data
base 1
base 2
base 1
. . .
base 2
dev 1
dev 2
dev 3
. . .
dev n
Bases & Deviations
base 1
base 2
. . .
[1]
[2]
[1]
. . .
[2]
dev 1
dev 2
dev 3
. . .
dev n
Deduplicated
Figure 3: GD splits data into bases and deviations.
Table 2: Notations
Construction
d
No. columns in the dataset
N
No. rows in the dataset
Ns
No. samples used to construct PairwiseHist
ρ
PairwiseHist sampling ratio, Ns/N
M
Minimum points for bins to be split
α
Significance level for hypothesis tests
Histograms
k(i)
No. histogram bins in column i
e(i)
Bin edges for column i
H(i)
Bin counts matrix for column i
v(i)±
Bin minimum and maximum values for column i
c(i)
Bin midpoints for column i
c(i)±
Bin weighted centre bounds for column i
u(i)
No. unique values in each bin for column i
Hypothesis
∆
Bin width
δ
Sub-bin width
s
No. sub-bins in a given bin
ℏ
Sub-bin count
Queries
β
Bin coverage
w
Bin weightings
a
No. sub-bins fully covered by a query
b
No. sub-bins fully or partially covered by a query
t∗
Bin index of query result (MEDIAN/MIN/MAX)
from O(kd) to O(d2k2) for d dimensions and k bins per
dimension. A compact storage encoding for Pairwise-
Hist is also proposed in Subsection 4.3.
PairwiseHist can also support multi-table databases.
That is, queries across different tables can be re-
solved via two-dimensional histograms involving the
primary/foreign keys. However, in this paper we focus
on single-table queries.
If PairwiseHist is used independently of GreedyGD,
then histograms are constructed from scratch (i.e.,
without using bases as initial bin edges), with slightly
longer synopsis construction time due to less precise
initial conditions.
4
PairwiseHist
PairwiseHist generates its collection of histograms by
recursively refining (i.e., splitting) an initial set of his-
togram bins using hypothesis testing, which ensures
that data points within individual bins are sufficiently
uniformly distributed. Refinement is terminated when
a bin is either uniform or has too few points to be split
further. PairwiseHist is thus parameterised by the min-
imum number of points required for a bin to be split, M,
the hypothesis test significance level, α, and the number
of samples used to construct PairwiseHist, Ns. Before
describing PairwiseHist in detail, this section provides
an overview of the key notation, which is summarised
in Table 2.
Bin edges for one-dimensional histograms are de-
noted by the vector e(i) =
D
e(i)
1 , e(i)
2 , . . . , e(i)
k(i)
E
, where
the superscript (i) indicates the column to which the
histogram applies and k(i) denotes the number of bins
for the one-dimensional histogram for column i. For
two-dimensional histograms, the bin edges for columns
i and j are denoted e(i|j) and e(j|i), respectively. This
superscript notation for two-dimensional histograms,
(i|j) and (j|i), indicates the fact that two-dimensional
histograms may have additional bin edges in either
or both dimensions compared to one-dimensional his-
tograms due to additional refinement. One-dimensional
histogram bin counts are denoted by the k(i)×k(i) diag-
onal matrix H(i) where the diagonal elements contain
the bin counts. That is:
H(i) =


h(i)
1
0
· · ·
0
0
h(i)
2
· · ·
0
...
...
...
...
0
· · ·
0
h(i)
k(i)


(1)
where h(i)
t
denotes the bin count for bin t.
Two-
dimensional histogram bin counts are similarly denoted
by the k(i|j) × k(j|i) matrix H(ij).
In this case, off-
diagonal values may be non-zero.
PairwiseHist stores various metadata for each bin,
namely: 1) minimum and maximum actual data val-
ues, v(i)−
t
and v(i)+
t
; 2) the bin midpoint, c(i)
t , which is
equidistant between the minimum and maximum val-
ues; 3) bounds on the weighted centre of the data points
within the bin, c(i)−
t
and c(i)+
t
; and 4) the unique count,
u(i)
t , which is the number of unique values in the bin.
Note that for two-dimensional histograms, each of these
metadata apply to both dimensions, as illustrated in
Fig. 4.
In this paper, vectors are indicated by bold lower case
letters and matrices by bold upper case letters. The L1
norm is denoted by ∥·∥1, the vector dot product by
5

---

2-d histogram: H(ij)
k(j|i)
k(i|j)
2-d Bin: h(ij)
titj
e(i|j)
ti+1
e(i|j)
ti
e(j|i)
tj
e(j|i)
tj+1
v(i|j)+
ti
v(i|j)−
ti
v(j|i)+
tj
v(j|i)−
tj
c(j|i)
tj
c(i|j)
ti
Figure 4:
Notation for two-dimensional histograms
with bin counts matrix H(ij) and individual bin count
h(ij)
titj.
x·y, Hadamard (element-wise) multiplication by x⊙y
and Hadamard division by x ⊘y. We also use specific
index variables for specific purposes. That is, i and j
are used for column indices within a dataset, t is used
for histogram bins and r is used for sub-bins. The terms
column and dimension are used interchangeably, as well
as tuple and data point.
The following subsections describe PairwiseHist con-
struction (Subsection 4.1), bin weighted centre bounds
(Subsection 4.2) and PairwiseHist storage (Subsec-
tion 4.3).
4.1
Histogram construction
PairwiseHist construction is outlined in Algorithm 1,
which consists of three sections: 1) extract a sample
D of size Ns from dataset D (line 1), 2) iterate over
each column to generate one-dimensional histograms
(lines 3–11), and 3) iterate over each pair of columns to
generate two-dimensional histograms (lines 13–26).
One-dimensional histograms are generated by first
selecting initial bin edges, ˆe, using either the bases
from GreedyGD (downsampled to at most ⌈Ns/M⌉)
or just the min and max values of the relevant col-
umn (line 4).
Each initial bin is then refined using
RefineBin1D (lines 6–9), which determines whether a
bin should be split or not based on a hypothesis test.
The one-dimensional histograms are finalised by com-
puting the midpoints, weighted centre bounds and bin
counts (using a standard histogram function, denoted
Hist) in lines 10–12.
RefineBin1D is described in detail in Algorithm 2.
This is a recursive algorithm that checks whether a
given bin needs to be split, i.e., if the distribution of
data points within the bin is not sufficiently uniform. If
so, it splits the bin and calls itself on the two newly cre-
ated splits, denoted by L and R. We tested both equal-
width (split at bin midpoint) and equal-depth (split at
median) approaches and found equal-width to perform
slightly better. Bins will not be split if they are empty
(line 3), have only one unique value (line 5) or have too
few data points (line 7). RefineBin1D returns the upper
edges from the original bin and all new splits, as well as
the bin minimum(s), maximum(s) and unique count(s).
Two-dimensional histograms are constructed using
an inner loop in BuildPairwiseHist (line 14) that iterates
over all columns previously iterated over by the outer
loop (line 2), thereby covering all pairs of columns. For
each column pair, an initial histogram is created using
bin edges from the corresponding one-dimensional his-
tograms (lines 15–16). This histogram is then refined
by applying RefineBin2D to each bin with at least M tu-
ples (lines 17–21). RefineBin2D is the two-dimensional
analogue of RefineBin1D and performs a hypothesis test
for uniformity on each column separately. In the case
where both columns are non-uniform, the split is ap-
plied to the least uniform column. Note that any bin
splits created by RefineBin2D apply only to the cur-
rent column pair.
That is, if a split is applied to
bin ti in the (ij)th histogram, it does not affect any
other histograms involving column i.
However, the
split does apply to all bins with the same bin index
ti in the (ij)th histogram. Fig. 5 provides an illustra-
tion of the two dimensions bin refinement process. The
two-dimensional histograms are completed by calculat-
ing the bin counts, minimums, maximums, midpoints,
weighted centre bounds and unique counts (lines 22–
26).
Hypothesis testing in both RefineBin1D and Refine-
Bin2D is performed using the function IsUniform.
Specifically, a chi-squared test is performed against the
null hypothesis that data points in the given bin are
uniformly distributed between the bin edges. That is,
the bin is divided into a number of sub-bins and the
number of points in each sub-bin is compared to the
expected number under the null hypothesis. The ap-
propriate number of sub-bins, s, is determined using
the Terrell-Scott inequality [49] as follows:
s =
l
(2u)1/3m
.
(2)
The test statistic is then:
χ2 =
s−1
X
r=0
 ℏr −ˆℏ
2
ˆℏ
,
(3)
where ˆℏ= h/s is the expected sub-bin count under
the null hypothesis and ℏr is the actual count for the
rth sub-bin.
The critical value, χ2
α, is then defined
such that Pr
 χ2 > χ2
α

= α and the null hypothesis is
rejected (and the bin split) if χ2 > χ2
α.
Notably, PairwiseHist construction is highly paral-
lelisable, since each histogram and bin refinement can
be computed independently, provided one-dimensional
histograms are constructed first.
4.2
Bin weighted centre bounds
To improve query bounds, PairwiseHist stores weighted
centres bounds for each histogram bin. The value of
6

---

Algorithm 1 BuildPairwiseHist
Inputs: dataset D, sample size Ns, minimum points M, hypothesis test signifi-
cance α, initial bin edges E0 (optional)
Outputs: PairwiseHist data structure
1: D ←downsample D to Ns rows
2: for i = 1, 2, . . . , number of columns in D do
3:
// 1-d histograms
4:
ˆe(i) ←downsample E(i)
0
to ⌈Ns/M⌉values, else min/max of D(i)
5:
e(i), v(i)−, v(i)+, u(i) ←⟨ˆe(i)
0 ⟩, ∅, ∅, ∅
// initialise
6:
for t = 1, 2, . . . , size of ˆe(i) −1 do
// loop over initial bins
7:
xt ←elements of D(i) between of ˆe(i)
t
and ˆe(i)
t+1
8:
e(i)
new, v(i)−
new , v(i)+
new , u(i)
new ←RefineBin1D
 ˆe(i)
t , ˆe(i)
t+1, xt, M, α

9:
Append e(i)
new, v(i)−
new , v(i)+
new , u(i)
new to e(i), v(i)−, v(i)+, u(i)
10:
c(i) ←
 v(i)+ + v(i)−
/2
11:
c−(i), c+(i) ←bin centre bounds (Eq. 10)
12:
H(i) ←Hist
 D(i), e(i)
13:
// 2-d histograms
14:
for j = 1, 2, . . . , i −1 do
// all columns before i
15:
e(i|j), e(j|i) ←e(i), e(j)
// initial 2-d bin edges
16:
H(ij) ←Hist(D(ij), e(i|j), e(j|i))
// initial 2-d bin counts
17:
for each bin (ti, tj) in H(ij) where htitj > M do
18:
Xti,tj ←elements of D(ij) within bin (ti, tj)
19:
e(i|j)
new , e(j|i)
new ←RefineBin2D(e(i|j)
ti
, e(i|j)
ti+1, e(j|i)
tj
, e(j|i)
tj+1, Xti,tj , M, α)
20:
Insert e(i|j)
new into e(i|j) after index ti
21:
Insert e(j|i)
new into e(j|i) after index tj
22:
H(ij) ←Hist(D(ij), e(i|j), e(j|i))
// refined 2-d bin counts
23:
v(i|j)−, v(j|i)−, v(i|j)+, v(j|i)+ ←min/max values in each bin
24:
c(i|j), c(j|i) ←(v(i|j)+ + v(i|j)−)/2, (v(j|i)+ + v(j|i)−)/2
25:
c−(i|j), c+(i|j), c−(j|i), c+(j|i) ←bin centre bounds (Eq. 10)
26:
u(i|j), u(j|i) ←number of unique values in each bin
Algorithm 2 RefineBin1D
Inputs: bin lower edge eL, bin upper edge eR, vector of data values x within the
bin, minimum points M, significance α
Outputs: upper bin edges e∗, bin minimum values v−, bin maximum values v+,
bin unique counts u
1: U ←unique values in x
2: NU ←number of elements in U
3: if x is empty then
4:
return ⟨eR⟩, ⟨eL⟩, ⟨eR⟩, ⟨0⟩
5: else if NU = 1 then
6:
return ⟨eR⟩, ⟨U0⟩, ⟨U0⟩, ⟨1⟩
7: else if fewer than M tuples in x or IsUniform(x, eL, eR, NU, α) then
8:
return ⟨eR⟩, ⟨min(U)⟩, ⟨max(U)⟩, ⟨NU⟩
9: else
10:
z ←select split point
11:
xL, xR ←split x at z
12:
e∗
L, v−
L , v+
L , uL ←RefineBin1D(xL, eL, z, M, α)
13:
e∗
R, v−
R, v+
R, uR ←RefineBin1D(xR, z, eR, M, α)
14:
return ⟨e∗
L, e∗
R⟩, ⟨v−
L , v−
R⟩, ⟨v+
L , v+
R⟩, ⟨uL, uR⟩
the weighted centre bounds depends on whether bins
passed the hypothesis test or not. For bins that did
not pass, the only available information on their in-
ternal data distribution is that they contain h data
points, u unique values and extrema v−and v+.
In
this case, weighted centre bounds occur when h −u + 1
points are at an extrema and one point is at each of the
other unique values, which are assumed to be as close
to the extrema as possible, i.e., with minimum spacing
for the given data type, denoted µ. Conversely, the in-
ternal distribution of bins that pass the hypothesis test
is known to be approximately uniform with respect to
7

---

(a)
(b)
(c)
(d)
(e)
(f)
Figure 5: Illustration of two-dimensional bin refine-
ment: (a) original data; (b) first bin is uniformly dis-
tributed (green); (c) second bin is non-uniformly dis-
tributed (red) in both dimensions, but less uniform in
the vertical dimension, so a new split is added to all
bins in the same column; (d) one of the resulting sub-
bins is non-uniform in the vertical dimension, so a new
split is added; (e) the resulting sub-bins are uniform
(green) or contain fewer than M points (gray), no fur-
ther splits; (f) both sub-bins from the third original bin
contain fewer than M points, no further splits.
a given number of sub-bins. This fact can be used to
derive tighter bounds, as shown in Theorem 1. Pass-
ing and non-passing bins can be distinguished by their
bin count, which is at least M for passing bins and less
than M for non-passing bins.
Theorem 1. Consider a bin with count h, minimum
value v−, maximum value v+ and u unique values. As-
sume this bin satisfies the hypothesis test in IsUniform
with s =

(2u)1/3
sub-bins and critical value χ2
α. Let
δ = (v+ −v−)/s be the sub-bin width. The bounds for
the weighted centre of the points within the bin are then
c± = v−+ (s ± 1)δ
2
± δ
6
r
3χ2α(s2 −1)
h
.
(4)
Proof. The lower bound occurs when all points are at
the lower edge of their respective sub-bins and can be
expressed as follows:
c−= 1
h
s−1
X
r=0
ℏr(v−+ rδ).
(5)
where ℏr is the count for the rth sub-bin.
Sub-bin
counts can be expressed in terms of the expected sub-
bin count plus an epsilon term, i.e., ℏr = h/s + ϵr.
Substituting this into Eq. 5 gives:
c−= v−+ δ(s −1)
2
+ δ
h
s−1
X
r=0
rϵr.
(6)
This can be optimised using Lagrange Multipliers with
constraints:
s−1
X
r=0
ϵr = 0 and χ2
α =
s−1
X
r=0
(ℏr −h/s)2
h/s
= s
h
s−1
X
r=0
ϵ2
r.
(7)
The Lagrangian is then:
L(ϵr, λ1, λ2) = v−+ δ(s −1)
2
+ δ
h
s−1
X
r=0
rϵr
+ λ1
s−1
X
r=0
ϵr + λ2
 
χ2
α −s
h
s−1
X
r=0
ϵ2
r
!
.
(8)
Setting the partial derivative ∂L/∂ϵr equal to zero gives
ϵr = (rδ + hλ1)/2sλ2. Substituting this into the con-
straints in Eq. 7 and solving for λ1 and λ2 gives the
following expression for ϵr:
ϵr = ±2
s

r −s(s −1)
2
 r
3χ2αh
s2 −1.
(9)
Taking the negative solution and substituting this into
Eq. 6 gives the desired result. A similar approach can
be used for v+.
Thus, bin weighted centre bounds are as follows:
c± =
(
v± ∓(u−1)uµ
2h
,
h < M
v−+ (s±1)δ
2
± δ
6
q
3χ2α(s2−1)
h
,
otherwise.
(10)
4.3
Storage
To minimise PairwiseHist storage requirements, we ob-
serve that bin midpoints and weighted centre bounds
can easily be re-derived from other parameters and thus
need not be stored. Additionally, bin counts, which re-
quire the most storage, are stored sparsely when this is
more effective. For sparse encoding, we store the delta
between non-zero indices and encode using Golomb
coding, which is optimal for geometrically distributed
data. Fig. 6 provides an overview of the storage config-
uration. In total, the storage requirements are:
S = Sparams + S1-d hists + S2-d hists + Scounts
(11)
≤29 + d + 4d2
+
d
X
i=1
 3m(i) + 4

 
d
X
j=1
k(i|j) −(d −1)k(i)
!
+
d
X
i=1
d
X
j=1

k(i|j)k(j|i)ℓ(ij)
h
/ 8

bytes,
(12)
where ℓh is the number of bits per bin count, i.e.,
ℓ(ij)
h
=
l
log2

1 + max
ti,tj

h(ij)
titj
m
,
(13)
and m(i) is the number of bytes per value in the ith
dimension.
In Fig. 6, I(ij)
h
is a binary variable that
indicates whether the (ij)th histogram is stored densely
or sparsely, θ(ij) is the number of non-zero values in
H(ij) and G(·) is Golomb coding.
8

---

Params
1-d hists
2-d hists
Bin counts
Overall Storage Configuration
N
Ns
M
α
d
m(1), . . . , m(d)
Parameters:
Sparams = 29 + d bytes
k(i|j) −k(i)
. . . , e(i|j)
ti
, . . .
. . . , v(i|j)−
ti
, . . .
. . . , v(i|j)+
ti
, . . .
. . . , u(i|j)
ti
, . . .
2-d Histograms:
S2-d hists = 2d(d −1) + Pd
i=1(3m(i) + 4)
  Pd
j=1 k(i|j) −dk(i)
bytes
k(i)
. . . , e(i)
t
, . . .
. . . , v(i)−
t
, . . .
. . . , v(i)+
t
, . . .
. . . , u(i)
t
, . . .
1-d Histograms:
S1-d hists = 2d + Pd
i=1 k(i)(3m(i) + 4) bytes
ℓ(ij)
h
I(ij)
h
. . . , h(ij)
titj
, . . .
Dense:
Scounts = 2d2 +
d
P
i=1
d
P
j=1
l k
(i|j)k
(j|i)ℓ
(ij)
h
8
m
ℓ(ij)
h
I(ij)
h
θ(ij)
. . . ,

G(ik(i) + j), h(ij)
titj
	
, . . .
Sparse:
Scounts = 3d2 +
d
P
i=1
d
P
j=1
l SG +θℓh
8
m
or
Figure 6: PairwiseHist storage configuration.
dist > 150
P1
AND
dist < 300
P2
OR
dist < 450
P3
AND
air time > 90.5
P4
x2 > 81
x2 > 231
x2 < 381
x3 > 655
−69
×1
−69
×1
−69
×1
−25
×10
H(2)
H(2)
H(2)
H(3)
β(2)
1
= ⟨0.19, 1, 1, 1, 1⟩
β(2)
2
= ⟨1, 1, 0.31, 0, 0⟩
β(2)
3
= ⟨1, 1, 1, 0.81, 0⟩
β(3)
4
= ⟨0, 0.375, 1, . . .⟩
β(2)
12 = ⟨0.19, 1, 0.31, 0, 0⟩
w(1) = 1 −

1 −H(12)β(2)
12 ⊘H(1)
⊙

1 −H(12)β(2)
3
⊙H(13)β(3)
4
⊘

H(1)2
Delayed
transformation
Transform coverage to
aggregation column
AND relation
GreedyGD
pre-process
Figure 7: Partial query execution for a query aggregating on column 1 with predicates on columns 2 (dist) and 3
(air time), including applying GreedyGD pre-processing, computing coverage for each predicate and bin weightings.
5
Query Execution
This section explains how AQP tasks are executed using
PairwiseHist executes (top section of Fig. 2), which is
illustrated in Fig. 7.
5.1
SQL parsing
SQL queries are parsed by applying GreedyGD pre-
processing to predicate literals so that they are in
the same domain as the compressed data on which
PairwiseHist is built. For example, in Fig. 7, the dist
column’s minimum value of 69 is subtracted from pred-
icates 1–3, while the air time column’s minimum value
of 25 is subtracted from predicate 4.
Predicate 4 is
also multiplied by 10 to convert from floating point to
integer.
5.2
Coverage
Given a condition P that applies to column j, we define
coverage, β(j), as the k(j) × 1 vector whose tth element
is the probability that a point in the tth bin of the one-
dimensional histogram for column j satisfies P. That
is,
β(j)
t
= Pr

P
 e(j)
t
≤x < e(j)
t+1

(14)
where Pr is the probability operator. This is estimated
as follows for equality conditions (inverse for inequal-
ity):
β(j)
t
=
(
0,
condition value outside bin
1/u(j)
t ,
otherwise,
(15)
9

---

and for all other condition types (i.e., ≤, <, ≥, >) as:
β(j)
t
=









0,
v(j)−
t
and v(j)+
t
fail P
1,
v(j)−
t
and v(j)+
t
satisfy P
0.5,
one of v(j)−
t
, v(j)+
t
satisfy P & u(j)
t
= 2
ft(P),
otherwise,
(16)
where ft(P) is the fraction of the bin width (∆t) that
satisfies P.
Coverage is estimated separately for each predicate
condition, as illustrated in Fig. 7 with β1 to β4 corre-
sponding to predicates P1 to P4. Groups of conditions
that apply to the same column are consolidated. By
‘group’ we mean any group of two or more conditions
that are directly connected by a single AND or OR op-
erator. For example, in Fig. 7, β1 and β2 are consoli-
dated into β12 since they both apply to the dist column
and are directly connected by an AND operator. How-
ever, despite P3 also applying to the same column, it is
not consolidated since it must be first combined with
P4 due to operator precedence (AND before OR). We
refer to this process as delayed transformation because
we delay transforming coverages into weightings in the
aggregation dimension (Subsection 5.3) to consolidate
same-column conditions.
Coverage bounds are also computed and used to
bound the query result. The source of uncertainty here
is the unknown distribution of data points within par-
tially covered bins. Applying similar logic to Subsec-
tion 4.2, we can show that, for bins that do not pass
the hypothesis test in IsUniform (i.e., bins with h < M),
coverage bounds occur when only one data point or all
but one data points satisfy P. However, for bins with at
least M points, tighter bounds can be derived by con-
sidering the partial bin count, which is defined as the
number of data points in a subset of the bin’s sub-bins.
Theorem 2 provides the key result for these bounds.
Theorem 2. Consider a histogram bin with count h
and u unique values. Assume that this bin satisfies the
hypothesis test in IsUniform with s =

(2u)1/3
sub-bins
and critical value χ2
α.
The minimum and maximum
partial bin count over ¯s ≤s sub-bins is then:
h±
¯s|s = h¯s
s ± h¯s
s
r
χ2α(s −¯s)
h¯s
.
(17)
Proof. Use Lagrange Multipliers to optimise the partial
count P¯s
r=1 ℏr, where ℏr is the count for the rth sub-
bin, given constraints:
s
X
r=1
ℏr = h and χ2
α =
s
X
r=1
(ℏr −h/s)2
h/s
.
(18)
The Lagrangian is then:
L(ℏr, λ1, λ2) =
¯s
X
r=1
ℏr + λ1
 
h −
s
X
r=1
ℏr
!
+ λ2
 
χ2
α −
s
X
r=1
(ℏr −h/s)2
h/s
!
.
(19)
Setting the partial derivative of L with respect to ℏr to
zero gives
ℏr =
(
h
s + h(1−λ1)
2sλ2
,
r < ¯s
h
s −hλ1
2sλ2 ,
r ≥¯s
(20)
Substituting this into the two constraints in Eq. 18 and
solving for λ1 and λ2 gives the following result for ℏr:
ℏr =
( h
s ± h
s
p
χ2α(s −¯s) / h¯s,
r < ¯s,
h
s ∓h
s
p
χ2α¯s / h(s −¯s)
r ≥¯s.
(21)
Multiplying the solution for r < ¯s by ¯s gives the desired
result.
Given Theorem 2, coverage bounds β−and β+ can
be obtained by dividing the partial bin count by the
total bin count with the appropriate number of sub-
bins. That is,
β−(j)
t
=





β(j)
t ,
β(j)
t
∈{0, 1}
1 / h(j)
t ,
β(j)
t
/∈{0, 1} & h(j)
t
< M
a
s −a
s
p
χ2α(s −a)/ha,
otherwise,
(22)
β+(j)
t
=





β(j)
t ,
β(j)
t
∈{0, 1}
1 −1 / h(j)
t ,
β(j)
t
/∈{0, 1} & h(j)
t
< M
b
s + b
s
p
χ2α(s −b)/hb,
otherwise,
(23)
where s =
 2u(j)
t
1/3
is the number of sub-bins,
a = ⌊β(j)
t s⌋is the number of sub-bins that are fully
covered by the predicate condition and b = ⌈β(j)
t s⌉is
the number of fully or partially covered sub-bins.
5.3
Weightings
Given
query
predicate
P
containing
conditions
P1, . . . , Pn and aggregation column i, we define bin
weightings, w(i), as the k(i) × 1 vector whose tth el-
ement is the estimated number of points in the tth bin
of the one-dimensional histogram for column i that sat-
isfy P . This can be expressed as follows:
w(i)
t
= h(i)
t Pr

P
 e(i)
t
≤x < e(i)
t+1

.
(24)
10

---

Table 3: Aggregation functions
Aggregation
Estimate
Lower bound
Upper bound
COUNT
∥w∥1 / ρ
∥w−∥1 / ρ
∥w+∥1 / ρ
SUM
w · c / ρ
w−· c−/ ρ
w+ · c+ / ρ
AVG
w · c / ∥w∥1
min
{w−, w+}

w• · c−/ ∥w•∥1
	
max
{w−, w+}

w• · c+ / ∥w•∥1
	
MIN
(
v+
t∗,
1-d, ut∗= 2 & wt∗<
ht∗
2
v−
t∗,
otherwise.
(
v+
t∗,
1-d, ut∗= 2 & w+
t∗<
ht∗
5
v−
t∗,
otherwise.
(
v+
t∗−aδt∗,
1-d, ut∗> 2 & ht∗> M
v+
t∗,
otherwise,
MAX
(
v−
t∗,
1-d, ut∗= 2 & wt∗<
ht∗
2
v+
t∗,
otherwise.
(
v−
t∗+ aδt∗,
1-d, ut∗> 2 & ht∗> M
v−
t∗,
otherwise,
(
v−
t∗,
1-d, ut∗= 2 & w+
t∗<
ht∗
5
v+
t∗,
otherwise.
MEDIAN





v−
t∗,
ut∗= 2 & ft∗< 0.5
v+
t∗,
ut∗= 2 & ft∗≥0.5
v−
t∗+ ∆t∗ft∗,
otherwise,
v−
t∗
v+
t∗
VAR
w · c2 / ∥w∥1 −(w · c / ∥w∥1)2 .
min
{w−, w+}
n
w• · (ξ−)2 / ∥w•∥1
−

w• · ξ−/ ∥w•∥1
2 o
max
{w−, w+}
n
w• · (ξ+)2 / ∥w•∥1
−

w• · ξ+ / ∥w•∥1
2 o
For predicates that are the intersection (AND) of multi-
ple conditions P1, . . . , Pn and assuming conditional in-
dependence between predicate conditions, this can be
expressed as follows:
w(i)
t
= h(i)
t Pr

P1 ∩P2 ∩. . . ∩Pn
 e(i)
t
≤x < e(i)
t+1

= h(i)
t
n
Y
ℓ=1
Pr

Pℓ
 e(i)
t
≤x < e(i)
t+1

.
(25)
Likewise, for predicates that are the union (OR) of mul-
tiple conditions and again assuming conditional inde-
pendence between predicate conditions, weightings can
be expressed as follows:
w(i)
t
= h(i)
t Pr

P1 ∪P2 ∪. . . ∪Pn
 e(i)
t
≤x < e(i)
t+1

= h(i)
t

1 −Pr

¯P1 ∩¯P2 ∩. . . ∩¯Pn
 e(i)
t
≤x < e(i)
t+1

= h(i)
t
 
1 −
n
Y
ℓ=1

1 −Pr

Pℓ
 e(i)
t
≤x < e(i)
t+1
!
.
(26)
We then observe that
Pr

Pℓ
 e(i)
t
≤x < e(i)
t+1

=
1
h(i)
t
h
H(ij)β(j)i
t ,
(27)
which allows us to express weightings as follows:
w(i) =







nQ
ℓ=1
H(ij)β(j) ⊘H(i),
intersection
1 −
nQ
ℓ=1

1 −H(ij)β(j) ⊘H(i)
,
union
(28)
where the product (Π) is element-wise (Hadamard).
By combining these results, arbitrary combinations of
AND and OR relations can be processed. Note that due
to assuming conditional independence, Eq. 28 may not
be reliable for highly correlated data. This is especially
true for multiple conditions on the same column, which
are clearly not (conditionally) independent, and thus
why we perform delayed transformation to consolidate
such conditions prior to computing bin weightings.
Weightings bounds, w−and w+, are computed us-
ing Eq. 28, using low and high coverage bounds, re-
spectively. If PairwiseHist is constructed from a data
sample, these bounds are widened to account for addi-
tional uncertainty due to sampling. That is, the bounds
are replaced by their outer two-sided 98-percentile con-
fidence interval bounds. Variance is estimated accord-
ing to the Binomial distribution as βt(1 −βt) where
βt = wt/ht. Including compensation for finite popula-
tion size, the weightings bounds are updated as follows:
w±
t ←w±
t ± z0.98
r
β±
t
 1 −β±
t
 N −Ns
N −1 ,
(29)
where z0.98 is the value of the standard normal den-
sity function corresponding to a two-sided 98-percentile
confidence interval.
5.4
Aggregation
This section describes the mathematical formulations
for query aggregation, which are listed in Table 3, along
with corresponding bounds. Currently, seven aggrega-
tion functions are supported, namely COUNT, SUM,
AVG, MIN, MAX, MEDIAN and VAR.
5.4.1
COUNT
This can be estimated by summing the weightings vec-
tor and then dividing by the sampling ratio, ρ.
5.4.2
SUM
This can be estimated as the weighted sum of bin mid-
points, c, using the estimated bin weightings, w. As
11

---

with COUNT, the result must also be scaled by the
sampling ratio, ρ.
5.4.3
AVG
This can be estimated as the weighted mean of bin mid-
points, c, using the estimated bin weightings, w. The
bounds follow the same formulation, but naturally use
the appropriate bounds for bin midpoints. Addition-
ally, each bound is estimated using both bin weightings
extrema and either the minimum or maximum is re-
turned. For example, the lower bound is the minimum
over w−and w+ where w• is a placeholder variable.
5.4.4
MIN
Estimating MIN requires identifying the index, t∗, of
the first bin with non-zero weighting, i.e.,
t∗= min
t {t, s.t. wt > 0}.
(30)
In most cases, the estimate is the minimum value for
this bin, v−
t∗. For the special case where the query in-
volves only a single column (for aggregation and all
predicates), there are only two unique values in the t∗th
bin (i.e., ut∗= 2) and the bin coverage is less than half
(i.e., wt∗< ht∗/2), then the bin maximum, v+
t∗, is a
better estimate.
The lower bound follows the same formulation, ex-
cept that t∗must be determined from the bin weight-
ings upper bound (to include the maximum range), i.e.,
t∗= min
t {t, s.t. w+
t > 0}
(lower bound).
(31)
Conversely, the bin corresponding to the upper bound
is identified using the bin weightings lower bound. A
higher threshold is used to ensure a higher likelihood of
non-zero true bin coverage, i.e.,
t∗= min
t {t, s.t. w−
t > 1/2}
(upper bound). (32)
A tighter upper bound can be obtained for queries in-
volving a single column in certain cases by considering
the sub-bins. That is, if the relevant bin passed the
uniformity hypothesis test, and hence h ≥M, then we
may assume that data is uniformly distributed across
the sub-bins. Thus, we can compute the number of sub-
bins that are fully covered as a = ⌊sw−
t∗/ht∗⌋and reduce
the upper bound by this number of sub-bin widths, δt∗.
5.4.5
MAX
This is the inverse of MIN. That is, we identify the
index, t∗, of the last bin with non-zero weighting, i.e.,
t∗= max
t {t, s.t. wt > 0},
(33)
and use this to determine the estimates. Similar, but
inverse, formulations apply for the lower and upper
bounds.
5.4.6
MEDIAN
This is estimated by first identifying the index, t∗, of
the bin that contains the median. That is,
t∗= min
t
(
t, s.t.
t
X
τ=0
wτ ≥1
2∥w∥1
)
.
(34)
The estimate is then the bin minimum, v−
t∗plus the bin
width, ∆t∗= v+
t∗−v−
t∗, multiplied by the fraction of the
bin weighting that is below the median, ft∗, which is
calculated as follows:
ft∗=
1
wt∗
 
1
2∥w∥1 −
t∗−1
X
t=0
wt
!
(35)
If the bin contains only two unique values (i.e., ut∗=
2), the bin minimum or maximum is returned instead,
depending on the value of ft∗.
MEDIAN bounds require identifying the minimum
and maximum bin indices that could correspond to the
median, i.e.,
t∗=
min
{w−, w+}
(
min
t
(
t, s.t.
t
X
τ=0
w•
τ ≥1
2
))
(lower bound)
(36)
t∗=
max
{w−, w+}
(
min
t
(
t, s.t.
t
X
τ=0
w•
τ ≥1
2
))
(upper bound)
(37)
5.4.7
VAR
This is estimated as the difference between the weighted
mean square value and the square of the estimated
mean. The idea for the bounds is to assume that all
points within a bin are either as far from the mean as
possible (upper bound) or as close to the mean as pos-
sible (lower bound). This is expressed using ξ−and ξ+,
which represent the (assumed) location of points within
each bin for the purpose of estimating the bounds and
are defined as follows:
ξ−
t =





v+
t ,
v+
t < AV G
v−
t ,
v−
t > AV G
AV G,
otherwise,
(38)
ξ+
t =
(
v−
t ,
|AV G −v−
t | > |v+
t −AV G|
v+
t ,
otherwise.
(39)
where AV G is the estimated mean. Thus, for the lower
bound, bins are represented by whichever of the bin
minimum or maximum is closest to the estimated mean,
while the bin that straddles the mean is represented by
the mean itself. Conversely, for the upper bound, bins
are represented by whichever of the bin minimum or
maximum is furthest from the mean.
As with AVG
and MEDIAN queries, the bounds are evaluated for
both weightings extrema and the appropriate min/max
is returned.
12

---

6
Performance Evaluation
To evaluate PairwiseHist, 11 real-world datasets were
used, which are summarised in Table 4.
The Base-
ment, Current and Furnace datasets [50, 51] contain
electrical meter data for different areas of a house.
Gas [52], Light [53], Power [54] and Temp [55] con-
tain multifaceted IoT sensor data from a single source,
while Aqua [56] and Build [57] contain IoT sensor data
combined from multiple sources (aquaponics ponds and
building rooms, respectively) with several data columns
each and a shared timestamp column. Aqua and Build
thus contain many null values due to asynchronous sam-
pling. Flights [58] and Taxi [59] contain records of in-
dividual trips and include several categorical fields, as
well as missing values.
Flights is commonly used in
AQP literature (e.g. [20–22, 38, 42, 60]), while Power is
used occasionally (e.g. [34, 41]). Overall, these datasets
encompass a wide variety of data types, dimensionality,
sizes and both sensor and non-sensor data.
We
implemented
PairwiseHist
in
Python
3.11
and compared it to state-of-the-art AQP techniques
DeepDB [20] and DBEst++ [21] using their corre-
sponding Python implementations [61, 62]. These tech-
niques were chosen for comparison due to their leading
performance (see Table 1) and code availability.
Our evaluation is divided into two parts: initial ex-
periments on the original datasets and comprehensive
experiments on scaled-up versions of the Power and
Flights datasets. For the initial experiments, we ran-
domly generated 100 single-predicate queries for each
dataset with aggregation functions COUNT, SUM and
AVG and minimum selectivity of 10−5. For the scaled-
up experiments, IDEBench [22] was used to scale the
datasets up to one billion rows, resulting in sizes of
40 GB and 130 GB, respectively.
We then randomly
generated 445 and 427 test queries for Power and
Flights, respectively, including all seven aggregation
functions supported by PairwiseHist, 1–5 predicate con-
ditions and minimum selectivity of 10−6. Due to afore-
mentioned limitations of DeepDB and DBEst++ (Sec-
tion 2), DeepDB supports only 146 queries (80 for
Power and 66 for Flights), while DBEst++ supports
just 86 queries (41 for Power and 45 for Flights). Also,
since DBEst++ requires many models to support dif-
ferent query templates (see Section 2), we include all
DBEst++ models required to support the same queries
as PairwiseHist when comparing synopsis size.
Our experimental setup consisted of an Intel(R)
Xeon(R) Gold 6130 2.10 GHz CPU with 24 GB RAM
available during synopsis construction and 6 GB dur-
ing query execution. Default parameters were used for
DeepDB and DBEst++, as well as GreedyGD. All ex-
periments were performed with M set to 1% of Ns (e.g.
M = 103 for Ns = 105) and α set to 0.001.
6.1
Initial experiments
The median query error and synopsis size for each
dataset is shown in Fig. 8 for PairwiseHist, DeepDB and
DBEst++ with 100k and 10k samples. As can be seen
in Fig. 8(a), PairwiseHist has the lowest error on 10 out
of 11 datasets. Indeed, even with a mere 10k samples,
PairwiseHist outperforms DeepDB with 100k samples
on 6 out of 11 datasets.
Overall, for 100k samples,
PairwiseHist has a median error of just 0.28%, com-
pared to 0.73% for DeepDB and 28.9% for DBEst++.
In terms of synopsis size, PairwiseHist is typically 1–
2 orders of magnitude smaller. For 100k samples, the
mean size for PairwiseHist is just 0.48 MB, compared
to 11.5 MB for DeepDB and 36.3 MB for DBEst++.
That is, PairwiseHist is at least 2.6× as accurate while
requiring 24× less storage.
6.2
Parameter sensitivity
In general, higher Ns, higher α and lower M all corre-
spond to higher accuracy at the cost of larger synopsis
size and longer construction time.
However, Ns has
greatest impact on performance, while α has minimal
impact. This is illustrated in Fig. 9 for the scaled-up
Flights dataset, where α has near-zero impact except
on accuracy for Ns = 100k in some cases. In our tests,
we have also observed that construction time scales lin-
early with Ns and query latency is largely consistent
across different parameter sets.
6.3
Accuracy
Query Accuracy.
Table 5 presents the median error
by dataset and aggregation function for the scaled-up
experiments.
As can be seen, PairwiseHist (denoted
PH) performs well across all aggregation functions and
delivers between 1.5–2.3× better overall accuracy than
DeepDB with median errors of just 0.20% and 0.43%
compared to 0.45% and 0.64% for the two datasets.
Note that a smaller sample size was used for DBEst++
were due to its prohibitively long training time (see
Subsection 6.6).
We also compared the distribution of query er-
rors over the subset of queries supported by DeepDB
(Fig. 10(a)) and DBEst++ (Fig. 10(b)) as CDF plots,
while the error distribution for PairwiseHist over all
queries is shown in (Fig. 10(c)).
As can be seen,
PairwiseHist provides a better error distribution in
each case. Indeed, with just 100k samples, Pairwise-
Hist achieves a higher probability of sub-1% error than
DeepDB with 1 million samples.
Overall, 85.1% of
queries have sub-10% error with PairwiseHist, as high-
lighted in Fig. 10(c).
During our evaluation, DeepDB was observed to per-
form significantly worse on real-world data compared to
IDEBench-generated synthetic data. To demonstrate
13

---

Aqua
Basement
Build
Current
Flights
Furnace
Gas
Light
Power
Taxis
Temp
0.1
1
10
100
1,000
PairwiseHist 100k
DeepDB 100k
DBEst++ 100k
PairwiseHist 10k
DeepDB 10k
DBEst++ 10k
Aqua
Basement
Build
Current
Flights
Furnace
Gas
Light
Power
Taxis
Temp
0.01
0.1
1
10
100
(a) Median error (%)
(b) Synopsis size (MB)
Figure 8: Error performance and storage requirements across 11 real-world datasets.
Table 4: Datasets used for evaluation
Dataset
Rows
Columns
Size (MB)
Aqua
Aquaponics sensors [56]
913 465
13
66.7
Basement
Basement power [50, 51]
1 051 200
12
50.5
Build
Smart building systems [57]
14 381 639
7
402.7
Current
Electric meters current [50, 51]
1 051 200
24
100.9
Flights∗
Flight delays & cancellations [58]
5 819 079
32
756.5
Furnace
Furnace power [50, 51]
1 051 200
12
50.5
Gas
Home gas sensor [52]
928 991
12
44.6
Light
IoT light detection [53]
405 184
9
19.9
Power
Home power consumption [54]
2 049 280
10
82.0
Taxis
Chicago taxi trips 2020 [59]
3 889 032
23
1 753.9
Temp
Temperature sensor [55]
10 553 597
5
369.4
∗Other works typically use only 12 columns from the Flights dataset (e.g. [20]). How-
ever, we use all 32 columns.
Table 5: Median relative error (%).
Power dataset
Flights dataset
Aggregation
PH
DeepDB
DBEst++
PH
DeepDB
DBEst++
COUNT
0.19
0.05
24.82
0.38
0.41
21.65
SUM
0.32
14.18
56.46
1.15
1.72
3.55
AVG
0.42
0.50
17.86
0.39
0.28
16.95
VAR
0.84
-
98.50
1.67
-
100.00
MIN
0.00
-
-
0.00
-
-
MAX
1.25
-
-
4.41
-
-
MEDIAN
0.00
-
-
0.29
-
-
Overall
0.20
0.45
56.46
0.43
0.64
28.42
PH = PairwiseHist: 1 million samples, DeepDB: 1 million samples, DBEst++: 100k samples.
this, we generated synthetic versions of the Power and
Flights datasets using IDEBench with the same number
of rows as the original data and tested identical queries
on them using DeepDB and PairwiseHist. The resulting
median errors are shown in Fig. 10(d). As can be seen,
DeepDB performs far worse on the real data compared
14

---

1 000
4 000
7 000
10 000
0
1
2
3
4
Min. points, M
(a) Median error (%)
1m, α=0.01
100k, α=0.001
100k, α=0.01
100k, α=0.1
1 000
4 000
7 000
10 000
0.1
1
10
100
Min. points, M
(b) Synopsis size (MB)
1m, α=0.01
100k, α=0.01
Figure 9: PairwiseHist performance on the scaled-up
Flights dataset for different parameter sets.
to the IDEBench-generated data. IDEBench generates
synthetic data by applying normalisation and Gaussian
models.
This suggests that, while DeepDB performs
well on standard test data, it may not perform as effec-
tively in the real world, where data is less well-behaved.
PairwiseHist, on the other hand, performs consistently
well and has up to 31× lower error than DeepDB on
the real datasets.
Query Bounds. Query bounds should be both accu-
rate (i.e., contain the true result) and narrow. Table 6
lists the percentage of queries for which DeepDB and
PairwiseHist provide accurate bounds and the median
bound widths as a percentage of the exact result for
the subset of queries supported by DeepDB (DBEst++
does not provide bounds). A significance value of 0.99
was used for DeepDB. As shown, PairwiseHist provides
more accurate bounds than DeepDB, especially for the
real-world datasets. DeepDB has consistently narrower
bounds, but given their lower accuracy, this may indi-
cate that its bounds are overly optimistic.
6.4
Storage requirements
Synopsis sizes are shown in Fig. 11(a).
As can be
seen, PairwiseHist requires the least storage in all
cases and is at least 11× smaller than DeepDB and
DBEst++ (0.25 MB vs. 2.75 MB for Power with 1m
samples). Additionally, with PairwiseHist built directly
on compressed data, total storage requirements are re-
duced, since data can be permanently stored in com-
pressed format. Total storage requirements are shown
in Fig. 11(b), where PairwiseHist delivers savings of
3.2–4.3×.
6.5
Query latency
Median query latency, including the time to calculate
query bounds (for PairwiseHist and DeepDB), is shown
in Fig. 11(c). As can be seen, PairwiseHist is signifi-
cantly faster than the state-of-the-art approaches with
an overall median latency of just 0.94 ms (for 1m sam-
ples), which is 3.5× faster than DeepDB and 15× faster
than DBEst++. PairwiseHist’s low latency can be at-
tributed to most aggregations requiring just a handful
of small matrix multiplications. The corresponding me-
dian latency for exact query processing using SQLite,
which we used for the ground truth, was 306.8 seconds,
which makes PairwiseHist over 300 000× faster.
6.6
Construction time
Finally, synopsis construction times are displayed in
Fig. 11(d). As can be seen, PairwiseHist consistently re-
quires the least time, being 1.2–4× faster than DeepDB,
while DBEst++ is more than two orders of magnitude
slower. Indeed, for the Flights dataset, DBEst++ re-
quires over 30 hours for 100k samples, while Pairwise-
Hist requires less than 3 minutes with 1 million samples.
7
Conclusion
In this paper, we propose a novel AQP technique called
PairwiseHist and a novel framework for AQP that lever-
ages data compression to reduce overall storage require-
ments. By using a collection of histograms approach,
efficient storage encoding and various query execution
optimisations, we are able to simultaneously deliver sig-
nificant improvements in terms of accuracy, latency,
synopsis size and construction time compared to state-
of-the-art AQP methods. In future work, we intend to
investigate histogram updates, online refinement and
multi-table support.
8
Acknowledgements
This work is supported by the Analytics Straight on
Compressed IoT Data (Light-IoT) project (Grant No.
0136-00376B), granted by the Danish Council for In-
dependent Research, and Aarhus University’s DIGIT
Centre. Computation was partially performed on the
UCloud system, which is managed by the eScience Cen-
ter at the University of Southern Denmark.
References
[1] K. Li and G. Li, “Approximate query processing:
What
is new and where to go?” Data Science and Engineering,
vol. 3, no. 4, pp. 379–397, 2018.
[2] P. S. Akash, W.-C. Lai, and P.-W. Lin, “Online aggregation
based approximate query processing: A literature survey,”
2022.
[3] X. Liang, S. Sintos, Z. Shang, and S. Krishnan, “Combining
aggregation and sampling (nearly) optimally for approxi-
mate query processing,” in Proceedings of the ACM SIG-
MOD International Conference on Management of Data,
2021.
[4] J. Peng, D. Zhang, J. Wang, and J. Pei, “AQP++: Con-
necting approximate query processing with aggregate pre-
computation for interactive analytics,” in Proceedings of the
15

---

82.5%
10−310−210−1 100
101
102
0
20
40
60
80
100
Relative error
Percentile
(b) DeepDB (n = 146)
PairwiseHist 1m
PairwiseHist 100k
DeepDB 1m
DeepDB 100k
95.1%
10−310−210−1 100
101
102
0
20
40
60
80
100
Relative error
(a) DBEst++ (n = 86)
PairwiseHist 1m
PairwiseHist 100k
DBEst++ 100k
DBEst++ 10k
85.1%
10−310−210−1 100
101
102
0
20
40
60
80
100
Relative error
(c) All queries (n = 872)
PairwiseHist 1m
PairwiseHist 100k
PowerFlightsPowerFlights
0
1
2
3
4
Median error (%)
(d) Real vs. IDEBench∗
PairwiseHist Real
PairwiseHist IDEBench
DeepDB Real
DeepDB IDEBench
∗1m sample size used for all models
Figure 10:
(a)–(c) CDF plots of query error for different subsets of queries across both datasets, (d) query
performance on the original real-world data and IDEBench-generated data of the same size.
.25 & 0.05
Power
Flights
0
20
40
(a) Synopsis size (MB)
PairwiseHist 1m
PairwiseHist 100k
DeepDB 1m
DeepDB 100k
DBEst++ 100k
DBEst++ 10k
Power
Flights
0
50
100
150
(b) Total storage (GB)
Power
Flights
0
5
10
15
(c) Median query latency (ms)
Power
Flights
1 s
1 min
1 hr
1 day
(d) Construction time
Figure 11: Storage and runtime performance comparison on the scaled-up datasets.
Table 6: Bounds accuracy rate and width.
Correct rate (%)
Width (%)
Dataset
PairwiseHist
DeepDB
PairwiseHist
DeepDB
Power (original)
70.0
40.0
4.4
0.7
Power (1 billion)
80.0
51.2
3.4
0.6
Flights (original)
78.8
50.0
8.7
3.0
Flights (1 billion)
78.8
75.8
4.3
2.3
ACM SIGMOD International Conference on Management
of Data, 2018, pp. 1477–1492.
[5] Y. Park, B. Mozafari, J. Sorenson, and J. Wang, “Ver-
dictDB: Universalizing approximate query processing,” in
Proceedings of the ACM SIGMOD International Conference
on Management of Data, 2018.
[6] A. Hurst, Q. Zhang, D. E. Lucani, and I. Assent, “Direct an-
alytics of generalized deduplication compressed IoT data,”
in IEEE Global Communications Conference (GLOBE-
COM), 2021.
[7] A. Hurst, D. E. Lucani, I. Assent, and Q. Zhang, “GLEAN:
Generalized deduplication enabled approximate edge ana-
lytics,” IEEE Internet of Things Journal, 2022.
[8] A. Hurst, D. E. Lucani, and Q. Zhang, “GreedyGD: En-
hanced generalized deduplication for direct analytics in
IoT,” IEEE Transactions on Industrial Informatics, 2024.
[9] R. Vestergaard, Q. Zhang, and D. E. Lucani, “Generalized
deduplication:
Lossless compression for large amounts of
small IoT data,” in European Wireless, 2019.
[10] ——, “Generalized deduplication:
Bounds, convergence,
and asymptotic properties,” in IEEE Global Communica-
tions Conference (GLOBECOM).
IEEE, 2019.
[11] R. Vestergaard, D. E. Lucani, and Q. Zhang, “A randomly
accessible lossless compression scheme for time-series data,”
in IEEE INFOCOM, 2020.
[12] R. Vestergaard, Q. Zhang, M. Sipos, and D. E. Lucani,
“Titchy: Online time-series compression with random ac-
cess for the internet of things,” IEEE Internet of Things
Journal, vol. 8, no. 24, pp. 17 568–17 583, 2021.
[13] H. Sehat, A. L. Kloborg, C. Mørup, E. Pagnin, and D. E.
Lucani, “Bonsai: A generalized look at dual deduplication,”
2022.
[14] L. Nielsen, R. Vestergaard, N. Yazdani, P. Talasila, D. E.
Lucani, and M. Sipos, “Alexandria: A proof-of-concept im-
plementation and evaluation of generalised data deduplica-
tion,” in IEEE (GLOBECOM) Workshops, 2019.
[15] M. Feh´er, D. E. Lucani, and I. Chatzigeorgiou, “An adaptive
column compression family for self-driving databases,” 2022,
arXiv:2209.02334v1.
[16] C. G¨ottel, L. Nielsen, N. Yazdani, P. Felber, D. E. Lucani,
and V. Schiavoni, “Hermes: enabling energy-efficient IoT
networks with generalized deduplication,” in Proceedings of
the 14th ACM International Conference on Distributed and
Event-based Systems.
ACM, 2020.
[17] J. Zhang, Y. Yan, L. J. Chen, M. Wang, T. Moscibroda, and
Z. Zhang, “Impression store:
Compressive sensing-based
storage for big data analytics,” in 6th USENIX Workshop on
Hot Topics in Cloud Computing (HotCloud 14).
USENIX
Association, 2014.
16

---

[18] L. Kong, J. Tan, J. Huang, G. Chen, S. Wang, X. Jin,
P. Zeng, M. Khan, and S. K. Das, “Edge-computing-driven
Internet of Things: A survey,” ACM Computing Surveys,
vol. 55, no. 8, pp. 1–41, 2022.
[19] S. Nayak, R. Patgiri, L. Waikhom, and A. Ahmed, “A re-
view on Edge analytics: Issues, challenges, opportunities,
promises, future directions, and applications,” Digital Com-
munications and Networks, 2022.
[20] B. Hilprecht, A. Schmidt, M. Kulessa, A. Molina, K. Ker-
sting, and C. Binnig, “DeepDB: Learn from data, not from
queries,” in Proceedings of the VLDB Endowment, vol. 13,
no. 7, 2020, pp. 992–1005.
[21] Q. Ma, A. M. Shanghooshabad, M. Almasi, M. Kurmanji,
and P. Triantafillou, “Learned approximate query process-
ing: Make it light, accurate and fast,” in Conference on
Innovative Data Systems Research, 2021.
[22] P. Eichmann, E. Zgraggen, C. Binnig, and T. Kraska,
“IDEBench: A benchmark for interactive data exploration,”
in Proceedings of the ACM SIGMOD International Confer-
ence on Management of Data.
ACM, 2020.
[23] S. Chaudhuri, B. Ding, and S. Kandula, “Approximate
query processing:
No silver bullet,” in ACM Interna-
tional Conference on Management of Data,
ser. SIG-
MOD/PODS’17.
ACM, 2017.
[24] H. Ahmadvand, M. Goudarzi, and F. Foroutan, “Gapprox:
using gallup approach for approximation in big data pro-
cessing,” Journal of Big Data, vol. 6, no. 1, 2019.
[25] B. Babcock, S. Chaudhuri, and G. Das, “Dynamic sample
selection for approximate query processing,” in Proceedings
of the ACM SIGMOD International Conference on Man-
agement of Data, 2003, pp. 539–550.
[26] S. Agarwal, B. Mozafari, A. Panda, H. Milner, S. Madden,
and I. Stoica, “BlinkDB,” in Proceedings of the 8th ACM
European Conference on Computer Systems, 2013.
[27] V. Sanca, P. Chrysogelos, and A. Ailamaki, “Laqy: Efficient
and reusable query approximations via lazy sampling,” in
Proceedings of the ACM SIGMOD International Conference
on Management of Data, 2023.
[28] Y. E. Ioannidis and V. Poosala, “Balancing histogram op-
timality and practicality for query result size estimation,”
ACM SIGMOD Record, vol. 24, no. 2, pp. 233–244, 1995.
[29] H. To, K. Chiang, and C. Shahabi, “Entropy-based his-
tograms for selectivity estimation,” in Proceedings of the
22nd ACM International Conference on Conference on In-
formation & Knowledge Management (CIKM).
ACM
Press, 2013.
[30] J. Acharya,
I. Diakonikolas,
C. Hegde,
J. Z. Li,
and
L. Schmidt, “Fast and near-optimal algorithms for approx-
imating distributions by histograms,” in Proceedings of the
34th ACM SIGMOD-SIGACT-SIGAI Symposium on Prin-
ciples of Database Systems, 2015.
[31] I. Diakonikolas, J. Li, and L. Schmidt, “Fast and sample
near-optimal algorithms for learning multidimensional his-
tograms,” in Proceedings of the 31st Conference On Learn-
ing Theory, vol. 75, 2018, pp. 819–842.
[32] S. Singla and A. Eldawy, Flexible Computation of Multidi-
mensional Histograms, New York, NY, USA, 2022, ch. 13,
pp. 119–130.
[33] G. Cormode, M. Garofalakis, P. J. Haas, and C. Jermaine,
“Synopses for massive data: Samples, histograms, wavelets,
sketches,” in Foundations and Trends in Databases, vol. 4,
no. 1-3, 2011, pp. 1–294.
[34] M. Zhang and H. Wang,
“Selectivity estimation with
density-model-based multidimensional histogram,” Knowl-
edge and Information Systems, vol. 63, no. 4, pp. 971–992,
2021.
[35] M. Shekelyan, A. Dign¨os, and J. Gamper, “DigitHist: A
histogram-based data summary with tight error bounds,” in
Proceedings of the VLDB Endowment, vol. 10, no. 11, 2017,
pp. 1514–1525.
[36] N. Bruno, S. Chaudhuri, and L. Gravano, “STHoles,” in
Proceedings of the ACM SIGMOD International Conference
on Management of Data, 2001.
[37] T. Lee, K. Nam, C. S. Park, and S.-S. Kim, “Exploiting
machine learning models for approximate query processing,”
in IEEE International Conference on Big Data, 2022.
[38] M. Kulessa, A. Molina, C. Binnig, B. Hilprecht, and K. Ker-
sting, “Model-based approximate query processing,” 2018.
[39] M. Kulessa,
B. Hilprecht,
A. Molina,
K. Engineering,
G. Data, M. Lab, M. Learning, and Lab, “Towards model-
based approximate query processing,” in 1st International
Workshop on Applied AI for Database Systems and Appli-
cations, 2019.
[40] Q. Ma and P. Triantafillou, “DBEst: Revisiting approximate
query processing engines with machine learning models,” in
Proceedings of the ACM SIGMOD International Conference
on Management of Data, 2019, pp. 1553–1570.
[41] M. Zhang and H. Wang, “LAQP: Learning-based approxi-
mate query processing,” Information Sciences, vol. 546, pp.
1113–1134, 2021.
[42] N. Sheoran, S. Mitra, V. Porwal, S. Ghetia, J. Varshney,
T. Mai, A. Rao, and V. Maddukuri, “Conditional gener-
ative model based predicate-aware query approximation,”
Proceedings of the AAAI Conference on Artificial Intelli-
gence, vol. 36, no. 8, pp. 8259–8266, 2022.
[43] S. Zeighami, C. Shahabi, and V. Sharan, “Neurosketch: Fast
and approximate evaluation of range aggregate queries with
neural networks,” Proceedings of the ACM on Management
of Data, vol. 1, no. 1, pp. 1–26, 2022.
[44] M. Fallahian, M. Dorodchi, and K. Kreth, “Gan-based tabu-
lar data generator for constructing synopsis in approximate
query processing: Challenges and solutions,” 2022.
[45] M. M¨uller, G. Moerkotte, and O. Kolb, “Improved selectiv-
ity estimation by combining knowledge from sampling and
synopses,” in Proceedings of the VLDB Endowment, vol. 11,
no. 9, 2018, pp. 1016–1028.
[46] K. Zeng, S. Gao, B. Mozafari, and C. Zaniolo, “The an-
alytical bootstrap:
A new method for fast error estima-
tion in approximate query processing,” in Proceedings of the
ACM SIGMOD International Conference on Management
of Data, 2014, pp. 277–288.
[47] K. Li, Y. Zhang, G. Li, W. Tao, and Y. Yan, “Bounded ap-
proximate query processing,” IEEE Transactions on Knowl-
edge and Data Engineering, vol. 31, no. 12, pp. 2262–2276,
2019.
[48] S. Agarwal, H. Milner, A. Kleiner, A. Talwalkar, M. Jor-
dan, S. Madden, B. Mozafari, and I. Stoica, “Knowing when
you’re wrong: Building fast and reliable approximate query
processing systems,” in Proceedings of the ACM SIGMOD
International Conference on Management of Data, 2014,
pp. 481–492.
[49] D. W. Scott, “Sturges’ rule,” WIREs Computational Statis-
tics, vol. 1, no. 3, pp. 303–306, 2009.
[50] S. Makonin, B. Ellert, I. V. Baji´c, and F. Popowich,
“Electricity,
water,
and natural gas consumption of a
residential house in Canada from 2012 to 2014,” Scientific
Data, vol. 3, 2016. [Online]. Available: http://ampds.org/
[51] S. Makonin, “AMPds2:
The almanac of minutely power
dataset (version 2),” 2016.
[52] R. Huerta, T. Mosqueiro, J. Fonollosa, N. F. Rulkov,
and
I.
Rodriguez-Lujan,
“Online
decorrelation
of
hu-
midity and temperature in chemical sensors for contin-
uous monitoring,”
Chemometrics and Intelligent Labo-
ratory Systems,
vol. 157,
pp. 169–176,
2016. [Online].
Available:
https://archive.ics.uci.edu/ml/datasets/Gas+
sensors+for+home+activity+monitoring
[53] A.
Prasad,
“Ml
prediction
for
light
de-
tection
sensor
iot,”
2020.
[Online].
Avail-
able:
https://www.kaggle.com/datasets/aashnaprasad/
ml-prediction-for-lightdetection-sensor-iot
17

---

[54] G. Hebrail and A. Berard, “Individual household electric
power
consumption
data
set,”
2012.
[Online].
Avail-
able:
https://archive.ics.uci.edu/ml/datasets/Individual+
household+electric+power+consumption
[55] M.
Porter,
“Temperature
IoT
on
GCP,”
2021.
[Online].
Available:
https://www.kaggle.com/datasets/
mattpo/temperature-iot-on-gcp
[56] Udanor
Collins,
Blessing
Ogbuokiri,
and
Nweke
Onyinye,
“Sensor
based
aquaponics
fish
pond
datasets,”
2022.
[Online].
Avail-
able: https://www.kaggle.com/datasets/ogbuokiriblessing/
sensor-based-aquaponics-fish-pond-datasets
[57] D. Hong, Q. Gu, and K. Whitehouse, “High-dimensional
time series clustering via cross-predictability,” in Proceed-
ings of the 20th International Conference on Artificial
Intelligence and Statistics, vol. 54, 2017, pp. 642–651.
[Online].
Available:
https://www.kaggle.com/datasets/
ranakrc/smart-building-system
[58] USA Department of Transportation, “2015 flight delays
and
cancellations,”
2016.
[Online].
Available:
https:
//www.kaggle.com/datasets/usdot/flight-delays
[59] City of Chicago,
“Taxi trips - 2020,”
2022. [Online].
Available:
https://data.cityofchicago.org/Transportation/
Taxi-Trips-2020/r2u4-wwk3
[60] S. Garg, S. Mitra, T. Yu, Y. Gadhia, and A. Kashettiwar,
“Reinforced approximate exploratory data analysis,” Pro-
ceedings of the AAAI Conference on Artificial Intelligence,
vol. 37, no. 6, pp. 7660–7669, 2023.
[61] B. Hilprecht, “deepdb-public,” 2020, GitHub repository.
Accessed:
1
Apr,
2023.
[Online].
Available:
https:
//github.com/DataManagementLab/deepdb-public
[62] Q. Ma, “DBEstClient,” 2022, GitHub repository. Accessed:
1 Apr,
2023. [Online]. Available:
https://github.com/
qingzma/DBEstClient
18

---

