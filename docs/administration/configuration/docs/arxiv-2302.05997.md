# The FOLE Database

> 来源: https://arxiv.org/pdf/2302.05997

arXiv:2302.05997v4  [cs.DB]  21 Apr 2023
The FOLE Database
Robert E. Kent
Ontologos
Abstract. This paper continues the discussion of the representation
and interpretation of ontologies in the ﬁrst-order logical environment
FOLE. The formalism and semantics of (many-sorted) ﬁrst-order logic can
be developed in both a classiﬁcation form and an interpretation form.
Two papers, “The ERA of FOLE: Foundation” and “The ERA of FOLE: Su-
perstructure”, represent the classiﬁcation form, corresponding to ideas
discussed in the Information Flow Framework. Two papers, “The FOLE
Table” and the current paper, represent the interpretation form, expand-
ing on material found in the paper “Database Semantics”. Although the
classiﬁcation form follows the entity-relationship-attribute data model of
Chen, the interpretation form incorporates the relational data model of
Codd. In general, the FOLE representation uses a conceptual structures
approach, that is completely compatible with the theory of institutions
(Goguen and Burstall), formal concept analysis (Ganter and Wille), and
information ﬂow (Barwise and Seligman).
Keywords: schema, schemed domain, database.

---

Table of Contents
The FOLE Database . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
1
Robert E. Kent
1
Introduction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
3
1.1
Knowledge Representation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
3
1.2
First Order Logical Environment . . . . . . . . . . . . . . . . . . . . . . . . . . . .
3
1.3
Overview . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
5
2
FOLE Schemas: LIST . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
6
3
FOLE Schemed Domains . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
8
3.1
General Case: DOM . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
8
3.2
Type Domain Indexing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
11
3.2.1 Lower Aspect:
˚
Dom(A) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
11
3.2.2 Upper Aspect:
˚
Dom . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
12
4
FOLE Databases . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
14
4.1
General Case: DB . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
14
4.2
Type Domain Indexing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
18
4.2.1 Lower Aspect: Db(A) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
18
4.2.2 Upper Aspect: Db . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
21
A Appendix . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
26
A.1 General Theory . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
26
A.1.1 Grothendieck Construction . . . . . . . . . . . . . . . . . . . . . . . . . . . .
27
A.1.2 Diagram Contexts. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
30
A.1.3 Kan Extensions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
34
A.2 Database Applications . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
38
A.2.1 Contexts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
38
A.2.2 Passages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
39
A.2.3 Bridges . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
40

---

The FOLE Database
3
1
Introduction
1.1
Knowledge Representation
Many-sorted (multi-sorted) ﬁrst-order predicate logic represents a community’s
“universe of discourse” as a heterogeneous collection of objects by conceptually
scaling the universe according to types. The relational model (Codd [3]) is an
approach for the information management of a “community of discourse” 1 using
the semantics and formalism of (many-sorted) ﬁrst-order predicate logic. The re-
lational model was initially discussed in two papers: “A Relational Model of Data
for Large Shared Data Banks” by Codd [?] and “The Entity-Relationship Model
– Toward a Uniﬁed View of Data” by Chen [2]. The relational model follows
many-sorted logic by representing data in terms of many-sorted relations, subsets
of the Cartesian product of multiple domains. All data is represented horizon-
tally in terms of tuples, which are grouped vertically into relations. A database
organized in terms of the relational model is a called relational database. The
relational model provides a method for modeling the data stored in a relational
database and for deﬁning queries upon it.
1.2
First Order Logical Environment
Basics. The ﬁrst-order logical environment FOLE is a category-theoretic repre-
sentation for many-sorted (multi-sorted) ﬁrst-order predicate logic. 2 The rela-
tional model can naturally be represented in FOLE. The FOLE approach to logic,
and hence to databases, relies upon two mathematical concepts: (1) lists and (2)
classiﬁcations. Lists represent database signatures and tuples; classiﬁcations rep-
resent data-types and logical predicates. FOLE represents the header of a database
table as a list of sorts, and represents the body of a database table as a set of
tuples classiﬁed by the header. The notion of a list is common in category the-
ory. The notion of a classiﬁcation is described in two books: “Information Flow:
The Logic of Distributed Systems” by Barwise and Seligman [1] and ”Formal
Concept Analysis: Mathematical Foundations” by Ganter and Wille [4].
Philosophy. A relational database system should satisfy the following properties.
It should present the data to the user as relations. In a FOLE database this is ac-
complished by using FOLE tables, which are discussed in the paper [12]. It should
provide relational operations to manipulate the data in tabular form. Relational
operations are discussed in the paper [14]. A relational database is a diagram
1 Examples include: an academic discipline; a commercial enterprise; library science;
the legal profession; etc.
2 Following the original discussion of FOLE (Kent [9]), we use the term mathematical
context for the concept of a category, the term passage for the concept of a functor,
and the term bridge for the concept of a natural transformation. A context represents
some “species of mathematical structure”. A passage is a “natural construction on
structures of one species, yielding structures of another species” (Goguen [?]).

---

4
Robert E. Kent
(linked collection) of tables. The information in a database is accessed by spec-
ifying queries, which use operations such as select to identify tuples, project to
identify attributes, and join to combine tables. In this paper, projection refers
to a primitive generalization-specialization operation between pairs of relational
tables (they are speciﬁed by the database schema, project from joined table to
components, or other), whereas join is a composite operation on a linked collec-
tion of tables. Selection is a special case of join, which uses reference relations
(tables).
Architecture. A series of papers provides a rigorous mathematical basis for
FOLE by deﬁning an architectural semantics for the relational data model, thus
providing the foundation for the formalism and semantics of ﬁrst-order logi-
cal/relational database systems. This architecture consists of two hierarchies of
two nodes each: the classiﬁcation hierarchy and the interpretation hierarchy.
• Two papers provide a precise mathematical basis for FOLE classiﬁcation. The
paper “The ERA of FOLE: Foundation” [10] develops the notion of a FOLE
structure, following the entity-relationship model of Chen [2]. This provided
a basis for the paper “The ERA of FOLE: Superstructure” [11], which develops
the notion of a FOLE sound logic.
• Two papers provide a precise mathematical basis for FOLE interpretation.
Both of these papers expand on material found in the paper “Database
Semantics” [8]. The paper “The FOLE Table” [12], develops the notion of a
FOLE table following the relational model of Codd [3]. This provides a basis
for the current paper “The FOLE Database”, which develops the notion of a
FOLE relational database.
The architecture of FOLE is pictured brieﬂy on the
right and more completely in Fig. 1 of the preface
of the paper [13]. This consists of two hierarchies of
two nodes each. The paper “FOLE Equivalence” [13]
proves that FOLE sound logics are equivalent to FOLE
databases.
≡
Relational
Calculus
Relational
Algebra
✾
✿
◦
•
◦
◦
FOLE
architecture
In the relational model there are two approaches for database management:
the relational algebra, which deﬁnes an imperative language, and the relational
calculus, which deﬁnes a declarative language. The paper “Relational Operations
in FOLE” [14] represents relational algebra by expressing the relational operations
of database theory in a clear and implementable representation. The relational
calculus will be represented in FOLE in a future paper.

---

The FOLE Database
5
1.3
Overview
This paper deﬁnes an architectural semantics for the relational data model. 3 It
deﬁnes the notion of a relational database in terms of the the ﬁrst-order logical
environment FOLE. In §2 we deﬁne FOLE Schemas in the context LIST. A schema
is a diagram of signatures. In §3 we deﬁne FOLE Schemed Domains. A schemed
domain is a diagram of signed domains. In §3.1 schemed domains are deﬁned in
general in the context DOM. In §3.2 schemed domains are deﬁned with ﬁxed
type domain (datatypes). In §3.2.1 schemed domains are constrained to a par-
ticular ﬁxed type domain (the lower aspect) in the context
˚
Dom(A). In §3.2.2
schemed domains are constrained to a ﬁxed type domain morphism (the upper
aspect) in the context
˚
Dom. The projective components of schemed domains
are deﬁned: signature diagrams (schemas) and type domain diagrams. Hence,
a schemed domain is a diagram of signed domains consisting of the following
components: a signature diagram and a type domain diagram with the same
shape and a common sort diagram. In §4 we deﬁne FOLE Databases. A relational
database is a diagram of tables. In §4.1 databases are deﬁned in general in the
context DB. In §4.2 databases are deﬁned with ﬁxed type domain (datatypes).
In §4.2.1 databases are constrained to a particular ﬁxed type domain (the lower
aspect) in the context Db(A). In §4.2.2 databases are constrained to a ﬁxed
type domain morphism (the upper aspect) in the context Db. Following tables,
the projective components of databases are deﬁned: 4 signed domain diagrams
(schemed domains) and key diagrams, linked by tuple bridges. Hence, a rela-
tional database is a diagram of tables consisting of the following components:
a signed domain diagram and a key set diagram with the same shape, which
are connected by a tuple bridge. The appendix §A reviews general theory and
database components. In §A.1 we review general theory: Grothendieck construc-
tion in §A.1.1, diagram contexts in §A.1.2, and Kan extensions in §A.1.3. In §A.2
we review the various database components of FOLE: contexts in §A.2.1, passages
in §A.2.2, and bridges in §A.2.3.
3 Older architectures of data include the hierarchical model and network model. Of
these, nothing will be said. A newer architecture of data, called the object-relation-
object model, is a presentation form for the relational data model described here.
4 Tables are based upon lists (signatures) and classiﬁcations (type domains), which
are linked through sort sets.

---

6
Robert E. Kent
§2
Fig. 1
: Schema Morphism: LIST
Fig. 2
: Schema Context: LIST
§3.1
Fig. 3
: Schemed Domain Morphism: DOM
Fig. 4
: Schemed Domain Context: DOM
§3.2.1
Fig. 5
: Schemed Domain Morphism:
˚
Dom(A)
§3.2.2
Fig. 6
: Schemed Domain Morphism:
˚
Dom
§4.1
Fig. 7
: Database Morphism: DB
Fig. 8
: Database Context: DB
Fig. 9
: Database Morphism (proj): DB
§4.2.1
Fig. 10 : Database Morphism: Db(A)
Fig. 11 : Database Context: Db(A)
Fig. 12 : Database Morphism (proj): Db(A)
§4.2.2
Fig. 13 : Database Morphism: Db
Fig. 14 : Database Context: Db
Fig. 15 : Database Morphism (proj): Db
§A.1.1
Fig. 16 : Inclusion Bridge: Fibered Context
§A.2.1
Fig. 17 : Diagram/Comma/Fibered Contexts
§1.3
Tbl. 1 : Figures and Tables
§3
Tbl. 2 : Schemed Domain Contexts
§4
Tbl. 3 : Relational Database Contexts
§A.2.1
Tbl. 4 : Schemed Domain Morphisms
Tbl. 5 : Relational Database Morphisms
§A.2.2
Tbl. 6 : Projection Passages
Tbl. 7 : Lim (Colim) Passages
§A.2.3
Tbl. 8 : Bridges
Tbl. 9 : Bridge Adjoints and Composites
Table 1. Figures and Tables
2
FOLE Schemas: LIST
A schema ⟨R, S⟩consists of a shape context R and a diagram of signatures
(lists) R
S
−−→List. A schema morphism ⟨R2, S2⟩
⟨R, σ⟩
−−−−→⟨R1, S1⟩consists of a
shape-changing passage R1
R
−−→R1 and a bridge S2
σ
==⇒R ◦S1. Composition
is component-wise.
R2
R1
List
R
S2
S1
σ
=⇒
✲
❙
❙
❙✇
✓
✓
✓✴
Fig. 1. Schema Morphism: LIST
Deﬁnition 1. The context of schemas is LIST = List
⇑=
 Cxt ⇑List

, a
diagram context over signatures (lists).
Proposition 1. The ﬁbered context (Grothendieck construction) LIST = List
⇑=
R
ˆ
List is complete and cocomplete and the projection List
⇑→Cxt : ⟨R, S⟩7→R
is continuous and cocontinuous.
Proof. Use the lax parts of Prop. 18 and Prop. 19 in § A.1.3, since the context
of schemas LIST is the diagram context LIST = List
⇑=
R
ˆ
List and List is
complete and cocomplete.

