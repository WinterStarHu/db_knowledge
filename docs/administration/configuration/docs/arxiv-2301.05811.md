# Weighted Minwise Hashing Beats Linear Sketching for Inner Product Estimation

> 来源: https://arxiv.org/pdf/2301.05811

Weighted Minwise Hashing Beats Linear Sketching for Inner
Product Estimation
Aline Bessa1∗
aline.bessa@nyu.edu
Majid Daliri1
daliri.majid@nyu.edu
Juliana Freire1
juliana.freire@nyu.edu
Cameron Musco2
cmusco@cs.umass.edu
Christopher Musco1
cmusco@nyu.edu
Aécio Santos1
aecio.santos@nyu.edu
Haoxiang Zhang1
haoxiang.zhang@nyu.edu
1New York University
2University of Massachusetts Amherst
May 8, 2023
Abstract
We present a new approach for independently computing compact sketches that can be used to approximate
the inner product between pairs of high-dimensional vectors. Based on the Weighted MinHash algorithm, our
approach admits strong accuracy guarantees that improve on the guarantees of popular linear sketching approaches
for inner product estimation, such as CountSketch and Johnson-Lindenstrauss projection. Speciﬁcally, while our
method exactly matches linear sketching for dense vectors, it yields signiﬁcantly lower error for sparse vectors with
limited overlap between non-zero entries. Such vectors arise in many applications involving sparse data, as well
as in increasingly popular dataset search applications, where inner products are used to estimate data covariance,
conditional means, and other quantities involving columns in unjoined tables. We complement our theoretical results
by showing that our approach empirically outperforms existing linear sketches and unweighted hashing-based
sketches for sparse vectors.
1
Introduction
The inner product of two vectors a and b, ⟨a, b⟩= Í𝑛
𝑘=1 a[𝑘]b[𝑘], is a ubiquitous operation. Among many other
applications, inner products can be used to compute document similarities [Salton et al., 1975], to evaluate learned
classiﬁcation models, and to estimate join sizes [Alon et al., 1999b, Achlioptas, 2003, Rusu and Dobra, 2008]. However,
in modern applications involving very high-dimensional vectors, computing exact inner products can be intractable.
The computational cost is 𝑂(𝑛) and computing ⟨a, b⟩requires loading 𝑂(𝑛) numbers from memory, or communicating
𝑂(𝑛) numbers if a and b are stored on diﬀerent machines.
A common approach for resolving this issue is to pre-compute a small space compression (a sketch) of each vector,
which we will denote by S(a) and S(b), respectively. An estimation function F is then used to approximate the inner
product as F (S(a), S(b)) ≈⟨a, b⟩. The beauty of sketching is that it simultaneously reduces storage, communication,
and runtime complexity. Moreover, once computed, sketches can be reused again and again to estimate inner products
with other vectors. For example, given another vector c we can estimate ⟨a, c⟩≈F (S(a), S(c)).
Sketching methods for approximating inner products are already widely used throughout computer science. In
machine learning, they can be used to accelerate the training of large-scale linear models like support vector machines
or logistic regression [Arriaga and Vempala, 2006, Li et al., 2011]. In relational databases, inner product sketches are
used in query optimizers to choose optimal query plans without having to execute expensive queries that involve
large joins [Cormode et al., 2011]. More recently, inner product sketches have found applications in dataset search
∗Author names are listed in alphabetical order.
1
arXiv:2301.05811v2  [cs.DB]  5 May 2023

---

Method
Error for sketches of size 𝑂(1/𝜖2)
Assumptions
Johnson-Lindenstrauss Projection [Arriaga
and Vempala, 2006], AMS [Alon et al.,
1999b], CountSketch [Charikar et al., 2002]
𝜖· ∥a∥∥b∥
None
MinHash (MH) Sampling [Beyer et al., 2007]
𝜖· max (∥aI∥∥b∥, ∥a∥∥bI∥)
a, b are binary, i.e.
with {0, 1} entries.
Our
Method:
Weighted
MinHash
(WMH) Sampling
𝜖· max (∥aI∥∥b∥, ∥a∥∥bI∥)
None
Table 1: Comparison of high-probability additive error guarantees for estimating ⟨a, b⟩using various sketching
methods. We let I = {𝑖: a[𝑖] ≠0 and b[𝑖] ≠0} denote the intersection of a’s and b’s supports. aI and bI are a and
b restricted to indices in I. Since max (∥aI∥∥b∥, ∥a∥∥bI∥) ≤∥a∥∥b∥, the bound for our Weighted MinHash (WMH)
method always beats the linear sketching methods. Our bound matches that of unweighted MinHash, but without
the strong limiting assumption that a and b are binary; it holds for all vectors.
and discovery, where they are used to discover joinable tables [Fernandez et al., 2019] and to estimate other column
statistics, such as correlation [Santos et al., 2021], without explicitly performing a join operation between two tables.
We discuss these applications and others in Section 1.2.
What was Previously Known? In all of the applications above, a primary concern is optimizing the trade-oﬀbetween
the sketch size (which governs storage, communication, and runtime eﬃciency) and how accurately F (S(a), S(b))
approximates ⟨a, b⟩. A large sketch size will in general lead to better approximation, but the question is by exactly how
much. Currently, the only methods with strong theoretical guarantees on this tradeoﬀfor general vectors (i.e., vectors
without any assumed value distribution or magnitude) are based on linear sketching algorithms. Such algorithms
include the famous “tug-of-war” sketch, a.k.a. the AMS sketch [Alon et al., 1999b, Alon et al., 1999a], the CountSketch
algorithm [Charikar et al., 2002], and methods based on Johnson-Lindenstrauss (JL) random projection [Achlioptas,
2003, Dasgupta and Gupta, 2003].
All of these approaches have a similar form. We choose a random matrix Π ∈R𝑚×𝑛(Π might have i.i.d. random
entries or more complex structure) and sets S(a) = Πa and S(b) = Πb. Each sketch is a length 𝑚vector and is
considered a linear sketch since S is a linear function. To estimate the inner product, the typical approach is to simply
return the sketch inner product ⟨S(a), S(b)⟩.1
A textbook theoretical accuracy guarantee for inner product estimation based on linear sketching is:
Fact 1 (Linear Sketching for Inner Products [Arriaga and Vempala, 2006]). Let 𝜖,𝛿∈(0, 1) be accuracy and failure
probability parameters respectively and let 𝑚= 𝑂(log(1/𝛿)/𝜖2). Let Π ∈R𝑚×𝑛be a random matrix with each entry set
independently to +
√︁
1/𝑚or −
√︁
1/𝑚with equal probability. For length 𝑛vectors a, b ∈R𝑛, let S(a) = Πa and S(b) = Πb.
With probability at least 1 −𝛿,
|⟨S(a), S(b)⟩−⟨a, b⟩| ≤𝜖∥a∥∥b∥
where ∥x∥denotes the standard Euclidean norm.
In addition to dense random matrices, analogous results to Fact 1 can be proven for sparse JL matrices, CountSketch
matrices, and other linear sketches [Cormode et al., 2011]. The fact provides a powerful accuracy guarantee that
improves with the sketch size 𝑚and depends naturally on the norms of a and b. To the best of our knowledge, linear
sketching methods were previously the only known algorithms to obtain such a strong theoretical guarantee.
1.1
Our Contributions
In this paper we introduce a novel method for inner product sketching based on the Weighted MinHash sketch
[Gollapudi and Panigrahy, 2006, Manasse et al., 2010, Ioﬀe, 2010], which is a variant of the classic MinHash method
[Broder, 1997, Broder et al., 1998]. We prove that our method obtains a reﬁned guarantee than Fact 1. In particular, it
1Other estimators involving e.g., the median of multiple approximate inner products, are also used [Larsen et al., 2021]. However, theoretical
guarantees are similar, typically diﬀering in the dependence on the failure probability 𝛿
2

---

matches the result for linear sketches in the worst case when a and b are dense2, but always obtains a better bound
when a and b are sparse vectors with limited overlap between non-zero entries. As discussed further in Section 1.2,
such pairs of vectors are the norm in many applications of inner product sketching to database problems and modern
dataset search applications.
Theorem 2 (Main Result). Let 𝜖,𝛿∈(0, 1) be accuracy and failure probability parameters and let 𝑚= 𝑂(log(1/𝛿)/𝜖2).
There is an algorithm S that produces size-𝑚sketches (Algorithm 3), along with an estimation procedure F (Algorithm 5),
such that for any a, b ∈R𝑛, with probability at least 1 −𝛿,
|F (S(a), S(b)) −⟨a, b⟩| ≤𝜖max (∥aI∥∥b∥, ∥a∥∥bI∥)
Above, I = {𝑖: a[𝑖] ≠0 and b[𝑖] ≠0} is the intersection of a’s and b’s supports. aI and bI denote a and b restricted to
indices in I.
We always have ∥aI∥≤∥a∥and ∥bI∥≤∥b∥, so we can bound max (∥aI∥∥b∥, ∥a∥∥bI∥) ≤∥a∥∥b∥. That is,
the guarantee of Theorem 2 matches that of Fact 1 in the worse-case, but can be signiﬁcantly better. For example,
consider a and b that have roughly the same number of non-zero entries, but only a 𝛾< 1 fraction of those entries
are non-zero in both a and b. In this case, it is reasonable to expect that ∥aI∥2 ≈𝛾∥a∥2 and ∥bI∥2 ≈𝛾∥b∥2 since aI
and bI contain just a 𝛾fraction of entries from the original vectors. Our course, the actually improvement is data
dependent; for example, we might have that ∥aI∥2 is signiﬁcantly smaller than 𝛾∥a∥2, or that it is not much smaller
than ∥a∥2.
Nevertheless, considering the “typical case” when a 𝛾fraction of non-zeros overlap, we might expect the bound
from Theorem 2 to be better than Fact 1 by a factor of √𝛾. So, to obtain the same error as a linear sketch, our method
could set 𝑚smaller by a factor of 𝛾. In many applications, 𝛾is very small. E.g., in Section 5 we consider a document
similarity problem where 𝛾≤.05 for 95% of vector pairs sketched. This could equate to roughly a 20𝑥improvement
in sketch size required to achieve a speciﬁed level of error.
Thanks to their strong theoretical guarantees, linear sketching algorithms have become the go-to approach for
generic inner product estimation [Cormode et al., 2011]. Our results show for the ﬁrst time that an alternative method
can provide stronger bounds. We hope that this paper will serve as a starting point for further investigation into
hashing-based algorithms for inner product sketching.
1.2
Motivating Application: Dataset Search
Before presenting the technical details of our results and discussing related work, we detail one application that
could beneﬁt from our proposed sketches, and helps illustrate the importance of obtaining bounds for inner product
estimation that are sensitive to the number of overlapping non-zero entries in a and b. Speciﬁcally, we consider the
problem of dataset search which has received increasing attention in recent years [Lehmberg et al., 2015, Zhu et al.,
2019, Yang et al., 2019, Zhu et al., 2016, Fernandez et al., 2019, Santos et al., 2021, Santos et al., 2022].
Suppose that a data scientist wants to understand the reasons for ﬂuctuations in taxi ridership in New York City
in 2022. The analyst only has a table containing two columns: a date column and the number of taxi rides taken on
that day. In order to carry out the analysis, she needs to ﬁnd other tables, either in her organization’s data lake or in
public repositories like NYC Open Data (which contain thousands of datasets [City of New York, 2022]), that would
bring in other relevant variables when joined with the original table. For example, the analyst might hope to ﬁnd
weather data, which can impact taxi ridership. Moreover, she would like to ﬁnd relevant factors that she might not
think of on her own, in an automatic way.
To solve this problem, we would like methods to automatically discover tables that are both 1) joinable with the
target table (i.e., also contain columns with dates from 2022) and 2) meaningfully related with the analyst’s data. For
example, a table containing precipitation data should be returned if taxi ridership is signiﬁcantly higher or lower on
days with high precipitation. To ﬁnd such tables, brute force search is not infeasible – we typically cannot aﬀord to
join the analyst’s table with all tables in the search set to look for good candidates. Instead, we need to eﬃciently
estimate statistics between disparate tables without materializing their join [Santos et al., 2021].
Sketching has become the most popular approach for performing this sort of estimation between unjoined data
tables [Zhu et al., 2016, Fernandez et al., 2019, Yang et al., 2019, Santos et al., 2021, Santos et al., 2022]. Speciﬁcally, a
2For dense vectors, Fact 1 is actually optimal up to constants: recent work implies that no sketch of size 𝑚= 𝑜(log(1/𝛿)/𝜖2) can achieve error
𝜖∥a∥∥b∥with probability 1 −𝛿for all inputs [Larsen and Nelson, 2017, Alon and Klartag, 2017]. Our result also matches this lower bound.
3

---

