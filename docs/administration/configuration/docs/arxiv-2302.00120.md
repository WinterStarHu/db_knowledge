# Holistic Cube Analysis: A Query Framework for Data Insights

> 来源: https://arxiv.org/pdf/2302.00120

Holistic Cube Analysis: A Query Framework for
Data Insights
Xi Wu, Shaleen Deep∗, Joe Benassi, Fengan Li‡, Yaqi Zhang‡, Uyeong Jang, James Foster, Stella Kim,
Yujing Sun, Long Nguyen, Stratis Viglas, Somesh Jha†, John Cieslewicz, Jeffrey F. Naughton‡
Google, ∗Microsoft GSL, †UW-Madison, ‡Celonis
Abstract
Many data insight questions can be viewed as searching in a large space of tables and finding important ones,
where the notion of importance is defined in some adhoc user defined manner. This paper presents Holistic Cube
Analysis (HoCA), a framework that augments the capabilities of relational queries for such problems. HoCA first
augments the relational data model and introduces a new data type AbstractCube, defined as a function which maps a
region-features pair to a relational table (a region is a tuple which specifies values of a set of dimensions). AbstractCube
provides a logical form of data, and HoCA operators are cube-to-cube transformations. We describe two basic but
fundamental HoCA operators, cube crawling and cube join (with many possible extensions). Cube crawling explores a
region space, and outputs a cube that maps regions to signal vectors. Cube join, in turn, is critical for composition,
allowing one to join information from different cubes for deeper analysis. Cube crawling introduces two novel
programming features, (programmable) Region Analysis Models (RAMs) and Multi-Model Crawling. Crucially, RAM
has a notion of population features, which allows one to go beyond only analyzing local features at a region, and
program region-population analysis that compares region and population features, capturing a large class of importance
notions. HoCA has a rich algorithmic space, such as optimizing crawling and join performance, and physical design of
cubes. We have implemented and deployed HoCA at Google. Our early HoCA offering has attracted more than 30
teams building applications with it, across a diverse spectrum of fields including system monitoring, experimentation
analysis, and business intelligence. For many applications, HoCA empowers novel and powerful analyses, such as
instances of recurrent crawling, which are challenging to achieve otherwise.
1
Introduction
Many data insight questions can be viewed as searching in a large space of tables (sometimes called slices) and
finding important ones, where the notion of importance is defined in some adhoc user-defined manner. For example,
Figure 1a starts with a top-level CostPerClick change, and asks what are important contributors to this change at slice
level; Figure 1b, instead, asks what are important outliers in a large space of slices. For both analysis questions, one
needs to consider a space of regions (a region is a tuple which specifies values for a set of dimensions, for example,
[Device=Pixel6] is a region with 1 dimension, [Device=Pixel6, Browser=Chrome] is region with 2 dimensions), and for
each region one needs to consider a set of features ([IsToday, Cost, Clicks] for CostPerClick contributors, and [Date,
Revenue] for interesting-outliers). Regions and features induce a space of tables, and instead of only analyzing features
of each region locally, these tables usually need to be analyzed altogether, or holistically, to uncover insights.
We note that, with classic declarative queries (e.g., SQL, OLAP), which are largely designed to answer forward-style
questions (i.e., from region and features to a table, such as “Extract Revenue timeseries data at Browser=Chrome”),
one needs to construct complex and esoteric pipelines to answer the search questions (such as the ones shown above).
To this end, we note that an array of systems (e.g., Abuzaid et al. (2021, 2018); Wang et al. (2015); Wu & Madden
(2013)) have been built to simplify data explanation tasks. However, these systems do not cover questions such as
important-outliers in Figure 1b, even though the workflow is similar to CostPerClick-explanation (Figure 1a).
1
arXiv:2302.00120v4  [cs.DB]  1 Jul 2023

---

(a) Finding important contributors to overall CostPerClick
change, starting from a base table.
While seemingly sim-
ple, a principled answer requires applying the AumannShapley
method, see Section 3.1.1.
(b) Finding important timeseries outliers, starting from a base
table: Given a large space of slices, what are important time-
series outliers one must pay attention to?
Figure 1: Many data insights problems can be viewed as: Given a space of tables (often called slices) that are aggregated at different
granularity, find interesting, or most attention-worthy slices (where these notions often need to be defined in an ad-hoc manner).
Currently, to perform such analysis, analysts often need to build complex workflows to generate the tables, and then analyze them
using advanced statistical and ranking techniques. By contrast, Figure 3 shows that one can answer these questions using succinct
HoCA programs.
This paper presents Holistic Cube Analysis (HoCA), a framework for systematically augmenting the capabilities of
relational queries for data insights. Unlike the data-explanation systems mentioned above, which basically augment SQL
and still work on set-of-tuples, HoCA first augments the relational data model by defining a new data type AbstractCube,
which is defined as a function from RegionFeatures space to relational tables (RegionFeatures space is a set of points,
where each point specifies a pair of region and features; Figure 2a gives a visualization). AbstractCube provides a
logical form of data, and HoCA operators are cube-to-cube transformations, i.e., higher order, function-to-function
transformations (Figure 2b provides a visualization). Since input and output are of the same type, therefore, similar to
relational algebra, one can compose HoCA operators to form complex HoCA programs.
We describe two basic, but fundamental, HoCA operators: Cube crawling and cube join (there are many more
possibilities devising more useful HoCA operators and extending the algebraic framework, which we discuss in
Section 6). Cube crawling introduces an enumeration-type operator, which allows one to scan regions in a subspace,
extract useful signals, and output results into an output cube. Cube join, in turn, combines two input cubes into one, by
joining tables from two region-features spaces (see Figure 4 for a visualization of the concept). Cube join is critical for
composition, since it allows one to join information from different cubes for deeper analysis, and it is utilized in some
of our most complex HoCA programs (e.g., Recurrent Cube Crawling in Section 3.3.2).
To solve a rich family of insight analytic problems, we design cube crawling with two novel programming features:
(1) Region Analysis Models (RAMs), which allows one to program region analysis to be used in the crawl operator.
Crucially, RAM has a notion of population features, which allows one to go beyond only analyzing local features at
a region, and program region-population analysis that compares region and population features, achieving a form of
holistic analysis. RAM abstraction allows easy integration and novel applications of advanced analytic techniques,
such as timeseries outlier detection (PyB), causal inference (Brodersen et al. (2015)), and differentiable programming
(Bradbury et al. (2018)), which goes much beyond previous work (e.g. Abuzaid et al. (2021)). (2) Multi-model crawling,
which allows one to apply multiple models, potentially on different feature sets, during crawling. Multi-model crawling
significantly broadens the scope of analytic questions one can answer with one crawl.
Together, these abstractions greatly simplified the analysis workflows aforementioned, and also go further in capturing
even more complex data insights problems. Figure 3 shows two HoCA programs that answered formal versions of the
two analytic questions in Figure 1. Each program only consists of three statements: Initializes a cube, initializes an
appropriate model, and then performs a cube crawling. Since HoCA abstractions are compatible with standard relational
constructions (e.g., SQL), HoCA programmers can also construct more complex HoCA programs by composing HoCA
operators, together with standard relational constructions.
2

---

(a) AbstractCube: A function mapping region-features to
relational tables. It provides a logical form of the data. In
particular, HoCA programmers do not need to care about
how the function mapping is computed. There are different
sub-types of AbstractCube, giving different ways to encode
functions (see Section 2.1). For the same logic cube, one
can also have different physical representations.
(b) A HoCA operator: A cube-to-cube transformation (i.e., a
higher-order, function-to-function transformation). A basic ex-
ample of HoCA operator is cube crawling: We traverse a region
space, for each region do some analysis, and output a cube record-
ing analysis results for regions. The “function-as-data” modeling
of HoCA cubes is critical for composition: Since the output is also
a HoCA cube, we can apply further HoCA operators to the output
cube (even though it may not be a projection-groupby-aggregation
one). This gives rise to constructions such as Recurrent Cube
Crawling (see Section 3.3.2).
Figure 2: The HoCA paradigm.
We have implemented and deployed HoCA at Google. HoCA has a rich algorithmic space, such as optimizing crawling
performance (leveraging region space structure), optimizing cube join performance (local vs. global join), and physical
design of cubes (i.e., encoding of functions). We briefly describe several implementations of cube crawling based on
different foundations (an in-house distributed relational query engine (Samwel et al. (2018)), and also Apache Beam
(Pyt)), and evaluate their main performance characteristics.
HoCA has found many useful applications in system monitoring, experimentation analysis, and business intelligence.
For most of our applications, our users are system builders, who use our new query framework to build data-insights
systems. Our early HoCA offering has attracted more than 30 teams directly dependent on our codebase. In several
applications, an interesting finding is that users had already built adhoc solutions that can be captured by HoCA.
Migration to HoCA not only significantly simplified these constructions, but also improved performance and scalability,
and enabled novel analyses (such as instances of recurrent crawling, which would be challenging to achieve without
HoCA concepts). For Business Intelligence (BI) applications, HoCA enabled fast development of novel data insights
functionalities. For example, somewhat surprisingly, we found that no previous work has even formulated the problem
of attributing a non-summable metric change within a complex region space (even for SUM/SUM ratio!). Within HoCA,
we give a natural formulation and develop a principled solution (Section 3.1.1).
HoCA vs. OLAP. Both HoCA and OLAP use the term “cubes”, which indeed share some similarities. For example,
OLAP cubes can provide encoding of HoCA cubes, by providing mapping from region-features to relational tables. A
crucial difference, however, is that HoCA and OLAP examine entirely different analytic questions. OLAP operators
(e.g. drill-down, roll-up, etc.) provide analytic capabilities in the “forward” direction (e.g., region-features →table),
where users can leverage OLAP operators to perform an iterative, but manual, slice-and-dice analysis to find data
insights. HoCA, on the other hand, provides operators to facilitate search in the region space. For example in
the CostPerClick attribution case described in Figure 1a, HoCA starts with the top-level CostPerClick change, and
the analysis deconstructs the metric and searches for the regions that are major contributors to this change. In this
sense, HoCA operators are “backwards”. This difference in analytic questions induces vastly different considerations
of the cube design: In HoCA, cubes are logical form of data, and HoCA operators are higher-order, cube-to-cube
transformations, where they can be composed into a program, with cubes flow in between explicitly as data objects.
There is no counterpart of this in OLAP. To this end, HoCA provides novel programming experiences and constructions,
such as Region Analysis Model programming, cube join, and recurrent cube crawling. A more detailed comparison is
in Section C in Wu et al. (2023).
3

---

