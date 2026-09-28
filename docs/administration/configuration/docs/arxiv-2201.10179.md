# Flexible skylines, regret minimization and skyline ranking: a comparison to know

> 来源: https://arxiv.org/pdf/2201.10179

Flexible skylines, regret minimization and skyline ranking: a
comparison to know how to select the right approach
Vittorio Fabris
Politecnico di Milano
Milan, Italy
vittorio.fabris@mail.polimi.it
Abstract
Recent studies pointed out some limitations about classic top-k queries and skyline queries. Ranking
queries impose the user to provide a speciﬁc scoring function, which can lead to the exclusion of interesting
results because of the inaccurate estimation of the assigned weights. The skyline approach makes it
diﬃcult to always retrieve an accurate result, in particular when the user has to deal with a dataset
whose tuples are deﬁned by semantically diﬀerent attributes. Therefore, to improve the quality of the
ﬁnal solutions, new techniques have been developed and proposed: here we will discuss about the ﬂexible
skyline, regret minimization and skyline ranking approaches. We present a comparison between the three
diﬀerent operators, recalling their way of behaving and deﬁning a guideline for the readers so that it is
easier for them to decide which one, among these three, is the best technique to apply to solve their
problem.
Keywords: top-k queries, skyline queries, ﬂexible skyline, regret minimization, skyline ranking
1
Introduction
Nowadays, databases contain lots of data. The user who looks for some information aims to retrieve the
best solutions that the database contains with respect to some preferences. However, providing in the exact
way the most suitable tuples for the case is not always a simple task.
Based on their request, the deployment of multi-criteria decision-making tools helps users to retrieve the
best available results in the database. For this reason, users should select the most appropriate approach
according to the current situation, so that they are guaranteed to get the ﬁnest answer for their query. In
fact, during the last decades several diﬀerent techniques have been proposed in literature. Remarkable ones
are the top-k query, the lexicographical approach and the skyline query.
Top-k queries extract the top-k objects from the database based on a scoring function. The score of an
object is based on its characteristics, which means that the values of its attributes contribute to the overall
score amount. The most simple and commonly used scoring function is the weighted-sum function: each
attribute contributes in a diﬀerent way according to some delineated weights that have been set a priori,
usually by the users. The tuning weights operation needs to be very precise because even a small variation
in the assigned values can deeply change the ﬁnal ranking. Most of the times users do not precisely know
what eﬀort to assign to the attributes, compromising the ﬁnal result and retrieving something that can be
far from the real best result that they could have extracted from the database. The same parameter tuning
process could be repeated multiple times to average the retrieved rankings, but this means to waste time
and resources.
What’s more, the weighted formula approach can also mix diﬀerent non-commensurable attributes into the
same instance: values that cannot be compared are included in the same computation and this leads to an
1
arXiv:2201.10179v2  [cs.DB]  30 Jan 2022

---

incoherent result, going against the principle for which in data extraction processes the retrieved information
should always be accurate and understandable to the users [18].
For this reason, lots of studies proposed new diﬀerent algorithms that deal with the ineﬃciency [33] and the
imprecisions carried by this method, tackling them through diﬀerent techniques, as explained also in [20].
The performances of this kind of approach have improved, but the drawbacks pointed out before are still a
considerable component that aﬀects the problem.
In the lexicographical approach it is established a priori a linear priority order among the attributes. This
means that between two tuples, the one with the best value in the highest priority attribute is preferred
to the other. This happens even if all the other attributes of the ﬁrst tuple show worse values, having no
possibility to compensate. This highlights the fact that, as it happens when using the weighted-formula, the
lexicographical approach deals with the so called missed opportunities [19]: it can happen that the real best
result is not provided to the users.
Skyline queries are based on the Pareto approach, introduced in [5], whose goal consists into selecting all the
possible non-dominated tuples in the database. In particular, a tuple t1 is dominated by a tuple t2 if the
values of all the attributes of t2 are better or equal than the ones of t1, but at least one is better. However,
since this method does not make a distinction among the retrieved tuples in the solution, it is up to the
users to select the one that best suits their purposes. When the cardinality of the database is huge and the
attributes are diﬃcult to compare to each other, it is very likely that the proposed solution is heavy from
the point of view of the number of retrieved tuples. Of course, this makes hard for the users to select the
best case to solve their problem, as directly documented also in [26].
The limitations described before among all the diﬀerent approaches lead the research community to im-
prove the existent techniques, developing new algorithms and procedures.
The main purpose of this survey is to focus on some of these techniques, explaining how they work and their
inner properties. Then, a comparison between them is made so that the readers can decide which is the
approach that best suits their situation.
The exploited techniques are:
• Flexible skyline;
• Regret minimization;
• Skyline ranking.
The rest of the paper is organized as follows. Section 2 presents the ﬂexible skyline and the concept of
F-dominance, with the related properties and algorithms that characterize them; Section 3 recalls the no-
tions about the regret minimization approach, while Section 4 introduces to the world of the skyline ranking
queries. Then, a comparison between the three approaches is made in Section 5, and the ﬁnal considerations
are made in Section 6 to conclude the paper.
2
Flexible Skyline
As it has been pointed out before, it is diﬃcult for the users to guess and set the right value for the weights
in a scoring function. What’s more, considering only ranking functions instead of skyline techniques or vice
versa does not lead to precise results. For this reason a mix between the two approaches helps to reduce the
drawbacks that one technique carries when it is used alone, compensating the ﬁnal result and retrieving a
better representation of what the users expects from their query.
This is the reason why the authors in [10] introduced the notion of ﬂexible skyline queries: taking into
account the diﬀerence of importance between the attributes, users do not have to set the precise values for
their weights, but it is suﬃcient that they formulate some constraints to state and bound the relationships
that exist between them. This allows us to introduce a higher ﬂexibility in the system, which gives the ﬁnal
result more chances to contain the tuple that the users are looking for and, at the same time, to avoid the
risk of providing the whole database as a solution.
2

