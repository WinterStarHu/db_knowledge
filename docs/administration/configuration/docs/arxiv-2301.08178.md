# Work-Efficient Query Evaluation in Constant Time with PRAMs

> 来源: https://arxiv.org/pdf/2301.08178

Logical Methods in Computer Science
Volume 22, Issue 2, 2026, pp. 27:1–27:55
https://lmcs.episciences.org/
Submitted
Dec. 03, 2024
Published
Jun. 12, 2026
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME
WITH PRAMS
JENS KEPPELER a, THOMAS SCHWENTICK
a, AND CHRISTOPHER SPINRATH b
a TU Dortmund University, Germany
e-mail address: jens.keppeler@tu-dortmund.de, thomas.schwentick@tu-dortmund.de
b Lyon 1 University, Liris CNRS, France
e-mail address: christopher.spinrath@liris.cnrs.fr
Abstract. The article studies query evaluation in parallel constant time in the CRCW
PRAM model. While it is well-known that all relational algebra queries can be evaluated
in constant time on an appropriate CRCW PRAM model, this article is interested in the
efficiency of evaluation algorithms, that is, in the number of processors or, asymptotically
equivalent, in the work. Naive evaluation in the parallel setting results in huge (polynomial)
bounds on the work of such algorithms and in presentations of the result sets that can
be extremely scattered in memory. The article discusses some obstacles for constant-time
PRAM query evaluation. It presents algorithms for relational operators and explores three
settings, in which efficient sequential query evaluation algorithms exist: acyclic queries,
semijoin algebra queries, and join queries — the latter in the worst-case optimal framework.
Under mild assumptions — that data values are numbers of polynomial size in the size
of the database or that the relations of the database are suitably sorted — constant-time
algorithms are presented that are weakly work-efficient in the sense that work O(T 1+ε) can
be achieved, for every ε > 0, compared to the time T of an optimal sequential algorithm.
Important tools are the algorithms for approximate prefix sums and compaction from
Goldberg and Zwick (1995).
1. Introduction
Parallel query evaluation has been an active research area during the last 10+ years. Parallel
evaluation algorithms have been thoroughly investigated, mostly using the Massively Parallel
Communication (MPC) model [BKS17]. For surveys, we refer to [KSS18, HY20].
Although the MPC model is arguably very well-suited to study parallel query evaluation,
it is not the only model to investigate parallel query evaluation. Indeed, there is also
the Parallel Random Access Machine (PRAM) model, a more “theoretical” model which
allows for a more fine-grained analysis of parallel algorithms, particularly in non-distributed
Key words and phrases: PRAM, query evaluation, work-efficient, parallel, acyclic queries, free-connex
queries.
A preliminary version of this article was published in the proceedings of the 26th International Conference
on Database Theory [KSS23].
This work was funded by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) —
SCHW 678/8-1.
The third author made his main contributions to this article while working at the TU Dortmund University.
LOGICAL METHODSl IN COMPUTER SCIENCE
DOI:10.46298/LMCS-22(2:27)2026
©
J. Keppeler, T. Schwentick, and C. Spinrath
CC
⃝
Creative Commons

---

27:2
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
settings. It was shown by Immerman [Imm89, Imm99] that PRAMs with polynomially many
processors can evaluate first-order formulas and thus relational algebra queries in time O(1).
In the study of PRAM algorithms it is considered very important that algorithms perform
well, compared with optimal sequential algorithms. The overall number of computation
steps in a PRAM-computation is called its work. An important goal is to design parallel
algorithms that are work-optimal in the sense that their work asymptotically matches the
running time of the best sequential algorithms.
Obviously, for O(1)-time PRAM algorithms the work and the number of processors differ
at most by a constant factor. Thus, the result by Immerman shows that relational algebra
queries can be evaluated in parallel constant time with polynomial work. Surprisingly, to the
best of our knowledge, work-efficiency of O(1)-time PRAM algorithms for query evaluation
has not been investigated in the literature. This article is meant to lay some groundwork in
this direction.
The proof of the afore-mentioned result that each relational algebra query can be
evaluated in constant-time by a PRAM with polynomial work is scattered over several
articles. It consists basically of three steps, translating from queries to first-order logic
formulas [Cod72], to bounded-depth circuits [BIS90], and then to PRAMs [Imm89]. A
complete account can be found in a monograph by Immerman [Imm99]. It was not meant
as a “practical translation” of queries and does not yield one. However, it is not hard to
see directly that the operators of the relational algebra can, in principle, be evaluated in
constant time on a PRAM. It is slightly less obvious, though, how the output of such an
operation is represented, and how it can be fed into the next operator.
Example 1.1. Let us consider an example to illustrate some issues of constant-time query
evaluation on a PRAM. Let q be the following conjunctive query, written in a rule-based
fashion, for readability.
q(x, y, z) ←E(x, x1), E(x1, x2), E(y, y1), E(y1, y2), E(z, z1), E(z1, z2), R(x2, y2, z2)
A (very) naive evaluation algorithm can assign one processor to each combination of
six E-tuples and one R-tuple, resulting in work O(|E|6|R|). Since the query is obviously
acyclic, it can be evaluated more efficiently in the spirit of Yannakakis’ algorithm [Yan81].
After its semijoin phase, the join underlying the first two atoms E(x, x1), E(x1, x2) can be
computed as a sub-query q1(x, x2) ←E(x, x1), E(x1, x2). This can be evaluated by |E|2
many processors, each getting a pair of tuples E(a1, a2), E(b1, b2) and producing output
tuple (a1, b2) in case a2 = b1. The output can be written into a two-dimensional table,
indexed in both dimensions by the tuples of E. In the next round, the output tuples can
be joined with tuples from R to compute q2(x, y2, z2) ←E(x, x1), E(x1, x2), R(x2, y2, z2).
However, since it is not clear in advance, which entries of the two-dimensional table carry
q1-tuples, the required work is about |E|2 ·|R|. Output tuples of q2 can again be written into
a two-dimensional table, this time indexed by one tuple from E (for x) and one tuple from
R (for y2 and z2). Proceeding in a similar fashion, q can be evaluated with work O(|E|3|R|).
Other evaluation orders are possible but result in similar work bounds. In terms of the
input size of the database, this amounts to O(IN4), whereas Yannakakis’ algorithm yields
O(IN · OUT) in the sequential setting, where IN denotes the number of tuples in the given
relations and OUT the size of the query result, respectively.
Let us take a look at the representation of the output of this algorithm. The result tuples
reside in a three-dimensional table, where each dimension is indexed by tuples from E. They
are thus scattered over a space of size |E|3, no matter the size of the result. Furthermore,

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:3
the same output tuple might occur several times due to several valuations. To produce a
table, in which each output tuple occurs exactly once, a deduplication step is needed, which
could yield additional work in the order of |E|6.
The example illustrates two challenges posed by the O(1)-time PRAM setting, which
will be discussed in more detail in Section 2.
▶It is, in general, not possible to represent the result of a query in a compact form, say, as
an array, contiguously filled with result tuples. In the above analysis, this obstacle yields
upper bounds in terms of the size of the input database, but not in the size of the query
result.
▶It might be necessary to deduplicate output (or intermediate) relations, but, unfortunately,
this cannot be done by sorting a relation, since (compact) sorting in constant time is not
possible on PRAMs, either.
We will use compaction techniques for PRAMs from Goldberg and Zwick [GZ95] to
deal with the first challenge. The second challenge is addressed by a suitable representation
of the relations. Besides a general setting without any assumptions, we consider a setting,
where data items are mapped to a linear-sized1 initial segment of the natural numbers by a
dictionary, and a setting where a linear order for the data values is available.
Although every query of the relational algebra can be evaluated by a O(1)-time parallel
algorithm with polynomial work, the polynomials can be arbitrarily bad. In fact, that
a graph has a k-clique can be expressed by a conjunctive query (cf. Section 6.3) with k
variables, and it follows from Rossman’s ω(nk/4) lower bound for the size of bounded-depth
circuit families for k-Clique [Ros08] that any O(1)-time parallel algorithm that evaluates this
query needs work ω(nk/4). Furthermore, it is conjectured that the k-clique problem cannot
be solved in time significantly less than O(nk) by any sequential combinatorial2 algorithm
[ABW15, ABBK17] and therefore it cannot be solved by a constant-time parallel algorithm
with work less than O(nk), either.3
Hence, it cannot be expected that conjunctive queries can be evaluated in constant
time and small work, in general.
Therefore, we consider restricted query classes like
acyclic conjunctive queries or the semijoin algebra, where much better bounds for sequential
algorithms are possible. We show that, for each ε > 0, there are Yannakakis-based algorithms
for acyclic join queries and free-connex acyclic join queries in the dictionary setting with
upper work bounds of O((IN · OUT)1+ε) and O((IN + OUT)1+ε), respectively. Two other
results are work-optimal algorithms for queries of the semijoin algebra, and algorithms for
join queries that are almost worst-case optimal and almost work-optimal.
We emphasise that the stated results do not claim a fixed algorithm that has an upper
work bound W such that, for every ε > 0, it holds W ∈O((IN · OUT)1+ε). It rather means
that there is a uniform algorithm that has ε as a parameter and has the stated work bound,
1As will be discussed at the end of Section 7 an initial segment of polynomial size yields the same results,
in most cases.
2The term combinatorial is frequently used in the Algorithms community. It does not have a formal
definition. In [ABW15] it is said that it “should be interpreted as any practically efficient algorithm that
does not suffer from the issues of FMM such as large constants and inefficient memory usage”. Here, FMM
refers to Fast Matrix Multiplication.
3For arbitrary algorithms this conjectured bound is O(n
kω
3 ), where ω is the fast matrix multiplication
exponent.

---

27:4
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
for each fixed ε > 0. The linear factor hidden in the O-notation thus depends on ε. This
holds analogously for our other upper bounds of this form.
Furthermore, we consider the semijoin algebra, conjunctive queries with their generalised
hypertree width as a parameter, and worst-case optimal join evaluation.
Outline. This article roughly consists of three parts.
The first part consists of three sections. Section 2 reviews some upper and lower bounds
for CRCW PRAMs for some basic operations from the literature and presents a constant
time algorithm that sorts numbers of polynomial size in a padded fashion. Section 3 explains
how databases are represented by arrays and discusses the three settings that we consider.
Section 4 presents some algorithms for basic operations on such arrays.
The second part presents algorithms for relational operators in Section 5.
The third part studies query evaluation in the above mentioned three contexts in which
(arguably) efficient algorithms exist for sequential query evaluation. Section 6 presents our
results for the dictionary setting and Section 7 discusses how results for the other settings
can be obtained, primarily by transforming the database at hand into the dictionary setting.
The results for query evaluation are summarised in Table 4.
The article ends with a conclusion and some additional details about the results of
Goldberg and Zwick [GZ95] in the appendix.
Related versions. This article is an extended version of our ICDT 2023 paper [KSS23].
However, whereas that paper relied on the compaction technique of Hagerup [Hag92b],
this article uses techniques from Goldberg and Zwick [GZ95], which came to our attention
shortly before the final version of [KSS23] was due. These techniques resulted in considerably
better bounds for acyclic and free-connex acyclic queries. Furthermore, in contrast to the
conference paper, we additionally address the evaluation of these queries and queries of the
semijoin algebra in the ordered setting, and the (weakly) worst-case optimal evaluation of
join queries in the general and the dictionary setting.
Most results are also part of the thesis of one of the authors [Spi24, Chapter 3], which
has been written in parallel to this article. However, the exact definitions of the settings
and the presentation of the algorithms and results have diverged and differ slightly.
Related work. The initial motivation for our research was to study parallel constant-time
algorithms that maintain query results in a dynamic setting, where the database can change
over time. This is related to the dynamic complexity framework of Patnaik and Immerman
[PI97] and similarly Dong and Su [DS95]. In this framework, it is studied, which queries can
be maintained by dynamic programs that are allowed to perform a constant time parallel
PRAM computation after each change in the database. In fact, the dynamic programs are
usually expressed by first-order formulas, but, as stated above, the O(1)-time PRAM point
of view is equivalent. Research on dynamic complexity has mostly concentrated on queries
that cannot be expressed in the relational algebra (e.g., involving transitive closure as for
the reachability query). It has mainly considered expressibility questions, i.e., which queries
can be maintained in constant time, at all. Recently, the investigation of such dynamic
programs from the work-efficiency point of view has been initiated [SST+21]. In this line
of research, the plan was to study the work-aware dynamic complexity of database queries.
However, it then turned out that, due to a lack of existing results, it makes sense to first
study how work-efficient queries can be evaluated by constant-time PRAM algorithms in
the purely static setting.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:5
As mentioned above, to the best of our knowledge, work-efficiency of O(1)-time parallel
algorithms has not been investigated in the literature. However, parallel query evaluation
has, of course, been studied for various other models. In a recent article, Wang and Yi
studied query evaluation by circuits [WY22]. Although this is in principle closely related,
the article ignores polylogarithmic depth factors and therefore does not study O(1)-time.
Denninghoff and Vianu [DV91] proposed database method schemas as model for studying
parallel query evaluation. While these schemas are defined for object-oriented databases they
can also be applied to relational databases. However, although [DV91] considers constant-
time parallel evaluation, they do not study the work of O(1)-time parallel algorithms.
Notably, they prove that PRAMs and database method schemas can simulate each other
within a logarithmic time factor under some (reasonable) assumptions [DV91, Section 5].
Finally, query evaluation has been studied extensively in the Massively Parallel Com-
munication (MPC) model, originally introduced by Beame et al. [BKS17]. Particularly
noteworthy in the context of our research is that worst-case optimal algorithms [KBS16]
and Yannakakis’ algorithm [HY19] have been studied within the MPC model. However, the
research focussed – as the name of the model suggests – on the communication between
servers, or more precisely the number of required communication rounds and the load – that
is, the maximal amount of data a server receives during a round. For the actual computation
in between the communication phases, the MPC model has no notion of computation steps;
which is why, for studying work bounds, we opted for the PRAM model instead.
2. A Primer on Constant-Time CRCW PRAM Algorithms
In this section, we define PRAMs and review some results about O(1)-time parallel algorithms
on CRCW PRAMs from the literature. More precisely, we recall some negative results,
in particular for sorting and some positive results, involving quite powerful constant-time
algorithms for approximative prefix sums and linear compaction, and padded sorting. We
also give a O(1)-time algorithm for padded sorting of sequences of numbers of polynomial
size that will be useful for our purposes.
2.1. Parallel Random Access Machines (PRAMs). A parallel random access machine
(PRAM) consists of a number of processors that work in parallel and use a shared memory.
The processors are consecutively numbered from 1 to some number pmax that depends on
the size of the input. Each processor can access its processor number and freely use it in
computations. For instance, a common application is to use it as an array index. The
memory consists of finitely many, consecutively numbered memory cells. The number of a
memory cell is called its address. The input for a PRAM consists of a sequence of n but
strings of length O(log n), residing in some designated input memory cells. We presume that
the word size, that is, the number of bits that can be stored in a memory cell, is bounded by
O(log n).
A processor can access any memory cell in one time step, given its address. Furthermore,
we assume that the usual arithmetic and bitwise operations can be performed in one time
step by any processor.

---

27:6
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
The work of a PRAM computation is the sum of the number of all computation steps
of all processors made during the computation. We define the space required by a PRAM
computation as the maximal address of any memory cell accessed during the computation.4
We mostly use the Concurrent-Read Concurrent-Write model (CRCW PRAM), i.e.,
processors are allowed to read and write concurrently from and to the same memory location.
Weaker PRAM models as CREW or EREW are not able to evaluate relational algebra
queries in constant time. In fact, CREW PRAMs require time Ω(log n) to compute the
logical OR of n bits, and therefore cannot compute the query π∅(R) deciding whether relation
R is empty in constant time [CDR86, Theorem 7].
More precisely, we mainly assume the Arbitrary CRCW PRAM model: if multiple
processors concurrently write to the same memory location, one of them, “arbitrarily”,
succeeds. This is our standard model, and we often refer to it simply by CRCW PRAM.
However, for some algorithms the weaker Common model suffices, where all processors
need to write the same value into the same location. On the other hand, the lower bounds
below even hold for the stronger Priority model, where always the processor with the smallest
processor number succeeds in writing into a memory cell.
It is well known that the weakest of the three models, the Common CRCW PRAM,
can simulate one step of the strongest model, the Priority CRCW PRAM, in constant
time [CDHR88, Theorem 3.2]. The simulation in [CDHR88] only requires an extra O(log n)
work factor, but might require an extra O(n)-factor of space. The technique of [CDHR88,
Theorem 3.2] can be easily adapted to yield an extra O(nϵ) work factor, but also only an
extra O(nϵ)-factor of space, for any ϵ > 0. Many of our upper bounds have an extra nϵ-factor
for work. For those results, the difference between the precise concurrent write mechanisms
is not essential.
For a few algorithms even the Exclusive-Read Exclusive-Write model (EREW PRAM)
model, where concurrent access is forbidden (Proposition 5.2) or the CREW PRAM model,
where concurrent writing is forbidden (Propositions 4.8 and 4.9), are sufficient.
We refer to [J´aJ92] for more details on PRAMs and to [vEB90, Section 2.2.3] for a
discussion of alternative space measures.
As mentioned in the introduction, the PRAM model is a theoretical algorithmic model.
Most of the PRAM-related research has been done in the 1990s or early 2000s. However,
given the growing built-in parallelism of modern hardware there has been considerable recent
interest in the model both with respect to algorithms (e.g., [CF23, AKL+24]), sometimes in
the more abstract work-depth (or work-depth) model (see, e.g., [LVC07]) and with respect to
the transferability of PRAM algorithms to real computers (e.g., [DBS21, GEB21, LFL+24]).
2.2. Lower and Upper Bounds for Constant-Time CRCW PRAM Algorithms.
Next, we are going to review some known results about PRAM algorithms for some basic
algorithmic tasks from the literature. These tasks deal with arrays, a very natural data
structure for PRAMs. Before we describe the results, we first fix some notation for arrays.
An array A is a sequence of consecutive memory cells. The size |A| of A is the number
of memory cells it consists of. By A[i] for 1 ≤i ≤|A| we refer to the i-th cell of A, and to
the (current) content of that cell. We call i the index of cell A[i]. Furthermore, we assume
4For simplicity, we do not count the space that a processor might need for its working register. For some
of our algorithms, the space of a computation under this definition might be significantly smaller than the
number of processors. However, we never state bounds of that kind, since we do not consider them useful.
Thus, our space bounds for an algorithm are always at least as large as the work bounds.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:7
that the size of an array is always available to all processors (for instance, it might be stored
in a “hidden” cell with index 0). Given an index i, any processor can access cell A[i] in O(1)
time with O(1) work.
We will also use arrays whose cells correspond to c underlying memory cells each, for
some constant integer c > 0. In terms of some programming languages this corresponds to
an array of structs (or records). Since a single processor can read and write c memory cells
in constant time, we often blur this distinction. For instance, we might write A[i] for the
i-th block of c memory cells in some array with cn memory cells. In particular, this will
allow us to refer to the i-th tuple of a relation that is stored in that array in a concise way.
Corollary 2.2 below implies that we cannot expect, in general, that query results can be
stored in a compact fashion, that is, the result t1, . . . , tm of m tuples is stored in an array of
size m. This follows from the following lower bound for computing the parity function on
CRCW PRAMs. This Boolean function tests whether the number of ones in a given bit
string is odd.
Proposition 2.1 [J´aJ92, Theorem 10.8]. Any algorithm that computes the parity function
of n variables and uses a polynomial number of processors requires Ω

log n
log log n

time on a
Priority CRCW PRAM.
We thus consider arrays which may have empty cells.5 An array without empty cells
is compact. We say that an algorithm compacts an array A with k non-empty cells, if it
computes a compact array of size k containing all values from the non-empty cells of A.
Proposition 2.1 implies that such an algorithm cannot run in constant-time on our PRAM
models, since otherwise the parity function could be computed by making all cells with value 0
empty, compacting and testing whether the compacted array has odd length. Similarly,
Proposition 2.1 also implies a lower bound for sorting an array.
Corollary 2.2.
(a) Any algorithm that compacts an array with n cells, some of which might be empty, and
uses a polynomial number of processors, requires Ω

log n
log log n

time on a Priority CRCW
PRAM.
(b) Any algorithm that sorts an array with n natural numbers and uses a polynomial number
of processors requires Ω

log n
log log n

time on a Priority CRCW PRAM. This holds even
if all numbers in the array are from {0, 1}.
Since the priority model is a stronger model, the lower bounds stated in Corollary 2.2
also apply to the Arbitrary and Common CRCW PRAM models, cf., e.g. [J´aJ92].
In the remainder of the section, we have a closer look at further lower bounds and at
almost matching upper bounds for approximate compaction and sorting.
2.2.1. Approximate Compaction. Corollary 2.2 rules out any constant-time algorithms that
compact a non-compact array (for the stated models). Therefore, the best we can hope for
is approximate compaction, i.e., compaction that guarantees some maximum size of the
result array in terms of the number of non-empty entries. In the following, λ(n) will be an
accuracy function.
5In terms of some programming languages an empty cell corresponds to a cell containing a special null
value. It can be indicated by storing a special value.

---

27:8
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
We say that an array is of size n is λ-compact, for a function λ, if it has at least
n
1+λ(n)
non-empty cells. That is, n is at most (1 + λ(n))m, where m is the number of non-empty
cells. An algorithm achieves λ-approximate compaction, if it compacts arrays into λ-compact
arrays. We call it order-preserving, if the relative order of array elements does not change.
We can always assume that λ(n) ≥1
n holds, since otherwise, even with only one empty
cell, we would have n ≤(1 + λ(n))(n −1) < n. Later on in this article λ will be a constant
or of the form (log n)−a, for some a.
We will see that approximate compaction can be done quite well, but the following
result implies a trade-off between time and number of processors.
Proposition 2.3 [Cha96, Theorem 5.3]. Any algorithm that achieves λ-approximate com-
paction, for an accuracy function λ, and uses µ(n)n processors on a Priority CRCW PRAM,
for some function µ, requires time Ω(log
log n
log (µ(n)λ(n)+2)).
Corollary 2.4. Any algorithm that achieves λ-approximate compaction for a constant λ > 0
within constant time requires Ω(n1+ε) processors, for some constant ε > 0.
Proof. Let an algorithm be given that achieves λ-approximate compaction in constant
time t. By Proposition 2.3 there is a constant c such that t ≥c log
log n
log (µ(n)λ+2). Therefore,
2t ≥
 log n
