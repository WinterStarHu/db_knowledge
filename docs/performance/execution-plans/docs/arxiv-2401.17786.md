# A Modular Graph-Native Query Optimization Framework

> 来源: https://arxiv.org/pdf/2401.17786

A Modular Graph-Native Query Optimization Framework
Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡,
Jingren Zhou
{bingqing.lbq,yihe.zxl,longbin.lailb,xiaofan.yyf,louyunkai.lyk,wenyuan.ywy,jingren.zhou}@alibaba-inc.com
ying.zhang@zjgsu.edu.cn
Alibaba Group, ‡Zhejiang Gongshang University
China
Abstract
Complex Graph Patterns (CGPs), which combine pattern matching
with relational operations, are widely used in real-world applica-
tions. Existing systems rely on monolithic architectures for CGPs,
which restrict their ability to integrate multiple query languages
and lack certain advanced optimization techniques. Therefore, to
address these issues, we introduce GOpt, a modular graph-native
query optimization framework with the following features: (1) sup-
port for queries in multiple query languages, (2) decoupling execu-
tion from specific graph systems, and (3) integration of advanced
optimization techniques. Specifically, GOpt offers a high-level inter-
face, GraphIrBuilder, for converting queries from various graph
query languages into a unified intermediate representation (GIR),
thereby streamlining the optimization process. It also provides a
low-level interface, PhysicalSpec, enabling backends to register
backend-specific physical operators and cost models. Moreover,
GOpt employs a graph-native optimizer that encompasses exten-
sive heuristic rules, an automatic type inference approach, and
cost-based optimization techniques tailored for CGPs. Comprehen-
sive experiments show that integrating GOpt significantly boosts
performance, with Neo4j achieving an average speedup of 9.2× (up
to 48.6×), and GraphScope achieving an average speedup of 33.4×
(up to 78.7×), on real-world datasets.
1
Introduction
Graph databases [6, 7, 12, 20, 37] have emerged as powerful tools
for analyzing complex relationships across various domains. At the
core of these databases lies graph pattern matching, a fundamental
and extensively researched problem [14, 15, 32, 39, 40, 44, 52, 59, 61].
Graph pattern (abbr. pattern henceforth) matching aims to identify
all subgraphs in a data graph that match a given query pattern and
is widely used in numerous areas [24, 29, 31, 35, 48, 62].
Recently, there has been growing interest in complex graph pat-
terns (CGPs) due to their utility in real-world applications [5, 17, 18,
27, 51, 60]. CGPs build upon patterns by incorporating additional
relational operations such as projection, selection, and aggregation,
enabling more expressive and versatile query capabilities. To en-
able efficient expression and execution of CGPs, existing graph
databases typically adopt a monolithic architecture design, where
the entire process is tightly integrated from query parsing to ex-
ecution. These systems handle specific query languages, starting
with a parser that translates the query into an internal representa-
tion. A query optimizer then generates a physical execution plan,
which is subsequently executed on an underlying execution engine.
Two representative examples of graph systems are Neo4j [7] and
GraphScope [28], illustrated in Fig. 1.
More Engines
MATCH (…) -[…]-> (…)
MATCH (…)<-[…]-(…)
WHERE (…)
RETURN …
Cypher Client
Gremlin Client
g.V( ).match(…)
.has(…)
.group().by(...)
.count()
Cypher Parser
Cypher Planner
Interpreted Runtime
Single Store
Neo4j
Gremlin Parser
Traversal Strategy
Distributed Runtime
Distributed Store
GraphScope
More Languages Clients
ANTLR Parser
GraphIRBuilder
Graph-native
Optimizer
PhysicalConvertor
AST
Physical Plan
Figure 1: An example of processing CGPs in the monolithic
systems of Neo4j and GraphScope, compared with the mod-
ular design of GOpt.
Neo4j processes CGPs written in the Cypher query language[30].
It employs a Cypher parser to convert the query into an intermedi-
ate structure, uses a CypherPlanner to optimize queries through
heuristic rules and cost-based techniques, and executes the op-
timized plans on its single-machine backend. In contrast, Graph-
Scope [28] is designed for industrial-scale distributed graph process-
ing. It supports CGPs expressed in Gremlin [51], utilizes a Gremlin
parser, applies TraversalStrategy to register heuristic optimiza-
tion rules, and distributes the execution across its dataflow-based
distributed backend engine [49].
Motivation and Challenges. The monolithic architecture used
by existing systems like Neo4j and GraphScope for processing
CGPs poses two key limitations.
Limitation 1. In practice, while most graph systems are designed to
support a single query language, there are scenarios where support-
ing multiple query languages becomes necessary to meet evolving
user demands. For example, at Alibaba, users transitioning from
Neo4j to GraphScope for scalable query processing may require
support for Cypher queries, despite GraphScope being originally
designed for Gremlin. Additionally, the upcoming standardization
of the graph query language GQL [5] further drives the need for
systems to adapt and expand their capabilities. While a language
converter is feasible, the only official converter currently available
translates Cypher to Gremlin [25], limiting its applicability in other
scenarios, such as adopting GQL in GraphScope. The monolithic
architectures make it challenging for existing systems to integrate
support for additional query languages.
Limitation 2. Different systems employ distinct optimization strate-
gies for CGPs, each with strengths, but often lack advanced tech-
niques available in others. For example, Neo4j leverages cost-based
optimization (CBO) to determine the optimal search order but
lacks advanced techniques like worst-case optimal join [46], which
arXiv:2401.17786v3  [cs.DB]  12 Dec 2024

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
GraphScope employs for efficient cyclic pattern matching. Con-
versely, GraphScope relies on a rule-based optimizer, missing the
sophisticated CBO strategies available in Neo4j. Both systems also
lack support for recent advancements such as high-order statis-
tics [40], critical for improving cardinality estimation and query
planning. The monolithic architectures make it difficult to integrate
such optimization techniques seamlessly.
A potential solution is to adopt a modular and unified optimiza-
tion framework with key features:
• Support for multiple query languages: The framework should
inherently support parsing and processing multiple query lan-
guages, enabling seamless interoperability.
• Decoupling from existing systems: By being independent of
specific graph systems, it can provide modular interfaces that
simplify integration with various platforms.
• Advanced optimization capabilities: The framework should
integrate advanced optimization techniques from academia and
industry into a unified system.
Beyond the efforts of system design, the implementation of such
a framework poses immediate challenges.
C1: How to support cross-language compatibility? CGPs can be ex-
pressed in diverse query languages such as Cypher and Gremlin,
each with distinct syntaxes and semantics, making integration into
a unified framework challenging.
C2: How to effectively optimize CGPs? Optimizing CGPs is inher-
ently complex due to their hybrid semantics, combining patterns with
relational operations. Existing graph optimization techniques [45,
61] focus on patterns and often overlook relational aspects. While
converting patterns into relational equivalents [8, 55, 57] enables
the use of relational optimization techniques, this non-graph-native
approach may miss optimization opportunities specific to graph
pattern matching [40, 61]. Another challenge is handling arbitrary
type constraints. CGPs often include patterns without explicit type
constraints when users have not assigned specific types on certain
vertices and edges and can, in theory, match any type in the data
graph. In practice, however, these elements are implicitly restricted
by the underlying data. Current techniques [40] depend heavily on
explicit type constraints, limiting their effectiveness in such cases.
Our Solutions. To address the challenges, We present GOpt, a
modular graph-native optimization framework for CGPs, as illus-
trated in Fig. 1. It is designed to support multiple query languages
and seamlessly integrate with existing graph systems.
S1: Modular System Design. GOpt enables cross-language compati-
bility with a unified graph intermediate representation (GIR) for
CGPs, combining patterns and relational operations. GOpt pro-
vides a high-level interface, GraphIrBuilder, that translates the
Abstract Syntax Tree (AST) generated by tools like ANTLR [1] from
various query languages into a unified GIR, thereby decoupling
query processing from specific languages. Additionally, GOpt intro-
duces a low-level interface, PhysicalSpec, enabling graph systems
to register their backend-specific operators. This flexibility allows
integration with various graph systems while maintaining compat-
ibility with multiple query languages. Currently, GOpt supports
both Cypher and Gremlin and has been integrated into Neo4j and
GraphScope. Note that the standardized GQL is not yet supported,
as its official grammar interpretation tool has not been finalized.
S2: Graph-native Optimization for CGPs. Building on the unified
GIR, GOpt enables graph-native optimization by addressing the
interaction of patterns and relational operations in CGPs. A compre-
hensive set of heuristic rules has been designed for the rule-based
optimization (RBO), which are extensible and pluggable. To han-
dle patterns with arbitrary types, we introduce an automatic type
inference algorithm that deduces appropriate type constraints for
pattern vertices and edges from graph data. By inferring type con-
straints, we can fully exploit CBO techniques, such as those in [40],
to enhance cardinality estimation using high-order statistics. Using
the estimated cardinalities, backend-specific physical operators,
and their cost models, we propose a top-down search framework
with branch-and-bound strategies to optimize CGPs, determining
the optimal execution plan by minimizing the estimated cost. The
unified framework allows advanced graph optimization techniques
to be seamlessly integrated, benefiting all integrated graph systems.
Concerns naturally arise regarding the unified design of GOpt,
particularly in: (1) the theoretical completeness of GIR in express-
ing diverse query languages with their syntactic and semantic
differences; and (2) the compatibility with different data models,
from Neo4j’s schema-loose model to GraphScope’s schema-strict
model [19]. In this paper, we briefly remark on these concerns and
refer readers to our open-source project for more details [3].
Contributions and organization. Below, we summarize our con-
tributions and the organization of the paper.
(1) Introduction of GOpt (Sec.4 and Sec. 5): GOpt stands as the
first, as far as we know, graph-native optimization framework
for industrial-scale graph systems, supporting multiple query lan-
guages through a unified intermediate representation and an ex-
tensible optimization architecture.
(2) Advanced optimization techniques (Sec.6): GOpt introduces a
comprehensive set of heuristic rules, an automatic type inference
algorithm, and a novel cardinality estimation method, integrated
into a cost-based optimizer with a top-down search framework.
(3) Implementation and experiments (Sec. 7 and Sec. 8): We im-
plemented GOpt as an open-source project [3] atop Apache Cal-
cite [21], supporting Gremlin and Cypher, and integrating with
Neo4j and GraphScope. Experiments show significant performance
gains, with GOpt achieving an average speedup of 9.2× (up to
48.6×) on Neo4j and 33.4× (up to 78.7×) on GraphScope using real-
world datasets. GOpt has also been deployed in real applications at
Alibaba, demonstrating its practicality and scalability.
Additionally, Section 2 covers background and related work,
Section 3 introduces the notations and definitions used in this
paper, and Section 9 concludes the paper.
2
Background and Related Work
Corresponding to the main challenges in implementing a modular
and unified optimization framework mentioned above, this section
reviews the existing query languages and optimization techniques,
then presents the existing databases for optimizing CGPs.
2.1
Graph Query Languages
Numerous graph query languages [5, 7, 17, 27, 51, 60] have been
developed for querying property graphs [16]. For instance, Grem-
lin [51] represents graph traversal as a sequence of steps, each

---