---

For a more detailed introduction to F-skylines, the reader should refer to [10], while here are only reported
its main concepts to allow a global understanding of their main characteristics.
The main node about this type of queries is the concept of F-dominance: a tuple t1 F-dominates another
tuple t2 when t1 is always better than or equal to t2 according to all the scoring functions in a certain
family F. The set F contains multiple scoring functions, which are all taken into account so that even an
incomplete or approximated ﬁrst evaluation of the attribute’s weights is covered by one of them. In this
framework, two operators have been introduced in order to characterize the set of non-F-dominated tuples
(i.e., ND) and to address the tuples which are potentially optimal according to some function in F (i.e., PO).
A practical example can help the reader to better understand the concepts that have just been pre-
sented. We consider the situation where the players of a football team want to deﬁne who is the most
valuable player among them.
We consider their statistics of goals and assists during their last winning
season.
The classic skyline, as shown in Figure 1, demonstrates that Harry, Sam, Andrea and Samuel
contributed signiﬁcantly for the ﬁnal win of the championship, while Thomas, Robert and Alex have been
excluded from the ﬁnal result because they have been dominated by their teammates. Then, we consider the
same dataset and apply the Flexible Skyline approach: F is the set of linear scoring functions of the form
MostV aluablePlayer = w1 ∗Goals + w2 ∗Assists such that w1 > w2. The PO result that contains the
set of potentially optimal tuples is composed by Harry and Sam (Thomas is still dominated). As we were
expecting, the result size is smaller than the one of the classic skyline applied at the beginning, and we can
better identify who should ﬁnally run for the Most Valuable Player title in the team.
Figure 1: Skyline of the most valuable players of a football team
F-skylines may seem to be equivalent to other developed approaches available in literature. In the following
lines, we want to clarify their way of behaving, comparing them to other known techniques. Some examples
where the F-dominance approach is applied are treated too, so that an idea about how they can be exploited
can be useful for the user’s experience.
As well as F-skylines, prioritized skylines [27] reduce the size of the result following the user’s preferences.
However, the way the attributes’ preference is expressed is diﬀerent, because instead of a set of constraints
that regulates the importance between each other, a strict priority between them exists. For this reason, the
ﬁnal tuple extraction shows a lower ﬂexibility into the selecting process. Some of the tuples that could fulﬁll
the user’s requirements are not selected because of the current order of the attributes, and no compensating
operation is performed in order to recover them.
The same words can be spent for the restricted skyline introduced by [2], where, thanks to the application
of the Weak Pareto Dominance condition and due to pruning actions and prime cuts [3] performances, the
tuples can be removed if they do not ﬁt with the user preferences with respect to a partial order instantiated
between the attributes.
We would like to highlight the fact that the constraints that are set for the ﬂexible skyline are not made
directly on the speciﬁc domain that an attribute can have, reducing the research ﬁeld of the constrained
3

---