log (µ(n)λ+2)
c, and thus
log n
log (µ(n)λ+2) ≤2t/c and log n ≤2t/c log (µ(n)λ + 2). Finally,
we get (µ(n)λ + 2)2t/c ≥n and therefore µ(n)λ + 2 ≥n1/c′, where c′ = 2t/c is a constant.
Since we assumed λ to be constant, we can conclude µ(n) = Ω(n1/c′) and the statement of
the corollary follows.
As a consequence of Corollary 2.2 and Corollary 2.4, our main data structure to represent
intermediate and result relations are (not necessarily compact) arrays. Furthermore, the
best work bounds we can expect for algorithms that compute c-approximate arrays, for some
constant c, are of the form O(n1+ε), for some ε > 0.
It turns out that λ-approximate compaction algorithms matching the lower bound of
Corollary 2.4 indeed exist, even order-preserving ones, and for λ ∈o(1).
Proposition 2.5 [GZ95]. For every ε > 0 and a > 0 there is an O(1)-time parallel algorithm
that achieves order-preserving λ-approximate compaction for λ(n) = (log n)−a. The algorithm
requires work and space O(n1+ε) on a Common CRCW PRAM.
In particular, order-preserving c-approximate compaction is possible for every constant
c > 0.
Proposition 2.5 is not stated in this form in [GZ95], but it readily follows from the next
result on consistent approximate prefix sums.
Let A be an array of size n containing integers. An array B of the same length contains
λ-consistent prefix sums for A, if, for each i ∈{1, . . . , n}, it holds
▶Pi
j=1 A[j] ≤B[i] ≤(1 + λ(n)) Pi
j=1 A[j] and
▶B[i] −B[i −1] ≥A[i].
We revisit the proof, outlined by [GZ95], of the following result in Appendix A for the sake
of completeness, and to assert the space bound, which is not explicitly stated by [GZ95].
Proposition 2.6 [GZ95, Theorem 4.2]. For every ε > 0 and a > 0 there is an O(1)-time
parallel algorithm that computes λ-consistent prefix sums for any array of length n with

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:9
(log n)-bit integers, for λ(n) = (log n)−a. The algorithm requires work and space O(n1+ε)
on a Common CRCW PRAM.
Indeed, Proposition 2.5 follows by using an array A such that A[j] = 1 if the j-th cell
of the array that is to be compacted is non-empty and 0, otherwise. The approximate prefix
sums then yield the new positions for the non-empty cells.
We emphasise that in Proposition 2.5 the size of the cell contents does not matter.
2.2.2. Processor Allocation. A crucial task for PRAM algorithms is to assign processors
properly to tasks. Sometimes this is straightforward, e.g., if each element of some array needs
to be processed by a separate processor. However, sometimes the assignment of processors
to tasks is not clear, a priori. This will, in particular, be the case for the evaluation of the
Join operator. Processor allocation can be formalised as follows.
A task description d = (m, ¯x) consists of a number m specifying how many processors
are required for the task, and a constant number of additional numbers ¯x = (x1, . . . , xk)
serving as “input” for the task, e.g. ¯x may contain links to input arrays or which algorithm
is used to solve the task.A task schedule for a sequence d1, . . . , dn of task descriptions is an
array C of size at least Pn
i=1 mi such that, for every i ∈{1, . . . , n}, there are at least mi
consecutive cells C[ji], . . . , C[ji +mi −1] with content di and each of these cells is augmented
by a link to C[ji], i.e. the cell with the smallest index in the sequence. The tasks specified
by d1, . . . , dn can then be solved in parallel using |C| processors: Processor j can lookup
the task it helps to solve in cell C[j], and using the link it can also determine its relative
processor number for the task. If a cell C[j] is empty, processor j does nothing.
The processor allocation problem is closely related to the prefix sums and interval
allocation problems. We believe the following lemma is folklore. The relationship of these
problems and an analogous result for randomised PRAMs and O(log∗n) time are, for
instance, discussed in [Hag92a, Section 2]. For the sake of completeness we provide a proof
for the deterministic constant-time case here.
Lemma 2.7. For every ε > 0 and λ > 0 there is a O(1)-time parallel algorithm that, given
an array T containing a sequence of task descriptions d1 = (m1, ¯x1), . . . , dn = (mn, ¯xn),
computes a schedule C for d1, . . . , dn of size (1 + λ) P
i=1 mi. It requires work and space
O(|T|1+ε + |C|1+ε) on a Common CRCW PRAM.
Proof. The algorithm first determines, for each task, a “lead processor”, which will be the
processor with the lowest processor number assigned to the task.
For this purpose, it computes consistent λ-approximate prefix sums s1, . . . , sn for the
sequence m1, . . . , mn using Proposition 2.6. It then assigns the first task d1 to processor 1,
and, for i ∈{2, . . . , n}, task di to processor si−1 + 1. Consequently, the algorithm allocates
an array C of size sn for the schedule and sets C[0] = d1, and C[si−1 + 1] = di, for i ≥2.
All remaining cells are initially empty. Since sn ≤(1 + λ) Pn
i=1 mi, the array C has the
desired size.
Thanks to Proposition 2.6 computing the prefix sums requires work and space O(|T|1+ε).
To assign the remaining mi −1 processors to task di, for each i, we observe that, for
each i, there are at least mi −1 empty cells in C between the cell containing di and the
cell containing di+1, because the prefix sums s1, . . . , sn are consistent. Thus, it suffices to
compute links from each empty cell C[j] to the non-empty cell C[k] with maximal number

---

27:10
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
k ≤j and to test, whether j −k is at most mi for the task di with C[k] = di. Due to the
following Proposition 2.8 this can be done with work and space O(|C|1+ε).
We say that an array B provides predecessor links for a (possibly non-compact) array A,
if it has the same length as A and, for each index j, B[j] is the largest number i < j, for
which A[i] is non-empty.
Proposition 2.8. For every ε > 0, there is a O(1)-time parallel algorithm that computes,
for an array A, an array B that provides predecessor links for A with work and space
O(|A|1+ε) on a Common CRCW PRAM.
Proof sketch. Let n = |A| and δ = ε
2. All cells of B are initially set to a null value. In the
first round, the algorithm considers subintervals of length nδ and establishes predecessor
links within them. To this end, it uses, for each interval a nδ×nδ-table whose entries (i, j)
with i < j are initialised by 1, if A[i] is non-empty and, otherwise, by 0. Next, for each triple
i, j, k of positions in the interval, entry (i, j) is set to 0 if i < k < j and A[k] is non-empty. It
is easy to see that afterwards entry (i, j) still carries a 1 if and only if i is the predecessor of
j. For all such pairs i < j, B[j] is set to i. Finally, for each interval, the unique non-empty
cell with a null value is identified or a flag is set if the interval has no non-empty cells at
all. For every interval, (nδ)3 = n3δ processors suffice for this computation, i.e. one processor
for each triple i, j, k of positions in the interval. Since there are
n
nδ = n1−δ intervals, this
yields an overall work of n1−δ · n3δ = n1+2δ = n1+ε. Similarly, the algorithm uses n1−δ many
tables of size n2δ each. Thus, it requires n1+δ ≤n1+ε space.
In the next round, intervals of length n2δ are considered and each is viewed as a sequence
of nδ smaller intervals of length nδ. The goal in the second round is to establish predecessor
links for the cells of each of the smaller intervals that have not yet obtained a predecessor
link. This can be done similarly with the same asymptotic work and space as in round 1.
After ⌈1
δ⌉rounds, this process has established predecessor links for all cells (besides for the
first non-empty cell and all smaller cells).
An analogous result holds for the computation of successor links.
2.2.3. Padded Sorting. Corollary 2.2 mentions another notorious obstacle for O(1)-time
parallel algorithms: they cannot sort (compactly) in constant time, at all. And similarly
to Corollary 2.4 linearly many processors do not suffice to sort in a (slightly) non-compact
fashion. The λ-padded sorting problem asks to sort n given items into an array of length
(1 + λ)n with empty cells in spots without an item.
Proposition 2.9 [Cha96, Theorem 5.4]. Solving the λ-padded sorting problem on a Priority
CRCW PRAM using µ(n)n processors requires Ω(log
log n
log((λ(n)+2)(µ(n)+1))) time.
The following corollary follows from Proposition 2.9 in the same way as Corollary 2.4
follows from Proposition 2.3.
Corollary 2.10. Any constant-time algorithm for the λ-padded sorting problem, for a
constant λ, requires n1+ε processors, for some constant ε > 0.
Thus, we cannot rely on c-padded sorting, for any constant c in constant time with a
linear number of processors.
However, with the help of the algorithms underlying Proposition 2.6 and Proposition 2.5,
it is possible to sort n numbers of polynomial size in constant time with O(n1+ε) work in a

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:11
c-padded fashion. We will see later that this is very useful for our purposes since fixed-length
tuples of numbers of linear size can be viewed as numbers of polynomial size.
Proposition 2.11. For every constant ε > 0, λ > 0, and c > 0 there is a constant-
time Common CRCW PRAM algorithm that sorts up to n integers a1, . . . , an in the range
{0, . . . , nc−1} and stores them (in order) into an array of size (1 + λ)n. More precisely, it
computes an array of size (1 + λ)n whose non-empty cells induce a sequence i1, . . . , in such
that, for all j < ℓ, aij ≤aiℓ. The algorithm requires work and space O(n1+ε).
Proof. We assume that n integers a1, . . . , an are given in an array A of size n. First, each
number ai is replaced by ai(n + 1) + i to guarantee that all numbers are distinct, in the
following. We also choose δ as ε
3.
The algorithm proceeds in two phases. First, it computes numbers b1, . . . , bn of size at
most O(n1+δ) such that, for all i, j, it holds ai < aj if and only if bi < bj. These numbers
are then used in the second step to order the original sequence a1, . . . , an.
For the first phase, we assume that nc > n1+δ holds, since otherwise the first phase can
be skipped.
The algorithm performs multiple rounds of a bucket-like sort, reducing the range by
applying a factor of (1 + λ) 1
nδ in each round.
In the following, we describe the algorithm for the first round. More precisely, we show
that in constant time with work O(n1+δ) numbers b1, . . . , bn can be computed (in an array
B), such that, for each i, j it holds ai < aj if and only if bi < bj and, for every i ≤n, it
holds bi ≤(1 + λ)nc−δ.
First, for each i ≤n, the algorithm determines ci, di such that ai = cinc−1−δ + di and
0 ≤di < nc−1−δ. Since ai ≤nc −1, it holds ci ≤n1+δ −1. Here ci is the “bucket” for ai.
Next, each ci is replaced by a number of size at most (1 + λ)n. To this end, let C be an
array of size n1+δ, all of whose entries are initially empty. For each i, the number ci is stored
in C[ci]. Next, the array C is compacted to size at most (1 + λ)n −1 using Proposition 2.5
with some suitable λ′ < λ. Let C′ denote this compacted version of C. Each ci is then
assigned to its index in C′ as follows: For each index j of C′, if C′[j] is non-empty then j
is stored in C[C′[j]]. We note that since the compaction is order-preserving, we have that
C[ci] < C[ck] if and only if ci < ck.
Finally, for each i ≤n, we let bi be C[ci]nc−1−δ + di. Since C only contains numbers of
size at most (1 + λ)n −1, we get that
bi ≤((1 + λ)n −1)nc−1−δ + nc−1−δ = (1 + λ)nc−δ.
By repeating this procedure for at most O(c) times, we obtain an array B with numbers
b1, . . . , bn of size at most O(n1+δ) such that, for each i ≤n, it holds ai < aj if and only if
bi < bj. This concludes the first phase of the algorithm.
In the second phase, a new array D of size O(n1+δ) is allocated and initialised by
setting, for each i ≤n, D[bi] = i (and empty for indices in D for which no such i exists).
Approximate order-preserving compaction yields an array D′ of size (1 + λ)n such that the
sequence i1, . . . , in of the non-empty cells of D′ fulfils ai1 < · · · < ain.
The work in the second phase is dominated by the compaction. Compacting an array of
size O(n1+δ) can be done with work and space O(n(1+δ)2) thanks to Proposition 2.5. Since
we can assume that δ ≤1 holds, we have
n(1+δ)2 = n1+2δ+δ2 ≤n1+3δ = n1+ε.

---

27:12
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Table 1: Operators of the relational algebra; X denotes a set of attributes, A an attribute,
x an attribute or a constant, and E1, E2 expressions of the relational algebra
Unary Operators
Binary Operators
Select
σA=x(E1)
Join
E1 ⋊⋉E2
Semijoin
E1 ⋉E2
Project
πX (E1)
Difference
E1 \ E2
Union
E1 ∪E2
Thus, the second phase requires O(n1+ε) work and space. This is also an upper bound for
each of the constantly many rounds of the first phase.
Proposition 2.11 suffices for our purposes, but the algorithm can easily be adapted to inte-
gers of unbounded size. However, in general, its running time might not be constant but rather
O(logn m) and the work can be bounded by a term of the form O((1 + λ)(1+ε) logn mn1+ε),
where m is the maximum size of numbers.
3. Databases and their Representations for PRAM Algorithms
In this section, we first recall some concepts from database theory. Then we discuss three
settings that differ by how a PRAM can access the relations of databases.
Finally, we explain how relations can be represented with the help of arrays. While the
concrete representation will depend on the setting, arrays will provide a unified interface
allowing us to represent intermediate results and to evaluate queries in a compositional
manner.
Notation for databases and queries. A database schema Σ is a finite set of relation
symbols, where each symbol R is equipped with a finite set attr(R) of attributes. A tuple
t = (a1, . . . , a|X|) over a finite list X = (A1, . . . , Ak) of attributes has, for each i, a value ai
for attribute Ai. Unless we are interested in the lexicographic order of a relation, induced by
X, we can view X as a set. An R-relation is a finite set of tuples over attr(R). The arity
ar(R) of R is |attr(R)|. For Y ⊆X, we write t[Y] for the restriction of t to Y. And for
Y ⊆attr(R), we set R[Y] = {t[Y] | t ∈R}. A database D over Σ consists of an R-relation
D(R), for each R ∈Σ. We usually write R instead of D(R) if D is understood from the
context. That is, we do not distinguish between relations and relation symbols. The size |R|
of a relation R is the number of tuples in R. By |D| we denote the number of tuple entries
in database D.
In this article we consider expressions of the relational algebra to define queries over
a database schema: Every relation symbol R from the schema is an expression, and given
expressions E1, E2 can be combined into a new expressions τ(E1) and (E1 ◦E2) where τ and
◦range over the unary and binary operators of the relational algebra presented in Table 16,
respectively. As usual, we omit parentheses when writing expressions when it does not lead
to ambiguity. For details on (the operators of) the relational algebra, we refer to [ABL+21].
Throughout this article, D always denotes the underlying database. We always assume
a fixed schema and therefore, in particular, a fixed maximal arity of tuples.
6The relational algebra also features an operator for renaming attributes, but since this can trivially be
done in constant time by a single processor, we omit it here.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:13
Settings. We next describe the three settings that we study in this article, distinguished by
how PRAMs can interact with (input) databases.
In the most general setting, we do not specify how databases are actually stored. We
only assume that the tuples in a relation R are numbered from 1 to |R| and the following
elemental operations can be carried out in constant time by a single processor.
▶Equal(R1, i1, j1; R2, i2, j2) tests whether the j1-th attribute of the i1-th tuple of R1 has
the same value as the j2-th attribute of the i2-th tuple of R2;
▶EqualConst(R, i, j, x) tests whether the j-th attribute of the i-th tuple of R has value x;
▶Output(R, i1, j2; i2, j2) outputs the value of the j1-th attribute of the i1-th tuple of R as
j2-th attribute of the i2-th output tuple;
▶NumTuples(R) returns the number of tuples in relation R.
We note that the operations EqualConst(R, i, j, x) are only required for selections with
constants, e.g. σA=a(R) for a domain value a. For queries without constants, they can be
omitted.
The second setting is the ordered setting. Here we assume that there is a linear order on
the data values occurring in the database D, and that the following additional elemental
operation is available to access this order.
▶LessThan(R1, i1, j1; R2, i2, j2) tests whether the j1-th attribute of the i1-th tuple of R1 is
less or equal than the value of the j2-th attribute of the i2-th tuple of R2.
The third setting is a specialisation of the ordered setting, in which we assume that
data items are small numbers. More precisely, in the dictionary setting we assume that
the database D has small data values, that is, that its data values are natural numbers
from {1, . . . , cval |D|}, for some fixed constant cval. It is in the spirit of dictionary-based
compressed databases, see, e.g., [CGK01]. In a nutshell, such a database has a dictionary
that maps data values to natural numbers and uses these numbers instead of the original
data values throughout query processing. Such dictionaries are often defined attribute-wise,
but for the purpose of this article we assume for simplicity that there is only one mapping
for all values of the database.
To summarise, the general setting makes no assumptions on the data, the ordered setting
assumes that the data is ordered, and the dictionary setting further assumes that it consists
of small numbers.
We will see later how the general and the ordered setting can be translated into the
dictionary setting with reasonable effort, and we will mostly study actual query processing
for the dictionary setting.
We note, that the queries we consider do not refer to any order of data values. Therefore,
a possible order has no semantical use, but it is only used to get better query evaluation
algorithms.
It should be noted that the settings considered here are very analogous to the various
alphabet settings in string algorithms for non-fixed alphabets. For general alphabets, al-
gorithms can only test whether two positions carry the same symbol, for general ordered
alphabets, they can be compared with respect to some linear order. Other algorithms assume
integer alphabets or polymomial integer alphabets, where the symbols are numbers or numbers
of polynomial size in the length of the string, respectively (see, e.g., [Bre92, AB96]).
Next, we will explain how data values, tuples, and relations can be represented by a
PRAM in memory. This is in particular intended for storing (intermediate) results and
having an interface for (database) operations.

---

27:14
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Representing data items. As indicated before, in this article, databases are represented
by arrays. We first explain how data items are represented such that each item only requires
one memory cell.
In the dictionary setting a data value can be directly stored in a memory cell. Conse-
quently, for each relation, a tuple can be stored in a constant number of cells.
However, in the general and the ordered setting we do not make any assumptions on the
size or nature of a single data item. Therefore, we do not assume that a data item can itself be
stored in a memory cell of the PRAM. Instead, we use token of the form (R, i, j) to represent
data values, where R is a relation symbol, i ∈{1, . . . , |R|} and j ∈{1, . . . , |attr(R)|}. More
precisely, (R, i, j) represents the value of the j-th attribute of the i-th tuple in relation
R. We emphasise that different token (R1, i1, j1) and (R2, i2, j2) can represent the same
data value. Note that a single processor can test in constant time whether two such token
represent the same data value using the operation Equal(R1, i1, j1; R2, i2, j2). In the ordered
setting the data values represented can be compared using LessThan(R1, i1, j1; R2, i2, j2).
This encoding extends to tuples in the natural fashion. Furthermore, such token can be
stored in memory cells of a PRAM. We will refer to this encoding as token representation of
a data value or tuple.
Example 3.1. Consider the ternary relation R given by
R =

("Hello", 6000, blob1), ("World", 3.14, blob2), ("Hello", 3.14, blob3)
	
