# Pylon: Semantic Table Union Search in Data Lakes

> 来源: https://arxiv.org/pdf/2301.04901

Pylon: Semantic Table Union Search in Data Lakes
Tianji Cong
University of Michigan
Ann Arbor, USA
congtj@umich.edu
Fatemeh Nargesian
University of Rochester
Rochester, USA
fnargesian@rochester.edu
H. V. Jagadish
University of Michigan
Ann Arbor, USA
jag@umich.edu
Abstract—The large size and fast growth of data repositories,
such as data lakes, has spurred the need for data discovery to help
analysts ﬁnd related data. The problem has become challenging
as (i) a user typically does not know what datasets exist in an
enormous data repository; and (ii) there is usually a lack of
a uniﬁed data model to capture the interrelationships between
heterogeneous datasets from disparate sources. In this work, we
address one important class of discovery needs: ﬁnding union-
able tables.
The task is to ﬁnd tables in a data lake that can be unioned
with a given query table. The challenge is to recognize union-
able columns even if they are represented differently. In this
paper, we propose a data-driven learning approach: speciﬁcally,
an unsupervised representation learning and embedding retrieval
task. Our key idea is to exploit self-supervised contrastive
learning to learn an embedding model that takes into account the
indexing/search data structure and produces embeddings close
by for columns with semantically similar values while pushing
apart columns with semantically dissimilar values. We then ﬁnd
union-able tables based on similarities between their constituent
columns in embedding space. On a real-world data lake, we
demonstrate that our best-performing model achieves signiﬁcant
improvements in precision (16% ↑), recall (17% ↑), and query
response time (7x faster) compared to the state-of-the-art.
I. INTRODUCTION
Recent years have witnessed a vast growth in the amount
of data available to the public, particularly from data markets,
open data portals, and data communities (e.g., Wikidata and
Kaggle) [1]. To beneﬁt from the many new opportunities for
data analytics and data science, the user ﬁrst usually has to
ﬁnd related datasets in a large repository (e.g., data lake).
Common practice in production is to provide a keyword search
interface over the metadata of datasets [2] but users often
have discovery needs that cannot be precisely expressed by
keywords. The challenge for a system is to support users with
varying discovery needs, without the help of a uniﬁed data
model capturing the interrelationships between datasets.
In response to the challenge, there are many ongoing efforts
under the umbrella of data discovery. One task of interest in
data discovery is to ﬁnd union-able tables [3]–[6] with the
aim of adding additional relevant rows to a user-provided
table. Figure 1 shows an example of two tables union-able
over four pairs of attributes. In general, the literature considers
two tables union-able if they share attributes from the same
domain and assumes the union-ability of two attributes can be
implied by some notion of similarity. We refer to the problem
of ﬁnding union-able tables as table union search (as termed
in [5]) in the rest of the paper.
The typical solution path is to ﬁrst identify union-able
attributes (or columns in the tables) with the aid of an
indexing/search data structure (e.g., locality sensitive hashing)
and then aggregate column-level results to obtain candidate
union-able tables. To uncover the union-ability of attributes,
both syntactic and semantic methods have been exploited.
Syntactic methods are the easiest, and have been used the
longest. While they are robust at catching small changes, such
as capitalization or the use of a hyphen, they are unable
to address even the use of common synonyms. Semantic
methods offer the possibility of ﬁnding union-able columns of
semantically similar values despite their syntactic dissimilarity
(e.g., “venue” column and “platform” column in ﬁgure 1). [4],
[5] link cell values to entity classes in an external ontology
and compare similarity of entity sets. [5], [6] use off-the-shelf
word embeddings to measure semantics. Both methods have
notable limitations. [5] observed that only 13% of attribute
values of their collected Open Data tables can be mapped
to entities in YAGO [7], one of the largest and publicly
available ontologies. Although word embeddings can provide
more semantic coverage of attributes, they are subject to the
training text corpus and may not generalize well to textual data
in tables [8], [9]. Recent advance in tabular embeddings [10],
[11] may mitigate the issue, however, we argue that these
models in training do not take into account the indexing/search
data structure, which is a core component of any efﬁcient
solution to table union search. In particular, [5], [6] rely on the
correlation between column union-ability and cosine similarity
of their embeddings. Nevertheless, the embeddings they use
and recent more advanced tabular models are not optimized
in training for approximate cosine similarity search so the
performance of indexing/search data structure is suboptimal.
Instead of relying on low-coverage ontologies or pre-trained
embeddings that are unaware of required data structure in
table union search, we propose a data-driven learning approach
to capture data semantics and model characteristics of the
essential indexing/search data structure. We also argue that the
popular classiﬁcation formulation in the literature [10]–[13] is
less feasible for table union search. On one hand, there is
no large-scale labeled dataset for table union search. The only
publicly available benchmark [5] with table- and column-level
ground truth contains a limited number of tables synthesized
from only 32 base tables, which is far from being enough for
training purposes. On the other hand, even if the training data
problem were resolved, we would only be able to determine
arXiv:2301.04901v2  [cs.DB]  13 Jan 2023

---

id
title
authors
venue
year
671167
A Database System for Real-Time Event Aggregat...
Jerry Baulier, Stephen Blott, Henry F. Korth, ...
Very Large Data Bases
1998
672964
Integrating a Structured-Text Retrieval System...
Tak W. Yan, Jurgen Annevelink
Very Large Data Bases
1994
872823
Evaluating probabilistic queries over imprecis...
Reynold Cheng, Dmitri V. Kalashnikov, Sunil Pr...
International Conference on Management of Data
2003
...
...
...
...
...
Title
Authors
Platform
Cited url
Cited count
Year
Fg-index: towards veriﬁcation-free query proc...
J Cheng, Y Ke, W Ng, A Lu
Proceedings of the 2007 ACM SIGMOD internation...
https://scholar.google.com/scholar?oi=bibs&hl=...
286
2007
Efﬁcient query processing on graph databases
J Cheng, Y Ke, W Ng
ACM Transactions on Database Systems (TODS) 34...
https://scholar.google.com/scholar?oi=bibs&hl=...
83
2009
Context-aware object connection discovery in l...
J Cheng, Y Ke, W Ng, JX Yu
2009 IEEE 25th International Conference on Dat...
https://scholar.google.com/scholar?oi=bibs&hl=...
66
2009
...
...
...
...
...
...
Fig. 1: An example of two tables union-able over four pairs of attributes: title - Title, authors - Authors, venue - Platform, and
year - Year.
column matches pairwise. Unlike tasks (e.g., semantic column
type annotation and entity matching) that can be formulated as
a classiﬁcation problem, ﬁnding union-able tables is a search
problem. It would be very inefﬁcient to exhaustively consider
every query column and every column in the data lake pairwise
to predict union-ability. In short, the inherent search nature of
the problem makes the supervised classiﬁcation formulation
infeasible and it is important to jointly consider representation
learning and the indexing/search data structure.
In this work, we overcome the aforementioned difﬁculties
by casting table union search as an unsupervised representation
learning and embedding retrieval task. Our goal is to learn
column-level embeddings into a high-dimensional feature
space that also models characteristics of the indexing/search
data structure. Locality search in this feature space can then di-
rectly be used for union-able table search. To achieve this goal,
our key idea is to exploit self-supervised contrastive learning
to learn an embedding model that produces embeddings with
high similarity measure (which is used in indexing/search data
structure) for columns with semantically similar values and
pushes away columns with semantically dissimilar values. We
propose Pylon, a novel self-supervised contrastive learning
framework that learns column representations and serves table
union search without relying on labeled data.
There are two main challenges in the development of Pylon:
1) How to learn embeddings that capture both data se-
mantics and model characteristics of indexing/search
data structure? Existing embedding models may capture
semantics from a large training corpus but they are
ignorant of additional data structure necessary in table
union search. In other words, the potential of locality
search is not fully realized with existing embeddings.
2) How to create training data without human labeling?
The self-supervised contrastive learning technique re-
quires constructing positive and negative examples from
data themselves. In the ﬁeld of computer vision where
contrastive learning ﬁrst took off, [14] applies a series
of random data augmentation of crop, ﬂip, color jitter,
and grayscale to generate stochastic views of an image.
These views preserve the semantic class label of the
image and so make positive examples for training. They
further consider any two views not from the same
image as a negative example. However, the tabular data
modality is dramatically different from images and it
remains unclear how to create different views of tables
while keeping the semantics.
In summary, we make the following contributions:
• We formulate semantic table union search as an un-
supervised representation learning and embedding re-
trieval problem, and propose to use self-supervised con-
trastive learning to model both data semantics and index-
ing/search data structure.
• We present Pylon, a contrastive learning framework for
learning semantic column representations from large col-
lections of tables without using labels. In particular, we
propose two simple yet effective strategies to construct
training data in an unsupervised manner.
• We empirically show that our approach is both more
effective and efﬁcient than existing embedding methods
on a real-world data lake of GitHub tables and a synthetic
public benchmark of open data tables. On the GitHub data
lake, two of our model variants outperform their corre-
sponding baseline version by 14% and 6% respectively on
both precision and recall. We also observe that they speed
up the query response time by 2.7x and 9x respectively.
We (plan to) open-source our new benchmark of GitHub
tables for future research study.
• We demonstrate that our embedding approach can be
further augmented by syntactic measures and that our
best ensemble model has signiﬁcant advantages over
the state-of-the-art (namely, D3L [6]), more than 15%
improvement in precision and recall, and 7x faster in
query response time.
We give a formal problem setup and background about
embedding models in Section 2. We describe our framework
Pylon including embedding training and search in Section 3.
Section 4 reports experiments that validate our approach. We
discuss related work in Section 5 and conclude in Section 6.
II. PROBLEM DEFINITION & BACKGROUND
In this section, we start by describing the formal problem
setup in II-A, and then provide an overview of how table union
search is different from a well-established data management
problem, namely schema matching, and a related problem of
join discovery in II-B. We ﬁnally elaborate on the challenges
of applying representation learning for table union search
in II-C.

