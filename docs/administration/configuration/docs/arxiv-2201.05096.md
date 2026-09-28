# Flexible Skyline: one query to rule them all

> 来源: https://arxiv.org/pdf/2201.05096

arXiv:2201.05096v2  [cs.DB]  14 Jan 2022
Flexible Skyline: one query to rule them all
GIACOMO VINATI
Politecnico di Milano
Milan, Italy
giacomo.vinati@mail.polimi.it
Abstract
The most common archetypes to identify relevant information in large datasets and ﬁnd the best
options according to some preferences or user criteria, are the top-k queries (ranking method based on
a score function deﬁned over the records attributes) and skyline queries (based on Pareto dominance of
tuples). Despite their large diﬀusion, both approaches have their pros and cons.
In this survey paper, a comparison is made between these methods and the Flexible Skylines, which is
a framework that combines the ranking and skyline approaches using the novel concept of F-dominance
to a set of monotone scoring functions F.
Keywords: R-skylines, Flexible skylines, ranking queries, Skyline queries, multi-objective optimization
1
Introduction
Handling complex problems well and considering multiple criteria explicitly leads to more informed and
better decisions. Multiple criteria decision making, deals with mathematical optimization problems (min,
max of a function) involving more than one objective function to be optimized simultaneously and evaluating
multiple conﬂicting criteria in decision making, where optimal decisions need to be taken in the presence of
trade-oﬀs between two or more colliding objectives.
Now, considering dataset which consists of many objects and each of them is described by some features
or attributes: out of this data , most of the times, is necessary to ﬁnd the best options according to some
preferences to some user criteria and the aim of simultaneously optimize two or more quality criteria is
known as multi-objective optimization.
It’s used for mainly two diﬀerent data mining scenarios: the ﬁrst one involves predictive tasks, such as
classiﬁcation, regression and the second one attribute & feature selection. Three are the mainly types of
approaches to cope with multi-objective optimization:
• The lexicographic approach (not debated in this paper).
• The ranking queries (Top-k) approach that depend on the choice of weight in a scoring function for
ranking tuples.
• The skyline approach that uses the Pareto dominance to retrieve the best tuples that are not dominated
by any other tuple.
In the next sections is presented a description of each methods with their pros and cons and a comparison
with the newest Flexible Skylines approach.
2
Ranking queries
One of the most used approach for multi-objective optimization consists in transforming it into a single-
objective problem, assigning a numerical weight to each attribute (chosen from the dataset R) and combine
1

---

the values in a single one by adding or multiplying them. One common way to identify the top-k objects, is
by using a scoring function S and below is described its general formula [1]:
S = w1 × a1 + w2 × a2 + ... + wn × an
(1)
where wi = 1, ...n represents the weight associated to each attribute ai = 1, ...n.This approach is one of
the most used due to the fact that is possible retrieve the relative importance of attributes, control the
cardinality of the result and possibly reach a compromise among diﬀerent attributes [2].
The other side of the coin is that ranking queries depends on the choice of the weight in the scoring function
and this may require to repeat the task multiple times in order to ”predict” the eﬀect on ranking by changing
one or more parameters of the scoring function S(1).
Start
User chooses weights
for diﬀerent criteria
Run algorithm
Returns the top-k object
the best solution ?
Stop
No
Yes
Figure 1: Top-k query Flowchart
Another downside is that this approach suﬀers from scalability problems with respect to the database
size and the number of features [3].These approach touches diﬀerent ﬁelds such as caching with the purpose
of increasing data retrieval performance by reducing the need to access the next, slower tier of storage. It’s
also used in multimedia search, e-commerce, metasearch engines for the eﬃcient combining of rankings from
diﬀerent search engines and many other ﬁelds (ML, Recommended systems).
Top-k processing techniques can be classiﬁed into diﬀerent categories based on query model, data access
methods, implementation level, data & query uncertainty and ranking function.
The latter can also be divided in three sub-categories: the ﬁrst one, which includes the majority of current
techniques, assumes the usage of a monotone ranking functions; the second category make use of generic
ranking functions [4] and the third one leaves the ranking function unspeciﬁed(this leads to skyline queries)
[3, 5].
Example 1.1 Considering a user interested in ﬁnding a particular PC model in diﬀerent stores where the
cost of the Pc and the distance of the store is minimized. This is an example of a dataset with just two
dimensions: price and distance. The preference criterion in the scoring function tells exactly how the user
want to rank the object which is really a very important part of the problem.In a ﬁrst run the user set the
score function(e.g. Score = distance + 3 ∗price) and result show the t1 tuple as the top query. Then, with
2