.
The tuples of R can be represented by the token sequences
((R, 1, 1), (R, 1, 2), (R, 1, 3)), ((R, 2, 1), (R, 2, 2), (R, 2, 3)), and ((R, 3, 1), (R, 3, 2), (R, 3, 3)).
However, the third tuple could as well be represented by ((R, 1, 1), (R, 2, 2), (R, 3, 3)).
Of course, even tuples not in R can be represented by token sequences. For instance,
((R, 3, 1), (R, 2, 1)) represents the tuple ("Hello", "World").
Representing databases by arrays. As indicated before, we represent relations by one-
dimensional arrays, whose cells contain tuples or their token representations and might be
augmented by additional data.
There are various possibilities how to deal with ordered relations. One might store a
relation R in an array and, if available, one or more ordered lists of position numbers (with
respect to some attribute lists) in additional index arrays.
However, in this article, we rather represent a relation by one array, which might be
ordered with respect to some attribute list. We made this choice to simplify notation and
because, in most results, only one order of a relation is relevant. The choice does not affect
the complexity results. In the framework with index arrays, algorithms just need to keep
relation arrays and index arrays in sync (by pointers in both directions) and if a relation
array is compacted, its index arrays are compacted, as well.
Due to the impossibility of (perfect) compaction and sorting in constant time, as
discussed in Section 2, our algorithms will often yield result arrays, in which not all cells
represent result tuples.
Therefore, a cell can be inhabited, if it represents a “useful” tuple, or uninhabited,
otherwise, indicated by some flag. In all three settings, we refer to the tuple represented by
an inhabited cell A[i] by A[i].t, even if this representation is via token as in the general and
the ordered setting. In the same spirit we say that a tuple occurs in a cell or a cell contains
a tuple when the cell actually contains a token representation for the tuple. Please note

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:15
that the terms “inhabited” and “uninhabited” are used on the level of tuples, whereas the
terms “non-empty” and “empty” are used on the level of arrays. In particular, an inhabited
cell (not carrying a useful tuple) can be non-empty.
We note that, in all three settings, all elemental operations can be performed by a single
processor in constant time (and space). Since the arities of the relations at hand are always
fixed, this also extends to tuples.
As mentioned before, there might be additional data stored in a cell, e.g., further Boolean
flags and links to other cells of (possibly) other arrays. However, the number of items is
always bounded by a constant, therefore we still view the representation of a tuple together
with this additional data as a cell, since all of it can be read or written in time O(1).
We say that an array represents a relation R, if for each tuple t of R, there is some
inhabited cell that contains t and no inhabited cells represent other tuples not in R. This
definition allows that a tuple occurs more than once. An array represents R concisely, if
each tuple occurs in exactly one inhabited cell. In this case, we call the array concise.
To indicate that an array represents a relation R we usually denote it as R, R′, etc. We
recall that |R| denotes the size of an array representing R, whereas |R| denotes the size of
the relation R.
We call an array representing a relation compact if it has no uninhabited cells. We
similarly adapt the notion of λ-compact arrays to arrays representing relations.
We often consider the induced tuple sequence t1, . . . , t|A| of an array A. Here, ti = A[i].t
is a proper tuple, if A[i] is inhabited, or otherwise ti is the empty tuple ⊥.
Example 3.2. The tuple sequence [(1, 5), ⊥, (3, 4), (8, 3), (1, 5), ⊥, ⊥, (7, 3)] from an array
A of size eight has five proper tuples and three empty tuples. It represents the relation
R = {(1, 5), (3, 4), (8, 3), (7, 3)}, but not concisely. The sequence [(1, 5), (3, 4), (7, 3), ⊥, (8, 3)]
represents R concisely and ordered with respect to the canonical attribute order. It is not
compact but 1
4-compact.
We assume throughout this article that, if a database is represented by arrays, all these
arrays are concise.
In the ordered and dictionary setting an array R that represents a relation R is X-ordered,
for some ordered list X of attributes of R’s schema, if i < j implies A[i].t[X] ≤A[j].t[X], for
all indices i, j. We note that this definition allows that tuples that agree on all attributes of
X occur in any order. We call A fully ordered, if it is X-ordered, for some X that contains
all attributes of R’s schema. In this case, the relative order is uniquely determined for all
tuples. We emphasize that, in neither setting, it is guaranteed that ordered arrays for the
database relations are given a priori; we discuss this in more detail in Section 7.2.
4. Algorithms for Basic Array Operations
In this section, we present algorithms for some basic operations on database arrays which
we will use as building blocks to implement database operations and the transformations
between PRAM settings.
To illustrate some aspects of parallel query processing in the PRAM model we first
consider an example. Afterwards, we introduce some basic operations in Section 4.1. In
Section 4.2, we give algorithms for padded sorting and compaction, based on the algorithms
in Section 2. In Section 4.3 we study work-efficient search and deduplication algorithms in

---

27:16
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
the dictionary setting and in Section 4.4 we consider space-efficient search and deduplication
algorithms for sorted arrays.
Example 4.1. We sketch how to evaluate the projection πB(R) given the array R =
[(1, 5), (3, 4), (7, 3), ⊥, (8, 3)] representing R from Example 3.2.
First, the array R′ = [5, 4, 3, ⊥, 3] is computed and each tuple R[i] is augmented by a
link to R′[i] and vice versa. For instance, t3 = (7, 3) is augmented by a link to the third cell
of R′ containing t′
3 = 3 and t5 = (8, 3) by a link to the fifth cell containing t′
5 = 3 (and vice
versa). We say that the tuples are mutually linked.
To achieve this, the tuples from R are loaded to processors 1, . . . , 5, each processor
applies the necessary changes to its tuple (or the token representation thereof), and then
writes the new tuple to the new array R′. We note that it is not known in advance which
cells of A are inhabited and therefore, we need to assign one processor for each cell. Each
processor only applies a constant number of steps, so the overall work is in O(|R|).
Towards a concise representation of πB(R), a second operation eliminates duplicates.
To this end, it creates a copy R′′ of R′ and checks in parallel, with one processor per pair
(i, j) of indices with i < j, whether R′′[i].t = R′′[j].t holds. If R′′[i].t = R′′[j].t holds, then
cell R′′[j] is flagged as uninhabited. Lastly, the algorithm creates links from every cell in R′
to the unique inhabited cell in R′′ holding the same tuple. To this end, each processor for a
pair (i, j) with R′[i].t = R′′[j].t, for which R′′[i] is still inhabited, augments the cell R′[j]
with a link to R′′[i]. Furthermore, a link from R′′[i] to R[i] is added. Note that multiple
processors might attempt to augment a cell R′′[i] with a link to R[i]; but this is fine, even
in the Common CRCW model. Overall, we get two-step-links from R to R′′ and immediate
links from R′′ to “representatives” in R.
The second operation has a work bound of O(|R|2) because it suffices to assign one
processor for each pair (i, j) of indices and each processor only applies a constant number of
steps.
Observe that the algorithms we sketched above can be realised even in the most
general setting, since all steps can be implemented with Equal and by manipulating token
representations.
As in this example, algorithms for query evaluation will use basic operations. In fact,
besides deduplication, also compaction, (padded) sorting and search will be used.
We will see below that the work bound for deduplication can be considerably improved
in the dictionary setting or if the array is ordered, thereby also improving the bound for the
ordered setting.
4.1. Basic Operations. We now describe the basic array operations which we will use as
building blocks for query evaluation algorithms for PRAMs.
Just as in Example 4.1, the operations are usually applied to arrays representing relations,
and produce an array as output. Furthermore, in all participating arrays, tuples might be
augmented by additional data, in particular, by links to other tuples. In fact, each time a
tuple of an output array results from some tuple of an input array links are added.
We emphasise that the input (and output) arrays of the following operations do not
necessarily have to represent relations concisely, some operations are even only meaningful if
they do not.
▶Compactλ(A) copies the proper tuples in A into distinct cells of an array B of size at
most (1 + λ)k, where k is the number of proper tuples in A and λ > 0 a constant. Mutual

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:17
links are added between each inhabited cell A[i] and the cell of B the contents of A[i]
got copied to. Additionally, the operation preserves the relative order of tuples.
▶Sortλ(A, X) returns an X-ordered array B of size (1 + λ) |A| which contains all proper
tuples of A. Here X is an ordered list of attributes from the relation represented by A.
Mutual links are added between each inhabited cell of A and the corresponding cell of B.
▶SearchTuples(A, B) links every inhabited cell A[i] to an inhabited cell B[j], such that
B[j].t = A[i].t holds, if such a cell exists. We sometimes write SearchTuple(t, B) in the
special case that only one tuple t is searched for.
▶Deduplicate(A) chooses one representative tuple from each set of identical tuples,
deactivates the other tuples and adds a link from each deactivated other tuple to the
representative tuple for the set.
In the remainder of this section, we give O(1)-time parallel algorithms for these opera-
tions.
▶For Compactλ we give an algorithm that even works in the most general setting and relies
on Proposition 2.5.
▶For Sortλ we give an algorithm for the dictionary setting.
▶For the other three operations, we give work-efficient algorithms in the dictionary setting
and space-efficient algorithms that assumes that (at least) one array is ordered in an
appropriate way.
4.2. Algorithms for Compaction and Padded Sorting. In this subsection, we present
algorithms for compaction and sorting. They are both easily inherited from their counterparts
in Section 2.
The following result for Compactλ basically follows from Proposition 2.5.
Lemma 4.2 [GZ95, implied by Theorem 4.2]. For every constant λ > 0 and ε > 0, there
is a O(1)-time parallel algorithm for Compactλ that, given an array A, requires O(|A|1+ε)
work and space on a Common CRCW PRAM.
We note that the result holds even for the most general setting.
Proof. The lemma follows from Proposition 2.5 by observing that for any constant λ > 0
there is an integer a such that λ < (log n)−a holds for all n > 2. The mutual links can be
established as follows: Instead of compacting A directly, the algorithm allocates an array A′
of the same size as A and sets A′[i] = i if A is inhabited, and leaves A′[i] empty otherwise.
Then A′ is compacted using Proposition 2.5. Let B′ be the resulting array. The desired
output array B can then be compiled as follows: Processor j checks whether B′[j] contains
an index i. If yes, it sets B[j] = A[i] and establishes mutual links between B[j] and A[i].
This procedure requires only work and space O(|A|) in addition to the compaction. The
bounds are therefore inherited from Proposition 2.5. The length of B can be determined by
adding an element to the end of A and by following its final link to B.
The following result for Sortλ is easily obtained from Proposition 2.11.
Lemma 4.3. For all constants λ > 0 and k, there is a O(1)-time parallel algorithm for
Sortλ that, given an array A and a list X of k attributes, requires O((|A| + |D|)1+ε) work
and space on a Common CRCW PRAM in the dictionary setting.

---

27:18
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Proof. Let t1, . . . , tn with n = |A| be the tuple sequence given by A. We assume that
X = (A1, . . . , Ak) contains all attributes occurring in A. Otherwise, X can be extended
arbitrarily. In the following we denote by ≤X the lexicographic order induced by X on the
tuples occurring in A.
For each proper tuple ti, the algorithm computes its characteristic number
ci =
k
X
j=1
ti[Aj]mk−j
where m = cval |D| + 1. Observe that, since the database has small values, m is larger
than any value in A. Thus, we have ti ≤X tj if and only if ci ≤cj for all i, j ∈{1, . . . , n}.
Furthermore, a processor can derive ti from ci in constant time.
Thanks to Proposition 2.11 an array of size (1+λ) max{|A| , |D|} representing a sequence
i1, . . . , in, can be computed in constant time with O((|A| + |D|)1+ε) work and space, such
that ij < iℓimplies cij ≤ciℓ. The result array B can then be obtained by storing each tuple
tij in cell B[ij]. If necessary, B can be compacted using Compactλ′ for a sufficiently small λ′
to yield an array of the desired size.
The computation of mutual links is straightforward.
4.3. Work-Efficient Algorithms for Search and Deduplication. In the dictionary
setting, both search and deduplication can be implemented in a work-efficient fashion
based on hashing. The dictionary setting in itself can be seen as a form of hashing, more
precisely, as mapping (arbitrary) data values injectively to small natural numbers O(|D|).
Implicitly, these mappings induce mappings of tuples of arity k to numbers of size O(|D|k).
However, this does not suffice to obtain work-efficient algorithms for search and deduplication
operations. Instead, we lift the basic hashing mappings to the level of tuples in a way that
yields natural numbers of size O(|A|) for tuples from a given array A. More formally, we
call a mapping that maps each inhabited cell of an array A to a number from {1, . . . , |A|},
such that A[i] and A[j] get the same number if and only if A[i].t = A[j].t holds, an array
hash table. Array hash tables can be efficiently computed, as the following lemma states.
Lemma 4.4. For every ε > 0, there is a O(1)-time parallel algorithm that, in the dictionary
setting, computes an array hash table for a given array A, and requires O(|A|) work and
O(|A| · |D|ε) space on an Arbitrary CRCW PRAM.
We note that the array hash table computed by the algorithm underlying Lemma 4.4 is
not uniquely determined by A, but can depend on the “arbitrary” resolution of concurrent
write operations.
Proof sketch. We describe the construction for ε = 1.
Let A1, . . . , Aℓbe the attributes of the relation R represented by A in an arbitrary but
fixed order and define Xj = (A1, . . . , Aj) for all j ∈{1, . . . , ℓ}. The algorithm inductively
computes hash values for tuples in R[Xj] for increasing j from 1 to ℓ. It uses |A| processors.
The idea is to assign, to each tuple t ∈R[Xj], a number in the range {1, . . . , |A|} as
hash value and to augment each cell of A containing a proper tuple t′ with t′[X] = t by
this hash value. The challenge is that the same (projected) tuple t ∈R[Xj] might occur in
multiple cells of A.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:19
Recall that, in the dictionary setting, each value in the active domain is a number of
size at most cval |D|.
For the base case j = 1 the algorithm allocates an auxiliary array B of size cval |D|.
For each i ≤|A|, let ti = A[i].t. Each processor i with a proper tuple writes its processor
number i into cell ti[A1] of B and then augments ti by the value actually written at position
ti[A1]. Note that, for each value a, all processors i with ti[A1] = a will assign the same value
to their tuple ti, since precisely one processor among the processors with ti[A1] = a succeeds
in writing its number to cell ti[A1] on an Arbitrary CRCW PRAM. This needs O(|A|) work
and O(|A| + |D|) space.
For j > 1 the algorithm proceeds similarly but also takes, for a tuple t, the previous hash
value hj−1(t[Xj−1]) for t[Xj−1] into account, in addition to t[Aj]. It allocates an auxiliary
array B of size |A|·cval |D| which is interpreted as two-dimensional array and each processor
writes its number i into cell (hj−1(ti[Xj−1]), ti[Xj]) of B, if ti is a proper tuple. The number
written into this cell is then the hash value for ti[Xj], as in the base case.
Writing and reading back the processor numbers requires O(|A|) work and B requires
O(|A|·|D|) space. The same bounds hold for the recursive invocations of ComputeHashvalues.
Since the recursion depth is ℓ, the procedure requires O(ℓ· |A|) = O(|A|) work and, because
the space for B can be reused, O(|A| · |D|) space in total. This concludes the proof for the
case ε = 1 and, of course, the same construction works for ε > 1.
For ε < 1, each attribute can be replaced by a list of ⌈1
ε⌉attributes with values of size
O(|D|ε). The factor |D| in the space bound above can thus be replaced by |D|ε, as in the
statement of the lemma. The asymptotic overall work is not affected by this adaptation,
since it only adds a factor of ⌈1
ε⌉.
Lemma 4.5. For every ε > 0, there is a O(1)-time parallel algorithm for SearchTuples
that, given arrays A and B requires work O(|A| + |B|) and space O((|A| + |B|) · |D|ε) in
the dictionary setting.
Proof sketch. First an array hash table for (the concatenation of) A and B is computed
with O(|A| + |B|) work and O((|A| + |B|) · |D|ε) space, similarly as in Lemma 4.4. For a
proper tuple t, let h(t) denote the hash value in the range {1, . . . , |A| + |B|} assigned to t.
The algorithm then allocates an auxiliary array C of size |A| + |B| and, for each proper
tuple si in B, it writes, in parallel, i into cell h(si) of C. Here si denotes the i-th tuple
from B. Other processors might attempt to write an index to cell h(si), but only one will
succeed. This requires O(|B|) work to write the indices and O(|A| + |B|) space for C.
For each proper tuple t in A it is then checked in parallel, if cell h(t) contains an index i.
If yes, then t is marked and augmented with a pointer to cell B[i], since B[i].t = t. If not,
then t has no partner tuple in B, thus t is not augmented by a link.
We note that in the special case that A consists of a single tuple t, the algorithm is
worse than the naive algorithm that just compares t with each tuple of B since that also
requires work O(|B|) but does not need any additional space.
Array hash tables also yield a work-efficient algorithm for deduplication in a straightfor-
ward way.
Lemma 4.6. For every ε > 0, there is a O(1)-time parallel algorithm for Deduplicate in
the dictionary setting that, on an Arbitrary CRCW PRAM, requires work O(|A|) and space
O(|A| · |D|ε).

---

27:20
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Proof sketch. The algorithm first computes an array hash table for A with O(|A|) work
and O(|A| · |D|ε) space, thanks to Lemma 4.4. For a proper tuple t, let h(t) denote the
hash value in the range {1, . . . , |A|} assigned to t. The algorithm then allocates an auxiliary
array B of size |A| and, for each proper tuple ti in A, it writes, in parallel, i into cell h(ti)
of B. Here ti denotes the i-th tuple from A. Several processors might attempt to write an
index into the same cell h(ti), but only one will succeed. This requires O(|A|) work to write
the indices and O(|A|) space for B.
For each proper tuple ti in A it is the index j stored in cell h(ti) is then compared,
in parallel, with i. If i = j then ti is a representative and remains active. Otherwise, ti is
marked as a duplicate and a pointer to tj is added.
4.4. Order-Based Algorithms for Search and Deduplication. Even though the algo-
rithms of Section 4.3 are work-optimal, they require some additional space, e.g., O(|A|·|D|ε)
in Lemma 4.6. In this subsection, we consider algorithms that are slightly more space-efficient
whenever |A| < |D|. They require that data values are equipped with a linear order, but do
not rely on the dictionary setting. However, they are not work-optimal and require that at
least one of the arrays is ordered and has some additional structure.
In sequential database processing, indexes implemented by search trees make it possible
to efficiently test whether a given tuple is in a given relation and to find the largest “smaller”
tuple, if it is not. In a concise ordered array, this is possible in constant time with work
O(|A|ε) by “|A|ε-ary search”. That is, in a first round a sub-array of length |A|1−ε containing
the tuple (if it is there) is identified by inspecting |A|ε cells, and so on. However, in arrays
with uninhabited cells, this might fail, since these are not helpful for this process. To this
end, the algorithms in this subsection use predecessor and successor links, linking each
(inhabited or uninhabited) cell to the next smaller or larger inhabited cell, respectively. We
say an array is fully linked if such links are available. By Proposition 2.8 we know that
predecessor and successor links can be computed in constant time with work and space
O(|A|1+ε).
For fully ordered arrays, deduplication is very easy.
Lemma 4.7. For every ε > 0, there is a O(1)-time parallel algorithm on an Arbitrary
CRCW PRAM for Deduplicate that, given a fully ordered array A requires work and space
O(|A|1+ε).
Proof sketch. The algorithm basically uses the algorithm of Proposition 2.8 twice. During
the first time, it computes predecessor and successor links just as in Proposition 2.8. Then,
for every proper tuple t, t is marked as a representative, if the predeccessor tuple of t is
different from t. Then the algorithm of Proposition 2.8 is applied a second time but this time
cells whose tuple are not representatives are treated like uninhabited cells resulting in the
computation of a link to the next representative (of the same tuple) and from representatives
to the previous representative (of a smaller tuple).
In fully linked and ordered arrays, it is possible to search efficiently for tuples.
Proposition 4.8. For every ε > 0, there is a O(1)-time parallel algorithm on a CREW
PRAM for SearchTuples that, given arrays A and B requires work and space O(|A| · |B|ε)
if the array B is fully linked and fully ordered. In fact, if the algorithm computes, for each
tuple t of A the largest index i with B[i].t[X] ≤t (or the smallest index j with B[j].t[X] ≥t).
Here, X denotes the list of attributes, such that B is X-ordered.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:21
If B is fully ordered, but not fully linked, the combination with Proposition 2.8 yields
an upper bound of O((|A| + |B|) · |B|ε).
Proof sketch. Let n = |B|. The algorithm performs the following search, for each proper
tuple t of A in parallel. In the first round, using nε processors, the algorithm aims to identify
a number j with jn1−ε ≤i < (j + 1)n1−ε for the largest index i with B[i].t[X] ≤t. To this
end, it tests, for all cells with positions of a form k = ℓ· n1−ε for 0 ≤ℓ< nε whether B[k]
(or its successor if B[k] is not inhabited) contains a tuple t′ such that t′[X] ≤t holds and
whether this does not hold for position (ℓ+ 1)n1−ε or its successor. The search continues
recursively in the thus identified sub-interval. After ⌈1
ε⌉rounds it terminates. Since, in each
round, nε processors are used (per tuple t), the statement follows.
We note that, unlike for Lemma 4.5, the algorithm is also quite efficient for the single
tuple case (|A| = 1).
As an alternative to fully-linked arrays, bounded-depth search trees with degree about
nε could be used as index structures. They can be defined in the obvious way. The work for
a search is then asymptotically the same as for fully linked ordered arrays.
Interestingly, there is a dual algorithm with almost dual bounds in the case that A is
fully ordered, instead of B.
Proposition 4.9. For every ε > 0, there is a O(1)-time parallel algorithm on an Arbitrary
CREW PRAM for SearchTuples that, given arrays A and B requires work and space
O((|A| + |B|) · |A|ε), if the array A is fully ordered.
However, unlike the algorithm of Proposition 4.8, this algorithm does not guarantee to
identify the largest index i with B[i].t[X] ≤t (or the smallest index j with B[j].t[X] ≥t).
Proof sketch. First, the algorithm computes a deduplicated version A′ of A and, in particular,
computes links from all tuples of A to their representatives in A′. Then, it searches, for
each proper tuple s in B, the smallest tuple t in A′ with t ≥s. If t = s then the cell of t
is marked and a link to the cell of s is added. We note that if B is not concise, multiple
processors might attempt to write a link for a cell of a proper tuple t in A′, but only one of
them succeeds. Finally, for each proper tuple t in A, if its representative in A′ has obtained
a link to a tuple in B, this link is added to t.
5. Database Operations
In this section, we proceed similarly to Section 4. We start by defining array-based operations
for the operators of the relational algebra. The main contribution of this section is the
presentation of O(1)-time parallel algorithms for these operations and the analysis of their
complexity with respect to work and space. Before we do that in Section 5.2, we will first
present some lower bounds in Section 5.1 that are consequences of the impossibility results
of Section 2.

---

27:22
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Array-based database operations. For database operations, unlike for the basic opera-
tions, we require that input relations are given by arrays representing them concisely. That
is, each tuple occurs exactly once in the array. Likewise, all algorithms produce output
arrays which represent the result relation concisely. However, neither for input nor for output
relations we make any assumptions about the compactness of the representations, i.e., there
can be uninhabited cells.
More precisely, we actually present O(1)-time parallel algorithms for the following
operations (on arrays) which correspond to the operators of the relational algebra (on
relations).7
Recall that we denote arrays representing relations R,S, etc. by R, S, etc.
▶SelectA=x(R) returns a new array R′ that represents σA=x(R) concisely. Here A is an
attribute of R and x is either an attribute of R or a domain value.
▶ProjectX (R)] returns a new array R′ that represents πX (R) concisely. Here X is a set
or sequence of attributes from R.
▶Difference(R, S) returns a new array that represents R \ S concisely. Here R and S are
relations over the same set of attributes.
▶Union(R, S) returns a new array that represents R ∪S concisely. Here R and S are
relations over the same set of attributes.
▶SemiJoin(R, S) returns a new array R′ that represents R ⋉S concisely.
▶Join(R, S) returns a new array that represents R ⋊⋉S concisely.
We note that the relational algebra has an additional rename operator, which, of course,
does not require a parallel algorithm.
5.1. Lower Bounds. In this subsection, we show two lower bound results for algorithms
that compute the semijoin of two unary relations R and S:
▶there is no O(1)-time parallel algorithm using a polynomial number of processors, that
stores the result in an array of size |R ⋉S|;
▶any algorithm that stores the result in an array of size (1 + λ) |R ⋉S|, for each input,
requires n1+ε processors.
These lower bounds rely on the lower bounds for the exact compaction problem (Corol-
lary 2.2(a)) and the λ-approximate compaction problem (Corollary 2.4), respectively. Note,
that the lower bounds even hold if the input arrays are concise, compact and fully ordered.
Our lower bounds are stated in the following theorem.
Theorem 5.1. Let λ > 0 be a constant. For every CRCW PRAM algorithm for the operation
SemiJoin the following statements hold.
(a) If the algorithm uses a polynomial number of processors and produces compact output
arrays, for every possible input, then it has running time Ω