---

A. Table Union Search
The table union search problem [5] is motivated by the
need to augment a (target) table at hand with additional data
from other tables containing similar information. For example,
starting with a table about trafﬁc accidents in one state for
a particular year, an analyst may wish to ﬁnd similar trafﬁc
accident data for other states and years. Ideally, these tables
would have the same schema (e.g. data from the same state
agency for two different years) so that we could simply union
the row-sets. However, this is typically not the case for data
recorded independently (e.g. data from different states). We
consider two tables union-able if they share attributes from the
same domain. Also, as in prior work on this topic, we assume
the union-ability of attributes can be quantiﬁed by some notion
of similarity.
Deﬁnition 1 (Attribute Union-ability). Given two attributes A
and B, the attribute union-ability Uattr(A, B) is deﬁned as
Uattr(A, B) = M(T (A), T (B))
where T (·) is a feature extraction technique that transforms
raw columns (attribute names, attribute values, or both) to a
feature space and M(·, ·) is a similarity measure between two
instances in the feature space.
With the deﬁnition of attribute union-ability, we can deﬁne
table uniona-bility as a bipartite graph matching problem
where the disjoint sets of vertices are attributes of the target ta-
ble and the source table respectively, and edges can be deﬁned
by attribute union-ability. In this paper, we restrict ourselves
to the class of greedy solutions. Therefore, we formalize the
deﬁnition table union-ability as a greedy matching problem as
follows:
Deﬁnition 2 (Union-able Tables). A source table S with
attributes B = {Bj}n
j=1 is union-able to a target table T with
attributes A = {Ai}m
i=1 if there exists a one-to-one mapping
g : A′(̸= ∅) ⊆A →B′ ⊆B such that
1) |A′| = |B′|;
2) ∀Ai ∈A′, Uattr(Ai, g(Ai)) ≥τ where
g(Ai) = arg max
Bj {Uattr(Ai, Bj) : 1 ≤j ≤n}
and τ is a pre-deﬁned similarity threshold.
Deﬁnition 3 (Table Union-ability). Following notations in
Deﬁnition 2, the table union-ability U(S, T) is deﬁned as
U(S, T) =
Pl
i=1 wi · Uattr(Ai, g(Ai))
Pl
i=1 wi
where l is the number of union-able attribute pairs between
the target table T and a source table S, and wi weights the
contribution of the attribute pair (Ai, g(Ai)) to the table union-
ability.
Considering the scale of the dataset repository, we also
follow the common practice [4]–[6] of performing top-k
search. The table union search problem is formally deﬁned
as below.
Deﬁnition 4 (Top-k Table Union Search). Given a table corpus
S, a target table T, and a constant k, ﬁnd up to k candidate
tables S1, S2, ..., Sk ∈S in descending order of table union-
ability with respect to the query table T such that S1, S2, ..., Sk
are most likely to be union-able with T.
B. How Table Union Search Differs from Schema Matching
and Join Discovery?
Despite of overlapping elements, we emphasize the com-
plexity of table union search over related problems of schema
matching and join discovery. As a long-standing and well-
studied problem in data integration, schema matching takes
a pair of schemas as input and returns a mapping between
columns of two schemas that semantically correspond to
each other [15]. Conceptually, table union search can be
viewed as an extreme extension of schema matching. Instead
of having two schemas as inputs, table union search only
has one while having to search another (partially) matching
schema in a large corpus (e.g., data lakes) in the ﬁrst place.
Essentially, aside from the matching component, table union
search needs to address the additional problem of identifying
matching candidates among many non-matching ones, which
is a signiﬁcantly more challenging setup. Similarly, fuzzy
join [16], [17] assumes a restrictive setup with a pair of input
datasets. In their experiments, the second dataset in the pair
is usually a syntactically perturbed variant of the ﬁrst dataset
and thus cannot mimic the complexity of data lakes consisting
of heterogeneous datasets across domains.
A problem more related to table union search is join discov-
ery [6], [18], [19], which targets at ﬁnding joinable tables in
data lakes. Both are search problems, nevertheless, table union
search needs to ideally identify a matching between blocks
of columns in two tables as opposed to identifying a pair of
join keys between two tables in join discovery. This difference
poses higher demand for embedding quality in table union
search because moderately high similarity between every pair
of columns makes it harder to match union-able pairs.
C. General Challenges
Representation learning for tables has achieved excellent
results for many table-centric tasks. We hypothesize that the
table union search problem can also beneﬁt from advances
in table modeling. However, several challenges remain to be
addressed.
1) To the best of our knowledge, no prior work has taken
the learning approach for table union search. We argue
that this is mainly because neither the supervised learn-
ing setting nor the popular pre-training and ﬁne-tuning
paradigm is directly applicable for the problem. It is
inefﬁcient to formulate the underlying search of union-
able columns as a classiﬁcation problem. In a supervised
learning setting, one can attempt to train a classiﬁer
to predict whether two columns are union-able, but it

---

