# Maximal co-occurrence nonoverlapping sequential rule mining

> 来源: https://arxiv.org/pdf/2301.12630

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
1
Maximal co-occurrence nonoverlapping sequential
rule mining
Yan Li, Chang Zhang, Jie Li, Wei Song, Zhenlian Qi, Youxi Wu, Member, IEEE, and Xindong Wu, Fellow, IEEE
Abstract—The aim of sequential pattern mining (SPM) is
to discover potentially useful information from a given se-
quence. Although various SPM methods have been investigated,
most of these focus on mining all of the patterns. However,
users sometimes want to mine patterns with the same speciﬁc
preﬁx pattern, called co-occurrence pattern. Since sequential
rule mining can make better use of the results of SPM, and
obtain better recommendation performance, this paper addresses
the issue of maximal co-occurrence nonoverlapping sequential
rule (MCoR) mining and proposes the MCoR-Miner algo-
rithm. To improve the efﬁciency of support calculation, MCoR-
Miner employs depth-ﬁrst search and backtracking strategies
equipped with an indexing mechanism to avoid the use of
sequential searching. To obviate useless support calculations
for some sequences, MCoR-Miner adopts a ﬁltering strategy
to prune the sequences without the preﬁx pattern. To reduce
the number of candidate patterns, MCoR-Miner applies the
frequent item and binomial enumeration tree strategies. To
avoid searching for the maximal rules through brute force,
MCoR-Miner uses a screening strategy. To validate the per-
formance of MCoR-Miner, eleven competitive algorithms were
conducted on eight sequences. Our experimental results showed
that MCoR-Miner outperformed other competitive algorithms,
and yielded better recommendation performance than frequent
co-occurrence pattern mining. All algorithms and datasets
can be downloaded from https://github.com/wuc567/Pattern-
Mining/tree/master/MCoR-Miner.
Index Terms—Sequential pattern mining, sequential rule min-
ing, rule-antecedent, co-occurrence pattern, maximal rule mining
I. INTRODUCTION
A
S an important method of knowledge discovery [1],
sequential pattern mining (SPM) [2] aims to mine sub-
sequences (patterns) that meet certain conditions from se-
quence datasets [3]. A variety of SPM methods have been
derived for different mining requirements, such as order-
preserving SPM for time series [4], SPM for large-scale
databases [5, 6], episode pattern mining [7], spatial co-location
pattern mining [8, 9], contrast SPM [10, 11], negative SPM
[12, 13], high utility SPM [14], high average-utility SPM
Manuscript received August 22, 2022. (Corresponding author: Y. Wu).
Yan Li, Chang Zhang, Jie Li are with the School of Economics and
Management, Hebei University of Technology, Tianjin, 300400, China (e-
mail: lywuc@163.com.)
Wei Song is with the North China University of Technology, Beijing, China,
(e-mail: songwei@ncut.edu.cn)
Zhenlian Qi is with Guangdong Eco-Engineering Polytechnic, Guangzhou
510520, China, (e-mail: qzlhit@foxmail.com)
Youxi Wu is with the School of Artiﬁcial Intelligence, Hebei University of
Technology, Tianjin, 300400, China (e-mail: wuc567@163.com.)
Xindong Wu is with Key Laboratory of Knowledge Engineering with Big
Data (the Ministry of Education of China), Hefei University of Technology,
Hefei, 230009, China (e-mail: xwu@hfut.edu.cn)
[15–17], outlying SPM [18], three-way SPM [19, 20], co-
occurrence SPM [21, 22], and SPM with gap constraints [23].
One of the disadvantages of traditional SPM is that it only
considers whether a given pattern occurs within a sequence
and ignores the repetition of the pattern in the sequence
[24]. For example, the support (number of occurrences) of a
pattern ad in sequence adbdad is one according to traditional
SPM, despite the pattern ad occurring more than once in the
sequence. From this example, we see that repetition is ignored
in traditional SPM, meaning that some interesting patterns will
be lost [25].
To solve this issue, gap constraint SPM was proposed [26],
which can be expressed as p = p1p2 · · · pm−1pm with gap =
[a, b] (or p = p1[a, b]p2...[a, b]pm), where a and b (0 ≤a ≤b)
are integers indicating the minimum and maximum wildcards
between pj and pj+1, respectively [27, 28]. For example,
pattern a[0, 3]d means that there are zero to three wildcards
between a and d. Repetitions of patterns can be useful in
terms of capturing valuable information from sequences, and
gap constraint SPM therefore has many applications, such
as septic shock prediction for ICU patients [29], keyphrase
extraction [30], missing behaviors analysis [31], and pyramid
scheme pattern mining [32]. However, gap constraint SPM
is not only difﬁcult to solve, but also has many forms, such
as periodic gaps SPM [33], disjoint SPM [34], one-off SPM
[35], and nonoverlapping SPM [23]. Previous research work
has shown that the nonoverlapping SPM avoids the production
of many redundant patterns [24]; for example, under the
nonoverlapping condition, the pattern ad occurs twice in
sequence adbdad.
Unfortunately, current schemes based on gap constraint
SPM can only mine all of the frequent patterns. Compared
with rule mining, frequent pattern mining is not suitable for
making predictions or recommendations. Rule mining [36]
focuses on mining rules such as p →q, which means that
if pattern p occurs in the sequence, pattern q is likely to
appear afterward with a probability higher than or equal to
a given conﬁdence, i.e., conf(p →q) ≥mincf. However, in
cases where users only want to ﬁnd the rules with the same
antecedent p, then mining all the strong rules is not only time-
consuming and laborious, but also meaningless. For example,
in a recommendation problem, researchers hope to discover
potential rules from historical data and use the recent events
to predict future events. Obviously, it is valuable to discover
rules with the same recent events instead of all rules. This kind
of rule is called co-occurrence rule and is more meaningful.
For clariﬁcation, an illustrative example is as follows.
arXiv:2301.12630v1  [cs.DB]  30 Jan 2023

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
2
Example 1 Suppose
we
have
a
sequence
s
=
adbdadcdccabadcd, a gap constraint gap = [0,3], and
a predeﬁned support threshold minsup = 3. According to
nonoverlapping SPM, there are 12 frequent patterns: {a, c,
d, ad, cd, dc, dd, adc, add, dcd, ddc, adcd}. Moreover, if we
continue to set the minimum conﬁdence threshold mincf =
0.7, there are 11 rules: {a →d, a →dc, a →dd, a →dcd,
d →d, d →c, ad →d, ad →c, ad →cd, dd →c, adc →
d}. Obviously, it is difﬁcult for users to apply these excessive
numbers of frequent patterns and rules.
However, if we have a preﬁx-pattern (or antecedent) p =
ad, the number of frequent super-patterns and rules will be
reduced. The details are shown as follows. We know that p
= ad occurs four times in sequence s, since the subsequence
s1s2 is ad and the subsequences s5s6, s11s14, and s13s16 are
also ad. Thus, the support of p in s is four. Similarly, we know
that the subsequences s1s4s7, s5s6s9, and s11s14s15 are all
adc. Thus, the support of pattern adc in s is three, which is not
less than minsup = 3. Hence, the pattern adc is a frequent
co-occurrence pattern of p = ad. Furthermore, ad →c is a
co-occurrence rule whose conﬁdence is 3/4 = 0.75 ≥mincf
= 0.7. Similarly, we know that patterns add and adcd are
frequent, and that ad →d and ad →cd are co-occurrence
rules. Hence, there are only three co-occurrence patterns of
pattern p, adc, add, and adcd, and three co-occurrence rules
ad →c, ad →d, and ad →cd, which means that the number
of frequent patterns and rules is greatly reduced.
Inspired by the maximal SPM, the concept of maximal co-
occurrence rules (MCoRs) is developed to further decrease
the number of co-occurrence rules. For instance, if a rule p
→r is an MCoR, then we know that p →q is also a co-
occurrence rule, where pattern q is the preﬁx pattern of r.
Moreover, if the pattern w is a superpattern of r, then p →w
is not a co-occurrence rule. From the above examples, we see
that it is meaningful to investigate MCoR mining. The main
contributions of this paper are as follows.
1. To avoid mining irrelevant patterns and obtain better recom-
mendation performance, we develop MCoR mining, which
can mine all MCoRs with the same rule-antecedent, and
we propose the MCoR-Miner algorithm.
2. In MCoR mining, the user does not need to set the support
threshold, since it can be automatically calculated based
on the support of the rule-antecedent and the minimum
conﬁdence threshold.
3. To improve support calculation, MCoR-Miner consists of
three parts: a preparation stage, candidate pattern genera-
tion, and a screening strategy to improve efﬁciency.
4. To validate the performance of MCoR-Miner, eleven com-
petitive algorithms and eight datasets are selected. Our
experimental results verify that MCoR-Miner outperforms
the other competitive algorithms and yields better recom-
mendation performance than frequent SPM.
The structure of this paper is as follows. Section II gives
an overview of related work. Section III deﬁnes the problem.
Section IV presents the MCoR-Miner algorithm. Section V re-
ports the performance of MCoR-Miner. Section VI concludes
this paper.
II. RELATED WORK
The aim of SPM is to ﬁnd subsequences (patterns) in
a sequence database that meet the given requirements [37].
SPM methods are commonly used for data mining, since their
results are intuitive and interpretable [38, 39]. Traditional SPM
mainly focuses on frequent pattern mining, which means the
mined patterns have high frequency. To reduce the number
of patterns, top-k SPM [12], closed SPM [40], and maximal
SPM [41] were developed, all of which require that the data
are static rather than dynamic. To overcome this drawback,
incremental SPM [42] and window SPM [43] methods were
explored. However, the research community noticed that rare
patterns were of great signiﬁcance in the ﬁeld, and rare
pattern mining was also proposed [44]. In addition, to discover
missing events, negative SPM methods such as e-NSP [45] and
e-RNSP [46] were designed. An approach called high utility
SPM was also designed [47, 48], which can discover patterns
with low frequency but high utility [49, 50].
Most SPM methods can be seen as classical SPM [51],
since these methods only consider whether a pattern occurs
within a sequence, while repetitive SPM deeply considers the
number of occurrences of a pattern in the sequence [33].
For example, suppose we have two sequences: s1=aabbaaba
and s2=abcbc. According to classical SPM, the support of
pattern aba in s1 and s2 is one, since pattern aba occurs in
sequence s1=aabbaaba, but does not occur in sequence s2.
Thus, classical SPM neglects the fact that pattern aba occurs
in sequence s1=aabbaaba more than once, while repetitive
SPM considers the number of occurrences. Another signiﬁcant
difference is that classical SPM focuses on mining patterns in
sequences with itemsets, while repetitive SPM mainly aims
to mine patterns in sequences with items [52]. For example,
(ab)(bc)(a)(bd)(ad) is a sequence with itemsets, and each
itemset has many ordered items. If all itemsets in a sequence
have only one item, then the sequence is a sequence with
items. Thus, a sequence with items can be seen as a special
case of a sequence with itemsets. The sequences with items are
used in many ﬁelds, such as DNA sequence, protein sequence,
clickstreams, and commercial data.
Note that repetitive SPM is similar to episode mining [53].
The differences are three-fold. First, episode mining deals with
one sequence, while repetitive SPM processes one or more
sequences. Second, episode mining aims to mine patterns in
an event sequence, where an event sequence can be represented
by <(e1,t1), (e2,t2), · (en,tn)>, where ei is an event set, and ti
is the occurrence time of ei. In contrast, in repetitive SPM, the
sequences do not have the occurrence time. Third, in episode
mining, ei can be a set, while in repetitive SPM, the sequence
consists of items, rather than sets.
Compared with classical SPM, repetitive SPM not only is
more challenging, but also has many forms: general form (no
condition) [33], disjoint [52], one-off [54], and nonoverlapping
forms [55]. Note that the disjoint form was called the nonover-
lapping form in some studies [34, 46], which is far different
from the nonoverlapping form in this study. To clarify the
difference between disjoint and nonoverlapping, an illustrative
example is shown as follows.

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
3
Example 2 Suppose we have a sequence s=aabbaaba and a
pattern p=a[0,1]b[0,1]a.
In the disjoint form [34, 46], the ﬁrst position of an
occurrence is greater than the last position of its previous
occurrence. Thus, there are two occurrences: <1,3,5> and
<6,7,8>. Note that <1,3,5> and <2,4,6> do not satisfy the
disjoint form, since the ﬁrst position of occurrence <2,4,6>
2 is less than 5, which is the last position of <1,3,5>.
In the nonoverlapping form [24], each item cannot be
reused by the same pj, but can be reused by different pj. Thus,
there are three occurrences: <1,3,5>,<2,4,6>, and <6,7,8>.
Note that <2,4,6>, and <6,7,8> satisfy the nonoverlapping
form, since p3 matches s6 in <2,4,6>, and p1 matches s6 in
<6,7,8>.
Recently, various applications for SPM with gap constraints
were investigated. For example, top-k contrast nonoverlapping
SPM was proposed, in which the mined patterns can be used
as features for a sequence classiﬁcation task [10]. To discover
low frequency but high average utility patterns, high average
utility one-off SPM [49] and nonoverlapping SPM [56] were
developed. To discover missing events, a one-off negative
SPM was proposed, which could be used to predict the future
trend in trafﬁc ﬂow [13]. Inspired by three-way decisions
[19, 57], nonoverlapping three-way SPM [20] was designed
to mine the patterns to which users pay the most attention,
and can effectively mine patterns composed of strong-interest
and medium-interest items.
Most of these schemes aim to discover all of the patterns
that satisfy the predeﬁned constraints. However, in general,
these methods will discover numerous patterns. Although top-
k SPM [10], nonoverlapping closed SPM [40], and nonover-
lapping maximal SPM [41] can reduce the number of patterns,
users may not be interested in many of the patterns that
are discovered. However, these mining methods fail to reveal
the relationship between patterns. Rule mining is an effective
method in discovering the relationship between patterns [36].
There are many rule mining methods such as association rule
mining [58], sequential rule mining [36], episode rule mining
[59], and order-persevering rule mining [60]. Similar to pattern
mining, there are many methods to reduce the redundant rules,
such as maximum consequent and minimum antecedent [61],
top-k rule mining [58], closed rule mining, and maximal rule
mining [60]. Nevertheless, in some cases, users know a preﬁx
pattern advance, and they want to discover its super-patterns.
This is called co-occurrence pattern mining [62]. Based on
the co-occurrence patterns, co-occurrence rules can be further
explored to reveal the relationships between the preﬁx patterns
and their super-patterns. Although we can mine all patterns at
ﬁrst, and then ﬁlter out useless patterns with different preﬁxes,
this approach will increase the running time [63].
In summary, although the use of SPM with gap constraints
can make the mining results more meaningful, the mining
results of this scheme are not targeted. In order to make the
mining results more suitable for recommendations, based on
the special needs of users, we present a scheme inspired by
co-occurrence SPM [64] and maximal nonoverlapping SPM
[41], called MCoR mining.
III. PROBLEM DEFINITIONS
Deﬁnition 1 (Sequence) A sequence s with length n is de-
noted by s = s1s2 · · · sn, where si (1 ≤i ≤n) ∈P, P
represents a set of items in sequence s, and the size of P can
be expressed as | P |.
Deﬁnition 2 (Sequence database) A sequence database D
with length k is a set of sequences, denoted by D = {s1,
s2, · · · , sk}.
Deﬁnition 3 (Pattern) A pattern p with length m is denoted
by p = p1[a, b] p2 · · · [a, b]pm (or abbreviated as p = p1p2
· · · pm−1pm with gap = [a, b]), where a and b (0 ≤a ≤b)
are integers indicating the minimum and maximum wildcards
between pj and pj+1, respectively.
Deﬁnition 4 (Occurrence and nonoverlapping occurrence)
Suppose we have a sequence s = s1 s2 · · · sn and a pattern p
= p1[a, b]p2 · · · [a, b]pm. l = <l1, l2, · · · , lm> is an occurrence
of pattern p in sequence s if and only if p1 = sl1, p2 = sl2, · · · ,
pm = slm (0 ≤l1 ≤l2 ≤· · · ≤lm ≤n) and a ≤li −li−1 −1
≤b. We assume there is also another occurrence l
′ = <l
′
1, l
′
2,
· · · , l
′
m>. l and l
′ are two nonoverlapping occurrences if and
only if for any (1 ≤j ≤m), lj̸ = l
′
j.
Example 3 Suppose
we
have
a
sequence
s
=
adbdadcdccabadcd and a pattern p = a[0, 3]d. According to
the gap constraint [0,3], all occurrences of p in s are <1,2>,
<1,4>, <5,6>, <5,8>, <11,14>, <13,14> and <13,16>.
<1,2>
and
<1,4>
do
not
satisfy
the
nonoverlapping
condition, since 1 appears in these two occurrences in
the same position. Thus, there are four nonoverlapping
occurrences of p in s, which are <1,2>, <5,6>, <11,14>,
and <13,16>.
Note that there are many different methods to calculate the
nonoverlapping occurrences and the results may be different,
such as NETLAP [65], NETGAP [24], Netback [41], DFOM
[56]. For example, besides two nonoverlapping occurrences
<1,2> and <5,6>, <1,4> and <5,8> are also two nonover-
lapping occurrences. Although the results may be different,
this problem has been theoretically proved to be solved in
polynomial time [65]. More importantly, it has been shown
that there are four different ways to ﬁnd the nonoverlapping
occurrences, ﬁnding the maximal occurrences in the rightmost
leaf-root way, ﬁnding the maximal occurrences in the right-
most root-leaf way, ﬁnding the minimal occurrences in the
leftmost leaf-root way, and ﬁnding the minimal occurrences in
the leftmost root-leaf way [66]. In this example, <1,2> and
<5,6> are called minimal nonoverlapping occurrences [56],
while <1,4> and <5,8> are called maximal nonoverlapping
occurrences [65]. In this paper, we search for the minimal
nonoverlapping occurrences.
Deﬁnition 5 (Support) The support of pattern p in sequence s
is the number of nonoverlapping occurrences, represented by
sup(p, s). The support of pattern p in sequence database D is
the sum of the supports in each sequence, i.e., sup(p, D) =
Pk
l=1 sup(p, si).

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
4
Deﬁnition 6 (Frequent pattern) If the support of pattern p in
sequence s or D is no less than the minimum support threshold
minsup, then pattern p is a frequent pattern.
Deﬁnition 7 (Preﬁx pattern, subpattern, and superpattern).
Given two patterns p = p1p2 · · · pm−1pm and q = q1q2 · · ·
qn−1qn (m < n) with gap = [a, b], if and only if p1 = q1, p2
= q2, · · · , and pm = qm, then pattern p is the preﬁx pattern
of pattern q. Moreover, pattern p is a subpattern of pattern q,
and pattern q is a superpattern of pattern p.
Example 4 Given two patterns p = ad and q = adbd, pattern
p is the preﬁx pattern of pattern q.
Deﬁnition 8 (Co-occurrence pattern, co-occurrence rule, rule
antecedent, rule consequent, and conﬁdence) Suppose we have
a pattern q=p·r = p1p2 · · · pmqm+1qm+2 · · · qn, where
p = p1p2 · · · pm and r = qm+1qm+2 · · · qn. The pattern
r is a co-occurrence pattern of p, and p →r is a co-
occurrence rule, where p and r are the rule antecedent and
consequent, respectively. The ratio of the supports of patterns
q and p is called the conﬁdence of the sequential rule p →r,
and is denoted by conf(p →r) = sup(p·r,D)/sup(p,D). The
conﬁdence indicates the probability of occurrence of pattern r
when pattern p occurs.
Deﬁnition 9 (Maximal co-occurrence pattern) Suppose we
have a pattern q. If one of its superpattern r is a frequent
co-occurrence pattern, then pattern q is not a maximal co-
occurrence pattern; otherwise, pattern q is a maximal co-
occurrence pattern.
Deﬁnition 10 (Strong co-occurrence rule and MCoR) If
conf(p →r) is greater than or equal to the predeﬁned
threshold mincf, i.e., conf(p →r) ≥mincf, then p →
r is a strong co-occurrence rule. Suppose p →r is a strong
co-occurrence rule. For any superpattern w of pattern r, if p
→w is not a strong co-occurrence rule, then p →r is an
MCoR.
MCoR mining: Given a sequence s or sequence dataset D,
mincf, and preﬁx pattern p, the aim of MCoR mining is to
discover all MCoRs.
Example 5 From Example 1, we know that ad →c and ad
→cd are two co-occurrence rules. Rule ad →c is not an
MCoR, while rule ad →cd is an MCoR, since the pattern c
is the preﬁx pattern of cd and for any superpattern of cd, such
as cdc, ad →cdc is not a strong co-occurrence rule.
The symbols used in this paper are shown in Table I.
IV. PROPOSED ALGORITHM
In this section, we propose MCoR-Miner, an algorithm
designed to discover all MCoRs. MCoR mining is based on
nonoverlapping SPM whose main issue is support calculation.
Therefore, support calculation is a key aspect of MCoR mining
illustrated in Section IV-A. In addition to support calculation,
MCoR-Miner has three parts: preparation stage, candidate
pattern generation, and screening strategy. The framework of
MCoR-Miner is shown in Fig. 1.
TABLE I: Notations
Symbol
Description
s
A sequence with length n
D
A sequence database with k sequences
p
A pattern with length m
a, b
The minimum and maximum wildcards, respectively
sup(p, s)
The number of occurrences of p in s
sup(p, D)
The number of occurrences of p in D
P
The set of items in sequence database D
minsup
The minimum support threshold
mincf
The predeﬁned conﬁdence threshold
p →r
A co-occurrence rule
conf(p →r)
The conﬁdence of the co-occurrence rule p →r
Candidate pattern generation 
Frequent item set F1  
& frequent pattern with 
length-2 set F2 
FET strategy 
Prune infrequent items 
BET strategy 
Prune infrequent patterns 
with length-2 
Preparation stage 
 
 
 