log n
log log n

.
(b) If the algorithm only needs constant time and produces λ-compact output arrays, for
every possible input, then it needs at least Ω(n1+ε) processors, for some constant ε > 0.
Here n is the size of the input arrays. The lower bounds even hold if the input relations R
and S are unary and represented by concise, compact and fully ordered arrays R and S, and
the database has small values.
7We believe that distinguishing between operations on arrays and operations on relations also improves
the readability of (pseudo-code) algorithms and proofs.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:23
Proof. Both results basically use the same reduction from the respective compaction problem.
We first prove the second part. Assume for contradiction that there is a CRCW PRAM
algorithm for SemiJoin that guarantees a λ-compact output array and runs in constant
time using µ(n) processors, where µ(n) ≥n and µ(n) = o(n1+ε), for every ε > 0. We show
how this algorithm can be used to solve the approximate compaction problem with µ(n)
processors in constant time.
Let B be an input array of size n with k non-empty cells for the λ-approximate
compaction problem.
In the first step create an array R of size n for the unary relation R that consists of the
even numbers from 2 to 2n. This can be done in parallel in constant time with n processors.
Let S be an array of size n. In the second step, store, for every i ∈{1, . . . , n}, the value
2i in S[i] if B[i] is not empty, and otherwise store the value 2i + 1 in S[i]. Hence, the query
result of q exactly consists of all even numbers 2i, for which B[i] is not empty.
Note, that by construction, the arrays for the relations R and S are concise, compact,
and fully ordered.
From the array for the query result a solution for the linear approximate compaction
problem can be obtained by replacing every value 2i in the result by B[i]. The size of the
compact array is at most (1 + λ) |R ⋉S| = (1 + λ) |R ⋊⋉S| = (1 + λ)k.
All in all, the algorithm takes constant time and uses µ(n) processors to solve the linear
approximate compaction problem. Hence, by Proposition 2.3 it holds µ(n) = Ω(n1+ε), for
some ε > 0. By the same construction, an algorithm for SemiJoin (or Join) according to
(a) yields an exact compaction algorithm that works in constant time with polynomially
many processors, contradicting Corollary 2.2(a).
Of course, the result also holds for the join of two unary relations.
We emphasise that Theorem 5.1 (b) really relies on the condition that the output array
is λ-compact, since we will see below in Proposition 5.4 that SemiJoin can be computed
with linear work without this condition, in the dictionary setting.
5.2. Algorithms and Upper Bounds. With the notable exception of the Join operation,
for most operations our algorithms are simple combinations of the algorithms of Section 4.
These simple algorithms are presented in Section 5.2.1.
The algorithms for the Join operation are slightly more involved and are presented in
Section 5.2.2.
We present algorithms for the dictionary setting and algorithms that do not rely on the
dictionary setting but assume that some input array is suitably ordered (and possibly fully
linked).
5.2.1. Algorithms for the Operations of the Semijoin Algebra. For the operators of the
semijoin algebra, i.e. all except the Join-operation, we will present “high-level” algorithms
built upon the basic array operations introduced in Section 4. Plugging in the concrete
algorithms for the basic operation then yields different algorithms with different assumptions
and (slightly) different complexities. More precisely, there is always an algorithm for the
dictionary setting that has no further assumptions and there are algorithms that require
that some arrays are suitably ordered.

---

27:24
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Table 2: Complexity bounds for the operations of the semijoin algebra in the dictionary
setting
Operation
Result
Work bound
Space bound
SelectA=x(R)
Proposition 5.2
O(|R|)
O(|R|)
ProjectX (R)
Proposition 5.3
O(|R|)
O(|R| · |D|ε)
SemiJoin(R, S)
Proposition 5.4
O(|R| + |S|)
O((|R| + |S|) · |D|ε)
Difference(R, S)
Proposition 5.5
O(|R| + |S|)
O((|R| + |S|) · |D|ε)
Union(R, S)
Proposition 5.6
O(|R| + |S|)
O((|R| + |S|) · |D|ε)
Table 3: Complexity bounds for the operations of the semijoin algebra in the ordered (and
dictionary) setting. In the conditions for the SemiJoin operation, X is the set of
common attributes of R and S.
Operation
Result
Work and space bound
Conditions
SelectA=x(R)
Proposition 5.2
O(|R|)
–
ProjectX (R)
Proposition 5.3
O(|R|1+ε)
if R is X-ordered
and fully linked
SemiJoin(R, S)
Proposition 5.4
O(|R| · |S|ε)
if S is X-ordered
and fully linked
O((|R| + |S|) · |R|ε)
if R is X-ordered
and fully linked
Difference(R, S)
Proposition 5.5
O(|R| · |S|ε)
if S is fully ordered
and fully linked
O((|R| + |S|) · |R|ε)
if R is fully ordered
and fully linked
Union(R, S)
Proposition 5.6
O(|R| · |S|ε + |S|)
if S is fully ordered
and fully linked
An overview of the work and space bounds obtained by the algorithms for the dictionary
setting is given in Table 2. The bounds for the other algorithms are given in Table 3, together
with the underlying assumptions.
Proposition 5.2. For every x that is either a domain value or an attribute there is a
O(1)-time parallel algorithm for SelectA=x that, given an array R, requires O(|R|) work
and space on an EREW PRAM. The output array is of size at most |R|. If R is X-ordered,
then the output is X-ordered, too.
Proof. The algorithm simply assigns to each tuple one processor, which replaces the tuple
by ⊥if it does not fulfil the selection condition. Obviously, the output is ordered, if R is
ordered.
Proposition 5.3. For every ε > 0 and every sequence X of attributes, there are O(1)-time
parallel algorithms for ProjectX that, given an array R, have the following bounds on an
Arbitrary CRCW PRAM.
(a) Work O(|R|) and space O(|R| · |D|ε) in the dictionary setting;

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:25
(b) Work and space O(|R|1+ε), if R is fully ordered.
The algorithms also provide links from the tuples in R to the respective result tuples and
from the tuples of the result relation to some “source tuple”. The output array is of size |R|.
If R is Y-ordered, for some Y, then the output is Y-ordered, too.
We note that in (b) the requirement that R is fully linked is only needed to meet the
space bound, since the computation of full links is possible within the given work bound
(possibly using more space).
Proof for Proposition 5.3. The algorithm first computes with O(R) work and space an
array R′ that has, for each tuple of R, the respective projected tuple. Then it invokes
Deduplicate(R′) to single out representatives for tuples with multiple appearances. It
then marks duplicates, i.e., cells that do not contain any representative, as uninhabited
and outputs the resulting array. The links can be easily computed with the help of the
links provided by Deduplicate(R′). The work and space bounds are dominated by the
deduplication, therefore the bounds follow from Lemma 4.6 and Lemma 4.7, respectively.
To apply Lemma 4.7 it is crucial that R′ is fully ordered w.r.t. X, which is the case since R
is ordered w.r.t. X.
Proposition 5.4. For every ε > 0, there are O(1)-time parallel algorithms for SemiJoin
that, given arrays R and S have the following bounds on an Arbitrary CRCW PRAM.
(a) Work O(|R| + |S|) and space O((|R| + |S|) · |D|ε) in the dictionary setting;
(b) Work and space O(|R| · |S|ε), if S is fully X-ordered and fully linked;
(c) Work and space O((|R| + |S|) · |R|ε) if R is fully X-ordered.
Here, X denotes the set of joint attributes of the relations R and S.8 The output array is of
size |R|. If R is Y-ordered, then the output is Y-ordered, too.
Proof sketch. The “high-level” algorithm is identical for (a) and (c), but they yield different
bounds due to different implementations of some operations. Afterwards, we discuss how
the algorithm is adapted for (b).
First, the algorithm computes arrays R′ and S′ which represent R′ = πX (R) and
S′ = πX (S) by applying the projection to X to each tuple. These arrays are, in general, not
concise. It further adds links between each tuple and its projection and vice versa.
The algorithm then uses SearchTuples(R′, S′) to augment every tuple in R′ by a link,
if there is a corresponding tuple in S′. Tuples in R′ without a corresponding tuple in S′
are dropped. Finally, using |S| processors, the algorithm computes, for those tuples, whose
projection has a link to a tuple in S′, links to tuples in S, using the available pointers from
R-tuples to R′-tuples and from S′-tuples to (some) S-tuples. For (a) and (c), the work
and space for SearchTuples dominate the overall work and space and the bounds therefore
follow from Lemma 4.5 and Proposition 4.9, respectively.
To achieve the stated work bound in (b), with the help of Proposition 4.8, S′ is actually
not materialised, but instead the tuple search algorithm is adapted to find partner tuples
in S, for each tuple in R′. This is possible, since S is fully X-ordered.
By almost the same algorithms, the same bounds hold for Difference. However, a
tuple remains in the result, if there is no partner tuple in S, and any list of attributes, for
which S (or R) is ordered, works.
8In (b) and (c), X can be any list of these attributes.

---

27:26
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Proposition 5.5. For every ε > 0, there are O(1)-time parallel algorithms for Difference
that, given arrays R and S have the following bounds on an Arbitrary CRCW PRAM.
(a) Work O(|R| + |S|) and space O((|R| + |S|) · |D|ε) in the dictionary setting;
(b) Work and space O(|R| · |S|ε), if S is fully ordered and fully linked;
(c) Work and space O((|R| + |S|) · |R|ε) if R is fully ordered.
The output array is of size |R|. If R is Y-ordered, then the output is Y-ordered, too.
Finally, we consider the operation Union. It is trivial to compute a non-concise rep-
resentation of R ∪S from concise representations of R and S, by basically concatenating
the arrays R and S. To obtain a concise representation, Proposition 5.5 can be used to
compute a representation of R \ S, which then can be concatenated with S. Conciseness is
then guaranteed since R \ S and S are disjoint. This yields the following result.
Proposition 5.6. For every ε > 0, there are O(1)-time parallel algorithms for Union that,
compute concise representations of R ∪S, given concise arrays R and S, and have the
following bounds on an Arbitrary CRCW PRAM.
(a) Work O(|R| + |S|) and space O((|R| + |S|) · |D|ε) in the dictionary setting;
(b) Work and space |R| · |S|ε + |S|, if S is fully ordered and fully linked.9
The output array is of size |R| + |S|.
5.2.2. Algorithms for the Join-Operation. In this section, we present algorithms for the
Join-operation. There is a straightforward naive algorithm that requires work Θ(|R| · |S|),
comparing every tuple in R with every tuple in S. In fact, for unordered data, there is no
better algorithm as will be shown in Theorem 7.1.
In the dictionary setting, or if R and S are appropriately ordered one can do significantly
better. However, Theorem 5.1 indicates that any constant time algorithm that computes
the join of R and S and represents its result by a λ-compact array, for some λ, may require
Ω(|R|1+ε + |S|1+ε) processors.
On the other hand, since the output relation needs to be materialised by any algorithm,
the work has to be Ω(|R ⋊⋉S|).
We will see that these lower bounds can be almost matched: in fact, if one of the
relations is properly ordered the work can be bounded by O(|R|1+ε + |S|1+ε + |R ⋊⋉S|1+ε).
The algorithm first computes a λ-compact array A′ representing R ⋉S and a X-sorted
array B′ representing S ⋉R, where X is a list of all common attributes of R and S.
Afterwards, each tuple from A′ needs to be combined with each tuple from B′ with the same
X-projection. Thanks to its ordering the latter tuples are already grouped appropriately
in B′.
However, to get the desired work bound, it does not suffice to merely λ-compact B′.
To see this, consider the join of two relations R and S along a join attribute X. Let us
assume, both relations consist of n tuples and there are n0.4 attribute values that occur n0.3
times in both relations and all other attribute values occur only once. Each of the frequent
values induces n0.6 output tuples, the n0.4 values together thus yield n output tuples. The
infrequent values result in slightly less than n output tuples. Even if both R and S are
λ-compact, it is possible that in R and S the tuples of each frequent value stretch over a
subarray of n0.6 cells. Assigning processors to each pair of such cells (one in R and one
9Of course, the roles of R and S can be exchanged.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:27
in S) would require n1.5 processors, violating the desired upper bound. To overcome this
challenge, the algorithm will rather compact each group separately.
We are now ready to present our algorithms for the Join operation.
Proposition 5.7. For every ε > 0 and every λ > 0, there are O(1)-time parallel algorithms
for Join that, given arrays R and S have the following bounds on an Arbitrary CRCW
PRAM. Here, X denotes the joint attributes of R and S.
(a) Work and space O((|S| + |D|)1+ε + |R|1+ε + |R ▷◁S|1+ε) in the dictionary setting;
(b) Work and space O(|S|1+ε + |R|1+ε + |R ▷◁S|1+ε) if S is fully X-ordered.
In both cases, the size of the output array is bounded by (1 + λ) |R ▷◁S|.
Proof. Let R and S denote the relations represented by R and S, respectively. Let further
δ = min{1
3, ε
3} and λ′ = min{1
3, λ
3}.
The algorithm for (a) is by sorting S according to Lemma 4.3 and applying the algorithm
for (b) afterwards.
The algorithm for (b) proceeds as follows.
(1) Compute array A1 representing R ⋉S and λ′-compact it.
(2) Compute an X-sorted array B1 representing S ⋉R.
(3) Fully link B1 according to Proposition 2.8.
(4) Let B2 be ProjectX (B1).
(5) For each proper tuple s of B2, compute the positions i1(s) and i2(s) of the first and last
tuple of B1 whose X-projection is s, respectively.
(6) For each proper tuple s of B2, λ′-compact the subarray of B1 from position i1(s) to
i2(s). Let B3 denote the result array.
(7) For each proper tuple s of B2, compute the positions j1(s) and j2(s) of the first and
last tuple of B3 whose X-projection is s, respectively.
(8) For each proper tuple t of A1, find the unique corresponding tuple s(t) in B2.
(9) For each proper tuple t of A1 and each proper tuple s′ between positions j1(s(t)) and
j2(s(t)), construct an output tuple by combining s′ with t.
Step (1) can be done according to Proposition 5.4 (b) and Lemma 4.2. Step (2) uses the
algorithm of Proposition 5.4 (c). Step (3) uses the algorithm of Proposition 2.8 and Step (4)
the algorithm of Proposition 5.3. Step (5) and Step (7) can be done by slightly adapted
versions of an algorithm for SearchTuples using Proposition 4.8. Step (6) uses Lemma 2.7
for the allocation of processors, assigning (i2(s) −i1(s) + 1)1+δ processors to the group of
each s, and Lemma 4.2 with parameter δ (instead of ε) for each group. Finally, Step (9) uses
Lemma 2.7 for the allocation of processors. For each tuple t it assigns j2(s(t)) −j1(s(t)) + 1
processors. The position of a result tuple in the output array is just the number of the
processor that writes it.
For most steps the work and space bounds follow easily from the observations that all
A-arrays have size at most |R|, all B-arrays have size at most |S|, and that |R| · |S|ε is
bounded by |R|1+ε or |S|1+ε.
Towards the complexity analysis of Step (6) and Step (9) we denote, for each tuple s
from B2 the number (i2(s) −i1(s) + 1)1+δ of processors by ms and the number of proper
tuples from B1 matching s by ns. After Step (6) the overall size of all groups in B3 is at

---

27:28
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
most
(1+λ′)
X
s∈B2
ms = (1+λ′)
X
s∈B2
(i2(s)−i1(s)+1)1+δ ≤(1+λ′)

X
s∈B2
(i2(s) −i1(s) + 1)


1+δ
and the latter is in O(|S|1+δ). Therefore, Lemma 2.7 yields a work and space bound |S|(1+δ)2
for Step (6), which is |S|1+ε thanks to the choice of δ. For step Step (9) we observe that, for
each s from B2, it holds j2(s) −j1(s) + 1 ≤(1 + λ′)ns. Therefore,
X
t∈R⋉S
(j2(s(t)) −j1(s(t)) + 1) ≤
X
t∈R⋉S
(1 + λ′)ns(t) = (1 + λ′) |R ⋊⋉S| .
Thus, Lemma 2.7 establishes the work and space bound |R ▷◁S|1+ε for Step (9) and
guarantees that the size of the output array is at most (1 + λ′)2 |R ⋊⋉S| ≤(1 + λ) |R ⋊⋉S|.
6. Query Evaluation in the Dictionary Setting
After studying algorithms for basic operations and operators of the relational algebra, we
are now prepared to investigate the complexity of O(1)-time parallel algorithms for query
evaluation. In this section we will focus on the dictionary setting. We will derive algorithms
and bounds for other settings by a transformation into the dictionary setting in Section 7.
As mentioned in the introduction lower bound results for the size of bounded-depth
circuits for the clique problem and the clique conjecture destroy the hope for parallel
constant-time evaluation algorithms for conjunctive queries with small work.
We therefore concentrate in this section on restricted query evaluation settings. We
study two restrictions of query languages which allow efficient sequential algorithms, the
semijoin algebra and (free-connex) acylic conjunctive queries. Furthermore, we present a
O(1)-time parallel version of worst-case optimal join algorithms.
For notational simplicity, we assume in this section that database relations are represented
concisely by compact arrays without any uninhabited cells. This allows us to express bounds
in terms of the size of the database as opposed to the sizes of its arrays.10
In the following, IN thus always denotes the maximum number of cells in any array
representing a relation of the underlying database that is addressed by the given query. Note
that |D| ∈O(IN) for any database D over a fixed schema. Analogously, OUT denotes the
number of tuples in the query result.
The results of this section are summarised in the right-most column of Table 4.
6.1. Query Plans. To investigate the complexity of O(1)-time parallel algorithms for
query evaluation we will utilize query plans, which we briefly recall here from the literature.
Furthermore, we present a first result which allows us to, given a query plan, derive work
and space bounds for query evaluation from bounds for intermediate results.
A query plan P = (V, E, ω) over a database schema Σ is a finite, directed, ordered,
binary tree11 with a node labelling function ω that labels
10Assuming that the input arrays are λ-compact, for some constant λ, would suffice for the stated purpose.
11Sometimes query plans are defined more generously as acyclic graphs. However, regarding the size of
intermediate results, there is no essential difference between such a query plan and its tree-unravelling.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:29
Table 4: Overview of results on query evaluation. Here CQ is short for “conjunctive query”
and “a-ordered” refers to the attribute-wise ordered setting.
Query class
Work bound in the . . .
general setting
a-ordered setting
dictionary setting
Semijoin
Algebra
O(IN2)
O(IN1+ε)
O(IN)
Corollary 7.4
Corollary 7.6 (a)
Theorem 6.2
Acyclic CQs
O((IN · OUT)1+ε + IN2)
O((IN · OUT)1+ε)
Corollary 7.4
Corollary 7.6 (b)
Theorem 6.5 (a)
Free-Connex
Acyclic CQs
O((IN + OUT)1+ε + IN2)
O((IN + OUT)1+ε)
Corollary 7.4
Corollary 7.6 (b)
Theorem 6.5 (b)
CQs
O((INghw(q) · OUT)1+ε + IN2)
O((INghw(q) · OUT)1+ε)
Corollary 7.4
Corollary 7.6 (b)
Theorem 6.6 (a)
CQs
O((INfghw(q) + OUT)1+ε + IN2)
O((INfghw(q) + OUT)1+ε)
Corollary 7.4
Corollary 7.6 (b)
Theorem 6.6 (b)
Natural Join
Queries
O((agm(q, D) + |D|)1+ε + |D|2)
O((agm(q, D) + |D|)1+ε)
Corollary 7.4
Corollary 7.6 (b)
Corollary 6.8
▶every leaf with a relation symbol from Σ;
▶every node with a single child with either a select or a project operator; and
▶every node with two children with either a semijoin, join, difference, or union operator.
We note that in case of a select σA=x or a project operator πX , A and x, or X, respectively,
are part of the label. For convenience, we also do not consider nodes with a renaming
operator, since attributes can always be renamed in constant time on a single processor.
Every query plan represents a query of the relational algebra12 but there might be
multiple query plans for a query. In fact, we will often describe query plans which do not
directly correspond to a given query expression. Moreover, we will often describe query
plans as a sequence of operations, if it is clear that they can be arranged in a tree.
Given a database D and a query plan P over a common schema, we inductively associate
each node v of P with a relation RD,v as follows. For a leaf v labelled with a relation symbol
R = ω(v), we set RD,v = D(R). For nodes v labelled with a unary operator τ = ω(v), we set
RD,v = τ(RD,w) where RD,v is the relation associated with the child w of v. And for nodes
labelled with a binary operator ◦= ω(v) , we set RD,v = RD,w ◦RD,u where RD,w and RD,u
are the relations associated with the left child w and the right child u of v, respectively. The
query result P(D) of a query plan P with root node v on a database D is RD,v. A query
plan P for a query q satisfies P(D) = q(D) for all databases D.
The inductive definition of the RD,v gives rise to a straightforward evaluation scheme:
Simply compute RD,v in a bottom-up fashion. The following elementary result provides an
upper bound for the work and space required by a O(1)-time parallel algorithm implementing
this scheme, given an upper bound for the size of the intermediate relations.
12A query plan can also be understood as a parse tree of a relational algebra query.

