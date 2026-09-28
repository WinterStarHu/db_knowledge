# An outline of multi objective optimization in databases with focus on flexible s

> 来源: https://arxiv.org/pdf/2201.04899

arXiv:2201.04899v1  [cs.DB]  13 Jan 2022
An outline of multi objective optimization in databases with focus
on ﬂexible skyline queries
Matteo Savino
Politecnico di Milano
Milan, Italy
matteo.savino@mail.polimi.it
January 13, 2022
Abstract
The problem of optimizing across diﬀerent, conceivably conﬂicting, criteria is called multi-objective
optimization and it is widely spread across many ﬁelds. This is a recurring problem in database queries
when there is the need of obtaining the best objects from a very large data set. In this article, I included
a complete review of the main approaches typically used to achieve multi-criteria optimization. Starting
from ranking queries and skylines and then proceeding to more advanced methods, this paper aims to
deﬁne a clear outline of multi-objective optimization in databases. In particular, the ﬂexible skyline
paradigm is considered and thoroughly discussed as it overcomes many of the critical issues that arise
with other methods.
Keywords:
Multi-objective optimization, Skyline queries, Top-k queries, Ranking queries, Flexible
skyline, Restricted skyline
1
Introduction
The problem of optimizing across diﬀerent, conceivably conﬂicting, criteria is called multi-objective opti-
mization. As reported in [10] the need to ﬁnd the optimal solution to many desired goals is found across
many research ﬁelds such as mathematics, economics, engineering and many others. Several reviews on
this topic have been conducted since it is widespread across multiple ﬁelds and many techniques have been
designed to solve this problem. Some of these methods do not require complex mathematical equations,
therefore they can be easily applied. These simpler approaches fall under two main categories: pareto and
scalarization [10].
One of the ﬁelds in which multi-objective optimization appears very frequently is database queries. [8]
highlights how the modern web infrastructure, together with social networks, produces an unprecedented
mass of data. Therefore, data is usually available in very large quantities and hence determining the most
relevant items in data sets is fundamental. A slightly more formal deﬁnition of the problem has been reported
below.
Problem 1 Given N objects described by d (dimensions) attributes in a data set and given some notion of
quality, possibly conﬂicting, for each attribute, ﬁnd the best objects.
Problem 1 will be dealt with in this survey by showing some of the most widely recognized or innovative
techniques. Multi-objective optimization in data sets is commonly obtained with three main approaches
[4, 7, 9]:
1. The ranking or top-k (or scalarization as previously mentioned) approach: it reduces the multi-objective
problem to a single objective one by using a weighted formula.
The weights express the relative
importance of each attribute.
1

---

2. The lexicographic approach: It enforces a strict priority among attributes.
3. The skyline (or Pareto as previously mentioned) approach: It is based on the concept of dominance
and it returns all objects that are not dominated by other objects.
The lexicographic method is not covered by this document in detail. However, its disadvantages are clear, a
tuple may be better than another across all attributes but the one with the highest priority and be discarded.
In this paper, an overview of the ranking and skyline methods is provided along with a description of their
pros and cons. Then, to overcome some of the critical issues, a brief explanation of some evolved versions
is given. Finally, the main and ﬁnal goal is to go into details of one of the previously mentioned evolutions
which is the ﬂexible skylines paradigm. In short, it consists of a mix between the top-ks and skylines which
aims to get the best of the two worlds.
The structure of the paper is organized as follows. Section 2 discusses ranking queries while section 3
focuses on skylines. Section 4 contains the list of some newer approaches and ﬁnally section 5 presents an
entire module devoted to ﬂexible skylines. The aim of all sections before the ﬁfth one is to provide the
reasons that made this approach necessary. F-skylines are discussed in detail since they are the core topic
of the document. Finally, section 6 concludes the paper.
2
Ranking queries
Ranking queries, also called top-k queries, have been studied extensively and are by far the most used
approach for multi-criteria decision making. The deﬁnition of Problem 1 has to be adapted to properly
reﬂect what top-k queries try to achieve.
Problem 2 Given N objects described by d (dimension) attributes in a data set and given some notion of
quality, possibly conﬂicting, for each attribute, ﬁnd the best k objects ordered according with their relevance.
In Problem 2, the notion of ranking is implicitly introduced and it represents the arranging of objects
accordingly with their signiﬁcance. The importance of a tuple with respect to another one, concept that
deﬁnes the ranking, is obtained by applying a so called scoring function.
The basic idea behind ranking queries is solving the multi-optimization problem by transforming it into
a single optimization one through a weighted formula [9], called scoring function [7]. The most common
and widespread cases involve linear scoring functions, hence they will be the focus of the discussion. The
deﬁnition of the formula is as follow:
F = w1f1 + w2f2 + .. + wnfn
(1)
where F is the candidate’ score, wi is the weight assigned to the i-th criteria f and n is the number of
evaluation criteria [9]. It’s clear that weights are an input that need to be either explicitly speciﬁed or
computed somehow. There are diﬀerent know methods to obtain weights as shown in [6]:
1. The user is asked to insert directly the parameters or more conceivably some preferences from which
weights can be easily obtained.
2. User’s activities are monitored and weights are learned from their habits.
3. The preferences of multiple users are aggregated to obtain the needed parameters (e.g. using crowd-
sourcing [8]).
An intuitive example of the top-k approach is provided without using a speciﬁc algorithm; it will be useful
also for pointing out some details further in this paper.
2