dimension, as it happens in [14] and in [15], where a condition to reduce the size of the operands involved
in the computation is expressed to deploy an algebraic optimization operation that reduces the overall costs
of the procedure. F-skylines share with the classic skylines the capability to provide an overall view of
interesting results, without limiting the domain of a dimension, but allowing the data analyst to focus on
speciﬁc parts of the skyline, depending on the user preferences. The framework is able to express prefer-
ences like “attribute a1 is more important than attribute a2, but no more than twice as important” [13].
Therefore, this approach is also diﬀerent to the ones which assume to give the attributes a weight based
onto a probabilistic function, such as in [35]. It is now easy to see that neither the ε-skyline [39] or the thick
skyline [21] deal with the problem in the same way that the F-skyline does. While the former two control
the cardinality of the ﬁnal result, which can be regulated with respect to the user needs, they do not care in
the same way about the user’s attributes’ preference as the latter one. Dynamic skylines [32, 22] exploit a
diﬀerent perspective, because while they both deal with multiple scoring functions, they consider them for
diﬀerent purposes: dynamic skylines deal with build-up tuples based on the original data and transformed
through a certain function; ﬂexible skylines deal with an inﬁnite set of scoring functions and the concept of
F-dominance includes them all at the same time when points are evaluated.
Concerning F-skylines, the authors in [10, 11, 13] introduced diﬀerent algorithms implementing the ND
and PO operators with the aim of extracting the ﬂexible skyline with respect to the set of scoring functions
F. The reader is invited to check Resource [13] to read the details about the time and space complexities of
the exploited procedures.
In [12] the authors develop another algorithm based on the concept of F-Dominance, with the aim of sourcing
the top-k tuples from a database. In this scenario, not all the weights for the attributes are known and there-
fore more than a single scoring function needs to be considered in order to be sure that users get what they
are looking for. FSA, which is based on the Fagin’s Algorithm (FA) [16] and on the Threshold Algorithm
(TA) [17], proves to be able to keep the cardinality of the result to a reasonable value and outperforms other
similar reference procedures, gaining a performance level that can be compared to the one of the classical
top-k queries.
Mouratidis and Tang introduced the concept of uncertain top-k queries (UTK) [29], where they decide to
face the problem of the estimation of the weights by extending the usual speciﬁc vector to a broader region.
Two algorithms are proposed and they are both based on the notion of F-dominance. In this scenario,
where weights are not well-deﬁned because we are talking about their area of pertinence and not about their
speciﬁc value, it can happen that a record might dominate another due to its wider boundaries (not limited
to a ﬁxed value, as it happens in the traditional way) and then we’re allowed to prune the useless tuples.
In [36] it is highlighted the fact that the problem belongs to the RP group, since its preference input is a
region R and gives as output the top-k results for the query (as points P).
In conclusion, we can say that the user that wants to retrieve information in a ﬂexible way, interacting
with the problem by setting (even partially) the weights for the parameters involved in it, retrieving a ﬁnal
outcome which considers all the dimensions of the problem and that is presented in a form that reminds the
one of the classic skyline, can ﬁnd the concept of F-dominance very interesting for his application.
3
Regret Minimization
The regret minimization approach has been introduced by Nanongkai et al. [31] to reduce the drawbacks
given from both classic top-k and skylines techniques highlighted in previous sections, while trying to take by
its side the beneﬁts that the same methods can oﬀer, such as the possibility to provide a controlled number
of interesting tuples without stressing the user to deﬁne the perfect scoring function.
The regret minimization performs a computation to extract a representative subset of the database so that
for any preference vector that users would set when deploying other techniques, the top ranked points in
the subset are a good approximation of the top ranked items in the whole database, fulﬁlling the users’
expectations and interests.
Therefore, it is possible to deal with something which is smaller than an eventual result proposed by the
4

---

application of a classic skyline algorithm. In particular, given a database D and the desired output size k,
the ﬁnal goal is to ﬁnd a set of k tuples that minimizes the maximum regret ratio [31]. This means that,
while having no information about the users’ preferences, the algorithm tries to satisfy the most part of
them reducing at its minimum the percentage of the unsatisﬁed ones. A user is not regretful with a given
subset if his/her regret ratio is close to zero, since the highest utility in the subset is close to the best utility
in the dataset. [9] introduces the concept of k-regret-minimization, relaxing the initial condition where the
regret ratio denoted how far from the best score in the dataset is the best score in the subset: the preference
scores of the best tuple in the subset is then compared with the users top-k choice.
The regret minimization query (RMS) is scale-invariant, because the regret ratio does not change if we
scale each point of the dataset for a certain factor. In fact, the computation of the regret is performed
as a ratio, and therefore the scaling operation has no eﬀect on the ﬁnal output. What’s more, the RMS
is said to be stable. When a junk point (i.e., a point that shows never into user’s preferences and will be
never considered into the RMS generated subset because it does not have an high utility for any considered
function) is added or removed from the dataset, the regret amount does not change.
Research in this ﬁeld tried to maximize the possible achievable rewards thinking about guaranteeing the best
possible regret ratio in order to satisfy the users’ preferences. However, if we want to go a little bit more
into the details, in [30, 42] the authors pointed out that if the database has p points, it is not possible to
guarantee a maximum regret ratio better than Ω(p−
2
d−1 ), where d is the dimension of the problem.
Searching for an optimal solution for RMS, which is to ﬁnd the minimum size set for which a certain regret
ratio ε is guaranteed, [9] demonstrated that it was a NP-hard problem, and then [7] and [1] supported this
conclusion for dimensions d > 2.
We do not spend so much time to group here the algorithms that are used to solve the RMS problem,
as it is not the main purpose of this paper. The reader can ﬁnd a good reference in [40], where diﬀer-
ent state-of-the-art methods are presented and reviewed. They describe and compare diﬀerent procedures,
covering a full range from the ones that interactively deal with the user (e.g., [30, 41, 45]) to the ones
that greedily approximate solutions for the high-dimensional scenarios, where deterministic solutions are
not available (e.g., [40, 23]), and comment on their way of behaving and their performances with respect to
classic skylines or top-k queries.
In the end, just to focus a little bit more on the pragmatic aspects of this technique, we can reason about
some possible applications of it.
We can recall the same scenario mentioned in the previous Section 1.
Through Figure 2, we can show to the reader some practical results of the problem, tackled with the regret
minimization approach, highlighting the regret ratios obtained considering some speciﬁc functions.
Figure 2: Example of the regret ratio results for a subset of the football players problem. In this scenario,
the last function guarantees that with the selected subspace the user will not be regretful at all because the
solution contains the best tuple possible in the database.
Otherwise, we can think about other possible applications that well-ﬁt with this kind of approach, e.g.,
5

