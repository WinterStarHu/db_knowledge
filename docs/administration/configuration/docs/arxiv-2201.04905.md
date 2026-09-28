# A Formal Category Theoretical Framework for Multi-model Data Transformations

> 来源: https://arxiv.org/pdf/2201.04905

A Formal Category Theoretical Framework for
Multi-Model Data Transformations
Valter Uotila and Jiaheng Lu
Unified Database Management Systems, University of Helsinki, Helsinki, Finland
{valter.uotila,jiaheng.lu}@helsinki.fi
Abstract. Data integration and migration processes in polystores and
multi-model database management systems highly benefit from data and
schema transformations. Rigorous modeling of transformations is a com-
plex problem. The data and schema transformation field is scattered
with multiple different transformation frameworks, tools, and mappings.
These are usually domain-specific and lack solid theoretical foundations.
Our first goal is to define category theoretical foundations for relational,
graph, and hierarchical data models and instances. Each data instance is
represented as a category theoretical mapping called a functor. We for-
malize data and schema transformations as Kan lifts utilizing the functo-
rial representation for the instances. A Kan lift is a category theoretical
construction consisting of two mappings satisfying the certain universal
property. In this work, the two mappings correspond to schema trans-
formation and data transformation.
Keywords: Polystores · Multi-model databases · Data and schema trans-
formations · Database theory · Category theory.
1
Introduction
The biggest success stories in database theory are the relational model and
relational algebra. Codd’s theory [3] on relational databases has had an incom-
prehensible huge impact on database theory and applications. More formal and
theoretical treatment of polystores and multi-model databases would make it
possible us to repeat this success story in polystores and multi-model databases.
A solid mathematical foundation would highly benefit their research and in-
dustry. Besides, to standardize the existing techniques and systems, a rigorous
formulation is crucial.
Polystores and multi-model databases are a solution to the problem of han-
dling a variety of data [12,14,20]. Native graph, document, key-value, and column
databases have reached the point where they are competitive alternatives for re-
lational databases especially in the cases when we perform a lot of read- and
write-operations and heavy data analysis tasks. Since ML and AI are relying on
massive amounts of data, NoSQL databases have gained attention.
Undoubtedly, polystores and multi-model databases are more complicated
systems than ordinary relational databases since they subsume relational databases.
arXiv:2201.04905v1  [cs.DB]  13 Jan 2022

---

2
Valter Uotila and Jiaheng Lu
The theory and language describing the systems have to evolve along with the
systems which are gradually becoming more complex. But this should not mean
that the theory and languages become more complex for end-users or even for
database administrators and architects. Different databases have their own the-
oretical foundations and query languages that are not automatically compatible
at a practical or theoretical level. This creates a huge challenge that we are
tackling from the theoretical perspective.
Data and schema transformations form a significant part of the data inte-
gration and migration problems [10]. For example, the transformations might
be needed at any point during the development of ML and AI solutions where
databases are a part of the process. Initially, importing data requires transforma-
tions. Data integration between the databases can require multiple transformation-
based views between the participating databases. Sometimes the most efficient
solution is to materialize the transformed data. When the amount of data grows,
the transformation systems need to be able to adapt for the growth. Thus mono-
tonicity and temporality aspects of transformations are important to take into
account. Eventually, the data require transformations before it can fit ML and
AI models. For example, ML and AI models can use a knowledge graph ap-
proach but the data is stored in a relational database. The same transformation
problems are also apparent for polystores and multi-model databases.
Often these transformations lack formal treatment. Daimler et al. [7] argue
that informal data transformations are harmful. This is one of the challenges we
are addressing in this work. The language, which is proved to be capable of cap-
turing highly complex structures with a compact notation, is category theory.
Liu et al. [19] visioned that the foundations of multi-model databases could be
built on category theory because relational algebra’s expressiveness is not pow-
erful enough. We argue that the same applies to polystores. Our contributions
include
– continuing previous research connecting category theory and database the-
ory,
– formalizing graph and hierarchical models and instances in terms of category
theory, and
– formalizing data transformations in polystores and multi-model databases
as a solution to a category theoretical lifting problem.
Informally category can be thought of as a graph or a network with a cer-
tain additional structure. The additional structure is usually easy to find from
computer science and database applications. If our goal is to express database
theory precisely, it does not make sense to use only graphs because we can do
modeling much better with categories.
In this work, we are often mentioning ”schema”. By schema, we do not only
mean the conventional relational schema but a larger piece of information that
contains any constraint related to a model. Also, the information about the
model is part of the schema. Although modern NoSQL data is often referred
to as schemaless, the data always have some constraints which we include in a
schema in this context.

---