(a) A HoCA program for finding important contributors
to CostPerClick change. ‘aumann_shapley_attribution’ is
based on both region and population features. See Sec-
tion 3.1.1 for details.
(b) A HoCA program for finding important timeseries out-
liers. ‘importance_score’ is based on both region and popu-
lation features.
Figure 3: HoCA programs that use cube crawling to answer the analytic questions raised in Figure 1. In both cases, we analyze
features from both the region and the entire population, which is holistic compared to analyzing region features alone.
Paper organization. Section 2 presents the HoCA framework of HoCA cubes and operators. Section 3 gives various
examples of programming using HoCA to find data insights. Section 4 discusses important algorithmic considerations.
Section 5 presents our current implementation of HoCA and its evaluations on several data sets. Section 6 discusses
HoCA applications and future directions, and we conclude in Section 7.
2
Holistic Cube Analysis framework
This section presents the HoCA framework. We begin with some basic definitions:
• Dimensions and measures. As in OLAP, we distinguish two kinds of columns: Dimensions and measures.
Dimensions are qualitative values that can be used to categorize and segment data. Measures are numeric, quantitative
values that one can measure. For simplicity, in this paper, dimensions are synonymous with attributes, and measures are
synonymous with metrics.
• Region. A region is a tuple which specifies values of a set of dimensions (e.g., (Device=‘Pixel 5a’) is a region,
(Device=‘Pixel 5a’, Browser=‘Chrome’) is another region). For a region γ and a dimension d, we use γ[d] to denote
the value d takes in γ. We use dim(γ) to denote the set of dimensions in γ. The number of dimensions in the region
is called the degree of the region (e.g., (Device=‘Pixel 5a’) is degree-1, (Device=‘Pixel 5a’, Browser=‘Chrome’) is
degree-2).
• Filtering a relation by a region. If B is a relation, we use B[γ] to denote the set of tuples in γ induced by a filtering:
For any d, B[γ] takes value γ[d] for dimension d. In SQL, this simply corresponds to a WHERE clause on B. For
example, B[Device=‘Pixel 5a’] considers tuples where Device is ‘Pixel 5a’.
• Features. A feature is a dimension or a measure. For example, ‘Device’ is a (dimension) feature, and ‘Revenue’ is a
(measure) feature. For example we can have dims = [‘Device’, ‘Browser’], and measures = [‘Revenue’].
With these, we discuss two main aspects of the HoCA framework:
Abstract cube. In Section 2.1, we define AbstractCube, a data type defined as a function mapping RegionFeatures
space to relational tables. This function-as-data modeling allows us to simultaneously capture a space of non-uniform
tables in the co-domain of the function, as well as the rich structure in the region space (e.g., hierarchies) on the domain
of the function. As a result, operators on abstract cubes typically transform one cube to another. That is, they are
4

---

higher-order, function-to-function transformations.
HoCA operators. In Section 2.2, we describe two current HoCA operators: (i) Cube crawling, which explores a
subspace of regions in a cube, extracting signals from each feature table visited, and finally output a cube that maps
regions to signal vectors. (ii) Cube join, which melds different cubes into one, and is critical for composition.
2.1
AbstractCube: A function-as-data modeling
Abstract cubes are foundational data objects in HoCA. Our definition was inspired by the traditional OLAP cubes, but
have diverged significantly. Specifically, an abstract cube is a function from RegionFeatures space to relational tables.
We give details below.
Definition 1 (RegionFeatures space). The RegionFeatures space is a set of points, where each point in the RegionFea-
tures space defines a pair of region and features.
For example, suppose that we have three dimensions, Device, Browser, Date, and one metric, Revenue. The following
are some examples of RegionFeatures points:
(region: [Browser=’Chrome’], features: [Date, Revenue])
(region: [Device=’Pixel 7’], features: [Date, Revenue])
(region: [Device=’Pixel 7’, Browser=’Chrome’], features: [Revenue])
Basically, region gives the dimension values to zoom into, while features gives the dimensions and metrics to analyze.
Definition 2 (AbstractCube). An abstract cube is a function that maps the RegionFeatures space to relational tables.
Specifically, given a (region, features) point, the cube maps this pair to a relational table whose schema conforms to
features (i.e., columns of the table are dimensions and measures in features)
What this definition is saying is that in HoCA, the logical form of data is a function of type “region-features 7→
relational table”. There can be, however, many different encoding of such functions, depending on different needs.
In the following we give three examples: BaseTableGroupByCube (a natural encoding using a base relation and
SQL groupby-aggregation), CellsetCube (an encoding leveraging cellset and AbstractAggregate, Algorithm 2), and
RandomizedCube (an example of non-base table aggregatable cubes)
BaseTableGroupByCube. The simplest example of cubes is that we have a base table, and given a point of region-
features, we compute a groupby-aggregation from the base view to the region and features. For example, consider the
point (region: [Device=’Pixel 5a’], features=[Date, Revenue]). Then we filter by Pixel 5a, then GroupBy Date, and
aggregate Revenue (so Browser is aggregated away). As a result, we get relational table daily Revenue timeseries for
Pixel 5a. Algorithm 1 gives more details.
Algorithm 1 GetView: Function that maps a region-features to a table for BaseTableGroupByCube.
Class members: B: A base relation; A: A dictionary of ‘measure →aggregation function’
Input: γ: A region; F = (D, M): Dimension and measure features
Output: A view (relational table) V
1: Filter the base relation B using γ, and get X = B[γ].
2: Using X, compute view V by GroupBy dimensions in D, and compute measure m ∈M using aggregation A[m].
3: return V
CellsetCube. CellsetCube is a more general encoding: First, it uses a generic value * to augment dimension values so
that we can encode more tuples, which gives rise to cellset (Definition 3). Then, given a region (which does not allow *
value) and features, the mapping to a relational table is done by a lookup in a cellset, and associate appropriate cells into
a table (again, does not contain * value). We call this mapping AbstractAggregate (Algorithm 2).
5

---

Definition 3 (Cellset). Let d1, . . . , dn be dimensions with domains U1, . . . , Un, the universe is U = Sn
i=1 Ui. Any
value in U is called a specific value. Let ∗be a value not in U, which is called a generic value, A cellset S is a function
of the form S : Qn
i=1
 Ui ∪{∗}

→M, where a cell in a cellset a pair (κ, S(κ)). Since S is a function, sometimes we
also abuse the notation and call κ a cell.
Algorithm 2 defines the mapping from region-features to tables. The idea is that use region to filter cells, then dimensions
in the features can take any specific value, and all other dimensions take *.
Algorithm 2 AbstractAggregate: Function that maps a region-features to a table for CellsetCube.
Class members: S: A cellset
Input: γ: A region; F = (D, M): features of dimensions and measures.
Output: A view (relational table) V
1: Instantiate a cellset K = S
# Initially, all cells
2: K = K[γ]. That is, for any d that γ[d] = v, we only keep cells that take value v at dimension d
# Filtering using the region
3: Retain a cell in x ∈K using the following rules:
(D, M) features
i. ∀d ∈D, x.d̸ = ∗
# A dimension feature takes any specific value
ii. ∀d /∈D ∪dim(γ), x.d = ∗
# Any other dimension takes *
4: Remove any dimension in the K that has ∗value, the result is a usual relation with no generic value ∗. We call this relation V .
5: return V .
RandomizedCube: A non-base table aggregatable cube. We note that there are cubes that are not base-table
aggregatable. This is because one can construct a cellset with a special measure, where there is no relationship among
the cells w.r.t the measure. One example is RandomizedCube: We start with a set of cells, and we map each cell
to a randomized value (we call this value ‘randomized_metric’), which is sampled independently for every cell. In
other words, For every cell, say (Device=*, Browser=*, Date=*), the measure ‘randomized_metric’ is a value sampled
independently from a random value generator. Clearly, this gives a valid cellset, and so we can create a CellsetCube
from it. However, this cube is not base table aggregatable, because the randomized value of a cell is not determined by
cells that take specific values in dimensions.
This example may seem artificial, but it shows that there can be data cube objects that are information-theoretically
non-base-table aggregtable. In practice, HoCA such as cube crawling may generate results that is naturally a cube, but
the cost of generating the cube is so high that they should be treated similar to the random cube: We should simply record
these results in some cube data object for further analysis (An example of this is the intermediate cubes in the recurrent
cube crawling pipeline, see Section 3.3.2). Therefore, these cubes are not instances of BaseTableGroupByCube, but
they are instances of CellsetCube.
2.2
HoCA operators
With abstract cubes, we can then design operators to analyze them. We present two basic HoCA operators: Cube
crawling and cube join.
Cube crawling. Cube crawling refers to the following procedure in general: Given a space of regions (region space),
and a set of Region Analysis Models (RAMs, or simply models), we want to traverse every region in a region space, and
for each region we extract features needed by the models, and evaluate models over these features to get a signal vector.
Finally, we output a cube mapping regions to signal vectors. Algorithm 3 gives the conceptual algorithm. We note that:
Region space. Region space specification specifies the space of regions for crawling. The simplest example of region
space is the cube space, specified as ‘cube_space(dimension_list)’ such as
‘cube_space([Device, Browser])’, which considers all possible combinations of the two dimensions, and generate
regions such as (Device=‘Pixel 5a’), (Device=‘Pixel 5a’, Browser=‘Chrome’),
(Browser=‘Chrome’). Note that there are various possibilities to shrink the region space by leveraging the data topology.
For example we can consider data topology such as product of hierarchies (Ruhl et al. (2018); Fagin et al. (2005a)), and
functional dependencies (Abuzaid et al. (2021)), which can be easily encoded as region space specification.
6

---

Algorithm 3 NaiveCubeCrawl: A naïve algorithm for cube crawling, for illustrating the concept. Note that models are pro-
grammable, and are fed as input to crawling. This algorithm is impractical since the region space may be exponentially large.
Input: C: AbstractCube; region_space: A specification of region space; models: List[Model]
Output: R : AbstractCube A cube mapping regions to signals. For simplicity, here the output cube is encoded as a set of
region-signals pairs.
1: # Set population features for each model
2: for f in models do
3:
f.population_df = C(f.attribute_features, f.metric_features)
4: end for
5: R = ∅.
6: # Evaluate models on every region and collect results.
7: for region in region_space do
8:
subcube = C[region]
9:
r = ∅
10:
for f in models do
11:
data_frame = subcube(f.attribute_features, f.metric_features)
12:
r.append(f(data_frame))
13:
end for
14:
if r passes all filtering then
15:
R.append((region, r))
16:
end if
17: end for
18: return R.
Model features. Each model f has a set of dimension and measure features, encoded as attribute_features and
measure_features.
Population feature data for a model. Lines 2–4 sets the population data for each model, by extracting features from C.
Region feature data for a model. At lines 10–12, we zoom into a region, which gives a subcube, and we extract model
features from the subcube, which gives region features. Therefore, each model f sees two pieces of data, region features
and population features.
Model programmability. Cube crawling supports programming new region analysis models and use them for crawling.
This feature allows us to apply different models and capture a wide variety of different use cases. In Section 3, we
describe in details how model programming is designed, and give detailed examples.
Crawling output. The output of crawling is a cube with a particular structure: It maps a region (no feature) to a signal
vector (signals are encoded as a table with one row, and each column encodes one signal name). One can naturally
extend this to mapping regions to relational tables in general.
Example 1 (Crawling for timeseries outliers). This is a first example of cube crawling. We first instantiate a model:
1
ts_model = TimeSeriesOutlierDetector(
2
datetime=’Date’, metric=’Revenue’,
3
timepoint=’2022-01-31’,
4
signals=[’importance_score’])
This model then instantiates where attribute_features is [Date], and metric_features is [Revenue]. Finally, given
a timeseries, we want to check whether the metric value at 2022-01-31 is an outlier, this checking is captured by
computing a signal called ‘importance_score’, which is offered by the model programmer. Then we can crawl with this
model on the cube C:
1
CubeCrawl(
2
C,
3
region_space=span(Device, Browser),
4
models=[ts_model])
7