A Modular Graph-Native Query Optimization Framework
Table 1: Limitations of Existing Graph Databases. “Lang.”,
“Opt.”, “H. Stats”, and “T. Infer” represent “Language”, “Opti-
mization”, “High-order Statistics”, and “Type Inference”.
Database
Lang.
Opt.
WcoJoin
H. Stats.
T. Infer
Neo4j
Cypher
RBO/CBO
×
×
×
GraphScope
Gremlin
RBO
✓
×
×
GLogS
Gremlin
CBO
✓
✓
×
GOpt
Multiple
RBO/CBO
✓
✓
✓
offering functions such as navigating through graph vertices and
edges. Cypher [30] crafted for Neo4j [7], allows users to describe
graph patterns with an ASCII-art syntax while integrating relational
operators similar to those in SQL. The recently published GQL [5] is
a new standard developed by ISO committee for querying property
graphs, with a consensus effort that integrates previous advance-
ments. While these languages focus on querying property graphs,
SPARQL [11] is a W3C recommendation for querying Resource
Description Framework (RDF) graphs [10]. Despite the prolifera-
tion of graph query languages, there is a notable gap: the lack of a
dedicated optimizer to enhance query efficiency in these languages.
2.2
Graph Query Optimizations
Graph pattern matching is fundamental in graph query process-
ing. In a sequential context, Ullmann’s introduction of the first
backtracking algorithm [59] marked a significant advancement
in graph pattern matching. This has led to various optimizations,
including tree indexing [52], symmetry breaking [32], and com-
pression techniques [22]. Due to the challenges in parallelizing
backtracking algorithms, join-based algorithms have been devel-
oped for distributed environments. These algorithms often hinge
on cost estimation to optimize join order for matching patterns
efficiently. For instance, binary-join algorithms [38, 39] estimate
costs using random graph models. In contrast, the work in [15]
adopts the WcoJoin algorithm [46], ensuring a cost that remains
within a worst-case upper bound. Recognizing the limitations of
both binary join and WcoJoin methods in consistently delivering
optimal performance [39], researchers have turned to hybrid ap-
proaches [14, 45, 61] that adaptively select between binary and
WcoJoin techniques based on the estimated costs. For more accu-
rate cost estimation, [45] and [40] suggested to leverage high-order
statistics. While these studies have significantly improved graph
pattern matching, they are not designed to address graph queries
in practice that often encompasses relational operations. There is
extensive work on RDF graph query optimization [43, 50, 54, 58],
which is not detailed here as this paper focuses on property graphs.
2.3
Databases for Optimizing CGPs
Graph databases [6, 7, 12, 20, 37, 40] enable users to perform com-
plex graph queries using declarative query languages. However,
they encounter limitations when it comes to fully supporting CGPs.
For example, Neo4j, a leading graph database, is limited by its tight
coupling with Cypher [30] for CGPs support. GraphScope [28],
a distributed graph computing system coupled with the Gremlin,
lacks CBO optimization techniques. GLogS [40] is designed specifi-
cally to optimize patterns, ensuring worst-case optimality as well as
leveraging high-order statistics (i.e., the small pattern frequencies),
but it cannot optimize CGPs due to its inability to handle relational
Table 2: Frequently used notations.
Notation
Definiton
𝐺(𝑉𝐺, 𝐸𝐺)
A data graph with 𝑉𝐺and 𝐸𝐺
𝑃(𝑉𝑃, 𝐸𝑃)
A pattern graph with 𝑉𝑃and 𝐸𝑃
𝑁𝐺(𝑣), 𝑁𝐸
𝐺(𝑣)
Out neighbors and out edges of 𝑣in graph 𝐺
𝜆𝐺(𝑣), 𝜆𝐺(𝑒)
The type of vertex 𝑣and edge 𝑒in graph 𝐺
𝜏𝑃(𝑣), 𝜏𝑃(𝑒)
The type constraint of vertex 𝑣and edge 𝑒in pattern
𝑃, can be BasicType, UnionType or AllType
F𝑃,𝐺
The number of mappings of pattern 𝑃in graph 𝐺
operations or arbitrary types. More limitations are summarized in
Table 1. Note that Neo4j does not perform type inference because of
its schema-loose design for greater flexibility. In summary, current
graph databases face challenges in optimizing CGPs effectively.
A non-graph-native approach involves converting CGPs into
relational queries and leveraging relational optimizers, as seen in
systems like IBM DB2 Graph[57], SQLGraph [55], and others [33,
36, 42]. The primary advantage of this method lies in its ability
to build upon the well-studied relational optimization techniques.
However, this approach fails to utilize graph-specific optimizations
[40, 45, 61] and struggles to handle UnionTypes (i.e., a combina-
tion of multiple types, detailed in Section 3) in CGPs, a construct
inherently tied to graph semantics and absent in relational mod-
els, leading to inefficient query execution. For example, matching
the pattern with UnionTypes in Fig. 3(a) may require executing
multiple queries—each with specific types for pattern vertices and
edges—and then merging the results, leading to inefficiency.
3
Preliminaries
Data graph 𝐺= (𝑉𝐺, 𝐸𝐺) in this paper adheres to the definition of
the property graph model [18]. 𝑉𝐺and 𝐸𝐺are the sets of vertices
and edges, where |𝑉𝐺| and |𝐸𝐺| represent the number of vertices
and edges. Given𝑢, 𝑣∈𝑉𝐺, (𝑢, 𝑣) ∈𝐸𝐺is an edge directed from𝑢to
𝑣, and all the out neighbors and out edges of𝑢are denoted as 𝑁𝐺(𝑣)
and 𝑁𝐸
𝐺(𝑣), respectively. Each vertex or edge in 𝐺is associated with
a type, denoted as 𝜆𝐺(𝑣) and 𝜆𝐺(𝑒) respectively. Both vertices and
edges can carry properties, which are key-value pairs. Note that if
no ambiguity arises, we omit 𝐺from the subscript in the notations,
and so as the follows. Besides, although our framework supports
multi-type vertices as in [30], this paper focuses on vertices with
single type for simplicity. Considering two graphs 𝐺1 and 𝐺2, we
assert that 𝐺2 is a subgraph of 𝐺1, symbolized as 𝐺2 ⊆𝐺1, if and
only if 𝑉𝐺2 ⊆𝑉𝐺1, and 𝐸𝐺2 ⊆𝐸𝐺1.
A pattern 𝑃= (𝑉𝑃, 𝐸𝑃) is a small connected graph. Note that if 𝑃
is not connected, matching the pattern is equivalent to taking the
Cartesian product of the matches for its connected components,
which is naturally the problem of CGPs in the following. Each ver-
tex and edge in the pattern graph is associated with a set of types as
a type constraint, denoted as 𝜏𝑃(𝑣) and 𝜏𝑃(𝑒), respectively. Three
categories of type constraints are supported: (1) BasicType contains
a single type that matches a particular vertex (or edge) type in the
data graph. (2) UnionType encompasses multiple types, allowing
for a match with data vertices (or edges) of any type in this set. For
instance, UnionType {Post,Comment} signifies that the matched
vertices can be either of type Post or Comment in data graph. (3)
AllType, considered as a special UnionType, indicates that any ver-
tex or edge in data graph satisfies the constraint. Predicates can be

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
ANTLR Parser
GraphIRBuilder
Graph-native Optimizer
PhysicalConvertor
RBO
Type Checker
CBO
Schema
High-order
Statistics
Metadata
Provider
GLogue:
GetStatistics
GetSchemaInfo
GOpt
Graph Query
Physical Plan
AST
GIR
Client: Cypher, Gremlin, GQL etc.
Backend Engine: Neo4j, GraphScope etc.
Figure 2: System Architecture Overview
specified to vertices and edges in the pattern graph as well, while
we mostly focus on the type constraints in this paper.
Finding matches of 𝑃in 𝐺involves identifying all subgraphs 𝐺′
in 𝐺where 𝑃can be mapped to 𝐺′ via a homomorphism preserving
edge relations and type constraints. The mapping functionℎ: 𝑉𝑃→
𝑉𝐺′ ensures that ∀𝑒= (𝑢, 𝑣) ∈𝐸𝑃, there is a corresponding edge
(ℎ(𝑢),ℎ(𝑣)) ∈𝐸𝐺′. Additionally, the types of vertices and edges
in 𝐺′ must align with the type constraints specified in 𝑃: (1) ∀𝑣∈
𝑉𝑃, 𝜆𝐺′ (ℎ(𝑣)) ∈𝜏𝑃(𝑣), and (2) ∀𝑒= (𝑢, 𝑣) ∈𝐸𝑃, 𝜆𝐺′ ((ℎ(𝑢),ℎ(𝑣))) ∈
𝜏𝑃(𝑒). The number of mappings of 𝑃in 𝐺is called pattern frequency,
denoted as F𝑃,𝐺, or simply F𝑃when 𝐺is clear.
Remark 3.1. The homomorphism semantics, which allows dupli-
cate vertices or edges in matching results, is employed in our frame-
work due to its transformability. Specifically, a plan using homomor-
phism semantics can be converted to a plan using other commonly
adopted semantics, such as the no-repeated-edge semantics (used by
Cypher) that excludes duplicate edges, by adding an all-distinct filter
at the end of the pattern match. This makes our framework flexible
and adaptable to different query language semantics.
A complex graph pattern, termed as CGP, extends patterns with
further relational operations. Optimizing CGPs is challenging due
to their hybrid semantics. A straightforward way is to first identify
matches of 𝑃in 𝐺, and then subject the matched subgraphs to the
remaining relational operators in CGPs for further analysis, such
as projecting the properties of matched vertices and edges and
selecting the matched subgraphs that satisfy certain conditions.
4
System Overview
To address the limitations in existing systems, we propose a graph-
native query optimization framework, GOpt, specifically for CGPs.
This framework leverages state-of-the-art graph query optimiza-
tion techniques (with refinement and extension for CGPs), offers
a unified approach for supporting multiple query languages, and
facilitates seamless integration with various backend engines. The
system architecture is shown in Fig. 2, with three principal compo-
nents of query parser, optimizer, and metadata provider.
Query Parser. GOpt employs the ANTLR parser tool [1] to gen-
erate an AST for queries in various graph query languages, such
as Gremlin and Cypher. Then it utilizes a GraphIrBuilder to con-
vert the AST into a language-independent plan based on a unified
graph intermediate representation (GIR), detailed in Section 5.1.
This GIR decouples GOpt from specific query languages and allows
extensive reuse of techniques developed within GOpt.
Optimizer. The graph-native optimizer is the core module in GOpt,
employing a combination of Rule-based Optimization (RBO), type
checker, and Cost-based Optimization (CBO). The RBO comprises
a comprehensive set of heuristic rules designed to optimize the
interactions between patterns and relational operations in CGPs.
Apart from the rules originally included in RBO, new rules can be
integrated to further enhance its optimization capabilities. How-
ever, since RBO does not account for data characteristics, it may
fail to fully optimize CGPs, particularly in the presence of com-
plex patterns. Therefore, we need to explore additional data-driven
optimization techniques for handling CGPs.
The first such technique is a type checker, specifically designed
to infer implicit type constraints from the underlying data for pat-
terns with arbitrary types. This technique is crucial for query opti-
mization, enhancing execution efficiency and improving cardinality
estimation accuracy in the subsequent CBO phase.
Building on this, we propose a unique CBO approach for fur-
ther optimization. Our CBO introduces several key innovations for
patterns. First, we leverage high-order statistics from GLogS [40]
for more accurate estimation of pattern frequencies. Unlike GLogS,
however, our approach handles arbitrary type constraints. Second,
to accommodate diverse backend engines, we allow backends to
register their specific physical operators and cost models through
a PhysicalSpec. Finally, we introduce a top-down search algo-
rithm with a branch-and-bound strategy to determine the optimal
query plan, aiming to minimize the estimated cost. Together, these
techniques ensure robust and adaptable query optimization across
various systems. We build GOpt based on Apache Calcite [21],
a prominent open-source optimization framework for relational
databases, to leverage Calcite’s relational optimization techniques.
Metadata Provider. The metadata provider has two key compo-
nents: the first is the graph schema, defining the types of vertices
and edges in the data graph for the type checker. For simplicity, we
initially assume a schema-strict context with an explicit schema,
and more flexible contexts are discussed later in Remark 6.1. The
second component, named GLogue following [40], serves as a data
statistics provider. It precomputed the frequency of small graph
patterns (a.k.a., motifs) with up to 𝑘vertices (𝑘≥3) in the data
graph, going beyond the low-order statistics which only count
the vertices and edges. These advanced high-order statistics afford
the optimizer with more precise cardinality estimation for query
patterns, thereby enhancing the effectiveness of the optimization.
Overall Workflow. The query processing workflow of GOpt is
illustrated in Fig. 3. After parsing the queries, the optimization
process proceeds in the following order: RBO, type inference, and
finally CBO. This sequence is designed to balance optimization effec-
tiveness with computational cost, as both RBO and type inference
can influence CBO outcomes. Details on query parsing, heuristic
rules, type inference, and cost-based optimizations are provided
in Section 5, Section 6.1, Section 6.2, and Section 6.3, respectively.
This paper focuses specifically on optimizing graph patterns. For
instance, in CBO, our primary focus is on the costs associated with
these patterns. The handling of relational operators and their costs
is further detailed in Remark 7.1.

---