A Category Theoretical Framework for Multi-Model Data Transformations
3
1.1
Related work
There are influential transformation frameworks but only a few of them are de-
veloped formally. SQLGraph [27] is a system, which translates graph databases
to relational databases. It utilizes hashing and the fact that the modern rela-
tional databases natively support JSON. A framework of converting relational
databases to graph databases by Virgilio et al. [9] utilizes schema paths. Das et
al. [8] have developed a framework that creates RDF-view for property graph
data in Oracle databases. All of these transformations are considered from a
domain-specific and practical perspective although we identify that they have
characteristical features which could be theoretically modeled and unified.
Jananthan et al. [15] propose associative algebra as a mathematical foun-
dation for polystores. Leclercq et al. [18] built foundations of polystores on the
tensor-based data model. Liu et al. [19] visioned that the foundations of multi-
model databases could be built on category theory and we continue this work
for polystores and multi-model databases.
There has been relatively much research on applying category theory to
database theory. Our approach is highly influenced by David Spivak [25,26].
As he points out in [25], the category theoretical database research can be di-
vided into two schools: category-based [24] and sketch-based [16]. A sketch [28]
is a category with certain limit objects. Our position is category-based.
Besides work on database theory, category theory has been applied widely in
computer science. Some of the most interesting and recent applications are pro-
gramming languages (foundations of many functional programming languages),
machine learning [6,11], automata learning [13], natural language processing
(DisCoCat [5]), and quantum computing and mechanics [1,4]. Applied category
theory has its annually organized conference called ACT (Applied Category The-
ory).
2
Prerequisites
2.1
Categories
Category theory is a relatively new field of mathematics. Saunders MacLane and
Samuel Eilenberg introduced categories, functors, and natural transformations
in the mid-1940s as a ”meta-mathematical” tool to study algebraic topology.
MacLane [17] is the standard introduction to the topic. Other good introduction
from mathematical perspective is [22] and from computer science perspective
[26,28].
Definition 1 (Category). A category C consists of a collection of objects de-
noted by Obj(C) and a collection of morphisms denoted by Hom(C). For each
morphism f ∈Hom(C) there exists an object A ∈Obj(C) that is a domain of f
and an object B ∈Obj(C) that is a target of f. In this case we denote f : A →B.
We require that all the defined compositions of morphisms are included in C: if
f : A →B ∈Hom(C) and g: B →C ∈Hom(C) are morphisms, then the com-
position g ◦f ∈Hom(C) is defined and g ◦f : A →C is a morphism. Also, we

---

4
Valter Uotila and Jiaheng Lu
assume that the composition operation is associative and that for every object
A ∈Obj(C) there exists an identity morphism idA : A →A so that f ◦idA = f
and idA ◦f = f whenever the composition is defined.
See Figure 1 as a simple example of a category. In this work sans serif font
always indicates a category. We follow the standard notation of category theory
literature that is used, for example, in [22]. One of the most important categories
h
object
1
g
h○g
object
4
object
2
f
g○f
object
3
id
id
id
id
h○g○f
Fig. 1. A simple four object category with three non-trivial morphisms f, g and h and
identities. In this case all the compositions of morphisms are drawn.
is the category Set whose objects are sets and morphisms are functions between
the sets. The composition operation of the morphisms is the composition of
functions.
2.2
Functors
In science and mathematics, we often have functions or mappings which respect
the underlying structures. Next, we define a structure-preserving mapping for
categories. The mapping is called a functor.
Definition 2 (Functor). Assume C, D are categories. A functor F : C →D is
defined so that
– for every object c in the category C, F(c) is an object in the category D and
– for every morphism f : c →d in C, it holds that F(f): F(c) →F(d) is a
morphism in D.
Besides, we assume that following axioms hold:
– For every object c ∈C it holds that F(idc) = idF (c) and
– if the composition f ◦g is defined, then F(f ◦g) = F(f) ◦F(g).
If every morphism in the category D has a preimage in the category C, we call
the functor F full.
See Figure 2 (a) as an example of functor between two simple categories. The fact
that a functor preserves the structure of a category is apparent in the example.
2.3
Natural transformations
The idea behind structure-preserving mappings is so fundamental that we can
study what it means to preserve a structure of structure-preserving mappings.

---