---

Student
Math grade
Eng grade
Alex
9
5
James
10
1
Emma
6
6
Robert
6
4
John
4
9
Table 1: Simple data set for examples.
Example 1 Consider the data set of Table 1 and the scoring function StudentScore = 0.5 ∗MathGrade +
0.5 ∗EngGrade. We want to compute the top-2 query. The computation procedure is shown only for one of
the students, the rest can be easily obtained in the same way: AlexScore = 0.5 ∗9 + 0.5 ∗5 = 7. The ranking
for k = 2 clearly is: Alex in ﬁrst place and John in second place.
2.1
Pros and cons
Top-k queries are clearly a very simple, eﬃcient and easy-to-use approach and this probably explains why it
is widespread. In addition, the ability to control the size of the output and the trade-oﬀs among attributes
should not be underestimated [4, 5, 7, 16]. However, this method is not free of drawbacks and can have
substantial disadvantages. First, ranking queries are essentially aggregating diﬀerent criteria and thus they
are possibly mixing up diﬀerent units of measurements or, which is worse, non-commensurable criteria [9].
Data normalization is certainly a possible solution but it requires speciﬁc background knowledge and hence
an ad-hoc solution for every domain. This inconvenience may prevent its adoption in many areas that require
general solutions.
Last but not least, the elephant in the room is the setting of weights. First of all, it is proven that it’s
diﬃcult to obtain the right values for multiple reasons such as the fact that the user who inputs the data may
not themselves know their preferences. Moreover, it is really hard to estimate what change could cause the
modiﬁcation of the weight’s vector [7]. The only way to do it is to experiment by running it several times with
diﬀerent values for the parameters, which evidently is not convenient and once again would end up in an ad-
hoc approach. Due to these facts, both making the user inputs the parameters directly and computing them
from user preferences does not lead to a perfect solution. As shown in [8], some crowdsourcing techniques
proved helpful for overcoming this weakness at least to some extent. Unfortunately, this is not enough to
consider the problem solved because once a combination of weights is found, then it’s hard to explore diﬀerent
solutions to ﬁnd a better setting, since it would require experiments involving multiple runs to observe the
impact on changes.
Example 2 Consider once more the data set of Table 1. A user may conceivably think that the StudentScore
scoring function that gives to MathGrade and to EngGrade the same weights is a good way of determining
the best top k = 2 students. But carefully looking at data, it is easy to notice that Emma may never appear
in the result even if she is the only student to have both grades greater than six.
3
Skylines
Skyline queries are not based on an aggregate scoring function with weights, but instead ﬁnd their roots in
the concept of pareto dominance. Again, as for top-k queries, the deﬁnition of Problem 1 has to be adapted
[15].
Problem 3 Given N objects described by d (dimension) attributes in a data set and given some convention
for assessing the attributes (e.g. usually lower values are considered better): retrieve all objects which are
not dominated by any other object.
As seen, the notion of pareto dominance, or simply dominance, is key to understanding skyline queries.
[7, 9, 15, 12, 16, 11, 3]
3

---