A Modular Graph-Native Query Optimization Framework
MATCH (v1) -[e1]-> (v2)
(v2) -[e2]-> (v3)
MATCH (v1) -[e3]-> (v3:Place)
WHERE v3.name = “China”
WITH v2, COUNT(v2) as cnt
RETURN v2, cnt
ORDER BY cnt LIMIT 10
GET_VERTEX
{NA,‘v1’,
AllType, NA}
EDGE_EXPAND
{‘v1’, ‘e1’,
AllType, OUT}
GET_VERTEX
{‘e1’, ‘v2’,
AllType, END}
MATCH_START
GET_VERTEX
{NA,‘v2’,
AllType, NA}
EDGE_EXPAND
{‘v2’, ‘e2’,
AllType, OUT}
GET_VERTEX
{‘e2’, ‘v3’,
AllType, END}
GET_VERTEX
{NA,‘v1’,
AllType, NA}
EDGE_EXPAND
{‘v1’, ‘e3’,
AllType, OUT}
GET_VERTEX
{‘e3’, ‘v3’,
Place, END}
MATCH_END
SELECT (v3.name = “China”)
GROUP (key=v2, agg_func=COUNT, alias=cnt)
ORDER (key=cnt, cmp=asc, limit=10)
1. Parse
2. Optimize
g.V( ).match(
__.as(‘v1’).out( ).as(‘v2’),
__.as(‘v2’).out( ).as(‘v3’))
.match(
__.as(‘v1’).out( ).as(‘v3’))
.select(‘v3’).has(‘name’, ‘China’)
.hasLabel(‘Place’)
.groupCount( ).by(‘v2’)
.order( ).by(values).limit(10)
1. Parse
(a) Cypher Query
(b) Gremlin Query
(c) Logical Plan
(e) Neo4j Physical Plan
Scan v3 (Place, name = “China” )
Expand v3->v1 (Person)
ExpandInto (v2, v3)
Group (key=v2, agg=Count)
Order (key=cnt, limit=10)
Project (expr=v2)
MATCH_START
MATCH_END
JOIN
(d) GraphScope Physical Plan
Scan v3 (Place, name = “China” )
Expand v3->v1 (Person)
ExpandIntersect v2 (Person|Product)
GroupLocal (key=v2, agg=Count)
GroupGlobal (key=v2, agg=Sum)
Order (key=cnt, limit=10)
Project (expr=v2)
v1
v3: Place
e3
Expand v1->v2 (Person|Product)
v1
v2
e1
e2
v3
Figure 3: An example of query processing workflow. For simplicity, we draw the pattern graph for MATCH_PATTERN (examples are
given) in the following. In this paper, logical operators are in ALL_UPPERCASE format, and physical operators use CamelCase.
5
Query Transformation
To allow different query languages to plug into GOpt, we present
the unified graph intermediate representation (GIR) for CGPs and
describe interfaces to convert queries into this format.
5.1
GIR Abstraction
The GIR abstraction [34] provides a foundation for representing
CGPs with both patterns and relational query semantics. It defines
a data model D that presents a schema-like structure for interme-
diate results in which each data field has a name and a designated
datatype, including graph-specific datatypes (e.g., Vertex, Edge, Path)
and general datatypes (e.g., Primitives and Collections). It also de-
fines a set of operators Ω that operate on data tuples from D and
produce new data tuples as results, consisting of graph operators
and relational operators. The graph operators are designed to re-
trieve graph data, including: (1) EXPAND_EDGE to expand adjacent
edges from vertices; (2) GET_VERTEX to retrieve endpoints from
edges; (3) EXPAND_PATH to support path expansion with a specified
hop number 𝑙, corresponding to 𝑙consecutive edges in the pat-
tern, and users can also define path constraints such as Arbitrary
(no constraints), Simple (No-repeated-node), or Trail (No-repeated-
edge) [18]; and (4) MATCH_PATTERN as a composite operator that
encapsulates the above graph operators between MATCH_START and
MATCH_END to represent a pattern, as illustrated in Fig. 3(c). The rela-
tional operators consist of the commonly used operators in RDBMS
and can be applied on graph data, e.g., PROJECT for projecting vertex
properties, SELECT for selecting edges based on conditions, JOIN for
joining sub-paths, etc. More details of the GIR can be found in [2].
Remark 5.1. The definition of GIR is inspired by existing work on
graph relational algebra [56] and is enhanced with MATCH_PATTERN to
handle complex patterns. Moreover, GIR’s development follows an
engineer-oriented approach, prioritizing support for commonly used
functionalities over theoretical completeness. It continuously evolves
to meet new requirements from real applications.
With the GIR abstraction, a CGP is represented as a unified di-
rected acyclic graph (DAG), where the nodes represent operators
in Ω, and the edges define the data flow between operators. The
DAG has two representations, the logical plan for high-level query
semantics (shown in Fig. 3(c)) and the physical plan for low-level
operator implementations (shown in Fig. 3(d) and 3(e)). To construct
the logical plan, GOpt offers a GraphIrBuilder, as exemplified in
Section 5.2. For the physical plan, where operators are tied to the
backend engine, GOpt uses a PhysicalSpec to allow backends to
register their own physical operators, ensuring efficient plan exe-
cution. Physical plans on two different backends are exemplified in
Fig. 3(d) and Fig. 3(e), and further details are provided in Section 6.3.
5.2
Query Parser
GOpt employs the ANTLR parser tool [1] to interpret queries in
different query languages into an Abstract Syntax Tree (AST). Cur-
rently, GOpt supports two of the most popular graph query lan-
guages, Cypher[30] and Gremlin[51], as exemplified in Fig. 3(a) and
Fig. 3(b), and preserves compatibility with the recent ISO standard
GQL [5]. Then, the AST is transformed into the GIR as a logical
plan, as shown in Fig. 3(c), through a GraphIrBuilder. A code
snippet for building the logical plan is as follows:
GraphIrBuilder irBuilder = new GraphIrBuilder();
pattern1 = irBuilder.patternStart()
.getV(Alias("v1"),AllType())
.expandE(Tag("v1"),Alias("e1"),AllType(),Dir.OUT)
.getV(Tag("e1"),Alias("v2"),AllType(),Vertex.END)
.expandE(Tag("v2"),Alias("e2"),AllType(),Dir.OUT)
.getV(Tag("e2"),Alias("v3"),AllType(),Vertex.END)
.patternEnd();
pattern2 = irBuilder.patternStart()
.getV(Alias("v1"),AllType())
.expandE(Tag("v1"),Alias("e3"),AllType(),Dir.OUT)
.getV(Tag("e3"),Alias("v3"),BasicType("Place"),Vertex.END)
.patternEnd();
query = irBuilder.join(pattern1,pattern2,
Keys([Tag("v1"), Tag("v3")]), JoinType.INNER)
.select(Expr("v3.name='China'"))
.group(Keys(Tag("v2")),AggFunc.COUNT, Alias("cnt"))
.order(Keys(Tag("cnt")), Order.ASC, Limit(10));
Note that Alias() defines an alias for results, accessible via Tag()
in later operations. With the GraphIrBuilder, the logical plan is
constructed in a language-independent manner, facilitating the
subsequent optimization process. Henceforth, when optimizing
CGPs, we are referring to optimizing their GIR form.

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
SELECT (v3.name = “China”)
GROUP (key=v2, agg_func=COUNT, alias=cnt)
ORDER (key=cnt, cmp=asc, limit=10)
GROUP (key=v2, agg_func=COUNT, alias=cnt)
ORDER (key=cnt, cmp=asc, limit=10)
RBO
COLUMNS
= empty
(a) Logical Plan
(b) Optimized Logical Plan after RBO
COLUMNS
= empty
COLUMNS
= {name}
PROJECT v2
v1
v2
e1
e2
v3
v1
v2
e1
e2
e3
v3: Place
name =
“China”
v1
v3: Place
e3
JOIN
Figure 4: An Example of Rule-Based Optimizations
6
Optimization
In this section, we present our optimization techniques, including
RBO with carefully designed heuristic rules for CGPs (Section 6.1),
a type inference method for arbitrary patterns (Section 6.2), and
CBO techniques (Section 6.3).
6.1
Rule-based Optimization
Given a CGP 𝑄, GOpt first employs Rule-Based Optimizations
(RBO) to optimize 𝑄in a heuristic way. These pre-defined rules
consider possible optimizations across patterns and relational oper-
ators. Note that the heuristic rules are designed to be extensible and
pluggable. We introduce four representative rules in the following.
FilterIntoPattern. Consider a pattern followed by a SELECT opera-
tor. The FilterIntoPattern aims to push filters into patterns to reduce
the number of intermediate results. Typically, querying pattern
in graph databases can result in numerous matchings. Thus, the
users usually apply filters with SELECT operator to narrow them
down. This rule optimizes the process by integrating filters with
graph operators during the pattern matching phase. For example,
the SELECT operator in Fig. 4(a) is pushed down into the pattern,
applying constraints during matching 𝑣3 as shown in Fig. 4(b).
FieldTrim. Given a pattern, the FieldTrim is designed to eliminate
unnecessary intermediate data during query execution, which is
useful when the aliased intermediate results are no longer needed
in the subsequent query processing. For example, in Fig. 4(a), since
only 𝑣3’s name is used in the query, we specify retrieving just this
attribute during pattern matching using COLUMNS. Similarly, since
the query focuses solely on 𝑣2’s count after pattern matching, Field-
Trim uses a PROJECT operator to trim the other vertices and edges.
JoinToPattern. For two patterns connected by a JOIN operator, the
JoinToPattern aims to merge them into a single one, when the join
keys (i.e., vertices and/or edges) serving as the common vertices
and/or edges in the resulted pattern. This rule is effective under
the homomorphism-based matching semantics (Remark 3.1). How-
ever, the situation becomes more complex when the patterns are
followed by other relational operators, and then connected by JOIN.
Specifically, if the patterns are followed by PROJECT, it does not
affect join elimination because the PROJECT can be reordered with
the JOIN without impacting the query results. If a SELECT follows,
employing the FilterIntoPattern allows us to push the filter into the
patterns and then eliminate the JOIN. Conversely, if the patterns are
followed by relational operators like GROUP, ORDER, or LIMIT, which
alter the results of the pattern matching, the subsequent JOIN con-
necting the patterns cannot be eliminated. In Fig. 4(a), the two
Algorithm 1: Type Inference and Validation
Input
: Pattern 𝑃, Graph Schema 𝑆
Output
: Pattern 𝑃′ with validated type constraints or INVALID
Initialize 𝑄= {𝑢|𝑢∈𝑉𝑃} and sort 𝑄by ascending |𝜏𝑃(𝑢) |;
1
while 𝑄≠∅do
2
𝑢= 𝑄.𝑝𝑜𝑝();
3
CandVTypes = ∅and CandETypes = ∅;
4
for each 𝑡∈𝜏𝑃(𝑢) do
5
if |𝑁𝑃(𝑢) | > 0 and |𝑁𝑆(𝑡) | = 0 then
6
remove 𝑡from 𝜏𝑃(𝑢);
7
else
8
CandVTypes = CandVTypes ∪𝑁𝑆(𝑡);
9
CandETypes = CandETypes ∪𝑁𝐸
𝑆(𝑡);
10
for each 𝑣∈𝑁𝑃(𝑢) do
11
𝜏𝑃(𝑣) = 𝜏𝑃(𝑣) ∩CandVTypes;
12
𝜏𝑃(𝑒𝑢,𝑣) = 𝜏𝑃(𝑒𝑢,𝑣) ∩CandETypes;
13
if 𝜏𝑃(𝑣) = ∅or 𝜏𝑃(𝑒𝑢,𝑣) = ∅then
14
return INVALID
15
if 𝜏𝑃(𝑣) is updated and 𝑣∉𝑄then
16
insert 𝑣into 𝑄;
17
Return 𝑃′ with validated type constrains;
18
patterns can be merged into a single pattern with 𝑣1 and 𝑣3 as the
common vertices, as shown in Fig. 4(b).
ComSubPattern. For two patterns connected by binary operators
such as UNION, JOIN, and DIFFERENCE, we design the ComSubPat-
tern to identify common subpatterns in the two patterns, and save
the computation cost by matching the common subpattern only
once. For example, when querying the following CGP:
(v1:Person)-[]->(v2:Person)-[]->(:Product)
UNION
(v1:Person)-[]->(v2:Person)-[]->(:Place),
ComSubPattern identifies the common subpattern (v1:Person)-[]
->(v2:Person) across the binary UNION operator. It computes and
clones the results, which are then expanded for (v2:Person) -
[]->(:Product) and (v2:Person)-[]->(:Place) separately. Fi-
nally, the results are combined using the UNION operation.
6.2
Type Inference and Validation
As we discussed, patterns in CGPs often contain arbitrary type
constraints in real applications, which can be BasicType, Union-
Type, or AllType. While constraints like AllType enhance query
flexibility by allowing patterns to be expressed without specific
type constraints, they can significantly degrade performance if not
properly optimized. For instance, consider the pattern in Fig. 4(b),
where both 𝑣1 and 𝑣2 are typed with AllType. In this scenario, the
backend engine may have to scan all vertices, as they all meet the
type constraint. However, if certain type combinations do not exist
in the underlying data, much of this computation is wasted. As an
example, suppose 𝑣1 represents a Person, and 𝑣2 is expanded to
represent a Place. If there is no edge connecting 𝑣2 to a known
Place 𝑣3, the process generates unnecessary intermediate results,
exacerbating inefficiency. Furthermore, during CBO, imprecise type
constraints can lead to significant deviations between estimated
and actual costs, resulting in suboptimal query plans. These issues
highlight the critical need for type inference in patterns.
For clarity, we first assume a schema-strict context [19], where
the types of vertices and edges are predefined and can be directly

