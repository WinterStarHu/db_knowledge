# Approximate Integrity Constraints in Incomplete Databases With Limited Domains

> 来源: https://arxiv.org/pdf/2402.05057

Approximate Integrity Constraints in Incomplete
Databases With Limited Domains⋆
Munqath Al-atar1, Attila Sali2,3
1 ITRDC, University of Kufa
munqith.alattar@uokufa.edu.iq
2 Department of Computer Science and Information Theory,
Budapest University of Technology and Economics
3 Alfr´ed R´enyi Institute of Mathematics
sali.attila@renyi.hu
Abstract. In case of incomplete database tables, a possible world is obtained by re-
placing any missing value by a value from the corresponding attribute’s domain that
can be infinite. A possible key or possible functional dependency constraint is satis-
fied by an incomplete table if we can obtain a possible world that satisfies the given
key or functional dependency. On the other hand, a certain key or certain functional
dependency holds if all possible worlds satisfy the constraint, A strongly possible
constraint is an intermediate concept between possible and certain constraints, based
on the strongly possible world approach (a strongly possible world is obtained by
replacing NULL’s by a value from the ones appearing in the corresponding attribute
of the table). A strongly possible key or functional dependency holds in an incom-
plete table if there exists a strongly possible world that satisfies the given constraint.
In the present paper, we introduce strongly possible versions of multivalued depen-
dencies and cross joins, and we analyse the complexity of checking the validity of a
given strongly possible cross joins. We also study approximation measures of strongly
possible keys (spKeys), functional dependencies (spFDs), multivalued dependencies
(spMVDs) and cross joins (spCJs). g3 and g5 measures are used to measure how close
a table Y satisfies a constraint if it is violated in T. Where the two measures g3
and g5 represent the ratio of the minimum number of tuples that are required to be
removed from or added to, respectively, the table so that the constraint holds. Re-
moving tuples may remove the cases that caused the constraint violation and adding
tuples can extend the values shown on an attribute. For spKeys and spFDs, We show
that the g3 value is always an upper bound of the g5 value for a given constraint in a
table. However, there are tables of arbitrarily large number of tuples and a constant
number of attributes that satisfy g3 −g5 = p
q for any rational number 0 ≤p
q < 1. On
the other hand, we show that the two measures values are independent of each other
in the case of spMVDs and spCJs.
We also treat complexity questions of determination of the approximation values.
Keywords: Strongly possible functional dependencies, Strongly possible keys, cross
joins, multivalued dependency, incomplete databases, data Imputation, Approximate func-
tional dependencies, approximate keys.
⋆Research of the second author was partially supported by the National Research, Development
and Innovation Office (NKFIH) grants K–116769 and SNN-135643. This work was also supported
by the BME- Artificial Intelligence FIKP grant of EMMI (BME FIKP-MI/SC) and by the Min-
istry of Innovation and Technology and the National Research, Development and Innovation
Office within the Artificial Intelligence National Laboratory of Hungary.
arXiv:2402.05057v1  [cs.DB]  7 Feb 2024

---

2
Munqath Al-atar, Attila Sali
1
Introduction
Missing values is a common issue in many databases because of many reasons such as data
repair, error while data transmission, data storage defect, etc [14]. Imputing a value instead
of any missed information is the most common way o handle this issue [29].
In [3], a new imputation approach was introduced that considers only the active domain
for each attribute (the data that are already there in that attribute of the table). The
resulting complete table using this imputation approach is called a strongly possible world.
Using only the shown data for imputation ensures that we always use values related to the
attributes domains.
Using this concept, new versions of integrity constraints called strongly possible con-
straints, such as keys (spKeys), functional dependencies (spFDs), multivalued dependencies
(spMVDs) and cross joins (spCJs) were defined in [4–6] or in case of spCJs are introduced
in the present paper, that are satisfied after replacing any missing value (NULL) with a value
that is already shown in the corresponding attribute. In section 2, we provide the formal
definitions.
The present paper is the extended version of the conference paper [1] that continued the
work started in [6], where an approximation approach to measure how close a table satisfies
a key constraint was introduced. The closeness is measured by calculating the ratio of the
minimum number of tuples to be removed so that the constraint holds in the resulting table.
This is necessary as the active domains may not contain enough values to replace the NULL
so that the resulting table satisfies the key.
Here we also consider strongly possible multivalued dependencies and cross joins. We
introduce approximation measures of spKeys, spFDs and spCJs by adding tuples. Adding
a tuple with new unique values will add more values to the attributes’ active domains,
thus some unsatisfied equality generating constraints may get satisfied. On the other hand,
adding tuples consisting of NULL values give enough tuples for tuple generating constraints.
Note that if possible keys or functional dependencies [24] are considered, then adding tuples
does not change the satisfaction of the given constraint, as in that case any domain values
could be used to replace NULL’s.
For example, Table 1 does not satisfy the spKey sp⟨Car Model, DoorNo⟩, while they are
designed to distinguish Cars Types. We need to either remove two tuples or add a new tuple
with new door number value to satisfy sp⟨Car Model, DoorNo⟩. Furthermore,car model
and door number should, generally, determine the engine type, so, the added tuple with a
new value in the DoorNo attribute will satisfy (Car Model, DoorNo) →sp Engine Type
instead of removing other two tuples.
Car Model
Door No
Engine Type
BMW
4
⊥
BMW
⊥
electric
Ford
⊥
V8
Ford
⊥
V6
Table 1: Cars Information Incomplete Table

---

Approximate Keys and FDs
3
If the key or the FD is not satisfied in the total part of the table, then adding a new
values is useless. So, in this paper we suppose that sp⟨K⟩or X →sp Y is satisfied by the
K-total part of the table (for exact definitions see Section 2). In this paper, we assume that
there is at least one non-null value for each attribute to have a non-empty active domain.
The main objectives of this paper are:
– Extend the g3 measure defined for spKeys in [6] to other strongly possible integrity
constraints.
– Propose the g5 approximation measure for strongly possible constraints, that measures
the minimum number of tuples that are required to be added to satisfy the constraints.
– Compare g5 with g3 and show that for spKeys and spFDs it is more effective to adding
new tuples than removing violating ones.
– We show that except for the inequality above, g3 and g5 are independent of each other.
– Introduce strongly possible versions of multivalued dependencies and cross joins
– Compare spMVDs with NMVDs introduced by Lien [27].
– Analyse the complexity of checking the validity of a given spCJ, and also determining
the approximation measures of a given spCJ.
Possible worlds were studied by many sets of authors, such as [12, 25, 38]. Generally, a
NULLcan be replaced by any value from a domain that can be infinite, then an infinite
number of worlds can be considered. While strongly possible worlds considers only values
allowed by the original table given to replace with NULLs. The paper is organized as follows.
Section 2 gives the basic definitions and notations. Section 3 discusses some related work.
Sections 4 and 5 provide the approximation measures for spKeys and spFDs respectively.
Strongly possible versions of tuple generating constraints are introduced in Section 6. Their
approximation measures are analysed, furthermore complexity questions are treated in this
section. The conclusions and some suggested future research directions are discussed in
Section 7.
2
Basic Definitions
Let R = {A1, A2, . . . An} be a relation schema. The set of all the possible values for each
attribute Ai ∈R is called the domain of Ai and denoted as Di = dom(Ai) for i = 1,2,. . . n.
Then, for X ⊆R, then DX =
Q
∀Ai∈K
Di.
An instance T = (t1,t2, . . . ts) over R is a list of tuples such that each tuple is a function
t : R →S
Ai∈R dom(Ai) and t[Ai] ∈dom(Ai) for all Ai in R. By taking a list of tuples we
use the bag semantics that allows several occurrences of the same tuple. Usage of the bag
semantics is justified by that SQL allows multiple occurrences of tuples. Of course, the order
of the tuples in an instance is irrelevant, so mathematically speaking we consider a multiset
of tuples as an instance. For a tuple tr ∈T and X ⊂R, let tr[X] be the restriction of tr to
X.
It is assumed that ⊥is an element of each attribute’s domain that denotes missing
information. tr is called V -total for a set V of attributes if ∀A ∈V , tr[A]̸ = ⊥. Also, tr is a
total tuple if it is R-total. t1 and t2 are weakly similar on X ⊆R denoted as t1[X] ∼w t2[X]
defined by K¨ohler et.al. [24] if
∀A ∈X
(t1[A] = t2[A] or t1[A] = ⊥or t2[A] = ⊥).

---

