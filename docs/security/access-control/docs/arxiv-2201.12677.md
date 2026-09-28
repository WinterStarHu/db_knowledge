# AIM: An Adaptive and Iterative Mechanism for Differentially Private Synthetic Da

> 来源: https://arxiv.org/pdf/2201.12677

AIM: An Adaptive and Iterative Mechanism for
Differentially Private Synthetic Data
Ryan McKenna
Brett Mullins
University of Massachusetts
Amherst, Massachusetts
{rmckenna,bmullins}@cs.umass.edu
Daniel Sheldon
Gerome Miklau
University of Massachusetts
Amherst, Massachusetts
{sheldon,miklau}@cs.umass.edu
ABSTRACT
We propose AIM, a new algorithm for differentially private syn-
thetic data generation. AIM is a workload-adaptive algorithm within
the paradigm of algorithms that first selects a set of queries, then
privately measures those queries, and finally generates synthetic
data from the noisy measurements. It uses a set of innovative fea-
tures to iteratively select the most useful measurements, reflecting
both their relevance to the workload and their value in approx-
imating the input data. We also provide analytic expressions to
bound per-query error with high probability which can be used to
construct confidence intervals and inform users about the accuracy
of generated data. We show empirically that AIM consistently out-
performs a wide variety of existing mechanisms across a variety of
experimental settings.
PVLDB Reference Format:
Ryan McKenna, Brett Mullins, Daniel Sheldon, and Gerome Miklau. AIM:
An Adaptive and Iterative Mechanism for Differentially Private Synthetic
Data. PVLDB, 15(11): 2599 - 2612, 2022.
doi:10.14778/3551793.3551817
1
INTRODUCTION
Differential privacy [14] has grown into the preferred standard for
privacy protection, with significant adoption by both commercial
and governmental enterprises. Many common computations on
data can be performed in a differentially private manner, including
aggregates, statistical summaries, and the training of a wide variety
predictive models. Yet one of the most appealing uses of differential
privacy is the generation of synthetic data, which is a collection of
records matching the input schema, intended to be broadly represen-
tative of the source data. Differentially private synthetic data is an
active area of research [1, 2, 4, 10, 11, 18, 24, 26, 29, 30, 45, 47, 48, 50–
52, 54–57] and has also been the basis for two competitions, hosted
by the U.S. National Institute of Standards and Technology [43].
Private synthetic data is appealing because it fits any data pro-
cessing workflow designed for the original data, and, on its face,
the user may believe they can perform any computation they wish,
while still enjoying the benefits of privacy protection. Unfortu-
nately, it is well-known that there are limits to the accuracy that
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 15, No. 11 ISSN 2150-8097.
doi:10.14778/3551793.3551817
can be provided by synthetic data under differential privacy or any
other reasonable notion of privacy [13].
As a consequence, it is important to tailor synthetic data to some
class of tasks, and this is commonly done by asking the user to
provide a set of queries, called the workload, to which the synthetic
data can be tailored. However, as our experiments will show, exist-
ing workload-aware techniques often fail to outperform workload-
agnostic mechanisms, even when evaluated specifically on their
target workloads. Not only do these algorithms fail to produce ac-
curate synthetic data, but they provide no way for end-users to
detect the inaccuracy. As a result, in practical terms, differentially
private synthetic data generation remains an unsolved problem.
In this work, we advance the state-of-the-art of differentially
private synthetic data in two key ways. First, we propose a new
workload-aware mechanism that offers lower error than all com-
peting techniques. Second, we derive analytic expressions to bound
the per-query error of the mechanism with high probability.
Our mechanism, AIM, follows the select-measure-generate para-
digm, which can be used to describe many prior approaches.1 Mech-
anisms following this paradigm first select a set of queries, then
measure those queries in a differentially private way (through noise
addition), and finally generate synthetic data consistent with the
noisy measurements. We leverage Private-PGM [40] for the gener-
ate step, as it provides a robust and efficient method for combining
the noisy measurements into a single consistent representation
from which records can be sampled.
The low error of AIM is primarily due to innovations in the
select stage. AIM uses an iterative, greedy selection procedure, in-
spired by the popular MWEM algorithm for linear query answering.
Through careful analysis, we define a low-sensitivity quality score
function to determine the best marginal to measure next, which
takes into account: (i) how well the candidate marginal is already
estimated, (ii) the expected improvement measuring it can offer,
(iii) the relevance of the marginal to the workload, and (iv) the
available privacy budget. This new quality score is accompanied by
a host of other algorithmic techniques including adaptive selection
of rounds and budget-per-round, intelligent initialization, and new
set of candidates from which to select.
In conjunction with AIM, we develop new techniques to quan-
tify the uncertainty in query answers derived from the generated
synthetic data. The bounds on error are useful in practice to under-
stand which queries the synthetic data supports well, and which
it does not, and are therefore critical to avoid the mis-use of the
1Another common approach is based on GANs [19]. Recent research [46] has shown
that published GAN-based approaches rarely outperform simple baselines; therefore,
we do not compare with those techniques in this paper.
arXiv:2201.12677v2  [cs.DB]  13 Jun 2024

---

