# FOLE Equivalence

> 来源: https://arxiv.org/pdf/2201.07373

arXiv:2201.07373v5  [cs.DB]  22 Apr 2023
FOLE Equivalence
Robert E. Kent
Ontologos
Abstract. The ﬁrst-order logical environment FOLE provides a rigorous
and principled approach to distributed interoperable ﬁrst-order infor-
mation systems. FOLE has been developed in two forms: a classiﬁcation
form and an interpretation form. Two papers represent FOLE in a classi-
ﬁcation form corresponding to ideas of the Information Flow Framework
([14],[15],[16]): the ﬁrst paper [9] provides a foundation that connects ele-
ments of the ERA data model [2] with components of the ﬁrst-order logical
environment FOLE; the second paper [10] provides a superstructure that
extends FOLE to the formalisms of ﬁrst-order logic. The formalisms in
the classiﬁcation form of FOLE provide an appropriate framework for de-
veloping the relational calculus. Two other papers represent FOLE in
an interpretation form: the ﬁrst paper [11] develops the notion of the
FOLE table following the relational model [3]; the second paper [12] dis-
cusses the notion of a FOLE relational database. All the operations of the
relational algebra have been rigorously developed [13] using the interpreta-
tion form of FOLE. The present study demonstrates that the classiﬁcation
form of FOLE is informationally equivalent to the interpretation form of
FOLE. In general, the FOLE representation uses a conceptual structures
approach, that is completely compatible with the theory of institutions,
formal concept analysis and information ﬂow.
Keywords: structures, speciﬁcations, sound logics, databases.

---

Table of Contents
FOLE Equivalence . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
1
Robert E. Kent
1
Preface.. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
3
2
Introduction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
5
2.1
First Order Logical Environment . . . . . . . . . . . . . . . . . . . . . . . . . . . .
5
2.2
Overview. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
6
3
Basic Concepts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
9
3.1
Formalism . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
9
3.2
Interpretation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
13
3.3
Satisfaction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
15
4
FOLE Structures. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
18
4.1
Structures. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
18
4.2
Structure Morphisms. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
20
4.3
Transition. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
21
4.4
Lax Structures. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
23
4.5
Lax Structure Morphisms. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
23
5
FOLE Speciﬁcations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
26
5.1
Speciﬁcations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
26
5.2
Speciﬁcation Morphisms. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
27
5.3
Speciﬁcation Satisfaction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
28
6
FOLE Sound Logics. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
30
6.1
Sound Logics. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
30
6.2
Sound Logic Morphisms. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
31
7
FOLE Databases. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
35
7.1
Databases. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
35
7.2
Database Morphisms. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
37
A Appendix . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
43
A.1 FOLE Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
43
A.2 Classiﬁcations and Infomorphisms . . . . . . . . . . . . . . . . . . . . . . . . . . .
45

---

FOLE Equivalence
3
1
Preface.
The architecture for the ﬁrst-order logical environment FOLE is displayed in
Fig. 1. 1 The left side of Fig. 1 represents FOLE in classiﬁcation form. The right
side of Fig. 1 represents FOLE in interpretation form.
Sound Logic
Structure
|
{z
}
classiﬁcation form
|
{z
}
interpretation form
Database
Table
Relational
Calculus
Relational
Operations
q
≡
✐
☛
❄
☞
✌
✠
✻
✎
✍
Fig. 1. FOLE Architecture
Classiﬁcation form. An ontology deﬁnes the primitives with which to model the
knowledge resources for a community of discourse (Gruber [6]). These primi-
tives, which consist of classes, relationships and properties, are represented by
the entity-relationship-attribute ERA model (Chen [2]). An ontology uses formal
axioms to constrain the interpretation of these primitives. In short, an ontology
speciﬁes a logical theory.
Two papers provide a rigorous mathematical representation for the ERA data
model in particular, and ontologies in general, within the ﬁrst-order logical en-
vironment FOLE. These papers represent the formalism and semantics of (many-
sorted) ﬁrst-order logic in a classiﬁcation form corresponding to ideas discussed
in the Information Flow Framework (IFF [16]). The paper (Kent [9]) develops the
notion of a FOLE structure; this provides a foundation that connects elements of
the ERA data model with components of the ﬁrst-order logical environment FOLE.
The paper (Kent [10]) develops the notion of a FOLE sound logic; this provides
a superstructure that extends FOLE to the formalisms of ﬁrst-order logic.
1 FOLE is described in the following papers: “The ERA of FOLE: Foundation” [9], “The
ERA of FOLE: Superstructure” [10], “The FOLE Table” [11], “The FOLE Database” [12],
“FOLE Equivalence” [this paper], and “Relational Operations in FOLE” [13] .

---

4
Robert E. Kent
Interpretation form. The relational model (Codd [3]) is an approach for the
information management of a “community of discourse” 2 using the semantics
and formalism of (many-sorted) ﬁrst-order predicate logic. The ﬁrst-order logical
environment FOLE (Kent [8]) is a category-theoretic representation for this logic.
3 Hence, the relational model can naturally be represented in FOLE. A series of
papers is being developed to provide a rigorous mathematical basis for FOLE by
deﬁning an architectural semantics for the relational data model.
Two papers provide a precise mathematical basis for FOLE interpretation.
Both of these papers expand on material found in the paper (Kent [7]). The
paper (Kent [11]) develops the notion of a FOLE table following the relational
model (Codd [3]). The paper (Kent [12]) develops the notion of a FOLE rela-
tional database, thus providing the foundation for the semantics of ﬁrst-order
logical/relational database systems.
Equivalence. The current paper “FOLE Equivalence” deﬁnes an interpretation of
FOLE in terms of the transformational passage, ﬁrst described in (Kent [8]), from
the classiﬁcation form of ﬁrst-order logic to an equivalent interpretation form,
thereby deﬁning the formalism and semantics of ﬁrst-order logical/relational
database systems. Although the classiﬁcation form follows the entity-relationship-
attribute data model of Chen [2], the interpretation form incorporates the rela-
tional data model of Codd [3]. Relational operations are described in the paper
(Kent [13]). The relational calculus will be discussed in a future paper.
2 Examples include: an academic discipline; a commercial enterprise; the genetics re-
search community, library science; the legal profession; etc.
3 Following the original discussion of FOLE (Kent [8]), we use the term mathematical
context for the concept of a category, the term passage for the concept of a functor,
and the term bridge for the concept of a natural transformation. A context represents
some “species of mathematical structure”. A passage is a “natural construction on
structures of one species, yielding structures of another species” (Goguen [5]).

---

FOLE Equivalence
5
2
Introduction.
This paper deﬁnes the equivalence between two forms
of the ﬁrst-order logical environment FOLE, the clas-
siﬁcation form and the interpretation form. Equiv-
alence sits between the top of both forms, pictured
brieﬂy on the right, and more completely in Fig.1 in
the preface §1. The classiﬁcation form hierarchy (left
hand side) consists of “The FOLE Foundation” at the
bottom and “The FOLE Superstructure” at the top.
The interpretation form hierarchy (right hand side)
consists of “The FOLE Table” at the bottom and “The
FOLE Database” at the top.
≡•
Relational
Calculus
Relational
Algebra
✾
✿
◦
◦
◦
◦
FOLE
architecture
2.1
First Order Logical Environment
This paper relates two forms of the ﬁrst order logic environment FOLE: the clas-
siﬁcation form and the interpretation form. These two forms are shown to be
“informationally equivalent” 4 to each other. Both forms have their own advan-
tages: the classiﬁcation form allows formalism 5 to be easily deﬁned, whereas
the interpretation form allows relational operations 6 to be easily deﬁned. The
classiﬁcation form of FOLE is realized in the notion of a (lax) sound logic, whereas
the interpretation form of FOLE is realized in the notion of a relational database.
To demonstrate the equivalence of the classiﬁcation form with the interpretation
form, (lax) sound logics and relational databases are shown to be in a reﬂective
relationship (Fig. 2).
Although a FOLE relational database can be taken as a
whole, a FOLE sound logic resolves into the two parts of structure and speciﬁca-
tion, plus the relationship of satisfaction. 7
In more detail (Tbl. 1), the classiﬁcation form of FOLE is represented by a
(lax) sound logic consisting of two components, a (lax) structure and an abstract
speciﬁcation, which are connected by a satisfaction relation. The (lax) structure
consists of a (lax) entity classiﬁcation, an attribute classiﬁcation (typed domain),
a schema, and one of the two equivalent descriptions: either a tabular map from
predicates to tables; or a bridge consisting of an indexed collection of table tu-
ple functions. The abstract speciﬁcation is the same as a the database schema.
Satisfaction is deﬁned by table interpretation using constraints. The interpre-
tation form of FOLE is represented by a relational database with constant type
domain, a tabular interpretation diagram, whose projective components consist
of a database schema, a key diagram, and a tuple bridge. The tabular interpreta-
tion diagram is equivalent to the satisfaction relation between the (lax) structure
and the abstract speciﬁcation. 8
4 See Prop. 12 in § A.1 of the paper [11] “The FOLE Table”.
5 See the paper [10] “The ERA of FOLE: Superstructure”.
6 See the paper [13] “Relational Operations in FOLE”.
7 The satisfaction relation corresponds to the “truth classiﬁcation” in Barwise and
Seligman [1], where the conceptual intent MS corresponds to the “theory of M”.
8 See (Key) Prop. 3 in § 5.3.

---

6
Robert E. Kent
Snd
˚
Snd
Db
lax
im
⊣
inc
✲
✲
✛
Fig. 2. FOLE Equivalence
2.2
Overview.
˚
Snd
im
←−Db: A database resolves into a sound logic: the speciﬁcation is the
database schema projection; the (lax) structure is the constraint-free
aspect of a database; and tabular interpretation deﬁnes satisfaction.
˚
Snd
inc
−−→Db: A sound logic assembles a database: the speciﬁcation pro-
vides (is the same as) the database schema; the (lax) structure provides
a constraint-free interpretation consisting of a collection of tables in-
dexed by predicates; and satisfaction deﬁnes the tabular interpretation.
Table 1. FOLE Equivalence in Brief
Brieﬂy, § 3 deﬁnes some basic concepts of FOLE (formula, interpretation and
satisfaction); § 4 deﬁnes structures and converts them to a lax variety; § 5 deﬁnes
formal and abstract speciﬁcations, and satisfaction of speciﬁcations by struc-
tures; § 6 deﬁnes (lax) sound logics and converts these to relational databases;
and § 7 deﬁnes relational databases and converts these to (lax) sound logics. In
overview, Table 2 lists the ﬁgures and tables used in this paper.
Basic Concepts. § 3 reviews some basic concepts (Tbl. 3) of the FOLE logical
environment from § 2 of the paper [10] “Superstructure”. This covers the con-
cepts of formalism, tabular interpretation, and satisfaction. § 3.1 recapitulates
the deﬁnition of formalism in [10]. Formalism is deﬁned in terms of the logical
Boolean operations and quantiﬁers using syntactic ﬂow (Tbl. 4). § 3.2 extends
to tables the deﬁnition of logical interpretation in [10] using Boolean operations
within ﬁbers and quantiﬁer ﬂow between ﬁbers (Tbl. 5). It represents the syntac-
tic ﬂow operators of Tbl. 4 by their associated semantic ﬂow operators (Tbl. 6).
§ 3.3 reviews the notion of satisfaction in [10], which links formalism and seman-
tics via satisfaction. Satisfaction is deﬁned for both sequents and constraints.
Satisfaction is reﬂective (Fig. 3) between relations and tables.
Structures. § 4 reviews and extends the basic concepts of FOLE structure and
structure morphism from § 4.3 of the paper [9]“Foundation”. In § 4.1, Def. 1 de-
ﬁnes a FOLE structure with both a classiﬁcation and interpretation form. Fig. 4

---

FOLE Equivalence
7
illustrates this idea. Note the global key sets used in the entity classiﬁcation
of this deﬁnition. In § 4.2, Def. 2 deﬁnes an extended notion of FOLE structure
morphism by adding internal bridges. Fig. 5 illustrates this idea. Note the global
key function in the entity infomorphism of this deﬁnition. § 4.3 deﬁnes a transi-
tion from strict to lax structures and structure morphisms. This is accomplished
by changing the entity classiﬁcation and entity infomorphism to lax versions,
thus changing the global key sets and key function to local versions. Note 1,
Prop. 1 (Key) and Cor. 1 deﬁne a step-by-step process for this transition. Fig. 6
illustrates the steps of this transition. § 4.4 and § 4.5 introduce the idea of lax
structures and lax structure morphisms. We generalize to lax structures and
lax structure morphisms by eliminating the global key sets and key functions.
Def. 3 deﬁnes a lax FOLE structure in terms of either a tabular interpretation
function or a tuple bridge. Prop. 2 shows that a lax structure is the same as the
constraint-free aspect of a database. Def. 4 deﬁnes a (lax) structure morphism.
Cor. 2 shows that a (lax) structure morphism deﬁnes a tabular interpretation
bridge function. Fig. 7 illustrates a (lax) structure morphism.
Speciﬁcations. § 5 reviews and extends the notion of a FOLE speciﬁcation. For-
mal FOLE speciﬁcations are covered in § 3.1 of the paper [10] “Superstructure”.
Here we extend to abstract FOLE speciﬁcations. § 5.1 deﬁnes a formal speciﬁca-
tion in Def. 5 and an abstract speciﬁcation in Def. 6. Every abstract speciﬁcation
is closely linked to a companion formal speciﬁcation. § 5.2 deﬁnes a abstract
speciﬁcation morphism in Def. 7 and illustrates this in Fig. 8. Abstract speciﬁ-
cations and morphisms are the same as database schemas and morphisms. § 5.3
deﬁnes speciﬁcation satisfaction. Def. 8 deﬁnes satisfaction for formal speciﬁ-
cations, whereas Def. 9 deﬁnes satisfaction for abstract speciﬁcations in terms
of satisfaction for rheir formal companion. Assuming satisfaction holds, Def. 10
deﬁnes the abstract table passage as the composition of the object-identical
companion passage, the inclusion into the structure conceptual intent, and the
relation interpretation passage of Lem. 2 in § 3.3. Prop. 3 is key: it proves that
satisfaction is equivalent to tabular interpretation, This is central, since it binds
together the two parts of a sound logic, its structure and its speciﬁcation. It
underpins the core idea that sound logics are equivalent to relational databases.
Fig. 9 illustrates and compares speciﬁcation passages, both in general and with
satisfaction. Tbl. 7 illustrates and compares speciﬁcations with the sound logics
deﬁned in § 6.
Sound Logics. § 6 reviews the notion of a FOLE sound logic. § 6.1 discusses sound
logics. Def. 11 deﬁnes (lax) sound logics in terms of satisfaction between its two
components: structure and abstract speciﬁcation. Prop. 4 proves that any (lax)
sound logic deﬁnes a relational database. Tbl. 8 lists and illustrates the various
components of a (lax) sound logic. § 6.2 discusses sound logic morphisms. Def. 12
deﬁnes the notion of a (lax) sound logic morphism. Prop. 5 shows how (lax)
sound logic morphisms preserve and link satisfaction between their source and
target logics. The large ﬁgure Fig. 10 expands in detail the naturality used in this
proposition. Prop. 6 proves that a (lax) sound logic morphism deﬁnes a database