4
Munqath Al-atar, Attila Sali
Furthermore, t1 and t2 are strongly similar on X ⊆R denoted by t1[X] ∼s t2[X] if
∀A ∈X
(t1[A] = t2[A]̸ = ⊥).
For the sake of convenience we write t1 ∼w t2 if t1 and t2 are weakly similar on R and use
the same convenience for strong similarity. Let T = (t1, t2, . . . ts) be a table instance over
R. Then, T ′ = (t′
1, t′
2, . . . t′
s) is a possible world of T, if ti ∼w t′
i for all i = 1, 2, . . . s and
T ′ is completely NULL-free. That is, we replace the occurrences of ⊥with a value from the
domain Di different from ⊥for all tuples and all attributes. A active domain of an attribute
is the set of all the distinct values shown under the attribute except the NULL. Note that
this was called the visible domain of the attribute in papers [2–4,6].
Definition 2.1. The active domain of an attribute Ai (V DT
i ) is the set of all distinct values
except ⊥that are already used by tuples in T:
V DT
i = {t[Ai] : t ∈T} \ {⊥} for Ai ∈R.
To simplify notation, we omit the upper index T if it is clear from the context what instance
is considered.
Then the V D1 in Table 2 is {Mathematics, Datamining}. The term active domain refers
to the data that already exist in a given dataset. For example, if we have a dataset with
no information about the definitions of the attributes’ domains, then we use the data itself
to define their own structure and domains. This may provide more realistic results when
extracting the relationship between data so it is more reliable to consider only what infor-
mation we have in a given dataset.
While a possible world is obtained by using the domain values instead of the occurrence
of NULL, a strongly possible world is obtained by using the active domain values.
Definition 2.2. A possible world T ′ of T is called a strongly possible world (spWorld) if
t′[Ai] ∈V DT
i for all t′ ∈T ′ and Ai ∈R.
Note that V DT
i
= ∅might happen in the degenerate case of an attribute having only
NULL values. In order to be able to define strongly possible world for any table, a special
symbol ssymb is added to V DT
i
in that degenerate case. The symbol ssymb is assumed
not being contained in any domain of any attribute. The concept of strongly possible world
was introduced in [3]. A strongly possible worlds allow us to define strongly possible keys
(spKeys) and strongly possible functional dependencies (spFDs).
Definition 2.3. A strongly possible functional dependency, in notation X →sp Y , holds in
table T over schema R if there exists a strongly possible world T ′ of T such that T ′ |= X →Y .
That is, for any t′
1, t′
2 ∈T ′ t′
1[X] = t′
2[X] implies t′
1[Y ] = t′
2[Y ]. The set of attributes X is
a strongly possible key, if there exists a strongly possible world T ′ of T such that X is a key
in T ′, in notation sp⟨X⟩. That is, for any t′
1, t′
2 ∈T ′ t′
1[X] = t′
2[X] implies t′
1 = t′
2.
Note that this is not equivalent with spFD X →sp R, since we use the bag semantics. For
example, {Course Name, Year} is a strongly possible key of Table 2 as the strongly possible
world in Table 3 shows it.
Following [17] strongly possible cross joins are defined as
Definition 2.4. A cross join (CJ) over relation schema R is an expression X × Y where
X and Y are subsets of R. A table T over R is said to satisfy the CJ X × Y over R if and

---

Approximate Keys and FDs
5
Course Name
Year
Lecturer
Credits
Semester
Mathematics
2019
⊥
5
1
Datamining
2018
Sarah
7
⊥
⊥
2019
Sarah
⊥
2
Table 2: Incomplete Dataset
Course Name
Year
Lecturer
Credits
Semester
Mathematics
2019
Sarah
5
1
Datamining
2018
Sarah
7
2
Datamining
2019
Sarah
7
2
Table 3: Complete Dataset
only if for all t1, t2 ∈T there is some t ∈r such that t[X] = t1[X] and t[Y ] = t2[Y ]. If T
does not satisfy X ×Y , then we also say that r violates X ×Y . A strongly possible cross join
(spCJ) over schema R is an expression X ×sp Y where X and Y are subsets of R. A table
T over R is said to satisfy the spCJ X ×sp Y over R if and only if there exists a strongly
possible world T ′ of T such that T ′ |= X × Y .
Similarly, strongly possible multivalued dependencies are introduced as follows.
Definition 2.5. A strongly possible multivalued dependency (spMVD) over schema R is an
expression X ↠sp Y . The spMVD X ↠sp Y is satisfied in T if and only if there exists a
strongly possible world T ′ of T such that T ′ |= X ↠Y .
If T = {t1, t2, . . . , tp} and T ′ = {t′
1, t′
2, . . . , t′
p} is an spWorld of it with ti ∼w t′
i, then t′
i
is called an sp-extension or in short an extension of ti. Let X ⊆R be a set of attributes and
let ti ∼w t′
i such that for each A ∈R: t′
i[A] ∈V D(A), then t′
i[X] is an strongly possible
extension of ti on X (sp-extension)
3
Related Work
Approximation measures Giannella et al. [15] measure the approximate degree of func-
tional dependencies. They developed the IFD approximation measure and compared it with
the other two measures: g3 (minimum number of tuples need to be removed so that the
dependency holds) and τ (the probability of a correct guess of an FD satisfaction) in-
troduced in [23] and [16] respectively. They developed analytical bounds on the measure
differences and compared these measures analysis on five datasets. The authors show that
when measures are meant to define the knowledge degree of X determines Y (prediction
or classification), then IFD and τ measures are more appropriate than g3. On the other
hand, when measures are meant to define the number of ”violating” tuples in an FD, then,
g3 measure is more appropriate than IFD and τ. This paper extends the earlier work of [6]
that utilized the g3 measure for spKeys by calculating the minimum number of tuples to
be removed from a table so that an spKey holds if it is not. The same paper proposed the
g4 measure that is derived from g3 by emphasizing the effect of each connected component

---

6
Munqath Al-atar, Attila Sali
in the table’s corresponding bipartite graph (where vertices of the first class of the graph
represent the table’s tuples and the second class represent all the possible combinations of
the attributes’ active domains). In this paper, we propose a new measure g5 to approximate
FDs by adding new tuples with unique values rather than deleting tuples as in g3.
Several other researchers worked on approximating FDs in the literature. King et al.
[22] provided an algorithmic method to discover functional and approximate functional
dependencies in relational databases. The method provided is based upon the mathematical
theory of partitions of row identification numbers from the relation, then determining non-
trivial minimal dependencies from the partitions. They showed that the operations that
need to be done on partitions are both simple and fast.
3.1
Algorithmic approaches
In [36], Varkonyi et al. introduced a structure called Sequential Indexing Tables (SIT) to
detect an FD regarding the last attribute in their sequence. SIT is a fast approach so it
can process large data quickly. The structure they used does not scale efficiently with the
number of the attributes and the sizes of their domains, however. Other methods, such as
TANE and FastFD face the same problem [33]. TANE was introduced by Huhtala [19] to
discover functional and approximate dependencies by taking into consideration partitions
and deriving valid dependencies from these partitions in a breadth-first or level-wise manner.
Bra, P. De, and Jan Paredaens gave a new decomposition theory for functional depen-
dencies in [10]. They break up a relation into two subrelations whose union is the given
relation and a functional dependency that holds in one subrelation is not in the other.
In [35], Tusor et al. presented the Parallelized Sequential Indexing Tables method that is
memory-efficient for large datasets to find exact and approximate functional dependencies.
Their method uses the same principle of Sequential Indexing Tables in storing data, but
their training approach and operation are different.
Pyro is an algorithm to discover all approximate FDs in a dataset presented by Kruse [26].
Pyro verifies samples of agree sets and prunes the search spaces with the discovered FDs.
On the other hand, based on the concept of ”agree sets”, Lopes et al. [31] developed an
algorithm to find a minimum cover of a set of FDs for a given table by applying the so-
called ”Luxenburger basis” to develop a basis of the set of approximate FDs in the table.
Simovici et al. [34] provide an algorithm to find purity dependencies such that, for a
fixed right-hand side (Y ), the algorithm applies a level-wise search on the left-hand sides
(X) so that X →Y has a purity measure below a user-defined threshold. Other algorithms
were proposed in [21,30] to discover all FDs that hold in a given table by searching through
the lattice of subsets of attributes.
In [37], Jef Wijsen summarizes and discusses some theoretical developments and concepts
in Consistent query answering CQA (when a user queries a database that is inconsistent
with respect to a set of constraints). Database repairing was modeled by an acyclic binary
relation ≤db on the set of consistent database instances, where r1 ≤db r2 means that r1 is at
least as close to db as r2. One possible distance is the number of tuples to be added and/or
removed. In addition to that, Bertossi studied the main concepts of database repairs and
CQA in [8], and emphasis on tracing back the origin, motivation, and early developments.
J. Biskup and L. Wiese present and analyze an algorithm called preCQE that is able to
correctly compute a solution instance, for a given original database instance, that obeys the
formal properties of inference-proofness and distortion minimality of a set of appropriately
formed constraints in [9].

---