A Category Theoretical Framework for Multi-Model Data Transformations
5
The category theoretical notion for this is called a natural transformation. We
follow a convention from category theory and denote a natural transformation
by ”⇒”-arrow.
Definition 3 (Natural transformation). Assume F, G: C ⇒D are functors.
A natural transformation α: F ⇒G contains the following information: For
each c ∈C is associated a component of the natural transformation αc : F(c) →
G(c). This component is a morphism in D so that the following diagram com-
mutes for any morphism f : c →d in C
F(c)
F (f)
↓
αc
→G(c)
G(f)
↓
F(d)
αd →G(d)
In equational format commuting means that G(f) ◦αc = αd ◦F(f).
See Figure 2 (b) as an example of a natural transformation.
f
g○f
object
1
g
object
2
object
3
id
id
id
F(f)
object
F(1)
F(g)
object
F(2)
object
F(3)
F(id)
= id
F(id)
= id
F(id)
= id
Category C
Subcategory F(C) of
category D
Functor 
F : C → D
F(g)○F(f)=
F(g○f)
(a)
f
g○f
object
1
g
object
2
object
3
id
id
id
F(f)
object
F(1)
F(g)
object
F(2)
object
F(3)
F(id)
= id
F(id)
= id
F(id)
= id
Category C
Subcategory F(C)
in category D
Functor 
F : C → D
F(g)○F(f)=
F(g○f)
object
G(1) =
G(2) =
G(3)
f
g○f
object
1
g
object
2
object
3
id
id
id
Category C
Functor 
G : C → D
G(f) = G(g)
= G(id) = id
Natural transformation
α : F 
 G
Subcategory G(C) in
category D
(b)
Fig. 2. (a) An example of a simple functor (b) An example of a simple natural trans-
formation α: F ⇒G. The component morphisms αi : F(i) →G(i) are defined so that
they map everything to the single object in D.

---

6
Valter Uotila and Jiaheng Lu
2.4
Kan lifts
We discuss Kan lifts [21] shortly. Kan lift is a pair consisting of a functor and a
natural transformation. The problem can be expressed as a diagram
A
C
B
F
L
G
ε
where all the arrows represent functors and a natural transformation ε: G ◦
L ⇒F. The category theoretical problem is to find a suitable functor L: A →
B and a natural transformation ε: G ◦L ⇒F which make the construction
universal i.e. the natural transformation ε is universal among all the suitable
natural transformations which satisfy the diagram. The problem is called a lifting
problem.
Definition 4 (Kan lift). Let F : A →C and G: B →C be functors. A right
Kan lift of F through G consists of a functor RiftGF : A →B and a natural
transformation ε: G ◦RiftGF ⇒F so that they satisfy the following univer-
sal property: given any other pair of a functor and a natural transformation
(H : A →B, η: G ◦H ⇒F) then there exists a unique natural transformation
γ : H ⇒RiftGF so that η factors through ε i.e. η = ε◦(G◦γ). Diagrammatically
if
A
C
B
F
RiftGF
G
ε
and
A
C
B
F
H
G
η
then
A
C
B
F
H
RiftGF
γ
G
ε
The problem of finding the pair RiftGF : A →B and ε: G ◦RiftGF ⇒F is
called a lifting problem. The intuition behind Kan lifts is that we find a functor
RiftGF that is the best approximation which makes the triangle ”commute”.
The notion of Kan lift grabs a larger collection of data transformations since
we do not require that the triangle necessarily commutes in strict sense. Al-
though the definition is abstract, we believe that is suitably flexible to describe
transformations conceptually.
2.5
Graphs
Graphs have a three-folded role in this work. The first role of graphs is that every
category is naturally a graph where objects are the vertices and morphisms are
the edges. On the other hand, a graph is an abstract data model which we

---

A Category Theoretical Framework for Multi-Model Data Transformations
7
are formalizing in terms of category theory. Some concrete models following the
graph model are property graphs and RDF graphs. The third role of graphs is
that they serve as the most standard tool to model relationships in a database,
for example, ER diagrams and various relational schemas are graphs. We want
to emphasize that these graphs should not be confused.
Definition 5 (Graph). A graph G is a quad G = (V, E, src, tgt) where V is
a set of vertices, E is the set of edges, src: E →V is the source function and
tgt: E →V is the target function. If e ∈E is an edge then its source vertex is
src(e) = v and its target vertex is tgt(e) = w.
When we have graphs, it is natural to talk about paths. The following notation
for paths is used in [24].
Definition 6 (Path). Let G = (V, E, src, tgt) be a graph. A path p of length
n in the graph G is a sequence of connected edges in G. The set of all paths of
length n is denoted by Path(n)
G . The set of all path of G is PathG = ∪n∈NPath(n)
G .
3
Functorial instances and databases
3.1
Functorial representation of relational data
We can draw a correspondence that we use categories to encode database con-
straints and functors to create instances. Because database instances have to
follow the constraints, the structure-preserving (and thus constraint-preserving)
mapping, a functor, is a natural choice to model instances and transfer con-
straints to them.
David Spivak [24] represented a simple database definition language using
categories and functors. Now we shortly recall this construction. Following his
ideas, we extend relational construction to graph and hierarchical data models.
When data models have their functorial representations, we can define data
transformations as a solution to the lifting problem (Definition 4).
Definition 7 (Categorical path equivalence relation [24]). Let
G = (V, E, src, tgt) be a graph. A categorical path equivalence relation, denoted
by ∼=, is an equivalence relation on the set PathG of all the paths of G and it has
the properties listed in Definition 3.2.4 in [24].
We omit the full list of properties since the list is relatively long and for
this work, the most important is to know that the relation ∼= is an equivalence
relation on the set PathG.
Definition 8 (Categorical schema). A categorical schema is C = (G, ∼=)
where G is a graph and ∼= is a categorical path equivalence relation on PathG.
Definition 9 (Schema category). Let C = (G, ∼=) be a categorical schema.
The schema category C is the category whose objects are the vertices of the graph
G and the morphisms are the equivalence classes of the paths of G defined by ∼=.
The composition is defined as path composition with respect to the equivalence
relation.