T𝐴
𝐾𝐴
𝑉𝐴
1
6.0
3
2.0
4
6.0
5
1.0
6
4.0
7
2.0
8
2.0
9
8.0
11
3.0
T𝐵
𝐾𝐵
𝑉𝐵
2
1.0
4
5.0
5
1.0
8
2.0
10
4.0
11
2.5
12
6.0
15
6.0
16
3.7
T𝐴⊲⊳𝐵
𝐾𝐴⊲⊳𝐵
𝑉𝐴⊲⊳
𝑉𝐵⊲⊳
4
6.0
5.0
5
1.0
1.0
8
2.0
2.0
11
3.0
2.5
SIZE(𝑉𝐴⊲⊳) = 4
SUM(𝑉𝐴⊲⊳) = 12.0
SUM(𝑉𝐵⊲⊳) = 10.5
MEAN(𝑉𝐴⊲⊳) = 12.0/4 = 3.0
Figure 2: The table T𝐴⊲⊳𝐵is the output of a one-to-one join between the tables T𝐴with T𝐵. We are interested in
approximating post-join statistics (e.g., join size, sums, means, and covariances) of the table T𝐴⊲⊳𝐵using only inner
products.
small-space sketch is precomputed for all data tables in the search set. When the analyst issues a query to ﬁnd relevant
data, a sketch of her table is compared against these preexisting sketches using a fraction of the computational
resources in comparison to explicitly materializing table joins [Santos et al., 2021].
Inner product sketching for dataset search. Interestingly, in the framework discussed above, many problems of
interest can be formulated precisely as inner product sketching problems. To see why this is the case, consider the
example tables T𝐴and T𝐵shown in Figure 2: each contains a column of keys, 𝐾𝐴and 𝐾𝐵, and a column of values, 𝑉𝐴
and 𝑉𝐵. A join operation between the tables on their keys generates the output table T𝐴⊲⊳𝐵.3
We list in Figure 2 a number of statistics that we might hope to estimate in T𝐴⊲⊳𝐵when searching for relevant
datasets. We claim that all of these statistics can be estimated using inner products between vector representations of
the tables, which we denote x1[𝐾𝐴], x𝐾𝐴and x1[𝐾𝐵], x𝐾𝐵respectively and show in Figure 3.
First, it is easy to see that the size of T𝐴⊲⊳𝐵is equal to the intersection between the keys in 𝐾𝐴and 𝐾𝐵, i.e.,
|𝐾𝐴∩𝐾𝐵| = 4. This is in turn equal to the inner product between x1[𝐾𝐴] and x1[𝐾𝐵]. Similarly, the SUM aggregate
of the values in 𝑉𝐴after join (i.e., SUM(𝑉𝐴⊲⊳)) is equal to the inner product SUM(𝑉𝐴⊲⊳) = ⟨x𝑉𝐴, x1[𝐾𝐵]⟩. To estimate a
post-join mean (i.e., MEAN(𝑉𝐴⊲⊳)), we can combine the join-size estimate with the SUM estimate:
MEAN(𝑉𝐴⊲⊳) =
⟨x𝑉𝐴, x1[𝐾𝐵]⟩
⟨x1[𝐾𝐴], x1[𝐾𝐵]⟩.
Finally, computing a post-join inner product, ⟨x𝑉𝐴, x𝑉𝐵⟩could be useful. In the application above, for tables containing
precipitation data and taxi ridership, a high inner-product might signify that high precipitation days align with high
ridership days.
Comparison of diﬀerent methods. Given the above reductions, both linear sketching methods like JL projection
and CountSketch, and our Weighted MinHash method, can be directly applied to the dataset search problem. We simply
need to precompute S(x1[𝐾𝐵]) and S(x𝑉𝐵) for all tables T𝐵in our search set. Sketching other vector transformations
like S((x𝑉𝐵)2) opens up the possibility of also estimating other quantities like post-join variance.
In search applications, we note that the vector length 𝑛can be very large. However, computing sketches does not
require fully materializing the vectors x1[𝐾𝐴] and x1[𝐾𝐵]: all sketching methods discussed in this paper only need to
process the vectors’ non-zero entries. Furthermore, it is not necessary to know the 𝑛beforehand: we can simply set 𝑛
to be large enough to cover the whole domain of the keys being sketched (e.g., 𝑛= 232 or 𝑛= 264).
To compare methods, Fact 1 and Theorem 2 suggest that any asymptotic diﬀerences in performance between
our WMH method and linear sketching will depend on the overlap in non-zero entries between the vectors being
sketched. In dataset search, this exactly corresponds to the Jaccard similarity of the key sets 𝐾𝐴and 𝐾𝐵. Our method
will perform better when the Jaccard similarity is small. For example, in Figure 2, only 4 out of 14 unique keys are
shared in both tables, so the similarity is ≈.29. In the scenario discussed above, we could imagine a much smaller
ratio: for example, our data analyst might only have a table containing taxi data from 2022, but compare it to a
weather data table with dates from 1960 through the present day. The Jaccard similarity would be 1/63 ≈.016. In
Section 5 we consider a dataset search use case involving data from the World Bank [World Bank, 2022] where 42%
percent of table pairs had Jaccard similarity < .1, and 35% have Jaccard similarity < .05.
3Note that, in the example described in Figure 2, we assume a one-to-one join. Dataset search problems can involve many-to-many joins
as well, although a typical approach is to use a data aggregation function to reduce to the one-to-one setting [Santos et al., 2021, Santos et al.,
2022, Kanter and Veeramachaneni, 2015].
4

---

index
1
2
3
4
5
6
7
8
9
10
11
12 13 14 15
16
x𝑉𝐴
6.0
0
2.0 6.0 1.0 4.0 2.0 2.0 8.0
0
3.0
0
0
0
0
0
x1[𝐾𝐴]
1
0
1
1
1
1
1
1
1
0
1
0
0
0
0
0
x𝑉𝐵
0
1.0
0
5.0 1.0
0
0
2.0
0
4.0 2.5 6.0
0
0
6.0 3.7
x1[𝐾𝐵]
0
1
0
1
1
0
0
1
0
1
1
1
0
0
1
1
Figure 3: Vector representation of tables T𝐴with T𝐵from Figure 2. The vector x1[𝐾𝐴] (resp. x1[𝐾𝐵]) is the vector
representation for the join key 𝐾𝐴(resp. 𝐾𝐵) and x𝑉𝐴(resp. x𝑉𝐵) is the vector representation for the column 𝑉𝐴(resp.
𝑉𝐵). Bold numbers are entries included in the join result from T𝐴⊲⊳𝐵.
1.3
Paper Roadmap
In Section 2 we review related prior work. In Section 3 we outline an analysis of the standard unweighted MinHash
method for inner product estimation. This analysis serves as a technical warm-up for our main result (Theorem 2)
on Weighted MinHash, which is presented in Section 4. Finally, in Section 5 we support Theorem 2 with a detailed
empirical evaluation of our method.
2
Related Work
Inner Product Estimation for Binary Vectors. Beyond linear sketching methods for estimating the inner product
between general real-valued vectors a and b, there has been a lot of prior work on the special case of binary vectors
with {0, 1} entries. For such vectors, approximating the inner product amounts to approximating the size of the
intersection of two sets. Concretely, any a, b ∈{0, 1}𝑛can be associated with sets A and B that contain integers
from {1, . . . ,𝑛}. We deﬁne A to contain all 𝑖for which a[𝑖] = 1, and similarly B to contain all 𝑖for which b[𝑖] = 1.
Note that ⟨a, b⟩= |A ∩B|.
Applying Fact 1, we know that a linear sketch of size 𝑚= 𝑂(1/𝜖2) can estimate ⟨a, b⟩up to additive error
𝜖∥a∥∥b∥= 𝜖
√︁
|A||B|. However, a better bound can be obtained using non-linear sketching methods based on the
classic MinHash sketch [Broder, 1997, Broder et al., 1998, Manber, 1994, Heintze, 1996], the 𝑘-minimum value (KMV)
sketch [Beyer et al., 2007], or related techniques [Li and König, 2010, Li et al., 2012]. With 𝑚= 𝑂(1/𝜖2) space,
such methods are achieve error 𝜖
√︁
max(|A|, |B|) · |A ∩B|, which is always smaller than 𝜖
√︁
|A||B| [Beyer et al.,
2007, Pagh et al., 2014]. For binary vectors, this bound was proven optimal in [Pagh et al., 2014].
Our work was motivated by this pre-existing result for binary vectors. In fact, our Theorem 2, is a strict
generalization of the bound to all real-valued vectors. When a and b are binary, we have that ∥aI∥2 = ∥bI∥2 = |A ∩B|.
So it is not hard to see that 𝜖
√︁
max(|A|, |B|) · |A ∩B| = 𝜖· max (∥aI∥∥b∥, ∥a∥∥bI∥), which is exactly our bound
from Theorem 2. We summarize how all prior inner product sketching methods compare to our result in Table 1.
Beyond Binary Vectors. There has been less work on obtaining better results for estimating inner products of
vectors with non-binary entries. One recent paper [Larsen et al., 2021] proves reﬁned bounds for the CountSketch
method that depend on the ℓ1 norm of a and b (instead of the Euclidean norm). These bounds can be tighter than
Fact 1 for some vectors, especially when the sketch size 𝑚is large. However, the results are not directly comparable
to ours.
We take a diﬀerent approach, moving beyond linear sketching entirely. Our main result is based on a class of
sketches that we collectively refer to as “Weighted MinHash” methods [Chi and Zhu, 2017, Shrivastava, 2016]. These
methods include weighted versions of coordinated random sampling [Cohen and Kaplan, 2007, Cohen and Kaplan,
2013], as well as the “Consistent Weighted Sampling” algorithm [Manasse et al., 2010, Gollapudi and Panigrahy,
2006] and its descendants, which are essentially equivalent, but computationally cheaper to apply [Ioﬀe, 2010, Wu
et al., 2019, Haeupler et al., 2014]. As shown in Section 4, Weighted MinHash sketches allows us to handle vectors
whose entries have highly varying magnitude (in contrast to binary vectors, where all non-zero entries have the same
magnitude of 1).
Weighted MinHash sketches have been used in a number of applications, including for approximating weighted
Jaccard similarity [Wu et al., 2019], for near-duplicate detection with weighted features [Manasse et al., 2010], for
approximating the distance between two vectors [Ioﬀe, 2010], and for sketching image histograms [Shrivastava,
2016]. In many of these applications, the weighted sketches empirically outperform unweighted sketches. Weighted
MinHash sketches have also been used to compute general “sum aggregate” queries, for which the inner product is a
5

---

Algorithm 1 Unweighted MinHash Sketch
Input: Length 𝑛vector a, sample number 𝑚, random seed 𝑠.
Output: Sketch 𝐻a = {𝐻ℎ𝑎𝑠ℎ
a
, 𝐻𝑣𝑎𝑙
a
}, where 𝐻ℎ𝑎𝑠ℎ
a
and 𝐻𝑣𝑎𝑙
a
have length 𝑚and contain values in [0, 1] and from a,
respectively
1: Initialize random number generator with seed 𝑠.
2: for i = 1, ..., m do
3:
Select uniformly random hash func. ℎ𝑖: {1, ...,𝑛} →[0, 1].
4:
Compute 𝑗∗= arg min𝑗∈{1,...,𝑛}, a[𝑗]≠0 ℎ𝑖(𝑗).
5:
Set 𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = ℎ𝑖(𝑗∗) and 𝐻𝑣𝑎𝑙
a
[𝑖] = a[𝑗∗]
6: end for
7: return {𝐻ℎ𝑎𝑠ℎ
a
, 𝐻𝑣𝑎𝑙
a
}
special case [Cohen and Kaplan, 2013]. However, we are not aware of strong worst-case error guarantees for the
above applications, let alone for the problem of general inner product estimation. Consistent Weighted Sampling
has also been used to approximate inner products in [Li, 2017], albeit using a diﬀerent estimator than in our work.
However, non-asymptotic worst-case guarantees are not provided.
Locality Sensitive Hashing. Finally, our problem of estimating inner products from sketches is closely related to
cosine similarity and maximum inner product search (MIPS), where the goal is to retrieve vectors from a database
with the highest cosine similarity (respectively, inner product) with a given query vector. One approach for solving
these problems is locality sensitive hashing [Gionis et al., 1999], and there are methods based on both MinHash and
random projections, like SimHash [Charikar, 2002]. It has been observed that MinHash often outperforms SimHash
for binary data, which parallels what was previously known for binary inner product estimation [Shrivastava and Li,
2014].
3
Warmup: Unweighted MinHash
Notation. We use bold letters to denote vectors, and for a vector a, a[𝑘] denotes the 𝑘th entry (indexing starts
with 1). For two length 𝑛vectors, a, b, ⟨a, b⟩= Í𝑛
𝑘=1 a[𝑘]b[𝑘] denotes the inner product. ∥a∥=
√︁
⟨a, a⟩denotes the
Euclidean norm and ∥a∥∞= max𝑘∈{1,...,𝑛} |a[𝑘]| denotes the inﬁnity norm. ∥a∥1 = Í𝑛
𝑘=1 |a[𝑘]| denotes the ℓ1 norm.
As is standard in the literature [Beyer et al., 2007], we assume access to uniformly random hash functions that map to
the real line. I.e., we assume that we can construct a random function ℎsuch that for any input 𝑗∈{1, . . . ,𝑛}, ℎ(𝑗) is
distributed uniformly and independently on the interval [0, 1]. In practice, ℎcan be replaced with a low-randomness
function that map to a suﬃcient large discrete set {1/𝑈, 2/𝑈. . . , 1}. Typically 𝑈is chosen to equal 𝑛𝑐for constant 𝑐
(e.g. 𝑐= 3) [Cormode et al., 2011]. We let Pr[𝐸] denote the probability that a random event 𝐸occurs, and 1[𝐸] is the
indicator random variable that evaluates to 1 if 𝐸occurs and to 0 otherwise. E[𝑋] and Var[𝑋] denote the expectation
and variance of a random variable 𝑋.
An unweighted method. Before introducing our Weighted MinHash sketching method, we review the unweighted
MinHash algorithm and prove a inner product estimation bound that can be obtained from this method. The bound
closely follows prior work on binary vectors [Beyer et al., 2007, Pagh et al., 2014] and only holds under strong
assumptions on the sketched vectors a and b – speciﬁcally that their entries are uniformly bounded in magnitude.
Nevertheless, it serves as a warmup for our main result, which is proven using a similar strategy, but eliminates the
assumption by using weighted sampling.
Given a vector a, we obtain an entry in the standard MinHash sketch (see e.g., [Broder, 1997]) by hashing the index
of every non-zero entry in a to the interval [0, 1]. We then store the smallest hash value. This process is repeated
𝑚times with independently chosen random hash functions. For binary vectors a and b with non-zero index sets
A = {𝑘: a[𝑘] ≠0} and B = {𝑘: b[𝑘] ≠0}, the minimum hash value alone can be used to estimate the Jaccard
similarity |A ∩B|/|A ∪B| or the union size |A ∪B| [Flajolet and Martin, 1985, Beyer et al., 2007, Kane et al., 2010].
For non-binary vectors, is it common to augment the standard MinHash sketch by also storing the value of the
index with minimum hash value. This idea is used in “coordinated sampling” or “conditional random sampling”
sketches [Cohen and Kaplan, 2013, Li et al., 2006, Cohen, 2016], and was recently used to extend MinHash and
the closely related 𝑘-minimum values (KMV) sketch to estimate vector correlations [Santos et al., 2021]. The basic
augmented MinHash sketching method is shown in Algorithm 1, which returns 𝐻ℎ𝑎𝑠ℎ
a
and 𝐻𝑣𝑎𝑙
a
as vectors of minimum
hashes and their corresponding vector values, respectively.
6