---

the same data set, if the user computes the global score of these Pc’s with a diﬀerent criterion (for example
user weights seven times the distance as much as the price Score = 7 ∗distance + price ) then basically that
means that user explores this data set according to some other direction, so in this case the best Pc for the
user is another one (t3).
0
10
20
30
40
50
0
10
20
30
40
50
distance
price
Score = distance + 3 ∗price
Score = 7 ∗distance + price
t1
t2
t3
t4
t8
t6
t7
t5
Figure 2: example 1.1 Top-k query
As shown in the ﬁgure (2), if the scoring function is changed, also the preferences are changed then also
the result is diﬀerent and this is a rather important topic because there are datasets and problems in which
the preference criterion is really crucial and even very small changes in that, might determine big changes
in the result.
So the result of the query heavily depends on how the user preferences are translated in the choice of weights
in the scoring function. This is a very hard task due to the fact that it’s diﬃcult to predict the eﬀect of
changing the wights on the ﬁnal ranking result and thus fail to oﬀer an overall view of the dataset.
Also the user cannot quantify with absolute precision the relative importance of the diﬀerent attributes
[6, 7, 8].
3
Skyline queries
The objective of this approach is to return all the non-dominated tuples.This is also known as a maximal
vector problem [5] which that aims to identify the maximals over a set of vectors, or more speciﬁcally, ﬁnd
the subset of vectors where each one is not dominated by any other vector in the set [9].
With this approach, instead of transforming a multi-objective problem to a single one, a multi-objective
algorithm is used for solving the original multi-objective problem. This is also called the Pareto dominance
approach [10], where in a dataset R, a tuple t is said to dominate a tuple s if and only if exists at least an
attribute of t that is greater then the same attribute of s and if all the attributes of t are greater than or
equal to the respective attributes of s. In a more formal approach [1]:
SKY (R) = {t ∈R | ∀s ∈R, s̸ = t, ∃ai(t(ai) > s(ai) ∧∀ak, k = 1, ...n, t(ak) ≥s(ak))}
(2)
With respect to ranking queries, the skyline approach has the advantage of simplicity and easy of use, due
to the fact that there is no weight parameter to be set by the user [1] and even if the scoring function is not
known, the highest scoring tuple is guaranteed to be in the skyline.
3

---

Even if there is high probability that the query may retrieve too many object as result (cardinality issue
and lack of customization in controlling the number of outputs), this gives to the user diﬀerent solutions
that allows him/her to analyze diﬀerent trade-oﬀs (Figure 3) associated with diﬀerent criteria and choose
the best solution a posteriori [7, 1].
Start
Run the algorithm
Returns all non-dominated
tuples/solutions
User chooses the best solution
according to his/her
preferences a posteriori
Stop
Figure 3: Skyline query Flowchart
Example 1.2 Taking the same example used for top-k queries, there is the same dataset with normalized
attribute values, but instead of deciding which one is the best object, which one is the second best and so
on and so forth, the query returns which ones are those that might be the best options for at least one
preference criterion and in particular the black points in the skyline area are those that are potentially the
best ones for some criteria and that are not dominated by any other point.
0
0.2
0.4
0.6
0.8
1
0
0.2
0.4
0.6
0.8
1
skyline
non-skyline
distance
price
t1
t2
t3
t8
t5
t4
t6
t7
Figure 4: example 1.2 Skyline query
In the example (Figure 4) if the user gives a lot of importance to distance, then the black point in the
left upper part would be the best option although it has a high price. The lower-right black point is instead
4