---

8
Valter Uotila and Jiaheng Lu
The schema category consists of objects which are table descriptions, for
example, similar to that we have in the ER diagram. The morphisms are induced
by the foreign key constraints between the tables. Intuitively, a schema category
is the category induced by the corresponding ER diagram.
Definition 10 (Instance functor). Let C = (G, ∼=) be a schema category. An
instance functor I : C →Set maps the schema category to the category of sets
and it satisfies the property that if p ∼= q, then I(p) = I(q).
See Figure 3 (a) as an example of a relational instance functor. In Figure 3
(a) arrows are based on the constraints between the attributes. Since functional
dependencies can be composed, the compositions of the dependencies are defined.
A set of attributes trivially depends on itself which creates identity arrows.
For instance, we can ask a question related to Figure 3 (a): What is the
channel that the moderator with ModName alicee owns? The answer can be
found when we compose the arrow Moderator.FollowerID →Follower.ID with
the arrow Follower.OwnChannel →Channel.ID. This gives us an arrow Moder-
ator.FollowerID →Channel.ID. The answer is the channel with id C4 which can
be read in Figure 3 (a).
The intuition behind a relational instance functor is that it sends each object
c ∈C (corresponding table description or a column in the schema) to a set I(c) ∈
Set. The set I(c) is the concrete instance of a table or a column. For example
in Figure 3 (a), I(ChannelMods) = {(C1, M1), (C2, M2), (C3, M1), (C3, M2)}. If
a morphism f : c →d ∈C corresponds a foreign key dependency between the
table descriptions c and d in the schema, then I(f): I(c) →I(d) ∈Set is the set
valued function that sends the tuples of the table I(c) to the tuples of the table
I(d) along the functional dependency defined by the foreign key constraint.
3.2
Functorial representation of the graph and hierarchical data
Bumby et al. [2] gives a category theoretical formulation for graphs. Recall that
we previously defined a graph G to be a quad (V, E, src, tgt). Property graphs
have been studied from an algebraic and category theoretical perspective already
in [23].
Definition 11 (Graph as functor). Let G be the two element category which
consists of the identity morphisms and two non-trivial morphisms as the diagram
0
s
→
t
→1
describes. Now a graph G is a functor G: G →Set where G(0) = E is the set of
edges, G(1) = V is the set of vertices, G(s): G(0) →G(1) = src: E →V is the
source function and G(t): G(0) →G(1) = tgt: E →V is the target function.
Besides, G maps identity morphisms of G to identity functions in Set.

---