Approximate Keys and FDs
7
Hannula et. al. [17] showed that the problem deciding whether there is a cross join
that holds on a gven table is W[3] complete. The present authors [4] showed that checking
one spKey can be done in polynomial time, while checking a system of spKeys, as well as
checking an spFD is NP complete. In a forthcoming paper [7] they also treat the complexity
of determining the approximation measures of spKeys and spFDs.
3.2
Multivalued dependencies
Multivalued dependencies are a generalization of functional dependencies and they extend
the understanding of logical database design. Multivalued dependencies lead to the fourth
normal form for relational databases, where a relation schema is in the fourth normal form
if all functional and multivalued dependencies are the result of keys [13]. The satisfaction
of the functional dependency X →Y is a sufficient condition for r to be the lossless join
of its projections r[XY ] and r[X(R \ Y )], but not a necessary condition. The satisfaction
of multivalued dependency X ↠Y provides a sufficient and necessary condition for r to be
the lossless join of its projections r[XY ] and r[X(R \ Y )] without loss of information [11].
Informally, a relation r over the relation schema R satisfies the MVD X ↠Y whenever the
value on X determines the set of values on Y independently of the set of values on R \ Y .
The multivalued dependencies show different behaviour in the presence of missing infor-
mation in the attributes of the table, because missing information changes the implication
properties between attributes. For example, if the two tuples t1 and t2 have the values 1
and ⊥respectively on the attribute X, they do not agree on X and they do not disagree
at the same time. It is possible that t2[X] = 1, and this value is not yet inserted. Some re-
search and studies discuss and analyze the problem of incomplete databases for multivalued
dependencies.
[18, 27, 28] introduced a generalized version of multivalued dependencies for databases
with missing information. Lien [27] introduced a new class of multivalued dependencies in
the context of null values have been, called multivalued dependency with nulls (NMVD).
The NMVD NX ↠Y holds in R(X, Y, Z), where Z is disjoint from Y , if and only if,
whenever X null-free (X-total) tuples (x, y, z) and (x, y′, z′) are tuples in R, so are tuples
(x, y′, z) and (x, y, z′). The data value x is for attributes X, and similarly, y (or y′) and z(or
z′) correspond to Y and Z respectively. (R contains no two distinct tuples t and t′ such that
t subsumes t′). In [28], Lien defined the NMVD over R as a statement X ↠Y and considers
that the left-hand side of the dependency is X-total. According to this, MVD X ↠Y is
satisfied by a relation R, denoted by R |= X ↠Y , if and only if for every two tuples t1, t2
in the relation, the following is true: if t1 and t2 are X-total and t1[X] = t2[X], then there
is some tuples t such that t[XY ] = t1[XY ] and t[X(R \ Y )] = t2[X(R \ Y )]. Lien presented
valid inference rules. It was also shown that the four basic inference rules, complementation,
reflexivity, augmentation, and union, are complete and therefore sufficient for studying the
formal properties of the revised multivalued dependencies.
S. Link [18] defined the weak multivalued dependency (WMVDs) over R as a statement
3X ↠Y , where XY ⊆R. A relation r over R is said to satisfy the WMVD 3X ↠Y over R
if there is some possible world s of r such that for all t1, t2 ∈s the following holds: if t1[X] =
t2[X], then there is some t ∈s such that t[XY ] = t1[XY ] and t[X(R \ Y )] = t2[X(R \ Y )].
Our proposed class of multivalued dependency uses the strongly possible worlds instead of
the possible worlds.

---

8
Munqath Al-atar, Attila Sali
4
SPKey Approximation
Investigations of strongly possible worlds can be extended for other types of dependencies,
like multivalued dependencies and cross joins. In [6], the authors studied strongly possible
keys, and the main motivation is to uniquely identify tuples in incomplete tables, if it is
possible, by using the already shown values only to fill up the occurrences of NULLs. Consider
the relational schema R = and K ⊆R. Furthermore, let T be an instance over R with NULLs.
Let T ′ be the set of total tuples T ′ = {t′ ∈Πb
i=1V DT
i : ∃t ∈T such that t[K] ∼w t′[K]},
furthermore let G = (T, T ′; E) be the bipartite graph, called the K-extension graph of T,
defined by {t, t′} ∈E
⇐⇒
t[K] ∼w t′[K]. Finding a matching of G that covers all the
tuples in T (if exists) provides the set of tuples in T ′ to replace the incomplete tuples in
T with, to verify that K is an spKey. A polynomial-time algorithm was given in [4] to find
such matching. It is a non-trivial application of the well-known matching algorithms, as |T ′|
is usually an exponential function of the size of the input table T.
The Approximate Strongly Possible Key (ASP Key) was defined in [6] as follows.
Definition 4.1. Attribute set K is an approximate strongly possible key of ratio a in table
T, in notation asp−
a ⟨K⟩, if there exists a subset S of the tuples T such that T \ S satisfies
sp ⟨K⟩, and |S|/|T| ≤a. The minimum a such that asp−
a ⟨K⟩holds is denoted by g3(K).
The measure g3(K) represents the approximation which is the ratio of the number of tuples
needed to be removed over the total number of tuples so that sp ⟨K⟩holds. The measure
g3(K) has a value between 0 and 1, and it is exactly 0 when sp ⟨K⟩holds in T, which means
we don’t need to remove any tuples. For this, we used the g3 measure introduced in [23],
to determine the degree to which ASP key is approximate. For example, the g3 measure of
sp⟨X⟩on Table 4 is 0.5, as we are required to remove two out of four tuples to satisfy the
key constraint as shown in Table 5.
It was shown in [6] that the g3 approximation measure for strongly possible keys satisfies
g3(K) = |T| −ν(G)
|T|
.
where ν(G) denotes the maximum matching size in the K-extension graph G. The smaller
value of g3(K), the closer K is to being an spKey.
For the bipartite graph G defined above, let C be the collection of all the connected
components in G that satisfy the spKey, i.e. for which there exists a matching that covers
all tuples in the set (∀C∈C ∄X ⊆C ∩T such that |X| > N(X) by Hall’s Theorem). Let
D ⊆G be defined as D = G \ S
∀C∈C C, and let C ′ be the set of connected components
of D. Let VC denote the set of vertices in a connected component C. The approximation
measure of strongly possible keys may be more appropriate by considering the effect of each
connected component in the bipartite graph on the matching. We consider the effect of
the components of C to get doubled in the approximation measure, as these components
represent that part of the data that do not require tuple removal. So a derived version of
the g3 measure was proposed and named g4 considering these components’ effects,
g4(K) = |T| −(P
C∈C (|VC|) + P
C′∈C ′ ν(C′))
|T| + P
C∈C |VC|
.
Furthermore, it was proved that for a set of attributes K in any table, we have either
g3(K) = g4(K) or 1 < g3(K)/g4(K) < 2. Moreover, there exist tables of an arbitrarily large
number of tuples with g3(K)/g4(K) = p
q for any rational number 1 ≤p
q < 2.

---

Approximate Keys and FDs
9
In this paper, we extend our investigation on approximating spKeys by considering
adding new tuples instead of removing them to satisfy an spKey if possible. Removing a
non-total tuple t1 means that there exist another total and/or non-total tuple(s) that share
the same strongly possible extension with t2. The following proposition shows that we can
always remove only non-total tuples if the total part of the table satisfies the key.
Proposition 4.1. Let T be an instance over schema R and let K ⊆R. If the K-total part
of the table T satisfies the key sp ⟨K⟩, then there exists a minimum set of tuples U to be
removed that are all non-K-total so that T \ U satisfies sp ⟨K⟩.
Proof. Observe that a minimum set of tuples to be removed is T \ X for a subset X of
the set of vertices (tuples) covered by a particular maximum matching of the K-extension
graph. Let M be a maximum matching, and assume that t1 is total and not covered by M.
Then, the unique neighbour t′
1 of t1 in T ′ is covered by an edge (t2, t′
1) of M. Then t2 is
non-total since the K-total part satisfies sp ⟨K⟩, so we replace the edge (t2, t′) by the edge
(t1, t′) to get matching M1 of size |M1| = |M|, and M1 covers one more total tuple. Repeat
this until all total tuples are covered.
4.1
Measure g5 for spKeys
The g3 approximation measure for spKeys was introduced in [6]. In this section, we introduce
a new approximation measure for spKeys. As we consider the active domain to be the source
of the values to replace each null with, adding a new tuple to the table may increase the
number of the values in the active domain of an attribute. for example, consider Table 4,
the active domain of the attribute X1 is {2} and it changed to {2, 3} after adding a tuple
with new values as shown in Table 6.
X
X1
X2
⊥
1
2
⊥
2
⊥
2
2
Table 4: Incomplete Table
to measure sp⟨X⟩
X
X1
X2
⊥
1
2
2
Table 5: The table after
removing (asp−
a ⟨X⟩)
X
X1
X2
⊥
1
2
⊥
2
⊥
2
2
3
3
Table 6: The table
after adding (asp+
b ⟨X⟩)
In the following definition, we define the g5 measure as the ratio of the minimum number
of tuples that need to be added over the total number of tuples to have the spKey satisfied.
Definition 4.2. Attribute set K is an add-approximate strongly possible key of ratio b in
table T, in notation asp+
b ⟨K⟩, if there exists a set of tuples S such that the table TS satisfies
sp ⟨K⟩, and |S|/|T| ≤b. The minimum b such that asp+
b ⟨K⟩holds is denoted by g5(K).
The measure g5(K) represents the approximation which is the ratio of the number of tuples
needed to be added over the total number of tuples so that sp ⟨K⟩holds. The value of the
measure g3(K) ranges between 0 and 1, and it is exactly 0 when sp ⟨K⟩holds in T, which

---