Table 1: Table of Notation
Symbol
Meaning
𝜖,𝛿, 𝜌
Privacy parameters
Ω
Domain
𝑑
Number of attributes
𝑥
Single record in Ω
𝐷
Dataset of records in Ω
𝑟
Subset of attributes
𝑀𝑟
Marginal query
𝑛𝑟
Domain size of attributes 𝑟
𝑊
Workload (marginal queries + weights
𝑐𝑟
Weight on marginal 𝑟in the workload
Δ
Sensitivity
𝑝
Distribution over Ω
S
Set of all distributions over Ω
𝑇
Number of rounds of MWEM+PGM
𝛼
Privacy budget split of AIM
𝑤𝑟
Weighted assigned to marginal 𝑟by AIM
data by downstream users, a danger that could limit the adoption of
synthetic data [27]. To the best of our knowledge, AIM is the first
synthetic data mechansim equipped with such guarantees.The prob-
lem of error quantification for data independent mechanisms like
the Laplace or Gaussian mechanism is trivial, as they provide unbi-
ased answers with known variance to all queries. The problem is
considerably more challenging for data-dependent mechanisms like
AIM, where complex post-processing is performed and only a sub-
set of workload queries have unbiased answers. Some mechanisms,
like MWEM, provide theoretical guarantees on their worst-case er-
ror, under suitable assumptions. However, this is an a priori bound
on error obtained from a theoretical analysis of the mechanism
under worst-case datasets. Instead, we develop an a posteriori error
analysis, derived from the intermediate differentially private mea-
surements used to produce the synthetic data. Our error estimates
therefore reflect the actual execution of AIM on the input data but
do not require any additional privacy budget for their calculation.
This paper makes the following contributions:
(1) In Section 3, we assess the prior work in the field, character-
izing different approaches via key distinguishing elements
and limitations, which brings clarity to a complex space.
(2) In Section 4, we propose AIM, a new mechanism for syn-
thetic data generation that is workload-aware (for work-
loads consisting of weighted marginals) as well as data-
aware.
(3) In Section 5, we derive analytic expressions to bound the
per-query error of AIM with high probability. These ex-
pressions can be used to construct confidence bounds.
(4) In Section 6, we conduct a comprehensive empirical evalu-
ation and show that AIM consistently outperforms all prior
work, improving error over the next best mechanism by
1.6× on average and up to 5.7× in some cases.
2
BACKGROUND
In this section we provide the requisite background on datasets,
marginals, and differential privacy needed to understand this work.
2.1
Data, Marginals, and Workloads
Data. A dataset 𝐷is a multiset of 𝑁records, each containing
potentially sensitive information about one individual. Each record
𝑥∈𝐷is a 𝑑-tuple (𝑥1, . . . ,𝑥𝑑). The domain of possible values for 𝑥𝑖
is denoted by Ω𝑖, which we assume is finite and has size |Ω𝑖| = 𝑛𝑖.
The full domain of possible values for 𝑥is thus Ω = Ω1 × · · · × Ω𝑑
which has size Î
𝑖𝑛𝑖= 𝑛. We use D to denote the set of all possible
datasets, which is equal to ∪∞
𝑁=0Ω𝑁.
Marginals. A marginal is a central statistic to the techniques
studied in this paper, as it captures low-dimensional structure com-
mon in high-dimensional data distributions. A marginal for a set
of attributes 𝑟is essentially a histogram over 𝑥𝑟: it is a table that
counts the number of occurrences of each 𝑡∈Ω𝑟.
Definition 1 (Marginal). Let 𝑟⊆[𝑑] be a subset of attributes,
Ω𝑟= Î
𝑖∈𝑟Ω𝑖, 𝑛𝑟= |Ω𝑟|, and 𝑥𝑟= (𝑥𝑖)𝑖∈𝑟. The marginal on 𝑟is a
vector 𝜇∈R𝑛𝑟, indexed by domain elements 𝑡∈Ω𝑟, such that each
entry is a count, i.e., 𝜇[𝑡] = Í
𝑥∈𝐷1[𝑥𝑟= 𝑡]. We let 𝑀𝑟: D →R𝑛𝑟
denote the function that computes the marginal on 𝑟, i.e., 𝜇= 𝑀𝑟(𝐷).
In this paper, we use the term marginal query to denote the
function 𝑀𝑟, and marginal to denote the vector of counts 𝜇=
𝑀𝑟(𝐷). With some abuse of terminology, we will sometimes refer
to the attribute subset 𝑟as a marginal query as well.
Workload. A workload is a collection of queries the synthetic
data should preserve well. It represents the measure by which we
will evaluate utility of different mechanisms. We want our mech-
anisms to take a workload as input and adapt intelligently to the
queries in it, providing synthetic data that is tailored to the queries
of interest. In this work, we focus on the special (but common) case
where the workload consists of a collection of weighted marginal
queries. Our utility measure is stated in Definition 2.
Definition 2 (Workload Error). A workload 𝑊consists of a list of
marginal queries 𝑟1, . . . ,𝑟𝑘where 𝑟𝑖⊆[𝑑], together with associated
weights 𝑐𝑖≥0. The error of a synthetic dataset ˆ𝐷is defined as:
Error(𝐷, ˆ𝐷) =
1
𝑘· |𝐷|
𝑘
∑︁
𝑖=1
𝑐𝑖

𝑀𝑟𝑖(𝐷) −𝑀𝑟𝑖( ˆ𝐷)

1
We measure error using a normalized 𝐿1 distance between the
true workload query answers and the synthetic workload query
answers. This 𝐿1 error metric is a common choice [7, 40, 54, 57];
although, alternatives have been considered in prior work including
𝐿∞error [3, 32, 33, 50] and 𝐿2 (squared) error [11, 36]. The 𝐿1 metric
is appealing because it captures the overall error better than the 𝐿∞
metric, and is easily interpretable. We also provide supplemental
evaluations with 𝐿∞and 𝐿2 error in Appendix J of the full paper.
2.2
Differential Privacy
Differential privacy protects individuals by bounding the impact
any one individual can have on the output of an algorithm. This is
formalized using the notion of neighboring datasets. Two datasets
𝐷, 𝐷′ ∈D are neighbors (denoted 𝐷∼𝐷′) if 𝐷′ can be obtained
from 𝐷by adding or removing a single record.
Definition 3 (Differential Privacy). A randomized mechanism
M : D →R satisfies (𝜖,𝛿)-differential privacy (DP) if for any

---

neighboring datasets 𝐷∼𝐷′ ∈D, and any subset of possible outputs
𝑆⊆R,
Pr[M(𝐷) ∈𝑆] ≤exp(𝜖) Pr[M(𝐷′) ∈𝑆] + 𝛿.
A key quantity needed to reason about the privacy of common
randomized mechanisms is the sensitivity, defined below.
Definition 4 (Sensitivity). Let 𝑓: D →R𝑝be a vector-valued
function of the input data. The 𝐿2 sensitivity of 𝑓is
Δ(𝑓) = max𝐷∼𝐷′ ∥𝑓(𝐷) −𝑓(𝐷′)∥2.
It is easy to verify that the 𝐿2 sensitivity of any marginal query
𝑀𝑟is 1, regardless of the attributes in 𝑟. This is because one individ-
ual can only contribute a count of one to a single cell of the output
vector. Below we introduce the two building block mechanisms
used in this work.
Definition 5 (Gaussian Mechanism). Let 𝑓: D →R𝑝be a vector-
valued function of the input data. The Gaussian Mechanism adds i.i.d.
Gaussian noise with scale 𝜎Δ(𝑓) to each entry of 𝑓(𝐷). That is,
M(𝐷) = 𝑓(𝐷) + 𝜎Δ(𝑓)N (0, I),
where I is a 𝑝× 𝑝identity matrix.
Definition 6 (Exponential Mechanism). Let 𝑞𝑟: D →R be quality
score function defined for all 𝑟∈R and let 𝜖≥0 be a real number.
Then the exponential mechanism outputs a candidate 𝑟∈R according
to the following distribution:
Pr[M(𝐷) = 𝑟] ∝exp
 𝜖
2Δ · 𝑞𝑟(𝐷)

,
where Δ = max𝑟∈R Δ(𝑞𝑟).
Our algorithm is defined using zCDP, an alternate version of
differential privacy definition which offers beneficial composition
properties. We convert to (𝜖,𝛿) guarantees when necessary.
Definition 7 (zero-Concentrated Differential Privacy (zCDP)). A
randomized mechanism M is 𝜌-zCDP if for any two neighboring
datasets 𝐷and 𝐷′, and all 𝛼∈(1, ∞), we have:
𝐷𝛼(M(𝐷) || M(𝐷′)) ≤𝜌· 𝛼,
where 𝐷𝛼is the Rényi divergence of order 𝛼.
Proposition 1 (zCDP of the Gaussian Mechanism [5]). The Gauss-
ian Mechanism satisfies
1
2𝜎2 -zCDP.
Proposition 2 (zCDP of the Exponential Mechanism [9]). The
Exponential Mechanism satisfies 𝜖2
8 -zCDP.
We rely on the following propositions to reason about multiple
adaptive invocations of zCDP mechanisms, and the translation from
zCDP to (𝜖,𝛿)-DP. The proposition below covers 2-fold adaptive
composition of zCDP mechanisms, and it can be inductively applied
to obtain analogous k-fold adaptive composition guarantees.
Proposition 3 (Adaptive Composition of zCDP Mechanisms [5]).
Let M1 : D →R1 be 𝜌1-zCDP and M2 : D×R1 →R2 be 𝜌2-zCDP.
Then the mechanism M = M2(𝐷, M1(𝐷)) is (𝜌1 + 𝜌2)-zCDP.
Proposition 4 (zCDP to DP [8]). If a mechanism M satisfies 𝜌-
zCDP, it also satisfies (𝜖,𝛿)-differential privacy for all 𝜖≥0 and
𝛿= min
𝛼>1
exp  (𝛼−1)(𝛼𝜌−𝜖)
𝛼−1

1 −1
𝛼
𝛼
.
2.3
Private-PGM
An important component of our approach is a tool called Private-
PGM [35, 37, 40]. For the purposes of this paper, we will treat
Private-PGM as a black box that exposes an interface for solving
subproblems important to our mechanism. We briefly summarize
Private-PGM and three core utilities it provides. Private-PGM con-
sumes as input a collection of noisy marginals of the sensitive data,
in the format of a list of tuples ( ˜𝜇𝑖, 𝜎𝑖,𝑟𝑖) for 𝑖= 1, . . . ,𝑘, where
˜𝜇𝑖= 𝑀𝑟𝑖(𝐷) + N (0, 𝜎2
𝑖I).2
Distribution Estimation. At the heart of Private-PGM is an
optimization problem to find a distribution ˆ𝑝that “best explains”
the noisy observations ˜𝜇𝑖:
ˆ𝑝∈argmin
𝑝∈S
𝑘
∑︁
𝑖=1
1
𝜎𝑖

𝑀𝑟𝑖(𝑝) −˜𝜇𝑖

2
2
Here S = {𝑝| 𝑝(𝑥) ≥0 and Í
𝑥∈Ω 𝑝(𝑥) = 𝑛} is the set of (scaled)
probability distributions over the domain Ω.3 When ˜𝜇𝑖are cor-
rupted with i.i.d. Gaussian noise, this is exactly a maximum like-
lihood estimation problem [35, 37, 40]. In general, convex opti-
mization over the scaled probability simplex is intractable for the
high-dimensional domains we are interested in. Private-PGM over-
comes this curse of dimensionality by exploiting the fact that the
objective only depends on 𝑝through its marginals. The key obser-
vation is that one of the minimizers of this problem is a graphical
model ˆ𝑝𝜃. The parameters 𝜃provide a compact representation of
the distribution 𝑝that we can optimize efficiently.
Junction Tree Size. The time and space complexity of Private-
PGM depends on the measured marginal queries in a nuanced
way, the main factor being the size of the junction tree implied
by the measured marginal queries [37, 39]. While understanding
the junction tree construction is not necessary for this paper, it is
important to note that Private-PGM exposes a callable function
JT-SIZE(𝑟1, . . . ,𝑟𝑘) that can be invoked to check how large a junc-
tion tree is. JT-SIZE is measured in megabytes, and the runtime of
distribution estimation is roughly proportional to this quantity. If
arbitrary marginals are measured, JT-SIZE can grow out of control,
no longer fitting in memory, and leading to unacceptable runtime.
Synthetic Data Generation. Given an estimated model ˆ𝑝,
Private-PGM implements a routine for generating synthetic tabular
data that approximately matches the given distribution. It achieves
this with a randomized rounding procedure, which is a lower vari-
ance alternative to sampling from ˆ𝑝[37].
3
PRIOR WORK ON SYNTHETIC DATA
In this section we survey the state of the field, describing basic
elements of a good synthetic data mechanism, along with novel-
ties of more sophisticated mechanisms. We focus our attention on
marginal-based approaches to differentially private synthetic data
in this section, as these have generally seen the most success in
practical applications. These mechanisms include PrivBayes [54],
PrivBayes+PGM [40], MWEM+PGM [40], MST [37], PrivSyn [57],
2Private-PGM is more general than this, but this is the most common setting.
3When using unbounded DP, 𝑛is sensitive and therefore we must estimate it.

---

Algorithm 1 MWEM+PGM
Input: Dataset 𝐷, workload 𝑊, privacy parameter 𝜌
Output: Synthetic Dataset ˆ𝐷
Hyper-Parameters: rounds 𝑇= 𝑑, budget split 𝛼= 0.9
Initialize ˆ𝑝0 = Uniform[X]
𝜖=
√︁
8(1 −𝛼)𝜌/𝑇
𝜎=
√︁
𝑇/2𝛼𝜌
for 𝑡= 1, . . . ,𝑇do
select 𝑟𝑡∈𝑊using exponential mechanism with 𝜖budget:
𝑞𝑟(𝐷) = ∥𝑀𝑟(𝐷) −𝑀𝑟( ˆ𝑝𝑡−1)∥1 −𝑛𝑟
measure marginal on 𝐶:
˜𝜇𝑡= 𝑀𝑟𝑡(𝐷) + N (0, 𝜎2I)
estimate data distribution using Private-PGM:
ˆ𝑝𝑡= argmin
𝑝∈𝑆
𝑡∑︁
𝑖=1

𝑀𝑟𝑖(𝑝) −𝑦𝑖

2
2
end for
generate synthetic data ˆ𝐷using Private-PGM:
return ˆ𝐷
RAP [3], GEM [33], and PrivMRF [7]. We will begin with a formal
problem statement:
Problem 1 (Workload Error Minimization). Given a workload
𝑊, our goal is to design an (𝜖,𝛿)-DP synthetic data mechanism
M : D →D such that the expected error defined in Definition 2 is
minimized.
3.1
The Select-Measure-Generate Paradigm
We begin by providing a broad overview of the basic approach
employed by many differentially private mechanisms for synthetic
data. These mechanisms all fit naturally into the select-measure-
generate framework. This framework represents a class of mech-
anisms which can naturally be broken up into 3 steps: (1) select
a set of queries, (2) measure those queries using a noise-addition
mechanism, and (3) generate synthetic data that explains the noisy
measurements well. We consider iterative mechanisms that alter-
nate between the select and measure step to be in this class as
well. Mechanisms within this class differ in their methodology for
selecting queries, the noise mechanism used, and the approach to
generating synthetic data from the noisy measurements.
MWEM+PGM, shown in Algorithm 1, is one mechanism from
this class that serves as a concrete example as well as the starting
point for our improved mechanism, AIM. As the name implies,
MWEM+PGM is a scalable instantiation of the well-known MWEM
algorithm [21] for linear query answering, where the multiplicative
weights (MW) step is replaced by a call to Private-PGM. It is a
greedy, iterative mechanism for workload-aware synthetic data
generation, and there are several variants. One variant is shown
in Algorithm 1. The mechanism begins by initializing an estimate
of the joint distribution to be uniform over the data domain. Then,
it runs for 𝑇rounds, and in each round it does three things: (1)
selects (via the exponential mechanism) a marginal query that is
poorly approximated under the current estimate, (2) measures the
selected marginal using the Gaussian mechanism, and (3) estimates
a new data distribution (using Private-PGM) that explains the noisy
measurements well. After 𝑇rounds, the estimated distribution is
used to generate synthetic tabular data. MWEM+PGM represents
one mechansim from this broad class, but many others are very
closely related to it. In fact, RAP and GEM can both be seen as
scalable instantiations of MWEM, that use different algorithms to
estimate the data distribution instead of Private-PGM. PrivMRF
is also closely related to MWEM+PGM (and uses Private-PGM),
with some minor differences in design decisions in other parts
of the algorithm. Algorithms like PrivBayes, MST, and PrivSyn
are also conceptually similar to MWEM+PGM, as they attempt
to select marginal queries that are poorly approximated under
a simple model. While all of these algorithms are conceptually
similar, each one makes different design decisions that may have
important performance implications in practice. In the subsequent
subsections, we will characterize existing mechanisms in terms
of how they approach these different aspects of the problem, and
discuss some of the design decisions made by these mechansism.
3.2
Basic Elements of a Good Mechanism
In this section we outline some basic criteria reasonable mecha-
nisms should satisfy to get good performance. These recommenda-
tions primarily apply to the measure step.
Measure Entire Marginals. Marginals are an appealing statistic
to measure because every individual contributes a count of one to
exactly one cell of the marginal. As a result, we can measure every
cell of 𝑀𝑟(𝐷) at the same privacy cost of measuring a single cell.
With a few exceptions [3, 33, 50], existing mechanisms utilize this
property of marginals or can be extended to use it. The alternative
of measuring a single counting query at a time sacrifices utility
unnecessarily.
Use Gaussian Noise. Back of the envelope calculations reveal
that if the number of measurements is greater than roughly log (1/𝛿)
+ 𝜖, which is often the case, then the standard deviation of the re-
quired Gaussian noise is lower than that of the Laplace noise. Many
newer mechanisms recognize this and use Gaussian noise, while
older mechanisms were developed with Laplace noise, but can easily
be adapted to use Gaussian noise instead.
Use Unbounded DP. For fixed (𝜖,𝛿), the required noise mag-
nitude is lower by a factor of
√
2 when using unbounded DP (add
/ remove one record) over bounded DP (modify one record). This
is because the 𝐿2 sensitivity of a marginal query 𝑀𝑟is 1 under un-
bounded DP, and
√
2 under bounded DP. We remark that these two
different definitions of DP are qualitatively different, and because
of that, the privacy parameters have different interpretations. The
√
2 difference could be recovered in bounded DP by increasing the
privacy budget appropriately. In some cases, the privacy model
is imposed externally, in which case it is better if the mechanism
naturally supports both bounded and unbounded DP. When either
privacy definition is acceptable, as in recent NIST competitions
[43], unbounded DP should be preferred.

---

Table 2: Taxonomy of select-measure-generate mechanisms.
Name
Year
Workload
Data
Budget
Efficiency
Aware
Aware
Aware
Aware
Independent
-
✓
Gaussian
-
✓
PrivBayes [54]
2014
✓
✓
✓
HDMM+PGM [40]
2019
✓
PrivBayes+PGM [40]
2019
✓
✓
✓
MWEM+PGM [40]
2019
✓
✓
PrivSyn [57]
2020
✓
✓
✓
MST [37]
2021
✓
✓
RAP [3]
2021
✓
✓
✓
GEM [33]
2021
✓
✓
✓
PrivMRF [7]
2021
✓
✓
✓
AIM [This Work]
2022
✓
✓
✓
✓
Devote more Budget to the Measure Step. For mechanisms that
select marginal queries based on the data, the privacy budget must
be split between the select step and the measure step. A simple
50/50 split is usually suboptimal, and it is often better to allocate
the majority of the privacy budget for the measure step. Indeed,
prior work has reported 10/90 splits to work well empirically in a
variety of settings [7, 57]. Intuitively, this uneven split makes sense
because the statistics needed to select marginal queries are often
coarser grained aggregations than the marginal queries themselves,
and as a result are more robust to noise.
Summary. The implementation of MWEM+PGM in Algorithm 1
gets these basic elements right. This particular implementation of
MWEM+PGM is new — the original measured a single counting
query per round, used Laplace noise, bounded DP, and an even
select/measure budget split [21, 40]. While the modifications made
are simple, as we will show in Section 6.3, they have a substantial
influence on the performance of the mechanism in practice.
3.3
Distinguishing Elements of Existing Work
Beyond the basics, different mechanisms exhibit different novel-
ties, and understanding the design considerations underlying the
existing work can be enlightening. We provide a simple taxonomy
of this space in Table 2 in terms of four criteria: workload-, data-,
budget-, and efficiency-awareness. These characteristics primarily
pertain to the select step of each mechanism.
Workload-awareness. Different mechanisms select from a dif-
ferent set of candidate marginal queries. PrivBayes and PrivMRF,
for example, select from a particular subset of 𝑘-way marginals, de-
termined from the data. Other mechanisms, like MST and PrivSyn,
restrict the set of candidates to 2-way marginal queries. On the other
end of the spectrum, the candidates considered by MWEM+PGM,
RAP, and GEM, are exactly the marginal queries in the workload.
This is appealing, since these mechanisms will not waste the privacy
budget to measure marginals that are not relevant to the workload.
Data-awareness. Many mechanisms select marginal queries
from a set of candidates based on the data, and are thus data-aware.
For example, MWEM+PGM selects marginal queries using the
exponential mechanism with a quality score function that depends
on the data. Independent, Gaussian, and HDMM+PGM are the
exceptions, as they always select the same marginal queries no
matter what the underlying data distribution is.
Budget-awareness. Another aspect of different mechanisms is
how well do they adapt to the privacy budget available. Some mech-
anisms, like PrivBayes, PrivSyn, and PrivMRF recognize that we
can afford to measure more (or larger) marginals when the privacy
budget is sufficiently large. When the privacy budget is limited,
these mechanisms recognize that fewer (and smaller) marginals
should be measured instead. In contrast, the number and size of the
marginals selected by mechanisms like MST, MWEM+PGM, RAP,
and GEM does not depend on the privacy budget available.4
Efficiency-awareness. Mechanisms that build on top of Private-
PGM must take care when selecting measurements to ensure JT-
SIZE remains sufficiently small to ensure computational tractability.
Among these, PrivBayes+PGM, MST, and PrivMRF all have built-in
heuristics in the selection criteria to ensure the selected marginal
queries give rise to a tractable model. Gaussian, HDMM+PGM and
MWEM+PGM have no such safeguards, and they can sometimes
select marginal queries that lead to intractable models. In the ex-
treme case, when the workload is all 2-way marginals, Gaussian
selects all 2-way marginals, the model required for Private-PGM
explodes to the size of the entire domain, which is often intractable.
Mechanisms that utilize different techniques for post-processing
noisy marginals into synthetic data, like PrivSyn, RAP, and GEM,
do not have this limitation, and are free to select from a wider
collection of marginals. While these methods do not suffer from
this particular limitation of Private-PGM, they have other pros and
cons which were surveyed in a recent article [35].
Summary. With the exception of our new mechanism AIM, no
mechanism listed in Table 2 is aware of all four factors we discussed.
Mechanisms that do not have four checkmarks in Table 2 are not
necessarily bad, but there are clear ways in which they can be
improved. Conversely, mechanisms that have more checkmarks
than other mechanisms are not necessarily better. For example,
Independent only has one checkmark, but as we show in Section 6,
it sometimes outperforms mechanisms with three checkmarks.
3.4
Other Design Considerations
Beyond these four characteristics summarized in the previous sec-
tion, different methods make different design decisions that are
relevant to mechanism performance, but do not correspond to the
four criteria discussed in the previous section. In this section, we
summarize some of those additional design considerations.
Selection method. Some mechanisms select marginals to mea-
sure in a batch, while other mechanisms select them iteratively.
Generally speaking, iterative methods like MWEM+PGM, RAP,
GEM, and PrivMRF are preferable to batch methods, because the
selected marginals will capture important information about the
distribution that was not effectively captured by the previously mea-
sured marginals. On the other hand, PrivBayes, MST, and PrivSyn
select all the marginals before measuring any of them. It is not dif-
ficult to construct examples where a batch method like PrivSyn has
4The number of rounds to run MWEM+PGM, RAP, and GEM is a hyper-parameter,
and the best setting of this hyper-parameter depends on the privacy budget available.

---

suboptimal behavior. For example, suppose the data contains three
perfectly correlated attributes. We can expect iterative methods to
capture the distribution after measuring any two 2-way marginals.
On the other hand, a batch method like PrivSyn will determine that
all three 2-way marginals need to be measured.
Budget split. Every mechanism in this discussion, except for
PrivSyn, splits the privacy budget equally among selected marginals.
This is a simple and natural thing to do, but it does not account
for the fact that larger marginals have smaller counts that are less
robust to noise, requiring a larger fraction of the privacy budget to
answer accurately. PrivSyn provides a simple formula for dividing
privacy budget among marginals of different sizes, but this approach
is inherently tied to their batch selection methodology. It is much
less clear how to divide the privacy budget within a mechanism
that uses an iterative selection procedure.
Hyperparameters. All mechanisms have some hyperparame-
ters than can be tuned to affect the behavior of the mechanism.
Mechanisms like PrivBayes, MST, PrivSyn, and PrivMRF have rea-
sonable default values for these hyperparameters, and these mech-
anisms can be expected to work well out of the box. On the other
hand, MWEM+PGM, RAP, and GEM have to tune the number of
rounds to run, and it is not obvious how to select this a priori. While
the open source implementations may include a default value, the
experiments conducted in the respective papers did not use these
default values, in favor of non-privately optimizing over this hyper-
parameter for each dataset and privacy level considered [3, 33].
4
AIM: AN ADAPTIVE AND ITERATIVE
MECHANISM FOR SYNTHETIC DATA
While MWEM+PGM is a simple and intuitive algorithm, it leaves
significant room for improvement, even after getting the basic ele-
ments right. Our new mechanism, AIM, is presented in Algorithm 2.
In this section, we describe the differences between MWEM+PGM
and AIM, the justifications for the relevant design decisions, as well
as prove the privacy of AIM.
Intelligent Initialization. In Line 7 of AIM, we spend a small
fraction of the privacy budget to measure 1-way marginals in the
set of candidates. Estimating ˆ𝑝from these noisy marginals gives
rise to an independent model where all 1-way marginals are pre-
served well, and higher-order marginals can be estimated under
an independence assumption. Intuitively, this feature of AIM is
justified by the fact that MWEM+PGM tends to select marginal
queries covering disjoint attribute subsets in the first few rounds in
an attempt to correctly preserve the 1-way marginal distributions.
By measuring all 1-way marginals immediately instead, we are
saving the privacy budget that would otherwise be spent to select
these marginal queries.
New Candidates. In Line 13 of AIM, we make two notable
modifications to the candidate set that serve different purposes.
Specifically, the set of candidates is a carefully chosen subset of
the marginal queries in the downward closure of the workload. The
downward closure of the workload is the set of marginal queries
whose attribute sets are subsets of some marginal query in the
workload, i.e., 𝑊+ = {𝑟| 𝑟⊆𝑠,𝑠∈𝑊}.
Algorithm 2 AIM: An Adaptive and Iterative Mechanism
1: Input: Dataset 𝐷, workload 𝑊, privacy parameter 𝜌
2: Output: Synthetic Dataset ˆ𝐷
3: Hyper-Parameters: MAX-SIZE=80MB, 𝑇= 16𝑑, 𝛼= 0.9
4: 𝜎0 =
√︁
𝑇/(2 𝛼𝜌)
5: 𝜌𝑢𝑠𝑒𝑑= 0
6: 𝑡= 0
7: Initialize ˆ𝑝𝑡using Algorithm 3
8: 𝑤𝑟= Í
𝑠∈𝑊𝑐𝑠| 𝑟∩𝑠|
9: 𝜎𝑡+1 ←𝜎0
𝜖𝑡+1 ←
√︁
8(1 −𝛼)𝜌/𝑇
10: while 𝜌𝑢𝑠𝑒𝑑< 𝜌do
11:
𝑡= 𝑡+ 1
12:
𝜌𝑢𝑠𝑒𝑑←𝜌𝑢𝑠𝑒𝑑+ 1
8𝜖2
𝑡+
1
2𝜎2
𝑡
13:
𝐶𝑡= {𝑟𝑡∈𝑊+ | JT-SIZE(𝑟1, . . . ,𝑟𝑡)) ≤𝜌𝑢𝑠𝑒𝑑
𝜌
· MAX-SIZE}
14:
select 𝑟𝑡∈𝐶𝑡using the exponential mechanism with:
𝑞𝑟(𝐷) = 𝑤𝑟