will quickly become computationally prohibitive in the
search phase to classify every pair of target column in
a query table with every column in a large corpus.
2) The scarcity of table union search datasets is another
severe bottleneck of applying a learning approach and
studying the problem in general. The only publicly
available benchmark [5] with table- and column-level
ground truth is synthesized from only 32 base tables,
which is barely enough for evaluation. It is also very
laborious and time consuming to label such datasets, as
curators need to examine every pair of columns for every
pair of tables in a collection.
3) Efﬁcient solutions to table union search involve two
stages: proﬁling (e.g., embed columns into a feature
space) and index-based search. Taking off-the-shelf em-
bedding models or training a new model without consid-
ering the indexing/search data structure indispensable in
table union search is suboptimal. We argue that aligning
representation learning with indexing/search data struc-
ture can further improve effectiveness and efﬁciency of
a solution to table union search.
In the next section, we present our design that contributes
a representation learning approach to table union search while
effectively addressing the challenges we point out here.
III. PYLON: A SELF-SUPERVISED CONTRASTIVE
LEARNING FRAMEWORK FOR TABULAR DATA
Our key idea is to exploit self-supervised contrastive learn-
ing that can provide a feasible training objective for learning
effective column representations for the table union search
problem while not requiring any labeled data and taking into
account the indexing/search data structure (corresp. to chal-
lenge 1 and 3). Within the framework of contrastive learning,
we propose two strategies that arithmetically construct training
data from unlabeled data to tackle challenge 2.
A. Contrastive Learning
The high-level goal of contrastive learning is to learn to
distinguish (so called ”contrast”) between pairs of similar
and dissimilar instances. Ideally, in the learned representation
space, similar instances stay close to each other whereas
dissimilar ones are pushed far away. A pair of instances is
considered similar and labeled a positive example in training
if it comprises different views of the same object; otherwise,
they are considered dissimilar and make a negative example.
Contrastive learning has been used extensively in computer
vision [14], where a positive example consists of a pair of
augmented images transformed from the same image (e.g., by
applying cropping or color distortion).
We introduce, Pylon, our self-supervised contrastive learn-
ing framework for table union search. As table union search
begins by ﬁnding union-able columns, Pylon is designed to
generate a vector representation for each column of input
tables where columns containing semantically similar values
have embeddings closer to one another.
B. Pylon Workﬂow
Figure 2 shows the training workﬂow of the framework that
consists of the following major components.
Training Data Construction. Without labeled data, the
success of contrastive learning hinges on the construction of
positive and negative examples from data themselves. To make
positive examples, it requires an operation to transform a data
instance in a way that introduces variations while preserving
the semantics. As table union search builds on union-able
column search, we propose two strategies to construct positive
and negative examples at the column level.
1) Online sampling strategy. Consider a training batch of
N tables {Ti}N
i=1 where each table Ti has mi columns
{Ci
j}mi
j=1, giving M = PN
i=1 mi columns in total. We
obtain a positive example of column pairs (xk, xk+M)
(1 ≤k ≤M) by randomly sampling values from each
column Ci
j of each table Ti. Since both xk and xk+M are
samples from the same column, we consider they share
semantics and make a positive example. The sampling
process yields 2M column instances, and we treat the
other 2(M −1) samples as negatives with respect to xk.
In other words, considering (xk, xk+M) and (xk+M, xk)
as distinct positive examples, we construct 2M positive
examples and 2M(M −1) negative examples from each
training batch.
2) Ofﬂine approximate matching strategy. An alternative is
to construct positive examples ahead of training. Instead
of relying on ad-hoc sampling, we can leverage existing
approaches to ﬁnd a union-able candidate for each col-
umn, which in turn makes positive examples in training.
Based on the observation that top-k union-able column
search of existing techniques is reasonably precise when
k = 1, we are able to use this approximate matching
without human involvement. We ﬁnd it produces valid
results and models do not deteriorate due to potential
false positives in training data.
Base Encoder & Projection Head. We pass column in-
stances {xk}2M
k=1 through a base encoder f(·) to get initial col-
umn embeddings {ek}2M
k=1. Note that our contrastive learning
framework is ﬂexible about the choice of the base encoder. The
encoder can give embeddings at token/cell/column level, and
if necessary, we can apply aggregation (e.g, average) to obtain
column-level embeddings. Our framework has the ﬂexibility
to beneﬁt from the advance of modeling techniques over time
without being tied to a speciﬁc model. We describe the choices
of f(·) we experiment with in subsection III-C.
Following the encoder, a small multi-layer neural network
g(·), called projection head, maps the representations from the
encoder to a latent space through linear transformations and
non-linear activation in between. Note that unlike the practice
in CV which discards projection head in inference and uses
encoder outputs for downstream tasks, we preserve projection
head and use projected embeddings for table union search.
This is because we found projected embeddings yield better
performance in initial experiments, and for encoders like word

---

r1
r2
r3
r4
r5
r6
Online Training
Data
Construction
Base Encoder f &
Projection Head g
f
g
f
g
e1
e2
e3
e1+M
e2+M
e3+M
Projected column embeddings
Table Samples
c1 c2 c3
r1
r2
r5
r2
r3
r6
Fig. 2: Training workﬂow of Pylon (with online training data construction).
embedding models, only projection head is trainable and has
to be preserved for inference. For simplicity, we keep using
the notations {ek}2M
k=1 for projection outputs.
Contrastive Loss. The training objective is a core com-
ponent in the framework, which drives the learned repre-
sentations towards the characteristics of the indexing/search
data structure in table union search. For example, considering
an indexing/search data structure that approximates cosine
similarity of vectors, the model should ideally learn to pro-
duce embeddings with high cosine similarity for union-able
columns in our case.
One common setting of contrastive learning deﬁnes a pre-
diction task of identifying positive examples from the training
batch. Given embedded columns {ek}2M
k=1, the model learns
to predict ek+M as the most similar one to ek and vice
versa for each ek(1 ≤k ≤M). Here, one can choose a
similarity measure that aligns with locality search. In other
words, depending on what similarity measure for which the
indexing/search data structure is designed, we can push that
similarity measure into model learning. As an illustration,
the similarity between any two instances ei and ej can be
measured by their cosine similarity as
sim(i, j) =
eT
i ej
∥ei∥∥ej∥
and the loss is calculated as
l(k, k + M) = −log
exp (sim(k, k + M) / τ)
P2M
l=1,l̸=k exp (sim(k, l) / τ)
where τ > 0 is a scaling hyper-parameter called temperature.
Minimizing l(k, k + M) is equivalent to maximizing the
probability of ek+M being the most similar to ek in terms of
cosine similarity among all the embedded columns except ek
itself. In this way, the learned column representations are more
feasible to be used with the indexing/search data structure that
approximates cosine similarity compared to embeddings given
by any other models that are not trained to optimize for this
purpose (e.g., tabular language models that are trained with
the objective to recover masked tokens or entities [10]).
Finally, the loss over all the 2M positive column pairs in a
training batch is computed as
L =
1
2M
M
X
k=1
[l(k, k + M), l(k + M, k)].
Algorithm 1 summarizes the training process of contrastive
learning in Pylon.
C. Choices of the Base Encoder
Although we expect the input to the contrastive loss function
to be column embeddings, the base encoder does not neces-
sarily need to give column embeddings directly. It is possible
for the encoder model to generate embeddings at different
granularity (i.e., token/cell/column) because we can apply ag-
gregation if necessary. We describe the basic encoding process
of embedding models we experimented with in section IV.
Word Embedding Models (WEM). As a WEM assigns
a ﬁx representation to a token, WEM-based encoders treat
each column independently as a document where a standard
text parser tokenizes data values in a column. With a fastText
embedding model, we ﬁrst get cell embeddings by averaging
token embeddings in each cell and then aggregate cell em-
beddings to get a column embedding. More interestingly, web
table embedding models [8] consider each cell as a single
token (they concatenate tokens in a cell with underscores) and
output embeddings at cell level. Nevertheless, we aggregate
cell embeddings to derive the column embedding.
Language Models (LM). Since a table is a cohesive
structure for storing data, considering values in neighboring
columns could integrate context into the embeddings and

---

