# Explaining Dataset Changes for Semantic Data Versioning with Explain-Da-V (Techn

> 来源: https://arxiv.org/pdf/2301.13095

Explaining Dataset Changes for Semantic Data Versioning with
Explain-Da-V (Technical Report)
Roee Shraga, Renée J. Miller
Northeastern University
Boston, MA, USA
{r.shraga,miller}@northeastern.edu
ABSTRACT
In multi-user environments in which data science and analysis
is collaborative, multiple versions of the same datasets are gen-
erated. While managing and storing data versions has received
some attention in the research literature, the semantic nature of
such changes has remained under-explored. In this work, we in-
troduce Explain-Da-V, a framework aiming to explain changes
between two given dataset versions. Explain-Da-V generates ex-
planations that use data transformations to explain changes. We
further introduce a set of measures that evaluate the validity, gener-
alizability, and explainability of these explanations. We empirically
show, using an adapted existing benchmark and a newly created
benchmark, that Explain-Da-V generates better explanations than
existing data transformation synthesis methods.
PVLDB Reference Format:
Roee Shraga, Renée J. Miller. Explaining Dataset Changes for Semantic
Data Versioning with Explain-Da-V (Technical Report). PVLDB, XX(XX):
XXX-XXX, 2023.
doi:XX.XX/XXX.XX
PVLDB Artifact Availability:
The source code, data, and/or other artifacts have been made available at
https://github.com/shraga89/ExplainDaV.
1
INTRODUCTION
Data is one of the most important ingredients in any decision mak-
ing process. The amount and size of data is growing and datasets
are being reused for multiple analyses. Data may be stored in dif-
ferent systems (e.g., data lakes [77]), vary in their formats, and may
or may not contain metadata. Data projects often involve multiple
users that work on datasets conjointly or independently, creating
different data versions. Accordingly, data versioning becomes an
important ingredient in data management [21]. Nevertheless, even
if versions are well managed [22], the documentation may be super-
ficial, e.g., embedded in filenames, which can be very inadequate. In
addition, the collaboration itself may not be structured or properly
managed and each user may perform different, often undocumented
processing steps on data [55, 60–62, 106]. For example, some users
may clean the data by removing rows or columns if they have
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. XX, No. XX ISSN 2150-8097.
doi:XX.XX/XXX.XX
duplicated or missing information. Other users extract features,
transforming the current data to create new columns.
Current tools have limited data versioning support [60]. Gen-
erally speaking, data, as opposed to code, may be less docu-
mented [61, 106] and data changes, even if documented, are rarely
accompanied by useful descriptions, making it difficult to under-
stand them [55]. Within a close collaboration group, a notebook
containing transformation code may be shared, but between organi-
zations this is rarely done. Consider, for example, the many versions
of important datasets shared on open data portals [42, 43, 56] where
transformations are generally not shared. The lack of sufficient ver-
sion documentation results in reduced reproducibility and trust
among users using the data [62, 106]. While managing and storing
data versions has received attention in literature [21, 22, 57, 88, 105],
the semantic nature of such changes has remained under-explored.
We motivate our work using the following example.
(a) Dataset version created by UserA
(b) Dataset version created by UserB
Figure 1: Example dataset versions about movies created by
two users. Attribute names are provided in Example 1.
Example 1. Figure 1 presents two dataset versions about movies.
We discard the column names from the figure to illustrate a realistic
(data lake) scenario. For readability, a0 is a tuple id, a1 represents
the movie title, a2 measures the movie runtime in minutes, a3 as-
signs a rating to the movie, and a4 provides the genre of the movie.
For convenience of presentation, lets assume that the table on the
bottom (Figure 1b) was created by UserB as a derivation of the table
on the top (Figure 1a) that was created by UserA. Even properly
naming the tables, e.g., Table 1a as data1_v1.csv and Table 1b
as data1_v2.csv, or knowing that Table 1b is derived from Ta-
ble 1a [21], does not help UserA to get a semantic understanding of
what UserB changed in the table or, more importantly, what data
processing steps UserB has performed.
arXiv:2301.13095v1  [cs.DB]  30 Jan 2023

---

Example 1 illustrates the need for a semantic understanding of a
new dataset version. Aiming to fill this gap, this work provides the
setup and new solution to explain the semantic changes between
two dataset versions. Specifically, our goal is to automatically ex-
plain (in a simple user friendly way) the steps leading from one
version of dataset to the other. For example, how was column a6 in
Figure 1b created? or why was the fourth row in Figure 1a deleted?
Note that the changer’s intent, which is subjective, cannot be truly
reverse engineered. Our objective is to provide the other user an
accurate explanation, e.g., a set of functions, that describes the
changes. Following this goal, we return to our motivating example.
Example 1 (cont.). Figure 2 illustrates an annotated version
of Figure 1b, that explains the changes. In other words, Figure 2
reverse engineers the changes made by UserB in a way that a user
can understand. Specifically, UserB cleaned the rows that contain
NaN values (in this case m4) and extracted numerical features. The
certification of the movie, given in parenthesis in a1, was extracted
to create a5 and the column a6 converts the units of a2, the runtime
of the movie, from minutes to hours. Since the range of movie ratings
(a3) is limited, UserB also discretized the values to create four rating
classes in column a7. Aiming to examine the effect of title length (an
effect found for paper citations [44]) within the domain of movies,
UserB added column a8 that provides the length of titles from a1.
Figure 2: An interpretation of the changes between the
dataset versions given in Figure 1. The columns are colored
based on their origin (e.g., a5 is blue because it originates
from the blue a1) and annotated column transformations
are given at the bottom. The annotated row transformation
is given on the right, in this case removing a row, which is
also illustrated by diagonal stripes over the row.
As illustrated in Example 1, there are a variety of possible trans-
formations (e.g., multiplying/dividing the values of a numeric col-
umn, e.g., a3, by a constant), potentially creating an infinite possi-
ble number of changes to a dataset. These changes can be vertical
(changing columns) or horizontal (changing rows), they can add
information (adding columns/rows) or remove information (remov-
ing columns/rows) and they can involve different data types, e.g.,
textual to numeric (a1 to a8) or numeric to categorical (a3 to a7).
In addition, a user may also change a cell in the table, e.g., replacing
the NaN value in row m4 by 146.25 (the mean value of the other
values in the column), or perform a full-table operation, e.g., trans-
posing the table. Transformation discovery methods are used for
multiple data management tasks including fuzzy joins [109], data
wrangling [25], entity consolidation [45] and more [18, 52, 54, 58]
mainly focusing on textual (text-to-text) transformations and con-
sider the transformed values (rather than the transformation itself).
Our method mainly focuses on data versioning, for which, the trans-
formations themselves, as a means of explaining changes among
different dataset versions, is the main interest. Our resolved trans-
formations also cover transformations that involve, among others,
numeric transformations. The term “explanation” became quite
common recently and may be associated with multiple meanings.
For example, both El Gebaly et al. [47] and Kim et al. [65] use data
summaries as explanations. Explain3D [101], which shares a simi-
lar context to ours, explains dataset disagreements with syntactic
provenance-based and value-based modification mappings. In this
work the main component of an explanation is a transformation
that explains change. This paper makes the following contributions.
(1) Semantic Data Versioning Definition: we define and solve
a novel problem of semantic data versioning by explaining the
changes between two dataset versions.
(2) Vertical and Horizontal Data Transformation Resolution
Across Different Data Types: we present a solution to the
problem of semantic data versioning that examines both vertical
(adding/removing columns) and horizontal (adding/removing
rows) transformations that involve multiple data types.
(3) Semantic Data Versioning Metrics: we provide a set of
evaluation measures to examine the quality of explanations in
terms of validity, generalizablity, and explainability.
(4) Semantic Data Versioning Benchmark: we introduce a new
data versioning benchmark composed of 5 version-sets including
342 different dataset versions representing a total of 1702 changes.1
(5)
Empirical
Evaluation:
our
experiments
show
that
Explain-Da-V performs better than multiple baselines on
both our new version benchmark and on an existing data science
pipeline benchmark [1]. We analyze the impact of different
components of our solution on performance.
In this paper, we assume two tables are given where one is known
to have been derived from the other (i.e., is a version it) and we know
a match between the attributes and tuples the two tables share. This
work focuses on “internal” additions, deletions, or modifications
(modeled as deletions followed by additions). External additions,
e.g., finding joinable tables [108] and joining them with a table to
create a new version, are reserved for future work.
2
RELATED WORK
We are, to the best of our knowledge, the first to address the seman-
tic aspect of data versioning. Yet, related research exists ranging
from synthesizing data transformations to exploring data change.
2.1
Data Versioning
Data versioning research mainly focus on developing version man-
agers to decrease the need for storing many versions of large
datasets [77]. For example, DataHub provides a git-like interface
to manage, store, recreate, and retrieve versions using a directed
version graph [21]. Follow-up research further studied the trade-off
between recreation and storage in a principled way analyzing six dif-
ferent settings [22]. Recently, Schüle et al. presented TardisDB [88],
1Code and benchmark are publicly available [15].
2

---

an SQL extension to support version management. TardisDB uses
named branches over tables, to monitor table versions and track
their modification history. In contrast, we focus on the semantic
aspects of data versioning, zooming in on explaining the semantic
differences between dataset versions. Schema versioning has also
been studied [85]. Although schemata may change over time [94],
which provides semantic hints to data change, we assume metadata
is not always complete and may be ambiguous [77]. Hence, we
focus only on the versioning of the data itself.
Multiple methods find or discover related tables [33, 41] (e.g.,
joinable [108] and unionable [63, 78]). While different versions of
a table may be related and found using these methods, our work
assumes that the discovery has already been done and aims at pro-
viding a semantic explanation for the differences between versions.
2.2
Data Change, Difference, and Integration
We assume that some match between the attributes and tuples of
the versions is given. This assumption is rooted in many years of
data integration research, exploring attribute matching (schema
matching) [84, 90], tuple matching (entity resolution) [48, 70], and
others [20, 64, 73]. Earlier works looked into change and copy
detection in structured data [34, 35], which was later extended also
to semi-structured documents such as XML [38, 79, 102].
Acknowledging data change, Bleifuß et al. [23] envision systems
that can interactively explore such change. They present a model
of what changed, where, when and how, using what they call a
change-cube to monitor the history of changes over time using
methodologies such as time-series clustering [26]. DBChEx [24] is
a tool to explore data and schema change using a set of exploration
primitives. While similar in nature, this line of work focuses mainly
on how to explore change aiming to answer questions such as “How
many changes have there been in recent minutes?" and “How old
are the entities in table Y? When were they last updated?" [23, 24].
Our work focuses on local changes between versions and how the
changes were performed (which transformations were applied?),
e.g., how did UserB create the table in Figure 1b from Figure 1a.
Another related research area is explaining query answers [72, 87].
Given a query and a database, they explain query answers using
the tuples in the given database, e.g., using provenance [36]. We,
in contrast, explain dataset changes using data transformations.
While changes can be thought of as a set of queries, explanations
for queries that involve non-trivial transformations (e.g., adding a5
in Example 1) cannot be explained only using the tuples.
2.3
Data Transformation By Example
The final related line of research we cover aims to automatically
transform data. Largely, given input and output tables (datasets) or
their subsets (examples), the goal of such approaches is to find a
transformation (program) such that if it is applied over the input we
get the output. It is worth noting that earlier work has referred to
this problem as query reverse engineering [80, 98], which is roughly
the same idea, i.e., finding a query that generates the output using
the input. This line of work can be divided into two main groups.
The first group is rooted in a paradigm called programming-by-
example (PBE) [25, 50, 52, 58, 59, 92, 93, 109], where the goal is to
synthesize a program that manipulates a given input to get a given
output. To do so, methods design different search spaces (operators
to be applied over the input) and apply different search algorithms.
For example, Foofah [58] creates a search space using operators
such as drop (delete a column) and split (separate a column by some
delimiter) and search the space using A* heuristic search. Clx [59]
also introduces string patterns such as regular expressions to the
search space and tokenizations. Data Diff [95] applies a search
approach to “patch” transformations, summarizing distribution
changes, including one numeric patch (operator) supporting linear
transformations with pre-defined (randomly selected) parameters.
Muller et al. describes differences between relational databases
with what they call “update distance” [75] using a similar searching
approach. Finally, Bogatu et al. introduced functional dependencies
to navigate the search space [25], which we also use in our work.
The second group focuses on creating transformation repos-
itories from external sources such as Web Forms, Knowledge
Bases [18, 81], GitHub and Stackoverflow [53, 54]. Transform Data
by Example (TDE) [53], instead of searching through a space of pre-
defined possible operations, creates a search engine where trans-
formation functions are crawled from GitHub and Stackoverflow.
Instead of applying heuristic search such as A*, TDE ranks candi-
date functions to find relevant functions. TDE was later extended
to allow transformation search based on patterns [54]. DataX-
Former [18] and Proteus [81] create a repository of tables from
which desired output values can be extracted.
A similar line of research revolves around resolving data prepa-
ration and analysis transformations [19, 103, 104]. AutoPandas [19]
focuses on Pandas library [14] and aims to synthesize a program us-
ing pandas functions. Auto-pipeline [104] extends the “by-example"
paradigm to “by-target", meaning that the output the user provides
is not necessarily aligned with the input and can require table-
reshaping operations (e.g., group by). Auto-pipeline comes in two
variations, namely, search (which is equivalent, yet extended to
what is described above) and deep reinforcement learning. The for-
mer can be a candidate baseline for our approach. The latter requires
training data which we assume does not exist in our setting.
In contrast to PBE and query reverse engineering, we do not
focus on matching input to output. Rather than looking only at
success rates (is the transformation valid), our search is guided
by the principle of creating valid, generalizable, and explainable
transformations. In our approach, these transformations can be
multi-dimensional (adding/removing attributes/tuples) and address
multiple data-types (e.g., numeric, categorial, and text transforma-
tions). While our string-based transformation resolution is based
on an extended Foofah, we also support numeric transformations
using explainable machine-learning algorithms to fit the appropriate
transformation rather than searching a very large space of possible
transformations. We go beyond Foofah to support text-to-numeric
transformations (e.g., measuring the length of a string) and text
cleaning operations (e.g., stopword removal and lemmatization).
3
SEMANTIC DATA VERSIONING
A dataset is denoted by a table 𝑇, composed of a set of attributes
𝑇𝐴= {𝐴1, . . . ,𝐴𝑛} and tuples 𝑇𝑟= {𝑟1, . . . ,𝑟𝑚}. Each tuple is de-
fined as 𝑟𝑖= ⟨𝑟𝑖0,𝑟𝑖1, . . . ,𝑟𝑖𝑛⟩, such that 𝑟𝑖0 is the tuple identifier
and 𝑟𝑖𝑗(𝑗≠0) is a value assigned to the attribute 𝐴𝑗in the tuple 𝑟𝑖.
3