∥𝑀𝑟(𝐷) −𝑀𝑟( ˆ𝑝𝑡−1)∥1 −
√︁
2/𝜋· 𝜎𝑡· 𝑛𝑟

15:
measure marginal on 𝑟𝑡:
˜𝑦𝑡= 𝑀𝑟𝑡(𝐷) + N (0, 𝜎2
𝑡I)
16:
estimate data distribution using Private-PGM:
ˆ𝑝𝑡= argmin
𝑝∈𝑆
𝑡∑︁
𝑖=1
1
𝜎𝑖

𝑀𝑟𝑖(𝑝) −˜𝑦𝑖

2
2
17:
anneal 𝜖𝑡+1 and 𝜎𝑡+1 using Algorithm 4
18: end while
19: generate synthetic data ˆ𝐷from ˆ𝑝𝑡using Private-PGM
20: return ˆ𝐷
Algorithm 3 Initialize 𝑝𝑡(subroutine of Algorithm 2)
1: for 𝑟∈{𝑟∈𝑊+ | |𝑟| = 1} do
2:
𝑡= 𝑡+ 1
𝜎𝑡←𝜎0
𝑟𝑡←𝑟
3:
˜𝑦𝑡= 𝑀𝑟(𝐷) + N (0, 𝜎2
𝑡I)
4:
𝜌𝑢𝑠𝑒𝑑←𝜌𝑢𝑠𝑒𝑑+
1
2𝜎2
𝑡
5: end for
6: ˆ𝑝𝑡= argmin𝑝∈𝑆
Í𝑡
𝑖=1
1
𝜎𝑖

𝑀𝑟𝑖(𝑝) −˜𝑦𝑖

2
2
Using the downward closure is based on the observation that
marginals with many attributes have low counts, and answering
them directly with a noise addition mechanism may not provide an
acceptable signal to noise ratio. In these situations, it may be better
to answer lower-dimensional marginals, as these tend to exhibit a
better signal to noise ratio, while still being useful to estimate the
higher-dimensional marginals in the workload.
We filter candidates from this set that do not meet a specific
model capacity requirement. Specifically, the set will only consist
of candidates that, if selected, will lead to a JT-SIZE below a pre-
specified limit (the default is 80 MB). This ensures that AIM will
never select candidates that lead to an intractable model, and hence
allows the mechanism to execute consistently with a predictable
memory footprint and runtime.

---

Algorithm 4 Budget annealing (subroutine of Algorithm 2)
1: if

𝑀𝑟𝑡( ˆ𝑝𝑡) −𝑀𝑟𝑡( ˆ𝑝𝑡−1)

1 ≤
√︁
2/𝜋· 𝜎𝑡· 𝑛𝑟𝑡then
2:
𝜖𝑡+1 ←2 · 𝜖𝑡
3:
𝜎𝑡+1 ←𝜎𝑡/2
4: else
5:
𝜖𝑡+1 ←𝜖𝑡
6:
𝜎𝑡+1 ←𝜎𝑡
7: end if
8: if (𝜌−𝜌𝑢𝑠𝑒𝑑) ≤2 1
2𝜎2
𝑡+1 + 1
8𝜖2
𝑡+1
 then
9:
𝜖𝑡+1 =
√︁
8 · (1 −𝛼) · (𝜌−𝜌𝑢𝑠𝑒𝑑)
10:
𝜎𝑡+1 =
√︁
1/(2 · 𝛼· (𝜌−𝜌𝑢𝑠𝑒𝑑))
11: end if
Better Selection Criteria. In Line 14 of AIM, we make two mod-
ifications to the quality score function for marginal query selection
to better reflect the utility we expect from measuring the selected
marginal. In particular, our new quality score function is
𝑞𝑟(𝐷) = 𝑤𝑟
  ∥𝑀𝑟(𝐷) −𝑀𝑟(𝑝𝑡−1)∥1 −
√︁
2/𝜋· 𝜎𝑡· 𝑛𝑟
,
(1)
which differs from MWEM+PGM’s quality score function 𝑞𝑟(𝐷) =
∥𝑀𝑟(𝐷) −𝑀𝑟(𝑝𝑡−1)∥−𝑛𝑟in two ways.
First, the expression inside parentheses can be interpreted as
the expected improvement in 𝐿1 error we can expect by measuring
that marginal. It consists of two terms: the 𝐿1 error under the
current model minus the expected 𝐿1 error if it is measured at the
current noise level (Theorem 5 in the full paper [38]). Compared
to the quality score function in MWEM+PGM, this quality score
function penalizes larger marginals to a much more significant
degree, since 𝜎𝑡≫1 in most cases. Moreover, this modification
makes the selection criteria “budget-adaptive”, since it recognizes
that we can afford to measure larger marginals when 𝜎𝑡is smaller,
and we should prefer smaller marginals when 𝜎𝑡is larger.
Second, we give different marginal queries different weights to
capture how relevant they are to the workload. In particular, we
weight the quality score function for a marginal query 𝑟using
the formula 𝑤𝑟= Í
𝑠∈𝑊𝑐𝑠| 𝑟∩𝑠|, as this captures the degree
to which the marginal queries in the workload overlap with 𝑟. In
general, this weighting scheme places more weight on marginals
involving more attributes. Note that now the sensitivity of 𝑞𝑟is 𝑤𝑟
rather than 1. Thus, to apply the exponential mechanism to select a
candidate, we use Δ𝑡= max𝑟∈𝐶𝑡𝑤𝑟. A nice property of using 𝑤𝑟as
a multiplicative weight is a certain invariance to how the workload
is represented: in particular, the behavior of AIM is identical in the
two cases where (1) two copies of a marginal query are included in
the workload, (2) the marginal query appears once with a weight
of two. This is not true of MWEM+PGM, which generally has
different behavior based on how the workload is represented.
This quality score function exhibits an interesting trade-off: the
penalty term
√︁
2/𝜋𝜎𝑡𝑛𝑟discourages marginals with more cells,
while the weight 𝑤𝑟favors marginals with more attributes. How-
ever, if the inner expression is negative, then the larger weight will
make it more negative, and much less likely to be selected.
Adaptive Rounds and Budget Split. In Lines 12 and 17 of
AIM, we introduce logic to modify the per-round privacy budget as
execution progresses, and as a result, eliminate the need to provide
the number of rounds up front. This makes AIM hyper-parameter
free, relieving practitioners from that often overlooked burden.
Specifically, we use a simple annealing procedure (Algorithm 4)
that gradually increases the budget per round when an insufficient
amount of information is learned at the current per-round bud-
get. The annealing condition is activated if the difference between
𝑀𝑟𝑡( ˆ𝑝𝑡) and 𝑀𝑟𝑡( ˆ𝑝𝑡−1) is small, which indicates that not much in-
formation was learned in the previous round. If it is satisfied, then
𝜖𝑡for is doubled, while 𝜎𝑡is cut in half.
This check can pass for two reasons: (1) there were no good
candidates (all scores are low in Equation (1)) in which case increas-
ing 𝜎𝑡will make more candidates good, and (2) there were good
candidates, but they were not selected because there was too much
noise in the select step, which can be remedied by increasing 𝜖𝑡.
The precise annealing threshold used is
√︁
2/𝜋· 𝜎𝑡· 𝑛𝑟𝑡, which is
the expected error of the noisy marginal, and an approximation for
the expected error of ˆ𝑝𝑡on marginal 𝑟. When the available privacy
budget is small, this condition will be activated more frequently,
and as a result, AIM will run for fewer rounds. Conversely, when
the available privacy budget is large, AIM will run for many rounds
before this condition activates.
As 𝜎𝑡decreases throughout execution, quality scores generally
increase, and it has the effect of “unlocking” new candidates that
previously had negative quality scores. We initialize 𝜎𝑡and 𝜖𝑡con-
servatively, assuming the mechanism will be run for𝑇= 16𝑑rounds.
This is an upper bound on the number of rounds that AIM will run,
but in practice the number of rounds will be much less.
Privacy Analysis. The privacy analysis of AIM utilizes the
notion of a privacy filter [9, 15, 44], and the algorithm runs until
the realized privacy budget spent matches the total privacy budget
available, 𝜌. To ensure that the budget is not over-spent, there
is a special condition (Line 8 in Algorithm 4) that checks if the
remaining budget is insufficient for two rounds at the current 𝜖𝑡
and 𝜎𝑡parameters. If this condition is satisfied, 𝜖𝑡and 𝜎𝑡are set to
use up all of the remaining budget in one final round of execution.
Theorem 1. For any𝑇≥𝑑, 𝛼∈(0, 1), 𝜌≥0, AIM satisfies 𝜌-zCDP.
Proof. There are three steps in AIM that depend on the sen-
sitive data: initialization, selection, and measurement. The initial-
ization step satisfies 𝜌0-zCDP for 𝜌0 = |{𝑟∈𝑊+ | |𝑟| = 1}|/2𝜎2
0 ≤
𝑑/2𝜎2
0 = 2𝛼𝑑𝜌/2𝑇≤𝜌. For this step, all we need is that the privacy
budget is not over-spent. The remainder of AIM runs until the
budget is consumed. Each step of AIM involves one invocation of
the exponential mechanism, and one invocation of the Gaussian
mechanism. By Propositions 1 to 3, round 𝑡of AIM is 𝜌𝑡-zCDP for
𝜌𝑡= 1
8𝜖2
𝑡/8 + 1/2𝜎2
𝑡. Note that at round 𝑡, 𝜌𝑢𝑠𝑒𝑑= Í𝑡
𝑖=0 𝜌𝑖, and by
Theorem 3.1 of [15], it suffices to show that 𝜌𝑢𝑠𝑒𝑑never exceeds
𝜌. There are two cases to consider: the condition in Line 8 of Algo-
rithm 4 is either true or false. If it is true, then we know after round
𝑡that 𝜌−𝜌𝑢𝑠𝑒𝑑≥2𝜌𝑡+1, i.e., the remaining budget is enough to run
round 𝑡+ 1 without over-spending the budget. If it is false, then we
modify 𝜖𝑡+1 and 𝜌𝑡+1 to exactly use up the remaining budget. Specif-
ically, 𝜌𝑡+1 = 8(1 −𝛼)(𝜌−𝜌𝑢𝑠𝑒𝑑)/8 + 2𝛼(𝜌−𝜌𝑢𝑠𝑒𝑑)/2 = 𝜌−𝜌𝑢𝑠𝑒𝑑.
As a result, when the condition is true, 𝜌𝑢𝑠𝑒𝑑at time 𝑡+ 1 is exactly

---

𝜌, and after that iteration, the main loop of AIM terminates. The
remainder of the mechanism does not access the data.
□
5
UNCERTAINTY QUANTIFICATION
We now propose a solution to the uncertainty quantification prob-
lem for AIM. Our method uses information from both the noisy
marginals, measured with Gaussian noise, and the marginal queries
selected by the exponential mechanism. The method does not re-
quire additional privacy budget, as it quantifies uncertainty only
by analyzing the private outputs of AIM. We give guarantees for
marginals in the (downward closure of the) workload, which is
exactly the set of marginals the analyst cares about. Providing
guarantees for marginals outside this set is an area for future work.
We break our analysis up into two cases: the “easy” case, where
we have access to unbiased answers for a particular marginal, and
the “hard” case, where we do not. In both cases, we identify an
estimator for a marginal whose error we can bound with high
probability. Then, we connect the error of this estimator to the error
of the synthetic data by invoking the triangle inequality. Proofs of
all statements in this section appear in the full paper [38].
The Easy Case: Supported Marginal Queries. A marginal
query r is “supported” whenever 𝑟⊆𝑟𝑡for some 𝑡. In this case,
we can readily obtain an unbiased estimate of 𝑀𝑟(𝐷) from 𝑦𝑡, and
analytically derive the variance of that estimate. If there are multiple
𝑡satisfying the condition above, we have multiple estimates we
can use to reduce the variance. We can combine these independent
estimates to obtain a weighted average estimator:
Theorem 2 (Weighted Average Estimator). Let𝑟1, . . . ,𝑟𝑡and𝑦1, . . . ,𝑦𝑡
be as defined in Algorithm 2, and let 𝑅= {𝑟1, . . . ,𝑟𝑡}. For any 𝑟∈𝑅+,
there is an (unbiased) estimator ¯𝑦𝑟= 𝑓𝑟(𝑦1, . . . ,𝑦𝑡) such that:
¯𝑦𝑟∼N (𝑀𝑟(𝐷), ¯𝜎2
𝑟I) where
¯𝜎2
𝑟=
h
𝑡∑︁
𝑖=1
𝑟⊆𝑟𝑖
𝑛𝑟
𝑛𝑟𝑖𝜎2
𝑖
i −1
,
While this is not the only (or best) estimator to use [12], the sim-
plicity allows us to easily bound its error, as we show in Theorem 3.
Theorem 3 (Confidence Bound). Let ¯𝑦𝑟be the estimator from The-
orem 2. Then, for any 𝜆≥0, with probability at least 1 −exp (−𝜆2):
∥𝑀𝑟(𝐷) −¯𝑦𝑟∥1 ≤
√︁
2 log 2¯𝜎𝑟𝑛𝑟+ 𝜆¯𝜎𝑟
√2𝑛𝑟
Note that Theorem 3 gives a guarantee on the error of ¯𝑦𝑟, but
we are ultimately interested in the error of ˆ𝐷. Fortunately, it easy
easy to relate the two by using the triangle inequality:
Corollary 1. Let ˆ𝐷be any synthetic dataset, and let ¯𝑦𝑟be the esti-
mator from Theorem 2. Then with probability at least 1 −exp (−𝜆2):

𝑀𝑟(𝐷) −𝑀𝑟( ˆ𝐷)

1 ≤

𝑀𝑟( ˆ𝐷) −¯𝑦𝑟