---

8
Robert E. Kent
morphism. Thm. 1 proves existence of a passage from the context of (lax) FOLE
sound logics to the context of FOLE relational databases. Tbl. 9 illustrates the
components of a (lax) sound logic morphism.
Relational Databases. § 7 reviews the notion of a FOLE relational database. § 7.1
discusses FOLE relational databases. Def. 13 deﬁnes a relational database as an
interpretation diagram from predicates to tables for a ﬁxed type domain. Fig. 11
illustrates this deﬁnition. Def. 14 deﬁnes relational databases using table projec-
tion passages. Tbl. 10 lists the components of a FOLE relational database. Prop.7
shows that the constraint-free aspect of a database is the same as a (lax) struc-
ture. Prop.8 proves that a FOLE database deﬁnes a (lax) FOLE sound logic. § 7.2
discusses FOLE relational database morphisms. Def. 15 deﬁnes a database mor-
phism to consist of a tabular passage between source/target predicate contexts,
an infomorphism between source/target type domains, and a bridge connect-
ing the source/target tabular interpretations. Fig. 12 illustrates this deﬁnition.
Def. 16 deﬁnes relational database morphisms using table projection passages.
Tbl. 11 lists and Fig. 14 illustrates the components of a FOLE relational database.
Prop. 9 shows that the constraint-free aspect of a FOLE database morphism is the
same as a (lax) FOLE structure morphism. Prop.10 proves that a FOLE database
morphism deﬁnes a (lax) FOLE sound logic morphism. Thm. 2 proves existence of
a passage from the context of FOLE relational databases to the context of (lax)
FOLE sound logics. Thm. 3 proves that the contexts of FOLE relational databases
and FOLE (lax) sound logics are “informationally equivelent” by way of a reﬂec-
tion.
Appendix. § A.1 lists the FOLE components used in this paper. Tbl. 12 in § A.1
lists the equivalent and adjoint versions of FOLE bridges. Tbl. 13 in § A.1 lists the
FOLE Morphisms. § A.2 reviews the concepts of classiﬁcations and infomorphisms.
Both are extended to lax versions.

---

FOLE Equivalence
9
§1 Fig. 1
:
FOLE Architecture
§2 Fig. 2
:
FOLE Equivalence
§3 Fig. 3
:
Table-Relation Reﬂection
§4 Fig. 4
:
FOLE Structure
Fig. 5
:
Structure Morphism
Fig. 6
:
Transition
Fig. 7
:
Lax Structure Morphism
§5 Fig. 8
:
Speciﬁcation Morphisms
Fig. 9
:
Speciﬁcation Passages
§6 Fig. 10 :
Naturality Combined
§7 Fig. 11 :
Database: Type Domain
Fig. 12 :
Database Morphism
Fig. 13 :
Inclusion Bridge: Tables
Fig. 14 :
Database Morphism: Type Domain
§A Fig. 15 :
Infomorphism
Fig. 16 :
Lax Infomorphism
§ 2 Tbl. 1
:
FOLE Equivalence in Brief
Tbl. 2
:
Figures and Tables
§ 3 Tbl. 3
:
Basic Concepts
Tbl. 4
:
Syntactic Flow
Tbl. 5
:
Formula Interpretation
Tbl. 6
:
Formal/Semantics Reﬂection
§ 5 Tbl. 7
:
Comparisons
§ 6 Tbl. 8
:
Sound Logic
Tbl. 9
:
Sound Logic Morphism
§ 7 Tbl. 10 :
Relational Database
Tbl. 11 :
Database Morphism
§ A Tbl. 12 :
FOLE Adjoint Bridges
Tbl. 13 :
FOLE Morphisms
Tbl. 14 :
Lax Infomorphisms
Table 2. Figures and Tables
3
Basic Concepts
The basic concepts of FOLE are listed in Tbl. 3. 9 Except for the formula inter-
pretation in Tbl.5, we can refer all the formal material to the paper “The ERA
of FOLE: Superstructure” [10].
§ 2.1
Formalism (formulas, sequents, constraints)
Axioms (Tbl. 3)
§ 2.2
Semantics (formula interpretation)
Formal/Semantics Reﬂection (Tbl. 6)
§ 2.3
Satisfaction (sequents, constraints)
Table 3. Basic Concepts
3.1
Formalism
Formulas. Let S = ⟨R, σ, X⟩be a ﬁxed schema with a set of entity types R,
a set of sorts (attribute types) X and a signature function R
σ−→List(X). The
set of entity types R is partitioned R = S
⟨I,s⟩∈List(X) R(I, s) into ﬁbers, where
9 Satisfaction for (abstract) speciﬁcations is deﬁne in Def. 9 of § 5.3.

---

10
Robert E. Kent
R(I, s) ⊆R is the ﬁber (subset) of all entity types with signature ⟨I, s⟩. These are
called ⟨I, s⟩-ary entity types. 10 Here, we follow the tuple, domain, and relation
calculi from database theory, using logical operations to extend the set of basic
entity types R to a set of deﬁned entity types bR called formulas or queries.
Formulas, which are deﬁned entity types corresponding to queries, are con-
structed by using logical connectives within a ﬁber and logical ﬂow along signa-
ture morphisms between ﬁbers (Tbl. 4). 11 12 Logical connectives on formulas
express intuitive notions of natural language operations on the interpretation
(extent, view) of formulas. These connectives include: conjunction, disjunction,
negation, implication, etc. For any signature ⟨I, s⟩, let bR(I, s) ⊆bR denote the
set of all formulas with this signature. There are called ⟨I, s⟩-ary formulas. The
set of S-formulas is partitioned as bR = S
⟨I,s⟩∈List(X) bR(I, s).
ﬁber: Let ⟨I, s⟩be any signature. Any ⟨I, s⟩-ary entity type (relation symbol) is an ⟨I, s⟩-
ary formula; that is, R(I, s) ⊆bR(I, s). For a pair of ⟨I, s⟩-ary formulas ϕ and ψ,
there are the following ⟨I, s⟩-ary formulas: meet (ϕ ∧ψ), join (ϕ ∨ψ), implication
(ϕ _ ψ) and diﬀerence (ϕ \ ψ). For ⟨I, s⟩-ary formula ϕ, there is an ⟨I, s⟩-ary
negation formula ¬ϕ. There are top/bottom ⟨I, s⟩-ary formulas ⊤⟨I,s⟩and ⊥⟨I,s⟩.
ﬂow: Let ⟨I′, s′⟩
h−→⟨I, s⟩be any signature morphism. For ⟨I, s⟩-ary formula ϕ, there are
⟨I′, s′⟩-ary existentially/universally quantiﬁed formulas P
h(ϕ) and Q
h(ϕ). a For an
⟨I′, s′⟩-ary formula ϕ′, there is an ⟨I, s⟩-ary substitution formula h∗(ϕ′) = ϕ′(t).
a For any index i ∈I, quantiﬁcation for the complement inclusion signature function
⟨I \ {i}, s′⟩
inci
−−→⟨I, s⟩gives the traditional syntactic quantiﬁers ∀iϕ, ∃iϕ.
⟨I′, s′⟩
h−→⟨I, s⟩
bR(I′, s′)
bR(I, s)
P
h
h∗
Q
h
✛
✲
✛
Table 4. Syntactic Flow
In general, we regard formulas to be constructed entities or queries (deﬁn-
ing views and interpretations; i.e., relations/tables), not assertions. Contrast
this with the use of “asserted formulas” below. For example, in a corporation
data model the conjunction (Salaried∧Married) is not an assertion, but a
constructed entity type or query that deﬁnes the view “salaried employees that
10 This is a slight misnomer, since the signature of r is σ(R) = ⟨I, s⟩, whereas the arity
of r is α(R) = I.
11 An S-signature morphism ⟨I′, s′⟩
h−→⟨I, s⟩in List(X) is an arity function I′
h
−→I
that preserves signature s′ = h · s.
12 The full version of FOLE (Kent [8]) deﬁnes syntactic ﬂow along term vectors.

---

FOLE Equivalence
11
are married”. Formulas form a schema bS = ⟨bR, bσ, X⟩that extends S with S-
formulas as entity types: with the inductive deﬁnitions above, the set of entity
types is extended to a set of logical formulas R
incS֒
−−−→bR, and the entity type
signature function is extended to a formula signature function bR
bσ
−−→List(X)
with σ = incS · bσ.
Sequents. To make an assertion about things, we use a sequent. Let S = ⟨R, σ, X⟩
be a schema. A (binary) S-sequent 13 is a pair of formulas (ϕ, ψ) ∈bR × bR with
the same signature bσ(ϕ) = ⟨I, s⟩= bσ(ψ). To be explicit that we are making an
assertion, we use the turnstile notation ϕ ⊢ψ for a sequent. Then, we are claim-
ing that a specialization-generalization relationship exists between the formulas
ϕ and ψ. A asserted sequent ϕ ⊢ψ expresses interpretation widening, with the
interpretation (view) of ϕ required to be within the interpretation (view) of ψ.
An asserted formula ϕ ∈bR can be identiﬁed with the sequent ⊤⊢ϕ in bR × bR,
which asserts the universal view “all entities” of signature σ(ϕ) = ⟨I, s⟩. Hence,
from an entailment viewpoint we can say that “formulas are sequents”. In the
opposite direction, there is an enfolding map bR × bR →bR that maps S-sequents
to S-formulas (ϕ ⊢ψ) 7→(ϕ _ ψ). The axioms in Tbl. 3 of the paper [10] make
sequents into an order. Let ConS(I, s) = ⟨bR(I, s), ⊢⟩denote the ﬁber preorder
of S-formulas.
Constraints. Sequents only connect formulas within a particular ﬁber: an S-
sequent ϕ ⊢ψ is between two formulas with the same signature bσ(ϕ) = ⟨I, s⟩=
bσ(ψ), and hence between elements in the same ﬁber ϕ, ψ ∈bR(I, s). We now de-
ﬁne a useful notion that connects formulas across ﬁbers. An S-constraint ϕ′ h−→ϕ
consists of a signature morphism bσ(ϕ′) = ⟨I′, s′⟩
h−→⟨I, s⟩= bσ(ϕ) and a binary
sequent P
h(ϕ) ⊢ϕ′ in ConS(I′, s′), or equivalently by the axioms in Tbl. 3 of
the paper [10], a binary sequent ϕ ⊢h∗(ϕ′) in ConS(I, s). Hence, a constraint
requires that the interpretation of the hth-projection of ϕ be within the in-
terpretation of ϕ′, or equivalently, that the interpretation of ϕ be within the
interpretation of the hth-substitution of ϕ′. 14
Given any schema S, an S-constraint ϕ′
h−→ϕ has source formula ϕ′ and
target formula ϕ. Constraints are closed under composition: ϕ′′
h′
−→ϕ′
h−→
ϕ = ϕ′′
h′ · h
−−−→ϕ. Let Cons(S) 15 denote the mathematical context, whose
set of objects are S-formulas and whose set of morphisms are S-constraints.
This context is ﬁbered over the projection passage Cons(S) →List(X) :
13 Since FOLE formulas are not just types, but are constructed using, inter alia, con-
junction and disjunction operations, we can restrict attention to binary sequents.
14 In some sense, this formula/constraint approach to formalism turns the tuple calculus
upside down, with atoms in the tuple calculus becoming constraints here.
15 Cons(S), which stands for “S-constraints”, was deﬁned in the paper [10].

---

12
Robert E. Kent
 ϕ′ h−→ϕ

7→
 ⟨I′, s′⟩
h−→⟨I, s⟩

. Formula formation is idempotent: bbR = bR and
Cons( bS) = Cons(S). 16
Sequents are special cases of constraints: a sequent ϕ′ ⊢ϕ asserts a constraint
ϕ
1−→ϕ′ that uses an identity signature morphism. 17 Since an asserted formula
ϕ can be identiﬁed with the sequent ⊤⊢ϕ, it can also be identiﬁed with the
constraint ϕ
1−→⊤. Thus, from an entailment viewpoint we can say that “formulas
are sequents are constraints”. In the opposite direction, there are enfolding maps
that map S-constraints to S-formulas: either
 ϕ′
h−→ϕ

7→
 P
h(ϕ) _ ϕ′
with
signature ⟨I′, s′⟩, or
 ϕ′
h−→ϕ

7→
 ϕ _ h∗(ϕ′)

with signature ⟨I, s⟩.
16 Formulas form a schema bS = ⟨bR, bσ, X⟩that extends S with S-formulas as entity
types (relation names): by induction, the set of entity types is extended to a set of
logical formulas R
incS֒
−−−→bR, and the entity type signature function is extended to a
formula signature function bR
bσ
−−→List(X) with σ = incS · bσ.
17 A constraint in the ﬁber ConS(I, s) uses an identity signature morphism ϕ
1−→ϕ′,
and hence is a sequent ϕ′ ⊢ϕ.

---

FOLE Equivalence
13
3.2
Interpretation
The logical semantics of a structure M resides in its core, which is deﬁned by
its formula interpretation function
TM : bR →Tbl(A).
(1)
The formula interpretation function, which extends the traditional interpretation
function TM : R →Tbl(A) of a structure M (Def. 1 in § 4), is deﬁned in Tbl. 5 by
induction within ﬁbers and ﬂow between ﬁbers. To respect the logical semantics,
the formal ﬂow operators (P
h,Q
h,h∗) for existential/universal quantiﬁcation and
substitution reﬂect the semantic ﬂow operators (P
h,Q
h,h∗) via interpretation
(Tbl. 6).
18
ﬁber: For each signature ⟨I, s⟩∈List(X), the ﬁber function bR(I, s)
T M
⟨I,s⟩
−−−→TblA(I, s)
is deﬁned in the top part of Tbl. 5 by induction on formulas. At the base
step (ﬁrst line in the top of Tbl. 5), it deﬁnes the formula interpretation
of an entity type r ∈bR as the traditional interpretation of that type: the
A-table TM(r) = ⟨σ(r), K(r), τr⟩∈Tbl(A) (Fig. 4 of §4).
At the induc-
tion step (remaining lines in the top of Tbl. 5), it represents the logical
operations by their associated boolean operations: meet of interpretations
for conjunction, join of interpretations for disjunction, etc.; see the boolean
operations deﬁned in § 3.2 of the paper “Relational Operations in FOLE” [13].
ﬂow: (bottom Tbl. 5), It represents the syntactic ﬂow operators in Tbl. 4 by their
associated semantic ﬂow operators; see the adjoint ﬂow for ﬁxed type domain
A deﬁned in § 3.3.1 of the paper “Relational Operations in FOLE” [13]. 19 The
function bR
TM
−−→Tbl(A) is the parallel combination of its ﬁber functions