10
Munqath Al-atar, Attila Sali
means we do not have to add any tuple. For example, the g5 measure of sp⟨X⟩on Table 4
is 0.25, as it is enough to add one tuple to satisfy the key constraint as shown in Table 6.
Let T be a table and U ⊆T be the set of the tuples that we need to remove so that
the spKey holds in T, i.e, we need to remove |U| tuples, while by adding a tuple with new
values, we may make more than one of the tuples in U satisfy the spKey using the new
added values for their NULLs. In other words, we may need to add a fewer number of tuples
than the number of tuples we need to remove to satisfy an spKey in the same given table.
For example, Table 4 requires removing two tuples to satisfy sp ⟨X⟩, while adding one tuple
is enough.
On the other hand, one may think about mixed modification of both adding and deleting
tuples for Keys approximation, by finding the minimum number of tuples needs to be either
added or removed. If first the additions are performed, then after that by Proposition 4.1, it
is always true that we can remove only non-total tuples; then, instead of any tuple removal,
we may add a new tuple with distinct values. Therefore, mixed modification in that way
would not change the approximation measure, as it is always equivalent to tuples addition
only. However, if the order of removals and additions count, then it is a topic of further
research whether the removals can be substituted by additions.
The values of the two measures, g3 and g5, range between 0 and 1, and they are both
equal to 0 if the spKey holds (we do not have to add or remove any tuples). Proposition
4.2 proves that the value of g3 measure is always larger than or equal to the value of g5
measure.
Proposition 4.2. For any K ⊆R with |K| ≥2, we have g3(K) ≥g5(K).
Proof. Indeed, we can always remove non-total tuples for g3 by Proposition 4.1. Let the
tuples to be removed be U = {t1, t2, . . . tu}. Assume that T ∗is an spWorld of T \ U, which
certifies that T \ U |= sp ⟨K⟩For each tuple ti ∈U, we add tuple t′
i = (zi, zi, . . . , zi) where
zi is a value that does not occur in any other tuple originally of T or added. The purpose
of adding t′
i is twofold. First it is intended to introduce a completely new active domain
value for each attribute. Second, their special structure ensures that they will never agree
with any other tuple in the spWorld constructed below for the extended instance. Let ti”
be a tuple such that exactly one NULL in K of ti is replaced by zi, any other NULLs of ti are
imputed by values from the original active domain of the attributes. It is not hard to see
that tuples in T ∗∪{t′
1, t′
2 . . . , t′
u} ∪{t1”, t2” . . . , tu”} are pairwise distinct on K.
According to Proposition 4.2 we have 0 ≤g3(K)−g5(K) < 1 and the difference is a rational
number. What is not immediate is that for any rational number 0 ≤p
q < 1 there exist a
table T and K ⊆R such that g3(K) −g5(K) = p
q in table T.
Proposition 4.3. Let 0 ≤p
q < 1 be a rational number. Then there exists a table T with an
arbitrarily large number of rows and K ⊆R such that g3(K) −g5(K) = p
q in table T.
Proof. We may assume without loss of generality that K = R, since T ′ |= sp ⟨K⟩if and
only if we can make the tuples pairwise distinct on K by imputing values from the active
domains, that is values in R\K are irrelevant. Let T be the following q ×(p+2) table (with

---

Approximate Keys and FDs
11
x = q −p −1).
T =
1 1 1 . . . 1
1 1 1 . . . 2
...
1 1 1 . . . x
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
q −p −1
⊥1 . . . 1 1
1 ⊥. . . 1 1
...
1 1 . . . ⊥1

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

p + 1
(1)
Since the active domain of the first p + 1 attributes is only {1}, we have to remove p + 1
rows so g3(K) = p+1
q . On the other hand it is enough to add one new row (2, 2, . . . , 2, q −p)
so g5(K) = 1
q. Since p
q = cp
cq for any positive integer c, the number of rows in the table could
be arbitrarily large.
The tables constructed in the proof of Proposition 4.3 have an arbitrarily large number of
rows, however, the price for this is that the number of columns is also not bounded. The
question arises naturally whether there are tables with a fixed number of attributes but with
an arbitrarily large number of rows that satisfy g3(K) −g5(K) = p
q for any rational number
0 ≤p
q < 1? The following theorem answers this problem.
Theorem 4.1. Let 0 ≤p
q < 1 be a rational number. Then there exist tables over schema
{A1, A2} with arbitrarily large number of rows, such that g3({A1, A2}) −g5({A1, A2}) = p
q .
Proof. The proof is divided into three cases according to whether p
q < 1
2, p
q = 1
2 or p
q > 1
2.
In each case, the number of rows of the table will be an increasing function of q and one just
has to note that q can be chosen arbitrarily large without changing the value of the fraction
p
q .
Case p
q < 1
2 Let T<.5 be defined as
T<.5 =
q −p −1

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

1
1
1
2
...
...
1
q −p −1
p + 1

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

⊥
⊥
⊥
⊥
...
...
⊥
⊥
(2)
Clearly, g3(K) = p+1
q , as all the tuples with NULLs have to be removed. On the other hand,
if tuple (2, q−p) is added, then the total number of active domain combinations is 2·(q −p),

---

12
Munqath Al-atar, Attila Sali
out of which q −p is used up in the table, so there are q −p possible pairwise distinct tuples
to replace the NULLs. Since p
q <
1
2, we have that q −p ≥p + 1 so all the tuples in the
q + 1-rowed table can be made pairwise distinct. Thus, g3(K) −g5(K) = p+1
q
−1
q.
Case p
q = 1
2 Let T=0.5 be defined as
T=.5 =
q −p −2

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

1
1
1
2
...
...
1
q −p −2
p + 2

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

⊥
⊥
⊥
⊥
...
...
⊥
⊥
(3)
Table T=.5 contains all possible combinations of the active domain values, so we have to
remove every tuple containing NULLs, so g3(K) = p+2
q . On the other hand, if we add just
one new tuple (say (2, q −p −1)), then the largest number of active domain combinations
is 2 · (q −p −1) that can be achieved. There are already q −p −1 pairwise distinct total
tuples in the extended table, so only q −p −1 < p + 2 would be available to replace the
NULLs. On the other hand, adding two new tuples, (2, q −p −1) and (3, q −p) creates a pool
of 3 · (q −p) combinations of active domains, which is more than (q −p −1) + p + 2 that is
needed.
Case p
q > 1
2 Table T is defined similarly to the previous cases, but we need more careful
analysis of the numbers.
T =
b

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

1 1
1 2
...
...
1 b
x

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

⊥⊥
⊥⊥
... ...
⊥⊥
(4)
Clearly, g3(K) =
x
x+b. Let us assume that y tuples are needed to be added. The maximum
number of active domain combinations is (y + 1)(y + b) obtained by adding tuples (2, b +
1), (3, b + 2), . . . , (y + 1, y + b). This is enough to replace all tuples with NULLs if
(y + 1)(y + b) ≥x + y + b.
(5)

---

Approximate Keys and FDs
13
On the other hand, y −1 added tuples are not enough, so
y(y −1 + b) < x + y −1 + b.
(6)
Since the total number of active domain combinations must be less than the tuples in the
extended table. We have p
q = g3(K) −g5(K) = x−y
x+b that is for some positive integer c we
must have cp = x −y and cq = x + b if gcd(p, q) = 1. This can be rewritten as
y = x −cp ;
y + b = c(q −p) ;
b = cq −x ;
x + y + b = y + cq.
(7)
Using (7) we obtain that (5) is equivalent with
y ≥
cp
c(q −p) −1.
(8)
If c is large enough then ⌈
cp
c(q−p)−1⌉= ⌈
p
q−p⌉so if y = ⌈
p
q−p⌉is chosen then (8) and
consequently (5) holds. On the other hand, (6) is equivalent to
y <
cq −1
c(q −p) −2.
(9)
The right hand side of (9) tends to
q
q−p as c tends to infinity. Thus, for large enough c we
have ⌊
cq−1
c(q−p)−2⌋= ⌊
q
q−p⌋. Thus, if
y = ⌈
p
q −p⌉≤⌊
q
q −p⌋
(10)
and
q
q−p is not an integer, then both (5) and (6) are satisfied for large enough c. Observe
that
p
q−p + 1 =
q
q−p, thus (10) always holds. Also, if
q
q−p is indeed an integer, then we have
strict inequality in (10) that implies (9) and consequently (6).
5
spFD Approximation
In this section, we measure to which extent a table satisfies a Strongly Possible Functional
Dependency (spFD) X →sp Y if T̸ |= X →sp Y .
Similarly to Section 4, we assume that the X-total part of the table satisfies the FD
X →Y , so we can always consider adding tuples. The measures g3 and g5 are defined
analogously to the spKey case.
Definition 5.1. For the attribute sets X and Y , σ : X →sp Y is a remove-approximate
strongly possible functional dependency of ratio a in a table T, in notation
T |=≈−
a X →sp Y , if there exists a set of tuples S such that the table T \ S |= X →sp Y ,
and |S|/|T| ≤a. Then, g3(σ) is the smallest a such that T |=≈−
a σ holds.
The measure g3(σ) represents the approximation which is the ratio of the number of tuples
needed to be removed over the total number of tuples so that T |= X →sp Y holds.
Definition 5.2. For the attribute sets X and Y , σ : X →sp Y is an add-approximate
strongly possible functional dependency of ratio b in a table T, in notation T |=≈+
b X →sp Y ,
if there exists a set of tuples S such that the table T ∪S |= X →sp Y , and |S|/|T| ≤b. Then,
g5(σ) is the smallest b such that T |=≈+
b σ holds.

---