1 +
√︁
2 log 2¯𝜎𝑟𝑛𝑟+ 𝜆¯𝜎𝑟
√2𝑛𝑟
The LHS is what we are interested in bounding, and we can
readily compute the RHS from the output of AIM. The RHS is a
random quantity that, with the stated probability, upper bounds
the error. When we plug in the realized values we get a concrete
numerical bound that can be interpreted as a (one-sided) confidence
interval. In general, we expect 𝑀𝑟( ˆ𝐷) to be close to ¯𝑦𝑟, so the error
bound for ˆ𝐷will not be that much larger than that of ¯𝑦𝑟.5
The Hard Case: Unsupported Marginal Queries. We now
shift our attention to the hard case, providing guarantees about
the error of different marginals even for unsupported marginal
queries (those not selected during execution of AIM). This problem
is significantly more challenging. Our key insight is that marginal
queries not selected have relatively low error compared to the mar-
ginal queries that were selected. We can easily bound the error of
selected queries and relate that to non-selected queries by utilizing
the guarantees of the exponential mechanism. In Theorem 4 be-
low, we provide expressions that capture the uncertainty of these
marginals with respect to ˆ𝑝𝑡−1, the iterates of AIM.
Theorem 4 (Confidence Bound). Let 𝜎𝑡,𝜖𝑡,𝑟𝑡, ˜𝑦𝑡,𝐶𝑡, ˆ𝑝𝑡be as de-
fined in Algorithm 2, and let Δ𝑡= max𝑟∈𝐶𝑡𝑤𝑟. For all 𝑟∈𝐶𝑡, with
probability at least 1 −𝑒−𝜆2
1/2 −𝑒−𝜆2:
∥𝑀𝑟(𝐷) −𝑀𝑟( ˆ𝑝𝑡−1)∥1 ≤𝑤−1
𝑟
 𝐵𝑟+ 𝜆1𝜎𝑡√𝑛𝑟𝑡+ 𝜆2
2Δ𝑡
𝜖𝑡

where 𝐵𝑟is equal to:
𝑤𝑟𝑡

𝑀𝑟𝑡( ˆ𝑝𝑡−1) −𝑦𝑡

1
|                 {z                 }
estimated error on 𝑟𝑡
+
√︁
2/𝜋𝜎𝑡
 𝑤𝑟𝑛𝑟−𝑤𝑟𝑡𝑛𝑟𝑡

|                          {z                          }
relationship to
non-selected candidates
+ 2Δ𝑡
𝜖𝑡
log (|𝐶𝑡|)
|            {z            }
uncertainty from
exponential mech.
We can readily compute 𝐵𝑟from the output of AIM, and use it
to provide a bound on error in the form of a one-sided confidence
interval that captures the true error with high probability. While
these error bounds are expressed with respect to ˆ𝑝𝑡−1, they can
readily be extended to give a guarantee with respect to ˆ𝐷.
Corollary 2. Let ˆ𝐷be any synthetic dataset, and let 𝐵𝑟be as defined
in Theorem 4. Then with probability at least 1 −𝑒−𝜆2
1/2 −𝑒−𝜆2:

𝑀𝑟(𝐷) −𝑀𝑟( ˆ𝐷)

1
≤

𝑀𝑟( ˆ𝐷) −𝑀𝑟( ˆ𝑝𝑡−1)

1 + 𝑤−1
𝑟
 𝐵𝑟+ 𝜆1𝜎𝑡√𝑛𝑟𝑡+ 𝜆2
2Δ𝑡
𝜖𝑡

Again, the LHS is what we are interested in bounding, and we
can compute the RHS from the output of AIM. We expect ˆ𝑝𝑡−1 to
be reasonably close to ˆ𝐷, especially when 𝑡is larger, so this bound
will often be comparable to the original bound on ˆ𝑝𝑡−1.
Putting it Together. We’ve provided guarantees for both sup-
ported and unsupported marginals. The guarantees for unsupported
marginals also apply for supported marginals, although we gener-
ally expect them to be looser. In addition, there is one guarantee
for each round of AIM. It is tempting to use the bound that provides
the smallest estimate, although unfortunately doing this invalidates
the bound. To ensure a valid bound, we must pick only one round,
and that cannot be decided based on the value of the bound. A
natural choice is to use only the last round, for three reasons: (1)
𝜎𝑡is smallest and 𝜖𝑡is largest in that round, (2) the error of ˆ𝑝𝑡
generally goes down with 𝑡, and (3) the distance between ˆ𝑝𝑡and
5From prior experience, we might expect the error of ˆ𝐷to be lower than the error of
¯𝑦𝑟[40, 41], so we are paying for this difference by increasing the error bound when
we might hope to save instead. Unfortunately, this intuition does not lend itself to a
clear analysis that provides better guarantees.

---

ˆ𝐷should be the smallest in the last round. However, there may
be some marginal queries which were not in the candidate set for
that round. To bound the error on these marginals, we use the last
round where that marginal query was in the candidate set.
6
EXPERIMENTS
In this section we empirically evaluate AIM, comparing it to a
collection of state-of-the-art mechanisms and baseline mechanisms
for a variety of workloads, datasets, and privacy levels.
6.1
Experimental Setup
Datasets. Our evaluation includes datasets with varying size
and dimensionality. We describe our exact pre-processing scheme
in the full paper [38], and summarize the pre-processed datasets
and their characteristics in the table below.
Table 3: Summary of datasets used in the experiments.
Dataset
Records
Dimensions
Min/Max
Total
Domains
Domain Size
adult [28]
48842
15
2–42
4 × 1016
salary [23]
135727
9
3–501
1 × 1013
msnbc [6]
989818
16
18
1 × 1020
fire [43]
305119
15
2–46
4 × 1015
nltcs [34]
21574
16
2
7 × 104
titanic [17]
1304
9
2–91
9 × 107
Workloads. We consider 3 workloads for each dataset, all-
3way, target, and skewed. Each workload contains a collection of
3-way marginal queries. The all-3way workload contains queries
for all 3-way marginals. The target workload contains queries
for all 3-way marginals involving some specified target attribute.
For the adult and titanic datasets, these are the income>50K
attribute and the Survived attribute, as those correspond to the
attributes we are trying to predict for those datasets. For the other
datasets, the target attribute is chosen uniformly at random. The
skewed workload contains a collection of 3-way marginal queries
biased towards certain attributes and attribute combinations. In par-
ticular, each attribute is assigned a weight sampled from a squared
exponential distribution. 256 triples of attributes are sampled with
probability proportional to the product of their weights. This results
in workloads where certain attributes appear far more frequently
than others, and is intended to capture the situation where analysts
focus on a small number of interesting attributes. In Appendix K,
we provide results on a fourth workload, all-2way as well. All
randomness in the construction of the workload was done with a
fixed random seed, to ensure that the workloads remain the same
across executions of different mechanisms and parameter settings.
Mechanisms. We compare against both workload-agnostic and
workload-aware mechanisms in this section. The workload-agnostic
mechanisms we consider are PrivBayes+PGM, MST, PrivMRF. The
workload-aware mechanisms we consider are MWEM+PGM, RAP,
GEM, and AIM. We set the hyper-parameters of every mechanism
to default values available in their open source implementations.
While these default hyper-parameters may be suboptimal, we con-
ducted sensitivity experiments in Appendix I to evaluate the impact
of hyper-parameters on the performance of competing mechanisms,
and found that the improvement in utility from optimizing hyper-
parameters is outweighed by the cost to privacy needed to run
an appropriate DP hyper-parameter selection mechanism. We also
consider baseline mechanisms: Independent and Gaussian. The for-
mer measures all 1-way marginals using the Gaussian mechanism,
and generates synthetic data using an independence assumption.
The latter answers all queries in the workload using the Gaussian
mechanism (using the optimal privacy budget allocation described
in [57]). Note that this mechanism does not generate synthetic data,
only query answers.
Privacy Budgets. We consider a wide range of privacy param-
eters, varying 𝜖∈[0.01, 100.0] and setting 𝛿= 10−9. The most
practical regime is 𝜖∈[0.1, 10.0], but mechanism behavior at the
extremes can be enlightening so we include them as well.
Evaluation. For each dataset, workload, and 𝜖, we run each
mechanism for 5 trials, and measure the workload error from Defi-
nition 2. We report the average workload error across the five trials,
along with error bars corresponding to the minimum and maximum
workload error observed across the five trials. In Appendix J, we
evaluate error using 𝐿2 and 𝐿inf error metrics as well.
Runtime Environment. We ran most experiments on a single
core of a compute cluster with a 4 GB memory limit and a 24 hour
time limit.6 These resources were not sufficient to run PrivMRF or
RAP, so we utilized different machines to run those mechanisms.
PrivMRF requires a GPU to run, so we used one node a different
compute cluster, which has a Nvidia GeForce RTX 2080 Ti GPU. RAP
required significant memory resources, so we ran those experiments
on a machine with 16 cores and 64 GB of RAM.
6.2
Experimental Results
Experimental results are shown in Figure 1. Results for the titanic
dataset are omitted due to space. Workload-aware mechanisms are
shown by solid lines, while workload-agnostic mechanisms are
shown with dotted lines. Some points are missing from the plots,
indicating a mechanism failed to complete in under the 24 hour
time limit for that experimental setting. From these plots, we make
the following observations:
all-3way Workload.
(1) AIM consistently achieves competitive workload error, across
all datasets and privacy regimes considered. On average,
across all six datasets and nine privacy parameters, AIM
improved over PrivMRF by a factor of 1.3×, MST by a factor
of 2.6×, MWEM+PGM by a factor of 1.5×, PrivBayes+PGM
by a factor 2.2×, RAP by a factor 5.6×, and GEM by a fac-
tor 2.0×. In the most extreme cases, AIM improved over
PrivMRF by a factor 3.6×, MST by a factor 118×, MWEM+PGM
by a factor 16×, PrivBayes+PGM by a factor 14.7×, RAP by
a factor 47.1×, and GEM by a factor 11.7×.
(2) Prior to AIM, PrivMRF was consistently the best perform-
ing mechanism, even outperforming all workload-aware
mechanisms. The all-3way workload is one we expect
workload agnostic mechanisms like PrivMRF to perform
6These experiments usually completed in well under the time limit.

---

AIM
PrivMRF
MST
Privbayes+PGM
MWEM+PGM
GEM
RAP
Independent
Gaussian
10
1
100
Adult
All-3Way
Target
Skewed
10
2
10
1
100
Salary
10
2
10
1
100
MSNBC
10
2
10
1
100
Fire
10
2
10
1
100
101
102
Epsilon
10
3
10
2
10
1
100
NLTCS
10
2
10
1
100
101
102
Epsilon
10
2
10
1
100
101
102
Epsilon
Figure 1: Workload error (y-axis) vs Epsilon (x-axis) of competing mechanisms on the all-3way (left), target (center),
and skewed (right) workloads for 𝛿= 10−9.

---

well on, so it is interesting, but not surprising that it out-
performs workload-aware mechanisms in this setting.
(3) Prior to AIM, the best workload-aware mechanism varied
for different datasets and privacy levels: MWEM+PGM was
best in 72% of settings, GEM was best in 28% of settings
7 , and RAP was best in 0% of settings. Including AIM,
we observe that it is best in 76% of settings, followed by
MWEM+PGM in 18% of settings and GEM in 5% of settings.
Additionally, in the most interesting regime for practical
deployment (𝜖≥1.0), AIM is best in 100% of settings.
target Workload.
(1) All three high-level findings from the previous section are
supported by these figures as well.
(2) Somewhat surprisingly, PrivMRF outperforms all workload-
aware mechanisms prior to AIM on this workload. This is an
impressive accomplishment for PrivMRF, and clearly high-
lights the suboptimality of existing workload-aware mech-
anisms like MWEM+PGM, GEM, and RAP. Even though
PrivMRF is not workload-aware, it is clear from their paper
that every detail of the mechanism was carefully thought
out to make the mechanism work well in practice, which
explains it’s impressive performance. While AIM did out-
perform PrivMRF again, the relative performance did not
increase by a meaningful margin — offering a 1.4× improve-
ment on average and a 4.6× improvement in the best case.
skewed Workload.
(1) All four high-level findings from the previous sections are
generally supported by these figures as well, with the fol-
lowing interesting exception:
(2) PrivMRF did not score well on salary, and while it was
still generally the second best mechanism on the other
datasets (again out-performing the workload-aware mech-
anisms in many cases), the improvement offered by AIM
over PrivMRF is much larger for this workload, averaging
a 2× improvement with up to a 5.7× improvement in the
best case. We suspect for this setting, workload-awareness
is essential to achieve strong performance.
6.3
Ablations
In this section, we systematically evaluate the components of AIM,
by making modifications to the base mechanism and measuring
their impact on workload error. Specifically, the elements we study
are enumerated in Figure 2b, and are labeled by B1, B2, and B3 for
the basic elements of a good mechanism described in Section 3.2,
A1, A2, and A3 for the new elements of AIM described in Section 4,
and O1 for an additional relevent element. For each element of AIM
listed below, we run AIM with and without that element across
the entire set of experimental configurations we considered in this
work, i.e., 9 privacy budgets × 6 datasets × 3 workloads × 5 trials.
For each of the 162 (privacy budget, dataset, workload) triples, we
have 5 measurements which we use to compute two things: (1) the
ratio of average workload errors with and without the specified
7We compare against a variant of GEM that selects an entire marginal query in each
round. In results not shown, we also evaluated the variant of that measures a single
counting query, and found that this variant performs significantly worse.
element, and (2) a p-value from a one sided t-test. The former
quantity provides a measure of practical significance, while the
latter quantity provides a measure of statistical significance.
Figure 2a shows the distribution of error ratios for each element
across experimental settings, visualized as a box-and-whisker plot;
ratios above 1 indicate the element of AIM reduced error. Aggre-
gating the error ratios via geometric mean reveals the three basic
elements improved error by a factor 1.18 on average for Gaussian
noise, 1.13 for unbounded DP, and 1.08 for a 10/90 budget split. The
new elements of AIM improved error by a factor of 1.03 for ini-
tialization, 1.37 for the new selection critera, and 1.48 for adaptive
rounds and budget split. Finally, using Private-PGM in the generate
step, rather than an alternative known as relaxed projection [3],
improved error by a factor of 2.36 on average. Among these ele-
ments, the improvement offered by using adaptive rounds + budget
split, as well as Private-PGM, showed a clear depeendence on 𝜖,
with improvements growing with increasing 𝜖. The other elements
showed no clear dependence on 𝜖.
Aggregating the 162 p-values via Stouffer’s Z-score method [53],
we see that the combined p-value for every element tested ranges
from 10−22 for A1 (initialization) all the way to 10−166 for A3 (adap-
tive rounds + budget split). Thus, it is clear that all elements have a
positive effect on the performance of AIM in a statistical sense.
In addition to the algorithmic elements of AIM we evaluate in
this section, we conducted experiments varying the model capacity
parameter of AIM in Appendix G. Unsurprisingly, the utility of
AIM increases with larger model capacities, at the cost of increased
runtime.
6.4
Uncertainty Quantification
In this section, we demonstrate that our expressions for uncertainty
quantification correctly bound the error, and evaluate how tight
the bound is. For this experiment, we ran AIM on the fire dataset
with the all-3way workload at 𝜖= 10. In Figure 6 (c), we plot
the true error of AIM on each marginal in the workload against
the error bound predicted by our expressions. We set 𝜆= 1.7 in
Corollary 1, and 𝜆1 = 2.7, 𝜆2 = 3.7 in Corollary 2, which provides
95% confidence bounds. Our main findings are listed below:
(1) For all marginals in the (downward closure of the) workload,
the error bound is always greater than true error. This
confirms the validity of the bound, and suggests they are
safe to use in practice. Note that even if some errors were
above the bounds, that would not be inconsistent with our
guarantee, as at a 95% confidence level, the bound could
fail to hold 5% of the time. The fact that it doesn’t suggests
there is some looseness in the bound.
(2) The true errors and the error bounds vary considerably,
ranging from 10−4 all the way up to and beyond 1. In
general, the supported marginals have both lower errors,
and lower error bounds than the unsupported marginals,
which is not surprising. The error bounds are also tighter
for the supported marginals. The median ratio between er-
ror bound and observed error is 4.4 for supported marginals
and 8.3 for unsupported marginals. Intuitively, this makes
sense because we know selected marginals should have
higher error than non-selected marginals, but the error