---

A Modular Graph-Native Query Optimization Framework
v1: Person
Person |
Product
v3: Place
v2:
e1:
Knows |
Purchases
LocatedIn |
ProducedIn
e2:
LocatedIn
e3:
v1
v2
e1
e2
e3
(b) Origin Pattern
(c) Pattern after Type Inference
Type Inference
v3: Place
HasMember
ContainerOf
Likes
Knows
Post
Forum
Person
id: Integer
name: String
id: Integer
name: String
id: Integer
title: String
(a) Graph Schema
Figure 5: An Example of Type Inference and Validation
utilized for type inference. A naive solution is to unfold each Union-
Type and AllType, enumerating all possible type combinations in-
cluding BasicTypes only in the pattern, and then validate each
combination according to the schema. However, it is not practi-
cal as such combinations can be exponential to the patterns. The
Pathfinder algorithm [53] infers type constraints for a path pattern
using schema hints, but is not applicable to general patterns. More-
over, Pathfinder requires inferred types to be BasicTypes, leading to
potentially enormous inferred patterns similar to the naive solution.
To address the drawbacks, we proposed a novel algorithm in
Algorithm 1 to infer types with schema hints, while preserve the
flexibility by UnionType if the inferred results contains multiple
types. We start by initializing a priority queue 𝑄to preserve all the
vertices in the pattern, sorted in ascending order of |𝜏(𝑢)| to ensure
that vertices with more specific type constraints are addressed first.
For vertices in the pattern, the algorithm iteratively updates the
vertex’s type constraint and those of its neighboring edges and
vertices based on the graph schema connectivity. If no valid type
constraints can be assigned, the algorithm returns an INVALID flag;
Otherwise, the algorithm terminates when 𝑄is empty, indicating
all inferred type constraints are stable, and returns the pattern with
these validated constraints. Note that for simplicity and due to
space limits, the algorithm only considers outgoing adjacencies,
but incoming adjacencies can be handled similarly.
Complexity Analysis. Assume the algorithm converges in 𝑘itera-
tions, the overall complexity is 𝑂(𝑘|𝑉𝑆|(𝑑𝑆+ |𝑉𝑃|)), where 𝑑𝑆is the
maximum vertex degree in 𝑆. In practice, the algorithm converges
quickly by starting with the most specific type constraints.
Remark 6.1. We address cases involving schema-loose systems,
such as Neo4j, where incomplete schema information prevents the
filtering of invalid type constraint assignments in the pattern. To
overcome this, we can retrieve the schema information directly from
the data graph during the initialization phase. Schema extraction
can be performed using methods such as those described in [23] or
system-provided tools like APOC [13] in Neo4j. Once the schema
is established, we can incrementally track changes caused by data
modification operations, ensuring the schema remains up to date for
subsequent optimization. If the data is not initially present, optimiza-
tion is unnecessary at this stage, and the schema extraction process
can be deferred until a sufficient amount of data is available.
Example 6.1. Given the graph schema in Fig. 5(a) and the origin
pattern in Fig. 5(b), the result pattern after type inference is shown
in Fig. 5(c). We start with vertex 𝑣3. By examining each basic type
in 𝜏(𝑣3), i.e., Place, CandVTypes for 𝑣3’s in neighbors is updated as
{Person, Product} through edges Person-LocatedIn->Place
and Product-ProducedIn->Place in schema. Thus,𝜏(𝑣1) and𝜏(𝑣2)
are updated to {Person,Product}. Then for 𝑣2, we update Can-
dVTypes for 𝑣2’s in neighbors through Person-Knows->Person,
Person-Purchase->Product, which further narrows 𝜏(𝑣1) down
to {Person}. Type constraints of edges can be inferred similarly.
6.3
Cost-based Optimization
We introduce Cost-Based Optimizations (CBO) for processing pat-
terns in CGPs, incorporating data statistics, backend engine varia-
tions, and complex type constraints. Inspired by prior works[15, 40,
61], we focus on two principles: (1), high-order statistics [40] for pre-
cise cardinality estimation, and (2) hybrid pattern joins combining
WcoJoin [46] and binary joins for improved performance. How-
ever, directly applying these techniques face challenges: (1) existing
high-order statistics only support patterns with BasicTypes, and
cannot handle UnionTypes, and (2) backend engines may lack effi-
cient implementations of join operations, particularly WcoJoin (e.g.
Neo4j). We explain how GOpt addresses these challenges below.
6.3.1
Cardinality Estimation. We leverage GLogue [40], which
precomputed the frequencies of patterns as higher-order statistics
for cardinality estimation. Techniques from [40], such as graph
sparsification, pattern encoding, and efficient maintenance and
lookup in GLogue, are directly utilized. Our focus is on processing
patterns with arbitrary type constraints.
Basically, given two subgraphs 𝑃𝑠1, 𝑃𝑠2 of 𝑃𝑡with 𝐸𝑃𝑡= 𝐸𝑃𝑠1 ∪
𝐸𝑃𝑠2 , by assuming the independent presence of patterns in the data
graph, we compute the frequency of 𝑃𝑡as follows:
F𝑃𝑡=
F𝑃𝑠1 × F𝑃𝑠2
F𝑃𝑠1∩𝑃𝑠2
(1)
where 𝑃𝑠1 ∩𝑃𝑠2 denotes the common parts of 𝑃𝑠1 and 𝑃𝑠2.
For the case𝑉𝑃𝑡\𝑉𝑃𝑠= {𝑣}, that the edges 𝑒1, . . . ,𝑒𝑛∈𝐸𝑃𝑡\𝐸𝑃𝑠1
are iteratively appended on 𝑃𝑠and generates intermediate patterns
𝑃1, . . . , 𝑃𝑛, where 𝐸𝑃𝑖\ 𝐸𝑃𝑖−1 = {𝑒𝑖} and 𝑃𝑛= 𝑃𝑡. We define the
expand ratio 𝜎𝑒𝑖, to reflect the change in pattern frequency when
expanding edge 𝑒𝑖= (𝑣𝑖, 𝑣), as follows:
𝜎𝑒𝑖=