14
Munqath Al-atar, Attila Sali
The measure g5(σ) represents the approximation which is the ratio of the number of tuples
needed to be added over the total number of tuples so that T |= X →sp Y holds. For
example, consider Table 7. We are required to remove at least 2 tuples so that X →sp Y
holds, as it is easy to check that if we remove only one tuple, then T̸ |= X →sp Y , but on
the other hand, the table obtained by removing tuples 4 and 5, shown in Table 8 satisfies
X →sp Y . It is enough to add only one tuple to satisfy the dependency as the table in Table
9 shows.
X
Y
X1
X2
⊥
1
1
2
⊥
1
2
⊥
1
2
1
2
2
1
2
2
2
2
Table 7: Incomplete Table
to measure (X →sp Y )〉
X
Y
X1
X2
⊥
1
1
2
⊥
1
2
⊥
1
2
2
2
Table 8: The table after
removing (−
a X →sp Y )
X
Y
X1
X2
⊥
1
1
2
⊥
1
2
⊥
1
2
1
2
2
1
2
2
2
2
3
3
3
Table 9: The table after
adding (+
b X →sp Y )
5.1
The Difference of g3 and g5 for spFDs
The same table may get different approximation measure values for g3 and g5. For example,
the g3 approximation measure for Table 7 is 0.334 (it requires removing at least 2 tuples
out of 6), while its g5 approximation measure is 0.167 (it requires adding at least one tuple
with new values).
The following theorem proves that it is always true that the g3 measure value of a table
is greater than or equal to the g5 for spFDs.
Theorem 5.1. Let T be a table over schema R, σ : X →sp Y for some X, Y ⊆R. Then
g3(σ) ≥g5(σ).
The proof is much more complicated than the one in the case of spKeys, because we cannot
assume that there always exists a minimum set of non-total tuples to be removed for g3,
as the table in Table 10 shows. In this table the third tuple alone forms a minimum set of
tuples to be removed to satisfy the dependency and it has no NULL.
From that table, we need to remove the third row to have X →sp Y satisfied. Let us
note that adding row (3, 3, 3) gives the same result, so g3(X →sp Y ) = g5(X →sp Y ) = 1.
However, there exist no spWorlds that realize the g3 and g5 measure values and agree on
those tuples that are not removed for g3.
Proof. of Theorem 5.1 Without loss of generality, we may assume that X ∩Y = ∅, because
T |= X →sp Y
⇐⇒T |= X \ Y →sp Y \ X. Also, it is enough to consider attributes in
X ∪Y . Let U = {t1, t2, . . . , tp} be a minimum set of tuples to be removed from T. Let T ′ be
the spWorld of T \ U that satisfies X →Y . Let us assume that t1, . . . ta are such that ti[X]
is not total for 1 ≤i ≤a. Furthermore, let ta+1[X] = . . . = tj1[X], tj1+1[X] = . . . = tj2[X],

---

Approximate Keys and FDs
15
X
Y
X1
X2
1
⊥
1
1
⊥
1
1
1
2
1
1
⊥
1
2
3
Table 10: X-total tuple needs to be removed
. . ., tjf +1[X] = . . . = tp[X] be the maximal sets of tuples that have the same total projection
on X. We construct a collection of tuples {s1, . . . sa+f+1}, together with an spWorld T ∗of
T ∪{s1, . . . , sa+f+1} that satisfies X →Y as follows.
Case 1. 1 ≤i ≤a. Let zi be a value not occurring in T neither in every tuple sj constructed
so far. Let si[A] = zi for ∀A ∈X and si[B] = ti[B] for B ∈R \ X. The corresponding
sp-extensions s∗
i , t∗
i ∈T ∗are given by setting s∗
i [B] = t∗
i [B] = β where β ∈V DB arbitrarily
fixed if ti[B] = ⊥in case B ∈R \ X, furthermore t∗
i [A] = zi if A ∈X and ti[A] = ⊥.
Case 2. X-total tuples. For each such set tjg−1+1[X] = . . . = tjg[X] (g ∈{1, 2, . . . , f + 1})
we construct a tuple sa+g. Let vg
1, vg
2, . . . vg
kg ∈T \ U be the tuples whose sp-extension vg
j
′ in
T ′ satisfies vg
j
′[X] = tjg[X] for 1 ≤j ≤kg. Let vg
1, vg
2, . . . vg
ℓbe those that are also X-total.
Since the X-total part of the table satisfies X →sp Y , tjg−1+1, . . . tjg, vg
1, vg
2, . . . vg
ℓcan be
sp-extended to be identical on Y . Let us take those extensions in T ∗.
Let sa+g be defined as sa+g[A] = za+g where za+g is a value not used before for A ∈X,
furthermore sa+g[B] = vg
ℓ+1[B] for B ∈R \X. The sp-extensions are given as vg∗
q [A] = za+g
if vg∗
q [A] = ⊥and A ∈X, otherwise vg∗
q [A] = vg
q
′[A] for ℓ+ 1 ≤q ≤kg. Finally, let
s∗
a+g[B] = vg
1
′[B] for B ∈R \ X.
For any tuple t ∈T \ U for which no sp-extension has been defined yet, let us keep its
extension in T ′, that is let t∗= t′.
Claim T ∗|= X →sp Y . Indeed, let t1, t2 ∈T ∪{s1, . . . , sa+f+1} be two tuples such that
their sp-extensions in T ∗agree on X, that is t1∗[X] = t2∗[X]. If t1∗[X] contains a new value
zj for some 1 ≤j ≤a + f + 1, then by definition of the sp-extensions above, we have
t1∗[Y ] = t2∗[Y ]. Otherwise, either both t1, t2 are X-total, so again by definition of the sp-
extensions above, we have t1∗[Y ] = t2∗[Y ], or at least one of them is not X-total, and then
t1∗= t1′ and t2∗= t2′. But in this latter case using T ′ |= X →sp Y we get t1∗[Y ] = t2∗[Y ].
The values g3 and g5 are similarly independent of each other for spFDs as in the case of
spKeys.
Theorem 5.2. For any rational number 0 ≤p
q < 1 there exists tables with an arbitrarily
large number of rows and bounded number of columns that satisfy g3(σ) −g5(σ) = p
q for
σ: X →sp Y .

---

16
Munqath Al-atar, Attila Sali
T =
X
Y
X1 X2
1
1
1
1
2
2
...
...
...
1
b
b
⊥
⊥b + 1
⊥
⊥b + 2
...
...
...
⊥
⊥b + x
Table 11: g3 −g5 = p
q
Proof. Consider the following table T. We clearly have g3(X →sp Y ) =
x
x+b for T as all
tuples with NULLs must be removed. On the other hand, by adding new tuples and so
extending the active domains, we need to be able to make at least x + b pairwise distinct
combinations of X-values. If y tuples are added, then we can extend the active domains to
the sizes |V D1| = y + 1 and |V D2| = y + b. Also, if y is the minimum number of tuples to
be added, then
g3(X →sp Y ) −g5(X →sp Y ) = x −y
x + b = p
q
(11)
if cp = x −y and cq = x + b for some positive integer c. From here y = x −cp and
y + b = c(q −p) Thus, what we need is
(y + 1)(y + b) = (y + 1)c(q −p) ≥cq
(12)
and, to make sure that y −1 added tuples are not enough,
y(y + b −1) = y(c(q −p) −1) ≤cq −1.
(13)
Easy calculation shows that (12) is equivalent with y ≥
p
q−p, so we take y =
l
p
q−p
m
. On the
other hand, (13) is equivalent with y ≤
cq−1
c(q−p)−1. Now, similarly to Case 3 of the proof of
Theorem 4.1 observe that
cq−1
c(q−p)−1 →∞as c →∞, so, if c is large enough, then (13) holds.
5.2
Semantic Comparison of g3 and g5
In this section, we compare the g3 and g5 measures to analyze their applicability and usability
for different cases. The goal is to specify when it is semantically better to consider adding
or removing rows for approximation for both spFDs and spKeys.
Considering the teaching table in Table 12, we have the two strongly possible constraints
Semester TeacherID →sp CourseID and sp⟨Semester TeacherID⟩. It requires adding one
row so that asp+
a ⟨Semester TeacherID⟩= +
a Semester TeacherID →sp CourseID. But on
the other hand, it requires removing 3 out of the 6 rows. Then, it would be more convenient

---

Approximate Keys and FDs
17
to add a new row rather than removing half of the table, which makes the remaining rows
not useful for analysis for some cases.
Adding new tuples to satisfy some violated strongly possible constraints ensures that we
make the minimum changes. In addition to that, in the case of deletion, some active domain
values may be removed. There are some cases where it may be more appropriate to remove
rather than add tuples, however. This is to preserve semantics of the data and to avoid using
values that are out of the appropriate domain of the attributes while adding new tuples with
new unseen values. For example, Table 13 represents the grade records for some students
in a course that imply the key (Name, Group) and the dependency Points Assignment →
Result, while both of sp⟨NameGroup⟩and Points Assignment →sp Result are violated by
the table. Then, adding one tuple with the new values (Dummy, 3, 3, Maybe, Hopeless) is
enough to satisfy the two strongly possible constraints, while they can also be satisfied by
removing the last two tuples. However, it is not convenient to use these new values for the
attributes, since they are probably not contained in the intended domains. Hence, removing
two tuples is semantically more acceptable than adding one tuple.
Semester
TeacherID
CourseID
First
1
1
⊥
1
2
First
2
3
⊥
2
4
First
3
5
⊥
3
6
Table 12: Incomplete teaching table
Name
Group
Points
Assignment
Result
Bob
1
2
Submitted
Pass
Sara
1
1
Not Submitted
Fail
Alex
1
2
Not Submitted
Fail
John
1
1
Submitted
Pass
⊥
1
1
⊥
Retake
Alex
⊥
2
⊥
Retake
Table 13: Incomplete course grading table
If g3 is much larger than g5 for a table, it is better to add rows than remove them.
Row removal may leave only a short version of the table which may not give a useful data
analysis, as is the case in Table 11. If g3 and g5 are close to each other, it is mostly better to
add rows, but when the attributes’ domains are restricted to a short range, then it may be

---