---

Basically, this crawling considers regions spanned by Device and Browser (e.g., a single device where browsers are
aggregated, a single browser where devices are aggregated, or a combination of a specific device and a specific browser).
For every region, we extract a timeseries of Date and Revenue, then the model ts_model analyzes this timeseries, and
outputs a signal ‘importance_score’.
Figure 4: Cube join: The left (red) and right (blue) are two cubes (RegionFeatures→RelationalTable functions). The cube join
operator allows one to meld these two functions into one, by matching region, and then join on dimension features. The joined cube
(green) thus contains both p_value and Revenue metric features.
Cube join. Cube join operator joins two cubes into one. Cube join is critical for composition, since it allows one to
join information from different cubes for deeper analysis. For simplicity of presentation, we only consider the case
where two cubes to join have the same dimensions. There are two ways to define cube join: A local definition and
a global definition (if we choose to work with Cellset cubes as the abstract cubes). The local definition is based on
the observation that the core of a cube is to implement mapping given region and features. This gives the following
definition:
Definition 4 (Local definition of cube join). Let C l and C r be two cubes. We define C = C l JOIN C r, the joined
cube, where the GetView is implemented as follows. Let γ be a region, and F be features, then
1. We extract dfl = C l[γ](F)
2. We extract dfr = C r[γ](F)
3. We compute df = dfl JOIN dfr, where the join keys are the dimension feature columns.
We can use different join semantics for the JOIN operator (LEFT_JOIN, RIGHT_JOIN, INNER_JOIN). Figure 4
visualizes this process.
On the other hand, if we are working with CellsetCube, we can define cube join at the cellset level, and then use the
abstract aggregation (Algorithm 2) to induce an cube instance. This gives the following:
Definition 5 (Global join for cellsets). Let C l and C r be two cubes. Suppose that both cubes have been converted into
instances of CellsetDataCube. Then we define C = C l JOIN C r the joined cube, as follows: (1) We join the underlying
cellsets of C l and C r, using the specified join operator (LEFT_JOIN, RIGHT_JOIN, INNER_JOIN), where the join
keys are all the dimensions. Let the resulting cellset be Sjoined. (2) Return C = CellsetDataCube(Sjoined).
Example 2 (Augmenting a cube with historical p_value). We give more explanation to Figure 4: Suppose that we
run outlier detection crawling daily, and the outlier detector computes a p_value for each region. These computed
8

---

p-values (for each day) is stored in a cube C ′ (i.e., red cube on the left in Figure 4), which has dimensions Device,
Browser, Date, and measure p_value. Now, on a new date t∗, and we have a cube (blue cube on the right in Figure 4)
C with dimensions Device, Browser, Date, and measure Revenue, then we can “inner join”, C INNER_JOIN C ′,
using join key Device, Browser, and Date. This gives a larger cube now with two measures Revenue and p_value. In
Section 3.3.2, we discuss recurrent cube crawling, where a revised timeseries outlier detector can leverage the historical
‘p_value’ in the joined data cube.
This construction of augmenting a cube with previous analysis results is useful in continual monitoring, and in particular
in Recurrent Cube Crawling, described in detail in Section 3.3.2.
3
Programming insights with HoCA
This section gives various examples of programming with HoCA to uncover data insights. The power of the current
HoCA framework comes from several aspects: (1) As we mentioned before, one can program region analysis models
(RAMs) to collect relevant analysis on a set of data features into a module and reuse. Crucially, RAM has a notion
of population features, which allows one to go beyond only analyzing local features at a region, and program region-
population analysis that compares region and population features, achieving a form of holistic analysis. RAM abstraction
allows easy integration and novel applications of advanced analytic techniques, such as timeseries outlier detection
(PyB), causal inference (Brodersen et al. (2015)), differentiable programming (Bradbury et al. (2018)), which goes
much beyond previous works (e.g. Abuzaid et al. (2021)). (2) An important feature of our crawler API design is
that it allows crawling with multiple models, potentially requesting different feature sets, during one crawling. This
significantly broadens the scope of analytic questions we can answer with one crawl. (3) Since input and output are
both cubes, HoCA operators can be composed to construct complex HoCA programs for advanced use cases.
3.1
Programming RAMs
RAM abstraction allows easy integration and novel applications of advanced analytic techniques, such as timeseries
outlier detection (PyB), causal inference (Brodersen et al. (2015)), differentiable programming (Bradbury et al. (2018)).
We give a few examples.
3.1.1
Metric attribution via Aumann-Shapley
Let C be a cube and M be a metric. For a region γ, we use M γ or M[γ] to denote the value of metric at the region.
Specifically, for empty region γ = [], we use M p to denote the population metric value. Suppose now that we divide the
data into two segments (test segment, and control segment), where on the test segment we have metric value M p
t , and
on the control segment we have metric value M p
c , so there is a population metric value change ∆p = M p
t −M p
c . In the
metric (change) attribution problem, we want to attribute ∆p to regions in the cube: That is we want to assign a score,
denoted as RAS(γ), and naturally we want this scoring to have the following natural properties: (1) Completeness:
That is for the empty region the attribution score is exactly ∆p, RAS([]) = ∆p. (2) Additivity: For any two disjoint
regions β, γ, RAS(β ∪γ) = RAS(β)+RAS(γ). So for example, we have many different devices and their attributions
should add up to the population level change. (3) RAS(γ) should reflect the importance of contribution to ∆p. Note
that (3) is informal, and it is reflected in our algorithms. We found that a novel application of the Aumann-Shapley
method (Sun & Sundararajan (2011); Aumann & Shapley (2015)) gives principled answers to such questions. Our
approach uses the following definition
Definition 6 (Region-Ambient Metric Model). A region-ambient metric model combines metric values (maybe more
than that of M) of a region γ, and metric values of the ambient of the region γc (i.e., data not in γ), to recover the
population metric.
9

---

If M is summable (e.g., Revenue), a region-ambient metric model is simple: F(w, w′) = w + w′ (w models the metric
value in a region, and w′ is the metric value in the ambient of the region). If M is non-summable, we may need more
metrics than just M: For example, for a density metric M = W/S where both W and S are summable, we need values
of both W and S in order to recover the population metric value, and a natural region-ambient metric model has four
parameters: F(w, w′, s, s′) = (w + w′)/(s + s′).
With a region-ambient metric model, one can then apply the Aumann-Shapley method to the model, with test/control
metric values as two end points. This can be easily illustrated on a summable metric (F(w, w′) = w + w′): In the
control segment we have point P0 = (M γ
c , M p
c −M γ
c ), and in the test segment we have point P1 = (M γ
t , M p
t −M γ
t ).
We consider a straight line h(t) = (1 −t)P0 + tP1, t ∈[0, 1]. Then for G(t) = F(h(t)), we have:
∆p = G(1) −G(0) =
Z 1
0
G′(t)dt
=
Z 1
0
∂F
∂w
∂w
∂t + ∂F
∂w′
∂w′
∂t

dt
=
Z 1
0
∂F
∂w
∂w
∂t dt

+
Z 1
0
∂F
∂w′
∂w′
∂t dt

(1)
where the last equality switch sum-integration order. We then define RAS(γ) as
R 1
0
∂F
∂w
∂w
∂t dt, which is easily evaluated
to RAS(γ) = M γ
t −M γ
c , which is just our intuitive notion of metric shift in the region!
For non-summable metrics, this method works the same way, but produces formulas that are far less intuitive. For
example, for the density metric, if we use the metric model F(w, w′, s, s′) = (w + w′)/(s + s′), the attribution formula
for a region, which is the result of doing path integration, becomes:
RAS(r)
=(wr
t −wr
c)(sp
t −sp
c) −(wp
t −wp
c)(sr
t −sr
c)
(sp
t −sp
c)2

ln(sp
t ) −ln(sp
c)

+ sr
t −sr
c
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

(2)
which is much less intuitive, unless one approaches from first principles. Due to space, the derivation and the proofs that
they satisfy completeness and additivity are deferred to Section A. For more general metric models, where closed forms
of integration are more difficult to derive, one can use differentiable programming framework, such as JAX (Bradbury
et al. (2018))), to compute the integration numerically.
3.1.2
Outlier detection and self supervision
Adapting advanced timeseries outlier detector for region analysis. because model programmers can directly work
with features without caring how they are generated, we can adapt various timeseries outlier analysis (e.g. Brodersen
et al. (2015) and its variants) almost verbatim as region analysis models. The availability of population features
also enables us to improve these analyses: These timeseries analyses primarily focus on the shape of one timeseries.
However, the cube population data allows us to measure the normalized size of a timeseries within the population. This
allows us to compute signals that incorporate both the normalized size and outlier score. Due to the normalization, these
hybrid signals are easier to filter than unnormalized versions, and they also provide better signals for larger slices that
are experiencing anomalies, due to the hybrid signal design.
Calibrating p-value using historical p-values. In Example 2 we described joining a cube with historical ‘impor-
tance_score’. With the joined cube, we can then leverage the these historical importance scores for outlier detection,
which provide important information for improving precision/recall of the detection for the current time point. Specifi-
cally, we revised the CausalImpactModel (Brodersen et al. (2015)) for outlier detection to make use of historical p-value:
Causal impact detection makes a statistical assumption that that p-value follows Unif(0, 1) distribution under null
hypothesis. However, this assumption does not really hold on practical data. Instead of working under this assumption,
10

---