---

the best option if user gives a lot of importance to price although it has a high distance.
White ones are points that are certainly not the best options because they are dominated by at least one of
the black points, so they can never be the best option no matter what preference criterion user chooses and
this kind of query is called a skyline query because it kind of oﬀers the peaks in a dataset that give user a
nice overview of what is potentially interesting in a dataset.
4
Restricted Skylines
As said in the previous sections, ranking and skyline queries have their own weaknesses: ﬁrst of all, Top-k
retrieves the top best objects but the choice of the right weights in the scoring function is a complex problem
for the user, cause each weight is usually empirically determined. Additionally, the user must pay attention
in comparing, in the scoring function, only commensurable criteria in order to avoid meaningless results or
quantities [1].
Skyline approach instead, suﬀers from cardinality issue, such that the user itself cannot control the output
dimension and his/her preferences cannot be satisﬁed due to the fact that this approach returns a set a
non-dominated solutions, whereas in practice the user will often use a single best one.
A novel skyline approach for multi-objective optimization, called Flexible Skylines (aka F-skylines) aims to
combine pros of ranking and skyline queries and capture the user preferences or model priority criteria by
means of arbitrary constraints on the space of the weights without the hard task of specifying weights in a
score function.
This original framework is aware of users’ criteria by means of constraints on the weights used in a scoring
function [6] and for this purpose the concept of F-dominance is lead.
A tuple t is said to F-dominating a tuple s when t is always better than or equal to s with respect to
all the monotone scoring functions that belong to a limited set F of monotone scoring functions [6, 11, 2].
More generally, if the normal skyline approach consider the dominance (maximal vector problem or Pareto
dominance)[5] over a set M of monotone scoring functions, the F-skylines apply the same method but on a
subset F of M.
Taking into account a relational schema R with A attributes R(A1, ...Ad) with d ≥1 with normalized
attributes values in range [0, 1] and the instance r ∈R, skylines and F-skylines are described in a more
formal approach as follows:
SKY (r) = {t ∈r | ∃f ∈M.∀s ∈r.s̸ = t →f(t) < f(s)}
(3)
F −SKY (r) = {t ∈r | ∃f ∈F ⊆M.∀s ∈r.s̸ = t →f(t) ≤f(s)}
(4)
The F-dominance concept in notation (4) can also be written as t ≺F s.
The F-skylines also introduce two ﬂexible operators which both return a subset of the skyline: ND and
PO operators. The ﬁrst refers to the set of non-F-dominated tuples and the second one to the potentially
optimal tuples [6, 11, 2].
As said in [6], for any set F of monotone scoring functions, ND is a subset of the skyline and PO is a subset
of ND and both parameters reduce the size of the ﬁnal result (cardinality).
The high ﬂexibility of this operators allows to solve the multi-objective function problems, retrieving the top
one query and also constraint the scoring function and being very eﬀective on large datasets.
5

---

Start
User choose constraints on weights
need precision?
Run ND algorithm
Run PO algorithm
Returns the ND tuples
Returns the PO tuples
the best solutions?
Stop
no
yes
yes
no
Figure 5: F-skyline query Flowchart
As shown in the ﬂowchart (5), the result of the query may be quite diﬀerent, according to choice of the
constraints and the desired operator: select the ND will return a set of non-dominated tuples; however It
will be more precise than the classic skyline approach due to the fact that the result set is a subset of the
latter(SKY).
Selecting the PO instead, will return as result a subset of ND, containing only the potentially optimal
solutions (tuples), that are strictly better than all the others. This is true for any set F of monotone scoring
functions [6].
Example 1.3 Using F-skylines framework over the same dataset used for the previous examples, the user’s
preference can be translated into a constraint on weights of the scoring function [6, 11] (e.g. set of monotone
scoring function F = {wp ∗price + wd ∗distance | wp ≥wd} ) where the price aﬀects more than distance
(e.g. wp = 0.9, wd = 0.1).
6