18
Munqath Al-atar, Attila Sali
better to remove rows rather than add new rows with ”noise” values that are semantically
not related to the meaning of the data, as is the case in Table 13.
6
Strongly possible tuple generating integrity constraints
6.1
Missing Values and MVD
Investigations of strongly possible worlds can be extended for other types of dependencies,
like multivalued dependencies and cross joins. Note that T |= X ↠sp Y if and only if for
each value in X, all the possible combinations of Y and T \ XY are there in some strongly
possible world of T. Then, there should be at least a ∗b tuples for each value v ∈X, where
a and b are the number of distinct values shown on Y and T \ XY respectively on those
tuples. To check if an FD X →sp Y is valid in a relation R, we only have to check its validity
in the projection R[XY ]; the validity does not depend on the values of the other attributes.
On the other hand, the validity of X ↠sp Y in R depends on the values of all attributes
and cannot be checked in R[XY ] only.
In [28], Lien defined the NMVD over R as a statement X ↠Y and considers that the
left-hand side of the dependency is X-total. According to this, MVD X ↠Y is satisfied by a
relation R, denoted by R |= X ↠Y , if and only if for every two tuples t1, t2 in the relation,
the following is true: if t1 and t2 are X-total and t1[X] = t2[X], then there is some tuples
t such that t[XY ] = t1[XY ] and t[X(R \ Y )] = t2[X(R \ Y )]. The assumption of having
a limited set of values to be replaced with any NULL occurrence makes the satisfaction of
spMVD different compared with NMVD by Lien. In Figure 1, Table 1a satisfies the spMVD
X ↠sp Y , as the spWolrd obtained by replacing the NULLwith either 1 or 2 will satisfy the
MVD X ↠Y ; but it does not satisfy the NMVD X ↠Y , as it violates the NMVD condition.
The same for Table 1b, the spMVD X ↠sp Y is satisfied by replacing the NULLwith 2, and
the NMVD X ↠Y condition is violated. On the other hand, Table 1c violates the X ↠sp Y
and satisfies the NMVD X ↠Y . These cases show that the spMVDs and the NMVDs are
independent of each other where a table may satisfy the NMVD and violates the spMVD
or vice versa.
X
Y
Z
1
1
1
1
1
2
1
1
⊥
(a)
X
Y
Z
V
2
1
1
1
2
2
1
2
2
2
1
1
2
1
1
⊥
(b)
X
Y
Z
1
1
1
2
2
2
⊥
3
3
(c)
Fig. 1: spMV d and NMV D Tables
Proposition 6.1. If T |= X →sp Y then T |= X ↠sp Y .
This is true as in the strongly possible world T ′ of T that satisfies X →Y , then T ′ |= X ↠Y
and then T |= X ↠sp Y .

---

Approximate Keys and FDs
19
X
Y
Z
V
1
1
1
1
⊥
2
1
2
Table 14: X ↠sp Y holds in U = R \ V
It is possible that X ↠sp Y is not valid in R but it is valid in U, where U ⊂R, as in
Table 14: Where X ↠sp Y holds in R \ V but not in R. Furthermore, X ↠sp Y is valid
in R if and only if X ↠sp Y \ X is valid in R. This property of spMVD follows from the
ordinary MVD properties.
In contrast with the ordinary MVD’s, spMVD’s don’t provide a necessary and sufficient
condition for a relation to be decomposable into two of its projections without loss of in-
formation. As it shown in Table 15 with the spMVD X ↠sp Y that is not possible to be
decomposed in a lossless way into XY and XZ.
X
Y
Z
1
1
1
1
⊥
2
Table 15: Decomposition violation table
6.2
Multivalued Dependencies Approximation
This section presents an approximation approach that measures how close an spMVD X ↠sp
Y is satisfied in a table T if the ordinary MVD X ↠Y is voilated by T. We use an
assumption similar to what we presented in Sections 4 and 5, where the total part of the
table satisfies the MVD X ↠sp Y . And we also employee the g3 and g5 measures so that
we remove or add tuples, respectivly, to satisfy the violated spMVD. The two measures, g3
and g5 are defined for spMVD in Definitions 6.1 and 6.2.
Definition 6.1. For the attribute sets X and Y , σ : X ↠sp Y is a remove-approximate
strongly possible multivalued dependency of ratio a in a table T, in notation
T |=≈−
a X ↠sp Y , if there exists a set of tuples S such that the table T \ S |= X ↠sp Y ,
and |S|/|T| ≤a. Then, g3(σ) is the smallest a such that T |=≈−
a σ holds.
Definition 6.2. For the attribute sets X and Y , σ : X ↠sp Y is an add-approximate
strongly possible multivalued dependency of ratio b in a table T, in notation T |=≈+
b X ↠sp
Y , if there exists a set of tuples S such that the table T ∪S |= X ↠sp Y , and |S|/|T| ≤b.
Then, g5(σ) is the smallest b such that T |=≈+
b σ holds.
Where the measures g3(σ) and g5(σ) represent the approximation which is the ratio of the
number of tuples needed to be removed or added, respectively, over the total number of
tuples so that the table T satisfies X ↠sp Y .
Table
16 shows that we need to remove at least 2 tuples (either the first or the last
two tuples) st the the table satisfies x ↠sp Y . While adding only one tuple (a tuple with a
value ”2” on X and ⊥on Y and Z) is enough to satisfy the constraint, then in this case

---

20
Munqath Al-atar, Attila Sali
g3 > g5. On the other hand, in Table 17, it is enough to remove only the last tuple to satisfy
the spMVD X ↠sp Y but it required to add at least 2 tuples (2,1,2,1) and (2,2,1,1), then
g3 < g5. And it is also possible that g3 = g5 as it is shown in Table 18 where removeing
the last tuple or adding the tuple (1,2,1) is enough. Hence, unlike spFd, where it is always
true that g3 ≥g5, here in the case of spMVD g3 and g5 are independent on each other.
X
Y
Z
⊥
1
1
1
1
1
1
⊥
1
1
1
1
1
1
⊥
1
2
2
1
1
1
⊥
2
3
Table 16: MVD
Approximation: g3 > g5
X
Y
Z
1
1
1
1
1
1
2
1
2
1
1
1
2
2
2
⊥
Table 17: MVD
Approximation: g3 < g5
X
Y
Z
1
1
1
1
1
2
1
2
⊥
Table 18: MVD
Approximation: g3 = g5
6.3
Cross joins
In the present section, some results on cross joins are collected. Hannula et.al. [17] show
that the problem of deciding whether there is a cross join that holds on a given table is not
only NP-complete but W[3]-complete in its most natural parameter, namely its arity. In the
proof it is used that if X and Y are given, then checking whether X × Y holds in table r
can easily be done in polynomial time.
However, if r is incomplete, then the same statement does not hold in general. First, we
give a simple case that already illustrates in a sense the reason of possible intractability.
Proposition 6.2. Let R be a relational schema, X, Y ∈R be attributes, T be an incomplete
table over R. Let the problem Singular spCJ be defined as
Input: R, X, Y ∈R and T.
Question: Does T |= X ×sp Y hold?
Then Singular spCJ is in P.
Proof. Let the sizes of active domains V DT
X and V DT
Y be x and y, respectively. A strongly
possible world T ′ satisfies CJ X × Y if and only if for all a ∈V DT
X and b ∈V DT
Y there
exists a tuple t′ ∈T ′ such that t′[X] = a and t′[Y ] = b. Construct a bipartite graph
G = (A, B; E) where A = T and B = V DT
X × V DT
Y and {t, (a, b)} ∈E is an edge iff
t[XY ] ∼w (a, b). Clearly the size of G is a polynomial function of the input size and it can
be constructed by a single scan of the table T. We claim that there exists an spWorld T ′
such that T ′ |= X × Y iff there exists a matching in G covering partite class B. Indeed, if
∀(a, b) ∈B∃t′ ∈T : (t′[X] = a)∧(t′[Y ] = b), then pick one such tuple t′. The edges {t, (a, b)}
form a matching in G covering B, where t′ is the extension of t in T ′.
On the other hand, if a matching covering B exists in G, then an edge {t, (a, b)} represents
a tuple that can be extended to t′ with (t′[X] = a) ∧(t′[Y ] = b). Since B is covered by
the matching, every possible value combinations on attributes X, Y occur in the spWorld
obtained.
The existence of a matching covering B can be checked in polynomial time of the input
graph G, say by the Hungarian Method [32].

---

Approximate Keys and FDs
21
On the other hand, if X, Y can be arbitrary subsets of the schema R, then checking whether
T |= X ×sp Y holds is hard. Let the problem General spCJ be defined as
Input: Schema R, sets of attributes X, Y ⊆R and table T over R.
Question: Does T |= X ×sp Y hold?
Let the weak similarity graphs of X and Y , GT
X and GT
Y be defined as GT
X = (T, ET
X)
(resp. GT
Y = (T, ET
Y ) where {t1, t2} ∈ET
X) iff t1[X] ∼w t2[X] (resp. {t1, t2} ∈ET
Y iff
t1[Y ] ∼w t2[Y ]). If T ′ is an spWorld of T and for tuples t′
1[X] = t′
2[X] = . . . t′
k[X] holds,
then t1, t2, . . . tk form a clique (complete subgraph) of the weak similarity graph GT
X and
the same holds for attribute set Y . This implies that T |= X ×sp Y holds iff there exists
clique partitions QX and QY of the weak similarity graphs GT
X and GT
Y , respectively that
∀Q ∈QX∀Q′ ∈QY : Q∩Q′̸ = ∅. That is, we are given two graphs, and we need a completely
crossing pair of clique partitions of them. This problem seems to be hard. However, to prove
that General spCJ is NP-complete one does not need the full generality of the clique
partition question.
Theorem 6.1. The problem General spCJ is NP-complete.
The following lemma is needed for the proof of Theorem 6.1.
Lemma 6.1. Let G = (V, E) be a simple graph with |V | = k. Then there exists a table over
schema R of k attributes that G is the weak similarity graph of attribute set R.
Proof. Consider R = {A1, A2, . . . , Ak} and define tuple ti for i = 1, 2, . . . , k as follows.
ti[Aℓ] =