bR(I, s)
T M
⟨I,s⟩
−−−−→TblA(I, s) | ⟨I, s⟩∈List(X)

deﬁned above. The function TM
is deﬁned in terms of these ﬁber functions and the ﬂow operators.
18 The morphic aspect of Tbl. 6 anticipates the deﬁnition of satisfaction in §.3.3: for
sequents within the ﬁbers TA(I, s) and for constraints using ﬂow between ﬁbers;

P
h ⊣h∗⊣Q
h

: TblA(I′, s′) ⇆TblA(I, s).
19 The paper [13] used only two of the three operators in the ﬁber adjunction of tables
TblA(I′, s′)

´
tblA(h) ⊣`
tblA(h)

←−−−−−−−−−−−−−

P
h ⊣h∗
TblA(I, s)
(2)
deﬁned by composition/pullback: the left adjoint existential operation (called projec-
tion) and the right adjoint substitution or inverse image operation (called inﬂation).

---

14
Robert E. Kent
ﬁber: signature ⟨I, s⟩with extent (tuple set) tupA(I, s) = Q
i∈I Asi
operator
deﬁnition
TM(ϕ) ∈TblA(I, s) =
 Set ↓tupA(I, s)

entity type
TM(r) = TM(r) = ⟨σ(r), K(r), τr⟩r ∈R(I, s) ⊆bR(I, s)
meet
TM(ϕ ∧ψ) = TM(ϕ) ∧TM(ψ)
ϕ, ψ ∈bR(I, s)
join
TM(ϕ ∨ψ) = TM(ϕ) ∨TM(ψ)
top
TM(⊤⟨I,s⟩) = ⟨tupA(I, s), 1⟩
terminal table
bottom
TM(⊥⟨I,s⟩) = ⟨∅, 0⟩
initial table
negation
TM(¬ϕ) = TM(⊤⟨I,s⟩\ ϕ) = TM(⊤⟨I,s⟩)−TM(ϕ)
implication
TM(ϕ _ ψ) = TM(ϕ) _ TM(ψ) = (¬TM(ϕ)) ∨TM(ψ)
diﬀerence
TM(ϕ \ ψ) = TM(ϕ)−TM(ψ) = TM(ϕ) ∧(¬TM(ψ))
ﬂow: signature morphism ⟨I′, s′⟩
h−→⟨I, s⟩
with tuple map tupA(I′, s′)
tupA(h)
←−−−−−tupA(I, s)
operator
deﬁnition
existential
TM(P
h(ϕ)) = P
h(TM(ϕ))
ϕ ∈bR(I, s)
universal
TM(Q
h(ϕ)) = Q
h(TM(ϕ))
substitution
TM(h∗(ϕ′)) = h∗(IM(ϕ′))
ϕ′ ∈bR(I′, s′)
Table 5. Formula Interpretation

 bR(I′, s′), ⊢′

 bR(I, s), ⊢

TblA(I′, s′)
TblA(I, s)
P
h
h∗
Q
h
P
h
h∗
Q
h
T M
⟨I′,s′⟩
T M
⟨I,s⟩
✛
✲
✛
✛
✛
✲
❄
❄
⟨I′, s′⟩
h−→⟨I, s⟩
tupA(I′, s′)
tup(h)
←−−−−tupA(I, s)
P
h ⊣h∗⊣Q
h
P
h ◦T M
⟨I′,s′⟩= T M
⟨I,s⟩◦P
h
h∗◦T M
⟨I,s⟩= T M
⟨I′,s′⟩◦h∗
Q
h ◦T M
⟨I′,s′⟩= T M
⟨I,s⟩◦Q
h
Table 6. Formal/Semantics Reﬂection

---

FOLE Equivalence
15
3.3
Satisfaction.
Satisfaction is a fundamental classiﬁcation between formalism and semantics.
The atom of formalism used in satisfaction is the FOLE constraint, whereas the
atom of semantics used in satisfaction is the FOLE structure. Satisfaction is de-
ﬁned in terms of the table formula interpretation function TM : bR →Tbl(A) of
§ 3.2 and the associated the relation formula interpretation function RM : bR →
Rel(A). 20 Assume that we are given a structure schema S = ⟨R, σ, X⟩with a
set of predicate symbols R and a signature (header) map R
σ−→List(X).
Sequent Satisfaction. A (lax) S-structure M = ⟨E, σ, τ, A⟩∈Struc(S) satisﬁes
a formal S-sequent ϕ ⊢ϕ′, for a pair of formulas (ϕ, ϕ′) ∈bR × bR with the same
signature bσ(ϕ) = ⟨I, s⟩= bσ(ϕ′), when the interpretation widening of views
asserted by the sequent actually holds in M:
RM(ϕ) ⊆RM(ϕ′)
in RelA(I,s)
reﬂectively21
TM(ϕ)
k
−→TM(ϕ′)
in TblA(I,s)
.
Satisfaction is symbolized either by M |=S (ϕ ⊢ϕ′) or by ϕ ⊢M ϕ′. For each
signature ⟨I, s⟩∈List(X), satisfaction deﬁnes the ﬁber order ⟨bR(I, s), ≤M⟩,
where ϕ ≤M ϕ′ when ϕ ⊢M ϕ′ for any two formulas ϕ, ϕ′ ∈bR(I, s).
K(ϕ′)
K(ϕ)
℘t′
ϕ′(K(ϕ′))
℘tϕ(K(ϕ))
tupA(σ(ϕ′))
tupA(σ(ϕ))
k
RM(h)
r
tupA(h)
tϕ′
tϕ
iϕ′
iϕ
eϕ′
eϕ
✛
✛
✛
✛
❄
❄
❄
✄ ❄
✄ ❫
✢
RM(ϕ′)


















RM(ϕ)
|
{z
}
TM(ϕ′)
|
{z
}
TM(ϕ)
✛TM(h)
⟨h, k⟩
Fig. 3. Table-Relation Reﬂection
20 Denoted by IM : bR →Rel(A) in § 2,2,1 of the paper “The ERA of FOLE: Superstruc-
ture” [10]
21 See the formal/semantics reﬂection deﬁned in § A.1 of the paper “The FOLE Table”
[11] and in § 3.1 of the paper “Relational Operations in FOLE” [13].

---

16
Robert E. Kent
Constraint Satisfaction. A (lax) S-structure M ∈Struc(S) satisﬁes a formal S-
constraint ϕ′
h−→ϕ, for a pair of formulas (ϕ′, ϕ) ∈bR × bR connected by a signature
morphism bσ(ϕ′) = ⟨I′, s′⟩
h−→⟨I, s⟩= bσ(ϕ),
when the following equivalence
holds
RM(ϕ′) ⊇∃h(RM(ϕ))
in RelA(I′,s′)
⇄
h−1(RM(ϕ′)) ⊇RM(ϕ)
in RelA(S)
|
{z
}
RM(ϕ′)
RM(h)
←−−−−−
⟨h,r⟩
RM(ϕ)
in Rel(A)
;
(3)
reﬂectively21 (visualized in Fig. 3)
TM(ϕ′)
k
←−P
h(TM(ϕ))
in TblA(I′,s′)
⇄
h∗(TM(ϕ′))
k′
←−−TM(ϕ)
in TblA(S)
|
{z
}
TM(ϕ′)
TM(h)
←−−−−−
⟨h,k⟩
TM(ϕ)
in Tbl(A)
.
(4)
Satisfaction is symbolized by M |=S (ϕ′
h−→ϕ).
Lemma 1. A (lax) S-structure M determines a mathematical context MS ⊑Cons(S),
called the conceptual intent of M, whose objects are S-formulas and whose mor-
phisms are S-constraints satisﬁed by M. The ⟨I, s⟩th ﬁber is the order MS(I, s) =
⟨bR(I, s), ≥M⟩. 22
Proof. MS is closed under constraint identities and constraint composition.
1:
M |=S (ϕ
1−→ϕ),
and
2:
if
M |=S (ϕ′′
h′
−→ϕ′)
and
M |=S (ϕ′
h−→ϕ),
then M |=S (ϕ′′
h′ · h
−−−→ϕ), since ϕ′′ ≥M
P
h′(ϕ′) and ϕ′ ≥M
P
h(ϕ) implies
ϕ′′ ≥M
P
h′(P
h(ϕ)) = P
h′ · h(ϕ).
Lemma 2. For any structure M, there is a relation interpretation passage and
a table interpretation graph morphism, 23
MSop
RM
−−−→Rel(A)
incA֒
−−−→Tbl(A) and
|MS|
op
TM
−−−→|Tbl(A)|,
(5)
which extend the formula interpretation function TM : bR →Tbl(A) of § 3.2,
and hence the structure interpretation function TM : R →Tbl(A) of § 4.
Proof.
objects: An S-formula ϕ ∈MS(I, s) = ⟨bR(I, s), ≤M⟩with S-signature ⟨I, s⟩
is mapped to an A-table TM(ϕ) = ⟨I, s, K, t⟩deﬁned by induction in the
top part of Tbl. 5 in in § 3.2. Reﬂectively, the formula ϕ is mapped to an
A-relation RM(ϕ) = ⟨I, s, ℘t(K)⟩.
22 The satisfaction relation corresponds to the “truth classiﬁcation” in Barwise and
Seligman [1], where the conceptual intent MS corresponds to the “theory of M”.
23 Relational interpretation is closed under composition; tabular interpretation is closed
under composition only up to key equivalence.

---

FOLE Equivalence
17
morphisms: An S-constraint ϕ′
h−→ϕ satisﬁed by the S-structure M ∈Struc(S),
M |=S (ϕ′
h−→ϕ), is mapped by constraint satisfaction to the Tbl(A)-morphism
TM(ϕ′) = T ′ = ⟨I′, s′, K(ϕ′), tϕ′⟩
⟨h,k⟩
←−−−⟨I, s, K(ϕ), tϕ⟩= T = TM(ϕ)
with indexing X-sorted signature morphism ⟨I′, s′⟩
h
−−→⟨I, s⟩and a key func-
tion K(ϕ′)
k
←−K(ϕ) 24 satisfying either of the adjoint ﬁber morphisms in
Disp.4 leading to the naturality condition k · tϕ′ = tϕ · tupA(h) and visual-
ized in Fig. 3. Reﬂectively, the constraint ϕ′
h−→ϕ is mapped to an A-relation
morphism RM(ϕ′) = R′ = ⟨I′, s′, ℘t′
ϕ′(K(ϕ′))⟩
⟨h,r⟩
←−−−⟨I, s, ℘tϕ(K(ϕ))⟩=
R = RM(ϕ) satisfying either of the adjoint ﬁber orderings in Disp.3 leading
to the naturality condition r · iϕ′ = iϕ · tupA(h) and visualized in Fig. 3.
24 Deﬁned by choice. However, the choice for a composite signature morphism is not
identical to the composition of the component choices; only equivalent.

---

18
Robert E. Kent
4
FOLE Structures.
We deﬁne two forms of structures and structure morphisms: a classiﬁcation
(strict) form and an interpretation (lax) form.
4.1
Structures.
Assume that we are given a schema S = ⟨R, σ, X⟩with a set of predicate symbols
R and a signature (header) map R
σ−→List(X).
Deﬁnition 1. An S-structure M = ⟨E, σ, τ, A⟩(LHS Fig. 4) consists of an en-
tity classiﬁcation E = ⟨R, K, |=E⟩of predicate symbols R and keys K, an attribute
classiﬁcation (typed domain) A = ⟨X, Y, |=A⟩of sorts X and data values Y , and
a list designation ⟨σ, τ⟩: E ⇒List(A) with signature map R
σ−→List(X), tuple
map K
τ−→List(Y ) and deﬁning condition k |=E r implies τ(k) |=List(A) σ(r). 25
Projections deﬁne the type hypergraph (schema) S = ⟨R, σ, X⟩, and an instance
hypergraph (universe) U = ⟨K, τ, Y ⟩.
R
K
List(X)
List(Y )
|=E
|=List(A)
σ
τ
✲
✲
R
Tbl(A)
TM
❄
R
List(X)
℘K
℘List(Y )
Set
extE
extList(A)
K
tupA
σ
℘τ
⊆
τ⌞
==⇒
inc
inc
✲
✲
❅
❅
❘
  ✠
❄
❄
③
✾
classiﬁcation form
interpretation form (passage)
interpretation form (bridge)
Fig. 4. FOLE Structure
By dropping the global key set K, the entity classiﬁcation E = ⟨R, K, |=E⟩can
be regarded (RHS Fig. 4) as a set-valued function K = R
extE
−−−→
K
℘K ⊆Set;
that is, as an indexed collection E = ⟨R, K⟩of subsets of keys

extE(r) =
K(r) ⊆Set | r ∈R
	
. The deﬁning condition of the list designation demon-
strates that a structure can be regarded (MID Fig. 4) as a table-valued func-
tion R
TM
−−→Tbl(A); that is, as an R-indexed collection of A-tables TM(r) =
⟨σ(r), K(r), τr⟩, whose tuple maps

K(r)
τr
−→tupA(σ(r)) | r ∈R
	
are restric-
tions of the tuple map K
τ−→List(Y ). Here, an entity type (predicate symbol)
r ∈R is interpreted as the A-table TM(r) = ⟨σ(r), K(r), τr⟩∈Tbl(A), consist-
ing of the X-signature σ(r) ∈List(X), the key set K(r) = extE(r) ⊆K, and the
25 In more detail, if entity k ∈K is of type r ∈R, then the description tuple τ(k) = ⟨J, t⟩
is the same “size” (J = I) as the signature σ(r) = ⟨I, s⟩and for each index n ∈I
the data value tn is of sort sn.

---

FOLE Equivalence
19
tuple function K(r)
τr
−→tupA(σ(r)), which is a restriction of the tuple function
K
τ−→List(Y ). The list classiﬁcation List(A) = ⟨List(X), List(Y ), |=List(A)⟩
can alternatively be regarded (RHS Fig. 4) (Fig. 4 of the paper [9]) as a set-
valued function List(X)
extList(A)
−−−−−−→
tupA
℘List(Y ); that is, as an indexed collection
List(A) = ⟨List(X), tupA, List(Y )⟩of subsets of tuples

extList(A)(I, s) =
tupA(I, s) ⊆List(Y ) | (I, s) ∈List(X)
	
. The bridge K
τ⌞
==⇒℘τ ◦inc provides
“restrictions” of the bridge K
τ
==⇒List(Y ) to subsets of K.

---

20
Robert E. Kent
4.2
Structure Morphisms.
Assume that we are given a schema morphism (Tbl. 13 in § A.1)
S2 = ⟨R2, σ2, X2⟩
⟨r, `ϕ,f⟩
=====⇒⟨R1, σ1, X1⟩= S1
(6)
consisting of a function on relation symbols R2
r−→R1, a sort function X2
f−→X1,
and a schema bridge σ2 · P
f
`ϕ
==⇒r · σ1, whose rth
2 -component is the morphism
P
f(σ2(r2))
`ϕr2
−−→
h
σ1(r(r2)) in List(X1).
Deﬁnition 2. A structure morphism M2
⟨r,k, `ϕ,β,f,g⟩
−−−−−−−−⇀
↽−−−−−−−−M1 from source struc-
ture M2 = ⟨E2, ⟨σ2, τ2⟩, A2⟩to target structure M1 = ⟨E1, ⟨σ1, τ1⟩, A1⟩along
(top Fig. 5) a schema morphism (Disp.6) is a list designation morphism con-
sisting of (back Fig. 5) an entity infomorphism E2
⟨r,k⟩
−−−⇀
↽−−−E1, and (front Fig. 5)
an attribute infomorphism A2
⟨f,g⟩
−−−⇀
↽−−−A1. These are bridged by the above schema
morphism and (bottom Fig. 5) a universe morphism U2
⟨k,β,g⟩
⇐===== U1 with tuple
bridge k · τ2
β
==⇒τ1 · P
g, whose kth
1 -component is the morphism τ2(k(k1))
βk1
−−→
h
P
g(τ1(k1)) in List(Y2), with equal arity
`ϕr2 ◦arity X1 = βk1 ◦arity Y2
|
{z
}
(I2
`
ϕr2
−−→
h
I1) = (J2
βk1
−−→
h
J1)
when k(k1) |=E2 r2 iﬀk1 |=E1 r(r2)
|
{z
}
k1 |=⟨r,k⟩r2
.
R2
R1
K2
K1
r
k
|=E2
|=E1
✲
✛
List(X2)
List(X1)
List(Y2)
List(Y1)
P
f
P
g
`
ϕ
===⇒
|=List(A2)
|=List(A1)
✲
✛
σ2
σ1
τ2
τ1
❆
❆❆❯
❆
❆❆❯
❆
❆❆❯
❆
❆❆❯
β
===⇒
lax schema morphism
sch(M2)
⟨r, `
ϕ,f⟩
======⇒sch(M1)
z
}|
{
E2
⟨r,k⟩
−−−⇀
↽−−−E1
entity infomorphism

















List
 A2
⟨f,g⟩
−−−−⇀
↽−−−−A1

typed domain morphism

















|
{z
}
univ(M2)
⟨k,β,g⟩
⇐====== univ(M1)
lax universe morphism
E2
List(A2)
E1
List(A1)
⟨σ2, τ2⟩
⟨σ1, τ1⟩
⟨r, k⟩
List(⟨f, g⟩)
⟨P
f , P
g⟩
⟨`ϕ,β⟩
===⇒
✲
✛
✲
✛
❄❄
❄❄
Fig. 5. Structure Morphism
Let Struc denote the mathematical context of structures and their morphisms.

---

FOLE Equivalence
21
4.3
Transition.
In this section (§ 4), we deﬁne two forms of structures and structure morphisms:
a classiﬁcation (strict) form and an interpretation (lax) form. Fig. 5 illustrates
the classiﬁcation (strict) form; whereas Fig. 7 illustrates the interpretation (lax)
form. Here we deﬁne a transition from the strict form to the lax form.
Note 1. By forgetting the full key sets and the full key function, the entity info-
morphism becomes a (lax) entity infomorphism
K2
extE2
κ
⇐== r ◦
K1
extE1 consisting
of an R2-indexed collection of key functions

K2
extE2(r2)
κr2
←−−
k
K1
extE1(r(r2)) | r2 ∈R2
	
.
Map k1 ∈
K1
extE1(r(r2)) with k1 |=E1 r(r2) to κr2(k1) = k(k1) ∈
K2
extE2(r2) with
k(k1) |=E2 r2. The collection of List(X1)-signature morphisms
P
f(
S2
σ2(r2))
`
ϕr2
−−−→
h
S1
σ1(r(r2)) | r2 ∈R2
	 deﬁnes the List(Y1)-tuple functions

tupA1(P
f(σ2(r2)))
tupA1 ( `
ϕr2 )
←−−−−−−−−
tupA1 (h)
tupA1(σ1(r(r2))) | r2 ∈R2
	.