help mitigate ambiguity in unionable column search. For
example, encoding column ”year” in ﬁgure 1 individually loses
the context that this column refers to the publication year
of research papers. In this case, the embeddings of ”Year”
columns in the corpus are less distinguishable (in terms of
cosine similarity) even though they may refer to different
concepts of year such as the birth year of people or the release
year of movies. With context provided by other columns like
”Title” and ”Venue”, it is more likely that ”Year” columns
appearing in tables about papers are more close to each other
than ”Year” columns in tables about other topics, which helps
ﬁnd more related tables.
We leverage LMs to derive contextual column embeddings.
We ﬁrst serialize each row in Ti as a sequence by concate-
nating tokenized cell values. For example, the ﬁrst row of the
table at the top in Figure 1 will be linearized as follows
[CLS] title | A Database . . . [SEP] authors | Jerry . . . [SEP] . . . [END]
The sequence is annotated with special tokens in the LM where
[CLS] token indicates the beginning of the sequence, [END]
token indicates the end, and [SEP] tokens separate cell values
in different columns. Then the LM takes in each sequence
and generates a contextual representation for each token in the
sequence (essentially taking into account the relation between
values in the same row). We apply mean pooling to tokens in
the same cell and get cell embeddings. To consider the relation
of values in the same column, we adopt the vertical attention
mechanism in [20] to have weighted column embeddings by
attending to all of the sampled cells in the same column.
Word embedding models have previously been used to ﬁnd
union-able tables. Two state-of-the-art choices are fastText and
WTE (web table embeddings [8]). Language models have not
thus far been used for the union-ability problem. BERT [21] is
a leading language model used for many purposes today. We
develop three versions of Pylon, one for each of these three
encoder choices: fastText, WTE, and a BERT-based language
model, and refer to the derived models as Pylon-fastText,
Pylon-WTE, Pylon-LM respectively. We evaluate the effect of
encoder choices in subsection IV-E.
D. Embedding Indexing and Search
To avoid exhaustive comparisons of column embeddings
over a large corpus at query time, we use locality-sensitive
hashing (LSH) [22] for approximate nearest neighbor search
and treat union-able column search as an LSH-index lookup
task [5], [6]. Note that the speciﬁc choice of indexing/search
data structure is ﬂexible (one can use a more advanced
technique like Hierarchical Navigable Small World [23]).
The key is that the similarity measure approximated by the
indexing/search data structure should align with the similarity
measure employed in the training objective of contrastive
learning so that the learned embeddings are optimized for the
indexing/search data structure.
LSH utilizes a family of hash functions that maximize
collisions for similar inputs. The result of LSH indexing
is that similar inputs produce the same hash value and are
Algorithm 1: Pylon Contrastive Learning
Input :
S, a corpus of tables;
N, batch size;
p, training hyper-parameters.
Output:
g ◦f, a Pylon model.
1 g ◦f ←initialize model();
2 for mini-batch of N tables {Ci
j}N
i=1 from S do
3
{xk, xk+M}M
k=1 ←
construct training data({Ci
j}N
i=1) ;
4
{ek}2M
k=1 ←
g ◦f.encode and embed({xk, xk+M}M
k=1) ;
5
/* Deﬁne
l(k, k + M) = −log
exp (sim(k,k+M) / τ)
P2M
l=1,l̸=k exp (sim(k,l) / τ) and
sim(i, j) =
eT
i ej
∥ei∥∥ej∥*/
6
L ←
1
2M
M
X
k=1
[l(k, k + M), l(k + M, k)] ;
7
g ◦f ←L.backpropagate(p) ;
8 end
9 return g ◦f;
Algorithm 2: Top-k Table Union Search
Input :
I, a populated LSH index;
Q, a query table;
k, a constant.
Output:
top-k union-able tables.
1 column candidates ←{};
2 column scores ←{};
3 for c ∈Q.columns do
4
c candidates, c scores ←I.lookup(c);
5
column candidates[c].add(c candidates);
6
column scores[c].add(c scores);
7 end
8 table candidates ←group by(column candidates);
9 ranked table candidates ←
cmpt table unionability(table candidates, column scores);
10 return ranked table candidates[: k];
bucketed together whereas dissimilar inputs are ideally placed
in different buckets. For approximate search relative to the
cosine similarity, we index all column embeddings in a random
projection LSH index [24]. The idea of random projection is to
separate data points in a high-dimensional vector space by in-
serting hyper-planes. Embeddings with high cosine similarity
tend to lie on the same side of many hyper-planes.
Algorithm 2 summarizes the top-k table union search.
Following Deﬁnition 1, we instantiate the union-ability of
two attributes as the cosine similarity of their embeddings
(c scores in line 4 of Algorithm 2). Line 8 groups re-
trieved column candidates across query columns by their table
sources. To decide on the table union-ability from Deﬁnition 3

---

(cmpt table unionability in line 9), we use the same weight-
ing strategy as
[6] over query attributes and corresponding
matching attributes in candidate tables. For a target attribute A,
let RA denote the distribution of all similarity (union-ability)
scores between A and any attribute B returned by the LSH
index. The weight w of a similarity score Uattr(A, B) is given
by the cumulative distribution function of RA evaluated at
Uattr(A, B):
w = Pr(Uattr(A, B′) ≤Uattr(A, B)), ∀Uattr(A, B′) ∈RA
In other words, a similarity score is weighted by its percentile
in the distribution. This weighting scheme helps balance
between a candidate table with a few union-able attributes of
high similarity scores and another candidate table with more
union-able attributes but of lower similarity scores.
Using the same index and search structure as previous works
makes it transparent to compare our embedding approach with
theirs in effectiveness and efﬁciency.
E. Integrating Syntactic Methods
Thus far, we have focused purely on semantic methods
to unify similar attributes. It makes sense to prefer semantic
methods to syntactic ones because of their potential robustness
to many different types of variation. However, we note that
syntactic methods are based on measures of similarity very
different from semantic methods. Intuitively, one should expect
to be able to do better if we can integrate the two.
Indeed, some previous work [5], [6] has made this ob-
servation as well, and shown that an ensemble of semantic
and syntactic methods can do better than either on its own.
The Pylon semantic method permits the use of an additional
complementary syntactic method. As in [6], we independently
obtain scores from the two methods and then use the average
of the two as our ﬁnal score.
IV. EXPERIMENTS
We ﬁrst evaluate the effectiveness and efﬁciency of three
model variants from our contrastive learning framework and
compare them with their corresponding base encoders. We
then demonstrate that our embedding approach is orthogonal
to existing syntactic measures, which can further improve the
results. We ﬁnally compare our best model with the state-of-
the-art D3L [6].
A. Datasets and Metrics
TUS Benchmark. [5] compiles the ﬁrst benchmark with
ground truth out of Canadian and UK open data lakes. They
synthesize around 5, 000 tables from 32 base tables by per-
forming random projection and selection. They also generate
a smaller benchmark consisting of around 1, 500 tables from
10 base tables in the same manner. We refer to them as TUS-
Large and TUS-Small respectively.
Pylon Benchmark.
We create a new dataset from Git-
Tables [25], a data lake of 1.7M tables extracted from CSV
ﬁles on GitHub. The benchmark comprises 1,746 tables in-
cluding union-able table subsets under topics selected from
Schema.org [26]: scholarly article, job posting, and music
playlist. We end up with these three topics since we can ﬁnd a
fair number of union-able tables of them from diverse sources
in the corpus (we can easily ﬁnd union-able tables from a
single source but they are less interesting for table union search
as simple syntactic methods can identify all of them because
of the same schema and consistent value representations).
Cleaning and Construction. We download three largest
subsets of GitTables (”object”, ”thing”, and ”whole”) and
preprocess them by removing HTML ﬁles, tables without
headers, rows with foreign languages, and ﬁnally small tables
with fewer than four rows or four columns. We cluster the
resulting tables by their schema and perform a keyword
search over schema with keywords related to three topics.
We manually select 35 union-able tables of topic scholarly
article, 41 tables of topic job posting, and 48 tables of topic
music playlist. We then randomly sample 100,000 tables for
training, 5,000 tables for validation, and put the rest of tables
as negatives1 in a pool with selected union-able table subsets
for the search evaluation.
Table I provides an overview of basic table statistics of each
evaluation benchmark.
TABLE I: Basic statistics of evaluation datasets.
Pylon
TUS-Small
TUS-Large
# Tables
1,746
1,530
5,043
# Base Tables
1,746
10
32
Avg. # Rows
115
4,466
1,915
Avg. # Columns
10
10
11
# Queries
124
1,327
4,296
Avg. # Answers
42
174
280
Metrics. For effectiveness, we report both precision and
recall of top-k search with varying k. At each value of k, we
average the precision and recall numbers over all the queries.
We consider a table candidate a true positive with respect to the
target table if it is in labeled ground truth. We do not require
perfect attribute pair matching as it is a more challenging
setting and requires laborious column-level labeling.
As to efﬁciency, we report indexing time (i.e., total amount
of time in minutes to index all columns in a dataset) and query
response time (i.e., average amount of time in seconds for the
LSH index to return results over all queries in a dataset2).
In evaluation, we randomly sample 1000 queries from TUS-
Large for efﬁcient experiment purposes. The query subset has
an average answer size of 277, which is very close to that of
the full query set (i.e., 280). We use all the queries in Pylon
and TUS-Small datasets.
B. Baselines
We consider two embedding methods and one full approach
as baselines for comparison.
1we ﬁltered these tables using their schema to reduce the chance of them
being union-able to selected tables in the union-able subsets.
2Current implementations include data loading and logging time as well.