1 if ℓ= i
⊥if {vi, vℓ} ∈E
2 if {vi, vℓ}̸ ∈E
(14)
In fact, attribute Ai shows the non-similarities with tuple ti. It is easy to see that in this
table ti ∼w tℓ⇐⇒{vi, vℓ} ∈E.
Proof (of Theorem 6.1). Problem General spCJ is in NP, since an spWorld T ′ satisfying
T ′ |= X × Y is a good witness, as checking a given cross join for a complete table can be
done in polynomial time.
To prove that General spCJ is NP-hard we prove the
3DM ≺GeneralspCJ
(15)
Karp-reduction. Let an input of 3DM be be given as F ⊆B×C×D where |B| = |C| = |D| =
q, they are pairwise disjoint. The question is whether there exists a matching F′ ⊆F such
that |F′| = q and no two members of F′ agree in any coordinate? Let F = {(bi, ci, di): i =
1, 2, . . . , k}. Construct graph G = (V, E) as follows. V = B∪C∪D∪Sk
i=1{aj
i : j = 1, 2, . . . , 9}
and E = Sk
i=1 Ei, where Eiis the set of 18 edges shown on Figure 2. This gadget is taken
from [20]. Actually, what is shown in the famous book of Garey and Johnson is that there
exists a matching F′ if and only if the vertex set of graph G can be partitioned into triangles
(complete graphs of size three). Note that the size of G is |V | = 3q + 9k and |E| = 18k
that is a polynomial function of the input size of the 3DM problem. An incomplete table
T over schema R = {A1, A2, . . . , A|V |, Y } is constructed as follows. The tuples correspond
to the vertices of G and the part over X = {A1, A2, . . . , A|V |} is given by Lemma 6.1 so
that the weak similarity graph GX of X is G. On the other hand, let the Y -values of tuples

---

22
Munqath Al-atar, Attila Sali
corresponding to vertices of G be given by 1 for bi, a3
i , a4
i , a7
i and 2 for ci, a1
i , a6
i , a8
i , finally 3
for di, a2
i , a5
i , a7
i . If some vertices of B ∪C ∪D are not covered by F, that is they are isolated
vertices in G, then their corresponding tuples have Y value 1. Our claim is that there exists
a matching F′ ⊆F if and only if T |= X ×sp Y .
Assume first, that there exists a matching F′ ⊆F say (b1, c1, d1), . . . (bq, cq, dq). Then on
X take weak similarity cliques bia1
i a2
i , cia4
i a5
i , dia7
i a8
i , a3
i a6
i a9
i for i = 1, . . . , q. Furthermore
if (bj, cj, dj) ∈F is not in the matching, then take on X the weak similarity cliques a1
ja2
ja3
j,
a4
ja5
ja6
j, a7
ja8
ja9
j. These cliques partition the tuples of table T. Extend the three tuples in each
clique to the same complete tuple on X, respectively. Observe that each clique meets all
three possible Y values by construction, so the strongly possible world T ′ obtained satisfies
the cross join X × Y .
On the other hand, assume now that T |= X ×sp Y . Observe that cliques of G have size
at most three. Let T ′ be the spWorld that satisfies the cross join X × Y . That means that
each X value occurs in tuple with each three possible Y -values. These tuples must form a
weak similarity clique on X, so a triangle in G. That is the tuples of T are partitioned into
weak similarity cliques of size three, that corresponds to partitioning of the vertex set of G
into triangles. This latter one implies that there is a matching F′ ⊆F by [20].
ci
bi
a2
i
a3
i
a8
i
a9
i
a4
i
a1
i
a6
i
a5
i
a7
i
di
Fig. 2: Gadget for 3DM ≺GeneralspCJ
6.4
Cross Join Approximation
To measure the approximation of spCJ, we employ the measures g3 and g5 to find the
minimum number of tuples to remove or add so that all the values combinations of the
attribute sets X and Y are there in some strongly possible world. To precisely define g3
and g5 for an spCJ σ: X ×sp Y one needs only to consider that X ×sp Y is the same as
the spMVD ∅↠sp X in the projection of the given table to attribute set XY . Note that
g5 may take values larger than 1 in this case. Removing tuples ensures taking off parts of
the table where it is not possible to achieve all the strongly possible combinations. Table 19
shows that removing the last two tuples satisfies the spCJ TeacherID ×sp CourseID, as it

---