For any source predicate r2 ∈R2, there is a bridge κr2 · ¯τ2,r2
βr2
===⇒¯τ1,r(r2) · P
g
K2
List(Y2)
K1
List(Y1)
K2(r2)
K1(r(r2))
tupA2 (σ2(r2))
tupA1 (σ1(r(r2)))
tupA1 (P
f (σ2(r2)))
κr2
tup( `
ϕr2 , f, g)
τ2,r2
τ1,r(r2)
tupA1 ( `
ϕr2 ) = h · (-)
(-) · g = `τ⟨f,g⟩(σ2(r2))
k
P
g
τ2
τ1
=
=
=
=
τ `
ϕr2
===⇒
β
===⇒
βr2
===⇒
❄
❄
✛
✛
◗
◗
❦
✑
✑
✰
❄
✛
✛
❄
■
✒
☛
❯
q
Fig. 6. Transition
that is a restriction of the bridge k · τ2
β
==⇒τ1 · P
g to the subset K1(r(r2)) ⊆K1,
where ¯τ2,r2 = τ2,r2 · inc and ¯τ1,r(r2) = τ1,r(r2) · inc. For each key k1∈K1(r(r2)),
the kth
1 -component of the bridge βr2 is the List(Y2)-morphism
¯τ2,r2(κr2(k1))
τ2(k(k1))
βk1
−−→
h
P
g(¯τ1,r(r2)(k1))
P
g(τ1(k1))
. 26
26 Note that we have used the equal arity condition for a structure morphism (Def 2):
`ϕr2 ◦arity X1 = βk1 ◦arity Y2 when k(k1) |=E2 r2 iﬀk1 |=E1 r(r2).

---

22
Robert E. Kent
Proposition 1 (Key). Any structure morphism M2
⟨r,k, `ϕ,β,f,g⟩
−−−−−−−−⇀
↽−−−−−−−−M1 (Def 2)
satisﬁes the following condition: for any source predicate r2 ∈R2,
κr2 · τ2,r2 = τ1,r(r2) · tupA1( `ϕr2) · `τ⟨f,g⟩(σ2(r2)). 27
Proof. For
suppose
that
k1 ∈extE1(r(r2))
with
k2
=
κr2(k1)
=
k(k1) ∈extE2(r2). Deﬁne (I1, t1) = τ1,r(r2)(k1) = τ1(k1) ∈tupA1(σ1(r(r2)))
and
(I2, t2)
=
τ2,r2(κr2(k1))
=
τ2(k2) ∈tupA2(σ2(r2)).
We
have
the
List(Y2) morphism (I2, t2)
=
τ2(k(k1))
βk1
−−→
h
P
g(τ1(k1))
=
P
g(I1, t1).
Thus, t2
=
h · t1 · g. This means that (I2, t2)
=
tup(h, f, g)(I1, t1)
=
`τ⟨f,g⟩(σ2(r2))(tupA1(h)(I1, t1))
=
`τ⟨f,g⟩(σ2(r2))(tupA1( `ϕr2)(I1, t1)).
Hence,
τ2,r2(κr2(k1))
=
`τ⟨f,g⟩(σ2(r2))(tupA1( `ϕr2)(τ1,r(r2)(k1)))
=
tup( `ϕr2, f, g)(τ1,r(r2)(k1)), for all k1 ∈extE1(r(r2)).
Corollary 1. For r2 ∈R2, each bridge κr2 · ¯τ2,r2
βr2
===⇒¯τ1,r(r2) · P
g reduces to
the composite βr2 = τ1,r(r2) · τ `ϕr2 ◦P
g for the bridge tupA1( `ϕr2) ◦inc
τ `
ϕr2
===⇒
inc associated with the function tupA1(P
f(σ2(r2)))
tupA1 ( `ϕr2)
←−−−−−−−
h · (-)
tupA1(σ1(r(r2))).
28
Proof. Straightforward.
27
The tuple bridge tupA2
`τ⟨f,g⟩
⇐===== (P
f)op◦tupA1 is deﬁned and used in the paper
“The FOLE Table”[11].
28 For tuple (I1, t1) ∈tupA1(σ1(r(r2))), the (I1, t1)th component of τ `
ϕr2 is the List(Y1)-
morphism tupA1( `ϕr2)(I1, t1) = (I1, h · t1)
τ `
ϕr2 (I1,t1)
−−−−−−−→
h
(I1, t1).

---

FOLE Equivalence
23
4.4
Lax Structures.
To show equivalence between sound logics and databases, we need to use lax
structures. 29 Again, assume that we are given a schema S = ⟨R, σ, X⟩with a
set of predicate symbols R and a signature (header) map R
σ−→List(X).
Deﬁnition 3. A (lax) S-structure M = ⟨E, σ, τ, A⟩consists of a lax entity clas-
siﬁcation E = ⟨R, K⟩, an attribute classiﬁcation (typed domain) A = ⟨X, Y, |=A⟩,
the schema S = ⟨R, σ, X⟩, and one of the two equivalent descriptions:
• either (MID Fig. 4) a function R
TM
−−→Tbl(A) consisting of an R-indexed
collection of A-tables TM(r) = ⟨σ(r), K(r), τr⟩;
• or (RHS Fig. 4) a tuple bridge K
τ
==⇒σ ◦tupA consisting of an indexed
collection of tuple functions {K(r)
τr
−→tupA(σ(r)) | r ∈R}.
Hence, we can think of a lax structure M = ⟨E, σ, τ, A⟩as extending the FOLE
schema R
σ
−→List(X) to the tabular interpretation function R
TM
−−−→Tbl(A).
Proposition 2. A (lax) S-structure M = ⟨E, σ, τ, A⟩deﬁnes, is the same as,
the constraint-free aspect of a database R = ⟨R, σ, A, K, τ⟩consisting of a set
of predicate types R, a key function R
K
−−→Set, a schema S = ⟨R, σ, X⟩
with a signature function R
σ
−−→List(X), and a (constraint-free) tuple bridge
K
τ
==⇒S ◦tupA consisting of an R-indexed collection of tuple maps

K(r)
τr
−−→
tupA(σ(r)) | r ∈R
	
.
Proof. See the previous discussion.
4.5
Lax Structure Morphisms.
In order to make sound logic morphisms equivalent to database morphisms, we
need to eliminate the global key function K2
k
←−K1. To do this we deﬁne a lax
version of Def. 2. Note 1 eliminated the need for the global key function in the
entity infomorphism¿ Prop. 1 and Cor. 1 eliminated the need for the universe
morphism with its global key function. However, we do need to include the
condition of Prop. 1.
29 A structure becomes lax when we forget the global set of keys K and use only a
lax entity classiﬁcation E = ⟨R, K⟩. We can retrieve a “crisp” entity classiﬁcation
by deﬁning the disjoint union of key subsets `
r∈R K(r). But, using the extent
form of a structure (laxness), we have lost a certain coordination of tuple functions
{extE(r)
τr
−→tupA(σ(r)) | r ∈R
	
here, which may or may not be important.

---

24
Robert E. Kent
Deﬁnition 4. For any two (lax) structures M2 = ⟨E2, σ2, τ2, A2⟩and M1 =
⟨E1, σ1, τ1, A1⟩, a (lax) structure morphism (Tbl. 13 in § A.1) (Fig. 7)
M2 = ⟨E2, σ2, τ2, A2⟩
⟨r,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨E1, σ1, τ1, A1⟩= M1
consists of (RHS Fig. 7) a schemed domain morphism
D2 = ⟨R2, σ2, A2⟩
⟨r, `ϕ,f,g⟩
−−−−−−→⟨R1, σ1, A1⟩= D1
consisting of a typed domain morphism A2
⟨f,g⟩
−−−⇀
↽−−−A1 and a schema morphism
S2 = ⟨R2, σ2, X2⟩
⟨r, `ϕ,f⟩
======⇒⟨R1, σ1, X1⟩= S1 (Disp.6 in § 4.2) with common
type function X2
f−−→X1, and (LHS Fig. 7) a lax entity infomorphism
E2 = ⟨R2, K2⟩
⟨r,κ⟩
↽−−−⟨R1, K1⟩= E1
with a predicate function R2
r
−→R1 and a key bridge K2
κ
⇐== r ◦K1 consisting of
the key functions

K2(r2)
κr2
←−−K1(r(r2)) | r2 ∈R2
	
, which satisfy the condition
n
κr2 · τ2,r2 = τ1,r(r2) · tupA1( `ϕr2) · `τ⟨f,g⟩(σ2(r2)) | r2 ∈R2
o
.30
(7)
See the (Key) Prop. 1.
Corollary 2. A (lax) structure morphism M2
⟨r,κ, `ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−M1 deﬁnes a tabular
interpretation bridge function R2
ξ
−→mor(Tbl), which maps a predicate symbol
r2 ∈R2 with image r(r2) ∈R1 to the table morphism
T2(r2)
z
}|
{
⟨σ2(r2), A2, K2(r2), τ2,r2⟩
ξr2
←−−−−−−−−
⟨`
ϕr2 ,f,g,κr2 ⟩
T1(r(r2))
z
}|
{
⟨σ1(r(r2)), A1, K1(r(r2)), τ1,r(r2)⟩.
(8)
visualized by the diagram
K2(r2)
K1(r(r2))
tupA2(σ2(r2))
tupA1(P
f(σ2(r2)))
tupA1(σ1(r(r2)))
κr2
`τ⟨f,g⟩(σ2(r2))
tupA1 ( `ϕr2)
tup( `ϕr2, f, g)
τr2
τ ′
r1
✛
✛
✛
❄
❄
✡
✻
✠
source
table






































target
table
where
30 This is the constraint-free aspect of the database morphism condition
κ • τ2 = (Rop◦τ1) • ( `ϕop◦tupA1) • (S op
2
◦`τ⟨f,g⟩).
See Def. 16 in § 7.2

---

FOLE Equivalence
25
• T2(r2) = ⟨σ2(r2), A2, K2(r2), τ2,r2⟩is a table deﬁned by the tabular interpreta-
tion function R2
T2
−−→Tbl(A2) of structure M2, and
• T1(r(r2)) = ⟨σ1(r(r2)), A1, K1(r(r2)), τ1,r(r2)⟩is the table deﬁned by the tabular
interpretation function R1
T1
−−→Tbl(A1) of structureM1.
Proof. See Disp. 7 above.
Let
˚
Struc denote the mathematical context of (lax) structures and their mor-
phisms. Since any structure is a lax structure and any structure morphism is a
lax structure morphism, there is an passage Struc
lax
−−−→
˚
Struc.
r ◦K1
K2
r ◦σ1 ◦tupA1
σ2 ◦tupA2
( `ϕ ◦tupA1) • (σ2 ◦`τ⟨f,g⟩)
r ◦τ1
τ2
κ
=====⇒
=====⇒
www
www
P
f ◦tupA1
tupA2
`τ⟨f,g⟩
www
lax entity
infomorphism
tuple attribute
infomorphism
Fig. 7. Lax Structure Morphism

---

26
Robert E. Kent
5
FOLE Speciﬁcations.
A FOLE speciﬁcation R = ⟨R, S⟩consists of a context R of predicates linked
by constraints and a diagram S : R →Set of lists. A speciﬁcation morphism
is a diagram morphism ⟨R, ζ⟩: ⟨R2, S2⟩⇒⟨R1, S1⟩consisting of a shape-
changing passage R2
R
−−→R1 and a bridge ζ : S2 ⇒R ◦S1. Composition is
component-wise. The mathematical context of FOLE speciﬁcations is denoted by
SPEC = List
⇓=
 (-) ⇓List

. The subcontext of FOLE speciﬁcations (with ﬁxed
sort sets and ﬁxed sort functions) is denoted by Spec ⊆SPEC.
5.1
Speciﬁcations.
Assume that we are given a schema S = ⟨R, σ, X⟩with a set of predicate symbols
R and a signature (header) map R
σ−→List(X).
Deﬁnition 5. A (formal) S-speciﬁcation is a subgraph R ⊑Cons(S), whose
nodes are S-formulas and whose edges are S-constraints. 31
Let Spec(S) = ℘Cons(S) denote the set of all S-speciﬁcations. 32
Deﬁnition 6. An (abstract) S-speciﬁcation T = ⟨R, S, X⟩33 consists of: a
context R, whose objects r ∈R are predicate symbols and whose arrows r′
p−→r
are called abstract S-constraints, and a passage R
S
−−→List(X), which extends
the signature map R
σ
−−→List(X) by mapping an abstract constraint r′
p
−→r
to an X-signature morphism S(r′) = σ(r′) = ⟨I′, s′⟩
S(p)=σ(p)
−−−−−−−→
h
⟨I, s⟩= σ(r) =
S(r).
An abstract S-speciﬁcation T = ⟨R, S, X⟩has a companion formal S-speciﬁcation
bT = ⟨bR, bS, X⟩, whose graph bR ⊑Cons(S) is the set of all formal constraints

r′
σ(p)
−−−→
h
r | r′
p−→r ∈R
	
. 34 Since bR is closed under composition and
contains all identities, bT is an abstract S-speciﬁcation with signature passage
bR
bS−→List(X).
...
31 We can place axiomatic restrictions on speciﬁcations in various manners. A FOLE
speciﬁcation requires entailment to be a preorder, satisfying reﬂexivity and transi-
tivity. It could also require satisfaction of suﬃcient axioms (Tbl. 3 of the paper [10])
to described the various logical operations (connectives, quantiﬁers, etc.) used to
build formulas in ﬁrst-order logic.
32 For any graph G, ℘G = ⟨℘G, ⊑⟩denotes the power preorder of all subgraphs of G.
33 An abstract speciﬁcation is also known as a database schema (Def. 13 in § 7.1).
34 These are formal constraints, since any predicate symbol is a formula.

---

FOLE Equivalence
27
5.2
Speciﬁcation Morphisms.
A FOLE (abstract) speciﬁcation morphism in Spec, with constant sort function
f : X2 →X1, is a diagram morphism ⟨R, ζ⟩: ⟨R2, S2⟩→⟨R1, S1⟩in List
consisting of a relation passage R : R2 →R1 and a list interpretation bridge
S2
ζ==⇒R ◦S1 that factors (Fig. 8)
ζ = ( `ϕ ◦incX1) • (S2 ◦`ιf)
(9)
through the ﬁber adjunction List(X2)
´
listf ⊣
`
list f
←−−−−−−−List(X1) 35 in terms of
• some bridge `ϕ : S2 ◦P
f ⇒Rop ◦S1 and
• the inclusion bridge `ιf : incX2 ⇒P
f ◦incX1.
We normally just use the bridge restriction `ϕ for the speciﬁcation morphism.
The original deﬁnition can be computed with the factorization in Disp. 9.
Deﬁnition 7. An (abstract) speciﬁcation morphism (Tbl. 13 in § A.1) 36 37
T2 = ⟨R2, S2, X2⟩
⟨R, `
ϕ,f⟩
−−−−−→⟨R1, S1, X1⟩= T1,
along a schema morphism (Disp.6 in § 4.2) consists of a relation passage R2
R
−−→
R1 extending the predicate function R2
r
−→R1 of the schema morphism to con-
straints, the sort function X2
f
−−→X1 of the schema morphism, and a bridge
S2 ◦P
f
`ϕ
==⇒R ◦S1 extending the schema bridge to naturality. 38 39
As noted before, Spec ⊆SPEC denotes the mathematical context of abstract
FOLE speciﬁcations (with ﬁxed sort sets). This context is the same as the context
of database schemas and their morphisms.
There is an (abstract) S-speciﬁcation morphism (LHS Fig. 9 in § 5.3)
T = ⟨R, S, X⟩
R
−−→⟨bR, bS, X⟩= bT
with a object-identical passage R
R
−−→bR that preserves signature
R
R
−−→bR
bS−→List(X) = R
S−→List(X).
35 Fibered by signature over the adjunction List(X2)
⟨´
listf⊣`
listf ⟩
←−−−−−−−
⟨P
f ⊣f∗⟩
List(X1) (Kent [11])
representing list ﬂow along a sort function f : X2 →X1.
36 Visualized on the right side Fig. 8.
37 This is the same as a database schema morphism of § 7.2.
38 Naturality means that for any source constraint r′
2
p2
−−→r2 with target constraint
R(r′
2) = r(r′
2)
p1
−−−−→
R(p2) r(r2) = R(r2), if their signature morphisms are ⟨I′
2, s′
2⟩
h2
−−→
⟨I2, s2⟩and ⟨I′
1, s′
1⟩
h1
−−→⟨I1, s1⟩, we have the naturality diagram P
f(h2) ◦`ϕr2 =
`ϕr′
2 ◦h1.
39 An example of a non-trivial bridge is projection: assume that the arity functions
I′
2
`
ϕr′
2֒
−−→I′
1 and I2
`
ϕr2֒
−−→I1 are inclusion, thus deﬁning signature projection, and assume
that I′
2
h2
−−→I2 is a restriction of I′
1
h1
−−→I1.

---

28
Robert E. Kent
R2
R1
List
R
S2
S1
ζ
==⇒
✲
❫
✢
=
R2
R1
List(X2)
List(X1)
List
R
S2
S1
P
f
incX2
incX1
`ϕ
=⇒
`ιf
==⇒
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
Fig. 8. Speciﬁcation Morphism
5.3
Speciﬁcation Satisfaction.
Assume that we are given a schema S = ⟨R, σ, X⟩with a set of predicate symbols
R and a signature (header) map R
σ−→List(X).
Deﬁnition 8. (formal satisfaction) An S-structure M ∈Struc(S) satisﬁes a
(formal) S-speciﬁcation T = ⟨R, S, X⟩, symbolized M |=S T , when it satisﬁes
every constraint in the speciﬁcation: M |=S T iﬀMS ⊒R. Hence, MS is the
largest and most specialized (formal) S-speciﬁcation satisﬁed by M. 40
Deﬁnition 9. (abstract satisfaction) An S-structure M ∈Struc(S) satisﬁes
an abstract S-constraint r′
p−→r in R, symbolized by M |=S (r′
p−→r), when it
satisﬁes the associated formal constraint r′
σ(p)
−−−→r in bR. An S-structure M ∈
Struc(S) satisﬁes (is a model of) an abstract S-speciﬁcation T = ⟨R, S, X⟩,
symbolized M |=S T , when it satisﬁes every abstract constraint in the speci-
ﬁcation. Equivalently, an S-structure M ∈Struc(S) satisﬁes an abstract S-
speciﬁcation T = ⟨R, S, X⟩when it satisﬁes the companion formal speciﬁcation
bT = ⟨bR, bS, X⟩: M |=S T iﬀMS ⊒bR.
Deﬁnition 10. When M |=S T holds, the abstract table passage Rop T
−−→Rel(A)
is deﬁned to be the composition (RHS Fig. 9) of the object-identical passage
R
R
−−→bR with the “inclusion” bR ⊑MS and the relation interpretation pas-
sage MSop
RM
−−−→Rel(A) of Lem. 2 in § 3.3. 41
Note that the the abstract table passage Rop
T
−−→Rel(A) extends the table-
valued function R
TM
−−→Tbl(A)
imA֒
−−−→Rel(A) of the structure M to constraints.
Proposition 3 (Key). Satisfaction is equivalent to tabular interpretation.
Proof. On the one hand, if M |=S T , then the tabular interpretation passage
Rop T
−−→Rel(A)
incA֒
−−−→Tbl(A) maps a constraint r′
p
−→r in R to the A-relation
40 So, MS is not just a mathematical context, but also an S-speciﬁcation.
41 The passage MS op
RM
−−−→Rel(A) was deﬁned in Lemma. 2 of § 3.3 on satisfaction.

---

FOLE Equivalence
29
morphism
T(r′) = ⟨S(r′), ℘t′
r′(K(r′))⟩
T(p)
←−−−−
⟨hp,rp⟩⟨S(r), ℘tr(K(r))⟩= T(r)
as pictured in Fig. 3 of §3.3. 42
On the other hand, if there is a tabular interpretation passage Rop
T
−−→
Tbl(A), then the adjoint ﬂow of A-tables 43 demonstrates that the S-structure
M satisﬁes each abstract S-constraint r′
p−→r in R (see Disp.4 in § 3.3).
R
bR
Cons(S)
List(X)
R
inc
S
bS
SS
✲
✲
✄✂
❅
❅
❅
❘
❄
   ✠
Rop
bRop
MSop
Rel(A)
incA֒
−−−→Tbl(A)
Rop
inc
T
bT
RM
✲
✲
✄✂
❅
❅
❅
❘
❄
   ✠
in general
with satisfaction
Fig. 9. Speciﬁcation Passages
Speciﬁcation
(formal) S-speciﬁcation – subgraph
:
R ⊑Cons(S)
signature passage
:
Cons(S) →List(X)
(abstract) S-speciﬁcation – passage
:
R
S
−−→List(X)
Sound Logic
(formal) S-speciﬁcation – subgraph
:
R ⊑MS
table passage
:
MS op RM
−−−→Rel(A)
incA֒
−−−→Tbl(A)
(abstract) S-speciﬁcation – table passage
:
Rop
T
−−→Rel(A)
incA֒
−−−→Tbl(A)
Table 7. Comparisons
42 We use relations here rather than tables, since (Lem. 2 of § 3.3): relational inter-
pretation is closed under composition; but tabular interpretation is closed under
composition only up to key equivalence.
43 See the discussion about type domain indexing in § 3.4.1 of the paper [11].

---

30
Robert E. Kent
6
FOLE Sound Logics.
6.1
Sound Logics.
Deﬁnition 11. A (lax) sound logic L = ⟨S, M, T ⟩with a schema S = ⟨R, σ, X⟩,
consists of a (lax) S-structure M = ⟨E, σ, τ, A⟩and an (abstract) S-speciﬁcation
T = ⟨R, S, X⟩, where the structure M satisﬁes the speciﬁcation T : M |=S T .
Proposition 4. Any (lax) FOLE sound logic L = ⟨S, M, T ⟩deﬁnes a FOLE re-
lational database with constant type domain R = ⟨R, T, A⟩. 44
Proof. By the deﬁnition of satisfaction (Def. 9 and Def. 10 in § 5.3), the tabular
interpretation R
T−→Tbl(A) (Def. 3 of § 4.4) extends to a table passage Rop T
−→
Rel(A) ⊆Tbl(A), which forms a relational database R = ⟨R, T, A⟩.
L = ⟨S, M, T ⟩
sound logic
schema
S = ⟨R, σ, X⟩
signature function
R
σ
−−→List(X)
(lax) S-structure
M = ⟨E, σ, τ, A⟩
(lax) entity classiﬁcation
E = ⟨R, K⟩
attribute classiﬁcation
A = ⟨X, Y, |=A⟩
tuple bridge
K
τ
==⇒σ ◦tupA
table function
R
TM
−−−→Tbl(A)
S-speciﬁcation
T = ⟨R, S, X⟩
signature passage
R
S
−−→List(X)
satisfaction
M |=S T
table passage
Rop
T
−−→Rel(A)
incA֒
−−−→Tbl(A)
Table 8. Sound Logic
44 A (lax) FOLE sound logic is described in terms of its components in Tbl. 8. In § 7.1,
a FOLE relational database is deﬁned in Def. 13 and is described in terms of its
components in Tbl. 10.

---

FOLE Equivalence
31
6.2
Sound Logic Morphisms.
Deﬁnition 12. For any two sound logics L2 = ⟨S2, M2, T2⟩and L1 = ⟨S1, M1, T1⟩,
a (lax) sound logic morphism (Tbl. 13 in § A.1)
L2 = ⟨S2, M2, T2⟩
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨S1, M1, T1⟩= L1
consists of a (lax) structure morphism
M2 = ⟨E2, ⟨σ2, τ2⟩, A2⟩
⟨r,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨E1, ⟨σ1, τ1⟩, A1⟩= M1 and
an (abstract) speciﬁcation morphism
T2 = ⟨R2, S2, X2⟩
⟨R, `
ϕ,f⟩
−−−−−→⟨R1, S1, X1⟩= T1
along a common schema morphism
S2 = ⟨R2, σ2, X2⟩
⟨r, `
ϕ,f⟩
=====⇒⟨R1, σ1, X1⟩= S1.
Let
˚
Snd denote the context of (lax) sound logics and their morphisms.
Note 2. At this point we know that a (lax) sound logic morphism
L2 = ⟨S2, M2, T2⟩
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨S1, M1, T1⟩= L1
has tabular interpretation passages R2
T2
−−→Rel(A2) ⊆Tbl(A2) and R1
T1
−−→
Rel(A1) ⊆Tbl(A1) at the source and target sound logics and a predicate
passage R2
R
−−→R1. We complete the picture in Prop. 5 by proving that sound
logic morphisms preserve satisfaction in some way.
Proposition 5. There is a (tabular interpretation) bridge
ξ = ( `ψ ◦incA1) • (T2 ◦`χ⟨f,g⟩) : T2 ⇐Rop◦T1
that extends the collection of tabular interpretation bridge functions

T2(r2)
ξr2
←−−−−−−−−−
⟨`ϕr2,f,g,κr2⟩T1(r(r2)) | r2 ∈R2
	
(see Cor. 2 of § 4.5) to constraints:
for any source constraint r′
2
p2
−→r2 in R2
with R-image target constraint r′
1
p1
−→r1 in R1, we have the following naturality
diagram, which represents “preservation or linkage of satisfaction”. 45
T2(r′
2)
T1(r′
1)
T2(r2)
T1(r1)
ξr′
2
⟨`ϕr′
2, f, g, κr′
2⟩
ξr2
⟨`ϕr2, f, g, κr2⟩
T2(p2)
T1(p1)
✛
✛
✻
✻
T2
ξ
⇐== R ◦T1
naturality
source
interpretation


































target
interpretation
45 The
sound
logic
morphism
L2
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−
L1
maps
the
table
morphism
T1(r′
1)
T1(p1)
←−−−−T1(r1) representing the satisfaction M1 |=S1 (r′
1
p1
−→r1) to the table
morphism T2(r′
2)
T2(p2)
←−−−−T2(r2) representing the satisfaction M2 |=S2 (r′
2
p2
−→r2).

---

32
Robert E. Kent
Proof. The above diagram is expanded into more detail in Fig. 10. To understand
extE2(r′
2)
extE1(r′
1)
tupA2(σ2(r′
2))
tupA1(P
f(σ2(r′
2)))
tupA1(σ1(r′
1))
κr′
2
`τ⟨f,g⟩(σ2(r′
2))
tupA1 ( `ϕr′
2)
tup( `ϕr′
2, f, g)
τr′
2
τr′
1
✛
✛
✛
❄
❄
✡
✻
✠
kp2
kp1
tupA2 (hp2)
tupA1 (P
f (hp2))
tupA1(hp1)
❙
❙
❙♦
❙
❙
❙♦
❙
❙
❙♦
❙
❙
❙♦
❙
❙
❙♦
extE2(r2)
extE1(r1)
tupA2(σ2(r2))
tupA1(P
f(σ2(r2)))
tupA1(σ1(r1))
κr2
`τ⟨f,g⟩(σ2(r2))
tupA1 ( `ϕr2)
tup( `ϕr2, f, g)
τr2
τ ′
r1
✛
✛
✛
❄
❄
✡
✻
✠
Fig. 10. Naturality Combined
this, we discuss each part (facet) separately. In short: the front/back is due to
Cor. 2 in § 4.5 for (lax) structure morphisms; the left/right hold by satisfaction of
source/target sound logics; the bottom-right is due to the (abstract) speciﬁcation
morphism; the bottom-left is due to naturality of tupA2
`τ⟨f,g⟩
⇐===== Pop
f ◦tupA1;
and the top holds for relations. We now discuss each facet in more detail.
front/back: For each source predicate r2 ∈R2, the (lax) structure morphism M2
⟨r,κ, `ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−
M1 deﬁnes (Cor. 2 of § 4.5) the table morphism
⟨
Sσ(r2), A2,
K
extE2(r2), τr2⟩
T2(r2)
⟨`
ϕr2 ,f,g,κr2 ⟩
←−−−−−−−−−−
ξr2
⟨
Sσ(r1), A1,
K
extE1(r1), τr1⟩
T1(R(r2))
(same for r′
2 ∈R2).
left/right (sat): Satisfaction for source/target sound logics (§ 5.3) deﬁne table morphisms
⟨σ(r′
i), extE(r′
i), τr′
i⟩
⟨hpi ,kpi ⟩
←−−−−−−−
Ti(pi)
⟨σ(ri), extE(ri), τri⟩,
which are equivalent to naturality of the bridges Ki
τi
=====⇒
Ti ◦τAi
S op
i ◦tupAi.
bottom right: The structure and speciﬁcation morphisms have the same underlying schema
morphism S2 = ⟨R2, σ2, X2⟩
⟨r, `ϕ,f⟩
=====⇒⟨R1, σ1, X1⟩= S1. Apply the tuple
function tupA1 to the naturality of the bridge S2 ◦P
f
`ϕ
==⇒R ◦S1 for any
abstract S-constraint r′
2
p2
−−→r2 in R2: for any constraint r′
2
p2
−→r2 in R2,
the following diagram commutes.

---

FOLE Equivalence
33
P
f(σ2(r′
2))
σ1(r′
1)
P
f(σ2(r2))
σ1(r′
1)
`ϕr′
2
`ϕr′
2
`ϕr2
`ϕr2
P
f (hp2) = hp2
hp1
✲
✲
✻
✻
`ϕ naturality
bottom left: The tuple bridge tupA2
`τ⟨f,g⟩
⇐===== Pop
f ◦tupA1 of the type domain morphism
A2
⟨f,g⟩
−−−⇀
↽−−−A1 (see footnote 27 in § 4.2) satisﬁes naturality: for any constraint
r′
2
p2
−→r2 in R2, the following diagram commutes.
tupA2(σ2(r2))
tupA1(P
f(σ2(r2)))
tupA2(σ2(r2))
tupA1(P
f(σ2(r2)))
`τ⟨f,g⟩(σ2(r2))
(-) · g
(-) · g
`τ⟨f,g⟩(σ2(r2))
kp2
kp1
✛
✛
✻
✻
`τ⟨f,g⟩naturality
top: By the other naturality conditions just proven, for any constraint r′
2
p2
−→r2 in
R2 with R-image r′
1
p1
−→r1 in R1, we know that kp1 · κr′
2 · τr′
2 = κr2 · kp2 · τr′
2.
If the tuple map extE2(r′
2)
τr′
2
−−→tupA2(σ2(r′
2)) were injective, the bridge
K2
extE2
κ
⇐==
Rr ◦
K1
extE1 would satisfy “extent naturality”:
extE2(r′
2)
extE1(r′
1)
extE2(r2)
extE1(r1)
κr′
2
k
k
κr2
kp2
kp1
✛
✛
✻
✻
κ naturality
Here, we use the image part of the table-relation reﬂection ⟨im ⊣inc⟩:
Tbl ⇄Rel. 46 Then, we use diagonal ﬁll-in Fig. 10. Hence, extent naturality
holds for the relational interpretation into Rel.
46 The reﬂection ⟨im ⊣inc⟩: Tbl ⇄Rel (“The FOLE Table”[11]) of the context of
relations into the context of tables embodies the notion of “informational equiva-
lence”.

---

34
Robert E. Kent
Proposition 6. A (lax) sound logic morphism
L2 = ⟨S2, M2, R2⟩
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨S1, M1, R1⟩= L1
deﬁnes a database morphism
R2 = ⟨R2, S2, A2, K2, τ2⟩
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−→
⟨R,ξ⟩
⟨R1, S1, A1, K1, τ1⟩= R147
whose tabular interpretation bridge T2
ξ
⇐== R ◦T1 factors
ξ = ( `ψ ◦incA1) • (T2 ◦`χ⟨f,g⟩)
through the ﬁber adjunction Tbl(A2)
´
tbl ⟨f,g⟩⊣`
tbl ⟨f,g⟩
←−−−−−−−−−−−Tbl(A1).
Proof. By Prop. 4 the sound logics L2 and L1 deﬁne two databases R2 and
R1. By Prop.5 the (lax) sound logic morphism
L2
⟨R,κ, `ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−L1
deﬁnes
a database morphism ⟨R2, T2⟩
⟨R,ξ⟩
←−−−⟨R1, T1⟩, whose tabular interpretation
bridge T2
ξ
⇐== R ◦T1 factors as above.
Theorem 1. There is a passage
˚
Snd
op
˚
db
−−→Db.
Proof. A sound logic L = ⟨S, M, T ⟩is mapped to its associated database R =
⟨R, K, S, τ, A⟩by Prop. 4. A sound logic morphism L2
⟨R,k, `ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−L1 is mapped
to its associated database morphism R2
⟨R,κ, `ϕ,f,g⟩
−−−−−−−→R1 by Prop. 6.
sound logic morphism
L2 = ⟨S2, M2, T2⟩
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨S1, M1, T1⟩= L1
• schema morphism
S2 = ⟨R2, σ2, X2⟩
⟨r, `
ϕ,f⟩
======⇒⟨R1, σ1, X1⟩= S1
• (lax) struc morph
M2 = ⟨
E2
⟨R2, K2⟩, σ2, τ2, A2⟩
⟨r,κ, `
ϕ,f,g⟩
−−−−−−−−⇀
↽−−−−−−−−⟨
E1
⟨R1, K1⟩, σ1, τ1, A1⟩= M1
◦type domain morphism
A2 = ⟨X2, Y2, |=A2 ⟩
⟨f,g⟩
−−−−⇀
↽−−−−⟨X1, Y1, |=A1⟩= A1
◦(lax) entity infomorphism
K2 = ⟨R2, K2⟩
⟨R,κ⟩
−−−−−→⟨R1, K1⟩= K1
which satisfy the constraint
κ • τ2 = (Rop◦τ1) • ( `ϕop◦tupA1) • (S op
2
◦`τ⟨f,g⟩)
• speciﬁcation morphism
T2 = ⟨R2, S2, X2⟩
⟨R, `
ϕ,f⟩
−−−−−→⟨R1, S1, X1⟩= T1
Table 9. Sound Logic Morphism
47 See Def. 16 and Tbl. 11 in § 7.2.

---

FOLE Equivalence
35
7
FOLE Databases.
A FOLE relational database R = ⟨R, T⟩consists of a context R of predicates
linked by constraints and an interpretation diagram T : Rop →Tbl of tables. A
relational database morphism ⟨R, ξ⟩: ⟨R2, T2⟩←⟨R1, T1⟩(Tbl. 13 in § A.1) is a
diagram morphism (LHS Fig. 12 in § 7.2) consisting of a shape-changing passage
R2
R
−−→R1 and a bridge ξ : T2 ⇐Rop ◦T1. Composition is component-wise.
The mathematical context of FOLE relational databases is denoted by DB =
Tbl
⇓=
 (-)op⇓Tbl

. 48
7.1
Databases.
Deﬁnition 13. A FOLE database R = ⟨R, T, A⟩, with constant type domain A,
is a database with an interpretation diagram T : Rop →Tbl(A)֒ →Tbl that
factors through the context of A-tables.
Rop
Tbl(A)
List(X)op
Set
T
K
key A
signop
A
S op
tupA
τA
=⇒
❄
❅❅
❘
  ✠
❘❘
❄
Fig. 11. Database: Type Domain
Deﬁnition 14. Using A-table projection passages 49 (Fig. 11), a database R =
⟨R, K, S, τ, A⟩, with constant type domain A, consists of
• a context R of predicates,
• a relational database schema S = ⟨R, S, X⟩with signature diagram S =
T op◦signA : R →List(X),
• a key diagram K = T ◦key A : Rop →Set, and
• a tuple bridge τ = T ◦τA : K ⇒S op◦tupA.
48 See § 4.2.1 in the paper “The FOLE Database” [12].
49 See § 3.4.1 of the paper “The FOLE Table” [11].

---

36
Robert E. Kent
R = ⟨R, T, A⟩
relational database
predicate context
R
type domain (attribute classiﬁcation)
A = ⟨X, Y, |=A⟩
table passage
Rop
T
−−→Tbl(A)
R = ⟨R, S, K, τ, A⟩
database schema (speciﬁcation)
T = ⟨R, S, X⟩
signature passage
R
S
−−−−−−−→
T op◦signA
List(X)
key passage
Rop
K
−−−−−−→
T ◦keyA
Set
tuple bridge
K
τ
====⇒
T ◦τA
S op◦tupA
Table 10. Relational Database
Proposition 7. The constraint-free aspect of a FOLE database R = ⟨R, K, S, τ, A⟩,
with constant type domain A, is the same as a (lax) FOLE structure M =
⟨E, σ, τ, A⟩in
˚
Struc.
Proof. We deﬁne the various components of the (lax) structure M = ⟨E, σ, τ, A⟩
listed in Def. 3 of § 4.4 and pictured in Fig. 4 of § 4.1.
A: The attribute classiﬁcation (typed domain) A = ⟨X, Y, |=A⟩is given.
σ: The schema (type hypergraph) S = ⟨R, σ, X⟩consists of the set R of relation
symbols (predicates) and the signature map σ : R →List(X) : r 7→σ(r) =
S(r). This is the constraint-free aspect of the database schema S = ⟨R, S, X⟩
with signature diagram S : R →List(X).
E: The (lax) entity classiﬁcation E = ⟨R, K⟩consists of the set R of relation
symbols (predicates) and the key function R
K
−→Set. This is the constraint-
free aspect of the key diagram Rop
K
−→Set.
τ: The tuple bridge τ : K ⇒σ ◦tupA is the constraint-free aspect of the tuple
bridge τ : K
τ=⇒S op◦tupA.
Proposition 8. Any FOLE database R = ⟨R, T, A⟩= ⟨R, K, S, τ, A⟩in Db(A)
deﬁnes a (lax) FOLE sound logic L = ⟨S, M, T ⟩in
˚
Snd.
Proof. The schema S = ⟨R, σ, X⟩is the structure schema (mentioned above),
the constraint-free aspect of the database schema ⟨R, S, X⟩. The S-structure
M = ⟨E, σ, τ, A⟩is deﬁned in Prop. 7 above. The (abstract) S-speciﬁcation
T = ⟨R, S, X⟩is the same as the database schema, as discussed in § 5.1. By
Prop 3 in § 5.3, the tabular interpretation passage Rop T
−→Tbl(A) demonstrates
satisfaction M |=S T .

---

FOLE Equivalence
37
7.2
Database Morphisms.
A FOLE database morphism, with constant type domain morphism ⟨f, g⟩: A2 ⇄
A1, is a FOLE database morphism ⟨R, ξ⟩: ⟨R2, T2⟩←⟨R1, T1⟩, whose tabular
interpretation bridge T2
ξ
⇐== R ◦T1 factors (Fig. 12)
ξ = ( `ψ ◦incA1) • (T2 ◦`χ⟨f,g⟩)
(10)
through the ﬁber adjunction Tbl(A2)
´
tbl⟨f,g⟩⊣`
tbl ⟨f,g⟩
←−−−−−−−−−−−Tbl(A1) 50 in terms of
• some bridge `ψ : T2 ◦`
tbl ⟨f,g⟩⇐Rop ◦T1 and
• the inclusion bridge `χ⟨f,g⟩: incA2 ⇐`
tbl ⟨f,g⟩◦incA1
51 .
We normally just use the bridge restriction `ψ for the database morphism. The
original deﬁnition can be computed with the factorization in Disp. 10.
Rop
2
Rop
1
Tbl
Rop
T2
T1
ξ
⇐===
✲
❫
✢
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
tbl⟨f,g⟩
incA2
incA1
`ψ
⇐=
`χ⟨f,g⟩
⇐====
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
Fig. 12. Database Morphism
The inclusion bridges for the table ﬁber adjunction 52
Tbl(A2)
Tbl(A1)
´
tbl⟨f,g⟩
`
tbl⟨f,g⟩
η⟨f,g⟩⊣ε⟨f,g⟩
✛
✲
50
There is a table ﬁber adjunction Tbl(A2)
⟨´
tbl ⟨f,g⟩⊣`
tbl⟨f,g⟩⟩
←−−−−−−−−−−−Tbl(A1) representing
tabular ﬂow along a type domain morphism A2
⟨f,g⟩
−−−⇀
↽−−−A1. See § 3.4.2 of Kent [11].
The ﬁber passage Tbl(A2)
´
tbl⟨f,g⟩
←−−−−−Tbl(A1) is deﬁne in terms of the tuple bridge
f ∗op◦tupA2
´τ⟨f,g⟩
⇐===== tupA1 and the substitution function List(X2)
f∗
←−−List(X1).
The adjoint ﬁber passage Tbl(A2)
`
tbl⟨f,g⟩
−−−−−→Tbl(A1) is deﬁne in terms the adjoints,
the tuple bridge tupA2
`τ⟨f,g⟩
⇐===== Pop
f ◦tupA1 and the existential quantiﬁer function
List(X2)
P
f
−−→List(X1).
51 Equivalently, in terms of their levo bridge adjoints in Tbl. 12 of § A.1.
52 Notation from § 3.4.2.

---

38
Robert E. Kent
levo
dextro
Tbl(A2)
Tbl(A1)
Tbl
´
tbl⟨f,g⟩
incA2
incA1
´χ⟨f,g⟩
⇐=
✛
❙
❙❙✇
✓
✓
✓✴
Tbl(A2)
Tbl(A1)
Tbl
`
tbl ⟨f,g⟩
incA2
incA1
`χ⟨f,g⟩
⇐=
✲
❙
❙❙✇
✓
✓
✓✴
A2
⟨f,g⟩
−−−−⇀
↽−−−−A1
levo
dextro
´χ⟨f,g⟩: ´
tbl ⟨f,g⟩◦incA2 ⇐incA1
`χ⟨f,g⟩: incA2 ⇐`
tbl ⟨f,g⟩◦incA1
´χ⟨f,g⟩= (η⟨f,g⟩◦incA1 ) • ( ´
tbl ⟨f,g⟩◦`χ⟨f,g⟩)
`χ⟨f,g⟩= ( `
tbl⟨f,g⟩◦´χ⟨f,g⟩) • (ε⟨f,g⟩◦incA2)
Fig. 13. Inclusion Bridge: Tables
are deﬁned by
´
tbl ⟨f,g⟩(T1)
z
}|
{
⟨f ∗(I1, s1), P
´τ⟨f,g⟩(I1,s1)(K1, t1)⟩
´χ⟨f,g⟩(T1)
←−−−−−−−−−−−−−
⟨εf (I1,s1),f,g,1K1 ⟩
T1
z
}|
{
⟨I1, s1, K1, t1⟩,
T2
z
}|
{
⟨I2, s2, K2, t2⟩
`χ⟨f,g⟩(T2)
−−−−−−−→
⟨1I2 ,f,g,ˆk⟩
`
tbl ⟨f,g⟩(T2)
z
}|
{
⟨P
f(I2, s2), (`τ⟨f,g⟩(I2, s2))∗(K2, t2)⟩.

---

FOLE Equivalence
39
Deﬁnition 15. For any two databases R2 = ⟨R2, T2, A2⟩and R1 = ⟨R1, T1, A1⟩,
a database morphism, with constant type domain morphism A2
⟨f,g⟩
−−−⇀
↽−−−A1, (Fig. 12)
R2 = ⟨R2, T2, A2⟩
⟨R, `ψ,f,g⟩
←−−−−−−⟨R1, T1, A1⟩= R1
(Tbl. 13 in § A.1) consists of a shape-changing relation passage R : R2 →R1
and a bridge `ψ : T2 ◦`
tbl⟨f,g⟩⇐Rop ◦T1.
The subcontext of FOLE relational databases (with constant type domains and
constant type domain morphisms) is denoted by Db ⊆DB. 53
53 See § 4.2.2 in the paper “The FOLE Database” [12].

---

40
Robert E. Kent
Deﬁnition 16. Using projections (Fig. 14), a FOLE database morphism, with
constant type domain morphism A2
⟨f,g⟩
−−−⇀
↽−−−A1,
R2 = ⟨R2, S2, A2, K2, τ2⟩
⟨R,κ, `
ϕ,f,g⟩
←−−−−−−−⟨R1, S1, A1, K1, τ1⟩= R1
(Tbl. 13 in § A.1) consists of a relation passage R2
R
−−→R1 as above, and
• a schema bridge `ϕ = `ψop◦sign : S2 ◦P
f ⇒R ◦S1 54 , and
• a key bridge κ = `ψ ◦key : K2 ⇐Rop◦K1 consisting of an R2-indexed
collection {K2(r2)
κr2
←−−K1(r(r2)) | r2 ∈R2} of key functions. 55
These components satisfy the condition
κ • τ2 = (Rop◦τ1) • ( `ϕop◦tupA1) • (S op
2
◦`τ⟨f,g⟩),
(11)
as pictured in the following bridge diagram.
Rop◦K1
K2
Rop◦S op
1 ◦tupA1
S op
2 ◦tupA2
( `ϕop◦tupA1 ) • (S op
2 ◦`τ⟨f,g⟩)
Rop◦τ1
τ2
κ
=====⇒
=====⇒
www
www
P op
f ◦tupA1
tupA2
`τ⟨f,g⟩
www
lax entity
infomorphism
tuple attribute
infomorphism
R2 = ⟨R2, K2, S2, τ2, A2⟩
⟨R,κ, `
ϕ,f,g⟩
←−−−−−−−⟨R1, K1, S1, τ1, A1⟩= R1
• schema bridge
`ϕ : S2 ◦P
f ⇒R ◦S1
• a key bridge
κ : K2 ⇐Rop◦K1
• constraint
κ • τ2 = (Rop◦τ1) • ( `ϕop◦tupA1) • (S op
2
◦`τ⟨f,g⟩)
Table 11. Database Morphism
54 This deﬁnes a database schema morphism
T2 = ⟨R2, S2, X2⟩
⟨R, `
ϕ,f⟩
−−−−−⇀
↽−−−−−⟨R1, S1, X1⟩= T1,
which is the same as the (abstract) speciﬁcation morphism in Def. 7 of § 5.2.
55 This deﬁnes a lax entity infomorphism K2
κ
⇐== r ◦K1 consisting of an R2-indexed
collection of key functions

K2(r2)
κr2
←−−K1(r(r2)) | r2 ∈R2
	

---

FOLE Equivalence
41
Rop
Pop
f
id
✲
✲
✲
✛
`ϕop
⇐=
κ
⇐=
`τ⟨f,g⟩
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
keyA2
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
Fig. 14. Database Morphism: Type Domain
Proposition 9. The constraint-free aspect of a FOLE database morphism
R2 = ⟨R2, S2, A2, K2, τ2⟩
⟨R,κ, `ϕ,f,g⟩
←−−−−−−−⟨R1, S1, A1, K1, τ1⟩= R1,
in Db deﬁnes, is the same as, a (lax) FOLE structure morphism
M2 = ⟨E2, σ2, τ2, A2⟩
⟨r,κ, `ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨E1, σ1, τ1, A1⟩= M1
in
˚
Struc.
Proof. We deﬁne the various components of the (lax) structure morphism above,
as deﬁned in Def.4 and pictured in Fig. 7 of § 4.5.
r: The predicate function R2
r
−→R1 is the constraint-free aspect of the relation
passage R2
R
−→R1.
⟨f, g⟩: The type domain morphism A2
⟨f,g⟩
−−−⇀
↽−−−A1 is given.
⟨r, `ϕ, f⟩: The schema morphism
S2 = ⟨R2, σ2, X2⟩
⟨r, `
ϕ,f⟩
=====⇒⟨R1, σ1, X1⟩= S1, consist-
ing of the R2-indexed collection of signature morphisms {P
f(σ2(r2))
`ϕr2
−−−→
h
σ1(r(r2)) | r2 ∈R2}, is the constraint-free aspect of the database schema
morphism in Def. 16.
⟨r, κ⟩: The lax entity infomorphism E2 = ⟨R2, K2⟩
⟨r,κ⟩
↽−−−⟨R1, K1⟩= E1, consisting
of the R2-indexed collection of key functions

K2(r2)
κr2
←−−K1(r(r2)) | r2 ∈
R2
	
, is the constraint-free aspect of the key bridge κ : K2 ⇐Rop◦K1.
These components satisfy the condition 56 57
n
κr2 · τ2,r2 = τ1,r(r2) · tupA1( `ϕr2) · `τ⟨f,g⟩(σ2(r2))
|
{z
}
tup( `ϕr2 ,f,g)
| r2 ∈R2
o
..
56 This is the constraint-free aspect of the database morphism condition
κ • τ2 = (Rop◦τ1) • ( `ϕop◦tupA1) • (S op
2
◦`τ⟨f,g⟩).
See Def. 16 above.
57 See Disp.7 in Def.4 of § 4.5.

---

42
Robert E. Kent
Proposition 10. Any FOLE database morphism
R2 = ⟨R2, S2, A2, K2, τ2⟩
⟨R,κ, `ϕ,f,g⟩
←−−−−−−−⟨R1, S1, A1, K1, τ1⟩= R1
in Db deﬁnes a (lax) FOLE sound logic morphism
L2 = ⟨S2, M2, T2⟩
⟨R,κ, `ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨S1, M1, T1⟩= L1
in
˚
Snd.
Proof. The source and target sound logics are deﬁned by Prop. 8 above. The
structure morphism is given by Prop. 9 above. The (abstract) speciﬁcation mor-
phism is the same as the database schema morphism
T2 = ⟨R2, S2, X2⟩
⟨R, `ϕ,f⟩
−−−−−⇀
↽−−−−−⟨R1, S1, X1⟩= T1,
as discussed in § 5.1.
Theorem 2. There is a passage Dbop
˚
snd
−−−→
˚
Snd.
Proof. A database R = ⟨R, T, A⟩in Db is mapped to its associated sound logic
L = ⟨S, M, T⟩by Prop. 8. A database morphism R2
⟨R,ψ,f,g⟩
←−−−−−−R1 in Db is
mapped to its associated sound logic morphism L2
⟨R,κ,α,f,g⟩
−−−−−−−⇀
↽−−−−−−−L1 by Prop. 10.
Theorem 3. The contexts of databases and (lax) sound logics form a reﬂection
Dbop
˚
Snd
im
⊣
inc
✲
✛
 ✁
,
so that these two representation of FOLE are “informationally equivalent”. 58 59
Proof. The passages in Thm. 1 and Thm. 2 form a reﬂection. Here, we use the
image part Tbl
im֒
−−→Rel of the table-relation reﬂection. 60 For an alternate
proof, ﬁrst compose with image part of the table-relation reﬂection 60, and then
restrict to ﬁxed type domains.
58 The database-logic reﬂection
Db(A)
⟨imA ⊣incA⟩
−−−−−−−−−→Log(A)
generalizes the table-relation reﬂection Tbl(A)
⟨imA ⊣incA⟩
−−−−−−−−−→Rel(A). These reﬂec-
tions embody the notion of informational equivalence.
59 See Prop. 12 in § A.1 of the paper [11] “The FOLE Table”.
60 The reﬂection ⟨im ⊣inc⟩: Tbl ⇄Rel (“The FOLE Table”[11]) of the context of
relations into the context of tables embodies the notion of “informational equiva-
lence”.

---

FOLE Equivalence
43
A
Appendix
A.1
FOLE Components
Bridges. Although adjointly equivalent, no levo bridges are used throughout this
paper, except for the levo tuple bridge f ∗op◦tupA2
´τ⟨f,g⟩
⇐===== tupA1 discussed in
footnote 50 in § 7.2.
levo
dextro
´ϕ : S2 ⇒R ◦S1 ◦f ∗
`ϕ : S2 ◦Σf ⇒R ◦S1
´ϕ = (S2 ◦ηf) • ( `ϕ ◦f ∗)
`ϕ = ( ´ϕ ◦Σf) • (R ◦S1 ◦εf)
´ϕ = ( ´ψ ◦signop
A2)op
`ϕ = ( `ψ ◦signop
A1)op
´ψ : T2 ⇐Rop ◦T1 ◦´
tbl ⟨f,g⟩
`ψ : T2 ◦`
tbl ⟨f,g⟩⇐Rop ◦T1
´ψ = ( `ψ ◦´
tbl ⟨f,g⟩) • (T2 ◦ε⟨f,g⟩)
`ψ = (Rop ◦T1)η⟨f,g⟩• ( ´ψ ◦`
tbl⟨f,g⟩)
´χ⟨f,g⟩: ´
tbl ⟨f,g⟩◦incA2 ⇐incA1
`χ⟨f,g⟩: incA2 ⇐`
tbl ⟨f,g⟩◦incA1
´χ⟨f,g⟩= (η⟨f,g⟩◦incA1) • ( ´
tbl ⟨f,g⟩◦`χ⟨f,g⟩)
`χ⟨f,g⟩= ( `
tbl ⟨f,g⟩◦χ⟨f,g⟩) • (ε⟨f,g⟩◦incA2)
´τ⟨f,g⟩: (f ∗)op ◦tupA2 ⇐tupA1
`τ⟨f,g⟩: tupA2 ⇐Pop
f ◦tupA1
´τ⟨f,g⟩= (εop
f ◦tupA1) • ((f ∗)op ◦`τ⟨f,g⟩)
`τ⟨f,g⟩= (Pop
f ◦´τ⟨f,g⟩) • (ηop
f ◦tupA2)
ξ : T2 ◦incA2 ⇐Rop ◦T1 ◦incA1
(Rop◦T1 ◦´χ⟨f,g⟩) • ( ´ψ ◦incA2) = ξ = ( `ψ ◦incA1) • (T2 ◦`χ⟨f,g⟩)
Table 12. FOLE Adjoint Bridges

---

44
Robert E. Kent
Morphisms. The FOLE equivalence is explained and understood principally in
terms of its various morphisms (Tbl. 13).
schema morphism
S2 = ⟨R2, σ2, X2⟩
⟨r, `
ϕ,f⟩
=====⇒⟨R1, σ1, X1⟩= S1
schemed domain morphism
D2 = ⟨R2, σ2, A2⟩
⟨r, `
ϕ,f,g⟩
−−−−−−→⟨R1, σ1, A1⟩= D1
(lax) structure morphism
M2 = ⟨E2, σ2, τ2, A2⟩
⟨r,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨E1, σ1, τ1, A1⟩= M1
speciﬁcation morphism
T2 = ⟨R2, S2, X2⟩
⟨R, `
ϕ,f⟩
−−−−−→⟨R1, S1, X1⟩= T1
sound logic morphism
L2 = ⟨S2, M2, T2⟩
⟨R,κ, `
ϕ,f,g⟩
−−−−−−−⇀
↽−−−−−−−⟨S1, M1, T1⟩= L1
database morphism1
R2 = ⟨R2, T2⟩
⟨R,ξ⟩
←−−−⟨R1, T1⟩= R1
database morphism2
R2 = ⟨R2, T2, A2⟩
⟨R, `
ψ,f,g⟩
←−−−−−−⟨R1, T1, A1⟩= R1
database morphism3
R2 = ⟨R2, S2, A2, K2, τ2⟩
⟨R,κ, `
ϕ,f,g⟩
←−−−−−−−⟨R1, S1, A1, K1, τ1⟩= R1
1 full, 2 ﬁxed type domain, 3 with projections
Table 13. FOLE Morphisms

---

FOLE Equivalence
45
A.2
Classiﬁcations and Infomorphisms
The concept of a “classiﬁcation” comes from the theory of Information Flow: see
the book Information Flow: The Logic of Distributed Systems by Barwise and
Seligman [1]. A classiﬁcation is also important in the theory of Formal Concept
Analysis, where it is called a “formal context”: see the book Formal Concept
Analysis: Mathematical Foundations by Ganter and Wille [4].
Classiﬁcation. A classiﬁcation A = ⟨X, Y, |=A⟩consists of: a set Y = inst(A) of
objects to be classiﬁed, called tokens or instances; a set X = typ(A) of objects
that classify the instances, called types; and a binary relation |=A ⊆Y ×X be-
tween instances and types. The extent of any type x ∈X is the subset of instances
classiﬁed by x: extA(x) = {y ∈Y | y |=A x}. Dually, the intent of any instance
y ∈Y is the subset of types that classify y: intA(y) = {x ∈X | y |=A x}. Two
types x, x′ ∈X are coextensive in A when extA(x) = extA(x′). Two instances
y, y′ ∈Y are cointensive or indistinguishable in A when intA(y) = intA(y′).
A classiﬁcation A is separated or intensional when there are no two indistin-
guishable instances: y̸ = y′ implies intA(y)̸ = intA(y′). A classiﬁcation A is
extensional when all coextensive types are identical: extA(x) = extA(x′) im-
plies x = x′; equivalently, x̸ = x′ implies extA(x)̸ = extA(x′). More strongly,
a classiﬁcation A is disjoint when distinct types have disjoint extents: x̸ = x′
implies extA(x) ∩extA(x′) = ∅. Even more strongly, a classiﬁcation A is parti-
tioned when it is disjoint and all instances are classiﬁed: intA(y)̸ = ∅equivalently
y ∈extA(x) some x ∈X for all y ∈Y . A classiﬁcation A is pseudo-partitioned
when it is disjoint and all instances are classiﬁed except for one special instance
· ∈Y : intA(·) = ∅.
Infomorphism. An infomorphism A2 = ⟨X2, Y2, |=A2⟩
⟨f,g⟩
−−−⇀
↽−−−⟨X1, Y1, |=A1⟩= A1
consists of a type map X2
f
−−→X1 and an instance map Y2
g
←−Y1, which satisfy
the following:
g(y1) |=A2 x2
iﬀ
y1 |=A1 x1 = f(x2)
g(y1) ∈extA2(x2)
Y2(x2)
iﬀ
y1 ∈extA1(f(x2))
Y1(f(x2))
g−1(extA2(x2)) = extA1(f(x2))
X2
X1
Y2
Y1
|=A2
|=A1
f
g
✲
✛
or
X2
X1
℘Y2
℘Y1
extA2
extA1
f
g−1
✲
✲
❄
❄
Fig. 15. Infomorphism

---

46
Robert E. Kent
If two distinct source types x2, x′
2 ∈X2, x2̸ = x′
2, are mapped by the type
map to the same target type 61 f(x2) = f(x′
2) = x1 ∈X1, then any target
instance in the extent y1 ∈extA1(x1) is mapped by the instance map to the
extent intersection g(y1) ∈extA2(x2) ∩extA2(x′
2). Hence, if extent sets are
disjoint in the source classiﬁcation, then the type map must be injective. Note
however that there is restricted map extA2(x2) × extA2(x′
2)
g
←−extA1(x1). Let
Cls denote the context of classiﬁcations and infomorphisms.
Type Domains. In the FOLE theory of data-types [9], a classiﬁcation A = ⟨X, Y, |=A⟩
is known as a type domain. A type domain [11] is an sort-indexed collection of
data types from which a table’s tuples are chosen. It consists of a set of sorts (data
types) X, a set of data values (instances) Y , and a binary (classiﬁcation) relation
|=A between data values and sorts. The extent of any sort (data type) x ∈X is
the subset extA(x) = Ax = {y ∈Y | y |=A x}. Hence, a type domain is equiv-
alent to be a sort-indexed collection of subsets of data values X
A
−−→℘Y : x 7→
extA(x) = Ax. 62 The list classiﬁcation List(A) = ⟨List(X), List(Y ), |=List(A)⟩
has X-signatures as types and Y -tuples as instances, with classiﬁcation by com-
mon arity and universal A-classiﬁcation: a Y -tuple ⟨J, t⟩is classiﬁed by an X-
signature ⟨I, s⟩when J = I and tk |=A sk for all k ∈J = I. 63 In the FOLE
theory of data-types, an infomorphism A′
⟨f,g⟩
−−−⇀
↽−−−A is known as a type domain
morphism, and consists of a sort function X′
f
−−→X and a data value function
Y ′
g
←−Y that satisfy the condition
g(y) |=A′ x′ iﬀy |=A f(x′) for any source
sort x′ ∈X′ and target data value y ∈Y .
Lax Classiﬁcation. From an extensional point-of-view, a classiﬁcation A = ⟨X, Y, |=A⟩
is a set-valued function X
extA
−−−→
Y
℘Y ; that is, an indexed collection of (sub)sets

extA(x) = Y (x) | x ∈X
	
. In a lax classiﬁcation we omit the global set of
data values Y . 64 Hence, a (lax) classiﬁcation is just the pair A = ⟨X, Y ⟩con-
sisting of a set X = typ(A) of objects called types that classify the instances,
61 Are you producting the two types by doing this? Remember how the sum and product
of classiﬁcations is deﬁned.
62 Some examples of data-types useful in databases are as follows. The real numbers
might use sort symbol ℜwith extent {−∞, · · · , 0, · · · , ∞}. The alphabet might use
sort symbol ℵwith extent {a, b, c, · · · , x, y, z}. Words, as a data-type, would be lists
of alphabetic symbols with sort symbol ℵ∗with extent {a, b, c, · · · , x, y, z}∗being all
strings of alphabetic symbols. The periodic table of elements might use sort symbol
E with extent {H, He, Li, He, · · · , Hs,Mt}. Of course, chemical elements can also be
regarded as entity types in a database with various properties such as name, symbol,
atomic number, atomic mass, density, melting point, boiling point, etc.
63 In particular, when I = 1 is a singleton, an X-signature ⟨1, s⟩is the same as a
sort s(·) = x ∈X, a Y -tuple ⟨1, t⟩is the same as a data value t(·) = y ∈Y , and
tup(1, s, A) = tupA(1, s) = extList(A)(1, s) = Ax.
64 We can always deﬁne a global set of instances; for example, Y = S
x∈X Y (x), Y =
`
x∈X Y (x), etc.

---

FOLE Equivalence
47
and a collection of indexed subsets

Y (x) | x ∈X
	
, where Y (x) = extA(x) is
the set of instances (tokens) classiﬁed by the type x ∈X. More brieﬂy, a (lax)
classiﬁcation is a Set-valued diagram X
Y
−−→Set.
Lax Infomorphism. Tbl. 14 motivates the deﬁnition of a lax infomorphism. In
a lax infomorphism A2 = ⟨X2, Y2⟩
⟨f,γ⟩
↽−−−⟨X1, Y1⟩= A1 the instance func-
tion Y2
g
←−Y1 is replaced by the collection of instance functions

Y2(x2)
γr2
←−−
Y1(f(x2)) | x2 ∈X2
	
. Hence, an infomorphism is a Set-valued instance bridge
Y2
γ
⇐== f ◦Y1. Let
˚
Cls denote the context of lax classiﬁcations and lax info-
morphisms. There is a passage Cls
lax
−−→
˙
Cls.
infomorphism
A2 = ⟨X2, Y2, |=A2⟩
⟨f,g⟩
−−−⇀
↽−−−
⟨X1, Y1, |=A1⟩= A1
g(y1) |=A2 x2
⇐⇒
y1 |=A1 f(x2)
g(y1) ∈extA2(x2)
⇐⇒
y1 ∈extA1(f(x2))
g−1(extA2(x2))
=
extA1(f(x2))
............................................... implies ...............................................
g−1(
Y2
extA2(x2))
⊇
Y1
extA1(f(x2))
g(x1) ∈
Y2
extA2(x2)
⇐=
x1 ∈
Y1
extA1(f(x2))
g(y1) |=A2 x2
⇐=
y1 |=A1 f(x2)
A2 = ⟨X2, Y2⟩
⟨f,γ⟩
↽−−−
⟨X1, Y1⟩= A1
lax infomorphism
Table 14. Lax Infomorphisms
X′
X
℘Y ′
℘Y
Y ′
Y
f
g−1
✲
✲
❄
❄
X′
X
Set
Y ′
Y
f
✲
ψ
⇐===
❅
❅
❅
❘
   ✠
strict
lax
Fig. 16. Lax Infomorphism

---

48
Robert E. Kent
References
1. Barwise, J., and Seligman, J.: Information Flow: The Logic of Distributed Systems.
Cambridge University Press, Cambridge (1997).
2. Chen, P.: “The Entity-Relationship Model - Toward a Uniﬁed View of Data”. ACM
Trans. on Database Sys., 1 (1): pp. 9-36. doi:10.1145/320434.320440.
3. Codd, E.F.: The relational model for database management : version 2. Addison
Wesley, Boston (1990).
4. Ganter, B., and Wille, R.: Formal Concept Analysis: Mathematical Foundations.
Springer, New York (1999).
5. Goguen, J.: A categorical manifesto. Mathematical Structures in Computer Science
1, 49–67 (1991).
6. Gruber,
T.
“Ontology”.
In:
Ling
Liu
and
M.
Tamer
¨Ozsu
(eds.)
The
Encyclopedia
of Database Systems,
Springer-Verlag (2009). Available
online:
tomgruber.org/writing/ontology-definition-2007.htm.
7. Kent, R.E.: “Database Semantics”. (2011). Available online:
https://arxiv.org/abs/1209.3054.
8. Kent, R.E.: “The First-order Logical Environment”. In: Pfeiﬀer, H.D., Ignatov, D.I.,
Poelmans, J., and Nagarjuna G. (eds.) Conceptual Structures in Research and Edu-
cation, LNCS vol. 7735, pp. 210–230. Springer, Heidelberg (2013). Available online:
https://arxiv.org/abs/1305.5240.
9. Kent, R.E.: “The ERA of FOLE: Foundation” (2015). Submitted for publication. Avail-
able online: https://arxiv.org/abs/1512.07430.
10. Kent, R.E.: “The ERA of FOLE: Superstructure” (2016). Available online:
https://arxiv.org/abs/1602.04268.
11. Kent, R.E.: “The FOLE Table”. Submitted for publication. Available online:
https://arxiv.org/abs/1810.12100.
12. Kent, R.E.: “The FOLE Database”. Available online:
https://arxiv.org/abs/2302.05997.
13. Kent, R.E.: “Relational Operations in FOLE”. Submitted for publication. Available
online: https://arxiv.org/abs/2103.11027.
14. Kent, R.E.: “Semantic Integration in the IFF”. Presented at the Semantic Inte-
gration Workshop of the 2nd International Semantic Web Conference (ISWC2003),
Sanibel Island, Florida, October 20, 2003. Available online:
https://arxiv.org/abs/1109.0032.
15. Kent, R.E.: “Semantic Integration in the Information Flow Framework”. Dagstuhl
Seminar Proceedings 04391, Semantic Interoperability and Integration, Schloss
Dagstuhl, Leibniz-Zentrum fur Informatik GmbH, 2005. Available online:
https://arxiv.org/abs/1810.08236.
16. The Information Flow Framework (IFF). Start document available from the IEEE
P1600.1 Standard Upper Ontology Working Group (SUO WG) Home Page.
http://ontolog.cim3.net/file/resource/historic-archives/IEEE-SUO-WG/.

---