---

Often we may have two datasets and know one was derived from
the other but the actual transformation code or documentation has
been lost [55, 60–62, 106]. In what follows, we address the problem
of explaining the changes between two dataset versions.
Given two dataset versions,𝑇and𝑇′, we assume the latter, wlog,
is a derived table, i.e., a user changed the table 𝑇and as a result
obtained the table 𝑇′ with 𝑇′
𝐴= {𝐴′
1, . . . ,𝐴′𝑛} and tuples 𝑇′𝑟=
{𝑟′
1, . . . ,𝑟′𝑚}. We assume that an alignment between 𝑇𝐴and 𝑇′
𝐴
(attribute-match, denoted Σ𝐴) is given and that tuples in 𝑇and
𝑇′ with the same identifier (𝑟0𝑖and 𝑟′
0𝑖) are assumed to represent
the same real world entity. An attribute 𝐴𝑖∈𝑇(or 𝐴′
𝑗∈𝑇′) is
considered unmatched if it does not appear in Σ𝐴. A record 𝑟𝑖∈𝑇
(or 𝑟′
𝑗∈𝑇′) is considered unmatched if there is no record in 𝑇′
(respectively, 𝑇) with the same identifier.
Given an attribute-match Σ𝐴, we define the changes between the
two dataset versions to be explained using a three symbols notation.
The first refers to whether the dataset is the left-hand one (L) or
the right-hand (revised) one (R), the second to whether it is the
matched (∇) or unmatched (unmatched is also called delta (Δ)), and
the third refers to attributes (A) or tuples (r). Specifically, 𝐿Δ𝐴(left-
hand delta attributes) and 𝐿∇𝐴(left-hand matched attributes) are
the set of unmatched (delta) and matched (consistent) attributes
in 𝑇, respectively. Similarly, 𝑅Δ𝐴and 𝑅∇𝐴are the unmatched and
matched attributes in𝑇′. Using these sets, we create projected tuples.
Let 𝑟𝑗be a tuple of table𝑇, the projected tuple is given by 𝜋𝐿∇𝐴[𝑟𝑗],
projecting out non-matching attributes. Given such projected tu-
ples, we can define similar sets for tuples, namely 𝐿Δ𝑟(left-hand
delta tuples), 𝑅Δ𝑟(right-hand delta tuples), 𝐿∇𝑟(left-hand consistent
tuples) and 𝑅∇𝑟(right-hand consistent tuples). We summarize this
notation in Table 1. Intuitively, we are interested in explaining the
deltas between the datasets, i.e., 𝐿Δ𝐴, 𝑅Δ𝐴, 𝐿Δ𝑟, and 𝑅Δ𝑟.
Example 2. Given the dataset versions in Figures 1a (𝑇) and 1b
(𝑇′), the attribute-match is simply given by aligning the columns
headers (e.g., a2 ↔a2). The tuple ids are given under a0 (e.g., m1
↔m1). The following are the change sets: 𝐿Δ𝐴= ∅(no removed
columns), 𝑅Δ𝐴= {a5, a6, a7, a8} (four added attributes), 𝐿Δ𝑟= {m4}
(one removed tuple), and 𝑅Δ𝑟= ∅(no added tuples).
3.1
Change Explanations
We use the term explanation to refer to a user friendly way to
interpret a change between two relations. Intuitively, an explanation
is a transformation P from an origin O to a goal G. Formally, an
explanation E is defined with respect to a goal G with a name
G𝑛𝑎𝑚𝑒and an associated relation G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛it represents. As the
goal, the origin is also associated with a name (O𝑛𝑎𝑚𝑒) and a relation
(O𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛). A transformation P is an expression that transforms
the origin relation O𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛into the goal relation G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛. The
origin relation may also be empty. A formal definition is as follows
Definition 3 (Explanation (E)). Let G be a goal. An explana-
tion EG = (O, P) of G is composed of an origin O and a transfor-
mation P, such that G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛= P(O𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛).
Table 1: Notations used in the paper. The changes 𝐿Δ𝐴, 𝐿∇𝐴,
𝐿Δ𝑟, and 𝐿∇𝑟are defined wrt the left-hand table𝑇. The right-
hand notation can be obtained by replacing𝑇with𝑇′ below.
Notation
Meaning
Basic
𝑇
Left-hand dataset
𝑇′
Right-hand (revised) dataset
𝑇𝐴
The attribute set of dataset 𝑇
𝑇𝑟
The tuple set of dataset 𝑇
Changes
𝐿Δ𝐴
The set of unmatched attributes in T
{𝐴𝑖: 𝐴𝑖∈𝑇𝐴∧𝐴′
𝑗∈𝑇′ : (𝐴𝑖,𝐴′
𝑗) ∈Σ𝐴}
𝐿∇𝐴
The set of matched attributes in T
𝑇𝐴\ 𝐿Δ𝐴
𝐿Δ𝑟
The set of unmatched tuples in T
{𝜋𝐿∇𝐴[𝑟𝑗] : 𝑟𝑗∈𝑇𝑟∧𝑟′
𝑖∈𝑇: 𝑟0𝑖= 𝑟′
0𝑖}
𝐿Δ𝑟
The set of matched tuples in T
{𝜋𝐿∇𝐴[𝑟𝑗] : 𝑟𝑗∈𝑇𝑟}\𝐿Δ𝑟
3.2
Explaining Dataset Changes
We focus on two orientations of explanations, namely, vertical ex-
planations and horizontal explanations. We further distinguish be-
tween removal and addition explanations. Modifications can be
modeled as a removal followed by an addition. Explanation types
differ in the type of relations that the origin and the goal represent.
The goal (G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛) and origin (O𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛) relations are defined
with respect to versions𝑇or𝑇′. Specifically, the relations O𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛
and G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛can be a projection (subset of attributes) or selec-
tion (subset of tuples) over either 𝑇or 𝑇′. In vertical explanations
(adding or removing attributes), the associated goal and origin
names (G𝑛𝑎𝑚𝑒and O𝑛𝑎𝑚𝑒) are the projected attributes. For hori-
zontal explanations (adding or removing tuples), G𝑛𝑎𝑚𝑒and O𝑛𝑎𝑚𝑒
correspond to the set of tuple ids in the subset. When clear from
context, we refer to the goal and the origin by their names.
Example 4. Recall the versions in Figures 1a (𝑇) and 1b (𝑇′). An
example explanation for a goal G = (𝑎6, 𝜋𝑎6[𝑇′]) is composed of
an origin O = (𝑎2, 𝜋𝑎2[𝑇]) and a transformation P = 𝜋𝑎2[𝑇] ÷ 60,
which is tuple-based, i.e., divide each tuple in 𝜋𝑎2[𝑇] by 60. When
clear from context, we denote this explanation as E𝑎6 = (𝑎2,𝑎2÷60).
Recalling the change sets, we aim to find vertical addition expla-
nations for 𝐿Δ𝐴, vertical removal explanations for 𝑅Δ𝐴, horizontal
addition explanations for 𝐿Δ𝑟, and horizontal removal explanations
for 𝑅Δ𝑟. An explicit problem definition, that relies on the quality
of explanations is provided in Section 7.2.
Example 5. Recall the versions of Figure 1, annotated changes
in Figure 2, and 𝐿Δ𝐴, 𝑅Δ𝐴, 𝐿Δ𝑟, and 𝑅Δ𝑟, defined in Example 2. A
possible set of explanations to explain the changes is as follows
Ea5 = (𝑎1, extract(a1, ‘(.*?)’))
Ea6 = (𝑎2,𝑎2 ÷ 60)
4

---

Ea7 =
©­­­­­
«
𝑎3,


4,
if 9 ≤𝑎3
3,
if 8 ≤𝑎3 < 9
2,
if 7 ≤𝑎3 < 8
1,
otherwise
ª®®®®®
¬
Ea8 = (𝑎1, len(a1))
Em4 = (∅, has_NaN)
Most of the explanations are self-explanatory (as they should be).
Interesting cases are E𝑎5, that extracts value in parenthesis. Another
example is the horizontal explanation E𝑚4, for which the origin is an
empty set and the tuple was removed due to a NaN (null equivalent)
value. Although the goal is 𝑚4, the transformation we find is one
that removes 𝑚4 and no other tuples.
Explain-Da-V is a data-driven2 method composed of four parts cor-
responding to adding/removing attributes/tuples. We first describe
our core explanation methods (Section 4), which are then utilized
to explain vertical (Section 5) and horizontal changes (Section 6).
4
CORE SEMANTIC EXPLANATION
METHODS
Our core explanation methods rely on fitting an appropriate ex-
planation methodology to data types we find in the origin O and
the goal G. Rather than the traditional database attribute types
(strings, integers, floats, etc.), given the nature of our analysis, we
look into ML feature types [89]. We focus on three main types,
namely, Numeric, Categorical and Textual (mixed types are consid-
ered textual), which characterizes the core changes Explain-Da-V
covers.3 Aiming to resolve a high variety of changes, we develop
methods that are built on top of different types of origin sets using
multiple approaches that exploit the type of change. Accordingly,
Explain-Da-V can be applied over any pair of versions, regardless
of how far apart the versions are (meaning how many transfor-
mations have been applied). If an explanation is not found for a
specific change, it is declared idiopathic (unexplained).
Note that among the different changes, the vertical additions are
the most common and complex and, thus, the presented methods
mostly address such a scenario. Specifically, for the presentation
of methods, we assume the goal as a single attribute (a right-hand
attribute to be explained) with its data values. Also, given a goal,
finding its origin is not straight forward. For the moment, assume
the origin is the original left-hand table 𝑇. We discuss a method to
“find” an origin, given a goal, in Section 4.6.
4.1
Numeric Change Explanations
Whenever we need to explain a numeric goal using an origin that
contains numeric data, we position the problem as regression in
which the origin relation tuples are treated as independent vari-
ables and the goal relation tuples as dependent variables. Aiming
at explainable transformations, we build on top of linear regres-
sion [30]. To reduce model complexity and prevent over-fitting [96],
we experiment with Lasso and Ridge regularization.
2Data-driven reflects that we only use data values (we do not use meta-data).
3Explain-Da-V can be easily extended to support additional types such as dates.
Example 6. A numeric transformation is given in Figure 1b,
where explaining a6 can be resolved by fitting a regressor 1
60 · 𝑎2.
Not all numeric transformations can be covered by a linear func-
tion. Accordingly, to allow richer, more flexible, numeric transfor-
mations, we extend the feature space (i.e., the origin) by generating
additional features. Note that while these extensions are motivated
by commonly used data science and engineering operations [67],
they do not (and cannot) cover every possible transformation.
Polynomial Regression and Inter-relation Features: To ex-
plain polynomial transformations, we generate additional poly-
nomial features [46] over O. Given a predefined degree 𝑑, the poly-
nomial extension of O is given by 𝑝𝑜𝑙𝑦(O) whose attributes corre-
spond to {𝐴2
𝑖, . . . ,𝐴𝑑
𝑖, ∀𝐴𝑖∈O𝑛𝑎𝑚𝑒}. The extended origin relation
is created on a tuple level by applying the associated operation. For
example, the attribute 𝐴2
𝑖of the tuple 𝑟𝑗in the extended relation
would get the value in attribute 𝐴𝑖squared, meaning 𝜋𝐴𝑖[𝑟𝑗]2. We
also introduce feature inter-relation, that is, multiplication and di-
vision between different attribute values in O. Note that addition
and subtraction are already supported when using linear regres-
sion. The inter-relation extension of O, 𝑖𝑛𝑡𝑒𝑟(O) corresponds to
{𝐴𝑖· 𝐴𝑗,𝐴𝑖÷ 𝐴𝑗. . . , ∀𝐴𝑖,𝐴𝑗∈O ∧𝐴𝑖≠𝐴𝑗}. Also here the trans-
formations are done on the tuple level, e.g., the attribute 𝐴𝑖· 𝐴𝑗of
the tuple 𝑟𝑗would get the value 𝜋𝐴𝑖[𝑟𝑗] · 𝜋𝐴𝑗[𝑟𝑗]. The extensions
can also be applied consecutively, e.g., 𝑖𝑛𝑡𝑒𝑟(𝑝𝑜𝑙𝑦(O)) to create
attributes such as 𝐴𝑖÷ 𝐴2
𝑗to resolve, for example, the BMI formula
(𝑘𝑔÷ 𝑚2). For example, recall Figure 1 and let O𝑛𝑎𝑚𝑒= {𝑎2,𝑎3},
the extended features using 𝑝𝑜𝑙𝑦(𝑖𝑛𝑡𝑒𝑟(O)) with 𝑑= 2 would be:
a3
a4
𝒂𝟑𝟐
𝒂𝟒𝟐
𝒂𝟑⋅𝒂𝟒
𝒂𝟑
𝒂𝟒
𝒂𝟒
𝒂𝟑
𝒂𝟑𝟐⋅𝒂𝟒
…
175
9.2
30625
84.64
1610
19.02 0.05
281750
…
160
8.6
25600
73.96
1376
18.6 0.05
220160
…
143
8.0
20449
64
1144
17.88 0.06
163592
…
NaN
8.8
NaN
77.44
NaN
NaN NaN
NaN
…
107
7.6
11449
57.76
813.2
14.08 0.07
87012
…
Figure 3: Polynomial and Inter-relation extensions over a3
and a4 Figure 1a.
Mathematical Transformations: When generating new features
over numeric data, it is also common to use mathematical oper-
ations [27]. Specifically, to support this type of explanation we
generate a math extension of O, 𝑚𝑎𝑡ℎ(O), with the attributes
{𝑙𝑜𝑔(𝐴𝑖),𝑠𝑞𝑟𝑡(𝐴𝑖),𝑟𝑒𝑐𝑖𝑝𝑟𝑜𝑐𝑎𝑙(𝐴𝑖),𝑒𝑥𝑝(𝐴𝑖), . . . , ∀𝐴𝑖∈O}, where
𝑠𝑞𝑟𝑡(𝐴𝑖) = √𝐴𝑖, 𝑟𝑒𝑐𝑖𝑝𝑟𝑜𝑐𝑎𝑙(𝐴𝑖) = 𝐴−1
𝑖, and 𝑒𝑥𝑝(𝐴𝑖) = 𝑒𝐴𝑖. The
transformations are tuple-based, e.g., the feature 𝑙𝑜𝑔(𝐴𝑖) of the
tuple 𝑟𝑗in the extended relation would get the value 𝑙𝑜𝑔(𝜋𝐴𝑖[𝑟𝑗]).
For illustration, recall our running example, the extended features
using 𝑚𝑎𝑡ℎ({𝑎2,𝑎3}) would be:
Global Aggregations: We also generate aggregate features. This
extended set is especially important when looking at one of the
most common transformations in machine learning, that is, (value)
normalization [107]. We introduce an extension of O, 𝑎𝑔𝑔(O), with
the attributes {𝑠𝑢𝑚(𝐴𝑖),𝑚𝑒𝑎𝑛(𝐴𝑖),𝑚𝑎𝑥(𝐴𝑖),𝑚𝑖𝑛(𝐴𝑖) . . . , ∀𝐴𝑖
∈
O}. Here, although assigned on a tuple level, the extended values
5