---

B1
B2
B3
A1
A2
A3
O1
Variant
2
1
20
21
22
23
Improvement Ratio
(a) Practical Significance
Variant
Element of AIM
Alternative
B1
Gaussian Noise
Laplace Noise
B2
Unbounded DP
Bounded DP
B3
10/90 budget split
50/50 budget split
A1
Independent initialization
Uniform initialization
A2
New selection criteria +
MWEM+PGM selection +
candidate set
criteria + candidate set
A3
Adaptive rounds +
𝑑rounds + fixed
budget split
budget per round
O1
Private-PGM
Relaxed Projection
(b) Element codes and descriptions
10
4
10
3
10
2
10
1
100
Estimated Error Bound
10
4
10
3
10
2
10
1
100
True Error
Unsupported Marginals
Supported Marginals
(c) True Error vs. Error Bound
Figure 2: (a) Box plot of the ratio of errors with and without using an element of AIM across all experimental settings. (b)
Table describing elements of AIM removed and the alternatives used in this ablation study. (c) Accuracy of the uncertainty
quantification estimates.
of the non-selected marginal can be far below that of the
selected marginal (and hence the bound), which explains
the larger gap between the actual error and our predicted
bound.
7
DISCUSSION AND LIMITATIONS
In this paper, we studied the problem of differentially private syn-
thetic data generation, surveying the field and identifying strengths
and weaknesses of prior work. While much of the prior work is
conceptually similar, details and specific design decisions differ
from mechanism to mechanism, and these small differences can
lead to large performance differences in practice. In practical de-
ployments of differential privacy, these details matter to obtain
the best privacy-utility trade-off. In this work, we propose AIM,
a new mechanism where every detail is carefully thought out to
maximize utility in practice. These details allowed AIM to consis-
tently and significantly outperform competitors in our empirical
evaluation. In addition, our uncertainty quantification guarantees
enables analysts to understand which queries the synthetic data
preserves well, and which it does not, which is important to know
when performing downstream analyses on synthetic data. While
our work significantly improves over prior work, the problem of
differentially private synthetic data remains far from solved, and
there are a number of promising avenues for future work in this
space. We enumerate some of the limitations of AIM below, and
identify potential future research directions.
Handling More General Workloads. In this work, we focused
on weighted marginal query workloads. Designing mechanisms
that work for the more general class of linear queries (perhaps
defined over the low-dimensional marginals) remains an important
open problem. While the prior work, MWEM+PGM, RAP, and GEM
can handle workloads of this form, they achieve this by selecting a
single counting query in each round, rather than a full marginal
query, and thus there is likely significant room for improvement.
Beyond linear query workloads, other workloads of interest include
more abstract objectives like machine learning efficacy and other
non-linear query workloads. These metrics have been used to eval-
uate the quality of workload-agnostic synthetic data mechanisms,
but have not been provided as input to the mechanisms themselves.
Handling Mixed Data Types. In this work, we assumed the
input data was discrete, and each attribute had a finite domain with
a reasonably small number of possible values. Data with numerical
attributes must be appropriately discretized before running AIM.
The quality of the discretization could have a significant impact on
the quality of the generated synthetic data. Designing mechanisms
that appropriately handle mixed (categorical and numerical) data
type is an important problem.
Utilizing Public Data. A promising avenue for future research
is to design synthetic data mechanisms that incorporate public data
in a principled way. There are many places in which public data
can be naturally incorporated into AIM, and exploring these ideas
is a promising way to boost the utility of AIM in real world settings
where public data is available. Early work on this problem includes
[32, 33, 37], but it certainly warrants additional research.
Uncertainty Quantification Guarantees. In this paper, we
initiated the study of formal and well-calibrated guarantees about
the error of the synthetic data on different marginal queries. These
error estimates can be used to determine to what degree the syn-
thetic data should be trusted. However, our guarantees only pertain
to the 𝐿1 error of each marginal, and we provide no guarantees
on the error in each individual cell of the marginals. These finer-
grained guarantees could be useful in some applications, and is an
interesting technical challenge for future research.
Small Workloads. In our experimental evaluation, as in much of
the current literature, we focus on workloads with a large number of
marginal queries where privacy and scalability constraints prevent
measuring them all. For smaller workloads, simpler techniques like
Gaussian+PGM may achieve better performance than AIM, since
it does not have to devote budget to the select step.
High-cardinality attributes. The scalability of AIM, and more
generally any method that uses Private-PGM depends on the do-
main of attributes in the dataset. The datasets we considered in
Section 6 were preprocessed to have reasonable domain sizes (most
attributes had a domain size ≤50). Datasets with high-cardinality
attributes often have sparse marginals that may deserve special
treatment not covered in this paper.
ACKNOWLEDGMENTS
This work was supported by the National Science Foundation under
grants IIS-1749854 and CNS-1954814, and by Oracle Labs, part of
Oracle America, through a gift to the University of Massachusetts
Amherst in support of academic research.

---

REFERENCES
[1] Nazmiye Ceren Abay, Yan Zhou, Murat Kantarcioglu, Bhavani M. Thuraisingham,
and Latanya Sweeney. 2018. Privacy Preserving Synthetic Data Release Using
Deep Learning. In Machine Learning and Knowledge Discovery in Databases -
European Conference, ECML PKDD 2018, Dublin, Ireland, September 10-14, 2018,
Proceedings, Part I (Lecture Notes in Computer Science), Michele Berlingerio,
Francesco Bonchi, Thomas Gärtner, Neil Hurley, and Georgiana Ifrim (Eds.),
Vol. 11051. Springer, 510–526. https://doi.org/10.1007/978-3-030-10925-7_31
[2] Hassan Jameel Asghar, Ming Ding, Thierry Rakotoarivelo, Sirine Mrabet,
and Mohamed Ali Kâafar. 2019.
Differentially Private Release of High-
Dimensional Datasets using the Gaussian Copula. CoRR abs/1902.01499 (2019).
arXiv:1902.01499 http://arxiv.org/abs/1902.01499
[3] Sergul Aydore, William Brown, Michael Kearns, Krishnaram Kenthapadi, Luca
Melis, Aaron Roth, and Ankit A Siva. 2021. Differentially Private Query Release
Through Adaptive Projection. In Proceedings of the 38th International Conference
on Machine Learning (Proceedings of Machine Learning Research), Marina Meila
and Tong Zhang (Eds.), Vol. 139. PMLR, 457–467. https://proceedings.mlr.press/
v139/aydore21a.html
[4] Vincent Bindschaedler, Reza Shokri, and Carl A. Gunter. 2017. Plausible Deniabil-
ity for Privacy-Preserving Data Synthesis. Proceedings of the VLDB Endowment
10, 5 (2017), 481–492. https://doi.org/10.14778/3055540.3055542
[5] Mark Bun and Thomas Steinke. 2016. Concentrated Differential Privacy: Simpli-
fications, Extensions, and Lower Bounds. In Theory of Cryptography Conference.
Springer, 635–658. https://doi.org/10.1007/978-3-662-53641-4_24
[6] Igor Cadez, David Heckerman, Christopher Meek, Padhraic Smyth, and Steven
White. 2000. Visualization of navigation patterns on a web site using model-
based clustering. In Proceedings of the sixth ACM SIGKDD international conference
on Knowledge discovery and data mining. 280–284.
[7] Kuntai Cai, Xiaoyu Lei, Jianxin Wei, and Xiaokui Xiao. 2021. Data synthesis via
differentially private markov random fields. Proceedings of the VLDB Endowment
14, 11 (2021), 2190–2202.
[8] Clément L. Canonne, Gautam Kamath, and Thomas Steinke. 2020. The Discrete
Gaussian for Differential Privacy. In NeurIPS. https://proceedings.neurips.cc/
paper/2020/hash/b53b3a3d6ab90ce0268229151c9bde11-Abstract.html
[9] Mark Cesar and Ryan Rogers. 2021. Bounding, Concentrating, and Truncating:
Unifying Privacy Loss Composition for Data Analytics. In Proceedings of the 32nd
International Conference on Algorithmic Learning Theory (Proceedings of Machine
Learning Research), Vitaly Feldman, Katrina Ligett, and Sivan Sabato (Eds.),
Vol. 132. PMLR, 421–457. https://proceedings.mlr.press/v132/cesar21a.html
[10] Anne-Sophie Charest. 2011. How Can We Analyze Differentially-Private Syn-
thetic Datasets?
Journal of Privacy and Confidentiality 2, 2 (2011).
https:
//doi.org/10.29012/jpc.v2i2.589
[11] Rui Chen, Qian Xiao, Yu Zhang, and Jianliang Xu. 2015. Differentially private
high-dimensional data publication via sampling-based inference. In Proceedings
of the 21th ACM SIGKDD International Conference on Knowledge Discovery and
Data Mining. ACM, 129–138. https://doi.org/10.1145/2783258.2783379
[12] Bolin Ding, Marianne Winslett, Jiawei Han, and Zhenhui Li. 2011. Differentially
private data cubes: optimizing noise sources and consistency. In Proceedings of
the ACM SIGMOD International Conference on Management of Data, SIGMOD
2011, Athens, Greece, June 12-16, 2011, Timos K. Sellis, Renée J. Miller, Anastasios
Kementsietsidis, and Yannis Velegrakis (Eds.). ACM, 217–228. https://doi.org/10.
1145/1989323.1989347
[13] Irit Dinur and Kobbi Nissim. 2003. Revealing information while preserving
privacy. In Proceedings of the Twenty-Second ACM SIGACT-SIGMOD-SIGART
Symposium on Principles of Database Systems, June 9-12, 2003, San Diego, CA,
USA, Frank Neven, Catriel Beeri, and Tova Milo (Eds.). ACM, 202–210. https:
//doi.org/10.1145/773153.773173
[14] Cynthia Dwork, Frank McSherry Kobbi Nissim, and Adam Smith. 2006. Cali-
brating Noise to Sensitivity in Private Data Analysis. In TCC. 265–284. https:
//doi.org/10.29012/jpc.v7i3.405
[15] Vitaly Feldman and Tijana Zrnic. 2021. Individual privacy accounting via a renyi
filter. Advances in Neural Information Processing Systems 34 (2021), 28080–28091.
[16] James S Frame. 1945. Mean deviation of the binomial distribution. The American
Mathematical Monthly 52, 7 (1945), 377–379.
[17] Thomas Cason Frank E. Harrell Jr. [n.d.]. Encyclopedia Titanica.
[18] Chang Ge, Shubhankar Mohapatra, Xi He, and Ihab F. Ilyas. 2021. Kamino:
Constraint-Aware Differentially Private Data Synthesis. Proceedings of the VLDB
Endowment 14, 10 (2021), 1886–1899. http://www.vldb.org/pvldb/vol14/p1886-
ge.pdf
[19] Ian J. Goodfellow, Jean Pouget-Abadie, Mehdi Mirza, Bing Xu, David
Warde-Farley, Sherjil Ozair, Aaron C. Courville, and Yoshua Bengio. 2014.
Generative Adversarial Nets. In Advances in Neural Information Process-
ing Systems 27: Annual Conference on Neural Information Processing Sys-
tems 2014, December 8-13 2014, Montreal, Quebec, Canada, Zoubin Ghahra-
mani, Max Welling, Corinna Cortes, Neil D. Lawrence, and Kilian Q. Wein-
berger (Eds.). 2672–2680.
https://proceedings.neurips.cc/paper/2014/hash/
5ca3e9b122f61f8f06494c97b1afccf3-Abstract.html
[20] William H Greene. 2003. Econometric analysis. Pearson Education India.
[21] Moritz Hardt, Katrina Ligett, and Frank McSherry. 2012.
A Simple and
Practical Algorithm for Differentially Private Data Release. In Advances in
Neural Information Processing Systems 25: 26th Annual Conference on Neural
Information Processing Systems 2012. Proceedings of a meeting held Decem-
ber 3-6, 2012, Lake Tahoe, Nevada, United States, Peter L. Bartlett, Fernando
C. N. Pereira, Christopher J. C. Burges, Léon Bottou, and Kilian Q. Wein-
berger (Eds.). 2348–2356.
https://proceedings.neurips.cc/paper/2012/hash/
208e43f0e45c4c78cafadb83d2888cb6-Abstract.html
[22] Joachim Hartung, Guido Knapp, Bimal K Sinha, and Bimal K Sinha. 2008. Statis-
tical meta-analysis with applications. Vol. 6. Wiley Online Library.
[23] Michael Hay, Ashwin Machanavajjhala, Gerome Miklau, Yan Chen, and Dan
Zhang. 2016. Principled evaluation of differentially private algorithms using
dpbench. In Proceedings of the 2016 International Conference on Management of
Data. 139–154.
[24] Zhiqi Huang, Ryan McKenna, George Bissias, Gerome Miklau, Michael Hay, and
Ashwin Machanavajjhala. 2019. PSynDB: accurate and accessible private data
generation. VLDB Demo (2019). https://people.cs.umass.edu/~miklau/assets/
pubs/dp/huang19psyndata-demo.pdf
[25] Norman L Johnson, Adrienne W Kemp, and Samuel Kotz. 2005. Univariate discrete
distributions. Vol. 444. John Wiley & Sons.
[26] James Jordon, Jinsung Yoon, and Mihaela van der Schaar. 2019. PATE-GAN: Gen-
erating Synthetic Data with Differential Privacy Guarantees. In 7th International
Conference on Learning Representations, ICLR 2019, New Orleans, LA, USA, May
6-9, 2019. OpenReview.net. https://openreview.net/forum?id=S1zk9iRqF7
[27] Gary King. [n.d.]. Noisy Data from the Noisy Census. ([n. d.]).
[28] Ron Kohavi et al. 1996. Scaling up the accuracy of naive-bayes classifiers: A
decision-tree hybrid.. In Kdd, Vol. 96. 202–207.
[29] Haoran Li, Li Xiong, and Xiaoqian Jiang. 2014. Differentially Private Synthesiza-
tion of Multi-Dimensional Data using Copula Functions. In Proceedings of the 17th
International Conference on Extending Database Technology, EDBT 2014, Athens,
Greece, March 24-28, 2014, Sihem Amer-Yahia, Vassilis Christophides, Anastasios
Kementsietsidis, Minos N. Garofalakis, Stratos Idreos, and Vincent Leroy (Eds.).
OpenProceedings.org, 475–486. https://doi.org/10.5441/002/edbt.2014.43
[30] Fang Liu. 2016. Model-based differentially private data synthesis. arXiv preprint
arXiv:1606.08052 (2016). https://arxiv.org/abs/1606.08052
[31] Jingcheng Liu and Kunal Talwar. 2019. Private selection from private candi-
dates. In Proceedings of the 51st Annual ACM SIGACT Symposium on Theory of
Computing. 298–309.
[32] Terrance Liu, Giuseppe Vietri, Thomas Steinke, Jonathan R. Ullman, and Zhi-
wei Steven Wu. 2021. Leveraging Public Data for Practical Private Query Release.
In ICML. 6968–6977. http://proceedings.mlr.press/v139/liu21w.html
[33] Terrance Liu, Giuseppe Vietri, and Steven Wu. 2021. Iterative Methods for
Private Synthetic Data: Unifying Framework and New Methods. In Advances in
Neural Information Processing Systems, A. Beygelzimer, Y. Dauphin, P. Liang, and
J. Wortman Vaughan (Eds.).
[34] Kenneth G. Manton. 2010. National Long-Term Care Survey: 1982, 1984, 1989,
1994, 1999, and 2004.
[35] Ryan McKenna and Terrance Liu. 2022. A simple recipe for private synthetic
data generation. DifferentialPrivacy.org
[36] Ryan McKenna, Gerome Miklau, Michael Hay, and Ashwin Machanavajjhala.
2018. Optimizing error of high-dimensional statistical queries under differential
privacy. Proceedings of the VLDB Endowment 11, 10 (2018), 1206–1219. https:
//doi.org/10.14778/3231751.3231769
[37] Ryan McKenna, Gerome Miklau, and Daniel Sheldon. 2021. Winning the NIST
Contest: A scalable and general approach to differentially private synthetic data.
Journal of Privacy and Confidentiality 11, 3 (2021).
[38] Ryan McKenna, Brett Mullins, Daniel Sheldon, and Gerome Miklau. 2022. AIM:
An Adaptive and Iterative Mechanism for Differentially Private Synthetic Data.
(2022).
[39] Ryan McKenna, Siddhant Pradhan, Daniel R Sheldon, and Gerome Miklau. 2021.
Relaxed Marginal Consistency for Differentially Private Query Answering. Ad-
vances in Neural Information Processing Systems 34 (2021).
[40] Ryan McKenna, Daniel Sheldon, and Gerome Miklau. 2019. Graphical-model
based estimation and inference for differential privacy. In International Conference
on Machine Learning. 4435–4444. http://proceedings.mlr.press/v97/mckenna19a.
html
[41] Aleksandar Nikolov, Kunal Talwar, and Li Zhang. 2013. The geometry of differ-
ential privacy: the sparse and approximate cases. In Proceedings of the forty-fifth
annual ACM symposium on Theory of computing. 351–360.
[42] Nicolas Papernot and Thomas Steinke. 2021. Hyperparameter Tuning with Renyi
Differential Privacy. arXiv preprint arXiv:2110.03620 (2021).
[43] Diane Ridgeway, Mary Theofanos, Terese Manley, Christine Task, et al. 2021.
Challenge Design and Lessons Learned from the 2018 Differential Privacy Chal-
lenges. (2021).
[44] Ryan M Rogers, Aaron Roth, Jonathan Ullman, and Salil Vadhan. 2016. Pri-
vacy odometers and filters: Pay-as-you-go composition. Advances in Neural
Information Processing Systems 29 (2016), 1921–1929.