---

27:30
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Theorem 6.1. For every query plan P = (V, E, ω) for a query q and every ε > 0, λ > 0
there is a O(1)-time parallel algorithm on an Arbitrary CRCW PRAM and a constant c,
such that the following holds. For every database D, given in a λ-compact representation
in the dictionary setting, the algorithm evaluates q(D) with work and space cN1+ε, where
N = max(|D| , maxv |RD,v|). The output array is of size O(|q(D)|).
If no node of P is labelled with the join operator, work cN suffices. The output array is
then of size O(|D|).
Proof. The O(1)-time parallel algorithm computes λ-compact arrays RD,v for the relations
RD,v in a bottom-up fashion. It maintains the invariant |RD,v| ≤(1 + λ)N, for all v ∈V .
We show that for each node v, there is a constant cv, such that the evaluation of RD,v needs
at most work and space cvN1+ε. Then, c can be chosen as the sum of all cv.
For a leaf node v the claim follows immediately, because the λ-compact array RD,v
for RD,v is given as input and N bounds its size. Consider a node v which has a single
child node w. Then v is labelled with a select or project operator, and the algorithms from
Proposition 5.2 and Proposition 5.3 (a) guarantee that RD,v can be computed with work
O(|RD,w|) and space O(|RD,w| · |D|ε). Thanks to the invariant, and N being a bound on
|RD,v| and |RD,w|, this amounts to work O(N) and space O(N1+ε). The invariant holds
since |RD,v| ≤|RD,w|. The constant cv is obtained by adding the constant factor for the
application of the select or project operator to cw.
Consider now a node v with two child nodes w and u. If v is labelled with a set
difference, union, or semijoin operator, the claim follows analogously to the case for the
select and project operators by replacing the term |RD,w| with |RD,w| + |RD,u| and using
the corresponding “(a)-algorithms” from Section 5 (see Table 2 for an overview).
It remains to consider the case that v is labelled with the join operator. Thanks to
Proposition 5.7(a) the join RD,v = RD,w ⋊⋉RD,u can be computed with work and space
O

(|RD,u| + |D|)1+ε + |RD,w|1+ε + |RD,w ⋊⋉RD,u|1+ε
.
Thanks to the invariant and N bounding |RD,w| and |RD,u|, the claim regarding work and
space follows. Furthermore, Proposition 5.7 guarantees an output size of
(1 + λ) |RD,w ⋊⋉RD,u| = (1 + λ) |RD,v| ,
and hence the invariant holds, since N also bounds |RD,v|. In all binary cases, the constant
cv is obtained by adding the constant factor for the application of the respective operator to
cw + cu.
Overall, the query plan can be evaluated with the stated work and space bounds. Since
all steps, except for the computation of a join, can be done with linear work, we get an
improved work bound of cN, if no node of the join plan is labelled with the join operator.
However, this work bound does not allow to apply compaction and therefore in this case we
only get the weaker bound O(|D|) for the output size.
6.2. Semijoin Algebra. The semijoin algebra is the fragment of the relational algebra that
does not use the join operation (nor Cartesian product), but can use the semijoin operation
instead — besides selection, projection, rename, union, and set difference. It is well-known
that semijoin queries produce only query results of size O(|D|) [LV07, Corollary 16] and can
be evaluated in time O(|D|) [LMTdB05, Theorem 19].

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:31
Since semijoin algebra queries do not use the join operator, the following is a direct
consequence of Theorem 6.1 and the fact that the size of all intermediate results can be
bounded by O(IN), since they are themselves results of semijoin (sub-)queries.
Theorem 6.2. For every ε > 0, λ > 0 and each query q of the semijoin algebra there
is a O(1)-time parallel algorithm that, given a λ-compact representation of a database D,
evaluates q(D) on an Arbitrary CRCW PRAM with work O(IN) and space O(IN1+ε) in the
dictionary setting. The output array is of size O(IN).
Altogether, semijoin queries can be evaluated work-optimally by a O(1)-time parallel
algorithm in the dictionary setting.
6.3. Acyclic and other Conjunctive Queries. There are various fragments of the class
of conjunctive queries, defined by restrictions on the structure of a query, that allow efficient
query evaluation. For instance, there are the acyclic join queries and, more generally, acyclic
queries, which can be evaluated efficiently by the well-known Yannakakis algorithm [Yan81],
and their restriction to free-connex queries that allows for efficient enumeration of query
results [BDG07]. Furthermore, there are various generalisations of these fragments, e.g.,
based on the notion of generalised hypertree width. In this subsection, we study how queries
of some of these fragments can be evaluated work-efficiently in parallel constant time. We
first study acyclic queries and their variants and then generalise the results to queries of
bounded generalised hypertree width. Before that we recall the definition of conjunctive
queries and fix our notation.
Conjunctive queries are conjunctions of relation atoms. We write a conjunctive query
(CQ for short) q as a rule of the form q: A ←A1, . . . , Am, where A, A1, . . . , Am are atoms
and m ≥1. Here an atom has the form R(x1, . . . , xk) where R is a relation symbol with
arity k and x1, . . . , xk are variables. The atoms A1, . . . , Am form the body of q and A is
the head of q. All relation symbols occurring in the body are from the database schema Σ
and the relation symbol of the head is, on the other hand, not. Further, we only consider
safe queries; that is, every variable which occurs in the head, also occurs in (some atom
of) the body. If a variable occurs in the head atom, it is a free variable. Otherwise, the
variable is quantified. A join query is a conjunctive query with no quantified variables, i.e.
every variable in a join query is free. For more background on (acyclic) conjunctive queries,
including their semantics, we refer to [AHV95, ABL+21].
In this section we will assume that there are no variable repetitions in any atom, i.e. the
variables x1, . . . , xk of an atom R(x1, . . . , xk) are pairwise distinct. We note that we do not
allow constants in our definition of conjunctive queries, either. Both requirements can easily
be established by proper precomputations using only SelectX which only requires linear
work and space. Furthermore, we assume that no relation symbol appears more than once in
the body of the query. This is just a matter of renaming (or copying) some input relations.
Acyclic conjunctive queries. A conjunctive query q is acyclic, if it has a join tree Tq. A
join tree for q is an undirected, rooted tree (V (Tq), E(Tq)) where the set of nodes V (Tq)
consists of (all) the atoms in q and for each variable x in Tq the set {v ∈V (Tq) | v contains x}
induces a connected subtree of Tq.
An acyclic query q with free variables x1, . . . , xℓ, for which the query q′ that results
from q by adding a new atom A′(x1, . . . , xℓ) to its body, remains acyclic, is called free-connex

---

27:32
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
acyclic.13 Acyclic join queries are a special case of free-connex acyclic queries, in which all
variables of the body of the query are free.
Our results on acyclic conjunctive queries are obtained by an easy application of
Theorem 6.1 to the already mentioned Yannakakis algorithm [Yan81].
This algorithm
consists of two parts. Given an acyclic conjunctive query q, a join tree Tq for q and a
database D, it computes in the first part a full reduction D′ of D as in [BG81, Section 3].
To this end, we associate with each node v in Tq a relation Sv. Initially, Sv = Rv(D), where
Rv is the relation symbol of v. The computation of the full reduction has two phases.
(1) bottom-up semijoin reduction: All nodes are visited in bottom-up traversal order of
Tq. When a node v is visited, Sv is updated to Sv ⋉Sw for every child w of v in Tq.
(2) top-down semijoin reduction: All nodes are visited in top-down traversal order of
Tq. When a node v is visited, the relation Sw is updated to Sw ⋉Sv for every child w of
v in Tq.
Let D′ denote the resulting database, i.e., the database that has, for each node v the relation
Sv in place of Rv (and is identical with D, otherwise).
Proposition 6.3 [BG81, Theorem 1]. For every acyclic conjunctive query q, database D,
and full reduction D′ of D, it holds that
(a) q(D′) = q(D); and
(b) πattr(q)∩attr(R)(D′(R)) = πattr(R)(q(D)), for every relation symbol R of D.
In the second part, the algorithm computes the join of the reduced relations by a
succession of binary joins in a bottom-up manner. Since each tuple of an intermediate result
relation for a node v can be partitioned into a subtuple of a tuple from Rv and a subtuple
of the output, the following bound holds.
Lemma 6.4 [Yan81, Lemma 4.1]. All intermediate result relation in the second part of the
Yannakakis algorithm are of size at most IN · OUT.
Now we are ready to state and prove our results about acyclic queries.
Theorem 6.5. For every ε > 0, λ > 0, and each acyclic conjunctive query q, there are
O(1)-time parallel algorithms that given a λ-compact representation of a database D in the
dictionary setting, compute q(D) on an Arbitrary CRCW PRAM
(a) with work and space O((IN · OUT)1+ε);
(b) with work and space O((IN + OUT)1+ε), if q is a free-connex acyclic query.
In both cases, the result can be represented by an array of size O(OUT).
Proof. Let all relations R occurring on q be represented concisely by arrays R.
In both cases, the algorithm first computes the full reduction as in Proposition 6.3.
Since the full reduction constitutes a query plan without joins, and all intermediate result
relations are subrelations of relations of the database, this can be done with work O(IN) and
space O(IN1+ε) by Theorem 6.1.
Afterwards every node v in Tq is associated with an array Sv of size at most O(IN)
which represents Sv concisely.
Statement (a) now follows by applying Theorem 6.1 to the second part of Yannakakis’
algorithm thanks to the bound on intermediate results established by Lemma 6.4.
13There are several equivalent definitions of free-connex acyclic queries. We chose this definition from
[BB13, Section 3.2], where such queries are called starred, since it is easy to state.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:33
Towards (b), let Tq′ be a join tree for the query q′ with the additional atom R′(x1, . . . , xℓ),
where x1, . . . , xℓare the free variables of q. The query result q(D′) = q(D) can be obtained
as the join of all πX(A), where A is an atom of q′ whose node is a neighbour of R′(x1, . . . , xℓ)
in Tq′, and X is the set of free variables of q that occur in A. This follows from Proposi-
tion 6.3 and the observation that each free variable of q occurs in some neighbour atom of
R′(x1, . . . , xℓ) in q′ since it occurs in some atom by the safety of q and thus in a neighbour
atom by the connectedness condition of the acyclic query q′.
This join can be computed by a sequence of binary joins, each of which producing a
result relation that is a projection of q(D′) and is therefore of size at most OUT. Thus,
again by Theorem 6.1, the work and space are bounded by O((IN + OUT)1+ε).
To achieve the size of the output array in (a), a final compaction might be necessary.
For (b), it is already guaranteed by Proposition 5.7.
General conjunctive queries. We next investigate how the algorithms for acyclic queries
can be adapted to all conjunctive queries. More precisely, we give algorithms with upper
bounds for the work and space for the evaluation of conjunctive queries depending on their
generalised hypertree width.
We use the notation of [GGLS16]. A tree decomposition of a query q is a pair (T, χ)
where T = (V, E) is an undirected, rooted tree, and χ is a mapping that maps every node
v ∈V in T to a subset of variables in q such that the following three conditions are satisfied.14
(1) For every variable x in q there is a node v ∈V such that x ∈χ(v);
(2) for each atom R(x1, . . . , xr) in q there is a node v ∈V such that {x1, . . . , xr} ⊆χ(v);
and
(3) for each variable x in q the set {v ∈V | x ∈χ(v)} induces a connected subtree of T.
A generalised hypertree decomposition of a query q is a triple (T, χ, µ) where (T, χ) is
a tree decomposition of q and µ is a mapping15 which maps every node v of T to a set of
atoms from the body of q such that χ(v) ⊆S
R(x1,...,xr)∈µ(v){x1, . . . , xr}.
The width of a generalised hypertree decomposition (T, χ, µ) is the maximal number
maxv∈V |µ(v)| of atoms assigned to any node of T. The generalised hypertree width ghw(q) of a
conjunctive query q is the minimal width over all of its generalised hypertree decompositions.
We note that a conjunctive query is acyclic, if and only if its generalised hypertree width
is 1 [GLS02, Theorem 4.5].16
A tree decomposition (T, χ) of a conjunctive query q is free-connex if there is a set of nodes
U ⊆V (T) that induces a connected subtree in T and satisfies free(q) = S
u∈U χ(u) [BDG07,
Definition 36]. A generalised hypertree decomposition is free-connex if its tree decomposition
is free-connex. The free-connex generalised hypertree width fghw(q) of a conjunctive query is
the minimal width among its free-connex generalised hypertree decompositions.
Theorem 6.6. For every ε > 0, λ > 0, and every conjunctive query q, there are O(1)-time
parallel algorithms that, given a λ-compact representation of a database D in the dictionary
setting, computes q(D) on an Arbitrary CRCW PRAM
(a) with work and space O((INghw(q) · OUT)1+ε);
14We note that Condition (1) is redundant thanks to safety and Condition (2).
15In the literature, λ is often used to denote this mapping, but λ has a different role in this article.
16We note that the proof given in [GLS02] is for hypertree decompositions which impose an additional
condition which is, however, not used in the proof.

---

27:34
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
(b) with work and space O((INfghw(q) + OUT)1+ε).
As in Theorem 6.5, the result can be represented by an array of size O(OUT).
Proof. We basically show that the reduction to the evaluation of an acyclic query of [GLS02,
Section 4.2] transfers, in both cases, well to our parallel setting.
We first show (a). Let thus ε > 0 and a conjunctive query q be fixed and let (T, χ, µ) be
a generalised hypertree decomposition of q of width ghw(q). By [GLS02, Lemma 4.4] we
can assume that it is complete, i.e., for every atom A in the body of q, there is a node v
such that A ∈µ(v).
The idea is to compute an acyclic query q′ from q and a database D′ from D and q such
that q′(D′) = q(D).
We first describe D′ and q′ and then show how D′ can be computed in constant time.
For every v ∈V (T), we define a new relation Rv by means of the conjunctive query qv
with free variables χ(v) and body µ(v). The database D′ consists of all these relations Rv.
That is, the schema of D′ is {Rv | v ∈V (T)} and D′(Rv) = qv(D) for all v ∈V (T).
The query q′ is then the conjunctive query with the same head as q and its body consists
of the head atoms of all queries qv. It is straightforward to verify that q(D) = q′(D′) by
inlining the definitions of the qv and observing that every atom of q occurs in one of the qv
thanks to the decomposition being complete. Moreover, q′ is acyclic because the generalised
hypertree decomposition (T, χ, µ′) for q′ with µ′(v) = Rv for every node v has width 1.
The relations Rv can be computed using at most |µ(v)| many Join operations, followed
by a Projectfree(qv) operation. The arrays representing the relations in µ(v) have size at
most O(IN) and since (T, χ, µ) has width ghw(q), the relation Rv and the intermediate
results in its computation have size at most O(INghw(q)). The computation can thus be
carried out with work and space O(INghw(q)(1+ε)) thanks to Theorem 6.1.
Statement (a) then follows by Theorem 6.5 (a).
Statement (b) follows by Theorem 6.5 (b) and the observation that q′ is free-connex
acyclic if it is applied to a free-connex generalised hypertree decomposition. This can easily
be seen with the original definition of free-connex acyclicity in [BDG07, Definition 22],
requiring that the free variables of the query induce a connected subtree of the join tree.
6.4. Weakly Worst-Case Optimal Work for Joins Queries. This section is concerned
with the evaluation of join queries17 q = R1 ⋊⋉. . . ⋊⋉Rm over some schema Σ = {R1, . . . , Rm}
with attributes attr(q) = Sm
i=1 attr(Ri). It was shown in [AGM13] that |q(D)| ≤agm(q, D)
holds for every database D and that this bound is tight for infinitely many databases D (this
is also known as the AGM bound). Here agm(q, D) denotes Qm
i=1|Ri|xi, where x1, . . . , xm is
a fractional edge cover of q defined as a solution of the following linear program.
minimise
m
X
i=1
xi subject to
X
i:A∈attr(Ri)
xi ≥1 for all A ∈attr(q)
and xi ≥0 for all 1 ≤i ≤m
There exist sequential algorithms whose running time is bounded by the above worst-case
size of the query result (and the size of the database), i.e., by O(agm(q, D) + |D|) [NPRR18].
17Following tradition, we denote join queries in this subsection slightly differently from the previous
subsection.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:35
They are called worst-case optimal. However, these algorithms are not captured by query
plans and therefore their parallel constant-time counterparts cannot be obtained by a direct
application of Theorem 6.1.
We say that a join query q has weakly worst-case optimal O(1)-time parallel algorithms,
if, for every ε > 0, there is a O(1)-time parallel algorithm that evaluates q with work
(agm(q, D) + |D|)1+ε. In this subsection, we show that join queries indeed have weakly
worst-case optimal O(1)-time parallel algorithms, if the arrays representing the relations are
suitably ordered. In the dictionary setting the latter requirement can actually be dropped,
since the arrays can be appropriately sorted in a padded fashion and compacted, within the
overall work and space bounds.
Before we formally state this result, we fix some notation. Let X = (A1, . . . , Ak) be
an ordered list of all attributes occurring in q. For each i ∈{1, . . . , k}, Zi denotes the
subsequence of X consisting of all attributes of attr(Ri).
Theorem 6.7. For every ε > 0, λ > 0 and join query q = R1 ⋊⋉. . . ⋊⋉Rm, there is
a O(1)-time parallel algorithm that, given λ-compact arrays R1, . . . , Rm representing the
relations R1, . . . , Rm concisely, where each Ri is Zi-ordered, computes q(D) represented by
a λ-compact array and requires O
 (agm(q, D) + |D|)1+ε
work and space on an Arbitrary
CRCW PRAM.
In the dictionary setting, we can drop the requirement that the arrays are suitably
sorted, since they can be sorted with work O(|D|1+ε).
Corollary 6.8. For every ε > 0, λ > 0 and join query q = R1 ⋊⋉. . . ⋊⋉Rm, there is
a O(1)-time parallel algorithm that, given λ-compact arrays R1, . . . , Rm representing the
relations R1, . . . , Rm concisely, in the dictionary setting, computes q(D) represented by a
λ-compact array and requires O
 (agm(q, D) + |D|)1+ε
work and space on an Arbitrary
CRCW PRAM.
A O(1)-time parallel algorithm can proceed, from a high-level perspective, similarly to
the sequential attribute elimination join algorithm, see e.g. [ABL+21, Algorithm 10]. The
core of this algorithm is captured by the following result.
Proposition 6.9 [ABL+21, Algorithm 10 and Proposition 26.1]. For a join query q =
R1 ⋊⋉. . . ⋊⋉Rm with attributes X = (A1, . . . , Ak) and each database D, consider the family
(Lj)1≤j≤k of sets Lj, which are inductively defined as follows:
▶L1 = T
i:A1∈attr(Ri) πA1(Ri) and,
▶for each j with 1 < j ≤k, Lj be the union of all relations
Vt = {t} ×
\
i:Aj∈attr(Ri) πAj(Ri ⋉{t})
for each t ∈Lj−1.
Then the relation Lk is the query result q(D).
We will also use the following inequalities proven in [ABL+21] in our complexity analysis.
Lemma 6.10 [ABL+21, pp. 228-229]. Let q = R1 ⋊⋉. . . ⋊⋉Rm be a join query with attributes
X = (A1, . . . , Ak) and x1, . . . , xm be a fractional edge cover of q. Furthermore, let L1, . . . , Lk
be defined as in Proposition 6.9. For every database D it holds that
(a) mini:A1∈attr(Ri) |Ri| ≤agm(q, D), and

---

27:36
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
(b) P
t∈Lj−1 mini:Aj∈attr(Ri) |Ri ⋉{t}| ≤agm(q, D) for all j ∈{2, . . . , k}.
Proof for Theorem 6.7. In a nutshell, the algorithm computes iteratively, for increasing j
from 1 to k, the relations Lj defined in Proposition 6.9 and finally outputs Lk.18 The
correctness follows immediately thanks to Proposition 6.9.
Further on, we discuss how the relations Lj can be computed and that |Lj| ≤(1 +
λ)agm(q, D) holds for every j, where Lj is the array representing Lj concisely. Finally, the
result array Lk can be λ-compacted within the required bounds thanks to Lemma 4.2.
Let X and the Zi be defined as before. Let furthermore Xj = (A1, . . . , Aj), for each
j ∈{1, . . . , k}, be the prefix of X up to attribute Aj. By Rj we denote the set of indices
i, for which Aj ∈attr(Ri). For each j ∈{1, . . . , k}, and i ∈{1, . . . , m}, let Yi,j be the
subsequence of Xj consisting of attributes in attr(Ri).
Without loss of generality, we assume λ < 1
2.
During an initialisation phase the algorithm computes Yi,j-ordered, fully linked arrays
Pi,j, for each j ∈{1, . . . , k}, and i ∈{1, . . . , m}, that represent πYi,j(Ri) concisely, respec-
tively. The order is inherited, since the arrays Ri are sorted according to Yi,k. It thus
suffices, for each i, to establish full links in Ri and to apply ProjectYi,j for up to m values
of j. By doing this in decreasing order of j, links from each tuple in Pi,j to its projection in
Pi,j−1 can be established.19 In the special case of Yi,j consisting solely of Aj, all tuples are
linked to the first cell in Pi,j−1.
This initial phase requires work and space O(Pm
i=1 |Ri|1+ε) = O(|D|1+ε), for each i,
thanks to Proposition 2.8 and Proposition 5.3 (b). The arrays Pi,j have size O(|D|).
The computation of L1 is straightforward: The algorithm picks an i for which A1 ∈
attr(Ri) holds and initialises L1 as a copy of Pi,1. Then it computes the semijoins of
L1 with all remaining Pk,1 for which A1 ∈attr(Rk).
This requires O(|D|1+ε) work
and space thanks to Proposition 5.4 (b). Furthermore, the output array L1 has size at
most |D|. Thus, compacting L1 with Compactλ yields an array representing L1 of size at
most (1 + λ) |L1| and requires work and space O(|D|1+ε) thanks to Lemma 4.2. Clearly,
|L1| ≤min1≤i≤m|πA1(Ri)| ≤min1≤i≤m|Ri| ≤agm(q, D) thanks to Lemma 6.10. Thus, the
size of the compacted array L1 is bounded by (1 + λ)agm(q, D).
To compute Lj, for j > 1, the algorithm operates in two phases: a grouping phase and
an intersection phase. In both phases only those input relations Ri with Aj ∈attr(Ri)
participate. Note that for these i we have in particular that Aj occurs in Yi,j (but not in
Yi,j−1).
Towards the grouping phase, observe that the tuples in the arrays Pi,j are grouped by
Yi,j−1 since they are even Yi,j-ordered. Furthermore, note that the group in Pi,j for a tuple
t ∈Lj−1 is essentially a list of the values in πAj(Ri ⋉{t}) annotated with t[Yi,j−1]. Similar
to our algorithm for the Join operation, each group in Pi,j is compacted and each proper
tuple t ∈Lj−1 is augmented by links to (the first and last tuple of) its group in Pi,j as
follows.
(1) Determine the minimum and maximum indices of each group in Pi,j with |Pi,j| processors:
processor p checks whether Pi,j[p].t is a proper tuple and differs from its predecessor (resp.
successor) with respect to attributes Yi,j−1. The representative in Pi,j−1 is augmented
with these indices. Since Pi,j is Yi,j-ordered, the proper tuples between the minimum
18We note that the algorithm cannot be cast as a query plan, since it relies on a low-level grouping
operation to achieve the desired bounds. Thus, Theorem 6.1 is not applicable.
19If Aj does not occur in Yi,j, then Pi,j−1 is just Pi,j and no computation is necessary.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:37
and maximum assigned to a proper tuple t in Pi,j−1 are then precisely the tuples t′ with
t′[Yi,j−1] = t.
For every proper tuple t in Pi,j−1 let Gt,i,j denote the (sub)array of the group for t
in Pi,j for every 1 ≤i ≤m.
(2) Compact each group Gt,i,j in parallel using Compactλ′ with λ′ = min{1
3, λ
3} and pa-
rameter δ = min{1
3, ε
3} (the choice of λ′ is required for the complexity bounds in the
intersection phase). To this end, the algorithm creates, for each proper tuple t in Pi,j−1
a task description dt for mt = |Gt,i,j|1+δ processors with links to Gt,i,j and the tuple t
(in Pi,j−1) itself.
Invoking the algorithm guaranteed by Lemma 2.7 yields a schedule of size
(1 + λ)
X
t∈Pi,j−1
mt = (1 + λ)
X
t∈Pi,j−1
|Gt,i,j|1+δ
≤(1 + λ)