---

Algorithm 2 Unweighted MinHash Estimate
Input: Sketches 𝐻a = {𝐻ℎ𝑎𝑠ℎ
a
, 𝐻𝑣𝑎𝑙
a
}, 𝐻b = {𝐻ℎ𝑎𝑠ℎ
b
, 𝐻𝑣𝑎𝑙
b } constructed using Algorithm 1 with the same inputs 𝑚,𝑠.
Output: Estimate of ⟨a, b⟩.
1: Set ˜𝑈=
𝑚
Í𝑚
𝑖=1 min(𝐻ℎ𝑎𝑠ℎ
a
[𝑖],𝐻ℎ𝑎𝑠ℎ
b
[𝑖]) −1
2: return
˜𝑈
𝑚
Í𝑚
𝑖=1 1

𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖]

· 𝐻𝑣𝑎𝑙
a
[𝑖] · 𝐻𝑣𝑎𝑙
b
[𝑖]
For any single vector a, the augmented MinHash sketch 𝐻a contains a uniform subsample (collected with
replacement) of the non-zero values in a. This is because for all 𝑖∈{1, . . . ,𝑚} the minimum value of the 𝑖th hash is
equally likely to come from any of the indices with non-zero value. More importantly, sketch can be used to obtain a
uniform subsample from the intersection of a and b, i.e., from entries where both vectors are non-zero. This subsample
can in turn be used to estimate the sum ⟨a, b⟩= Í𝑛
𝑘=1 a[𝑘]b[𝑘], since a[𝑘]b[𝑘] only contributes to the sum if a[𝑘]
and b[𝑘] are both non-zero. Concretely, we have the following well-known fact:
Fact 3. Consider vectors a and b sketched using Algorithm 1 to produce sketches 𝐻a and 𝐻b. Deﬁne the sets A = {𝑖:
a[𝑖] ≠0} and B = {𝑖: b[𝑖] ≠0}. Then for all 𝑖∈{1, . . . ,𝑚} we have:
1. 𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖] with probability |A∩B |
|A∪B |.
2. If 𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖], then 𝐻𝑣𝑎𝑙
a
[𝑖] = a[𝑗] and 𝐻𝑣𝑎𝑙
b
[𝑖] = b[𝑗] for 𝑗chosen uniformly at random from A ∩B.
Fact 3 indicates that, to obtain a uniform subsample from the intersection of a and b, we can simply take all entries
in 𝐻𝑣𝑎𝑙
a
and 𝐻𝑣𝑎𝑙
b
where the corresponding entries in 𝐻ℎ𝑎𝑠ℎ
a
and 𝐻ℎ𝑎𝑠ℎ
b
are equal – and, as per (1), they will be equal
with good probability.
With Fact 3 in place, we describe an inner product estimator based on MinHash (Algorithm 2). This estimator will
serve as a template for our weighted MinHash estimator in the next section.
Consider the summation in line 2 of Algorithm 2. Using linearity of expectation and Fact 3, we can compute the
expectation:
E
" 𝑚
∑︁
𝑖=1
1
h
𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖]
i
· 𝐻𝑣𝑎𝑙
a
[𝑖] · 𝐻𝑣𝑎𝑙
b
[𝑖]
#
= 𝑚· E
h
1
h
𝐻ℎ𝑎𝑠ℎ
a
[1] = 𝐻ℎ𝑎𝑠ℎ
b
[1]
i
· 𝐻𝑣𝑎𝑙
a
[1] · 𝐻𝑣𝑎𝑙
b
[1]
i
= 𝑚·
∑︁
𝑗∈A∩B
1
|A ∪B| a[𝑗]b[𝑗] =
𝑚
|A ∪B| · ⟨a, b⟩.
It follows from the above that, if we multiplied the summation Í𝑚
𝑖=1 1

𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖]

· 𝐻𝑣𝑎𝑙
a
[𝑖] · 𝐻𝑣𝑎𝑙
b
[𝑖]
by |A∪B |
𝑚
, then we would have an unbiased estimate for ⟨a, b⟩, as desired. The only catch is that we do not know
|A ∪B|. This union size cannot be computed exactly from our sketches 𝐻a and 𝐻b. However, it can be estimated
using the same information contained in our MinHash sketches. In particular, since ℎ𝑖hashes uniformly to [0, 1],
𝑚
Í𝑚
𝑖=1 min(𝐻ℎ𝑎𝑠ℎ
a
[𝑖],𝐻ℎ𝑎𝑠ℎ
b
[𝑖]) −1 provides a good estimate for |A∪B|. This is actually a standard variant of the well-known
Flajolet-Martin distinct elements estimator [Flajolet and Martin, 1985, Beyer et al., 2007]. In Line 1 of Algorithm 2, we
set ˜𝑈equal to this estimator and we multiply by
˜𝑈
𝑚in Line 2 as a surrogate for |A∪B |
𝑚
. This gives our ﬁnal estimator
for ⟨a, b⟩.
Overall, we are able to prove the following concentration bound for the estimator for computing the inner product
between any pair of bounded vectors. For binary vectors, the constant 𝑐below equals 1 and we exactly recover the
bounds from prior work [Pagh et al., 2014].
Theorem 4 (Intermediate Result: Inner Product Sketching with Unweighted MinHash). Let 𝜖,𝛿∈(0, 1) be accuracy
and failure probability parameters and let 𝑚= 𝑂(log(1/𝛿)/𝜖2). There is an algorithm S that produces size-𝑚sketches
(Algorithm 1), along with an estimation procedure F , such that for any a, b ∈R𝑛with entries bounded in [−𝑐,𝑐], with
probability at least 1 −𝛿,
|F (S(a), S(b)) −⟨a, b⟩| ≤𝜖· 𝑐2 ·
√︁
max(|A|, |B|) · |A ∩B|
for A = {𝑖: a[𝑖] ≠0} and B = {𝑖: b[𝑖] ≠0}.
7

---

Algorithm 3 Weighted MinHash Sketch
Input: Length 𝑛vector a, sample number 𝑚, random seed 𝑠, integer discretization parameter 𝐿.
Output: Sketch 𝑊a = {𝑊ℎ𝑎𝑠ℎ
a
,𝑊𝑣𝑎𝑙
a
, ∥a∥}, where 𝑊ℎ𝑎𝑠ℎ
a
is a length 𝑚vector of values in [0, 1], 𝑊𝑣𝑎𝑙
a
is a length 𝑚
vector containing a subset of entries from a, and ∥a∥is a scalar, the Euclidean norm of a.
1: Initialize random number generator with seed 𝑠.
2: Set ˜a = Round(a/∥a∥, L) using Algorithm 4.
3: For each 𝑖∈{1, . . . ,𝑛}, let ¯a(𝑖) be a length 𝐿vector whose ﬁrst ˜a[𝑖]2 · 𝐿entries are set to ˜a[𝑖]. Set the remaining
entries to 0.
4: Let ¯a = [¯a(1), . . . , ¯a(𝑛)] be a length 𝑛· 𝐿vector obtained by concatenating the vectors deﬁned above.
5: for i = 1, ..., m do
6:
Select uniform random hash func. ℎ𝑖: {1, ...,𝑛𝐿} →[0, 1].
7:
Compute 𝑗∗= arg min𝑗∈{1,...,𝑛·𝐿}, ¯a[𝑗]≠0 ℎ𝑖(𝑗).
8:
Set 𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = ℎ𝑖(𝑗∗) and 𝑊𝑣𝑎𝑙
a
[𝑖] = ¯a[𝑗∗].
9: end for
10: return {𝑊ℎ𝑎𝑠ℎ
a
,𝑊𝑣𝑎𝑙
a
, ∥a∥}.
The full proof of Theorem 4 is included in Appendix A.1. It requires two technical ingredients. First, we must
bound the variance of an “ideal” estimator that uses the exact value of |A ∪B|. This can be done by using the fact
that a and b have entries bounded in [−𝑐,𝑐]. Second, we can bound the error introduced by replacing |A ∪B| with
an estimate for the union, as discussed above. To do so, we rely on the following standard result, which shows that
MinHash sketches for a and b can be used to compute a (1 ±𝜖) relative error approximation to the true union |A ∪B|
when 𝑚= 𝑂(1/𝜖2):
Lemma 1 (Union Size Estimator [Blum et al., 2020]). Let A and B be non-empty subsets of {1, . . . ,𝑛} and let
ℎ1, . . . ,ℎ𝑚: {1, . . . ,𝑛} →[0, 1] be independent, uniform random hash functions. For any 𝜖,𝛿∈(0, 1), if 𝑚= 𝑂

1
𝛿𝜖2

,
then with prob. at least 1 −𝛿, the estimator ˜𝑈=
𝑚
Í𝑚
𝑖=1 min𝑗∈A∪B ℎ𝑖(𝑗) −1 satisﬁes:
(1 −𝜖)|A ∪B| ≤˜𝑈≤(1 + 𝜖)|A ∪B|.
Note that, while it is written in a slightly diﬀerent way, the ˜𝑈in Lemma 1 is exactly equivalent to the ˜𝑈in
Algorithm 2 (when A and B contain the non-zero indices of a and b). To see why this is the case, note that
𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = min𝑗∈A ℎ𝑖(𝑗) and 𝐻ℎ𝑎𝑠ℎ
b
[𝑖] = min𝑗∈B ℎ𝑖(𝑗). So min

𝐻ℎ𝑎𝑠ℎ
a
[𝑖], 𝐻ℎ𝑎𝑠ℎ
b
[𝑖]

= min𝑗∈A∪B ℎ𝑖(𝑗).
4
Main Result: Weighted MinHash
The main technical challenge in our work is extending the results of the previous section (Theorem 4) to vectors
whose entries have highly varying magnitude. It is not hard to see that the simple MinHash method fails for such
vectors. For example, consider the extreme case when a and b both contain a very large values at some index 𝑖, so
large that the term a[𝑖]b[𝑖] dominates the inner product ⟨a, b⟩= Í𝑛
𝑘=1 a[𝑘]b[𝑘]. To correctly approximate the inner
product, we need to include a[𝑖] and b[𝑖] in our sketches for a and b, respectively. A MinHash sketch will only do so
with low probability, since it uniformly samples entries from the intersection of the vectors. Thus, it will obtain a
poor estimate for ⟨a, b⟩.
To address the issue with heavy entries, we modify the approach of Section 3 to incorporate non-uniform sampling
weights using a Weighted MinHash sketch [Manasse et al., 2010]. This allows us to sample high magnitude entries in
the vectors with higher probability. Speciﬁcally, our goal is to sample the 𝑖th entry of a with probability proportional
to the squared magnitude, a[𝑖]2. The Weighted MinHash sketch achieves non-uniform sampling in a simple way:
we construct an extended vector ¯a which has the same entries as a, but entries are repeated multiple times, with the
exact number of repetitions proportional to their magnitude. We then apply the standard MinHash sketch to ¯a. This
approach is detailed in Algorithm 3.
Rounding & Normalization. While Weighted MinHash allows us to sample entries with non-uniform probability,
another challenge arises: since sketches for a and b are computed independently, we no longer sample with the same
probability from both vectors. For b, Weighted MinHash samples indices with probability proportional to b[𝑖]2 instead
of a[𝑖]2. This mismatch can actually reduce the probability that we select entries from a and b with the same index.
8