---

[45] Uthaipon Tantipongpipat, Chris Waites, Digvijay Boob, Amaresh Ankit Siva,
and Rachel Cummings. 2019. Differentially Private Mixed-Type Data Generation
For Unsupervised Learning. CoRR abs/1912.03250 (2019). arXiv:1912.03250
http://arxiv.org/abs/1912.03250
[46] Yuchao Tao, Ryan McKenna, Michael Hay, Ashwin Machanavajjhala, and Gerome
Miklau. 2021. Benchmarking Differentially Private Synthetic Data Generation Al-
gorithms. Third AAAI Privacy-Preserving Artificial Intelligence (PPAI-22) workshop
(2021).
[47] Amirsina Torfi, Edward A Fox, and Chandan K Reddy. 2022. Differentially private
synthetic medical data generation using convolutional gans. Information Sciences
586 (2022), 485–500.
[48] Reihaneh Torkzadehmahani, Peter Kairouz, and Benedict Paten. 2019. DP-CGAN:
Differentially Private Synthetic Data and Label Generation. In IEEE Conference on
Computer Vision and Pattern Recognition Workshops, CVPR Workshops 2019, Long
Beach, CA, USA, June 16-20, 2019. Computer Vision Foundation / IEEE, 98–104.
https://doi.org/10.1109/CVPRW.2019.00018
[49] Michail Tsagris, Christina Beneki, and Hossein Hassani. 2014. On the folded
normal distribution. Mathematics 2, 1 (2014), 12–28.
[50] Giuseppe Vietri, Grace Tian, Mark Bun, Thomas Steinke, and Zhiwei Steven
Wu. 2020. New Oracle-Efficient Algorithms for Private Synthetic Data Release.
In Proceedings of the 37th International Conference on Machine Learning, ICML
2020, 13-18 July 2020, Virtual Event (Proceedings of Machine Learning Research),
Vol. 119. PMLR, 9765–9774. http://proceedings.mlr.press/v119/vietri20b.html
[51] Liyang Xie, Kaixiang Lin, Shu Wang, Fei Wang, and Jiayu Zhou. 2018. Differ-
entially Private Generative Adversarial Network. CoRR abs/1802.06739 (2018).
arXiv:1802.06739 http://arxiv.org/abs/1802.06739
[52] Chugui Xu, Ju Ren, Yaoxue Zhang, Zhan Qin, and Kui Ren. 2017. DPPro: Differ-
entially Private High-Dimensional Data Release via Random Projection. IEEE
Transactions on Information Forensics and Security 12, 12 (2017), 3081–3093.
https://doi.org/10.1109/TIFS.2017.2737966
[53] Dmitri V Zaykin. 2011. Optimally weighted Z-test is a powerful method for
combining probabilities in meta-analysis. Journal of evolutionary biology 24, 8
(2011), 1836–1841.
[54] Jun Zhang, Graham Cormode, Cecilia M. Procopiuc, Divesh Srivastava, and
Xiaokui Xiao. 2017. PrivBayes: Private Data Release via Bayesian Networks.
ACM Transactions on Database Systems (TODS) 42, 4 (2017), 25:1–25:41. https:
//doi.org/10.1145/3134428
[55] Wei Zhang, Jingwen Zhao, Fengqiong Wei, and Yunfang Chen. 2019. Differ-
entially Private High-Dimensional Data Publication via Markov Network. EAI
Endorsed Trans. Security Safety 6, 19 (2019), e4. https://doi.org/10.4108/eai.29-7-
2019.159626
[56] Xinyang Zhang, Shouling Ji, and Ting Wang. 2018. Differentially private releasing
via deep generative model (technical report). arXiv preprint arXiv:1801.01594
(2018). https://arxiv.org/abs/1801.01594
[57] Zhikun Zhang, Tianhao Wang, Ninghui Li, Jean Honorio, Michael Backes, Shibo
He, Jiming Chen, and Yang Zhang. 2021. PrivSyn: Differentially Private Data
Synthesis. In 30th USENIX Security Symposium (USENIX Security 21). USENIX
Association, 929–946. https://www.usenix.org/conference/usenixsecurity21/
presentation/zhang-zhikun

---

A
DATA PREPROCESSING
We apply consistent preprocessing to all datasets in our empirical
evaluation. There are three steps to our preprocessing procedure,
described below:
Attribute selection. For each dataset, we identify a set of at-
tributes to keep. For the adult, salary, nltcs, and titanic datasets,
we keep all attributes from the original data source. For the fire
dataset, we drop the 15 attributes relating to incident times, since af-
ter discretization, they contain redundant information. The msnbc
dataset is a streaming dataset, where each row has a different num-
ber of entries. We keep only the first 16 entries for each row.
Domain identification. Usually we expect the domain to be
supplied separately from the data file. For example, the IPUMS
website contains comprehensive documentation about U.S. Census
data products. However, for the datasets we used, no such domain
file was available. Thus, we “cheat” and look at the active domain
to automatically derive a domain file from the dataset. For each
attribute, we identify if it is categorical or numerical. For each cate-
gorical attribute, we list the set of observed values (including null)
for that attribute, which we treat as the set of possible values for
that attribute. For each numerical attribute, we record the minimum
and maximum observed value for that attribute.
Discretization. We discretize each numerical attribute into 32
equal-width bins, using the min/max values from the domain file.
This turns each numerical attribute into a categorical attribute,
satisfying our assumption.
B
UNCERTAINTY QUANTIFICATION PROOFS
B.1
The Easy Case: Supported Marginals
Theorem 2 (Weighted Average Estimator). Let𝑟1, . . . ,𝑟𝑡and𝑦1, . . . ,𝑦𝑡
be as defined in Algorithm 2, and let 𝑅= {𝑟1, . . . ,𝑟𝑡}. For any 𝑟∈𝑅+,
there is an (unbiased) estimator ¯𝑦𝑟= 𝑓𝑟(𝑦1, . . . ,𝑦𝑡) such that:
¯𝑦𝑟∼N (𝑀𝑟(𝐷), ¯𝜎2
𝑟I) where
¯𝜎2
𝑟=
h
𝑡∑︁
𝑖=1
𝑟⊆𝑟𝑖
𝑛𝑟
𝑛𝑟𝑖𝜎2
𝑖
i −1
,
Proof. For each 𝑟𝑖⊇𝑟, we observe ˜𝑦𝑖∼𝑀𝑟𝑖(𝐷) + N (0, 𝜎2
𝑖I).
We can use this noisy marginal to obtain an unbiased estimate
𝑀𝑟(𝐷) by marginalizing out attributes in the set 𝑟𝑖\𝑟. This requires
summing up 𝑛𝑟𝑖/𝑛𝑟cells, so the variance in each cell becomes
𝑛𝑟𝑖𝜎2
𝑖/𝑛𝑟. Moreover, the noise is still normally distributed, since
the sum of independent normal random variables is normal. We
thus have such an estimate for each 𝑖satisfying 𝑟𝑖⊇𝑟, and we
can combine these independent estimates using inverse variance
weighting [22], resulting in an unbiased estimator with the stated
variance. For the same reason as before, the noise is still normally
distributed.
□
Theorem 3 (Confidence Bound). Let ¯𝑦𝑟be the estimator from The-
orem 2. Then, for any 𝜆≥0, with probability at least 1 −exp (−𝜆2):
∥𝑀𝑟(𝐷) −¯𝑦𝑟∥1 ≤
√︁
2 log 2¯𝜎𝑟𝑛𝑟+ 𝜆¯𝜎𝑟
√2𝑛𝑟
Proof. Noting that 𝑀𝑟(𝐷) −¯𝑦∼N (0, 𝜎2I), the statement is a
direct consequence of Theorem 5, below.
□
Theorem 5. Let 𝑥∼𝑁(0, 𝜎2)𝑛, then:
E[∥𝑥∥1] =
√︁
2/𝜋𝑛𝜎
and
Pr[∥𝑥∥1 ≥
√︁
2 log 2𝜎𝑛+ 𝑐𝜎
√
2𝑛] ≤exp (−𝑐2)
Proof. First observe that |𝑥𝑖| is a sample from a half-normal
distribution. Thus, E[𝑥𝑖] =
√︁
2/𝜋𝜎. From the linearity of expec-
tation, we obtain E[∥𝑥∥1] =
√︁
2/𝜋𝜎𝑛, as desired. For the second
statement, we begin by deriving the moment generating function
of the random variable |𝑥𝑖|. By definition, we have:
E[exp (𝑡· |𝑥𝑖|)] =
∫∞
−∞
𝜙(𝑧) exp (𝑡· |𝑧|)𝑑𝑧
= 2
∫∞
0
𝜙(𝑧) exp (𝑡· 𝑧)𝑑𝑧
= 2
∫∞
0
1
𝜎
√
2𝜋
exp

−𝑧2
2𝜎2

exp (𝑡· 𝑧)𝑑𝑧
= 1
𝜎
√︂
2
𝜋
∫∞
0
exp

−𝑧2
2𝜎2 + 𝑡· 𝑧

𝑑𝑧
= exp
𝜎2𝑡2
2
 
Φ
 𝑡𝜎
√
2

+ 1

Moreover, since ∥𝑥∥1 = Í𝑛
𝑖=1 |𝑥𝑖| is a sum of i.i.d random variables,
the moment generating function of ∥𝑥∥1 is:
E[exp (𝑡· ∥𝑥∥1)] = exp
𝜎2𝑡2
2
𝑛
Φ
 𝑡𝜎
√
2

+ 1
𝑛
From the Chernoff bound, we have
Pr[∥𝑥∥1 ≥𝑎] ≤min
𝑡≥0
E[exp (𝑡· ∥𝑥∥1)]
exp (𝑡𝑎)
= min
𝑡≥0 exp
𝑛𝜎2𝑡2
2
−𝑡𝑎
 
Φ
 𝑡𝜎
√
2

+ 1
𝑛
≤min
𝑡≥0 2𝑛exp
𝑛𝜎2𝑡2
2
−𝑡𝑎

≤2𝑛exp
𝑛𝜎2(𝑎/𝑛𝜎2)2
2
−(𝑎/𝑛𝜎2)𝑎

= 2𝑛exp
 𝑎2
2𝑛𝜎2 −𝑎2
𝑛𝜎2

= 2𝑛exp

−
𝑎2
2𝑛𝜎2

= exp

−
𝑎2
2𝑛𝜎2 + 𝑛log 2

With some further manipulation of the bound, we obtain:
Pr[∥𝑥∥1 ≥𝑑𝜎
√
2𝑛] ≤exp

−𝑑2 + 𝑛log 2

(𝑎= 𝑑𝜎
√
2𝑛)
Pr[∥𝑥∥1 ≥(𝑐+
√︁
𝑛log 2)𝜎
√
2𝑛] ≤exp (−𝑐2)
(𝑑= 𝑐+
√︁
𝑛log 2)
Pr[∥𝑥∥1 ≥
√︁
2 log 2𝜎𝑛+ 𝑐𝜎
√
2𝑛] ≤exp (−𝑐2)
□

---

B.2
The Hard Case: Unsupported Marginals
Theorem 4 (Confidence Bound). Let 𝜎𝑡,𝜖𝑡,𝑟𝑡, ˜𝑦𝑡,𝐶𝑡, ˆ𝑝𝑡be as de-
fined in Algorithm 2, and let Δ𝑡= max𝑟∈𝐶𝑡𝑤𝑟. For all 𝑟∈𝐶𝑡, with
probability at least 1 −𝑒−𝜆2
1/2 −𝑒−𝜆2:
∥𝑀𝑟(𝐷) −𝑀𝑟( ˆ𝑝𝑡−1)∥1 ≤𝑤−1
𝑟
 𝐵𝑟+ 𝜆1𝜎𝑡√𝑛𝑟𝑡+ 𝜆2
2Δ𝑡
𝜖𝑡

where 𝐵𝑟is equal to:
𝑤𝑟𝑡

𝑀𝑟𝑡( ˆ𝑝𝑡−1) −𝑦𝑡

1
|                 {z                 }
estimated error on 𝑟𝑡
+
√︁
2/𝜋𝜎𝑡
 𝑤𝑟𝑛𝑟−𝑤𝑟𝑡𝑛𝑟𝑡

|                          {z                          }
relationship to
non-selected candidates
+ 2Δ𝑡
𝜖𝑡
log (|𝐶𝑡|)
|            {z            }
uncertainty from
exponential mech.
Proof. By the guarantees of the exponential mechanism, we
know that, with probability at most 𝑒−𝜆2, for all 𝑟∈𝐶𝑡we have:
𝑞𝑟𝑡≤𝑞𝑟−2Δ𝑡
𝜖𝑡
(log (|𝐶𝑡|) + 𝜆2)
Now define 𝐸𝑟= ∥𝑀𝑟(𝐷) −𝑀𝑟(𝑝𝑡−1)∥1. Plugging in 𝑞𝑟= 𝑤𝑟(𝐸𝑟−
√︁
2/𝜋𝜎𝑡𝑛𝑟) and rearranging gives:
𝐸𝑟≥
𝑤𝑟𝑡(𝐸𝑟𝑡−
√︁
2/𝜋𝜎𝑡𝑛𝑟𝑡) + 2Δ𝑡
𝜖𝑡(log (|𝐶𝑡|) + 𝜆2)
𝑤𝑟
+
√︁
2/𝜋𝜎𝑡𝑛𝑟
From Theorem 6, with probability at most 𝑒−𝜆2
1/2, we have:

𝑀𝑟𝑡(𝑝𝑡−1) −𝑦𝑡