---

someone who is doing a research or a survey on a particular subject and who wants to see which are the
preferences of a certain population in a speciﬁc ﬁeld. Researchers may want to choose this method because
it aims at ﬁnding the best result so that every user preference is covered. This is guaranteed by the fact
that the extracted results are not based on a speciﬁc scoring function, but they try to satisfy all the people
involved in a broader way. The results retrieved from this analysis can be used in a second moment, to
deﬁne marketing speciﬁcations so that a product can be designed to be sold to a larger amount of people
and guaranteeing a higher ﬁnal income.
4
Skyline Ranking
The capability of proposing to the user an ordered list of the most satisfactory results for his research has
always been a fundamental task to solve and whose performances should be improved as much as possible.
Ranking data in a good way allows the user to spot and use in a quicker way the needed information.
We can think about how ranking techniques have successfully been applied in the web search ﬁeld [6] or
simply when we’re doing a keyword research in a database [4].
As the name suggests, skyline ranking aims to deploy an hybrid approach between the skyline and the top-k
ordering techniques. In fact, the goal of skyline ranking is to extract the interesting skyline points from a
dataset and rank them based on the utilities they provide. The more points in diﬀerent subspaces a point
dominates, the more important it is and therefore is very likely to ﬁnd it in the ﬁnal ranking. Subsets are
intended as subsets of attributes of the global space. So, this meaning is basically diﬀerent to the one of
subsets of points contained in the dataset, as for example it has been exploited in G-Skyline queries [24] or
their variants (e.g., FGSky queries [43]).
[38] considers that the interestingness of a point is higher if it dominates many other important skyline points
in diﬀerent subspaces, and it is even more relevant when the dominated ones also dominate other points in
other subspaces. This concept is very close to the one of the skyline frequency [8], where the more times
a point shows in a subset’s skyline, the more probability it has to be in the main skyline that deﬁnes the
set. The SKYRANK method presented in [38] considers this idea and improves its technical behavior, as
it does not care so much about the so called extreme points (i.e., the skyline points of the one-dimensional
subspaces), producing a very nice result. The skyline graph is a useful tool that allows us to order all of the
interleaving relationships between subspaces and skyline points, so that even in the absence of a preference
function given by the user this approach perfectly works.
We can say that the classic SKY RANK approach is basically diﬀerent with respect to other techniques
that hybridize the skyline and top-k queries approach. In fact, approaches like [28], where we can ﬁnd the
attempt of controlling the cardinality of the output and give to the users the most relevant results for their
research based on a certain deﬁned preference vector, do not completely ﬁt with the SKY RANK’s main
idea. However, the basic version of it can be extended to handle top-k preference skyline queries when the
user preferences are available.
Skyline cubes [44] help in doing the job, allowing the algorithm to eﬃciently select only the possible non-empty
subsets of the global dataset saving time in the computation and enhancing then the overall performance.
[25] takes advantage of partitioning the global dataset and introduces the notion of size constrained skyline
queries, which are able to retrieve k desirable points from the d-dimensional dataset: the skyline ordering
approach creates a skyline-based partitioning of the points and instantiates an order among such partitions.
It has been proved that skyline ordering enhances the general performances of the constrained skyline query
[34]. Then, when selecting the k points of the result, this approach progressively considers the points of the
partitions in the order that is in force between them. When the k points are retrieved, the last partitions are
pruned. Points are not evaluated one by one according to a speciﬁc mapping function and they are neither
taken all together selecting the best ones in order to maximize an overall score that shows the greatness of
the retrieved result, because it would be computationally expensive. So, points are organized in batches and
then ranked one after the other, balancing the two approaches just presented.
As it has been mentioned above, visiting all the points of the skyline introduces some drawbacks from the
performance point of view. For the same reason, the IR-style ranking mechanism presented in [37] improves
6

---