X
t∈Pi,j−1
|Gt,i,j|
1+δ
= (1 + λ) |Pi,j|1+δ .
Thanks to (1+δ)2 ≤(1+ε) computing the schedule requires work and space O(|D|1+ε).
Moreover, the arrays Gt,i,j can be compacted with Compactλ′, and the tuples in Pi,j
can be augmented by links to the λ′-compact arrays within the same bounds.
(3) Finally, links are established from proper tuples in Lj−1 to their respective cells in
Pi,j−1 for every 1 ≤i ≤m as follows. Since Lj−1 is a relation over Xj−1 which is a
superset of Yi,j−1, it is straightforward to obtain a (possibly) non-concise representation
of πLj−1(Yi,j−1) with mutual links to/from Lj−1 with work and space O(|Lj−1|). Then,
for each 1 ≤i ≤m, SearchTuples is applied to find, for each proper tuple t in Lj−1,
the respective tuple t[Yi,j−1] in Pi,j−1. Each of the (constantly many) applications of
SearchTuples requires work and space O(|Lj−1| · |Pi,j−1|ε) = O((agm(q, D)) · |D|ε),
because Pi,j−1 is fully ordered (w.r.t. Yi,j−1) and fully linked. These links, together with
the links in Pi,j−1 to the λ′-compact group arrays Gt,i,j allow to determine, for each
tuple t in Lj−1, the smallest group array Gt′,j with t′ = t[Yi,j−1] among the group arrays
Gt′,i,j with work O(|Lj−1|) = O(agm(q, D)). Note that, in general, multiple tuples in
Lj−1 may be linked to the same group.
For tuples t ∈Lj−1, we will write G′
t,i,j and G′
t,j to denote the groups Gt′,i,j and
Gt′,j, respectively, where t′ = t[Yi,j−1].
This phase requires work and space O((agm(q, D) + |D|) · |D|ε) in total.
Observe that a group array G′
t,i,j for some t ∈Lj−1 represents πYi,j(Ri) ⋉{t} concisely.
Since t determines the values for all attributes except Aj, G′
t,i,j can also be viewed as an
array representing πAj(Ri ⋉{t}) concisely, where every value is annotated with t[Yi,j−1]. In
particular, a group G′
t,j represents the smallest set πAj(Ri ⋉{t}), for i ∈Rj.
In the intersection phase, the algorithm computes the union of all
Vt = {t} ×
\
i:Aj∈attr(Ri) πAj(Ri ⋉{t})
for t ∈Lj−1 in parallel. It proceeds in two steps. First, it joins all t ∈Lj−1 with all proper
tuples in G′
t,j, i.e., for all t ∈Lj−1, it computes the relation {t} × πAj(Ri ⋉{t}) for the i
minimizing the size of πAj(Ri ⋉{t}).

---

27:38
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Then, in the second step, it performs semijoins with all20 group arrays Gt,ℓ,j to effectively
compute the intersection of the sets {t} × πAj(Rℓ⋉{t}) for all ℓ.
For the first step, the algorithm has to assign |Gt,j| processors21 to each tuple t ∈Lj−1;
recall that Gt,j is the smallest group array for t. To this end, it creates, for each t ∈Lj−1, a
task description dt for mt = |Gt,j| processors and, as usual, with links to the group array
Gt,j and the cell of t in Lj−1. Since Lj−1 already contains links to the group arrays, these
task descriptions can be computed with work and space linear in |Lj−1| and stored in an
array of size |Lj−1|. Thanks to Lemma 2.7 it is then possible to compute a schedule of size
M = (1 + λ′)
X
t∈Lj−1
mt
(6.1)
in constant time and with work and space O
 |Lj−1|1+ε + M1+ε
.
To finalise the first step, the algorithm then allocates an array Lj of size M and uses M
processors to write, for all t ∈Lj−1, the join of {t} with all tuples in Gt,j into Lj: If the
m-th overall processor is the ℓ-th processor assigned to t, it writes t ⋊⋉Gt,j[ℓ].t into Lj[m],
if Gt,j[ℓ] is inhabited.
For the second step of the intersection phase, it suffices to compute the semijoins of Lj
with Pi,j for all i with Aj ∈attr(Ri). Because the arrays Pi,j are Yi,j-ordered and have
size O(|D|) the second step required work and space O(M · |D|ε) thanks to Proposition 5.4
(b).
To establish the desired work and space bounds for the intersection phase as well as
upper bounds for the size of Lj, we prove that M ≤(1 + λ)agm(q, D). As pointed out above,
an array Gt,i,j represents πYi,j(Ri) ⋉{t} = πYi,j(Ri ⋉{t}) concisely. Further, we have that
|πYi,j(Ri) ⋉{t}| = |πYi,j(Ri ⋉{t})| ≤|Ri ⋉{t}|. Since the groups where compacted using
Compactλ′ in the grouping phase, we can conclude that (1 + λ′) |Ri ⋉{t}| is an upper bound
for |Gt,i,j|. In particular, for the group arrays Gt,j of minimal size, we have
|Gt,j| ≤(1 + λ′) min
1≤i≤m|Ri ⋉{t}|.
(6.2)
Therefore, we have
M
(6.1)
= (1 + λ′)
X
t∈Lj−1
mt
= (1 + λ′)
X
t∈Lj−1
|Gt,j|
(6.2)
≤(1 + λ′)
X
t∈Lj−1
(1 + λ′) min
1≤i≤m|Ri ⋉{t}|
(3)
≤(1 + λ)
X
t∈Lj−1
min
1≤i≤m|Ri ⋉{t}|
(4)
≤(1 + λ)agm(q, D)
20For each tuple, t, the semijoin is redundant, for some ℓ. But it is convenient to do it in this way.
21We note that this corresponds (up to a logarithmic factor) to the running time stated by [ABL+21,
Claim 26.3] and required for the complexity analysis of [ABL+21, Algorithm 10]; an implementation for the
operation described in [ABL+21, Claim 26.3] is, e.g., the Leapfrog-Join [Vel14], [ABL+21, Proposition 27.10].

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:39
where (3) holds because (1 + λ′)2 ≤(1 + λ); and (4) thanks to Lemma 6.10 (b). Therefore,
altogether M = |Lj| ≤(1 + λ)agm(q, D). This completes the description of the computation
of the arrays Lj, for j > 1.
7. Query Evaluation in Other Settings
In this section we discuss query evaluation in other settings than the dictionary setting.
We first consider the general setting, where data can only be compared with respect to
equality. In this setting it turns out that the naive algorithms for the evaluation of database
operations are already work-optimal: for SelectA=a the work is linear and for the other
operators quadratic. We also show that with quadratic work in its size, a database can
be translated into the dictionary setting in constant parallel time. Therefore, all results of
Section 6 apply to the general setting with an extra additive term O(|D|2) (or O(IN2) — cf.
Table 4, left column).
Then we consider the setting, where data can be compared with respect to a linear
order. Without any further assumption, the linear order does not give us better algorithms
while the lower bounds of the general setting cease to exist. However, with a somewhat
stronger assumption it is possible to translate a given database into the dictionary setting
in constant parallel time with work O(|D|1+ε) and in this way most bounds of Section 6
for query evaluation apply (cf. Table 4, middle column). We refer to this setting as the
attribute-wise ordered (or a-ordered) setting.
7.1. Query Evaluation in the General Setting. We first give the lower bound mentioned
above.
Theorem 7.1. For the operations ProjectA, SemiJoin, Join, Difference, Union every
O(1)-time parallel algorithm requires Ω(n2) work for infinitely many input databases in the
general setting. Here n is the size of the input arrays.
The lower bound for ProjectA even holds for binary input relations and the others for
unary input relations, and for compact and concise input arrays. In the case of Join the
infinitely many databases can be chosen such that the join result has at most one tuple, for
the join at hand.
Proof. We first prove the lower bound for SemiJoin. To this end, we define a family of
databases Dn and show that the elemental operation Equal has to be invoked at least n2
times to evaluate R ⋉S correctly. For any n > 0, let Rn = {2, . . . , 2n} be the set of all even
numbers from 2 to 2n and Sn = {1, . . . , 2(n −1) + 1} be the set of all odd numbers from 1
to 2(n −1) + 1. Note that |Rn| = |Sn| = n and let Dn be the database over schema R, S
with Dn(R) = Rn and Dn(S) = Sn. Let Rn and Sn be compact arrays representing Rn and
Sn concisely. The query result of R ⋉S on Dn is empty.
Assume for the sake of a contradiction that there is a O(1)-time parallel algorithm
for the general setting that evaluates R ⋉S on Dn with less than n2 invocations of Equal.
Then there are i, j such that Equal(Rn, i, 1; Sn, j, 1) is never invoked. Furthermore, by
construction any invocation of Equal(Rn, i′, 1; Sn, j′, 1) returns false on Dn, and invocations
Equal(Rn, i1, 1; Sn, i2, 1) or Equal(Rn, i1, 1; Sn, i2, 1) return true if and only if i1 = i2. Now
consider the database D′
n that is defined like Dn except that the i-th value of Rn and the
j-th value of Sn are set to 2n + 1. Let S′
n be a compact array representing S′
n concisely.

---

27:40
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Since Equal(Rn, i1, 1; Sn, i2, 1) is never invoked, every invocation of Equal still yields
the same result as before. As furthermore the sizes of Sn and S′
n are the same, we can
conclude that the computation on D′
n does not differ from the computation on Dn and the
algorithm outputs the empty query result. This is a contradiction because the query result
of R ⋉S on D′
n is {2n + 1}.
For Join, Difference, and Union exactly the same construction can be used. For
Difference, the contradiction results from 2n + 1 being still present in the output result
for Difference(Rn, S′
n) and for Union, the contradiction results from 2n + 1 being present
twice in the output array for Union(Rn, S′
n).
For ProjectA, a similar construction can be used with a binary relation containing
tuples of the form (1, n + 1), . . . , (n, 2n). If the algorithm does not invoke any operations
of the form Equal(Rn, i1, 1, Rn, i2, 1), for some i1̸ = i2 (and i1, i2 ∈{1, . . . , n}), then the
output array for the database in which (i2, i2 + n) is replaced by (i1, i2 + n) has a duplicate
entry for i1.
As mentioned before, the lower bounds of Theorem 7.1 can easily be matched by
straightforward algorithms.
Theorem 7.2. There are O(1)-time parallel algorithms for the following operations that,
given arrays R and S, representing R and S concisely, have the following bounds on an
Arbitrary CRCW PRAM.
(a) Work and space O(|R|) for SelectA=x(R).
(b) Work and space O(|R|2) for ProjectX (R).
(c) Work and space O(|R| · |S|) for SemiJoin(R, S) and Difference(R, S).
(d) Work and space O(|R| · |S|) for Join(R, S).
(e) Work and space O((|R| + |S|)2) for Union(R, S).
Proof. The algorithms for SelectA=a, SemiJoin, Difference and Join are entirely straight-
forward. The algorithm for ProjectA, first adapts every tuple in the obvious way and then
removes duplicates by using one processor for each pair (t, t′) of tuples and removing (that is:
making its cell uninhabited) the tuple with the larger index, in case t = t′. The algorithm for
Union first concatenates the two arrays and then removes duplicates in the same fashion.
As mentioned before, the results of Section 6 translate into the general setting by adding
an additive term O(IN2). However, these results are not obtained by applying the above
algorithms but rather by transforming the database at hand into a database in the dictionary
setting.
To turn a database D in the general or ordered setting into a representation for the
dictionary setting, the data values occurring in D have to be “replaced” by small values; that
is, numbers within {1, . . . , cval |D|} for some constant cval. More precisely, we are interested
in an injective mapping key: adom(D) →{1, . . . , cval |D|}. Here adom(D) is the set of all
data values occurring in (some relation of) D. The idea is then to compute a database
D′ = key(D) with small values, evaluate a given query q on D′, and then obtain the actual
result by applying the inverse of key to the query result q(D′).
Since a PRAM cannot directly access the data values in the general and ordered setting,
we will use a data structure that allows to map a token representation for a data value a to
key(a) and vice versa. Recall that token representations are not unique, i.e. there may be
multiple token representations for the same data value a. All these representations have to
be mapped to the same key key(a).

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:41
We define a dictionary as a data structure that allows a single processor to carry out
the following operations for every relation R of the database in constant time.
▶KeyOf(R, i, j) returns key(a) where a is the value of the j-th attribute of the i-th tuple in
relation R.
▶KeyOutput(k, i, j) outputs the value key−1(k) as the j-th attribute of the i-th output
tuple.
Here key is an arbitrary but fixed injective function key: adom(D) →{1, . . . , cval |D|} for
some constant cval.
Observe that, using KeyOf(R, ·, ·) an array representing a relation R in the general
setting can be translated into an array representing key(R) in the dictionary setting in
constant time with linear work.
The following result states that dictionaries can be computed in constant time with
quadratic work, in the general setting.
Lemma 7.3. There is a O(1)-time parallel algorithm that, given a database D in the general
setting, computes a dictionary with work and space O(|D|2) on a Common CRCW PRAM.
Proof. The idea is to compute an array D of size O(|D|), whose cells contain all (token
representations of) data values occurring in D. This array will be the underlying data
structure of the dictionary. We note that D is (most likely) not concise. The key key(a)
for a data value a is then the index of a fixed representative of a in D. In the following
we will detail how to compile D, and how the operations KeyOf, and KeyOutput can be
implemented on top of it.
For each input relation R and j ∈{1, . . . , ar(R)} array BR,j of size |R| is computed
using |R| processors as follows: Processor i writes the token (R, i, j) to cell BR,j[i]. Thus,
BR,j is a compact array that contains (token representations for) all data values occurring
for the j-th attribute in any tuple of R. Concatenating all arrays BR,j, where R ranges over
all input relations and j over {1, . . . , ar(R)} yields the array D. The size of D is clearly
bounded by P
R∈Σ ar(R) · |R| ≤cval |D| where cval = P
R∈Σ ar(R). This step requires work
and space O(|D|).
Next, the algorithm can identify duplicates in D similarly as in Theorem 7.2 and link
every cell D[i] to a representative cell D[j] which contains a token representation for the
same data value as D[i]. This requires work O(|D|2) and space O(|D|).
It remains to show that KeyOf and KeyOutput can be carried out in constant time by a
single processor given D. For KeyOf(R, i, j) we observe that a single processor can determine
the index ℓof the token (R, i, j) in D: Indeed, (R, i, j) has been stored in BR,j[i], D is the
(compact) concatenation of constantly many BS,m, and a single processor can obtain the size
of any relation (and, hence, BS,m) using NumTuples. Given ℓit is then easy to determine
the representative cell D[k] for D[ℓ] using the links established before (possibly k = ℓholds).
The index k is then returned as the unique key for the data value represented by (R, i, j).
The implementation of KeyOutput(k, i, j) is straightforward. Indeed, k is an index of D
and D[k] contains a token representation (R, i1, j1) for the data value with the unique key k.
Thus, invoking Output(R, i1, j1; i, j) has the desired effect.
Corollary 7.4. The results of Theorem 6.2, Theorem 6.5, Theorem 6.6 and Corollary 6.8
hold in the general setting with the proviso that an additional term O(IN2) (or O(|D|2) for
Corollary 6.8) is added to the stated work and space bounds.

---

27:42
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
We note that constants occurring in select subqueries can be handled as follows. By using
O(IN) processors, which brute force it can be checked using EqualConst, and KeyOf whether
the constant occurs in the database and to which number it is mapped. In case no token
representation is found, the constant does not occur in the database and the subquery result
is empty. Otherwise the obtained number can be used to evaluate the select subquery in a
straightforward fashion.
7.2. Query Evaluation in the Ordered Setting. We finally consider the ordered setting,
where the elemental operation LessThan is available to access the database. We note that
the ordered setting does not guarantee arrays that store the tuples of a relation in any
particular order.
The lower bounds from Theorem 7.1 do not hold anymore in the presence of LessThan,
and therefore we hoped that its presence would allow us to find algorithms that improve the
bounds of the general setting. Unfortunately, we were not able to find such algorithms.
An obstacle is that we do not know whether there is a O(1)-time parallel algorithm for
comparison-based padded sorting on CRCW PRAMs. Such algorithms exist for the parallel
comparison model [AV87, Section 4], but to the best of our knowledge the best deterministic
PRAM algorithms have non-constant time bounds [HR93, CR98]. Therefore, it is not clear
how to sort a relation array, in general.
However, if we assume that suitable orderings for the database relations do exist, the
results of Theorem 6.5, Theorem 6.6 and Corollary 6.8 can be transferred with the same
bounds by a reduction to the dictionary setting.
In the attribute-wise ordered setting (a-ordered setting), for each relation R and each
attribute A of R, there is some X-ordered array representing R, such that A is the first
attribute of X.
Lemma 7.5. For every ε > 0, there is a O(1)-time parallel algorithm that, given a database
D in the attribute-wise ordered setting, computes a dictionary with work and space O(|D|1+ε)
on an Arbitrary CRCW PRAM.
Proof. In the ordered setting an algorithm can essentially proceed similarly to the algorithm
for the general setting detailed above. To yield the better upper bound of O(|D|1+ε) it
would suffice to use the algorithm for deduplication for ordered arrays (cf. Lemma 4.7),
since this is the only operation with a non-linear work bound. However, the array D is not
necessarily ordered.
We will show how to construct another array C that, like D, contains all (token
representations of) data values in D, and is piecewise ordered. It is then possible to search,
for each cell of D, a representative cell in C. We note that the unordered version D is still
required to carry out KeyOf in constant time (by a single processor).
To construct C, the algorithm first computes ordered arrays CR,j which correspond to
the arrays BR,j. Let R ∈Σ and j ∈{1, . . . , ar(R)}. Furthermore, let Xj be an ordered list
of all attributes of R that starts with the j-th attribute Aj of R. The array CR,j can now
be derived from the array AR,Xj as follows with |R| processors: Processor p writes the token
representation (R, i, j) for the value of the j-th attribute of the i-tuple of R into cell CR,j[p]
if i = AR,Xj[p]. Since AR,Xj induces the lexicographical order w.r.t. Xj and Xj starts with
Aj, the array CR,j is fully ordered w.r.t. {Aj}. The array C is then the concatenation of all
CR,j. Computing C requires linear work and space.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:43
To determine representatives, fix an arbitrary linear order on the set of all pairs (R, j)
where R is a relation symbol from Σ and j ∈{1, . . . , ar(R)}. For each pair (R, j) the
algorithm invokes the algorithm of Lemma 4.7 to find representatives for all data values
in the subarray CR,j of C. Since there are only constantly many pairs (R, j) this can be
done in constant time with O(|D|1+ε) work and O(|D|) space thanks to Lemma 4.7 and
each CR,j being fully ordered. The representative for a cell D[ℓ] is then the representative
cell for D[ℓ] of the subarray CR,j for the smallest pair (R, j) for which such a representative
cell exists in CR,j.
The operations KeyOf and KeyOutput can then be implemented analogously to the
general setting. That is, instead of returning an index of D, KeyOf(R, i, j) returns the index
of the representative cell in C for the cell of D containing (R, i, j), and KeyOutput(k, i, j)
can use the token representation in C[k] to output the proper value.
By combining Theorem 6.2 with Lemma 7.5, and since IN1+ε is dominated by the upper
bounds of Theorem 6.5, Theorem 6.6 and Corollary 6.8, we can conclude following result.
Corollary 7.6.
(a) For every ε > 0 and each query q of the semijoin algebra there is a O(1)-time parallel
algorithm that, given a database D, evaluates q(D) on an Arbitrary CRCW PRAM with
work and space O(IN1+ε) in the attribute-wise ordered setting.
(b) The results of Theorem 6.5, Theorem 6.6 and Corollary 6.8 hold in the attribute-wise
ordered setting with the same upper bounds.
It should be mentioned that a relaxed form of the dictionary setting where data values
can be of polynomial size in |D| can be easily transformed into the a-ordered setting with
the algorithm of Proposition 2.11.
8. Conclusion
This article is meant as a first study on work-efficient O(1)-time parallel algorithms for query
evaluation and many questions remain open. The results are very encouraging as they show
that quite work-efficient O(1)-time parallel algorithms for query evaluation are possible. In
fact, the results give a hint at what could be a good notion of work-efficiency in the context of
constant-time parallel query evaluation. Our impression is that work-optimality is very hard
to achieve in constant time and that query evaluation should be considered as work-efficient
for a query language, if there are constant-time parallel algorithms with O(T 1+ε) work, for
every ε > 0, where T is the best sequential time of an evaluation algorithm. Of course, it
would be nice if this impression could be substantiated by lower bound results, but that
seems to be challenging.
It also remains open whether O(1)-time parallel versions of more advanced query
evaluation algorithms can be implemented. An intriguing example is the PANDA algorithm
[KNS25]. A O(1)-time parallel version of PANDA would yield significant improvements over
our results on conjunctive and natural join queries. However, while we believe that O(1)-
time parallel algorithms for PANDA’s operations [KNS25, Section 5.1] can be implemented,
PANDA also computes statistics, e.g. the degree of input values, to decide which operations
are invoked. Due to the limitation of O(1)-time parallel algorithms (e.g., Proposition 2.1), it
is not possible to compute these statistics exactly, within our framework. It is likely that