0
2
4
6
8
10
0
2
4
6
8
10
dominated
skyline
John
Emma
Alex
James
Robert
Math grade
Eng grade
Figure 1:
Skyline for tuples from Table 1. Higher values are better. The black dots are part of the skyline.
Deﬁnition 1 Consider the tuples t and s belonging to a data set with schema R over d dimensions and
consider lower values as better. Then we can say that t dominates s if for each attribute, t is never worse
(greater or equal) than s and if for at least one attribute, t is strictly better (less) than s.
As a result of Deﬁnition 1, skylines can now be properly deﬁned as well [5, 2]:
Deﬁnition 2 A skyline is the set of all non-dominated tuples or, alternatively and equivalently, the set of
potentially optimal tuples.
An example is included to show how skyline works. It will be used further to discuss some characteristics of
this technique.
Example 3 We take as landmark the data set in Table 1 and then apply the skyline operator. The results
are shown graphically in Figure 1. The skyline is composed of all students that are not dominated (e.g. no
other student has a greater or equal grade in both Math and Eng with at least one of the two strictly greater).
Reading the plot from left to right, we can ﬁnd this set of tuples in the skyline: John, Emma, Alex, James.
The white dot, representing Robert, is dominated by both Emma and Alex, thus it’s excluded.
Before moving on to the next section, it is worth noting that the concept of skyline can be further generalized
by introducing the concept of k-skybands [7, 13]:
Deﬁnition 3 A k-skyband is the set of all tuples dominated by less than k other tuples.
It’s easy to note that a skyline is nothing else than a k-skyband with a particular value of k = 1. Another
interesting aspect to consider consists in the fact that the result of every top-k query is contained in the
k-skyband query executed on the same data set. Many k-skyband based approaches exist for solving diﬀerent
problems (e.g. the one in [1]).
3.1
Pros and cons
Skylines completely solve the weights problem and this approach does not require them to work properly
[4, 5, 7, 9]. Actually, this approach is more intuitive since it adapts itself to the multi-criteria optimization
problem while ranking queries transform the problem in a single-objective optimization one [9].
4

---

Another advantage consists in the greater informative quality of the result. Considering Example 3, it’s
clear that all possible interesting tuples are included in the result. Regrettably, there is another side of the
coin. The size of the result may increase too much especially when dealing with many attributes d and in the
worst case it may reach the size of the entire data set [15, 12, 16, 3]. The average user may be overwhelmed
by the task of choosing between many tuples [9, 16, 3]
Skylines are said to be more complex than ranking queries and usually a little more expensive to compute
but that doesn’t seem enough to overshadow the previously mentioned advantages [4, 9]. Furthermore, the
authors of [3] provide an algorithm to parallelize the computation of skylines making this technique suitable
also in distributed scenarios.
Another drawback of this technique consists in the fact that it lacks a feature for adjusting the relative
importance of each attribute [12, 11].
Example 4 Consider the results obtained in Example 3.
The skyline operator gave us all the possible
interesting results. We have Emma with a balance between grades, James is the best in Math, Alex is good in
Math and not so bad in Eng and ﬁnally John has opposite grades to Alex. A user dealing with these tuples
may have a hard time choosing the best student. In a simple data set as the one shown in Table 1, the skyline
approach gave us almost the entire data set, hence it’s evident that the situation could have been a lot worse
in a real world scenario.
4
Related work
In the previous sections disadvantages exhibited by ranking and skyline queries have been deeply described.
The scientiﬁc community has designed multiple solutions to solve those problems.
Usually, each of the
solutions start from one of the two classic methods and then either tries to mix them up or consider adding
new strategies.
In [6], the authors introduced an instance optimal algorithm called FSA to compute top-k queries that
do not require precise values of weights but just a rough estimate. Their work is based on the concept of
F-dominance that in this document will be dealt with in greater depth in the next section where F-skylines
are analyzed.
Another possibility is shown in [16], where top-k dominating queries have been studied. This technique
consists in ranking queries with a particular scoring function which, considering a tuple t consists in the
count of tuples dominated by t. An optimized algorithm has been provided too.
A further study [13] has presented uncertain top-k queries (UTK) in which, instead of avoiding the
weighted approach, the provided algorithm takes into account the weight uncertainties. The resulting query
works using the concept of dominance and tries to include in the result set also interesting results within a
certain range from the combination of weights.
Next, moving into more skyline based methods, there is [12] that adds attribute importance (preferences)
to skylines creating the p-skyline framework. Incorporating preferences also reduces considerably the result
size.
Unfortunately, this approach somehow requires user preferences and limits the ﬂexibility between
dimensions.
An additional extension is the trade-oﬀskyline paradigm [11].
As the name suggests, they aim to
introduce the concept of trade-oﬀbetween attributes in skylines. Despite this, the proposed algorithm is not
so eﬃcient and the trade-oﬀpreferences require to be somehow elicited.
All presented solutions solve either some or even a great part of the common problems that are usually
encountered in multi-objective optimization, but they all have some drawbacks.
5
Flexible skylines
Every approach is imperfect, but ﬂexible skylines appear to solve most of the issues with fewer problems
compared to other methods. Their focus is to enhance basic skylines by giving control of the result size [4].
Originally, they were called restricted skylines (or r-skylines) [4, 5, 15] but newer literature refers to them as
ﬂexible skylines [7]. Their foundation consists in the decision of weakening the notion of pareto dominance
5