---

0
0.2
0.4
0.6
0.8
1
0
0.2
0.4
0.6
0.8
1
distance
price
t1
t2
t3
t5
t4
t6
t7
t8
SKY \ ND
ND \ PO
PO
Figure 6: example 1.3 F-Skyline query
As shown in the ﬁgure (6), the F-Skyline, instead of showing only the non-dominated tuples, as said
before, the user can translate the preference (e.g.
in price) into a constraint on weight of the scoring
function. In such case t1,t2,t5 are the non-dominated tuples (Pc’s) and t3 belongs to the SKY even if It’s
F-dominated by t5, since It has an higher price.
Between the potentially optimal PO t1,t5, the ﬁrst one would be the best choice (the teal colored line)
if the user gave a lot of importance to the price (i.e.wp = 0.8, wd = 0.2).On the other hand, t5 would
be the best option if the user gave the same importance (the brown colored line) to price and distance
(i.e.wp = 0.5, wd = 0.5). Tuple t2 is ND but not PO since there is no combination of weights that satisﬁes
the initial constraint wp ≥wd and that makes it the best choice over any other tuple.
4.1
Comparison
General skylines consist in retrieving the maximals or admissible points (maximal vector problem) of a
monotone scoring function and even if it’s unknown by the user, the set of non-dominated tuple is guaranteed
to be in the skyline.
The general issues with this approach are essentially three:
1. It’s an high cost operation.
2. The cardinality of the output is out of control for the user and this might be useless or not informative
enough for choosing the best ﬁnal option.
3. Also, the limit of this approach is that it assigns the same importance to all attributes and can’t
represent user’s preferences.
F-skyline approach instead, uses a scoring function on a subset of a monotone scoring functions, and con-
straining the weights, allows the preference elicitation of the user [12].The F-skyline operator (ND & PO)
are very eﬀective in focusing on the tuple of interest for the user, and can lead to a considerably smaller
result (reducing the cardinality problem of standard skylines) and the more the constraints are restrictive,
the more the results of both ND and PO reduce [6].
A possible common problem for both approaches, is the normalization of diﬀerent quality attributes: choos-
ing the right method (min-max,z-score, decimal scaling, etc...) can be aﬀected by an inductive bias that
7

---