---

The FOLE Database
7
Projections. Projections oﬀer an alternate representation, deﬁning the two pri-
mary components of schemas and schema morphisms: arity diagrams and sort
diagrams. arity diagrams and sort diagrams come from composition with list
projection passages Set
arity
←−−−List
sort
−−→Set. The context LIST has projection
passages Set
⇑
˚
arity
←−−−LIST
˚
sort
−−→Set
⇑.
• The arity domain projection
˚
arity = (-) ◦arity : LIST = List
⇑→Set
⇑
◦maps a schema ⟨R, S⟩to the arity diagram
˚
arity(R, S) = ⟨R, S ◦arity⟩
with the arity passage R
A
−−−−−→
S ◦arity Set, and
◦maps a schema morphism ⟨R2, S2⟩
⟨R, σ⟩
−−−−→⟨R1, S1⟩to the arity dia-
gram morphism
˚
arity(R, σ) = ⟨R, α⟩: ⟨R2, S2⟩→⟨R1, S1⟩with bridge
A2
α
======⇒
σ ◦arity
R ◦A1.
• The sort domain projection
˚
sort = (-) ◦sort : LIST = List
⇑→Set
⇑
◦maps a schema ⟨R, S⟩to the sort diagram
˚
sort(R, S) = ⟨R, S ◦sort⟩
with the sort passage R
B
−−−−−→
S ◦sort Set,
◦maps a schema morphism ⟨R2, S2⟩
⟨R, σ⟩
−−−−→⟨R1, S1⟩to the sort dia-
gram morphism
˚
sort(R, σ) = ⟨R, β⟩: ⟨R2, B2⟩→⟨R1, B1⟩with a bridge
B2
β
=====⇒
σ ◦sort
R ◦B1.
Set⇑
LIST
Set⇑
˚
arity
˚
sort
✛
✲
Fig. 2. FOLE Schema Context

---

8
Robert E. Kent
3
FOLE Schemed Domains
The schemed domain contexts deﬁned in this paper are listed in Tbl. 2.
DOM = Dom⇑
: diagram context
Def. 2
in § 3.1
= LIST×Set⇑CLS : pullback context
Prop. 3 in § 3.1
˚
Dom(A) = Dom(A)⇑
: diagram context
Def. 3
in § 3.2.1
˚
Dom =
R
Cls
ˆ
dom
−−−→Adj : Grothendieck construction
Prop. 5 in § 3.2.2
Table 2. Schemed Domain Contexts
3.1
General Case: DOM
In this section we discuss the context of schemed domains DOM, which mirrors
the context of signed domains Dom at a higher dimension. 5 A schemed domain
(signed domain diagram) ⟨R, Q⟩consists of a shape context R and a diagram
of signed domains R
Q
−−→Dom. A schemed domain morphism ⟨R2, Q2⟩
⟨R, ς⟩
−−−→
⟨R1, Q1⟩(Fig. 3) consists of a shape-changing passage R1
R
−−→R1 and a bridge
ς : Q2 ⇒R ◦Q1. Composition is component-wise.
R2
R1
Dom
R
Q2
Q1
ς
=⇒
✲
❙
❙
❙✇
✓
✓
✓✴
Fig. 3. Schemed Domain Morphism: DOM
Deﬁnition 2. The context of schemed domains is the lax comma context DOM =
Dom
⇑, a diagram context over signed domains. (Def. 7 in § A.1.2)
Proposition 2. The ﬁbered context (Grothendieck construction) DOM = Dom
⇑=
R
ˆ
Dom is complete and cocomplete and the projection Dom
⇑→Cxt : ⟨R, Q⟩7→
R is continuous and cocontinuous.
5 The schemed domain R
Q
−→Dom as developed in this paper is a derived concept built
up from the basic concept of the signed domain D = ⟨I, s, A⟩∈Dom as deﬁned
in the paper “The FOLE Table” [12]. We replace signed domains D ∈Dom with
diagrams (passages) R
Q
−→Dom, and replace signed domain morphisms D2
⟨h,f,g⟩
−−−−→
D1 in Dom with bridges ς : Q2 ⇒R ◦Q1.

---

The FOLE Database
9
Proof. Use the lax parts of Prop. 18 and Prop. 19 in § A.1.3, since the context
of schemed domains DOM is the diagram context DOM = Dom
⇑=
R
ˆ
Dom
and Dom is complete and cocomplete.
Projections. Projections oﬀer an alternate representation, deﬁning the three
primary components of schemed domains and schemed domain morphisms: di-
agram shapes, signature domains and type domain diagrams. Diagram shapes
are direct projections, whereas signature domains and type domain diagrams
are indirect, coming from composition with signed domain projection passages
(deﬁned in detail in §2.3 of the paper “The FOLE Table” [12]). The schemed
domain projections are described in Fig. 4 and deﬁned as follows.
• The signature domain projection
˚
sign = (-) ◦sign : DOM →LIST
◦maps a schemed domain ⟨R, Q⟩to the schema
˚
sign(R, Q) = ⟨R, Q ◦sign⟩=
⟨R, S⟩with the signature passage R
S
−−−−−→
Q ◦sign List, and
◦maps a schemed domain morphism ⟨R2, Q2⟩
⟨R, ς⟩
−−−→⟨R1, Q1⟩to the
schema morphism
˚
sign(R, ς) = ⟨R, γ⟩: ⟨R2, S2⟩→⟨R1, S1⟩with bridge
S2
γ
=====⇒
ς ◦sign
R ◦S1.
• The type domain projection
˚
data = (-) ◦data : DOM →CLS
◦maps a schemed domain ⟨R, Q⟩to the type domain diagram
˚
data(R, Q) =
⟨R, C⟩with the type domain passage R
C
−−−−−→
Q ◦data Set,
◦and maps a schemed domain morphism ⟨R2, Q2⟩
⟨R, ς⟩
−−−→⟨R1, Q1⟩to the
CLS-morphism
˚
data(R, ς) = ⟨R, γ⟩: ⟨R2, C2⟩→⟨R1, C1⟩with a bridge
C2
γ
=====⇒
ς ◦data
R ◦C1.
Pullback Context. The context DOM has projection passages (RHS Fig. 4)
LIST
˚
sign
←−−−DOM
˚
data
−−−→CLS. 6 7
• Using projections, a schemed domain ⟨R, S, A⟩consists of a schema (signa-
ture diagram) ⟨R, S⟩∈LIST and a type domain diagram ⟨R, A⟩∈CLS
with common sort diagram
˚
sort(R, S) = ⟨R, X ⟩=
˚
sort(R, A) ∈Set
⇑
6 LIST = List⇑is the context of schemas. A schema ⟨R, S⟩consists of a shape
context R and a diagram of signatures (lists) R
S
−−→List. A schema morphism
⟨R2, S2⟩
⟨R, σ⟩
−−−−→⟨R1, S1⟩consists of a shape-changing passage R1
R
−−→R1 and a
bridge S2
σ
==⇒R ◦S1.
7 CLS = Cls⇑. is the context of type domain diagrams. A type domain diagram
⟨R, A⟩consists of a shape context R and a diagram of type domains R
A
−−→Cls.
A morphism of type domain diagrams ⟨R2, A2⟩
⟨R,α⟩
−−−→⟨R1, A1⟩consists of a shape-
changing passage R1
R
−−→R1 and a bridge A2
α
==⇒R ◦A1.

---

10
Robert E. Kent
(and hence common shape R). The passages R
S−→List and R
A
−→Cls
satisfy S ◦sort = X = A ◦sort. 8
• A schemed domain morphism ⟨R2, S2, A2⟩
⟨R,σ,α⟩
−−−−−→⟨R1, S1, A1⟩consists of
a morphism of signature diagrams ⟨R2, S2⟩
⟨R,σ⟩
−−−→⟨R1, S1⟩in LIST and
a morphism of type domain diagrams ⟨R2, A2⟩
⟨R,α⟩
−−−→⟨R1, A1⟩in CLS
with common sort diagram morphism
˚
sort(R, σ) = ⟨R, ω⟩=
˚
sort(R, α) ∈
Set
⇑(and hence common shape-changing passage R2
R
−−→R1). The bridges
S2
σ
==⇒R ◦S1 and A2
α
==⇒R ◦A1 satisfy σ ◦sort = α ◦sort.
Proposition 3. The context of schemed domains DOM is the pullback context
(ﬁbered product)
LIST
˚
sign
←−−DOM = LIST×Set⇑CLS
˚
data
−−→CLS
for the opspan of passages LIST
˚
sort
−−→Set
⇑
˚
sort
←−−CLS (Fig. 4 RHS).
Proof. From §2.3 of the paper “The FOLE Table” [12], the context of signed
domains Dom can be deﬁned as the ﬁbered product
List
sign
←−−Dom = List×SetCls
data
−−→Cls,
for the opspan of passages List
sort
−−→Set
sort
←−−Cls.
Set
Dom =
 Set ↓sort

Cls
Set
List =
 Set ↓Set

Set
arity
data
arity
sort
1
sign
sort
✛
✲
✛
✲
❄
❄
❄
Extend this to diagram contexts LIST = List
⇑and CLS = Cls
⇑.
8 LIST
˚
sort
−−→Set⇑is the sort projection for the ﬁbered context of schemas (signature
diagrams), and CLS
˚
sort
−−→Set⇑is the sort projection for type domain diagrams.

---

The FOLE Database
11
Set⇑
DOM
CLS
Set⇑
LIST
Set⇑
˚
arity
˚
arity
˚
data
˚
sort
1
˚
sign
˚
sort
✛
✛
✲
✲
❄
❄
❄
schema
˚
sign = (-) ◦sign : DOM →LIST
data
˚
data = (-) ◦data : DOM →CLS
Fig. 4. Schemed Domain Context: DOM
3.2
Type Domain Indexing
A type domain, which constrains a signed domain, is an indexed collection of
data types. Here we deﬁne schemed domains with ﬁxed type domains. Schemed
domains with ﬁxed signed domains (headers plus datatypes) are trivial.
3.2.1
Lower Aspect:
˚
Dom(A) Let A = ⟨X, Y, |=A⟩be a ﬁxed type domain.
Deﬁnition 3. The context of A-schemed domains is
˚
Dom(A) = Dom(A)⇑=
List(X)⇑, a diagram context over A-signed domains; i.e. X-signatures.
A relational A-schemed domain ⟨R, S⟩is a diagram of A-signatures, consisting
of a shape context R and a passage R
S
−→List(X). A A-schemed domain
morphism ⟨R2, S2⟩
⟨R, ϕ⟩
−−−−→⟨R1, S1⟩consists of a shape-changing passage R1
R
−−→
R1 and a bridge S2
ϕ
==⇒R◦S1.
R2
R1
List(X)
R
S2
S1
ϕ
=⇒
✲
❙
❙
❙✇
✓
✓
✓✴
Fig. 5. Schemed Domain Morphism:
˚
Dom(A)
Proposition 4. The ﬁbered context (Grothendieck construction) of A-schemed
domains
˚
Dom(A) = Dom(A)⇑= List(X)⇑is complete and cocomplete and
the projection
˚
Dom(A) = Dom(A)⇓= List(X)⇑→Cxt : ⟨R, S⟩7→R is
continuous and cocontinuous.
Proof. By Prop. 19 of § A.1.3, since the context Dom(A) = List(X) is cocom-
plete and complete (see § 4.2 in the paper “The FOLE Table” [12]).

---