---

Algorithm 4 Vector Rounding for Weighted MinHash
Input: Length 𝑛unit vector z, integer discretization parameter 𝐿.
Output: Length 𝑛unit vector ˜z with ˜z[𝑖]2 an integer multiple of 1/𝐿for all 𝑖.
1: For all 𝑖∈{1, . . . ,𝑛}, ˜z[𝑖] = sign(z[𝑖]) ·
√︃
⌊z[𝑖]2·𝐿⌋
𝐿
.
2: Let 𝑖∗= arg max𝑖∈1,...,𝑛|z[𝑖]|.
3: Fix 𝛿= 1 −∥˜z∥2, then set ˜z[𝑖∗] = sign(z[𝑖∗]) ·
√︁
˜z[𝑖∗]2 + 𝛿.
4: return ˜z.
Algorithm 5 Weighted MinHash Estimate
Input: Sketches𝑊a = {𝑊ℎ𝑎𝑠ℎ
a
,𝑊𝑣𝑎𝑙
a
, ∥a∥} and𝑊b = {𝑊ℎ𝑎𝑠ℎ
b
,𝑊𝑣𝑎𝑙
b
, ∥b∥} constructed using Algorithm 3 with the same
inputs 𝑚, 𝑠, and 𝐿.
Output: Estimate of ⟨a, b⟩.
1: For 𝑖∈{1, . . . ,𝑚}, set 𝑞𝑖= min

𝑊𝑣𝑎𝑙
a
[𝑖]2,𝑊𝑣𝑎𝑙
b
[𝑖]2
.
2: Set ˜𝑀= 1
𝐿·

𝑚
Í𝑚
𝑖=1 min(𝑊ℎ𝑎𝑠ℎ
a
[𝑖],𝑊ℎ𝑎𝑠ℎ
b
[𝑖]) −1

.
3: Set 𝐼=
˜𝑀
𝑚
Í𝑚
𝑖=1 1

𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖]

·
𝑊𝑣𝑎𝑙
a
[𝑖]·𝑊𝑣𝑎𝑙
b
[𝑖]
𝑞𝑖
.
4: return ∥a∥∥b∥· 𝐼
We are able to balance this issue with a normalization strategy. In particular, line 2 in Algorithm 3 performs a
simple but important preprocessing step that scales and rounds a to a unit vector ˜a whose squared entries are all
integer multiples of 1/𝐿for some large integer 𝐿(to be chosen later). The rounding handles a minor issue: since we
control the frequency with which each entry a[𝑖] is sampled by repetition, we need the squared value of all entries to
be integer multiples of the same ﬁxed constant in order to sample precisely with probability proportional to a[𝑖]2. As
will be proven, 𝐿can be chosen so that the discretization has little impact on the accuracy of our ﬁnal inner product
estimate, and the parameter also has no impact on the size of the sketch returned by Algorithm 1.4
The scaling is what deals with the bigger issue discussed above, which is the mismatch in sampling probabilities
between a and b. Surprisingly, we can show that the impact of this mismatch can be controlled when ∥a∥= ∥b∥. So
while it is possible to come up with examples where the algorithm fails if we directly sketch a and b, we can obtain a
worst-case bound by sketching a/∥a∥and b/∥b∥, approximating ⟨a/∥a∥, b/∥b∥⟩, and then post-multiplying the result
by ∥a∥∥b∥to get our ﬁnal estimator.
Deriving the Inner Product Estimator. We next motivate Algorithm 2, which is the algorithm used to estimate
⟨a, b⟩from our sketches. Note that Weighted MinHash Sketch (Algorithm 3) in fact returns an Unweighted MinHash
Sketch (Algorithm 1) for the expanded vectors ¯a, ¯b. So, we can apply Fact 3 to obtain the following:
Fact 5. Consider vectors a and b sketched using Algorithm 3 to produce 𝑊a and 𝑊b. Deﬁne A and B as in Fact 3. For all
𝑖∈{1, . . . ,𝑚} we have:
1. 𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖] with probability equal to the weighted Jaccard similarity, ¯𝐽=
Í𝑛
𝑗=1 min(˜a[𝑗]2,˜b[𝐽]2)
Í𝑛
𝑗=1 max(˜a[𝑗]2,˜b[𝑗]2) .
2. If𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖], then we have that𝑊𝑣𝑎𝑙
a
= ˜a[𝑗] and𝑊𝑣𝑎𝑙
b
= ˜b[𝑗] for 𝑗chosen from A ∩B with probability
equal to min(˜a[𝑗]2, ˜b[𝑗]2)/Í𝑛
𝑖=1 max(˜a[𝑗]2, ˜b[𝑗]2).
A proof of Fact 5 is given in Appendix A.2. With the statement in place, we present our procedure for estimating
⟨a, b⟩based the sketches computed by Algorithm 3. This procedure, shown in Algorithm 5, is reminiscent of our
estimator for unweighted sketches from the previous section. The only diﬀerence is that, since we are sampling with
non-uniform probabilities, we need to inversely weight samples in our sum to keep everything correct in expectation.
In particular, consider the sum in line 3 of the algorithm.
By Fact 5 and linearity of expectation, we have that:
4Note that our rounding method (Algorithm 4) is non-standard: It rounds all entries of the input vector down to smaller magnitude values,
except for the largest magnitude entry in the vector, which gets rounded up. This scheme allows us to achieve small relative error when rounding
and to avoid additive error depending on 1/𝐿.
9

---

E
" 𝑚
∑︁
𝑖=1
1
h
𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖]
i
·
𝑊𝑣𝑎𝑙
a
[𝑖] ·𝑊𝑣𝑎𝑙
b
[𝑖]
𝑞𝑖
#
𝑚· E
h
1
h
𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖]
ii
·
𝑊𝑣𝑎𝑙
a
[𝑖] ·𝑊𝑣𝑎𝑙
b
[𝑖]
𝑞𝑖
= 𝑚·
∑︁
𝑗∈A∩B
𝑞𝑗
Í𝑛
𝑖=1 max(˜a[𝑖]2, ˜b[𝑖]2)
˜a[𝑗] ˜b[𝑗]
𝑞𝑗
=
𝑚
Í𝑛
𝑖=1 max(˜a[𝑖]2, ˜b[𝑖]2)
· ⟨˜a, ˜b⟩.
So, we have obtained an estimator that in expectation is equal to ⟨˜a, ˜b⟩, multiplied by 𝑚over a term 𝑀=
Í𝑛
𝑖=1 max(˜a[𝑗]2, ˜b[𝑗]2). This term 𝑀is referred to as the weighted union size between the vectors. We can multiply
by 𝑀
𝑚to obtain an unbiased estimator for ⟨˜a, ˜b⟩. Since ˜a and ˜b were obtained by scaling a and b inversely by their
Euclidean norms (ignoring the eﬀect of rounding for now), our ﬁnal estimator in Line 4 of Algorithm 5 multiplies by
∥a∥∥b∥. The values of ∥a∥and ∥b∥are stored explicitly in the sketches for a and b, respectively (as just one extra
number per sketch).
The formal analysis of Algorithm 5, which yields Theorem 2, is included in Appendix A.2. It contains three
parts. First, when analyzing the unweighted estimator, we do not know 𝑀exactly, so must estimate it. We can
take advantage of the fact that 𝑀is exactly equal to the unweighted union size | ¯
A ∪¯B| between the non-zero
index sets ¯
A and ¯B of the expanded vectors ¯a and ¯b constructed in Algorithm 3. We can apply Lemma 1 directly
to obtain an estimator, which is denoted as ˜𝑀in Algorithm 5. Second, we need to analyze the variance of the sum
Í𝑚
𝑖=1 1

𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖]

·
𝑊𝑣𝑎𝑙
a
[𝑖]·𝑊𝑣𝑎𝑙
b
[𝑖]
𝑞𝑖
. This analysis uses the fact that ˜a and ˜b are unit vectors. Third, we
need to rigorously analyze the impact of the rounding procedure performed in Line 2 of Algorithm 3 to establish that
a good estimate for ⟨˜a, ˜b⟩actually yields a good estimate for ⟨a/∥a∥, b/∥b∥⟩=
1
∥a∥∥b∥⟨a, b⟩.
We conclude by noting that our ﬁnal analysis of Algorithm 5 requires setting 𝐿to be on the order of 𝑛6/𝜖2 when
sketching using Algorithm 3. This may sound large, but note that the parameter has no impact on the size of the
sketches returned by Algorithm 3, or on the runtime of our estimation procedure Algorithm 5. 𝐿does impact the
runtime of Algorithm 3, but as discussed in Section 5, prior work can be used to implement the Weighted MinHash
sketching method so that it has a logarithmic dependence on 𝐿– i.e., on 𝑂(log(𝑛/𝜖)).
5
Experiments
To support the results presented in Section 4, we performed an experimental evaluation using synthetic data and
real-world datasets.
Baselines. We compare our Weighted MinHash approach against 4 baseline methods, 2 linear and 2 sampling-based,
with the goal of evaluating the trade-oﬀbetween sketch size and accuracy in estimating inner products. Those
methods are:
Johnson-Lindenstrauss Projection (JL): equivalent to the AMS sketch [Alon et al., 1999b, Achlioptas, 2003]. Uses
a random matrix 𝚷with scaled ±1 entries (Fact 1).
CountSketch (CS): classic linear sketch introduced in [Charikar et al., 2002], and corresponds to multiplication with
a 𝚷that has sparse random entries. We follow the implementation in [Larsen et al., 2021], using 5 repetitions of the
sketch and taking the median to improve performance.
MinHash Sampling (MH): method described in Algorithm 1; we use a single sketch without any median estimate.
𝑘-Minimum Values Sampling (KMV): sampling-based sketch closely related to MinHash, but it draws samples
from the vector being sketched without replacement. It can also be used to estimate union size. We follow the
implementations from [Beyer et al., 2007] and [Santos et al., 2021].
Weighted MinHash Sampling (WMH): our method described in Algorithm 3; we use a single sketch without any
median estimate.
10

---

Storage Size. For linear sketches, we store the output of the matrix multiplication 𝚷a as 64-bit doubles. We also
store𝑊𝑣𝑎𝑙
a
and 𝐻𝑣𝑎𝑙
a
as 64-bit doubles. Since sampling-based sketches need to store hash values (which in our case are
32-bit ints), a sampling-based sketch with 𝑚samples takes 1.5𝑥as much space as a JL sketch with 𝑚rows. In our
experiments, we plot storage size which denotes the total number of bits in the sketch divided by 64, i.e., the total
number of 64-bit doubles (or equivalent) used in the sketch. Standard quantization tricks could likely be used to
reduce the size of numbers in all sketches (linear and sampling), but we leave the development of such methods to
future work. As a starting point, we note that there has already been interesting work on quantized JL projections
[Jacques, 2015, Li et al., 2016], and the SimHash method for estimating cosine similarity can be viewed as a “1-bit”
quantization of a JL sketch [Charikar, 2002].
Estimation Error. For all plots, we report the absolute diﬀerence between ⟨a, b⟩and the estimate, divided by ∥a∥∥b∥.
This is the term appearing on the right-hand side of the accuracy guarantee for linear sketches Fact 1, so this scaling
roughly ensures that errors are between 0 and 1, making it easier to compare across diﬀerent datasets. We always
report average error over 10 independent trials.
Choice of 𝐿. Note that the choice of 𝐿in Algorithm 3 does not impact the size of our ﬁnal sketch, so in general, it
should be set as large as possible. Our bounds from Lemma 3 that suggest 𝐿should be set ≥𝑛6 are likely loose (we did
not attempt to optimize polynomial factors), but we did ﬁnd that it is necessary to at least ensure that 𝐿> 𝑛. Ideally it
should be larger by a multiplicative factor 100 or 1000. The reason for this is that, if a is dense and is normalized
to have unit norm, as in Algorithm 1, most of its entries could have squared value < 1/𝑛(as the average value of a
squared entry in a unit norm vector is always 1/𝑛). If we set 𝐿< 1/𝑛, then any entries with value < 1/𝑛would get
rounded to 0, which could negatively impact the accuracy of an inner product estimate.
Eﬃcient Weighted Hashing. When 𝐿is large, a naive implementation of Algorithm 3 would be prohibitively slow.
The “extended” vector ¯a has length 𝑛· 𝐿and we must apply a hash function to every non-zero entry in that vector.
Let A = {𝑖: a[𝑖] ≠0} as before, so |A| is equal to the number of non-zero values in a. If each hash computation is
considered unit cost, this amounts to a runtime of 𝑂(|A|𝑚· 𝐿), which is too large, since 𝐿is chosen larger than 𝑛.
Fortunately, it is possible to improve this cost to 𝑂(|A|𝑚· log 𝐿) = 𝑂(|A|𝑚· log𝑛) using techniques for speeding
up weighted MinHash sketches. Such techniques have been heavily studied in recent years [Ioﬀe, 2010, Wu et al.,
2019, Haeupler et al., 2014, Shrivastava, 2016]. The savings are signiﬁcant, reducing the computation cost of sketching
to nearly-linear in the size of the input for each of our 𝑚samples. Among faster methods, we speciﬁcally employ the
simple “active index” technique, which was ﬁrst introduced in [Gollapudi and Panigrahy, 2006]. The rough idea is
that, when hashing non-zero entries in a particular length 𝐿block of ¯a, there is no need to hash all non-zero indices
in that block. We can skip over large sections of indices by observing that if 𝑧is the minimum hash value generated
so far, the next index where a lower hash value will be seen is a distributed as a geometric random variable with
parameter 𝑧. We can sample from the geometric distribution eﬃciently (e.g. using a built-in Python routine) and skip
ahead to that index. It is possible to prove that the expected cost of this approach is just 𝑂(log 𝐿) per block. See the
exposition in [Manasse et al., 2010] for further details.
Since initially releasing this paper, we became aware of even faster implementations of weighted MinHash that
reduce the runtime to 𝑂(|A|+𝑚log𝑚), which is nearly linear in the number of non-zeros in the vector being sketched
[Ertl, 2018, Christiani, 2020]. Such methods should be able to be adapted for use in our inner product sketching
application, although we leave further exploration to future work.
Choice of Hash Function. In practice we cannot obtain a truly uniform random hash function from {1, . . . ,𝑛} to
the reals, so we must use an approximation. In our experiments, we employ a standard 2-wise independent hash
function (linear function with random coeﬃcients) that maps from {1, . . . ,𝑛} to {1, . . . , 𝑝} for a 31-bit prime 𝑝[Carter
and Wegman, 1979]. 5 We then use as our hash value ℎ(𝑖)/𝑝, which is a number between 0 and 1. Since 𝑝is chosen to
have 31 bits, we can store the value of ℎ(𝑖) in our sketch using a standard 32-bit int.
5.1
Synthetic Data
We begin with an evaluation of our approach using synthetic data. We generate length 10000 vectors a and b, each
with 2000 non-zero entries. The ratio of non-zero entries that overlap, i.e., are non-zero in both a and b, is adjusted to
simulate diﬀerent practical settings with diﬀerent levels of joinability between tables (see Section 1.2). The non-zero
entries in a and b are normal random variables with values between −1 and 1, except 10% of entries are chosen
randomly as outliers and set to random values between 20 and 30.
5Our choice to use a 2-wise independent hash function was based on prior implementations of the weighted MinHash method [Wu et al., 2020]
that do so.
11

