# Distinctiveness Maximization in Datasets Assemblage

> 来源: https://arxiv.org/pdf/2401.00659

arXiv:2401.00659v4  [cs.DB]  27 Feb 2025
Distinctiveness Maximization in Datasets Assemblage
Tingting Wang
RMIT University
Melbourne, VIC, Australia
tingting.wang@student.rmit.edu.au
Shixun Huang
The University of Wollongong
Wollongong, NSW, Australia
shixunh@uow.edu.au
Zhifeng Bao∗
RMIT University
Melbourne, VIC, Australia
zhifeng.bao@rmit.edu.au
J. Shane Culpepper
The University of Queensland
St Lucia, QLD, Australia
s.culpepper@uq.edu.au
Volkan Dedeoglu
CSIRO’s Data61
Pullenvale, QLD, Australia
volkan.dedeoglu@csiro.au
Reza Arablouei
CSIRO’s Data61
Pullenvale, QLD, Australia
reza.arablouei@csiro.au
Abstract
In this paper, given a user’s query set and budget, we aim to use
the limited budget to help users assemble a set of datasets that can
enrich a base dataset by introducing the maximum number of dis-
tinct tuples (i.e., maximizing distinctiveness). We prove this prob-
lem to be NP-hard. A greedy algorithm using exact distinctiveness
computation attains an approximation ratio of (1 −푒−1)/2, but it
lacks eﬃciency and scalability due to its frequent computation of
the exact distinctiveness marginal gain of any candidate dataset
for selection. This requires scanning through every tuple in candi-
date datasets and thus is unaﬀordable in practice. To overcome this
limitation, we propose an eﬃcient machine learning (ML)-based
method for estimating the distinctiveness marginal gain of any
candidate dataset. This eﬀectively eliminates the need to test each
tuple individually. Estimating the distinctiveness marginal gain of
a dataset involves estimating the number of distinct tuples in the
tuple sets returned by each query in a query set across multiple
datasets. This can be viewed as the cardinality estimation for a
query set on a set of datasets, and the proposed method is the
ﬁrst to tackle this cardinality estimation problem. This is a signiﬁ-
cant advancement over prior methods that were limited to single-
query cardinality estimation on a single dataset and struggled with
identifying overlaps among tuple sets returned by each query in
a query set across multiple datasets. Extensive experiments using
ﬁve real-world data pools demonstrate that our algorithm, which
utilizes ML-based distinctiveness estimation, outperforms all rel-
evant baselines in eﬀectiveness, eﬃciency, and scalability. A case
study on two downstream ML tasks also highlights its potential to
ﬁnd datasets with more useful tuples to enhance the performance
of ML tasks.
CCS Concepts
• Information systems →Information integration.
∗The corresponding author
Permission to make digital or hard copies of all or part of this work for personal or
classroom use is granted without fee provided that copies are not made or distributed
for proﬁt or commercial advantage and that copies bear this notice and the full cita-
tion on the ﬁrst page. Copyrights for components of this work owned by others than
the author(s) must be honored. Abstracting with credit is permitted. To copy other-
wise, or republish, to post on servers or to redistribute to lists, requires prior speciﬁc
permission and/or a fee. Request permissions from permissions@acm.org.
WWW ’25, Sydney, NSW, Australia
© 2025 Copyright held by the owner/author(s). Publication rights licensed to ACM.
ACM ISBN 978-x-xxxx-xxxx-x/YYYY/MM
https://doi.org/10.1145/nnnnnnn.nnnnnnn
Keywords
Datasets assemblage; Distinctiveness maximization
ACM Reference Format:
Tingting Wang, Shixun Huang, Zhifeng Bao, J. Shane Culpepper, Volkan
Dedeoglu, and Reza Arablouei. 2025. Distinctiveness Maximization in Datasets
Assemblage. In Proceedings of the ACM Web Conference 2025 (WWW ’25),
April 28-May 2, 2025, Sydney, NSW, Australia. ACM, New York, NY, USA,
15 pages. https://doi.org/10.1145/nnnnnnn.nnnnnnn
1
Introduction
Data is an essential resource for informed decision making [59].
This importance is reinforced by remarkable progress in machine
learning (ML), which heavily relies on vast amounts of data to ex-
tract insights [50]. Hence, data preparation plays a pivotal role in
transforming raw data into meaningful insights to supportdecision-
making processes [70].
A common pipeline of data preparation. As shown in Fig. 1,
it comprises three key stages: data cleaning, datasets discovery,
and tuples discovery [50]. In Stage 1, cleaned datasets are obtained
through data cleaning, involving tasks like missing value imputa-
tion [39] and duplicate removal [9]. In Stage 2, a subset of cleaned
candidate datasets identiﬁed through datasets discovery is acquired
by users to meet their information needs. At Stage 3, tuples are se-
lected from the candidate datasets using tuples discovery to fulﬁll
users’ speciﬁc targets (e.g., enriching the training set of an existing
ML model [7]). Despite extensive prior research eﬀorts in datasets
discovery (Stage 2) [2, 5, 6, 20, 22, 27, 44, 45, 58], an important re-
search gap remains, limiting the practicality of existing solutions.
The gap in the pipeline: datasets discovery. Basic datasets dis-
covery returns top-푘relevant datasets using keywords (e.g., AWS
Marketplace [44]) or a base dataset (e.g., table union search [51]).
Its search process generally evaluates each candidate dataset indi-
vidually, focusing on the similarity or overlaps between individual
datasets and given keywords or base datasets. This can bring sub-
stantial information redundancy when assembling these returned
datasets [55]. Moreover, this approach implicitly assumes that users
can aﬀord all of the discovered datasets to later perform tuples dis-
covery, which is often unrealistic. Users often have a limited bud-
get and emphasize the return on investment [1].
Our study: advanced datasets assemblage. To bridge the above
gap, we delve into advanced datasets assemblage. It builds upon
the results of basic datasets discovery using a user’s base dataset.
It allows a user to specify her ﬁne-grained information needs to

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
Find a subset S of D with the  
maximum distinctiveness given 
a query set and a budget
Search relevant datasets by 
a base dataset, followed by 
schema alignment
Raw datasets
2 Datasets discovery
Data cleaning
1
Missing values
Duplicates
Inconsistency
Outliers
......
Coarse-grained candidates D
A Basic datasets discovery
B Advanced datasets assemblage
Fine-grained candidate S
Select tuples from datasets in 
S satisfying a specific target
3 Tuples discovery
Our pipeline
Existing pipeline
d10
d5
d1
d10
d5
d10
d5
d1
d15
...
......
Figure 1:
Our data preparation pipeline with advanced
datasets assemblage versus existing pipelines. The user in-
put for each stage is shown by color (blue for basic datasets
discovery, red for advanced datasets assemblage, and purple
for tuples discovery).
assemble a useful dataset collection within a budget, aiming to
evaluate the dataset collection as a whole to reduce information
redundancy. Since SQL queries are widely used to pinpoint ﬁne-
grained and precise information within datasets [17, 38, 61], we
employ a query set with SQL queries to allow a user to express her
ﬁne-grained information needs. Additionally, the schemas of can-
didate datasets obtained through basic datasets discovery can be
easily and eﬀectively aligned with the user’s base dataset using the
state-of-the-art schema alignment techniques, achieving high ac-
curacy [53]. Therefore, the user can readily formulate her query set
using the schema information from her base dataset. We introduce
the concept of distinctiveness to evaluate the usefulness of datasets
discovered w.r.t. a user’s ﬁne-grained information needs. Let 푄(푑)
be the union of tuple sets returned by each query in a user’s query
set 푄on a dataset 푑and 푑푢be a user’s base dataset. We deﬁne the
distinctiveness for a dataset as the size of 푄(푑), including tuples in
푄(푑푢). Correspondingly, the distinctiveness for a set of datasets is
deﬁned as the size of the union of 푄(푑) over each dataset 푑in a set
of datasets, including tuples in 푄(푑푢). The usefulness of datasets is
application-dependent and remains an open problem, but this dis-
tinctiveness deﬁnition serves as a starting point for assembling a
useful dataset collection with distinct tuples as no one prefers to
purchase an “assembled” dataset full of duplicate information. By
maximizing distinctiveness, advanced datasets assemblage identi-
ﬁes datasets with minimal information redundancy within a bud-
get, thereby locating useful datasets in a cost-eﬀective manner.
To this end, we introduce the problem of distinctiveness max-
imization in datasets assemblage. Given a user’s ﬁne-grained in-
formation needs expressed as a query set, along with her base
dataset and budget, and a set of candidate datasets discovered in
basic datasets discovery, our goal is to select a subset of candi-
date datasets for user acquisition. This selection process maximizes
the total distinctiveness for the subset within the user’s budget.
We exemplify this problem within the complete data preparation
pipeline in Example 1.1.
Example 1.1. Suppose a user wishes to purchase datasets about
Melbourne house information. As shown in Fig. 2, a user must
spend $400 to acquire a set of datasets, 퐷= {푑1,푑5,푑10}, which
are discovered using a base dataset 푑푢at Stage 2(A) within the
existing pipeline. Conversely, at Stage 2(B) in our pipeline, the
user provides a query set 푄= {푞1,푞2} locating Melbourne house
information. For each dataset 푑∈퐷, the union 푄(푑) of tuple
sets returned by each query in 푄on 푑is obtained. A subset 푆=
{푑5,푑10} of 퐷exhibits maximum distinctiveness (푄(푑5), 푄(푑10),
and 푄(푑푢) each have two tuples. 푄(푑5) has an overlap with both
푄(푑10) and 푄(푑푢), resulting in the distinctiveness of 푆of 4, i.e.,
|푄(푑5) ∪푄(푑10) ∪푄(푑푢)| = 4). The user can purchase this subset
for only $300. Using our pipeline, a user spends less money while
achieving the same tuples discovery results as 퐷, as shown in Stage
3 of Fig 2.
The gap in a solution backbone. We establish the NP-hardness
of obtaining an exact solution for the distinctness maximization
problem (See Theorem 2.5), as well as showing a greedy algorithm
using exact distinctiveness computation(Exact-Greedy for brevity)
that can achieve an approximation ratio of (1 −1/푒)/2 in §3.
However, the Exact-Greedy algorithm heavily relies on the fre-
quent computation of the exact distinctiveness marginal gain of
any dataset in candidate datasets during selection. The exact dis-
tinctiveness marginal gain of a dataset is computed as the diﬀer-
ence between the distinctiveness for a set of datasets including
the dataset and the distinctiveness for the dataset itself. Thus, the
union 푄(푑) of tuple sets returned by each query in a query set 푄
over any dataset 푑in candidate datasets must be obtained, which
demands inspecting every tuple in the candidate datasets returned
for the queries provided, signiﬁcantly degrading both eﬃciency
and scalability. To overcome this limitation, a natural choice is to ef-
fectively approximate the distinctiveness marginal gain rather than
relying on the exact computation.
From distinctiveness to cardinality estimation. The key to estimating
the distinctiveness marginal gain of a dataset is to estimate the dis-
tinctiveness for a set of datasets w.r.t. a query set 푄. This involves
estimating the size of the union of 푄(푑) over each dataset 푑in a set
of datasets, and we refer to it as multi-dataset-query cardinality estim
ation (MCE). MCE can be viewed as a generalized version of the
classical cardinality estimation problem [24, 26, 32, 42, 71, 76], which
estimates the cardinality of a single query for a single dataset (i.e.,
the size of the tuple set returned by a query on a dataset). To
distinguish between these two concepts, we refer to the latter as
single-dataset-query cardinality estimation (SCE). As illustrated in
Example 1.2 below, existing SCE solutions cannot be used to solve
the MCE problem since they cannot capture both overlaps among
the tuple sets returned by diﬀerent queries on a dataset and over-
laps among diﬀerent datasets.
Example 1.2 (Using the SCE solution for the MCE problem). Con-
sider the datasets 푑5 and 푑10, and a query set 푄= {푞1,푞2} shown
in Fig. 3. Using an SCE solution, for 푑5, the cardinality of 푞1 is 2,
and the cardinality of 푞2 is 2. For 푑10, the cardinality of 푞1 is 2, and
the cardinality of 푞2 is 2. Since the SCE solution only reports the
cardinality of each query for each dataset, the size of the union of
푄(푑5) and 푄(푑10) is estimated to be 8, by aggregating the cardinal-
ity of each query on each dataset, which is much greater than the
true result (three distinct tuples in the union of 푄(푑5) and 푄(푑10)).
A novel solution. To address this, we propose a novel ML-based
method to estimate the distinctiveness for a set of datasets w.r.t. a
query set. Speciﬁcally, we leverage a pre-trained model to trans-
form the data summary of a dataset into embeddings that capture

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
City
Type
Land 
size (m2)
House 
price
Melbourne
House
60
510K
Melbourne
Studio
20
320K
Sydney
Apartment
80
548K
Sydney
House
200
820K
Category
Location
Car 
space
Price
House
Melbourne
1
520,000
Apartment
Sydney
1
735,000
House
Sydney
2
815,000
House
Melbourne
1
510,000
Type
City
Price
Apartment
SYD
705,000
House
MEL
520,000
House
SYD
970,000
House
MEL
750,000
Stage 1: Datasets after data cleaning
Type
City
Price
Apartment
Sydney
705,000
House
Melbourne
520,000
House
Sydney
970,000
House
Melbourne
750,000
Type
City
Price
House
Melbourne
510,000
Studio
Melbourne
320,000
Apartment
Sydney
548,000
House
Sydney
820,000
Type
City
Price
House
Melbourne
520,000
Apartment
Sydney
735,000
House
Sydney
815,000
House
Melbourne
510,000
y
y
• ($100)
• ($100)
• !($200)
Stage 2(A): Coarse-grained candidates after basic datasets discovery
Stage 2(B): Fine-grained candidates after advanced datasets assemblage
Type
City
Price
House
Melbourne
520,000
House
Melbourne
750,000
Stage 3: Tuples after tuples discovery
...
...
A query set Q
• : SELECT * FROM d WHERE Type = 
‘House’ and City = ‘Melbourne’
• : SELECT * FROM d WHERE 500,000 < 
Price < 800,000 and City = ‘Melbourne’
A base dataset du
Type
City
Price
House
Sydney
815,000
House
Melbourne
510,000
Apartment
Melbourne
470,000
House
Melbourne
975,000
Target: a house price prediction task
User 
Type
City
Price
House
Melbourne
520,000
Apartment
Sydney
735,000
House
Sydney
815,000
House
Melbourne
510,000
Type
City
Price
Apartment
Sydney
705,000
House
Melbourne
520,000
House
Sydney
970,000
House
Melbourne
750,000
• ($100)
• !($200)
...
Figure 2: An example of Fig. 1 where our pipeline achieves the same tuples discovery with a lower budget.
A query set Q
• : SELECT * FROM d WHERE Type = ‘House’ 
and City = ‘Melbourne’
•!: SELECT * FROM d WHERE 500,000 < Price 
< 800,000 and City = ‘Melbourne’
Type
City
Price
Apartment
Sydney
705,000
House
Melbourne
520,000
House
Sydney
970,000
House
Melbourne
750,000
Type
City
Price
House
Melbourne
520,000
Apartment
Sydney
735,000
House
Sydney
815,000
House
Melbourne
510,000
• 
•!"
House
Melbourne
520,000
House
Melbourne
510,000
House
Melbourne
520,000
House
Melbourne
750,000
House
Melbourne
520,000
House
Melbourne
510,000
House
Melbourne
750,000
#(• )
#(•!")
,
#(• ) ∪#(•!")
Figure 3: An example for MCE (red for the overlapping tu-
ple).
nuanced information from each dataset, queries, and their interre-
lationships to eﬀectively identify overlaps among the tuple sets re-
turned by diﬀerent queries on a dataset. We use the embeddings cre-
ated to estimate distinctiveness for the respective dataset. Further-
more, we incorporate a learning function to consolidate the data
summaries from individual datasets to generate a data summary
corresponding to a collection of the considered datasets while iden-
tifying overlaps among datasets. This allows us to estimate the dis-
tinctiveness of a set of datasets utilizing pertinent pre-trained mod-
els. Finally, we propose a new greedy algorithm that uses our ML-
based distinctiveness estimation method (ML-Greedy for brevity)
to address the distinctiveness maximization problem (§4).
Evaluation. Since this is the ﬁrst attempt to investigate this prob-
lem, we present a range of strategies to prepare candidate datasets
and query sets. We achieve this using ﬁve real-world data pools,
controlling the number of overlapping tuples and query results in
the candidate datasets to encompass practical scenarios. We be-
lieve this setup is a valuable resource for future research on this
emerging topic (§5).
We conduct extensive evaluations on ﬁve real-world data pools
showcasing: 1) Our ML-based distinctiveness estimation method
signiﬁcantly outperformsthe SOTA SCE solution on the MCE prob-
lem, with one-order-of-magnitude higher accuracy for estimating
distinctiveness and is several times more eﬃcient than the SOTA
SCE solution. 2) Our ML-Greedy algorithm is competitive with Exact-Greedy
and signiﬁcantly outperforms other baselines for distinctiveness
Table 1: Summary of notation.
notation
description
푑, 퐷, 푆, 푑푢
a dataset, a set of datasets, a subset of 퐷, a base dataset
푝(푑),푝(푆)
the price of a dataset 푑, the price of a set 푆of datasets
퐵
a budget
푞, 푄
a query, a query set
푞(푑)
a tuple set returned by 푞on 푑
푄(푑)
the union of tuple sets returned by each 푞∈푄on 푑
풟(푆,푑푢,푄)
the distinctiveness of a set 푆of datasets over 푄
maximization. 3) Our ML-Greedy algorithm achieves impressive ef-
ﬁciency gains, with up to four orders of magnitude speedup over
Exact-Greedy and three orders of magnitude improvement over
the most eﬃcient baseline method.
We conduct a case study on two downstream ML tasks, classiﬁ-
cation and regression, to assess the impact of our datasets assem-
blage methods, ML-Greedy and Exact-Greedy, on downstream task
performance through the pipeline in Fig. 1. By comparing with the
SOTA basic datasets discovery method, we validate our methods’
potential in identifying datasets with more useful tuples (§6).
2
Problem Formulation
In this section, we outline our problem formulation and present the
hardness analysis for our problem. We summarize the frequently
used notations in Table 1.
Given a user’s base dataset 푑푢, a set 퐷= {푑1, ..., 푑|퐷|} of can-
didate datasets is retrieved using basic datasets discovery. Each
dataset 푑∈퐷has a price 푝(푑) ∈R+, determined by a pricing func-
tion 푝. It is noteworthy that data pricing is an open problem and
falls outside the scope of our study. We brieﬂy discuss it in §7 (Re-
lated Work). We deﬁne the total price of 퐷as 푝(퐷) = Í
푑∈퐷푝(푑).
A user submits a query set with SQL queries 푄= {푞1, ..., 푞|푄|} to
specify ﬁne-grained information needs. An SQL query can be ex-
pressed as SELECT * FROM푑WHERE ... AND푙푐≤푐≤푢푐AND ... where
푑is a dataset and푐is a query column, handling both numerical and
categorical data. For categorical data, 푙푐equals 푢푐. The queries 푞1
and 푞2 in Fig. 3 are two examples.
A user interested in acquiring datasets may want to determine
the number of unique tuples returned from a set 퐷of datasets

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
based on a query set 푄and base dataset 푑푢. We refer to this con-
cept as the distinctiveness of 퐷in relation to a user’s information
needs.
Deﬁnition 2.1 (Distinctiveness). Suppose 푞(푑) is the tuple set re-
turned by applying query 푞to dataset 푑, and 푄(푑) is the union of
the tuple sets returned by each 푞∈푄on 푑, referred to as 푄(푑) =
∪푞∈푄푞(푑). The distinctiveness 풟(푆,푑푢,푄) of a set of datasets 푆is
the size of the union of푄(푑) over all푑∈푆∪푑푢. That is, 풟(푆,푑푢,푄) =
Ð
푑∈푆∪푑푢푄(푑)
.
As mentioned in §1, the distinctiveness estimation problem is
analogous to the MCE problem, as formalized below.
Deﬁnition 2.2 (Multi-dataset-query cardinality estimation (MCE)).
Given a set 퐷of datasets and a query set 푄, MCE estimates the
cardinality of 푄for 퐷, which is the size of the union of 푄(푑) over
each dataset 푑∈퐷, i.e., |Ð
푑∈퐷푄(푑)|
In the rest of this paper, we use the concepts of distinctiveness
estimation and MCE interchangeably. Notably, when 푄has only
one query (|푄| = 1) and 퐷contains only one dataset (|퐷| = 1),
the distinctiveness estimation problem is equivalent to the well-
known SCE problem [42, 71, 76].
Deﬁnition 2.3 (Distinctiveness Maximization (DM)). Given a bud-
get 퐵, a query set 푄, a base dataset 푑푢, a set 퐷of candidate datasets,
and a pricing function 푝, the DM problem returns a subset 푆∗⊆퐷
that yields the maximum distinctiveness within the budget 퐵. For-
mally, we have
푆∗= argmax푆⊆퐷풟(푆,푑푢,푄) s.t. Í
푑∈푆푝(푑) ≤퐵.
(1)
We prove the NP-hardness of the DM problem using a reduction
from the maximum coverage (MC) problem [48].
Deﬁnition 2.4 (Maximum Coverage (MC) [48]). Given a universe
of elements 푉= {푒1, ..., 푒푛}, a list of sets {푆′
푖⊆푉}푚
푖=1 (possibly
overlapping), and a bound 퐾< 푚, the goal is to ﬁnd a collection S
of sets such that | ∪푆′∈S 푆′| is maximized and |S| = 퐾.
Theorem 2.5. The DM problem is NP-hard.
Proof. We demonstrate a polynomial-time reduction from any
instance of the MC problem to an instance of the DM problem.
Here every element 푒∈푉from the MC instance is converted into
a tuple. For categorical elements, each is assigned a unique index,
which is then mapped to a tuple. A set of elements 푆′ ⊆푉in the
MC problem corresponds to a dataset 푑∈퐷in the DM problem.
Hence, the universe 푉is equivalent to the universe of all tuples
푇퐷= Ð
푑∈퐷푑. By setting 푝(푑) = 1, we map 퐾to 퐵. Next, we deﬁne
an empty base dataset 푑푢= ∅and a query set 푄= {푞} with 푞=
SELECT * FROM 푑WHERE 푚푖푛(푇퐷) ≤푐≤푚푎푥(푇퐷) where 푚푖푛(푇퐷)
and 푚푎푥(푇퐷) are the minimum and maximum values in 푇퐷. As a
result, 푄(푑) includes all tuples in 푑, establishing a one-to-one cor-
respondence between 푆′ and 푄(푑). So, the objective of maximiz-
ing | ∪푆′∈S 푆′| and | Ð
푑∈푆∪푑푢푄(푑)| are equivalent. Therefore, the
optimal solution of the DM problem also solves the optimal MC
problem. Given the polynomial time complexity for this reduction,
and the NP-hardness of MC, the DM problem is also NP-hard.
□
Algorithm 1 Exact-Greedy
Input: a set 퐷of datasets, a base dataset 푑푢, a query set 푄, a budget 퐵;
Output: a subset 푆⊆퐷of datasets with distinctiveness;
1: 푆←∅, T ←∅, 푇푆←∅;
2: for 푑∈퐷∪푑푢do
3:
푄(푑) ←∅;
4:
for 푞∈푄do 푞(푑) ←ExecuteQueries(푑,푞), 푄(푑) ←푄(푑) ∪푞(푑);
5:
T[푑] ←푄(푑);
6: 푇푆←푇푆∪T[푑푢];
7: while 퐷≠∅do
8:
푔∗←0, 푑∗←∅, 푇∗←∅;
9:
for 푑∈퐷do
10:
푇←푇푆∪T[푑], 푔←(|푇| −|푇푆|)/푝(푑);
11:
if 푔> 푔∗then 푔∗←푔, 푑∗←푑, 푇∗←푇;
12:
if 푝(푆) + 푝(푑∗) ≤퐵then 푆←푆∪푑∗, 푇푆←푇∗;
13:
퐷←퐷\ 푑∗;
14: 푑푡←argmax푑∈퐷∧푝(푑) ≤퐵|T[푑] ∪T[푑푢]|;
15: if |푇푆| < |T[푑푡] ∪T[푑푢]| return {푑푡} and |T[푑푡] ∪T[푑푢]|;
16: return 푆and |푇푆|;
3
Greedy Algorithm using Exact
Distinctiveness Computation
Given the NP-hardness of the DM problem, obtaining an optimal
solution is computationally intractable, even for moderately sized
datasets. Therefore, we propose a greedy algorithm using exact dis-
tinctiveness computation, which we call Exact-Greedy, to ﬁnd ap-
proximate solutions with a theoretical guarantee. The pseudocode
for Exact-Greedy is shown in Alg. 1. Speciﬁcally, we begin by ex-
ecuting each query 푞∈푄on every dataset 푑∈퐷, and on the
base dataset 푑푢, followed by merging the tuple sets 푞(푑) returned
for 푞∈푄to obtain the union 푄(푑) of all 푞(푑) (Line 4). We record
푄(푑) in T [푑] (Line 6). Subsequently, in each iteration, we add the
dataset 푑∗with the greatest marginal gain 푔∗into 푆until the bud-
get is exhausted (Lines 7-13). In Line 14, we return a single dataset
푑푡with the maximum distinctiveness |T [푑푡] ∪T [푑푢]|. Finally, we
select the one with a larger distinctiveness from a set 푆of datasets
and a single best dataset푑푡(Lines 15-16). We present the associated
approximation guarantee in Theorem 3.1.
Theorem 3.1. Exact-Greedy (Alg. 1) achieves an approximation
ratio of 1−1/푒
2
when solving the DM problem.
Proof. Let 푆∗be the optimal set of datasets,푆푚the set of datasets
with size푚added to 푆in the ﬁrst 푙iterations, 푑푚+1 the ﬁrst dataset
considered by 푆∗but not included in 푆since it exceeds the budget
and 푆푚+1 = {푑푚+1} ∪푆푚. Using Lemma 2 of [31], observe that
풟(푆푚+1,푑푢,푄) ≥(1 −1
푒)풟(푆∗,푑푢,푄) in Alg. 1. Let Δ풟be the in-
crease in distinctiveness by including푑푚+1 in푆푚, 풟(푆푚+1,푑푢,푄) =
풟(푆푚,푑푢,푄) + Δ풟≥(1 −1
푒)풟(푆∗,푑푢,푄). Since Δ풟cannot be
greater than 풟({푑푡},푑푢,푄) for the best dataset 푑푡, 풟(푆푚,푑푢,푄) +
풟({푑푡},푑푢,푄) ≥풟(푆푚,푑푢,푄)+Δ풟≥(1−1
푒)풟(푆∗, 푑푢,푄). There-
fore, either 풟(푆푚,푑푢,푄) or 풟({푑푡},푑푢,푄) is greater than (1−1/푒)
2
풟(
푆∗,푑푢,푄), Exact-Greedy achieves an approximation ratio of (1−1/푒)
2
.
□
Time complexity analysis. Assume that 푑is the dataset in 퐷
with the greatest number of tuples. Alg. 1 requires O(|푑||푄|) time
to execute each query 푞∈푄and O(|푑|2|푄|) time to combine the
tuple sets 푞(푑) for each query 푞∈푄(Line 4). Therefore, construct-
ing T [푑] requires O(|푑|2|푄||퐷|) time (Lines 2-5). Computing the
marginal gain for the dataset 푑requires O(|푑|2|퐷|) time. So, ﬁnd-
ing the set 푆of datasets with the maximum distinctiveness requires

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
O(|푑|2|퐷|3) time (lines 7-13), resulting in a total time complexity
for Alg. 1 of O(|푑|2|푄||퐷| + |푑|2|퐷|3).
4
Greedy Algorithm using ML-based
Distinctiveness Estimation
Although Exact-Greedy can achieve a 1−1/푒
2
approximation ratio,
it is computationally expensive due to the exact computation of the
marginal gain (Line 10 in Alg. 1). Based on our experiments, the ex-
act distinctiveness computation requires one hour for 20 datasets
(with 100k tuples in each dataset) and 10 queries. This is not prac-
tical since a data preparation system in production must deliver
results to users quickly in order to avoid user abandonment.
Therefore, a natural question arises: Is it possible to eﬃciently
estimate the distinctiveness and maintain high eﬀectiveness? As
aforementioned in §1, distinctiveness estimation is analogous to
the MCE problem, with the goal of estimating the cardinality of a
query set on a set of datasets. It cannot be addressed by a solution
of the SCE problem [42]. Thus, we devise a new ML-based method
for solving the MCE problem.
Overviewfor our ML-based distinctivenessestimationmethod.
As shown in Fig. 4, our method consists of ﬁve components.
In an oﬄine process, we use Component 1 to generate a data
summary for each dataset under consideration. In an online pro-
cess, we use the data summary from each dataset and a query set as
the input. Using Components 2-4, we estimate the distinctiveness
for a dataset w.r.t. a query set while identifying overlaps among the
tuple sets returned by each query in a query set on a dataset. Specif-
ically, we ﬁrst utilize Component 2 to transform the data summary
into a query-aware dataset embedding, which captures the con-
nections between the query set and the data summary. Then, we
use Component 3 to generate a query-set embedding by merging
the information from the queries in the query set. Finally, Com-
ponent 4 estimates the distinctiveness for a dataset w.r.t. a query
set using the embeddings generated in the previous components.
To estimate the distinctiveness for a set of datasets w.r.t. a query
set using the above components, we ﬁrst compute a data summary
for a set of datasets by identifying overlaps among them. The data
summary for a set of datasets is computed by iteratively merging
the current data summary with the data summary of a new dataset,
starting with the ﬁrst dataset in the set. To this end, our ML-based
method uses Component 5, which includes a learning function, to
eﬃciently generate a data summary for a set of datasets by merg-
ing the data summaries for individual datasets.
4.1
Component 1: Data Summary Generation
We adopt the pre-training summarization approach IRIS [42] to
generate data summaries (see the left side of Fig. 4). When com-
pared to other possible approaches such as histograms [29] or sketches [13],
IRIS does not require per-dataset training. Hence, it reduces the to-
tal cost required to generate the summaries while producing high-
quality results for the SCE problem.
Speciﬁcally, IRIS has a two-step process. The ﬁrst step is iden-
tifying column sets where a set C푑of columns, which are highly
correlated with dataset 푑, is located. The second step, generating
column set embeddings, uses pre-trained models to create an em-
bedding 푒퐶for each column set 퐶∈C푑. These column set embed-
dings collectively form a data summary 퐸푑
퐶= {..., 푒퐶푖, ...} where
퐶푖∈C푑. Further details on these two steps are provided below.
4.1.1
Identifyingcolumn sets. For each dataset푑∈퐷, a small num-
ber of tuples is randomly selected from푑and the correlation scores
for each column pair are computed using CORDS [28]. A graph is
then constructed with columns as nodes and edges weighted using
their correlation scores. Using this graph, a set of nodes (columns)
is selected iteratively to form a column set. During each iteration,
a clique, containing no more than 휅(2 in our experiments) nodes,
with the highest total edge weight is selected as a column set. Then,
all edges from the chosen clique are removed from the graph.
Let Π퐶푑denote a projection of dataset 푑on columns in 퐶. The
process of selecting column sets continues until the combined stor-
age size of Π퐶푑of all of the column sets reaches a pre-deﬁned limit
(4 kb in our experiments), resulting in a set of column sets C푑, e.g.,
in Fig. 3, C푑1 of 푑5 is {퐶1 = {Type, City},퐶2 = {City, Price}}.
4.1.2
Generating column set embeddings. For each column set 퐶∈
C푑and corresponding rows Π퐶푑from dataset 푑∈퐷, a row embed-
ding is learned for each row 푟∈Π퐶푑. Then, the average for all of
the row embeddings for 퐶is computed, which is the column set
embedding 푒퐶of 퐶, i.e,
푒퐶≜
1
|Π퐶푑|
Í|Π퐶푑|
푖=1
휓(푟푖).
(2)
Here, 휓(·) is a learned function (model) for a row embedding,
computedusing a quantization function q(·) [42], a column embed-
ding function 휙푐(·), a row embedding function 휙푟(·), and a ReLU
activation function 훿(·) as
휓(푟푖) ≜훿(휙푟(Reorder([· · · ,휙푐(q(푐푗
푖)), · · · ]))),
(3)
where 휙푐: R휉→R64, 휙푟: Rℓ→R휂, and 푐푗
푖are values of the
푗-th column in 퐶for row 푟푖. The Reorder function reorders the val-
ues based on the total number of bits assigned, such that the most
distinct columns are aligned with the same input position for 휙푟.
A quantization function q(·) replaces the value for each column,
with an identiﬁer containing at most 휉bits, while 휙푐(q(푐푗
푖)) en-
codes an identiﬁer q(푐푗
푖) in an embedding layer. Let 푣푖be a vector
concatenating the reordered outputs for 휙푐. The function 휙푟(푣푖)
creates a row embedding of 푟푖∈Π퐶푑using a fully-connected
neural-network (NN) layer. The function 휙푟(푣푖) receives ℓbits as
input and outputs 휂bits (the size of the row embedding). Finally,
훿(휙푟(푣푖)) is the ReLU activation function is applied to 휙푟(푣푖). Us-
ing Eq. 2, a column set embedding 푒퐶of 퐶is computed with size
휂.
Example 4.1. Consider the column set 퐶= {City, Price} from
dataset 푑5 in Fig. 3. We allocate ℓ= 3 bits for the two columns, con-
taining 2 and 4 distinct values, respectively. Using a quantization
approach [42], we assign [1, 2] bits to the columns. Using the em-
bedding method, we produce 휙푐(q(푐1
1)) = [0], 휙푐(q(푐2
1)) = [0, 1],
and Reorder[휙푐(q(푐1
1)),휙푐(q(푐2
1))] = [휙푐(q(푐2
1)),휙푐(q(푐1
1))] = [0, 1, 0]
for 푟1 ∈Π퐶푑. Thus, we have 휓(푟1) = 훿(휙푟([0, 1, 0])).

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
∏ !"
#$
%
&'
((&')
+ !
…
,'
…
((&-)
((&|∏.!/|)
(( )
((…
…
&-
&|∏.!/|
&…
......
......
∏ 0"
∏ |12|"
+ 0
+ |12|
......
......
"
∏
"
1/
3 
/
…
∏ "
…
+ …
…
Reorder( #4 5 6'
-
, … , #4 5 6'
8
, … , #4 5 6'
| |
)
#4
#4 5 6'
-
, … , #4 5 6'
8
, … , #4 5 6'
| |
#4
#4
&'
Component 1
Data Summary Generation
Component 3
Query-set Embedding Generation
• 
[•!", •!#]
$!
%
[•!&, •!",!#]
•!",!#
[•
•!&
......[•!",…,! ' , •!|'| ]
$!
%
$!
%
•!(
•!|'|
•!"
•!…
!(…
•
) [*+]
…
…
!
) [*-]
!
…
•!
.
…
•!
) [*| |] •
.
•
…
•
.
)
*+
)
*-
) 
*| |
/0
1
•1
!(
•1
!|'|
•1
!"
…
…
0
1
•1
(
) [*-]
0
) [*-]
…
…
•1
 
[•1
!", •1
!#]
$1
%
[•1
!&, •1
!",!#]
•1
!",!#
[•!
,
•1
!&
......[•1
!",…,! ' 2", •1
!|'|]
$1
%
$1
%
Component 2
Query-aware Dataset Embedding Generation
• 
!
"#
$
•!
"%
$
.
"&
$
(• 
! , •! )
Component 4
Distinctiveness Estimation
Offline
Online
• 
!"
• 
!#
Component 5
Merging Data Summaries
• 
!
"#$
%,&
'#
()∪(+
"#$
%
(- = | ∪.∈0 10 2 |)
"#$
&
• 
!
"#3
%,&
"#3
%
"#3
&
…
…
Figure 4: The ML-based distinctiveness estimation method, where red arrows represent the process of estimating the distinc-
tiveness of a dataset and green arrows represent the process of merging data summaries.
4.2
Component 2: Query-aware Dataset
Embedding Generation
To eﬀectively represent any relationships between the queries in 푄
and a data summary 퐸푑
퐶of 푑, we create a query-aware dataset em-
bedding 푒푄
푑using a learned model 휙푑(·). This process is shown in
the “query-aware dataset embedding generation” portion of Fig. 4.
To improve overall eﬃciency, we construct a lookup table C푄
to store the column sets linked to each query 푞∈푄, i.e., C푄[푞] =
{퐶|퐶∈∩푑∈퐷C푑& 퐶∩ColsOf(푞)}. Here, ColsOf(푞) refers to the
query columns. Each column set in C푞is also a column set for a
dataset in 퐷. For a given data summary 퐸푑
퐶for dataset푑and lookup
table C푄[푞], we can construct the dataset embedding 푒푞
푑for each
query 푞∈푄. To this end, we concatenate all column set embed-
dings from 퐸푑
퐶which are associated with C푄[푞]. This produces
푒푞
푑= [..., 푒퐶푖, ...], where 푒퐶푖∈퐸푑
퐶and 퐶푖∈C푄[푞].
Next, we construct휙푑: R2휂푥→R휂푥, which is a fully-connected
NN layer with ReLU activation function 훿(·). This function is de-
signed to iteratively learn a query-aware dataset embedding for a
dataset 푑, i.e.,
푒푞1,푞2
푑
= 훿(휙푑([푒푞1
푑,푒푞2
푑])) ... 푒푞1,...,푞푗
푑
= 훿(휙푑([푒푞푗
푑,푒푞1,...,푞푗−1
푑
]))
... 푒푄
푑= 훿(휙푑([푒푞|푄|
푑
,푒푞1,...,푞|푄|−1
푑
])).
(4)
For the ﬁrst two queries, 푞1,푞2 ∈푄, we concatenate the respec-
tive dataset embeddings, 푒푞1
푑and 푒푞2
푑, as the input for 휙푑. The re-
sulting embedding, 푒푞1,푞2
푑
, combines the information of both 푒푞1
푑
and 푒푞2
푑. Similarly, we can generate the embedding 푒푞1,...,푞푗
푑
by com-
bining 푒푞푗
푑with 푒푞1,...,푞푗−1
푑
. Following this iterative process, a ﬁnal
query-aware dataset embedding 푒푄
푑= 푒푞1,...,푞|푄|
푑
is created. Note
that, since the size of each column set embedding is 휂, the input
size for 휙푑(·) is a constant, 2휂푥, and the output size is 휂푥. In cases
where the input size is less than 2휂푥, zero-padding can be applied
to achieve the required size.
4.3
Component 3: Query-set Embedding
Generation
In this section, we describe how to generate a query-set embedding
푒푄which merges information for all queries in a query set 푄. This
process is summarized in the “query-set embedding generation”
portion of Fig. 4.
For each query 푞∈푄, 퐶∈C푄[푞] represents the column set
included in the WHERE clause from 푞. As discussed in §2, each col-
umn 푐∈퐶is associated with a query range deﬁned by the mini-
mum value 푙푐and maximum value 푢푐. We can represent a query
as 푞= [푞퐶
푙,푞퐶
ℎ], where 푞퐶
푙= [푙푐1, ..., 푙푐|퐶|] and 푞퐶
ℎ= [푢푐1, ..., 푢푐|퐶|].
To generate the embeddings for a query 푞relative to the set 퐶, we
use the same row embedding function 휓(·) (see Eq. 3) for both the
minimal and maximal values of each column, namely 푞퐶
푙and 푞퐶
ℎ.
This produces two distinct embeddings for푞in퐶,휓(푞퐶
푙) and휓(푞퐶
ℎ).
Next, a complete query embedding 푒푞is created for 푞by concate-
nating all of the embeddings for 푞, for each column set 퐶∈C푄[푞],
i.e., 푒푞= [...,휓(푞퐶푖
푙),휓(푞퐶푖
ℎ), ...] where 퐶푖∈C푄[푞].
Example 4.2. Consider the column set 퐶= {City, Price} in Exam-
ple 4.1 and the query 푞2 = SELECT Count(*) FROM d WHERE 500,000 ≤
Price ≤800,000 AND City = ’Melbourne’. We have휙푐(q(Melbourne)) =
[0] and 휙푐(q(Sydney)) = [1], which is the range of all distinct val-
ues in City. We also have휙푐(q(500,000)) = [0, 0] and휙푐(q(800, 000))
= [1, 0]. Therefore, Reorder[휙푐(q(Melbourne)), 휙푐(q(500,000))] =
[0, 0, 0] and Reorder[휙푐(q(Sydney)), 휙푐(q(800,000))] = [1, 0, 1].
This results in the query embedding [휓(푞퐶
푙),휓(푞퐶
ℎ)] = [훿(휙푟([0, 0, 0]
)),훿(휙푟(1, 0, 1))] representing 푞2.
After generating all of the individual query embeddings, we ap-
ply an iterative procedure as described in §4.2 to produce the ﬁnal
query-set embedding as follows:
푒푞1,푞2 = 훿(휙푝([푒푞1,푒푞2])) ... 푒푞1,...,푞푗= 훿(휙푝([푒푞푗,푒푞1,...,푞푗−1]))
... 푒푄= 훿(휙푝([푒푞|푄|,푒푞1,...,푞|푄|−1])).
(5)
Here, 휙푞: R4휂푥→R2휂푥is a fully-connected layer and 훿(·) is the
ReLU activation function. Since the size of the column set embed-
ding for a query is 2휂, we ﬁx the input size of 휙푞(·) to 4휂푥and the
output size of휙푞(·) is 2휂푥. In cases where the input size is less than
4휂푥, zero-padding is applied to the embedding to ensure that the
input size is equal to 4휂푥.
4.4
Component 4: Distinctiveness Estimation
Using our query-aware dataset embedding 푒푄
푑and query-set em-
bedding 푒푄as inputs, we develop three learned models, namely,
휙1(·), 휙2(·), and 휙3(·), which allow us to estimate the distinctive-
ness of each dataset 푑as
풟(푒푄
푑,푒푄) = 훿(휙3(훿(휙1(푒푄
푑)) ⊙훿(휙2(푒푄))).
(6)

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Algorithm 2 Distinctiveness(푄, 퐸푑
퐶,푛, C푄)
Input: the data summary 퐸푑
퐶of 푑, a query set 푄, the number of tuples 푛in 푑, a
lookup table C푄to maintain column sets of each query 푞∈푄;
Output: estimated distinctiveness 풟;
1: 풟←0, 퐸푑←∅, 퐸푄←∅
2: for 푞∈푄do
3:
푒푞
푑←∅, 푒푞←∅;
4:
for 푒퐶∈퐸푑
퐶and 퐶∈C푄[푞] do
5:
푒푞
푑←[푒푞
푑, 푒퐶], 푒푞←[푒푞,휓(푞퐶
푙),휓(푞퐶
ℎ)];
6:
퐸푑←퐸푑∪푒푞
푑, 퐸푄←퐸푄∪푒푞;
7: Generate 푒푄
푑by each 푒푞
푑∈퐸푑using Eq. 4;
8: Generate 푒푄by 푒푞∈퐸푄using Eq. 5;
9: 풟←풟(푒푄
푑, 푒푄) × 푛using Eq. 6;
10: return 풟;
Algorithm 3 MergeEmbeddings(퐸푑
퐶, 퐸푆
퐶, C푄)
Input: data summary 퐸푑
퐶of the dataset 푑, data summary 퐸푆
퐶of the set 푆of datasets,
and a lookup table C푄to maintain column sets associated with each query푞∈푄;
Output: data summaries 퐸푆∪푑
퐶
;
1: 퐸푆∪푑
퐶
←∅;
2: for 푒퐶∈퐸푆
퐶do
3:
if 퐶∈∪푞∈푄C푄[푞] then
4:
Find column set embedding 푒′
퐶of 퐶from 퐸푑
퐶;
5:
푒←훿(휙푒([푒퐶,푒′
퐶])), 푒퐶←푒;
6:
퐸푆∪푑
퐶
←퐸푆∪푑
퐶
∪푒퐶
7: return 퐸푆∪푑
퐶
;
Here, 휙1 : R휂푥→R휂and 휙2 : R2휂푥→R휂are two fully-connected
layers and 휙3 : R휂→R1 is a multilayer perceptron with one
hidden layer. 훿(·) is the ReLU activation function.
The distinctiveness estimation process. As shown in Fig. 4, our
distinctiveness estimation process relies on Components 1 - 4, each
of which includes one or more models. Speciﬁcally, 휙푐and 휙푟are
used to generate the data summary, 휙푑is used to generate the
query-aware dataset embedding, 휙푞is used to generate the query-
set embedding, and 휙1, 휙2, and 휙3 are used to estimate distinc-
tiveness. These models are end-to-end pre-trained [23]. The pseu-
docode for distinctiveness estimation is presented in Alg. 2. First,
we compute a dataset embedding 푒푞
푑for each query 푞∈푄together
with a query embedding 푒푞for each query 푞∈푄through C푄[푞]
and 퐸푑
퐶(Lines 2-6). Next, we generate the query-aware dataset em-
bedding 푒푄
푑(in Line 7) followed by the query-set embedding 푒푄
(Line 8). Finally, we estimate the distinctiveness of dataset 푑(Line
9). Note that while we adopt an iterative approach to generate both
query-aware dataset and query-set embeddings, the order in which
the queries are processed minimally aﬀects the ﬁnal results.
The loss function. Consider a set D of training instances where
each instance includes an estimate for distinctiveness e풟(푑,푄) for
푑given 푄as well as the exact value of distinctiveness 풟(푑,푄). The
mean squared error (MSE) loss is deﬁned as
1
|D|
Í
( e풟(푑,푄),풟(푑,푄))∈D
( e풟(푑,푄) −풟(푑,푄))2.
4.5
Component 5: Merging Data Summaries
This component is designed to compute a data summary 퐸푆∪푑
퐶
for
푆∪푑by merging the data summary 퐸푆
퐶for the current set of
datasets, 푆, and the data summary 퐸푑
퐶for a dataset 푑. The objec-
tive is to estimate the distinctiveness of 푆∪푑w.r.t 푄using Alg. 2.
Algorithm 4 ML-Greedy
Input: a set 퐷of datasets, a base dataset 푑푢, a query set 푄, a budget 퐵;
Output: a set 푆⊆퐷of datasets with its distinctiveness;
1: Generate a set C푑of column sets and data summary 퐸푑
퐶for each 푑∈퐷∪푑푢; /*
oﬄine process */
2: C푄←∅;
3: for 푞∈푄do C푄[푞] ←{퐶|퐶∈∩푑∈퐷∪푑푢C푑and 퐶∩ColsOf (푞)};
4: 푆←∅, D ←∅, 퐸푆
퐶←∅, 푛∗←0, 풟∗←0;
5: 풟∗←Distinctiveness(푄, 퐸푑푢
퐶, |푑푢|, C푄), 퐸푆
퐶←퐸푑푢
퐶,푛∗←|푑푢|;
6: while 퐷≠∅do
7:
푔∗←0, 푑∗←∅, 퐸∗←∅;
8:
for 푑∈퐷do
9:
퐸푆∪푑
퐶
←MergeEmbeddings(퐸푑, 퐸푆
퐶, C푄)
10:
풟←Distinctiveness(푄, 퐸푆∪푑
퐶
,푛∗+ |푑|, C푄), 푔←풟−풟∗
푝(푑) ;
11:
if 푆== ∅then D[푑] ←풟;
12:
if 푔> 푔∗then 푑∗←푑, 푔∗←푔, 퐸∗←퐸푆∪푑
퐶
;
13:
if 푝(푑∗) + 푝(푆) ≤퐵then
14:
퐸푆
퐶←퐸∗, 푆←푆∪푑∗, 풟∗←풟∗+ 푔∗× 푝(푑∗), 푛∗←푛∗+ |푑∗|;
15:
퐷←퐷\ 푑∗;
16: 푑푡←argmax푑∈퐷∧푝(푑) ≤퐵D[푑];
17: If 풟∗< D[푑푡] return {푑푡} and D[푑푡];
18: return 푆and 풟∗;
IRIS [42] incrementally updates the data summary 퐸푑
퐶for the
dataset 푑when new rows are added to 푑. Speciﬁcally, for each col-
umn set 퐶of푑, with new rows in 퐶denoted as 푅new, a new column
set embedding is computed as 푒′
퐶= (푛푒퐶+ Í
푟∈푅푛푒푤휓(푟))/(푛+
|푅푛푒푤|). Here, 푒퐶is the column set embedding for 퐶in 퐸푑
퐶and
휓(·) is the row embedding function from Eq. 3. The column set
embedding 푒퐶in 퐸푑
퐶is then updated to 푒′
퐶. However, this method
is computationally expensive when updating the data summary 퐸푆
퐶
for the current set 푆of datasets with new rows from a dataset 푑.
So to better facilitate the update process, it is necessary to check if
any existing row in 푑is already included in 푆. In such a scenario,
a new model must be trained to learn the column set embeddings
for the data summary. This process is summarized in the “merg-
ing data summaries” portion of Fig. 4. Given two datasets 푑푖and
푑푗, 푑푖,푗is the dataset resulting from the merge process. Let 푒푖
퐶be
a column set embedding for 푑푖, 푒푗
퐶for 푑푗, and 푒푖,푗
퐶for 푑푖,푗, where
퐶∈∪푞∈푄C푄[푞]. The embedding is learned using푒푖
퐶and푒푗
퐶, which
approximates 푒푖,푗
퐶using:
훿(휙푒([푒푖
퐶,푒푗
퐶])) ≈푒푖,푗
퐶
(7)
where 휙푒: R2휂→R휂is a fully-connected layer.
Merging data summaries. The procedure for merging data sum-
maries is shown in Alg. 3. Given a data summary 퐸푑
퐶for the dataset
푑, a data summary 퐸푆
퐶for the set of datasets 푆, and a lookup table
C푄, which maps column sets C푞associated with each query 푞∈푄,
using Eq. 7 to update column set embeddings in 퐸푆
퐶whose column
set is in ∪푞∈푄C푞.
The loss function. Consider a set S of training instances where
each instance is the pair of column embedding e푒푖,푗
퐶for the column
set 퐶on the dataset created by merging 푑푖and 푑푗and the corre-
sponding ground-truth column pair embedding 푒푖,푗
퐶. The MSE loss
is
1
|S|
Í
(e푒푖,푗
퐶,푒푖,푗
퐶)∈S(e푒푖,푗
퐶−푒푖,푗
퐶)2.

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
4.6
The Complete Algorithm
Combining all components in §4.1-4.5, we present ML-Greedy, a
greedy algorithm using ML-based distinctiveness estimation, as
outlined in Alg. 4. The process begins oﬄine, generating the set of
column sets C푑and the data summary 퐸푑
퐶for each dataset 푑∈퐷
and the base dataset 푑푢(Line 1). Initially, a lookup table C푄is
created to store column sets associated with each query 푞∈푄
(Line 3). From the outset, the data summary 퐸푆
퐶of the current set
of datasets 푆is set to the data summary 퐸푑푢
퐶
of 푑푢and has the
distinctiveness of 푑푢(Line 5). In the ﬁrst iteration, the distinctive-
ness 풟({푑},푑푢,푄) for each individual dataset 푑is computed using
Alg. 2 and recorded in D (Line 11). In subsequent iterations, the
marginal gain 푔= 풟(푆∪푑,푑푢,푄) −풟(푆,푑푢,푄) when adding 푑to
the set 푆is computed using Alg. 2, after the data summaries for 푆
and 푑are merged in Alg. 3 (Lines 9-10). The set 푆is then iteratively
updated by adding the dataset 푑∗that yields the highest marginal
gain 푔∗until the budget is exceeded (Lines 13-14). Finally, we lo-
cate the single dataset 푑푡with the maximum distinctiveness (Line
16). It selects a better solution from the datasets in 푆and a single
dataset 푑푡.
Time complexity analysis. The proposed algorithm requires O(|
C푄[푞]||푄|) time to create the dataset and query embeddings for
each query푞∈푄(Lines 2-6 in Alg. 2) and O(8휂2푥2|푄|) time to gen-
erate the corresponding query-aware dataset and query set embed-
dings (Lines 7-8 of Alg. 2). Thus, a total of O(|C푄[푞]||푄|+8휂2푥2|푄|)
time is required to estimate the distinctiveness for each dataset
(Lines 1-9 in Alg. 2). Then, O(휂2| ∪푞∈푄C푄[푞]|) time is required to
merge the data summary 퐸푑
퐶of 푑with the data summary 퐸푆푐of 푆
(Lines 1-6 in Alg. 3). Therefore, O(|C푄[푞]||푄|+8휂2푥2|푄|+휂2|∪푞∈푄
C푄[푞]|) time is needed to compute the marginal gain for a dataset
푑w.r.t. 푆(Line 10 in Alg. 4). The total time complexity for the pro-
posed algorithm that utilizes ML-based distinctiveness estimation
is therefore O((8휂2푥2|푄| + 휂2| ∪푞∈푄C푄[푞]|)|퐷|2).
Note that in model pre-training, we set 휂= 128 (column set
embedding size) and 푥= 4 (i.e., a query corresponds to at most
4 column sets). Moreover, |푑| is generally in the millions. Hence,
the empirical eﬃciency improvement provided by ML-Greedy is
potentially even more substantial. This belief is veriﬁed in our ex-
periments where we observe that ML-Greedy can be up to four
orders of magnitude faster than Exact-Greedy.
5
Preparing the Datasets and Queries
In experiments, we use ﬁve real-world data pools of varying sizes
and column types (see Table 2). To reﬂect a wide range of use
cases, we present several strategies to prepare candidate datasets
and query sets using these data pools. The key to these strategies
is to control the overlapping tuples in the candidate datasets and
overlapping tuples in the tuple sets returned by diﬀerent queries,
as mentioned in §1. We provide more details on datasets and query
set preparation in the following.
5.1
Datasets Preparation
To control overlapping tuples in the candidate datasets, following
existing related studies [49, 63], we generate each set of candidate
datasets, 퐷, by sampling tuples from a data pool,푑pool (see Table 2
Table 2: Data pools that are not used in model pre-training.
Name
# of columns (R/C)∗
# of records
TPCH-LineItem [4]
11/4
6M
DMV [60]
7/13
11M
IMDB-CastInfo [15]
6/1
36M
Airline-OnTime [14]
66/17
440K
RealEstate [34]
21/14
1.4M
for ﬁve data pools). We introduce two new parameters, 푠min and
푠max, which set the lower and upper bounds (푠min|퐷|, and 푠max|퐷|)
which is the expected number of tuples in 퐷. We randomly choose
a sampling rate 푠within [푠min,푠max] and then sample 푠|푑pool| tu-
ples from 푑pool to produce each candidate dataset 푑. We repeat this
process to generate all datasets in 퐷.
In our experiments, we set the size of 퐷to |퐷| = 20 by de-
fault. Additionally, we set 푠min = 1/|퐷| = 0.05, implying that
each tuple is expected to appear in at least one dataset. We also
set 푠max = 2/|퐷| = 0.1, indicating that each tuple is expected to
appear in at most two datasets. This ensures that the datasets in 퐷
have a realistic overlap of tuples but also maintain suﬃcient mu-
tual distinctness.
Pricing and budget. For simplicity, we set 푝(푑) = 푤× |푑| for
each dataset 푑where 푤is selected randomly from (0, 1]. This ap-
proach follows existing pricing functions [3, 37, 46], where prices
are based on the number of tuples in datasets. To better control
budget variations, we introduce the B-ratio, which is the ratio of
the budget 퐵and the total price of the datasets in 퐷, Í
푑∈퐷푝(푑),
and set it to the default value of 0.5. Note that data pricing is or-
thogonal to this work and alternative data pricing functions are
discussed in §7.
5.2
Query Set Preparation
To control overlapping tuples in the tuple sets returned by diﬀerent
queries, we introduce the parameter 표푙which controls the mini-
mum overlap ratio in the tuples returned by any pair of queries
for a dataset. This idea is inspired by the approach used to gener-
ate queries in prior work [42]. To simplify the ﬁnal conﬁguration,
each query is limited to using most one categorical column. Query
set generation is derived from the number of available categorical
columns, 푘푐, which is randomly set to either 0 or 1:
• For 푘푐= 1, we randomly select a categorical column 푐from
datasets in 퐷. We set a value 푣푐for 푐by sampling 푐from datasets
in 퐷, so that, in any dataset 푑∈퐷, the total number of tuples
that satisfy 푐= 푣푐exceeds 표푙× |푑|. We merge tuples that satisfy
푐= 푣푐across datasets in 퐷, to produce a new dataset 푑푠푝. Next,
we randomly select 푘푟(푘푟∈[1, 3]) real-valued columns from
푑푠푝, setting the range to 푐∈[min(푐), max(푐)], where min(푐)
and max(푐) are the minimum and maximum values for 푐in 푑푠푝.
• For 푘푐= 0, we randomly sample 표푙× |푑| tuples from each dataset
푑∈퐷and merge them into the new dataset 푑푠푝. We then ran-
domly select 푘푟(푘푟∈[2, 4]) real-valued columns from 푑푠푝, set-
ting the range to 푐∈[min(푐), max(푐)].
After generating the query 푞using the above method, we gen-
erate another query 푞′ by selecting real-valued columns from the
same sampled dataset 푑푠푝produced from 푞. The query pair (푞,푞′)
must satisfy having a minimum overlap ratio 표푙for the tuples re-
turned from each dataset 푑∈퐷. This query pair is then added to
∗R indicates real-valued columns and C indicates categorical columns.

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
the query pool. The query generation process terminates once a
query pool of 100 query pairs is created. Query pairs are then ran-
domly selected from the query pool to form a query set 푄and used
with 퐷.
By default, the number of queries |푄| = 20. Depending on the
size of 퐷, 표푙is set to 5% by default to ensure the size of the sam-
pled dataset 푑푠푝does not exceed the total number of tuples in any
dataset 푑∈퐷, i.e., |푑푠푝| ≤|퐷| × 표푙× |푑| ≤|푑|, 표푙≤0.05. This
prevents a corner case where a query returns all tuples from the
dataset.
6
Experiments
We conduct extensive experiments to verify the eﬀectiveness, ef-
ﬁciency, and scalability of our greedy algorithm using ML-based
distinctiveness estimation.
6.1
Experimental setup
Methods for comparison. Our ML-based distinctiveness estima-
tion method includes two important components (1) distinctive-
ness estimation and (2) updating data summaries. To demonstrate
the eﬀectiveness of our method, we explore several alternatives for
both components. For component (1), we use two methods: DE –
our distinctiveness estimation method as described in Alg. 2; IRIS
– A state-of-the-art solution for the single-query-dataset cardinal-
ity estimation (SCE) problem [42], where the results can be aggre-
gated for all queries to approximate the distinctiveness of a query
set. For component (2), we also consider two methods: MS – our
approach to merge data summaries, as described in Alg. 3; IU – A
method that identiﬁes new tuples from a new dataset not present
in the current set of datasets, then update column set embeddings
using the new tuples, as outlined in §4.5. In total, this results in
four diﬀerent approaches being compared:
• ML-Greedy – Our greedy algorithm using ML-based distinctive-
ness estimation, as described in Alg. 4.
• (DE+IU)-ML-Greedy – A greedy algorithm that uses DE for dis-
tinctiveness estimation and IU for updating data summaries.
• (IRIS+IU)-ML-Greedy – A greedy algorithm that uses IRIS for
distinctiveness estimation and IU for updating data summaries.
• Exact-Greedy – The greedy algorithm using exact distinctive-
ness computation as described in Alg. 1.
Parametersettings.The key parameters introducedin §5 are sum-
marized in Table 3. Three parameters govern the generation of data
summaries: 휉(the maximum number of bits per column), ℓ(the
number of bits per row), 휂(the column set embedding size). The
same parameters are used by IRIS [42]. We set 휉= 128, ℓ= 2048,
and 휂= 128 for DE and IRIS, which are also the default values in
prior work [42]. Note that, DE has an additional parameter,푥, which
is the maximum number of column sets that a query corresponds
to during the generation of a query-aware dataset embedding and
a query-set embedding. We set this parameter to 푥= 4.
Training set generation. We pretrain our models using the 19
datasets listed in Table 4. These datasets are publicly available [42]
and are used to pretrain the SCE models.
To train the models for distinctiveness estimation, we follow the
approach used in prior work [42]. We select 5 column sets with the
highest correlation score, as calculated using CORDS [28], from the
Table 3: Parameter settings (default value in bold).
Parameter
Value
sample rate 푠푚푎푥
0.1, 0.2, 0.3, 0.4, 0.5
|퐷|
10, 20, 40, 80, 160
overlap ratio 표푙
1%, 3%, 5%, 7%, 9%
|푄|
10, 20, 40, 80, 160
퐵-ratio
0.1, 0.3, 0.5, 0.7, 0.9
Table 4: Datasets used for model pretraining.
Name
# cols
(R/C)∗
Name
# cols
(R/C)∗
Name
# cols
(R/C)∗
Higgs
28/0
KDD99
34/5
SUSY
19/0
PRSA
16/2
Gasmeth
18/0
Retail
5/3
Gastemp
20/0
Covtype
10/9
hepmass
29/0
Sgemm
10/4
Weather
7/0
Adult
6/8
PAMPA2
54/0
YearPred
90/0
HTsensor
10/0
Power
7/0
WECs
49/0
Census90
0/50
GasCO
18/0
Table 5: q-error of DE and IRIS for varying percentiles.
Dataset
Method
q-error
0th
25th
50th
75th
100th
TPCH
DE
1.602
1.661
1.669
1.682
1.801
IRIS
11.629
11.713
11.938
11.981
12.423
DMV
DE
1.139
1.171
1.189
1.212
1.237
IRIS
12.105
12.145
12.173
12.456
12.658
IMDB
DE
1.69
1.694
1.701
1.705
1.762
IRIS
12.17
12.229
12.245
12.276
12.322
Airline
DE
1.725
1.840
1.85
1.858
1.876
IRIS
12.07
12.087
12.103
12.134
12.18
RealEstate
DE
1.579
1.643
1.673
1.706
1.756
IRIS
12.186
12.22
12.251
12.313
12.445
training datasets and 300 randomly generated queries. For each col-
umn set, we record the top-10 queries by cardinality. We combine
every two column sets from the same training dataset to generate
the query pairs, resulting in 100 query pairs, for any two column
pairs, and create a total of 19,000 query pairs. We allocate 80% of
the query pairs for training and 20% for validation, and use a batch
size of 256. To train the model that is used to merge data summaries,
we randomly select 10,000 column pairs from the 19 datasets. For
each training dataset, we sample two datasets, 푑1 and 푑2, with a
sample rate of 0.5. For each column pair in the training dataset, we
use Eq. 2 to compute the column set embeddings 푒1 and 푒2 on 푑1
and 푑2, respectively. In addition, we generate a column set embed-
ding 푒for the dataset resulting from the merge of 푑1 and 푑2 using
Eq. 2.
Evaluation Metrics. We use the following metrics:
• Distinctiveness ratio (풟-ratio) is the ratio of the estimated distinc-
tiveness 풟to the exact distinctiveness 풟푔푡calculatedby Exact-Greedy,
i.e, 풟-ratio = 풟/풟푔푡.
• Runtime. The average time over ﬁve independent runs.
Implementation We perform all experiments on a server running
Red Hat Enterprise Linux with an Intel® Xeon® CPU@2.60GHz,
512GB of memory, and two Nvidia Tesla P100 GPUs, each with
16GB of memory. We implement all algorithms in Python. All source
code is publicly available [12].
6.2
Accuracy of Distinctiveness Estimation
We ﬁrst verify the eﬀectiveness of our distinctiveness estimation
method DE. As discussed in §6.1, we have considered two diﬀerent
implementations – our distinctiveness estimation method DE and

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
ML-Greedy
(DE+IU)-ML-Greedy
(IRIS + IU)-ML-Greedy
Exact-Greedy
 
 
 
 
 
B-rat
 

 
	
 

 -rat


(a) TPCH











 



B-rat


 



 



 

 -rat


(b) DMV
 
 
 
 
 
B-rat 
 

 
!
 

 -rat
"
#
(c) IMDB
$%&
$
%'
$%(
$%)
$%*
B-rat
+
,
$%
*
&
$%
*
-
$%
*
)
&
 -rat
.
/
(d) Airline
012
013
0
14
015
016
B-rat78
0
16
2
0
16
9
0
165
2
 -rat
:
;
(e) RealEstate
Figure 5: The impact of budget 퐵on the distinctiveness ratio of each algorithm. (line chart is not used since cases are indepen-
dent)
<
=
>=
?=
@=
<A
=
BD B
=
C D
<
=
C D
?
=
C DE
<
C
==
 -rat
F
G
(a) TPCH
HI
JI
KI
LI
H
MI
ND
N
I
OP
H
I
OP
K
I
OP
Q
H
O
II
 -rat
R
S
(b) DMV
TU
VU
WU
XU
T
Y
U
ZD
Z
U
[\
T
U
[\
W
U
[\]
T
[
UU
 -rat
^
_
(c) IMDB
`a
ba
ca
da
`
e
a
fDf
a
g h
`
a
g h
c
a
g hi
`
g
a
a
 -rat
j
k
(d) Airline
l
m
nm
om
pm
lq
m
rD r
m
s t
l
m
s t
o
m
s tu
l
s
mm
 -rat
v
w
(e) RealEstate
Figure 6: The impact of the number of datasets |퐷| on the distinctiveness ratio of each algorithm.
xyz
xy{
x
y|
xy}
xy~
a e rate
x
y

z
x
y

}
x
y


z
yxx
 -rat


(a) TPCH







 


a

e rate














 -rat


(b) DMV
 
 
 
 
 
a
  e rate

¡


¡


¡¢

 
 -rat
£
¤
(c) IMDB
¥¦§
¥
¦¨
¥¦©
¥¦ª
¥¦«
¬a­ ®¯e rate
¥¦
°
§
¥¦
°
ª
¥¦
°
±
§
¦¥
¥
 -rat
²
³
(d) Airline
´µ¶
´µ·
´
µ¸
´µ¹
´µº
»a¼ ½¾e rate
´
µ
¿
¶
´
µ
¿
¹
´
µ
¿
À
¶
µ´´
 -rat
Á
Â
(e) RealEstate
Figure 7: The impact of the sampling rate upper bound 푠max on the distinctiveness ratio of each algorithm.
Ã
Ä
Å
Æ
Ç
ÈÉer
Êa
Ë rat
Ì
È (
Í)
ÎÏ
Ç
Ã
ÎÏ
ÇÐ
ÎÏ
Ç
Æ
Ã
Ï ÎÎ
 -rat
Ñ
Ò
(a) TPCH
Ó
Ô
Õ
Ö
×
Ø Ùer
Úa
Û rat
Ü
Ø (
Ý)
Þß
×Ó
Þß
×
à
Þß
×Ö
Ó
ß ÞÞ
 -rat
á
â
(b) DMV
ã
ä
å
æ
ç
è éer
êa
ë rat
ì
è (
í)
îï
ç
ã
îï
çð
îï
ç
æ
ã
ï îî
 -rat
ñ
ò
(c) IMDB
ó
ô
õ
ö
÷
ø ùer
úa
û rat
ü
ø (
ý)
þÿ
÷ó
þÿ
÷ þÿ
÷
ö
ó
ÿþ
þ
 -rat


(d) Airline





	er

a
 rat

 (

)









 
 -rat


(e) RealEstate
Figure 8: The impact of the minimum overlap ratio 표푙between query pairs on the distinctiveness ratio of each algorithm.
TPCH
DMV
IMDB
Airline
RealEstate
ML- Greedy
(DE+IU)-ML- Greedy
(IRIS+IU)-ML- Greedy
|Q|=10
TPCH
DMV
IMDB
Airline
RealEstate
|Q|=40
TPCH
DMV
IMDB
Airline
RealEstate
|Q|=160
0.8
0.9
1.0
Figure 9: The impact of the number of queries |푄| on the
distinctiveness ratio of each algorithm.
a state-of-the-art SCE method IRIS. We compare the eﬀectiveness
using q-error, which is widely used in prior works on cardinality
estimation [32, 42]. Using the default settings, we estimate the dis-
tinctiveness for each dataset in 퐷, and then compute the q-error for
all of the datasets. Table 5 compares the performance when vary-
ing the percentiles of test cases. Observe that the q-error for DE is
more than an order of magnitude less than IRIS. This implies that
our method (Alg. 2) is considerably more eﬀective than the adapted
SOTA SCE approach.
6.3
Eﬀectiveness Study
Impact of the budget 퐵. In Figs. 5(a)-5(e), we examine how vary-
ing the budget impacts the distinctiveness ratio for each algorithm.
We make the following observations: (1) For larger values of 퐵-
ratio (budget), the distinctiveness ratio for both ML-Greedy and
(DE+IU)-ML-Greedy is around 6% greater than (IRIS+IU)-ML-Gre
edy. Given that |푑| is typically large in practice, even a seemingly
small diﬀerence – 6% – in distinctiveness ratio is equivalent to a
diﬀerence of tens of thousands of tuples. This reinforces our be-
lief that our distinctiveness estimation method DE eﬀectively and
reliably estimates distinctiveness. Additionally, the distinctiveness
estimated by both ML-Greedy and (DE+IU)-ML-Greedy are both
competitive with those of Exact-Greedy, especially on smaller
datasets such as the Airline dataset. (2) The distinctiveness ratio of
ML-Greedy is 2% larger than that of (DE+IU)-ML-Greedy. This im-
plies that our approach for updating data summaries (MS) is highly
eﬀective.
Impact of the number of datasets |퐷|. Based on the results shown
in Figs. 6(a)-6(e), observe that: (1) As |퐷| increases, the distinctive-
ness ratios of ML-Greedy and (DE+IU)-ML-Greedy become pro-
gressively higher than that of (IRIS+IU)-ML-Greedy. (2) The dis-
tinctiveness ratio of (IRIS+IU)-ML-Greedy decreases as |퐷| in-
creases, since more datasets are returned with greater |퐷|. This
leads to higher bias since IRIS can less accurately estimate distinc-
tiveness. (3) The distinctiveness ratio of ML-Greedy is robust to
changes in |퐷| compared to (DE+IU)-ML-Greedy.
Impact of the sampling rate upper bound 푠max. The results
shown in Figs. 7(a)-7(e) show that: (1) For large values of 푠max, the
distinctiveness ratios of ML-Greedy and (DE+IU)-ML-Greedy are
around 6% larger than that of (IRIS+IU)-ML-Greedy. (2) As 푠max
grows, the distinctiveness ratio of (IRIS+IU)-ML-Greedy gener-
ally decreases. Since each dataset adds additional tuples as 푠max

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
ML-Greedy
(DE+IU)-ML-Greedy
(IRIS + IU)-ML-Greedy
Exact-Greedy
 
 
 

 


B-rat











r

 
t
!
"
e (
#
)
(a) TPCH
$% &
$% '
$
% (
$
% )
$
% *
B-rat+,
&$
-
&$
.
&$
/
r
0
1
t
2
3
e (
4
)
(b) DMV
567
568
569
56:
56;
B-rat
<
=
7
5
>
7
5
?
7
5
@
7
5
A
ru
B
t
C
D
e (
E
)
(c) IMDB
FG H
FG I
FG J
F
G K
F
G L
B-rat
M
N
H
F
O
H
F
P
ru
Q
t
R
S
e (
T
)
(d) Airline
UVW
UVX
UVY
UVZ
UV [
B-rat\]
W
U
^
W
U
_
ru
`
t
a
b
e (
c
)
(e) RealEstate
Figure 10: The impact of the budget 퐵on the runtime of each algorithm.
de
f
e
ge
h
e
d
ie
jk
j
de
l
de
m
de
n
de
o
ru
p
t
q
r
e (
s
)
(a) TPCH
tu
v
u
w
u
xu
tyu
z {z
tu
|
tu
}
tu
~
tu

ru

t


e (

)
(b) DMV









 









ru

t


e (

)
(c) IMDB








 







ru

t
 
¡
e (
¢
)
(d) Airline
£¤
¥
¤
¦
¤
§¤
£
¨
¤
© ª
©
£¤
«
£¤
¬
£¤
­
ru
®
t
¯
°
e (
±
)
(e) RealEstate
Figure 11: The impact of the number of queries |푄| on the runtime of each algorithm.
²³
´
³
µ³
¶
³
²
·³
¸D
¸
²³
¹
²³
º
²³
»
²³
¼
²³
½
ru
¾
t
¿
À
e (
Á
)
(a) TPCH
ÂÃ
Ä
Ã
Å
Ã
ÆÃ
ÂÇÃ
ÈDÈ
ÂÃ
É
ÂÃ
Ê
ÂÃ
Ë
ÂÃ
Ì
ÂÃ
Í
ru
Î
t
Ï
Ð
e (
Ñ
)
(b) DMV
ÒÓ
Ô
Ó
ÕÓ
Ö
Ó
Ò
×
Ó
ØDØ
ÒÓ
Ù
ÒÓ
Ú
ÒÓ
Û
ÒÓ
Ü
ÒÓ
Ý
ÒÓ
Þ
ÒÓ
ß
ru
à
t
á
â
e (
ã
)
(c) IMDB
äå
æ
å
çå
èå
ä
éå
êD
ê
äå
ë
äå
ì
äå
í
äå
î
ru
ï
t
ð
ñ
e (
ò
)
(d) Airline
óô
õ
ô
öô
÷
ô
ó
øô
ùD
ù
óô
ú
óô
û
óô
ü
óô
ý
ru
þ
t
ÿ
 e (

)
(e) RealEstate
Figure 12: The impact of the number of datasets |퐷| on the runtime of each algorithm.
 
 
 

 


	a
 e rate









ru

t


e (

)
(a) TPCH
 

 

 

 

 
a e rate



 

!

"
ru
#
t
$
%
e (
&
)
(b) DMV
'()
'(*
'(+
'(,
'(-
.a/ 01e rate
)
'
2
)
'
3
)
'
4
)
'
5
ru
6
t
7
8
e (
9
)
(c) IMDB
:; <
:; =
:; >
:
; ?
:
; @
AaB CDe rate
<
:
E
<
:
F
ru
G
t
H
I
e (
J
)
(d) Airline
KL M
KL N
KL O
K
L P
KL
Q
RaS TUe rate
M
K
V
M
K
W
M
K
X
ru
Y
t
Z
[
e (
\
)
(e) RealEstate
Figure 13: The impact of the sampling rate upper bound 푠max on the runtime of each algorithm.
increases, the ability of IRIS to predict the number of tuples is
worse than DE. Recall that distinctiveness is the product of Eq. 6 and
the number of tuples in a dataset. Therefore, the error increases as
the number of tuples gets larger. (3) Although datasets are more
likely to have more similar data distributions as 푠max increases,
the distinctiveness ratio of ML-Greedy is consistently higher than
(DE+IU)-ML-Greedy. This demonstrates that our approach to up-
dating data summaries remains eﬀective regardless of the level of
similarity between dataset distributions.
Impact of the minimum overlap ratio 표푙. Based on the results
shown in Figs. 8(a)-8(e), observe that: (1) As 표푙increases, the dis-
tinctiveness ratios for ML-Greedy and (DE+IU)-ML-Greedy become
6% greater than (IRIS+IU)-ML-Greedy. (2) The distinctiveness ra-
tio of (IRIS+IU)-ML-Greedy increases as 표푙grows since a larger
overlap ratio produces more overlapping tuples for any query set.
However, IRIS does not consider overlapping tuplesacross queries.
(3) ML-Greedy has the highest distinctiveness ratio, particularly
when 표푙is small. In practice, the overlap ratio is typically small.
Hence, the practical beneﬁts of our method can be even greater.
Impact of the number of queries |푄|. Fig. 9 illustrates that: (1)
The distinctiveness ratios of ML-Greedy and (DE+IU)-ML-Greedy
can be up to 13% larger than (IRIS+IU)-ML-Greedy. (2) The dis-
tinctiveness ratio of (IRIS+IU)-ML-Greedy decreases as |푄| in-
creases as it ignores overlaps in query set results while a larger
|푄| typically leads to more overlapping tuples. In some cases, the
distinctiveness ratios of ML-Greedy and (DE+IU)-ML-Greedy may
also decrease with increasing |푄|. However, both approaches still
perform well (> 83%), which is a testament to the merits of the
newly proposed distinctiveness estimation method DE, in account-
ing for overlaps in the query set results.
6.4
Eﬃciency and Scalability Study
Impact of the budget 퐵. The impact of varying the budget ratio
is shown in Figs. 10(a)-10(e). Observe that: (1) As the 퐵-ratio is in-
creased, more datasets are selected, and the runtime for all of the
algorithms increases. However, ML-Greedy is at least two orders
of magnitude faster than all other algorithms. (2) Our distinctive-
ness estimation method DE is an order of magnitude faster than
Exact-Greedy, which uses the exact distinctiveness computation,
and is three times faster than IRIS. (3) Although (DE+IU)-ML-Greedy
uses the same distinctiveness estimation method as ML-Greedy,
it is an order of magnitude slower than ML-Greedy. This demon-
strates the high eﬃciency of our approach, MS, to update data sum-
maries.
Impact of the number of queries |푄|. Based on Figs. 11(a)-11(e),
observe that: (1) With increasing |푄|, the runtime for all algorithms
increases as more queries must be processed when estimating dis-
tinctiveness. However, our algorithms are at least two orders of
magnitude faster than the other algorithms. (2) Our distinctive-
ness estimation method DE is two orders of magnitude faster than
Exact-Greedy, and istwo times faster than IRIS. (3) Our approach

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
ML-Greedy
(DE+IU)-ML-Greedy
(IRIS + IU)-ML-Greedy
Exact-Greedy
]
^
_
`
a
bvercad rate
b (
f)
]
g
h
]
g
i
]
g
j
ru
k
t
l
m
e (
n
)
(a) TPCH
o
p
q
r
s
tveruav ratw
t (x)
o
y
z
o
y
{
o
y
|
ru
}
t
~

e (

)
(b) DMV





vera rat
 (
)












ru

t


e (

)
(c) IMDB





vera rat
 ()





 
ru
¡
t
¢
£
e (
¤
)
(d) Airline
¥
¦
§
¨
©
ªver«a¬ rat­
ª (®)
¥
¯
°
¥
¯
±
ru
²
t
³
´
e (
µ
)
(e) RealEstate
Figure 14: The impact of the minimum overlap ratio 표푙between query pairs on the runtime of each algorithm.
Table 6: Comparison against basic datasets discovery where
푆represents discovered datasets, the best model perfor-
mance is in bold (RMSE for House, AUC for HR).
Tasks
Methods
Í
푑∈푆|푑|
| Ð
푑∈푆푑|
Model performance
House
D3L
56,750
52,472
0.601
Exact-Greedy
133,391
110,404
0.569
ML-Greedy
133,391
110,404
0.569
HR
D3L
6711
3196
60.3%
Exact-Greedy
6270
5325
63.5%
ML-Greedy
6270
5325
63.5%
to updating data summaries, MS, is at least an order of magnitude
faster than IU.
Impact of the number of datasets |퐷|. In Figs. 12(a)-12(e), ob-
serve that: (1) As |퐷| increases, the runtime for all of the algo-
rithms increases since distinctiveness must be computed for more
datasets. However, our greedy algorithm with ML-based distinc-
tiveness estimation ML-Greedy is at least two orders of magnitude
faster than the baselines, which translates to better scalability. (2)
Our distinctiveness estimation method DE is three orders of mag-
nitude faster than Exact-Greedyand four times faster than IRIS.
(3) Our method for updating data summaries, MS, is two orders of
magnitude faster than IU.
Impact of the sampling rate upper bound푠max. From Figs. 13(a)-
13(e), we observe: (1) For larger values of 푠max, our approach is at
least two orders of magnitude faster than the baselines. (2) As 푠max
increases, the runtime of Exact-Greedy increases since it takes
more time to execute the queries and compute the marginal gain
for more tuples that are returned by the queries. All other algo-
rithms appear to be insensitive to changes to 푠max. This demon-
strates the advantage of using ourdistinctiveness estimation method,
i.e., eﬀectively eliminating the need to test each tuple individu-
ally. (3) Our distinctiveness estimation method DE is three orders of
magnitude faster than Exact-Greedy, and three times faster than
IRIS. (4) Our method for updating data summaries, MS, is two or-
ders of magnitude faster than IU.
Impact of the minimum overlap ratio 표푙. Based on Figs. 14(a)-
14(e), observe that: (1) When 표푙increases, the runtime for all of the
algorithms has little dependence on표푙. This indicates that the num-
ber of overlapping tuples returned by queries has minimal impact
on runtime, even though our distinctiveness estimation method
considers the overlaps. Regardless, ML-Greedy is up to four orders
of magnitude faster than the competitors. (2) Our distinctiveness
estimation method DE is at least two orders of magnitude faster
than Exact-Greedy, and is at least two times faster than IRIS. (3)
Our method for updating data summaries, MS, is at least two orders
of magnitude faster than IU.
6.5
Case Study
Now, we conduct a case study to test the hypothesis that our datasets
assemblage can help ﬁnd datasets with more useful tuples than ba-
sic datasets discovery. The point is that, we compare our datasets
assemblage methods, ML-Greedy and Exact-Greedy, with a state-
of-the-art basic datasets discovery method D3L [5], to show how
ML-Greedy, Exact-Greedy and D3L impact downstream task per-
formance through the pipeline illustrated in Fig. 1.
To this end, we consider two ML downstream tasks in [66], i.e,
a classiﬁcation task “predicting whether an employee will change
their job” using a multilayer perception (MLP) model (House for
brevity), and a regression task “predicting the price of a house”
using a support vector regression (SVR) model (HR for brevity).
For each ML task, the authors of [66] provide an initial training
set 푑푡푟푎푖푛, a test set 푑푡푒푠푡, a validation set 푑푣푎푙, and a data pool
푑푝표표푙. Using 푑푝표표푙, we create a set 퐷with 20 candidate datasets
and a user’s query set 푄with 10 queries following the procedure
of Appendix 5. We use 푑푡푟푎푖푛as a user’s base dataset 푑푢. Then, we
address the following problems:
• Basic datasets discovery: given a user’s base dataset 푑푢and a set
퐷of candidate datasets, it aims to ﬁnd top-푘datasets relevant to
푑푢.
• Advanced datasets assemblage: given a user’s base dataset 푑푢,
along with her query set 푄and her budget 퐵, and a set 퐷of candi-
date datasets, it aims to ﬁnd a subset of 퐷such that the subset has
the maximum distinctiveness within the budget.
• Tuples discovery: The user’s target, as in [66], is to enrich her
base dataset for model training. Thus, given a user’s base dataset
푑푢, along with her test set 푑푡푒푠푡, her validation set 푑푣푎푙and her
ML model 푀, and a data pool 푃after assembling datasets discov-
ered by basic datasets discovery or advanced datasets assemblage,
it aims to select a set of tuples from 푃to enrich 푑푢, such that the
performance of 푀has the maximum improvements.
Since D3L does not account for dataset prices, for a fair compar-
ison, we set the price of each candidate dataset to 1 and 푘= 퐵= 5.
For tuples discovery, we apply the IAS algorithm in [66], stopping
when the number of selected tuples is equal to the number of tu-
ples in 푑푢. As shown in Table 6, ML-Greedy can ﬁnd the same
datasets as Exact-Greedy for both ML tasks, showing that our ML-
based distinctiveness estimation is very close to exact distinctive-
ness computation. Our datasets assemblage methods, ML-Greedy
and Exact-Greedy, can identify more distinct tuples than D3L,
even when the total number of tuples in the datasets they dis-
cover is smaller than in those discovered by D3L. For both ML
tasks, models trained on datasets enriched by our datasets assem-
blage methods perform better. This suggests that our datasets as-
semblage methods’ potential in ﬁnding those datasets with more
useful tuples, as a higher number of distinct tuples leads to more

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
diverse data distributions in the training set, resulting in better
model training [37].
7
Related Work
Datasets discovery can be broadly divided into basic datasets dis-
covery and advanced datasets assemblage.
Basic datasets discovery is normally formulated as a search prob-
lem [8]. It relies on keywords [6, 44] or a base dataset [5, 20, 22, 27,
58] to retrieve relevant datasets. For example, table union search [20,
22, 27, 58] ﬁnds relevant datasets that share common columns with
the input base dataset to extend it with additional tuples. Basic
datasets discovery usually evaluates each candidate dataset indi-
vidually, emphasizing the similarity or overlaps between individ-
ual datasets and given keywords or base datasets. In contrast, our
datasets assemblage evaluates a set of candidate datasets as a whole,
emphasizing minimal overlaps with the input base dataset and among
the datasets in the results. Moreover, schema alignment is a com-
mon step following basic datasets discovery, such as when mate-
rializing the ﬁnal dataset through union operations in table union
search [19]. Our dataset assemblage builds upon the results of basic
datasets discovery after schema alignment.
Advanced datasets assemblage allows users to specify ﬁne-grained
information needs to assemble the most desirable datasets that are
evaluated as a whole. A recent study [36] deﬁnes a user’s ﬁne-
grained information needs as speciﬁc data attributes. They focus
on the richness of features in the datasets discovered. However,
this can result in insuﬃcient data instances and redundant fea-
tures during model training, which may increase the risk of over-
ﬁtting [75]. In contrast, our deﬁned distinctiveness measure (see
Deﬁnition 2.1) evaluates the distinctiveness of datasets, thereby fa-
cilitating the discovery of a more varied range of data instances.
Tuples discovery [7, 11, 21, 30, 37, 41, 73] is the process of se-
lecting the most beneﬁcial tuples from a pool of datasets, for a
speciﬁc target such as model training [7], causal inference in ques-
tion answering [21] or revenue allocation [43]. The “usefulness” of
the tuples added is typically assessed in relation to a single target.
However, our work diﬀers in that it focuses on acquiring complete
datasets (with less overlapping tuples) rather than individual tu-
ples.
Cardinality estimation. As discussed in §1, estimating the dis-
tinctiveness for a set of datasets w.r.t. a query set can be cast as the
multi-query-dataset cardinality estimation (MCE) problem. There-
fore, we also examine existing research works for the single-query-
dataset cardinality estimation (SCE) problem, which is generally
divided into two categories: query-driven or data-driven [24, 32].
Query-driven approaches [25, 47, 54, 57, 62, 65, 67] train SCE mod-
els on historical queries. Conversely, data-driven approaches [26,
40, 64, 69, 71, 72, 76] train SCE models based on data distributions,
without relying on any information from query workloads. While
query-driven methods often lack ﬂexibility, especially in the ab-
sence of representative queries, data-driven methods generally out-
perform query-driven methods [24]. Moreover, some hybrid meth-
ods [18, 33, 35, 42, 52, 68, 74] train SCE models by utilizing both
data distributions and query workloads, which exhibit higher esti-
mation accuracy and generality to varying data according to the
benchmark evaluations [24]. Despite the large body of existing
works, current methods for SCE are not amenable to the MCE prob-
lem directly since they estimate cardinality for only a single query
on a single dataset, whereas MCE requires estimating the cardinal-
ity for a query set on a set of datasets. This distinction underscores
the key challenge in the MCE problem, which is to eﬀectively iden-
tify overlaps among the tuple sets returned by each query in a
query set across multiple datasets.
Data pricing. A recent survey [56] reports several data pricing
functions. Commonly used pricing functions primarily depend on
the number of tuples in a dataset [3, 36, 37, 44–46]. Tuple-based
pricing functions [3, 37, 46] assign a price to each tuple, and the
price of a dataset is the sum of the tuple prices. Usage-based pricing
functions [44, 45] charge based on the dataset’s usage, measured in
bytes transferred per API request, with the data transferred linked
to the dataset’s tuple count. Query-based pricing functions [10, 16,
17, 36, 38] charge for the query results returned from a dataset
rather than providing the entire dataset, with the price of query
results also depending on the number of tuples returned. Without
loss of generality, in our experiments, we adopt tuple-based pricing
for datasets, as described in §5.1.
8
Conclusion
We introduced and studied the problem of maximizing distinctive-
ness, which requires a subset of candidate datasets to be found
that have the highest distinctiveness for a user-provided query set,
a base dataset, and a budget. We ﬁrst establish the NP-hardness of
this problem. To solve this problem, we propose a greedy algorithm
using ML-based distinctiveness estimation. This ML-based distinc-
tiveness estimation method can eﬀectively approximate the dis-
tinctiveness marginal gain without examining every tuple in each
dataset. Using a comprehensive empirical validation on ﬁve real-
world data pools, we demonstrate that our greedy algorithm using
ML-based distinctiveness estimation is eﬀective, eﬃcient, and scal-
able.
References
[1] Abolfazl Asudeh and Fatemeh Nargesian. 2022. Towards Distribution-aware
Query Answering in Data Markets. Proc. VLDB Endow. 15, 11 (2022), 3137–3144.
[2] NYU Auctus. 2022. https://auctus.vida-nyu.org/
[3] Magdalena Balazinska, Bill Howe, and Dan Suciu. 2011. Data Markets in the
Cloud: An Opportunity for the Database Community. Proc. VLDB Endow. 4, 12
(2011), 1482–1485.
[4] TPC-H Benchmark. 2022. http://www.tpc.org/tpch/.
[5] Alex Bogatu, Alvaro A. A. Fernandes, Norman W. Paton, and Nikolaos Konstanti-
nou. 2020. Dataset Discovery in Data Lakes. In ICDE. 709–720.
[6] Dan Brickley, Matthew Burgess, and Natasha F. Noy. 2019.
Google Dataset
Search: Building a search engine for datasets in an open Web ecosystem. In
WWW. 1365–1375.
[7] Chengliang Chai, Jiabin Liu, Nan Tang, Guoliang Li, and Yuyu Luo. 2022. Selec-
tive Data Acquisition in the Wild for Model Charging. Proc. VLDB Endow. 15, 7
(2022), 1466–1478.
[8] Adriane Chapman, Elena Simperl, Laura Koesten, George Konstantinidis, Luis-
Daniel Ibáñez, Emilia Kacprzak, and Paul Groth. 2020. Dataset search: a survey.
VLDB J. 29, 1 (2020), 251–272.
[9] Surajit Chaudhuri, Anish Das Sarma, Venkatesh Ganti, and Raghav Kaushik.
2007. Leveraging aggregate constraints for deduplication. In SIGMOD. 437–448.
[10] Shuchi Chawla, Shaleen Deep, Paraschos Koutris, and Yifeng Teng. 2019. Rev-
enue Maximization for Query Pricing. Proc. VLDB Endow. 13, 1 (2019), 1–14.
[11] Yiling Chen, Yiheng Shen, and Shuran Zheng. 2020. Truthful Data Acquisition
via Peer Prediction. In NeurIPS. 18194–18204.
[12] Source Code. 2023. https://github.com/rmitbggroup/DM.

---

WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
Tingting Wang et al.
[13] Graham Cormode and S. Muthukrishnan. 2005. An improved data stream sum-
mary: the count-min sketch and its applications. J. Algorithms 55, 1 (2005), 58–
75.
[14] Airline dataset. 2022. https://relational.ﬁt.cvut.cz/dataset/Airline.
[15] IMDB dataset. 2022. https://https://homepages.cwi.nl/~boncz/job/imdb.tgz.
[16] Shaleen Deep and Paraschos Koutris. 2017. The Design of Arbitrage-Free Data
Pricing Schemes. In ICDT, Vol. 68. 12:1–12:18.
[17] Shaleen Deep and Paraschos Koutris. 2017. QIRANA: A Framework for Scalable
Query Pricing. In SIGMOD. 699–713.
[18] Anshuman Dutt, Chi Wang, Azade Nazi, Srikanth Kandula, Vivek R. Narasayya,
and Surajit Chaudhuri. 2019. Selectivity Estimation for Range Predicates using
Lightweight Models. Proc. VLDB Endow. 12, 9 (2019), 1044–1057.
[19] Grace Fan, Jin Wang, Yuliang Li, and Renée J. Miller. 2023. Table Discovery in
Data Lakes: State-of-the-art and Future Directions. In SIGMOD. 69–75.
[20] Grace Fan, Jin Wang, Yuliang Li, Dan Zhang, and Renée J. Miller. 2023.
Semantics-aware Dataset Discovery from Data Lakes with Contextualized
Column-based Representation Learning. Proc. VLDB Endow. 16, 7 (2023), 1726–
1739.
[21] Sainyam Galhotra, Yue Gong, and Raul Castro Fernandez. 2023. Metam: Goal-
Oriented Data Discovery. In ICDE. 2780–2793.
[22] Yue Gong, Zhiru Zhu, Sainyam Galhotra, and Raul Castro Fernandez. 2023. Ver:
View Discovery in the Wild. In ICDE. 503–516.
[23] Ian Goodfellow, Yoshua Bengio, and Aaron Courville. 2016. Deep learning. MIT
press.
[24] Yuxing Han, Ziniu Wu, Peizhi Wu, Rong Zhu, Jingyi Yang, Liang Wei Tan, Kai
Zeng, Gao Cong, Yanzhao Qin, Andreas Pfadler, Zhengping Qian, Jingren Zhou,
Jiangneng Li, and Bin Cui. 2021. Cardinality Estimation in DBMS: A Compre-
hensive Benchmark Evaluation. Proc. VLDB Endow. 15, 4 (2021), 752–765.
[25] Shohedul Hasan, Saravanan Thirumuruganathan, Jees Augustine, Nick Koudas,
and Gautam Das. 2020.
Deep Learning Models for Selectivity Estimation of
Multi-Attribute Queries. In SIGMOD. 1035–1050.
[26] Benjamin Hilprecht, Andreas Schmidt, Moritz Kulessa, Alejandro Molina, Kris-
tian Kersting, and Carsten Binnig. 2020. DeepDB: Learn from Data, not from
Queries! Proc. VLDB Endow. 13, 7 (2020), 992–1005.
[27] Xuming Hu, Shen Wang, Xiao Qin, Chuan Lei, Zhengyuan Shen, Christos Falout-
sos, Asterios Katsifodimos, George Karypis, Lijie Wen, and Philip S. Yu. 2023.
Automatic Table Union Search with Tabular Representation Learning. In ACL.
3786–3800.
[28] Ihab F. Ilyas, Volker Markl, Peter J. Haas, Paul Brown, and Ashraf Aboulnaga.
2004. CORDS: Automatic Discovery of Correlations and Soft Functional Depen-
dencies. In SIGMOD. 647–658.
[29] Yannis E. Ioannidis. 2003. The History of Histograms (abridged). In VLDB. Mor-
gan Kaufmann, 19–30.
[30] Ruoxi Jia, David Dao, Boxin Wang, Frances Ann Hubis, Nezihe Merve Gürel, Bo
Li, Ce Zhang, Costas J. Spanos, and Dawn Song. 2019. Eﬃcient Task-Speciﬁc
Data Valuation for Nearest Neighbor Algorithms.
Proc. VLDB Endow. 12, 11
(2019), 1610–1623.
[31] Samir Khuller, Anna Moss, and Joseph Naor. 1999. The Budgeted Maximum
Coverage Problem. Inf. Process. Lett. 70, 1 (1999), 39–45.
[32] Kyoungmin Kim, Jisung Jung, In Seo, Wook-Shin Han, Kangwoo Choi, and Jae-
hyok Chong. 2022. Learned Cardinality Estimation: An In-depth Study. In SIG-
MOD. 1214–1227.
[33] Andreas Kipf, Thomas Kipf, Bernhard Radke, Viktor Leis, Peter A. Boncz, and
Alfons Kemper. 2019. Learned Cardinalities: Estimating Correlated Joins with
Deep Learning. In CIDR.
[34] Mingzhao Li, Zhifeng Bao, Timos Sellis, Shi Yan, and Rui Zhang. 2018. Home-
Seeker: A visual analytics system of real estate data. J. Vis. Lang. Comput. 45
(2018), 1–16.
[35] Pengfei Li, Wenqing Wei, Rong Zhu, Bolin Ding, Jingren Zhou, and Hua Lu. 2023.
ALECE: An Attention-based Learned Cardinality Estimator for SPJ Queries on
Dynamic Workloads. Proc. VLDB Endow. 17, 2 (2023), 197–210.
[36] Yanying Li, Haipei Sun, Boxiang Dong, and Wendy Hui Wang. 2018.
Cost-
eﬃcient Data Acquisition on Online Data Marketplaces for Correlation Analysis.
Proc. VLDB Endow. 12, 4 (2018), 362–375.
[37] Yifan Li, Xiaohui Yu, and Nick Koudas. 2021. Data Acquisition for Improving
Machine Learning Models. Proc. VLDB Endow. 14, 10 (2021), 1832–1844.
[38] Bing-Rong Lin and Daniel Kifer. 2014. On Arbitrage-free Pricing for General
Data Queries. Proc. VLDB Endow. 7, 9 (2014), 757–768.
[39] Wei-Chao Lin and Chih-Fong Tsai. 2020. Missing value imputation: a review
and analysis of the literature (2006–2017). Artiﬁcial Intelligence Review 53 (2020),
1487–1509.
[40] Yuming Lin, Zejun Xu, Yinghao Zhang, You Li, and Jingwei Zhang. 2023. Cardi-
nality estimation with smoothing autoregressive models. World Wide Web 26, 5
(2023), 3441–3461.
[41] Jiabin Liu, Fu Zhu, Chengliang Chai, Yuyu Luo, and Nan Tang. 2021. Automatic
Data Acquisition for Deep Learning. Proc. VLDB Endow.14, 12 (2021), 2739–2742.
[42] Yao Lu, Srikanth Kandula, Arnd Christian König, and Surajit Chaudhuri. 2021.
Pre-training Summarization Models of Structured Datasets for Cardinality Esti-
mation. Proc. VLDB Endow. 15, 3 (2021), 414–426.
[43] Xuan Luo, Jian Pei, Zicun Cong, and Cheng Xu. 2022. On Shapley Value in Data
Assemblage Under Independent Utility. Proc. VLDB Endow. 15, 11 (2022), 2761–
2773.
[44] Amazon AWS Marketplace. 2022. https://aws.amazon.com/marketplace.
[45] Snowﬂake Data Marketplace.2022. https://www.snowﬂake.com/data-marketplace/.
[46] Sameer Mehta, Milind Dawande, Ganesh Janakiraman, and Vijay S. Mookerjee.
2019. How to Sell a Dataset?: Pricing Policies for Data Monetization. In EC. 679.
[47] Magnus Müller, Lucas Woltmann, and Wolfgang Lehner. 2023. Enhanced Fea-
turization of Queries with Mixed Combinations of Predicates for ML-based Car-
dinality Estimation. In EDBT. 273–284.
[48] Viswanath
Nagarajan.
2021.
Approximation
&
Online
Algorithms.
http://viswa.engin.umich.edu/wp-content/uploads/sites/169/2021/02/greedy.pdf
(2021).
[49] Fatemeh Nargesian, Abolfazl Asudeh, and H. V. Jagadish. 2021. Tailoring Data
Source Distributions for Fairness-aware Data Integration. Proc. VLDB Endow. 14,
11 (2021), 2519–2532.
[50] Fatemeh Nargesian, Abolfazl Asudeh, and H. V. Jagadish. 2022. Responsible Data
Integration: Next-generation Challenges. In SIGMOD. 2458–2464.
[51] Fatemeh Nargesian, Erkang Zhu, Ken Q. Pu, and Renée J. Miller. 2018. Table
Union Search on Open Data. Proc. VLDB Endow. 11, 7 (2018), 813–825.
[52] Parimarjan Negi, Ziniu Wu, Andreas Kipf, Nesime Tatbul, Ryan Marcus, Sam
Madden, Tim Kraska, and Mohammad Alizadeh. 2023. Robust Query Driven
Cardinality Estimation under Changing Workloads. Proc. VLDB Endow. 16, 6
(2023), 1520–1533.
[53] Marcel Parciak, Brecht Vandevoort, Frank Neven, Liesbet M. Peeters,
and Stijn Vansummeren. 2024.
Schema Matching with Large Lan-
guage Models: an Experimental Study.
CoRR abs/2407.11852 (2024).
https://doi.org/10.48550/arXiv.2407.11852
[54] Yongjoo Park, Shucheng Zhong, and Barzan Mozafari. 2020. QuickSel: Quick
Selectivity Learning with Mixture Models. In SIGMOD. 1017–1033.
[55] Norman W. Paton, Jiaoyan Chen, and Zhenyu Wu. 2024. Dataset Discovery and
Exploration: A Survey. ACM Comput. Surv. 56, 4 (2024), 102:1–102:37.
[56] Jian Pei. 2022. A Survey on Data Pricing: From Economics to Data Science. IEEE
Trans. Knowl. Data Eng. 34, 10 (2022), 4586–4608.
[57] Silvan Reiner and Michael Grossniklaus. 2023. Sample-Eﬃcient Cardinality Es-
timation Using Geometric Deep Learning. Proc. VLDB Endow. 17, 4 (2023), 740–
752.
[58] El Kindi Rezig, Anshul Bhandari, Anna Fariha, Benjamin Price, Allan Vanter-
pool, Vijay Gadepally, and Michael Stonebraker. 2021. DICE: Data Discovery by
Example. Proc. VLDB Endow. 14, 12 (2021), 2819–2822.
[59] Fabian Schomm, Florian Stahl, and Gottfried Vossen. 2013. Marketplaces for
data: an initial survey. SIGMOD Rec. 42, 1 (2013), 15–26.
[60] snowmobile
State of
New York Vehicle
and
boat registrations. 2022.
https://catalog.data.gov/dataset/vehicle-snowmobile-and-boat-registrations.
[61] Michael Stonebraker and Andrew Pavlo. 2024.
What Goes Around Comes
Around... And Around... ACM SIGMOD Record 53, 2 (2024), 21–37.
[62] Ji Sun and Guoliang Li. 2019. An End-to-End Learning-based Cost Estimator.
Proc. VLDB Endow. 13, 3 (2019), 307–319.
[63] Ki Hyun Tae and Steven Euijong Whang. 2021. Slice Tuner: A Selective Data
Acquisition Framework for Accurate and Fair Machine Learning Models. In SIG-
MOD. 1771–1783.
[64] Kostas Tzoumas, Amol Deshpande, and Christian S. Jensen. 2013. Eﬃciently
adapting graphical models for selectivity estimation. VLDB J. 22, 1 (2013), 3–27.
[65] Fang Wang, Xiao Yan, Man Lung Yiu, Shuai Li, Zunyao Mao, and Bo Tang. 2023.
Speeding Up End-to-end Query Execution via Learning-based Progressive Car-
dinality Estimation. Proc. ACM Manag. Data 1, 1 (2023), 28:1–28:25.
[66] Tingting Wang, Shixun Huang, Zhifeng Bao, J. Shane Culpepper, Volkan
Dedeoglu, and Reza Arablouei. 2024. Optimizing Data Acquisition to Enhance
Machine Learning Performance. Proc. VLDB Endow. 17, 6 (2024), 1310–1323.
[67] Chenggang Wu, Alekh Jindal, Saeed Amizadeh, Hiren Patel, Wangchao Le, Shi
Qiao, and Sriram Rao. 2018. Towards a Learning Optimizer for Shared Clouds.
Proc. VLDB Endow. 12, 3 (2018), 210–222.
[68] Peizhi Wu and Gao Cong. 2021. A Uniﬁed Deep Model of Learning from both
Data and Queries for Cardinality Estimation. In SIGMOD. 2009–2022.
[69] Ziniu Wu, Amir Shaikhha, Rong Zhu, Kai Zeng, Yuxing Han, and Jingren Zhou.
2020. BayesCard: Revitilizing Bayesian Frameworks for Cardinality Estimation.
CoRR abs/2012.14743 (2020).
[70] Junwen Yang, Yeye He, and Surajit Chaudhuri. 2021. Auto-pipeline: synthesizing
complex data pipelines by-target using reinforcement learning and search. Proc.
VLDB Endow. 14, 11 (2021), 2563–2575.
[71] Zongheng Yang, Amog Kamsetty, Sifei Luan, Eric Liang, Yan Duan, Xi Chen,
and Ion Stoica. 2020. NeuroCard: One Cardinality Estimator for All Tables. Proc.
VLDB Endow. 14, 1 (2020), 61–73.

---

Distinctiveness Maximization in Datasets Assemblage
WWW ’25, April 28-May 2, 2025, Sydney, NSW, Australia
[72] Zongheng Yang, Eric Liang, Amog Kamsetty, Chenggang Wu, Yan Duan, Xi
Chen, Pieter Abbeel, Joseph M. Hellerstein, Sanjay Krishnan, and Ion Stoica.
2019. Deep Unsupervised Cardinality Estimation. Proc. VLDB Endow. 13, 3 (2019),
279–292.
[73] Jinsung Yoon, Sercan Ömer Arik, and Tomas Pﬁster. 2020. Data Valuation using
Reinforcement Learning. In ICML, Vol. 119. 10842–10851.
[74] Tianjing Zeng, Junwei Lan, Jiahong Ma, Wenqing Wei, Rong Zhu, Pengfei Li,
Bolin Ding, Defu Lian, Zhewei Wei, and Jingren Zhou. 2024. PRICE: A Pretrained
Model for Cross-Database Cardinality Estimation. CoRR abs/2406.01027 (2024).
[75] Daochen Zha, Zaid Pervaiz Bhat, Kwei-Herng Lai, Fan Yang, Zhimeng Jiang,
Shaochen Zhong, and Xia Hu. 2023. Data-centric Artiﬁcial Intelligence: A Sur-
vey. CoRR abs/2303.10158 (2023).
[76] Rong Zhu, Ziniu Wu, Yuxing Han, Kai Zeng, Andreas Pfadler, Zhengping Qian,
Jingren Zhou, and Bin Cui. 2021. FLAT: Fast, Lightweight and Accurate Method
for Cardinality Estimation. Proc. VLDB Endow. 14, 9 (2021), 1489–1502.

---