12
Robert E. Kent
3.2.2
Upper Aspect:
˚
Dom The subcontext of FOLE schemed domains (with
constant type domains and constant type domain morphisms) is denoted by
˚
Dom ⊆DOM.
• A schemed domain ⟨R, S, A⟩in
˚
Dom consists of a type domain A and a
schemed domain ⟨R, S⟩in
˚
Dom(A) with a shape context R and a passage
R
S
−→Dom(A) ∼= List(X).
• A schemed domain morphism ⟨R2, S2, A2⟩
⟨R, ˆϕ,f,g⟩
−−−−−−→⟨R1, S1, A1⟩in
˚
Dom
(Fig. 6) with constant type domain morphism ⟨f, g⟩: A2 ⇄A1 is a FOLE
schemed domain morphism ⟨R, ς⟩: ⟨R2, Q2⟩→⟨R1, Q1⟩, whose signed
domain interpretation bridge Q2
ς
==⇒R ◦Q1 factors adjointly
( ´ϕ ◦incA2) • (R ◦S1 ◦`ι⟨f,g⟩) = ς = (S2 ◦´ι⟨f,g⟩) • ( `ϕ ◦incA1)
(1)
through the ﬁber adjunction Dom(A2)
|
{z
}
List(X2)
`
dom ⟨f,g⟩⊣
´
dom⟨f,g⟩
−−−−−−−−−−−−−→
P
f ⊣f ∗
Dom(A1)
|
{z
}
List(X1)
using
the signed domain inclusion bridge adjointness ˆι⟨f,g⟩= (´ι⟨f,g⟩,`ι⟨f,g⟩)
levo
dextro
´ι⟨f,g⟩:
`
dom⟨f,g⟩◦incA1 ⇐incA2
`ι⟨f,g⟩: incA1 ⇐
´
dom⟨f,g⟩◦incA2
´ι⟨f,g⟩=
 ηf ◦incA2

•
 `
dom⟨f,g⟩◦`ι⟨f,g⟩

`ι⟨f,g⟩=
 ´
dom⟨f,g⟩◦´ι⟨f,g⟩

•
 εf ◦incA1

abstractly deﬁned in § A.1.1. This consists of equivalent morphisms
⟨R2, S2⟩
⟨R, ´ϕ⟩
−−−−→
⟨R1,S1◦
´
dom⟨f,g⟩⟩
z
}|
{
´
dom⟨f,g⟩(R1, S1)
|
{z
}
∈
˚
Dom(A2)
∼
=
↔
⟨R2,S2◦
`
dom⟨f,g⟩⟩
z
}|
{
`
dom⟨f,g⟩(R2, S2)
⟨R, `ϕ⟩
−−−−→⟨R1, S1⟩
|
{z
}
∈
˚
Dom(A1)
We normally just use the bridge restriction ´ϕ or `ϕ for the schemed domain
morphism. We use ˆϕ to denote either of these equivalent bridges. The original
deﬁnition can be computed with the factorization in Disp. 1.
Proposition 5. Hence, the ﬁbered context
˚
Dom (with constant type domain)
is the Grothendieck construction of the indexed adjunction
˚
Dom =
R
data : Cls
ˆ
dom
−−−→Adj.
Proof. For any type domain morphism A2
⟨f,g⟩
−−−⇀
↽−−−A1, there is a schemed domain
ﬁber adjunction Dom(A2)
|
{z
}
List(X2)
`
dom⟨f,g⟩⊣
´
dom⟨f,g⟩
−−−−−−−−−−−−−→
P
f ⊣f ∗
Dom(A1)
|
{z
}
List(X1)
that deﬁnes the context
of schemed domains
˚
Dom via the Grothendieck construction.

---

The FOLE Database
13
R2
R1
Dom(A2)
Dom(A1)
Dom
R
S2
S1
´
dom⟨f,g⟩
f ∗
incA2
incA1
´ϕ
=⇒
levo
`ι⟨f,g⟩
=⇒
✲
✛
❄
❄
❙
❙
❙✇
✓
✓
✓✴
R2
R1
Dom
R
Q2
Q1
ς
==⇒
✲
❫
✢
=
=
R2
R1
Dom(A2)
Dom(A1)
Dom
R
S2
S1
`
dom⟨f,g⟩
P
f
incA2
incA1
`ϕ
=⇒
dextro
´ι⟨f,g⟩
=⇒
✲
✲
❄
❄
❙
❙
❙✇
✓
✓
✓✴
levo
dextro
´ϕ : S2 ⇒R ◦S1 ◦
´
dom ⟨f,g⟩
`ϕ : S2 ◦
`
dom⟨f,g⟩⇒R ◦S1
´ϕ = (S2 ◦η⟨f,g⟩) • ( `ϕ ◦
´
dom⟨f,g⟩)
`ϕ = ( ´ϕ ◦
`
dom⟨f,g⟩) • (R ◦S1 ◦ε⟨f,g⟩)
Fig. 6. Schemed Domain Morphism:
˚
Dom
Proposition 6.
˚
Dom is a complete and cocomplete context.
Proof. By Fact 5 of § A.1.1, since the indexing context Cls is complete and co-
complete ([1]), and the ﬁber context
˚
Dom(A) = Dom(A)⇑= List(X)⇑is com-
plete and cocomplete for each type domain A by Prop.4 above.

---

14
Robert E. Kent
4
FOLE Databases
The relational database contexts deﬁned in this paper are listed in Tbl. 3.
DB = Tbl⇓
: diagram context
Def. 4
in § 4.1
Db(A) = Tbl(A)⇓
: diagram context
Def. 5
in § 4.2.1
Db =
R
Clsop
ˆ
db
−−→Adj : Grothendieck construction
Prop. 11 in § 4.2.2
Table 3. Relational Database Contexts
4.1
General Case: DB
In this section we discuss the context of relational databases DB. which mirrors
the context of tables Tbl at a higher dimension. 9 A relational database ⟨R, T⟩is
a diagram of tables, consisting of a shape context R and a passage Rop T
−−→Tbl.
A relational database morphism (Fig. 7) ⟨R2, T2⟩
⟨R, ξ⟩
←−−−⟨R1, T1⟩consists of a
shape-changing passage R2
R
−−→R1 and a bridge T2
ξ
⇐= Rop◦T1.
Rop
2
Rop
1
Tbl
Rop
T2
T1
ξ
⇐=
✲
❙
❙
❙✇
✓
✓
✓✴
Fig. 7. Database Morphism: DB
Deﬁnition 4. The context of databases is the oplax comma context DB = Tbl
⇓,
a diagram context over tables. (Def. 7 in § A.1.2)
Proposition 7. The context of databases DB is complete and cocomplete and
the projection DB →Cxt : ⟨R, T⟩7→R is continuous and cocontinuous.
Proof. Use the oplax parts of Prop. 18 and Prop. 19 in § A.1.3, since the context
of databases DB is the diagram context DB = Tbl
⇓=
R
ˆ
Tbl and Tbl is
complete and cocomplete.
9 The database Rop
T
−−→Tbl as developed in this paper is a derived concept built up
from the basic concept of the table T = ⟨D, K, t⟩∈Tbl as deﬁned in the paper “The
FOLE Table” [12]. We replace tables T ∈Tbl with diagrams (passages) Rop
T
−−→Tbl,
and replace table morphisms T2
⟨⟨h,f,g⟩,k⟩
−−−−−−−→T1 in Tbl with bridges ξ : T2 ⇐Rop◦T1.

---

The FOLE Database
15
Examples. Since DB is complete and cocomplete, so is DBop. Here we illus-
trate speciﬁc limits and colimits in DBop: initial and terminal objects, binary
coproducts and binary products, etc.
initial: ⟨∅op, 0Tbl⟩is the initial database in DBop. To any database ⟨R, T⟩
there is a unique database morphism ⟨∅op, 0Tbl⟩
⟨0op, 10Tbl ⟩
−−−−−−−→⟨R, T⟩in DBop.
terminal: ⟨Tblop, 1Tbl⟩is the terminal database in DBop. From any database
⟨R, T⟩there is a unique database morphism ⟨R, T⟩
⟨T op, 1T ⟩
−−−−−−→⟨Tblop, 1Tbl⟩
in DBop.
coproduct: Any pair of databases ⟨R1, T1⟩and ⟨R2, T2⟩has the binary coproduct
database ⟨R12, T12⟩in DBop that combines the two databases in an inde-
pendent union. The binary coproduct consists of
• the (opposite of the) coproduct context Rop
12 = Rop
1 + Rop
2
and
• the copairing passage Rop
12
T12
−−−−−→
[T1,T2] Tbl.
There is an opspan of injection database morphisms in DBop
⟨R1, T1⟩
⟨inc1, 1⟩
−−−−−→⟨R1+ R2, T12⟩
⟨inc2, 1⟩
←−−−−−⟨R2, T2⟩
with the opspan of inclusion passages R1
inc1֒
−−→R1 + R2
inc2
←−−֓ R2 and the
pair of identity bridges T1
1
⇐= incop
1 ◦T12 and incop
2 ◦T12
1
=⇒T2.
product: Any pair of databases ⟨R1, T1⟩and ⟨R2, T2⟩with the opspan of
passages Rop
1
T1
−−−→Tbl
T2
←−−−Rop
2
has a binary product database in DBop.
The binary product ⟨R12, T12⟩consists of
• the (opposite of the) pullback context Rop
12 = Rop
1 ×Tbl Rop
2
and
• the pairing passage Rop
12
T12
−−−−−→
(T1,T2) Tbl.
There is a span of projection database morphisms in DBop
⟨R1, T1⟩
⟨pr1, 1⟩
←−−−−−⟨R12, T12⟩
⟨pr 2, 1⟩
−−−−−→⟨R2, T2⟩
with the span of projection passages Rop
1
pr op
1
←−−−Rop
12
pr op
2
−−−→Rop
2
and the pair
of identity bridges pr op
1 ◦T1
1
⇐= T12 and pr op
2 ◦T12
1
=⇒T2.

---

16
Robert E. Kent
Projections. Projections oﬀer an alternate representation, deﬁning the three
primary components of databases and database morphisms: diagram shapes,
schemed domains and key diagrams. Diagram shapes are direct projections,
whereas schemed domains and key diagrams are indirect, coming from com-
position with table projection passages Compare the following ﬁgure (from the
FOLE table paper [12]) to Fig. 8 below.
Tbl
Domop
Set
key
dom
tup
τ
==⇒
❅❅
❘
  ✠
❘
Set
1
Tbl
Clsop
Listop
Setop
Domop
key
dom
data
sign
sort op
sort op
✛
✲
✛
✲
❄
❄
❄
❍❍
❥
✟
✟
✙
✟✟
✯
The context of schemed domains DOM can also be deﬁned as the ﬁbered prod-
uct
LIST
˚
sign
←−−DOM = LIST×SETCLS
˚
data
−−→CLS,
for the opspan of passages LIST
˚
sort
−−→SET
˚
sort
←−−CLS. The database projec-
tions are described in Fig. 8 and are deﬁned as follows.
• The schemed domain projection
˚
dom = (-)op ◦dom : DBop →DOM maps
a relational database ⟨R, T⟩to the schemed domain
˚
dom(R, T) = ⟨R, Q⟩
with signed domain diagram R
Q
−−−−−−→
T op◦dom
Dom, and maps a relational
database morphism ⟨R2, T2⟩
⟨R, ξ⟩
←−−−⟨R1, T1⟩to the schemed domain mor-
phism
˚
dom(R, ξ) = ⟨R, ς⟩: ⟨R2, Q2⟩→⟨R1, Q1⟩with schemed domain bridge
Q2
ς
======⇒
ξop◦dom
R ◦Q1.
• The key projection ˚
key = (-)◦key : DB →SET maps a relational database
⟨R, T⟩to the key set diagram
˚
key(R, T) = ⟨R, K⟩with the key passage
Rop
K
−−−−−→
T ◦key Set, and maps a relational database morphism ⟨R2, T2⟩
⟨R, ξ⟩
←−−−
⟨R1, T1⟩to the SET-morphism
˚
key(R, ξ) = ⟨R, κ⟩: ⟨R2, K2⟩←⟨R1, K1⟩
with a bridge K2
κ
⇐====
ξ ◦key R ◦K1.

---

The FOLE Database
17
DB
DOMop
SET
˚
key
˚
dom
op
˚
tup
˚
τ
==⇒
❅❅
❘
  ✠