A Category Theoretical Framework for Multi-Model Data Transformations
9
We do not assume that the graph would have a schema. In this sense, the
construction differs from the one that we gave to the relational data. In practice,
we might have a graph schema available, for example, in the cases when we are
transforming relational data into graph data.
When a graph schema is available, we can encode it in the category theoretical
definition. If we have a strict schema for the graph, we can generalize Spivak’s
approach for the relational data and assign the schema information to the objects
0 and 1 in Definition 11.
The classical graph example is a social network. Let us take a property graph
-oriented approach and set that the object 1 is associated with a graph schema
(person : {key, name, age}). The label person is the label of the node and key,
name and age are keys for the properties stored in nodes. For edges we can define
similar structure by setting 0 = [knows : {key, since}]. See Figure 3 (b) for the
full construction.
Follower
ID
Name
Age
OwnChannel
U1
Alice
25
C4
U2
Bob
22
C1
U3
Julia
45
C3
Follower
+ ID
+Name
+Age
+OwnChannel
Moderator
ID
ModName
FollowerID
M1
alicee
U1
M2
bobby
U2
Moderator
+ID
+Name
+FollowerID
Channel
ID
ChannelName
Followers
C1
musichannel
504
C2
movie_stream
1057
C3
chat_with_us
2 475 398
C4
learn_dancing
74
ChannelMods
ChannelID
ModID
C1
M1
C2
M2
C3
M1
C3
M2
ChannelMods
+ChannelID
+ModID
Channel
+ID
+ChannelName
+Followers
Relational schema category
Image of instance functor in the category Set
Relational instance functor
ChannelMods.ModID
= Moderator.ID
Moderator.FollowerID = Follower.ID
Follower.OwnChannel = 
Channel.ID
ChannelMods.ChannelID = Channel.ID
(a)
person:
{ key, name,
age }
knows: {
key, since }
s = source
t = target
0
1
Categorical representation for graph schema
knows: { key: e2,
since: 2018-11-12 }
Vertex set in category Set
person: 
{ key: p1,
name: "Alice",
age: 25}
person: 
{ key: p2,
name: "Bob",
age: 22}
person: 
{ key: p3,
name: "Julia",
age: 45}
Graph instance in category Set
Graph notation
person: 
{ key: p1,
name: "Alice",
age: 25 }
person: 
{ key: p2,
name: "Bob",
age: 22}
person: 
{ key: p3,
name: "Julia",
age: 45}
knows: { key: e1,
since: 2019-05-22 }
knows: { key: e2,
since: 2018-11-12 }
Set notation
e1
e2
e1
e2
p1
p1
p3
p2
Source function
Target function
Graph instance functor
Edge set in 
category Set
knows: { key: e1,
since: 2019-05-22 }
(b)
Fig. 3. (a) An example of a relational instance functor (b) The graph instance functor
consists of the functor from the category that is a categorical representation for the
graph schema to the category set. The graph is represented using the set notation and
the conventional property graph notation.
As far as we know, hierarchical data, such as XML and JSON, do not have a
category theoretical description that would have been studied previously. We use
terms hierarchical data and tree data interchangeable. For any tree, we identify

---