---

(a) 1% overlap
(b) 5% overlap
(c) 10% overlap
(d) 50% overlap
Figure 4: Inner product estimation (synthetic data).
Results for varying amounts of overlap are reported in Figure 4. They closely align with our theoretical ﬁndings:
when the overlap is small, the bounds for Weighted MinHash are signiﬁcantly better than those of linear sketching
methods. Accordingly, WMH outperforms all other methods for overlap ratio ≤10%. Note that unweighted sampling
based sketches also outperform linear sketches for very low overlap (1%). But as the overlap increases, the advantage
brought about by Theorem 2 over Fact 1 decreases. We can see this in Figure 4(d): at 50% overlap, the performance of
linear sketching is comparable to that of Weighted MinHash.
5.2
Real-World Data
Assessing the Eﬀect of Overlap and Outliers. Using sketches of size 400,6 we estimate the inner product between
5000 pairs of numerical columns from 56 datasets published by the World Bank Group [World Bank, 2022]. We
normalize columns to have norm 1 so that all inner products have magnitude less than 1. We visual results using
a winning table in Figure 5, ﬁlting vector pairs based on diﬀerent overlap ratios (column) and kurtosis values, a
measure of outliers (row). Each cell shows the average error diﬀerence (WMH estimation error minus the error of
other method) for vector pairs with the speciﬁed overlap and kurtosis values.
The blue cells (negative diﬀerence) correspond to combinations in which WMH outperforms the other methods,
while the red cells (positive diﬀerence) represent combinations in which the other methods win. The darker the cells,
6The size was chosen empirically. Our goal here is to simulate the real-world situation where a ﬁxed parameter must be selected for a given
application.
12

---

(a) WMH estimation error minus JL estimation error.
(b) WMH estimation error minus MH estimation error.
Figure 5: Inner product estimation (World Bank data). Diﬀerent shades of blue highlight combinations for which
WMH outperforms the other methods.
100
200
300
400
Storage Size
0.025
0.050
0.075
0.100
0.125
Average Difference
(a) All Documents
100
200
300
400
Storage Size
0.025
0.050
0.075
0.100
0.125
0.150
Average Difference
(b) Documents > 700 words
Figure 6: Text similarity estimation (20 Newsgroups dataset). Note that in the left plot, the lines for MH, WMH, and
KMV all lie essentially on top of one another.
the bigger the diﬀerence. A high kurtosis often indicates the presence of outliers, which will, based on our theoretical
results, present a diﬃculty for unweighted sampling methods like MH in comparison to JL or our WMH method.
This is supported by the experiments, which show that WMH has a great improvement over MH when kurtosis is
high (up to -.031 vs. at most -.020 when kurtosis is low). As predicted by Theorem 2 and shown in our synthetic
experiments, WMH also has a great edge over JL for low overlap values. For large overlaps (greater than .75), JL leads
to slightly smaller errors (from 0.003 to 0.006).
This suggests that WMH provides a good compromise for applications in which the distribution of data is unknown:
it provides much better estimates for many cases, and when it does not, its estimates are comparable to the best results
from existing sketching methods.
Document Similarity Estimation. We also evaluated the performance of WMH sketches for text similarity
estimation using the 20 newsgroups dataset [Mitchell, 1997]. We represent each document as a vector in which each
entry represents a term or a combination of 2 terms (bigrams), and is associated with a value that encodes term/bigram
importance using TF-IDF weights [Salton et al., 1975]. This setting is well-known for generating sparse vectors
of very high dimension. As a similarity measure, we use the cosine, which is equal to an inner product when the
vectors have are normalized. We sampled 700 documents and estimated the cosine similarity for over 200,000 pairs of
documents. The results in Fig. 6 show that, similar to previous experiments, in the worst case, the accuracy of WMH is
comparable to the other methods, but it can sometimes be better by a large margin. In this case, it performs better for
documents containing more than 700 words. Note that linear projection sketches have poor performance for small
sketches even when the documents are small, whereas our sampling-based methods are able to obtain signiﬁcantly
13

---

better accuracy for the same storage budget. Finally, also note that the Unweighted MinHash (MH) performs poorly
for long documents whereas the weighted version still performs well.
Acknowledgements. This work was supported by the DARPA D3M program and NSF awards ISS-2106888 and CCF-
2046235. Aline Bessa was supported by a 2021 CRA/CCC CIFellows Award. Cameron Musco was also supported by a
Google Research Scholar Award. Any opinions, ﬁndings, conclusions or recommendations expressed in this material
are those of the authors and do not necessarily reﬂect the views of NSF, DARPA, or other funding organizations.
References
[Achlioptas, 2003] Achlioptas, D. (2003). Database-friendly random projections: Johnson-Lindenstrauss with binary
coins. J. Comput. Syst. Sci., 66(4):671–687.
[Alon et al., 1999a] Alon, N., Gibbons, P. B., Matias, Y., and Szegedy, M. (1999a). Tracking join and self-join sizes in
limited storage. In Proceedings of the 18th Symposium on Principles of Database Systems (PODS).
[Alon and Klartag, 2017] Alon, N. and Klartag, B. (2017). Optimal compression of approximate inner products and
dimension reduction. In Proceedings of the 58th Annual IEEE Symposium on Foundations of Computer Science (FOCS),
pages 639–650.
[Alon et al., 1999b] Alon, N., Matias, Y., and Szegedy, M. (1999b). The space complexity of approximating the
frequency moments. Journal of Computer and System Sciences, 58(1).
[Arriaga and Vempala, 2006] Arriaga, R. I. and Vempala, S. (2006). An algorithmic theory of learning: Robust concepts
and random projection. Machine Learning, 63(2):161–182.
[Beyer et al., 2007] Beyer, K., Haas, P. J., Reinwald, B., Sismanis, Y., and Gemulla, R. (2007). On synopses for distinct-
value estimation under multiset operations. In Proceedings of the 2007 ACM SIGMOD International Conference on
Management of Data, pages 199–210.
[Blum et al., 2020] Blum, A., Hopcroft, J., and Kannan, R. (2020). Foundations of Data Science. Cambridge University
Press.
[Broder, 1997] Broder, A. (1997). On the resemblance and containment of documents. In Proceedings. Compression
and Complexity of SEQUENCES 1997, pages 21–29.
[Broder et al., 1998] Broder, A. Z., Charikar, M., Frieze, A. M., and Mitzenmacher, M. (1998). Min-wise independent
permutations (extended abstract). In Proceedings of the 30th Annual ACM Symposium on Theory of Computing
(STOC), pages 327–336.
[Carter and Wegman, 1979] Carter, J. L. and Wegman, M. N. (1979). Universal classes of hash functions. Journal of
Computer and System Sciences, 18(2):143–154.
[Charikar, 2002] Charikar, M. (2002). Similarity estimation techniques from rounding algorithms. In Proceedings of
the 34th Annual ACM Symposium on Theory of Computing (STOC), pages 380–388.
[Charikar et al., 2002] Charikar, M., Chen, K., and Farach-Colton, M. (2002). Finding frequent items in data streams.
In Proceedings of the 29th International Colloquium on Automata, Languages and Programming (ICALP), pages
693–703.
[Chi and Zhu, 2017] Chi, L. and Zhu, X. (2017). Hashing techniques: A survey and taxonomy. ACM Comput. Surv.,
50(1).
[Christiani, 2020] Christiani, T. (2020). Dartminhash: Fast sketching for weighted sets. arXiv:2005.11547.
[City of New York, 2022] City of New York (2022). Open Data NYC. https://opendata.cityofnewyork.us/.
[Cohen, 2016] Cohen, E. (2016). Min-Hash Sketches, pages 1282–1287. Springer New York, New York, NY.
[Cohen and Kaplan, 2007] Cohen, E. and Kaplan, H. (2007). Summarizing data using bottom-k sketches. In Proceedings
of the 2007 ACM Symposium on Principles of Distributed Computing (PODC), pages 225–234.
14

---

[Cohen and Kaplan, 2013] Cohen, E. and Kaplan, H. (2013). What you can do with coordinated samples. In Proceedings
of the 16th International Workshop on Approximation Algorithms for Combinatorial Optimization Problems (APPROX),
pages 452–467.
[Cormode et al., 2011] Cormode, G., Garofalakis, M., Haas, P., and Jermaine, C. (2011). Synopses for Massive Data:
Samples, Histograms, Wavelets, Sketches. Foundations and Trends in Databases. NOW publishers.
[Dasgupta and Gupta, 2003] Dasgupta, S. and Gupta, A. (2003). An elementary proof of a theorem of johnson and
lindenstrauss. Random Structures & Algorithms, 22(1):60–65.
[Ertl, 2018] Ertl, O. (2018). Bagminhash - minwise hashing algorithm for weighted sets. In Proceedings of the 24th
ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (KDD), pages 1368–1377.
[Fernandez et al., 2019] Fernandez, R. C., Min, J., Nava, D., and Madden, S. (2019). Lazo: A cardinality-based method
for coupled estimation of Jaccard similarity and containment. In Proceedings of the 35th IEEE International Conference
on Data Engineering (ICDE), pages 1190–1201.
[Flajolet and Martin, 1985] Flajolet, P. and Martin, G. N. (1985). Probabilistic counting algorithms for data base
applications. J. Comput. Syst. Sci., 31(2):182–209.
[Gionis et al., 1999] Gionis, A., Indyk, P., and Motwani, R. (1999). Similarity search in high dimensions via hashing.
In Proceedings of the 25th International Conference on Very Large Data Bases, pages 518–529.
[Gollapudi and Panigrahy, 2006] Gollapudi, S. and Panigrahy, R. (2006). Exploiting asymmetry in hierarchical topic
extraction. In Proceedings of the 15th ACM International Conference on Information and Knowledge Management
(CIKM), pages 475–482.
[Haeupler et al., 2014] Haeupler, B., Manasse, M., and Talwar, K. (2014). Consistent weighted sampling made fast,
small, and easy. arXiv:1410.4266.
[Heintze, 1996] Heintze, N. (1996). Scalable document ﬁngerprinting. In USENIX Workshop on Electronic Commerce.
[Ioﬀe, 2010] Ioﬀe, S. (2010). Improved consistent sampling, weighted minhash and l1 sketching. In Proceedings of the
2010 IEEE International Conference on Data Mining (ICDM), pages 246–255.
[Jacques, 2015] Jacques, L. (2015). A quantized johnson–lindenstrauss lemma: The ﬁnding of buﬀon’s needle. IEEE
Trans. Inf., 61(9):5012–5027.
[Kane et al., 2010] Kane, D. M., Nelson, J., and Woodruﬀ, D. P. (2010). An optimal algorithm for the distinct elements
problem. In Proceedings of the 29th Symposium on Principles of Database Systems (PODS), pages 41–52.
[Kanter and Veeramachaneni, 2015] Kanter, J. M. and Veeramachaneni, K. (2015). Deep feature synthesis: Towards
automating data science endeavors. In 2015 IEEE international conference on data science and advanced analytics
(DSAA), pages 1–10. IEEE.
[Larsen and Nelson, 2017] Larsen, K. G. and Nelson, J. (2017). Optimality of the johnson-lindenstrauss lemma. In
Proceedings of the 58th Annual IEEE Symposium on Foundations of Computer Science (FOCS), pages 633–638.
[Larsen et al., 2021] Larsen, K. G., Pagh, R., and Tětek, J. (2021). CountSketches, feature hashing and the median of
three. In Proceedings of the 38th International Conference on Machine Learning (ICML), pages 6011–6020.
[Lehmberg et al., 2015] Lehmberg, O., Ritze, D., Ristoski, P., Meusel, R., Paulheim, H., and Bizer, C. (2015). The
mannheim search join engine. Journal of Web Semantics, 35:159 – 166.
[Li, 2017] Li, P. (2017). Linearized gmm kernels and normalized random fourier features. In Proceedings of the 23rd
ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (KDD), page 315–324.
[Li et al., 2006] Li, P., Church, K., and Hastie, T. (2006). Conditional random sampling: A sketch-based sampling
technique for sparse data. In Advances in Neural Information Processing Systems 19 (NeurIPS), volume 19.
15