---

27:44
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
approximations of these statistics would still be sufficient, but verifying this claim is beyond
the scope of this article.
Some results presented in this article can be slightly improved. Indeed, Daniel Albert
has shown in his Master’s thesis that predecessor and successor links can be computed with
work and space O(n log(n)) for arrays of length n, improving Proposition 2.8 [Alb24]. The
algorithm uses the technique from [FRW88, Theorem 1] to find the first 1 in an array of
length n in constant time with work O(n).22 As a consequence deduplication (Lemma 4.7),
and the evaluation of ProjectX (Proposition 5.3) are possible with work O(n log(n)) (as
compared to O(n1+ϵ)). However, the lower bound from Theorem 5.1 shows that such an
improvement is not possible for the operation SemiJoin.
There remain many questions for future work. Is it possible to improve some of the
work bounds of the form O(T 1+ε) to O(T log(T))? Are there more lower bound results
preventing this? Can the work bounds be improved for particular kinds of join queries?
And of course, we are still interested in the dynamic setting, that is if the database is
modified, but auxiliary data can be used.
Acknowledgements
We are grateful to Uri Zwick for clarifications regarding results in [GZ95] and to Jonas
Schmidt and Jennifer Todtenhoefer for careful proofreading. We thank Martin Dietzfelbinger
for helpful discussions. Furthermore, we thank the reviewers of ICDT for many insightful
suggestions.
Finally, we thank the reviewers of this journal article for their insightful
comments. In particular, we are grateful for the suggestion to state Theorem 6.1 as a
separate result about the evaluation of query plans, and to derive many of the subsequent
results from it.
References
[AB96]
Alberto Apostolico and Dany Breslauer. An optimal O(log log N)-time parallel algorithm
for detecting all squares in a string. SIAM Journal on Computing, 25(6):1318–1331, 1996.
doi:10.1137/S0097539793260404.
[ABBK17]
Amir Abboud, Arturs Backurs, Karl Bringmann, and Marvin K¨unnemann. Fine-grained com-
plexity of analyzing compressed data: Quantifying improvements over decompress-and-solve. In
IEEE 58th Annual Symposium on Foundations of Computer Science (FOCS), pages 192–203.
IEEE, 2017. doi:10.1109/FOCS.2017.26.
[ABL+21]
Marcelo Arenas, Pablo Barcel´o, Leonid Libkin, Wim Martens, and Andreas Pieris. Database
Theory. Open source at https://github.com/pdm-book/community, 2021. Preliminary Version,
August 19, 2022.
[ABW15]
Amir Abboud, Arturs Backurs, and Virginia Vassilevska Williams. If the current clique algorithms
are optimal, so is Valiant’s parser. In IEEE 56th Annual Symposium on Foundations of Computer
Science, pages 98–117. IEEE, 2015. doi:10.1109/FOCS.2015.16.
[AGM13]
Albert Atserias, Martin Grohe, and D´aniel Marx. Size bounds and query plans for relational
joins. SIAM Journal on Computing, 42(4):1737–1767, 2013. doi:10.1137/110859440.
[AHV95]
Serge Abiteboul, Richard Hull, and Victor Vianu. Foundations of Databases. Addison-Wesley,
1995. URL: http://webdam.inria.fr/Alice/.
22A more precise description can be found on pages 33 and 34 in the appendix of [Alb26]. The description
is for an input with log n items, though.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:45
[Ajt93]
Mikl´os Ajtai. Approximate counting with uniform constant-depth circuits. In Jin-Yi Cai, editor,
Advances In Computational Complexity Theory, Proceedings of a DIMACS Workshop, New
Jersey, USA, December 3-7, 1990, volume 13 of DIMACS Series in Discrete Mathematics
and Theoretical Computer Science, pages 1–20. American Mathematical Society, 1993. doi:
10.1090/dimacs/013/01.
[AKL+24]
Arpit Agarwal, Sanjeev Khanna, Huan Li, Prathamesh Patil, Chen Wang, Nathan White, and
Peilin Zhong. Parallel approximate maximum flows in near-linear work and polylogarithmic
depth. In David P. Woodruff, editor, Proceedings of the 2024 ACM-SIAM Symposium on Discrete
Algorithms, SODA 2024, Alexandria, VA, USA, January 7-10, 2024, pages 3997–4061. SIAM,
2024. doi:10.1137/1.9781611977912.140.
[Alb24]
Daniel Albert. On parallel constant-time string algorithms. Master’s thesis, 2024.
[Alb26]
Daniel Albert. Longest common extension of a dynamic string in parallel constant time, 2026.
arXiv:2604.12696, doi:10.48550/arxiv.2604.12696.
[AV87]
Yossi Azar and Uzi Vishkin. Tight comparison bounds on the complexity of parallel sorting.
SIAM Journal on Computing, 16(3):458–464, 1987. doi:10.1137/0216032.
[BB13]
Johann Brault-Baron. De la pertinence de l’´enum´eration : complexit´e en logiques proposi-
tionnelle et du premier ordre. Theses, Universit´e de Caen, April 2013. URL: https://hal.
archives-ouvertes.fr/tel-01081392.
[BDG07]
Guillaume Bagan, Arnaud Durand, and Etienne Grandjean. On acyclic conjunctive queries and
constant delay enumeration. In Jacques Duparc and Thomas A. Henzinger, editors, Computer
Science Logic, 21st International Workshop, CSL 2007, 16th Annual Conference of the EACSL,
Lausanne, Switzerland, September 11-15, 2007, Proceedings, volume 4646 of Lecture Notes in
Computer Science, pages 208–222. Springer, 2007. doi:10.1007/978-3-540-74915-8_18.
[BG81]
Philip A. Bernstein and Nathan Goodman. Power of natural semijoins. SIAM Journal on
Computing, 10(4):751–771, 1981. doi:10.1137/0210059.
[BIS90]
David A. Mix Barrington, Neil Immerman, and Howard Straubing. On uniformity within NC1.
Journal of Computer and System Sciences, 41(3):274–306, 1990. doi:10.1016/0022-0000(90)
90022-D.
[BKS17]
Paul Beame, Paraschos Koutris, and Dan Suciu. Communication steps for parallel query
processing. Journal of the ACM, 64(6):40:1–40:58, 2017. doi:10.1145/3125644.
[Bre92]
Dany Breslauer. Efficient String Algorithmics. PhD thesis, Columbia University, 1992.
[CDHR88]
Bogdan S. Chlebus, Krzysztof Diks, Torben Hagerup, and Tomasz Radzik. Efficient simulations
between concurrent-read concurrent-write PRAM models. In Michal Chytil, Ladislav Janiga,
and V´aclav Koubek, editors, Mathematical Foundations of Computer Science 1988, MFCS’88,
Carlsbad, Czechoslovakia, August 29 - September 2, 1988, Proceedings, volume 324 of Lecture
Notes in Computer Science, pages 231–239. Springer, 1988. doi:10.1007/BFB0017146.
[CDR86]
Stephen A. Cook, Cynthia Dwork, and R¨udiger Reischuk. Upper and lower time bounds for
parallel random access machines without simultaneous writes. SIAM Journal on Computing,
15(1):87–97, 1986. doi:10.1137/0215006.
[CF23]
Nairen Cao and Jeremy T. Fineman. Parallel exact shortest paths in almost linear work and
square root depth. In Nikhil Bansal and Viswanath Nagarajan, editors, Proceedings of the 2023
ACM-SIAM Symposium on Discrete Algorithms, SODA 2023, Florence, Italy, January 22-25,
2023, pages 4354–4372. SIAM, 2023. doi:10.1137/1.9781611977554.CH166.
[CGK01]
Zhiyuan Chen, Johannes Gehrke, and Flip Korn. Query optimization in compressed database
systems. In Sharad Mehrotra and Timos K. Sellis, editors, Proceedings of the 2001 ACM SIGMOD
international conference on Management of data, Santa Barbara, CA, USA, May 21-24, 2001,
SIGMOD/PODS01, pages 271–282. ACM, 2001. doi:10.1145/375663.375692.
[Cha96]
Shiva Chaudhuri. Sensitive functions and approximate problems. Information and Computation,
126(2):161–168, 1996. doi:10.1006/inco.1996.0043.
[Cod72]
E. F. Codd. Relational completeness of data base sublanguages. In R. Rustin, editor, Database
Systems, pages 33–64. Prentice-Hall, 1972.
[CR98]
Ka Wong Chong and Edgar A. Ramos. Improved deterministic parallel padded sorting. In
Gianfranco Bilardi, Giuseppe F. Italiano, Andrea Pietracaprina, and Geppino Pucci, editors,
Algorithms - ESA ’98, 6th Annual European Symposium, Venice, Italy, August 24-26, 1998,

---

27:46
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Proceedings, volume 1461 of Lecture Notes in Computer Science, pages 405–416. Springer, 1998.
doi:10.1007/3-540-68530-8_34.
[DBS21]
Laxman Dhulipala, Guy E. Blelloch, and Julian Shun. Theoretically efficient parallel graph
algorithms can be fast and scalable. ACM Transactions on Parallel Computing (TOPC), 8(1):4:1–
4:70, 2021. doi:10.1145/3434393.
[DS95]
Guozhu Dong and Jianwen Su. Incremental and decremental evaluation of transitive closure
by first-order queries. Information and Computation, 120(1):101–106, July 1995. doi:10.1006/
inco.1995.1102.
[DV91]
Karl Denninghoff and Victor Vianu. The power of methods with parallel semantics. In Guy M.
Lohman, Am´ılcar Sernadas, and Rafael Camps, editors, 17th International Conference on Very
Large Data Bases, September 3-6, 1991, Barcelona, Catalonia, Spain, Proceedings, pages 221–232.
Morgan Kaufmann, 1991. URL: http://www.vldb.org/conf/1991/P221.PDF.
[FRW88]
Faith E. Fich, Prabhakar Ragde, and Avi Wigderson. Relations between concurrent-write models
of parallel computation. SIAM Journal on Computing, 17(3):606–627, 1988. doi:10.1137/
0217037.
[GEB21]
Fady Ghanim, Wael R. Elwasif, and David E. Bernholdt. Implementing arbitrary/common
concurrent writes of CRCW PRAM. In Federico Silla and Osni Marques, editors, ICPP Workshops
2021: 50th International Conference on Parallel Processing, Virtual Event / Lemont (near
Chicago), IL, USA, August 9-12, 2021, pages 37:1–37:9. ACM, 2021. doi:10.1145/3458744.
3474041.
[GGLS16]
Georg Gottlob, Gianluigi Greco, Nicola Leone, and Francesco Scarcello. Hypertree decomposi-
tions: Questions and answers. In Tova Milo and Wang-Chiew Tan, editors, Proceedings of the
35th ACM SIGMOD-SIGACT-SIGAI Symposium on Principles of Database Systems, PODS
2016, San Francisco, CA, USA, June 26 - July 01, 2016, SIGMOD/PODS’16, pages 57–74.
ACM, 2016. doi:10.1145/2902251.2902309.
[GLS02]
Georg Gottlob, Nicola Leone, and Francesco Scarcello. Hypertree decompositions and tractable
queries. Journal of Computer and System Sciences, 64(3):579–627, 2002. doi:10.1006/jcss.
2001.1809.
[GMV93]
Michael T. Goodrich, Yossi Matias, and Uzi Vishkin. Approximate parallel prefix computation
and its applications. In The Seventh International Parallel Processing Symposium, Proceedings,
Newport Beach, California, USA, April 13-16, 1993, pages 318–325. IEEE Computer Society
Press, 1993. doi:10.1109/IPPS.1993.262899.
[GMV94]
Michael T. Goodrich, Yossi Matias, and Uzi Vishkin. Optimal parallel approximation for prefix
sums and integer sorting. In Daniel Dominic Sleator, editor, Proceedings of the Fifth Annual ACM-
SIAM Symposium on Discrete Algorithms. 23-25 January 1994, Arlington, Virginia, USA, pages
241–250. ACM/SIAM, 1994. URL: http://dl.acm.org/citation.cfm?id=314464.314499.
[GZ95]
Tal Goldberg and Uri Zwick. Optimal deterministic approximate parallel prefix sums and their
applications. In Third Israel Symposium on Theory of Computing and Systems, ISTCS 1995,
Tel Aviv, Israel, January 4-6, 1995, Proceedings, ISTCS-95, pages 220–228. IEEE Computer
Society Press, 1995. doi:10.1109/ISTCS.1995.377028.
[Hag92a]
Torben Hagerup. The log-star revolution. In Alain Finkel and Matthias Jantzen, editors, STACS
92, 9th Annual Symposium on Theoretical Aspects of Computer Science, Cachan, France,
February 13-15, 1992, Proceedings, volume 577 of Lecture Notes in Computer Science, pages
259–278. Springer, 1992. doi:10.1007/3-540-55210-3_189.
[Hag92b]
Torben Hagerup. On a compaction theorem of Ragde. Information Processing Letters, 43(6):335–
340, 1992. doi:10.1016/0020-0190(92)90121-B.
[HR93]
Torben Hagerup and Rajeev Raman. Fast deterministic approximate and exact parallel sorting. In
Lawrence Snyder, editor, Proceedings of the 5th Annual ACM Symposium on Parallel Algorithms
and Architectures, SPAA ’93, Velen, Germany, June 30 - July 2, 1993, SPAA ’93, pages 346–355.
ACM Press, 1993. doi:10.1145/165231.157380.
[HY19]
Xiao Hu and Ke Yi. Instance and output optimal parallel algorithms for acyclic joins. In Dan
Suciu, Sebastian Skritek, and Christoph Koch, editors, Proceedings of the 38th ACM SIGMOD-
SIGACT-SIGAI Symposium on Principles of Database Systems, PODS 2019, Amsterdam, The
Netherlands, June 30 - July 5, 2019, pages 450–463. ACM, 2019. doi:10.1145/3294052.3319698.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:47
[HY20]
Xiao Hu and Ke Yi. Massively parallel join algorithms. ACM SIGMOD Record, 49(3):6–17, 2020.
doi:10.1145/3444831.3444833.
[Imm89]
Neil Immerman. Expressibility and parallel complexity. SIAM Journal on Computing, 18(3):625–
638, 1989. doi:10.1137/0218043.
[Imm99]
Neil Immerman. Descriptive Complexity. Graduate texts in computer science. Springer, 1999.
doi:10.1007/978-1-4612-0539-5.
[J´aJ92]
Joseph F. J´aJ´a. An Introduction to Parallel Algorithms. Addison-Wesley, 1992.
[KBS16]
Paraschos Koutris, Paul Beame, and Dan Suciu. Worst-case optimal algorithms for parallel
query processing. In International Conference on Database Theory, ICDT 2016, pages 8:1–8:18.
Schloss Dagstuhl - Leibniz-Zentrum fuer Informatik GmbH, Wadern/Saarbruecken, Germany,
2016. doi:10.4230/LIPIcs.ICDT.2016.8.
[KNS25]
Mahmoud Abo Khamis, Hung Q. Ngo, and Dan Suciu. PANDA: query evaluation in submodular
width. TheoretiCS, 4, 2025. doi:10.46298/THEORETICS.25.12.
[KSS18]
Paraschos Koutris, Semih Salihoglu, and Dan Suciu. Algorithmic aspects of parallel data
processing. Foundations and Trends in Databases, 8(4):239–370, 2018. doi:10.1561/1900000055.
[KSS23]
Jens Keppeler, Thomas Schwentick, and Christopher Spinrath. Work-efficient query evaluation
with PRAMs. In Floris Geerts and Brecht Vandevoort, editors, 26th International Conference on
Database Theory, ICDT 2023, March 28-31, 2023, Ioannina, Greece, volume 255 of LIPIcs, pages
16:1–16:20. Schloss Dagstuhl - Leibniz-Zentrum f¨ur Informatik, 2023. doi:10.4230/LIPIcs.ICDT.
2023.16.
[LFL+24]
Yang Liu, Wenfei Fan, Shuhao Liu, Xiaoke Zhu, and Jianxin Li. A single machine system
for querying big graphs with PRAM. Proc. VLDB Endow., 18(3):756–769, 2024. URL: https:
//www.vldb.org/pvldb/vol18/p756-liu.pdf, doi:10.14778/3712221.3712240.
[LMTdB05] Dirk Leinders, Maarten Marx, Jerzy Tyszkiewicz, and Jan Van den Bussche. The semijoin
algebra and the guarded fragment. Journal of Logic, Language and Information, 14(3):331–343,
2005. doi:10.1007/s10849-005-5789-8.
[LV07]
Dirk Leinders and Jan Van den Bussche. On the complexity of division and set joins in
the relational algebra. Journal of Computer and System Sciences, 73(4):538–549, 2007. doi:
10.1016/j.jcss.2006.10.011.
[LVC07]
Bryant C. Lee, Uzi Vishkin, and George C. Caragea. Models for advancing PRAM and other
algorithms into parallel programs for a pram-on-chip platform. In Sanguthevar Rajasekaran and
John H. Reif, editors, Handbook of Parallel Computing - Models, Algorithms and Applications.
Chapman and Hall/CRC, 2007. doi:10.1201/9781420011296.CH5.
[NPRR18]
Hung Q. Ngo, Ely Porat, Christopher R´e, and Atri Rudra. Worst-case optimal join algorithms.
Journal of the ACM, 65(3):16:1–16:40, 2018. doi:10.1145/3180143.
[PI97]
Sushant Patnaik and Neil Immerman. Dyn-FO: A parallel, dynamic complexity class. Journal
of Computer and System Sciences, 55(2):199–209, 1997. doi:10.1006/jcss.1997.1520.
[PW87]
J. Paris and A. Wilkie. Counting ∆0 sets. Fundamenta Mathematicae, 127(1):67–76, 1987. URL:
http://eudml.org/doc/211630.
[Ros08]
Benjamin Rossman. On the constant-depth complexity of k-clique. In Proceedings of the 40th
Annual ACM Symposium on Theory of Computing, Victoria, British Columbia, Canada, May
17-20, 2008, STOC ’08, pages 721–730. ACM, 2008. doi:10.1145/1374376.1374480.
[Spi24]
Christopher Spinrath. Query Evaluation Revised: Parallel, Distributed, via Rewritings. PhD
thesis, TU Dortmund University, 2024. doi:10.17877/DE290R-24219.
[SST+21]
Jonas Schmidt, Thomas Schwentick, Till Tantau, Nils Vortmeier, and Thomas Zeume. Work-
sensitive dynamic complexity of formal languages. In Stefan Kiefer and Christine Tasson, editors,
Foundations of Software Science and Computation Structures - 24th International Conference,
FOSSACS 2021, volume 12650 of Lecture Notes in Computer Science, pages 490–509. Springer
International Publishing, 2021. doi:10.1007/978-3-030-71995-1_25.
[vEB90]
Peter van Emde Boas. Machine models and simulation. In Jan van Leeuwen, editor, Handbook
of Theoretical Computer Science, Volume A: Algorithms and Complexity, pages 1–66. Elsevier
and MIT Press, 1990.

---