Original 
D 
Shrunk D1 
and its Arr1 
Support calculation 
For each s in D 
sup=DBI (p, s) 
N 
sup=0 
 
Y 
Filtering Strategy 
 
 
 
Minimum support 
strategy 
Obtain minsup 
Screening strategy 
 
 
 
 
Pattern q 
All super-
patterns are 
infrequent 
Super- 
pattern r 
p→q is 
 an MCoR 
N 
Y 
Support 
calculation 
Maximal  
co-occurrence 
pattern q 
Fig. 1: Framework of MCoR-Miner. In the preparation stage,
shown in Section IV-B, a ﬁltering strategy is proposed to prune
the patterns whose support is zero to shrink the database, and a
minimum support strategy is then explored to obtain minsup
based on the user-deﬁned parameter minconf. In candidate
pattern generation, shown in Section IV-C, a frequent item
enumeration tree (FET) strategy and then a binomial enu-
meration tree (BET) strategy are developed to reduce the
number of candidate patterns. Finally, a screening strategy
shown in Section IV-D is proposed to discover the maximal
co-occurrence patterns to avoid a brute-force search.
A. Support calculation
Given a sequence and a pattern with gap constraints, the
calculation of its support is a pattern matching task [65].
From Deﬁnition 4, we know that all nonoverlapping occur-
rences are a subset of all occurrences, and these occurrences
can be expressed using a Nettree structure. Wu et al. [65]
ﬁrst theoretically proved that calculating the nonoverlapping
occurrences can be solved in polynomial-time. Some state-of-
the-art algorithms, such as NETLAP-Best [65] and NETGAP
[24], initially create a Nettree and then iteratively prune useless
nodes to ﬁnd all nonoverlapping occurrences on the Nettree.
The time complexities of NETLAP-Best and NETGAP are
both O(m × m × n × w), where m, n, and w are the
length of pattern and sequence, and b −a + 1, respectively.
Since pruning these useless nodes will consume a lot of
time, Netback [41] was proposed to improve the efﬁciency,
in which a Nettree is ﬁrst created and a backtracking strategy
is then employed to ﬁnd all nonoverlapping occurrences on

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
5
...... 
1 
2 
4 
6 
5 
6 
8 
11 
14 
15 
13 
16 
7 
9 
6 
3 
5 
2 
4 
3 
7 
3 
... 
12 
16 
... 
Fig. 2: Occurrences searching process of DFOM
the Nettree. The time complexity of NetBack is reduced to
O(m × n × w). Although a Nettree can intuitively represent
all occurrences, it contains a lot of useless information when
representing all nonoverlapping occurrences, such as useless
nodes and parent-child relationships. To further improve the
efﬁciency, DFOM [56] was proposed; this algorithm does
not need to create a whole Nettree, and employs depth-ﬁrst
search and backtracking strategies to ﬁnd all nonoverlapping
occurrences. One of the shortcomings of DFOM is that it
employs a sequential searching strategy to ﬁnd the feasible
child nodes of each current node. The time complexity of
DFOM is O(m×n), since DFOM also employs the depth-ﬁrst
and backtracking strategies without creating a whole Nettree.
To overcome this drawback, we propose a depth-ﬁrst search
and backtracking with indexes algorithm, called DBI, which
employs an indexing mechanism to avoid sequential searching.
Example 6 illustrates the principle of DFOM [56].
Example 6 We use the same sequence s = adbdadcdccabadcd
as in Example 3 and a pattern p = a[0, 3]d[0, 3]c. Fig. 2
illustrates the occurrences searching process of DFOM. We
know that p1 = a. Thus, DFOM sequentially searches for a in
sequence s. Now, DFOM creates a root, labeled node 1, since
s1 = p1 = a. According to the depth-ﬁrst search strategy,
DFOM sequentially searches for d in sequence s after node 1
with gap constraints [0, 3], since p2 = d. We know that s2 = d.
Thus, DFOM creates a child of node 1, labeled node 2. Since
p3 = c, DFOM sequentially searches for c in sequence s after
node 2 with gap constraints [0, 3]. Unfortunately, there is no
c between s3 and s6. Hence, using a backtracking strategy,
DFOM backtracks node 1 to ﬁnd a new child. We know that
s3 is b, which is not equal to p2 = d, and DFOM, therefore,
continues to search. We know that s4 is d which is equal to p2
= d. Thus, DFOM ﬁnds a new child of node 1, labeled node
4. Following a depth-ﬁrst search strategy, DFOM searches for
c in sequence s after node 4 with gap constraints [0, 3], since
p3 = c. It is easy to see that s5 and s6 are not equal to c.
Since s7 = c is equal to p3 and the gap between positions
7 and 4 is 2, this satisﬁes the gap constraints [0, 3]. Thus,
DFOM ﬁnds a new child of node 4, labeled node 7. Since the
length of p is three, DFOM ﬁnds an occurrence <1,4,7>. Now,
DFOM continues to search for a new root. Since s2, s3, and
s4 are not equal to a, these characters are ignored. Since s5
is a, DFOM ﬁnds a new root, labeled node 5. By iterating the
above process, DFOM ﬁnds a new nonoverlapping occurrence
<5,6,9>. Finally, occurrence <11,14,15> is found.
From Example 6 and Fig. 2, we know that the main
drawback of DFOM is its sequential search. To overcome this
shortcoming, DBI uses index arrays to store the positions of
each character. Example 7 illustrates the principle of DBI.
Fig. 3: Index arrays for sequence s.
a
1
5
11
13
d
2
4
6
8
c
7
9
10
15
14
16
Fig. 4: Occurrences searching process of DBI
Example 7 We use the same sequence s = adbdadcdccabadcd
and pattern p = a[0, 3]d[0, 3]c as in Example 6. DBI uses
index arrays to store the positions of each character, as shown
in Fig. 3. Fig. 4 shows the occurrences searching process of
DBI. Since p1 = a, DBI gets the ﬁrst element in the array a,
which is position 1. Thus, DBI creates a root, labeled node
1. Following a depth-ﬁrst search strategy, since p2 = d, DBI
gets the ﬁrst element in the array d, which is 2, and the gap
between positions 2 and 1 is zero, which satisﬁes the gap
constraints [0, 3]. Thus, DBI creates a child of node 1, labeled
node 2. According to a depth-ﬁrst search strategy, since p3 =
c, DBI gets the ﬁrst element in the array c, which is position
7. The gap between positions 7 and 2 is four, which does not
satisfy the gap constraints [0, 3]. According to the backtracking
strategy, DBI backtracks node 1 to ﬁnd a new child. We know
that the second element of the array d is position 4, which
satisﬁes the gap constraints [0, 3]. Thus, DBI creates a child
of node 1, labeled node 4. Now, DBI selects the ﬁrst element
of the array c, which is position 7, and it satisﬁes the gap
constraints [0, 3]. Hence, DBI obtains the occurrence <1,4,7>.
Then, DBI gets the second element of array a, which is position
5. By iterating the above process, DBI obtains the occurrence
<5,6,9>. Finally, <11,14,15> is found.
From Example 7, we know that DBI ﬁrst creates m level
nodes according to the index arrays of pattern p. Then,
based on the index arrays, DBI adopts the depth-ﬁrst search
and backtracking strategies to iteratively ﬁnd the minimal
nonoverlapping occurrences. The pseudocode of DBI is shown
in Algorithm 1. The main steps of DBI are as follows.
Step 1: DBI selects the ﬁrst element in the index array of p1
as the current node, and set the current level as the
ﬁrst level (Lines 1 to 3).
Step 2: DBI gets the ﬁrst unused element in the next level as
the child node of the current node, and the distance
between the current node and the child node satisﬁes
the gap constraints gap=[a, b] (Lines 5 to 10).
Step 3: If DBI successfully ﬁnds the child node, then the child
node is selected as the current node and the next level
is set as the current level. Otherwise, DBI backtracks
to the parent node of the current node and searches
for the next child node (Lines 11 to 17).
Step 4: Iterate Step 3 until DBI reaches the m-th level or the

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
6
ﬁrst level. If DBI reaches the m-th level, then DBI
ﬁnds an occurrence, i.e., sup(p, s)++ (Lines 19 to 21).
Step 5: DBI selects the next element in the index array of p1
as the current node, and sets the current level as the
ﬁrst level.
Step 6: Iterate Steps 2 to 5 until all elements in the index
array of p1 are checked.
Algorithm 1 DBI
Input: Index arrays arr for sequence s, pattern p, and
gap=[a, b]
Output: sup(p,s)
1: for root ←each element in arr[p[1]] do
2:
CurNode ←occ[1] ←root;
3:
CurLevel ←1;
4:
while CurLevel > 0 && CurLevel < len(p) do
5:
child ←next element in arr[p[CurLevel + 1]];
6:
gap ←child −CurNode −1;
7:
while gap < a do
8:
child ←next element in arr[p[CurLevel + 1]];
9:
gap ←child −CurNode −1;
10:
end while
11:
if a ≤gap && gap ≤b then
12:
CurLevel++;
13:
CurNode ←occ[CurLevel] ←child;
14:
else
15:
CurLevel −−;
16:
CurNode ←occ[CurLevel];
17:
end if
18:
end while
19:
if CurLevel = len(p) then
20:
sup(p, s) + +;
21:
end if
22: end for
23: return sup(p, s)
Theorem 1 The time and space complexities of DBI are both
O(m × n/h), where m, n, and h are the lengths of pattern
and sequence, and the size of P, respectively.
Proof It is easy to know that the size of the index array of
each item is O(n/h), since the length of the sequence is n,
and the size of items is h. To calculate the support, there are
m index arrays. We know that each element in the index arrays
can be used at most once, which means that DBI visits these
elements one by one. Hence, the time and space complexities
of DBI are both O(m × n/h).
B. Preparation stage
In this section, we propose two strategies: ﬁltering strat-
egy and minimum support strategy to avoid some redundant
support calculations. We ﬁrst propose the ﬁltering strategy.
Filtering strategy. If the support of pattern p in sequence
s is zero, then sequence s can be pruned.
Theorem 2 Filtering strategy is correct and complete.
Proof We know that the nonoverlapping SPM satisﬁes anti-
monotonicity [24], which means that the support of a super-
pattern is no greater than that of its sub-pattern. If sup(p, s)
= 0, then we can safely say that sup(q, s) = 0, where pattern q
is a superpattern of pattern p, since the nonoverlapping SPM
satisﬁes the anti-monotonicity condition and sequence s can
therefore be pruned. Hence, the ﬁltering strategy is correct
and complete.
Moreover, based on this anti-monotonicity, we further pro-
pose a minimum support strategy.
Minimum support strategy. If the support of a pattern q
in D is less than minsup, then pattern q and its superpatterns
can be pruned, where minsup = sup(p, D) × mincf.
Theorem 3 Minimum support strategy is correct and com-
plete.
Proof Suppose a rule p →r is a strong co-occurrence rule,
i.e., conf(p →r) = sup(p·r, D)/sup(p, D) ≥mincf. Then,
sup(p·r, D) ≥sup(p, D) × mincf, which means that the
support of pattern p·r is greater than or equal to sup(p, D)×
mincf. Thus, for MCoR mining, users do not need to set
minsup, since it can be automatically calculated based on
mincf. Hence, the minimum support strategy is correct and
complete.
In the preparation stage, we propose the SDB-Filt algorithm
whose pseudocode is shown in Algorithm 2. The main steps
of SDB-Filt are as follows.
Step 1: Select a sequence s in D.
Step 2: SDB-Filt employs the DBI algorithm to calculate
sup(p, s).
Step 3: If sup(p, s) is zero, then sequence s can be shrunk
according to ﬁltering strategy. Otherwise, sequence s
is stored in a shrunk database D1, and the support is
updated, i.e., sup(p, D) gets sup(p, D) + sup(p, s)
(Lines 4 to 7).
Step 4: Iterate Steps 1 to 3 until all sequences are calculated.
Step 5: After getting sup(p, D), SDB-Filt calculates minsup
according to the minimum support strategy (Line 9).
Algorithm 2 SDB-Filt
Input: Sequence index arrays Arr, pattern p, gap=[m, n], and
mincf
Output: minsup and shrunk index arrays Arr1
1: sup(p,D) ←0;
2: for each sequence s in D do
3:
support ←DBI(arrs,p, gap);
4:
if support̸ = 0 then
5:
Store sequence index arrays s in Arr1;
6:
sup(p,D) ←sup(p,D) +support;
7:
end if
8: end for
9: minsup ←sup(p, D) × mincf;
10: return minsup, Arr1

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
7
C. Candidate pattern generation
There are two strategies that are commonly used for gen-
erating candidate patterns: the enumeration tree strategy and
the pattern join strategy. Many nonoverlapping SPM methods
have adopted the pattern join strategy to generate candidate
patterns, such as NOSEP [24] and NTP-Miner [20], since it
can effectively reduce the candidate patterns compared to the
enumeration tree strategy. However, the pattern join strategy
uses all frequent patterns with length m to generate candidate
patterns with length m+1, which means that we need to mine
all of the frequent patterns. Obviously, a brute-force algorithm
is used to mine all frequent patterns and then pattern q and
its superpatterns are found among them. We therefore adopt
the enumeration tree strategy. In the classical enumeration tree
strategy, if pattern q is a frequent pattern, then all patterns q·a
are candidate patterns, where a is any item in sequence s.
To reduce the number of candidate patterns, we ﬁrst propose
the FET strategy and then present the BET strategy.
The FET strategy: If pattern q is a frequent pattern and y
is any frequent item in sequence s, then all patterns q·y are
candidate patterns.
Example 8 demonstrates the advantage of the FET strategy.
Example 8 Suppose we have a sequence s = s1s2s3s4s5s6
s7s8s9s10 s11s12s13s14s15s16 = adbdadcdccabadcd, a pat-
tern q = a[0, 3]d[0, 3]c, and minsup = 3. From se-
quence s, we know that all of the items are {a, b, c, d}.
According
to
the
classical
enumeration
tree
strategy,
there are four candidate patterns based on pattern q:
a[0, 3]d[0, 3]c[0, 3]a, a[0, 3]d[0, 3]c[0, 3]b, a[0, 3]d[0, 3]c[0, 3]c,
and a[0, 3]d[0, 3]c[0, 3]d. However, we know that the sup-
ports of patterns a, b, c, and d are four, two, four, and
six, respectively. Thus, the frequent items are {a, c, d}, since
minsup = 3. Hence, according to FET, there are only three
candidate patterns based on pattern q: a[0, 3]d[0, 3]c[0, 3]a,
a[0, 3]d[0, 3]c[0, 3]c, and a[0, 3]d[0, 3]c[0, 3]d. This example
shows that the FET strategy has better performance than the
classical enumeration tree strategy.
To further reduce the number of candidate patterns, inspired
by the pattern join strategy, we propose the BET strategy as
follows.
The BET strategy: We discover all frequent patterns with
length two and store them in set F2. If x is the last item of q,
and pattern xy is a frequent pattern with length two, i.e. xy
∈F2, then pattern r = q·y is a candidate pattern.
Example 9 illustrates the advantage of the BET strategy.
Example 9 We use the same scenario as in Example 8.
We know that the frequent items are {a, c, d}. We can
then generate nine candidate patterns with length two {aa,
ac, ad, ca, cc, cd, da, dc, dd} using the pattern join
strategy. It is then easy to see that the frequent candi-
date patterns with length two are <ad>, <ca>, <cd>,
<dc>, and <dd>. From Example 8, we see that there are
only three candidate patterns based on pattern q using the
FET strategy: a[0, 3]d[0, 3]c[0, 3]a, a[0, 3]d[0, 3]c[0, 3]c, and
a[0, 3]d[0, 3]c[0, 3]d. Pattern a[0, 3]d[0, 3]c[0, 3]a cannot be
pruned by the BET strategy, since pattern c[0, 3]a is a frequent
pattern with length two, while pattern a[0, 3]d[0, 3]c[0, 3]c
can be pruned by the BET strategy, since pattern c[0, 3]c
is not a frequent pattern with length two. Similarly, pat-
tern a[0, 3]d[0, 3]c[0, 3]d cannot be pruned. Thus, only two
candidate patterns are generated by the BET strategy. This
example demonstrates that the BET strategy outperforms the
FET strategy. A comparison of the candidate patterns is given
in Fig. 5.
Theorem 4 Both FET and BET strategies are correct and
complete.
Proof As mentioned above, the nonoverlapping SPM satisﬁes
anti-monotonicity [24]. Thus, the support of a superpattern is
no greater than that of its sub-pattern. Therefore, if item y is
infrequent, then the pattern q·y is infrequent. Hence, the FET
strategy is correct and complete. Similarly, we know that the
BET strategy is also correct and complete.
D. Screening strategy
Obviously, it is easy for us to obtain strong co-occurrence
sequential rules based on the frequent co-occurrence patterns.
Moreover, we can discover the maximal strong co-occurrence
rules based on the maximal co-occurrence patterns. The sim-
plest method is to mine all frequent co-occurrence patterns,
and then discover the maximal co-occurrence patterns among
them. This method can be seen as a brute-force method. To
improve the performance, we propose a screening strategy to
discover the maximal co-occurrence patterns. The principle is
as follows.
Screening strategy: Suppose we have a pattern q. If one
of its superpatterns r is a frequent co-occurrence pattern, then
pattern q is not a maximal co-occurrence pattern; otherwise,
q is a maximal co-occurrence pattern.
Theorem 5 Screening strategy is correct and complete.
Proof According
to
the
deﬁnition
of
the
maximal
co-
occurrence pattern, for a pattern q, if one of its superpattern
r is a frequent co-occurrence pattern, then pattern q is
not a maximal co-occurrence pattern; otherwise, pattern q
is a maximal co-occurrence pattern. The screening strategy
discovers the maximal co-occurrence patterns based on the
deﬁnition of the maximal co-occurrence pattern. Hence, the
screening strategy is correct and complete.
We store all frequent co-occurrence patterns in a stack.
Suppose pattern q is the top element of the stack. We generate
the candidate patterns based on pattern q using the BET
strategy, and then we use the DBI algorithm to calculate the
supports of the candidate patterns. If candidate pattern r is a
frequent co-occurrence pattern, then we store pattern r in the
stack; otherwise, pattern q is a maximal co-occurrence pattern
and is stored in the set Mp. We check all patterns in the stack
until it is empty. Example 10 illustrates the principle of the
screening strategy.
Example 10 Suppose we have a sequence s = s1s2s3s4
s5s6s7s8s9s10s11s12s13s14s15s16 = adbdadcdccabadcd, p =
a[0, 3]d, and minsup = 3. Suppose the top element of

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
8
adc
3
adca
2
adcb
1
adcc
1
adcd
3