---

[15]. This process is accomplished by imposing a set of constraints on the scoring functions [4, 5, 7]. As a
result, the notion of F-dominance has been obtained:
Deﬁnition 4 Consider the tuples t and s belonging to a data set with schema R over d dimensions. Then
we can say that t F-dominates s if for each considered scoring function, t is never worse than s and if for
at least one scoring function, t is strictly better than s.
The concept of F-dominance helps to greatly reduce the result set with respect to the classic dominance. As
a consequence of including the set of constraints, F-skylines can adapt to user preference and hence they are
more ﬂexible.
The deﬁnition of F-dominance leads to the deﬁnition of two diﬀerent F-skylines operators. They are
respectively called ND and PO operators.
Deﬁnition 5 An ND F-skyline is the set of all non F-dominated tuples.
Deﬁnition 6 A PO F-skyline is the set of all potentially optimal tuples (i.e. top 1 according to some scoring
function).
It is worth noting an interesting property of the F-skylines operators [4, 7]:
PO ⊆ND ⊆SKY
(2)
This shows clearly that the size of PO and ND result sets has to be smaller than the size of the classic
skyline (equal in the worst case). Additionally, as said before, F-skylines oﬀer the necessary ﬂexibility that
was missing in the basic skylines and do not require precise weights (only constraints). It is clear that
F-skylines solve a great portion of the problems described in previous sections.
Example 5 Consider the data set of Table 1 again and F as the set of linear scoring functions of the form
StudentScore = w1 ∗MathGrade + w2 ∗EngGrade such that w1 > w2. The PO result set is composed by
the students Alex and James. As expected, the result size is smaller than the one of the basic skyline.
Before moving on, there is another thing to take into account that our example highlights.
F-skylines
successfully manage to reduce the size of the result set, though they can’t estimate the exact size of the
result before computing it. This issue has been addressed in [14] where the two operators ORD and ORU
have been designed. Last but not least, the assessment of performances can be found in the next subsection.
5.1
Algorithms
In [7] several algorithms to compute F-skylines have been introduced. The most eﬃcient between them are
reported here along with a brief description.
Computing ND highly depends on how challenging the data set is. In case of a challenging scenario, it is
advised to use the SVE1F algorithm while in the opposite case it is more suitable the SVE2 algorithm. The
names of the algorithms contain information to understand their behaviour.
1. The S means that the algorithm Sorts the input data set, which is always beneﬁcial in ND computation.
2. The VE part means that the algorithm works with the Vertex Enumeration strategy which is usually
faster than applying linear programming.
3. The digit points out the number of phases required. Number 2 means that ND is computed from the
classic skyline.
4. The F means that the algorithm interleaves dominance and F-dominance during its execution.
The best method to compute PO is always starting from ND and then applying the PODI2 algorithm, which
behaves well in all scenarios.
1. The PO part means that the algorithm computes the PO operator.
6

---

