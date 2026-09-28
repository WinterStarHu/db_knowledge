# JEDI: These aren&#39;t the JSON documents you&#39;re looking for... (Extended Ve

> 来源: https://arxiv.org/pdf/2201.08099

JEDI: These aren't the JSON documents you're looking for...
(Extended Version*)
Thomas Hütter
Nikolaus Augsten
thomas.huetter@plus.ac.at
nikolaus.augsten@plus.ac.at
University of Salzburg
Austria
Christoph M. Kirsch
ck@cs.uni-salzburg.at
University of Salzburg
Austria
Czech Technical University
Czech Republic
Michael J. Carey
Chen Li
mjcarey@ics.uci.edu
chenli@ics.uci.edu
University of California, Irvine
USA
ABSTRACT
The JavaScript Object Notation (JSON) is a popular data format used
in document stores to natively support semi-structured data. In this
paper, we address the problem of JSON similarity lookup queries:
given a query document and a distance threshold 𝜏, retrieve all
JSON documents that are within 𝜏from the query document. Due
to its recursive definition, JSON data are naturally represented as
trees. Different from other hierarchical formats such as XML, JSON
supports both ordered and unordered sibling collections within a
single document. This feature poses a new challenge to the tree
model and distance computation. We propose JSON tree, a lossless
tree representation of JSON documents, and define the JSON Edit
Distance (JEDI), the first edit-based distance measure for JSON
documents. We develop an algorithm, called QuickJEDI, for com-
puting JEDI by leveraging a new technique to prune expensive
sibling matchings. It outperforms a baseline algorithm by an or-
der of magnitude in runtime. To boost the performance of JSON
similarity queries, we introduce an index called JSIM and a highly
effective upper bound based on tree sorting. Our algorithm for the
upper bound runs in 𝑂(𝑛𝜏) time and 𝑂(𝑛+ 𝜏log𝑛) space, which
substantially improves the previous best bound of 𝑂(𝑛2) time and
𝑂(𝑛log𝑛) space (where 𝑛is the tree size). Our experimental evalu-
ation shows that our solution scales to databases with millions of
documents and JSON trees with tens of thousands of nodes.
KEYWORDS
JSON edit distance, similarity queries, big data management systems
1
INTRODUCTION
The JavaScript Object Notation (JSON) has evolved into one of
the most prominent data formats. It is used in a large variety of
scenarios, e.g., to publish datasets [21, 54] or as an open-standard
data interchange format in mobile and web applications [20]. JSON-
like formats are also used in document stores to natively support
semi-structured data [1, 6, 39].
As JSON does not enforce a schema, it increases the variety in
which a given piece of information can be represented. Consider the
following scenario: a web crawler collects movies in JSON format
from multiple sources and saves them in a document store. In order
to avoid duplicate entries, the crawler queries the database for the
existence of the movie to be inserted. However, a query for exact
*This is an extended version of an upcoming publication at ACM SIGMOD 2022. Please
cite the original SIGMOD version.
duplicates is not effective since key names or the structure will
typically vary. Consider the document in Figure 1a, which was dis-
covered by the crawler. The document in Figure 1b already resides
in the database. Both documents represent the same movie, but due
to their different representations a query for exact duplicates will
fail. Detecting near-duplicate entries remains a challenge.
{
"title" : "Star Wars -
A New Hope",
"running time" : 125,
"cast" : {
"Han" : "Ford",
"Leia" : "Fisher"
}
}
(a)
{
"cast" : [
"Ford",
"Fisher"
],
"running time" : 125,
"name" : "Star Wars -
A New Hope",
}
(b)
Figure 1: Two JSON representations of the same movie.
In this paper, we study the following problem of similarity queries
for JSON: given a query document 𝑇𝑞, retrieve all documents 𝑇𝑖
from a database of JSON documents that are within a given distance
threshold 𝜏from 𝑇𝑞. To answer such queries, a distance function
that assesses the similarity of two JSON documents is needed.
JSON similarity queries are poorly supported in many existing
systems. Stand-alone tools for JSON differences are either line-
based hence ignore the hierarchical information [16, 26], or do not
provide any guarantees on the quality of the result [12]. Similarity
functions related to JSON in database systems are limited to basic
values, e.g., strings and sets, and cannot be used to compute the
distance between JSON documents [18, 33, 35, 39, 42]. For other
data formats, similarity queries and the related distance measures
are well studied, e.g., for XML [17, 22, 32, 37] data, which – like
JSON – is a hierarchical data format. Common approaches for
XML are based on the well-known tree edit distance [41], which
is the minimal difference between two documents respecting both
their hierarchical structure and data values. For JSON, assessing a
minimal, edit-based difference is still an unsolved problem.
Assessing the edit-based difference between JSON documents
is challenging. JSON differs from other hierarchical data formats,
such as XML, in that it supports both ordered and unordered sibling
nodes within a single document. This uniqueness calls (1) for a
tree representation that models both types of siblings, and (2) for
a distance function that assesses the similarity of the resulting
trees. In particular, the support for unordered sibling collections
poses a computational challenge: We show that computing the
minimal difference between JSON documents is NP-hard when no

---