1 + 𝜆1𝜎𝑡√𝑛𝑟𝑡≤𝐸𝑟𝑡
Combining these two facts via the union bound, along with some
algebraic manipulation, yields the stated result.
□
Theorem 6. Let 𝑎,𝑏∈R𝑘and let 𝑐= 𝑏+ 𝑧where 𝑧∼N (0, 𝜎2)𝑛.
Pr[∥𝑎−𝑐∥1 ≤∥𝑎−𝑏∥1 −𝜆𝜎√𝑛] ≤exp

−1
2𝜆2
Proof. First note that |𝑎𝑖−𝑐𝑖| = |𝑎𝑖−𝑏𝑖−𝑧𝑖|, which is distributed
according to a folded normal distribution with mean |𝑎𝑖−𝑏𝑖|. It
is well known [49] that the moment generating function for this
random variable is 𝑀𝑖(𝑡), where:
𝑀𝑖(𝑡) = exp
 1
2𝜎2𝑡2 + |𝑎𝑖−𝑏𝑖|𝑡

Φ(|𝑎𝑖−𝑏𝑖|/𝜎+ 𝜎𝑡)
+ exp
 1
2𝜎2𝑡2 −|𝑎𝑖−𝑏𝑖|𝑡

Φ(−|𝑎𝑖−𝑏𝑖|/𝜎+ 𝜎𝑡).
Moreover, the moment generating function of ∥𝑎−𝑐∥1 is 𝑀(𝑡) =
Î
𝑖𝑀𝑖(𝑡). We will begin by focusing our attention on bounding
𝑀𝑖(−𝑡). For simplicity, let 𝜇= |𝑎𝑖−𝑏𝑖|. We have:
𝑀𝑖(−𝑡) = exp
𝜎2𝑡2
2
−𝜇𝑡

Φ(𝜇/𝜎−𝜎𝑡)
+ exp
𝜎2𝑡2
2
+ 𝜇𝑡

Φ(−𝜇/𝜎−𝜎𝑡)
= exp
𝜎2𝑡2
2
−𝜇𝑡

(1 −Φ(−𝜇/𝜎+ 𝜎𝑡))
+ exp
𝜎2𝑡2
2
+ 𝜇𝑡

Φ(−𝜇/𝜎−𝜎𝑡)
= exp
𝜎2𝑡2
2
−𝜇𝑡

−exp
𝜎2𝑡2
2
−𝜇𝑡

Φ(−𝜇/𝜎+ 𝜎𝑡)
+ exp
𝜎2𝑡2
2
+ 𝜇𝑡

Φ(−𝜇/𝜎−𝜎𝑡)
≤exp
𝜎2𝑡2
2
−𝜇𝑡

(Lemma 1 below; 𝑎= 𝜎𝑡,𝑏= 𝜇/𝜎)
We are now ready to plug this result into the Chernoff bound, which
states:
Pr[∥𝑎−𝑐∥1 ≤𝑟] ≤min
𝑡≥0 exp (𝑡· 𝑟)𝑀(−𝑡)
≤min
𝑡≥0 exp (𝑡· 𝑟)
Ö
𝑖
exp
𝜎2𝑡2
2
−|𝑎𝑖−𝑏𝑖|𝑡

= min
𝑡≥0 exp (𝑡· 𝑟+ 𝑛𝜎2𝑡2
2
−∥𝑎−𝑏∥1 𝑡)
Setting 𝑟= ∥𝑎−𝑏∥1 −𝜆𝜎√𝑛gives the desired result
Pr[∥𝑎−𝑐∥1 ≤∥𝑎−𝑏∥1 −𝜆𝜎√𝑛]
≤min
𝑡≥0 exp (𝑡· (∥𝑎−𝑏∥1 −𝜆𝜎√𝑛) + 𝑛𝜎2𝑡2
2
−∥𝑎−𝑏∥1 𝑡)
= min
𝑡≥0 exp

−𝑡𝜆𝜎√𝑛+ 𝑛𝜎2𝑡2
2

≤exp (−𝜆2/2)
(set 𝑡= 𝜆/𝜎√𝑛)
□
Lemma 1. Let 𝑎,𝑏≥0, and let Φ denote the CDF of the standard
normal distribution. Then,
exp
 1
2𝑎2 + 𝑎𝑏

Φ(−𝑎−𝑏) ≤exp
 1
2𝑎2 −𝑎𝑏

Φ(𝑎−𝑏)
Proof. First observe that:
exp
 1
2𝑎2 + 𝑎𝑏

Φ(−𝑎−𝑏) = exp

−1
2𝑏2 Φ(−𝑎−𝑏)
𝜙(−𝑎−𝑏)
exp
 1
2𝑎2 −𝑎𝑏

Φ(𝑎−𝑏) = exp

−1
2𝑏2 Φ(𝑎−𝑏)
𝜙(𝑎−𝑏)
Since 𝑎,𝑏≥0, we know that −𝑎−𝑏≤𝑎−𝑏. We will now argue
that the function Φ(𝛼)
𝜙(𝛼) is monotonically increasing in 𝛼, which
suffices to prove the desired claim. To prove this, we will observe
that this is this quantity is known as the Mills ratio [20] for the
normal distribution. We know that the Mills ratio is connected to a
particular expectation; specifically, if 𝑋∼N (0, 1), then
E[𝑋| 𝑋< 𝛼] = −𝜙(𝛼)
Φ(𝛼)
Using this interpretation, it is clear that the LHS (and hence the RHS)
is monotonically increasing in 𝛼. Since −𝜙(𝛼)
Φ(𝛼) is monotonically
increasing, so is Φ(𝛼)
𝜙(𝛼) .
□

---

10
2
10
1
100
101
102
Epsilon
10
3
10
2
10
1
100
101
102
Samples
adult
fire
msnbc
nltcs
salary
titanic
(a) General
10
2
10
1
100
101
102
Epsilon
10
4
10
3
10
2
10
1
100
101
102
Samples
adult
fire
msnbc
nltcs
salary
titanic
(b) Target
10
2
10
1
100
101
102
Epsilon
10
3
10
2
10
1
100
101
102
103
Samples
adult
fire
msnbc
nltcs
salary
titanic
(c) Weighted
Figure 3: Performance of AIM as measured by the number of samples needed to match the achieved workload error.
C
INTERPRETABLE ERROR RATE AND
SUBSAMPLING MECHANISM
In Section 6, we saw that AIM offers the best error relative to exist-
ing synthetic data mechanisms, although it is not obvious whether
a given 𝐿1 error should be considered “good”. This is necessary for
setting the privacy parameters to strike the right privacy/utility
tradeoff. We can bring more clarity to this problem by comparing
AIM to a (non-private) baseline that simply resamples 𝐾records
from the dataset. Then, if AIM achieves the same error as resam-
pling 𝐾= 𝑁
2 records, this provides a clear interpretation: that the
price of privacy is losing about half the data. Due to the simplicity
of this baseline, we can compute the expected workload error in
closed form, without actually running the mechanism. We provide
details of these calculations in the next section.
Figure 3 plots the performance of AIM on each dataset, epsilon,
and workload considered, measured using the fraction of samples
needed for the subsampling mechanism to match the performance
of AIM. These plots reveal that at 𝜖= 10, the median subsam-
pling fraction is about 0.37 for the general workload, 0.62 for the
target workload, and 0.85 for the weighted workload. At 𝜖= 1,
these numbers are 0.13, 0.15, and 0.21, respectively. The results
are comparable across five out of six datasets, with nltcs being
a clear outlier. For that dataset, a subsampling fraction of 1.0 was
reached by 𝜖= 0.31 for all workload. This could be an indication of
overfitting to the data; a possible reason for this behavior is that
the domain size of the nltcs data is small compared to the number
of records. mnsbc is also an outlier to a lesser extent, with worse
performance than the other datasets for larger 𝜖. A possible reason
for this behavior is that msnbc has the most data points, so subsam-
pling with the same fraction of points has much lower error. AIM
may not be able to match that low error due to the computational
constraints imposed on the model size, combined with the fact that
this dataset has a large domain.
C.1
Mathematical Details of Subsampling
We begin by analyzing the expected workload error of the (non-
private) mechanism that randomly samples 𝐾items with replace-
ment from 𝐷. Then, we will connect that to the error of AIM, and
determine the value of 𝐾where the error rates match. Theorem 7
gives a closed form expression for the expected 𝐿1 error on a single
marginal as a function of the number of sampled records.
Theorem 7. Let ˆ𝐷be the dataset obtained by sampling 𝐾items with
replacement from 𝐷. Further, let ®𝜇= 1
𝑁𝑀𝑟(𝐷) and ®𝑠= ⌈𝐾®𝜇⌉.
E
h 

1
𝑁𝑀𝑟(𝐷) −1
𝐾𝑀𝑟( ˆ𝐷)

i
=
2
𝐾
∑︁
𝑥∈Ω𝑟
𝑠(𝑥)
 𝐾
𝑠(𝑥)

𝜇(𝑥)𝑠(𝑥) (1 −𝜇(𝑥))𝐾−𝑠(𝑥)+1
Proof. The theorem statement follows directly from Lemma 4
and Lemma 3.
□
Lemma 2 (Mean Deviation [16, 25]). Let 𝑘∼𝐵𝑖𝑛𝑜𝑚𝑖𝑎𝑙(𝑛, 𝑝), then:
E
h𝑝−𝑘
𝑛

i
= 2
𝑛𝑠
𝑛
𝑠

𝑝𝑠(1 −𝑝)𝑛−𝑠+1,
where 𝑠= ⌈𝑛· 𝑝⌉.
Proof. This statement appears and is proved in [16, 25].
□
Lemma 3 (𝐿1 Deviation). Let ®𝑘∼𝑀𝑢𝑙𝑡𝑖𝑛𝑜𝑚𝑖𝑎𝑙(𝑛, ®𝑝), then:
E[

®𝑝−®𝑘/𝑛

1] = 2
𝑛
∑︁
𝑥
𝑠(𝑥)
 𝑛
𝑠(𝑥)

𝑝(𝑥)𝑠(𝑥) (1 −𝑝(𝑥))𝑛−𝑠(𝑥)+1,
where 𝑠(𝑥) = ⌈𝑛· 𝑝(𝑥)⌉.
Proof. The statement follows immediately from Lemma 2 and
the fact that 𝑘(𝑥) ∼𝐵𝑖𝑛𝑜𝑚𝑖𝑎𝑙(𝑛, 𝑝(𝑥)).
□
Lemma 4. Let ˆ𝐷be the dataset obtained by sampling 𝐾items with
replacement from 𝐷. Then,
𝑀𝑟( ˆ𝐷) ∼𝑀𝑢𝑙𝑡𝑖𝑛𝑜𝑚𝑖𝑎𝑙

𝐾, 1
𝑁𝑀𝑟(𝐷)

Proof. The statement follows from the definition of the multi-
nomial distribution.
□

---

D
STRUCTURAL ZEROS
In this section, we describe a simple and principled method to
specify and enforce structural zeros in the mechanism. These capture
attribute combinations that cannot occur in the real data. Without
specifying this, synthetic data mechanisms will usually generate
records that violate these constraints that hold in the real data as the
process of adding noise can introduce spurious records, especially in
high privacy regimes. These spurious records can be confusing for
downstream analysis of the synthetic data and can lead the analyst
to distrust the quality of the data. By imposing known structural
zero constraints, we can avoid this problem while also improving
the quality of the synthetic data on the workload of interest.
Structural zeros, if they exist, can usually be enumerated by a
domain expert. We can very naturally incorporate these into our
mechanism with only one minor change to the underlying Private-
PGM library. These structural zeros can be specified as input as
a list of pairs (𝑟, Z𝑟) where Z𝑟⊆Ω𝑟. The first entry of the pair
specifies the set of attributes relevant to the structural zeros, while
the second entry enumerates the attribute combinations whose
counts should all be zero. The method we propose can be used
within any mechanism that builds on top of Private-PGM and is
hence more broadly useful outside the context of AIM.
To understand the technical ideas in this section, please refer
to the background on Private-PGM [40]. Usually Private-PGM is
initialized by setting𝜃𝑟(𝑥𝑟) = 0 for all𝑟in the model and all𝑥𝑟∈Ω𝑟.
This corresponds to a model where 𝜇𝑟(𝑥𝑟) is uniform across all
𝑥𝑟. Our basic observation is that by initializing Private-PGM by
setting 𝜃𝑟(𝑥𝑟) = −∞for each 𝑥𝑟∈𝑍𝑟the cell of the associated
marginal will be 𝜇𝑟(𝑥𝑟) = 0, as desired. Moreover, each update
within the Private-PGM estimation procedure will try to update
𝜃𝑟(𝑥𝑟) by a finite amount, leaving it unchanged. Thus, 𝜇𝑟(𝑥𝑟) will
remain 0 during the entire estimation procedure. We conjecture
that the estimation procedure solves the following modified convex
optimization problem:
ˆ𝜇=
min
𝜇∈M
𝜇𝑟(𝑍𝑟)=0
𝐿(𝜇)
This approach is appealing because other simple approaches that
discard invalid tuples can inadvertently bias the distribution, which
is undesirable.
Note that for each clique in the set of structural zeros, we must
include that clique in our model, which increases the size of that
model. Thus, we should treat it as we would treat a clique selected
by AIM. That is, when calculating JT-SIZE in line 12 of AIM, we
need to include both the cliques selected in earlier iterations as well
as the cliques included in the structural zeros.
D.1
Experiments
In this section, we empirically evaluate this structural zeros en-
hancement, showing that it can reduce workload error in some
cases. For this experiment, we consider the general workload on
the fire dataset and compare the performance of AIM with and
without imposing structural zero constraints. This dataset contains
several related attributes, like “Zipcode of Incident“ and “City”.
While these attributes are not perfectly correlated, significant num-
bers of attribute combinations are impossible. We identified a total
of nine attribute pairs which contain some structural zeros and a
total of 2696 structural zero constraints within these nine marginals.
The results of this experiment are shown in Table 4. On average,
imposing structural zeros improves the performance of the mecha-
nism, although the improvement is not universal across all values
of epsilon we tested. Nevertheless, it is still useful to impose these
constraints for data quality purposes.
Table 4: Error of AIM on the fire dataset, with and
without imposing structural zero constraints.
𝜖
AIM
AIM+Structural Zeros
Ratio
0.010
0.613
0.542
1.130
0.031
0.303
0.263
1.151
0.100
0.141
0.153
0.924
0.316
0.087
0.077
1.124
1.000
0.052
0.053
0.979
3.162
0.044
0.045
0.964
10.00
0.038
0.032
1.170
31.62
0.029
0.026
1.149
100.0
0.025
0.025
1.004
E
RUNTIME EXPERIMENTS
Our primary focus in the main body of the paper was mechanism
utility, as measured by the workload error. In this section we discuss
the runtime of AIM, which is an important consideration when
deploying it in practice. Note that we do not compare against run-
time of other mechanisms here, because different mechanisms were
executed in different runtime environments. Figure 4 below shows
the runtime of AIM as a function of the privacy parameter. As evi-
dent from the figure, runtime increases drastically with the privacy
parameter. This is not surprising because AIM is budget-aware: it
knows to select larger marginals and run for more rounds when the
budget is higher, which in turn leads to longer runtime. For large
𝜖, the constraint on JT-SIZE is essential to allow the mechanism to
terminate at all. Without it, AIM may try to select marginal queries
that exceed memory resources and result in much longer runtime.
For small 𝜖, this constraint is not active, and could be removed
without affecting the behavior of AIM.
Recall that these experiments were conducted on one core of a
compute cluster with 4 GB of memory and a CPU speed of 2.4 GHz.
These machines were used due to the large number of experiments
we needed to conduct, but in real-world scenarios we only need to
run one execution of AIM, for a single dataset, workload, privacy
parameter, and trial. For this, we can use machines with much better
specs, which would improve the runtime significantly.

---