---

fastText. Many data management tasks not limited to table
union search [5], [27], [28] have adopted fastText in their
approach, which is a popular word embedding model trained
on Wikipedia documents.
WTE. [8] devises a word embedding-based technique to rep-
resent text values in Web tables. They generate text sequences
from tables for training by serializing tables in two different
ways that capture row-wise relations and relations between
schema and data values respectively. It is reported that the
model using both serialization obtained the best performance
in a task of ranking union-able columns.
D3L. [6] proposed a distance-based framework D3L that
uses ﬁve types of evidence to decide on column union-ability:
(i) attribute name similarity; (ii) attribute extent overlap; (iii)
word-embedding similarity; (iv) format representation similar-
ity; (v) domain distribution similarity for numerical attributes.
Their aggregated approach is shown to be more effective and
efﬁcient than previous work [5], [18] on the TUS benchmark
and another self-curated dataset of open data tables.
C. Comparisons of Interest
We have 5 variants of Pylon to compare against baseline
systems for both effectiveness and efﬁciency in identifying
union-able tables using semantic similarity methods: 3 variants
from the online training data construction strategy and 2
variants from the ofﬂine data construction strategy. In addition,
we have 3 syntactic similarity measures that could be used to
augment each of these 5 variants. Finally, we have 3 base-
lines, two of which are semantic word embedding based, and
hence could also be augmented with the syntactic similarity
measures. The third baseline (D3L) already integrates both
syntactic and semantic similarity, and hence does not beneﬁt
from additional augmentation with syntactic techniques.
Since there are a very large number of alternatives to
compare, we break up the comparisons into four sets, as
follows, and present the results for each set separately. For the
ﬁrst three sets, we restrict ourselves to the online training data
construction strategy for Pylon. We refer to the derived models
as Pylon-fastText, Pylon-WTE, Pylon-LM respectively based
on the corresponding encoder choice. Results for the ofﬂine
data construction strategy show generally similar trends, and
the most interesting are shown in the fourth set.
The ﬁrst set of comparisons look purely at semantic meth-
ods, considering the 3 variants of Pylon and comparing them
to the ﬁrst two baselines. We leave out D3L because it already
incorporates syntactic methods as well. The second set of
comparisons look purely at the beneﬁt obtained when semantic
methods are enhanced with syntactic measures. We do so
for all methods evaluated in the ﬁrst set. Finally, we bring
everything together by comparing the best methods of the
second set with the best integrated baseline, D3L. This is the
ﬁnal top line ”take away” from the experiments, eliding details
from the ﬁrst two sets of comparisons.
D. Experiment Details
As to model training, we train Pylon-fastText for 50 epochs
with a batch size of 16 on 2 NVIDIA GeForce RTX 2080
Ti GPUs; Pylon-WTE for 20 epochs with a batch size of
32 on a single NVIDIA Tesla P100 GPU; Pylon-LM for 20
epochs with a batch size of 8 on 4 NVIDIA Tesla P100
GPUs from Google Cloud Platform. As seen in table II, the
training is especially efﬁcient for simple word embedding
encoders (as only parameters in projection head are updated)
and the ofﬂine data construction strategy (as embeddings are
pre-computed before training). We save the models with the
smallest validation loss. The model training is implemented in
PyTorch [29] and PyTorch Lightning.
TABLE II: Model training time (min / epoch) where each
model is deﬁned by the encoder choice and the training data
construction strategy.
Online Sampling
Ofﬂine Approximate Matching
Pylon-fastText
6.5
0.42
Pylon-WTE
0.99
0.13
Pylon-LM
33
-
For evaluation of table union search, we set the similarity
threshold of LSH index to 0.7 in all experiments and use
the same hash size as D3L. We run all evaluation on a
Ubuntu 20.04.4 LTS machine with 128 GiB RAM and Intel(R)
Xeon(R) Bronze 3106 CPU @ 1.70GHz.
E. Results
As Pylon is an embedding-based approach, we ﬁrst evaluate
Pylon model variants against embedding baselines fastText and
WTE, and inspect the effects of contrastive learning on them.
Experiment 1(a): Comparison of effectiveness between
Pylon model variants and their corresponding base en-
coders. Figure 3 shows the precision and recall of each embed-
ding measure on the Pylon benchmark. Both Pylon-WTE and
Pylon-fastText outperform their corresponding base models
with a notable margin. When k = 40, around the average
answer size, Pylon-WTE is 6% better than WTE on both
metrics, and Pylon-fastText performs better than fastText by
15% on precision and 14% on recall.
Overall, our Pylon-WTE model consistently achieves the
highest precision and recall as k increases. We also note
that Pylon-LM has strong performance up until k = 30 but
degrades after that. This is because Pylon-LM only samples 10
rows from each table to construct embeddings (for indexing
and query efﬁciency) while other word-embedding methods
can afford to encode the entire table at low indexing time,
which we demonstrate in experiment 1(b).
Experiment 1(b): Comparison of efﬁciency between
Pylon model variants and their corresponding base en-
coders. In ﬁgure 4, we see both embedding baselines are
very efﬁcient in index construction and it takes less than
2 minutes to index the entire Pylon dataset. Unlike ﬁxed
embeddings, our models need to infer embeddings at runtime.
For Pylon-fastText and Pylon-WTE, since the encoder is ﬁxed,
the inference cost is exclusively from projection head. It takes
both less than 3.5 minutes to build the index. In contrast, the
runtime inference cost of Pylon-LM is more expensive as the
language model has much more complex architecture and has

---

10
20
30
40
50
60
70
80
90
100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
fastText
Pylon-fastText
WTE
Pylon-WTE
Pylon-LM
10
20
30
40
50
60
70
80
90
100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
fastText
Pylon-fastText
WTE
Pylon-WTE
Pylon-LM
Fig. 3: Top-k precision and recall of embedding measures
on the Pylon dataset.
fastText
Pylon-fastText
WTE
Pylon-WTE
Pylon-LM
Model
0
5
10
15
20
25
30
Indexing Time (min)
1.8
2.4
1.3
3.4
23.8
fastText
Pylon-fastText
WTE
Pylon-WTE
Pylon-LM
Model
0
5
10
15
20
25
Query Response Time (s / query)
15.8
4.3
24.7
2.4
3.0
Fig. 4: Indexing time and query response time on the
Pylon dataset.
0
20 40 60 80 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-fastText
Pylon-fastText-NVF
Pylon-fastText-NV
0
20 40 60 80 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-WTE
Pylon-WTE-NVF
Pylon-WTE-NV
0
20 40 60 80 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-LM
Pylon-LM-NVF
Pylon-LM-NV
0
20 40 60 80 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
0
20 40 60 80 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
0
20 40 60 80 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
(a) Pylon dataset
10
50
90
130
170
210
250
290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-fastText
Pylon-fastText-NVF
Pylon-fastText-NV
10
50
90
130
170
210
250
290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-WTE
Pylon-WTE-NVF
Pylon-WTE-NV
10
50
90
130
170
210
250
290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-LM
Pylon-LM-NVF
Pylon-LM-NV
10
50
90
130
170
210
250
290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
10
50
90
130
170
210
250
290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
10
50
90
130
170
210
250
290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
(b) TUS-Small dataset
Fig. 5: Precision and recall (w.r.t. varying k) of the ensemble of Pylon embedding models and syntactic measures.
130M parameters versus 35.8K parameters in projection head.
We also acknowledge the less efﬁcient implementation of
embedding inference at this point (e.g., run inference for each
column without batch predictions). Nevertheless, indexing
time, as a one-time overhead, can be amortized among queries.
On the other hand, all of our models are considerably
more efﬁcient in query response time. Pylon-fastText is 2.7x
faster than fastText and Pylon-WTE is 9x faster than WTE.
The signiﬁcant speedup of query response time is attributed
to contrastive learning where embeddings of attribute values
occurring in the same context are pushed close to each other
and to have high cosine similarity whereas embeddings of
two random columns are pushed apart and to have low cosine
similarity. As the embedding similarity between two random
columns is suppressed, this dramatically reduces the chance
of two random columns sharing many LSH buckets. In other
words, our column embeddings are trained in a speciﬁc way
that aligns with the similarity measure LSH index approxi-
mates and LSH index can process much fewer candidates at
the conﬁgured similarity threshold.
To illustrate the suppression effect of contrastive learning,
we compare heatmaps of pairwise cosine similarity of column
embeddings encoded by WTE and Pylon-WTE respectively.
Consider the three text columns of the ﬁrst table in Figure 1.
As shown in Figure 6(a), the pairwise cosine similarity of
WTE embeddings is mostly above 0.5. There is a very high
similarity (0.87) between the ”title” column and the ”venue”
column and they will be mistakenly viewed as union-able. But
this is not an issue for Pylon-WTE embeddings as shown in
Figure 6(b) where the pairwise similarity between different
columns are much lower (below 0.51) and the LSH index will
not return the ”venue” column as a union-able candidate of
the ”title” column.
In the next set of experiments, we consider three syntactic