10
Valter Uotila and Jiaheng Lu
the characteristical feature that each node in the tree has exactly one parent
node except the root. We can conceptually expand the tree construction so that
the root is the unique node that has itself as a parent.
Definition 12 (Tree as functor). Let T be the one element category whose
object is 0 and the only non-trivial morphism is p: 0 →0. Diagrammatically the
category is simply
0
p
↙
Now a tree is a functor T : T →Set which sends the single element 0 to the set
of nodes of the tree. The single non-trivial morphism p: 0 →0 is sent to the
function that gives the parent node for each node in T(0). If the node is the root
r, then we define T(p)(r) = r.
4
Data transformations between functorial instances
4.1
Intuition behind transformations represented in terms of
category theory
Before formally discussing the transformations, we show a motivating example
of how the theory in the previous sections manages to unify a big part of the
transformation theory.
This example is continuation to Figure 3 (b) where we had the classical social
network data stored in a relational database. In our opinion, the most obvious
way to store a social network is to use simple vertex- and edge-tables. The rela-
tionships are defined by foreign key constraints. The knows table, which serves
as the edge-table, has at least two foreign keys, k.personID1 and k.personID2.
These are connected to the person-table’s primary key p.personID. Diagrammat-
ically this can be expressed as
knows-table k
k.personID2 = p.personID
→
k.personID1 = p.personID
→person-table p
We note that this schema already defines a schema category (Definition 9).
Recall the category theoretical representation for the graph in Definition 11.
We can transform the relational instance into a graph in multiple ways. The first
way to map the relational schema category to the graph schema category is
on objects
{︄
p ↦→1
k ↦→0
and on morphisms
{︄
(p.personID = k.personID1) ↦→s
(p.personID = k.personID2) ↦→t.
The objects 0 and 1 and morphisms s and t refer to the same objects and
morphisms as in Definition 11. The second transformation is that we swap how

---

A Category Theoretical Framework for Multi-Model Data Transformations
11
the morphisms are mapped i.e. swap the roles of s and t. Compared to the first
transformation this inverses the direction of the edges in the resulting graph.
Besides these two mappings, we can find two more. The third possible functor
collapses the relational schema i.e. it maps everything to the object 0 and its
identity morphism:
on objects
{︄
p ↦→0
k ↦→0
and on morphisms
{︄
(p.personID = k.personID1) ↦→id0
(p.personID = k.personID2) ↦→id0.
The fourth possible functor is similar to the previous functor but maps every-
thing to the object 1. The benefit of the category theoretical formulation for
transformations is that we can mathematically characterize, that the transfor-
mation which sends the knows-table to vertices and person-table to edges, is not
valid because such transformation is not a functor.
The transformations 3. and 4. have problems although they are well-defined
functors. Thus functoriality is not a sufficient condition to characterize mean-
ingful transformations. It does not make sense to map everything to edges (the
result of the transformation 3.) because a valid edge needs to have a source and a
target vertex. Also, a graph that contains only vertices without edges (the result
of the transformation 4.) is not meaningful because edges are necessary for the
most important graph operations. Thus we require that the functor should be
full (Definition 2) to be relevant in practice. As we see, the transformations 3.
and 4. as functors are not full but transformations 1. and 2. are.
4.2
Data transformation as lifting problem
Data and schema transformations are usually modeled as mappings from a source
database to a target database. We base our data and schema transformation on
Kan lifts [21]. Lifting problems have been considered in database theory also
previously in [25]. As Definition 4 shows, the lift consists of two components: a
functor and a natural transformation. Informally, the functor part is a schema
mapping which describes a set of rules which define how the data items are
mapped at a schema level. The functor is required to be full (Definition 2) be-
cause functors which are not full are not practically meaningful as the discussion
in the previous section shows. Along the functor, we have a natural transfor-
mation which is data mapping. The pair satisfies the universal property which
creates certain classification for transformations. The nature of this classification
is still an open question.
The category theoretical approach to data and schema transformations re-
veals a crucial problem in transformation research. The problem is the sepa-
ration of data and schema. In a world where relational databases are still the
dominant databases, the division of data and schema is obvious. But the prob-
lem is apparent with the schemaless or schema-free models such as graphs and
documents. If graph and document data transformations are approached from
the relational perspective, we are likely to face problems. With category theory,
we can model as much structure as the data has. Modeling transformations as

---

12
Valter Uotila and Jiaheng Lu
pairs of mappings describes transformations more rigorously than a single total
function between data sets.
Let I1 : C1 →Set and I2 : C2 →Set be two data instances as functors where
the functors can represent either relational, graph or hierarchical instance func-
tors as described in Definitions 10, 11, and 12. The question is how do we gen-
erally find a transformation between the data instances I1 and I2. The problem
can be expressed as a diagram
C1
Set
C2
I1
F
I2
where the functor F : C1 →C2 is the schema transformation mapping between
the categorical representations of the schema categories C1 and C2. The second
part of the transformation consists of a natural transformation ε: I2 ◦F ⇒I1
which obeys certain laws. If we assume that we have the two diagrams
C1
Set
C2
I1
F
I2
ε
and
C1
Set
C2
I1
H
I2
η
where the second diagram has a functor H : C1 →C2 and η: I2 ◦H ⇒I1
a natural transformation. We then require that there exists a unique natural
transformation γ : H ⇒F such that η = ε ◦(I2 ◦γ).
Definition 13 (Data and schema transformation). Let I1 : C1 →Set and
I2 : C2 →Set be two data instances. A transformation from I1 to I2 is a Kan lift
(RiftI2I1 : C1 →C2, ε: I2 ◦RiftI2I1 ⇒I1) so that the functor RiftI2I1 is a full
functor.
We recall our example relational database instance in Figure 3 (a). In order
to transform the relational instance to a property graph we need to construct a
functor from the relational schema category to the graph schema category and
define the natural transformation. Figure 4 describes the full transformation and
the coloring codes the corresponding elements in each category. Informally, the
natural transformation in the example could be understood so that for each
object in the relational schema category, we have a mapping that tells how the
corresponding relational data object in the category Set is mapped to the graph
data object in the category Set.
5
Conclusions and future work
When the variety and amount of data grows, the need for polystores and multi-
model databases is urgent. The efficient utilization of the systems requires a pre-
cise theory of how the systems operate and how they are modeled. So far, there

---

A Category Theoretical Framework for Multi-Model Data Transformations
13
Moderator
ID
ModName
FollowerID
M1
alicee
U1
M2
bobby
U2
Moderator
+ID
+Name
+FollowerID
Channel
ID
ChannelName
Followers
C1
musichannel
504
C2
movie_stream
1057
C3
chat_with_us
2 475 398
C4
learn_dancing
74
ChannelMods
ChannelID
ModID
C1
M1
C2
M2
C3
M1
C3
M2
ChannelMods
+ChannelID
+ModID
Channel
+ID
+ChannelName
+Followers
Schema category for relational data
Images of instance functors in the category Set
Instance functor for relational data
Moderator
+ID
+Name
+Follower
Channel
+ID
+ChannelName
+Followers
Edge
ChannelMods
+ChannelID
+ModID
Vertex
source
target
Moderator:
{id: "M1",
modName: "alicee",
followerID: "U1"}
Instance functor for graph data
Moderator:
{id: "M2",
modName: "bobby",
followerID: "U2"}
Channel:
{id: "C1",
channelName:
"musichannel",
followers: 504}
Channel:
{id: "C4",
channelName:
"learn_dancing",
followers: 74}
Channel:
{id: "C3",
channelName:
"chat_with_us",
followers: 
2475398}
Channel:
{id: "C2",
channelName:
"movie_stream",
followers: 1057}
Transformation
functor i.e. lift
Schema category for graph data
Fig. 4. Example transformation from relational to property graph.
has been extensive research on practical and implementational aspects. With-
out a proper theoretical framework, the field is left scattered. We are answering
this challenge by formalizing the three most common data models and the data
and schema transformations between them. We continued previous research and
contributed by formalizing graph and hierarchical models functorially. We then
focused on data and schema transformations between the functorial instances.
Kan lifts require more studying as a basis for transformations but it seems a
promising direction.
Query transformations form another half of the transformation systems. A
query can be transformed correctly if the data is transformed correctly. This ties
both transformations together which makes the modeling challenge still harder.
Future work would include formalizing and unifying query transformations. In
the case of SQL, the topic has already been studied in [25].
We identify that there is a need to model temporal data better. The prob-
lem of temporality is rarely addressed in polystore, multi-model database, and
transformation research. Usually, the implicit assumption, especially in transfor-
mation frameworks, is that the systems are dealing with static data. Of course,
that is hardly ever true and data changes and expands constantly. We believe
that with category theory we can naturally include a time component to data.
Acknowledgement
This paper is partially supported by Finnish Academy Project 310321 and Oracle
ERO gift funding.

---

14
Valter Uotila and Jiaheng Lu
References
1. Abramsky, S., Coecke, B.: Categorical quantum mechanics (2008)
2. Bumby, R.T., Latch, D.M.: Categorical constructions in graph theory. Inter-
national Journal of Mathematics and Mathematical Sciences 9, 791947 (Jan
1986). https://doi.org/10.1155/S0161171286000017, https://doi.org/10.1155/
S0161171286000017
3. Codd, E.F.: A relational model of data for large shared data banks. Commun.
ACM 13(6), 377–387 (Jun 1970). https://doi.org/10.1145/362384.362685, https:
//doi.org/10.1145/362384.362685
4. Coecke,
B.,
Paquette,
´E.:
Categories
for
the
Practising
Physicist,
pp.
173–286.
Springer
Berlin
Heidelberg,
Berlin,
Heidelberg
(2011).
https://doi.org/10.1007/978-3-642-12821-9 3,
https://doi.org/10.1007/
978-3-642-12821-9_3
5. Coecke, B., Sadrzadeh, M., Clark, S.: Mathematical foundations for a compo-
sitional distributional model of meaning. CoRR abs/1003.4394 (2010), http:
//arxiv.org/abs/1003.4394
6. Cruttwell, G.S.H., Gavranovic, B., Ghani, N., Wilson, P.W., Zanasi, F.: Categorical
foundations of gradient-based learning. CoRR abs/2103.01931 (2021), https:
//arxiv.org/abs/2103.01931
7. Daimler, E., Wisnesky, R.: Informal data transformation considered harmful.
arXiv:2001.00338 [cs] (Jan 2020), http://arxiv.org/abs/2001.00338, arXiv:
2001.00338
8. Das,
S.,
Srinivasan,
J.,
Perry,
M.,
Chong,
E.,
Banerjee,
J.:
A
tale
of
two
graphs:
Property
graphs
as
rdf
in
oracle
(2014).
https://doi.org/10.5441/002/EDBT.2014.82,
https://openproceedings.org/
EDBT/2014/edbticdt2014industrial_submission_28.pdf
9. De Virgilio, R., Maccioni, A., Torlone, R.: Converting relational to graph databases.
In: First International Workshop on Graph Data Management Experiences and
Systems. p. 1–6. ACM (Jun 2013). https://doi.org/10.1145/2484425.2484426,
https://dl.acm.org/doi/10.1145/2484425.2484426
10. Dziedzic, A., Elmore, A.J., Stonebraker, M.: Data transformation and migra-
tion in polystores. In: 2016 IEEE High Performance Extreme Computing Con-
ference, HPEC 2016, Waltham, MA, USA, September 13-15, 2016. pp. 1–
6. IEEE (2016). https://doi.org/10.1109/HPEC.2016.7761594, https://doi.org/
10.1109/HPEC.2016.7761594
11. Fong,
B.,
Spivak,
D.,
Tuy´eras,
R.:
Backprop
as
functor:
A
composi-
tional perspective on supervised learning. In: 2019 34th Annual ACM/IEEE
Symposium
on
Logic
in
Computer
Science
(LICS).
pp.
1–13
(2019).
https://doi.org/10.1109/LICS.2019.8785665
12. Gadepally, V., Chen, P., Duggan, J., Elmore, A., Haynes, B., Kepner, J., Madden,
S., Mattson, T., Stonebraker, M.: The bigdawg polystore system and architecture.
In: 2016 IEEE High Performance Extreme Computing Conference (HPEC). pp. 1–6
(2016). https://doi.org/10.1109/HPEC.2016.7761636
13. van Heerdt, G., Kapp´e, T., Rot, J., Sammartino, M., Silva, A.: A categorical
framework for learning generalised tree automata. CoRR abs/2001.05786 (2020),
https://arxiv.org/abs/2001.05786
14. Holubov´a, I., Klettke, M., St¨orl, U.: Evolution management of multi-model data.
In: Gadepally, V., Mattson, T., Stonebraker, M., Wang, F., Luo, G., Laing, Y.,
Dubovitskaya, A. (eds.) Heterogeneous Data Management, Polystores, and Ana-
lytics for Healthcare. pp. 139–153. Springer International Publishing, Cham (2019)

---

A Category Theoretical Framework for Multi-Model Data Transformations
15
15. Jananthan, H., Zhou, Z., Gadepally, V., Hutchison, D., Kim, S., Kepner, J.:
Polystore mathematics of relational algebra. In: 2017 IEEE International Con-
ference on Big Data (Big Data). pp. 3180–3189. IEEE Computer Society, Los
Alamitos, CA, USA (dec 2017). https://doi.org/10.1109/BigData.2017.8258298,
https://doi.ieeecomputersociety.org/10.1109/BigData.2017.8258298
16. Kadish, B., Diskin, Z.: Algebraic graph-oriented = category theory based. mani-
festo of categorizing database theory (1994)
17. Lane, S.: Categories for the Working Mathematician. Graduate Texts in Math-
ematics, Springer New York, 233 Spring St, New York, NY 10013, USA (1998),
https://doi.org/10.1007/978-1-4612-9839-7
18. Leclercq, E., Savonnet, M.: A tensor based data model for polystore: An
application to social networks data. In: Proceedings of the 22nd Interna-
tional Database Engineering & Applications Symposium. p. 110–118. IDEAS
2018, Association for Computing Machinery, New York, NY, USA (2018).
https://doi.org/10.1145/3216122.3216152,
https://doi.org/10.1145/3216122.
3216152
19. Liu, Z., Lu, J., Gawlick, D., Helskyaho, H., Pogossiants, G., Wu, Z.: Multi-model
database management systems - a look forward. In: Poly/DMAH@VLDB (2018)
20. Lu, J., Holubov´a, I., Cautis, B.: Multi-model databases and tightly integrated
polystores: Current practices, comparisons, and open challenges. In: Cuzzocrea,
A., Allan, J., Paton, N.W., Srivastava, D., Agrawal, R., Broder, A.Z., Zaki,
M.J., Candan, K.S., Labrinidis, A., Schuster, A., Wang, H. (eds.) Proceed-
ings of the 27th ACM International Conference on Information and Knowl-
edge Management, CIKM 2018, Torino, Italy, October 22-26, 2018. pp. 2301–
2302. ACM (2018). https://doi.org/10.1145/3269206.3274269, https://doi.org/
10.1145/3269206.3274269
21. nLab authors: Kan lift. http://ncatlab.org/nlab/show/Kan%20lift (May 2021)
22. Riehl, E.: Category Theory in Context. Aurora: Dover Modern Math Originals,
Dover Publications, 31 2nd St, Mineola, NY 11501, USA (2017), www.math.jhu.
edu/~eriehl/context.pdf
23. Shinavier, J., Wisnesky, R.: Algebraic property graphs (2020)
24. Spivak, D.I.: Functorial data migration. CoRR abs/1009.1166 (2010), http://
arxiv.org/abs/1009.1166
25. Spivak, D.I.: Database queries and constraints via lifting problems. Mathematical
Structures in Computer Science 24 (2013)
26. Spivak, D.I.: Category theory for the sciences. MIT Press (2014)
27. Sun, W., Fokoue, A., Srinivas, K., Kementsietsidis, A., Hu, G., Xie, G.: Sql-
graph: An efficient relational-based property graph store. In: Proceedings of
the 2015 ACM SIGMOD International Conference on Management of Data. p.
1887–1901. ACM (May 2015). https://doi.org/10.1145/2723372.2723732, https:
//dl.acm.org/doi/10.1145/2723372.2723732
28. Wells, C.: Category theory for computing science. Theory and Applications of
Categories 22, 515 (01 2012)

---