adcda
2
adcdb
0
adcdc
1
adcdd
1




(a) Enumeration tree of all items
adc
3
adca
2
adcc
1
adcd
3


adcda
2
adcdc
1
adcdd
1



(b) Enumeration tree of FET
adc
3
adca
2
adcd
3

adcdc
1
adcdd
1


(c) Enumeration tree of BET
Fig. 5: Comparison of candidate patterns generated by different strategies. Eight candidate patterns are generated by using all
terms, while six and four candidate patterns are generated by using the FET and BET strategies, respectively.
the stack is pattern q = a[0, 3]d[0, 3]c. According to the
BET strategy, there are two candidate patterns based on
pattern q: a[0, 3]d[0, 3]c[0, 3]a and a[0, 3]d[0, 3]c[0, 3]d. We
know that the support of pattern a[0, 3]d[0, 3]c[0, 3]a is
two. This means that a[0, 3]d[0, 3]c[0, 3]a cannot be stored
in the stack, since it is not a frequent co-occurrence
pattern. Moreover, we know that the support of pattern
a[0, 3]d[0, 3]c[0, 3]d is three. The pattern a[0, 3]d[0, 3]c[0, 3]d
is therefore stored in the stack, since it is a frequent co-
occurrence pattern. Meanwhile, pattern q is not a max-
imal co-occurrence pattern, since it has a frequent co-
occurrence superpattern a[0, 3]d[0, 3]c[0, 3]d. Now, the top
element of the stack is pattern a[0, 3]d[0, 3]c[0, 3]d which
has two candidate patterns according to the BET strat-
egy: a[0, 3]d[0, 3]c[0, 3]d[0, 3]c and a[0, 3]d[0, 3]c[0, 3]d[0, 3]d.
It
is
then
easy
to
see
that
the
supports
of
patterns
a[0, 3]d[0, 3]c[0, 3]d[0, 3]c and a[0, 3]d[0, 3]c[0, 3]d[0, 3]d are
both one. Hence, the pattern a[0, 3]d[0, 3]c[0, 3]d is a maximal
co-occurrence pattern, since all its superpatterns are not fre-
quent co-occurrence patterns. The advantage of the screening
strategy is that the maximal co-occurrence patterns can be
discovered without a brute-force search process.
E. MCoR-Miner
We introduce the MCoR-Miner algorithm whose pseu-
docode is shown in Algorithm 3. MCoR-Miner has the fol-
lowing main steps.
Step 1: Use SDB-Filt to calculate the support of pattern p,
i.e., sup(p, D); prune the sequence s whose support
is zero; and calculate minsup = sup(p, D) × mincf
(Lines 1 to 2).
Step 2: Traverse D1 to ﬁnd all frequent items and store them
in F1 (Line 3).
Step 3: Generate candidate pattern set C2 using the pattern
join strategy (Line 4).
Step 4: Calculate the support of each pattern in set C2 and
store the frequent patterns in F2 (Line 5).
Step 5: Store pattern p in stack T (Line 6).
Step 6: Obtain the top element pattern q of stack T (Line 8).
Step 7: Generate all candidate co-occurrence patterns of pat-
tern q using frequent items F1 and store them in set
C (Lines 10 to 13).
Step 8: Use BET to prune candidate patterns (Line 14).
Step 9: Use the DBI algorithm to calculate the support of each
pattern r in C (Line 15).
Step 10: If pattern r is a frequent co-occurrence pattern, then
pattern r is stored in stack T (Lines 16 to 19).
Step 11: If all patterns r are not frequent co-occurrence pat-
terns, then pattern q is a maximal co-occurrence
pattern and is stored in set Mp (Lines 22 to 24).
Step 12: Iterate Steps 6 to 11, until the stack is empty.
Step 13: Generate maximal strong rules based on Mp.
Algorithm 3 MCoR-Miner
Input: Sequence database D, minimum conﬁdence mincf, gap =
[a, b], preﬁx pattern p
Output: Maximal co-occurrence sequential rule set Mr
1: Scan D to obtain index arrays Arr;
//Use the ﬁltering strategy to shrink dataset, and the minimum
support strategy to calculate minsup
2: minsup,Arr1 ←SDB-Filt(Arr,p,gap, mincf);
3: Scan Arr1 to ﬁnd and store frequent items in F1;
4: Generate candidate patterns with length two and store them in
C2;
5: Discover frequent patterns with length two and store them in F2;
6: Store pattern p in stack T;
7: while not empty T do
8:
q ←T.pop();
9:
ﬂag ←True;
//Use the FET strategy to prune candidate patterns
10:
for each item y in F1 do
11:
C ←C ∪q·y;
12:
x ←the last item of q;
13:
r ←q·y;
//Use the BET strategy to prune candidate patterns
14:
if pattern x·y in F2 then
15:
support ←DBI(Arr1,r, gap);
16:
if support ≥minsup then
17:
T.push (r);
18:
ﬂag ←False;
19:
end if
20:
end if
21:
end for
//Use the screening strategy to mine the patterns
22:
if ﬂag=True then
23:
Mp ←Mp ∪q;
24:
end if
25: end while
26: Mr ←Generate maximal strong rules based on Mp;
27: return Mr;
Theorem 6 The space and time complexities of MCoR-Miner
are O(N) and O(t×M ×N/h), where t, M, N, and h are the
number of candidate patterns, the maximal length of candidate
patterns, the total length of shrunk sequence database, and the
size of P, respectively.

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
9
Proof The time and space complexities of scanning the se-
quence database D to obtain its index arrays are O(N).
It is easy to know that the space complexity of SDB-Filt is
O(N). The time complexity of SDB-Filt is O(m × N/h),
since the time complexity of DBI is O(m × n/h) and SDB-
Filt checks all sequences, where N = Pk
i=1 ni. The space
complexity of F1 is O(h), since the size of all frequent items
is no greater than all items. Thus, the time complexity of Line
3 is O(h). The time and space complexities of Line 4 are
O(h2). The time complexity of Line 5 is O(h2 × 2 × N/h),
since there are O(h2) candidate patterns, and the length of
each candidate pattern is two. The space complexity of storing
frequent patterns with length two is O(h2×2). Suppose MCoR-
Miner checks t candidate patterns and the maximal length
of candidate patterns is M. The space complexity of storing
these candidate patterns is O(t×M), and the time complexity
of calculating the supports of these candidate patterns is
O(t×M ×N/h). Hence, the space complexity of MCoR-Miner
is O(N + N + h + h2 + k × M) =O(N), since generally h,
h2, k, M, and k × M are much smaller than N. The time
complexity of MCoR-Miner is O(N + m × N/h + h2 + h2 ×
2 × N/h + t × M × N/h)=O(t × M × N/h), since m and
2 × h2 are much smaller than M and t, respectively.
V. EXPERIMENTAL RESULTS AND ANALYSIS
To validate the performance of MCoR-Miner, we consider
the following eight research questions (RQs).
RQ1: Does MCoR-Miner yield better performance than other
state-of-the-art algorithms in terms of mining co-
occurrence patterns?
RQ2: Does DBI give better performance than other state-of-
the-art algorithms in terms of support calculation?
RQ3: Can the ﬁltering strategy reduce the number of support
calculations in MCoR-Miner?
RQ4: Can the FET and BET strategies reduce the number of
candidate patterns, and when can BET achieve better
performance?
RQ5: What is the effect of the screening strategy?
RQ6: Does MCoR-Miner have better scalability?
RQ7: How do different parameters affect the performance of
MCoR-Miner?
RQ8: What is the performance of MCoR-Miner for recom-
mendation tasks?
To answer RQ1, we select NOSEP, DFOM-All, and DBI-
All to verify the performance of MCoR-Miner on the problem
of co-occurrence pattern mining. In response to RQ2, we pro-
pose NETGAP-MCoR, Netback-MCoR, and DFOM-MCoR to
explore the effect of DBI, as described in Section V-B. To ad-
dress RQ3, we propose MCoR-NoFilt to investigate the effect
of the ﬁltering strategy, as presented in Section V-B. To answer
RQ4, we apply two algorithms, MCoR-AET and MCoR-
FET, to verify the effects of the FET and BET strategies, as
described in Section V-B. To solve RQ5, we propose MCoR-
NoScr to validate the effect of the screening strategy in Section
V-B. To answer RQ6, we explore the scalability of MCoR-
Miner, as presented in Section V-C. To address RQ7, we
explore the effects of different gap constraints and minimum
conﬁdence thresholds on the running time of MCoR-Miner in
Section V-D. To answer RQ8, we report the performances of
MCoR-Miner in terms of conﬁdence, recall, and F1-score in
section V-E. All experiments were conducted on a computer
with an Intel(R) Core(TM)i7-10870H processor, 32 GB of
memory, the Windows 10 operating system, and VS2022 as
the experimental environment. All algorithms and datasets
can be downloaded from https://github.com/wuc567/Pattern-
Mining/tree/master/MCoR-Miner.
A. Benchmark datasets and baseline algorithms
We used eight datasets shown in Table II as test sequences.
TABLE II: Description of datasets
Dataset
Type
P
Number of sequence
Length
GAMESALE1
Commerce
12
39
16,446
BABYSALE2
Commerce
6
949
29,971
TRANSACTION3
Commerce
31
4,661
32,851
MOVIE4
Commerce
20
4,988
741,132
MSNBC5
Clickstream
17
200,000
948,674
SARS6
Bio-sequence
4
426
29,751
SARS-Cov-27
Bio-sequence
4
428
29,903
HIV8
Bio-sequence
20
1
10,000
1: GAMESALE is a dataset of video game sales with ratings, which can be
downloaded from http://www.kaggle.com/rush4ratio/video-game-sales-with-ratings.
2: BABYSALE is a sales dataset for infant products, which can be downloaded from
https://tianchi.aliyun.com/dataset/dataDetail?dataId=45.
3: TRANSACTION is a dataset of sales behavior, which can be downloaded from
https://www.kaggle.com/retailrocket/ecommerce-dataset.
4: MOVIE contains users’ movie ratings, which can be downloaded from
http://grouplens.org/datasets/.
5: MSNBC is a clickstream sequence database, which can be downloaded from
http://www.philippe-fournier-viger.com/spmf/index.php?link=datasets.php.
6: SARS contains the gene sequences of the virus that caused severe acute respiratory
syndrome in 2003, and can be downloaded from
https://www.ncbi.nlm.nih.gov/nuccore/30271926.
7: SARS-COV-2 contains the gene sequences of the virus causing COVID-19, and can
be downloaded from https://www.ncbi.nlm.nih.gov/nuccore/MN908947.
8: HIV can be downloaded from
http://archive.ics.uci.edu/ml/machine-learning-databases/00330/.
To report the performance of the MCoR-Miner algorithm,
four experiments were designed, and nine competitive algo-
rithms were selected.
1. NOSEP [24], DFOM-All [56], and DBI-All: To verify
that it is necessary to use a special algorithm to discover
frequent co-occurrence patterns, we selected two state-of-
the-art algorithms: NOSEP [24] and DFOM [56], where
NOSEP can mine all frequent patterns. DFOM-All and
DBI-All can also discover all frequent patterns, which
employed the DFOM and DBI algorithms to calculate the
support, respectively. We can then ﬁnd the frequent co-
occurrence patterns among all frequent patterns. Based on
the above analysis, we know that the time complexities of
NOSEP, DFOM-All, and DBI-All are O(ta×M ×M ×N ×
w), O(ta × M × N), and O(ta × M × N/h), respectively,
where ta (ta ≥t) and w are the number of all frequent
patterns and b −a + 1.
2. NETGAP-MCoR [24], Netback-MCoR [41], and DFOM-
MCoR [56]: To explore the running performance of DBI,
three competitive algorithms were proposed: NETGAP-
MCoR, Netback-MCoR, and DFOM-MCoR. The three
competitive algorithms employed three state-of-the-art al-
gorithms NETGAP [24], Netback [41], and DFOM [56] to

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
10
calculate the support, respectively. Other strategies, such
as ﬁltering, FET, BET, and screening, are the same as
MCoR-Miner. Based on the above analysis, we know
that the time complexities of NETGAP-MCoR, Netback-
MCoR, and DFOM-MCoR are O(t × M × M × N × w),
O(t × M × N × w), and O(t × M × N), respectively.
3. MCoR-NoFilt: To demonstrate the performance of the
ﬁltering strategy, MCoR-NoFilt was proposed, which did
not employ the ﬁltering strategy but is otherwise the same
as MCoR-Miner. The time complexity of MCoR-NoFilt
is O(t × M × No/h), while that of MCoR-Miner is
O(t × M × N/h), where No and N (No ≥N) are the
lengths of the original and shrunk sequence databases,
respectively.
4. MCoR-AET and MCoR-FET: To investigate the perfor-
mance of the BET strategy, we proposed MCoR-AET and
MCoR-FET, which used all items and frequent items to
generate candidate patterns, respectively. The time com-
plexities of MCoR-AET and MCoR-FET are O(ta × M ×
N/h) and O(tf×M×N/h), respectively, where ta (ta ≥t)
and tf are the numbers of candidate patterns. Note that tf
can be smaller than t, since MCoR-Miner needs to calculate
O(h2) candidate patterns with length two, and in some
cases, it cannot prune O(h2) candidate patterns using the
BET strategy.
5. MCoR-NoScr: To assess the performance of the screening
strategy, we used MCoR-NoScr, which did not include the
screening strategy. The time complexity of MCoR-NoScr
is almost the same as that of MCoR-Miner.
6. CoP-Miner: To verify the recommendation performance,
CoP-Miner was proposed, which can mine all frequent
patterns with the predeﬁned preﬁx pattern, and employed
the same strategies as MCoR-Miner. The time complexity
of CoP-Miner is O(tc × M × N/h), where tc (tc ≥t) is
the number of all frequent patterns.
B. Efﬁciency
To determine the necessity of co-occurrence pattern min-
ing, we selected NOSEP, DFOM-All, and DBI-All as the
competitive algorithms. Moreover, to verify the performance
of the DBI algorithm and the ﬁltering, BET, and screening
strategies, we employed NETGAP-MCoR, Netback-MCoR,
DFOM-MCoR, MCoR-NoFilt, MCoR-AET, MCoR-FET, and
MCoR-NoScr as the competitive algorithms. Eight datasets
were selected. Since the characteristics of these datasets are
signiﬁcantly different, for example in terms of different num-
ber of characters and sequences, we set different parameters
as shown in Table III. Comparisons of the running time and
memory usage are shown in Tables IV and V, respectively.
The main indicators of mining results, such as the number of
CoRs and MCoRs are shown in Table VI.
These results give rise to the following observations.
1. Maximal co-occurrence rule mining can effectively reduce
the number of rules. From Table VI, on BABYSALE, there
are 98 co-occurrence rules, while there are 47 maximal co-
occurrence rules. The same phenomenon can be found on
all the other datasets. This is because as shown in Example
TABLE III: Parameters
Dataset
Preﬁx
Gap constraint
Minimum conﬁdence
GAMESALE
d
[0,8]
0.3
BABYSALE
a
[0,8]
0.2
TRANSACTION
z
[0,3]
0.3
MOVIE
d
[0,3]
0.5
MSNBC
e
[0,8]
0.3
SARS
C
[0,3]
0.6
SARS-Cov-2
C
[0,3]
0.6
HIV
C
[0,3]
0.3
5, both ad →c and ad →cd are rules, and ad →cd is
a maximal rule, while rule ad →c is not a maximal rule.
This means that MCoR mining can effectively reduce the
number of rules.
2. It is necessary to explore the co-occurrence pattern mining,
since MCoR-Miner is signiﬁcantly faster than NOSEP [24]
and DFOM-All [56], and in particular is faster than DBI-
All. For example, on GAMESALE, NOSEP and DFOM-
All take 47.95s and 2.47s, respectively, while MCoR-Miner
takes 0.42s, meaning that MCoR-Miner is about 100 times
faster than NOSEP, and six times faster than DFOM-
All. Moreover, DBI-all takes 0.92s, which is slower than
MCoR-Miner. These phenomena can be found on the other
datasets. The reasons for this are twofold. Firstly, MCoR-
Miner employs a more efﬁcient algorithm, called DBI, to
calculate the support compared to NOSEP and DFOM-
All. As mentioned in Section IV-A, we know that NOSEP
has to create a whole Nettree to calculate the support.
However, a Nettree contains many redundant nodes and
parent-child relationships. Although DFOM can overcome
this disadvantage, it uses a sequential searching strategy to
ﬁnd feasible child nodes of the current node, which is an
inefﬁcient method. In contrast, DBI is equipped with an in-
dexing mechanism to avoid sequential searching, meaning
that MCoR-Miner is signiﬁcantly faster than NOSEP and
DFOM-All. Secondly, although both DBI-All and MCoR-
Miner employ DBI to calculate the support, DBI-All runs
slower than MCoR-Miner. The reason for this is that the
three algorithms have to discover all of the patterns, and
since many of these are not targeted patterns, all three
algorithms have to ﬁlter out these useless patterns. The
experimental results therefore indicate that it is necessary
to explore the co-occurrence pattern mining.
3. MCoR-Miner runs faster than NETGAP-MCoR, Netback-
MCoR, and DFOM-MCoR on all datasets, which in-
dicates the efﬁciency of DBI. For example, from Ta-
ble IV, we can see that on BABYSALE, MCoR-Miner
takes 5.36s, while NETGAP-MCoR, Netback-MCoR, and
DFOM-MCoR take 113.00s, 112.17s, and 11.34s, re-
spectively. Thus, MCoR-Miner is obviously faster than
NETGAP-MCoR and Netback-MCoR, and is about twice
as fast as DFOM-MCoR. The reasons are as follows.
The four algorithms adopt different methods to calculate
the support. NETGAP-MCoR and Netback-MCoR have
to create the whole Nettree which contain many useless
nodes and parent-child relationships. Therefore, their time
complexities are higher than those of DFOM-MCoR and
MCoR-Miner. Although DFOM-MCoR does not create the

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
11
TABLE IV: Comparison of running time (s)
GAMESALE
BABYSALE
TRANSACTION
MOVIE
MSNBC
SARS
SARS-Cov-2
HIV
NOSEP
47.95
152.55
10.20
77.66
-
95.47
133.12
211.98
DFOM-All
2.47
12.33
2.11
5.78
-
9.07
10.00
84.28
DBI-All
0.92
8.38
0.45
4.13
15.72
6.56
8.28
1.48
NetGAP-MCoR
16.17
113.00
2.80
50.16
587.91
2.80
2.75
7.74
Netback-MCoR
15.89
112.17
2.70
46.53
582.67
2.58
2.60
7.78
DFOM-MCoR
1.88
11.34
0.70
5.25
97.38
3.60
3.13
5.11
MCoR-NoFilt
0.66
5.53
1.00
4.08
215.83
2.81
2.97
0.13
MCoR-AET
0.70
7.14
3.88
16.22
25.92
1.56
1.42
0.02
MCoR-FET
0.59
5.94
0.47
5.25
24.17
1.55
1.41
0.02
MCoR-NoScr
0.63
5.80
0.48
4.11
16.52
3.13
2.97
0.13
MCoR-Miner
0.42
5.36
0.38
4.00
16.08
2.34
2.66
0.11
TABLE V: Comparison of memory usage (Mb)
GAMESALE
BABYSALE
TRANSACTION
MOVIE
MSNBC
SARS
SARS-Cov-2
HIV
NOSEP
32.1
203.3
908.1
1092.5
1183.2
106.2
106.5
19.4
DFOM-All
22.0
195.7
903.7
971.2
1188.0
95.1
95.4
20.2
DBI-All
14.4
16.9
21.6
38.5
230.7
17.6
17.6
14.1
NetGAP-MCoR
23.7
25.8
24.8
163.1
404.9
25.2
25.2
19.6
Netback-MCoR
26.7
18.8
35.7
187.2
263.9
27.8
27.4
20.3
DFOM-MCoR
15.9
18.7
22.8
40.0
226.0
15.8
15.9
15.9
MCoR-NoFilt
16.7
19.6
25.0
41.1
445.8
17.6
24.3
23.0
MCoR-AET
16.0
18.8
24.5
43.9
232.4
17.2
17.2
16.0
MCoR-FET
24.0
26.4
30.5
47.8
238.80
14.9
14.8
13.4
MCoR-NoScr
20.8
32.1
30.3
47.4
239.0
24.3
16.9
15.8
MCoR-Miner
13.6
16.5
20.8
38.0
228.8
17.4
26.6
21.5
TABLE VI: Main indicators of mining results
GAMESALE
BABYSALE
TRANSACTION
MOVIE
MSNBC
SARS
SARS-Cov-2
HIV
Number of CoRs
36
98
4
4
12
2
2
3
Number of MCoRs
20
47
2
1
1
2
2
3
Number of ﬁltered sequences
642
1,350
104,787
288
49,163,184
28
28
0
Number of non-ﬁltered sequences
11,877
425,700
21,060
79,520
1,236,816
11,900
11,956
472
Number of all items
12
6
30
20
17
4
4
20
Number of frequent items
10
5
4
3
15
4
4
20
Number of BET items
27
15
4
2
1
13
13
286
Number of BET items under non-ﬁltered
27
15
6
2
24
13
13
286
Number of candidate patterns pruned by BET
149
70
9
8
168
0
0
8
Number of candidate patterns nonpruned by BET
221
425
11
7
27
12
12
72
whole Nettree, DFOM adopts a sequential searching strat-
egy to ﬁnd feasible child nodes of the current node, which
is inefﬁcient. Hence, MCoR-Miner outperforms NETGAP-
MCoR, Netback-MCoR, and DFOM-MCoR.
4. MCoR-Miner runs faster than MCoR-NoFilt on all datasets,
which indicates the effectiveness of the ﬁltering strategy.
According to Table IV, on BABYSALE, MCoR-Miner
takes 5.36s, while MCoR-NoFilt takes 5.53s. This phe-
nomenon can also be found on all the other datasets.
The reason for this is that some useless sequences are
ﬁltered out. For example, from Table VI, we see that 1350
sequences are ﬁltered out when minimg all rules, which
means that it is not necessary to calculate the support for
these 1350 sequences, and hence the running performance
is improved. The ﬁltering strategy can reduce not only
the number of sequences, but also the number of frequent
patterns with length two, which means that it can reduce the
number of candidate patterns with length more than two.
For example, on the TRANSACTION dataset, there are
only four patterns under the ﬁltering strategy, but six under
the non-ﬁltering strategy, meaning that more time is needed
to discover all the rules. All in all, the ﬁltering strategy is
effective, and MCoR-Miner outperforms MCoR-NoFilt.
5. MCoR-Miner runs faster than MCoR-AET and MCoR-FET
on GAMESALE, BABYSALE, TRANSACTION, MOVIE,
and MSNBC, but slower than MCoR-AET and MCoR-FET
on SARS, SARS-Cov-2, and HIV, which indicates that the
BET strategy has certain advantages and limitations. We
choose two typical datasets to illustrate the reason for this.
1) Taking GAMESALE as an example, we see that there
are 12 items and 10 frequent items. Thus, there are 10×
10=100 candidate patterns with length two. After checking
these 100 candidate patterns, we have 27 frequent patterns
with length two. Using these 27 patterns, 149 candidate
patterns are pruned by the BET strategy, and 221 candidate
patterns are not according to Table VI. Thus, by adding
100 times support calculations for candidate patterns with
length two, MCoR-Miner can avoid 149 times support
calculations for candidate patterns. Hence, MCoR-Miner
can improve the running performance on GAMESALE. 2)
Taking HIV as another example, we see that there are 20
frequent items. Thus, there are 20×20=400 candidate pat-
terns with length two. After checking these 400 candidate
patterns, we have 286 frequent patterns with length two.
Of these 286 patterns, only eight candidate patterns are
pruned by the BET strategy, and 72 are not according to
Table VI. Thus, by adding 400 times support calculations
for candidate patterns with length two, MCoR-Miner can

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
12
MCoR-NoFilt
215.83
405.34
607.64
817.94
981.25
1265.83
MCoR-AET
25.92
50.86
73.44
103.69
129.19
155.88
MCoR-FET
24.17
42.73
68.39
95.00
111.48
141.55
MCoR-NoScr
16.52
31.91
46.61
67.36
77.39
95.81
MCoR-Miner
16.08
31.55
46.42
65.53
73.28
92.52
MSNBC1
MSNBC2
MSNBC3
MSNBC4
MSNBC5
MSNBC6
0.00
300.00
600.00
900.00
1200.00
1500.00
Running time (s)
Fig. 6: Comparison of running time with different dataset sizes
(s)
avoid only eight times support calculations for candidate
patterns. The running time is therefore increased. Thus,
the experimental results show that the BET strategy has
some limitations on the Bio-sequence datasets. Hence, our
methods, MCoR-Miner or MCoR-FET, can obtain better
performance in all cases.
6. MCoR-Miner runs faster than MCoR-NoScr on all datasets,
which indicates the effectiveness of the screening strat-
egy. For example, on TRANSACTION, MCoR-Miner re-
quires 0.38s, while MCoR-NoScr requires 0.48s. This
phenomenon can be found on all the other datasets. The
reason for this is as follows. The difference between the
two algorithms is that MCoR-Miner is equipped with the
screening strategy, while MCoR-NoScr is not. Thus, the
results indicate that the screening strategy is an effective
way to reduce the running time, and hence MCoR-Miner
outperforms MCoR-NoScr.
7. From Table V, we notice that MCoR-Miner consumes less
memory when mining patterns. For example, on GAME-
SALE, MCoR-Miner consumes 13.6Mb memory, which is
less than the other competitive algorithms. This result can
be found on most of the datasets. In particular, MCoR-
Miner consumes less memory than NOSEP and DFOM-All
algorithms. This is because in order to calculate the support,
NOSEP needs to create a whole Nettree, which contains
a lot of useless information. Although DFOM overcomes
this drawback, it uses the sequential searching strategy to
ﬁnd feasible child nodes of the current node, which is not
efﬁcient. However, MCoR-Miner uses the DBI algorithm,
which is equipped with the indexing mechanism to avoid
sequential searching. Hence, MCoR-Miner consumes less
memory.
In summary, MCoR-Miner achieves better running per-
formance and memory consumption performance than other
competitive algorithms.
C. Scalability
To validate the scalability of MCoR-Miner, we selected
MSNBC as the experimental dataset, since it was the largest
dataset in Table II. Moreover, we created MSNBC1, MSNBC2,
MSNBC3, MSNBC4, MSNBC5, and MSNBC6, which were
one, two, three, four, ﬁve, and six times the size of MSNBC,
respectively. We set gap = [0, 8], mincf = 0.3, and the preﬁx
pattern was e. Comparisons of running time and memory usage
are shown in Figs. 6 and 7, respectively.
The results give rise to the following observations.
MCoR-NoFilt
445.8 
1006.5 
1503.9 
2021.4 
2479.9 
3009.4 
MCoR-AET
232.4 
462.4 
681.4 
967.1 
1091.0 
1531.0 
MCoR-FET
238.8 
462.3 
697.6 
961.7 
1087.7 
1359.6 
MCoR-NoScr
239.0 
454.7 
677.9 
1081.7 
1089.7 
1532.2 
MCoR-Miner
228.8 
457.0 
697.3 
935.0 
1086.5 
1358.8 
MSNBC1
MSNBC2
MSNBC3
MSNBC4
MSNBC5
MSNBC6
0.0 
500.0 
1000.0 
1500.0 
2000.0 
2500.0 
3000.0 
3500.0 
Memory usage (Mb)
Fig. 7: Comparison of memory usage with different dataset
sizes (Mb)
MCoR-NoFilt
0.19
0.31
0.34
0.66
1.44
2.80
MCoR-AET
0.25
0.41
0.64
0.70
2.30
5.95
MCoR-FET
0.20
0.34
0.52
0.59
2.06
4.31
MCoR-NoScr
0.23
0.25
0.47
0.63
1.38
3.39
MCoR-Miner
0.17
0.23
0.31
0.42
1.28
2.66
gap= [0,5]
gap= [0,6]
gap= [0,7]
gap= [0,8]
gap= [0,9]
gap= [0,10]
0.00
1.50
3.00
4.50
6.00
Running time (s)
Fig. 8: Comparison of running time with different gap (s)
From Figs. 6 and 7, we know that the running time and
the memory usage of MCoR-Miner both show linear growth
with the increase of the size of the dataset. For example,
the size of MSNBC6 is six times that of MSNBC1. MCoR-
Miner takes 16.08s on MSNBC1, and 92.52s on MSNBC6,
giving 92.52/16.08=5.75. The memory usage of MCoR-Miner
is 1358.8Mb on MSNBC6, and 228.8Mb on MSNBC1, giving
1358.8/228.8 = 5.94. Thus, the growth rates of the running
time and memory usage are slightly lower than the increase
of the dataset size. This phenomenon can be found on all the
other datasets. These results indicate that the time and space
complexities of MCoR-Miner are positively correlated with the
dataset size. More importantly, we can see that MCoR-Miner
is more than 10 times faster than MCoR-NoFilt, and that the
memory usage of MCoR-NoFilt is more than twice that of
MCoR-Miner. We therefore draw the conclusion that MCoR-
Miner has strong scalability, since the mining performance
does not degrade with the increase of the dataset size.
D. Inﬂuence of parameters
We assessed the effects of different gap constraints and
minimum conﬁdence on the number of rules and running time.
1) Inﬂuence of different gap constraints: To analyze the
inﬂuence of different gap constraints on the number of rules
and running time of MCoR-Miner, we selected GAMESALE
as the experimental dataset, and MCoR-NoFilt, MCoR-AET,
MCoR-FET, and MCoR-NoScr as the competitive algorithms.
The preﬁx pattern was d and the minimum conﬁdence was 0.3.
The gap constraints were [0,5], [0,6], [0,7], [0,8], [0,9], and
[0,10]. A comparison of the running time is shown in Fig. 8
and the numbers of mined CoRs and MCoRs mined are shown
in Table VII.
These results give rise to the following observations.
With the increase of the gap, the running time and number of
CoRs and MCoRs are increased. For example, when gap=[0,8],

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
13
TABLE VII:
Comparison of numbers of CoRs and MCoRs
with different gaps
gap=
gap=
gap=
gap=
gap=
gap=
[0,5]
[0,6]
[0,7]
[0,8]
[0,9]
[0,10]
Number of CoRs
8
14
20
36
63
134
Number of MCoRs
6
10
12
20
34
63
MCoR-NoFilt
18.50
4.81
2.89
1.03
0.42
0.34
MCoR-AET
19.72
5.77
3.47
1.86
0.94
0.56
MCoR-FET
19.81
5.77
3.25
1.66
0.78
0.44
MCoR-NoScr
19.19
4.95
3.14
0.86
0.44
0.36
MCoR-Miner
18.45
4.69
2.38
0.74
0.41
0.30
mincf =0.16
mincf =0.20
mincf =0.24
mincf =0.28
mincf =0.32
mincf =0.36
0.00
5.00
10.00
15.00
20.00
Running time (s)
Fig. 9: Comparison of running time with different mincf (s)
MCoR-Miner takes 0.17s, and mines eight CoRs and six
MCoRs, whereas when gap=[0,8], MCoR-Miner takes 0.42s,
and mines 36 CoRs and 20 MCoRs. This phenomenon can be
found on all the other algorithms. The reason is as follows. We
know that with the increase of the gap, the support of a pattern
increases. Thus, more patterns can be found, and each co-
occurrence pattern corresponds to a CoR. Hence, more CoRs
and MCoRs can be found and the running time also increases.
MCoR-Miner outperforms the other competitive algorithms for
any gap constraints.
2) Inﬂuence of different minimum conﬁdence: To report the
inﬂuence of different minimum conﬁdences on the number of
rules and running time of MCoR-Miner, we selected GAME-
SALE as the experimental dataset, and MCoR-NoFilt, MCoR-
AET, MCoR-FET, and MCoR-NoScr as the competitive algo-
rithms. The preﬁx pattern was d and the gap constraints was
[0,8]. We set the minimum conﬁdence to 0.16, 0.20, 0.24, 0.28,
0.32, and 0.36. A comparison of the running time is shown in
Fig. 9 and the numbers of CoRs and MCoRs mined are shown
in Table VIII.
The results give rise to the following observations.
With the increase of minimum conﬁdence, the running
time and numbers of CoRs and MCoRs are decreased. For
example, when mincf = 0.16, MCoR-Miner takes 18.45s, and
mines 796 CoRs and 431 MCoRs, whereas when mincf =
0.36, MCoR-Miner takes 0.30s, and mines 17 CoRs and nine
MCoRs. This phenomenon can be found on the other algo-
rithms. The reason is as follows. For a certain preﬁx pattern,
the minimum support threshold increases with the increase of
mincf. Thus, few patterns can be frequent patterns, and each
co-occurrence pattern corresponds to a CoR. Hence, fewer
TABLE VIII: Comparison of numbers of CoRs and MCoRs
with different mincf
mincf
mincf
mincf
mincf
mincf
mincf
=0.16
=0.20
=0.24
=0.28
=0.32
=0.36
Number of CoRs
796
246
100
49
27
17
Number of MCoRs
431
134
53
25
15
9
TABLE IX: Parameter settings
Dataset
Preﬁx
Gap
mincf for
minsup for
constraint
MCoR-Miner
CoP-Miner
GAMESALE
d
[0,3]
0.39
400
BABYSALE
fc
[0,3]
0.40
300
TRANSACTION
xz
[0,3]
0.40
100
MOVIE
dee
[0,3]
0.40
150000
CoRs and MCoRs can be found and the running time also
decreases. MCoR-Miner outperforms the other competitive
algorithms for any minimum conﬁdence.
E. MCoR-Miner for recommendation
The recommendation task is to provide the recommendation
schemes based on the discovered potential rules with the same
given antecedent p. To investigate the recommendation per-
formance of MCoR-Miner, we compare the recommendation
performance of co-occurrence pattern mining and rule min-
ing. Therefore, we employed CoP-Miner as the competitive
algorithm and selected the commerce datasets: GAMESALE,
BABYSALE, TRANSACTION, and MOVIE. The ﬁrst 80% of
the sequences were used as the training set, and the remaining
20% as the testing set. The parameters used for training are
shown in Table IX.
To evaluate the performance of recommendation based on
the co-occurrence rules, in addition to conﬁdence, there are
three commonly used criteria: precision Pr = TP/(TP+FP),
recall Re = TP/(TP + FN), and F1-score F1 = 2 × Pr ×
Re/(Pr+Re), where TP is the number of correct recommen-
dations, FP is the number of incorrect recommendations, and
FN is the number of relevant items that are not included in
the recommendation list. Taking GAMESALE as an example,
we see that there are two maximal co-occurrence rules in
the training set for MCoR-Miner: {d →d, d →e}, which
means that if a user purchases item d, then MCoR-Miner will
recommend items d and e to the user. In the testing set, all
of the patterns of length two with the preﬁx pattern d are
da, db, dd, de, dj, and dk, with supports 110, 108, 139,
281, 126, and 83, respectively. Therefore, in this example,
TP is 420, since the sum of the supports for patterns dd
and de is 139 + 281 = 420. FP is zero, since MCoR-Miner
recommends items d and e, and in the test set, the next-item
actually can be a, b, d, e, j, and k, which means that items d
and e are both in these items, i.e., MCoR-Miner has no error
recommendation. FN is 427, since the sum of the supports for
patterns da, db, dj, and dk is 110+ 108 + 126+ 83 = 427. Thus,
the precision, recall, and F1-score of MCoR-Miner on the
testing set are 420/(420+0) = 1, 420/(420+427) = 0.4959, and
2×1×0.4959/(1+0.4959) = 0.6630, respectively. Comparisons
of the conﬁdence, recall, and F1-score results are shown in
Figs. 10, 11, and 12, respectively.
The results indicate that our method has the following
advantages.
1. MCoR-Miner can effectively prune the co-occurrence rules
with low conﬁdence. For example, Fig.10 shows that the
conﬁdence for each maximal co-occurrence rule mined by
MCoR-Miner is larger than 0.39, while the conﬁdence for

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
14
0 . 0
0 . 2
0 . 4
0 . 6
0 . 8
1 . 0
C o P - M
i n e r
M
C o R - M
i n e r
C o n f i d e n c e
Fig. 10: Comparison of conﬁdence
CoP-Miner
0.2530
0.1266
0.1408
0.1987
MCoR-Miner
0.4959
0.1664
0.2538
0.3280
GAMESALE
BABYSALE
TRANSACTION
MOVIE
0.0000
0.2000
0.4000
0.6000
Recall
Fig. 11: Comparison of recall
many of the co-occurrence patterns mined by CoP-Miner
is less than 0.39, and the lowest is only 0.14. This is
because MCoR-Miner discovers rules with high conﬁdence
and high frequency, while CoP-Miner only discovers rules
with high frequency. Thus, MCoR-Miner can effectively
prune co-occurrence patterns with low conﬁdence, and the
recommendation conﬁdence is improved.
2. More importantly, MCoR-Miner has better performance for
recommendation task than CoP-Miner. For example, from
Figs. 11 and 12, on GAMESALE, the recall and F1-score
of MCoR-Miner are 0.4959 and 0.6630, respectively, which
are higher than those of CoP-Miner. This phenomenon
can also be found on the other datasets, meaning that
MCoR-Miner yields better recommendation performance
than CoP-Miner.
3. MCoR-Miner is a sequential rule-based recommendation
method that is more interpretable than the learning-based
recommendation method. The reason is as follows. MCoR-
Miner discovers the rules with high conﬁdence by calcu-
lating the support of patterns in the training set. Taking
GAMESALE as an example, the supports of patterns d, dd,
and de are 1917, 970, and 763, respectively. Thus, MCoR-
Miner generates two rules: {d →d, d →e}, whose conﬁ-
dences are 0.51 and 0.40, respectively. Therefore, MCoR-
Miner has better interpretability. However, for a learning-
based recommendation method, the recommendation model
is very complex, and cannot be expressed intuitively by a
mathematical formula.
In summary, MCoR-Miner has better recommendation per-
formance than CoP-Miner. More importantly, MCoR-Miner
CoP-Miner
0.4047
0.2247
0.2468
0.3315
MCoR-Miner
0.6630
0.2854
0.4049
0.4940
GAMESALE
BABYSALE
TRANSACTION
MOVIE
0.0000
0.3000
0.6000
0.9000
F1-score
Fig. 12: Comparison of F1-score
can form effective recommendation schemes, which can help
decision-makers make correct decisions.
VI. CONCLUSION
In nonoverlapping SPM or nonoverlapping sequential rule
mining, if the preﬁx pattern or rule-antecedent is known, it
is not necessary to discover all patterns or rules and then
ﬁlter out irrelevant patterns or rules. This problem is called
co-occurrence pattern mining or co-occurrence rule mining.
To avoid discovering irrelevant patterns and to obtain better
recommendation performance, and inspired by the concept of
maximal pattern mining, we investigate MCoR mining. Unlike
classical rule mining, which requires two parameters, mini-
mum conﬁdence and minimum support, MCoR mining does
not need the minimum support, since it can be automatically
calculated based on the support of the rule-antecedent and
the minimum conﬁdence. To effectively discover all MCoRs
with the same rule-antecedent, we propose the MCoR-Miner
algorithm. In addition to the support calculation, MCoR-Miner
consists of three parts: preparation stage, candidate pattern
generation, and screening strategy. To effectively calculate the
support, we propose the DBI algorithm, which adopts depth-
ﬁrst search and backtracking strategies equipped with an in-
dexing mechanism. MCoR-Miner uses the ﬁltering strategy to
prune the sequences without the rule-antecedent to avoid use-
less support calculation. It adopts the FET and BET strategies
to reduce the number of candidate patterns, and employs the
screening strategy to avoid ﬁnding the maximal rules by brute
force. To evaluate the performance of MCoR-Miner, eleven
competitive algorithms were implemented, and eight datasets
were considered. Our experimental results showed that MCoR-
Miner yielded better running performance and scalability than
the other competitive algorithms. More importantly, compared
with frequent co-occurrence pattern mining, MCoR-Miner had
better recommendation performance.
In this paper, we focus on the nonoverlapping maximal co-
occurrence rule mining. The nonoverlapping sequential pattern
mining is a kind of repetitive sequential pattern mining. We
know that there are some similar mining methods, such as one-
off sequential pattern mining and disjoint sequential pattern
mining. Different mining methods will lead to different mining
results. The one-off and disjoint maximal co-occurrence rule
mining deserve further exploration. Moreover, for a speciﬁc
mining task, which mining method is the best is worth further
study. More importantly, the sequence studied in this paper is
a special sequence, which means that the sequence consists of
items. However, general sequence consists of itemsets, each
of which has many ordered items. It is valuable to investigate
frequent repetitive pattern mining and repetitive rule mining
in general sequence database.
ACKNOWLEDGEMENT
This work was partly supported by National Natural Sci-
ence Foundation of China (61976240, 62120106008), Na-
tional Key Research and Development Program of China
(2016YFB1000901), and Natural Science Foundation of Hebei
Province, China (Nos. F2020202013).

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
15
REFERENCES
[1] X. Wu, X. Zhu, and M. Wu. ”The Evolution of Search: Three Computing
Paradigms,” ACM Trans. Manag. Inf. Syst., vol. 13, no. 2, pp. 20, 2022.
[2] C. H. Mooney and J. F. Roddick, “Sequential pattern mining–approaches
and algorithms,” ACM Computing Surveys, vol. 45, no. 2, pp. 1-39, 2013.
[3] W. Gan, J. C. W. Lin, P. Fournier-Viger, H. C. Chao, and P. S. Yu, “A
survey of parallel sequential pattern mining,” ACM Trans. Knowl. Discov.
Data, vol. 13, no. 3, pp. 25: 1-34, 2019.
[4] Y. Wu, Q. Hu, Y. Li, L. Guo, X. Zhu, and X. Wu, “OPP-Miner:
Order-preserving sequential pattern mining for time series,” IEEE Trans.
Cybern., DOI: 10.1109/TCYB.2022.3169327, 2022.
[5] J. C. W. Lin, Y. Djenouri, and G. Srivastava, “Efﬁcient closed high-utility
pattern fusion model in large-scale databases,” Information Fusion, vol.
76, pp.122-132, 2021.
[6] G. Srivastava, J. C. W. Lin, X. Zhang, and Y. Li, “Large-scale high-
utility sequential pattern analytics in Internet of Things,” IEEE Internet
of Things Journal, vol. 8, no.16, pp. 12669-12678, 2021.
[7] X. Ao, H. Shi, J. Wang, L. Zuo, H. Li, and Q. He, “Large-scale frequent
episode mining from complex event sequences with hierarchies,” ACM
Trans. Intell. Syst. Technol., vol. 10, no. 4, pp. 1-26, 2019.
[8] L. Wang, X. Bao, and L. Zhou, “Redundancy reduction for prevalent
co-location patterns,” IEEE Trans. Knowl. Data Eng., vol. 30, no. 1, pp.
142-155, 2018.
[9] L. Wang, Y. Fang, and L. Zhou, “Preference-based spatial co-location
pattern mining,” Series Title: Big Data Management, Springer Singapore,
DOI: 10.1007/978-981-16-7566-9, 2022.
[10] Y. Wu, Y. Wang, Y. Li, X. Zhu, and X. Wu, “Top-k self-adaptive contrast
sequential pattern mining,” IEEE Trans. Cybern., vol. 52, no. 11, pp.
11819-11833, 2022.
[11] Q. Li, L. Zhao, Y. Lee, and J. Lin. “Contrast pattern mining in paired
multivariate time series of a controlled driving behavior experiment,”
ACM Trans. Spatial Algorithms Syst., vol. 6, no. 4, pp. 1-28, 2020.
[12] X. Dong, P. Qiu, J. Lv, L. Cao, and T. Xu, “Mining top-k useful negative
sequential patterns via learning,” IEEE Trans. Neural Networks Learn.
Syst., vol. 30, no. 9, pp. 2764-2778, 2019.
[13] Y. Wu, M. Chen, Y. Li, J. Liu, Z. Li, J. Li, and X. Wu. “ONP-Miner:
One-off negative sequential pattern mining,” ACM Trans. Knowl. Discov.
Data, DOI: 10.1145/3549940, 2022.
[14] W. Gan, J. C. W. Lin, P. Fournier-Viger, H.-C. Chao, V. S. Tseng, P.
S. Yu, “A survey of utility-oriented pattern mining,” IEEE Trans. Knowl.
Data Eng., vol. 33, no. 4, pp. 1306-1327, 2021.
[15] T. C. Truong, H. V. Duong, B. Le, P. Fournier-Viger, “Efﬁcient vertical
mining of high average-utility itemsets based on novel upper-bounds,”
IEEE Trans. Knowl. Data Eng., vol. 31, no. 2, pp. 301-314, 2019.
[16] W. Song, L. Liu, and C. Huang. “Generalized maximal utility for mining
high average-utility itemsets,” Knowl. Inf. Syst., vol. 63, pp. 2947–2967,
2021.
[17] J. C. W. Lin, T. Li, M. Pirouz, J. Zhang, and P. Fournier-Viger, “High
average-utility sequential pattern mining based on uncertain databases,”
Knowl. Inf. Syst., vol. 62, no. 3, pp: 1199-1228, 2020.
[18] T. Wang, L. Duan, G. Dong, and Z. Bao, “Efﬁcient mining of outlying
sequence patterns for analyzing outlierness of sequence data,” ACM Trans.
Knowl. Discov. Data, vol. 14, no. 5, pp. 62, 2020.
[19] F. Min, Z. Zhang, W. Zhai, and R. Shen, “Frequent pattern discovery
with tri-partition alphabets,” Inf. Sci., vol. 507, pp. 715-732, 2020.
[20] Y. Wu, L. Luo, Y. Li, L. Guo, P. Fournier-Viger, X. Zhu, and X. Wu,
“NTP-Miner: Nonoverlapping three-way sequential pattern mining,” ACM
Trans. Knowl. Discov. Data, vol. 16, no. 3, pp. 51, 2022.
[21] D. Amagata and T. Hara, “Mining top-k co-occurrence patterns across
multiple streams,” IEEE Trans. Knowl. Data Eng., vol. 29, no. 10, pp.
2249-2262, 2017.
[22] H. Duong, T. Truong, A. Tran, and B. Le, “Fast generation of sequential
patterns with item constraints from concise representations,” Knowl. Inf.
Syst., vol. 62, no. 6, pp. 2191-2223, 2020.
[23] Y. Wang, Y. Wu, Y. Li, F. Yao, P. Fournier-Viger, and X Wu. “Self-
adaptive nonoverlapping sequential pattern mining,” Appl. Intell. , vol.
52, no. 6, pp. 6646-6661, 2021.
[24] Y. Wu, Y. Tong, X. Zhu, and X. Wu, “NOSEP: Nonoverlapping sequence
pattern mining with gap constraints,” IEEE Trans. Cybern., vol. 48, no.
10, pp. 2809-2822, 2018.
[25] Y. H. Ke, J. W. Huang, W. C. Lin, and B. P. Jaysawal, “Finding
possible promoter binding sites in DNA sequences by sequential patterns
mining with speciﬁc numbers of gaps,” IEEE ACM Trans. Comput. Biol.
Bioinform., vol. 18, no. 6, pp. 2459-2470, 2020.
[26] M. Zhang, B. Kao, D. Cheung, and K. Yip, “Mining periodic patterns
with gap requirement from sequences,” ACM Trans. Knowl. Discov. Data,
vol. 1, no. 2, pp. 7, 2007.
[27] Q. Shi, J. Shan, W. Yan, Y. Wu, and X. Wu, “NetNPG: Nonoverlapping
pattern matching with general gap constraints,” Appl. Intell. , vol. 50, no.
6, pp. 1832-1845, 2020.
[28] C. Li, Q. Yang, J. Wang, and M. Li, M, “Efﬁcient mining of gap-
constrained subsequences and its various applications,” ACM Trans.
Knowl. Discov. Data, vol. 6, no. 1, pp. 2:1-39, 2012.
[29] S. Ghosh, J. Li, L. Cao, and K. Ramamohanarao, “Septic shock
prediction for ICU patients via coupled HMM walking on sequential
contrast patterns,” Journal of Biomedical Informatics, no. 66, pp. 19-31,
2017.
[30] F. Xie, X. Wu, and X. Zhu, “Efﬁcient sequential pattern mining with
wildcards for keyphrase extraction,” Knowl. Based Syst., vol. 115, pp.
27-39, 2017.
[31] W. Wang and L. Cao, “VM-NSP: Vertical negative sequential pattern
mining with loose negative element constraints,” ACM Trans. Inf. Syst.,
vol. 39, no. 2, pp. 1-27, 2021.
[32] W. Wang, J. Tian, F. Lv, G. Xin, Y. Ma, and B. Wang, “Mining
frequent pyramid patterns from time series transaction data with custom
constraints,” Computers & Security, vol. 100, pp. 102088, 2021.
[33] Y. Wu, L. Wang, J. Ren, W. Ding, and X. Wu, “Mining sequential
patterns with periodic wildcard gaps,” Appl. Intell., vol. 41, no. 1, pp.
99-116, 2014.
[34] O. Ouarem, F. Nouioua, and P. Fournier-Viger, “Mining episode rules
from event sequences under non-overlapping frequency,” Intern. Con-
ference on Industrial, Engineering and Other Applications of Applied
Intelligent Systems. Springer, Cham, pp. 73-85, 2021.
[35] Y. Wu, X. Wang, Y. Li, L. Guo, Z. Li, J. Zhang, and X. Wu, “OWSP-
Miner: Self-adaptive one-off weak-gap strong pattern mining,” ACM
Trans. Manag. Inf. Syst., vol. 13, no. 3, pp. 25, 2022.
[36] P. Fournier-Viger, C.-W. Wu, V.S. Tseng, L. Cao, R. Nkambou, “Mining
partially-ordered sequential rules common to multiple sequences,” IEEE
Trans. Knowl. Data Eng., vol. 27, no. 8, pp. 2203-2216, 2015.
[37] J. S. Okolica, G. L. Peterson, R. F. Mills, and M. R. Grimaila, “Sequence
pattern mining with variables,” IEEE Trans. Knowl. Data Eng., vol. 32,
no. 1, pp. 177-187, 2020.
[38] J. D. Smedt, G. Deeva, and J. D. Weerdt, “Mining behavioral sequence
constraints for classiﬁcation,” IEEE Trans. Knowl. Data Eng., vol. 32,
no. 6, pp. 1130-1142, 2020.
[39] P. Ma, Y. Wu, Y. Li, L. Guo, H. Jiang, X. Zhu, and X. Wu, “HW-Forest:
Deep forest with hashing screening and window screening,” ACM Trans.
Knowl. Discov. Data, vol. 16, no. 6, pp. 123, 2022.
[40] Y. Wu, C. Zhu, Y. Li, L. Guo, and X Wu, “NetNCSP: Nonoverlapping
closed sequential pattern mining,” Knowl. Based Syst., vol. 196, pp.
105812, 2020.
[41] Y. Li, S. Zhang, L. Guo, J. Liu, Y. Wu, and X. Wu, “NetNMSP:
Nonoverlapping maximal sequential pattern mining,” Appl. Intell. , vol.
52, pp. 9861–9884, 2022.
[42] J. C. W. Lin, M. Pirouz, Y. Djenouri, C. F. Cheng, and U. Ahmed,
“Incrementally updating the high average-utility patterns with pre-large
concept,” Appl. Intell. , vol. 50, no. 11, pp. 3788-3807, 2020.
[43] Y. Baek, U. Yun, H. Kim, H. Nam, H. Kim, J. C. W. Lin, B. Vo, and
W. Pedrycz, “RHUPS: Mining recent high utility patterns with sliding
window-based arrival time control over data streams,” ACM Trans. Intell.
Syst. Technol., vol. 12, no. 2, pp. 16:1-16:27, 2021.
[44] Y. S. Koh, and S. D. Ravana, “Unsupervised rare pattern mining: a
survey,” ACM Trans. Knowl. Discov. Data, vol. 10, no. 4, pp. 1-29, 2016.
[45] L. Cao, X. Dong, and Z. Zheng, “e-NSP: Efﬁcient negative sequential
pattern mining,” Artiﬁcial Intelligence, vol. 235, pp. 156-182, 2016.
[46] X. Dong, Y. Gong, and L. Cao, “e-RNSP: An efﬁcient method for mining
repetition negative sequential patterns,” IEEE Trans. Cybern., vol. 50, no.
5, pp. 2084-2096, 2020.
[47] J. C. W. Lin, Y. Djenouri, G. Srivastava, Y. Li, and P. S. Yu, “Scalable
mining of high-utility sequential patterns with three-tier MapReduce
model,” ACM Trans. Knowl. Discov. Data, vol. 16, no. 3, pp. 1-26, 2022.
[48] W. Gan, J. C. W. Lin, J. Zhang, P. Fournier-Viger, H. C. Chao, and P.
S. Yu, “Fast utility mining on sequence data,” IEEE Trans. Cybern., vol.
51, no. 2, pp. 487-500, 2021.
[49] Y. Wu, R. Lei, Y. Li, L. Guo, and X. Wu, “HAOP-Miner: Self-adaptive
high-average utility one-off sequential pattern mining,” Expert Syst. Appl.,
vol. 184, pp. 115449, 2021.
[50] M.S. Nawaz, P. Fournier-Viger, U. Yun, Y. Wu, and W. Song. Mining
high utility itemsets with hill climbing and simulated annealing. ACM
Trans. Manag. Inf. Syst., vol. 13, no. 1, pp. 4, 2022.
[51] W. Gan, J. C. W. Lin, J. Zhang, H. Yin, P. Fournier-Viger, H. C. Chao, P.
S. Yu, “Utility mining across multi-dimensional sequences,” ACM Trans.
Knowl. Discov. Data, vol. 15, no. 5, pp. 82 ,2021.