Approximate Keys and FDs
23
is not possible in any way to have all the values (1, 2, and 3) on CourseID to appear with
the values of TeacherID. On the other hand, adding one tuple with a null value for each
attribute satisfies the spCJ. The two measure are independent of each other as it is shown
by Table 19 that g3 > g5, Table 20 shows that g3 < g5, and they can be equal as shown in
Table 18 where Y ×sp Z hols.
TeacherID
CourseID
1
1
1
2
1
3
2
⊥
2
⊥
Table 19: Cross Join Approximation:
g3 > g5
TeacherID
CourseID
1
1
1
2
1
3
2
⊥
Table 20: Cross Join Approximation:
g3 < g5
The next two theorems show that not only checking the satisfaction of a given spCJ is
hard, but finding the approximation measures g3 and g5 are NP-complete.
Theorem 6.2. Let problem spCJ −g3 be defined as follows.
Input: Incomplete table T over schema R, attribute sets X, Y ⊆R, rational number q ∈
[0, 1).
Question: Does g3(X ×sp Y ) ≤q hold?
Then spCJ −g3 is NP-complete.
Proof. To show that spCJ −g3 ∈NP the witness is a set U of k tuples to be removed from
T and an spWord T ′ of T \ U such that T ′ |= X × Y and
k
|T | ≤q. It is easy to see that this
witness can be verified in polynomial time.
To prove that spCJ −g3 is NP-hard a Karp-reduction
MaxClique ≺spCJ −g3
is presented. Let the input of MaxClique be graph G = (V, E) and k ∈N, with V =
{v1, v2, . . . , vn}. Construct a table T = {t1, t2, . . . , tn} over schema R = {X, A1, A2, . . . An}
as follows. Let Y = {A1, A2, . . . An}, ti[X] = i and the restriction T[Y ] is constructed by
using Lemma 6.1 so that the weak similarity graph GY is isomorphic to G. Furthermore, let
q = 1 −k
n. Our claim is that (G, k) ∈MaxClique ⇐⇒g3(X ×sp Y ) ≤q. Indeed, assume
first that G ∼= GY has a clique Q ⊆V of size k. Then let T1 = {ti : vI ∈Q}. Since these
tuples form a weak similarity clique in GY , they can be extended to the same value on Y .
(Note that we might need to use the special symbol ssymb introduced after Definition 2.2,
as T1 is obtained from T by removing tuples. Take that spWorld T ′
1 of T1, it clearly satisfies
T ′
1 |= X × Y . Thus g3(X ×sp Y ) ≤|V |−|Q|
|V |
= 1 −k
n.
Theorem 6.3. Let problem spCJ −g5 be defined as follows.
Input: Incomplete table T over schema R, attribute sets X, Y ⊆R, non-negative rational
number q.
Question: Does g5(X ×sp Y ) ≤q hold?
Then spCJ −g5 is NP-complete.

---

24
Munqath Al-atar, Attila Sali
Proof. The witness that spCJ −g5 ∈NP consists an (incomplete) table T ⊆U and an
spWorld U ′ of U such that U ′ |= X × Y and |U|−|T |
|T |
≤q. It is easy to see that the witness
can be checked in polynomial time. To prove that it is NP-hard, a Karp-reduction
3 −Color ≺spCJ −g5
is presented. Let simple graph G = (V, E) be the input of 3 −Color, with V = {v1, v2, . . . , vn}.
Create a table T = {t1, t2, . . . , tn} over schema R = {X, A1, A2, . . . An} as follows. Let
Y = {A1, A2, . . . An}, ti[X] = i and the restriction T[Y ] is constructed by using Lemma 6.1
so that the complement GY of the weak similarity graph GY is isomorphic to G. Let q = 2.
We claim that G is properly 3-colorable iff g5(X ×sp Y ) ≤2.
Assume first that χ(G) ≤3. This means that V can be partitioned into three indepen-
dent sets, that is GY can be partitioned into three cliques. So there exist three possible
Y -extensions yi : i = 1, 2, 3 so that each tuple of T can be extended on Y to one of them.
Add 2n tuples consisting only ⊥’s to T to obtain table U. Let U ′ be the spWorld of U
obtained by extending each ti to one of yi : i = 1, 2, 3, and for each i extend two of the
added 2n tuples to (i, yj where j takes those two values that are not used in the extension
of ti[Y ]. It is clear that U ′ |= X × Y .
On the other hand, assume that g5(X ×sp Y ) ≤2. This means that there exists a table
T ⊆U and an spWorld U ′ of U such that U ′ |= X × Y and |U| ≤3n. Since U ′[X] has at
least n different values and in total U ′ has at most 3n tuples, U ′[Y ] can have at most 3
different values if cross join X × Y holds in U ′. In particular, tuples ti have at most three
different Y -extensions, that is the weak similarity graph GY can be covered with at most
three cliques, that is G can be covered by at most threee independent sets, which gives
χ(G) ≤3.
7
Conclusion and Future Directions
We investigated two approximation measures g3 (the ratio of the minimum number of tuples
to be removed) and the newly introduced measure g5 (the ratio of the minimum number of
tuples to be added) for strongly possible constraints in the present paper. Adding tuples is
only useful for strongly possible constraints, as the new added tuples may add more values
to the active domains of attributes and this may satisfy some strongly possible constraints.
While adding new values cannot satisfy violated ordinary constraints or possible/certain
dependencies.
Instead of removing or adding only tuples one may consider removals and additions
concurrently, or one might even consider tuple modifications. In case of spKeys if first
the additions are performed, then after that by Proposition 4.1 it is always true that we
can remove only non-total tuples; then, instead of any tuple removal, we may add a new
tuple with distinct values. Therefore, mixed modification in that way would not change
the approximation measure, as it is always equivalent to tuples addition only. However,
it is interesting to further investigate the order of removals and additions and its effect on
considering the removals to be substituted by additions. However, for other strongly possible
constraints equivalent statement cannot be proven, so the further research direction of mixed
modifications are interesting research problem for spFDs, spMVDs and spCJs.
Modifying a tuple can also be done by removing the tuple and adding a new one with
the required modification. So, the research question is still open whether tuple modification
can provide better approximation result than adding then removing a tuple.

---

Approximate Keys and FDs
25
We introduced strongly possible versions of multivalued dependencies and cross joins;
definitions and properties are provided. We proved that spFDs determines spMVDs as it is
the case for ordinary FDs and MVDs. We compared our proposed spMVDs with NMVDs
introduced by Lien [27], and its shown that NMVDs and spMVDs are independent of each
other. An investigation on the satisfaction questions of spCJs is provided. We showed that
checking the satisfaction an spCJ of two singular attributes is in P. And also we proved that
the problem of checking spCJs in general is NP-complete.
We extended the approximation measure to other strongly possible integrity constraints.
We proved that the g3 value is less than or equal to the g5 value for a given strongly possible
key or FD in a table. Nevertheless, the two measures are independent of each other in the
sense that v = g3 −g5 for any rational value v such that 0 ≤v < 1. On the other hand, we
showed that the two measures values are independent of each other for a given spMVD or
spCJ in a table.
Some complexity issues were also treated in the present paper continuing the work started
in [4,7]. We showed that the decision problems is T |= X ×sp Y true, does g3(X ×sp Y ) ≤q
hold and does g5(X ×sp Y ) ≤q hold are all NP-complete.
A future research direction is given by the fact that we have no fixed order between
the g3 and g5 measures for spCJs and spMVDs. What is the complexity to decide whether
g3(σ) < g5(σ) for a given σ and table T if σ is an spCJ or spMVD? Another interesting
question is whether one may get better approximations of spFDs, spCJs and spMVDs if
deletions and additions of tuples are both allowed at the same time? This could be a question
like edit distance of graphs, that is we calculate the total number of modifications of the
table, additions and deletions together.
References
1. Munqath Al-Atar and Attila Sali. Approximate keys and functional dependencies in incomplete
databases with limited domains. In International Symposium on Foundations of Information
and Knowledge Systems, pages 147–167. Springer, 2022.
2. Munqath Al-Atar and Attila Sali.
Strongly possible functional dependencies for sql.
Acta
Cybernetica, 2022.
3. Munqath Alattar and Attila Sali. Keys in relational databases with nulls and bounded domains.
In European Conference on Advances in Databases and Information Systems, pages 33–50.
Springer, 2019.
4. Munqath Alattar and Attila Sali. Functional dependencies in incomplete databases with limited
domains. In International Symposium on Foundations of Information and Knowledge Systems,
pages 1–21. Springer, 2020.
5. Munqath Alattar and Attila Sali. Multivalued dependencies in incomplete databases with lim-
ited domain: Properties and rules. In 16th International Miklos Ivanyi PhD & DLA Symposium,
page 226, 2020.
6. Munqath Alattar and Attila Sali. Strongly possible keys for sql. Journal on Data Semantics,
9(2-3):85–99, 2020.
7. Munqath Alattar and Attila Sali. Approximate keys and functional dependencies in incomplete
databases with limited domains–algorithmic perspective. Informatica, to appear.
8. Leopoldo Bertossi. Database repairs and consistent query answering: Origins and further devel-
opments. In Proceedings of the 38th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles
of Database Systems, pages 48–58, 2019.
9. Joachim Biskup and Lena Wiese. A sound and complete model-generation procedure for con-
sistent and confidentiality-preserving databases. Theoretical Computer Science, 412(31):4044–
4072, 2011.

---

26
Munqath Al-atar, Attila Sali
10. P De Bra and Jan Paredaens. Conditional dependencies for horizontal decompositions. In
International Colloquium on Automata, Languages, and Programming, pages 67–82. Springer,
1983.
11. Edgar F Codd. Further normalization of the data base relational model. Data base systems,
pages 33–64, 1972.
12. Ander De Keijzer and Maurice Van Keulen.
A possible world approach to uncertain rela-
tional data. In Proceedings. 15th International Workshop on Database and Expert Systems
Applications, 2004., pages 922–926. IEEE, 2004.
13. Ronald Fagin. Multivalued dependencies and a new normal form for relational databases. ACM
Transactions on Database Systems (TODS), 2(3):262–278, 1977.
14. Alireza Farhangfar, Lukasz A Kurgan, and Witold Pedrycz. A novel framework for imputation
of missing values in databases. IEEE Transactions on Systems, Man, and Cybernetics-Part A:
Systems and Humans, 37(5):692–709, 2007.
15. Chris Giannella and Edward Robertson. On approximation measures for functional dependen-
cies. Information Systems, 29(6):483–507, 2004.
16. Leo A Goodman and William H Kruskal.
Measures of association for cross classifications.
Measures of association for cross classifications, pages 2–34, 1979.
17. Miika Hannula, Zhuoxing Zhang, Bor-Kuan Song, and Sebastian Link. Discovery of cross joins.
IEEE Transactions on Knowledge and Data Engineering, 2022.
18. Sven Hartmann and Sebastian Link. The implication problem of data dependencies over sql
table definitions: Axiomatic, algorithmic and logical characterizations. ACM Trans. Database
Syst., 37(2), June 2012.
19. Yka Huhtala, Juha K¨arkk¨ainen, Pasi Porkka, and Hannu Toivonen. Tane: An efficient algorithm
for discovering functional and approximate dependencies. The computer journal, 42(2):100–111,
1999.
20. David S Johnson and Michael R Garey. Computers and intractability: A guide to the theory
of NP-completeness. WH Freeman, 1979.
21. Martti Kantola, Heikki Mannila, Kari-Jouko R¨aih¨a, and Harri Siirtola. Discovering functional
and inclusion dependencies in relational databases. International journal of intelligent systems,
7(7):591–607, 1992.
22. Ronald S King and James J Legendre. Discovery of functional and approximate functional
dependencies in relational databases. Journal of Applied Mathematics and Decision Sciences,
7(1):49–59, 2003.
23. Jyrki Kivinen and Heikki Mannila. Approximate inference of functional dependencies from
relations. Theoretical Computer Science, 149(1):129–149, 1995.
24. Henning K¨ohler, Uwe Leck, Sebastian Link, and Xiaofang Zhou. Possible and certain keys for
sql. The VLDB Journal, 25(4):571–596, 2016.
25. Henning K¨ohler, Sebastian Link, and Xiaofang Zhou. Possible and certain sql keys. Proceedings
of the VLDB Endowment, 8(11):1118–1129, 2015.
26. Sebastian Kruse and Felix Naumann.
Efficient discovery of approximate dependencies.
Proceedings of the VLDB Endowment, 11(7):759–772, 2018.
27. Y Edmund Lien. Multivalued dependencies with null values in relational data bases. In Fifth
International Conference on Very Large Data Bases, 1979., pages 61–66. IEEE, 1979.
28. Y Edmund Lien.
On the equivalence of database models.
Journal of the ACM (JACM),
29(2):333–362, 1982.
29. Witold Lipski Jr. On databases with incomplete information. Journal of the ACM (JACM),
28(1):41–70, 1981.
30. St´ephane Lopes, Jean-Marc Petit, and Lotfi Lakhal. Efficient discovery of functional dependen-
cies and armstrong relations. In International Conference on Extending Database Technology,
pages 350–364. Springer, 2000.
31. St´ephane Lopes, Jean-Marc Petit, and Lotfi Lakhal. Functional and approximate dependency
mining: database and fca points of view.
Journal of Experimental & Theoretical Artificial
Intelligence, 14(2-3):93–114, 2002.

---

Approximate Keys and FDs
27
32. L´aszl´o Lov´asz and Michael D Plummer. Matching theory, volume 367. American Mathematical
Soc., 2009.
33. Thorsten Papenbrock, Jens Ehrlich, Jannik Marten, Tommy Neubert, Jan-Peer Rudolph, Mar-
tin Sch¨onberg, Jakob Zwiener, and Felix Naumann. Functional dependency discovery: An exper-
imental evaluation of seven algorithms. Proceedings of the VLDB Endowment, 8(10):1082–1093,
2015.
34. Dan A Simovici, Dana Cristofor, and Laurentiu Cristofor. Impurity measures in databases.
Acta Informatica, 38(5):307–324, 2002.
35. Bal´azs Tusor and Annam´aria R V´arkonyi-K´oczy.
Memory efficient exact and approximate
functional dependency extraction with parsit. In 2020 IEEE 24th International Conference on
Intelligent Engineering Systems (INES), pages 133–138. IEEE, 2020.
36. AR V´arkonyi-K´oczy, B Tusor, and JT T´oth. A multi-attribute classification method to solve the
problem of dimensionality. In Recent Global Research and Education: Technological Challenges,
pages 403–409. Springer, 2017.
37. Jef Wijsen. Foundations of query answering on inconsistent databases. ACM SIGMOD Record,
48(3):6–16, 2019.
38. Esteban Zim´anyi and Alain Pirotte.
Imperfect information in relational databases.
In
Uncertainty Management in Information Systems, pages 35–87. Springer, 1997.

---