the initial na¨ıve behavior, which implied the full scan of the set, by discarding as soon as possible the points
that for sure will not be included in the ﬁnal result to present to the user. In addition, [37] shows that even
if without making a proper division of the dataset into multiple subspaces, the ranking idea where the points
which are dominated the less by the others have an higher value is preserved.
To understand the steps that this kind of approach requires to be working, we can set up a basic ex-
ample. Considering the situation presented in Figure 1, we complete the scenario introducing other data
that allow us to extend the number of subspaces of the problem. In addition to Goals and Assists we intro-
duce the Dribblings performed by each player. Figure 3 shows the relations between the diﬀerent players,
and provides a diﬀerent skyline with respect to the one analyzed in the previous example. The computation
of the skyline graph allows to determine the dependences between dominated and dominating points: points
that have only outgoing edges are dominated by the ones they are pointing to, while points that have only
incoming edges are dominating points and are belonging to the skyline of that subspace. After the skyline
graph construction, link-based ranking techniques are applied in order to assign the score to each vertex (i.e.,
skyline point). For example, as it happens with web pages, we can think that the edge of the skyline graph
transfers some importance to the pointed items: skyline points that dominate many other skyline points,
which in turn dominate other points in some subspaces, at the end are highly ranked. Therefore, we can
explain why the value amount of Samuel is lower than the one of Sam and Harry: while the former belongs
only to one of the two skylines of the analyzed subspaces, the latter two are not dominated in both of the
two skylines. This justiﬁes the diﬀerent values of their ﬁnal scoring and their ﬁnal positions in the ranking.
(a) Skyline of subspace {Goals, Dribblings}
(b)
Skyline
graph
for
the
{Goals, Dribblings} subspace
(c) Final ranking
Figure 3
In conclusion, skyline ordering techniques and algorithms like SKY RANK can be very helpful when we
want to mitigate top-k and skylines’ drawbacks, but we still want to be sure to include all the dimensions
of the problem into our investigation and to beneﬁt of the pros of the two mentioned approaches. The ﬁnal
ranking that we obtain from the technique’s deployment improves our capabilities of analyzing the scenario
where we are operating. This allows us to have a clear and ordered representation of the best ways to solve
our problem and select the best item we are looking for.
5
Comparison between the diﬀerent techniques
Now that we overviewed the three diﬀerent techniques, recalled their way of behaving and main properties,
we can deﬁne in which situations and in which modalities the user can choose to use one method instead of
the other. In fact, while they have been shown to overclass more classic operators such as top-k and skyline,
some discriminants can be pointed out to decide that one is preferable to the other.
Table 1 helps to schematically sum-up and highlight the diﬀerences, the pros and the cons of each technique
that will be discussed more in the details in this section. Then, users will be able to address their research
towards a certain direction instead of another.
7

---

F-skyline
Regret Minimization
Skyline Ranking
Flexible input
✓
✓
✓
Mix top-k & skyline approaches
✓
✓
✓
Weight-based
✓
Multiple scoring functions
✓
User interaction
✓
possible
possible
Scale invariant
✓
✓
Stable
✓
✓
✓
Attribute order compensation
✓
✓
✓
k selection
✓
✓
Rank results
✓
All-d inclusive
✓
✓
✓
Uncontrollable output size
Partial imprecision of output
✓
Table 1: Main characteristics and properties of the studied operators. To have a full and complete explanation
of the table please refer to Section 5, where parameters are depicted with respect to each one of the three
analyzed techniques. The checkmark in a cell means that the property mentioned on the same row of the
left-most column of the table is satisﬁed by the selected approach.
As we have considered so far, all the three approaches improve the performances guaranteed by the top-k
and skyline operators. Features belonging to the two latter methods are considered at the same time, so
that the drawbacks that characterize them when they are used singularly are mitigated and the advantages
they carry are exploited at the same time. In addition, all the three surveyed techniques give the possibility
to provide a ﬂexible input that doesn’t stress users to deﬁne into the details the precise values of the eﬀorts
to assign to the discriminants of their problem.
In particular, from this last point of view some considerations about the F-skyline operator can be made.
When a comparison with ranking queries is made, while it increases the ﬂexibility, being able to control
the size of the result, they do not prevail on the other approach from the performance eﬃciency point of
view. Even if it lacks a satisfying general method of comparison, by taking into account that the scoring
function of the ranking queries approach is a single one while the results of the ﬂexible skyline are based
on a whole set, it has been shown that the top-k query retrieves more easily the interesting tuples than the
F-dominance-based approach: F-skylines pay the increased capability of returning interesting results at the
price of an higher computational overhead with respect to ranking queries [13].
Moving to another issue, we can consider the situation where we want to express our preferences about
properties (i.e., the attributes), because in our research we would like to concentrate on some aspects rather
than some others. Therefore, we might look for a solution that allows us to personalize the eﬀort that some
components have in the ﬁnal result, as it can be done when setting the values for the weights in the scoring
function in the top-k queries. As we have seen so far, ﬂexible skylines can perfectly ﬁt the situation too,
because we can set constraints on weights according to our preferences. For this reason, as it happens for the
two other approaches (i.e., regret minimization and skyline ranking), there is not a proper scoring function,
but we can say that a weight-based method is applied to guarantee to have not a lack of personalization
in the solution. In fact, the concept of F-dominance is applied with respect to a whole group of scoring
functions, not only a single one. On the other hand, when the users have no idea about what are the ratios
between the attributes, they might prefer to go for a method that provides them a solid solution simply by
extracting from the dataset the points that have an higher score compared to the others. Therefore, regret
minimization and skyline ranking are the indicated techniques to apply.
However, if the users are ﬁrmly decided to apply the regret minimization or the skyline ranking approaches
for a particular reason, we mentioned the fact that it is possible to deploy some speciﬁc algorithms that
would allow them to be included into the tuples’ extraction process in an interactive way.
8

---