would prioritize one solution (or interpretation) over another, independent of the observed data.Top-k ap-
proach instead, solves a multi-objective problem, transforming it in a single-objective one and using a scoring
function to retrieve the top-k objects, turning out to be more representative of user preferences with respect
to standard skyline queries and even if It has the advantage of conceptual simplicity and easy of use, it can
lead to uncertain results, due to the fact that the user has to specify exact weight values without knowing
how they condition the ﬁnal output.Sometimes, the uncertainty is upstream represented by the very own
values of the dataset due to human/sensor error and this is a problem for determining the right ordering of
Top-k result [8, 13].
F-skyline approach instead, solves the problem of the empiric estimation of weights, by constraining them to
a subset of a monotonic scoring function F.Regarding the uncertainty of the data, the latter query approach
can deal with this by learning weights via crowdsourcing tasks and reducing the uncertainty, modeling it as
constraint on wights of the scoring function [13].
A possible common problem for both approaches, might be the right choice of commensurable criteria that
have to be added/subtracted in the scoring function, cause comparing diﬀerent attributes can produce a
meaningless quantity that is essentially useless for the ﬁnal user’s choice.
4.2
Area of applicability
Possible application areas of Flexible skylines are where the ranking problem is relevant and the following
list displays only few of the dozens possible diﬀerent ﬁeld of applicability, most of which are discussed in
[14, 15].
1. Search engines: for example if a user want to book an hotel or a restaurant or search for a new car,
this approach can express several diﬀerent criteria that match user’s preferences (multiple criteria →
multi-objective optimization), so the goal of the search engine is to propose to the user those options
that best match his/her criteria. This approach is also found in e-commerce where the user search for
diﬀerent articles based on his/her preferences.
2. Machine-learned ranking (MLR) or learning to rank, where F-skylines could improve the quality of
ranking models for information retrieval.
3. NLP with Text mining & Sentiment Analysis: text pre-processing and feature selection are crucial
steps in text mining and F-skyline could improve text classiﬁcation accuracy, giving a competitive
advantage in business over competitors.
4. Recommender systems: algorithms that mimic the psychology and personality of humans, in order to
predict their needs and desires.
Retrieve diﬀerent user’s preferences on his past searches or usages of the service, aggregate diﬀerent
recommendations and generate a global one that combines diﬀerent criteria.
5. Feature Selection: when the number of features in the dataset is very large, It may contain a lot of
noisy data and the more relevant and sensible features user select for the model creation, the faster
is the output and the better is the accuracy of the model and reasons for using F-skyline approach in
feature selection are[16]:
(a) Enable the ML algorithm to train faster.
(b) Reduce the complexity of a model and makes it easier to interpret.
(c) Improving the accuracy of a model.
(d) Reduce overﬁtting.
Some more speciﬁc examples could be:
1. Labeling similar images that later are fed into Neural Network for images recognition (g.e. useful for
self driving vehicles, faster and more accurate facial recognition,...).
2. Credit institutions that use users’ criteria for ﬁnding the best candidates,the ones that would potentially
get a loan and the ones which wouldn’t.
8

---

3. Better ranking of players in lobbies in online video games matches.
4. Improve anti-cheat systems always in online videogames.
5. Identify genes relevant to disease in Bioinformatics.
6. Drug discovery: identify the most promising structure in a chemical library.
7. Detecting Malwares.
8. Improving sound classiﬁcation in Automatic Speech Recognition applications (ASR).
9. Rank all Tweets, Instagram & Facebook posts and improve the timeline composition in reverse chrono-
logical order.
5
Conclusion
Top-k, skyline and F-skyline approaches has been surveyed: starting from multi-objective optimization and
the maximal vector problem (or Pareto dominance), the description of each method has been provided with
its respective pros and cons. By comparing them, comes to light how Flexible skylines approach overcomes
the weaknesses of Top-k queries, giving the possibility of constraining the weights of the scoring function
and of normal Skyline using the ND & PO operators and reducing the cardinality of the result, taking into
account the user’s preferences and criteria.
References
[1] Alex A. Freitas.
A critical review of multi-objective optimization in data mining: a position pa-
per.
ACM SIGKDD Explorations Newsletter, Volume 6(Issue 2):77–86, December 2004.
DOI:
https://doi.org/10.1145/1046456.1046467.
[2] Davide Martinenghi Paolo Ciaccia.
Reconciling skyline and ranking queries.
In Proceedings of the
VLDB Endowment, Volume 10, Issue 11, August 2017, pages 1454–1465. Proceedings of the VLDB
Endowment, 2017. DOI: https://doi.org/10.14778/3137628.3137653.
[3] Mohamed A. Soliman Ihab F. Ilyas, George Beskales. A survey of top-k query processing techniques in
relational database systems. ACM Computing Surveys, Volume 40(Issue 4):1–58, October 2008. DOI:
https://doi.org/10.1145/1391729.1391730.
[4] Yidong Yuan, Xuemin Lin, Qing Liu, Wei Wang, Jeﬀrey Xu Yu, and Qing Zhang. Eﬃcient computation
of the skyline cube. In In Proceedings of the 31st International Conference on Very Large Data Bases,
page 241–252. DBLP, 2005. DOI: https://doi.org/10.1007/s13369-016-2048-z.
[5] K. Stocker S. Borzsony, D. Kossmann.
The skyline operator.
In Proceedings 17th Interna-
tional Conference on Data Engineering,2-6 April 2001,
pages 421–430. IEEE, 2002.
DOI:
https://ieeexplore.ieee.org/abstract/document/914855#:~:text=10.1109/ICDE.2001.914855.
[6] Davide Martinenghi Paolo Ciaccia. Flexible skylines: Dominance for arbitrary sets of monotone func-
tions.
ACM Transactions on Database Systems, Volume 45(Issue 4):1–45, December 2020.
DOI:
https://doi.org/10.1145/3406113.
[7] Bo Tang Kyriakos Mouratidis, Keming Li. Marrying top-k with skyline queries: Relaxing the preference
input while producing output of controllable size. In SIGMOD/PODS ’21: Proceedings of the 2021
International Conference on Management of DataJune 2021, pages 1317–1330. Proceedings of the VLDB
Endowment, 2021. DOI: https://doi.org/10.1145/3448016.3457299.
[8] Bo Tang Kyriakos Mouratidis. Exact processing of uncertain top-k queries in multi-criteria settings. In
Proceedings of the VLDB Endowment, Volume 11, Issue 8, April 2018, pages 866–879. VLDB, 2018.
DOI: https://doi.org/10.14778/3204028.3204031.
9