10
2
10
1
100
101
102
Epsilon
0
5
10
15
20
Time (hours)
adult
fire
msnbc
nltcs
salary
titanic
Figure 4: Runtime of AIM on the all-3way workload.
F
PRIVATE-PGM VS. RELAXED PROJECTION
In this paper, we built AIM on top of Private-PGM, leveraging prior
work for the generate step of the select-measure-generate para-
digm. Private-PGM is not the only method in this space, although it
was the first general purpose and scalable method to our knowledge.
“Relaxed Projection” [3] is another general purpose and scalable
method that solves the same problem, and could be used in place
of Private-PGM if desired. RAP, the main mechanism that utilizes
this technique, did not perform well in our experiments. However,
it is not clear from our experiments if the poor performance can be
attributed to the relaxed projection algorithm, or some other algo-
rithmic design decisions. In this section, we attempt to precisely
pin down the differences between these two related methods, tak-
ing care to fix possible confounding factors. We thus consider two
mechanisms: MWEM+PGM, which is defined in Algorithm 1, and
MWEM+Relaxed Projection which is identical to MWEM+PGM in
every way, except the call to Private-PGM is replaced with a call to
the relaxed projection algorithm of Aydore et al.
For this experiment, we consider the all-3way workload, and we
run each algorithm for 𝑇= 5, 10, . . . , 100, with five trials for each
hyper-parameter setting. We average the workload error across the
five trials, and report the minimum workload error across hyper-
parameter settings in Figure 5. Although the algorithms are con-
ceptually very similar, MWEM+PGM consistently outperforms
MWEM+Relaxed Projection, across every dataset and privacy level
considered. The performance difference is modest in many cases,
but significant on the fire dataset.
AP-PGM [39] offers another alternative to Private-PGM for the
generate step, and while it was shown to be an appealing alternative
to Private-PGM in some cases, within the context of an MWEM-
style algorithm, their own experiments demonstrate the superiority
of Private-PGM.
Generator networks [33] offer yet another alternative to Private-
PGM for the generate step. To the best of our knowledge, no direct
comparison between this approach and Private-PGM has been done
to date, where confounding factors are controlled for. Conceptually,
this approach is most similar to the relaxed projection approach, so
we conjecture the results to look similar to those shown in Figure 5.
G
TUNING MODEL CAPACITY
In Line 12 of AIM (Algorithm 2), we construct a set of candidates to
consider in the current round based on an upper limit on JT-SIZE.
80 MB was chosen to match prior work,8 but in general we can
tune it as desired to strike the right accuracy / runtime trade-off.
Unlike other hyper-parameters, there is no “sweet spot” for this one:
setting larger model capacities should always make the mechanism
perform better, at the cost of increased runtime. We demonstrate
this trade-off empirically in Figure 6 (a-b). For 𝜖= 0.1, 1, and 10, we
considered model capacities ranging from 1.25 MB to 1.28 GB, and
ran AIM on the fire dataset with the all-3way workload. Results
are averaged over five trials, with error bars indicating the min/max
runtime and workload error across those trials. Our main findings
are listed below:
(1) As expected, runtime increases with model capacity, and
workload error decreases with capacity. The case 𝜖= 0.1 is
an exception, where both the plots level off beyond a capac-
ity of 20𝑀𝐵. This is because the capacity constraint is not
active in this regime: AIM already favors small marginals
when the available privacy budget is small by virtue of
the quality score function for marginal query selection, so
the model remains small even without the model capacity
constraint.
(2) Using the default model capacity and 𝜖= 1 resulted in a
9 hour runtime. We can slightly reduce error further, by
about 13%, by increasing the model capacity to 1.28𝐺𝐵
and waiting 7 days. Conversely, we can reduce the model
capacity to 5𝑀𝐵which increases error by about 75%, but
takes less than one hour. The law of diminishing returns is
at play.
Ultimately, the model capacity to use is a policy decision. In real-
world deployments, it is certainly reasonable to spend additional
computational time for even a small boost in utility.
H
ADAPTIVE ROUNDS EXPERIMENTS
In Section 6.3, we saw that the “Adaptive Rounds + Budget Split”
element described in Section 4 had an important role in the strong
performance of AIM, offering 1.48× improvement over the default
number of rounds on average. In this section, we expand that ex-
periment, by comparing against alternatives that use a different
number of rounds. In particular, we run remove this element of
AIM, and instead run the mechanism for fixed rounds 𝑇, where
privacy budget is split evenly across rounds, and 𝑇is varied from
{2, 4, 8, 16, 32, 64, 128, 256,𝑑}. For each choice of𝑇, we run the mech-
anism across all experimental settings (6 datasets × 3 workloads ×
9 privacy levels) and 5 trials for each setting. We then compute the
mean workload error across the five trials, and compare that to the
mean workload error of AIM with adaptive rounds + budget split to
calculate an “improvement ratios”. The distribution of improvment
ratios for each 𝑇across the 162 experimental settings is shown in
Figure 7. The geometric mean of improvement ratios is 5.07 for
𝑇= 2, 3.87 for𝑇= 4, 2.36 for𝑇= 8, 1.46 for𝑇= 16, 1.13 for𝑇= 32,
1.06 for 𝑇= 64, 1.17 for 𝑇= 128, 1.27 for 𝑇= 256, and 1.48 for the
defualt 𝑇= 𝑑. Thus, it is better to use adaptive rounds + budget
8Cai et al. [7] limit the size of the largest clique in the junction tree to have at most
107 cells (80 MB with 8 byte floats), while we limit the overall size of the junction tree.

---

adult
fire
loans
msnbc
nltcs
titanic
0.00
0.25
0.50
0.75
1.00
1.25
1.50
1.75
2.00
Workload Error
MWEM + Relaxed Projection
MWEM + PGM
(a) 𝜖= 0.1
adult
fire
loans
msnbc
nltcs
titanic
0.00
0.25
0.50
0.75
1.00
1.25
1.50
1.75
2.00
Workload Error
MWEM + Relaxed Projection
MWEM + PGM
(b) 𝜖= 1.0
adult
fire
loans
msnbc
nltcs
titanic
0.00
0.25
0.50
0.75
1.00
1.25
1.50
1.75
2.00
Workload Error
MWEM + Relaxed Projection
MWEM + PGM
(c) 𝜖= 10.0
Figure 5: MWEM+Relaxed Projection vs. MWEM+PGM on the all-3way workload.
100
101
102
103
Max. Model Size (MB)
0.00
0.05
0.10
0.15
0.20
Workload Error
1 hour
9 hours
7 days
Epsilon=0.1
Epsilon=1.0
Epsilon=10.0
(a) Workload Error vs. Model Capacity
100
101
102
103
Max. Model Size (MB)
100
101
102
Runtime (hours)
Epsilon=0.1
Epsilon=1.0
Epsilon=10.0
(b) Runtime vs. Model Capacity
Figure 6: Impact of the model capacity hyper-parameter on the error and runtime of AIM.
split than any fixed 𝑇. If we chose the best 𝑇in hindsight for each
experimental setting, that is on average 1.1× better than using adap-
tive rounds + budget split. However, in general it would require
spending significant privacy budget to optimize 𝑇in practice [31],
and this small improvement in utility would likely not be enough
to warrant the high privacy cost of hyper-parameter optimization.
2
4
8
16
32
64
128
256
Default
Hindsight
Rounds
2
1
20
21
22
23
24
Improvement Ratio
Figure 7: Adaptive rounds experiment
I
SENSITIVITY TO HYPER-PARAMETERS
In Section 6, we evaluated both AIM and existing mechanisms us-
ing default hyper-parameter settings. A natural question is to what
extent the results would have changed if the hyper-parameters of
competing mechanisms had been near-optimally tuned for each
mechanism. In this section, we explore this question, by evaluating
three mechanisms (MWEM+PGM, GEM, and RAP) across a variety
of hyper-parameter settings. GEM and RAP were chosen because
the reported results in their experimental evaluation was best per-
formance on a grid of hyper-parameter settings. MWEM+PGM
was chosen because it is most similar to AIM. The other mecha-
nisms, like PrivMRF, PrivBayes, and MST are not included in this
experiment since these mechanisms were all evaluated with fixed
hyper-parameter settings in their own experimental evaluation
(and the effect of hyper-parameters were investigated in separate
experiments, if applicable).
For this experiment, we focus on the adult dataset and the
all-3way workload, but vary 𝜖∈[0.01, 100]. We run each mech-
anism for 𝑇= {2, 4, 8, 16, 32, 64, 75, 128, 256} rounds. By default,
MWEM+PGM runs for𝑑= 15 rounds, GEM runs for 75 rounds, and
RAP runs for 10 rounds. We used the same compute resources de-
scribed in Section 6, and used a 24 hour time limit for MWEM+PGM
and GEM. We used a smaller 4 hour time limit for RAP, since that re-
quired significantly more RAM (64 GB) than the other mechanisms
so only 2 executions of the mechanism could be run in parallel on
the compute cluster used in experiments.

---

Figure 8 shows the performance of these mechanisms with vary-
ing numbers of rounds. Note that none of the mechanisms com-
pleted for 256 rounds, GEM did not complete for 128 rounds and
RAP did not complete for 64 rounds. This is because these mecha-
nisms surpassed the time limit for the experiment. For MWEM+PGM,
the best hyper-parameter setting varied by 𝜖, with 𝑇= 8 working
well for 𝜖≤0.3, and 𝑇∈{64, 75, 128} working well for 𝜖≥1.
There is some loss in performance for using 𝑇= 16 (the default is
𝑇= 15), although the difference is small. Note that state-of-the-art
DP hyper-parameter selection algorithms come at a multiplicative
3× cost to the privacy parameter [31, 42]. Thus, it is clear from
Figure 8a that it is better to use the default hyper-parameter setting
than using a DP mechanism to optimize the hyper-parameter, espe-
cially for lower values of 𝜖. For example, at 𝜖= 0.1, MWEM+PGM
with 𝑇= 16 achieved a workload error of 0.62. The best work-
load error achieved at 𝜖= 0.032 was only 0.86 (for 𝑇= 8), which
would be worse than using the full private budget for the default
hyper-parameter setting.
The behavior of GEM demonstrated a similar trend, with 𝑇= 32
working well for 𝜖≤0.1 and 𝑇∈64, 75 working well for 𝜖≥
0.32. In this case, the default setting was actually best in many
cases, and in the settings where it was not optimal, it is still better
than the alternative of optimizing the hyper-parameter with a DP
mechanism, which comes at a 3× multiplicative privacy cost.
The behavior of RAP demonstrated the same trend, with larger
values of 𝑇working better for larger 𝜖, and vice-versa.
In short, while the default hyper-parameter settings are not
optimal in hindsight, the amount of utility gained by optimizing
hyper-parameters is not enough to warrant the high cost to pri-
vacy. Moreover, even if we ignored the privacy cost of this hyper-
parameter optimization, the utility gained would not be enough to
substantially change our main findings from Section 6.
J
OTHER ERROR METRICS
In this work, we primarily focused on the 𝐿1 workload error metric
defined in Definition 2, although other error metrics could have
been used instead. In Figures 9 and 10 we visualize the error of
AIM and other mechanism using an 𝐿2 error metric as well as a
max error metric. The results for the 𝐿2 error metric are similar to
the standard 𝐿1 metric, except MWEM+PGM outperforms AIM on
the salary dataset at 𝜖≤1. On other datasets, the performance
of AIM relative to competitors is roughly the same between the 𝐿1
and 𝐿2 metrics. AIM is also often teh best-performing mechanism
on the 𝐿inf (max) error metric, although GEM does outperform it
on both the fire and msnbc datasets. It is not surprising that GEM
outperforms AIM in some cases, since it specifically targets the 𝐿inf
error metric. It is interesting that AIM still outperforms GEM and
the other mechanisms on this error metric in other cases.
K
RESULTS ON 2-WAY MARGINALS
The workloads considered in our main experiments (all-3way, tar-
get, and skewed) consisted of different subsets of 3-way marginal
queries. In this section, we provide additional experiments on the
all-way workload, which contains all 2-way marginal queries. The
experimental setup is exactly the same as described in Section 6.
Results are shown in Figure 11. As before, AIM consistently outper-
forms all competing mechanisms on this workload. Interestingly,
Gaussian exhibits strong performance on this workload, especiall
for higher values of 𝜖, and the msnbc dataset. While Gaussian was
also strong in this regime for the other workloads, here it is surpass-
ing AIM at 𝜖= 1, whereas on the other workloads it was generally
not competitive until 𝜖≥31. This behavior can be attributed to
the fact that all-2way is a smaller workload than the others con-
sidered, and therefore the noise magnitude required to measure
every query in the workload is not excessively large. We remind
the reader that unlike the other mechanisms, Gaussian is a baseline
that does not produce synthetic data — it only produces noisy query
answers. Thus, even though it achieves lower workload error than
the synthetic data mechanisms, it would not be a viable mechanism
to use if synthetic data was needed.

---

10
2
10
1
100
101
102
Epsilon
10
1
100
Workload Error
rounds
2
4
8
16
32
64
75
128
(a) MWEM+PGM
10
2
10
1
100
101
102
Epsilon
10
1
100
Workload Error
rounds
2
4
8
16
32
64
75
(b) GEM
10
2
10
1
100
101
102
Epsilon
10
1
100
Workload Error
rounds
2
4
8
16
32
(c) RAP
Figure 8: Effect of the number of rounds on the performance of MWEM+PGM, GEM, and RAP.
AIM
PrivMRF
MST
Privbayes+PGM
MWEM+PGM
GEM
RAP
Independent
Gaussian
10
2
10
1
100
101
102
10
3
10
2
10
1
100
Workload Error
(a) Adult
10
2
10
1
100
101
102
10
3
10
2
10
1
100
(b) Salary
10
2
10
1
100
101
102
10
4
10
3
10
2
10
1
100
(c) MSNBC
10
2
10
1
100
101
102
Epsilon
10
4
10
3
10
2
10
1
100
Workload Error
(d) Fire
10
2
10
1
100
101
102
Epsilon
10
4
10
3
10
2
10
1
100
(e) NLTCS
10
2
10
1
100
101
102
Epsilon
10
2
10
1
100
(f) Titanic
Figure 9: 𝐿2 workload error of competing mechanisms on the all-3way workload for 𝜖= 0.01, . . . , 100.

---

AIM
PrivMRF
MST
Privbayes+PGM
MWEM+PGM
GEM
RAP
Independent
Gaussian
10
2
10
1
100
101
102
10
2
10
1
100
Workload Error
(a) Adult
10
2
10
1
100
101
102
10
2
10
1
100
(b) Salary
10
2
10
1
100
101
102
10
2
10
1
100
(c) MSNBC
10
2
10
1
100
101
102
Epsilon
10
2
10
1
100
Workload Error
(d) Fire
10
2
10
1
100
101
102
Epsilon
10
2
10
1
100
(e) NLTCS
10
2
10
1
100
101
102
Epsilon
10
2
10
1
100
(f) Titanic
Figure 10: 𝐿inf (max) workload error of competing mechanisms on the all-3way workload for 𝜖= 0.01, . . . , 100.
AIM
PrivMRF
MST
Privbayes+PGM
MWEM+PGM
GEM
RAP
Independent
Gaussian
10
2
10
1
100
101
102
10
2
10
1
100
Workload Error
(a) Adult
10
2
10
1
100
101
102
10
2
10
1
100
(b) Salary
10
2
10
1
100
101
102
10
3
10
2
10
1
100
(c) MSNBC
10
2
10
1
100
101
102
Epsilon
10
3
10
2
10
1
100
Workload Error
(d) Fire
10
2
10
1
100
101
102
Epsilon
10
3
10
2
10
1
100
(e) NLTCS
10
2
10
1
100
101
102
Epsilon
10
1
100
(f) Titanic
Figure 11: workload error of competing mechanisms on the all-2way workload for 𝜖= 0.01, . . . , 100.

---