❘
SET
1
DB
CLSop
LISTop
Set⇑op
DOMop
˚
key
˚
dom
op
˚
data
op
˚
sch
op
˚
sortop
˚
sort op
✛
✛
✲
✲
❄
❄
❄
❍❍
❥
✟
✟
✙
✟✟
✯
schemed domain
˚
dom = (-)op ◦dom : DBop →DOM
data
˚
data = (-)op ◦data : DBop →CLS
schema
˚
sch = (-)op ◦sign : DBop →LIST
key
˚
key = (-) ◦key
: DB →SET = Set⇓
Fig. 8. Database Mathematical Context: DB
Proposition 8. Using projections DB can be described as follows.
• A database R = ⟨R, Q, K, τ⟩consists of a shape context R, a schemed do-
main
˚
dom(R, T) = ⟨R, Q⟩with the signed domain diagram R
Q
−−−−−−→
T op◦dom
Dom, a key set diagram ˚
key(R, T) = ⟨R, K⟩with the key passage Rop
K
−−−−−→
T ◦key
Set, and a tuple bridge K
τ
=====⇒
T ◦τTbl
Qop◦tup.
• A database morphism (Fig. 9)
R2 = ⟨R2, Q2, K2, τ2⟩
⟨R,ς,κ⟩
←−−−−⟨R1, Q1, K1, τ1⟩= R1
consists of a shape passage R2
R
−→R1, a schemed domain morphism
˚
dom(R, ξ) =
⟨R, ς⟩: ⟨R2, Q2⟩
⟨R,ς⟩
−−−−−−→
˚
dom(R,ξ)
⟨R1, Q1⟩, and a key diagram morphism
˚
key(R, ξ) =
⟨R, κ⟩: ⟨R2, K2⟩←⟨R1, K1⟩with the key bridge κ = ξ ◦key : K2 ⇐
Rop◦K1, which satisfy the condition
(ξ ◦key
| {z }
κ
) • τ2 = (Rop◦τ1) • (ξ ◦domop
|
{z
}
ςop
◦tup).
(2)
.

---

18
Robert E. Kent
Rop
id
id
✲
✲
✛
✲
✛
ςop
⇐=
κ
⇐=
Rop
2
Tbl
Domop
Set
T2
K2
Qop
2
key
domop
tup
τTbl
=⇒
❄
❅❅
❘
  ✠
❘❘
❄
Rop
1
Tbl
Domop
Set
T1
K1
Qop
1
key
domop
tup
τTbl
⇐=
❄
  ✠