Í
𝑡𝑒𝑖∈𝜏(𝑒𝑖) F𝑡𝑒𝑖
Í
𝑡𝑣𝑖∈𝜏(𝑣𝑖) F𝑡𝑣𝑖
if v ∉𝑉(𝑃𝑖)
Í
𝑡𝑒𝑖∈𝜏(𝑒𝑖) F𝑡𝑒𝑖
Í
𝑡𝑣𝑖∈𝜏(𝑣𝑖) F𝑡𝑣𝑖×Í
𝑡𝑣∈𝜏(𝑣) F𝑡𝑣
if v ∈𝑉(𝑃𝑖)
It should be noted that the type constraints here, 𝜏(𝑣) and 𝜏(𝑒), can
be BasicType, UnionType, or AllType. Based on this, the frequency
of 𝑃𝑡can be estimated as follows:
F𝑃𝑡= F𝑃𝑠×
Ö
𝑒𝑖∈𝐸𝑃𝑡\𝐸𝑃𝑠
𝜎𝑒𝑖
(2)
This equation provides a cardinality estimation approach for pat-
terns with arbitrary type constraints based on the subgraph fre-
quencies and the expand ratio of the expanded edges.
Lastly, we design a GLogueQuery, providing a unified interface
getFreq for the cardinality estimation of arbitrary patterns 𝑃, as fol-
lows: Given a pattern 𝑃, if it only contains BasicTypes, the frequency
can be queried from GLogue directly. Otherwise, we alternately
and iteratively apply Eq. 1 and Eq. 2 to estimate 𝑃’s frequency. This
process continues until the subpattern either exists in GLogue or
GLogueQuery (which has been computed and cached), or simplifies
to a single vertex or edge whose frequency can be obtained by
summing up the frequencies of the contained basic types.

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
(b) Source Pattern Ps with FPs = 70
v1: Person
v2:Person |
Product
e1:
Knows | Purchase
v1: Person
v2:Person |
Product
e1: Knows |
Purchase
e2: LocatedIn |
ProducedIn
v3: Place
v1: Person
v2:Person |
Product
e1: Knows |
Purchase
e2: LocatedIn |
ProducedIn
e3:LocatedIn
(c) Expand e2 = (v2, v3), 𝜎!" = 1.0, estimated FP1 = 70 * 1.0 = 70
(d) Expand e3 = (v1, v3), 𝜎!# = 0.2, estimated FPt = 70 * 1.0 * 0.2 = 14
Person: 10
Product: 20
Place: 5
ProducedIn: 20
Purchases: 30
LocatedIn: 10
(a) GLogue
Person
Person
Person
Place
Person
Product
Product
Place
……
Knows: 40
v3: Place
Figure 6: An Example of Cardinality Estimation
Example 6.2. Given the GLogue in Fig. 6(a) and the source pattern
𝑃𝑠in Fig. 6(b) with F𝑃𝑠= 70, we show an example of cardinality esti-
mation for pattern 𝑃𝑡in Fig. 6(c-d). First we expand𝑒2 of UnionType,
as shown in Fig. 6(c), and get 𝜎𝑒2 = FLocatedIn+FProducedIn
FPerson+FProduct
= 1.0. Then
we consider 𝑒3 of BasicType, as shown in Fig. 6(d), and compute
𝜎𝑒3 =
FLocatedIn
FPerson×FPlace = 0.2. Thus, we have F𝑃𝑡= 70 × 1.0 × 0.2 = 14.
6.3.2
Registerable Physical Plan. The PatternJoin equivalent rule
ensures the correctness of pattern transformations during CBO.
PatternJoin. Given data graph 𝐺and pattern 𝑃𝑡, with 𝑃𝑠1 and
𝑃𝑠2 where 𝑃𝑡= 𝑃𝑠1 ⊲⊳𝑘𝑃𝑠2 and ⊲⊳𝑘is the join operator with join
key 𝑘= 𝑉𝑃𝑠1 ∩𝑉𝑃𝑠2 . Let 𝑅(𝑃,𝐺), or 𝑅(𝑃) for brevity, represent the
results of matching 𝑃in 𝐺. Under homomorphism-based matching
semantics (with an all-distinction operator for other semantics, as
discussed in Remark 3.1), 𝑅(𝑃𝑡) can be computed by:
𝑅(𝑃𝑡) = 𝑅(𝑃𝑠1) ⊲⊳𝑘𝑅(𝑃𝑠2)
(3)
PhysicalSpec. Following existing works [45, 61], two execution
strategies, binary join and vertex expansion, are commonly used
to implement PatternJoin. However, different backends may imple-
ment these strategies differently, potentially leading to suboptimal
query plans if costs are not accurately calculated. To address this, we
introduce a PhysicalSpec interface, allowing backends to register
their custom physical operators and corresponding cost models:
interface PhysicalSpec {
// Compute the cost of joining two patterns.
// Recall that GlogueQuery provides cardinality of patterns.
Double computeCost(GlogueQuery gq, Pattern Ps1, Pattern Ps2);
}
We use Neo4j and GraphScope as examples to show registering cus-
tom physical operators with their cost models via PhysicalSpec:
(1) Binary Join: denoted as Join(𝑃𝑠1, 𝑃𝑠2 →𝑃𝑡), this strategy
computes the mappings of 𝑃𝑠1 and 𝑃𝑠2 separately and then joins
the results to produce the mappings of 𝑃𝑡. Both Neo4j and Graph-
Scope implement this using HashJoin and register the correspond-
ing cost as F𝑃𝑠1 + F𝑃𝑠2 according to [40] in the PhysicalSpec.
(2) Vertex Expansion: Denoted as Expand(𝑃𝑠→𝑃𝑡), this strat-
egy applies when 𝑉𝑃𝑡\𝑉𝑃𝑠= {𝑣}, meaning 𝑃𝑡is formed by append-
ing a vertex 𝑣to 𝑃𝑠. Neo4j implements this with the ExpandInto op-
erator. GraphScope utilizes the ExpandIntersect operator, based on
v1
v2
v1
v2
v3
∩
u1
u2
u3
u4
u5
u5
u6
(a) Vertex Expansion
(b) ExpandInto Operator from Neo4j
u1
u2
u1
u2
u4
u1
u2
u5
Check Edge Existence
𝑃!
u2
𝑅(𝑃!)
u1
u2
?
 Expand(𝑃! →𝑃")
……
𝑃"
(c) ExpandIntersect Operator from GraphScope
Intersect Adjacent Vertex Set and Unfold
𝑅(𝑃")
……
u1
e1
e1
e2
e3
u1
u2
u5
Matches in Data Graph
v1
v2
u1
u2
Pattern
u3
Figure 7: An Example of Vertex Expansion Implementations
algorithms proposed in [45]. Each system can register its physical
operators with their respective cost models, as shown below:
// Neo4j's registration
class ExpandInto implements PhysicalSpec {
@Override
Double computeCost(GlogueQuery gq, Pattern Ps, Pattern Pv) {
// Pv denotes the subpattern that:
// Vpv = Vpt \ Vps, Epv = Ept \ Eps
Pattern Pi = Ps, cost = 0
for each e in Pv {
Pi <- append e to Pi
cost += gq.getFreq(Pi)
}
return cost;
}
}
// GraphScope's registration
class ExpandIntersect implements PhysicalSpec {
@Override
Double computeCost(GlogueQuery gq, Pattern Ps, Pattern Pv) {
return |Pv| * (gq.getFreq(Ps));
}
}
Example 6.3. We illustrate the different vertex expansion imple-
mentations used by Neo4j and GraphScope in Fig. 7. Initially, pat-
tern 𝑃𝑠matches to (𝑢1,𝑢2) in the data graph (Fig. 7(a)). To match 𝑃𝑡
by expanding 𝑒3 and 𝑒2, Neo4j first expands 𝑒3, yielding three map-
pings (Fig. 7(b)), and then performs ExpandInto to find matches for
𝑒2 connecting 𝑢2 to 𝑢3, 𝑢4 and 𝑢5, respectively. As ExpandInto flat-
tens the intermediate matching results, the cost is the sum of fre-
quencies of intermediate patterns. In contrast, GraphScope uses
ExpandIntersect, which begins by finding the match set 𝑅(𝑃1) by
expanding 𝑒3, yielding one intermediate result. It then expands
𝑒2 and intersects the matched set with 𝑅(𝑃1) to obtain 𝑅(𝑃𝑡), and
finally unfolds the match set after expanding all the edges (Fig. 7(c)).
ExpandIntersect reduces computation by avoiding flattening inter-
mediate results, with the cost defined in the snippet.
Cost Model. In general, we adopt a cost model for CGPs that
considers both communication and computation cost. The com-
munication cost is defined as the number of intermediate results
during execution, due to fetching remote intermediate results for
further processing in distributed systems. The computational cost
is defined as the total cost of the operators in the physical plan,
each by computeCost method in PhysicalSpec, adjusted by a nor-
malized factor 𝛼𝑜𝑝to reflect each operator’s relative processing
expense. Specifically, if the integrated engine employs sequential
processor, such as Neo4j, the communication cost can be ignored.

---

A Modular Graph-Native Query Optimization Framework
Algorithm 2: Graph Optimizer
Input
: Pattern 𝑃, GLogueQuery 𝐺𝑄
Output
: Optimal (𝑝𝑙𝑎𝑛,𝑐𝑜𝑠𝑡) for 𝑃
(𝑝𝑙𝑎𝑛∗,𝑐𝑜𝑠𝑡∗) ←GreedyInitial(𝑃,𝐺𝐿);
1
Initialize map 𝑀= {p:(plan, cost)} with patterns of size 1 and 2 precomputed;
2
RecursiveSearch(𝑃, 𝐺𝑄, 𝑀, 𝑐𝑜𝑠𝑡∗);
3
Return 𝑀.𝑔𝑒𝑡(𝑃);
4
Procedure RecursiveSearch(𝑃, 𝐺𝑄, 𝑀, 𝑐𝑜𝑠𝑡∗)
5
if 𝑀contains 𝑃then Return;
6
for 𝑒∈getCands(𝑃) do
7
if getLowerBound(𝑀,𝑒) ≥𝑐𝑜𝑠𝑡∗then continue;
8
if 𝑒is of Expand(𝑃𝑠→𝑃) then
9
RecursiveSearch(𝑃𝑠, 𝐺𝑄, 𝑀, 𝑐𝑜𝑠𝑡∗);
10
𝑐𝑜𝑠𝑡′=𝑀.getCost(𝑃𝑠)+𝐺𝑄.getFreq(𝑃)+𝑒.computeCost(𝐺𝑄,𝑃𝑠,𝑃𝑣);
11
else if 𝑒is of Join({𝑃𝑠1, 𝑃𝑠2 } →𝑃) then
12
RecursiveSearch(𝑃𝑠1, 𝐺𝑄, 𝑀, 𝑐𝑜𝑠𝑡∗);
13
RecursiveSearch(𝑃𝑠2, 𝐺𝑄, 𝑀, 𝑐𝑜𝑠𝑡∗);
14
𝑐𝑜𝑠𝑡′ = 𝑀.getCost(𝑃𝑠1 ) + 𝑀.getCost(𝑃𝑠2 ) + 𝐺𝑄.getFreq(𝑃) +
15
𝑒.computeCost(𝐺𝑄, 𝑃𝑠1, 𝑃𝑠2 );
if 𝑐𝑜𝑠𝑡′ < 𝑀.getCost(𝑃) then
16
update 𝑃in 𝑀with the new 𝑝𝑙𝑎𝑛′ and 𝑐𝑜𝑠𝑡′;
17
6.3.3
Top-Down Search Framework. Based on new cardinality esti-
mation methods and backend-registered cost models, we introduce
a top-down search framework for optimizing patterns in Algo-
rithm 2. We begin with a greedy search to find an initial solution as
a tight bound for further exploration. A map 𝑀is then initialized
to store optimal plans for the subgraphs of 𝑃, with costs for sin-
gle vertices and edges set to their frequencies. We then search for
the optimal plan for 𝑃in a top-down framework. In the recursive
search, getCands identifies candidate edges for pattern transforma-
tion targeting 𝑃by enumerating the subgraphs. For each candidate,
we prune non-optimal search branches based on getLowerBound.
After that, we continue searching for the optimal plan for sub-
patterns (lines 10, 13-14), until they have already been computed
and stored in 𝑀(line 6). Using the subplan’s cost, we compute 𝑃’s
cost by accumulating communication costs (if not a single-node
backend) and computation cost based on the backend-registered
PhysicalSpec (line 11, 15). If 𝑃’s cost is lower than previous bests,
we update the optimal plan for 𝑃in 𝑀(lines 16-17).
Initialize with Greedy Search. GreedyInitial is designed to iden-
tify a good initial solution as a tight bound for branch pruning.
Starting with the queried pattern 𝑃, it iteratively removes candi-
date edges with the smallest cost, including Expand and Join, in a
greedy manner, with the edges’ costs and subpatterns’ frequencies
being accumulated to the pattern cost, until reducing the pattern
to a single vertex. This initial solution helps Algorithm 2 prune
unpromising branches, enhancing overall efficiency.
Prune Branch with Lower Bound. We design pruning strategies
to filter out the search branches that cannot be optimal (line 9-
10). Consider a candidate edge Expand(𝑃𝑠→𝑃). If 𝑃𝑠has been
previously searched and its cost already exceeds 𝑐𝑜𝑠𝑡∗, or, if the
noncumulative cost of 𝑃(i.e., F𝑃𝑠+𝑒.computeCost(𝑃𝑠, 𝑃𝑣)) exceeds
𝑐𝑜𝑠𝑡∗, the branch can be pruned. Similar pruning strategies can be
applied when the candidate edge 𝑒is of Join({𝑃𝑠1, 𝑃𝑠2} →𝑃).
7
System Implementation
GOpt is built upon the Apache Calcite framework [21], a dynamic
data management platform with a focus on relational databases.
By integrating with Calcite, GOpt provides a unified approach for
optimizing CGPs, combining proposed graph optimization tech-
niques with the relational optimization techniques already present
in Calcite. To build GIR, the graph operators are implemented as sub-
classes of the fundamental RelNode structure in Calcite to ensure
smooth integration, facilitating a cohesive optimization process for
both graph patterns and relational operations.
Rule-based Optimization. In GOpt, we employ the HepPlanner,
an RBO planner in Calcite, to implement our RBO techniques. De-
veloping new heuristic rules involves two primary steps: (1) define
a condition that determines the applicability of the rule, and (2)
specify an action that modifies the subplan when the condition
is met. For instance, in FilterIntoPattern, when a SELECT opera-
tor with filters targeting a tag associated with a graph operator is
identified (the condition), we move the filter expression into the
graph operator (the action). Furthermore, we incorporate Calcite’s
existing rules for relational operators into GOpt, thereby leveraging
the established relational optimizations.
Cost-based Optimization. We further adopt the VolcanoPlanner,
a CBO planner in Calcite, to implement the CBO techniques for pat-
terns. First, we introduce a new metadata provider, GraphMdQuery,
which provides metadata for both graph and relational operators.
For graph operators, we implement the handlers for RowCount using
GLogueQuery and for NonCumulativeCost using PhysicalSpec,
as detailed in Section 6.3, to deliver more accurate cardinality esti-
mates and backend-specific cost estimations. For relational opera-
tors, we leverage Calcite’s built-in metadata handlers. Then to opti-
mize the patterns, we implement PatternJoin through HashJoin, Ex-
pandInto (on Neo4j) and ExpandIntersect (on GraphScope), to sup-
port the hybrid join strategy. Leveraging these transformation rules,
the VolcanoPlanner can produce equivalent plan sets for patterns,
where each set includes all possible plans for a specific induced sub-
graph of the original pattern. After integrating GraphMdQuery and
registering PatternJoin into VolcanoPlanner, we invoke the CBO
process to optimize CGPs in a top-down manner. As the search pro-
gresses, the VolcanoPlanner consults GraphMdQuery for estimated
cardinalities and costs to calculate the total cost of the plan.
Remark 7.1. While optimizing CGPs, we encapsulate patterns within
a specialized relational SCAN operator, with its cost determined by the
pattern frequencies, which enables us to leverage Calcite’s built-in
metadata handlers and relational optimization rules to enhance the
relational components of CGPs. This approach allows GOpt to benefit
from Calcite’s robust relational optimization techniques. For example,
when executing a GROUP operator, Calcite’s AggregatePushDown rule
can help reduce intermediate results and improve efficiency.
Moreover, more sophisticated cost estimation is required for pat-
terns with filters after they are incorporated into patterns (as described
in FilterIntoPattern in Section 6.1). Currently, we followed [40] to pre-
define selectivity values (e.g., 0.1) for vertices and edges with filtering
conditions. In future work, we aim to integrate advanced selectivity
estimation techniques, such as histograms and sampling provided by
Calcite, to further improve optimizing patterns with filters.
Output Format. We use the Google Protocol Buffers (protobuf) [47]
to define the format of the physical plan output by GOpt. Proto-
buf provides a platform-independent format, enabling seamless

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
Table 3: The LDBC datasets.
Graph
|𝑉|
|𝐸|
Size
𝐺30
89M
541M
40GB
𝐺100
283M
1, 754M
156GB
𝐺300
817M
5, 269M
597GB
𝐺1000
2, 687M
17, 789M
1, 960GB
integration of GOpt with various backends. Specifically, we have
integrated GOpt into Alibaba’s GraphScope platform, allowing the
optimized physical plans to be executed on the distributed dataflow
engine Gaia [49] through a PhysicalConverter. This integration
enhances the efficiency and scalability of handling CGPs in Graph-
Scope. Similarly, we have also integrated GOpt into Neo4j to demon-
strate its compatibility and effectiveness in various graph systems.
8
Experiments
We conducted experiments to demonstrate the effectiveness of
the proposed optimization techniques in GOpt and its ability to
integrate with existing systems. These experiments showcase how
GOpt readily enables support for multiple query languages while
enhancing query processing performance.
8.1
Experiment Settings
Benchmarks. We utilized the Linked Data Benchmark Council
(LDBC) social network benchmark [41] to test GOpt. As shown
in Table 3, 4 datasets were generated using the official data gen-
erator, where 𝐺𝑠𝑓denotes the graph with scale factor 𝑠𝑓. As our
focus is on optimization techniques, we used the initial snapshot of
each dataset and did not account for dynamic updates. We adopted
the LDBC Interactive workloads 𝐼𝐶1...12, and Business Intelligence
workloads 𝐵𝐼1...14,16,17,18, excluding 𝐼𝐶13,14 and 𝐵𝐼15,19,20. These ex-
cluded queries either replies on built-in shortest-path algorithm
or stored procedures, and are not currently supported in Graph-
Scope. In addition, we designed three query sets: 𝑄𝑅1...8 to evaluate
heuristic rules, 𝑄𝑇1...5 to test type inference, and 𝑄𝐶1...4(𝑎|𝑏) to
assess CBO. All the queries can be found in [9]. By default, these
queries were implemented in Cypher, with LDBC workloads using
the official Cypher implementations [26]. Certain queries written in
Gremlin were manually translated from their Cypher counterparts.
Compared Systems. We conducted experiments on two systems:
(1) GraphScope v0.29.0 [4], a distributed graph system supporting
Gremlin queries. It optimizes queries using a rule-based optimizer
and executes them on the distributed dataflow engine Gaia [49].
(2) Neo4j v4.4.9 [7], a widely used graph database supporting Cypher
queries. It optimizes queries using its CypherPlanner, which em-
ploys heuristic rules and cost-based optimization, and runs on a
single machine using Neo4j’s interpreted runtime.
For each query, we highlight the following three execution plans:
• GOpt-plan: The optimized plan generated by GOpt. Note that
the GOpt-plans for running on Neo4j and GraphScope may be
different due to the PhysicalSpec (Section 6.3).
• Neo4j-plan: The optimized plans generated by Neo4j’s optimizer
CypherPlanner. Although Neo4j’s execution engine may not be
the most competitive, its optimizer remains as a strong baseline,
being one of the most well-developed in the community.
Configurations. We conducted tests on a cluster of up to 16 ma-
chines, each with dual 8-core Intel Xeon E5-2620 v4 CPUs at 2.1GHz,
512GB memory, and a 10Gbps network. To avoid disk I/O effects, all
QR1
QR2
QR3
QR4
QR5
QR6
QR7
QR8
10
2
10
1
100
101
102
103
OT
Runtime (s)
WithOpt
NoOpt
(a) Heuristic Rules
QT1
QT2
QT3
QT4
QT5
100
101
102
103
OT
WithOpt
NoOpt
(b) Type Inference
QC1a
QC1b
QC2a
QC2b
QC3a
QC3b
QC4a
QC4b
100
101
102
103
Runtime (s)
OT
GOpt-Plan
GOpt-Neo-Plan
Others
(c) CBO
QC1a
QC1b
QC2a
QC2b
QC3a
QC3b
QC4a
QC4b
100
101
102
103
High-order Stats
Low-order Stats
(d) Cardinality Estimation
QR1
QR2
QR3
QR4
QR5
QR6
QR7
QR8
QC1a
QC1b
QC2a
QC2b
QC3a
QC3b
QC4a
QC4b
10
2
10
1
100
101
102
103
OT
Runtime (s)
GOpt-Plan
GS-Plan
(e) Optimizing Gremlin queries on GraphScope
Figure 8: Results of Micro Benchmarks on GraphScope.
graph data was stored in memory. For the distributed experiments
on GraphScope, vertices and properties were randomly assigned
to machines, while edges and properties were placed on machines
hosting their source and destination vertices. We excluded query
parsing and optimization time from our analysis due to its minimal
impact on runtime. Queries exceeding 1 hour were marked as OT.
8.2
Micro Benchmarks
We evaluated the effectiveness of GOpt ’s individual optimization
techniques in Section 6, namely heuristic rules, type inference, and
cost-based optimizations. To demonstrate GOpt’s capability in opti-
mizing different query languages, we further write queries in Grem-
lin, and compared the performance of GS-plans with GOpt-plans.
The experiments were conducted on 𝐺30 using a single machine
with 32 threads, with the queries executed on GraphScope. Other
than the “Optimizing Gremlin Queries” test, where all GOpt op-
timization techniques were applied, we conducted controlled ex-
periments to isolate the effects of specific techniques. For example,
when evaluating heuristic rules, we ensured that the queries in-
cluded only explicit types and disabled type checker and CBO to
prevent interference from other techniques.
Heuristic Rules. To evaluate the heuristic rules, we compared
performance with and without their application. As shown in
Fig. 8(a), FilterIntoPattern (𝑄𝑅1,2) demonstrated the most signifi-
cant impact, improving performance by orders of magnitude. Field-
Trim (𝑄𝑅3,4) achieved an average performance improvement of
4.8×, JoinToPattern (𝑄𝑅5,6) enhanced performance by 40.2×, and
the ComSubPattern (𝑄𝑅7,8) achieved a 34.3× improvement. These
findings, particularly the substantial gains achieved with the Filter-
IntoPattern, underscore the importance of GIR, which facilitates the
effective co-optimization between pattens and relational operators.

---

A Modular Graph-Native Query Optimization Framework
Type Inference. We tested the impact of type inference by compar-
ing query execution performance with it enabled versus disabled on
queries without explicit type constraints. As illustrated in Fig. 8(b),
type inference consistently accelerates all queries, with an average
speedup of 51×. Notably, 𝑄𝑇2 achieves a 209× improvement, thanks
to GOpt’s capability to infer type constraints, thereby avoiding
unnecessary traversal of irrelevant vertices and edges.
Cost-based Optimization. We tested CBO using 𝑄𝐶1...4(𝑎|𝑏), fo-
cusing on pattern matching for a triangle, a square, a 5-path, and a
complex pattern consists of 7 vertices and 8 edges. Each query has
two variants: 𝑎for queries with BasicTypes and 𝑏with UnionTypes.
For performance comparison, we designed up to 12 unique execu-
tion plans for each query, including: one GOpt-plan (marked with
“×”); one GOpt-Neo-Plan (marked with “Δ”), which is generated
by GOpt with deliberate computation of the cost of ExpandInter-
sect using Neo4j’s cost of ExpandInto; and up to 10 randomly gen-
erated plans (marked with red “◦”). As shown in Fig. 8(c), the results
highlight the vital role of CBO in pattern processing and demon-
strate GOpt’s effectiveness in utilizing backend-specific cost estima-
tion. The GOpt-plan consistently outperformed, averaging 14.4×
faster than GOpt-Neo-Plan, thanks to GOpt’s PhysicalSpec en-
abling backend-specific costs. This comparison underscores the
importance of using a cost model tailored to the backend system,
as mismatched models can result in suboptimal plans. Additionally,
GOpt’s plan was 117.8× faster the average of the randomized plans.
While GOpt may not always achieve the absolute best performance
due to its reliance on estimated costs, it generally performs close
to the optimal, demonstrating robustness and reliability.
We further evaluated the effectiveness of GOpt’s cardinality
estimation method by comparing the performance of GOpt-plans
utilizing GLogueQuery, which incorporates high-order statistics,
against those relying solely on low-order statistics. The results
in Fig. 8(d) show that, for 3 out of 8 queries, the plans utilizing
high-order statistics achieved better performance, with an aver-
age speedup of 13.1× across these three queries. High-order statis-
tics were particularly effective for complex patterns such as 𝑄𝐶4𝑎,
where the plan utilizing high-order statistics was 31.9× faster.
Optimizing Gremlin Queries. We wrote the queries in Gremlin,
enabling GraphScope to generate GS-plans using its native rule-
based optimizer and GOpt-plans after integrating GOpt. We com-
pared the execution performance of GS-plans versus GOpt-plans on
GraphScope, focusing on 𝑄𝑅and 𝑄𝐶queries, excluding 𝑄𝑇queries
due to GraphScope’s lack of type inference. As shown in Fig. 8(e),
for 𝑄𝑅queries testing heuristic rules, GOpt-plan outperformed GS-
plan on most queries (except for𝑄𝑅5 and𝑄𝑅6, which test JoinToPat-
tern, also supported by GraphScope’s native optimizer), with an
average speedup of 13.3×, even achieving significant improvements
in 𝑄𝑅2 where GS-plan runs OT. This demonstrates the effectiveness
of GOpt’s new heuristic rules. For 𝑄𝐶queries, GS-plan adhered to
user-specified orders, most running OT, whereas GOpt-plan, utiliz-
ing cost-based optimization techniques with improved cardinality
and cost estimation, produced more efficient search orders and
achieved an average speedup of 243.4×. Since GS-plans frequently
result in suboptimal query plans, we excluded them from further
comparisons in the subsequent experiments. These results demon-
strate that integrating GOpt into GraphScope can immediately
IC1
IC2
IC3
IC4
IC5
IC6
IC7
IC8
IC9
IC10
IC11
IC12
BI1
BI2
BI3
BI4
BI5
BI6
BI7
BI8
BI9
BI10
BI11
BI12
BI13
BI14
BI16
BI17
BI18
10
2
10
1
100
101
102
103
OT
Neo4j Runtime (s)
Neo4j-plan
GOpt-plan
(a) Time Cost of LDBC Queries on Neo4j
IC1
IC2
IC3
IC4
IC5
IC6
IC7
IC8
IC9
IC10
IC11
IC12
BI1
BI2
BI3
BI4
BI5
BI6
BI7
BI8
BI9
BI10
BI11
BI12
BI13
BI14
BI16
BI17
BI18
10
2
10
1
100
101
102
103
OT
GraphScope Runtime (s)
(b) Time Cost of LDBC Queries on GraphScope
Figure 9: Results of Comprehensive Experiments.
enhance its performance for executing Gremlin queries. Moreover,
GOpt extends GraphScope by enabling support for Cypher queries.
8.3
Comprehensive Experiments
In this subsection, we compare GOpt with Neo4j’s CypherPlan-
ner by testing GOpt-plans and Neo4j-plans on both Neo4j and
GraphScope. This comparison highlights GOpt’s advanced opti-
mization techniques and its ability to utilize backend-specific oper-
ators for superior performance. Experiments were conducted on
𝐺100 using a single machine with 32 threads, as Neo4j supports only
single-machine deployment. For fairness, we explicitly specify all
type constraints in the queries, given Neo4j’s schema-loose design
and lack of type inference support in its optimizer.
Neo4j-plan v.s. GOpt-plan on Neo4j. We began by comparing
the performance of executing the Neo4j-plan and GOpt-plan on
Neo4j. The results in Fig. 9(a) reveal that GOpt-plan outperforms
Neo4j-plan in 16 out of 29 queries, with an average speedup of
15.8× across these queries, and 9.2× overall. This enhancement
is primarily due to GOpt’s advanced optimization techniques. In
𝐼𝐶6, GOpt achieves the most significant improvement by 48.6× by
employing a hybrid-join strategy, whereas Neo4j relies on multi-
ple Expand, causing excessive intermediate results. In 𝐼𝐶10, 𝐵𝐼10
and 𝐵𝐼18, where Neo4j-plan runs OT, GS-plan optimizes the search
order with more precise cost estimation, reducing intermediate
results and enhancing performance. Additionally, in 𝐼𝐶9 and 𝐵𝐼13,
GS-plan utilizes the AggregatePushDown rule from Calcite, which
pushes aggregation operations earlier to reduce intermediate re-
sults, a feature not supported by CypherPlanner. Due to the space
limit, we will provide a detailed technical report to explain the
performance gains of GOpt over CypherPlanner for each query.
Overall, these experiments highlight the efficacy of GOpt’s opti-
mization techniques in improving query processing in Neo4j.
Neo4j-plan v.s. GOpt-plan on GraphScope. We further com-
pared the performance of the two plans on GraphScope. Note that
we manually translated Neo4j-plans into GraphScope-compatible
versions to run on GraphScope. As shown in Fig. 9(b), GOpt-
plan outperformed Neo4j-plan in 17 out of 29 queries, with an
average speedup of 56.2× and 33.4× overall, the most significant
being 78.7× in 𝐼𝐶6. This improvement is more pronounced than
on Neo4j, as GOpt enables the registration of optimized physical

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
IC1
IC2
IC3
IC4
IC5
IC6
IC7
IC8
IC9
IC10
IC11
IC12
100
101
102
Runtime (s)
G30
G100
G300
G1000
(a) Data Scale of 𝐼𝐶queries on GraphScope
BI1
BI2
BI3
BI4
BI5
BI6
BI7
BI8
BI9
BI10
BI11
BI12
BI13
BI14
BI16
BI17
BI18
100
101
102
103
Runtime (s)
(b) Data Scale of 𝐵𝐼queries on GraphScope
Figure 10: Results of Data Scale Experiments.
ST1
ST2
ST3
ST4
ST5
100
101
102
103
Runtime (s)
(2,4)
(4,2)
(3,3)
(3,3)
(3,3)
(6,0)
(6,0)
(6,0)
(6,0)
(6,0)
(3,3)
(3,3)
(4,2)
(4,2)
(4,2)
(4,2)
(2,4)
(2,4)
(2,4)
(2,4)
OT
GOpt-plan
Neo4j-plan
Alt-plan1
Alt-plan2
Figure 11: Performance of S-T Paths.
operators like ExpandIntersect in GraphScope via PhysicalSpec.
For example, in the cyclic pattern query 𝐼𝐶5, both plans use Ex-
pandInto on Neo4j and show similar performance. However, on
GraphScope, GOpt-plan selects the more efficient ExpandInter-
sect, achieving a 3.6× speedup, whereas Neo4j-plan sticks with
ExpandInto, executed as a Expand followed by Select. Other opti-
mized queries also show improved performance on GraphScope for
similar reasons, additionally benefiting from the efficient Expand-
Intersect. Overall, these results underscore the effectiveness of
GOpt’s optimization techniques in enhancing query processing on
GraphScope.
8.4
Data Scale Experiments
We also tested the scalability of GraphScope integrated with GOpt,
which supports distributed execution via Gaia, on a cluster of 16
machines, each equipped with 2 threads. We conducted 𝐼𝐶and 𝐵𝐼
queries across various dataset sizes. For 𝐼𝐶queries, we randomly
selected 8 parameter values per query, aggregating their runtimes
to obtain a representative query runtime and mitigate bias from
short execution times. Fig. 10(a) shows the scalability results for 𝐼𝐶
queries. When the graph size increases by 30×, from 𝐺30 to 𝐺1000,
the runtime for the most impacted query (𝐼𝐶9) increases by 20.0×,
while the average performance degradation is only 6.3×, which is
impressive given the substantial data scale. Fig. 10(b) presents the
results for 𝐵𝐼queries, demonstrating effective scalability with the
growth of graph data. As the graph size increases from 𝐺30 to 𝐺1000,
the average performance degradation is 30.4×. This is expected, as
𝐵𝐼queries are typically more complex, causing intermediate results
to grow steadily with the graph size. These findings highlight the
importance of effective query optimization, particularly the CBO,
in preventing poor search orders that could generate intermediate
results exponentially proportional to the graph size.
8.5
Case Study
GOpt with GraphScope backend is widely deployed in production
at Alibaba. This case study focuses on its application in fraud de-
tection. Fraudsters transfer funds through multiple intermediaries
before another fraudster withdraws the money. This problem can be
described as an s-t path in CGP, with the Cypher query as follows:
MATCH (p1:PERSON)-[p:*$k]->(p2:PERSON)
WHERE p1.id IN $S1 and p2.id IN $S2
RETURN p
Finding such paths in large graphs is challenging due to the ex-
plosion of intermediate results. Two strategies are common: (1)
single-direction expansion, expanding 𝑘hops from 𝑆1 and filter-
ing ends in 𝑆2; (2) bidirectional search, starting from 𝑆1 and 𝑆2
simultaneously, joining sub-paths when they meet in the middle.
Bidirectional search is generally more efficient, but is the middle
vertex in the path always the best choice for the join? Our case
study shows that it is not always true.
We conducted experiments on a real-world graph with 3.6 billion
vertices and 21.8 billion edges. We set 𝑘= 6 and created five queries
𝑆𝑇1...5, each with distinct pairs of (𝑆1,𝑆2) values randomly obtained
from real applications. For each query, we generated Neo4j-plan and
two alternatives that have different search orders to compare with
GOpt-plan. The results, shown in Fig. 11, indicate the path join po-
sitions above each bar. For example, (2, 4) means a 2-hop sub-path
from 𝑆1 joins with a 4-hop sub-path from 𝑆2, while all Neo4j-plans
execute single-direction expansion from 𝑆1 to 𝑆2. GOpt-plans out-
perform all alternatives from 3× to 20×, whereas all single-direction
plans run OT. In GOpt-plans, the join position does not always lie
at the center, as seen in 𝑆𝑇1 and 𝑆𝑇2, due to the varying number of
source vertices in 𝑆1 and 𝑆2 in real queries. By properly configuring
the costs for scans (now they are the number of vertices in the
source sets), GOpt’s CBO can automatically determine the opti-
mal join positions. This demonstrate the effectiveness of GOpt in
optimizing CGPs in real-world applications.
9
Conclusion
In this paper, we present GOpt, a modular, graph-native query
optimization framework for CGPs, which combine patterns and re-
lational operations. CGPs can be expressed in multiple graph query
languages and executed on various backends, necessitating a unified
optimization approach. GOpt addresses this need by employing a
unified GIR, and using a GraphIrBuilder to translate queries from
diverse languages into this GIR, facilitating advanced optimization
techniques. To optimize CGPs, GOpt utilizes comprehensive heuris-
tic rules to refine the interactions between patterns and relational
operations. It also includes an automatic type inference algorithm
to uncover implicit type constraints in query patterns, and employs
CBO techniques for further refinement. During the CBO process,
GOpt offers a PhysicalSpec, allowing backends to register custom
physical operators and cost models, enabling more accurate cost
estimation. Extensive experiments demonstrate that GOpt signifi-
cantly improves query performance compared to state-of-the-art
systems in both synthetic benchmarks and real-world applications.

---

A Modular Graph-Native Query Optimization Framework
References
[1] 2024. ANTLR: ANother Tool for Language Recognition. https://www.antlr.org/
[2] 2024. Artifacts for the paper and experiments. https://github.com/GraphScope/
GOpt-Artifact
[3] 2024. GOpt’s open-source project on GitHub.
https://github.com/alibaba/
GraphScope/tree/main/interactive_engine/compiler
[4] 2024. GraphScope’s open-source project on GitHub. https://github.com/alibaba/
GraphScope
[5] 2024. Information technology — Database languages — GQL. https://www.iso.
org/standard/76120.html
[6] 2024. JanusGraph: A Transactional Graph Database. https://janusgraph.org/
[7] 2024. Neo4j Graph Database. https://neo4j.com/.
[8] 2024. OrientDB. https://orientdb.com/
[9] 2024. Queries used for the experiments. https://github.com/alibaba/GraphScope/
tree/main/interactive_engine/benchmark/queries/cypher_queries/experiments
[10] 2024. RDF Primer. https://www.w3.org/TR/rdf-primer/
[11] 2024. SPARQL Query Language for RDF. https://www.w3.org/TR/rdf-sparql-
query/
[12] 2024. TigerGraph: Graph Analytics Platform. https://www.tigergraph.com/
[13] 2024. Viewing schema data with APOC Procedures in Neo4j. https://neo4j.com/
docs/apoc/current/overview/apoc.schema/
[14] Christopher R Aberger, Andrew Lamb, Susan Tu, Andres Nötzli, Kunle Olukotun,
and Christopher Ré. 2017. Emptyheaded: A relational engine for graph processing.
ACM Transactions on Database Systems (TODS) 42, 4 (2017), 1–44.
[15] Khaled Ammar, Frank McSherry, Semih Salihoglu, and Manas Joglekar. 2018.
Distributed Evaluation of Subgraph Queries Using Worst-Case Optimal Low-
Memory Dataflows. Proc. VLDB Endow. 11, 6 (oct 2018), 691–704. https://doi.
org/10.14778/3184470.3184473
[16] Renzo Angles. 2018. The Property Graph Database Model. In Alberto Mendelzon
Workshop on Foundations of Data Management. https://api.semanticscholar.org/
CorpusID:43977243
[17] Renzo Angles, Marcelo Arenas, Pablo Barcelo, Peter Boncz, George Fletcher,
Claudio Gutierrez, Tobias Lindaaker, Marcus Paradies, Stefan Plantikow, Juan
Sequeda, Oskar van Rest, and Hannes Voigt. 2018. G-CORE: A Core for Future
Graph Query Languages. In Proceedings of the 2018 International Conference
on Management of Data (Houston, TX, USA) (SIGMOD ’18). Association for
Computing Machinery, New York, NY, USA, 1421–1432. https://doi.org/10.1145/
3183713.3190654
[18] Renzo Angles, Marcelo Arenas, Pablo Barceló, Aidan Hogan, Juan Reutter, and
Domagoj Vrgoč. 2017. Foundations of Modern Query Languages for Graph
Databases. ACM Comput. Surv. 50, 5, Article 68 (sep 2017), 40 pages.
https:
//doi.org/10.1145/3104031
[19] Renzo Angles, Angela Bonifati, Stefania Dumbrava, George Fletcher, Alastair
Green, Jan Hidders, Bei Li, Leonid Libkin, Victor Marsault, Wim Martens, Filip
Murlak, Stefan Plantikow, Ognjen Savkovic, Michael Schmidt, Juan Sequeda,
Slawek Staworko, Dominik Tomaszuk, Hannes Voigt, Domagoj Vrgoc, Mingxi
Wu, and Dusan Zivkovic. 2023. PG-Schema: Schemas for Property Graphs.
Proceedings of the ACM on Management of Data 1, 2 (June 2023), 1–25. https:
//doi.org/10.1145/3589778
[20] AWS Neptune. 2024. https://aws.amazon.com/neptune/.
[21] Edmon Begoli, Jesús Camacho-Rodríguez, Julian Hyde, Michael J. Mior, and
Daniel Lemire. 2018. Apache Calcite: A Foundational Framework for Optimized
Query Processing Over Heterogeneous Data Sources. In Proceedings of the 2018
International Conference on Management of Data (SIGMOD/PODS ’18). ACM.
https://doi.org/10.1145/3183713.3190662
[22] Fei Bi, Lijun Chang, Xuemin Lin, Lu Qin, and Wenjie Zhang. 2016. Efficient
subgraph matching by postponing cartesian products. In Proceedings of the 2016
International Conference on Management of Data. 1199–1214.
[23] Angela Bonifati, Stefania-Gabriela Dumbrava, Emile Martinez, Fatemeh Ghasemi,
Malo Jaffré, Pacome Luton, and Thomas Pickles. 2022. DiscoPG: Property Graph
Schema Discovery and Exploration. Proc. VLDB Endow. 15, 12 (2022), 3654–3657.
[24] Mario Cannataro, Pietro Hiram Guzzi, and Pierangelo Veltri. 2010. Protein-to-
protein interactions: Technologies, databases, and algorithms. ACM Comput.
Surv. 43, 1 (2010), 1:1–1:36. https://doi.org/10.1145/1824795.1824796
[25] Cypher For Gremlin. 2024. https://github.com/opencypher/cypher-for-gremlin.
[Online; accessed 24-December-2024].
[26] Cypher Implementations of LDBC Social Network Benchmark. 2024.
https://github.com/ldbc/ldbc_snb_interactive_v1_impls/. [Online; accessed 24-
December-2024].
[27] Alin Deutsch, Yu Xu, Mingxi Wu, and Victor E. Lee. 2020. Aggregation Support for
Modern Graph Analytics in TigerGraph. In Proceedings of the 2020 ACM SIGMOD
International Conference on Management of Data (Portland, OR, USA) (SIGMOD
’20). Association for Computing Machinery, New York, NY, USA, 377–392. https:
//doi.org/10.1145/3318464.3386144
[28] Wenfei Fan, Tao He, Longbin Lai, Xue Li, Yong Li, Zhao Li, Zhengping Qian,
Chao Tian, Lei Wang, Jingbo Xu, Youyang Yao, Qiang Yin, Wenyuan Yu, Jingren
Zhou, Diwen Zhu, and Rong Zhu. 2021. GraphScope: A Unified Engine for Big
Graph Processing. Proc. VLDB Endow. 14, 12 (jul 2021), 2879–2892.
[29] Gary William Flake, Steve Lawrence, C Lee Giles, and Frans M Coetzee. 2002.
Self-organization and identification of web communities. Computer 35, 3 (2002),
66–70.
[30] Nadime Francis, Alastair Green, Paolo Guagliardo, Leonid Libkin, Tobias Lin-
daaker, Victor Marsault, Stefan Plantikow, Mats Rydberg, Petra Selmer, and
Andrés Taylor. 2018. Cypher: An evolving query language for property graphs.
In Proceedings of the 2018 International Conference on Management of Data. 1433–
1445.
[31] Benoit Gaüzère, Luc Brun, and Didier Villemin. 2015. Graph kernels in chemoin-
formatics. In Quantitative Graph TheoryMathematical Foundations and Applica-
tions, Matthias Dehmer and Frank Emmert-Streib (Eds.). CRC Press, 425–470.
https://hal.archives-ouvertes.fr/hal-01201933
[32] Wook-Shin Han, Jinsoo Lee, and Jeong-Hoon Lee. 2013. Turboiso: Towards Ul-
trafast and Robust Subgraph Isomorphism Search in Large Graph Databases. In
Proceedings of the 2013 ACM SIGMOD International Conference on Management of
Data (New York, New York, USA) (SIGMOD ’13). Association for Computing Ma-
chinery, New York, NY, USA, 337–348. https://doi.org/10.1145/2463676.2465300
[33] Mohamed S. Hassan, Tatiana Kuznetsova, Hyun Chai Jeong, Walid G. Aref,
and Mohammad Sadoghi. 2018. GRFusion: Graphs as First-Class Citizens in
Main-Memory Relational Database Systems. In Proceedings of the 2018 Inter-
national Conference on Management of Data (Houston, TX, USA) (SIGMOD
’18). Association for Computing Machinery, New York, NY, USA, 1789–1792.
https://doi.org/10.1145/3183713.3193541
[34] Tao He, Shuxian Hu, Longbin Lai, Dongze Li, Neng Li, Xue Li, Lexiao Liu,
Xiaojian Luo, Bingqing Lyu, Ke Meng, Sijie Shen, Li Su, Lei Wang, Jingbo Xu,
Wenyuan Yu, Weibin Zeng, Lei Zhang, Siyuan Zhang, Jingren Zhou, Xiaoli
Zhou, and Diwen Zhu. 2024. GraphScope Flex: LEGO-like Graph Computing
Stack. In Companion of the 2024 International Conference on Management of
Data, SIGMOD/PODS 2024, Santiago AA, Chile, June 9-15, 2024, Pablo Barceló,
Nayat Sánchez-Pi, Alexandra Meliou, and S. Sudarshan (Eds.). ACM, 386–399.
https://doi.org/10.1145/3626246.3653383
[35] Yanqing Hu, Shenggong Ji, Yuliang Jin, Ling Feng, H. Eugene Stanley, and Shlomo
Havlin. 2018. Local structure can identify and quantify influential global spread-
ers in large scale social networks.
Proceedings of the National Academy of
Sciences 115, 29 (2018), 7468–7472.
https://doi.org/10.1073/pnas.1710547115
arXiv:https://www.pnas.org/doi/pdf/10.1073/pnas.1710547115
[36] Guodong Jin and Semih Salihoglu. 2022. Making RDBMSs Efficient on Graph
Workloads through Predefined Joins.
Proc. VLDB Endow. 15, 5 (jan 2022),
1011–1023. https://doi.org/10.14778/3510397.3510400
[37] Chathura Kankanamge, Siddhartha Sahu, Amine Mhedhbi, Jeremy Chen, and
Semih Salihoglu. 2017. Graphflow: An Active Graph Database. In Proceedings
of the 2017 ACM International Conference on Management of Data, SIGMOD
Conference 2017, Chicago, IL, USA, May 14-19, 2017, Semih Salihoglu, Wenchao
Zhou, Rada Chirkova, Jun Yang, and Dan Suciu (Eds.). ACM, 1695–1698. https:
//doi.org/10.1145/3035918.3056445
[38] Longbin Lai, Lu Qin, Xuemin Lin, and Lijun Chang. 2015. Scalable subgraph
enumeration in mapreduce. Proceedings of the VLDB Endowment 8, 10 (2015),
974–985.
[39] Longbin Lai, Zhu Qing, Zhengyi Yang, Xin Jin, Zhengmin Lai, Ran Wang,
Kongzhang Hao, Xuemin Lin, Lu Qin, Wenjie Zhang, et al. 2019. Distributed
subgraph matching on timely dataflow. Proceedings of the VLDB Endowment 12,
10 (2019), 1099–1112.
[40] Longbin Lai, Yufan Yang, Zhibin Wang, Yuxuan Liu, Haotian Ma, Sijie Shen,
Bingqing Lyu, Xiaoli Zhou, Wenyuan Yu, Zhengping Qian, Chen Tian, Sheng
Zhong, Yeh-Ching Chung, and Jingren Zhou. 2023. GLogS: Interactive Graph
Pattern Matching Query At Large Scale. In 2023 USENIX Annual Technical Con-
ference (USENIX ATC 23). USENIX Association, Boston, MA, 53–69.
https:
//www.usenix.org/conference/atc23/presentation/lai
[41] LDBC Social Network Benchmark. 2022. https://ldbcouncil.org/benchmarks/snb/.
[Online; accessed 20-October-2022].
[42] Yunkai Lou, Longbin Lai, Bingqing Lyu, Yufan Yang, Xiaoli Zhou, Wenyuan Yu,
Ying Zhang, and Jingren Zhou. 2024. Towards a Converged Relational-Graph
Optimization Framework. arXiv:2408.13480 [cs.DB] https://arxiv.org/abs/2408.
13480
[43] Marios Meimaris and George Papastefanatos. 2017. Distance-Based Triple Re-
ordering for SPARQL Query Optimization. In 2017 IEEE 33rd International Con-
ference on Data Engineering (ICDE). 1559–1562. https://doi.org/10.1109/ICDE.
2017.227
[44] Lingkai Meng, Yu Shao, Long Yuan, Longbin Lai, Peng Cheng, Xue Li, Wenyuan
Yu, Wenjie Zhang, Xuemin Lin, and Jingren Zhou. 2024. A survey of distributed
graph algorithms on massive graphs. Comput. Surveys 57, 2 (2024), 1–39.
[45] Amine Mhedhbi and Semih Salihoglu. 2019. Optimizing subgraph queries by
combining binary and worst-case optimal joins. arXiv preprint arXiv:1903.02076
(2019).
[46] Hung Q Ngo, Ely Porat, Christopher Ré, and Atri Rudra. 2018. Worst-case optimal
join algorithms. Journal of the ACM (JACM) 65, 3 (2018), 1–40.
[47] Protocol Buffers. 2024. https://protobuf.dev/overview/.

---

Bingqing Lyu, Xiaoli Zhou, Longbin Lai, Yufan Yang, Yunkai Lou, Wenyuan Yu, Ying Zhang‡, Jingren Zhou
[48] N Pržulj, Derek G Corneil, and Igor Jurisica. 2006. Efficient estimation of graphlet
frequency distributions in protein–protein interaction networks. Bioinformatics
22, 8 (2006), 974–980.
[49] Zhengping Qian, Chenqiang Min, Longbin Lai, Yong Fang, Gaofeng Li, Youyang
Yao, Bingqing Lyu, Xiaoli Zhou, Zhimin Chen, and Jingren Zhou. 2021. GAIA:
A System for Interactive Analysis on Distributed Graphs Using a High-Level
Language. In 18th USENIX Symposium on Networked Systems Design and Imple-
mentation (NSDI 21). USENIX Association, 321–335. https://www.usenix.org/
conference/nsdi21/presentation/qian-zhengping
[50] Kashif Rabbani, Matteo Lissandrini, and Katja Hose. 2021. Optimizing SPARQL
Queries using Shape Statistics. In Proceedings of the 24th International Conference
on Extending Database Technology, EDBT 2021, Nicosia, Cyprus, March 23 - 26,
2021, Yannis Velegrakis, Demetris Zeinalipour-Yazti, Panos K. Chrysanthis, and
Francesco Guerra (Eds.). OpenProceedings.org, 505–510. https://doi.org/10.5441/
002/EDBT.2021.59
[51] Marko A. Rodriguez. 2015. The Gremlin Graph Traversal Machine and Language
(Invited Talk). In Proceedings of the 15th Symposium on Database Programming
Languages (Pittsburgh, PA, USA) (DBPL 2015). Association for Computing Ma-
chinery, New York, NY, USA, 1–10. https://doi.org/10.1145/2815072.2815073
[52] Haichuan Shang, Ying Zhang, Xuemin Lin, and Jeffrey Xu Yu. 2008. Taming
Verification Hardness: An Efficient Algorithm for Testing Subgraph Isomorphism.
Proc. VLDB Endow. 1, 1 (aug 2008), 364–375. https://doi.org/10.14778/1453856.
1453899
[53] Benjamin A. Steer, Alhamza Alnaimi, Marco A. B. F. G. Lotz, Félix Cuadrado,
Luis M. Vaquero, and Joan Varvenne. 2017.
Cytosm: Declarative Prop-
erty Graph Queries Without Data Migration. In Proceedings of the Fifth
International Workshop on Graph Data-management Experiences & Systems,
GRADES@SIGMOD/PODS 2017, Chicago, IL, USA, May 14 - 19, 2017, Peter A.
Boncz and Josep Lluís Larriba-Pey (Eds.). ACM, 4:1–4:6. https://doi.org/10.1145/
3078447.3078451
[54] Markus Stocker, Andy Seaborne, Abraham Bernstein, Christoph Kiefer, and Dave
Reynolds. 2008. SPARQL basic graph pattern optimization using selectivity
estimation. In Proceedings of the 17th International Conference on World Wide
Web, WWW 2008, Beijing, China, April 21-25, 2008, Jinpeng Huai, Robin Chen,
Hsiao-Wuen Hon, Yunhao Liu, Wei-Ying Ma, Andrew Tomkins, and Xiaodong
Zhang (Eds.). ACM, 595–604. https://doi.org/10.1145/1367497.1367578
[55] Wen Sun, Achille Fokoue, Kavitha Srinivas, Anastasios Kementsietsidis, Gang
Hu, and Guo Tong Xie. 2015. SQLGraph: An Efficient Relational-Based Property
Graph Store. In Proceedings of the 2015 ACM SIGMOD International Conference
on Management of Data, Melbourne, Victoria, Australia, May 31 - June 4, 2015,
Timos K. Sellis, Susan B. Davidson, and Zachary G. Ives (Eds.). ACM, 1887–1901.
https://doi.org/10.1145/2723372.2723732
[56] Gábor Szárnyas, József Marton, János Maginecz, and Dániel Varró. 2018. Reducing
Property Graph Queries to Relational Algebra for Incremental View Maintenance.
ArXiv abs/1806.07344 (2018). https://api.semanticscholar.org/CorpusID:49313167
[57] Yuanyuan Tian, En Liang Xu, Wei Zhao, Mir Hamid Pirahesh, Suijun Tong,
Wen Sun, Thomas Kolanko, Md. Shahidul Haque Apu, and Huijuan Peng. 2020.
IBM Db2 Graph: Supporting Synergistic and Retrofittable Graph Queries Inside
IBM Db2. In Proceedings of the 2020 International Conference on Management of
Data, SIGMOD Conference 2020, online conference [Portland, OR, USA], June 14-19,
2020, David Maier, Rachel Pottinger, AnHai Doan, Wang-Chiew Tan, Abdussalam
Alawini, and Hung Q. Ngo (Eds.). ACM, 345–359. https://doi.org/10.1145/3318464.
3386138
[58] Petros Tsialiamanis, Lefteris Sidirourgos, Irini Fundulaki, Vassilis Christophides,
and Peter A. Boncz. 2012. Heuristics-based query optimisation for SPARQL.
In 15th International Conference on Extending Database Technology, EDBT ’12,
Berlin, Germany, March 27-30, 2012, Proceedings, Elke A. Rundensteiner, Volker
Markl, Ioana Manolescu, Sihem Amer-Yahia, Felix Naumann, and Ismail Ari
(Eds.). ACM, 324–335. https://doi.org/10.1145/2247596.2247635
[59] Julian R Ullmann. 1976. An algorithm for subgraph isomorphism. Journal of the
ACM (JACM) 23, 1 (1976), 31–42.
[60] Oskar van Rest, Sungpack Hong, Jinha Kim, Xuming Meng, and Hassan Chafi.
2016. PGQL: A Property Graph Query Language. In Proceedings of the Fourth
International Workshop on Graph Data Management Experiences and Systems (Red-
wood Shores, California) (GRADES ’16). Association for Computing Machinery,
New York, NY, USA, Article 7, 6 pages. https://doi.org/10.1145/2960414.2960421
[61] Zhengyi Yang, Longbin Lai, Xuemin Lin, Kongzhang Hao, and Wenjie Zhang.
2021. Huge: An efficient and scalable subgraph enumeration system. In Proceed-
ings of the 2021 International Conference on Management of Data. 2049–2062.
[62] Qian Zhu, Jianhua Yao, Shengang Yuan, Feng Li, Haifeng Chen, Wei Cai, and Quan
Liao. 2005. Superstructure Searching Algorithm for Generic Reaction Retrieval.
J. Chem. Inf. Model. 45, 5 (2005), 1214–1222. https://doi.org/10.1021/CI0496402

---