27:48
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
[Vel14]
Todd L. Veldhuizen. Triejoin: A simple, worst-case optimal join algorithm. In Nicole Schweikardt,
Vassilis Christophides, and Vincent Leroy, editors, Proc. 17th International Conference on Data-
base Theory (ICDT), Athens, Greece, March 24-28, 2014, pages 96–106. OpenProceedings.org,
2014. doi:10.5441/002/icdt.2014.13.
[Vol99]
Heribert Vollmer. Introduction to Circuit Complexity - A Uniform Approach. Texts in Theoretical
Computer Science. An EATCS Series. Springer, 1999. doi:10.1007/978-3-662-03927-4.
[WY22]
Yilei Wang and Ke Yi. Query evaluation by circuits. In Leonid Libkin and Pablo Barcel´o, editors,
PODS ’22: International Conference on Management of Data, Philadelphia, PA, USA, June 12
- 17, 2022, SIGMOD/PODS ’22, pages 67–78. ACM, 2022. doi:10.1145/3517804.3524142.
[Yan81]
Mihalis Yannakakis. Algorithms for acyclic database schemes. In Very Large Data Bases, 7th
International Conference, September 9-11, 1981, Cannes, France, Proceedings, pages 82–94.
IEEE Computer Society, 1981.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:49
Appendix A. Revisiting Linear Compaction and Approximate Prefix Sums
The purpose of this section is to revisit the proof for Proposition 2.5 sketched by Goldberg
and Zwick [GZ95] and to analyse the space requirements of the compaction algorithm.
Compaction is closely related to prefix sums, as discussed in Section 2.2.1. Goldberg and
Zwick [GZ95] showed that approximate prefix sums can be computed in constant time using
a CRCW PRAM with polynomial work and space. This then gives rise to an algorithm for
linear compaction as stated in Proposition 2.5. Before we revisit the algorithm and analyse
its required space, let us give a formal definition of approximate prefix sums.
Definition A.1. For any λ > 0, a sequence s1, . . . , sn of natural numbers is called a
consistent λ-approximate prefix sums sequence of a sequence a1, . . . , an of natural numbers,
if for every i ∈{1, . . . , n} the following conditions hold.
(1) Pi
j=1 aj ≤si ≤(1 + λ) Pi
j=1 aj
(2) si −si−1 ≥ai if i > 1 and si ≥ai if i = 1.
The first condition ensures that each si is an approximation of the exact prefix sum and
the second condition ensures consistency, that is, that the difference between consecutive
(approximate) prefix sums is at least as large as the respective number.
Since we consider only consistent λ-approximate prefix sums we will omit the term “con-
sistent” from here on out. We restate the result of Goldberg and Zwick from Proposition 2.5.
Proposition 2.6 [GZ95, Theorem 4.2]. (Restated) For every ε > 0 and a > 0 there is
an O(1)-time parallel algorithm that computes λ-consistent prefix sums for any array of
length n with (log n)-bit integers, for λ(n) = (log n)−a. The algorithm requires work and
space O(n1+ε) on a Common CRCW PRAM.
To prove Proposition 2.6, Goldberg and Zwick proceed in three major steps. Based on
an algorithm for approximate counting by Ajtai [Ajt93], they first show that the sum of
n integers can be approximated in constant time with polynomial work and space. In the
second step this is used to compute approximate prefix sums with polynomial work and
space. The third step reduces the required work and space to O(n1+ε). Our presentation
will proceed analogously. The required result on approximate counting is the following.
Proposition A.2 [Ajt93, Theorem 2.1]. For every integer a > 0 there is an O(1)-time
parallel algorithm that, given an array A whose cells contain either 1 or 0, computes a
number k satisfying #1(A) ≤k ≤(1 + λ(|A|))#1(A) where #1(A) is the number of cells
of A containing a 1 and λ(n) = (log n)−a. The algorithm requires polynomial work and
space on a Common CRCW PRAM.
Let us point out that Proposition A.2 is phrased with our application in mind. Ajtai
actually stated it in terms of first-order formulas over the signature (+, ×, ≤) where +, ×, ≤
are binary relation symbols with the usual intended meaning. For every n let Mn be the
structure over (+, ×, ≤) with universe Mn = {0, . . . , n −1} and the usual interpretation of
the arithmetic relations +,×, and ≤. Ajtai proved the following.
For every a′ > 0 there is a formula φ(x, Y ) over (+, ×, ≤) with a free variable x and a
free unary relation variable Y , such that for every integer n > 0, m ∈Mn, and A ⊆Mn the
following holds.
(1) If |A| ≤(1 −λ′(n))m then Mn̸ |= φ(m, A); and
(2) if |A| ≥(1 + λ′(n))m then Mn |= φ(m, A).

---

27:50
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Here λ′(n) is of the same form as λ(n) in Proposition A.2, that is, λ′(n) = (log n)−a′.
We will briefly discuss how this implies Proposition A.2 as stated above. Let a be given
and a′ be such that λ′(n) ≤1
3λ(n), for sufficiently large n. Let A be an array with entries
from {0, 1}. We fix n = |A| and the interpretation A = {i ∈Mn | A[i + 1] = 1} for Y .
Further, we assume that |A| ≥(log n)a holds, and that n is sufficiently large. For small n,
#1(A) can be determined exactly, in a trivial way. We discuss the case |A| < (log n)a, and
how a PRAM can distinguish these two cases, in the end.
It is well-known that first-order formulas can be evaluated by a PRAM in constant time
with a polynomial number of processors and space (cf., e.g. Immerman [Imm99, Lemma 5.12],
the space bound is stated in the proof). Thus, it is possible to test, for all 0 ≤m ≤n −1 in
parallel, whether Mn |= φ(m, A) holds, and to write the results into an array C of size n.
Observe that Mn |= φ(0, A) holds and let m1 be the largest number from Mn such that
Mn |= φ(m, A) holds for all m ≤m1. Given the array C, the number m1 can easily be
determined with quadratic work and linear space.
We claim that k = (1 + λ′(n))(m1 + 1) satisfies |A| ≤k ≤(1 + 3λ(n)) |A|. Note that the
factor 3 in the upper bound is of no consequence, since a can always be chosen sufficiently
large. We first show that |A| ≤k holds. If m1 + 1 = n then |A| ≤n ≤k holds trivially.
Otherwise, m1 + 1 ≤n −1 and we have Mn̸ |= φ(m1 + 1, A) due to the choice of m1. Thus,
by contraposition of Statement (2) we know that |A| < (1 + λ′(n))(m1 + 1) = k.
Towards k ≤(1 + λ(n)) |A|, note that the contraposition of Statement (1) yields
|A| > (1 −λ′(n))m1 since Mn |= φ(m1, A) holds. Because 1 −λ′(n) < 1, this implies
|A| + 1 ≥(1 −λ′(n))(m1 + 1). Therefore, we can conclude
k = (1 + λ′(n))(m1 + 1) = (1 + λ′(n))(1 −λ′(n))(m1 + 1)
1 −λ′(n)
≤1 + λ′(n)
1 −λ′(n)(|A| + 1).
We claim that 1+λ′(n)
1−λ′(n) ≤1 + λ(n) holds for sufficiently large n. Indeed, we have
1 + λ′(n)
1 −λ′(n) ≤1 + λ(n) ⇔1 + λ′(n) ≤(1 −λ′(n))(1 + λ(n))
⇔1 + λ′(n) ≤1 + λ(n) −λ′(n) −λ(n)λ′(n)
⇔0 ≤λ(n) −2λ′(n) −λ(n)λ′(n)
⇔0 ≤λ(n) −2λ′(n) −λ(n)λ′(n)
where the last inequality holds, because λ(n) ≤1 and 3λ′(n) ≤λ(n) by our choice of λ(n).
Therefore, we have k ≤(1 + λ(n))(|A| + 1). Finally, we obtain (1 + λ(n))(|A| + 1) ≤
(1 + 3λ(n))(|A|) because
(1 + λ(n))(|A| + 1) = 1 + λ(n) + |A| + λ(n) |A| =

1 + λ(n) + 1
|A| + λ(n)
|A|

|A| ,
and we have
1
|A| ≤λ(n) as well as λ(n)
|A| ≤λ(n), since |A| ≥(log n)a by assumption and
λ(n) =
1
(log n)a ≤1.
We conclude the proof sketch for Proposition A.2 by stating the following lemma, which
justifies our assumption |A| ≥(log a)a: since PRAMs can evaluate first order formulas in
constant time with a polynomial number of processors and polynomial space, it indeed states
that PRAMs can compute |A| exactly, or detect that |A| ≥(log n)a holds.

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:51
Lemma A.3 [Ajt93, Lemma 2.2]. For every a > 0, there is a formula ψ(x, Y ) over (+, ×, ≤)
with a free variables x and a free unary relation variable Y , such that, for all A ⊆Mn,
Mn |= ψ(m, A) if and only if m = min{|A| , (log n)a}.
We note that [Ajt93] gives a self-contained proof but attributes this result to [PW87].
However in the latter paper the setting is slightly different, in that it considers arithmetic
over the natural numbers.
We now turn towards the first step of the proof for Proposition 2.6. It is captured by
the following result.
Proposition A.4 [GZ95, Theorem 3.1]. For every fixed integer a > 0, there is a O(1)-time
parallel algorithm that, given an array A containing a sequence a1, . . . , a|A| of natural numbers
of size at most O(log |A|), computes an integer s satisfying P|A|
i=1 ai ≤s ≤(1+λ(n)) P|A|
i=1 ai
where λ(n) = (log n)−a. The algorithm requires polynomial work and space on a Common
CRCW PRAM.
For a number ai, we denote by ai,j the bit at position j of the binary representation of
ai. The idea for Proposition A.4 is to approximate, for each position j, how many numbers
ai have a 1 at position j. That is, for each j, the algorithm computes an approximation k′
j
of kj = P|A|
i=1 ai,j using Proposition A.2. For this purpose, an algorithm can write the binary
representations of the numbers a1, . . . , an into a two-dimensional array of size O((log n) · n)
where n = |A|, filling up empty cells with 0. Assuming the numbers are written row-wise
into the array, Proposition A.2 can be applied to each column in parallel. Overall this
requires polynomial work and space.
The resulting numbers k′
0, . . . , k′
m with m ∈O(log n) satisfy kj ≤k′
j ≤(1 + λ(n))kj and
have size O(log n). Note that Pn
j=1 kj · 2j = Pn
i=1 ai, and, consequently, for s = Pn
j=1 k′
j · 2j
we have that Pn
i=1 ai ≤s ≤(1 + λ(n)) Pn
i=1 ai holds. Since there are only O(log n) many
numbers k′
j their exact sum, that is s, can be computed with polynomial work and space on
a Common CRCW PRAM.23
The next step is to show that prefix sums can be computed in constant time (with
polynomial work and space). Note that this mainly involves establishing consistency.
Proposition A.5 [GZ95, Theorem 3.2]. For every fixed a > 0, there is a O(1)-time parallel
algorithm that, given an array A containing a sequence a1, . . . , a|A| of natural numbers of
size at most O(log |A|), computes consistent λ-approximate prefix sums of a1, . . . , a|A| where
λ(n) = (log n)−a. The algorithm requires polynomial work and space on a Common CRCW
PRAM.
The algorithm for Proposition A.5 uses approximate summation trees which were
originally introduced by Goodrich, Matias, and Vishkin [GMV94, GMV93] for computing
prefix sums using randomisation.
Definition A.6 [GMV94, GMV93, Sections 2 and 3, resp.]. Let λ be an accuracy function.
A λ-approximate summation tree T for a sequence a1, . . . , an of integers is a complete,
ordered binary tree with n leaves in which every node v is labelled with an integer ˜s(v) such
that
23This seems to be folklore. It has been proved for polynomial-size, constant-depth circuits in, e.g., [Vol99,
Theorem 1.21] and these circuits can be simulated by a Common CRCW PRAM in constant time with
polynomial work and space, see, e.g., [J´aJ92, Theorem 10.9], where the space bound is implicit in the proof.

---

27:52
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
▶the i-th leaf (in, e.g., pre-order) is labelled with ai, for all 1 ≤i ≤n; and
▶s(v) ≤˜s(v) ≤(1 + λ(n))s(v) holds for each node v. Here s(v) is the sum Pj
k=i ak where
ai, . . . , aj are the leaf labels of the subtree rooted at v.
A λ-approximate summation tree is consistent if ˜s(v) ≥˜s(vℓ) + ˜s(vr) where vℓand vr denote
the children of v holds for all inner nodes v.
To compute λ-approximate prefix sums the algorithm first constructs a consistent
λ-approximate summation tree and then derives the prefix sums from it.
Indeed, given a λ-approximate summation tree T for a sequence a1, . . . , an, consistent
prefix sums can be derived as follows. For each i let Vi be the set of nodes in T that occur
as left children of a node on the path from the leaf for ai to the root but are not on the
path themselves. That is, a node v is in Vi if and only if
(1) v is the left child of a node w;
(2) v does not occur on the path from the node for ai to the root; but
(3) w does occur on the path from the node for ai to the root.
Observe that the subtrees rooted at the nodes in Vi induce a partition of a1, . . . , ai−1. Thus,
for bi = P
v∈Vi ˜s(v) + ai we have
i
X
j=1
aj ≤bi ≤(1 + λ(n))
i
X
j=1
aj.
Since Vi contains at most log n nodes, the sum bi can be computed with polynomial work
and space, cf. the proof of Proposition A.4. For a proof that the sequence b1, . . . , bn is
consistent, we refer to [GMV94, Lemma 3.2].
It remains to revisit how a PRAM can construct a consistent λ-approximate summation
tree. For any integer b > 0, a λ′-approximate summation tree T ′ where λ′ = (log n)−b can be
constructed with polynomial work and space by applying the algorithm of Proposition A.4
for each inner node of T ′. To obtain a consistent λ-approximate summation tree T the label
of every inner node of T ′ is multiplied with (1 + λ′(n))h where h is the height of the node.
More precisely, ˜s(v) = (1 + λ′(n))h˜s(v′) where v′ is the corresponding node of v in T ′ and h
is the height of v in T.
We follow the proof given for [GMV93, Lemma 2.2]24 to show that T is a consistent
λ-approximate summation tree. We start by proving that T is consistent.
Let v be an inner node of T, h its height, vℓ, vr its children, and v′, v′
ℓ, v′
r the corresponding
nodes in T ′. As in Definition A.6 we denote by s(w) the exact sum of all leaf labels of the
subtree rooted at w. We have that
˜s(vℓ) + ˜s(vr) = (1 + λ′(n))h−1˜s(v′
ℓ) + (1 + λ′(n))h−1˜s(v′
r)
≤(1 + λ′(n))hs(v′
ℓ) + (1 + λ′(n))hs(v′
r)
= (1 + λ′(n))hs(v′)
≤(1 + λ′(n))h˜s(v′)
= ˜s(v)
24We note that the proof in [GMV93, Lemma 2.2] uses a slightly different factor since their summation
trees assert (1 −λ(n))s(v) ≤˜s(v) instead of s(v) ≤˜s(v).

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:53
where the inequalities holds because T ′ is an λ′-approximate summation tree. Thus, T is
consistent.
We now argue that T is a λ-approximate summation tree. Indeed, for any inner node v
of T we have s(v) ≤˜s(v) ≤(1 + λ′(n))log(n)+1s(v) since T ′ is an approximate summation
tree (and all nodes have height at most log n). The claim then follows by the following
observation.25
Observation A.7. For all integers a > 1 there is an integer b > 1 such that for sufficiently
large n the inequality
(1 + λ′(n))log n ≤1 + 2(log n)λ′(n) ≤1 + λ(n)
holds where λ(n) = (log n)−a and λ′(n) = (log n)−b.
Explanation. The second inequality can always be established by choosing b large enough.
We thus focus on the first inequality. Let m = log n, so that we can write (1 +
1
mb )m for
(1 + λ(n)′)log n. Thanks to the binomial theorem we have
(1 + 1
mb )m =
m
X
k=0
m
k

1m−k
 1
mb
k
=
m
X
k=0
m
k
  1
mb
k
where the second equality holds simply because 1m−k = 1 for all k ∈{0, . . . , m}. Pulling
out the first two addends and then shifting k yields
m
X
k=0
m
k
  1
mb
k
= 1 + m · 1
mb +
m
X
k=2
m
k
  1
mb
k
= 1 + m · 1
mb +
m−1
X
k=1
 m
k + 1
  1
mb
k+1
.
To establish the inequality it thus suffices to show that r = Pm−1
k=1
  m
k+1
   1
mb
k+1 is less or
equal than m ·
1
mb . Indeed, then it follows that
(1 + 1
mb )m = 1 + m · 1
mb +
m−1
X
k=1
 m
k + 1
  1
mb
k+1
≤1 + 2 · m · 1
mb = 1 + 2(log n) · λ′(n)
holds.
For establishing r ≤m ·
1
mb , we observe that it suffices to show that
  m
k+1
   1
mb
k ≤1
holds, for every k ∈{1, . . . , m −1}. Expanding the binomial coefficient yields
 m
k + 1
  1
mb
k
=
m!
(k + 1)! · (m −k −1)! ·
 1
mb
k
= m · (m −1) · . . . · (m −k)
(k + 1)!
 1
mb
k
= m · (m −1) · . . . · (m −k)
(k + 1)! · mbk
.
Finally, note that there are k +1 factors in the numerator, each of which is less or equal than
m, and m occurs at least bk ≥2k ≥k + 1 times in the denominator, since k ≥1 and b > 1
by assumption. Since also (k + 1)! ≥1, we can conclude that
  m
k+1
   1
mb
k ≤1 holds.
The last step to prove Proposition 2.6 is to show that the work and space bounds can
be improved to O(n1+ε).
25The observation might be straightforward to some readers, but we feel that a self-contained presentation
should give its proof, as well.

---

27:54
J. Keppeler, T. Schwentick, and C. Spinrath
Vol. 22:2
Proof of Proposition 2.6. Due to Proposition A.5 there is a O(1)-time parallel algorithm
that computes prefix sums with polynomial work and space. Let n = |A| and c be a constant
such that this algorithm requires work and space O(nc). Furthermore, let ε > 0 be arbitrary
but fixed, and define δ = ε
c.
Let λ′(n) be an accuracy function of the form λ′(n) = (log n)−b such that (1 + λ′(n))2 ≤
(1 + λ(n)) holds for all n > 2. Note that this can be done by choosing a large enough b
which only depends on a.
The algorithm operates as follows in three steps. It first divides the given array A into
m = n1−δ subarrays A1, . . . , Am of size at most nδ. Then, for each subarray Ak in parallel,
arrays Bk containing consistent λ′-approximate prefix sums for Ak are computed using
the algorithm guaranteed by Proposition A.5. This step requires work and space O(n1+ε)
because

nδc
· n1−δ = n
ε
c c · n1−ε
c = n1+ε−ε
c ≤n1+ε.
In the second step, the algorithm initialises an array C of size n1−δ by setting C[1] = 0
and, for every index k > 1, C[k] to the largest prefix sum computed for Ak−1, i.e. Bk−1[nδ].
It then recursively computes an array D containing consistent λ′-approximate prefix sums
for C.
Finally, in the third step, the prefix sums for the Ak and C are combined to prefix
sums for A. For an index i ∈{1, . . . , n} let ki ∈{1, . . . , m} and i′ ∈{1, . . . , nδ} be such
that nδ · (ki −1) + i′ = i. That is, the i-th cell of A is the i′-th cell of subarray Aki. Let B
be the array of length n with B[i] = Bki[i] + D[ki]. The algorithm returns the array B.
The last step can easily be performed with linear work and space. The recursive call
in the second step thus requires O(n1+ε) as well. Note that the recursion depth is at most
lognδ n ∈O(1
δ). Therefore, the algorithm runs in constant time and requires work and space
O(n1+ε) as claimed.
In the following we prove that the algorithm is correct. That is, we prove that B contains
consistent λ-approximate prefix sums for A.
Let i ∈{1, . . . , n} and let i′ and ki be as before. We first show that B contains (not
necessarily consistent) approximate prefix sums for A. Indeed, we have
i
X
j=1
A[j] =
ki−1
X
ℓ=1
nδ
X
j=1
Aℓ[j] +
i′
X
j=1
Aki[j]
≤
ki−1
X
ℓ=1
Bℓ[nδ] + Bki[i′]
=
ki−1
X
ℓ=1
C[ℓ+ 1] + Bki[i′]
=
ki
X
ℓ=1
C[ℓ] + Bki[i′]
≤D[ki] + Bki[i′]
= B[i]

---

Vol. 22:2
WORK-EFFICIENT QUERY EVALUATION IN CONSTANT TIME WITH PRAMS
27:55
where the first inequality holds because the Bℓcontain prefix sums for the Aℓ, the second
and third equalities hold by definition of C (in particular, C[1] = 0), and the last inequality
holds because D contains approximate prefix sums for C.
Conversely, we have
B[i] = D[ki] + Bki[i′]
≤(1 + λ′(n))
ki
X
ℓ=1
C[ℓ] + Bki[i′]
= (1 + λ′(n))
ki−1
X
ℓ=1
Bℓ[nδ] + Bki[i′]
≤(1 + λ′(n))
ki−1
X
ℓ=1
(1 + λ′(n))
nδ
X
j=1
Aℓ[j] + (1 + λ′(n))
i′
X
j=1
Aki[j]
≤(1 + λ′(n))2h ki−1
X
ℓ=1
nδ
X
j=1
Aℓ[j] +
i′
X
j=1
Aki[j]
i
= (1 + λ′(n))2
i
X
j=1
A[j]
≤(1 + λ(n))
i
X
j=1
A[j]
where the first inequality holds because D contains λ′-approximate prefix sums for C, the
second equality holds by definition of C, and the second inequality holds because the Bℓ
contain λ′-approximate prefix sums for the Aℓ. The final inequality holds by choice of λ′.
It remains to show consistency for i ≥2. That is, we have to assert that B[i]−B[i−1] ≥
A[i] holds. We make a case distinction. If i and i −1 both map to the same subarray, i.e. if
ki = ki−1 holds, then
B[i]−B[i−1] = (Bki[i′]+D[ki])−(Bki[i′−1]+D[ki]) = Bki[i′]−Bki[i′−1] ≥Aki[i′] = A[i]
where the inequality holds because Bki contains consistent approximate prefix sums for Aki.
Otherwise, we can conclude that i is mapped to the first cell of Aki and i −1 is mapped
to the last cell of Aki−1. Thus, we have
B[i] −B[i −1] = (Bki[1] + D[ki]) −(Bki−1[nδ] + D[ki −1])
= D[ki] −D[ki −1] −Bki−1[nδ] + Bki[1]
≥C[ki] −Bki−1[nδ] + Bki[1]
= Bki[1]
≥Aki[1] = A[i]
where the first inequality holds because D contains consistent approximate prefix sums for
C, the last equality holds because we have C[ki] = Bki−1[nδ] by definition, and the last
inequality holds because Bki contains approximate prefix sums for Ak−1.
This work is licensed under the Creative Commons Attribution License. To view a copy of this
license, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative
Commons, 171 Second St, Suite 300, San Francisco, CA 94105, USA, or Eisenacher Strasse 2,
10777 Berlin, Germany

---