A brief analysis of some inner properties can be useful, so that the users can know whether or not they
are allowed to perform some kind of operations. For example, while the regret minimization and skyline
ordering operators are scale invariant, the F-skyline does not behave in the same manner. In fact, as there
have been set constraints on weights between attributes, changing the scale (and then the attributes’ score)
can compromise the validity of the relations that were decided at the beginning. On the other side, all the
three techniques are valid from the point of view of the stability. In fact, the same thought is valid for all of
them: when new junk points are added to the dataset, they will not be included in the ﬁnal result, keeping
the size of the solution on the same level.
All the discussed approaches demonstrate an attitude to compensate the order among the attributes when
they have to propose the ﬁnal result. This means that they overcame the problem of the top-k queries
where the ﬁxed preference imposed a situation where valid tuples were left out because of the strict relation
imposed a priori. This behavior remarks another time the high ﬂexibility of these methods, that are careful
to include all the possible interesting solution to the user.
As it happens in classic top-k queries, users may want to visualize a precise number of tuples in the re-
trieved solution. Therefore, regret minimization and skyline ordering are the two approaches they should
consider. F-skyline doesn’t include k selection as its inner feature, it may be included in a second moment
deploying speciﬁc algorithms to select the exact number of points. However, we would like to stress the fact
that this is not a property which is included in the basic version of the ﬂexible skyline approach. In addition,
if we want to get the tuples sorted and ordered so that we can retrieve a ranking with the best points of the
dataset, then we should go for the skyline ordering operator.
The three techniques allow us to have an overall view of interesting results, which is not always the case, as it
happens in classic top-k queries where some areas of the d-dimensional space are not considered enough be-
cause the weight of the attributes that characterizes them is not enough high to be relevant for the ﬁnal result.
What’s more, the skyline classic uncontrollable output’s size result is greatly mitigated, because the k
set speciﬁes exactly the number of proposed solutions it wants to be retrieved from the algorithms, while the
constraints imposed by the ﬂexible skyline and the eﬀect of the F-dominance relationship draw a narrower
area to include a smaller amount of tuples.
In conclusion, users can think about the precision that they can get from the tuples’ extraction process.
F-skyline and skyline ranking guarantee to include the best tuples available in the dataset, while the regret
minimization approach may only approximate the real best result that they can get form the operation.
For this reason, users should evaluate the eﬀort necessary to perform an exact computation on the available
points that the former two methods can assure them and the estimated regret they have to deal with when
applying the third technique, reducing the computational costs.
6
Conclusions
In this paper we have brieﬂy reviewed the way of behaving and the main properties of three approaches:
F-skyline, regret minimization and skyline ordering. Their aim is to overcome the limitations given by the
classic methods such as top-k queries and skyline queries, proposing a diﬀerent manner to deal with the
problem enhancing the global achievable performance of the process. We have then compared the diﬀerent
techniques, trying to deﬁne diﬀerent scenarios where users can identify themselves so that they can choose
which approach among the three is the best one to solve their problem. For example, the if the users know a
priori the relationship that exists between the attributes of their problem then they should select the ﬂexible
skyline approach to set proper attribute boundaries, applying the concept of F-dominance and retrieving
a more interesting skyline with respect to the classic one. Otherwise, if users do not want to inﬂuence the
tuples extraction process deﬁning a scoring function, they can decide to exploit the regret minimization
approach. Finally, the possibility to obtain a ranking of the extracted tuples can be obtained when applying
the skyline ordering technique.
9

---