---

IEEE TRANSACTIONS ON KNOWLEDGE AND DATA ENGINEERING
16
[52] P. Fournier-Viger, W. Gan, Y. Wu, M. Nouioua, W. Song, T. Truong,
and H. Duong, “Pattern mining: Current challenges and opportunities,”
DASFAA 2022 International Workshops, pp 34–49, 2022.
[53] P. Fournier-Viger, M. S. Nawaz, Y. He, Y. Wu, F. Nouioua, and U.
Yun, “MaxFEM: Mining maximal frequent episodes in complex event
sequences,” International Conference on Multi-disciplinary Trends in
Artiﬁcial Intelligence , pp 86–98, 2022.
[54] Y. Li, L. Yu, J. Liu, L. Guo, Y. Wu, and Xindong Wu, “NetDPO: (delta,
gamma)-approximate pattern matching with gap constraints under one-off
condition,” Appl. Intell. , vol. 52, no. 11, pp 12155-12174, 2022.
[55] Y. Wu, Z. Yuan, Y. Li, L. Guo, P. Fournier-Viger, and Xindong Wu,
“NWP-Miner: Nonoverlapping weak-gap sequential pattern mining,” Inf.
Sci., vol. 588, pp. 124-141, 2022.
[56] Y. Wu, M. Geng, Y. Li, L. Guo, Z. Li, P. Fournier-Viger, X. Zhu, and
X. Wu, “HANP-Miner: High average utility nonoverlapping sequential
pattern mining,” Knowl. Based Syst., vol. 229, pp. 107361, 2021.
[57] J. Zhan, J. Ye, W. Ding, and P. Liu, “A novel three-way decision model
based on utility theory in incomplete fuzzy decision systems,” IEEE
Trans. Fuzzy Syst., vol. 30, no. 7, pp. 2210 - 2226, 2022.
[58] X. Liu, X. Niu, and P. Fournier-Viger, “Fast Top-K association rule
mining using rule generation property pruning,” Appl. Intell., vol. 51, no.
4, pp. 2077-2093, 2021.
[59] X. Ao, P. Luo, J. Wang, F. Zhuang, and Q. He, “Mining precise-
positioning episode rules from event sequences,” IEEE Trans. Knowl.
Data Eng., vol. 30, no. 3, pp. 530-543, 2017.
[60] Y. Wu, X. Zhao, Y. Li, L. Guo, X. Zhu, P. Fournier-Viger, and X. Wu,
“OPR-Miner: Order-preserving rule mining for time series,” IEEE Trans.
Knowl. Data Eng., DOI: 10.1109/TKDE.2022.3224963, 2022.
[61] R. Wang, W. Ji, M. Liu, X. Wang, J. Weng, S. Deng, S. Gao, and
C. Yuan, “Review on mining data from multiple data sources,” Pattern
Recognition Letters, vol. 109, pp 120-128, 2018.
[62] S. Saleti and R. B. V. Subramanyam, “A novel mapreduce algorithm
for distributed mining of sequential patterns using co-occurrence infor-
mation,” Appl. Intell. , vol. 49, no. 1, pp. 150-171, 2019.
[63] G. Huang, W. Gan, and P. S. Yu, ”TaSPM: Targeted Sequential Pattern
Mining,” arXiv preprint arXiv:2202.13202, 2022.
[64] M. Celik, S. Shekhar, J. P. Rogers, and J. A. Shine, “Mixed-drove
spatiotemporal co-occurrence pattern mining,” IEEE Trans. Knowl. Data
Eng., vol. 20, no. 10, pp. 1322-1335, 2008.
[65] Y. Wu, C. Shen, H. Jiang, and X. Wu, “Strict pattern matching under
non-overlapping condition,” Sci. China Inf. Sci., vol. 60, no. 1, pp.
012101, 2017.
[66] Y. Wu, X. Liu, W. Yan, L. Guo, and X. Wu, “Efﬁcient algorithm for
solving strict pattern matching under nonoverlapping condition,” Journal
of Software, vol. 32, no. 11, pp. 3331-3350, 2021.
Yan Li received the PhD degree in Management
Science and Engineering from Tianjin University,
Tianjin, China. She is an associate professor with
Hebei University of Technology. Her current re-
search interests include data mining and supply
chain management.
Chang Zhang received the master degree in the
School of Economics and Management from the
Hebei University of Technology, Tianjin, China. His
current research interests include data mining and
machine learning.
Jie Li received the Ph.D. degree in electrical engi-
neering from the Hebei University of Technology,
Tianjin, China, in 2002. She is currently a Professor
with the School of Economics and Management,
Hebei University of Technology. Her research inter-
ests include Big Data analytics in smart health care,
business, and ﬁnance.
Wei Song received his Ph.D. degree in Computer
Science from University of Science and Technology
Beijing, Beijing, China, in 2008. He is a professor
with the School of Information Science and Technol-
ogy at North China University of Technology. His
research interests are in the areas of data mining and
knowledge discovery. He has published more than 40
research papers in refereed journals and international
conferences.
Zhenlian Qi received the Ph.D. in Environmental
Science and Engineering, Harbin Institute of Tech-
nology, Harbin, China in 2020. She was a postdoc
with Guangdong University of Technology, from
2020 to 2022. She is currently an Associate Profes-
sor with Guangdong Eco-Engineering Polytechnic,
Guangzhou, China. Her research interests include
environmental engineering, eco-big data, and data
analytics.
Youxi Wu received the Ph.D. degree in Theory
and New Technology of Electrical Engineering from
the Hebei University of Technology, Tianjin, China.
He is currently a Ph.D. Supervisor and a Profes-
sor with the Hebei University of Technology. He
has published more than 30 research papers in
some journals, such as IEEE TKDE, IEEE TCYB,
ACM TKDD, ACM TMIS, SCIS, INS, JCST, KBS,
EWSA, JIS, Neurocomputing, and APIN. He is a
senior member of CCF and a member of IEEE. His
current research interests include data mining and
machine learning.
Xindong Wu received the Ph.D. degree from the
University of Edinburgh, Edinburgh, U.K. He is a
Yangtze River Scholar with the Hefei University
of Technology, Hefei, China. His current research
interests include data mining, big data analytics,
knowledge based systems, and Web information
exploration. Dr. Wu was an Editor-in-Chief of IEEE
Transactions on Knowledge and Data Engineering
(TKDE) (2005-2008) and is the Steering Committee
Chair of the IEEE International Conference on Data
Mining and the Editor-in-Chief of Knowledge and
Information Systems. He is a Fellow of the American Association for the
Advancement of Science and IEEE.

---