---

[9] Jarek
Gryz
Parke
Godfrey,
Ryan
Shipley.
Algorithms
and
analyses
for
maximal
vec-
tor
computation.
The
VLDB
Journal,
Volume
16(Issue
1):28–16,
January
2007.
DOI:
https://doi.org/10.1007/s00778-006-0029-7.
[10] Niccolo’
Meneghetti
Jan
Chomicki,
Paolo
Ciaccia.
Skyline
queries,
front
and
back.
ACM
SIGMOD
Record,
Volume
42(Issue
3):6–18,
September
2013.
DOI:
https://doi.org/10.1145/2536669.2536671.
[11] Davide Martinenghi Paolo Ciaccia.
Beyond skyline and ranking queries:
Restricted skylines (ex-
tended abstract).
In Beyond Skyline and Ranking Queries:
Restricted Skylines (Extended Ab-
stract),SEBD 2018, June 24-27, 2018, Castellaneta Marina, Italy, pages 1–8. SEBD, 2018. CEUS-WS:
https://http://ceur-ws.org/Vol-2161/paper20.pdf.
[12] Jan Chomicki Denis Mindolin. Preference elicitation in prioritized skyline queries. The VLDB Journal,
Volume 20(2):157–182, 2011. DOI: https://doi.org/10.1007/s00778-011-0227-9.
[13] Davide Martinenghi Eleonora Ciceri,
Piero Fraternali and Marco Tagliasacchi.
Crowdsourc-
ing for top-k query processing over uncertain data.
In IEEE Transactions on Knowledge and
Data Engineering,
Volume:
28,
Issue:
1,
Jan. 1 2016),
pages 41–53. IEEE, 2016.
DOI:
https://doi.org/10.1109/TKDE.2015.2462357.
[14] Wagner Meira Jr. Mohammed J. Zaki. Data Mining and Machine Learning: Fundamental Concepts
and Algorithms. Data Mining and Machine Learning. Cambridge University Press, 2020.
[15] Lingfeng Niu Jianyu Miao. A survey on feature selection. Procedia Computer Science, Volume 91(Issue
1):919–926, 2016. DOI: https://doi.org/10.1016/j.procs.2016.07.111.
[16] Marcos V. N. Bedo, Paolo Ciaccia, Davide Martinenghi, and Daniel de Oliveira. A k-skyband approach
for feature selection. In Giuseppe Amato, Claudio Gennaro, Vincent Oria, and Milos Radovanovic,
editors, Similarity Search and Applications - 12th International Conference, SISAP 2019, Newark, NJ,
USA, October 2-4, 2019, Proceedings, volume 11807 of Lecture Notes in Computer Science, pages 160–
168. Springer, 2019.
10

---