❅❅
❘
✠
✠
❄
Rop ◦K1
Rop ◦˚
tup(R1, Q1)
z
}|
{
Rop ◦Qop
1
◦tup
=
Rop ◦T1 ◦domop ◦tup
K2
Qop
2
◦tup
|
{z
}
˚
tup(R2, Q2)
=
T2 ◦domop ◦tup
˚
tup(R, ς)
z
}|
{
ςop ◦tup
ξ ◦domop ◦tup
Rop◦τ1
τ2
κ
=⇒
=⇒
www
www
www
Fig. 9. FOLE Database Morphism (proj): DB
4.2
Type Domain Indexing
A type domain, which constrains the body of a relational table, is an indexed
collection of data types from which a table’s tuples are chosen. Here we deﬁne
databases with ﬁxed type domain (datatypes). These are more generalized than
databases with ﬁxed signed domain (header plus datatypes). 10
4.2.1
Lower Aspect: Db(A) Let A be a ﬁxed type domain.
Deﬁnition 5. The context of A-databases is the oplax comma context Db(A) =
Tbl(A)⇓, a diagram context over A-tables. (Def. 7 in § A.2.1)
A relational A-database ⟨R, T⟩is a diagram of A-tables, consisting of a shape
context R and a passage Rop
T
−−→Tbl(A). A relational A-database morphism
⟨R2, T2⟩
⟨R, ψ⟩
←−−−−⟨R1, T1⟩(Fig. 10) consists of a shape-changing passage R1
R
−−→
R1 and a bridge T2
ψ
⇐== Rop◦T1.
Rop
2
Rop
1
Tbl(A)
Rop
T2
T1
ψ
⇐=
✲
❙
❙
❙✇
✓
✓
✓✴
Fig. 10. Database Morphism: Db(A)
Proposition 9. The ﬁbered context (Grothendieck construction) of A-databases
Db(A) = Tbl(A)⇓is complete and cocomplete and the projection Db(A) =
Tbl(A)⇓→Cxt : ⟨R, T⟩7→R is continuous and cocontinuous.
Proof. By Prop. 19 of §A.1.3, since Tbl(A) is complete/cocomplete [12].
10 These are not deﬁned here. We could also deﬁne databases with ﬁxed schema
(header).

---

The FOLE Database
19
Projections. Projections oﬀer an alternate representation, deﬁning the three pri-
mary components of A-databases and A-database morphisms: diagram shapes,
schemed domains and key diagrams. Diagram shapes are direct projections,
whereas schemed domains and key diagrams are indirect, coming from compo-
sition with A-table projection passages. The database projections are described
in Fig. 11 and are deﬁned as follows.
Db(A)
˚
Dom(A)
op
SET
˚
key A
˚
domA
op
˚
tupA
˚
τA
==⇒
❅❅
❘
  ✠
❘
SET
1
Db(A)
˚
List(X)
op
˚
Dom(A)
op
∼=
˚
keyA
˚
dom
op
A
˚
sign
op
A
✛
✛
❄
❄
❍❍
❥
Fig. 11. Database Mathematical Context: Db(A)
• The schemed domain projection
˚
domA : Db(A) →
˚
Dom(A) maps
◦a relational A-database ⟨R, T⟩in Db(A) to the A-schemed domain
˚
domA(R, T) = ⟨R, S⟩in
˚
Dom(A) with signed domain diagram (schema)
R
S
−−−−−−−→
T op◦domA Dom(A) ∼= List(X), and
◦maps a relational A-database morphism ⟨R2, T2⟩
⟨R,ψ⟩
←−−−−⟨R1, T1⟩to the
schemed domain morphism ⟨R2, S2⟩
˚
domA(R,ψ)
−−−−−−−→
⟨R,ϕ⟩
⟨R1, S1⟩in
˚
Dom(A)
with bridge ϕ = ψop◦domA : S2 ⇒R◦S1.
• The key projection
˚
key A : Db(A) →SET
◦maps a relational database ⟨R, T⟩in Db(A) to the key set diagram
˚
key A(R, T) = ⟨R, K⟩in SET with key passage Rop
K
−−−−−−→
T ◦keyA
Set, and
◦maps a relational A-database morphism ⟨R2, T2⟩
⟨R,ψ⟩
←−−−−⟨R1, T1⟩to the
SET-morphism ⟨R2, K2⟩
˚
keyA(R,ψ)
←−−−−−−−
⟨R,κ⟩
⟨R1, K1⟩with a bridge κ = ψ ◦keyA :
K2 ⇐Rop◦K1.

---

20
Robert E. Kent
Proposition 10. Using projections Db(A) can be described as follows.
• An A-database is an object R = ⟨R, S, K, τ⟩in Db(A) consisting of (i) an
object
˚
key A(R) = ⟨R, K⟩in SET = Set
⇓with shape context R and key di-
agram Rop
K
−−−−−−→
T ◦key A
Set, (ii) an object
˚
domA(R) = ⟨R, S⟩in
˚
Dom(A) =
Dom(A)⇑with shape context R and schema R
S
−−−−−−−→
T op◦domA
Dom(A) ∼=
List(X), and (iii) a tuple bridge K
τ
====⇒
T ◦τA
S op◦tupA. Hence, a database
in Db(A) is a SET-morphism
˚
key A(R) = ⟨R, K⟩
˚
τR
−−−→
⟨1,τ⟩⟨R, S op◦tupA⟩= ˚
tupA(R, S) = ˚
tupA( ˚
domA(R)).
• An A-database morphism is a morphism
R2 = ⟨R2, S2, K2, τ2⟩
⟨R,ϕ,κ⟩
←−−−−−⟨R1, S1, K1, τ1⟩= R1
in Db(A) consisting of (i) a morphism
˚
key A(R2) = ⟨R2, K2⟩
˚
keyA(R, ˆ
ϕ,κ)
←−−−−−−−−
⟨R,κ⟩
⟨R1, K1⟩=
˚
keyA(R1) in SET with the bridge K2
κ
⇐== ˆRop◦K1, and (ii)
an A-schema morphism
˚
domA(R2) = ⟨R2, S2⟩
˚
domA(R, ˆϕ,κ)
−−−−−−−−−→
⟨R,ϕ⟩
⟨R1, S1⟩=
˚
domA(R1) in
˚
Dom(A) = Dom(A)⇑with the bridge S2
ϕ
==⇒R ◦S1, which
satisfy the condition ⟨ˆR, κ⟩◦⟨R2, τ2⟩= ⟨R1, τ1⟩◦⟨R, ϕop◦tupA⟩in SET. Hence,
R2 ◦ˆR = R ◦R1 and κ • τ2 = (Rop◦τ1) • (ϕop◦tupA). 11
K2
Rop◦K1
S op
2 ◦tupA
Rop◦S op
1 ◦tupA
τ2
Rop◦τ1
κ
ϕop◦tupA
⇐======
⇐===
www
www
⟨R2, K2⟩
⟨R1, K1⟩
⟨R2, S op
2 ◦tupA⟩
|
{z
}
˚
tup(R2,S2)
⟨R1, S op
1 ◦tupA⟩
|
{z
}
˚
tup(R1,S1)
⟨1, τ2⟩
⟨1, τ1⟩
⟨R, κ⟩
⟨R, ϕop◦tupA⟩
|
{z
}
˚
tupA(R,ϕ)
✛
✛
❄
❄
SET = Set⇓
Fig. 12. Database Morphism (proj): Db(A)
11 When the shape context is 1, an A-database is an A-table ⟨I, X, K, t⟩∈Tbl(A)
consisting of an X-sorted signature ⟨I, X⟩∈List(X), a key set K ∈Set, and a
tuple function K
t−→tupS(I, X). When the shape passage is 1
1−→1, an A-database
morphism is an A-table morphism ⟨I2, X2, K2, t2⟩
⟨h,k⟩
←−−−⟨I1, X1, K1, t1⟩in Tbl(A)
consisting of a X-sorted signature morphism ⟨I2, s2⟩
h−→⟨I1, s1⟩in List(X), and a
key function K2
k
←−K1, which satisfy the condition k · t2 = τ1 · tupA(h) in Set.

---

The FOLE Database
21
4.2.2
Upper Aspect: Db The subcontext of FOLE databases (with constant
type domains and constant type domain morphisms) is denoted by Db ⊆DB.
• A relational database ⟨R, T, A⟩in Db consists of a type domain A and a
relational database ⟨R, T⟩in Db(A) with a shape context R and a passage
Rop T
−−→Tbl(A).
• A relational database morphism ⟨R2, T2, A2⟩
⟨R, ˆψ,f,g⟩
←−−−−−−−⟨R1, T1, A1⟩in Db
(Fig. 13) with constant type domain morphism ⟨f, g⟩: A2 ⇄A1, is a FOLE
database morphism ⟨R, ξ⟩: ⟨R2, T2⟩←⟨R1, T1⟩, whose tabular interpreta-
tion bridge T2
ξ
⇐== R ◦T1 factors adjointly
(Rop ◦T1) ◦´χ⟨f,g⟩• ( ´ψ ◦incA2) = ξ = ( `ψ ◦incA1) • (T2 ◦`χ⟨f,g⟩)
(3)
through the ﬁber adjunction Tbl(A2)
´
tbl ⟨f,g⟩⊣`
tbl⟨f,g⟩
←−−−−−−−−−−−Tbl(A1)
using the
table inclusion bridge adjointness ˆχ⟨f,g⟩= (´χ⟨f,g⟩, `χ⟨f,g⟩) 12
levo
dextro
´χ⟨f,g⟩: ´
tbl ⟨f,g⟩◦incA2 ⇐incA1
`χ⟨f,g⟩: incA2 ⇐`
tbl ⟨f,g⟩◦incA1
´χ⟨f,g⟩= (η⟨f,g⟩◦incA1) • ( ´
tbl ⟨f,g⟩◦`χ⟨f,g⟩)
`χ⟨f,g⟩= ( `
tbl⟨f,g⟩◦´χ⟨f,g⟩) • (ε⟨f,g⟩◦incA2)
deﬁned in (Kent [12]). This consists of equivalent morphisms
⟨R2, T2⟩
⟨R, ´ψ⟩
←−−−−
⟨R1,T1◦´
tbl ⟨f,g⟩⟩
z
}|
{
´
db⟨f,g⟩(R1, T1)
|
{z
}
∈Db(A2)
∼
=
↔
⟨R2,T2◦`
tbl ⟨f,g⟩⟩
z
}|
{
`
db⟨f,g⟩(R2, T2)
⟨R, `
ψ⟩
←−−−−⟨R1, T1⟩
|
{z
}
∈Db(A1)
We normally just use the bridge restriction ´ψ or `ψ for the database mor-
phism. We use ˆψ to denote either of these equivalent bridges. The original
deﬁnition can be computed with the factorization in Disp. 3.
Proposition 11. Hence, the ﬁbered context Db (with constant type domain) is
the Grothendieck construction of the indexed adjunction
Db =
R
data : Clsop
ˆ
db
−−→Adj.
Proof. By composing on the bottom (type domain), deﬁne the following database
ﬁber adjunction for any type domain morphisms A2
⟨f,g⟩
−−−⇀
↽−−−A1
Db(A2)
Db(A1).
´
db⟨f,g⟩
`
db⟨f,g⟩
η⟨f,g⟩
⊣
ε⟨f,g⟩
✛
✲
12 The table bridge pair projects to the signed domain bridge pair
´χ⟨f,g⟩◦domop = domop
A1 ◦`ιop
⟨f,g⟩
`χ⟨f,g⟩◦domop = domop
A2 ◦´ιop
⟨f,g⟩
levo
dextro

---

22
Robert E. Kent
Rop
2
Rop
1
Tbl(A2)
Tbl(A1)
Tbl
Rop
T2
T1
´
tbl ⟨f,g⟩
incA2
incA1
´
ψ
⇐=
levo
´χ⟨f,g⟩
⇐====
✲
✛
❄
❄
❙
❙❙✇
✓
✓
✓✴
Rop
2
Rop
1
Tbl
Rop
T2
T1
ξ
⇐==
✲
❫✢
=
=
Rop
2
Rop
1
Tbl(A2)
Tbl(A1)
Tbl
Rop
T2
T1
`
tbl ⟨f,g⟩
incA2
incA1
`ψ
⇐=
dextro
`χ⟨f,g⟩
⇐====
✲
✲
❄
❄
❙
❙❙✇
✓
✓
✓✴
Fig. 13. Database Morphism: Db
Proposition 12. The ﬁbered context (Grothendieck construction) Db =
R
data :
Clsop
ˆ
db
−−→Adj is complete and cocomplete and the projection Db →Cls is
continuous and cocontinuous.
Proof. By Fact 5 of § A.1.1, since the indexing context Cls is complete and co-
complete ([1]), and the ﬁber context Db(A) is complete and cocomplete for each
type domain A by Prop. 9 above.
Proposition 13. Db is a subcontext of the context of databases Db ⊊DB.
Proof. There is a (vertical) composition passage Db
˚
inc֒
−−→DB, which maps a
database ⟨R, T, A⟩to the composite passage ˚
inc(R, T, A) = ⟨R, T ◦incA⟩and
maps a database morphism ⟨R2, T2, A2⟩
⟨R, ˆ
ψ,f,g⟩
←−−−−−−⟨R1, T1, A1⟩to the composite
bridge ˚
inc(R2, T2, A2)
˚
inc(R, ˆ
ψ,f,g)
⇐============
⟨R, ξ = ˆψ ◦ˆχ⟨f,g⟩⟩
˚
inc(R1, T1, A1).
Projections. Composition with table projection passages deﬁne database pro-
jection passages. These projections oﬀer an alternate representation, deﬁning
the three primary components of databases and their morphisms in Db: dia-
gram shapes, schemed domains and key diagrams. The database projections are
described in Fig. 14 and are deﬁned as follows.
• The schemed domain projection
˚
dom = (-)op ◦dom : Dbop →
˚
Dom maps
a relational database R = ⟨R, T, A⟩to the schemed domain
˚
dom(R) =
⟨R, S, A⟩with schema R
S
−−−−−−−→
T op◦domA Dom(A) ∼= List(X), and maps a rela-
tional database morphism ⟨R, ˆψ, f, g⟩: R2 ←R1 to the schema morphism
˚
dom(R, ˆψ, f, g) = ⟨R, ˆϕ, f, g⟩:
˚
dom(R2) →
˚
dom(R1) with equivalent bridge
pair ˆϕ = ⟨´ϕ, `ϕ⟩= ⟨´ψop◦signA2, `ψop◦signA1⟩.
• The key projection ˚
key = (-)◦key : Db →SET maps a relational database
R = ⟨R, T, A⟩to the key set diagram
˚
key(R) = ⟨R, K⟩in SET with

---

The FOLE Database
23
the key passage Rop
K
−−−−−→
T◦key A
Set, and maps a relational database mor-
phism ⟨R, ˆψ, f, g⟩: R2 ←R1 to the SET-morphism ˚
key(R, ˆψ, f, g) = ⟨R, κ⟩:
⟨R2, K2⟩←⟨R1, K1⟩with key bridge K2
κ
⇐== Rop◦K1.
Db
˚
Dom
op
SET
˚
key
˚
dom
op
˚
tup
˚
τ
==⇒
❅❅
❘
  ✠
❘
SET
1
Db
Clsop
˚
List
op
Setop
˚
Dom
op
˚
key
˚
dom
op
˚
data
op
˚
sch
op
sortop
sort op
✛
✛
✲
✲
❄
❄
❄
❍❍
❥
✟
✟
✙
✟✟
✯
schemed domain
˚
dom = (-)op ◦dom : Dbop →
˚
Dom
schema
˚
sch = (-)op ◦sign : Dbop →
˚
List
key
˚
key = (-) ◦key
: Db →SET
Fig. 14. Database Mathematical Context: Db

---

24
Robert E. Kent
Proposition 14. Using projections, Db can be described as follows.
• A database (with constant type domain) R = ⟨R, S, A, K, τ⟩consists of an
object ˚
key(R) = ⟨R, K⟩in SET 13, an object
˚
dom(R) = ⟨R, S, A⟩in
˚
Dom
14 and a tuple bridge K
τ
====⇒
T◦τA
S op◦tupA =
˚
tupA(S). Hence, a database
in Db is a SET-morphism
˚
key(R) = ⟨R, K⟩
⟨1,τ⟩
−−−→⟨R, ˚
tupA(S)⟩= ˚
tup(R, S, A) = ˚
tup( ˚
dom(R)).
• A database morphism (with constant type domain morphism)
R2 = ⟨R2, S2, A2, K2, τ2⟩
⟨R, ˆ
ϕ,f,g,κ⟩
←−−−−−−−⟨R1, S1, A1, K1, τ1⟩= R1
consists of a morphism
˚
key(R2) = ⟨R2, K2⟩
⟨R,κ⟩
←−−−⟨R1, K1⟩=
˚
key(R1) in
SET with bridge K2
κ
⇐== Rop◦K1, and a morphism
˚
dom(R2) = ⟨R2, S2, A2⟩
⟨R, ˆ
ϕ,f,g⟩
−−−−−−−→
⟨R1, S1, A1⟩=
˚
dom(R1) in
˚
Dom with equivalent bridge pair ˆϕ = ⟨´ϕ, `ϕ⟩=
⟨´ψop◦signA2, `ψop◦signA1⟩, which satisfy the condition
⟨R, κ⟩◦⟨1, τ2⟩= ⟨1, τ1⟩◦˚
tup(R, ˆϕ, f, g)
(4)
The condition (Expo. 4) resolves into the adjoint conditions
κ • τ2 = (Rop◦τ1) • (Rop◦S op
1 ◦´τ⟨f,g⟩) • ( ´ϕop◦tupA2 )
= (Rop◦τ1) • ( ˆϕop ◦ˆτ⟨f,g⟩)
|
{z
}
˚
tup⟨f,g⟩( ˆ
ϕ)
κ • τ2 = (Rop◦τ1) • ( `ϕop◦tupA1 ) • (S op
2 ◦`τ⟨f,g⟩)
= (Rop◦τ1) • ( ˆϕop◦ˆτ⟨f,g⟩)
|
{z
}
˚
tup⟨f,g⟩( ˆ
ϕ)
levo
dextro
Proposition 15. The schemed domain projection
˚
dom : DBop →DOM is
continuous and cocontinuous.
13 A shape context R and a key diagram Rop
K
−−−−−→
T◦keyA
Set.
14 A shape context R and a schema R
S
−−−−−−−→
T op◦domA Dom(A) ∼= List(X).

---

The FOLE Database
25
Rop
´
tbl ⟨f,g⟩
(f ∗)op
id
✲
✛
✲
✛
´ϕop
⇐=
κ
⇐=
´τ⟨f,g⟩
⇐=
Rop
2
Tbl(A2)
List(X2)op
Set
T2
K2
S op
2
key A2
signop
A2
tupA2
τA2
=⇒
❄
❅❅
❘
  ✠
❘❘
❄
Rop
1
Tbl(A1)
List(X1)op
Set
T1
K1
S op
1
keyA1
signop
A1
tupA1
τA1
⇐=
❄
  ✠
❅❅
❘
✠
✠
❄
K2
Rop◦K1
˚
tup(R2, S2, A2)
|
{z
}
S op
2
◦tupA2
Rop ◦˚
tup(R1, S1, A1)
z
}|
{
Rop ◦S op
1
◦tupA1
τ2
Rop◦τ1
κ
˚
tup⟨f,g⟩( ˆϕ)
z
}|
{
(Rop ◦S op
1
◦´τ⟨f,g⟩) • ( ´ϕop ◦tupA2 )
⇐=======
⇐====
www
www
Fig. 15. Database Morphism (proj): Db

---

26
Robert E. Kent
A
Appendix
A.1
General Theory
Fact 1 There is an adjunction A
⟨F ⊣G⟩
−−−−−→B with unit 1A
η==⇒F ◦G and counit
1B
ε
⇐== G ◦F when the following two triangle identities hold
F
(η◦F)
====⇒F ◦G ◦F
(F◦ǫ)
====⇒F = F
1F
==⇒F
G
(G◦η)
====⇒G ◦F ◦G
(ǫ◦G)
====⇒G = G
1G
==⇒G
Deﬁnition 6. A left adjoint A
F−→B to an inclusion passage A
G
←−֓ B (of a full
context B) is called a reﬂection. A full subcontext B of a context A is said to be
reﬂective in A when the inclusion passage A
G
←−֓ B has a left adjoint. A passage
A
F−→B is full when to every pair a and a′ of objects of A and to every morphism
F(a)
g−→F(a′) of B there is a morphism a
f−→a′ of A such that F(f) = g.
Fact 2 For a reﬂection 1B
ε
⇐==
= G ◦F the triangle identities become
F
(η◦F)
====⇒F = F
1F
==⇒F and G
(G◦η)
====⇒G = G
1G
==⇒G

---

The FOLE Database
27
A.1.1
Grothendieck Construction
ﬁbration: A ﬁbration (ﬁbered context)
R `C is the Grothendieck construction
of a contravariant pseudo-passage (indexed context) Iop
`C
−→Cxt, where the
action on any indexing object i in I is the ﬁber context `Ci and the action on
any indexing morphism i
a−→i′ is the ﬁber passage Ci
`Ca
←−−Ci′. An object in
R `C is a pair ⟨i, A⟩, where i is an indexing object in I and A is an object in
the ﬁber context `Ci. A morphism in
R `C is a pair ⟨i, A⟩
⟨a, ´f⟩
−−−→⟨i′, A′⟩, where
i
a−→i′ is an indexing morphism in I and A
´f−→`Ca(A′) is a ﬁber morphism
in `Ci. There is a projection passage
R `C →I.
opﬁbration: An opﬁbration
R ´C is the Grothendieck construction of a covari-
ant pseudo-passage (indexed context) I
´C
−→Cxt, where the action on any
indexing object i in I is the ﬁber context ´Ci and the action on any indexing
morphism i
a−→i′ is the ﬁber passage Ci
´Ca
−−→Ci′. An object in R ´C is a
pair ⟨i, A⟩, where i is an indexing object in I and A is an object in the ﬁber
context ´Ci. A morphism in
R ´C is a pair ⟨i, A⟩
⟨a, `f⟩
−−−→⟨i′, A′⟩, where i
a−→i′
is an indexing morphism in I and ´Ca(A)
`
f−→A′ is a ﬁber morphism in ´Ci′.
There is a projection passage
R ´C →I.
biﬁbration: A biﬁbration
R
C is the Grothendieck construction of an indexed
adjunction I
C
−→Adj consisting of a left adjoint covariant pseudo-passage
I
´C
−→Cxt and a right adjoint contravariant pseudo-passage Iop
`C
−→Cxt.
The action on any indexing object i in I is the ﬁber context Ci = `Ci = ´Ci
and the action on any indexing morphism i
a−→i′ is the ﬁber adjunction
 Ci
Ca
−−→Ci′
=
 Ci
⟨´Ca ⊣`Ca⟩
−−−−−−→Ci′
. The Grothendieck constructions of
component ﬁbration and component opﬁbration are isomorphic
R `C ∼=
R ´C
 ⟨i, A⟩
⟨a, ´
f⟩
−−−→⟨i′, A′⟩

∼
=
⇄
 ⟨i, A⟩
⟨a, `
f⟩
−−−→⟨i′, A′⟩

via the adjoint pair A
´
f−→`Ca(A′) ∼= ´Ca(A)
`
f−→A′. Deﬁne the Grothendieck
construction of the biﬁbration to be the Grothendieck construction of com-
ponent ﬁbration
R
C .=
R `C with projection
R
C →I.

---

28
Robert E. Kent
Given an I-morphism i2
a
←−i1, the ﬁber passage Ci2
`Ca
−−→Ci1 and injection
bridge `Ca ◦inci1
`ιa
==⇒inci2 (Fig. 16 dextro) have adjoints, the ﬁber passage
Ci2
´Ca
←−−Ci1 and injection bridge inci1
´ιa
==⇒´Ca ◦inci2 (Fig. 16 levo). 15
levo
dextro
Ci1
Ci2
R
C
´Ca
inci1
inci2
´ιa
=⇒
✲
❙
❙❙✇
✓
✓
✓✴
Ci1
Ci2
R
C
`Ca
inci1
inci2
`ιa
=⇒
✛
❙
❙❙✇
✓
✓
✓✴
i2
a
←−−i1
levo
dextro
´ιa : inci1 ⇒´Ca ◦inci2
`ιa : `Ca ◦inci1 ⇒inci2
´ιa = (ηa ◦inci1 ) • ( ´Ca ◦`ιa)
`ιa = ( `Ca ◦ιa) • (εa ◦inci2 )
Fig. 16. Inclusion Bridge: Fibered Context
Any morphism ⟨i1, A1⟩
⟨a,f⟩
−−−→⟨12, A2⟩in the ﬁbered context E =
R
C consists
of a morphism i1
a−→i2 in the indexing context I and the adjoint ﬁber morphisms,
´Ca(A1)
´f−→A2 in Ci2 or A1
`f−→`Ca(A2) in Ci1, with the factorization
⟨i1,A1⟩
inci1(A1)
⟨i2, ´Ca(A1)⟩
inci2( ´Ca(A1))
inci1( `Ca(A2))
⟨i1, `Ca(A2)⟩
inci2(A2)
⟨i2,A2⟩
´ιa(A1)
`ιa(A2)
inci1 ( `
f)
⟨1i1 , `
f⟩
inci2 ( ´f)
⟨1i2 , ´
f⟩
⟨a, f⟩
✲
✲
❄
❄
◗◗◗◗◗◗
s
15 The ﬁber adjunction Ci2
⟨´Ca ⊣`Ca⟩
←−−−−−−Ci1 has unit 1Ci1
ηa
==⇒´Ca ◦`Ca with the Ci-
morphism A
ηa(A)
−−−−→`Ca( ´Ca(A)) as its Ath component, and has counit `Ca ◦´Ca
εa
==⇒
1Ci2 with the Ci2-morphism ´Ca( `Ca(A′))
εa(A′)
−−−−→A′ as its A′th component.
A1
`
f
−→`Ca(A2) = A1
ηa(A1)
−−−−−→`Ca( ´Ca(A1))
`
Ca( ´
f)
−−−−→`Ca(A2)
´Ca(A1)
´
f
−→A2 =
´Ca(A1)
´
Ca( `
f)
−−−−→´Ca( `Ca(A2))
εa(A2)
−−−−−→A2

---

The FOLE Database
29
Fact 3 If Iop C
−→Cxt is a contravariant pseudo-passage (indexed context) s.t.
1. the indexing context I is complete,
2. the ﬁber context Ci is complete for each i ∈I, and
3. the ﬁber passage Ci
Ca
←−−Cj is continuous for each i
a−→j in I,
then the ﬁbered context (Grothendieck construction)
R
C is complete and the
projection
R
C
P
−→I is continuous.
Proof. Tarlecki, Burstall and Goguen [16].
Fact 4 If I
C
−→Cxt is a covariant pseudo-passage (indexed context) s.t.
1. the indexing context I is cocomplete,
2. the ﬁber context Ci is cocomplete for each i ∈I, and
3. the ﬁber passage Ci
Ca
−−→Cj is cocontinuous for each i
a−→j in I,
then the ﬁbered context (Grothendieck construction)
R
C is cocomplete and the
projection
R
C
P
−→I is cocontinuous.
Proof. Dual to the above.
Fact 5 If I
C
−→Adj is an indexed adjunction consisting of a contravariant
pseudo-passage Iop
`C
−→Cxt and a covariant pseudo-passage I
´C
−→Cxt that are
locally adjunctive
 Ci
⟨´Ca ⊣`Ca⟩
−−−−−−→Ci′
for each i
a−→j in I, s.t.
1. the indexing context I is complete and cocomplete,
2. the ﬁber context Ci is complete and cocomplete for each i ∈I,
then the ﬁbered context (Grothendieck construction)
R
C →I is complete and
cocomplete and the projection
R
C →I is continuous and cocontinuous.
Proof. Use Facts. 3 & 4, since the ﬁber passage Ci
`Ca
←−−Ci′ is continuous (be-
ing right adjoint) and the ﬁber passage Ci
´Ca
−−→Ci′ is cocontinuous (being left
adjoint) for each i
a−→j in I.

---

30
Robert E. Kent
A.1.2
Diagram Contexts For any base mathematical context A, there are
two contexts of lax diagrams with indexing (shape) contexts.
Deﬁnition 7.
DOM : The lax comma context over A is deﬁned to be the co-variant lax diagram
context A⇑=
 (-) ⇑A

=
 Cxt ⇑A

. An object of A⇑is a pair ⟨B, F⟩con-
sisting of a context B and a passage (diagram) B
F
−−→A. A morphism of
A⇑is a pair ⟨B2, F2⟩
⟨G,α⟩
−−−−→⟨B1, F1⟩consisting of shape varying passage
B2
G
−−→B1 and a bridge F2
α
==⇒G ◦F1. The ﬁber at shape context B is
the context of diagrams AB =

B, A

.
B2
B1
A
G
F2
F1
α
=⇒
✲
❙
❙❙✇
✓
✓
✓✴
DB : The oplax comma context over A is deﬁned to be the contra-variant lax di-
agram context A⇓=
 (-)op ⇓A
 ∼=
 Cxt ⇓A

. An object of A⇓is a pair
⟨B, F⟩consisting of a context B and a passage (diagram) Bop
F
−−→A. A
morphism of A⇓is a pair ⟨B2, F2⟩
⟨G,α⟩
←−−−−⟨B1, F1⟩consisting of a shape
passage B2
G
−−→B1 and a bridge F2
α
⇐== Gop ◦F1. 16 The ﬁber at shape
context B is the context of diagrams ABop =

Bop, A

.
Bop
2
Bop
1
A
Gop
F2
F1
α
⇐=
✲
❙
❙❙✇
✓
✓
✓✴
Composition is component-wise. 17
16 Notice the direction of the morphisms. This is opposite the deﬁnition of the “super-
comma” context in Mac Lane [15].
17 The operator (-)∝applies the opposite to all elements of a lax diagram (contexts,
passages and bridges). Hence,
 A⇓∝=
 (-)op ⇓A
∝≜
 (-) ⇑Aop
=
 Aop⇑and
 A⇑∝=
 (-) ⇑A
∝≜(-)op ⇓(Aop) = (Aop)⇓.
Bop
2
Bop
1
A
H2
H1
Gop
❆
❆❆❯
✁
✁✁☛
✲
α
⇐==
 
!∝
≜
B2
B1
Aop.
H op
2
H op
1
G
❆
❆❆❯
✁
✁✁☛
✲
αop
===⇒

⟨B2, H2⟩
⟨G,α⟩
←−−−−⟨B1, H1⟩
∝
≜
⟨B2, H op
2 ⟩
⟨G,αop⟩
−−−−−−→⟨B1, H op
1 ⟩

---

The FOLE Database
31
Example. The context SET = Set
⇓=
 (-)op ⇓Set
 ∼=
 Cxt ⇓Set

is the oplax
comma context over Set. Hence, an object ⟨B, F⟩in SET is a diagram Bop
F
−−→
A, and a morphism ⟨B2, F2⟩
⟨G,α⟩
←−−−−⟨B1, F1⟩in SET is a diagram morphism
with shape passage B2
G
−−→B1 and bridge F2
α
⇐== Gop ◦F1.
Change of Base. Any passage A
H
−→B deﬁnes lax diagram morphisms.
A⇓=
 (-)op ⇓A

H⇓
−−−−→
(-) ◦H
 (-)op ⇓B

= B⇓
 A⇓∝∼=
 Aop⇑
 H⇓∝
=
 H op⇑
−−−−−−−−−−−→
(-)op ◦H op
 Bop⇑∼=
 B⇓∝
A⇑=
 (-) ⇑A

H⇑
−−−−→
(-) ◦H
 (-) ⇑B

= B⇑
(A⇑)∝∼= (Aop)⇓
(H⇑)∝∼
= (H op)⇓
−−−−−−−−−−−→
(-) ◦H op
(Bop)⇓∼= (B⇑)∝
The passage A⇓
H⇓
−−−−→
(-) ◦H B⇓is deﬁned as follows. A⇑
H⇑
−−−−→
(-) ◦H B⇑is deﬁned dually.
• H⇓maps an object Iop
F
−−→A ∈A⇓to the object Iop
F ◦H
−−−−→B ∈B⇓.
• H⇓maps a morphism ⟨C2, F2⟩
⟨G,α⟩
←−−−−⟨C1, F1⟩of A⇓, a pair consisting
of a shape passage C2
G
−−→C1 and a bridge F2
α
⇐== Gop ◦F1, to the
morphism ⟨C2, F2◦H ⟩
⟨G,α◦H ⟩
←−−−−−−⟨C1, F1◦H ⟩of B⇓, a pair consisting of a
shape passage C2
G
−−→C1 and a bridge F2◦H
α◦H
⇐==== Gop ◦F1◦H .
.

---

32
Robert E. Kent
Complete/Cocomplete Diagram Contexts. A cone over a diagram I
F
−−→A is
a bridge F
π
⇐= ∆(a), whose vertex is an element a ∈A. Hence, a cone is a
morphism ⟨I, F⟩
⟨∆,π⟩
−−−−→⟨1, a⟩in A⇓=
 (-)op ⇓A

consisting of a shape passage
I
∆
−−→1 and a bridge I
π
⇐== ∆op ◦a.
Iop
1op
A
∆op
F
a
π
⇐=
✲
❙
❙❙✇
✓
✓
✓✴
A limiting cone for diagram I
F
−−→A is a universal cone: for any other cone
F
π′
⇐== ∆(a′), there is a unique A-morphism a
f←−a′ such that ∆(f) · π = π′.
A context A is complete when any diagram I
F
−−→A in A has a limiting cone
F
π
⇐= ∆(a). The dual notions are colimiting cocones and cocompleteness. 18
Proposition 16. For any cocomplete context A there is a passage A⇑
colim
−−−→A.
Dually, For any complete context A there is a passage A⇓
lim
−−→A.
Proof. We give an argument for limits in a complete context. A dual argument
holds for colimits in a cocomplete context. The limit passage A⇓
lim
−−→A maps
a diagram ⟨I, F⟩to the limiting cone vertex a, and maps a diagram morphism
⟨B2, F2⟩
⟨G,α⟩
←−−−−⟨B1, F1⟩to the unique morphism a2
g←−a1 from the vertex of
the cone F2
(Gop◦π1)•α
⇐========= ∆(a1) to vertex of the limiting cone F2
π2
⇐== ∆(a2) of
diagram I2
F2
−−→A such that ∆(g) · π2 = (Gop ◦π1) • α.
18 In any complete context, the limits of arbitrary diagrams can be constructed by
using only the terminal object and (binary) pullbacks. Dually, in any cocomplete
context, the colimits of arbitrary diagrams can be constructed by using only the
initial object and (binary) pushouts.

---

The FOLE Database
33
Continuity/Cocontinuity.
Deﬁnition 8. A passage A
H
−−→B is continuous when it maps any limiting
cone to a limiting cone. Dually, it is cocontinuous when it maps any colimiting
cocone to a colimiting cocone.
Proposition 17. For any continuous passage A
H
−−→B between complete con-
texts A and B, the passage A⇓
H⇓
−−−→B⇓satisﬁes the condition lim ◦H ∼=
H⇓◦lim expressing continuity. Dually, for any cocontinuous passage A
H
−−→B
between cocomplete contexts A and B, the passage A⇑
H⇑
−−−→B⇑satisﬁes the
condition colim ◦H ∼= H⇑◦colim expressing cocontinuity.
A⇓∼=
 (-) ⇓A

B⇓=
 (-) ⇓B

A
B
lim
lim
H⇓∼
=
 (-) ⇓H

H
✲
✲
❄
❄
∼=
A⇑∼=
 (-) ⇑A

B⇑=
 (-) ⇑B

A
B
colim
colim
H⇑∼
=
 (-) ⇑H

H
✲
✲
❄
❄
∼=
Proof. We give an argument for limits in a complete context: the passage A⇓
H⇓
−−−−→
(-) ◦H
B⇓maps a limiting cone ⟨I, F⟩
⟨∆,π⟩
−−−−→⟨1, a⟩in A⇓with vertex (limit object)
a = lim(F) ∈A to the limiting cone ⟨I, F◦H ⟩
⟨∆,π◦H ⟩
−−−−−−→⟨1, H (a)⟩in B⇓with
vertex (limit object) H (a) = lim(F ◦H ) ∈B. A dual argument holds for col-
imits in a cocomplete context.

---

34
Robert E. Kent
A.1.3
Kan Extensions 19
Deﬁnition 9. Given a passage K : C2 →C1 and a context A, if AC = [C, A]
is the hom context, then the passage AK : AC2 ←AC1 is deﬁned by composition
(S1
α
==⇒S ′
1) 7→(K ◦S1
K ◦α
=====⇒K ◦S ′
1).
• Given a passage K : C2 →C1 and an element S2 ∈AC2, a left Kan
extension of S2 along K is a pair (L, η) consisting of an element L ∈AC1
and a bridge S2
η
==⇒K ◦L, such that for each element S1 ∈AC1 and bridge
S2
α
==⇒AK (S1) = K ◦S1, there is a unique bridge L
β
==⇒S1 with
 S2
α
==⇒AK (S1)

=
 S2
η
==⇒AK(L)
AK (β)
======⇒AK (S1)

C2
C1
A
K
S2
L
S1
η
==⇒
α
===⇒
β=⇒
✲
❙
❙
❙✇
✌✙
α = η • (K ◦β)
We use the notation L = lanK (S2).
• The (dual) right Kan extension ranK (S2) is deﬁned by reversing the bridges.
Given a passage K : C2 →C1 and an element S2 ∈AC2, a right Kan
extension of S2 along K is a pair (R, ε) consisting of an element R ∈AC1
and a bridge S2
ε
⇐== K ◦R, such that for each element S1 ∈AC1 and
bridge S2
α
⇐== AK (S1) = K ◦S1, there is a unique bridge R
β
⇐== S1 with
 S2
α
⇐== AK(S1)

=
 S2
ε
⇐== AK(R)
AK (β)
⇐====== AK (S1)

C2
C1
A
K
S2
R
S1
ε
⇐==
α
⇐===
β
⇐=
✲
❙
❙
❙✇
✌✙
α = (K ◦β) • ǫ
We use the notation R = ranK(S2).
19 Kan extensions are speciﬁc cases of the Grothendieck construction: they are used to
describe the general contexts of schemed domains DOM and databases DB. The
more specialized contexts
˚
Dom and Db use the more general notion of Grothendieck
construction.

---

The FOLE Database
35
Fact 6 (Mac Lane[15])
• For any cocomplete context A and any passage C2
K
−−→C1, the left Kan ex-
tension passage AC2
lanK
−−−−→AC1 is left adjoint to the composition passage
AC2
AK
←−−−AC1. Since the left Kan operation is preserved under composi-
tion lan(K2 ◦K1) ∼= lanK2 ◦lanK1, this forms a ﬁber (an indexed) adjunc-
tion Cxt
˜A
−→Adj with local adjoint pair AC2
⟨´A ⊣`A⟩
−−−−−−−−→
⟨lanK ⊣AK ⟩AC1.
• For any complete context A and any passage C2
K
−−→C1, the right Kan ex-
tension passage AC2
ranK
−−−−→AC1 is right adjoint to the composition passage
AC2
AK
←−−−AC1. Since the right Kan operation is preserved under composi-
tion ran(K2 ◦K1) ∼= ranK2 ◦ranK1, this forms a ﬁber (an indexed) adjunc-
tion Cxtop ˆA
−→Adj with local adjoint pair AC2
⟨´A ⊣`A⟩
←−−−−−−−−
⟨AK ⊣ranK ⟩AC1.

---

36
Robert E. Kent
Proposition 18.
• By Fact 6, the diagram (lax comma) context over a cocomplete context A is
the biﬁbration (Grothendieck construction) A⇑=
R ˆA of the indexed adjunc-
tion Cxt
ˆA
−→Adj. A morphism ⟨C2, S2⟩
⟨K, ˆα⟩
−−−−→⟨C1, S1⟩in A⇑consists of
a passage C2
K
−−→C1 and a pair ˆα = ⟨´α, `α⟩of equivalent bridges.
S2
´α
====⇒
levo
AK (S1) = `A(S1)
in AC2
⇄
´A(S2) = lanK(S2)
`α
=====⇒
dextro
S1
in AC1
(5)
C2
C1
A
K
S2
S1
´α
=⇒
✲
❙
❙
❙✇
✓
✓
✓✴
C2
C1
A
lanK (S2)
S2
S1
`α
=⇒
✇
❙
❙
❙✇
✓
✓
✓✴
´α : S2 ⇒AK (S1)
`α : lanK (S2) ⇒S1
´α = ηS2 • AK (`α)
`α = lanK (´α) • εS1
• By Fact 6, the diagram (oplax comma) context over a complete context A is
the biﬁbration (Grothendieck construction) A⇓=
R ˆA of the indexed adjunc-
tion Cxtop ˆA
−→Adj. A morphism ⟨C2, S2⟩
⟨K, ˆα⟩
←−−−−⟨C1, S1⟩in A⇓consists of
a passage C2
K
−−→C1 and a pair ˆα = ⟨´α, `α⟩of equivalent bridges.
S2
´α
⇐====
levo AK(S1) = ´A(S1)
in AC2
⇄
`A(S2) = ranK (S2)
`α
⇐=====
dextro S1
in AC1
(6)
Cop
2
Cop
1
A
K op
S2
S1
´α
⇐=
✲
❙
❙
❙✇
✓
✓
✓✴
Cop
2
Cop
1
A
ranK (S2)
S2
S1
`α
⇐=
✇
❙
❙
❙✇
✓
✓
✓✴
´α : S2 ⇐AK (S1)
`α : ranK (S2) ⇐S1
´α = AK (`α) • εS2
`α = ηS1 • ranK (´α)

---

The FOLE Database
37
Proposition 19.
• For any complete and cocomplete context A, the ﬁbered context (Grothendieck
construction) A⇑=
R ˆA is complete and cocomplete and the projection
A⇑→Cxt : ⟨C, S⟩7→C is continuous and cocontinuous.
• For any complete and cocomplete context A, the ﬁbered context (Grothendieck
construction) A⇓=
R ˆA is complete and cocomplete and the projection A⇓→
Cxt : ⟨C, S⟩7→C is continuous and cocontinuous.
Proof. Use Prop. 18 and Fact. 5 of § A.1.1, since the indexing context Cxt is
complete and cocomplete, and the ﬁber context AC is complete and cocomplete
for each C ∈Cxt.

---

38
Robert E. Kent
A.2
Database Applications
A.2.1
Contexts Figure 17 shows six important contexts in this paper: two
comma contexts Dom and Tbl; two diagram contexts DOM and DB; 20 and two
ﬁbered contexts deﬁned by the Grothendieck construction:
˚
Dom and Db. Since
Dom and Tbl are (co)complete mathematical contexts, by Prop. 16 (also see the
paper ”The FOLE Table” [12]) we have the passages indicated in Tbl. 7. Tbl. 4
and Tbl. 5 display the deﬁnitions for schemed domain and relational database
morphisms.
Dom
Cls
Set
Set
arity
1Set
data
sort
σ
==⇒
  ✠
❅❅
❘
❅❅
❘
  ✠
Dom =
 1Set ↓sort

Signed Domains
Tbl
Domop
Set
Set
key
1Set
domop
tup
τ
==⇒
  ✠
❅❅
❘
❅❅
❘
  ✠
Tbl =
 1Set ↓tup

Tables
DOM = Dom⇑
CLS
LIST
Set⇑
˚
sign
˚
sort
˚
data
˚
sort
  ✠
❅❅
❘
❅❅
❘
  ✠
DOM= Dom⇑=
 Cxt ⇑Dom

= LIST×Set⇑CLS
DB
DOMop
SET
SET
˚
key
1SET
˚
dom
op
˚
tup
τ
==⇒
  ✠
❅❅
❘
❅❅
❘
  ✠
DB = Tbl⇓=
 (-)op ⇓Tbl

˚
Dom =
R
data : Cls
ˆ
dom
−−−→Adj
Db =
R
data : Clsop
ˆ
db
−−→Adj
Schemed Domains
Databases
Fig. 17. Diagram/Comma/Fibered Contexts
.
20 For any context C, the “super-comma” context
 Cxt ⇓C

= C⇓is deﬁned [15] as
follows: an object is a C-diagram ⟨I, D⟩with indexing context I and passage I
D
−→C;
a morphism is a C-diagram morphism ⟨I2, D2⟩
⟨F,α⟩
−−−→⟨I1, D1⟩with indexing passage
I2
F−→I1 and bridge D2
α
⇐== F ◦D1. To dualize, the context
 Cxt ⇑C

= C⇑is
deﬁned as follows: an object is as above; a morphism is a C-diagram morphism
⟨I2, D2⟩
⟨F,α⟩
−−−→⟨I1, D1⟩with indexing passage I2
F−→I1 and bridge D2
α
==⇒F ◦D1.

---

The FOLE Database
39
⟨R2, Q2⟩
⟨R, ς⟩
−−−−→⟨R1, Q1⟩
DOM
⟨R2, S2⟩
⟨R,ϕ⟩
−−−−−→⟨R1, S1⟩
˚
Dom(A)
⟨R2, S2, A2⟩
⟨R, ˆ
ϕ,f,g⟩
−−−−−−→⟨R1, S1, A1⟩
˚
Dom
Table 4. Schemed Domain Morphisms
⟨R2, T2⟩
⟨R, ξ⟩
←−−−−⟨R1, T1⟩
DB
⟨R2, Q2, K2, τ2⟩
⟨R,ς,κ⟩
←−−−−⟨R1, Q1, K1, τ1⟩
(proj)
⟨R2, T2⟩
⟨R,ψ⟩
←−−−−−⟨R1, T1⟩
Db(A)
⟨R2, S2, K2, τ2⟩
⟨R,ϕ,κ⟩
←−−−−−⟨R1, S1, K1, τ1⟩
(proj)
⟨R2, T2, A2⟩
⟨R, ˆ
ψ,f,g⟩
←−−−−−−−−⟨R1, T1, A1⟩
Db
⟨R2, S2, A2, K2, τ2⟩
⟨R, ˆ
ϕ,f,g,ˆκ⟩
←−−−−−−−⟨R1, S1, A1, K1, τ1⟩
(proj)
Table 5. Relational Database Morphisms
A.2.2
Passages The table projection passages (RHS) below are cocontinuous
[12], either by using ﬁbrations (
R ) or by using comma contexts (↓). Hence, we
LIST = List⇑
sort⇑
−−−−−→
(-) ◦sort Set⇑
List
sort
−−−→Set
R
DOM = Dom⇑
˚
data ≜data⇑
−−−−−−−−→
(-) ◦data
Cls⇑
Dom
data
−−→Cls
R
DOM = Dom⇑
˚
sign ≜sign⇑
−−−−−−−→
(-) ◦sign
List⇑
Dom
sign
−−→List
↓
DBop ∼= (Tblop)⇑
˚
dom ≜dom⇑
−−−−−−−→
(-)op ◦dom
Dom⇑= DOM
Tblop
dom
−−−→Dom
R
DBop ∼= (Tblop)⇑
˚
sign ≜sign⇑
−−−−−−−→
(-)op ◦sign
List⇑= LIST
Tblop
sign
−−−→List
↓
DBop ∼=
 Tblop⇑
˚
data ≜data⇑
−−−−−−−→
(-)op ◦data
Cls⇑
Tblop data
−−−→Cls
R
Table 6. Projection Passages
have various commuting diagrams as in Prop. 17.

---

40
Robert E. Kent
Corollary 1.
The signed domain of the join (limit) of a database is the sum
(colimit) of the underlying schemed domain. The signature of the colimit of a
schemed domain is the sum (colimit) of the underlying schema. Hence, the signa-
ture of the join of a database is the reference signature (colimit) of the underlying
schema.
DB =
 (-) ⇓Tbl

DOMop =
 (-) ⇑Dom
op
LISTop =
 (-) ⇑List
op
Tbl
Domop
Listop
lim
colimop
colimop
˚
dom
op =
 (-) ⇓domop
domop
˚
sch
op =  (-) ⇓signop
˚
sign
op =
 (-) ⇑sign
op
signop
signop
✲
✲
✲
❄
❄
❄
❄
☛
✡
✲
✟
✠
✛
For any database D with schema S =
˚
sch(D) and join table T = lim(D), the
signature of T is the reference signature of S: sign(T) = colim(S).
Proof. This is an instance of the result in Prop. 17, since Tbl is a complete
context, Dom and List are cocomplete contexts, and the passages Tblop
dom
−−−→
Dom and Dom
sign
−−−→List are cocontinuous.
LIST = List⇑
lim,colim
−−−−−−→List
schemas
DOM = Dom⇑
lim,colim
−−−−−−→Dom
˚
Dom =
R
data
ˆ
dom
lim,colim
−−−−−−→Dom
schemed domains
DB = Tbl⇓
lim,colim
−−−−−−→Tbl
Db =
R
data ˆ
db
lim,colim
−−−−−−→Tbl
databases
Table 7. Lim (Colim) Passages
A.2.3
Bridges Tbl. 8 list the bridges deﬁned and used in this paper and Tbl. 9
lists the bridge adjoints and bridge composites.

---

The FOLE Database
41
DOM
§ 3.1
Fig. 3
ς : Q2 ⇒R ◦Q1
Dom(A)
§ 3.2.1
Fig. 5
ϕ : S2 ⇒R ◦S1
Dom
§ 3.2
Fig. 6
´φ : S2 ⇐R ◦S1 ◦
´
dom⟨f,g⟩
`φ : S2 ◦
`
dom⟨f,g⟩⇐R ◦S1
DB
§ 4.1
Fig. 7
ξ : T2 ⇐Rop◦T1.
SET
κ : K2 ⇐Rop◦K1
Db(A)
§ 4.2.1
Fig. 10
ψ : T2 ⇐Rop◦T1
Db
§ 4.2.2
Fig. 13
´ψ : T2 ⇐Rop ◦T1 ◦´
tbl ⟨f,g⟩
`ψ : T2 ◦`
tbl ⟨f,g⟩⇐Rop ◦T1
Fig. 13
´χ⟨f,g⟩: ´
tbl⟨f,g⟩◦incA2 ⇐incA1
`χ⟨f,g⟩: incA2 ⇐`
tbl ⟨f,g⟩◦incA1
Table 8. Bridges
levo
dextro
´ϕ : S2 ⇒R ◦S1 ◦f ∗
`ϕ : S2 ◦Σf ⇒R ◦S1
´ϕ = (S2 ◦ηf) • ( `ϕ ◦f ∗)
`ϕ = ( ´ϕ ◦Σf) • (R ◦S1 ◦εf)
`ι⟨f,g⟩: f ∗◦incA2 ⇒incA1
´ι⟨f,g⟩: incA2 ⇒Σf◦f ∗
`ι⟨f,g⟩=
 f ∗◦´ι⟨f,g⟩

•
 ε⟨f,g⟩◦incA1

´ι⟨f,g⟩=
 η⟨f,g⟩◦incA2

•
 Σf ◦`ι⟨f,g⟩

ς : Q2 ⇒R ◦Q1
( ´ϕ ◦incA2) • (R ◦S1 ◦`ι⟨f,g⟩) = ς = (S2 ◦´ι⟨f,g⟩) • ( `ϕ ◦incA1)
´ψ : T2 ⇐Rop ◦T1 ◦´
tbl⟨f,g⟩
`ψ : T2 ◦`
tbl⟨f,g⟩⇐Rop ◦T1
´ψ = ( `ψ ◦´
tbl ⟨f,g⟩) • (T2 ◦ε⟨f,g⟩)
`ψ = (Rop ◦T1) ◦η⟨f,g⟩• ( ´ψ ◦`
tbl ⟨f,g⟩)
´χ⟨f,g⟩: ´
tbl ⟨f,g⟩◦incA2 ⇐incA1
`χ⟨f,g⟩: incA2 ⇐`
tbl⟨f,g⟩◦incA1
´χ⟨f,g⟩= (η⟨f,g⟩◦incA1) • ( ´
tbl ⟨f,g⟩◦`χ⟨f,g⟩)
`χ⟨f,g⟩= ( `
tbl ⟨f,g⟩◦χ⟨f,g⟩) • (ε⟨f,g⟩◦incA2)
ξ : T2 ⇐Rop◦T1
( ´ψ ◦incA1) • (T2 ◦´χ⟨f,g⟩) = ξ = (Rop◦T1) ◦`χ⟨f,g⟩• ( `ψ ◦incA2)
´τ⟨f,g⟩: (f ∗)op ◦tupA2 ⇐tupA1
`τ⟨f,g⟩: tupA2 ⇐Pop
f ◦tupA1
´τ⟨f,g⟩= (εop
f ◦tupA1) • ((f ∗)op ◦`τ⟨f,g⟩)
`τ⟨f,g⟩= (Pop
f ◦´τ⟨f,g⟩) • (ηop
f ◦tupA2)
κ • τ2 = (Rop◦τ1) • ( ˆϕop ◦ˆτ⟨f,g⟩) = (Rop◦τ1) • ˚
tup⟨f,g⟩( ˆϕ)
(Rop◦S op
1 ◦´τ⟨f,g⟩) • ( ´ϕop◦tupA2) = ˆϕop ◦ˆτ⟨f,g⟩= ( `ϕop◦tupA1) • (S op
2 ◦`τ⟨f,g⟩)
Table 9. Bridge Adjoints and Composites

---

42
Robert E. Kent
References
1. Barwise, J., and Seligman, J.: Information Flow: The Logic of Distributed Systems.
Cambridge University Press, Cambridge (1997).
2. Chen, P.: “The Entity-Relationship Model - Toward a Uniﬁed View of Data”. ACM
Trans. on Database Sys., 1 (1): pp. 9—36. doi:10.1145/320434.320440 (1976).
3. Codd, E.F.: The relational model for database management : version 2. Addison
Wesley, Boston (1990).
4. Ganter, B., and Wille, R.: Formal Concept Analysis: Mathematical Foundations.
Springer, New York (1999).
5. Goguen, J.: Information Integration in Institutions Paper for Jon Barwise memorial
volume (2004). Available online: http://cseweb.ucsd.edu/~goguen/pps/ifi04.
pdf.
6. Goguen, J., and Burstall, R.: “Institutions: Abstract Model Theory for Speciﬁcation
and Programming”. J. Assoc. Comp. Mach. vol. 39, pp. 95–146 (1992).
7. Kent, R.E. “System Consequence”. In: Rudolph, S., Dau, F., and Kuznetsov, S.O.
(eds.) Conceptual Structures: Leveraging Semantic Technologies, LNCS vol. 5662,
pp. 201–218. Springer, Heidelberg (2009).
8. Kent, R.E.: “Database Semantics”. (2011). Available online: http://arxiv.org/
abs/1209.3054.
9. Kent, R.E.: “The First-order Logical Environment”. In: Pfeiﬀer, H.D., Ignatov, D.I.,
Poelmans, J., and Nagarjuna G. (eds.) Conceptual Structures in Research and Edu-
cation, LNCS vol. 7735, pp. 210–230. Springer, Heidelberg (2013). Available online:
arxiv.org/abs/1305.5240.
10. Kent, R.E.: “The ERA of FOLE: Foundation” (2015). Available online: arxiv.org/
abs/1512.07430.
11. Kent, R.E.: “The ERA of FOLE: Superstructure” (2016). Available online: arxiv.
org/abs/1602.04268.
12. Kent, R.E.: “The FOLE Table” (2016). Available online: arxiv.org/abs/1810.
12100.
13. Kent, R.E.: “FOLE Equivalence” (2022). Available online: arxiv.org/abs/2201.
07373.
14. Kent, R.E.: “Relational Operations in FOLE” (2022). Available online: arxiv.org/
abs/2103.11027.
15. Mac Lane, S., Categories for the Working Mathematician. Springer-Verlag (1971).
16. Tarlecki, A., Burstall, R., Goguen, J.: “Some Fundamental Algebraic Tools for the
Semantics of Computation, Part 3: Indexed Categories”. Th. Comp. Sci. vol. 91,
pp. 239–264. Elsevier (1991).
17. The Information Flow Framework (IFF). The Standard Upper Ontology (SUO)
working group IEEE P1600.1. Available online:
http://web.archive.org/web/20121008145548/http://suo.ieee.org/IFF/;
Previously available online: http://suo.ieee.org/IFF/.
18. nLab Grothendieck ﬁbration. Available online:
ncatlab.org/nlab/show/Grothendieck+fibration.

---