we then use the historical p-values (enabled by cube join) to calibrate and get the final p-value. Note that this can be
viewed as a form of self-supervision, because we are using the p-values learned to supervise model behavior.
3.1.3
Emulating previous constructions
HoCA can also be used to emulate various classic constructions. As a simple example, Section B in Wu et al. (2023)
describes a region analysis model, FrequentItemsetModel, to use in cube crawling to solve FIM.
Emulating DIFF (Abuzaid et al. (2021)). We note that data explanation engines described in Abuzaid et al. (2021)
can be implemented as a single cube crawling with proper region analysis models. Specifically, the authors in Abuzaid
et al. (2021) defined DIFF operator, which receives two data frames, and differentiate these two data, based on some
simple statistics, to find interesting regions. One can encode this as a cube crawling by using a column ‘is_test’,
where True/False identifies the two tables to differentiate. Moreover, computing the differentiation statistics can be
wrapped into a region analysis model, which loads ‘is_test’ column as a feature. This way, we can emulate all use cases
supported in DIFF. We note that the DIFF paper described support for UDFs for computing differentiation statistics. A
key difference here is that the DIFF approach does not have the RAM abstraction, and so there is no separation between
features and analysis of features. This causes difficulties in integrating with advanced statistical analyses, and applying
multiple analyses during one crawl, since different analyses may need features aggregated at different granularity.
3.2
Multi-model crawling
Another important feature of our crawler interface design is that allows one to combine multiple models, potentially
requesting different feature sets, during one crawl. Multi-model crawling significantly expands the scope of analytic
questions that can be answered using one crawl. For example, in our application of finding important timeseries
outliers, it is usually useful to combine two models, EntityWeightModel and TimeSeriesOutleirModel, where the
EntityWeightModel checks the weight of the timeseries (for example this could be the total revenue in the time period),
and only if the region timeseries passes some thresholds on the weight we invoke the timeseries outlier detection.
In this case, since EntityWeightModel is much cheaper than outlier detector, it can save a lot of computation by
skipping “tiny” slices. Note that in this example, EntityWeightModel only requests feature [‘TotalRevenue’], while the
TimeSeriesOutlierModel requests features [‘Date’, ‘TotalRevenue’]. Without multi-model crawling, one would need to
first do a crawl using EntityWeightModel to analyze TotalRevenue, then using the results to filter timeseries and then
analyze timeseries for outlier, which results in much more complex analysis programs.
We note that this design is also flexible in two ways: (1) By having EntityWeightModel requests [‘Date’, ‘TotalRevenue’]
as features, we can immediately have more fine-grained filtering (e.g., on maximum daily total revenue), and (2)
EntityWeightModel can also be combined with other models for different analysis.
3.3
Compositions
Our discussion so far only covers, basically, what a single cube crawling can do. This section gives two examples of
complex analysis pipelines formed by composition of operators: (1) An analysis pipeline that is a sequential composition
of two cube crawling operators. (2) A recurrent analysis pipeline which leverages all the constructions we discussed so
far: At each timepoint a cube crawling is invoked, it leverages previous crawling results as features. More examples can
be found in Section D in Wu et al. (2023).
11

---