Therefore, users are here provided of the necessary tools to decide how to solve their problem, without the
risk of incurring in the limitations and drawbacks of classic skylines and top-k queries.
What’s more, once it has been decided to what approach go for, for a deeper study on which speciﬁc algo-
rithm to deploy, the current paper also provides interesting references to articles and surveys about all the
presented approaches.
References
[1] Pankaj K. Agarwal, Nirman Kumar, Stavros Sintos, and Subhash Suri. Eﬃcient algorithms for k-regret
minimizing sets. ArXiv, abs/1702.01446, 2017.
[2] Wolf-Tilo Balke and Ulrich G¨untzer. Eﬃcient skyline queries under weak pareto dominance. In IJCAI-05
Multidisciplinary Workshop on Advances in Preference Handling (PREFERENCE 2005), 2005.
[3] Wolf-Tilo Balke, Ulrich G¨untzer, and Wolf Siberski. Getting prime cuts from skylines over partially
ordered domains. Datenbanksysteme in Business, Technologie und Web (BTW 2007) – 12. Fachtagung
des GI-Fachbereichs ”Datenbanken und Informationssysteme” (DBIS), pages 64–81, 2007.
[4] Andrey Balmin, Vagelis Hristidis, and Yannis Papakonstantinou. Objectrank: Authority-based keyword
search in databases. Proceedings of the 30th International Conference on Very Large Data Bases, 30,
10 2004.
[5] Stephan B¨orzs¨onyi, Donald Kossmann, and Konrad Stocker. The skyline operator. Proceedings 17th
International Conference on Data Engineering, pages 421–430, 2001.
[6] Sergey Brin and Lawrence Page. The anatomy of a large-scale hypertextual web search engine. In
Proceedings of the Seventh International Conference on World Wide Web 7, WWW7, pages 107–117,
NLD, 1998. Elsevier Science Publishers B. V.
[7] Wei Cao, Jian Li, Haitao Wang, Kangning Wang, Ruosong Wang, Raymond Chi-Wing Wong, and Wei
Zhan. k-regret minimizing set: Eﬃcient algorithms and hardness. 20th International Conference on
Database Theory (ICDT 2017), 68:11:1–11:19, 2017.
[8] Chee-Yong Chan, H. V. Jagadish, Kian-Lee Tan, Anthony K. H. Tung, and Zhenjie Zhang. On high
dimensional skylines.
In Yannis Ioannidis, Marc H. Scholl, Joachim W. Schmidt, Florian Matthes,
Mike Hatzopoulos, Klemens Boehm, Alfons Kemper, Torsten Grust, and Christian Boehm, editors,
Advances in Database Technology - EDBT 2006, pages 478–495, Berlin, Heidelberg, 2006. Springer
Berlin Heidelberg.
[9] Sean Chester, Alex Thomo, S. Venkatesh, and Sue Whitesides. Computing k-regret minimizing sets.
Proc. VLDB Endow., 7(5):389–400, jan 2014.
[10] Paolo Ciaccia and Davide Martinenghi. Reconciling skyline and ranking queries. Proc. VLDB Endow.,
10(11):1454–1465, aug 2017.
[11] Paolo Ciaccia and Davide Martinenghi. Beyond skyline and ranking queries: Restricted skylines (ex-
tended abstract). In SEBD, 2018.
[12] Paolo Ciaccia and Davide Martinenghi.
FA + TA < FSA: Flexible score aggregation.
In Interna-
tional Conference on Information and Knowledge Management, Proceedings, pages 57–66. 27th ACM
International Conference on Information and Knowledge Management, CIKM 2018, 10 2018.
[13] Paolo Ciaccia and Davide Martinenghi. Flexible skylines: Dominance for arbitrary sets of monotone
functions. ACM Trans. Database Syst., 45(4), dec 2020.
10

---

[14] Evangelos Dellis, Akrivi Vlachou, Ilya Vladimirskiy, Bernhard Seeger, and Yannis Theodoridis. Con-
strained subspace skyline computation. In Proceedings of the 15th ACM International Conference on
Information and Knowledge Management, CIKM ’06, pages 415–424, New York, NY, USA, 2006. As-
sociation for Computing Machinery.
[15] Markus Endres and Werner Kießling. Semi-skyline optimization of constrained skyline queries. Confer-
ences in Research and Practice in Information Technology Series, 115, 01 2011.
[16] Ronald Fagin. Combining fuzzy information from multiple systems. Journal of Computer and System
Sciences, 58(1):83–99, 1999.
[17] Ronald Fagin, Amnon Lotem, and Moni Naor. Optimal aggregation algorithms for middleware. In
Proceedings of the Twentieth ACM SIGMOD-SIGACT-SIGART Symposium on Principles of Database
Systems, PODS ’01, pages 102–113, New York, NY, USA, 2001. Association for Computing Machinery.
[18] Usama Fayyad, Gregory Piatetsky-Shapiro, and Padhraic Smyth.
From data mining to knowledge
discovery in databases. AI Magazine, 17(3):37, Mar. 1996.
[19] Alex A. Freitas. A critical review of multi-objective optimization in data mining: A position paper.
SIGKDD Explor. Newsl., 6(2):77–86, dec 2004.
[20] Ihab F. Ilyas, George Beskales, and Mohamed A. Soliman. A survey of top-k query processing techniques
in relational database systems. ACM Comput. Surv., 40(4), oct 2008.
[21] Wen Jin, Jiawei Han, and Martin Ester. Mining thick skylines over large databases, pages 255–266.
Lecture Notes in Computer Science (including subseries Lecture Notes in Artiﬁcial Intelligence and
Lecture Notes in Bioinformatics). Springer, Germany, 01 2004.
[22] Christos Kalyvas and Theodoros Tzouramanis.
A survey of skyline query processing.
ArXiv,
abs/1704.01788, 2017.
[23] Nirman Kumar and Stavros Sintos. Faster approximation algorithm for the k -regret minimizing set and
related problems. In Proceedings of the Twentieth Workshop on Algorithm Engineering and Experiments,
ALENEX 2018, New Orleans, LA, USA, January 7-8, 2018, pages 62–74. SIAM, 01 2018.
[24] Jinfei Liu, Li Xiong, Jian Pei, Jun Luo, and Haoyu Zhang. Finding pareto optimal groups: Group-based
skyline. Proc. VLDB Endow., 8(13):2086–2097, sep 2015.
[25] Hua Lu, Christian S. Jensen, and Zhenjie Zhang. Flexible and eﬃcient resolution of skyline query size
constraints. IEEE Transactions on Knowledge and Data Engineering, 23(7):991–1005, 2011.
[26] Matteo Magnani, Ira Assent, Kasper Hornbæk, Kasperaek, Mikkel R. Jakobsen, and Ken Friis Larsen.
Skyview: A user evaluation of the skyline operator. In Proceedings of the 22nd ACM International
Conference on Information & Knowledge Management, CIKM ’13, pages 2249–2254, New York, NY,
USA, 2013. Association for Computing Machinery.
[27] Denis Mindolin and Jan Chomicki. Preference elicitation in prioritized skyline queries. The VLDB
Journal, 20, 08 2010.
[28] Kyriakos Mouratidis, Keming Li, and Bo Tang. Marrying top-k with skyline queries: Relaxing the
preference input while producing output of controllable size. In Proceedings of the 2021 International
Conference on Management of Data, SIGMOD/PODS ’21, pages 1317–1330, New York, NY, USA,
2021. Association for Computing Machinery.
[29] Kyriakos Mouratidis and Bo Tang. Exact processing of uncertain top-k queries in multi-criteria settings.
Proc. VLDB Endow., 11(8):866–879, apr 2018.
[30] Danupon Nanongkai, Ashwin Lall, Atish Das Sarma, and Kazuhisa Makino. Interactive regret min-
imization. Proceedings of the ACM SIGMOD International Conference on Management of Data, 05
2012.
11