2. The D part means that F-dominance is checked through a dual PO test which usually leads to better
performances than the primal test.
3. The I means that an incremental approach is being used.
4. The digit points out the number of phases required. Number 2 means that PO is computed from the
ND F-skyline.
In the cited article it is proven that the performances of F-skylines are usually better than normal skylines
(computed with the famous SFS [7, 3]) when computing ND and in line with them for what concerns PO. This
conﬁrms the fact that F-skylines can be used in place of normal skylines without worrying. Unfortunately,
they lose in the comparison of computational time with ranking queries. The increased capability of exploring
interesting results comes with a price. However, as for basic skylines, F-skylines can be extended to work in
a parallel or distributed environment.
6
Conclusion
This paper has presented a list of approaches for dealing with multi-objective optimization in data sets from
classic methods to newly designed ones. This review has shown how top-k queries and skylines work along
with their advantages and disadvantages, highlighting their weaknesses. Next, a list of methods aiming to
overcome the previously mentioned diﬃculties has been presented, up to the ﬂexible skyline paradigm, which
solves most of (unfortunately not all) the problems that arise with others solutions. F-skylines have been
deeply analyzed and some of the most eﬃcient algorithms to compute them have been presented. Another
interesting approach that has been mentioned but not investigated in detail is the ORD and ORU operators
that managed to solve one of the few F-skylines drawbacks.
In conclusion, even if ﬂexible skylines are not a panacea for multi-objective optimization, it sure is one of
the most valid approaches and it is worth keeping an eye on their possible evolution and applicability. In the
future, investigating further optimizations of this method may be interesting and the remaining drawbacks
of this approach may be solved.
References
[1] Marcos Bedo, Paolo Ciaccia, Davide Martinenghi, and Daniel de Oliveira. A k–skyband approach for
feature selection. In 12th International Conference, SISAP 2019, Newark, NJ, USA, October 2–4, 2019,
pages 160–168. Springer Link, 2019.
[2] S. Borzsony, D. Kossmann, and K. Stocker. The skyline operator. In Proceedings 17th International
Conference on Data Engineering, ICDE 2001, Heidelberg, Germany, 2-6 April 2001. IEEE, 2001.
[3] Jan Chomicki, Paolo Ciaccia, and Niccolo’ Meneghetti. Skyline queries, front and back. ACM SIGMOD
Record, 42(3):6–18, 2013.
[4] Paolo Ciaccia and Davide Martinenghi. Reconciling skyline and ranking queries. Proceedings of the
VLDB Endowment, 10(11):1454–1465, 2017.
[5] Paolo Ciaccia and Davide Martinenghi. Beyond skyline and ranking queries: Restricted skylines. In
Proceedings of the 26th Italian Symposium on Advanced Database Systems, SEBD, Castellaneta Marina
(Taranto), Italy , July 24 - 27, 2018, pages 1–8. CEUR Workshop Proceedings, 2018.
[6] Paolo Ciaccia and Davide Martinenghi. FA + T A < FSA: Flexible score aggregation. In Proceedings
of the 27th ACM International Conference on Information and Knowledge Management, CIKM 2018,
Torino, Italy, October 22 - 26, 2018, pages 57–66. ACM, 2018.
[7] Paolo Ciaccia and Davide Martinenghi. Flexible skylines: Dominance for arbitrary sets of monotone
functions. ACM Transactions on Database Systems (TODS), 45(4):1–45, 2020.
7

---

[8] Eleonora Ciceri, Piero Fraternali, Davide Martinenghi, and Marco Tagliasacchi. Crowdsourcing for
top-k query processing over uncertain data. IEEE Transactions on Knowledge and Data Engineering,
28(1):41–53, 2016.
[9] Alex A. Freitas. A critical review of multi-objective optimization in data mining: a position paper.
SIGKDD Explorations, 6(2):77–86, 2004.
[10] Nyoman Gunantara. A review of multi-objective optimization: Methods and its applications. Cogent
Engineering, 5(1):1–16, 2018.
[11] Christoph Loﬁ, Ulrich G¨untzer, and Wolf-Tilo Balke. Eﬃcient computation of trade-oﬀskylines. In
Proceedings of the 13th International Conference on Extending Database Technology, EDBT 2010, Lau-
sanne, Switzerland, September March 22 - 26, 2010, pages 597–608. ACM, 2010.
[12] D Mindolin and J Chomicki. Discovering relative importance of skyline attributes. In Proceedings of
the VLDB Endowment, VLDB 2009, Lyon, France, August 24-28, 2005, pages 610–621. ACM, 2005.
[13] Kyriakos Mouratidis and Bo Tang. Exact processing of uncertain top-k queries in multi-criteria settings.
Proceedings of the VLDB Endowment, 11(8):866–879, 2018.
[14] Kyriakos Mouratidis and Bo Tang. Marrying top-k with skyline queries: Relaxing the preference input
while producing output of controllable size. In Proceedings of the 2021 International Conference on
Management of Data, SIGMOD 2021, Virtual event, China, June 20 - 25, 2021, pages 1317–1330.
ACM, 2021.
[15] Balke W. T. and U. G¨untzer. Eﬃcient skyline queries under weak pareto dominance. In IJCAI-05
Multidisciplinary Workshop on Advances in Preference Handling, PREFERENCE 2005, Edinburgh,
UK, 2005, 2005.
[16] ML Yiu and N Mamoulis. Eﬃcient processing of top-k dominating queries on multi-dimensional data.
In Proceedings of the VLDB Endowment, VLDB 2007, Vienna, Austria, September 23-28, 2007, pages
483–494. ACM, 2007.
8

---