---

Fig. 6: Pairwise cosine similarity of column embeddings: (a)
WTE embeddings; (b) Pylon-WTE embeddings.
measures used by D3L and evaluate how much they can
augment our embedding measures.
1) Name (N): Jaccard similarity between q-gram sets of
attribute names.
2) Value (V ): Jaccard similarity between the TF-IDF sets
of attribute values.
3) Format (F): Jaccard similarity between regular expres-
sion sets of attribute values.
Experiment 2: Effectiveness of the ensemble of Pylon
model variants and syntactic measures. Figure 5(a) and
(b) show the precision and recall of the ensemble of Pylon
embedding models and syntactic measures on Pylon and TUS-
Small datasets respectively. We consistently observe from both
datasets that adding syntactic measures can further enhance the
performance. In particular, name (N) and value (V ) similarity
are most effective syntactic measures. Around the average
answer size of the Pylon dataset (k = 40), N and V together
raise up the precision and recall of Pylon-fastText by nearly
20%, of Pylon-WTE by 10%, and of Pylon-LM by over 5%.
Similarly, around the average answer size of the TUS-Small
dataset (k = 170), there is an increase of about 10% in
both precision and recall for Pylon-fastText, about 5% for
Pylon-WTE, and more than 10% for Pylon-LM.
We also observe that adding additional format measure
(F) hurts the performance (notably on the Pylon dataset
and slightly on TUS-small). This is because tables in the
Pylon dataset are mostly from disparate sources and so the
value format tends to be inconsistent across tables whereas
tables in TUS-Small are synthesized from only 8 base tables
and it is much more likely for many tables to share format
similarity. Even worse, including format index imposes non-
trivial runtime cost (see ﬁgure 7). For example, compared
to model Pylon-WTE-NV, the query response time of Pylon-
WTE-NVF (with the extra format measure) surges by 66.7%
on the Pylon dataset and by 32.2% on TUS-Small.
Finally, we compare our best-performing model Pylon-
WTE-NV with the state-of-the-art D3L. As Pylon-WTE-NV
does not use format and domain measures in D3L, for fair
comparison, we consider three versions of D3L. We refer to
the full version of D3L as D3L-5, the one without the format
measure as D3L-4, and the one without format and domain
measures as D3L-3.
Pylon-fastText
Pylon-WTE
Pylon-LM
0
1
2
3
4
5
6
7
Query Response Time (s / query)
7.2
3.9
4.2
4.7
2.3
3.3
NVF
NV
(a) Pylon dataset
Pylon-fastText
Pylon-WTE
Pylon-LM
0
5
10
15
20
25
30
35
Query Response Time (s / query)
34.9
27.3
16.2
28.7
20.6
11.1
NVF
NV
(b) TUS-Small dataset
Fig. 7: Comparison of query response time between including
and excluding the format measure.
Experiment 3: Comparison of effectiveness and efﬁ-
ciency between our best model and D3L. Figure 8 shows
the performance of Pylon-WTE-NV and three D3L variants on
Pylon, TUS-Small, TUS-Large datasets respectively. Around
the average answer size (k = 40) of the Pylon dataset, Pylon-
WTE-NV is around 15% better than the strongest D3L instance
(i.e., D3L-3) in both precision and recall. Pylon-WTE-NV
performs much better than D3L in this case because our
embedding model using contrastive learning is optimized for
indexing/search data structure and is trained on a dataset of a
distribution similar to the test set and thus can capture more
semantics than the off-the-shelf fastText embedding model
used in D3L.
On TUS-Small and TUS-Large, we observe all instances
have relatively competitive performance while Pylon-WTE-
NV performs marginally better compared to all D3L variants.
On TUS-Small, around the average answer size (k = 170),
Pylon-WTE-NV is 2% better than D3L-3 and 5% better than
D3L-5 in both precision and recall. On TUS-Large, around
the average answer size (k = 290), Pylon-WTE-NV is more
than 2% better than D3L variants in both metrics. The
smaller performance gap is due to the synthetic nature of TUS
benchmark where most of union-able tables are generated from
the same base table and share common attribute names and
many attribute values. So syntactic measures (N and V ) can
capture most of similarity signals and obtain high precision
and recall even without support of semantic evidence.
Additional to the performance gain, the biggest advantage of
Pylon-WTE-NV is the fast query response time. On the Pylon
dataset, our model is nearly 9x faster than the full version
D3L-5 and 7x faster than D3L-3. Even on TUS-Small and
TUS-Large, which are datasets of a different data distribution
(open data tables), we still save runtime by 44% and 32%
respectively compared to D3L-5, and by 35.5% and 21.9%
respectively compared to D3L-3.
Experiment 4: Effectiveness and efﬁciency of Pylon
model variants from the ofﬂine training data construction
strategy. Figure 10 shows the precision and recall of 4 Pylon
variants from two training data construction strategies and their
baselines. On the Pylon dataset, around the average answer
size (k = 40), two Pylon models from the alternative data
construction strategy, Pylon-WTE-ofﬂine and Pylon-fastText-

---