---

[31] Danupon Nanongkai, Atish Das Sarma, Ashwin Lall, Richard J. Lipton, and Jun Xu. Regret-minimizing
representative databases. Proc. VLDB Endow., 3(1–2):1114–1124, sep 2010.
[32] Dimitris Papadias, Yufei Tao, Greg Fu, and Bernhard Seeger. An optimal and progressive algorithm for
skyline queries. In Proceedings of the 2003 ACM SIGMOD International Conference on Management of
Data, SIGMOD ’03, pages 467–478, New York, NY, USA, 2003. Association for Computing Machinery.
[33] Christopher Re, Nilesh Dalvi, and Dan Suciu. Eﬃcient top-k query evaluation on probabilistic data. In
2007 IEEE 23rd International Conference on Data Engineering, pages 886–895, 2007.
[34] Jasna S and Manu Pillai. An algorithm for retrieving skyline points based on user speciﬁed constraints
using the skyline ordering. International Journal of Computer Applications, 104:24–29, 10 2014.
[35] Mohamed A. Soliman, Ihab F. Ilyas, Davide Martinenghi, and Marco Tagliasacchi.
Ranking with
uncertain scoring functions: Semantics and sensitivity measures.
In Proceedings of the 2011 ACM
SIGMOD International Conference on Management of Data, SIGMOD ’11, pages 805–816, New York,
NY, USA, 2011. Association for Computing Machinery.
[36] Bo Tang, Kyriakos Mouratidis, and Mingji Han. On m-impact regions and standing top-k inﬂuence prob-
lems. In Proceedings of the 2021 International Conference on Management of Data, SIGMOD/PODS
’21, pages 1784–1796, New York, NY, USA, 2021. Association for Computing Machinery.
[37] George Valkanas, A.N. Papadopoulos, and Dimitrios Gunopulos.
Skyline ranking `a la IR.
CEUR
Workshop Proceedings, 1133:182–187, 01 2014.
[38] Akrivi Vlachou and Michalis Vazirgiannis. Ranking the sky: Discovering the importance of skyline points
through subspace dominance relationships. Data & Knowledge Engineering, 69(9):943–964, 2010.
[39] Tian Xia, Donghui Zhang, and Yufei Tao. On skylining with ﬂexible dominance relation. 2008 IEEE
24th International Conference on Data Engineering, pages 1397–1399, 2008.
[40] Min Xie, Raymond Chi-Wing Wong, and Ashwin Lall. An experimental survey of regret minimization
query and variants: bridging the best worlds between top-k query and skyline query. The VLDB Journal,
29:147 – 175, 2019.
[41] Min Xie, Raymond Chi-Wing Wong, and Ashwin Lall. Strongly truthful interactive regret minimization.
In Proceedings of the 2019 International Conference on Management of Data, SIGMOD ’19, pages 281–
298, New York, NY, USA, 2019. Association for Computing Machinery.
[42] Min Xie, Raymond Chi-Wing Wong, Jian Li, Cheng Long, and Ashwin Lall. Eﬃcient k-regret query
algorithm with restriction-free bound for any dimensionality. In Proceedings of the 2018 International
Conference on Management of Data, SIGMOD ’18, pages 959–974, New York, NY, USA, 2018. Associ-
ation for Computing Machinery.
[43] Zhibang Yang, Xu Zhou, Kenli Li, Yunjun Gao, and Keqin Li. Progressive approaches to ﬂexible group
skyline queries. Knowledge and Information Systems, 63, 06 2021.
[44] Yidong Yuan, Xuemin Lin, Qing Liu, Wei Wang, Jeﬀrey Yu, and Qing Zhang. Eﬃcient computation of
the skyline cube. In Proceedings of the 31st International Conference on Very Large Data Bases, VLDB
’05, pages 241–252. VLDB Endowment, 01 2005.
[45] Jiping Zheng and Chen Chen. Sorting-based interactive regret minimization. In APWeb/WAIM, pages
473–490, 06 2020.
12

---