3.3.1
Composition of two crawlings
In Example 1, we used a cube crawl to find regions that have important outliers. Now, given the result cube, we may
ask a further question: “What regions are frequently involved in regions that have important outliers in this cube?” For
example, we may find that ‘(Device=Chrome)’, which is itself a region, appears in many regions that have important
outliers (e.g., (Browser=Chrome), or (Device=Pixel 6a, Browser=Chrome), or (Device=Desktop, Browser=Chrome)).
Such an analysis may unveil that Chrome may need more attention, because its combination with many devices have
resulted in anomalous behavior. We note that this question can be answered with a second crawl, working on the result
cube from the first crawl: (1) Recall the output of the first crawl is a cube which only keeps regions that have interesting
outliers. We augment the output cube with a measure column which measure the “weight” of a region in terms of outlier
(the simplest measure is to put a constant 1 for every region). The augmented cube is the input of next crawl. (2) We
can then apply techniques such as Frequent Itemset Mining (which can be implemented using one crawl to uncover
patterns that frequently (w.r.t. the weight measure) show up in regions that have important outliers.
3.3.2
Recurrent cube crawling
In the above, we discussed using cube join to inject previous crawling results as features for later detection. Figure 5
demonstrates a recurrent cube crawling pipeline applying this analysis in continual monitoring: Suppose that at time
t∗we want to do a crawling to find interesting outliers. Results of previous crawlings are recorded into a cube Rt
(red) (in particular, Rt appends results at t), so Rt∗−1 contains all historical crawling results for t ≤t∗−1. Now
at t∗, we have a data cube C t∗of newly collected data (e.g., Revenue) for detection, we join these two cubes to get
Dt∗= Join(Rt∗−1,C t∗) (green), which is then fed to a cube crawling for analysis. In our applications, we found
such constructions to be useful for outlier detection quality. We give two simple examples: (1) Self-supervision in
the continual monitoring. We described above 3.1.2 of a region analysis models that leverages historical p-value for
self supervision. Recurrent crawling is a natural fit for applying such models, where the cube join prepares historical
p-values in the cube to crawl. (2) Removing transient anomalies. Advanced outlier detectors all learn the shape
of timeseries (e.g., Bayesian Structural Time Series) from existing data points. However, sometimes timeseries may
contain transient anomalies that only appears short period of time and disappeared (e.g., several minutes). Leaving
these anomalies in the timeseries will bias the learning towards that these values are “normal” (i.e., there is a new trend),
and can cause noise. With recurrent cube crawling, we can simply detect transient anomalies and record them in the red
cube, and upon a new detection, we use these labels to locate transient anomalies and replace them with normal values.
This allows us to systematically correct transient anomalies.
Figure 5: Recurrent cube crawling: Previous crawling results are joined with new data (e.g., revenue cube of today) for analysis.
For outlier detection, it is very useful to use the p-values of previous detection results to calibrate the current detection.
4
Algorithmic space for HoCA
The last two sections covered the HoCA framework, and programming data insights with HoCA abstractions. This
section turns to the algorithmic space of HoCA: Section 4.1 considers algorithms for cube crawling, Section 4.2 on
algorithms for cube join, and Section 4.3 on physical design of cubes.
12

---

4.1
Considerations for cube crawling
We consider several algorithmic aspects for crawling: (1) Early stopping during region exploration. We note that
the naïve cube crawling algorithm, Algorithm 3, is impractical as the region space may grow exponentially in the
number of dimensions to crawl. For this we observe the natural lattice structure on the region space, and formulate
a generalized apriori property of model signals (Definition 7). This gives a natural top-down region exploration that
allows early stopping (Algorithm 4). (2) Model pushdown. Another important algorithmic opportunity is that we can
push some model computation into the cube processing, and filter regions without sending the extracted cube features
to the model. This can give significant performance benefits in a distributed implementation, where cube processing
and model evaluation are on different servers. (3) Top-N filtering. A common filtering strategy is to compute the top
N regions w.r.t. some signals. A naïve strategy is to check all regions to find the top N. To this end, we discuss how
can we leverage ideas in Fagin et al. (2002) to enable optimizations (1) and (2) during Top-N computation, so that one
doesn’t have to check all regions.
Algorithm 4 TopDownCubeCrawl: A more practical top-down algorithm paradigm for cube crawling. This paradigm allows early
stopping, by having the crawler interact with signals extracted by models from a region.
Input: C: AbstractCube; region_space: A specification of region space; models: List[Model]
Output: R: AbstractCube. A cube mapping regions to signals. For simplicity, here the output cube is encoded as a set of
region-signals pairs.
1: R = ∅
2: Initialize pending_regions as only contain the empty region
3: while pending_regions is not empty do
4:
region = pending_regions.pop()
5:
subcube = C[region]
6:
# Evaluate models on a region.
7:
r = ∅
8:
for f in models do
9:
# Extract features from the region subcube
10:
data_frame = subcube(f.attribute_features, f.metric_features)
11:
# Apply the model and append results
12:
r.append(f(data_frame))
13:
end for
14:
# Early stopping!
15:
if r fails apriori pruning then
16:
continue
17:
end if
18:
# Append more regions to crawl if we don’t stop early
19:
pending_regions.append(region.children)
20:
# Collect r into R
21:
if signals r passes all thresholds then
22:
R.append((region, r))
23:
end if
24: end while
25: return R.
Top-down crawling with early stopping. To begin with, we note that a region space may grow exponentially as the
number of dimensions increases. For example, if we have n dimensions to crawl, there are 2n subsets of dimensions
(each subset is called grouping set), and each grouping set can give a large number of regions. Therefore, it is important
to devise strategies to prune the search space w.r.t. the specified thresholds. For this, we note a natural partial order
among regions: For two regions γ1 and γ2, γ1 ≺γ2, if every dimension value in γ2 is also in γ1. In other words, γ1 is
more “fine-grained”, while γ2 is more “coarse-grained”. (e.g., (State=CA, City=MTV) ≺(State=CA)) Definition 7
defines Apriori property of model signals:
Definition 7 (Apriori property of model signals). Let σ be a signal computed by a model (e.g., support in the
FrequentItemsetModel). The signal is said to satisfy the apriori property if for any two regions γ1 ≺γ2, σ[γ1] ≺σ[γ2],
where σ[γ] means the value of signal σ on region γ.
13

---

There are many examples of apriori model signals. For example, if a signal is nonnegative and admits SUM aggregation,
then it satisfies the Apriori property. Another example is COUNT_DISTINCT, which also satisfies the Apriori property,
because more fine-grained regions can only have less distinct counts. With this definition, if we crawl with models that
computes signals that satisfy the above Apriori property, then we can early stop if a coarse-grained region already fails
some thresholding. This thus gives rise to top-down crawling as sketched in Algorithm 4. We note the following:
Region tree. At line 19, one needs to define ‘region.children’, which gives a tree of regions for exploration. We note
that finding a good tree will be important for performance. For example, one may start by considering dimensions
that have low cardinality, and then higher-cardinality dimensions, so we go from coarser regions to more fine-grained
regions. Another factor that may have a significant impact on region tree is data topology: For example, if there is a
hierarchy of dimensions (such as Country > State > City), then one only needs to crawl degree-1 regions (degree of a
region is defined in preliminaries) in Country, degree-2 regions in [Country, State], and degree-3 regions in [Country,
State, City].
Exploration strategy. At line 3, different data structures can be used for the ‘pending_regions’ variable, and thus give
different exploration order of regions. For example, instantiating it as a stack gives depth first exploration, and as a
queue gives breadth first exploration. Note the “embarrassing parallelism” for regions in ‘pending_regions’, and one
can explore regions in it in parallel.
Model pushdown to cube processing. In a distributed implementation, one may implement the cube function using
using a distributed query engine. In that case, the evaluation of models over the extracted views and the cube processing
may happen on different servers. To reduce data transfer, we can push some model computation to the cube-data
processing if they are easily expressible in SQL, so the signal computation is completed already during cube function
computation. This pushdown becomes particularly useful if there is a threshold filtering on the signal, so we may
directly filter a region without transferring data to model evaluation servers.
Top-N cube crawling. While thresholding on the model signals is a most intuitive method, sometimes it can get
difficult in determining what the thresholds should be. In such cases, a next intuitive filtering method is to compute
the Top-N results with respect to some model signals. An interesting algorithmic consideration here is how to avoid
examining every region in this computation. In view of Algorithm 4, this requires us to leverage apriori pruning on
model signals, which in turn needs a threshold on the signals, which do not exist for the Top-N computation. To this
end, suppose we are working with a single model signal ν which satisfies the apriori property. We adapt the basic
idea of “dynamic thresholding” from Fagin et al. (2002): If our goal is to find top n regions, then if we have seen any
set F of regions of size larger than n, then the (n + 1)-th region in F can be used as threshold on ν. While this is
simple to implement in the central case using a priority queue, it becomes challenging in a distributed implementation:
First, maintaining a centralized priority queue may incur much coordination. Second, there is a now a tradeoff between
examining a large batch of regions (in parallel) with a loose threshold, versus examining regions in smaller batches but
with better thresholds. To this end, we now adopt a simple design where we examine once some low-degree regions,
compute thresholds from them, and then use those signals for thresholding.
4.2
Cube join: Local vs. Global
As we discussed in the definition of cube join, there are two ways to perform cube join: One is to first load views locally
from two cubes, and join them as tables, and the other is to join the cellsets of two cubes, which could then induce any
view of the joined cube. These two approaches have different tradeoffs when one performs cube analysis on a joined
cube. For example, for a cube crawling on a joined cube, the local approach gives a lazy way to join data since we only
join data if there is a need to explore a certain view. However, this means that there will potentially be a huge amount of
small joins of tables, which may incur significant data processing overhead by having too many join queries. On the
other hand, the global approach prepares the entire cellset of the joined cube, which may incur significant overhead in
the beginning, but it gives only one join request, and any subsequent view can be efficiently computed from the joined
cellset. The above discussion indicates that there can be a third possibility of a hybrid approach, where we partially
perform local join, and partially perform global join.
14

---

4.3
Physical design of cubes
While logically cube is a function from RegionFeatures space to relational tables, its physical design (i.e., how do
we encode this function) need careful considerations in order to benefit HoCA operators’ performance. One basic
consideration is that in many cases, it will be too costly to crawl the tables if one has to aggregate slices on-the-fly from
some base table. Therefore, it is useful to provide encoding where the cube is (partially) materialized.
Materialization granularity. A naive strategy is to simply materialize the views needed in a crawling. For example,
suppose we are doing a daily continual monitoring, where we want to analyze a timeseries of seven-days data for
each day. Then naïvely, we materialize a space of tables, each of which is a seven-day timeseries. However, such
materialization strategy is rather wasteful: For example for any two consecutive days, the materialization has an overlap
of six days of aggregated data. A much better strategy in this case is to organize the materialized data by date: For each
day, we materialize the daily data of different regions into a chunk and store them.
Re-chunking. Suppose that we have an encoding of cube organized data by date, as discussed above. When we actually
do the cube crawling, we need to stitch together 7 days of data. For performance, we then would like to re-chunk the
cube so that for the same region, the 7-day data are stitched together into a slice. Note that the re-chunked cube and the
cube above are two different encoding of the same logical cube (i.e., RegionFeatures space to tables function).
5
Implementation and evaluation
We have implemented the current HoCA framework using a distributed SQL engine Samwel et al. (2018), as well as
Apache Beam Pyt. We give some important lessons of our implementation of cube crawling.
• For our pure SQL engine implementation, we leveraged TableValuedFunction (TVF) framework to execute user
programmed RAMs. At the high level, a coordinator receives a crawling request, and factors the crawling request into
SQL-TVF queries (the exact factoring is complicated, which depends on the exploration strategy): The SQL part is
to prepare region-features tables, and the TVF part is for evaluating RAMs on the materialized tables. We term this
implementation of crawler the SqlTvf crawler.
• One lesson we learned is that the current TVF framework implemented in our query engine does not scale well as the
cube grows: A key reason is that the current TVF scheduling is not designed with massive slice model evaluation (from
crawling) in mind. We are currently exploring a better TVF scheduling design that would overcome this limitation.
• To mitigate the above scalability issue, we turn to use Apache Beam for model evaluation. Basically, we only rely on
SQL to generate tables induced by region-features, and materialize these tables into some storage, and then we invoke a
carefully designed Beam pipeline to evaluate models on these slices. Since Beam provides more flexible programming
capabilities, we can capture more easily optimizations such as Apriori pruning described earlier. These optimizations,
together with powerful scheduling of our internal Beam runtime (Flume C++), scales really well on large cubes. We
term this implementation of crawler the SqlBeam crawler. Note that SqlBeam crawler has an additional materialization
cost, which hurts latency. Currently we use the SqlTvf crawler for streaming use cases, and use the SqlBeam crawler
for large-scale batch use cases.
Evaluation goal. We evaluate our SqlTvf crawler and SqlBeam crawler. At the high level we examine two questions:
(1) Latency: What are the characteristics of latency of the crawlers? (2) Scalability: What are the characteristics of
scalability of the crawlers?
Models and analyses. Table 1 summarizes the models we used in experiments. With these models, we evaluate two
analyses.
Shift analysis. For this analysis, for each dataset we chose a specific date to create a test-control split; the control
group contains all data points before the date Sep. 1, 2021 and the test group contains all the other data points. During
the analysis, we use the early stopping with the Apriori property (Definition 7) of the apriori support signal. We set a
15

---

ShiftModel
A simple model that analyzes change of a summable metric
(e.g., Revenue). A nontrivial part is that we normalize
using the population change, because RAM allows one to
access population features. This normalization is
very useful for filtering.
CausalImpactModel
A timeseries analysis model based on Brodersen et al. (2015). Our
implementation added more analysis leveraging the population
timeseries, which is useful in the holistic analysis scenario.
EntityWeightModel
A simple model for analyzing weights of multiple
entities. In our experiments, this model is used to filter
“small” timeseries.
Table 1: Summary of models used in experiments.
threshold of 0.075 as an early stopping criterion.
Time series anomaly detection. For this analysis, we combine two RAMs, EntityWeightModel and CausalImpactModel,
which gives an instance of multi-model crawling described in Section 3.2. Specifically, each region has a weight, the
sum of the values in the weight column over a specified time frame. The EntityWeightModel first filters regions so only
regions with large enough weight remain, then the CausalImpactModel performs timeseries analysis on these regions to
detect outliers. We apply this analysis daily in a continual fashion: For each day, we analyze today’s observation in a 30d
window, and determine whether the observation of today is an outlier, In the experiments, we run CausalImpactModel
for the data point on a specific date, Oct. 1, 2021, compared to the data points from the 30 days in September 2021. For
EntityWeightModel filtering, we use the metric columns of the datasets as the weight columns. Since the metric features
of two datasets show different scale, we set different threshold to filter the evaluation result. For the SqlTvf crawler
experiments, the threshold for the COVID-19 Open Data is 18,000, and the threshold for the CMS Open Payments is
5,500,000.
Datasets. We evaluate the distributed crawling performance on two real-world datasets. Table 2 summarizes those two
datasets.
COVID-19 Open Data. COVID-19 Open Data1 is Google’s public data collection that contains up-to-date COVID-19-
related information. COVID-19 Open Data consists of data from different sources, including demographics, economy,
epidemiology, government response, weather, etc. For our evaluation of distributed crawling performance, we use one
metric feature – the number of new confirmed cases – and 22 attribute columns, including age group, region, weather
and government responses.
Center for Medicare & Medicaid Services (CMS) Open Payments. CMS Open Payments2 is a public data set about
payments and transfers of value from reporting entity, such as pharmaceutical manufacturers, to covered recipients, such
as physicians. Starting from the program year 2013, CMS publishes Open Payments data annually. We merged nine
annual data, from the program year 2016 to the program year 2021, into one table. We use one metric feature – the total
amount of payment in US dollars – and 22 attribute columns, which encode information about recipients and payments.
Dataset
# rows
# attributes
# regions of degree ≤3
COVID-19
21.2M
22
16.8M
CMS
55.8M
22
607.6M
Table 2: Summary of datasets used for the evaluation of distributed crawling performance.
End-to-end performance evaluation. Latency. When measuring the SqlTvf crawler latency, we used 10 TVF workers
to handle each crawling request. We made 200 crawling requests for each dataset-analysis pair to compute the average
performance. Figure 6 presents the measured latency – Figure 6a shows the latency on COVID-19 Open Data, and
1https://health.google.com/covid-19/open-data/
2https://www.cms.gov/OpenPayments/Data
16

---

Figure 6b shows the latency on CMS Open Payments. To summarize the result, on the COVID-19 Open Data, the
average latency is 192.25 seconds for shift analysis and 353.96 seconds for anomaly detection. On the CMS Open
Payments, the average latencies are 218.75 seconds for shift analysis and 630.24 seconds for anomaly detection. This
shows that the SqlTvf crawler generally achieves low average latency for the example use cases.
(a) COVID-19 Open Data
(b) CMS Open Payments
Figure 6: Latency of the SqlTvf crawler implementation. Each column presents the average latency (bar), the median (green line),
and the distribution of the latencies (box plot).
SqlTvf crawler scalability. To evaluate SqlTvf crawler scalability, we first measured the latency of 200 requests on
varying TVF worker sizes: 2, 4, 6, 8, and 10. Then we computed the throughput by dividing the number of regions by
each measured latency. Figure 7 summarizes how the throughput increases as the number of TVF workers grows. In
summary, both analyses show the increase of throughput in the range of TVF worker sizes on all the dataset-analysis
pairs. However, the demonstrated scalability of the SqlTvf crawler is limited to small workload. For example, during
the anomaly detection on COVID-19 Open Data, the TVF framework evaluates on 821 regions after the filtering by
EntityWeightModel. If we increase the number of after-filtering regions, the SqlTvf crawler suffers from the TVF
scheduling problem and the latency increases significantly as a result. To overcome this limitation, we implemented the
SqlBeam crawler that a Beam pipeline evaluates RAMs.
SqlBeam crawler scalability. For SqlBeam crawler, we vary the workload (from small to big), and measure its
performance. For 11 different filtering threshold, we measured the E2E latency (of 50 requests) for anomaly detection
on COVID-19 Open Data. Figure 8 presents the measured E2E latency of the SqlBeam crawler. This shows that the
SqlBeam crawler can scale to large workload (e.g., 247202 regions), and the average E2E latency only gets doubled
while the workload grows more than 100 times.
6
Applications and discussions
Applications of HoCA. Even in this early stage, our HoCA offering has attracted more than 30 teams to build data-
insights systems with it. We identify three kinds of main application areas: (1) System monitoring. Many of our
partner teams are working with extremely complex systems, and monitoring the health of these systems is critical. Our
outlier detection construction, and its variants of slow-bleed detection (by switching to a trend-change detection model),
and recurrent cube crawling, have found major applications for these use cases: HoCA analysis enabled much faster
and more accurate detection of precise issues (such as which version is having anomalous behaviors), and thus prevents
significant revenue loss. (2) Business intelligence (BI). HoCA constructions such as metric attribution and correlation
detection have been applied in several BI systems to help analysts understand what is going on and identify new business
opportunities. For example, by composing several HoCA operators, we can quickly identify that certain account has a
revenue anomaly, and is strongly correlated with budget allocation of some campaigns. Some of these applications have
generated significant revenue uplift. (3) Experimentation analysis. Several major internal experimentation analysis
systems requires slicing the data and do A/B testing on the slices to understand fine-grained impact of an experiment.
17

---

(a) COVID-19 + Shift
(b) COVID-19 + Anomaly
(c) CMS + Shift
(d) CMS + Anomaly
Figure 7: Scalability of the SqlTvf crawler implementation.
These core analytic functionalities can be captured by cube crawling by programming appropriate RAMs (however,
these RAMs tend to have more statistical flavor since the input data is usually a sample). Migrating these systems to use
HoCA has significantly improved their latency and scalability, and sometimes enabled brand new functionalities (e.g.,
novel analysis leveraging HoCA abstractions).
More HoCA operators. Section 3.1.3 shows that cube crawling can emulate DIFF Abuzaid et al. (2021), which in turn
can emulate a variety of data explanation engines (see references therein). To this end, if we examines literature with
HoCA in mind, there are several work that can be interpreted as HoCA operators. For example, operators described in
Multistructural Database Fagin et al. (2005b) and Cascading Analyst Ruhl et al. (2018) can both be viewed as HoCA
operators, though they have much more adhoc semantics compared to cube crawling.
Beyond operators. As we have demonstrated in recurrent cube crawling (Section 3.3.2), there can be complex HoCA
pipelines with cubes (explicitly in the program) flowing in between. These pipelines require complex cube management,
and currently have esoteric constructions. Therefore, it is of importance to research how can we simplify and systematize
these pipeline constructions (which we call HoCA pipelines). Another intriguing direction is whether HoCA cubes can
be useful for learning (which we call the cube learning). To this end, one direction we are exploring is cube forecasting:
Classical forecasting usually assumes that the input data is one slice, yet in realistic scenario, input data can often
be modeled as a cube where the regions encode useful structural information, and conceivably one can leverage this
structure to achieve better timeseries forecasting. We believe there is more since HoCA cubes provide a rich data model
for data analysis and learning.
18

---

Figure 8: Latency of the SqlBeam crawler implementation. The boxplots present the latency distributions. The line plots show the
change in average latency (blue line) and the average latency of the materialization cost and the filtering (orange line).
7
Conclusion
In this paper we described Holistic Cube Analysis (HoCA), an approach to augment the capabilities of relational
queries for data insights. At the foundational level, HoCA defines AbstractCube, a data type defined as a function from
RegionFeatures space to relational tables, which allows one to go from a set of tuples (i.e., a table) to a set of tables (i.e.,
a set of set of tuples). As a result, queries over cubes become cube-to-cube transformations (i.e., higher-order functions).
We described two first operators, cube crawling and cube join, in the current HoCA framework. The power of these two
operators comes from programmable RAMs, multi-model crawling, and the composition of operators (between cube
crawling and cube join, and with other relational queries). HoCA has found many useful data-insights applications,
across different areas such as system monitoring, experimentation analysis, and business intelligence. There are various
future avenues for HoCA, such as efficient implementation of HoCA operators, more useful HoCA operators, HoCA
pipelines, HoCA and interactive analysis, and last but not least, exploring connections with machine learning.
References
Multidimensional
Expressions
(MDX).
https://learn.microsoft.com/en-us/sql/mdx/
multidimensional-expressions-mdx-reference?view=sql-server-ver16.
Python Bayesian Structural Time Series. https://pypi.org/project/pybsts/.
Apache Beam Python SDK. https://beam.apache.org/documentation/sdks/python/.
Firas Abuzaid, Peter Bailis, Jialin Ding, Edward Gan, Samuel Madden, Deepak Narayanan, Kexin Rong, and Sahaana Suri.
Macrobase: Prioritizing attention in fast data. ACM Trans. Database Syst., 43(4):15:1–15:45, 2018.
Firas Abuzaid, Peter Kraft, Sahaana Suri, Edward Gan, Eric Xu, Atul Shenoy, Asvin Ananthanarayan, John Sheu, Erik Meijer,
Xi Wu, Jeffrey F. Naughton, Peter Bailis, and Matei Zaharia. DIFF: a relational interface for large-scale data explanation. VLDB
J., 30(1):45–70, 2021. doi: 10.1007/s00778-020-00633-6. URL https://doi.org/10.1007/s00778-020-00633-6.
19

---

Robert J. Aumann and Lloyd S. Shapley. Values of Non-Atomic Games. Princeton University Press, 2015. ISBN 9781400867080.
doi: doi:10.1515/9781400867080. URL https://doi.org/10.1515/9781400867080.
James Bradbury, Roy Frostig, Peter Hawkins, Matthew James Johnson, Chris Leary, Dougal Maclaurin, George Necula, Adam
Paszke, Jake VanderPlas, Skye Wanderman-Milne, and Qiao Zhang. JAX: composable transformations of Python+NumPy
programs, 2018. URL http://github.com/google/jax.
Kay H. Brodersen, Fabian Gallusser, Jim Koehler, Nicolas Remy, and Steven L. Scott. Inferring causal impact using bayesian
structural time-series models. Annals of Applied Statistics, 9:247–274, 2015.
Ronald Fagin, Amnon Lotem, and Moni Naor. Optimal aggregation algorithms for middleware. CoRR, cs.DB/0204046, 2002. URL
https://arxiv.org/abs/cs/0204046.
Ronald Fagin, Ramanathan V. Guha, Ravi Kumar, Jasmine Novak, D. Sivakumar, and Andrew Tomkins. Multi-structural databases.
In Chen Li (ed.), Proceedings of the Twenty-fourth ACM SIGACT-SIGMOD-SIGART Symposium on Principles of Database
Systems, June 13-15, 2005, Baltimore, Maryland, USA, pp. 184–195. ACM, 2005a.
Ronald Fagin, Ramanathan V. Guha, Ravi Kumar, Jasmine Novak, D. Sivakumar, and Andrew Tomkins. Multi-structural databases.
In Chen Li (ed.), Proceedings of the Twenty-fourth ACM SIGACT-SIGMOD-SIGART Symposium on Principles of Database
Systems, June 13-15, 2005, Baltimore, Maryland, USA, pp. 184–195. ACM, 2005b.
Sebastian Raschka. Mlxtend: Providing machine learning and data science utilities and extensions to python’s scientific computing
stack. The Journal of Open Source Software, 3(24), April 2018. doi: 10.21105/joss.00638. URL http://joss.theoj.org/
papers/10.21105/joss.00638.
Matthias Ruhl, Mukund Sundararajan, and Qiqi Yan. The cascading analysts algorithm. In Gautam Das, Christopher M. Jermaine,
and Philip A. Bernstein (eds.), Proceedings of the 2018 International Conference on Management of Data, SIGMOD Conference
2018, Houston, TX, USA, June 10-15, 2018, pp. 1083–1096. ACM, 2018. doi: 10.1145/3183713.3183745. URL https:
//doi.org/10.1145/3183713.3183745.
Bart Samwel, John Cieslewicz, Ben Handy, Jason Govig, Petros Venetis, Chanjun Yang, Keith Peters, Jeff Shute, Daniel Tenedorio,
Himani Apte, Felix Weigel, David G Wilhite, Jiacheng Yang, Jun Xu, Jiexing Li, Zhan Yuan, Craig Chasseur, Qiang Zeng, Ian
Rae, Anurag Biyani, Andrew Harn, Yang Xia, Andrey Gubichev, Amr El-Helw, Orri Erling, Allen Yan, Mohan Yang, Yiqun
Wei, Thanh Do, Colin Zheng, Goetz Graefe, Somayeh Sardashti, Ahmed Aly, Divy Agrawal, Ashish Gupta, and Shivakumar
Venkataraman. F1 query: Declarative querying at scale. pp. 1835–1848, 2018. URL http://www.vldb.org/pvldb/
vol11/p1835-samwel.pdf.
Yi Sun and Mukund Sundararajan. Axiomatic attribution for multilinear functions. In Yoav Shoham, Yan Chen, and Tim Roughgarden
(eds.), Proceedings 12th ACM Conference on Electronic Commerce (EC-2011), San Jose, CA, USA, June 5-9, 2011, pp. 177–178.
ACM, 2011. doi: 10.1145/1993574.1993601. URL https://doi.org/10.1145/1993574.1993601.
Xiaolan Wang, Xin Luna Dong, and Alexandra Meliou. Data x-ray: A diagnostic tool for data errors. In Timos K. Sellis, Susan B.
Davidson, and Zachary G. Ives (eds.), Proceedings of the 2015 ACM SIGMOD International Conference on Management of Data,
Melbourne, Victoria, Australia, May 31 - June 4, 2015, pp. 1231–1245. ACM, 2015.
Eugene Wu and Samuel Madden. Scorpion: Explaining away outliers in aggregate queries. Proc. VLDB Endow., 6(8):553–564,
2013.
Xi Wu, Shaleen Deep, Joe Benassi, Yaqi Zhang, Fengan Li, Uyeong Jang, James Foster, Stella Kim, Yujing Sun, Long Nguyen,
Stratis Viglas, Somesh Jha, John Cieslewicz, and Jeffrey F. Naughton. Holistic cube analysis: A query framework for data insights,
2023.
20

---

A
Region Aumann-Shapley attribution for density metric
A density metric ρ is a ratio metric where both the numerator and the denominator admit sum aggregation (i.e., it is
“SUM/SUM”). We denote the numerator of the density by w, and denominator of the density by s. Let C be a cube.
Suppose that we have a dimension ‘is_test’ which splits the data into test (‘is_test’=True) and control (‘is_test’=False).
Therefore, at the population level, we have population metrics for test (wp
t , sp
t ) and control (wp
c and sp
c), which induces
a difference:
Cρ = wp
t
sp
t
−wp
c
sp
c
(3)
Let r be a region in the cube. At the region level, we have region metrics for test (wr
t and sr
t) and for control (wr
c and
sr
c), which induces metric changes ∆wr = wr
t −wr
c and ∆sr = sr
t −sr
c. We consider the following question:
Can we examine the region level metric change and the population level metric change, and compute a real value to
assign to the region, to “model” the contribution of the region to the population level density change?
Note that the answer is not trivial because the ratio nature of the density metric. The answer to the question can be
implemented as a region analysis model for cube crawling to help find regions that contribute significantly to the change
of a density metric at the top level. We give a principled answer to the question based on the Aumann-Shapley method.
To apply the Aumann-Shapley method, we consider the following function:
F(w, s, w′, s′) = w + w′
s + s′
(4)
where we should think of w, s are mass and volume in a region, and w′, s′ as mass and volume in the complement of
the region (i.e., outside of the region). Importantly, F gives a “region-population” modeling for attribution: For each
region, we only need the metric values of the region, and of the population, to compute the four values w, s, w′, s′.
With the above, then the control (base) point for Aumann-Shapley method is exactly P0 = (wr
c, sr
c, wp
c −wr
c, sp
c −sr
c),
and the test (comparison) point is exactly P1 = (wr
t , sr
t, wp
t −wr
t , sp
t −sr
t). Our goal is thus to compute attribution for
the first and second coordinates (where the first coordinate changes from wr
c to wr
t , and the second coordinate changes
from sr
c to sr
t). To apply the Aumann-Shapley method, we form a path:
h(t) = (1 −t) · P0 + t · P1
(0 ≤t ≤1)
(5)
Let g(t) = F(h(t)), therefore we have (this is the gist of Aumann-Shapley method)
F(P1) −F(P0) = g(1) −g(0) =
Z 1
0
g′(t)dt =
Z 1
0
X
i
∂F
∂zi
∂zi
∂t dt =
X
i
Z 1
0
∂F
∂zi
∂zi
∂t dt

(6)
where zi = h(t)i (i = 1, 2, 3, 4) are the variables of F, that is, parameterizations:
• w(t) = z1 = h(t)1 = (1 −t)wr
c + twr
t .
• s(t) = z2 = h(t)2 = (1 −t)sr
c + tsr
t.
• w′(t) = z3 = h(t)3 = (1 −t)(wp
c −wr
c) + t(wp
t −wr
t ).
• s′(t) = z4 = h(t)4 = (1 −t)(sp
c −sr
c) + t(sp
t −sr
t).
A.1
Attribution of numerator
Therefore the attribution to the first coordinate z1, is simply
Z 1
0
∂F
∂z1
∂z1
∂t dt
21

---

We note that
∂z1
∂t = wr
t −wr
c
and
∂F
∂z1
=
1
s(t) + s′(t) =
1
(1 −t)sp
c + tsp
t
=
1
(sp
t −sp
c)t + sp
c
Therefore the attribution of the first coordinate is
Z 1
0
wr
t −wr
c
s(t) + s′(t)dt =(wr
t −wr
c)
Z 1
0
1
(sp
t −sp
c)t + sp
c
dt
=wr
t −wr
c
sp
t −sp
c
ln

(sp
t −sp
c)t + sp
c

1
0
=(wr
t −wr
c)ln(sp
t ) −ln(sp
c)
sp
t −sp
c
(7)
A.2
Attribution of denominator
Now we turn to the attribution of the second coordinate, which is
Z 1
0
∂F
∂z2
∂z2
∂t dt
where
∂z2
∂t = sr
t −sr
c
and
∂F
∂z2
= −w(t) + w′(t)
(s(t) + s′(t))2 = −(1 −t)wp
c + twp
t

(1 −t)sp
c + tsp
t
2 = −(wp
t −wp
c)t + wp
c

(sp
t −sp
c)t + sp
c
2
(8)
Let f(t) =
1
(sp
t −sp
c)

(sp
t −sp
c)t+sp
c
, g(t) = (wp
t −wp
c)t + wp
c, then
(8) =
Z 1
0
f ′gdt
=fg

1
0 −
Z 1
0
fg′dt
(Integration by parts)
=
1
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

−wp
t −wp
c
sp
t −sp
c
Z 1
0
1
(sp
t −sp
c)t + sp
c
dt
=
1
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

−wp
t −wp
c
(sp
t −sp
c)2 ln

(sp
t −sp
c)t + sp
c

1
0
=
1
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

−wp
t −wp
c
(sp
t −sp
c)2

ln(sp
t ) −ln(sp
c)

Therefore we get attribution of denominator:
(sr
t −sr
c)

1
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

−wp
t −wp
c
(sp
t −sp
c)2

ln(sp
t ) −ln(sp
c)

(9)
22

---

A.3
Combining everything together
The theory of Aumann-Shapley attribution says that the attribution of z1 and z2 is the sum of their individual attributions,
this thus gives
(7) + (9) =(wr
t −wr
c)ln(sp
t ) −ln(sp
c)
sp
t −sp
c
+ (sr
t −sr
c)

1
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

−wp
t −wp
c
(sp
t −sp
c)2

ln(sp
t ) −ln(sp
c)

=(wr
t −wr
c)(sp
t −sp
c) −(wp
t −wp
c)(sr
t −sr
c)
(sp
t −sp
c)2

ln(sp
t ) −ln(sp
c)

+ sr
t −sr
c
sp
t −sp
c
wp
t
sp
t
−wp
c
sp
c

(10)
A.4
Completeness property of our region attributions
Note that we have used a particular way to perform the attribution: For every single region, we form a function to model
the region-population relationship and by analyzing that function, we compute a value as attribution for the region; and
we repeat this for all regions. We now show that our method has some nice completeness properties. To see this, we will
denote by RAS(γ) the attribution computed by our algorithm for region γ (RAS stands for “Region Aumann-Shapley”).
We observe that the population level metrics are constants, so the attribution formulas can be rewritten as follows:

(sp
t −sp
c)(wr
t −wr
c) −(wp
t −wp
c)(sr
t −sr
c)

· K +
sr
t −sr
c
sp
t −sp
c

· Cρ,
(11)
where K is some constant only depending on the population, which we don’t care in the following; and Cρ is actually
exactly the population density change. Now, we observe the following “summable” property:
Lemma 1 (Region attribution is additive). Consider two regions β, γ that are disjoint (namely the data points
involved are disjoint, which we write as β ∩γ = ∅). Then RAS(β ∪γ) = RAS(β) + RAS(γ).
Proof. At the region level, we have the metrics for β, γ, which is: β : (wβ
c , sβ
c ) →(wβ
t , sβ
t ), and γ : (wγ
c , sγ
c ) →
(wγ
t , sγ
t ). Because β, γ are disjoint, therefore for the union we have:
β ∪γ : (wβ
c + wγ
c , sβ
c + sγ
c ) →(wβ
t + wγ
t , sβ
t + sγ
t ).
So we can compute RAS(β ∪γ) using formula (11), and one can see that it is just sum of RAS(β) and RAS(γ).
Note that we may not be able to represent β ∪γ as a region, so the conclusion of this lemma is quite nontrivial. In fact,
it immediately implies the following two:
Corollary 1 (Global population completeness). Suppose that we have a collection F of disjoint regions, where these
regions “sum up” to the population. Then
X
r∈F
RAS(r) = Cρ,
where Cρ is the top level density change.
Proof. This immediately follows from the “summable” result above. Here we give a alternate direct proof. Summing
over the attributions of regions r ∈F, which gives:
X
r∈F

(sp
t −sp
c)(wr
t −wr
c) −(wp
t −wp
c)(sr
t −sr
c)

· K +
sr
t −sr
c
sp
t −sp
c

· Cρ

,
23

---

We observe that this gives exactly Cρ, because the first summand gives rise to a sum that is zero, while for the second
summand, P
r(sr
t −sr
c)/(sp
t −sp
c) = 1 (exercise). This gives global population completeness.
Corollary 2 (Subpopulation completeness). Suppose we have a region γ which has density change Cγ
ρ . Now, suppose
γ can be partitioned into a family of disjoint regions F. Then P
r∈F RAS(r) = Cγ
ρ .
A.5
The degenerate case
Clearly, so far we derive the closed form of path integration based on the assumption thatsp
t̸ = sp
c. The case where
sp
t = sp
c = sp (note that we introduced a new notation sp) is the degenerate case. In that case, only mass changes
from wp
c to wp
t but the volume does not change. Therefore the contribution of numerator to the change degenerates to
(precisely it is only that the path integration changes):
(wr
t −wr
c)
Z 1
0
1
sp
c
dt = wr
t −wr
c
sp
(12)
For denominator, the attribution degenerates to
−(sr
t −sr
c)
(sp
c)2
Z 1
0

(wp
t −wp
c)t + wp
c

dt = −(sr
t −sr
c)(wp
t + wp
c)
2(sp
c)2
= −(sr
t −sr
c)(wp
t + wp
c)
2(sp)2
(13)
Summing up this gives:
wr
t −wr
c
sp
−(sr
t −sr
c)(wp
t + wp
c)
2(sp)2
(14)
A.6
Teasing out churn effects
In this section we consider the following setup, for every region we can identify a set of “entities” where we can
categorize traffic in a region by these entities. Specifically, we consider three kinds of traffic:
1. Entities that only appear in the control, but not in test (control-only, shorthand CO below).
2. Entities that only appear in the test, but not in control (test-only, shorthand TO below).
3. Entities that appear in both test and control (test-control, shorthand TC below).
For certain applications, it is important to do attribution separately for each type of the traffic.
There is a simple reduction to reduce this attribution to our derivation above. Basically, for every region r (think about
r =(Domain=‘facebook.com’) above, this region is (implicitly) split into three finer grained regions rCO, rCT, and rTO.
These three regions have disjoint traffic (because it is identified by entities). Therefore, we can apply the derivation
above to each of the traffic in these three regions to compute the attributions, respectively.
B
Frequent Itemset Mining via cube crawling
We describe FrequentItemsetModel, which can be used in cube crawling to solve the classic Frequent Itemset Mining
problem. To this end, recall that the input data to frequent itemset mining is a set of transactions, encoded as follows:
To fit the problem into cube crawling, we first encode the items as dimensions of a new table, ‘encoding_df’. Such
encoding can be achieved using common libraries (e.g., TransactionEncoder in mlextend Raschka (2018)). Note that
we attach a measure column, ‘Count’, so that each row (i.e. a transaction) has a count 1 (this can be generalized by
24

---

Id
Transaction
1
{ Beer, Diaper}
2
{ Beer, Diaper }
3
{ Rum, Whisky}
...
...
(a)
Beer
Diaper
Rum
Whisky
Count
1
1
0
0
1
1
1
0
0
1
0
0
1
1
1
...
...
...
...
...
(b)
Table 3: (a): An example transaction data set, for demonstrating FrequentItemsetModel. (b): ‘encoding_df’ that encodes a
transaction data set, so that the “items” in the transaction data set become dimensions in the encoding_df. The first three rows are
encoding of the transactions of the first three transactions in Table 3a.
attaching arbitrary weight, instead of a count). We can therefore now define a BaseTableAggregatableCube C FIM,
where: (i) The base table is ‘encoding_df’, and (ii) The aggregation for Count is SUM.
FrequentItemsetModel. Recall that for an itemset (a subset of all items), frequent itemset mining computes a metric,
called support, as the fraction of transactions that contain this itemset. To compute this with cube crawling, we
observe that an itemset corresponds exactly to a region in the ‘encoding_df’, where the dimensions in the region are
exactly items in the itemset, and all dimensions in the region takes value 1. We call such regions the “itemset regions”.
Further, for an itemset region, such as (Beer=1, Diaper=1), the aggregated Count (i.e., SUM(Count)) gives exactly
the number of times itemset {Beer, Diaper} appears in all transactions. This thus gives FrequentItemsetModel: (1)
The model requests Count as a measure feature. Note that, for example, C FIM(Count) is precisely the total number
of transactions N (i.e., number of rows) in the base table ‘encoding_df’. (2) At a region γ, If the region γ contains a
dimension that is assigned value 0, then we simply stop exploration from there, since that region does not correspond
to a itemset. (3) Otherwise, the region γ corresponds to an itemset, and the region feature Count is the number Nγ
of number of transactions that contain this itemset. (4) Finally, support of this itemset is simply Nγ/N. As a result,
CubeCrawl(FrequentItemsetModel) computes the support of all itemset regions, as desired. Detailed code is given
below.
1
class FrequentItemsetMiningModel(region_analysis_model.RegionAnalysisModel):
2
# Initializer.
3
def __init__(self, count_column, signal_names, apriori_signal_names):
4
super().__init__(
5
signal_names=signal_names,
6
apriori_signal_names=apriori_signal_names,
7
prefix=prefix)
8
9
self._count_column = count_column
10
self._metric_feature_specifiers = [count_column]
11
self._total_count = 0
12
13
@property
14
def population_df(self):
15
"""Returns population data with which we compare with data."""
16
return self._population_df
17
18
@population_df.setter
19
def population_df(self, population_df):
20
self._population_df = population_df
21
self._total_count = self._population_df[self._count_column]
22
23
def __call__(self, data_frame, region):
24
"""Returns an Signals object for FIM.
25
26
Args:
27
data_frame: The data frame to compute attention signals. It should be
28
noted that a wide table must be used as data_frame for this model.
29
region: A tuple of attribute-value pairs representing the region to
30
evaluate, e.g.: ((’beer’, True), (’Rum’, False)).
31
"""
32
signals = signals.Signals(support=0, continue_exploration=1)
25

---

33
signals.signal_names = self._signal_names
34
35
if any(not value for _, value in region):
36
signals[’continue_exploration’] = 0
37
else:
38
signals[’continue_exploration’] = 1
39
if region:
40
signals[’support’] = (
41
data_frame[self._count_column].sum() / self._total_count)
42
else:
43
# Set the support of order-0 region to 0.
44
signals[’support’] = 0
45
return signals
C
Comparison with OLAP
In this section, we will compare the standard OLAP framework with the HoCA framework introduced in this paper.
First, we present the OLAP framework and its foundational building blocks.
Online analytical processing (OLAP, for short). OLAP broadly refers to the technology that enables fast multi-
dimensional analytics (MDA). In MDA, the data schema is divided into two parts: categorical attributes (referred to as
the dimensions) and numeric attributes (called measures). A typical OLAP query seeks to understand the relationship
of the measures with respect to a set of dimensions. For example, consider a business warehouse with dimensions as
part, supplier, customer, date. The measure of interest is the total sales sales. An OLAP query over this warehouse
may consist of aggregating the sales for each (part, supplier, customer) combination. A business user may look at
the sales data and decide to breakdown the sales figure by rolling-up to only the customer dimension and look at the
total sales figure per customer. Similarly, it is also possible to add the date dimension (this is known as drilling-down)
to understand the sales figures for each customer per month/quarter/year.
The fundamental abstraction that allows for fast computation of OLAP queries is efficient processing of data cubes.
Given a set of dimensions D and a measure M, a user may ask an OLAP query that corresponds to a GROUP BY
query with a subset of D as the group by columns and an aggregation function over M. The number of all possible
group-by queries is 2|D|. Further, the cardinality of the result of each group-by query is also exponential in the size
of the input table (in the worst case). In typical applications, the materialized result can be of the order of several
hundred gigabytes, so development of efficient data cube implementation algorithms is extremely critical. The problem
of selecting data cubes to materialize in order to obtain fast query response time while minimizing the cube computation
resource requirement has been the subject of intense research in the database community.
HoCA vs. OLAP. We now highlight the key differences between our framework and OLAP.
Analytical problems. OLAP is designed for fast multidimensional analytics which are mainly on the “forward” direction,
in the sense that users instantiates actions on where to examine next. By contrast, HoCA is designed to solve search
problems over the cube view of data formed by the region expressed in the program. The analytical problems solved by
HoCA are usually in the “backward” direction: For example in the CostPerClick attribution case, HoCA starts with
the top-level CostPerClick change, and the analysis deconstructs the metric and search for the regions that are major
contributors to this change. To solve the same Cpc attribution problem in OLAP, users have to use OLAP operators to
perform an iterative, but manual, slice-and-dice analysis to find the insights.
HoCA cubes vs. OLAP cubes. This difference in analytic questions induces vastly different considerations of the
cube design: In HoCA, cubes are designed to be a logical form of data, and HoCA operators are about higher-order,
cube-to-cube transformations. These operators can be composed in a HoCA program, where HoCA cubes flow in
between. OLAP cubes are, on the other hand, designed for entire languages (e.g. MDX) for forward cube analytic
capabilities. OLAP cubes are monolithic data objects, and there is little sense of OLAP cubes explicitly flowing between
operators. Since one of the goals of HoCA is to build a framework that is easy to program in, abstract cube and regions
26

---

provides an intuitive way to model the sub-space that needs to be explored. Further, observe that the notion of cellset is
general enough to capture an OLAP data cube. Indeed, the * in a Cellset can be seen as an equivalent of ANY in OLAP
cubes3. A cellset is also more expressive than an OLAP cube since we do not require the measure to be generated by a
decomposable aggregate function, which is typically the case in OLAP. This property has important implications for
compositions in HoCA, in that given a materialized data cube, one could interpret that as a CellsetCube, allowing users
to write programs over the cube subsequently.
Analysis and programming. HoCA provides a data model (a new logical form of data) and an algebraic framework.
HoCA provides novel programming experiences and constructions, such as Region Analysis Model programming, cube
join, and recurrent cube crawling, which are all beyond OLAP considerations. To this end, we emphasize that HoCA
cube crawling allows passing of information (via the population data for each model) about the entire region induced by
all the dimensions to the sub-regions crawled. This is important to allow for computation of advanced signals such as
aumann_shapley_attribution (which requires such population information, see Section A). OLAP does not
have a counterpart to allow for message passing between sub-cubes.
A remark on similarities between HoCA and OLAP. We note a key similarity between the two frameworks that
are likely to allow several optimizations that have been designed for OLAP to improve HoCA’s efficiency. For a
BaseTableGroupByCube, given a set of dimensions D′ = {d1, . . . dk} ⊆D, the number of the region spaces explored
by HoCA and the cardinality of the data cube formed by D′ is the same. This suggests that ROLAP based optimizations
built for exploiting the overlap between different data cubes could potentially be transferred to multiple HoCA programs
exploring common regions. Indeed, multiple HoCA programs running over the same input can be optimized jointly to
minimize computation. We leave the problem of building such an optimizer as a problem for future work.
C.1
Expressing Constraint Verification using cube crawling in HoCA
In this section, we will show how the problem of detecting integrity constraint violations can be naturally expressed as a
HoCA program. We will consider the following version of functional dependency detection: Consider a set of columns
S, and another set of columns T (for concreteness, let S = {X, Y }, and T = {Z, W}). Now given a relation R, we
want to check whether there is a functional dependency S →T in R, that is:
h
∀t, t′ ∈R
i
t[S] = t′[S] ⇒t[T ] = t′[T ]
That is, for any two tuples t, t′ ∈R that have the same values when projected over attributes S, the projections of the
two tuples on attribute T are also the same. We show that there are various ways to program this using cube crawling in
HoCA (we will use some pseudo-code to simplify things and highlight ideas)
Approach 1: Encoding counting as a cube metric. In this approach, we push the counting work into the cube
abstraction, using a BaseTableGroupByCube. For this, consider we define the following metric:
1
2
distinct_target_count = COUNT(DISTINCT Z, W)
where Z, W are the assumed members in T . Therefore, for any region say γ : (X = x, Y = y), if we re-
quest the metric feature distinct_target_count, we get the number of projections of Z, W conditioned
on the values in S. With this, we can consider a trivial model IdModel, which simply requests the metric feature
distinct_target_count, as follows:
1
2
id_model = IdModel(metric_features=[’distinct_target_count’])
3Note that the cardinality of a data cube (which is Πi∈[n](Ui + 1)) also matches that of a Cellset
27

---

Therefore, if distinct_target_count is larger than 1 for any region, there is no functional dependency in R.
This can be encoded using the following cube crawling:
1
2
CubeCrawl(
3
data_cube=BaseTableGroupByCube(R),
4
grouping_sets=[[’X’, ’Y’],],
5
models=[id_model],
6
thresholds = {distinct_target_count : 1.0})
Note that here we used the grouping_sets parameter to focus on grouping set [X, Y ], because we don’t need to
consider any region of smaller degree.
Approach 2: Counting entities in a model. In the approach, we program an region analysis model called the
entity_model. This model receives as parameters a set of dimensions called entity_columns, which in this
case is just T . Upon a region, the BaseTableGroupByCube projects the data to the region γ : (X = x, Y = y), and
requests two dimension columns T = [Z, W]. The semantics is simply computing the group-by on these dimensions
and return a table of the Z, W pairs. Because of the groupby, these two columns become the primary keys. Therefore,
by counting the number of entities in the region feature table, say recording it in a signal called entity_count, we
can detect functional dependency failure if any region has entity_count larger than one. This gives the following
HoCA program:
1
entity_model = EntityModel(
2
entity_columns=[’Z’, ’W’],
3
output_signals=[’entity_count’])
4
5
CubeCrawl(
6
data_cube=BaseTableGroupByCube(R),
7
grouping_sets=[[’X’, ’Y’],],
8
models=[entity_model],
9
thresholds = {entity_count : 1.0})
Approach 3: An alternative model using more standard SQL semantics. In this approach, we augment the base
relation with a new column say const_one, where it is a constant 1, and we put a SUM aggregation function. Then
the we can program a different region analysis model, say EntityMeasureModel, which requests a set of entity
columns, and a set of entity measures, and then process them. In our case, for each region, entity_measure_model
will receives a table where each row contains an entity and its corresponding measures. Therefore again by just counting
the number entities (ignoring the aggregated measure), and recording the answer using a signal called entity_count,
we can detect functional dependency failure if any region has more than one entities. This gives the following program:
1
entity_model = EntityMeasureModel(
2
entity_columns=[’Z’, ’W’],
3
entity_measure=[’const_one’]
4
output_signals=[’entity_count’])
5
6
CubeCrawl(
7
data_cube=BaseTableGroupByCube(R),
8
grouping_sets=[[’X’, ’Y’],],
9
models=[entity_model],
10
thresholds = {entity_count : 1.0})
D
More examples
D.1
Using cube crawling to generate pseudo-labels for deep learning
We describe a case where cube crawling plays a key role in deep learning. Suppose that we have a set of “events” that
we want to perform a binary classification (so class labels are 0/1). However, unlike typical supervised learning setting,
28

---

there is no label on the training data (or in other words, the training data is entirely unlabeled). In this case, one general
strategy is the following: (1) We first generate pseudo-labels (we call them plabels in the following), (2) We then use
these plabels together with the unlabeled training data to train a deep learning model. Now, the question reduces to:
How to generate good plabels?
Figure 9: Cube crawling used for generating pseudo-labels (plabels) for a downstream deep-learning pipeline.
To answer the question, we note that the training data we have is organized as a relational table, as shown on the left
side of Figure 9. Each row represents an event, and an event is described by its id, a bunch of attributes (abstracted
into ‘A1’, ‘A2’, ...,) and a single metric ‘metric’ (to simplify things). Now the idea is to use cube crawling to generate
plabels: By considering different regions of the abstract cube (induced by slicing on the base table on attributes), we
can put a single event (say event id=1) into different regions (“Slicing” in Figure 9). For each region we run a region
analysis to check the behavior of all events in that region, and based on that we assign ‘pre-plabels’ (either 0 or 1)
to all events in the region (“Region Analysis” in Figure 9). After this step, for each event, we have an “event table”
of its pre-plabels in different regions. Finally, the plabel of an event is just the fraction that its pre-plabel is 1 in the
respective event table. Note that this is “soft label” which somehow captures the “probability” that we thinks it is 1. In
practice, we found that considering a large number of regions is crucial for this strategy to work, since it gives different
“view points” about the behavior of an event. Therefore the efficiency of crawling is important. Also, our design allows
machine learnists to focus on writing the statistical analysis to assign pre-plabels.
D.2
Cross rank correlation
For the test period, we have N data points of (Budget, Cost) pairs U = {(Bt
i, Rt
i)}N
i=1. Similarly, for the control period,
we have V = {Bc
j, Rc
j}M
j=1 (note that there are M points, and N may not be equal to M). The correlation formula is
the following:
CrossRankCorr(U, V ) =
P
i∈[N],j∈[M] sgn

Rt
i −Rc
j

Bt
i −Bc
j

NM
(15)
29

---