---

[Li and König, 2010] Li, P. and König, A. C. (2010). b-bit minwise hashing. In Proceedings of the 19th International
World Wide Web Conference (WWW).
[Li et al., 2016] Li, P., Mitzenmacher, M., and Slawski, M. (2016). Quantized random projections and non-linear
estimation of cosine similarity. In Advances in Neural Information Processing Systems 29 (NeurIPS), volume 29.
[Li et al., 2012] Li, P., Owen, A., and Zhang, C.-h. (2012). One permutation hashing. In Advances in Neural Information
Processing Systems 25 (NeurIPS).
[Li et al., 2011] Li, P., Shrivastava, A., Moore, J., and König, A. (2011). Hashing algorithms for large-scale learning.
Advances in Neural Information Processing Systems 24 (NeurIPS), 24.
[Manasse et al., 2010] Manasse, M., McSherry, F., and Talwar, K. (2010). Consistent weighted sampling. Technical
Report MSR-TR-2010-73.
[Manber, 1994] Manber, U. (1994). Finding similar ﬁles in a large ﬁle system. In USENIX Winter 1994 Technical
Conference.
[Mitchell, 1997] Mitchell, T. (1997).
20 newsgroups dataset.
https://scikit-learn.org/stable/modules/
generated/sklearn.datasets.fetch_20newsgroups.html.
[Pagh et al., 2014] Pagh, R., Stöckel, M., and Woodruﬀ, D. P. (2014). Is min-wise hashing optimal for summarizing set
intersection? In Proceedings of the 33rd Symposium on Principles of Database Systems (PODS), pages 109–120.
[Rusu and Dobra, 2008] Rusu, F. and Dobra, A. (2008). Sketches for size of join estimation. ACM Transactions on
Database Systems (TODS), 33(3):1–46.
[Salton et al., 1975] Salton, G., Wong, A., and Yang, C.-S. (1975). A vector space model for automatic indexing.
Communications of the ACM, 18(11):613–620.
[Santos et al., 2021] Santos, A., Bessa, A., Chirigati, F., Musco, C., and Freire, J. (2021). Correlation sketches for approx-
imate join-correlation queries. In Proceedings of the 2021 ACM SIGMOD International Conference on Management of
Data, pages 199–210.
[Santos et al., 2022] Santos, A., Bessa, A., Musco, C., and Freire, J. (2022). A sketch-based index for correlated dataset
search. In Proceedings of the 38th IEEE International Conference on Data Engineering (ICDE), pages 2928–2941. IEEE.
[Shrivastava, 2016] Shrivastava, A. (2016). Simple and eﬃcient weighted minwise hashing. In Advances in Neural
Information Processing Systems 29 (NeurIPS), pages 1506–1514.
[Shrivastava and Li, 2014] Shrivastava, A. and Li, P. (2014). In Defense of Minhash over Simhash. In Proceedings of
the 17th International Conference on Artiﬁcial Intelligence and Statistics (AISTATS).
[World Bank, 2022] World Bank (2022). World bank group ﬁnances.
[Wu et al., 2020] Wu, W., Li, B., Chen, L., Gao, J., and Zhang, C. (2020). A Review for Weighted Minhash Algorithms.
IEEE Trans. Knowl. Data Eng., pages 1–1.
[Wu et al., 2019] Wu, W., Li, B., Chen, L., Zhang, C., and Yu, P. S. (2019). Improved consistent weighted sampling
revisited. IEEE Trans. Knowl. Data Eng., 31(12):2332–2345.
[Yang et al., 2019] Yang, Y., Zhang, Y., Zhang, W., and Huang, Z. (2019). Gb-kmv: An augmented kmv sketch for
approximate containment similarity search. In Proceedings of the 35th IEEE International Conference on Data
Engineering (ICDE), pages 458–469. IEEE.
[Zhu et al., 2019] Zhu, E., Deng, D., Nargesian, F., and Miller, R. J. (2019). Josie: Overlap set similarity search
for ﬁnding joinable tables in data lakes. In Proceedings of the 2019 ACM SIGMOD International Conference on
Management of Data, pages 847–864.
[Zhu et al., 2016] Zhu, E., Nargesian, F., Pu, K. Q., and Miller, R. J. (2016). Lsh ensemble: Internet-scale domain search.
Proceedings of the VLDB Endowment, 9(12).
16

---

A
Additional Proofs
A.1
Unweighted MinHash Analysis
In this section, we give a full proof of Theorem 4.
Proof of Theorem 4. Let F (𝐻a, 𝐻b) denote the estimator from Algorithm 2. Ultimately we will set F in Theorem 4 to
be F , but repeated 𝑂(log(1/𝛿) times to obtain failure probability 1 −𝛿.
We focus on showing ﬁrst that F (𝐻a, 𝐻b) achieves error 𝜖· 𝑐2 ·
√︁
max(|A|, |B|) · |A ∩B| with probability ≥2/3.
To prove this, let F ∗(𝐻a, 𝐻b) be an alternative idealized estimator where we replace ˜𝑈in line 1 of Algorithm 2 with
the true union size 𝑈= |A ∪B|:
F ∗(𝐻a, 𝐻b) = 𝑈
𝑚
𝑚
∑︁
𝑖=1
1
h
𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖]
i
· 𝐻𝑣𝑎𝑙
a
[𝑖] · 𝐻𝑣𝑎𝑙
b
[𝑖].
We will ﬁrst analyze F ∗, before showing that F obtains essentially as good of an estimate. As established in Section 3,
using the properties of Fact 3, we have that
E [F ∗(𝐻a, 𝐻b)] = 𝑈·
1
|A ∪B| · ⟨a, b⟩= ⟨a, b⟩.
So we turn to bounding the variance of the estimator. Deﬁne the random variable 𝑍𝑖= 1

𝐻ℎ𝑎𝑠ℎ
a
[𝑖] = 𝐻ℎ𝑎𝑠ℎ
b
[𝑖]

·
𝐻𝑣𝑎𝑙
a
[𝑖] · 𝐻𝑣𝑎𝑙
b
[𝑖] and note that F ∗(𝐻a, 𝐻b) = 𝑈
𝑚
Í𝑚
𝑖=1 𝑍𝑖. From Fact 3 we have:
𝑍𝑖=
(
0
with probability 1 −|A∩B |
|A∪B |
a[𝑗]b[𝑗]
with probability
1
|A∪B | for all 𝑗∈A ∩B.
Since each 𝑍𝑖is independent, we can bound:
Var [F ∗(𝐻a, 𝐻b)] = 𝑈2
𝑚2
𝑚
∑︁
𝑖=1
Var [𝑍𝑖] .
Using our assumption that a[𝑘], b[𝑘] ≤𝑐for all 𝑘, we have
Var [𝑍𝑖] ≤E

𝑍2
𝑖

=
∑︁
𝑗∈A∩B
1
|A ∪B| · a[𝑗]2b[𝑗]2 ≤𝑐4 · |A ∩B|
|A ∪B|,
for all 𝑍𝑖. So we conclude that Var [F ∗(𝐻a, 𝐻b)] ≤1
𝑚·𝑐4 · |A ∩B||A ∪B|. We then plug our expectation and variance
bounds into Chebyhev’s inequality. If 𝑚= 𝑂(1/𝜖2), we conclude that with probability ≥5/6,
|F ∗(𝐻a, 𝐻b) −⟨a, b⟩| ≤𝜖· 𝑐2√︁
|A ∩B||A ∪B|.
(1)
The proof is almost complete; we just need to extend this bound to the non-idealized estimator F =
˜𝑈
𝑈· F ∗. We
do so by observing that ˜𝑈is a good approximation to 𝑈. Speciﬁcally, by Lemma 1 applied with 𝛿= 1/6, we have that,
when 𝑚= 𝑂(1/𝜖2), (1 −𝜖)𝑈≤˜𝑈≤(1 + 𝜖)𝑈, with probability ≥5/6. It follows that
(1 −𝜖)F ∗(𝐻a, 𝐻b) ≤F (𝐻a, 𝐻b) ≤(1 + 𝜖)F ∗(𝐻a, 𝐻b).
(2)
By a union bound, with probability at least 2/3, both (1) and (2) hold simultaneously. Finally, by triangle inequality
and the fact that ⟨𝑎,𝑏⟩≤𝑐2|A ∩B| ≤𝑐2√︁
|A ∩B||A ∪B| it follows that:
|F (𝐻a, 𝐻b) −⟨a, b⟩| ≤3𝜖· 𝑐2 ·
√︁
|A ∩B||A ∪B|.
Noting that |A ∩B||A ∪B| ≤2 max(|A|, |B|) · |A ∩B| and adjusting 𝜖by a constant factor, we thus have that
when 𝑚= 𝑂(1/𝜖2), F (𝐻a, 𝐻b) satisﬁes the guarantee of Theorem 4 with probability at least 2/3. To boost success
probability to 1 −𝛿, we can use the exact same median-trick used in the proof of Theorem 2: instead of computing
a single pair of sketches 𝐻a, 𝐻b for inputs a, b, we concatenate 𝑂(log(1/𝛿)) sketches, each constructed using an
independent random seed. If we apply F to each pair of independent sketches and return the median estimate for
⟨a, b⟩, with probability at least 1 −𝛿, it will satisfy our desired guarantee.
□
17

---

A.2
Weighted MinHash Analysis
In this section we complete the analysis of Algorithm 5 introduced in Section 4, which yields our main result,
Theorem 2. We start with a formal proof of Fact 5, which is the weighted analog of Fact 3.
Proof of Fact 5. Let ¯
A = {𝑖: ¯a[𝑖] ≠0} and ¯B = {𝑖: ¯b[𝑖] ≠0}. Since ¯a, ¯b are each comprised of 𝑛blocks of 𝐿elements,
with the ﬁrst ˜a[𝑖]2 · 𝐿entries and ˜b[𝑖]2 · 𝐿entries in the 𝑖th block set to be nonzero, we have the following equalities:
| ¯
A ∩¯B| = 𝐿·
𝑛
∑︁
𝑗=1
min(˜a[𝑗]2, ˜b[𝑗]2)
(3)
| ¯
A ∪¯B| = 𝐿·
𝑛
∑︁
𝑗=1
max(˜a[𝑗]2, ˜b[𝑗]2).
(4)
Since Wℎ𝑎𝑠ℎ
a
[𝑖] and Wℎ𝑎𝑠ℎ
b
[𝑖] are constructed exactly as unweighted MinHash sketches of ¯a, ¯b, by claim (1) of Fact 3,
Wℎ𝑎𝑠ℎ
a
[𝑖] = Wℎ𝑎𝑠ℎ
b
[𝑖] with probability | ¯
A∩¯B |
| ¯
A∪¯B | = ¯𝐽. This gives claim (1).
To prove claim (2) we note that it is equivalent to claiming that, unconditional on whether or not Wℎ𝑎𝑠ℎ
a
[𝑖] =
Wℎ𝑎𝑠ℎ
b
[𝑖], 𝑊𝑣𝑎𝑙
a
= ˜a[𝑗] and 𝑊𝑣𝑎𝑙
b
= ˜b[𝑗] for some shared 𝑗∈A ∩B with probability
min(˜a[𝑗]2,˜b[𝑗]2)
Í𝑛
𝑖=1 max(˜a[𝑗]2,˜b[𝑗]2) . To
prove this statement, we use that, by Fact 3, for any ℓ∈
¯
A ∩¯B, 𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖] = ℎ𝑖(ℓ), W𝑣𝑎𝑙
a [𝑖] = ¯a[ℓ],
and W𝑣𝑎𝑙
b [𝑖] = ¯b[ℓ] with probability
1
| ¯
A∪¯B | =
1
𝐿Í𝑛
𝑘=1 max(˜a[𝑘]2,˜b[𝑘]2) . Now, by construction (line 3 of Algorithm 3),
¯a[ℓ] = ˜a[𝑗] and ¯b[ℓ] = ˜b[𝑗] whenever ℓlies in the 𝑗th length 𝐿block of entries in ¯a. For a given 𝑗, the number of
values of ℓfor which ¯a[ℓ] = ˜a[𝑗], ¯b[ℓ] = ˜b[𝑗] is exactly 𝐿· min(˜a[𝑗]2, ˜b[𝑗]2). Thus, summing over these entries,
𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖], W𝑣𝑎𝑙
a [𝑖] = ˜a[𝑗], and W𝑣𝑎𝑙
b [𝑖] = ˜b[𝑗] with probability
min(˜a[𝑗]2,˜b[𝑗]2)
Í𝑛
𝑘=1 max(˜a[𝑘]2,˜b[𝑘]2) .
□
Analysis for Discrete Vectors. Next, as a step towards proving Theorem 2, we prove a restricted intermediate result,
Lemma 2, that only applies to vectors whose entries, after scaling to be unit norm, are already integer multiplies of
1/𝐿for a ﬁxed discretization parameter 𝐿. When this is the case, the Round procedure in Algorithm 3 is no-op: it
simply returns a/∥a∥unmodiﬁed. Making this assumption simpliﬁes our analysis. Later we introduce a rounding
error analysis to obtain a result for arbitrary vectors.
Lemma 2. Consider any integer discretization parameter 𝐿, accuracy parameter 𝜖∈(0, 1), and a, b ∈R𝑛such that for
all 𝑖, a[𝑖]2
∥a∥2 and b[𝑖]2
∥b∥2 are integer multiples of 1/𝐿. When run with sample size 𝑚= 𝑂 1/𝜖2 and discretization parameter
𝐿, Algorithm 3 returns sketches 𝑊a and 𝑊b such that, letting F denote the estimation procedure of Algorithm 5, with
probability at least 2/3,
|F (𝑊a,𝑊b) −⟨a, b⟩| ≤𝜖max (∥aI∥∥b∥, ∥a∥∥bI∥) .
Here I = {𝑖: a[𝑖] ≠0 and b[𝑖] ≠0} is the intersection of a’s and b’s supports and aI, bI denote a and b restricted to
indices in I.
Note that Lemma 2 is also weaker than Theorem 2 in that it only gives an accurate solution with constant
probability, 2/3, instead of 1 −𝛿probability for any chosen 𝛿. This is again to simplify the analysis and later we show
how the standard “median-trick” can be used to improve the success probability to 1 −𝛿[Cormode et al., 2011, Larsen
et al., 2021].
Proof. As stated, since a/∥a∥and b/∥b∥have squared entries that are integer multiples of 1/𝐿by assumption, in line
2 of Algorithm 3, Round(a/∥a∥, 𝐿) simply sets ˜a = a/∥a∥. Analogously it sets ˜b = b/∥b∥. Let A = {𝑖: a[𝑖] ≠0} and
B = {𝑖: b[𝑖] ≠0} denote the supports of a and b respectively. We have I = A ∩B.
Reduction to Unit Vectors. We ﬁrst note that, to prove the theorem, it suﬃces to only consider the inner product
between the unit vectors ˜a and ˜b. Speciﬁcally, we will show that:

F (𝑊a,𝑊b)
∥a∥∥b∥
−⟨˜a, ˜b⟩

(5)
≤𝜖
v
t ∑︁
𝑖∈A∩B
max(˜a[𝑖]2, ˜b[𝑖]2)
𝑛
∑︁
𝑖=1
max(˜a[𝑖]2, ˜b[𝑖]2).
18

---

Using that ∥˜a∥2 + ∥˜b∥2 = 2 since ˜a, ˜b are unit vectors, we have:
v
t ∑︁
𝑖∈A∩B
max(˜a[𝑖]2, ˜b[𝑖]2)
𝑛
∑︁
𝑖=1
max(˜a[𝑖]2, ˜b[𝑖]2)
≤
√︂
∥˜aI∥2 + ∥˜bI∥2
 
∥˜a∥2 + ∥˜b∥2

=
√︂
2

∥˜aI∥2 + ∥˜bI∥2

=
√︄
2
 ∥aI∥2
∥a∥2 + ∥bI∥2
∥b∥2

.
Thus, multiplying (5) on both sides by ∥a∥∥b∥we have:
|F (𝑊a,𝑊b) −⟨a, b⟩| ≤𝜖
√
2∥a∥∥b∥·
√︄
∥aI∥2
∥a∥2 + ∥bI∥2
∥b∥2
= 𝜖
√
2
√︁
∥aI∥2∥b∥2 + ∥bI∥2∥a∥2
≤2𝜖· max (∥aI∥∥b∥, ∥bI∥∥a∥) .
The last inequality follows from the fact that the sum is at most two times the max. Adjusting 𝜖by a constant gives
the desired bound of Lemma 2. Thus, we turn our attention to proving (5).
Analysis for Unit Vectors. We start by analyzing an idealized version of the estimator computed by Algorithm 5,
where 𝑀is replaced by the exact weighted union size 𝑀= Í𝑛
𝑖=1 max(˜a[𝑖]2, ˜b[𝑖]2). Speciﬁcally, deﬁne:
F ∗= 𝑀
𝑚
𝑚
∑︁
𝑖=1
1
h
𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖]
i
·
𝑊𝑣𝑎𝑙
a
[𝑖] ·𝑊𝑣𝑎𝑙
b
[𝑖]
𝑞𝑖
,
(6)
where 𝑞𝑖= min

𝑊𝑣𝑎𝑙
a
[𝑖]2,𝑊𝑣𝑎𝑙
b
[𝑖]2
as in line 1 of Algorithm 5.
We ﬁrst show that E[F ∗] = ⟨˜a, ˜b⟩and then bound F ∗’s variance. For each 𝑖∈{1, . . . ,𝑚} deﬁne the random
variable 𝑍𝑖as
𝑍𝑖= 1
h
𝑊ℎ𝑎𝑠ℎ
a
[𝑖] = 𝑊ℎ𝑎𝑠ℎ
b
[𝑖]
i
·
𝑊𝑣𝑎𝑙
a
[𝑖] ·𝑊𝑣𝑎𝑙
b
[𝑖]
𝑞𝑖
.
Recalling that ¯𝐽=
Í𝑛
𝑗=1 min(˜a[𝑗]2,˜b[𝑗]2)
Í𝑛
𝑗=1 max(˜a[𝑗]2,˜b[𝑗]2) is the weighted Jaccard similarity between ˜a and ˜b, applying Fact 5 we have:
𝑍𝑖=


0
with probability 1 −¯𝐽
˜a[𝑗] ˜b[𝑗]
min(˜a[𝑗]2,˜b[𝑗]2)
with probability
min(˜a[𝑗]2,˜b[𝑗]2)
Í𝑛
𝑘=1 max(˜a[𝑘]2,˜b[𝑘]2)
for all 𝑗∈A ∩B.
Thus, E[𝑍𝑖] =
⟨˜a,˜b⟩
Í𝑛
𝑘=1 max(˜a[𝑘]2,˜b[𝑘]2) = ⟨˜a,˜b⟩
𝑀. Since F ∗= 𝑀
𝑚
Í𝑚
𝑖=1 𝑍𝑖, it follows from linearity of expectation that:
E[F ∗] = 𝑀
𝑚
𝑚
∑︁
𝑖=1
E [𝑍𝑖] = ⟨˜a, ˜b⟩.
(7)
We next bound the variance of F ∗. For each 𝑍𝑖we have that:
Var[𝑍𝑖] ≤
∑︁
𝑗∈A∩B
min(˜a[𝑗]2, ˜b[𝑗]2)
Í𝑛
𝑘=1 max(˜a[𝑘]2, ˜b[𝑘]2)
·
˜a[𝑗]2 ˜b[𝑗]2
min(˜a[𝑗]2, ˜b[𝑗]2)2
=
∑︁
𝑗∈A∩B
max(˜a[𝑗]2, ˜b[𝑗]2)
Í𝑛
𝑘=1 max(˜a[𝑘]2, ˜b[𝑘]2)
=
Í
𝑗∈A∩B max(˜a[𝑗]2, ˜b[𝑗]2)
Í𝑛
𝑘=1 max(˜a[𝑘]2, ˜b[𝑘]2)
=
Í
𝑗∈A∩B max(˜a[𝑗]2, ˜b[𝑗]2)
𝑀
19

---

Since each 𝑍𝑖is independent, it follows that:
Var[F ∗] = 𝑀2
𝑚2
𝑚
∑︁
𝑖=1
Var [𝑍𝑖]
≤1
𝑚
∑︁
𝑗∈A∩B
max(˜a[𝑗]2, ˜b[𝑗]2) ·
𝑛
∑︁
𝑗=1
max(˜a[𝑗]2, ˜b[𝑗]2).
(8)
Combining (7) and (8) with Chebyshev’s inequality, we can claim that when 𝑚= 𝑂(1/𝜖2), with probability at least
5/6:
F ∗−⟨˜a, ˜b⟩
 ≤𝜖
v
u
t ∑︁
𝑗∈A∩B
max(˜a[𝑗]2, ˜b[𝑗]2)
𝑛
∑︁
𝑗=1
max(˜a[𝑗]2, ˜b[𝑗]2).
(9)
We want to extend this bound from the idealized estimator F ∗to our true estimator F , which equals
˜𝑀
𝑀· F ∗. To
do so, we use that ˜𝑀is a good approximation to 𝑀. As discussed in Section 4, this is because ˜𝑀exactly equals 1
𝐿
times a distinct elements estimator applied to the support sets ¯
A and ¯B of the extended vectors ¯a, ¯b. From (4) and
Lemma 1, we have that for 𝑚= 𝑂(1/𝜖2),
(1 −𝜖)𝑀≤˜𝑀≤(1 + 𝜖)𝑀,
with probability at least 5/6. It follows that:
(1 −𝜖)F ∗≤F (𝑊a,𝑊b)
∥a∥∥b∥
≤(1 + 𝜖)F ∗.
(10)
By a union bound, with probability at least 2/3, both (9) and (10) hold simultaneously. Finally, by Cauchy-Schwarz
inequality,
⟨˜a, ˜b⟩≤
v
u
t ∑︁
𝑗∈A∩B
max(˜a[𝑗]2, ˜b[𝑗]2)
𝑛
∑︁
𝑗=1
max(˜a[𝑗]2, ˜b[𝑗]2).
Combining (9) and (10) with triangle inequality, it follows that

F (𝑊a,𝑊b)
∥a∥∥b∥
−⟨˜a, ˜b⟩

≤3𝜖
v
u
t ∑︁
𝑗∈A∩B
max(˜a[𝑗]2, ˜b[𝑗]2)
𝑛
∑︁
𝑗=1
max(˜a[𝑗]2, ˜b[𝑗]2).
Adjusting 𝜖by a 1/3 factor proves Lemma 2.
□
Rounding for Continuous Vectors. With Lemma 2 in place, we complete our proof of Theorem 2 by analyzing
the impact of the rounding step in Algorithm 5. In Lemma 3, we show that if 𝐿is set on the order of 𝑛6/𝜖2, then we
can bound the impact of this step on the accuracy of our inner product estimate. Formally, we have:
Lemma 3 (Rounding). Consider any a, b ∈R𝑛and discretization parameter 𝐿. Let ˜a = Round(a/∥a∥, 𝐿) and
˜b = Round(b/∥b∥, 𝐿), as in line 2 of Algorithm 3. Let a′ = ∥a∥· ˜a and b′ = ∥b∥· ˜b, and let 𝐵denote 𝐵=
max (∥aI∥∥b∥, ∥a∥∥bI∥) .
1. a′, b′ satisfy the assumption of Lemma 2, that for all 𝑖, a′[𝑖]2
∥a′ ∥2 and b′[𝑖]2
∥b′ ∥2 are integer multiples of 1/𝐿.
2. For any discretization parameter 𝐿, sketch size 𝑚, and random seed 𝑠, Algorithm 3 yields identical outputs on a, b
and a′, b′. I.e., 𝑊a = 𝑊a′ and 𝑊b = 𝑊b′.
3. For 𝐿≥9𝑛6/𝜖2, |⟨a, b⟩−⟨a′, b′⟩| ≤𝜖𝐵.
20

---

4. For 𝐿≥𝑛3, max

∥a′
I∥∥b′∥, ∥a′∥∥b′
I∥