0
20
40
60
80
100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
Precision
Pylon-WTE-NV
D3L-3
D3L-4
D3L-5
0
20
40
60
80
100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
Recall
Pylon-WTE-NV
D3L-3
D3L-4
D3L-5
(a) Pylon dataset
10
50
90 130 170 210 250 290
k
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-WTE-NV
D3L-3
D3L-4
D3L-5
10
50
90 130 170 210 250 290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
Pylon-WTE-NV
D3L-3
D3L-4
D3L-5
(b) TUS-Small dataset
10
50
90 130 170 210 250 290
k
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-WTE-NV
D3L-3
D3L-4
D3L-5
10
50
90 130 170 210 250 290
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
Pylon-WTE-NV
D3L-3
D3L-4
D3L-5
(c) TUS-Large dataset
Fig. 8: Comparison of precision and recall between D3L instances and our best model Pylon-WTE-NV.
D3L-5
D3L-4
D3L-3
Pylon-WTE-NV
Model
0.0
2.5
5.0
7.5
10.0
12.5
15.0
17.5
20.0
Query Response Time (s / query)
19.6
17.1
16.1
2.3
(a) Pylon dataset
D3L-5
D3L-4
D3L-3
Pylon-WTE-NV
Model
0
5
10
15
20
25
30
35
40
Query Response Time (s / query)
41.2
42.2
32
20.6
(b) TUS-Small dataset
D3L-5
D3L-4
D3L-3
Pylon-WTE-NV
Model
0
20
40
60
80
100
Query Response Time (s / query)
110
110.5
95.6
74.6
(c) TUS-Large dataset
Fig. 9: Comparison of query response time between D3L instances and Pylon-WTE-NV.
ofﬂine, retain strong performance and outperform the corre-
sponding baseline by 3% and 9% respectively. Note that Pylon
models derived from the sampling data construction strategy
have consistently better performance as k increases. We also
observe a similar trend on the TUS benchmark while the
performance gap of all instances is smaller.
As shown in ﬁgure 11, both new models are efﬁcient in
indexing time and query response time. Compared to the
corresponding baseline, Pylon-WTE-ofﬂine is 12x faster and
Pylon-fastText-ofﬂine is 14.5x faster in query response time.
Again, this signiﬁcant speedup demonstrates the value of
considering characteristics of indexing/search data structure
in the training of embedding models and the distinguishing
power of contrastive learning, which enables the LSH index
to work more effectively with embeddings.
F. Discussion
We also leave and discuss a few clues for future extensions.
Alternative Contrastive Loss. While the loss function used
in this project is an effective one, it is not the only feasible
training objective for self-supervised contrastive learning. For
example, triplet loss [30] considers a triplet (x, x+, x−) as a
training example where x is an input, x+ is a positive sample
(belonging to the same class as x or semantically similar to
x) and x−is a negative sample. Additionally, what considers
as negative examples and ”hardness” of negative examples are
also interesting aspects to explore.
Veriﬁcation of Column Union-ability. Besides quantitative
evaluation, we also manually inspect results of a few queries
for each dataset. We observe that in some correct table
matches, there are misalignment of union-able columns. To
mitigate this issue, we consider that progress in semantic col-
umn type prediction [31], [32] can be beneﬁcial for verifying
the union-ability of columns as a post-processing step.
V. RELATED WORK
Our work is most related to data integration on the web and
data discovery in enterprise and open data lakes.
Web Table Search. [33] presents OCTOPUS that integrate
relevant data tables from relational sources on the web. OCTO-
PUS includes operators that perform a search-style keyword
query over extracted relations and their context, and cluster re-
sults into groups of union-able tables using multiple measures
like TF-IDF cosine similarity. [34] deﬁnes three information
gathering tasks on Web tables. The task of augmentation by
example essentially involves ﬁnding union-able tables that
can be used to ﬁll in the missing values in a given table.
Their Infogather system leverages indirectly matching tables
in addition to directly matching ones to augment a user input.
[4] formalizes the problem of detecting related Web tables. At
the logical level, the work considers two tables related to each

---

10 20 30 40 50 60 70 80 90 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Precision
Pylon-WTE
Pylon-WTE-offline
WTE
Pylon-fastText
Pylon-fastText-offline
fastText
10 20 30 40 50 60 70 80 90 100
k
0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
Recall
Pylon-WTE
Pylon-WTE-offline
WTE
Pylon-fastText
Pylon-fastText-offline
fastText
Fig. 10: Top-k precision and recall of 6 embedding
measures on the Pylon dataset.
fastText
Pylon-fastText
Pylon-fastText-offline
WTE
Pylon-WTE
Pylon-WTE-offline
Model
0
1
2
3
4
Indexing Time (min)
1.8
2.4
2.2
1.3
3.4
1.7
fastText
Pylon-fastText
Pylon-fastText-offline
WTE
Pylon-WTE
Pylon-WTE-offline
Model
0
5
10
15
20
25
Query Response Time (s / query)
15.8
4.3
1.2
24.7
2.4
1.7
Fig. 11: Indexing time and query response time on the
Pylon dataset.
other if they can be viewed as results to queries over the same
(possibly hypothetical) original table. In particular, one type
of relatedness they deﬁne is Entity Complement where two
tables with coherent and complementary subject entities can be
unioned over the common attributes. This deﬁnition requires
each table to have a subject column of entities indicating what
the table is about and that the subject column can be detected.
Following the deﬁnition, the work captures entity consistency
and expansion by measuring the relatedness of detected sets
of entities with signals mined from external ontology sources.
Finally, they perform schema mapping of two complement
tables by computing a schema consistency score made up of
the similarity in attribute names, data types, and values.
Data Discovery in the Enterprise. [35] identiﬁes data dis-
covery challenges in the enterprise environment. The position
paper describes a data discovery system including enrichment
primitives that allow a user to perform entity and schema
complement operations. Building on top of the vision in
[35], [18] presents AURUM, a system that models syntactic
relationships between datasets in a graph data structure. With a
two-step process of proﬁling and indexing data, AURUM con-
structs a graph with nodes representing column signatures and
weighted edges indicating the similarity between two nodes
(e.g., content and schema similarity). By framing queries as
graph traverse problems, AURUM can support varied discov-
ery needs of a user such as keyword search and similar content
search (which can be used for ﬁnding union-able columns and
tables).
[27] further employs word embeddings in AURUM
to identify semantically related objects in the graph.
Data Discovery in Open Data Lakes. [5] deﬁnes the table
union search problem on open data and decomposes it as ﬁnd-
ing union-able attributes. They propose three statistical tests
to determine the attribute union-ability: (1) set union-ability
measure based on value overlap; (2) semantic union-ability
measure based on ontology class overlap; and (3) natural
language union-ability measure based on word embeddings. A
synthesized benchmark consisting of tables from Canadian and
UK open data shows that natural language union-ability works
best for larger k in top-k search. In the meantime, set union-
ability is decent when k = 1 for each query but vulnerable
to value overlap in attributes of non-unionable tables, and
semantic union-ability stays competitive to ﬁnd some union-
able tables for most queries despite incomplete coverage of
external ontologies. The ensemble of three measures further
improves the evaluation metrics.
[6] adopts more types of
similarity measures based on schema- and instance-level ﬁne-
grained features. Without relying on any external sources,
their D3L framework is shown effective and efﬁcient on open
data lakes. EMBDI [28] proposes a graph model to capture
relationships across relational tables and derives training se-
quences from random walks over the graph. They further
take advantage of embedding training algorithms like fastText
to construct embedding models. Their relational embeddings
demonstrate promising results for data integration tasks such
as schema matching and entity resolution. SANTOS [36],
a very recent work, leverages the relationship of pairs of
attributes for table union search. However, it relies on the
existence of a relationship and the coverage of the relationships
in a knowledge base. Although SANTOS also draws on the
data lake itself to discover new relationships using the co-
occurrence frequency of attribute pairs, it particularly misses
rare yet important relationships.
For a broader overview of the literature, we refer readers to
the survey of dataset search [1].
VI. CONCLUSION
In this work, we formulate the table union search problem
as an unsupervised representation learning and embedding
retrieval task. We present Pylon, a self-supervised contrastive
learning framework that models both data semantics and char-
acteristics of indexing/search data structure. We also demon-
strate that our approach is both more effective and efﬁcient
compared to the state-of-the-art.

---