Hütter, et al.
restrictions are imposed on the standard set of node edit operations,
i.e., insertion, deletion, and renaming.
We solve the problem of computing a minimal, edit-based dif-
ference between JSON documents. (1) We develop a lossless tree
representation of JSON that models both ordered and unordered
siblings. (2) We show that the edit distance in its general formu-
lation leads to non-intuitive results. We therefore restrict the edit
operations to respect the nested document structure of JSON and
propose the first edit-based distance measure for JSON documents,
called JSON Edit Distance (JEDI). The function guarantees that the
difference is minimal and the document nesting is respected.
We present an algorithm for JEDI, called QuickJEDI, which is
based on a recursive solution. Compared to previous edit distance
algorithms for related problems [60, 61], this algorithm leverages a
novel technique, the aggregate size bound, to prune the expensive
min-cost matching between sibling sets in each recursive step. This
optimization leads to runtime improvements of up to an order of
magnitude. We further propose the JSIM index that only searches
the 𝜏-range around the query document instead of scanning all
documents. JSIM is a 4-level tree and each level routes the search
into one or more branches. A new technique allows us to reduce the
𝜏-range at each level, thus reducing the total number of explored
branches. The documents returned by the index are filtered with a
highly effective upper bound based on tree sorting, for which we
improve the computational complexity from quadratic to linear.
The main contributions of this paper are:
• We show that the existing formulation of the tree edit dis-
tance can lead to non-intuitive results and is NP-hard for
JSON. To solve the problem, we introduce JSON trees, a loss-
less tree representation of JSON documents, and JEDI, the
first edit-based distance measure for JSON.
• We develop a new algorithm, QuickJEDI, for computing JEDI
in 𝑂(𝑛2𝑑log𝑑) time and 𝑂(𝑛2) space for JSON trees of size
𝑛and maximum degree 𝑑. The algorithm leverages the new
aggregate size bound to prune expensive sibling matchings.
• To improve the performance of JSON similarity queries, we
introduce (1) a novel index called JSIM; (2) an effective upper
bound based on tree sorting, and an algorithm for computing
the bound in 𝑂(𝑛𝜏) time and 𝑂(𝑛+ 𝜏log𝑛) space, which
substantially improves the previous best bound of 𝑂(𝑛2)
time and 𝑂(𝑛log𝑛) space.
• Our empirical study on 22 JSON datasets suggests that our
solution scales to databases with millions of documents and
can handle large JSON trees with tens of thousands of nodes.
2
EDIT-BASED DISTANCE FOR JSON TREES
We now introduce a new distance measure that assesses the minimal
difference of two JSON documents by a given set of allowable edit
operations and a novel tree representation of JSON data. To our
best knowledge, this measure is the first distance for JSON that
respects its nested structure and provides quality guarantees, i.e.,
the difference defining the distance is guaranteed to be minimal.
The JSON Data Format. We recap the definition of the JSON data
format (cf. RFC8259 [8]). A JSON document is recursively composed
of values, arrays, and objects: (1) A value is either a literal (string,
number, boolean, or null), an object, or an array. (2) An array is an
ordered, possibly empty list of values enclosed by brackets. (3) An
object is an unordered, possibly empty collection of key-value pairs
enclosed by curly braces. The keys (called “names” in [8]) are string
literals that are unique within an object.
Example 1. The JSON document in Figure 1a is an object of
three key-value pairs. The keys are "title", "running time", and
"cast". The value of "cast" is an object, and the other values are
string and number literals.
2.1
JSON Tree Representation
Due to its recursive definition, JSON is hierarchically structured
and naturally represented as a tree. The specifics of transforming
a JSON document into a tree, however, are not obvious. Previous
attempts to model JSON as trees are unsuitable for distances based
on a minimal number of node edit operations because either (1) the
object and array information is not modelled [34, 46], e.g., [[’A’]]
and ’A’ are transformed to identical trees such that the structural
information is lost; or (2) arrays are modeled as objects with the
array index as a key [7, 47], which generates an error of 𝑂(𝑛) when
a single element in an array of size 𝑛is missing . Consider two
arrays [’A’, ’B’, ’C’, ’D’] and [’B’, ’C’, ’D’]: the array
index keys of all identical elements differ due to element ’A’ that
is not present in the second array. Tree models for XML documents
are not suitable since XML is ordered by definition; although XML
has been modeled as unordered trees to capture the semantics of
data-centric XML [2], these models do not support a mix of ordered
and unordered siblings.
JSON Tree. We introduce the new concept of a JSON tree. The
constraints that we impose on JSON trees model all aspects of
JSON data and allow for a lossless transformation between JSON
documents and JSON trees.
A JSON tree 𝑇= (𝑁, 𝐸, Λ, Ψ, <𝑆) is a tree with nodes 𝑁and
edges 𝐸⊆𝑁× 𝑁. The label of node 𝑣, Λ(𝑣), is a literal value; the
labels of array and object nodes are 𝑛𝑢𝑙𝑙. Function Ψ assigns a type
to each node 𝑣∈𝑁, Ψ(𝑣) ∈{object, array, key, literal}. The
sibling order, <𝑆, defines a strict, partial order on the nodes of a tree.
Two nodes 𝑥,𝑦∈𝑁(𝑇) of a JSON tree are comparable, i.e., 𝑥<𝑆𝑦
or 𝑦<𝑆𝑥, iff one of the following holds:
(1) 𝑥and 𝑦are children of the same array node; or
(2) there is an ancestor 𝑥′ of 𝑥(including 𝑥) and an ancestor 𝑦′
of 𝑦(including 𝑦) such that 𝑥′ and 𝑦′ are comparable.
In the second condition, 𝑥<𝑆𝑦iff 𝑥′ <𝑆𝑦′. Intuitively, the order
among the children of an array node imposes an order on the
subtrees rooted in these children; all other nodes are incomparable.
The children of an object node (i.e., key nodes) must have unique
labels among their siblings.
Transformation. A JSON document is transformed into a JSON
tree by recursively unnesting the document. Objects become nodes
of type object (label null) with key node children; a key node (la-
beled with its name) has a single child subtree that represents its
value; an array (label null) becomes an array node with the 𝑖-th
value in its list becoming the 𝑖-th child subtree defining the sibling
order <𝑆. Literals are leaf nodes of type literal (labeled with the
respective literal value).

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
{ }
𝑣11
"title"
𝑣10
"Star..."
𝑣9
"r.time"
𝑣8
125
𝑣7
"cast"
𝑣6
{ }
𝑣5
"Han"
𝑣2
"Ford"
𝑣1
"Leia"
𝑣4
"Fisher"
𝑣3
{ }
𝑤9
"cast" 𝑤4
[ ]
𝑤3
"Ford"
𝑤1
"Fisher"
𝑤2
"r.time" 𝑤8
125 𝑤7
"name"
𝑤6
"Star..."
𝑤5
𝑇1
𝑇2
Figure 2: JSON trees of the documents in Figure 1. Object
nodes are visualized as stars with symbol { }, array nodes as
triangles with symbol [ ], keys as rectangles, and literals as
ellipses with their original labels, respectively. Blue lines –
depict the JSON edit mapping, and vi, wj are node identifiers.
Example 2. Figure 2 shows the JSON tree representation of the
two documents in Figure 1.
Notation. With 𝑁(𝑇) resp. 𝐸(𝑇), we denote the nodes resp. edges
of a JSON tree𝑇. |𝑇| = |𝑁(𝑇)| is the size of𝑇, 𝑣∈𝑇is shorthand for
𝑣∈𝑁(𝑇). The parent of a node 𝑣∈𝑇is 𝑝(𝑣), the set of its children
is 𝑐ℎ𝑑(𝑣), the degree is 𝑑𝑒𝑔(𝑣) = |𝑐ℎ𝑑(𝑣)|; the degree of tree 𝑇,
𝑑𝑒𝑔(𝑇), is the largest degree of a node in 𝑇; 𝑎𝑛𝑐(𝑣) and 𝑑𝑒𝑠𝑐(𝑣)
denote the set of ancestors resp. descendants of 𝑣(excluding 𝑣). The
lowest common ancestor of two nodes 𝑣,𝑤is 𝑙𝑐𝑎(𝑣,𝑤).
𝑇[𝑣] denotes the subtree rooted in node 𝑣. The subforest of node
𝑣, denoted 𝐹[𝑣], is the set of subtrees of its children, 𝑇[𝑣𝑖], 𝑣𝑖∈
𝑐ℎ𝑑(𝑣). If an order is defined on 𝑐ℎ𝑑(𝑣), then the subforest 𝐹[𝑣] is
ordered by the root nodes of its subtrees. We use 𝜖to denote the
empty node, which is not part of any tree. We define 𝑇[𝜖] to be the
empty subtree with 𝑁(𝑇[𝜖]) = ∅and 𝐸(𝑇[𝜖]) = ∅, and 𝐹[𝜖] = ∅to
be the empty subforest. The postorder traversal recursively visits all
children of a node 𝑣before visiting 𝑣(ordered children in ascending
order and unordered children in arbitrary order; 𝑝𝑜𝑠𝑡(𝑣) is the
position of node 𝑣in a given postorder traversal.
2.2
JSON Edit Distance (JEDI)
Given two JSON trees, our goal is to assess their similarity. We
aim for a similarity measure that captures fine-grained differences,
allows an intuitive interpretation of the similarity value, and guaran-
tees the minimality of the similarity value. A well-known approach
that satisfies these requirements is the edit distance, which has
been applied to strings [58], trees [41], and graphs [24].
The edit distances for general, rooted, labeled trees [48, 62],
however, are not applicable to JSON trees since they can only deal
with either ordered or unordered trees, but not with a mix of the
two. In JSON trees, the order of array children must be respected,
whereas the order of object children must be ignored. Note that all
nodes in subtree 𝑇[𝑐𝑖] appear before the nodes in 𝑇[𝑐𝑗] if 𝑐𝑖<𝑆𝑐𝑗,
i.e., the order imposed by an array is propagated to the subtrees
rooted in the children. We are the first to define an edit distance
that can deal with both ordered and unordered siblings in a single
tree. Further, we respect the node types of JSON, e.g., a literal value
should not be aligned to a key node.
Similar to the edit distance for other data types, we define the
JSON edit distance (JEDI) as the minimum number of edit opera-
tions required to transform one tree to the other. Allowable opera-
tions include: delete node 𝑣and connect its children to the parent
of 𝑣; insert a new node 𝑤between an existing node 𝑣and a possibly
empty subset of 𝑣’s children; and rename the label of node 𝑣.
JSON Edit Mapping. Following previous works, we formally de-
fine the JSON edit distance using the concept of an edit mapping.
The edit mapping aligns the nodes of the input trees,𝑇1 and𝑇2, and
must respect some constraints to be valid. The interpretation is as
follows: nodes in 𝑇1 that are not mapped are deleted, nodes in 𝑇2
that are not mapped are inserted, and nodes that are mapped are
renamed. The constraints imposed on the mapping control which
edit operations are allowable depending on the tree context; they
are discussed in detail below.
Definition 1 (JSON Edit Mapping). A mapping 𝑀⊆𝑁(𝑇1) ×
𝑁(𝑇2) is a JSON edit mapping from 𝑇1 to 𝑇2 iff the following con-
straints hold for any node pairs (𝑣,𝑤), (𝑣′,𝑤′), (𝑣′′,𝑤′′) ∈𝑀:
(1) 𝑣= 𝑣′ iff 𝑤= 𝑤′ [one-to-one],
(2) 𝑣is an ancestor of 𝑣′ iff 𝑤is an ancestor of 𝑤′ [ancestor],
(3) 𝑡𝑦𝑝𝑒(𝑣) = 𝑡𝑦𝑝𝑒(𝑤) [type],
(4) if 𝑣<𝑆𝑣′ and 𝑤is comparable to 𝑤′ in <𝑆, then 𝑤<𝑆𝑤′
[array-order],
(5) 𝑙𝑐𝑎(𝑣, 𝑣′) is a proper ancestor of 𝑣′′ iff 𝑙𝑐𝑎(𝑤,𝑤′) is a proper
ancestor of 𝑤′′ [document-preserving].
A mapping 𝑀′ ⊆𝑀between two subforest 𝐹1[𝑣] and 𝐹2[𝑤] is an
edit mapping iff 𝑀′ is an edit mapping from 𝑇1[𝑣] to 𝑇2[𝑤].
The cost of all edit operations is one except for rename: if the
labels of the mapped nodes are identical, then the cost is zero. The
cost of an edit mapping, 𝛾(𝑀), is the total cost of all edit operations.
The edit distance is defined as the cost of the edit mapping with
the lowest cost.
Example 3. Figure 2 shows a JSON edit mapping between two
JSON trees. The cost of the mapping is 5: delete nodes "Han", "Leia",
and {} from the left tree; insert [] into the right tree; rename "title"
to "name". There is no mapping with a lower cost, thus JEDI is 5.
Constraints (1) and (2) of the edit mapping ensure that the node
mapping can be interpreted as a set of edit operations. Constraint (3)
ensures that labels can only be renamed between nodes of the same
type. This prevents that nodes with identical labels but different
types (e.g., a key and a literal value may have identical labels) are
mapped at zero cost, thus ignoring their difference. Note that it is
still possible to substitute (delete and insert) a node of one type
by a node of another type, but the cost is higher than for rename.
The array-order constraint (4) uses the partial order <𝑆defined on
JSON trees to enforce the order imposed by array nodes; children
of object nodes are not restricted and can be arbitrarily mapped.
Document-Preserving Constraint. The recursive definition of JSON
gives rise to its nested document structure. A nested document (e.g.,
representing the cast of a movie) often is meaningful only in the
context of the enclosing document (in the example, the movie the
cast belongs to). Constraint (5), the document-preserving constraint,
forces the edit mappings to respect the nested document structure of
JSON and leads to more intuitive mappings. In particular, shortcuts

---

Hütter, et al.
that delete the root nodes of subtrees (thus disassembling the docu-
ments they root), rearrange their nested subtrees, and recompose
the nested subtrees into new documents by inserting new subtree
roots are prevented. We illustrate the effect of this constraint in
Example 4.
{ }
"𝑙1"
𝑣1
{ }
𝑜1
"𝑎"
𝑥1
"𝑏"
𝑥2
"𝑙2"
𝑣2
{ }
𝑜2
"𝑐"
𝑥3
"𝑑"
𝑥4
{ }
"𝑚1"
𝑤1
{ }
𝑜3
"𝑎"
𝑦1
"𝑐"
𝑦3
"𝑚2"
𝑤2
{ }
𝑜4
"𝑏"
𝑦2
"𝑑"
𝑦4
𝑇1
𝑇2
Figure 3: Edit mappings with and without the document-
preserving constraint.
Example 4. Consider the schematic illustration of the two JSON
trees 𝑇1 and 𝑇2 in Figure 3. Each tree consists of two subtrees 𝑇1[𝑣1],
𝑇1[𝑣2] resp. 𝑇2[𝑤1], 𝑇2[𝑤2], which in turn are composed of an object
node and two smaller subtrees 𝑇1[𝑥𝑖] resp. 𝑇2[𝑦𝑗] each, 𝑖, 𝑗≤4. The
subtree pairs 𝑇1[𝑥𝑖] and 𝑇2[𝑦𝑗], 𝑖= 𝑗, are identical (same color in
the figure) and are all of size 𝑛. Any two subtrees 𝑇1[𝑣𝑖] and 𝑇2[𝑤𝑗],
𝑖≠𝑗, are different with an edit mapping of cost 𝑂(𝑛).
The minimum-cost edit mapping (with document-preserving con-
straint) will delete 𝑇1[𝑥2] and 𝑇1[𝑥3], and insert their identical coun-
terparts 𝑇2[𝑦2] and 𝑇2[𝑦3] since they belong to different documents
in 𝑇2. An edit mapping that does not respect the document-preserving
constraint, however, has only cost 8: delete nodes 𝑣1, 𝑣2,𝑜1,𝑜2, insert𝑜3
as parent of𝑦1,𝑦3; 𝑜4 as parent of𝑦2,𝑦4; 𝑤1 as parent of 𝑜3; and 𝑤2 as
parent of 𝑜4. Without the document-preserving constraint, rearranged
subtrees form new documents, which is not desired for JSON trees.
As a pleasant side effect, the document-preserving constraint
substantially reduces the search space for the minimal cost mapping
and allows for faster algorithms. In fact, we show that finding a
minimum JSON edit mapping that ignores the document-preserving
constraint is an NP-hard problem. The proof is by reducing the
problem of exact cover by 3-sets (X3C).
Theorem 1. Without the document-preserving constraint, the
problem of computing the JSON edit distance between two JSON
trees is NP-hard.
Proof. Cf. Section A.1.
□
3
AN EFFICIENT ALGORITHM FOR JEDI
Next, we introduce QuickJEDI, an efficient algorithm for comput-
ing the JSON edit distance. We first discuss a baseline solution,
analyze its performance bottlenecks, and finally propose effective
techniques to address these bottlenecks.
3.1
A Baseline Algorithm
None of the previous algorithms that computes the minimum edit
distances between trees is applicable in our scenario due to the
type and the array-order constraints in the JSON edit mapping (cf.
Definition 1). Our baseline extends two algorithms for the so-called
constrained tree edit distance. These algorithms compute minimal
edits under the document-preserving constraint (constraint (5) in
the JSON edit mapping) for ordered [60] resp. unordered trees [61].
Since a single JSON tree may include both ordered and unordered
siblings, neither of the two algorithms is applicable; also, these
algorithms deal with generic trees and do not consider node types.
We recap the solutions for the constrained tree edit distance
and show how they can be extended to compute the JSON edit
distance. Both algorithms are based on a recursive solution that is
implemented using dynamic programming.
𝑣
𝑐1
𝑐𝑖
𝑐𝑙
...
...
𝑤
𝑐′
1
𝑐′
𝑗
𝑐′
𝑚
...
...
Figure 4: Recursive decomposition of two trees; pairs of sub-
trees resp. subforests of the same color form the subprob-
lems required to compute the distance btw. T[v] and T[w].
Recursive Solution. The recursive solution decomposes two trees
𝑇1 and 𝑇2 with root nodes 𝑣∈𝑇1 and 𝑤∈𝑇2 into subtrees and
subforests as illustrated in Figure 4. The distance between𝑇1 and𝑇2
is computed from the distances between the subproblems resulting
from their decomposition. With dt(𝑣,𝑤) we denote the tree distance
between subtrees 𝑇1[𝑣] and 𝑇2[𝑤], and df(𝑣,𝑤) denotes the forest
distance between subforests 𝐹1[𝑣] and 𝐹2[𝑤]. Then, the recursive
solution is defined as follows:
df(𝜖, 𝜖) = 0; dt(𝜖, 𝜖) = 0
df(v, 𝜖) =
Õ
c∈chd(v) dt(c, 𝜖); dt(v, 𝜖) = df(v, 𝜖) + 𝛾(v, 𝜖)
(1)
df(𝜖, w) =
Õ
c’∈chd(w) dt(𝜖, c’); dt(𝜖, w) = df(𝜖, w) + 𝛾(𝜖, w)
df(v, w) = min


df(𝜖, w) + minc’∈chd(w){df(v,c’) - df(𝜖,c’)}
(2a)
df(v, 𝜖) + minc∈chd(𝑣){df(c, w) - df(c, 𝜖)}
(2b)
Min-cost-matching (chd(v), chd(w))
(2c)
dt(v, w) = min


dt(𝜖, w) + minc’∈chd(w){dt(v, c’) - dt(𝜖, c’)}
(3a)
dt(v, 𝜖) + minc∈chd(v){dt(c, w) - dt(c, 𝜖)}
(3b)
df(v, w) + 𝛾(v, w)
(3c)
The tree distance, dt(𝑣,𝑤), is the minimum cost of three scenarios
(cf. Figure 4 and Eq. 3), each of which represents an edit operation:
(3a) 𝑤is inserted, hence the nodes in subtree 𝑇1[𝑣] are mapped to
the nodes of one of 𝑤’s children 𝑇2[𝑐′
𝑗] (green), (3b) 𝑣is deleted,
hence the nodes of subtree𝑇2[𝑤] are mapped to the nodes of one of
𝑣’s children𝑇1[𝑐𝑖] (red), and (3c) 𝑣is mapped to 𝑤with rename cost
𝛾(𝑣,𝑤), hence also the subtrees of their children are mapped (blue);
𝛾(𝑣,𝜖) and𝛾(𝜖,𝑤) denote the cost of deleting resp. inserting a node.
The cost of matching the children of nodes 𝑣and 𝑤in scenario (3c)

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
𝑐ℎ𝑑(𝑣)
𝑐1
𝑐2
𝑐𝑖
𝑐𝑙
𝜖
𝜖
𝑐ℎ𝑑(𝑤)
𝑐′
1
𝑐′
2
𝑐′
𝑗
𝑐′
𝑙
𝑐′
𝑙+1
𝑐′
𝑚
𝑐𝑜𝑠𝑡(𝑐𝑖,𝑐′
𝑗) = 𝑑𝑡(𝑐𝑖,𝑐′
𝑗)
Figure 5: Bipartite graph for the nodes chd(v) and chd(w).
is equivalent to their forest distance df(𝑣,𝑤). The base cases of the
recursion are shown in Eq. 1. The forest distance, df(𝑣,𝑤), (cf. Eq. 2)
is computed analogously for insertion (2a) and deletion (2b). In the
third scenario (2c), a minimum-cost matching between the subtrees
rooted in 𝑐ℎ𝑑(𝑣) and 𝑐ℎ𝑑(𝑤) is established.
The minimum-cost matching M is one-to-one and models the
subtrees rooted in 𝑐ℎ𝑑(𝑣) and 𝑐ℎ𝑑(𝑤) as nodes of a bipartite graph
(cf. Figure 5); the cost of an edge between two subtrees rooted in
𝑐𝑖∈𝑐ℎ𝑑(𝑣) and 𝑐′
𝑗∈𝑐ℎ𝑑(𝑤) is their tree distance, dt(𝑐𝑖,𝑐′
𝑗). In
the unordered case [61], the minimum-cost bipartite graph match-
ing, 𝑀𝐵𝑃𝑀(𝑣,𝑤), with cost 𝛾(𝑀𝐵𝑃𝑀(𝑣,𝑤)) = 𝐵𝑃𝑀(𝑣,𝑤) must be
computed (e.g., using a min-cost max-flow algorithm [50]). In the
ordered case [60], the subtree sequence edit distance matching,
𝑀𝑆𝐸𝐷(𝑣,𝑤), with cost𝛾(𝑀𝑆𝐸𝐷(𝑣,𝑤)) =𝑆𝐸𝐷(𝑣,𝑤) must be computed.
Adaption to JSON. In Lemma 1, we show how previous solutions
can be extended to compute JEDI between two JSON trees.
Lemma 1. Given two JSON trees 𝑇1 and 𝑇2, the recursive formulas
(1), (2), and (3), compute the JSON edit distance between 𝑇1 and 𝑇2,
𝐽𝐸𝐷𝐼(𝑇1,𝑇2) = dt(root(𝑇1), root(𝑇2)) with the following extensions:
(1) The minimum-cost matching M ⊆𝑐ℎ𝑑(𝑣) × 𝑐ℎ𝑑(𝑤) observes
the node type:
M =
(
𝑀𝑆𝐸𝐷(𝑣,𝑤)
if type(v) = type(w) = array
𝑀𝐵𝑃𝑀(𝑣,𝑤)
otherwise
(4)
(2) The rename cost must be redefined as follows:
𝛾′(𝑣,𝑤) =
(
𝛾(𝑣,𝑤)
if 𝑡𝑦𝑝𝑒(𝑣) = 𝑡𝑦𝑝𝑒(𝑤)
𝛾(𝑣,𝜖) + 𝛾(𝜖,𝑤)
otherwise
(5)
Proof. Given a node pair (𝑣,𝑤) with 𝑣∈𝑇1 and 𝑤∈𝑇2. We
distinguish three cases: (1) Both 𝑣and 𝑤are array nodes: Proof as
for the ordered, constrained edit distance [60]. (2) Both 𝑣and 𝑤
are non-array nodes: Proof as for the unordered, constrained edit
distance [61]. (3) Otherwise: W.l.o.g., we assume that 𝑣is an array
node (siblings ordered) and 𝑤is a non-array node (siblings not
ordered). The min-cost matching M between 𝑐ℎ𝑑(𝑣) and 𝑐ℎ𝑑(𝑤)
must be computed using bipartite graph matching since the children
of node 𝑤can be arbitrarily rearranged to allow any matching
without violating the order on 𝑐ℎ𝑑(𝑣). — The rename cost for non-
matching node types is the cost of deleting 𝑣and inserting𝑤instead.
□
Dynamic Programming Implementation. Algorithm 1 implements
the recursive solution of Lemma 1. The results for subproblems are
stored in two matrices, dt and df, each of size (|𝑇1| + 1) × (|𝑇2| + 1).
The distance between subtrees 𝑇1[𝑣] and 𝑇2[𝑤] is stored in row
𝑣and column 𝑤, and we refer to the value as dt(𝑣,𝑤); similarly,
df(𝑣,𝑤) stores the distance between subforests 𝐹1[𝑣] and 𝐹2[𝑤].
Table 1 shows examples of a forest and a tree distance matrix.
Initialization: The first row and column of each matrix are ini-
tialized in lines 1-8. Mapping two empty trees has cost 0; for all
other nodes, the cost results from summing up the deletion resp.
insertion costs of their child subtrees, e.g., dt(𝑣6,𝜖) = 6 (cf. Table 1)
is the cost of deleting the subtree of node "cast" in Figure 2.
Distance Computation: The algorithm processes the tree nodes
bottom-up in postorder and the distance matrices are filled row by
row. We label the three cases in Eq. 2 (forest distance) with 𝑖𝑛𝑠𝐹(2a),
𝑑𝑒𝑙𝐹(2b), and 𝑟𝑒𝑛𝐹(2c); the cases in Eq. 3 (tree distance) are labeled
𝑖𝑛𝑠𝑇(3a), 𝑑𝑒𝑙𝑇(3b), 𝑟𝑒𝑛𝑇(3c). Due to the postorder traversal, all
values required to compute dt(𝑣,𝑤) and df(𝑣,𝑤) are available in
the distance matrices. To compute 𝑟𝑒𝑛𝐹, a min-cost matching M
among the children must be established. If both 𝑣and 𝑤are array
nodes (ordered case), the edit distance between ordered sequences
of siblings establishes the min-cost matching (line 16), in all other
cases a bipartite graph matching must be computed (line 18). The
distance between 𝑇1 and 𝑇2 results in the lower right corner of the
tree distance matrix, e.g., dt(root(𝑇1), root(𝑇2)) = 5 in Table 1.
Complexity: The space complexity is dominated by the distance
matrices of size 𝑂(|𝑇1||𝑇2|). The runtime is dominated by the bi-
partite graph matching, which for a node pair 𝑣,𝑤with degrees
𝑑𝑣= 𝑑𝑒𝑔(𝑣) and 𝑑𝑤= 𝑑𝑒𝑔(𝑤) is computed in time 𝑂(𝑑𝑣× 𝑑𝑤×
(𝑑𝑣+𝑑𝑤) ×𝑙𝑜𝑔(𝑑𝑣+𝑑𝑤)) using a min-cost max-flow algorithm [50].
For the overall algorithm (cf. Algorithm 1), the runtime complexity
is 𝑂(|𝑇1| × |𝑇2| × (𝑑𝑒𝑔(𝑇1) +𝑑𝑒𝑔(𝑇2)) ×𝑙𝑜𝑔(𝑑𝑒𝑔(𝑇1) +𝑑𝑒𝑔(𝑇2))) [61].
df
𝜖
𝑤1
𝑤2
. . .
𝑤6
𝑤9
𝜖
0
0
0
. . .
1
8
𝑣9
0
0
0
. . .
1
8
𝑣10
1
1
1
. . .
0
7
...
...
...
...
...
...
...
𝑣6
5
5
5
. . .
5
8
𝑣11
10
10
10
. . .
9
5
dt
𝜖
𝑤1
𝑤2
. . .
𝑤6
𝑤9
𝜖
0
1
1
. . .
2
9
𝑣9
1
1
1
. . .
1
8
𝑣10
2
2
2
. . .
1
8
...
...
...
...
...
...
...
𝑣6
6
5
5
. . .
6
8
𝑣11
11
10
10
. . .
10
5
Table 1: Forest and tree distance matrices df and dt for the
JSON trees in Figure 2.
3.2
Avoiding the Expensive Min-Cost Matching
JEDI must compute the min-cost matching between the child sub-
trees of each node pair of the input trees. This step is expensive and
dominates the overall runtime. In this section, we show that the
expensive min-cost computation can be avoided in many cases, thus
substantially improving the runtime of the distance computation.
The key idea is that the min-cost matching in Eq. (2) is the
minimum of three values. Two of them are efficient to compute,
one is the expensive matching. If we can show that the cost of the
matching is higher than one of the other two values, the exact cost
of the matching is irrelevant and the computation can be skipped.
We are the first to follow this approach. The challenge is to iden-
tify a lower bound on the min-cost matching that is both effective
and can be computed efficiently. Efficiency is crucial since the lower
bound filter will be evaluated in addition to the min-cost matching
whenever the filter cannot avoid the matching computation. The
min-cost matching is a bipartite graph matching in the unordered

---

Hütter, et al.
Algorithm 1: JEDI-baseline(𝑇1,𝑇2)
Input: JSON trees 𝑇1 and 𝑇2.
Result: JSON Edit Distance: JEDI(𝑇1, 𝑇2).
/* Initialization.
*/
1 dt(0, 0) = 0
/* Tree distance matrix of size 𝑇1 + 1 ×𝑇2 + 1. */
2 df(0, 0) = 0 /* Forest distance matrix of size 𝑇1 + 1 ×𝑇2 + 1. */
3 for 𝑣in 𝑁(𝑇1) do
4
df(𝑣, 0) = Í
𝑐∈𝑐ℎ𝑑(𝑣) dt(𝑐, 0)
5
dt(𝑣, 0) = df(𝑣, 0) + 𝛾(𝑣, 𝜆)
6 for 𝑤in 𝑁(𝑇2) do
7
df(0, 𝑤) = Í
𝑐’∈𝑐ℎ𝑑(𝑤) dt(0, 𝑐’)
8
dt(0, 𝑤) = df(0, 𝑤) + 𝛾(𝜆,𝑤)
/* Distance computation.
*/
9 for 𝑣in 𝑁(𝑇1) do
/* In postorder. */
10
for 𝑤in 𝑁(𝑇2) do
/* In postorder. */
/* Cost for inserting node 𝑤.
*/
11
insF = df(0, 𝑤) + min𝑐’∈𝑐ℎ𝑑(𝑤){df(𝑣,𝑐’) - df(0,𝑐’)}
12
insT = dt(0, 𝑤) + min𝑐’∈𝑐ℎ𝑑(𝑤){dt(𝑣,𝑐’) - dt(0,𝑐’)}
/* Cost for deleting node 𝑣.
*/
13
delF = df(𝑣, 0) + min𝑐∈𝑐ℎ𝑑(𝑣){df(𝑐,𝑤) - df(𝑐,0)}
14
delT = dt(𝑣, 0) + min𝑐∈𝑐ℎ𝑑(𝑣){dt(𝑐,𝑤) - dt(𝑐,0)}
/* Cost for renaming node 𝑣to node 𝑤.
*/
15
if type(v) == type(w) == array then
16
renF = SED(v, w)
17
else
18
renF = BPM(v, w)
19
df(𝑣, 𝑤) = min{insF, delF, renF}
20
renT = df(𝑣, 𝑤) + 𝛾’(𝑣,𝑤’)
21
dt(𝑣, 𝑤) = min{insT, delT, renT}
22 return dt(𝑟𝑜𝑜𝑡(𝑇1), 𝑟𝑜𝑜𝑡(𝑇2))
case and a sequence edit distance computation in the ordered case.
Since the sequence edit distance cannot be smaller than the bipartite
graph matching cost, we focus on the bipartite graph matching.
Figure 5 illustrates the bipartite graph for the nodes 𝑐ℎ𝑑(𝑣) and
𝑐ℎ𝑑(𝑤). The edge cost 𝑐𝑜𝑠𝑡(𝑐𝑖,𝑐′
𝑗) between two nodes 𝑐𝑖∈𝑐ℎ𝑑(𝑣)
and 𝑐′
𝑗∈𝑐ℎ𝑑(𝑤) is the tree distance between the subtrees rooted
in these nodes, dt(𝑐𝑖,𝑐′
𝑗). To simplify the presentation, we assume
𝑙= 𝑑𝑒𝑔(𝑣) < 𝑑𝑒𝑔(𝑤) = 𝑚, i.e., 𝑘= 𝑚−𝑙subtrees will be matched
to the empty tree. We denote the cost of the bipartite matching
between the children of two nodes 𝑣,𝑤with 𝐵𝑃𝑀(𝑣,𝑤).
Aggregate Size Bound. To establish a lower bound on the bi-
partite graph matching cost, we leverage the specific character-
istics of the edge costs in our scenario. Since the edge costs are
given by the respective subtree distances, we can bound the cost
by the size difference of the subtrees, 𝑐𝑜𝑠𝑡∗(𝑐𝑖,𝑐′
𝑗) = |(|𝑇[𝑐𝑖]| −
|𝑇[𝑐′
𝑗]|)| ≤𝑐𝑜𝑠𝑡(𝑐𝑖,𝑐′
𝑗). A minimal matching 𝐵𝑃𝑀∗(𝑣,𝑤) that uses
𝑐𝑜𝑠𝑡∗(𝑐𝑖,𝑐′
𝑗) cannot be more expensive than the original matching,
𝐵𝑃𝑀∗(𝑣,𝑤) ≤𝐵𝑃𝑀(𝑣,𝑤). We leverage this fact to derive a novel
lower bound based on subtree sizes. We define the sorted aggregate
size between start 𝑠and end 𝑒in a subforest 𝐹[𝑣] as
𝑆𝐴𝑆(𝑣,𝑠,𝑒) =
𝑒Õ
𝑖=𝑠
|𝑇[𝑐𝑖]|,
𝑐𝑖∈𝑐ℎ𝑑(𝑣),
(6)
where 𝑐𝑖is the 𝑖-th smallest subtree in 𝐹[𝑣] (ties broken arbitrarily).
The intuition of our bound is as follows: There exists a match-
ing with cost 𝐵𝑃𝑀(𝑣,𝑤), 𝑑𝑒𝑔(𝑣) < 𝑑𝑒𝑔(𝑤), that matches the 𝑘=
𝑑𝑒𝑔(𝑤) −𝑑𝑒𝑔(𝑣) smallest subtrees to the empty tree, inducing cost
𝑆𝐴𝑆(𝑤, 1,𝑘). The matching cost between the remaining subtrees is
no larger than the difference of their aggregate subtree sizes.
Theorem 2 (Aggregate Size Bound). Given two JSON tree nodes
𝑣∈𝑇1,𝑤∈𝑇2. Let 𝑑𝑣= 𝑑𝑒𝑔(𝑣), 𝑑𝑤= 𝑑𝑒𝑔(𝑤), 𝑘= 𝑑𝑤−𝑑𝑣, and
𝑑𝑣≤𝑑𝑤, then:
𝐵𝑃𝑀(𝑣,𝑤) ≥|𝑆𝐴𝑆(𝑣, 1,𝑑𝑣)−𝑆𝐴𝑆(𝑤,𝑘+1,𝑑𝑤)|+𝑆𝐴𝑆(𝑤, 1,𝑘).
Proof. We show that the lower bound holds for 𝐵𝑃𝑀∗(𝑣,𝑤) ≤
𝐵𝑃𝑀(𝑣,𝑤) with edge costs 𝑐𝑜𝑠𝑡∗(𝑐𝑖,𝑐′
𝑗) = ||𝑇[𝑐𝑖]| −|𝑇[𝑐′
𝑗]||, 𝑐𝑖∈
𝑐ℎ𝑑(𝑣), and 𝑐′
𝑗∈𝑐ℎ𝑑(𝑤). W.l.o.g., assume that the children of 𝑤are
sorted by subtree size, |𝑇[𝑐′
𝑖]| ≤|𝑇[𝑐′
𝑗]| if 𝑖< 𝑗. (a) We show that
there is a min-cost matching that maps the𝑘smallest subtrees to the
empty tree, inducing cost |𝑆𝐴𝑆(𝑤, 1,𝑘)|: Let M ⊆𝑐ℎ𝑑(𝑣) ×𝑐ℎ𝑑(𝑤)
be a min-cost matching with (𝜖,𝑐′
𝑗) ∈M such that 𝑗> 𝑘, i.e.,
|𝑇[𝑐′
𝑗]| ≥|𝑇[𝑐′
𝑘]|. Then, there must be a node 𝑐′𝑥with 𝑥≤𝑘
that is mapped to node 𝑐𝑖, 𝑐𝑖≠𝜖. By changing the matching to
M \ {(𝜖,𝑐′
𝑗), (𝑐𝑖,𝑐′𝑥)} ∪{(𝑐𝑖,𝑐′
𝑗), (𝜖,𝑐′𝑥)}, the cost cannot increase
as can be verified by considering the three options for the size
of 𝑇[𝑐𝑖]: |𝑇[𝑐′
𝑗]| ≤|𝑇[𝑐𝑖]| (cost decreases by 2(|𝑇[𝑐′
𝑗]| −|𝑇[𝑐′𝑥]|),
|𝑇[𝑐′𝑥] ≤|𝑇[𝑐𝑖]| < |𝑇[𝑐′
𝑗]| (cost decreases by 2(|𝑇[𝑐𝑖]| −|𝑇[𝑐′𝑥]|)),
and |𝑇[𝑐𝑖]| < |𝑇[𝑐′𝑥]| (cost does not change). We repeat this step
until all nodes 𝑐′
1,𝑐′
2, . . . ,𝑐′
𝑘are mapped to empty nodes. (b) The
cost of the remaining matching M′ = {(𝑐𝑖,𝑐′
𝑗) ∈M | 𝑐𝑖≠𝜖} is
Í
(𝑐𝑖,𝑐′
𝑗) ∈M′ |(|𝑇[𝑐𝑖]| −|𝑇[𝑐′
𝑗]|)|, which is at least |𝑆𝐴𝑆(𝑣, 1,𝑑𝑣) −
𝑆𝐴𝑆(𝑤,𝑘+ 1,𝑑𝑤)| = Í
(𝑐𝑖,𝑐′
𝑗) ∈M′(|𝑇[𝑐𝑖]| −|𝑇[𝑐′
𝑗]|).,
□
Example 5. For the root nodes of the JSON trees in Figure 2,
𝐵𝑀𝑃(𝑣11,𝑤9) = 5 and the aggregate size bound is 2 (𝑆𝐴𝑆(𝑤9, 1,𝑘) =
0 since both nodes have the same degree, i.e., 𝑘= 0). In Figure 6,
𝑘= 1 and the aggregate subtree bound is 9: 𝑆𝐴𝑆(𝑤, 1,𝑘) = 5 and
|𝑆𝐴𝑆(𝑣, 1,𝑑𝑣) −𝑆𝐴𝑆(𝑤,𝑘+ 1,𝑑𝑤)| = 4. Note that our aggregate size
bound performs much better than a simple subtree size difference
bound, which is |𝑆𝐴𝑆(𝑣, 1,𝑑𝑣) −𝑆𝐴𝑆(𝑤, 1,𝑑𝑤)| = 1 in this example.
𝑤
𝑐′
1
𝑐′
2
𝑐′
3
6
5
6
5
11
17
𝑣
𝑐′
1
𝑐′
2
8
8
8
16
Figure 6: SAS arrays for the aggregate size bound.
Efficient Computation of Aggregate Size Bound. The aggregate
size bound requires us to compute sums of subtree sizes. Since the
bound is computed 𝑂(|𝑇1||𝑇2|) times (for all pairs of parent nodes),
computing these sums is too expensive. We precompute an array
SAS𝑣of size𝑑𝑒𝑔(𝑣) for each node 𝑣∈𝑇1 with SAS𝑣[𝑖] = 𝑆𝐴𝑆(𝑣, 1,𝑖)
(cf. Eq. (6)); analogously SAS𝑤for all 𝑤∈𝑇2 is computed. Thanks

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
to the SAS arrays we can compute the bound in constant time:
|𝑆𝐴𝑆(𝑣, 1,𝑑𝑣) −𝑆𝐴𝑆(𝑤,𝑘+ 1,𝑑𝑤)| + 𝑆𝐴𝑆(𝑤, 1,𝑘) =
|SAS𝑣[𝑑𝑣] −SAS𝑤[𝑑𝑤] + SAS𝑤[𝑘]| + SAS𝑤[𝑘]
(7)
Example 6. SAS𝑤9 = [2, 4, 8] for root node𝑤9 in Figure 2. Figure 6
shows the SAS arrays for the root nodes 𝑣and 𝑤of the example trees.
Local Greedy Lower Bound. The local greedy lower bound on
𝐵𝑃𝑀(𝑣,𝑤) matches each node by following the lowest cost edge.
The result may violate the one-to-one requirement and therefore
may not be a valid matching. Similar bounds have been used before
(e.g., [45]). Since this bound is as expensive as the sequence edit
distance (quadratic in the node degrees as all edge costs must be
checked), it is only useful for the bipartite graph matching.
Lemma 2 (Local Greedy Lower Bound). Let𝑇1,𝑇2 be JSON trees,
𝑣∈𝑇1,𝑤∈𝑇2. Let𝐺𝑀𝑣⊆𝑐ℎ𝑑(𝑣)×𝑐ℎ𝑑(𝑤) map𝑐𝑖∈𝑐ℎ𝑑(𝑣) to some
𝑐𝑗∈𝑐ℎ𝑑(𝑤) such that dt(𝑐𝑖,𝑐𝑗) is minimal;𝐺𝑀𝑤⊆𝑐ℎ𝑑(𝑤)×𝑐ℎ𝑑(𝑣)
is defined analogously:
𝐵𝑃𝑀(𝑣,𝑤) ≥max{𝛾(𝐺𝑀𝑣),𝛾(𝐺𝑀𝑤)}
Proof. 𝐺𝑀𝑣greedily picks the lowest cost outgoing edge for
each 𝑐𝑖∈𝑐ℎ𝑑(𝑣). The bipartite matching must also provide a one-
to-one matching and may therefore not be able to use the lowest
cost edge for each node. Analogous reasoning for 𝐺𝑀𝑤.
□
We show how to compute 𝐺𝑀𝑣and 𝐺𝑀𝑤with low overhead:
While we build the bipartite graph and retrieve all edge costs be-
tween the children of two nodes 𝑣,𝑤, we maintain the minimum
cost edge for each node 𝑐𝑖∈𝑐ℎ𝑑(𝑣) and 𝑐′
𝑗∈𝑐ℎ𝑑(𝑤). In a single
pass over the nodes, we get 𝐺𝑀𝑣and 𝐺𝑀𝑤with linear overhead.
An interesting opportunity arises when 𝐺𝑀𝑣or 𝐺𝑀𝑤is one-to-
one: In this case, we can skip the bipartite graph matching since
𝐵𝑃𝑀(𝑣,𝑤) = max{𝛾(𝐺𝑀𝑣),𝛾(𝐺𝑀𝑤)} and we know the exact costs.
3.3
The QuickJEDI Algorithm
We present QuickJEDI, our efficient algorithm for computing the
JSON edit distance. QuickJEDI extends JEDI-baseline (Algorithm 1)
with the results in Section 3.2. While the baseline must compute the
expensive min-cost matching between the children of each node
pair (𝑣,𝑤), QuickJEDI checks the aggregate size bound (cf. Th. 2) to
assess whether the matching is required. The aggregate size bound
is a lower bound for both types of min-cost matchings: the sequence
edit distance, 𝑆𝐸𝐷(𝑣,𝑤), for pairs of array nodes, and the bipartite
graph matching, 𝐵𝑃𝑀(𝑣,𝑤), which is applied otherwise. Only if
the lower bound is smaller than both 𝑖𝑛𝑠𝐹and 𝑑𝑒𝑙𝐹(line 2), the min-
cost matching must be computed. Before computing 𝐵𝑃𝑀(𝑣,𝑤),
we also check the local greedy lower bound (cf. Lemma 2).
We further avoid the min-cost matching for two special cases
(omitted in Algorithm 2 for brevity): if both 𝑣and 𝑤are key nodes,
they have only one child each (𝑐𝑣resp. 𝑐𝑤), and 𝑟𝑒𝑛𝐹= dt(𝑐𝑣,𝑐𝑤).
If both 𝑣and 𝑤are literal values, they are leaves, and 𝑟𝑒𝑛𝐹= 0.
4
THE JEDIORDER FILTER
In this section, we propose JediOrder, a highly effective upper bound
filter on the JSON edit distance. In a JSON similarity query, the upper
bound is evaluated before JEDI: if the upper bound is within the
similarity threshold 𝜏, the expensive JEDI needs not be computed.
Algorithm 2: QuickJEDI(𝑇1,𝑇2)
Input: JSON trees 𝑇1 and 𝑇2.
Result: JSON Edit Distance: JEDI(𝑇1, 𝑇2).
/* Lines 1-14 from Algorithm 1
*/
1 𝐴𝑔𝑔𝑆𝑖𝑧𝑒𝐵𝑑= |SAS𝑣[𝑑𝑣] −SAS𝑤[𝑑𝑤] +SAS𝑤[𝑘]| +SAS𝑤[𝑘]
2 if 𝐴𝑔𝑔𝑆𝑖𝑧𝑒𝐵𝑑< min{𝑖𝑛𝑠𝐹,𝑑𝑒𝑙𝐹} then
3
if type(v) == type(w) == array then
4
renF = SED(v, w)
5
else
6
𝐿𝑜𝑐𝑎𝑙𝐺𝑟𝑒𝑒𝑑𝑦𝐵𝑑= max{𝛾(𝐺𝑀𝑣),𝛾(𝐺𝑀𝑤)}
7
if 𝐿𝑜𝑐𝑎𝑙𝐺𝑟𝑒𝑒𝑑𝑦𝐵𝑑< min{𝑖𝑛𝑠𝐹,𝑑𝑒𝑙𝐹} then
8
renF = BPM(v, w)
/* Lines 19-21 from Algorithm 1
*/
9 return dt(𝑟𝑜𝑜𝑡(𝑇1), 𝑟𝑜𝑜𝑡(𝑇2))
We discuss Wang's algorithm [55], the fastest known algorithm
that (with some adaptions to JSON trees) computes JediOrder. Wang's
algorithm is faster than JEDI (quadratic vs. cubic) and requires less
space. It turns out, however, that Wang's algorithm is still too slow
to be used as an upper bound filter. The upper bound is computed
for all tree pairs, but can only avoid the JEDI computation when
the upper bound is within the threshold 𝜏. Whenever the upper
bound is larger than 𝜏(including the cases when the true distance
is larger), JEDI must be computed in addition to JediOrder.
To pay off, the upper bound filter must incur very low cost
compared to the computation of the exact distance. To this end, we
develop a new algorithm, called JOFilter, that takes the similarity
threshold 𝜏into account. JOFilter only assesses whether JediOrder
is within threshold 𝜏(which is enough for the filter purpose) and
avoids computing the exact JediOrder value otherwise. With a
clever tree traversal that considers only relevant node pairs, we
achieve linear runtime (vs. quadratic runtime of Wang's algorithm).
4.1
Tree Sorting and Upper Bound Guarantee
JediOrder sorts the children of object nodes in a JSON document
lexicographically by their keys; recall that the keys are string liter-
als that are unique within an object. The result is an ordered JSON
tree in which all sibling collections are totally ordered (cf. Figure 7).
JediOrder computes the minimal, edit-based distance between sorted
JSON trees. Thanks to the order, JediOrder does not need to com-
pute a bipartite graph matching, 𝐵𝑃𝑀(𝑣,𝑤), between the children
of two nodes 𝑣and 𝑤; instead, the cheaper sequence edit distance,
𝑆𝐸𝐷(𝑣,𝑤), is evaluated (cf. Section 3.1). Formally, JediOrder is de-
fined as the cost of the min-cost mapping that satisfies Definition 2.
Definition 2 (Ordered JSON Edit Mapping). A JSON edit
mapping 𝑀is ordered iff for any node pairs (𝑣,𝑤), (𝑣′,𝑤′) ∈𝑀:
• 𝑣is to the left1 of 𝑣′ iff 𝑤is to the left of 𝑤′ [order].
Example 7. Considering the (ordered) JSON edit mappings in
Figures 2 and 7, 𝐽𝐸𝐷𝐼(𝑇1,𝑇2) = 5 vs. 𝐽𝑒𝑑𝑖𝑂𝑟𝑑𝑒𝑟(𝑇1,𝑇2) = 8. Due to
the lexicographical order of the key nodes in Figure 7, the node pairs
(𝑣9,𝑤5) and (𝑣10,𝑤6) violate the order constraint and are not in the
minimum-cost ordered JSON edit mapping.
1𝑣is to the left of 𝑣′ if 𝑣is not a descendant of 𝑣′ and precedes 𝑣′ in postorder.

---

Hütter, et al.
{ }
𝑣11
"cast"
𝑣6
{ }
𝑣5
"Han"
𝑣2
"Ford"
𝑣1
"Leia"
𝑣4
"Fisher"
𝑣3
"r.time"
𝑣8
125
𝑣7
"title"
𝑣10
"Star..."
𝑣9
{ }
𝑤9
"cast" 𝑤4
[ ]
𝑤3
"Ford"
𝑤1
"Fisher"
𝑤2
"name"
𝑤6
"Star..."
𝑤5
"r.time" 𝑤8
125 𝑤7
𝑇1
𝑇2
Figure 7: Sorted JSON trees from Figure 2 including the or-
dered JSON edit mapping –, postorder numbers vi and wj,
and favorable children •.
The order constraint in Definition 2 subsumes the array-order in
Definition 1, thus JediOrder provides an upper bound for JEDI.
Theorem 3 (JediOrder Upper Bound). Given JSON trees 𝑇1, 𝑇2,
then 𝐽𝑒𝑑𝑖𝑂𝑟𝑑𝑒𝑟(𝑇1,𝑇2) ≥𝐽𝐸𝐷𝐼(𝑇1,𝑇2).
Proof. By contradiction. Assume an ordered JSON edit mapping
𝑀𝐽𝑂with cost 𝛾(𝑀𝐽𝑂) = 𝐽𝑒𝑑𝑖𝑂𝑟𝑑𝑒𝑟(𝑇1,𝑇2) and a JSON mapping
𝑀with cost 𝛾(𝑀) = 𝐽𝐸𝐷𝐼(𝑇1,𝑇2) such that 𝐽𝑒𝑑𝑖𝑂𝑟𝑑𝑒𝑟(𝑇1,𝑇2) <
𝐽𝐸𝐷𝐼(𝑇1,𝑇2). Since 𝑀𝐽𝑂by Def. 2 is also a JSON edit mapping,
𝛾(𝑀) is not minimal, which contradicts 𝛾(𝑀) = 𝐽𝐸𝐷𝐼(𝑇1,𝑇2).
□
4.2
JediOrder Baseline: Wang's Algorithm
JediOrder is based on sorted, hence, ordered trees. As a baseline
algorithm for JediOrder, we adapt the state-of-the-art constraint
tree edit distance algorithm by Wang and Zhang [55], which runs
in 𝑂(|𝑇1||𝑇2|) time and 𝑂(|𝑇2| log |𝑇1|) space, to JSON trees.
Recursive Solution: The recursive solution discussed in Section 3.1
(cf. Eq. 1-3 and Lemma 1) also holds for JediOrder. Due to the total
order among siblings, the minimum-cost matching in Eq. 2c is
always computed by the sequence edit distance (rather than the
more expensive bipartite graph matching). Zhang [60] shows the
correctness of the recursion.
Memory Efficient Implementation: Similar to Algorithm 1, Wang's
algorithm uses dynamic programming and a nested loop over all
node pairs of the input trees 𝑇1 and 𝑇2. To reduce the memory
complexity, Wang implements two key ideas: (1) The deletion and
rename costs of a node 𝑣∈𝑇1 (delF/delT and renF/renT in Algo-
rithm 1) w.r.t. all nodes 𝑤∈𝑇2 (inner loop) are computed incre-
mentally while the children of 𝑣are processed (in the outer loop).
The required cost arrays of size |𝑇2| are maintained with each node
𝑣; they are allocated when the first child of 𝑣is processed and are
released after processing 𝑣. (2) The nodes of 𝑇1 (outer loop) are
processed in favorable child order, a postorder traversal that visits
the so-called favorable child (defined as the child with the largest
subtree) first and all other children in the usual left-to-right order.
This traversal guarantees that only log |𝑇1| nodes 𝑣∈𝑇1 maintain
their cost arrays concurrently, thus reducing the memory com-
plexity from quadratic to 𝑂(|𝑇2| log |𝑇1|). In Figure 7, the favorable
children of 𝑇1 are marked with an orange bullet •.
We will reuse these concepts and in addition leverage the simi-
larity threshold to evaluate the JediOrder filter in linear time.
4.3
Leveraging the Distance Threshold
In the similarity lookup scenario, we are only interested in assessing
whether JediOrder is within the similarity threshold 𝜏. Hence, we
do not need to consider mappings 𝑀𝐽𝑂with a cost larger than 𝜏.
On top of the two optimizations of Wang's algorithm (cf. Sec-
tion 4.2), we add a third key idea: (3) leverage the user-defined
similarity threshold 𝜏in combination with the postorder lower
bound (cf. Lemma 3) to reduce the number of relevant node pairs.
Lemma 3 (Postorder Lower Bound [31]). Given an ordered
JSON edit mapping 𝑀𝐽𝑂with cost 𝛾(𝑀𝐽𝑂), for every node pair
(𝑣,𝑤) ∈𝑀𝐽𝑂the following holds: |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| ≤𝛾(𝑀𝐽𝑂).
Proof. Proof by contradiction adapted from Hütter et al. [31].
Assume a node pair (𝑣,𝑤) ∈𝑀𝐽𝑂with |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| >
𝛾(𝑀𝐽𝑂). Due to the ancestor (cf. Definition 1) and order (cf. Def-
inition 2) constraints, the nodes 𝑣𝑖with 𝑝𝑜𝑠𝑡(𝑣𝑖) < 𝑝𝑜𝑠𝑡(𝑣) can
only be mapped to the nodes 𝑤𝑗with 𝑝𝑜𝑠𝑡(𝑤𝑗) < 𝑝𝑜𝑠𝑡(𝑤). Since
|𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| > 𝛾(𝑀𝐽𝑂), there must be at least |𝑝𝑜𝑠𝑡(𝑣) −
𝑝𝑜𝑠𝑡(𝑤)| unmapped nodes. Therefore, the overall mapping cost is
greater than 𝛾(𝑀𝐽𝑂) which contradicts the assumption.
□
In similarity queries, the distance is bounded by the threshold
𝜏. Therefore, Lemma 3 implies that there are only 2𝜏+ 1 eligible
mapping partners 𝑤∈𝑇2 for a given node 𝑣∈𝑇1 such that the cost
of the overall ordered JSON edit mapping is within 𝜏. We refer to
the eligible nodes 𝑤∈𝑇2 as the 𝜏-range of a node 𝑣∈𝑇1.
Example 8. Consider the JSON trees in Figure 7 and a threshold
𝜏= 2. Any ordered JSON edit mapping that maps 𝑣6 to a node in 𝑇2
and has a cost of at most 𝜏must map node 𝑣6 to a node in its 𝜏-range,
i.e., 𝑤4, 𝑤5, 𝑤6, 𝑤7, or 𝑤8.
Our goal is to apply the 𝜏-range in Wang’s algorithm to avoid the
nested loop over all node pairs. In particular, we strive to replace
the inner loop over all nodes of 𝑇2 by a constant 𝜏-range of 2𝜏+ 1
nodes. This has an impact on the computation of the tree, the forest,
and the sequence edit distance (SED) matrices.
In the tree and forest distance matrix, at most 2𝜏+1 cells are filled
per row. The other cells are guaranteed to exceed the threshold due
to the 𝜏-range and do not need to be computed. Whenever these
cells appear in a minimum computation, their value is considered
to be infinite. If the overall mapping cost is within the threshold,
the matrices store the correct JediOrder values. The correctness
proof for the tree and the forest distance matrix is similar to the
proof for the SED matrix, which we discuss in detail below.
We leverage the 𝜏-range also for SED, which is used to compute
the minimum-cost matching between the ordered children of two
nodes. A sequence edit matching must satisfy Definition 3.
Definition 3 (Seqence Edit Matching). Matching 𝑀𝑆𝐸𝐷(𝑚,𝑛)
⊆𝑐ℎ𝑑(𝑚) × 𝑐ℎ𝑑(𝑛), 𝑚∈𝑇1 and 𝑛∈𝑇2, is a sequence edit matching
iff for any pairs (𝑣,𝑤), (𝑣′,𝑤′) ∈𝑀𝑆𝐸𝐷(𝑚,𝑛) the following holds:
• 𝑣= 𝑣′ iff 𝑤= 𝑤′ [one-to-one],
• 𝑣is to the left of 𝑣′ iff 𝑤is to the left of 𝑤′ [order].
Restricting SED to the 𝜏-range results in 𝜏-restricted SED match-
ings and the corresponding 𝜏-sequence edit distance (𝜏SED).

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
Definition 4 (𝜏-restricted). Let 𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛), 𝑚∈𝑇1 and 𝑛∈
𝑇2, be a sequence edit matching. 𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛) is 𝜏-restricted iff for
any pair (𝑣,𝑤) ∈𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛) the following holds:
• |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| ≤𝜏[𝜏-range].
The cost of a minimal SED matching 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)) is identical
to the cost of a minimal 𝜏-restricted SED matching 𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛))
whenever the overall JediOrder value is within the threshold 𝜏(cf.
Theorem 4). Otherwise,𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) provides an upper bound on
𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)) and hence an upper bound on 𝛾(𝑀𝐽𝑂) is computed.
However, only tree pairs with 𝛾(𝑀𝐽𝑂) ≤𝜏have to be considered
in a similarity lookup.
Theorem 4 (Exact 𝜏𝑆𝐸𝐷). If the minimal ordered JSON edit
mapping 𝑀𝐽𝑂between 𝑇1 and 𝑇2 has a cost of 𝛾(𝑀𝐽𝑂) ≤𝜏, then
𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) = 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)) for any node pair (𝑚,𝑛) ∈𝑀𝐽𝑂.
Proof. By contradiction and case distinction. Suppose𝛾(𝑀𝐽𝑂) ≤
𝜏and 𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) ≠𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)). We consider the following
cases:
Case 1 (𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) < 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛))): A 𝜏-restricted sequence
edit matching is also a sequence edit matching (cf. Definition 4)
which contradicts the minimality of the sequence edit matching.
Case 2.1 (𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) > 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)) and 𝛾(𝑀𝐽𝑂) = 𝜏): The
𝜏-restricted and unrestricted sequence edit matchings are identical
by definition which contradicts 𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) > 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)).
Case 2.2 (𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) > 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)) and 𝛾(𝑀𝐽𝑂) < 𝜏):
|𝑝𝑜𝑠𝑡(𝑚) −𝑝𝑜𝑠𝑡(𝑛)| ≤𝛾(𝑀𝐽𝑂) is stricter than |𝑝𝑜𝑠𝑡(𝑚)−𝑝𝑜𝑠𝑡(𝑛)| ≤
𝜏which contradicts 𝛾(𝑀𝜏𝑆𝐸𝐷(𝑚,𝑛)) > 𝛾(𝑀𝑆𝐸𝐷(𝑚,𝑛)).
□
Note that 𝜏SED is superior to a simple approach that uses a
threshold on the string edit distance [44]. While 𝜏SED prunes based
on the postorder positions in the tree, the latter approach prunes
based on the position in the string/sequence. Hence, for subtrees
of size larger than one, 𝜏SED provides better pruning power than
the simple approach, and the same pruning power otherwise.
Example 9. Table 2 shows the SED matrix for the root nodes 𝑣11
and 𝑤9 of the trees in Figure 7. Consider node 𝑣8 (at sequence position
2 and postorder 8) and a threshold 𝜏= 2. The unrestricted SED
must compute all cells of the matrix. The simple threshold-based
approach for the string edit distance must compute all cells for nodes
with sequence positions 2 ± 2, i.e., all nodes 𝑤𝑐∈𝑐ℎ𝑑(𝑤9) must be
considered. 𝜏SED, however, only computes the cells in the 𝜏-range of
the postorder positions (highlighted in green), e.g., for node 𝑣8 only
nodes with postorder positions 8±2 (𝑤6 and 𝑤8) need to be considered.
chd(𝑤9)
SED
𝜖
𝑤4
𝑤6
𝑤8
chd(𝑣11)
𝜖
0
4
6
8
𝑣6
6
4
6
8
𝑣8
8
6
6
6
𝑣10
10
8
7
8
Table 2: SED(v11, w9) matrix of the root nodes in Figure 7. For
threshold τ = 2, τSED only computes the cells highlighted in
green.
Algorithm 3: Wang(𝑇1,𝑇2,𝜏)
Input: JSON trees 𝑇1 and 𝑇2, and threshold 𝜏.
/* Outline of SED computation in Wang's algorithm.
*/
1 for 𝑣in 𝑇1 do
2
for 𝑤in 𝑇2 with |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| ≤𝜏do
3
for 𝑐in 𝑐ℎ𝑑(𝑤) do
4
Compute cell (v,c) of the SED(p(v), w) matrix.
𝑣18
𝑣2
𝑣5
𝑣17
𝑤18
𝑤2
𝑤5
𝑤17
Figure 8: Two identical JSON trees T1 and T2.
4.4
Challenges of Applying the 𝜏-Range
For the loop variables 𝑣∈𝑇1 and 𝑤∈𝑇2, Wang computes row 𝑣of
the SED(𝑝(𝑣),𝑤) matrix (cf. Algorithm 3). This matrix has a row
for each child of 𝑝(𝑣) and a column for each child of 𝑤.
To apply the 𝜏-range in Wang's algorithm, (1) the inner loop over
all node pairs must be restricted to the nodes in the 𝜏-range and
(2) the SED must be 𝜏-restricted. Unfortunately, extending Wang's
algorithm with the 𝜏-range (highlighted in line 2, Algorithm 3) will
lead to incorrect results. Consider the matrix of the SED(𝑣18,𝑤18)
computation between the two identical JSON trees in Figure 8 with
𝜏= 2. Wang's algorithm computes row 𝑣2 while processing 𝑣2 in
the outer loop and 𝑤18 in the inner loop. However, 𝑤18 is not in
the 𝜏-range of 𝑣2; hence the node pair (𝑣2,𝑤18) is not considered
in the nested loop, and row 𝑣2 in the SED matrix is not filled.
4.5
The JOFilter Algorithm
We now present a novel algorithm, called JOFilter, that assesses
whether JediOrder is within a given threshold 𝜏. Our solution is
able to leverage all key ideas of the space-efficient algorithm by
Wang (incremental cost computation and favorable child order,
cf. Section 4.2) and the 𝜏-range introduced in Section 4.3. In the
following, we discuss the key challenges that must be addressed
and show that JOFilter runs in 𝑂(𝑛𝜏) time and 𝑂(𝑛+𝜏log𝑛) space.
Cost arrays of size 𝜏. Similar to Wang's algorithm, we split the
auxiliary matrices into rows and store each row with the relevant
nodes 𝑣∈𝑇1. A node 𝑣maintains the following data: row 𝑣of
(1) the tree and (2) the forest distance matrix, denoted v.dt and
v.df, respectively; (3) the tree distance matrix row of 𝑣’s favorable
child, v.dtfc; finally, (4) two rows of the SED(𝑣,𝑤) matrices for
all 𝑤∈𝑇2, denoted 𝑣.𝑠𝑒𝑑𝐿0, and 𝑣.𝑠𝑒𝑑𝐿1, which are sufficient to
compute SED [28]. Due to the 𝜏-range, the size of these cost arrays
(i.e., matrix rows) can be reduced from 𝑂(|𝑇2|) in Wang's algorithm
to 𝑂(𝜏) in JOFilter. Summarizing, a node 𝑣∈𝑇1 stores auxiliary
data of size 𝑂(𝜏). Moreover, the insertion (resp. deletion) costs of
node 𝑣in the forest, tree, and SED matrices, denoted v.df𝜖, v.dt𝜖,
and v.se𝑑𝜖, are stored in global arrays of size |𝑇2|.
Logarithmic number of active nodes. A node is called active while
the node and its auxiliary data are held in main memory. A node 𝑣