≤2𝐵.
Proof. We prove the four claims of the lemma in order. For the ﬁrst two, we focus on a and a′. Identical claims hold
for b and b′.
Claim 1: a′[𝑖]2
∥a′ ∥2 is an integer multiple of 1/𝐿for all 𝑖. First observe that ˜a = Round(a/∥a∥, 𝐿) is a unit vector. This
is ensured by line 3 of Algorithm 4. Thus, ∥a′∥= ∥a∥· ∥˜a∥= ∥a∥and a′[𝑖]2
∥a′ ∥2 = a′[𝑖]2
∥a∥2 = ˜a[𝑖]2. So to prove the claim, it
suﬃces to show that ˜a[𝑖]2 is an integer multiple of 1/𝐿for all 𝑖. This is guaranteed by Algorithm 4. After line 1, we
can see that ˜z[𝑖]2 is an integer multiple of 1/𝐿for all 𝑖. Since 𝐿is an integer, 1 is also trivially an integer multiple of
1/𝐿. So 𝛿= 1 −∥˜z∥2 as set in line 2 is an integer multiple of 1/𝐿. Finally, this ensures that ˜z[𝑖∗]2 = ˜z[𝑖∗]2 + 𝛿as set in
line 3 is an integer multiple of 1/𝐿, completing the claim.
Claim 2: 𝑊a = 𝑊a′. As shown above, ∥a′∥= ∥a∥. So to prove the claim, it suﬃces to show that Round

a
∥a∥, 𝐿

=
Round

a′
∥a′ ∥, 𝐿

. This ensures that Algorithm 3 proceeds identically on inputs a and a′. By Claim (1), Round(a′/∥a′∥, 𝐿) =
a′/∥a′∥= a′/∥a∥= ˜a. And by deﬁnition, ˜a = Round(a/∥a∥, 𝐿). This completes the claim.
Claim 3: For 𝐿≥9𝑛6/𝜖2, |⟨a, b⟩−⟨a′, b′⟩| ≤𝜖𝐵. Let ˆa = a/∥a∥and ˆb = b/∥b∥. So ˜a = Round(ˆa, 𝐿) and ˜b =
Round(ˆb, 𝐿). We will show that
⟨ˆa, ˆb⟩−⟨˜a, ˜b⟩
 ≤𝜖·
√︃
∥ˆaI∥2 + ∥ˆbI∥2.
(11)
Multiplying each side of (11) by ∥a∥∥b∥then gives:
|⟨a, b⟩−⟨a′, b′⟩| ≤𝜖· ∥a∥∥b∥
√︃
∥ˆaI∥2 + ∥ˆbI∥2
= 𝜖· ∥a∥∥b∥
√︄ ∥aI∥2
∥a∥2 + ∥bI∥2
∥b∥2

= 𝜖
√︁
(∥aI∥2∥b∥2 + ∥bI∥2∥a∥2)
≤
√
2𝜖· max  ∥aI∥2∥b∥2, ∥bI∥2∥a∥2 ,
which completes the claim after adjusting 𝜖by a constant.
We proceed to prove (11). Observe that for any 𝑖∉I, we have at least one of ˆa[𝑖] or ˆb[𝑖] equal to 0. In turn, at
least one of ˜a[𝑖] or ˜b[𝑖] is also 0 since in the rounding procedure of Algorithm 4 any entry of z that is 0 is set to 0 in ˜z.
So we can conclude that ⟨ˆa, ˆb⟩= ⟨ˆaI, ˆbI⟩and similarly, ⟨˜a, ˜b⟩= ⟨˜aI, ˜bI⟩. This gives that:
⟨ˆa, ˆb⟩−⟨˜a, ˜b⟩
 =
⟨ˆaI, ˆbI⟩−⟨˜aI, ˜bI⟩
 .
So, to prove (11), it suﬃces to bound the righthand side of the above equation. We consider two cases:
Case 1: max

∥ˆaI∥, ∥ˆbI∥

≥
1
√
𝐿. For 𝑖∈I, if |ˆa[𝑖]| <
1
√
𝐿and 𝐿≥𝑛, then |ˆa[𝑖]| <
1
√𝑛and so 𝑖≠arg max𝑖∈1,...,𝑛ˆa[𝑖]
since ˆa is a unit vector so has at least one entry with magnitude ≥1/√𝑛. Thus, ˆa[𝑖] is rounded in line 1 of Algorithm 4,
and not in line 3. We have ⌊ˆa[𝑖]2 · 𝐿⌋= 0 and so |˜a[𝑖] −ˆa[𝑖]| = |ˆa[𝑖]| <
1
√
𝐿. Alternatively, if |ˆa[𝑖]| ≥
1
√
𝐿and
𝑖≠arg max𝑖∈1,...,𝑛ˆa[𝑖] (so ˆa[𝑖] is rounded in line 1 but not line 3 of Algorithm 4) then:
|˜a[𝑖] −ˆa[𝑖]| ≤
1
√
𝐿
·

√︁
ˆa[𝑖]2 · 𝐿−
√︁
ˆa[𝑖]2 · 𝐿−1

= 1
√
𝐿
·
1
√︁
ˆa[𝑖]2 · 𝐿+
√︁
ˆa[𝑖]2 · 𝐿−1
≤
1
√
𝐿
.
If 𝑖= arg max𝑖∈1,...,𝑛ˆa[𝑖] then ˆa[𝑖] is rounded in line 3 and so
|˜a[𝑖] −ˆa[𝑖]| ≤

√︁
ˆa[𝑖]2 + 𝛿−|ˆa[𝑖]|
 ≤
𝛿
2|ˆa[𝑖]|,
(12)
21

---

where we use that √𝑥is concave with derivative
1
2|ˆa[𝑖] | at ˆa[𝑖]2. In line 2 of Algorithm 4 we set 𝛿= 1 −∥˜a∥2, where ˜a
is formed by rounding down entries of ˆa in line 1. Each squared entry is rounded down by at most 1/𝐿, so recalling
that ˆa is a unit vector, 𝛿≤𝑛/𝐿. Plugging into (12), and recalling that we assume ˆa[𝑖] ≥1/
√
𝐿,
|˜a[𝑖] −ˆa[𝑖]| ≤𝑛/𝐿
2/
√
𝐿
≤𝑛
√
𝐿
.
(13)
Overall, we can conclude that ∥˜aI −ˆaI∥∞≤
𝑛
√
𝐿. Similarly, we have ∥˜bI −ˆbI∥∞≤
𝑛
√
𝐿. Thus,
⟨˜a, ˜b⟩−⟨ˆa, ˆb⟩
 =
⟨˜aI, ˜bI⟩−⟨ˆaI, ˆbI⟩

≤𝑛
√
𝐿

∥ˆaI∥1 + ∥ˆbI∥1

+ |I| · 𝑛2
𝐿
.
By Cauchy-Schwarz, we have ∥ˆaI∥1 ≤
√︁
|I| · ∥ˆaI∥and ∥ˆbI∥1 ≤
√︁
|I| · ∥ˆbI∥. Overall, this gives:
⟨˜a, ˜b⟩−⟨ˆa, ˆb⟩
 ≤𝑛
√︁
|I|
√
𝐿

∥ˆaI∥+ ∥ˆbI∥

+ |I| · 𝑛2
𝐿
≤𝑛3
√
𝐿
·

∥ˆaI∥+ ∥ˆbI∥+ max

∥ˆaI∥, ∥ˆbI∥

,
where in the last line we use that |I| ≤𝑛, along with the assumption of Case 1 that max

∥ˆaI∥, ∥ˆbI∥

≥
1
√
𝐿. Setting
𝐿≥9𝑛6
𝜖2 , we have
⟨˜a, ˜b⟩−⟨ˆa, ˆb⟩
 ≤𝜖· max

∥ˆaI∥, ∥ˆbI∥

≤𝜖·
√︃
∥ˆaI∥2 + ∥ˆbI∥2.
This proves (11) for Case 1.
Case 2: max

∥ˆaI∥, ∥ˆbI∥

<
1
√
𝐿. In this case, for all 𝑖∈I, |ˆa[𝑖]| <
1
√
𝐿and |ˆb[𝑖]| <
1
√
𝐿. Thus, for 𝐿> 𝑛,
no 𝑖∈I satisﬁes 𝑖= arg max𝑖∈1,...,𝑛ˆa[𝑖] or 𝑖= arg max𝑖∈1,...,𝑛ˆb[𝑖]. So for all 𝑖∈I, ˆa[𝑖] and ˆb[𝑖] are rounded
to 0 in line 1 of Algorithm 4. I.e., ˜aI and ˜bI are both all zero vectors. So, to prove (11), we must show that
⟨ˆaI, ˆbI⟩
 ≤𝜖·
√︃
∥ˆaI∥2 + ∥ˆbI∥2. This follows from Cauchy-Schwarz and our assumption that ∥aI∥, ∥bI∥<
1
√
𝐿
⟨ˆaI, ˆbI⟩
 ≤∥ˆaI∥∥ˆbI∥≤
1
√
𝐿
max

∥ˆaI∥, ∥ˆbI∥

≤
1
√
𝐿
√︃
∥ˆaI∥2 + ∥ˆbI∥2.
Setting 𝐿≥
1
𝜖2 gives (11), completing Claim (3) of the lemma.
Claim 4: For 𝐿≥𝑛3, max

∥a′
I∥∥b′∥, ∥a′∥∥b′
I∥

≤2𝐵. Recall that by construction ∥a′∥= ∥a∥and ∥b′∥= ∥b∥. Thus,
dividing each side of the inequality by ∥a∥∥b∥it suﬃces to show:
max
 ∥a′
I∥
∥a∥,
∥b′
I∥
∥b∥

≤2 max
 ∥aI∥
∥a∥, ∥bI∥
∥b∥

.
I.e., we must show that max(∥˜aI∥, ∥˜bI∥) ≤2 max(∥ˆaI∥, ∥ˆbI∥). It suﬃces to show that ∥˜aI∥≤2∥ˆaI∥and that
∥˜bI∥≤2∥ˆbI∥. We focus on proving this for a. The bound for b follows the same argument. We consider two cases.
Let 𝑖∗= arg max𝑖∈1,...,𝑛|ˆa[𝑖]|.
Case 1: 𝑖∗∉I. In this case, all entries in ˆaI are only rounded in line 1 of Algorithm 4. They are thus all rounded
down and so ∥˜aI∥≤∥ˆaI∥, giving the claim.
Case 2: 𝑖∗∈I. In this case, since ˆa is a unit vector, we have ∥ˆaI∥≥|ˆa[𝑖∗]| ≥1/√𝑛≥1/
√
𝐿when 𝐿> 𝑛.
Further, all entries in ˆaI are rounded down, except ˆa[𝑖∗]. But as shown via (13), |˜a[𝑖∗]| ≤|ˆa[𝑖∗]| +
𝑛
√
𝐿. Thus,
∥˜aI∥≤∥ˆaI∥+ 𝑛
√
𝐿≤2∥ˆaI∥, as long as 𝐿≥𝑛3.
This completes Claim (4) and thus the lemma.
□
22

---

Putting everything together. Finally, we prove our main result by combining Lemma 3 with Lemma 2.
Proof of Theorem 2. Given any a, b ∈R𝑛, let a′ and b′ be deﬁned as in Lemma 3. Consider applying Algorithm 3 to
compute sketches 𝑊a,𝑊b,𝑊a′,𝑊b′ of size 𝑚= 𝑂(1/𝜖2), using discretization parameter 𝐿= 𝑂(𝑛6/𝜖2). Using the ﬁrst
claim of Lemma 3 , we can apply Lemma 2 to a′, b′ to show that with probability ≥2/3,
|F (𝑊a′,𝑊b′) −⟨a′, b′⟩| ≤𝜖max  ∥a′
I∥∥b′∥, ∥a′∥∥b′
I∥ .
Combining triangle inequality with Claims (2) and (4) of Lemma 3, we conclude that with probability ≥2/3,
|F (𝑊a,𝑊b) −⟨a, b⟩| ≤|⟨a, b⟩−⟨a′, b′⟩|
+ 2𝜖max (∥aI∥∥b∥, ∥a∥∥bI∥) .
Finally, applying Claim (3) of Lemma 3 gives that
|F (𝑊a,𝑊b) −⟨a, b⟩| ≤3𝜖max (∥aI∥∥b∥, ∥a∥∥bI∥) .
After adjusting 𝜖by a factor of 1/3, this establishes the bound of Theorem 2. The probability of success is 2/3. Using
a standard trick, we can boost the success probability by computing 𝑡= 𝑂(log(1/𝛿)) independent sketches of a, b
using Algorithm 3 with independent random seeds [Cormode et al., 2011]. Call these sketches 𝑊(1)
a
, . . . ,𝑊(𝑡)
a
and
𝑊(1)
b
, . . . ,𝑊(𝑡)
b
. For any 𝑖, with probability ≥2/3,
|F (𝑊(𝑖)
a ,𝑊(𝑖)
b ) −⟨a, b⟩| ≤𝜖max (∥aI∥∥b∥, ∥a∥∥bI∥) .
Via a standard Chernoﬀbound, with probability at least 1 −𝛿, this bound holds for > 𝑡/2 of the independent sketches.
Thus, if we take the median estimate produced by the sketches, it will satisfy the desired bound with probability
≥1 −𝛿. Concatenating our 𝑡independent sketches into a single sketch, we can see that the total sketch size is
𝑡· 𝑚= 𝑂(log(1/𝛿)/𝜖2), giving Theorem 2.
□
23

---