REFERENCES
[1] A. Chapman, E. Simperl, L. Koesten, G. Konstantinidis, L.-D. Ib´a˜nez,
E. Kacprzak, and P. Groth, “Dataset search: a survey,” The VLDB
Journal, vol. 29, no. 1, pp. 251–272, 2020.
[2] D. Brickley, M. Burgess, and N. Noy, “Google dataset search: Building
a search engine for datasets in an open web ecosystem,” in The World
Wide Web Conference, 2019, pp. 1365–1375.
[3] M. J. Cafarella, A. Halevy, D. Z. Wang, E. Wu, and Y. Zhang,
“Webtables: Exploring the power of tables on the web,” Proc. VLDB
Endow., vol. 1, no. 1, p. 538–549, 2008.
[4] A. Das Sarma, L. Fang, N. Gupta, A. Halevy, H. Lee, F. Wu, R. Xin, and
C. Yu, “Finding related tables,” in Proceedings of the 2012 ACM SIG-
MOD International Conference on Management of Data, ser. SIGMOD
’12.
New York, NY, USA: Association for Computing Machinery,
2012, p. 817–828.
[5] F. Nargesian, E. Zhu, K. Q. Pu, and R. J. Miller, “Table union search
on open data,” Proc. VLDB Endow., vol. 11, no. 7, p. 813–825, 2018.
[6] A. Bogatu, A. A. Fernandes, N. W. Paton, and N. Konstantinou, “Dataset
discovery in data lakes,” in 2020 IEEE 36th International Conference
on Data Engineering (ICDE).
IEEE, 2020, pp. 709–720.
[7] F. M. Suchanek, G. Kasneci, and G. Weikum, “Yago: a core of semantic
knowledge,” in Proceedings of the 16th international conference on
World Wide Web, 2007, pp. 697–706.
[8] M. G¨unther, M. Thiele, J. Gonsior, and W. Lehner, “Pre-trained web
table embeddings for table discovery,” in Fourth Workshop in Exploiting
AI Techniques for Data Management, ser. aiDM ’21.
New York, NY,
USA: Association for Computing Machinery, 2021, p. 24–31.
[9] C. Koutras, G. Siachamis, A. Ionescu, K. Psarakis, J. Brons, M. Fragk-
oulis, C. Loﬁ, A. Bonifati, and A. Katsifodimos, “Valentine: Evaluating
matching techniques for dataset discovery,” in 2021 IEEE 37th Inter-
national Conference on Data Engineering (ICDE).
IEEE, 2021, pp.
468–479.
[10] X. Deng, H. Sun, A. Lees, Y. Wu, and C. Yu, “Turl: table understanding
through representation learning,” Proceedings of the VLDB Endowment,
vol. 14, no. 3, pp. 307–319, 2020.
[11] N. Tang, J. Fan, F. Li, J. Tu, X. Du, G. Li, S. Madden, and M. Ouzzani,
“Rpt: relational pre-trained transformer is almost all you need towards
democratizing data preparation,” Proceedings of the VLDB Endowment,
vol. 14, no. 8, pp. 1254–1261, 2021.
[12] Y. Li, J. Li, Y. Suhara, A. Doan, and W.-C. Tan, “Deep entity matching
with pre-trained language models,” Proceedings of the VLDB Endow-
ment, vol. 14, no. 1, pp. 50–60, 2020.
[13] Y. Li, J. Li, Y. Suhara, J. Wang, W. Hirota, and W.-C. Tan, “Deep
entity matching: Challenges and opportunities,” Journal of Data and
Information Quality (JDIQ), vol. 13, no. 1, pp. 1–17, 2021.
[14] T. Chen, S. Kornblith, M. Norouzi, and G. Hinton, “A simple framework
for contrastive learning of visual representations,” in International
conference on machine learning.
PMLR, 2020, pp. 1597–1607.
[15] E. Rahm and P. A. Bernstein, “A survey of approaches to automatic
schema matching,” VLDB J., vol. 10, no. 4, pp. 334–350, 2001.
[16] Z. Chen, Y. Wang, V. R. Narasayya, and S. Chaudhuri, “Customizable
and scalable fuzzy join for big data,” Proc. VLDB Endow., vol. 12,
no. 12, pp. 2106–2117, 2019.
[17] S. Suri, I. F. Ilyas, C. R´e, and T. Rekatsinas, “Ember: No-code context
enrichment via similarity-based keyless joins,” Proc. VLDB Endow.,
vol. 15, no. 3, pp. 699–712, 2021.
[18] R. C. Fernandez, Z. Abedjan, F. Koko, G. Yuan, S. Madden, and
M. Stonebraker, “Aurum: A data discovery system,” in 2018 IEEE 34th
International Conference on Data Engineering (ICDE).
IEEE, 2018,
pp. 1001–1012.
[19] E. Zhu, D. Deng, F. Nargesian, and R. J. Miller, “Josie: Overlap set
similarity search for ﬁnding joinable tables in data lakes,” in Proceedings
of the 2019 International Conference on Management of Data, 2019, pp.
847–864.
[20] P. Yin, G. Neubig, W.-t. Yih, and S. Riedel, “Tabert: Pretraining for
joint understanding of textual and tabular data,” in Proceedings of the
58th Annual Meeting of the Association for Computational Linguistics,
2020, pp. 8413–8426.
[21] J. Devlin, M.-W. Chang, K. Lee, and K. Toutanova, “Bert: Pre-training
of deep bidirectional transformers for language understanding,” in
Proceedings of the 2019 Conference of the North American Chapter
of the Association for Computational Linguistics: Human Language
Technologies, Volume 1 (Long and Short Papers), 2019, pp. 4171–4186.
[22] P. Indyk and R. Motwani, “Approximate nearest neighbors: towards
removing the curse of dimensionality,” in Proceedings of the thirtieth
annual ACM symposium on Theory of computing, 1998, pp. 604–613.
[23] Y. A. Malkov and D. A. Yashunin, “Efﬁcient and robust approxi-
mate nearest neighbor search using hierarchical navigable small world
graphs,” IEEE transactions on pattern analysis and machine intelligence,
vol. 42, no. 4, pp. 824–836, 2018.
[24] M. S. Charikar, “Similarity estimation techniques from rounding algo-
rithms,” in Proceedings of the thiry-fourth annual ACM symposium on
Theory of computing, 2002, pp. 380–388.
[25] M. Hulsebos, c. Demiralp, and P. Groth, “Gittables: A large-scale corpus
of relational tables,” arXiv preprint arXiv:2106.07258, 2021.
[26] R. V. Guha, D. Brickley, and S. Macbeth, “Schema. org: evolution of
structured data on the web,” Communications of the ACM, vol. 59, no. 2,
pp. 44–51, 2016.
[27] R. C. Fernandez, E. Mansour, A. A. Qahtan, A. Elmagarmid, I. Ilyas,
S. Madden, M. Ouzzani, M. Stonebraker, and N. Tang, “Seeping se-
mantics: Linking datasets using word embeddings for data discovery,” in
2018 IEEE 34th International Conference on Data Engineering (ICDE).
IEEE, 2018, pp. 989–1000.
[28] R. Cappuzzo, P. Papotti, and S. Thirumuruganathan, “Creating embed-
dings of heterogeneous relational datasets for data integration tasks,” in
Proceedings of the 2020 ACM SIGMOD International Conference on
Management of Data, 2020, pp. 1335–1349.
[29] A. Paszke, S. Gross, F. Massa, A. Lerer, J. Bradbury, G. Chanan,
T. Killeen, Z. Lin, N. Gimelshein, L. Antiga, A. Desmaison, A. Kopf,
E. Yang, Z. DeVito, M. Raison, A. Tejani, S. Chilamkurthy, B. Steiner,
L. Fang, J. Bai, and S. Chintala, “Pytorch: An imperative style, high-
performance deep learning library,” in Advances in Neural Information
Processing Systems 32.
Curran Associates, Inc., 2019, pp. 8024–8035.
[30] F. Schroff, D. Kalenichenko, and J. Philbin, “Facenet: A uniﬁed embed-
ding for face recognition and clustering,” in Proceedings of the IEEE
conference on computer vision and pattern recognition, 2015, pp. 815–
823.
[31] D. Zhang, Y. Suhara, J. Li, M. Hulsebos, C. gatay Demiralp, and W.-C.
Tan, “Sato: Contextual semantic type detection in tables,” Proceedings
of the VLDB Endowment, vol. 13, no. 11, 2020.
[32] Y. Suhara, J. Li, Y. Li, D. Zhang, C¸ . Demiralp, C. Chen, and W.-C. Tan,
“Annotating columns with pre-trained language models,” in Proceedings
of the 2022 International Conference on Management of Data, 2022, pp.
1493–1503.
[33] M. J. Cafarella, A. Halevy, and N. Khoussainova, “Data integration for
the relational web,” Proceedings of the VLDB Endowment, vol. 2, no. 1,
pp. 1090–1101, 2009.
[34] M. Yakout, K. Ganjam, K. Chakrabarti, and S. Chaudhuri, “Infogather:
entity augmentation and attribute discovery by holistic matching with
web tables,” in Proceedings of the 2012 ACM SIGMOD International
Conference on Management of Data, 2012, pp. 97–108.
[35] R. C. Fernandez, Z. Abedjan, S. Madden, and M. Stonebraker, “Towards
large-scale data discovery: position paper,” in Proceedings of the Third
International Workshop on Exploratory Search in Databases and the
Web, San Francisco, CA, USA, July 1, 2016.
ACM, 2016, pp. 3–5.
[36] A. Khatiwada, G. Fan, R. Shraga, Z. Chen, W. Gatterbauer, R. J. Miller,
and M. Riedewald, “Santos: Relationship-based semantic table union
search,” arXiv preprint arXiv:2209.13589, 2022.

---