---

Hütter, et al.
Algorithm 4: JOFilter(𝑇1,𝑇2,𝜏)
Input: JSON trees 𝑇1 and 𝑇2, and threshold 𝜏.
/* Outline of SED computation in the JOFilter.
*/
1 for 𝑣in 𝑇1 do
2
for 𝑤in 𝑇2 with |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| ≤𝜏do
3
Compute cell (v,w) of the SED(p(v), p(w)) matrix.
becomes active when its favorable child is processed and inactive
after 𝑣itself was processed. The favorable child order guarantees
that at most 𝑂(log |𝑇1|) nodes are active at any time [55].
Applying the 𝜏-range. We apply the 𝜏-range by replacing the
inner loop over all nodes 𝑤∈𝑇2 by a constant range of 2𝜏+1 nodes.
As shown in Section 4.4, applying the 𝜏-range in Wang's algorithm
leads to incorrect results. We therefore adapt the computation order
of the values in the SED computation as shown in Algorithm 4:
only a single cell (𝑣,𝑤) of the SED(𝑝(𝑣), 𝑝(𝑤)) matrix is filled in
the inner loop rather than an entire matrix row. Since 𝑣and 𝑤are
the loop variables, we guarantee that all node pairs in the 𝜏-range
are considered in the SED computation.
Algorithm. We present the pseudocode of our solution, JOFilter,
in Algorithm 5. Note that 𝑙𝑠(𝑣) denotes the left sibling of node 𝑣and
a dot ’.’ accesses the data of a given node. The nodes 𝑣∈𝑇1 (outer
loop) are traversed in favorable child order, while the nodes 𝑤∈𝑇2
(inner loop) are traversed in postorder. To avoid the computation
between all node pairs, we apply the 𝜏-range (cf. Lemma 3) in the
inner loop. Assuming that the rename and deletion costs are given,
we first compute the tree and forest distance between nodes 𝑣and
𝑤(cf. lines 4-9). In the remainder of the algorithm (cf. lines 10-28),
the deletion and rename costs for the parent of node 𝑣are computed
incrementally. After processing all node pairs, the overall distance
is stored in the tree distance matrix line of the root node of 𝑇1,
𝑟𝑜𝑜𝑡(𝑇1).𝑑𝑡(𝑟𝑜𝑜𝑡(𝑇2)). The filter only accepts a tree pair (𝑇1,𝑇2) iff
JediOrder(𝑇1,𝑇2) ≤𝜏(cf. line 29).
Complexity. For each node 𝑣∈𝑇1 only 2𝜏+ 1 nodes 𝑤∈𝑇2 are
considered (cf. Lemma 3). Therefore, the overall time complexity is
𝑂(|𝑇1|𝜏). The space complexity is dominated by the global arrays
of size 𝑂(|𝑇2|) that store the insertion (resp. deletion) costs of node
𝑣in the forest, tree, and SED matrices. Each active node fits in 𝑂(𝜏)
space and there are at most 𝑂(log |𝑇1|) active nodes at any point in
time, leading to an overall space complexity of 𝑂(|𝑇2| + 𝜏log |𝑇1|).
5
JSIM: JSON SIMILARITY INDEX
We now present the JSIM index for JSON similarity queries and
discuss the use of index and filters in the similarity query context.
The input to the JSIM index over a tree database T is a query tree
𝑇𝑞and a threshold 𝜏, the output is a candidate set 𝐶⊆T that is a
superset of the query result, 𝑅= {𝑇𝑖∈T | 𝐽𝐸𝐷𝐼(𝑇𝑞,𝑇𝑖) ≤𝜏} ⊆𝐶.
Existing indexing techniques for tree similarity queries [31, 49]
require ordered trees. They leverage concepts that (due to the miss-
ing order of object nodes) are not applicable to JSON, e.g., the
postorder position of nodes in the tree [31] or an order-based parti-
tioning of trees into subgraphs [49]. Sorting JSON trees does not
solve the problem: The distance between sorted trees may increase
w.r.t. JEDI such that the index fails to retrieve relevant trees.
Algorithm 5: JOFilter(𝑇1,𝑇2,𝜏)
Input: JSON trees 𝑇1 and 𝑇2, and threshold 𝜏.
Result: True if JediOrder(𝑇1, 𝑇2) ≤𝜏, False otherwise.
1 for 𝑣in 𝑇1 do
/* Favorable child order */
2
p = p(v)
3
for 𝑤with |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| ≤𝜏do
/* Postorder */
/* Cost for inserting node 𝑤.
*/
4
insF = w.df𝜖+ min𝑐∈𝑐ℎ𝑑(𝑤){v.df(c) - c.df𝜖}
5
insT = w.dt𝜖+ min𝑐∈𝑐ℎ𝑑(𝑤){v.dt(c) - c.dt𝜖}
/* Costs for deleting and renaming already computed. */
6
renF = v.sed𝐿0(𝑤𝑡)
/* 𝑤’s rightmost child 𝑤𝑡. */
7
v.df(w) = min{insF, v.delF(w), renF}
8
renT = v.df(w) + min{𝛾(𝑣,𝑤), 𝛾(𝑣, 𝜆) + 𝛾(𝜆,𝑤)}
9
v.dt(w) = min{insT, v.delT(w), renT}
/* Compute deletion and rename costs for parent.
*/
10
if v is favorable child then
11
p.dtfc(w) = v.dt(w)
12
p.delF(w) = v.df𝜖+ v.df(w) - v.df𝜖
13
p.delT(w) = v.dt𝜖+ v.dt(w) - v.dt𝜖
14
else
15
p.delF(w) = min{p.delF(w), p.df(0)+v.df(w)-v.df(0)}
16
p.delT(w)=min{p.delT(w), p.dt(0)+v.dt(w)-v.dt(0)}
17
if v is left-most child then
18
p.sed𝐿1(0) = p.sed𝐿0(0) + v.dt𝜖
19
p.sed𝐿1(w) = min{p.sed𝐿1(ls(w)) + w.dt𝜖, w.sed𝜖+
v.dt𝜖, ls(w).sed𝜖+ v.dt(w)}
20
else if v is not favorable child then
21
p.sed𝐿1(0) = p.sed𝐿0(0) + v.dt𝜖
22
p.sed𝐿1(w) = min{p.sed𝐿1(ls(w)) + w.dt𝜖,
p.sed𝐿0(w) + v.dt𝜖, p.sed𝐿0(ls(w)) + v.dt(w)}
23
if v is left sibling of favorable child cf then
24
p.sed𝐿0(0) = p.sed𝐿1(0) + p.dtfc(0)
25
for 𝑤with |𝑝𝑜𝑠𝑡(𝑣) −𝑝𝑜𝑠𝑡(𝑤)| ≤𝜏do
26
p.sed𝐿0(w) = min{p.sed𝐿0(ls(w)) + w.dt𝜖,
p.sed𝐿0(w) + p.dtfc(0), p.sed𝐿0(ls(w)) + p.dtfc(w)}
27
else
28
p.sed𝐿0 = p.sed𝐿1
29 return root(𝑇1).dt(root(𝑇2)) ≤𝜏
Our JSIM index leverages a novel lower bound for JSON trees,
called JSON region bound, that is based on the position of a node in
the tree. Based on this lower bound and a node label filter, we build
an effective multi-level index that only returns trees 𝑇𝑖∈T that
pass all filters. Moreover, we introduce a technique that decreases
the search threshold level by level during the index lookup. This
allows us to aggressively prune index branches at deeper index
levels.
5.1
Leveraging Node Position and Labels
We now present the JSON region bound that is based on the ancestor
constraint of the JSON edit mapping in Definition 1. Assume that
the node pair (𝑣,𝑤) in Figure 9 is mapped; then, 𝑎𝑛𝑐(𝑣) must be
mapped to 𝑎𝑛𝑐(𝑤) (red), 𝑑𝑒𝑠𝑐(𝑣) to 𝑑𝑒𝑠𝑐(𝑤) (green), and 𝑙𝑟(𝑣) to

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
𝑙𝑟(𝑤) (blue). The left-right nodes 𝑙𝑟(𝑣) of node 𝑣are all nodes in 𝑇𝑞
different from 𝑣, 𝑑𝑒𝑠𝑐(𝑣), and 𝑎𝑛𝑐(𝑣). Intuitively, the size difference
of the individual regions imposes a lower bound on the respective
mapping cost. For example, the cost of mapping the ancestors in
Figure 9 is at least one.
v
anc(v)
lr(v)
lr(v)
desc(v)
𝑤
anc(w)
lr(w)
lr(w)
desc(w)
Figure 9: Due to the ancestor constraint, mapping node v to
w splits the JSON tree into three regions.
Lemma 4 (JSON Region Bound). Let 𝑇1, 𝑇2 be JSON trees, 𝑀a
JSON edit mapping from 𝑇1 to 𝑇2. For a given similarity threshold 𝜏,
if the cost of the mapping is 𝛾(𝑀) ≤𝜏, then for each (𝑣,𝑤) ∈𝑀:
||𝑑𝑒𝑠𝑐(𝑣)|−|𝑑𝑒𝑠𝑐(𝑤)||+||𝑎𝑛𝑐(𝑣)|−|𝑎𝑛𝑐(𝑤)||+||𝑙𝑟(𝑣)|−|𝑙𝑟(𝑤)|| ≤𝜏.
Proof. The proof is by contradiction: Suppose 𝛾(𝑀𝐷𝑃𝐽𝐸𝐷) ≤
𝜏and ||𝑑𝑒𝑠𝑐(𝑣)| −|𝑑𝑒𝑠𝑐(𝑤)|| + ||𝑎𝑛𝑐(𝑣)| −|𝑎𝑛𝑐(𝑤)|| + ||𝑙𝑟(𝑣)| −
|𝑙𝑟(𝑤)|| > 𝜏. Due to the ancestor constraint of the edit mapping (cf.
Definition 1) any (𝑣′,𝑤′) ∈𝑀𝐷𝑃𝐽𝐸𝐷must either be in 𝑑𝑒𝑠𝑐(𝑣) ×
𝑑𝑒𝑠𝑐(𝑤), 𝑎𝑛𝑐(𝑣) ×𝑎𝑛𝑐(𝑤), or 𝑙𝑟(𝑣) ×𝑙𝑟(𝑤). From the initial assump-
tion, we know that more than 𝜏edit operations are needed to adjust
the sizes of these regions which contradicts 𝛾(𝑀𝐷𝑃𝐽𝐸𝐷) ≤𝜏.
□
Tightening the Bound. An interesting observation is that when
we know one of the size differences in Lemma 4, e.g., Δ = ||𝑑𝑒𝑠𝑐(𝑣)|−
|𝑑𝑒𝑠𝑐(𝑤)||, we can tighten the bound for the remaining, unknown
differences: ||𝑎𝑛𝑐(𝑣)| −|𝑎𝑛𝑐(𝑤)|| + ||𝑙𝑟(𝑣)| −|𝑙𝑟(𝑤)|| ≤𝜏−Δ. We
leverage this effect to prune branches in our index traversal.
Label Intersection. A well known lower bound is based on the bag
intersection of node labels [3]. For JSON trees, we need to replace
node labels by (𝑙𝑎𝑏𝑒𝑙,𝑡𝑦𝑝𝑒) pairs. Then, the following holds:
𝐽𝐸𝐷𝐼(𝑇1,𝑇2) ≥𝑚𝑎𝑥(|𝑁(𝑇1)|, |𝑁(𝑇2)|) −|𝑁(𝑇1) ` 𝑁(𝑇2)|.
(8)
5.2
Index Structure and Lookup
We discuss the structure of the JSIM index and our lookup technique
that leverages the filters discussed in Section 5.1.
Building the Index. JSIM is a tree with four levels that store (1)
node labels, (2) descendant counts, (3) ancestor counts, and (4) left-
right node counts, respectively. Each index node is a sorted list of
entries that either points to a child node (non-leaf entry) or to a list
of indexed trees (leaf entries).
A new tree 𝑇𝑖is inserted |𝑇𝑖| times into the index, once for each
node. Each node adds a constant number of (at most 5) index entries.
Therefore, the overall index size is proportional to the aggregated
number of nodes of the indexed JSON trees. The insert path for a
node 𝑣∈𝑇𝑖is determined by its label, its number of descendants,
ancestors, and left-right nodes. New values are inserted into the
respective index node, for existing values the child pointer is fol-
lowed. The process of inserting node 𝑣8 ∈𝑇1 from Figure 2 into the
I =
label
descendants
ancestors
left-
right
...
r.time
...
1
3
8
1
3
4
2
3
5
2
6
8
4
5
5
6
7
𝑇2
𝑇8
𝑇1
𝑇5
(a) Insert node 𝑣8 from Figure 2.
I =
...
r.time
...
1
3
8
1
3
4
2
3
5
2
6
8
4
5
5
6
7
𝑇2
𝑇8
𝑇1
𝑇5
−𝜏
+𝜏
−𝜏𝑎
+𝜏𝑎
−𝜏𝑎
+𝜏𝑎
−𝜏𝑙𝑟
+𝜏𝑙𝑟
−𝜏𝑙𝑟
+𝜏𝑙𝑟
(b) Lookup node 𝑤8 from Figure 2.
Figure 10: JSIM index: four-level inverted list.
index is highlighted in Figure 10a (green). Tree 𝑇1 is inserted with
label = "r.time", |𝑑𝑒𝑠𝑐(𝑣8)| = 1, |𝑎𝑛𝑐(𝑣8)| = 1, and |𝑙𝑟(𝑣8)| = 8.
Index Lookup. The lookup for query tree𝑇𝑞processes 𝜏+1 nodes
𝑣∈𝑇𝑞, and for each node proceeds in two steps: (1) Label lookup:
Follow the branch for the label of 𝑣in the index root node. The
index lookup is limited to only 𝜏+ 1 nodes since any tree 𝑇𝑖that
has more than 𝜏+ 1 mismatching labels with 𝑇𝑞cannot be within
edit distance 𝜏[31, 38]. (2) Region traversal: We leverage Lemma 4
to traverse the remaining levels. At each node, we follow all keys 𝑘
(i.e., region counts) that fall into the range given by Lemma 4, e.g.,
𝑑= ||𝑑𝑒𝑠𝑐(𝑣)| −𝑘| ≤𝜏at the descendant count level. Note that each
of the three size differences (which are all positive) must be within
the threshold 𝜏. At the lower index levels, we leverage the size
difference that we know from previous levels, e.g., the threshold
for the ancestor level can be decreased to 𝜏𝑎= 𝜏−𝑑and the index
verifies all keys 𝑘𝑎with 𝑎= ||𝑎𝑛𝑐(𝑣)|−𝑘𝑎| ≤𝜏𝑎. The process for the
fourth level is similar, we verify all keys 𝑘𝑙𝑟with ||𝑙𝑟(𝑣)|−𝑘𝑙𝑟| ≤𝜏𝑙𝑟
against an even further reduced threshold 𝜏𝑙𝑟= 𝜏𝑎−𝑎. All trees in
the lists that we reach are candidates and are returned by the index.
For example, the lookup of node 𝑤8 ∈𝑇2 (Figure 2) is illustrated in
Figure 10b (blue) and returns 𝑇2,𝑇8,𝑇1,𝑇5.
Note that a search may end before reaching a leaf node when no
trees in the 𝜏-range are found. This desirable effect is boosted by
reducing the 𝜏-range at each level.
5.3
JSON Similarity Lookups
We leverage our techniques (i.e., JSIM, JOFilter, and QuickJEDI)
to answer JSON similarity lookup queries as follows: (1) Lookup
query tree 𝑇𝑞with threshold 𝜏in the JSIM index to retrieve can-
didate set 𝐶. (2) For each tree 𝑇𝑖∈𝐶check the label intersection
lower bound in Eq. (8). (3) For the remaining candidates 𝑇𝑖∈𝐶′, if
𝐽𝑒𝑑𝑖𝑂𝑟𝑑𝑒𝑟(𝑇𝑞,𝑇𝑖) ≤𝜏, then 𝑇𝑖is a result pair. (4) Verify the remain-
ing candidates 𝑇𝑖∈𝐶′′ by computing 𝑄𝑢𝑖𝑐𝑘𝐽𝐸𝐷𝐼(𝑇𝑞,𝑇𝑖).
6
EXPERIMENTS
We experimentally evaluate our solution for JSON similarity lookups
on 22 real-world datasets in a unified C++ framework. The source
code [30] and the experimental data [29] are publicly available. The
experiments are executed single-threaded on an Intel Xeon E5-2630
v3 2.40GHz server with 16 cores and 96GB of RAM (Debian 10).

---

Hütter, et al.
4
6
8
10
12
14
Threshold
101
102
103
104
Runtime [in ms]
(a) FENF, 𝑇50%.
20
40
60
80
Threshold
101
102
103
104
105
Runtime [in ms]
(b) Reddit, 𝑇75%.
10
20
30
40
50
Threshold
100
101
102
103
104
105
Runtime [in ms]
(c) Cards, 𝑇75%.
250
500
750
1000
1250
1500
1750
Threshold
103
104
Runtime [in ms]
(d) StanDev, 𝑇75%.
2
3
4
5
6
7
Threshold
0
100
101
102
103
104
Runtime [in ms]
(e) Movies, 𝑇25%.
50
100
150
200
250
Threshold
104
105
106
Runtime [in ms]
(f) NBA, 𝑇25%.
10
20
30
40
50
60
Threshold
104
Runtime [in ms]
(g) Device, 𝑇75%.
4
6
8
10
12
14
16
Threshold
100
101
Runtime [in ms]
(h) arXiv, 𝑇75%.
10
20
30
40
50
Threshold
101
102
103
104
Runtime [in ms]
(i) Twitter2, 𝑇50%.
4
6
8
10
12
14
Threshold
0
100
101
102
103
104
105
Runtime [in ms]
(j) DENF, 𝑇25%.
2
4
6
8
10
Threshold
102
103
Runtime [in ms]
(k) Schema, 𝑇25%.
5
10
15
20
25
Threshold
104
105
Runtime [in ms]
(l) SMSen, 𝑇50%.
Scan, QuickJEDI, JOFilter
JSIM, Baseline
JSIM, QuickJEDI
JSIM, Baseline, Wang
JSIM, QuickJEDI, JOFilter
Figure 11: Overall runtime: JSON similarity lookup query.
3
5
10
15
Threshold
100
101
102
103
104
#Trees
(a) FENF, 𝑇50%.
14
28
55
83
Threshold
100
101
#Trees
(b) Reddit, 𝑇75%.
9
18
35
53
Threshold
100
101
102
103
104
#Trees
(c) Cards, 𝑇75%.
318
635
1270
1905
Threshold
100
101
#Trees
(d) StanDev, 𝑇75%.
2
3
5
7
Threshold
100
101
102
103
104
105
106
#Trees
(e) Movies, 𝑇25%.
45
90
180
270
Threshold
100
101
102
103
104
#Trees
(f) NBA, 𝑇25%.
11
22
44
66
Threshold
100
101
102
103
104
105
#Trees
(g) Device, 𝑇75%.
3
6
11
17
Threshold
100
101
102
103
104
105
106
#Trees
(h) arXiv, 𝑇75%.
10
19
37
56
Threshold
100
101
102
103
104
#Trees
(i) Twitter2, 𝑇50%.
3
5
10
15
Threshold
100
101
102
103
#Trees
(j) DENF, 𝑇25%.
2
4
7
10
Threshold
100
101
102
103
104
#Trees
(k) Schema, 𝑇25%.
5
9
17
25
Threshold
100
101
102
103
104
#Trees
(l) SMSen, 𝑇50%.
Figure 12: Filter effectiveness: pruned by the ■JSIM index, ■label intersection, ■upper bound, and ■number of verifications.
6.1
Setup
Algorithms: We evaluate various algorithmic combinations. Scan de-
notes a linear scan, JSIM denotes our index (cf. Section 5), Wang is
the state-of-the-art JediOrder algorithm, JOFilter is our JediOrder fil-
ter (Algorithm 5), Baseline refers to the JEDI-baseline (Algorithm 1)
and QuickJEDI to our optimized version (Algorithm 2).
Datasets: The evaluation is performed on a collection of 22 real-
world JSON datasets. We summarize their most important charac-
teristics: Collection sizes of up to 8.76 million JSON trees; JSON tree
sizes of up to 48𝑘nodes; a type distribution within a JSON tree of
up to 20% objects, 10% arrays, 49% keys, and 49% literals; the degree
of object nodes is typically less than 20 with the exception of one
dataset (104); the degree of array nodes is up to 1603 values; one
dataset provides a depth of 50 (less than 14 for all other datasets).
We briefly describe the datasets used for the experiments in
Figures 11 and 12. (1) FENF [23]: FDA enforcement actions, ∼14𝑘
documents with an average of 49 nodes per document and a depth
of 3. (2) Reddit [43]: 25 Reddit articles with an average of 265 nodes
per document. This dataset provides the highest object degree of 104
children. (3) Cards [27]: ∼20𝑘Magic cards with an average number
of 132 nodes per document. (4) StanDev [53]: question-answering
dataset, 48 documents with up to ∼18𝑘nodes and an average of
5, 379 nodes per document. (5) Movies[40]: TV and movie ratings,
∼8.7 million documents with an average of 23 nodes per document.
(6) NBA [15]: ∼31𝑘NBA games with an average of 977 nodes per
document. (7) Device [23]: ∼150𝑘FDA enforcement actions with
up to 3, 264 nodes per document. (8) arXiv [52]: 1.8 million re-
search publications with an average of 53 nodes per publication. (9)
Twitter2 [51]: ∼19𝑘tweets with an average of 195 nodes per docu-
ment. (10) DENF [23]: ∼7𝑘FDA enforcement actions with an average
of 59 nodes per document. (11) Schema [5]: 81𝑘JSON schemas with
up to 48𝑘nodes per schema document. (12) SMSen [14]: ∼55𝑘SMS
messages with an average of 81 nodes per document.
Experimental Setup: For each dataset, we perform JSON similarity
lookup queries for three different query trees and four different
thresholds. Since the runtime of the distance algorithms depends on
the tree sizes, we pick the query trees that are closest to the 25%, 50%,
and 75% quantiles of the tree sizes for each dataset (denoted 𝑇25%,
𝑇50%, and 𝑇75%). The goal of similarity lookup queries is to return
documents that are similar to the query document, hence useful
thresholds depend on the size of the query tree. We experiment with

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
thresholds that are 5%, 10%, 20%, and 30% of the respective query
tree size. The timeout for computing the results for all thresholds
for a given algorithm and dataset is 24 hours.
Evaluation: We analyze the overall runtime and the effectiveness
of the introduced bounds. Each plot in Figure 11 and 12 shows the
results of a single experiment, i.e., a given dataset and query tree
for varying thresholds on the x-axis. For example, Figure 11a shows
the results for dataset FENF and the 50% quantile query tree 𝑇50%.
Figure 11 shows the overall lookup runtimes in milliseconds for
various algorithm combinations. Figure 12 evaluates the number
of trees pruned by the individual filters as well as the number of
required verifications. The total height of a bar is the number of
documents (i.e., trees) in the dataset, the colors distinguish the
tree pairs that are pruned by the JSIM index (orange), the label
intersection (red), the upper bound (purple), and the number of
verifications (blue). The runtime and effectiveness plots are aligned,
e.g., Figures 11a and 12a result from the same experiment.
The overall experiment includes 66 dataset/query combinations.
Due to space restrictions, we provide a representative selection that
covers the most relevant phenomena (cf. Figures 11 and 12).
6.2
Results
JSIM Index vs. Dataset Scan. We measure the effectiveness of
the index by the number of returned candidates (cf. Figure 12).
Especially for small thresholds, the returned candidates are orders of
magnitude smaller than the collection size (e.g., Figure 12h and 12e).
Due to the smaller number of candidates, the index outperforms
the scan in each experiment, e.g., the index is up to five orders of
magnitude faster in Figure 11j. For larger datasets (e.g., Figure 11e),
the index is needed to answer the query within the timeout. In some
scenarios, however, applying an index without further optimiza-
tions is not enough: The Reddit dataset used for the experiment
in Figure 11b only contains 25 documents; however, due to its ob-
ject degree of 104, verifying even a single candidate significantly
increases the runtime. As a result, scanning Reddit with our op-
timized algorithms (Scan, QuickJEDI, JOFilter) outperforms the
index-based solution with baseline verification (JSIM, Baseline).
In some cases, when the lookup result is empty, the query is an-
swered only within the index, i.e., neither the upper bound nor the
verification are computed (e.g., Figures 12h and 12j).
Wang vs. JOFilter. Next, we compare the state-of-the-art JediOrder
algorithm (Wang) with our optimized algorithm (JOFilter). The
experimental results show the behaviour expected based on the
runtime complexities of the algorithms. The complexity of JOFil-
ter depends on the threshold. Even for larger thresholds, JOFilter
is superior to Wang due to the quadratic complexity of the latter.
We compare the runtimes of Wang (purple) and JOFilter (blue) in
Figure 11. In Figure 11a, no candidates must be verified except for
threshold 15; hence the runtime improves from JOFilter alone. We
observe the largest improvements of JOFilter in Figures 11k and 11l,
where Wang is up to an order of magnitude slower.
In many scenarios (cf. Figures 12), the upper bound identifies
most of the result set and only few trees must be verified (blue
bar). However, the upper bound is applied to each candidate and
introduces additional overhead which may increase the runtime in
cases where the upper bound is not effective (cf. Figure 11f). These
results show that an efficient verification algorithm is indispensable.
Baseline Verification vs. QuickJEDI. We also evaluated the effect
of the optimized verification algorithm QuickJEDI over the baseline
without applying the upper bound (red stars vs. orange pentagons in
Figure 11). The complexities of both algorithms heavily depend on
the degrees of the trees. QuickJEDI aims at skipping the expensive
min-cost matching computation, which substantially reduces the
runtime. Consider the measurements for threshold 55 in Figures 11b
and 12b: even though only 16 trees have to be verified, the runtime
difference between the baseline and QuickJEDI is almost two orders
of magnitude. This results from the characteristics of the Reddit
dataset, where some documents feature up to 104 unordered key-
value pairs per object. Moreover, in 4 out of the 22 datasets the
lookup terminated within the timeout only in configurations that
include QuickJEDI (e.g., Figures 11f and 11i).
Summary. Overall, the best performance results are achieved by
combining the JSIM index, JOFilter, and QuickJEDI. This configu-
ration provides the lowest runtimes for 61 out of our total of 66
experiments and is the only one that is able to process all datasets
(e.g., Figure 11g) within 24 hours. Only in cases where the upper
bound is ineffective (cf. Figure 11f), QuickJEDI without JOFilter is
slightly better. These results are robust even when the characteris-
tics of the datasets vary, e.g., large documents (cf. Figure 11d) and
large collections (cf. Figure 11e). In 37 experiments, the query is
answered without applying a verification algorithm, i.e., the can-
didates returned by the index are equivalent to the result and are
verified by the upper bound, highlighting the filter effectiveness.
7
RELATED WORK
JSON Tree Representations. There exist multiple tree represen-
tations of JSON documents. Bourhis et al. [7] represent keys and
the array order as edges and values as leaf nodes; the approach by
Shukla et al. [46] is similar, but keys and the array order are inner
nodes instead of edges. Similar to our approach, Klettke et al. [34]
introduce three different types of nodes (object, array, property) in
addition to the label. Spoth et al. [47] use a tree containing atomic
values at the leaves and complex values in the inner nodes. These
representations either discard the object and the array information
or encode the information in the edges of a tree; both choices are
unsuitable for node edit operations. Tree representations of XML
data (e.g., by Augsten et al. [2]) cannot be applied in the context of
JSON since XML siblings are considered to be ordered.
JSON Similarity. To the best of our knowledge, there is only one
scientific work on JSON diffs. Cao et al. [12] present an algorithm
that computes a JSON patch based on the edit operations defined
in RFC6902 [9]. In an experimental study, a comparison to four
open source solutions was performed. However, the runtime and
space complexity of the presented algorithm was not discussed.
Further, the resulting patch is not minimal and therefore unsuitable
for similarity queries. Yahia et al. [56] proposed a YAML-based
language for describing change-detection strategies on JSON data.
Diff algorithms do exist for other hierarchical data formats.
Chawathe et al. [13] present an algorithm that computes minimal
diffs for LATEX and HTML documents. The following edit operations

---

Hütter, et al.
are considered: insert and delete leaf nodes, update the value of
any node, and subtree moves. The XML diffs by Cobena et al. [17]
consider insertions and deletions of subtrees, value updates of any
node, and moves of a node or a part of a subtree. Both approaches
operate on ordered trees and are therefore unsuitable for JSON.
JSON Schema. Most of the scientific work related to JSON deal
with schema extraction. Schemas are used as dataset descriptions
or to enable optimization techniques in database systems. Durner
et al. [19] present a solution to extract multiple local schemas for a
single dataset. The schemas are grouped based on the label sets of
the keys in a document. Baazizi et al. [4] introduce a parametric and
parallel schema inference algorithm. Klettke et al. [34] present a
schema extraction algorithm to identify structural outliers based on
structure identification graphs. While the goal of schema extraction
is different from that of similarity queries, JEDI could be used to
identify schemas for similar documents.
Tree Edit Distance. A well-known edit distance for hierarchical
data is the tree edit distance (TED). The current best algorithm for
ordered trees by Pawlik and Augsten [41] computes TED in cubic
time using quadratic memory. Computing TED for unordered trees
is NP-hard [62]. Further, TED was applied for different query types,
e.g., similarity joins [31] and top-k similarity joins [36]. However,
these techniques are not applicable for JSON since JSON trees
consist of ordered as well as unordered children. In fact, we showed
that a TED adaption for JSON results in an NP-hard problem.
Zhang introduced a constraint TED version which can be com-
puted in time 𝑂(𝑛2) for ordered [60] and 𝑂(|𝑇1| · |𝑇2| · (𝑑𝑒𝑔(𝑇1) +
𝑑𝑒𝑔(𝑇2)) · 𝑙𝑜𝑔2(𝑑𝑒𝑔(𝑇1) + 𝑑𝑒𝑔(𝑇2))) for unordered trees [61]. Sim-
ilar to TED, both algorithms are designed for either ordered or
unordered trees. We combined both approaches to construct the
baseline JEDI algorithm. As shown in our experimental evaluation,
we introduce heuristics that decrease the runtime of JEDI often
by orders of magnitude. The ordered constraint TED algorithm by
Wang et al. [55] using 𝑂(𝑛log𝑛) memory was used as a baseline
algorithm for JediOrder. We introduced a novel JediOrder algorithm
that improves the complexity to be linear in time and space.
Heuristics for the Unordered Tree Edit Distance. Due to the compu-
tational complexity of the unordered TED, a number of heuristics
have been presented. Augsten et al. [2] introduced an approxima-
tion based on tree decomposition, called windowed pq-grams, that
splits a tree into a set of smaller elements which are then com-
pared to the decomposition of another tree. They experimentally
showed that windowed pq-grams outperform other tree decom-
position algorithms (binary branches [57], path shingles [11], and
valid subtrees [25]). Rather than introducing approximations, we
defined an exact and minimal JEDI distance.
8
CONCLUSION AND FUTURE WORK
In this paper, we addressed the problem of JSON similarity lookup
queries: Given a query document 𝑇𝑞and a distance threshold 𝜏,
retrieve all documents from a JSON database T that are within
distance 𝜏from the query. We proposed (a) a lossless tree repre-
sentation for JSON, (b) JEDI, the first edit-based distance for JSON
documents, (c) the efficient QuickJEDI algorithm for JEDI, (d) the
JSIM index to efficiently retrieve candidate trees for JSON similarity
queries, and (e) JediOrder, an effective upper bound on JEDI. In our
experiments, we scaled JSON similarity lookup queries to databases
with millions of documents and JSON trees with thousands of nodes.
In an ongoing effort, our solution is being integrated into Apache
AsterixDB, an open-source big data management system that uses
partitioned-parallel query processing and a JSON-like data format.
ACKNOWLEDGMENTS
We thank Wail Alkowaileet, Daniel Kocher, Mateusz Pawlik, and
Zhihui Yang for valuable discussions. This work was supported by
the Austrian Marshall Plan Foundation, the Austrian Science Fund
(FWF): P 29859 and P 34962, the European Research Council (ERC)
under the European Union’s Horizon 2020 research and innovation
program, under grant agreement No. 695412, and the Czech Min-
istry of Education, Youth and Sports from the Czech Operational
Programme Research, Development, and Education, under grant
agreement No. CZ.02.1.01/0.0/0.0/15_003/0000421.
REFERENCES
[1] Sattam Alsubaiee, Yasser Altowim, Hotham Altwaijry, Alexander Behm, Vinayak
Borkar, Yingyi Bu, Michael Carey, et al. 2014. AsterixDB: A Scalable, Open Source
BDMS. Proceedings of the VLDB Endowment 7, 14, 1905–1916.
[2] Nikolaus Augsten, Michael Böhlen, Curtis Dyreson, and Johann Gamper. 2012.
Windowed pq-grams for approximate joins of data-centric XML. The VLDB
Journal 21, 4 (2012), 463–488.
[3] Nikolaus Augsten and Michael H Böhlen. 2013. Similarity joins in relational
database systems. Vol. 5. Morgan & Claypool Publishers.
[4] Mohamed-Amine Baazizi, Dario Colazzo, Giorgio Ghelli, and Carlo Sartiani. 2019.
Parametric schema inference for massive JSON datasets. The VLDB Journal 28, 4
(2019), 497–521.
[5] Mohamed Amine Baazizi, Dario Colazzo, Giorgio Ghelli, Carlo Sartiani, and
Stefanie Scherzinger. 2021. A JSON Schema Corpus. https://github.com/sdbs-
uni-p/json-schema-corpus.
[6] Dipti Borkar, Ravi Mayuram, Gerald Sangudi, and Michael Carey. 2016. Have
your data and query it too: From key-value caching to big data management. In
Proceedings of the 2016 International Conference on Management of Data. ACM,
239–251.
[7] Pierre Bourhis, Juan L Reutter, Fernando Suárez, and Domagoj Vrgoč. 2017. JSON:
data model, query languages and schema specification. In Proceedings of the 36th
Symposium on Principles of Database Systems. 123–135.
[8] Tim Bray. 2017. The JavaScript Object Notation (JSON) Data Interchange Format.
RFC 8259. RFC Editor. https://www.rfc-editor.org/rfc/rfc8259.txt
[9] Paul C Bryan and Mark Nottingham. 2013. JavaScript Object Notation (JSON)
Patch. RFC 6902. RFC Editor. https://www.rfc-editor.org/rfc/rfc6902.txt
[10] Jan P Buchmann, Mathieu Fourment, and Edward C Holmes. 2018. The Biological
Object Notation (BON): a structured file format for biological data. Scientific
reports 8, 1 (2018), 1–8.
[11] David Buttler. 2004. A short survey of document structure similarity algorithms.
Proceedings of the International Conference on Internet Computing 1, 3–9.
[12] Hanyang Cao, Jean-Rémy Falleri, Xavier Blanc, and Li Zhang. 2016. JSON Patch
for Turning a Pull REST API into a Push. In International Conference on Service-
Oriented Computing. Springer, 435–449.
[13] Sudarshan S Chawathe, Anand Rajaraman, Hector Garcia-Molina, and Jennifer
Widom. 1996. Change detection in hierarchically structured information. In
Proceedings of the 1996 International Conference on Management of Data. ACM,
493–504.
[14] Tao Chen and Min-Yen Kan. 2013. Creating a live, public short message service
corpus: the NUS SMS corpus. Language Resources and Evaluation 47, 2 (2013),
299–335.
[15] Mohamed L. Chouder, Stefano Rizzi, and Rachid Chalal. 2017. JSON Datasets for
Exploratory OLAP. https://doi.org/10.17632/CT8F9SKV97.1
[16] Circlecell. 2022. JSON Compare. https://jsoncompare.com/. Accessed: 2022-01-12.
[17] Gregory Cobena, Serge Abiteboul, and Amelie Marian. 2002. Detecting changes
in XML documents. In Proceedings of the 18th International Conference on Data
Engineering. IEEE, 41–52.
[18] SQL Docs. 2021. Full Text Search. https://docs.microsoft.com/en-us/sql/relational-
databases/search/full-text-search?view=sql-server-ver15. Accessed: 2022-01-12.
[19] Dominik Durner, Viktor Leis, and Thomas Neumann. 2021. JSON Tiles: Fast Ana-
lytics on Semi-Structured Data. In Proceedings of the 2021 International Conference
on Management of Data. ACM, 445–458.

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
[20] Vincent Emeakaroha, Philip Healy, Kaniz Fatema, and John Morrison. 2013.
Analysis of Data Interchange Formats for Interoperable and Efficient Data Com-
munication in Clouds. In IEEE/ACM 6th International Conference on Utility and
Cloud Computing. 393–398.
[21] EU. 2021. EU Open Data Portal. https://data.europa.eu. Accessed: 2022-01-12.
[22] Jan P Finis, Martin Raiber, Nikolaus Augsten, Robert Brunel, Alfons Kemper, and
Franz Färber. 2013. Rws-diff: flexible and efficient change detection in hierarchical
data. In Proceedings of the 22nd ACM international conference on Information &
Knowledge Management. 339–348.
[23] US Food and Drug Administration. 2017. FDA Enforcement Actions Dataset.
https://www.kaggle.com/fda/fda-enforcement-actions Accessed: 2022-01-12.
[24] Xinbo Gao, Bing Xiao, Dacheng Tao, and Xuelong Li. 2010. A survey of graph
edit distance. Pattern Analysis and Applications 13 (2010), 113–129.
[25] Minos Garofalakis and Amit Kumar. 2003. Correlating XML data streams using
tree-edit distance embeddings. In Proceedings of the 22nd Symposium on Principles
of Database Systems. 143–154.
[26] Zack Grossbart. 2021. JSON Diff. http://www.jsondiff.com. Accessed: 2022-01-12.
[27] Zachary Halpern. 2022.
Magic Cards Dataset.
https://mtgjson.com/api/v5/
AtomicCards.json. Accessed: 2022-01-12.
[28] Daniel S. Hirschberg. 1975. A linear space algorithm for computing maximal
common subsequences. Commun. ACM 18, 6 (1975), 341–343.
[29] Thomas Hütter. 2021. https://github.com/DatabaseGroup/jedi-experiments: SIG-
MOD 2022. https://doi.org/10.5281/zenodo.5807299
[30] Thomas Hütter. 2022. https://github.com/DatabaseGroup/jedi-experiments: SIG-
MOD 2022. https://doi.org/10.5281/zenodo.5881864
[31] Thomas Hütter, Mateusz Pawlik, Robert Löschinger, and Nikolaus Augsten. 2019.
Effective filters and linear time verification for tree similarity joins. In Proceedings
of the 35th International Conference on Data Engineering. IEEE, 854–865.
[32] Bumsuk Jang, SeongHun Park, and Young-guk Ha. 2017. A stream-based method
to detect differences between XML documents. Journal of Information Science 43,
1 (2017), 39–53.
[33] Taewoo Kim, Wenhai Li, Alexander Behm, Inci Cetindil, Rares Vernica, Vinayak
Borkar, Michael J Carey, and Chen Li. 2020. Similarity query support in big data
management systems. Information Systems 88 (2020), 101455.
[34] Meike Klettke, Uta Störl, and Stefanie Scherzinger. 2015. Schema extraction and
structural outlier detection for JSON-based NoSQL data stores. Datenbanksysteme
für Business, Technologie und Web (2015), 425–444.
[35] IBM Knowledge Center. 2022. Fuzzy search. https://www.ibm.com/support/
knowledgecenter/SSEPGG_11.5.0/com.ibm.db2.luw.admin.ts.doc/doc/c0058557.
html. Accessed: 2022-01-12.
[36] Daniel Kocher and Nikolaus Augsten. 2019. A scalable index for top-k subtree sim-
ilarity queries. In Proceedings of the 2019 International Conference on Management
of Data. ACM, 1624–1641.
[37] Erwin Leonardi and Sourav S Bhowmick. 2005. Detecting changes on unordered
XML documents using relational databases: a schema-conscious approach. In Pro-
ceedings of the 14th ACM International Conference on Information and Knowledge
Management. 509–516.
[38] Willi Mann, Nikolaus Augsten, and Panagiotis Bouros. 2016. An empirical evalu-
ation of set similarity join techniques. Proceedings of the VLDB Endowment 9, 9,
636–647.
[39] MongoDB. 2020. White paper: MongoDB Architecture Guide: Overview. Technical
Report. 12 pages. mongodb.com
[40] Jianmo Ni, Jiacheng Li, and Julian McAuley. 2019. Justifying Recommendations
using Distantly-Labeled Reviews and Fine-Grained Aspects. In Proceedings of the
2019 Conference on Empirical Methods in Natural Language Processing. 188–197.
[41] Mateusz Pawlik and Nikolaus Augsten. 2016. Tree edit distance: Robust and
memory-efficient. Information Systems 56 (2016), 157–173.
[42] PostgreSQL Documentation. 2021. Additional Supplied Modules. https://www.
postgresql.org/docs/current/pgtrgm.html. Accessed: 2022-01-12.
[43] Reddit. 2021. Reddit Dataset. https://www.reddit.com/r/science.json. Accessed:
2022-01-12.
[44] João Setubal and João Meidanis. 1997. Introduction to Computational Biology.
PWS Publishing Company.
[45] Zeyuan Shang, Yaxiao Liu, Guoliang Li, and Jianhua Feng. 2017.
K-Join:
Knowledge-Aware Similarity Join. In Proceedings of the 33rd International Confer-
ence on Data Engineering. IEEE, 23–24.
[46] Dharma Shukla, Shireesh Thota, Karthik Raman, Madhan Gajendran, Ankur
Shah, Sergii Ziuzin, Krishnan Sundaram, et al. 2015. Schema-agnostic indexing
with Azure DocumentDB. Proceedings of the VLDB Endowment 8, 12, 1668–1679.
[47] William Spoth, Ting Xie, Oliver Kennedy, Ying Yang, Beda Hammerschmidt,
Zhen Hua Liu, and Dieter Gawlick. 2018.
SchemaDrill: Interactive Semi-
Structured Schema Design. In Proceedings of the Workshop on Human-In-the-Loop
Data Analytics. 1–7.
[48] Kuo-Chung Tai. 1979. The tree-to-tree correction problem. J. ACM 26, 3, 422–433.
[49] Yu Tang, Yilun Cai, and Nikos Mamoulis. 2015. Scaling similarity joins over
tree-structured data. Proceedings of the VLDB Endowment 8, 11, 1130–1141.
[50] Robert Endre Tarjan. 1983. Data structures and network algorithms. SIAM.
[51] Twitter. 2022. Twitter Developer Platform.
https://developer.twitter.com/en/
docs.html Accessed: 2022-01-12.
[52] Cornell University. 2022. arXiv Dataset.
https://www.kaggle.com/Cornell-
University/arxiv Accessed: 2022-01-12.
[53] Stanford University. 2019. Stanford QA Dataset.
https://www.kaggle.com/
stanfordu/stanford-question-answering-dataset Accessed: 2022-01-12.
[54] US. 2021. Open Data US. https://www.data.gov. Accessed: 2022-01-12.
[55] Lusheng Wang and Kaizhong Zhang. 2008. Space efficient algorithms for ordered
tree comparison. Algorithmica 51, 3 (2008), 283–297.
[56] Elyas Ben Hadj Yahia, Jean-Rémy Falleri, and Laurent Réveillère. 2017. Polly: A
Language-Based Approach for Custom Change Detection of Web Service Data.
In International Conference on Service-Oriented Computing. Springer, 430–444.
[57] Rui Yang, Panos Kalnis, and Anthony KH Tung. 2005. Similarity evaluation
on tree-structured data. In Proceedings of the 2005 International Conference on
Management of Data. ACM, 754–765.
[58] Minghe Yu, Jin Wang, Guoliang Li, Yong Zhang, Dong Deng, and Jianhua Feng.
2017. A unified framework for string similarity search with edit-distance con-
straint. The VLDB Journal 26, 2 (2017), 249–274.
[59] Kaizhong Zhang. 1989. The editing distance between trees: algorithms and applica-
tions. Ph.D. Dissertation. Dept. of Computer Science, Courant Institute.
[60] Kaizhong Zhang. 1995. Algorithms for the constrained editing distance between
ordered labeled trees and related problems. Pattern recognition 28, 3 (1995),
463–474.
[61] Kaizhong Zhang. 1996. A constrained edit distance between unordered labeled
trees. Algorithmica 15, 3 (1996), 205–222.
[62] Kaizhong Zhang, Rick Statman, and Dennis Shasha. 1992. On the editing distance
between unordered labeled trees. Information processing letters 42, 3 (1992),
133–139.
A
PROOFS
A.1
NP-completeness of DNJEDI
Removing the document-preserving constraint from Definition 1
results in the document-neglecting JSON edit distance (DNJEDI).
To show the computational complexity of DNJEDI, we consider the
following decision problem:
Definition 5. DNJEDIx.
Instance: Two JSON trees 𝑇𝑆and 𝑇𝐶and a positive integer 𝑥.
Question: Is the JSON edit distance 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≤𝑥?
Similar to the unordered tree edit distance [59], the proof is by
reducing the exact cover by 3-sets (X3C) problem, c.f. Definition 6
to the DNJEDIx problem. The main differences compared to the
unordered tree edit distance are the two additional JSON edit map-
ping constraints (cf. Definition 1). Further, the tree transformation
used by Zhang would produce invalid JSON trees and therefore
needs to be changed.
Definition 6. Exact cover by 3-sets (X3C).
Instance: A finite set 𝑆= {𝑠1,𝑠2, . . . ,𝑠𝑚}, where 𝑚= 3𝑘, and a col-
lection 𝐶= {𝐶1,𝐶2, . . . ,𝐶𝑛}, where 𝐶𝑖= {𝑐𝑖1,𝑐𝑖2,𝑐𝑖3} and 𝑐𝑖𝑗∈𝑆.
Question: Is there a subcollection 𝐶′ ⊆𝐶such that every element of
𝑆occurs in exactly one member of 𝐶′?
Given an instance of X3C, let 𝑙1, . . . ,𝑙2𝑛−𝑘,𝑙𝑥,𝑙𝑦,𝑙𝑧, 𝐿∉𝑆be
strings that are not elements of set 𝑆and, w.l.o.g., each element
𝑠𝑖∈𝑆occurs only once in 𝑆. The polynomial time transformation
of an X3C instance into a DNJEDIx instance (i.e., JSON trees 𝑇𝑆, 𝑇𝐶,
and integer 𝑖) is shown in Figure 13. Tree 𝑇𝑆is built based on set 𝑆;
for each element 𝑠𝑖∈𝑆a 𝜆-subtree is inserted (3𝑘many in total),
and additionally 𝑛−𝑘𝜇-subtrees are inserted. Tree𝑇𝐶is built based
on collection 𝐶; for each element 𝐶𝑖∈𝐶, a 𝜅-subtree is inserted (𝑛
many in total). Further, let 𝑖= 4𝑛−2𝑘.

---

Hütter, et al.
{ }
"𝑙1"
{ }
"𝑐11"
"L"
"𝑐12"
"L"
"𝑐13"
"L"
. . .
"𝑙𝑛"
{ }
"𝑐𝑛1"
"L"
"𝑐𝑛2"
"L"
"𝑐𝑛3"
"L"
𝑇𝐶
𝜅-subtrees (𝑛many)
𝑇𝑆
𝜆-subtrees (𝑚= 3𝑘many)
𝜇-subtrees (𝑛−𝑘many)
{ }
"𝑠1"
"L"
"𝑠2"
"L"
. . .
"𝑠𝑚"
"L"
"𝑙𝑛+1"
{ }
"𝑙𝑥"
"L"
"𝑙𝑦"
"L"
"𝑙𝑧"
"L"
. . .
. . .
"𝑙2𝑛−𝑘"
{ }
"𝑙𝑥"
"L"
"𝑙𝑦"
"L"
"𝑙𝑧"
"L"
Figure 13: Polynomial time transformation of an exact cover by 3-sets (X3C) instance into JSON trees 𝑇𝑆and 𝑇𝐶.
Given an instance of X3C with JSON tree transformations𝑇𝐶and
𝑇𝑆, we show that the following holds: 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≤4𝑛−2𝑘
(i.e., DNJEDIx with 𝑖= 4𝑛−2𝑘) iff there is an exact cover by 3-sets.
Lemma 5. Given an instance of X3C with JSON tree transforma-
tions𝑇𝑆and𝑇𝐶, let 𝑀𝐷𝑁𝐽be the minimal document-neglecting JSON
edit mapping between JSON trees𝑇𝑆and𝑇𝐶, then 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≥
4𝑛−2𝑘.
Proof. As a result of the described transformation process, the
sizes of the trees |𝑇𝐶|, |𝑇𝑆| and the mapping size |𝑀𝐷𝑁𝐽| are as
follows:
• |𝑇𝑆| = 8(𝑛−𝑘) + 2(3𝑘) + 1: 𝑛−𝑘𝜇-subtrees of size 8 are
inserted, a 𝜆-subtree with 2 nodes is inserted (key and literal)
for each 𝑠𝑖∈𝑆with |𝑆| = 3𝑘, and one node for the root.
• |𝑇𝐶| = 8𝑛+ 1: for each 𝐶𝑖∈𝐶with |𝐶| = 𝑛, a 𝜅-subtree with
8 nodes is inserted, and one node for the root.
• |𝑀𝐷𝑁𝐽| = |𝑇𝑆|−𝑑= 8𝑛−2𝑘+1−𝑑, where 𝑑is the number of
unmapped nodes in 𝑇𝑆. From the JSON tree transformation,
we know that |𝑇𝐶| ≥|𝑇𝑆|. Then, the mapping size is the
size of the smaller tree |𝑇𝑆| subtracted by the number of
unmapped nodes in 𝑇𝑆.
Further, there are at most 4(𝑛−𝑘)+2(3𝑘)+1 nodes with identical
labels. 1 results from the identical object in the root nodes,𝑠1, . . . ,𝑠𝑚
and their child literals 𝐿may be identical to 𝑐𝑖𝑗and their child
literals, and all other subtrees (𝑛−𝑘many) share one object node
and three literals 𝐿.
The cost of the minimal JSON edit mapping 𝛾(𝑀𝐷𝑁𝐽) between
𝑇𝑆and 𝑇𝐶is bounded as follows:
𝛾(𝑀𝐷𝑁𝐽) ≥(|𝑀𝐷𝑁𝐽| −(4(𝑛−𝑘) + 2(3𝑘) + 1))
+ (|𝑇𝐶| −|𝑀𝐷𝑁𝐽|) + (|𝑇𝑆| −|𝑀𝐷𝑁𝐽|)
𝛾(𝑀𝐷𝑁𝐽) ≥4𝑛−4𝑘−𝑑+ (|𝑇𝐶| −|𝑀𝐷𝑁𝐽|) + (|𝑇𝑆| −|𝑀𝐷𝑁𝐽|)
𝛾(𝑀𝐷𝑁𝐽) ≥4𝑛−2𝑘+ (|𝑇𝑆| −|𝑀𝐷𝑁𝐽|)
𝛾(𝑀𝐷𝑁𝐽) ≥4𝑛−2𝑘+ 𝑑
𝛾(𝑀𝐷𝑁𝐽) ≥4𝑛−2𝑘
Note that the first term is an upper bound on the number of
rename operations, the second term is the number of deletions, and
the third term is the number of insertions.
Since the minimal JSON edit mapping is a visual representation of
the node edit operations, we know that𝛾(𝑀𝐷𝑁𝐽) = 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶).
Hence, 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≥4𝑛−2𝑘.
□
Lemma 6. Given an instance of X3C with JSON tree transforma-
tions𝑇𝑆and𝑇𝐶, the following holds: if there is an exact cover by 3-sets,
then 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≤4𝑛−2𝑘.
Proof. Create a JSON edit mapping 𝑀∗
𝐷𝑁𝐽as follows:
• Map nodes 𝑠1,𝑠2, . . . ,𝑠𝑚in 𝑇𝑆to a 𝑐𝑖𝑗in 𝑇𝐶with the same
label. There must be zero-cost mappings for all 𝑠𝑖∈𝑆as well
as their literal children 𝐿, since there exists an exact cover by
3-sets. Hence, for each triplet of 𝜆-subtrees (𝑘many), 2 nodes
have to be inserted (𝑙𝑗and an object node). The resulting
costs are 2𝑘.
• Map the remaining 𝜇-subtrees (𝑛−𝑘many) in 𝑇𝑆to the
remaining 𝜅-subtrees in 𝑇𝐶with cost 4.
The cost of the resulting mapping is 𝛾(𝑀∗
𝐷𝑁𝐽) = 2𝑘+ 4(𝑛−𝑘) =
4𝑛−2𝑘. Since 𝑀∗
𝐷𝑁𝐽is a valid but not necessarily minimal JSON
edit mapping, 𝛾(𝑀∗
𝐷𝑁𝐽) ≥𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶).
□
Lemma 7. Given an instance of X3C with JSON tree transforma-
tions 𝑇𝑆and 𝑇𝐶, the following holds: if 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≤4𝑛−2𝑘,
then there is an exact cover by 3-sets.
Proof. From 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≤4𝑛−2𝑘and Lemma 5, we
know that 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) = 4𝑛−2𝑘. Further, from Lemma 5, we
know that 𝑑= 0, hence all nodes in 𝑇𝑆are in the minimal JSON
edit mapping 𝑀𝐷𝑁𝐽. We continue by analyzing which nodes pairs
of 𝑇𝑆and 𝑇𝐶are in 𝑀𝐷𝑁𝐽.
First, the root of𝑇𝑆has to be mapped to the root of𝑇𝐶. Otherwise,
the root can only be mapped to an object in a 𝜅-subtree. Due to
the ancestor condition, all nodes in 𝑇𝑆have to be mapped to the
subtree of the according object node in 𝑇𝐶. Since there are more
nodes in 𝑇𝑆than in such a subtree, this contradicts the fact that all
nodes in 𝑇𝑆are mapped.
Next, consider the root node of any 𝜇-subtree. Due to the type
constraint of the JSON edit mapping, it can only be mapped to the
root of a 𝜅-subtree or to a 𝑐𝑖𝑗. Mapping it to the root implies a
minimal cost of 4 rename operations compared to at least 6 deletion
operators otherwise. Therefore, in a minimal mapping, each 𝜇-
subtree is mapped to a 𝜅-subtree with cost 4, which results in an
overall cost of 4(𝑛−𝑘).
Hence, only 2𝑘edit operations remain to map 3𝑘𝜆-subtrees to 𝑘
𝜅-subtrees. The size difference between these remaining subtrees in
𝑇𝐶and 𝑇𝑆is 8𝑘−6𝑘= 2𝑘. Hence, all nodes in 𝑇𝑆must be mapped
with cost 0, i.e., all 𝑠𝑖∈𝑆must match exactly one 𝑐𝑖𝑗in 𝑘𝜅-subtrees

---

JEDI: These aren't the JSON documents you're looking for... (Extended Version*)
in 𝑇𝐶, which is equivalent to 𝐶′ and , therefore, there is exists an
exact cover by 3-sets.
□
Theorem 5. Computing the JSON edit distance between two JSON
trees is NP-complete.
Proof. We need to show the following two steps:
• 𝐷𝑁𝐽𝐸𝐷𝐼𝑥∈𝑁𝑃: A non-deterministic algorithm can guess
a JSON edit mapping 𝑀∗
𝐷𝑁𝐽⊆𝑁(𝑇𝑆) × 𝑁(𝑇𝐶) between two
JSON trees𝑇𝑆and𝑇𝐶and verify in polynomial time whether
the mapping costs are at most 𝑖.
• X3C can be reduced to DNJEDIx: From Lemma 6 and Lemma 7,
it immediately follows that there is an exact cover by 3-sets
iff 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝐶,𝑇𝑆) ≤4𝑛−2𝑘.
Hence, the computation of the JSON edit distance is NP-complete.
□
While the above proof only holds for JSON trees with degree
3, the proof for trees with degree 𝑑𝑒𝑔= 𝑞> 3 results from an
according reduction of exact cover by 𝑞-sets. In this general case,
the claim is as follows: there exists an exact cover by 𝑞-sets iff
𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝑆,𝑇𝐶) ≤(𝑞+ 1)𝑛+ (𝑞−5)𝑘.
"𝑙1"
{ }
"𝑐11"
"L"
"𝑐12"
"L"
"𝑐13"
"L"
"𝑙1"
{ }
"𝑐11"
"L"
"𝑙𝑤"
{ }
"𝑐12"
"L"
"𝑐13"
"L"
Figure 14: Transformation of 𝜅- and 𝜇-subtrees into a JSON
tree with degree 2, 𝑙𝑤∉𝑆.
Since exact cover by 2-sets is solvable in polynomial time, we
reduce exact cover by 3-sets to show the NP-completeness of trees
with degree two. The following two modifications are needed: (1)
compared to Figure 13, adjust the structures of 𝜅- and 𝜇-subtrees as
shown in Figure 14, (2) the sizes change as follows |𝑇𝐶| = 10𝑛+ 1,
|𝑇𝑆| = 10(𝑛−𝑘) + 2(3𝑘) + 1, |𝑀| = 10𝑛−4𝑘+ 1 −𝑑, and there are
at most 5(𝑛−𝑘) + 2(3𝑘) + 1 nodes with identical labels. Then it
holds that 𝐷𝑁𝐽𝐸𝐷𝐼(𝑇𝐶,𝑇𝑆) ≤5𝑛−3𝑘iff there is an exact 3-cover.
Hence, the JSON edit distance is NP-complete for JSON trees with
degree 2 or higher. Note that DNJEDI for trees with degree 1 can be
computed using the edit distance. This observations follows from
the ancestor condition of DNJEDI.
Summarizing, the high computational complexity of DNJEDI
disqualifies its application in real-world scenarios where JSON
trees with thousands of nodes need to be compared.
B
REAL-WORLD JSON DATASET ANALYSIS
In Table 3, we give a summary of the characteristics of the datasets
used in Section 6.
5https://www.kaggle.com/Cornell-University/arxiv
6https://mtgjson.com/api/v5/AtomicCards.json
7https://www.kaggle.com/dataturks/clothing-item-detection-for-ecommerce
8https://www.kaggle.com/fda/fda-enforcement-actions?select=food-enforcement-
0001-of-0001.json
9https://www.kaggle.com/dataturks/face-detection-in-images
10https://data.nasa.gov/resource/y77d-th95.json
11https://www.kaggle.com/gjbroughton/christmas-recipes
12https://www.reddit.com/r/science.json
13https://www.kaggle.com/rtatman/the-national-university-of-singapore-sms-
corpus
14https://social-dynamics.net/pepmusic/musicdata.zip
15https://www.kaggle.com/stanfordu/stanford-question-answering-dataset
16https://developer.twitter.com/en/docs.html

---

Hütter, et al.
Arxiv5
Cards6
Clothing7
DBLP [15]
DENF8
Device8
#records
1,865,501
20,746
504
1,984,049
7,497
147,899
#nodes/rec
38
53
11367
37
132
298
29
29
51
14
26
651
47
59
283
49
323
3264
#objects
2
2.6
188
3
12
39
4
4
7
2
2
2
2
2
2
2
2
2
#arrays
3
6.2
2834
8
8
11
3
3
5
0
1.5
5
0
2.7
20
0
1.9
2
#keys
16
17.1
388
17
59
127
12
12
21
6
11
17
23
27
45
24
29.9
39
#literals
17
28
8512
9
54
192
10
10
18
5
11.5
634
22
28
221
23
289
3230
object
degree
min
2
2
2
0
0.9
1
2
2
2
1
1
1
0
2.7
20
0
5.9
6
avg
2
7.1
8
3
5.2
12
3
3
3
3
5.6
8.5
12
13.4
23
12
14.9
15
max
14
14
14
16
21.5
28
5
5
5
5
10
16
23
24
25
24
24
24
array
degree
min
1
1.4
4
0
0.03
1
1
1
1
0
1.5
263
0
0.2
1
0
131
1600
avg
1.7
2.6
63.7
0.3
1.7
21
1.3
1.3
1.6
1
1.9
312
0
0.3
11
0
131
1602
max
3
5
2832
1
7
167
2
2
2
1
2.3
621
0
1.3
95
0
131
1603
max. depth
5
5
5
5
6.9
7
8
8
8
4
4
4
3
3.3
5
3
5
5
Face9
FENF8
Movie[40]
NASA10
NBA [15]
Reads[10]
#records
409
13,991
8,765,568
1,000
31,686
30,000
#nodes/rec
29
68
359
47
49
51
15
23
729
15
27
31
659
977
1269
11
11
11
#objects
4
9.3
49
2
2
2
1
1.9
2
1
2
2
21
27
35
1
1
1
#arrays
3
6.5
33
0
0
0
0
0
1
0
1
1
3
3
3
0
0
0
#keys
12
28
147
23
24
25
7
11
13
7
12
14
339
477
619
5
5
5
#literals
10
24
130
22
23
24
7
10
714
7
12
14
332
470
612
5
5
5
object
degree
min
2
2
2
0
0
0
1
1.4
11
2
2.1
7
1
1
1
5
5
5
avg
3
3
3
11.5
12
12.5
4.5
5.8
11
5.5
6.1
7
16
17.4
18.4
5
5
5
max
5
5
5
23
24
25
7
10
12
7
10.2
12
20
20.5
21
5
5
5
array
degree
min
1
1
1
0
0
0
0
0
704
0
1.9
2
2
2
2
0
0
0
avg
1.3
1.6
1.9
0
0
0
0
0
704
0
1.9
2
5.3
7.5
10
0
0
0
max
2
3.1
16
0
0
0
0
0
704
0
1.9
2
7
10.7
14
0
0
0
max. depth
8
8
8
3
3
3
2
3.9
4
2
5
5
8
8
8
2
2
2
Recipes11
Reddit12
Schema[5]
SMSen13
SMSzh13
Spotify14
#records
1,617
25
81,518
55,835
31,465
1,107
#nodes/rec
13
26.1
64
209
265
432
3
270.5
48,128
81
81
81
79
80.9
81
5,141
5,141
5,146
#objects
1
1
1
5
13
27
1
51.7
7,680
19
19
19
19
19
19
2
2
2
#arrays
2
2
2
6
7.8
10
0
11.4
1,454
0
0
0
0
0
0
5
5
5
#keys
6
6
6
104
130
206
1
122
23,768
40
40
40
39
39.9
4,006
19
19
19
#literals
7
17.1
55
94
115
189
1
85.4
16,307
22
22
22
21
21.9
22
5,115
5,115
5,120
object
degree
min
6
6
6
0
0
0
0
1.2
10
1
1
1
1
1.4
11
9
9
9
avg
6
6
6
7.6
11.3
20.8
1
2.7
10
2.1
2.1
2.1
4.5
5.8
11
9.5
9.5
9.5
max
6
6
6
102
103
104
1
13.2
531
9
9
9
7
10
12
10
10
10
array
degree
min
0
3.5
19
0
0
0
0
1.4
463
0
0
0
0
0
0
1
1
avg
1.5
6.5
25.5
0
0.7
1.9
0
2.2
745.5
0
0
0
0
0
0
1,020
1,020
1,021
max
2
9.6
41
0
3.9
6
0
4.7
2,810
0
0
0
0
0
0
3,600
3,600
3,600
max. depth
3
3
3
5
10.9
11
2
11.6
50
8
8
8
8
8
8
6
6
6
StanDev15
StanTrain15
Twitter 216
Virus[10]
#records
48
442
19,316
500
#nodes/rec
2212
5379
18,135
294
2597
10,549
115
195
489
19
19
19
#objects
404
988
3303
50
440
1783
5
11.4
42
1
1
1
#arrays
118
264
864
28
242
966
2
13.2
27
0
0
0
#keys
904
2196
7416
122
1078
4383
55
83
222
9
9
9
#literals
786
1931
6551
94
837
3417
53
87
208
9
9
9
object
degree
min
2
2
2
2
2
2
0
1.5
2
9
9
9
avg
2.1
2.2
2.3
2.4
2.45
2.5
4.4
7.75
11.9
9
9
9
max
3
3
3
3
3
3
29
34
35
9
9
9
array
degree
min
1
2.2
4
1
1
1
1
1
2
0
0
0
avg
3.1
3.7
5.3
1.7
1.8
.9
1.7
2
2.5
0
0
0
max
21
43
98
5
43
149
2
4.4
16
0
0
0
max. depth
11
11
11
11
11
11
5
9.2
14
3
3
3
Table 3: Analysis of the collected JSON datasets.

---