---

a3
a4
𝒍𝒐𝒈(𝒂𝟑)
𝒔𝒒𝒓𝒕(𝒂𝟑)
𝒓𝒆𝒄𝒊𝒑𝒓𝒐𝒄𝒂𝒍(𝒂𝟑)
… 𝒆𝒙𝒑(𝒂𝟒)
175
9.2
2.24
13.23
0.006
…
9897
160
8.6
2.20
12.65
0.006
…
5432
143
8.0
2.155
11.96
0.007
…
2981
NaN
8.8
NaN
NaN
NaN
…
6634
107
7.6
2.029
10.34
0.009
…
1998
Figure 4: Math extension over a3 and a4 Figure 1a.
are computed over all the values in the attribute. For example, the
feature 𝑠𝑢𝑚(𝐴𝑖) of the tuple 𝑟𝑗would get the value Í
𝑟𝑖𝑘∈𝜋𝐴𝑖(𝑇) 𝑟𝑖𝑘.
Then, if a user applies a sum normalization over 𝐴𝑖, the feature-set
𝑎𝑔𝑔(𝑖𝑛𝑡𝑒𝑟(O)) that includes the feature 𝐴𝑖÷𝑠𝑢𝑚(𝐴𝑖) would be able
to resolve and explain this added attribute. Similarly, in the case
of min-max normalization [107] the additional features of 𝑚𝑖𝑛(𝐴𝑖)
and 𝑚𝑎𝑥(𝐴𝑖) can be used to generate accurate explanations. An-
other example is the common collaborative filtering transformation
of subtracting the mean value (𝐴𝑖−𝑚𝑒𝑎𝑛(𝐴𝑖)) [71]. Recalling our
running example and let O = {𝑎2,𝑎3}, the extended features using
𝑎𝑔𝑔(O) would be:
a3
a4
𝒔𝒖𝒎(𝒂𝟑)
𝒎𝒆𝒂𝒏(𝒂𝟑)
𝒔𝒕𝒅(𝒂𝟑)
𝒎𝒊𝒏(𝒂𝟑)
…
𝒎𝒂𝒙(𝒂𝟒)
175
9.2
585
146.25
25.33
107
…
9.2
160
8.6
585
146.25
25.33
107
…
9.2
143
8.0
585
146.25
25.33
107
…
9.2
NaN
8.8
585
146.25
25.33
107
…
9.2
107
7.6
585
146.25
25.33
107
…
9.2
Figure 5: Aggregation extension over a3 and a4 Figure 1a.
An extended feature-set is used to fit a regressor that assigns
coefficients for extended feature-set. A perfect regressor would be
able to deal one all-inclusive feature-set (i.e., 𝑝𝑜𝑙𝑦(𝑖𝑛𝑡𝑒𝑟(. . . (O) ∪
𝑖𝑛𝑡𝑒𝑟(𝑝𝑜𝑙𝑦(. . . (O), . . . ); yet, since it is not realistic to expect that
(from an explainable regressor), we apply each set independently
(power-set of the extensions) and generate multiple “possible” ex-
planations. Section 7.4 addresses the issue of choosing among them.
Note that the transformation is “learned” (fitted) only based on
the two dataset versions𝑇and𝑇′ and no additional training data
is required. Section 5.1 discusses the main application of numeric
change explanations and illustrates it using multiple examples.
4.2
Categorical Change Explanations
Aiming to explain a categorical goal using an origin relation that
contains numeric, we position the problem as classification, in which
the tuples of the origin relation are treated as explanatory variables
and the goal relation tuples are used as the output class labels. The
output class can be binary (e.g., is movie longer than two hours) or
multi-class (e.g., a7, Example 1). Aiming at explainability, we focus
on decision trees [30]. Note that decision trees cover only explana-
tions that can be represented as disjunction of conjunctions [74].
Each path from the root to a leaf corresponds to a conjunction and
the tree is the disjunction of these conjunctions.
a3>9
a7=4
a3<7
a3>8
a7=2
a7=3
𝑇𝑟𝑢𝑒
𝐹𝑎𝑙𝑠𝑒
a7=1
𝑇𝑟𝑢𝑒
𝐹𝑎𝑙𝑠𝑒
𝐹𝑎𝑙𝑠𝑒
𝑇𝑟𝑢𝑒
Example 7. Figure 1b
provides
an
example
a
categorical transformation,
namely, a7, which can be
resolved with the help of the
following decision tree.
4.3
Textual Change Explanations
When the origin and/or goal are textual, we follow the PBE ap-
proach (see Section 2.3), using a search-based solution. Specifically,
we adopt an existing framework called Foofah [58]. The PBE so-
lution is composed of designing a space of possible operators and
a search algorithm. The search algorithm (A*, following Foofah)
navigates the space of operators using a heuristic function (based
on dissimilarity of tables) that estimates the cost of any proposed
partial solution. The space is pruned to boost search speed [58].
4.3.1
Textual-to-Textual. Addressing data versioning, we extend
the traditional PBE operators to include operators the cover fre-
quent text-processing steps [100], including text lowering, lemmati-
zation, removal of special charterers (e.g., punctuations and numeric
values) and tokens (e.g., stop-words and html tags). All implemented
additional operators for foofah are given in our repository [6].
Unlike Foofah, we also consider textual-to-numeric and textual-
to-categorical. Note that although in recent years transformer-based
models have become a standard way to extract (latent) features from
text, traditional feature engineering over text, that is, extracting
manual numeric and categorical features from textual values, is still
an important ingredient in NLP [37, 40, 66] and in other research
disciplines such as HCI [31] and information management [51].
4.3.2
Textual-to-Numeric. The search space defined for resolving
this kind of transformation includes a meta-operation that counts
the occurrences of some pattern 𝑝𝑎𝑡in a value (count𝑝𝑎𝑡(𝑟𝑖𝑗)),
where 𝑟𝑖𝑗is a value in the table, see Section 3). Using this operation
we can define operations such as number_of_words = count‘␣’(𝑟𝑖𝑗)
and number_of_questions = count‘?’(𝑟𝑖𝑗). We also cover counting
a pre-defined set of stop-words and punctuation marks.
4.3.3
Textual-to-Categorical. We define a similar meta-operation
for a pattern existence (contains𝑝𝑎𝑡(𝑟𝑖𝑗)), which is used to gener-
ate operations such as contains_percent = contains‘%′(𝑟𝑖𝑗).
Example 8. Figure 1b provides an example of textual-to-textual
transformation, namely, a5, which can be resolved with the help of
the foofah environment in its original implementation. Specifically,
if we consider a1 as an origin, foofah would consider 𝜋𝑎1[𝑇] as input
examples and 𝜋𝑎5[𝑇′] as corresponding output examples (goal in our
terms) and synthesize a tuple-based data transformation program
(1) t = split(t, 0, ‘(’), (2) t = split(t, 1, ‘)’), (3) t = drop(t, 0), (4) t = drop(t, 2)
the tuple value Moana (U), for example, would be transformed as
follows [Moana , U)] →[Moana , U, ] →[U, ] →U.
Resolving a8 requires Explain-Da-V’s extensions that includes
textual-to-numeric transformations (len()).
Note that Foofah aims to synthesize transformations using a
given set of example tuples, and is often able to do so using just a
few examples. Our goal, in contrast, is to generate an explanation
that correctly explains a full table transformation (a dataset version).
Hence, our tremendous expansion of the search space beyond text-
to-text transformations plays a critical role. Moreover, Section 4.6
introduces a technique that prunes the search space in this context.
6

---

4.4
Categorical-encoding Change Explanations
Whenever dealing with mixed types, textual and categorical values
may be encoded. A common encoding approach, which we use
here, is one-hot-encoding [86]. Let 𝐴𝑖∈O be a textual/categorical
attribute in the origin. One-hot-encoding of this attribute generates
an additional attribute for each unique value (or category) in 𝐴𝑖and
assigns a value of 1 to each tuple that corresponds to this value (cat-
egory). This addition, not only allows the resolution of this common
encoding scheme, but also a richer representation that can be used
to resolve other types of encoding (e.g., ordinal encoding) and addi-
tional transformations. Such encodings are also commonly used in
data preparation for machine learning [28]. Recalling Example 1,
if a user aims to predict the rating of a movie, extracting features
such as Is_Drama or Is_Action can be beneficial for learning.
4.5
Reshaping Change Explanations
Generally group-by is a table-reshaping operation [104], i.e., a nat-
ural attribute-match and tuple-match do not exist. However, when
it comes to feature engineering, group-by can also be used to gen-
erate aggregated features based on some other attribute. The latter
is addressed in a manner that is similar to numeric change ex-
planations. An extended origin, similar to Section 4.1, would be
created for each numeric attribute 𝐴𝑗∈𝑇𝐴with respect to each
textual/categorical attribute 𝐴𝑖∈O independently or conjointly
(grouping by multiple attributes). We use an SQL syntax for clarity.
SELECT 𝐴𝑖, mean(𝐴𝑗), max(𝐴𝑗)...
FROM T
GROUP BY 𝐴𝑖
Figure 6: Group by Query
A helper query (Figure 6) can
be used to generate the ex-
tended group-by features of
the numeric attribute 𝐴𝑗∈
𝑇𝐴with respect to a textual/-
categorical attribute 𝐴𝑖∈O.
If more than one numeric attribute exists, it will be added to
the GROUP BY and SELECT clauses. Using this helper query, by
joining it with the origin, we obtain the additional possible at-
tributes. Consider, for example, the attribute a4 of Figure 1a. The
additional aggregation features would be generated over the nu-
meric attributes a2 and a3 and joined into the table, as illustrated
in Fig. 7. Among these, we can find the mean a2 (runtime) and a3
(rating) per a4 (genre), supporting such explanations.
a3
a4
a5
𝒔𝒖𝒎𝒂𝟑
𝒃𝒚𝒂𝟓
𝒎𝒆𝒂𝒏𝒂𝟑
𝒃𝒚𝒂𝟓
…
𝒎𝒊𝒏𝒂𝟒
𝒃𝒚𝒂𝟓
𝒎𝒂𝒙𝒂𝟒
𝒃𝒚𝒂𝟓
175
9.2
Drama
167.5
335
…
8.6
9.2
160
8.6
Drama
167.5
335
…
8.6
9.2
143
8.0
Action
143
143
…
8
8.8
NaN
8.8
Action
143
143
…
8
8.8
107
7.6
Animation
107
107
…
7.6
7.6
Figure 7: Groupby feature extension over a3 and a4 Fig-
ure 1a.
We also consider the reshaping scenario introduced in previous
work, e.g., [104]. Reshaping is often considered as a possible opera-
tion that can be applied over a table throughout the search (see Sec-
tion 2.3). We introduce an alternative data-driven approach. Specifi-
cally, reshaping is associated only with attribute-match when there
is no tuple-match. We explicitly reshape the table using the query of
Figure 6 and fit a regressor over it. Currently, Explain-Da-V does
not support other reshaping transformations such as transpose and
pivot, which we intend to explore in future work.
4.6
Finding the Origin
In our discussion so far, we have assumed that the origin for the
transformations P is the original relation𝑇. However, we can make
our search more efficient if we can determine that for a specific
goal, the origin is only a portion of 𝑇. Accordingly, we aim to “find
the origin”. Different from some related literature where the input-
output scope is clear (see Section 2.3), in data versioning we do
not know what was used to derive a specifical goal. Hence, our
approach first searches for an origin for the transformation.
A naïve solution to use all available data values. For example,
in the context of adding attributes, using all attributes of 𝑇as an
origin, i.e., O = (𝑇𝐴,𝑇). The problem with this method is twofold.
First, unrelated attributes may serve as noise when aiming to find a
proper transformation for the goal. For example, referring back to
Example 1, aiming to resolve a5 using all attributes (a1-a4) presents
a much larger search space than aiming to resolve it using a2. A
second issue has to do with the data types. Using a numeric change
explanation (Section 4.1) may be more beneficial than a textual
change explanation (Section 4.3). For example, using a2 as an origin
to explain a5 instead of using a1 to a4.
When examining the creation of a new attribute from existing
attributes, we observe a side effect of creating a functional depen-
dency between the origin and the new attribute (goal). For example,
if two movies have the same runtime in minutes (a2), they will have
the same runtime in hours (a5), which, by definition constructs a
functional dependency between a2 and a5. Accordingly, we use a
functional dependency discovery algorithm [82] to find the origin.4
We find dependencies in which our goal is the dependent set and
the discovered determinant is used as the origin. Note that there
can be more than one attribute set that determines the goal and
accordingly multiple origins may be generated.
We analyze all determining attribute sets by considering each one
of them as a candidate origin. Accordingly, multiple explanations
may be generated for a goal. Section 7.4 describes how we choose
among them. Specifically, we rank the determinants by size and
cardinality and, if desired, an early stop condition can be introduced
based on the size or quality of the discovered transformation.
Example 9. Recall Figure 1 and consider attribute a7 as a goal.
Since the example tables are small, any combination of attributes
in {a1, a2, a3, a4} can be considered as an origin. If no high quality
explanations are found for singleton attributes, the algorithm can
consider combinations of attributes. In a larger real example, only a
few attributes or combinations of them may be an origin.
5
EXPLAINING VERTICAL CHANGES
With our arsenal of explanation methods, we now consider how to
use them to explain changes. We begin with attribute additions, after
which, we describe our approach to handling attribute removal.
4In our experiments we use a discovery algorithm called FDEP [49].
7

---

5.1
Addition Explanations for 𝑅Δ𝐴
Adding an attribute is a very common operation in data science,
mainly revolving around data preparation and feature engineering
for machine learning (ML) [107]. Added attributes are usually a
result of applying some transformation over the existing data. We
first find the origin (Section 4.6) an then utilize the core explanation
methods (Section 4) to find transformations that, when applied to
the origin relation, generate the desired goal relation. Figure 8 pro-
vides a sketch of the approach (left and middle parts) and highlights
its main novelties (right part) in the context of adding attributes.
Find 
Origin
𝑅Δ𝐴
Types?
𝑁𝑢𝑚𝑒𝑟𝑖𝑐
Regression
𝐶𝑎𝑡𝑒𝑔𝑜𝑟𝑖𝑐𝑎𝑙
𝑁𝑢𝑚𝑒𝑟𝑖𝑐
𝑁𝑢𝑚𝑒𝑟𝑖𝑐
𝑁𝑢𝑚𝑒𝑟𝑖𝑐
Classification
𝐶𝑎𝑡𝑒𝑔𝑜𝑟𝑖𝑐𝑎𝑙
𝐶𝑎𝑡𝑒𝑔𝑜𝑟𝑖𝑎𝑙
𝑇𝑒𝑥𝑡𝑢𝑎𝑙
𝑇𝑒𝑥𝑡𝑢𝑎𝑙
Search
𝐶𝑎𝑡𝑒𝑔𝑜𝑟𝑖𝑐𝑎𝑙
𝑃𝑜𝑙𝑦𝑛𝑜𝑚𝑖𝑎𝑙(𝑎𝑖
2, … )
𝑀𝑎𝑡ℎ(log 𝑎𝑖, … )
𝐼𝑛𝑡𝑒𝑟-𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛𝑠(𝑎𝑖⋅𝑎𝑗, … )
𝐺𝑙𝑜𝑏𝑎𝑙𝑎𝑔𝑔. (sum 𝑎𝑖, … )
𝑜𝑛𝑒-ℎ𝑜𝑡(𝑎𝑖), …
𝐺𝑟𝑜𝑢𝑝-𝑏𝑦𝑎𝑖→𝑚𝑒𝑎𝑛𝑎𝑗, …
𝑐𝑜𝑢𝑛𝑡𝑝𝑎𝑡(𝑟𝑖𝑗)
𝑐𝑜𝑛𝑡𝑎𝑖𝑛𝑠𝑝𝑎𝑡(𝑟𝑖𝑗)
𝑙𝑒𝑚𝑚𝑎𝑡𝑖𝑧𝑎𝑡𝑖𝑜𝑛(𝑟𝑖𝑗)
𝑟𝑒𝑚𝑜𝑣𝑒𝑠𝑡𝑜𝑝-𝑤𝑜𝑟𝑑𝑠(𝑟𝑖𝑗)
numeric extentions
ai categorical?
ai textual/categorical, ai numeric?
enriching textual-to-textual
search space for
textual-to-categorical
search space for
textual-to-numeric
…
…
…
Figure 8: Explaining attribute additions
Algorithm 1: Explaining Attribute Additions
1 Input: A set of attributes to-be-explained 𝑅Δ𝐴
2 Output: A set of explanations for each attribute E𝑅Δ𝐴
3 E𝑅Δ𝐴:= ∅
4 for 𝐴𝑖∈𝑅Δ𝐴do
5
E𝐴𝑖:= ∅; O𝐴𝑖:= find origin (Section 4.6)
6
for O ∈O𝐴𝑖do
7
if 𝐴𝑖is numeric then
8
if O is numeric then
9
EO
𝐴𝑖←Numeric Explanations (Section 4.1)
10
else
11
EO
𝑡𝑒𝑥𝑡←Textual Explanations (Section 4.3)
12
EO
𝑒𝑛𝑐𝑜𝑑𝑒←Encoding Explanations (Section 4.4)
13
EO
𝑟𝑒𝑠ℎ𝑎𝑝𝑒←Reshaping Explanations (Section 4.5)
14
EO
𝐴𝑖←EO
𝑒𝑛𝑐𝑜𝑑𝑒∪EO
𝑟𝑒𝑠ℎ𝑎𝑝𝑒
15
else if 𝐴𝑖is categorical then
16
if O is numeric then
17
EO
𝐴𝑖←Categorical Explanations (Section 4.2)
18
else
19
EO
𝑡𝑒𝑥𝑡←Textual Explanations (Section 4.3)
20
EO
𝑒𝑛𝑐𝑜𝑑𝑒←Encoding Explanations (Section 4.4)
21
EO
𝑟𝑒𝑠ℎ𝑎𝑝𝑒←Reshaping Explanations (Section 4.5)
22
EO
𝐴𝑖←EO
𝑒𝑛𝑐𝑜𝑑𝑒∪EO
𝑟𝑒𝑠ℎ𝑎𝑝𝑒
23
else if 𝐴𝑖is textual then
24
EO
𝐴𝑖←Textual Explanations (Section 4.3)
25
E𝑅Δ𝐴←E𝑅Δ𝐴∪E𝐴𝑖
26 Return:E𝑅Δ𝐴
Explain-Da-V attribute addition explanation algorithm is pro-
vided in Algorithm 1. Explain-Da-V works iteratively, aiming to
resolve each added attribute (i.e., the goal G = (𝐴𝑖, 𝜋𝐴𝑖[𝑇′])) at a
time (Lines 4-25). After a set of possible origins O𝐴𝑖is found (Line 5),
we utilize the core explanation methods to generate a set of expla-
nations E O
𝐴𝑖for each origin (Lines 6-24). For example, if a numeric
origin is found for a numeric goal (Line 9), Explain-Da-V uses
the numeric explanation method (Section 4.1). Note that multiple
explanations are generated for each target, for which we introduce
a search strategy in Section 7.4. We illustrate it over Figure 9, which
provides an additional version of the table in Figure 1a.
a0
a1
a2
a3
a4
a9
a10
a11
a12
a13
a14
m1
The Godfather (A)
175
9.2
Drama
0.28
3.15
1
godfather a
8.9
1
m2
Hamilton (PG-13)
160
8.6
Drama
0.28
3.23
1
hamilton pg
8.9
1
m3
The Avengers (UA)
143
8.0
Action
0.24
3.36
0
avengers ua
8.0
2
m5
Moana (U)
107
7.6
Animation
0.23
4.26
0
moana u
7.6
3
Figure 9: Dataset version created by UserC over Figure 1a.
Example 10. Among the new added attributes a9 and a10 are
numeric (Lines 8). The attribute a9 is a (sum) normalization of
the values in a3 (normalized rating). Explain-Da-V would first
find its origins (Line 5). As in the case of a6 (see Example 9), also
a9 can be determined by multiple attribute sets. Among the pos-
sible origins, consider O =a3. Since both a3 and a9 are numeric,
Explain-Da-V uses numeric change explanations (Line 9). Zoom-
ing in on the method (Section 4.1), a baseline explanation will be
generated by fitting a regressor over O. Then, different extensions
will be applied over the origin, each will be associated with an ex-
planation by fitting a regressor. Among the generated extensions we
will find 𝑎𝑔𝑔(𝑖𝑛𝑡𝑒𝑟(O)), that contains the feature a3÷sum(a3) over
which a transformation a9=a3÷sum(a3) will be fitted to generate
an explanation E𝑎9 = (𝑎3,𝑎3 ÷𝑠𝑢𝑚(𝑎3)) that will be added to E O
𝑎9.
Similarly, a10 is determined by multiple attribute sets. Among them,
consider O ={a2, a3}, over which the following explanation will
be generated E𝑎10 = ({𝑎2,𝑎3}, 60 · 𝑎3 ÷ 𝑎2) (rating per hour) and
added to E O
𝑎10.
a3>8
a11=0
a11=1
𝑇𝑟𝑢𝑒
𝐹𝑎𝑙𝑠𝑒
Example 10 (cont.). Next we look
at a11, which is categorical, and for
example, consider the origin O =a3.
Accordingly, Explain-Da-V uses cate-
gorical change explanations (Line 17) and might fit the following
decision tree to explain a11. Note that a11 might been created by
applying a3>8.5 which differs from Explain-Da-V’s data-driven
explanation. Our goal however is to provide an accurate explanation
which both are. Interestingly, if we consider a2 as an origin we can
derive a similar decision tree rooted at 𝑎2 > 150. These issues refer
to the generalizability of explanations which will be discussed in
Section 7.
The added attribute a12 is textual and focuses on text cleaning.
Consider an origin O =a1, Explain-Da-V will execute Line 24 and
specifically Section 4.3.1 which describes text-to-text transformations.
The resolved transformation includes removing punctuation marks
(e.g., ‘(’) and numeric values (‘13’) and lowering the text. Note that
such a transformation requires our extensions to Foofah and would
not be accurately resolved using the original implementation of
Foofah [58]. A textual-to-categorical (Section 4.3.3) example would
be to use ‘contains_multiple_words?’, in this case the tuples m1 and
m3 would get the value 1 and m2 and m5 the value 0.
8

---

Next, consider a13, which is numeric and among possible origins,
consider O ={a3,a4}, which is mixed. Explain-Da-V would turn
to encoding (Line ??) and reshaping (Line ??). Consider the latter
and note that new generated features are illustrated in Figure 7.
Explain-Da-V will generate an explanation using the transfor-
mation 1 · (𝑚𝑒𝑎𝑛(𝑎3) 𝑏𝑦𝑎4) with represents a group by a4 and
computing the mean of a3 (mean rating by genre).
Finally, attribute a14 is categorical and consider, a4 as an ori-
gin. In addition to applying trying to find textual explanations
(Line 19), Explain-Da-V would also turn to encoding (Line 20) and
reshaping (Line 21) explanations. Consider the former and note that
a14 is an ordinal encoding of attribute a4 (Drama→1, Action→2,
Animation→3). The three encoded attributes, namely is_Drama,
is_Action? and is_Animation? are used to resolve a14. Note
that in a real-world scenario, an attribute like a14 would not nec-
essarily be recognized as a categorical (e.g., high cardinality or
misclassification as a numeric value). In this case Explain-Da-V
would turn to Line 12 resulting in the transformation 1·is_Drama?
+ 2·is_Action? + 3·is_Animation?.
5.2
Removal Explanations for 𝐿Δ𝐴
Removing attributes is less common and usually include superficial
transformations. We treat each attribute in 𝐿Δ𝐴separately as a goal.
We cover two main types of explanations for removal reflecting
data cleaning (removing duplicated and noisy attributes).
First, we examine a table-independent attribute removal, which
in our terms reflects an empty origin (O = ∅). Specifically, we
use a threshold to decide whether a attribute was removed be-
cause it has too many (above a threshold) missing (NaN) values.5
In this case an explanation for a removed attribute 𝐴𝑖∈𝐿Δ𝐴
will be in the form of E𝐴𝑖= (∅, ‘contains missing information’).
Formally, the ‘contains missing information’ can be defined as
𝐴𝑖=
(
∅,
if ratio of NaN values > 𝛼
𝐴𝑖,
otherwise
,
where 𝛼∈[0, 1] is some threshold.
As a second case, we look into duplicated information. A trivial
explanation can be provided for an identical attribute in 𝑇′. Given
a goal 𝐴𝑖, the origin is some attribute 𝐴′
𝑗∈𝑇′ such that 𝐴′
𝑗∉𝑇and
𝜋𝐴𝑖[𝑇] = 𝜋𝐴′
𝑗[𝑇′] (full overlap of values). A natural extension of
finding duplications is looking into similarities between attributes.
We look into two types of similarities, measuring the overlap be-
tween attributes and if there is a one-to-one dependency between
them. Overlap is measured and, if it meets some threshold, an expla-
nation is generated using the overlapping attribute 𝐴′
𝑗as the origin
and an ‘overlaps with 𝐴′
𝑗’ transformation, which is defined similar
to above. We also check if some attribute in 𝑇′ determines (using
a similar methodology as described in Section 4.6) 𝐴𝑖∈𝐿Δ𝐴. Ob-
viously many other measures of similarity exist, which we intend
to explore in future work. Finally, note that sometimes attribute
removal can be idiopathic, i.e., the user simply removed an attribute
because they are not interested in some parts of the data.
5The threshold can be treated as an hyper-parameter or a user-provided input.
6
EXPLAINING HORIZONTAL CHANGES
We begin with the common data cleaning operation of tuple re-
moval, after which we discuss adding tuples.
6.1
Removal Explanations for 𝐿Δ𝑟
Tuple removal is a very common operation in data preparation,
which mainly revolves around cleaning data. Our examination be-
gins iteratively by looking into each removed tuple in 𝐿Δ𝑟indepen-
dently. This may, for example, result in the horizontal explanation
E𝑚4 from Example 5. Finally, we explore if a predicate was applied
to remove them all remaining (unexplained) tuples conjointly.
As in Section 5.2, we aim to find tuples that were removed collec-
tively in a table-independent manner due to missing values (NaNs),
see the m4 explanation in Example 5. For table-dependent expla-
nations, we find duplicated tuples, which is a common result of
data cleaning using entity resolution [48, 70]. We focus only on
identical tuple removal. Note that this strict requirement can be
relaxed and any entity resolution technique, e.g., using declarative
rules [29], can be used to find duplicated-tuple removal explana-
tions. Specifically, if a duplicated tuple 𝑟′
𝑗∈𝑇′ is found for a goal
tuple 𝑟𝑖∈𝐿Δ𝑟, we create a horizontal explanation of the form
E𝑟𝑖= (∅, duplicated of 𝑟′
𝑗). This transformation can be expressed
as follows 𝑟𝑖=
(
∅,
∃𝑟′
𝑗∈𝑇′𝑠.𝑡.𝑟𝑖= 𝑟′
𝑗
𝑟𝑖,
otherwise
Finally, outlier detectors (Z-method and IQR-method [32, 97]) also
serve as explanations for removed tuples.
Not all tuples can be explained independently, thus, for all unex-
plained tuples, 𝐿Δ𝑟𝑢𝑛𝑒𝑥𝑝𝑙𝑎𝑖𝑛𝑒𝑑, we aim to find a joint explanation
in the form of a predicate. Given a set of unexplained tuples, we
use a categorical explanation method (Section 4.2) to find a joint
explanation. Similar to Section 5.1, in case the origin has mixed
types, a decision tree is applied also over encoded (using categorical-
encoding change explanation, Section 4.4) attributes in the table.
a0
a1
a2
a3
a4
m1
The Godfather (A)
175
9.2
Drama
m2
Hamilton (PG-13)
160
8.6
Biography
m3
The Avengers (UA)
143
8.0
Action
m4
Inception (UA)
NaN
8.8
Action
m5
Moana (U)
107
7.6
Animation
(a) Dataset version created
by UserD over Figure 1a.
a3>8.5
remove
is_Drama?
is_Action?
remove
maintain
𝑇𝑟𝑢𝑒
𝐹𝑎𝑙𝑠𝑒
maintain
𝑇𝑟𝑢𝑒
𝐹𝑎𝑙𝑠𝑒
𝑇𝑟𝑢𝑒
𝐹𝑎𝑙𝑠𝑒
(b) Tree
Figure 10: UserD version of Figure 1a and its explanation.
Example 11. In the example of Figure 1b we present a simple
example of tuple removal due to NaN value. Figure 10a provides an
example of applying a predicate over the table. To resolve this predi-
cate, Explain-Da-V will first add the one-hot-encoded features cor-
responding to a4 (is_Drama?, is_Action? and is_Animation?),
then, using a decision tree, it will try to resolve the predicate. The
decision tree in Figure 10b will be generated.
6.2
Addition Explanations for 𝑅Δ𝑟
The non-idiopathic addition of tuples may be a result of over-
sampling (bootstrapping). To detect such a transformation, we use
9

---

a similar methodology as in Section 6.1. Given an added tuple 𝑟′
𝑖∈
𝑅Δ𝑟, we aim to find a duplicated (equal or similar) tuple 𝑟𝑗∈𝑇to
create an explanation noting that the tuple has been bootstrapped.
7
EVALUATING EXPLANATIONS
We aim to generate user friendly explanations that capture the
semantics of changes. Specifically, the explanation (transformation)
can reproduce the change and generalize it beyond a specific setup.
Aiming to assess such semantics, we now describe how we evaluate
explanations. Sometimes multiple explanations can be generated
with respect to a change. Recall Example 10 in which we present
two possible valid explanations for a11. The first decision tree
explanation is rooted at 𝑎3 > 8 and the second is rooted at 𝑎2 >
150. Also a decision tree rooted at 𝑎3 > 7.5 is a possible (invalid)
explanation. In what follows, an important question that needs to be
asked is how to compare (and choose among) possible explanations?
Related work on data transformation (see Section 2.3) employ
success rates that measure whether the output was generated suc-
cessfully by applying the transformation over the input. Yang et al.
also introduce a ranking measure (MRR) over possible transforma-
tions (pipelines in their terms), which still views the transformation
as a whole [104]. We claim that solely using such a measure does
not capture the true nature of the transformation, especially when
evaluating an attribute-to-attribute (Section 5.1) transformations.
To provide a more fine-grained evaluation, we evaluate both the
validity and generalizablity computed over the transformed values
to assess the coverage of the transformation. As we are interested
in providing explainable solutions, we also use two explainability
dimensions, conciseness and concentration.
7.1
Explanation Validity and Generalizablity
Attribute (vertical) addition explanations are richer than removal or
tuple transformations, so their evaluation is addressed accordingly.
Vertical Additions: We separate this evaluation into validity (does
the generated transformation recreate the goal using the origin?)
and generalizability (will the generated transformation be able to
recreate a similar goal using a similar origin?). Recall Definition 3
and the notation of origin (O), goal (G), and transformation (P).
For simplicity, we denote the output of a transformation applied to
an origin relation as ˆG = P(O𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛). Validity is computed in a
tuple-based manner over value-pairs (ˆ𝑟𝑖𝑗,𝑟𝑖𝑗) such that ˆ𝑟𝑖𝑗∈ˆG is a
transformed value corresponding to a goal value𝑟𝑖𝑗∈G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛, i.e.,
ˆ𝑟𝑖0 = 𝑟𝑖0 (𝑟𝑖0 is the tuple id so this means the tuples are matching,
see Section 3). Explanation validity is measured as follows:
𝑉𝑎𝑙(EG) =
1
|G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛|
∑︁
ˆ𝑟𝑖𝑗∈ˆG,𝑟𝑖𝑗∈G𝑟𝑒𝑙𝑎𝑡𝑖𝑜𝑛:
𝑠.𝑡. ˆ𝑟𝑖0=𝑟𝑖0
I(ˆ𝑟𝑖𝑗= 𝑟𝑖𝑗)
(1)
where I(ˆ𝑟𝑖𝑗= 𝑟𝑖𝑗) is an indicator returning the value 1 if the trans-
formed value equals to the corresponding goal value and 0 other-
wise. The validity can be viewed as a tuple-based success rate, i.e.,
the proportion of the tuples that were successfully transformed.
Example 12. Recall the vertical explanation E𝑎9 = (𝑎3,𝑎3 ÷
𝑠𝑢𝑚(𝑎3)) which was created for the attribute a9 in Figure 9 (see
Example 6). Also consider an alternative vertical explanation E′𝑎9
= (𝑎3,𝑎3÷33.4). Both explanations would have a validity score of 1
as applying the corresponding transformation recreates a9 perfectly.
As illustrated in the example, validity only looks at the given
dataset versions 𝑇and 𝑇′, which may result in overfitting (e.g.,
selecting 𝑎3 ÷ 33.4 over 𝑎3 ÷ 𝑠𝑢𝑚(𝑎3)). Aiming to measure such
scenarios, we introduce generalizability, measuring the extent to
which a solution can explain an equivalent set of versions. Specifi-
cally, generalizability can be measured if a pair of versions ˜𝑇and
˜𝑇′ exist such that ˜𝑇′ was generated as a version of ˜𝑇using the
same transformations that were used to generate 𝑇′ from 𝑇. Let ˜O
be the origin over ˜𝑇and ˜G the goal over ˜𝑇′. The generalizability
of an explanation 𝐺𝑒𝑛(EG) is measured by applying P over ˜O to
generate ˆ˜G and is computed as in Eq. 1 over ˆ˜G and ˜G. We illustrate
the importance of generalizability using the following example.
a0
a1
a2
a3
a4
m6
Pulp Fiction (A)
154
8.9
Drama
m7
Saw (UA)
103
7.6
Horror
m8
Snatch (UA)
104
NaN
Crime
m9
King Kong (Passed)
100
7.9
Adventure
a0
a1
a2
a3
a4
a9
a10
a11
a12
a13
a14
m6
Pulp Fiction (A)
154
8.9
Drama
0.36
3.47
1
pulp fiction a
8.9
1
m7
Saw (UA)
103
7.6
Horror
0.31
4.43
0
saw ua
7.6
4
m9
King Kong (Passed)
100
7.9
Adventure
0.32
4.74
0
king kong passed
7.9
5
Figure 11: Example versions for generalizability
Example 13. Fig. 11 provides two dataset versions. The top table
is similar to Fig. 1a and the bottom table corresponds to Fig. 9 such
that the same transformations over Fig. 1a generates Fig. 9. Recall the
explanations E𝑎9 = (𝑎3,𝑎3 ÷ 𝑠𝑢𝑚(𝑎3)) and E′𝑎9 = (𝑎3,𝑎3 ÷ 33.4).
While these two are valid, using Fig. 11, we observe that E𝑎9 is also
generalizable while E′𝑎9 is not. Specifically, if we apply E𝑎9 over a3
in Fig. 11 we obtain the values of a9 in the bottom table. However,
if we apply E′𝑎9, we obtain the values 0.27, 0.23, and 0.24 for the
records m6, m7, and m9, respectively, resulting in a 0 generalizability.
In practical settings, generalizability can be computed when the
same changes are applied to multiple datasets, e.g., in a data pipeline
such as ETL [99]. For our new benchmark (Section 8.1.1), we gener-
ate an annotated hold-out set, used to compute generalizability.
Other Explanations: For tuple removal, we apply a reconstruction
methodology to evaluate validation and generalizability globally.
We gather all generated explanations and apply them over𝑇and try
to regenerate 𝑇′. Then, we check the overlap between the removed
tuples and the tuples that are not included in 𝑇′. For example, if a
a3>8 predicate was used to explain the removed tuples, the same
predicate would be applied over𝑇and compared to𝑇′. This overlap,
i.e., the proportion of tuples that were correctly removed using the
explanations of Explain-Da-V, is used as the overall validity of
tuple removal. The generalizability is measured similar to above
using an additional dataset version pair ˜𝑇and ˜𝑇′.
We also compute validity and generalizability for other expla-
nations. Validation and generalizability of a removed attribute or
added tuple are computed independently, i.e., a score of 1 is given if
an attribute was removed correctly or a tuple was added correctly.
10

---

7.2
Problem Definition
We now formally state the problem of explaining data versions.
Recall the change sets defined over the 𝑇and 𝑇′ (see Section 3.2).
Definition 14. Given 𝑇′, a version of 𝑇where the goals are
𝐿Δ𝐴(left-hand delta attributes), 𝑅Δ𝐴(right-hand delta attributes),
𝐿Δ𝑟(left-hand delta tuples), and 𝑅Δ𝑟(right-hand delta tuples). From a
search space of possible explanations, the version explanation problem
is to find, for each goal, a set of explanations with the highest validity.
A solution to the version explanation problem is a set of explana-
tions that composed come closest to producing𝑇′ from𝑇. Note that
with validity alone we may have ties (as in our examples where
multiple explanations have validity 1). If we have multiple datasets
(or a dataset holdout), we can use generalizability to pick among
the multiple solutions. We may also relax Definition 14 to find so-
lutions whose validity is within some range of the best and then
use generalizability to select among these candidate solutions. In
addition, we can use explainability (described next) in this selection
and pick explanations that a user can better understand.
7.3
Explanation Explainability
As motivated above, we care about the explainability of the gen-
erated solution. We, again, mainly focus on the attribute addition
transformations. Since we use different models to generate explana-
tions (regressors, decision trees, and programs), we seek a common
ground to measure explainability. Inspired by Narayanan et al. [76]
and Lakkaraju et al. [68], who focus on decision sets, we introduce
two explainability dimensions, namely conciseness, and concentra-
tion, that can be measured across different explanations types.
Explainability Conciseness: Studies show that the fewer the
components in a model and the shorter it is, the easier it is for
a user to understand it [39, 83]. In what follows, we measure the
conciseness of the transformation as the number of components
(𝑁𝑐) it holds. For regression models we use the number of coefficients,
for decision trees we use the number of nodes, and for programs we
use the number of implementation lines.
Example 15. Consider an 𝑒𝑥𝑝(𝐴𝑖) transformation. Obviously a
desired explanation would use the 𝑚𝑎𝑡ℎ(·) extension (Section 4.1) to
generate a valid and generalizable explanation (𝐴𝑖,𝑒𝑥𝑝(𝐴𝑖)) that
obtains an explainability conciseness of 1 (a sole coefficient).
An alternative explanation would use a Taylor Series over the
𝑝𝑜𝑙𝑦(·) extension to generate a valid and generalizable explanation
(𝐴𝑖, 1 + 𝐴𝑖+ 𝐴2
𝑖
2 + 𝐴3
𝑖
6 + . . . ) with an explanability conciseness of
1
𝑑+1, where 𝑑is the polynomial degree. Note that this case also
highlights the trade-off between validity (or generalizability) and
explainability. The bigger the selected degree, the higher the validity
(and generalizability) and the lower the explainability.
Explainability Concentration: While a more concise explana-
tion is favorable, it should also contain as few components as possi-
ble [69] (i.e., it should be as concentrated as possible). Specifically,
since humans have a limited working memory, a solution that is
grouped into fewer chunks of information is favorable [76]. For
example, a linear regression function is easier to understand than
a polynomial regression with reciprocal and logarithmic transfor-
mations, even if the former is longer. For regressors, we count the
extensions that were used (e.g., polynomials and math operations).
For decision trees, we count the number of internal nodes that repre-
sent conditions and for programs we use the number of intermediate
transformations. Let 𝑁𝑔be the number of chunks, the explanability
concentration is then given as 1÷𝑁𝑔such that a more concentrated
transformation gets a higher score.
Example 16. The concentration of (𝐴𝑖,𝑒𝑥𝑝(𝐴𝑖)) and (𝐴𝑖, 1 +
𝐴𝑖+ 𝐴2
𝑖
2 + . . . ) is 0.5 (1 extension, 1 degree) and 1
𝑑, respectively.
To highlight the difference between conciseness and concentration
consider, for example, E1 = 𝐴1 +𝐴2 + 5 and E2 = 𝑙𝑜𝑔(𝐴1) +𝐴2
2 ·𝐴1.
While E1 is less concise ( 1
3 vs 1
2 of E2), it is more concentrated (1)
than E2 ( 1
3) which involves two additional extensions.
The total explanability is a linear combination of conciseness
and concentration that can be defined by a user or a system.6
7.4
On Choosing an Explanation
Explain-Da-V works iteratively, aiming to find valid explanations
for each detected change following Section 5 and Section 6. As
mentioned above, for each goal, multiple explanations can be gen-
erated, for example, if there are multiple origins (Section 4.6) or
we have more than one methodology to explain a transformation
(e.g., different extensions in Section 4.1). Explain-Da-V chooses
the most explainable valid explanation for each goal.
Each independent explanation is derived in a way that optimizes
some notion of error within the respective context that is not always
the same as our definition of validity. A regressor (Section 4.1)
minimizes the mean squared errors, a PBE solution (Section 4.3)
directly optimizes accuracy via search and a decision tree (greedily)
optimizes the split functions of nodes. Given a set of explanations,
we choose one as follows. (1) Find the highest validity in the set. (2) If
multiple explanations share this value, return the most explainable
based on total explainability (see Section 7.3).
Note that generalizability can not be used for explanation selec-
tion unless we have access to a ˜𝑇and ˜𝑇′ (see Section 7.1).
Potentially, there can be a large number of transformations. Deal-
ing with this size, the explanations in a set are generated in a sorted
order by the size and cardinally of their origin (see Section 4.6).
Similarly, among regression models the explanations are sorted
by the amount of extensions that were applied (i.e., first, a model
without extensions is considered). Accordingly, we introduce an
early stop condition such that if an explanation meets a predefined
threshold of validity and explainability, it is returned and the search
is stopped.7 Empirically, almost 70% of cases are terminated early.
8
EMPIRICAL EVALUATION
We now compare our performance to baselines (Section 8.2) and
analyze the components using an ablation study (Section 8.3).
8.1
Experimental Setup
We now detail our benchmarks, implementation, and baselines. The
benchmark and code are available in our repository [15].
6In our experiments we use a uniform combination.
7In our experiments the threshold was set to .95.
11

---

Table 2: Semantic Data Versioning Benchmark Details.
Topic (Name)
# of Original
# of Original
# of
# of
Tuples
Attributes
Versions
Version-pairs
Movies and TV shows [8] (IMDB)
1,000
6
72
29
NBA Players [10] (NBA)
11,700
9
68
27
Wines Reviews [12] (WINE)
129,971
6
72
29
Iris Flowers [9] (IRIS)
150
5
58
22
Titanic Passengers [11] (TITANIC)
891
6
72
29
8.1.1
Benchmarks. We design a new benchmark for the novel task
of semantic data versioning, termed Semantic Data Versioning
Benchmark (SDVB), composed of five version-sets. We also adopt a
publicly available dataset designed by Yang et al. [104] for a similar
task of synthesizing data pipelines.
Semantic Data Versioning Benchmark (SDVB): SDVB contains
a total of 342 dataset versions (136 version pairs) over five different
topics, ranging in length (number of tuples) and width (number of
attributes).8 Each topic represents a version-set that was derived
from a well-known seed dataset detailed in Table 2, which includes
smaller datasets (e.g., IRIS) along side bigger datasets (e.g., WINE).
Version Generation: Given a seed dataset, we revise it to generate
a version of it by first selecting a subset of change dimensions (e.g.,
𝑅Δ𝐴and 𝐿Δ𝑟). Then, based on the dimension, we perform a set of
transformations (some sampled and some manually created). We
assure that each of the five version-sets cover all change dimensions.
Prior to version generating, each dataset is split into 𝑇and ˜𝑇(80%-
20%), where the latter is a hold-out to compute generalizability.
Following Section 7.1, the same changes applied to 𝑇to generate
𝑇′ are applied to ˜𝑇to generate ˜𝑇′.9
Finally, note that a version may be created using more than one
change and, in practice, the aforementioned number of versions is
actually composed of 1,702 changes. For example, to create the
72 WINE dataset versions, a total of 681 changes were applied over
the original dataset and its versions.
Auto-Pipeline Benchmark [1]: This benchmark contains real
data pipelines extracted from Github notebooks. As we focus on
dataset versions, we filter out pipelines that include more than one
table (e.g., those that use a join). Following Yang et al. [104], we
consider the “test” table as 𝑇and the “target” table as 𝑇′. For a fair
comparison, we run Explain-Da-V and all baselines on all the data
and do not consider generalizability for this benchmark.
8.1.2
Implementation. Explain-Da-V was implemented in python,
following Sections 5 and 6. Main parts of the code are provided
in our repository [15]. Linear regression with Lasso [13] and
Rigde [16],10 regularization and decision trees [3] were imple-
mented with Scikit-learn. We extended Foofah’s python publicly
available implementation [7]. We use the Featuretools [5] frame-
work to generate aggregated and group by features (see Section 5.1).
8.1.3
Baselines. Foofah [58] is used as a PBE baseline (see Sec-
tion 2.3). Foofah+ denotes Foofah with our novel extensions (e.g.,
8Not all versions use all original attributes.
9The numbers reported in Table 2 include the hold-outs.
10We first tried applying Lasso and if failed we applied Rigde.
textual-to-numeric, see Section 4.3). As Auto-pipeline’s implemen-
tation is not publicly available, we reproduced its search method-
ology11 using Foofah’s framework by implementing the operators
provided by Yang et al. (Auto-pipeline*) [104]. Search has an ex-
ponential worst case time complexity, so we apply a 60 second
timeout for all methods following the default in Foofah [58].12
We also ran AutoPandas [19] using their available implementa-
tion [2]. AutoPandas creates a search space based on pandas [14]
operations and prunes the space of programs using deep learning.
Similar to the reported performance in Auto-pipeline [104], Au-
toPandas performance was inferior and thus not reported. We also
experimented with SQUARES [80], a recent query reverse engi-
neering framework, and, similarly, do not report its inferior results.
Since SQUARES was designed to synthesize traditional SQL queries
it can sometimes resolve selection predicates; yet, it fails to cope
with other changes such as attributes added using transformations.
Finally, a naïve implementation of the baselines would use all
of 𝑇and 𝑇′ as input-output examples. However, to allow a fair
comparison, we “find the origin” (see Section 4.6) for each of the
baselines and vertical explanations are solved iteratively (each at-
tribute at a time). For horizontal addition explanations the tuples
of 𝑇are used as input and the tuples of 𝑇′ as output (similarly for
horizontal removal with 𝑇′ as input and 𝑇as output).
8.1.4
Evaluation Measures. The explanations provided by our base-
lines are of a single type (programs, not regressors or decision trees),
thus, in Section 8.2, we compare the Validity (Val.) and Generalizabil-
ity (Gen.) of Explain-Da-V to the baselines. Since Explain-Da-V
can return explanations that do not have a validity/generalizability
score of 1.0, we also report the proportion of such explanations out
of all output explanations. We further report the average number of
explanations (# E) from which the method selects the most explain-
able valid (see Section 7.4). We also compare and report runtimes.
Section 8.3 also uses explainability (conciseness and concentration).
8.2
Explain-Da-V Compared to Baselines
The comparison between Explain-Da-V and the baselines (Sec-
tion 8.1.3) over the benchmarks (Section 8.1.1) is reported in Table 6.
Explain-Da-V performs much better than the baselines mainly
due to its ability to cope with varying data types (numeric and
categorical in addition to textual). The adapted Auto-pipeline
benchmark is an exception where Explain-Da-V only performs
slightly better than Auto-pipeline*. Also, even if we zoom-in only
on textual transformations (provided in a technical report [91]),
Explain-Da-V still out-performs all baselines. Even when we eval-
uate only the 100% valid/generalizable explanations returned by
Explain-Da-V (denoted in parenthesis in Table 6), we observe a sig-
nificant improvement. Across baselines, we observe that extending
Foofah (Foofah+) provides an average validity and generalizability
boost of 9.5%, showing the benefit of the extended search space. All
methods select among multiple explanations (# E, see Section 8.1.4)
based on multiple origins (see Section 8.1.3). Explain-Da-V consid-
ers almost twice as many explanations since it generates expanded
origins for numeric explanations (see Section 4.1).
11Reinforcement learning requires training data, which we assume unavailable.
12We note that Auto-pipeline default timeout limit is an hour
12

---

Table 3: Performance in terms of Validity (Val), Generalizability (Gen) and average number of explanations the method chooses
from (# E). For Explain-Da-V, we also report (in parenthesis) the proportion of explanations with Val/Gen score of 1.
Dataset→
IMDB
NBA
WINE
IRIS
TITANIC
Auto-pipeline
↓Method
Val
Gen
# E
Val
Gen
# E
Val
Gen
# E
Val
Gen
# E
Val
Gen
# E
Val
Gen
# E
Foofah
.42
.42
3.7
.28
.28
4.2
.29
.29
3.9
.23
.23
3.1
.29
.29
4.1
.55
-
3.3
Foofah+
.44
.44
3.7
.29
.29
4.2
.34
.34
3.9
.25
.25
3.1
.37
.37
4.1
.55
-
3.3
Auto-pipeline*
.44
.44
3.7
.30
.30
4.2
.33
.33
3.9
.26
.26
3.1
.37
.37
4.1
.78
-
3.3
Explain-Da-V
.73 (.64)
.60 (.56)
6.4
.90 (.89)
.79 (.69)
7.3
.87 (.76)
.81 (.59)
6.8
.93 (.88)
.83 (.76)
8.9
.88 (.79)
.77 (.68)
7.2
.82 (.78)
-
5.7
+ over baseline
+65%
+36%
+202%
+167%
+156%
+138%
+254%
+217%
+140%
+109%
+5%
-
Table 4: Foofah, Foofah+, Auto-pipeline*, and Explain-Da-V performance in terms of Validity (Val.) and Generalizability (Gen.)
for Numeric goals
Dataset→
IMDB
NBA
WINE
IRIS
TITANIC
↓Method
Val.
Gen.
Val.
Gen.
Val.
Gen.
Val.
Gen.
Val.
Gen.
Foofah
.20
.20
.11
.11
.14
.14
.18
.18
.12
.12
Foofah+
.20
.20
.15
.15
.16
.16
.21
.21
.24
.24
Auto-pipeline*
.22
.22
.16
.16
.18
.18
.22
.22
.26
.26
Explain-Da-V
.97 (+340%)
.85(+286%)
.72 (+350%)
.66 (+313%)
.87 (+383%)
.75 (+316%)
.99 (+350%)
.85 (+286%)
.92 (+253%)
.84 (+223%)
Table 5: Foofah, Foofah+, Auto-pipeline*, and Explain-Da-V performance in terms of Validity (Val.) and Generalizability (Gen.)
for Categorical goals
Dataset→
IMDB
NBA
WINE
IRIS
TITANIC
↓Method
Val.
Gen.
Val.
Gen.
Val.
Gen.
Val.
Gen.
Val.
Gen.
Foofah
.15
.15
.09
.09
.16
.16
.23
.23
.22
.22
Foofah+
.25
.25
.12
.12
.18
.18
.25
.25
.22
.22
Auto-pipeline*
.27
.27
.12
.12
.17
.17
.26
.26
.22
.22
Explain-Da-V
.86 (+218%)
.86(+218%)
.99 (+725%)
.87 (+625%)
.89 (+423%)
.78 (+358%)
.98 (+277%)
.91 (+250%)
.88 (+300%)
.83 (+277%)
Table 6: Foofah, Foofah+, Auto-pipeline*, and Explain-Da-V performance in terms of Validity (Val.) and Generalizability (Gen.)
for Textual goals
Dataset→
IMDB
NBA
WINE
IRIS
TITANIC
↓Method
Val.
Gen.
Val.
Gen.
Val.
Gen.
Val.
Gen.
Val.
Gen.
Foofah
.50
.50
.48
.48
.44
.44
.33
.33
.47
.47
Foofah+
.52
.52
.50
.50
.53
.53
.42
.42
.48
.48
Auto-pipeline*
.52
.52
.56
.56
.53
.53
.38
.38
.50
.50
Explain-Da-V
.62 (+19%)
.57(+10%)
.88 (+57%)
.67 (+20%)
.58 (+9%)
.56 (+6%)
.82 (+115%)
.72 (+89%)
.79 (+58%)
.69 (+38%)
Comparing among version-sets, we observe that in the IRIS
dataset, Explain-Da-V obtained the best performance (.927 Val.
and .831 Gen.) and the highest improvement. For the IMDB version-
set, Explain-Da-V obtained the worst performance (.732 Val. and
.602 Gen.) and lowest improvement (among the newly suggested
benchmark version-sets). IRIS is mostly composed of numeric at-
tributes (4 out of 5) which are solved using our numeric change
explanations (Section 4.1) and are not dealt with by the baselines.
Note that accordingly, Explain-Da-V considers almost three times
as many explanations. Yet, the numeric extensions introduced in
Section 4.1 and the fact that we find the origin helps to home in
on a valid solution quite quickly (see runtime below). The IMDB
version-set, on the other hand, contains more textual attributes (5
out of 6) and involves changes that Explain-Da-V fails to solve. For
example, one of the IMDB version-sets involves a transformation
that adds an attribute containing the count of the number of genres
from a Genre attribute. In the Genre attribute, the genres are sepa-
rated by a comma (e.g., Drama, Romance). A correct transformation
would, for example, count the number of commas and add 1. While
finding a transformation that counts the number of commas is a
practical task for Explain-Da-V (which includes textual transfor-
mations and aggregations), such a composition is not currently
possible. Instead, the explanation Explain-Da-V chose (most valid,
see Section 7.4) uses an IMDB Rating attribute to determine the
number of genres using a decision tree with a validity of 0.65.13
Finally, we note that the performance varies with respect to the
different change dimensions. Interestingly, if we only look at verti-
cal removals (Section 5.2), all three baselines have a validity and
generalizability score of 1. The reason for that is their ability to
13The explanation is available in the repository [4].
13

---

Full
W/O extentions
W/O find origin
All numeric
All textual
0.0
0.2
0.4
0.6
0.8
1
Validity
(a) Validity
IMDB
IRIS
WINE
NBA
TITANIC
Full
W/O extentions
W/O find origin
All numeric
All textual
0.0
0.2
0.4
0.6
0.8
1
Generalizability
(b) Generalizability
Full
W/O extentions
W/O find origin
All numeric
All textual
0.0
0.2
0.4
0.6
0.8
1
Conciseness
(c) Conciseness
Full
W/O extentions
W/O find origin
All numeric
All textual
0.0
0.2
0.4
0.6
0.8
1
Concentration
(d) Concentration
Figure 12: Ablation Study over SDVB datasets.
discover projections (in their terms applying a drop operation over
an attribute). Although it successfully finds these transformations,
it lacks the ability to explain the semantics of the attribute removal.
Explain-Da-V, although not perfectly valid and generalizable (.95),
is more expressive in term of explaining the removal. For exam-
ple, explaining that an attribute was removed because it contains
duplicated information (see Section 5.2). When looking at tuple
removal, Explain-Da-V performs much better than the baselines.
Since Auto-pipeline does “not consider row-level filtering” [104],
we recall the comparison against SQUARES (see Section 8.1.3). De-
spite its focus on learning a selection predicate, SQUARES is able
to resolve cases where a predicate was applied with 0.6 validity
(Explain-Da-V obtains 0.73 over these changes). This is because
SQUARES was not able to resolve removing tuples containing NaN
values and duplicate tuples (two cases in the benchmark).
Runtime: In these experiments, excluding timeouts (see Sec-
tion 8.1.3), finding an explanation using foofah took an average of
4.9 seconds, foofah+ 12.4 seconds, Auto-pipeline* 8.1 seconds, and
Explain-Da-V 2.4 seconds. A reason for that difference is that fit-
ting a regressor (linear time complexity) and learning a decision tree
(quadratic complexity) are more efficient than search (exponential).
8.3
Explain-Da-V Ablation Study
Figure 12 provides an ablation study of Explain-Da-V. We focus
on vertical addition explanations and analyze Explain-Da-V per-
formance without finding the origin (W/O find origin), i.e., using 𝑇
as a whole to explain a given goal and without the extensions for
numeric-to-numeric transformations (W/O extensions). We also an-
alyze the resolved data types by applying Explain-Da-V assuming
all types are numeric (All numeric) or all textual (All textual).
As illustrated in Figures 12a and 12b, the full Explain-Da-V
provides the most valid and generalizable performance. Adding
extensions and finding the origin provide an average performance
boost of 30% and 107%, respectively, in terms of validity, while
addressing all attribute types as numeric and textual decreases
the validity by 35% and 64%, respectively. The NBA version-set
demonstrates an interesting case. Since it contains diverse attributes
of varying types, without finding origin, Explain-Da-V obtains
very low validity and generalizability. Similarly, as mentioned above,
since the IRIS version-set mainly consists of numeric attributes,
treating all attributes as textual results in very low performance.
Examining the explainability (Figures 12c-12d), we observe that
while less valid and generalizable, explanations without extensions
are more concise and concentrated. If an origin is not found, the
explanations are usually less concise and much less concentrated.
Finally, numeric explanations are more explainable than textual
explanations especially in terms of conciseness. Limitations via
Interesting Cases: Consider the NBA version-set. One vertical
addition in this dataset creates a binary attribute representing an
indicator for a “double double” performance.14 A valid and gen-
eralizable transformation generated by Explain-Da-V returns 1
if 𝐴𝑎𝑠𝑡> 10 (more than 10 assists) simply because for each tuple
𝑟𝑖∈𝑇such that 𝜋𝐴𝑎𝑠𝑡[𝑟𝑖] > 10 it also happens that 𝜋𝐴𝑝𝑡𝑠[𝑟𝑖] > 10
(more than 10 points). While correct in the specific scenario, it does
not capture the semantics of a double double.
Another interesting case considers a square-root transformation
over movie rating (𝐴𝑟𝑎𝑡𝑖𝑛𝑔) in the IMDB version-set. Explain-Da-V
generated two valid and generalizable explanations one using the
transformation 𝑠𝑞𝑟𝑡(𝐴𝑟𝑎𝑡𝑖𝑛𝑔) (using the 𝑚𝑎𝑡ℎextensions) and one
using a polynomial transformation 1.074 + 0.262 · 𝐴𝑟𝑎𝑡𝑖𝑛𝑔−0.005 ·
𝐴2
𝑟𝑎𝑡𝑖𝑛𝑔. Obviously, these two transformations are different; how-
ever, if we zoom in on the range 𝑥∈[6, 10] (typical ratings in
IMDB), we observe that the transformations behave almost iden-
tically. For example, a rating of 9 would be transformed to 3 and
3.02, respectively. An illustration is given in our repository [17].
9
CONCLUSION
This work laid the groundwork for explaining semantic changes in
data versioning. Explain-Da-V, uses different types of techniques
to resolve and explain changes between a pair of dataset versions.
We introduced measures to evaluate explanations and show that
Explain-Da-V performs better than multiple baselines over an ex-
isting adapted benchmark and a newly introduced data versioning
benchmark. In future work, we intend to extend Explain-Da-V
to address additional data types, e.g., dates, and address changes
that are triggered by external data such as performing joins and
unions. An additional future challenge is to formulate the version
explanation problem as a multi-objective optimization problem that
collectively optimizes validity, generalizability, and explainability.
REFERENCES
[1] 2022. Auto-pipeline benchmark. https://gitlab.com/jwjwyoung/autopipeline-
benchmarks.
[2] 2022. AutoPandas Implementation. https://github.com/rbavishi/autopandas.
[3] 2022. Decision Trees. https://scikit-learn.org/stable/modules/tree.html.
[4] 2022. Explanation Example. https://github.com/shraga89/ExplainDaV/blob/
main/Explanation_Example.md.
[5] 2022. Featuretools. https://www.featuretools.com/.
[6] 2022. Foofah Extensions (Repository). https://github.com/shraga89/ExplainDaV/
blob/main/Code/Ops_added_to_Foofah.py.
[7] 2022. Foofah Implementation. https://github.com/umich-dbgroup/foofah.
[8] 2022.
Initial
IMDB
dataset.
https://www.kaggle.com/datasets/
harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows.
[9] 2022. Initial IRIS dataset. https://www.kaggle.com/uciml/iris.
[10] 2022. Initial NBA dataset. https://www.kaggle.com/justinas/nba-players-data.
[11] 2022. Initial TITANIC dataset. https://www.kaggle.com/competitions/titanic.
14In basketball, a double-double is when a player accumulates ten or more in two
of statistical categories https://en.wikipedia.org/wiki/Double-double.
14

---

[12] 2022.
Initial WINE dataset.
https://www.kaggle.com/christopheiv/
winemagdata130k.
[13] 2022. Lasso Regularization. https://scikit-learn.org/stable/modules/generated/
sklearn.linear_model.Lasso.html.
[14] 2022. Pandas. https://pandas.pydata.org/.
[15] 2022. Repository. https://github.com/shraga89/ExplainDaV.
[16] 2022. Rigde Regularization. https://scikit-learn.org/stable/modules/generated/
sklearn.linear_model.Rigde.html.
[17] 2022. Sqrt Example (Repository). https://github.com/shraga89/ExplainDaV/
blob/main/sqrt_example.pdf.
[18] Ziawasch Abedjan, John Morcos, Ihab F. Ilyas, Mourad Ouzzani, Paolo Papotti,
and Michael Stonebraker. 2016. DataXFormer: A robust transformation discov-
ery system. In 32nd IEEE International Conference on Data Engineering, ICDE
2016, Helsinki, Finland, May 16-20, 2016. IEEE Computer Society, 1134–1145.
https://doi.org/10.1109/ICDE.2016.7498319
[19] Rohan Bavishi, Caroline Lemieux, Roy Fox, Koushik Sen, and Ion Stoica. 2019.
AutoPandas: neural-backed generators for program synthesis. Proc. ACM Pro-
gram. Lang. 3, OOPSLA (2019), 168:1–168:27. https://doi.org/10.1145/3360594
[20] Ladjel Bellatreche and Robert Wrembel. 2013. Special issue on: Evolution and
versioning in semantic data integration systems. , 57–59 pages.
[21] Anant P. Bhardwaj, Souvik Bhattacherjee, Amit Chavan, Amol Deshpande,
Aaron J. Elmore, Samuel Madden, and Aditya G. Parameswaran. 2015. DataHub:
Collaborative Data Science & Dataset Version Management at Scale. In Seventh
Biennial Conference on Innovative Data Systems Research, CIDR 2015, Asilomar,
CA, USA, January 4-7, 2015, Online Proceedings. www.cidrdb.org. http://cidrdb.
org/cidr2015/Papers/CIDR15_Paper18.pdf
[22] Souvik Bhattacherjee, Amit Chavan, Silu Huang, Amol Deshpande, and Aditya
Parameswaran. 2015. Principles of dataset versioning: Exploring the recre-
ation/storage tradeoff. In Proceedings of the VLDB Endowment. International
Conference on Very Large Data Bases, Vol. 8. NIH Public Access, 1346.
[23] Tobias Bleifuß, Leon Bornemann, Theodore Johnson, Dmitri V Kalashnikov, Felix
Naumann, and Divesh Srivastava. 2018. Exploring change: A new dimension of
data analytics. Proceedings of the VLDB Endowment 12, 2 (2018), 85–98.
[24] Tobias Bleifuß, Leon Bornemann, Dmitri V Kalashnikov, Felix Naumann, and
Divesh Srivastava. 2019. DBChEx: Interactive Exploration of Data and Schema
Change. In CIDR.
[25] Alex Bogatu, Norman W. Paton, Alvaro A. A. Fernandes, and Martin Koehler.
2019. Towards Automatic Data Format Transformations: Data Wrangling at
Scale. Comput. J. 62, 7 (2019), 1044–1060. https://doi.org/10.1093/comjnl/bxy118
[26] Leon Bornemann, Tobias Bleifuß, Dmitri Kalashnikov, Felix Naumann, and
Divesh Srivastava. 2018. Data change exploration using time series clustering.
Datenbank-Spektrum 18, 2 (2018), 79–87.
[27] Richard J Brook and Gregory C Arnold. 2018. Applied regression analysis and
experimental design. CRC Press.
[28] Jason Brownlee. 2022. Data preparation for machine learning.
[29] Douglas Burdick, Ronald Fagin, Phokion G. Kolaitis, Lucian Popa, and Wang-
Chiew Tan. 2016. A Declarative Framework for Linking Entities. ACM Trans.
Database Syst. 41, 3 (2016), 17:1–17:38.
[30] Nadia Burkart and Marco F Huber. 2021. A survey on the explainability of
supervised machine learning. Journal of Artificial Intelligence Research 70 (2021),
245–317.
[31] Hancheng Cao, Vivian Yang, Victor Chen, Yu Jin Lee, Lydia Stone, N’godjigui Ju-
nior Diarrassouba, Mark E Whiting, and Michael S Bernstein. 2021. My team
will go on: Differentiating high and low viability teams through team interaction.
Proceedings of the ACM on Human-Computer Interaction 4, CSCW3 (2021), 1–27.
[32] Varun Chandola, Arindam Banerjee, and Vipin Kumar. 2009. Anomaly detection:
A survey. ACM computing surveys (CSUR) 41, 3 (2009), 1–58.
[33] Adriane Chapman, Elena Simperl, Laura Koesten, George Konstantinidis, Luis-
Daniel Ibáñez, Emilia Kacprzak, and Paul Groth. 2020. Dataset search: a survey.
VLDB J. 29, 1 (2020), 251–272.
[34] Sudarshan S Chawathe and Hector Garcia-Molina. 1997. Meaningful change
detection in structured data. ACM SIGMOD Record 26, 2 (1997), 26–37.
[35] Sudarshan S Chawathe, Anand Rajaraman, Hector Garcia-Molina, and Jennifer
Widom. 1996. Change detection in hierarchically structured information. Acm
Sigmod Record 25, 2 (1996), 493–504.
[36] James Cheney, Laura Chiticariu, Wang-Chiew Tan, et al. 2009. Provenance in
databases: Why, how, and where. Foundations and Trends® in Databases 1, 4
(2009), 379–474.
[37] Anton Chernyavskiy, Dmitry Ilvovsky, and Preslav Nakov. 2021. Transform-
ers:“The End of History” for Natural Language Processing?. In Joint European
Conference on Machine Learning and Knowledge Discovery in Databases. Springer,
677–693.
[38] Gregory Cobena, Serge Abiteboul, and Amelie Marian. 2002. Detecting changes
in XML documents. In Proceedings 18th International Conference on Data Engi-
neering. IEEE, 41–52.
[39] Nicole Cruz, Jean Baratgin, Mike Oaksford, and David E Over. 2015. Bayesian
reasoning with ifs and ands and ors. Frontiers in psychology 6 (2015), 192.
[40] Giovanni Da San Martino, Seunghak Yu, Alberto Barrón-Cedeno, Rostislav
Petrov, and Preslav Nakov. 2019. Fine-grained analysis of propaganda in news
article. In Proceedings of the 2019 conference on empirical methods in natural
language processing and the 9th international joint conference on natural language
processing (EMNLP-IJCNLP). 5636–5646.
[41] Anish Das Sarma, Lujun Fang, Nitin Gupta, Alon Halevy, Hongrae Lee, Fei Wu,
Reynold Xin, and Cong Yu. 2012. Finding Related Tables. In Proceedings of the
2012 ACM SIGMOD International Conference on Management of Data (Scottsdale,
Arizona, USA) (SIGMOD ’12). Association for Computing Machinery, New York,
NY, USA, 817–828. https://doi.org/10.1145/2213836.2213962
[42] Canada Open Data. 2020. https://open.canada.ca/en/open-data
[43] UK Open Data. 2020. https://data.gov.uk/
[44] Boer Deng. 2015. Papers with shorter titles get more citations. Nature News 26
(2015).
[45] Dong Deng, Wenbo Tao, Ziawasch Abedjan, Ahmed K. Elmagarmid, Ihab F.
Ilyas, Guoliang Li, Samuel Madden, Mourad Ouzzani, Michael Stonebraker,
and Nan Tang. 2019. Unsupervised String Transformation Learning for Entity
Consolidation. In 35th IEEE International Conference on Data Engineering, ICDE
2019, Macao, China, April 8-11, 2019. IEEE, 196–207. https://doi.org/10.1109/
ICDE.2019.00026
[46] Jeffrey R Edwards. 2002. Alternatives to difference scores: Polynomial regression
and response surface methodology. Advances in measurement and data analysis
(2002), 350–400.
[47] Kareem El Gebaly, Parag Agrawal, Lukasz Golab, Flip Korn, and Divesh Srivas-
tava. 2014. Interpretable and informative explanations of outcomes. Proceedings
of the VLDB Endowment 8, 1 (2014), 61–72.
[48] Ahmed K Elmagarmid, Panagiotis G Ipeirotis, and Vassilios S Verykios. 2006.
Duplicate record detection: A survey. IEEE Transactions on knowledge and data
engineering 19, 1 (2006), 1–16.
[49] Peter A Flach and Iztok Savnik. 1999. Database dependency discovery: a machine
learning approach. AI Communications 12 (3) (1999), 139 – 160. http://content.
iospress.com/articles/ai-communications/aic182 Publisher: IOS Press.
[50] Yihan Gao, Silu Huang, and Aditya G. Parameswaran. 2018. Navigating the
Data Lake with DATAMARAN: Automatically Extracting Structure from Log
Datasets. In Proceedings of the 2018 International Conference on Management of
Data, SIGMOD Conference 2018, Houston, TX, USA, June 10-15, 2018, Gautam
Das, Christopher M. Jermaine, and Philip A. Bernstein (Eds.). ACM, 943–958.
https://doi.org/10.1145/3183713.3183746
[51] Dimitris C Gkikas, Katerina Tzafilkou, Prokopis K Theodoridis, Aristogiannis
Garmpis, and Marios C Gkikas. 2022. How do text characteristics impact user
engagement in social media posts: Modeling content readability, length, and
hashtags number in Facebook. International Journal of Information Management
Data Insights 2, 1 (2022), 100067.
[52] William R. Harris and Sumit Gulwani. 2011. Spreadsheet table transforma-
tions from examples. In Proceedings of the 32nd ACM SIGPLAN Conference on
Programming Language Design and Implementation, PLDI 2011, San Jose, CA,
USA, June 4-8, 2011, Mary W. Hall and David A. Padua (Eds.). ACM, 317–328.
https://doi.org/10.1145/1993498.1993536
[53] Yeye He, Xu Chu, Kris Ganjam, Yudian Zheng, Vivek R. Narasayya, and Surajit
Chaudhuri. 2018. Transform-Data-by-Example (TDE): An Extensible Search
Engine for Data Transformations. Proc. VLDB Endow. 11, 10 (2018), 1165–1177.
https://doi.org/10.14778/3231751.3231766
[54] Yeye He, Zhongjun Jin, and Surajit Chaudhuri. 2020. Auto-Transform: Learning-
to-Transform by Patterns. Proc. VLDB Endow. 13, 11 (2020), 2368–2381. http:
//www.vldb.org/pvldb/vol13/p2368-he.pdf
[55] Fred Hohman, Kanit Wongsuphasawat, Mary Beth Kery, and Kayur Patel. 2020.
Understanding and visualizing data iteration in machine learning. In Proceedings
of the 2020 CHI conference on human factors in computing systems. 1–13.
[56] The home of the U.S. Government’s open data. 2020. https://data.gov/
[57] Silu Huang, Liqi Xu, Jialin Liu, Aaron J Elmore, and Aditya Parameswaran. 2017.
ORPHEUSDB: Bolt-on Versioning for Relational Databases. Proceedings of the
VLDB Endowment 10, 10 (2017).
[58] Zhongjun Jin, Michael R. Anderson, Michael J. Cafarella, and H. V. Jagadish. 2017.
Foofah: Transforming Data By Example. In Proceedings of the 2017 ACM Interna-
tional Conference on Management of Data, SIGMOD Conference 2017, Chicago, IL,
USA, May 14-19, 2017, Semih Salihoglu, Wenchao Zhou, Rada Chirkova, Jun Yang,
and Dan Suciu (Eds.). ACM, 683–698. https://doi.org/10.1145/3035918.3064034
[59] Zhongjun Jin, Michael J. Cafarella, H. V. Jagadish, Sean Kandel, Michael Minar,
and Joseph M. Hellerstein. 2019. CLX: Towards verifiable PBE data transfor-
mation. In Advances in Database Technology - 22nd International Conference
on Extending Database Technology, EDBT 2019, Lisbon, Portugal, March 26-29,
2019, Melanie Herschel, Helena Galhardas, Berthold Reinwald, Irini Fundu-
laki, Carsten Binnig, and Zoi Kaoudi (Eds.). OpenProceedings.org, 265–276.
https://doi.org/10.5441/002/edbt.2019.24
[60] Mary Beth Kery, Amber Horvath, and Brad Myers. 2017. Variolite: Supporting
Exploratory Programming by Data Scientists. In Proceedings of the 2017 CHI
Conference on Human Factors in Computing Systems. 1265–1276.
15

---

[61] Mary Beth Kery, Bonnie E John, Patrick O’Flaherty, Amber Horvath, and Brad A
Myers. 2019. Towards effective foraging by data scientists to find past analysis
choices. In Proceedings of the 2019 CHI Conference on Human Factors in Computing
Systems. 1–13.
[62] Mary Beth Kery, Marissa Radensky, Mahima Arya, Bonnie E John, and Brad A
Myers. 2018. The story in the notebook: Exploratory data science using a literate
programming tool. In Proceedings of the 2018 CHI Conference on Human Factors
in Computing Systems. 1–11.
[63] Aamod Khatiwada, Grace Fan, Roee Shraga, Zixuan Chen, Wolfgang Gatter-
bauer, Renée J Miller, and Mirek Riedewald. 2023. SANTOS: Relationship-
based Semantic Table Union Search. In SIGMOD Conference 2023. ACM. https:
//arxiv.org/pdf/2209.13589.pdf
[64] Aamod Khatiwada, Roee Shraga, Wolfgang Gatterbauer, and Renée J. Miller.
2022. Integrating Data Lake Tables. Proc. VLDB Endow. 16, 4 (2022), 932–945.
https://www.vldb.org/pvldb/vol16/p932-khatiwada.pdf
[65] Alexandra Kim, Laks VS Lakshmanan, and Divesh Srivastava. 2020.
Sum-
marizing hierarchical multidimensional data. In 2020 IEEE 36th International
Conference on Data Engineering (ICDE). IEEE, 877–888.
[66] Olga Kovaleva, Alexey Romanov, Anna Rogers, and Anna Rumshisky. 2019.
Revealing the Dark Secrets of BERT. In Proceedings of the 2019 Conference on
Empirical Methods in Natural Language Processing and the 9th International Joint
Conference on Natural Language Processing (EMNLP-IJCNLP). 4365–4374.
[67] Max Kuhn and Kjell Johnson. 2019. Feature engineering and selection: A practical
approach for predictive models. CRC Press.
[68] Himabindu Lakkaraju, Stephen H Bach, and Jure Leskovec. 2016. Interpretable
decision sets: A joint framework for description and prediction. In Proceedings
of the 22nd ACM SIGKDD international conference on knowledge discovery and
data mining. 1675–1684.
[69] Benjamin Letham, Cynthia Rudin, Tyler H McCormick, and David Madigan.
2015. Interpretable classifiers using rules and bayesian analysis: Building a
better stroke prediction model. The Annals of Applied Statistics 9, 3 (2015),
1350–1371.
[70] Yuliang Li, Jinfeng Li, Yoshihiko Suhara, AnHai Doan, and Wang-Chiew Tan.
2020. Deep entity matching with pre-trained language models. Proceedings of
the VLDB Endowment 14, 1 (2020), 50–60.
[71] Benjamin Marlin. 2004. Collaborative filtering: A machine learning perspective.
University of Toronto Toronto.
[72] Zhengjie Miao, Qitian Zeng, Boris Glavic, and Sudeepa Roy. 2019. Going beyond
provenance: Explaining query answers with pattern-based counterbalances.
In Proceedings of the 2019 International Conference on Management of Data.
485–502.
[73] Renée J Miller. 2018. Open data integration. Proceedings of the VLDB Endowment
11, 12 (2018), 2130–2139.
[74] Tom Mitchell. 1997. Decision tree learning. Machine learning 414 (1997), 52–78.
[75] Heiko Müller, Johann-Christoph Freytag, and Ulf Leser. 2006. Describing differ-
ences between databases. In Proceedings of the 15th ACM international conference
on Information and knowledge management. 612–621.
[76] Menaka Narayanan, Emily Chen, Jeffrey He, Been Kim, Sam Gershman, and Fi-
nale Doshi-Velez. 2018. How do humans understand explanations from machine
learning systems? an evaluation of the human-interpretability of explanation.
arXiv preprint arXiv:1802.00682 (2018).
[77] Fatemeh Nargesian, Erkang Zhu, Renée J. Miller, Ken Q. Pu, and Patricia C.
Arocena. 2019. Data Lake Management: Challenges and Opportunities. Proc.
VLDB Endow. 12, 12 (aug 2019), 1986–1989. https://doi.org/10.14778/3352063.
3352116
[78] Fatemeh Nargesian, Erkang Zhu, Ken Q. Pu, and Renée J. Miller. 2018. Table
Union Search on Open Data. Proc. VLDB Endow. 11, 7 (mar 2018), 813–825.
https://doi.org/10.14778/3192965.3192973
[79] Andrew Nierman and HV Jagadish. 2002. Evaluating Structural Similarity in
XML Documents.. In webdb, Vol. 2. Citeseer, 61–66.
[80] Pedro Orvalho, Miguel Terra-Neves, Miguel Ventura, Ruben Martins, and Vasco
Manquinho. 2020. SQUARES: a SQL synthesizer using query reverse engineering.
Proceedings of the VLDB Endowment 13, 12 (2020), 2853–2856.
[81] Aslihan Özmen, Mahdi Esmailoghli, and Ziawasch Abedjan. 2021.
Com-
bining Programming-by-Example with Transformation Discovery from large
Databases. In Datenbanksysteme für Business, Technologie und Web (BTW 2021),
19. Fachtagung des GI-Fachbereichs „Datenbanken und Informationssysteme"
(DBIS), 13.-17. September 2021, Dresden, Germany, Proceedings (LNI), Kai-Uwe
Sattler, Melanie Herschel, and Wolfgang Lehner (Eds.), Vol. P-311. Gesellschaft
für Informatik, Bonn, 313–324. https://doi.org/10.18420/btw2021-16
[82] Thorsten Papenbrock, Jens Ehrlich, Jannik Marten, Tommy Neubert, Jan-Peer
Rudolph, Martin Schönberg, Jakob Zwiener, and Felix Naumann. 2015. Func-
tional Dependency Discovery: An Experimental Evaluation of Seven Algorithms.
Proc. VLDB Endow. 8, 10 (2015), 1082–1093. https://doi.org/10.14778/2794367.
2794377
[83] Forough Poursabzi-Sangdeh, Daniel G Goldstein, Jake M Hofman, Jennifer Wort-
man Wortman Vaughan, and Hanna Wallach. 2021. Manipulating and measuring
model interpretability. In Proceedings of the 2021 CHI conference on human factors
in computing systems. 1–52.
[84] Erhard Rahm and Philip A Bernstein. 2001. A survey of approaches to automatic
schema matching. the VLDB Journal 10, 4 (2001), 334–350.
[85] John F Roddick. 1995. A survey of schema versioning issues for database systems.
Information and Software Technology 37, 7 (1995), 383–393.
[86] Pau Rodríguez, Miguel A Bautista, Jordi Gonzalez, and Sergio Escalera. 2018.
Beyond one-hot encoding: Lower dimensional target embedding. Image and
Vision Computing 75 (2018), 21–31.
[87] Sudeepa Roy, Laurel Orr, and Dan Suciu. 2015. Explaining query answers with
explanation-ready databases. Proceedings of the VLDB Endowment 9, 4 (2015),
348–359.
[88] Maximilian E Schüle, Josef Schmeißer, Thomas Blum, Alfons Kemper, and
Thomas Neumann. 2021. TardisDB: Extending SQL to Support Versioning.
In Proceedings of the 2021 International Conference on Management of Data.
2775–2778.
[89] Vraj Shah, Jonathan Lacanlale, Premanand Kumar, Kevin Yang, and Arun Kumar.
2021. Towards Benchmarking Feature Type Inference for AutoML Platforms.
In Proceedings of the 2021 International Conference on Management of Data.
1584–1596.
[90] Roee Shraga, Avigdor Gal, and Haggai Roitman. 2020. Adnev: Cross-domain
schema matching using deep similarity matrix adjustment and evaluation. Pro-
ceedings of the VLDB Endowment 13, 9 (2020), 1401–1415.
[91] Roee Shraga and Renée J. Miller. 2022. Explaining Dataset Changes for Semantic
Data Versioning with Explain-Da-V (Technical Report). https://github.com/
shraga89/ExplainDaV/blob/main/Explain_Da_V_TR.pdf
[92] Rishabh Singh. 2016. BlinkFill: Semi-supervised Programming By Example for
Syntactic String Transformations. Proc. VLDB Endow. 9, 10 (2016), 816–827.
https://doi.org/10.14778/2977797.2977807
[93] Rishabh Singh and Sumit Gulwani. 2012. Learning Semantic String Trans-
formations from Examples. Proc. VLDB Endow. 5, 8 (2012), 740–751.
https:
//doi.org/10.14778/2212351.2212356
[94] Richard T Snodgrass, Curtis Dyreson, Faiz Currim, Sabah Currim, and Shailesh
Joshi. 2008. Validating quicksand: Temporal schema versioning in 𝜏XSchema.
Data & Knowledge Engineering 65, 2 (2008), 223–242.
[95] Charles Sutton, Timothy Hobson, James Geddes, and Rich Caruana. 2018. Data
diff: Interpretable, executable summaries of changes in distributions for data
wrangling. In Proceedings of the 24th ACM SIGKDD International Conference on
Knowledge Discovery & Data Mining. 2279–2288.
[96] Christos Thrampoulidis, Samet Oymak, and Babak Hassibi. 2015. Regularized
linear regression: A precise analysis of the estimation error. In Conference on
Learning Theory. PMLR, 1683–1709.
[97] Kai Ming Ting, Sunil Aryal, and Takashi Washio. 2018. Which Outlier Detector
Should I use?. In 2018 IEEE International Conference on Data Mining (ICDM).
IEEE, 8–8.
[98] Quoc Trung Tran, Chee-Yong Chan, and Srinivasan Parthasarathy. 2014. Query
reverse engineering. The VLDB Journal 23, 5 (2014), 721–746.
[99] Panos Vassiliadis. 2009. A survey of extract–transform–load technology. Inter-
national Journal of Data Warehousing and Mining (IJDWM) 5, 3 (2009), 1–27.
[100] S Vijayarani, Ms J Ilamathi, Ms Nithya, et al. 2015. Preprocessing techniques
for text mining-an overview. International Journal of Computer Science & Com-
munication Networks 5, 1 (2015), 7–16.
[101] Xiaolan Wang and Alexandra Meliou. 2019. Explain 3D: explaining disagree-
ments in disjoint datasets. Proceedings of the VLDB Endowment 12, 7 (2019).
[102] Yuan Wang, David J DeWitt, and J-Y Cai. 2003. X-Diff: An effective change detec-
tion algorithm for XML documents. In Proceedings 19th international conference
on data engineering (Cat. No. 03CH37405). IEEE, 519–530.
[103] Cong Yan and Yeye He. 2020. Auto-suggest: Learning-to-recommend data
preparation steps using data science notebooks. In Proceedings of the 2020 ACM
SIGMOD International Conference on Management of Data. 1539–1554.
[104] Junwen Yang, Yeye He, and Surajit Chaudhuri. 2021. Auto-pipeline: synthesiz-
ing complex data pipelines by-target using reinforcement learning and search.
Proceedings of the VLDB Endowment 14, 11 (2021), 2563–2575.
[105] Gunce Su Yilmaz, Tana Wattanawaroon, Liqi Xu, Abhishek Nigam, Aaron J
Elmore, and Aditya Parameswaran. 2018. Datadiff: User-interpretable data
transformation summaries for collaborative data analysis. In Proceedings of the
2018 International Conference on Management of Data. 1769–1772.
[106] Amy X Zhang, Michael Muller, and Dakuo Wang. 2020. How do data science
workers collaborate? roles, workflows, and tools. Proceedings of the ACM on
Human-Computer Interaction 4, CSCW1 (2020), 1–23.
[107] Alice Zheng and Amanda Casari. 2018. Feature engineering for machine learning:
principles and techniques for data scientists. " O’Reilly Media, Inc.".
[108] Erkang Zhu, Dong Deng, Fatemeh Nargesian, and Renée J Miller. 2019. Josie:
Overlap set similarity search for finding joinable tables in data lakes. In Proceed-
ings of the 2019 International Conference on Management of Data. 847–864.
[109] Erkang Zhu, Yeye He, and Surajit Chaudhuri. 2017. Auto-Join: Joining Tables
by Leveraging Transformations. Proc. VLDB Endow. 10, 10 (2017), 1034–1045.
https://doi.org/10.14778/3115404.3115409
16

---

