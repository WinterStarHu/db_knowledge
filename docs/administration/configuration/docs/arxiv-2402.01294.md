# Minimizing Regret in Billboard Advertisement under Zonal Influence Constraint

> 来源: https://arxiv.org/pdf/2402.01294

Minimizing Regret in Billboard Advertisement
under Zonal Influence Constraint
Dildar Ali, Suman Banerjee, Yamuna Prasad
Department of Computer Science and Engineering, Indian Institute of
Technology Jammu, 181221, Jammu and Kashmir, India.
*Corresponding author(s). E-mail(s): suman.banerjee@iitjammu.ac.in;
Contributing authors: 2021rcs2009@iitjammu.ac.in;
yamuna.prasad@iitjammu.ac.in;
Abstract
In a typical billboard advertisement technique, a number of digital billboards are
owned by an influence provider, and many advertisers approach the influence
provider for a specific number of views of their advertisement content on a pay-
ment basis. If the influence provider provides the demanded or more influence,
then he will receive the full payment or else a partial payment. In the context of
an influence provider, if he provides more or less than an advertiser’s demanded
influence, it is a loss for him. This is formalized as ‘Regret’, and naturally, in the
context of the influence provider, the goal will be to allocate the billboard slots
among the advertisers such that the total regret is minimized. In this paper, we
study this problem as a discrete optimization problem and propose four solution
approaches. The first one selects the billboard slots from the available ones in an
incremental greedy manner, and we call this method the Budget Effective Greedy
approach. In the second one, we introduce randomness with the first one, where
we perform the marginal gain computation for a sample of randomly chosen bill-
board slots. The remaining two approaches are further improvements over the
second one. We analyze all the algorithms to understand their time and space
complexity. We implement them with real-life trajectory and billboard datasets
and conduct a number of experiments. It has been observed that the random-
ized budget effective greedy approach takes reasonable computational time while
minimizing the regret.
Keywords: Billboard Advertisement, Influence Provider, Advertiser, Regret
Minimization
1
arXiv:2402.01294v1  [cs.DB]  2 Feb 2024

---

1 Introduction
Among many other advertisement techniques, digital billboards have emerged as an
effective approach for the out-of-home advertisement technique 1. In a recent market
survey 2, it has been reported that this advertisement approach leads to more return
on investment. In general, if an advertiser requests some influence from an influence
provider depending upon their budget, the influence provider provides the required
influence and gains profit. Figure 1 shows a schematic diagram of the process. Most of
the existing literature [1–6] on the influence maximization problem in billboard adver-
tisement is solved from the advertiser’s perspective. The key problem addressed in
these studies is to choose k many influential billboard slots to maximize the influence.
However, from the influence provider’s point of view, billboard slots must be allocated
to minimize the total regret (formally defined in Section 3). Hence, deviating from the
existing literature, in this paper, we study the problem of allocating billboard slots
to minimize the overall regret. To the best of our knowledge, other than the study by
[7], there does not exist any other study in this direction.
Background
Now-a-days, billboards are digital and allocated slot-wise to the advertisers for display-
ing their advertisement content. In practice, several advertisers approach an influence
provider for some influence demand on a payment basis. The payment rule is as fol-
lows: if the influence provider provides the demanded or more influence, then the full
payment will be made else a partial payment may be based on a prorata basis. In this
setting, for the influence provider, it will be a loss whether he provides more or less
influence (compared to the demanded one). This loss has been mathematically for-
malized as regret. Detailed discussion on this is deferred till Section 3. The allocation
of the billboard slots needs to be done so that the whole regret is minimized. Next,
we discuss the motivation of our study.
Motivation
At present, a very limited amount of literature on regret analysis in billboard adver-
tisements is available. In all the existing literature [3, 7–10], it has been considered
that the influence at every zone is equally meaningful. However, it may not be the case
always in practice. Consider the following scenario where we know the demographic
information regarding a city’s population. Then, it is quite natural that it is not mean-
ingful to display the advertisement content of a costly product in a place where we
know that the population is economically backward classes. Also, it is important to
observe that this only makes sense for the billboards that are placed in residential
zones. Hence, to incorporate this concept, we divide the billboard slots into two groups:
those in crowded locations and those in residential zones. Now, from the advertiser’s
point of view, they may have the demand of zonal specific influence requirements.
This means instead of having a total influence demand, advertisers post zone-specific
influence demand. Consider the geographical region under consideration Z is divided
1https://www.lamar.com/howtoadvertise/Research/
2https://topmediadvertising.co.uk/billboard-advertising-statistics/
2

---

Fig. 1: Schematic Diagram
into k many non-overlapping zones z1, z2, . . . , zk and advertiser ai expresses their zone
specific influence requirement σi(z1), σi(z2), . . . , σi(zk). So, studying the billboard slot
allocation problem under the zone-specific influence demand constraint is important.
Problem Definition
Consider an influence provider with access to a billboard database containing informa-
tion about several digital billboards and a trajectory database containing the location
information over different time stamps of a group of people. A number of advertis-
ers are approaching the influence provider to have a given amount of influence on a
payment basis. As mentioned previously, the payment scheme is as follows: ”If the
influence provider can provide the required or more influence as asked by the adver-
tiser, then the influence provider will get the full payment or else a partial payment will
be made”. Now, we analyze the situation from the influence provider’s point of view.
If the influence provider provides less influence, it will be a loss because the advertiser
will make a partial payment. Similarly, if it provides more influence than required,
it also causes loss to the influence provider. Because the influence provider does not
get any incentive, on the other hand, this extra influence could have been provided to
the other advertisers whose influence demand has not been fulfilled yet. Both these
losses have been formalized in terms of ‘regret’. This study aims to allocate the bill-
board slots to minimize the total regret while maintaining the zone-specific influence
demand. In this paper, we study this problem as a discrete optimization problem and
propose four solution methodologies.
2 Related Work
This section will discuss the existing literature on regret minimization and influence
maximization that are loosely related to our proposed work. We divide our litera-
ture survey into three major categories: Influential Zone Selection, Trajectory Driven
Influence Maximization, and Regret Minimization.
2.1 Influential Zone Selection
The influential zone or site selection problems gain popularity due to its vast appli-
cation area. In this direction, Cabello et al.[11, 12] first introduce the MaxBRNN
problem. They present an Euclidean distance-based strategy to solve the problem of
locating all points in a dataset whose closest neighbor is a specific query point. Later,
3

---

Du et al. [13] solve optimal location query in spatial databases. They use R∗- tree
and OL-tree-based solution using Manhattan distance. In a similar direction, Xia et
al. [14] address the problem of top-t most influential sites selection and propose a new
approach by extending the work of finding RNN proposed by Stanoi et al. [15] in which
R-tree is called many times and that is the drawback of their work. To overcome this,
Xia et al. proposed a novel algorithm called ‘TopInfluentialSites’ in which the R-
tree will be called only once. Next, Zhou et al. [16] extended the MaxBRNN problem
to the MaxBRkNN problem, which identifies an ideal region where establishing a ser-
vice site ensures that the greatest number of consumers will regard the site to be one
of their k nearest service sites. Later, Huang et al. [17] studied the top-k most influ-
ential location selection problem and proposed two branch and bound-based solution
approaches using different geometric properties to prune the search space and per-
form better than a naive-based approach. Extensive experiments on real-world and
synthetic datasets show the efficiency of their proposed methods.
2.2 Trajectory Driven Influence Maximization
The advancement of mobile and sensors increases the availability of trajectory datasets
[18]. In recent years, Guo et al. [19] have studied the problem of finding k optimal
trajectories rather than identifying k influential sites due to the efficiency of influ-
ence maximization over the trajectory. The primary objective is to identify optimal
trajectories associated with certain advertisements to maximize their impact on tar-
get audiences. Subsequently, Zhang et al. [20] conducted a study that addressed the
issue of identifying a collection of highly influential billboards capable of attracting a
greater number of trajectories while adhering to specific budgetary limitations. They
present a user-defined parameter-based termination technique while introducing a tan-
gent line-based algorithm to determine the top bound of billboard influence. It obtains
an approximation guarantee of θ
2(1−1
e). In a similar direction, a study by Wang et al.
[21] found that the outdoor advertising business faces challenges in effectively deliver-
ing its intended influence to the intended audience. A divide-and-conquer-based search
technique was implemented to address this discrepancy. Instead of just considering
billboards and trajectory, they considered some aspects, including advertisement con-
tent, traffic behavior, and mobility transition. Next, Zahradka et al.[22] did a case
study analysis of the cost of billboard advertising in the different regions of the Czech
Republic. Zhang et al.[23] studied the trajectory-driven influential billboard placement
problem where a set of billboards, along with its location and cost, is given. The goal
here is to choose a subset of the billboards within the budget that influence the largest
number of trajectories. Later, Ali et al. [8, 24] studied the problem of selecting influ-
ential billboard slots and introduced a submodularity graph-based solution approach.
Their main contribution is to prune less influential billboard slots and select the Top-
k most influential slots. Further, Wang et al. [25] studied the problem of the Targeted
Outdoor Advertising Recommendation (TOAR) problem considering the facts of user
profiles and advertisement topics. Their main contribution was a targeted influence
model that characterizes the advertising influence spread along with user mobility.
Based on the divide and conquer approach, they developed two solution strategies.
Implementation with real-world datasets shows the efficiency and effectiveness of the
4

---

proposed solution approaches. There are some loosely related studies with our work
also. Liu et al.[26] developed a visualization tool using large-scale trajectory data to
place the billboards.
2.3 Regret Minimization
Until now, very little literature exists in the context of regret minimization. In the
direction of database query optimization, a k-regret query was examined [27–29] which
addresses decision-making based on multiple criteria. Their solution aims to overcome
the constraints of both the top-k query, which requires an exact utility function from
the user, and the skyline query, which cannot control the size of the result. A k-
regret query is designed to select k tuples from a given database in such a manner
that ensures the utility of the user’s preferred tuple among these k selections is only
marginally lower than the usefulness of their preferred tuple in the entire database,
regardless of the precise utility function utilized. Further, Xie et al. [30] studied the
problem of minimizing the regret ratio by enhancing user interaction in selecting the
best tuples from the whole database. In social network advertisement, Aslay et al.
[31] introduce a new problem domain that involves allocating users to advertisers to
promote commercial posts. Their approach leverages the network effect and consid-
ers several practical considerations, including ad relevance, social proof’s impact, user
attention span, and the constraints imposed by restricted advertiser expenditures.
In a similar direction, few studies in the context of billboard advertisement consider
the minimization of regret causes due to providing influence to the advertiser. Next,
Zhang et al. [7] studied the problem of regret minimization and proposed several solu-
tion methodologies. Experimentation with real-world datasets showed the efficiency
of the approaches. Recently, Ali et al. [9] introduced an efficient algorithm to mini-
mize the total regret of a billboard provider in a multi-advertiser setting. To the best
of our knowledge, no study exists related to regret minimization under zonal influ-
ence constraint for online or offline advertisement. Motivated by these observations,
we studied the problem of regret minimization under zonal influence constraint by
satisfying zone-specific influence demand in multi-advertiser settings.
Our Contributions
To the best of our knowledge, this is the first study on regret minimization for bill-
board advertisements considering zonal influence constraint. In particular, we make
the following contributions:
• We study the Regret Minimization in Billboard Advertisement Problem in multi-
advertiser settings for which the literature is very limited.
• We propose four efficient heuristic solutions: Budget-Effective Greedy, Random-
ized Budget-Effective Greedy, Randomized Synchronous Greedy, and Randomized
Advertiser Exchange algorithm for the regret minimization problem.
• We perform an extensive set of experiments with real-world datasets and com-
pare the performance of the proposed solutions with the available strategies in the
literature.
5

---

Organization of the Paper
The rest of the paper is organized as follows. Section 3 describes required background
concepts and defines the problem formally. Section 4 describes the proposed solution
approach with illustration and analysis. Section 5 contains an experimental setup
with different parameter settings and discussion. Section 6 contains the experimental
evaluations and analysis of the proposed solution approaches. Section 7 concludes this
study and gives future research directions. Next, we discuss background and problem
definition.
3 Background and Problem Definition
In this section, we describe the background of the problem and formally define our
problem. For any positive integer k, [k] denotes the set {1, 2, . . . , k} and for any two
positive integer x and y, with x ≤y, [x, y] denotes the set {x, x + 1, . . . , y}. Initially,
we start by describing the notion of billboard and billboard slots.
3.1 Billboards and Billboard Slots
Consider ℓbillboards B = {b1, b2, . . . , bℓ} are places at different locations of a city.
Each billboard bi ∈B runs for the duration [T1, T2], and these billboards are allocated
to different advertisers for a fixed duration denoted by ∆. We call each fixed-duration
slot a billboard slot. We denote a billboard slot as a tuple of the form (bi, [t, t + ∆])
where bi ∈B and t ∈{T1, T1 + ∆+ 1, T1 + 2∆+ 1, . . . , T2−T1
∆
−∆+ 1}. We denote the
set of all billboard slots as BS. Given a subset of billboard slots S ⊆BS, we denote
its influence as I(S) and can be computed in different ways [7, 23]. We consider the
influence is happening by the rule of the triggering model stated in Definition 1
Definition 1 (Influence of Billboard Slots). Given a subset of billboard slots S and a
trajectory database D, the influence of S under the triggering model can be computed
using Equation No. 1.
I(S) =
X
tj∈D
1 −
Y
bi∈BS
(1 −Pr(bi, tj))
(1)
where Pr(bi, tj) denotes the influence probability of the trajectory tj by the billboard
slot bi.
In this study, we assume that for every bi ∈BS and tj ∈D, the value of Pr(bi, tj)
is known. In the literature [3, 7], there are standard methods for computing this value.
Next, we describe the notion of Zonal influence constraint.
3.2 Zonal Influence Constraint
Consider that the geographical region under consideration Z is partitioned into k
many disjoint zones z1, z2, . . . , zk. Naturally, any billboard bi ∈B will belong to one
of the k zones. All the slots associated with the billboard will belong to the zone in
which the billboard belongs to. Hence, the set of billboard slots BS can be partitioned
into k parts BS1, BS2, . . . , BSk such that for any i ∈[k], the partition BSi contains
6

---

the billboard slots that belongs to the zone zi only. For any advertiser ai ∈A, can be
represented by a tuple (ai, σi, ui), which means that the advertiser ai is opting for the
influence of amount σi by the payment ui. In this study, we consider that the influence
demand of each advertiser is also specific to each zone. Hence, σi can be replaced by
the tuple (σ1
i , σ2
i , . . . , σk
i ) where σj
i denotes the influence demand of the advertiser ai
for the zone zj. Hence, for any i ∈[n], σi = Pk
j=1 σj
i . Now, we formally define the
zonal influence constraint.
Definition 2 (Zonal Influence Constraint). Let, BSai denote the set of billboard slots
allocated to the advertiser ai. BSzj
ai is the subset of BSai, contains the billboard slots
that belongs to the zone zj. Now, we say that the allocation satisfies the zonal influence
constraint for the advertiser ai and zone zj if and only if I(BSzj
ai) ≥σj
i .
Next, we describe the regret model that we have considered in our study for
billboard slot allocation.
3.3 The Regret Model
As mentioned previously, there are n advertisers, A = {a1, a2, . . . , an} and one influ-
ence provider X. Each advertiser ai submits a campaign proposal to the Influence
Provider X as follows: “The advertiser ai has the influence demand of σ1
i , σ2
i , . . . , σk
i
over the zones z1, z2, . . . , zk on the basis of payment ui”. The influence provider
X has the advertiser database A whose content are the tuples of the form (ai, <
σ1
i , σ2
i , . . . , σk
i >, ui) for all i ∈[n]. Let BSzj
ai be the set of billboard slots allocated to
the advertiser ai and belongs to zone zj. Now, as per the payment rule for all zj ∈Z,
if I(BSzj
ai) ≥σj
i , then the payment of amount ui will be made else a partial payment
(e.g., pro-rata basis which will be lesser than the ui) will be made.” Now, there are a
few important points to highlight.
• The first one is for any advertiser and for any zone if the influence provided by X is
less than what is expected, then this is a loss for X because a partial payment will
be received. We call this regret as the Unsatisfied Regret.
• On the other hand, if X provides more influence than what is expected, that also
leads to a loss for X. The reason is as follows. Assume that for the advertiser ai and
zone zj, I(BSzj
ai) > σj
i . Now, for providing the excess influence I(BSzj
ai) −σj
i to the
advertiser ai for the zone zj, the influence provider does not get any extra incentive.
Also, it may so happen that for any other advertiser ax ∈A \ {ai} at the zone zj,
I(BSzj
ax) < σj
x. So, some of the billboard slots from BSzj
ai can be included to BSzj
ax
such that I(BSzj
ax) ≥σj
x. We call the regret of this kind the Excessive Regret.
Combining these two cases, we define the regret model considered in this paper in
Definition 3.
Definition 3 (The Regret Model). Let, for the advertiser ai ∈A, the set of allocated
billboard slots is BSai and the regret associated with this allocation for the zone zj is
7

---

denoted by Rzj
ai. This quantity can be defined by the following conditional equation:
Rzj
ai =





ui · (1 −γ ·
I(BS
zj
ai )
σj
i
),
if σj
i > I(BSzj
ai)
ui ·
I(BS
zj
ai )−σj
i
σj
i
,
otherwise
Here, the fraction
I(BS
zj
ai )
σj
i
is part of the satisfied influence for the advertiser ai from the
zone zj and γ is a parameter which is called as the penalty ratio due to the unsatisfied
demand.
The developed solution methodologies in this paper are independent of the choice
of γ, and it has been explained further in Section 5 of this paper.
3.4 Allocation of Billboard Slots
The task is to allocate the billboard slots among the advertisers. The goal is to
minimize the total regret while the following two constraints are satisfied:
• Zonal Influence Constraint : This constraint means that for any advertiser ai ∈A,
and zone zj ∈Z, I(BSzj
ai) ≥σj
i .
• Disjointness Constraint : For any two advertisers ax and ay, let BSax and BSay
denotes the set of billboard slots allocated to ax and ay, respectively. The dis-
jointness constraint implies that any billboard slot (bi, [t, t + ∆]) ∈BS can not be
allocated to more than one advertiser. Hence, BSax ∩BSay = ∅.
Let L denote the set of all possible allocations, and any arbitrary allocation of all n
advertisers is denoted as (BSa1, BSa2, . . . , BSan). Now, we define the notion of feasible
allocation in Definition 4.
Definition 4 (Feasible Allocation). An allocation of the billboard slots is said to be a
feasible allocation if it satisfies both the Zonal Influence Constraint and the disjointness
constraint.
As mentioned previously, the objective of the allocation is to minimize the total
regret. So, we define the notion of total regret for an allocation in Definition 5.
Definition 5 (Total Regret Associated with an Allocation). Given an allocation of
the billboard slots Y = {BSa1, BSa2, . . . , BSan} the total regret associated with the
allocation Y is denoted by R(Y) and defined as the sum of the regret associated with
the individual advertisers. In turn, the regret due to the allocation of one advertiser
can be obtained by summing up the corresponding zonal regrets.
R(Y) =
X
ai∈A
X
zj∈Z
Rzj
ai
(2)
It can be observed that the value of Rzj
ai has already defined. We denote an optimal
allocation of the billboard slots by YOP T . As mentioned previously, the goal of the
influence provider is to find the optimal allocation of the billboard slots such that total
regret is minimized. We call this problem the Regret Minimization with Zonal
Influence Constraint Problem. This problem has been stated in Definition 6.
8

---

Definition 6 (Regret Minimization with Zonal Influence Constraint). Given the bill-
board slot information BS, a trajectory database D, and the advertiser database A, the
goal of this problem is to create an allocation Y = {BSa1, BSa2, . . . , BSan} in which the
set of billboard slots BSai are allocated to the advertiser ai such that the total regret is
minimized. Mathematically, this problem can be posed as follows:
YOP T = argmin
Yi∈L(Y)
R(Yi)
(3)
Here the constraint is for all BSai and BSaj they need to be disjoint; i.e., BSai ∩
BSaj = ∅. Now, from the computational point of view, this problem can be written as
follows:
Regret Minimization in Billboard Advertisement Problem
Input: Billboard Slots set BS, Influence Function I(), Trajectory Database
D, Advertiser Database A.
Problem: Find out an optimal allocation YOP T = {BSa1, BSa2, . . . , BSan}
of the billboard slots that minimizes the overall regret.
The regret minimization problem in the context of billboard advertisement has been
studied by Zhang et al. [7] without the zonal influence constraint. They had an
inappoximability result stated in Theorem 1.
Theorem 1. Regret Minimization with Zonal Influence Constraint Prob-
lem is NP-hard to solve optimally, and it is also hard to obtain any constant factor
approximation algorithm.
This means that the same inappoximability result will also hold for our problem
as well. Next, we proceed to describe the proposed solution methodologies.
4 Proposed Solution
The hardness of the problem implies that any efficient algorithm with a theoretical
guarantee for optimal regret does not exist unless P = NP. Now, we define the notion
of budget-effective advertiser in Definition 7.
Definition 7 (Budget Effective Advertiser). Given any two advertisers ai, aj ∈A
with their respective proposal (ai, σi, ui) and (aj, σj, uj), ai is said to be more budget
effective than aj if ( ui
σi > uj
σj ) holds.
Considering its hardness, we propose two efficient algorithms: (1) Budget Effective
Greedy and (2) Randomized Budget Effective Greedy that will satisfy more budget-
effective advertisers while minimizing the total regret for the influence provider’s
perspective.
4.1 Budget-Effective Greedy (BG)
We introduce a heuristic Greedy in Algorithm 1. First, initialize a set of empty bill-
board slots set in Line No. 1. Next, sort each advertiser in descending order based on
budget over demand. Now, in Line No. 3 to 11, for each advertiser and its correspond-
ing zones, While Loop iterates for assigning billboard slots to the advertisers that best
9

---

reduce the total regret and satisfy the zonal influence requirement. The final billboard
slot set is returned after all the advertisers are satisfied or billboard slots run out.
Algorithm 1: Budget-Effective Greedy Algorithm for Regret Minimization
Problem
Data: Trajectory Database D, Billboard Slot Information BS, Advertiser Database
A, and the Influence Function I().
Result: An allocation Y of the billboard slots that minimizes the total regret
1 Initialize Y ←{S1, S2, . . . , S|A|} of empty lists;
2 A ←Sort each advertiser ai ∈A based on descending order of ui
σi ;
3 for each ai ∈A do
4
for each zj ∈aiz do
5
while σi > I(Si) and BSzj̸ = ϕ do
6
s∗←argmax
s∈BSzj
R(Si)−R(Si∪{s})
σ({s})
;
7
Si ←Si ∪{s∗};
8
BSzj ←BSzj \ {s∗};
9
end
10
end
11 end
12 return Y;
Complexity Analysis. Now, we analyze the time and space requirement of Algo-
rithm 1. In-Line No. 1, initializing Y as a set of empty billboard slots set will take
O(n) time. Sorting advertisers in Line No. 2 will take O(n log n) time. It is clear that
For Loop at Line No. 3 will iterate for n number of advertisers, and it will take O(n)
time to execute. Line No. 4 For Loop will execute at most k times, and it takes O(k)
time. Now, in the worst case, While Loop at Line No. 5 will execute at most the num-
ber of billboard slots a zone has, and to compute the regret in Line No. 6, we need to
compute the influence for l number of slots that takes O(n.k.ℓ.t) time where t is the
number of tuple in the trajectory database. Line No. 7 and 8 will take O(n.k) time.
Hence, Line No. 3 to 11 will take O(n.k.ℓ.t + n.k) time to execute. So, the total time
taken by Algorithm 1 is O(n + n log n + n.k.ℓ.t + n.k) i.e., O(n log n + n.k.ℓ.t). The
extra space is taken by Algorithm 1 to store the billboard slots list Y and Advertisers
list A both will take O(n) space. As k number of zones is there, to store them, it will
take O(k) extra space. In the worst case, Si will take O(ℓ) extra space as at most ℓ
many billboard slots can be allocated to satisfy the zonal influence requirement of an
advertiser. Hence, the total extra space required by Algorithm 1 is O(n + n + k + ℓ)
i.e., O(n + k + ℓ).
Though Algorithm 1 is simple to understand and easy to implement, this algorithm
is extremely inefficient, as mentioned in Section 5. This is particularly due to the huge
number of marginal gain computations. To eliminate this problem, we propose the
randomized budget effective greedy algorithm.
10

---

4.2 Randomized Budget-Effective Greedy (RG)
Algorithm 2 represents the randomized budget-effective greedy heuristic search in the
form of pseudocode. At first, in Line No. 1, we initialize an empty set of billboard slots
set for each advertiser. Next, each advertiser is sorted in descending order based on
the advertiser’s budget over influence demand. Each advertiser has influence demand
over different zones, and to satisfy this quantity, in Line No. 3 For Loop iterates
over all the advertisers, and in Line No. 4, For Loop iterates over different zone for
each advertiser. Now, in Line No. 5, billboard slots for a particular zone are sorted in
ascending order according to their individual influence value. Next, in Line No. 8 to 13
While Loop iterates over all the slots of a zone to satisfy the zonal influence demand
of an advertiser. From this While Loop, a maximum number of billboard slots set
that satisfy the zonal influence demand of an advertiser is generated. So, from Line
No. 14 to 19, a greedy heuristic is applied to fulfill the advertiser’s influence demand
by assigning slots according to zonal influence requirement and best reduce the total
regret. Now, in Line No. 14, for each advertiser with corresponding zonal information,
While Loop iterates till influence demand for a particular zone is not satisfied or slots
run out. At each iteration, it samples out
|BSzj |
|S′
i| log 1
ϵ many elements form BSzj, and
from the sample out slots pick one which minimizes the regret. Here, |BSzj|, and |S
′
i|
is the number of slots in zone j, and the maximum number of billboard slots required
from a zone to satisfy an advertiser ai, respectively, and ϵ is a user-defined parameter.
This procedure will continue till all the advertisers are satisfied or no more billboard
slots remain, and finally, the billboard slot set Y will be returned.
Complexity Analysis. Now, we analyze the time and space requirement of Algo-
rithm 2. In-Line No. 1 initializing Y will take O(n) time, and Line No. 2 will take
O(n log n) time to sort the advertisers. Now, in Line No. 3 For Loop executes for
O(n) time, and in Line No. 4 For Loop executes for O(k) time. To sort the advertiser
in Line No. 5 based on individual influence value will take O(n.k.ℓlog ℓ) time, and
Line No. 6 and 7 will take O(n.k) time for initialization. Now, in Line No. 8 While
Loop will execute for O(n.k.ℓ) time as in the worst case, a zone has at most ℓnum-
ber of billboard slots. Line No. 9, 11, 12 will take O(n.k) time execute, but Line No.
10 will take O(n.k.ℓ.t) as each time needs to compute the influence using Equation
1. So, Line No. 8 to 13 will take O(n.k + n.k.ℓ.t) time in total. In the worst case,
While Loop in Line No. 14 will execute for O(n.k.ℓ) time. In-Line No. 15 to sample
out
|BSzj |
|S′
i| log 1
ϵ many elements from BSzj will take O(n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ ) time when
|S
′
i| = ℓin the worst case. Calculating regret in Line No. 16 will take O(n.k.ℓ.t) time
and Line No. 17, 18 will take O(n.k.ℓ) computational time. So, from Line No. 14 to 19
will take O(n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ + n.k.ℓ.t + n.k.ℓ) time in total. Hence, Algorithm 2 will
take O(n + n log n + n.k.ℓlog ℓ+ n.k + n.k + n.k.ℓ.t + n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ + n.k.ℓ.t + n.k)
i.e., O(n log n + n.k.ℓlog ℓ+ n.k.ℓ.t + n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ ) time.
Now, the additional space requirement to store the lists Y, A, BSzj, S
′
i, and Si
will be of O(n), O(n), O(ℓ), O(ℓ), and O(ℓ), respectively. To store zonal information
11

---

Algorithm 2: Randomized Budget-Effective Greedy Algorithm for Regret
Minimization Problem
Data: Trajectory Database D, Billboard Slot Information BS, Advertiser Database
A, and the Influence Function I().
Result: An allocation Y of the billboard slots that minimizes the total regret
1 Initialize Y ←{S1, S2, . . . , S|A|} of empty lists;
2 A ←Sort each advertiser ai ∈A based on descending order of ui
σi ;
3 for each ai ∈A do
4
for each zj ∈aiz do
5
BSzj ←Sort slots in ascending order based on individual influence;
c ←−1;
6
S
′
i ←−∅; Si ←−∅; I(S
′
i) ←−0; I(Si) ←−0;
7
while I(S
′
i) < σi and BSzj̸ = ∅do
8
S
′
i ←−S
′
i ∪BSzj[c];
9
I(S
′
i) ←−I(S
′
i) + I(BSzj[c]);
10
BSzj ←−BSzj \ (BSzj[c]);
11
c ←−c + 1
12
end
13
while σi > I(Si) and BSzj̸ = ∅do
14
P ←Sample
|BSzj |
|S′
i|
log 1
ϵ many elements from BSzj \ Si;
15
s∗←argmax
s∈P
R(Si)−R(Si∪{s})
σ({s})
;
16
Si ←Si ∪{s∗};
17
BSzj ←BSzj \ {s∗};
18
end
19
end
20 end
21 return Y;
of billboard slots will take O(k) space. Hence, the total extra space requirement for
Algorithm 2 will be of O(k + 2n + 3ℓ), i.e., O(k + n + ℓ).
4.3 Randomized Synchronous Greedy Approach (RSG)
Budget-effective greedy suffers from allocating billboard slots fairly, as most influential
slots are allocated to some of the most budget-effective advertisers. The unsatisfied
regret plays a significant role compared to excessive regret to produce total regret
in our regret model described in Section 3. So, the advertisers who are unsatisfied
due to billboard slots running out are not preferable to consider. To address this, we
introduce a synchronous greedy approach in Algorithm 3 in which slots are allocated
synchronously to overcome the drawback of budget-effective greedy. First, in Line No.
1, initialize a set of empty billboard slots set. In Line No. 2, all advertisers are sorted
according to their budget effectiveness. Next, in Line No. 3 to 21, synchronously allo-
cate billboard slots to each advertiser individually, reducing the regret best. In Line No.
22 to 34, the number of unsatisfied advertisers is calculated after allocating billboard
slots to them. Now, in Line No. 35 to 43 after allocation, if more than one advertiser is
12

---

still unsatisfied, then release advertisers one by one according to less budget effective-
ness and allocate the released slots to other unsatisfied ones. This procedure continues
until all the remaining advertisers are satisfied or no further improvement occurs.
Complexity Analysis. Now, we analyze the time and space requirements of
Algorithm 3. In-Line No. 1 initializing Y will take O(n) time and Line No. 2, to sort
the advertisers will take O(n log n) time. Now, in Line No. 4 For Loop executes for
O(n) time, and in Line No. 5 For Loop executes for O(k) time as there are n number
of advertisers and k number of influential zones respectively. To sort the advertisers
in Line No. 6 based on their individual influence value will take O(n.k.ℓlog ℓ) time,
and Line No. 7 will take O(n.k) time for initialization. Now, in Line No. 8 While
Loop will execute for O(n.k.ℓ) time as in the worst case, a zone has at most ℓnumber
of billboard slots. Line No. 9, 11, 12 will take O(n.k) time execute, but Line No. 10
will take O(n.k.ℓ.t) as each time needs to compute the influence using Equation 1.
So, Line No. 8 to 13 will take O(n.k.ℓ+ n.k.ℓ.t) time in total. In the worst case,
While Loop in Line No. 14 will execute for O(n.k.ℓ) time. In-Line No. 15 to sample
out
|BSzj |
|S′
i| log 1
ϵ many elements from BSzj will take O(n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ ) time when
|S
′
i| = ℓin the worst case. Calculating regret in Line No. 16 will take O(2.n.k.ℓ.t) time
and Line No. 17, 18 will take O(n.k.ℓ) computational time. So, from Line No. 14 to
19 will take O(n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ + n.k.ℓ.t + n.k.ℓ) time in total. So. from Line No. 4
to 21 will take O(n + n.k.ℓlog ℓ+ n.k + n.k.ℓ+ n.k.ℓ.t + n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ + n.k.ℓ.t +
n.k) i.e., O(n.k.ℓlog ℓ+ n.k.ℓ.t + n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ ) time. Now, in Line No. 22 to 34,
calculating the number of unsatisfied advertisers will take O(n.k) time to execute as
in the worst case, all the n advertisers can be unsatisfied and in Line No. 36 to sort all
the advertisers will take O(n log n) in the worst case. Next, in Line No. 37 copying slots
from released advertiser to billboard slots zone BSz will take O(ℓ) in the worst case
and Line No. 38 will take O(1) time. Hence, Line No. 35 to 39 will take O(n log n + ℓ)
time. Hence, Algorithm 3 will take O(n.k.ℓlog ℓ+n.k.ℓ.t+n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ + n log n)
time in total for allocating slots in one iteration of the While Loop.
Now, the additional space requirement to store the lists Y, A, BSzj, S
′
i, and Si
will be of O(n), O(n), O(ℓ), O(ℓ), and O(ℓ), respectively. To store zonal information
of billboard slots will take O(k) space. Hence, the total extra space requirement for
Algorithm 3 will be of O(k + 2n + 3ℓ), i.e., O(k + n + ℓ).
4.4 Randomized Advertiser Exchange Approach (RAE)
In the ‘RSG’ approach, after allocating billboard slots, if more than two advertisers
are still unsatisfied, we release advertisers one by one according to their budget effec-
tiveness and allocate released billboard slots to the remaining unsatisfied ones. Now,
after the allocation of billboard slots to the advertisers in the ‘RSG’ approach, the
excessive regret is huge compared to the unsatisfied regret. Now, another allocation of
billboard slots to the advertiser may exist, as described in Definition 4, which may be
better than the current allocation as we have used randomization during allocation, as
shown in Algorithm 3. We introduce the Randomized Advertiser Exchange approach to
address this issue after billboard slot allocation in the ‘RSG’ approach. Here, our main
13

---

Algorithm 3: Randomized Synchronous Greedy Approach for Regret Mini-
mization Problem
Data: Trajectory Database D, Billboard Slot Information BS, Advertiser Database
A, and the Influence Function I().
Result: An allocation Y of the billboard slots that minimizes the total regret
1 Initialize Y ←{S1, S2, . . . , S|A|} of empty lists;
2 A ←Sort each advertiser ai ∈A based on descending order of ui
σi ;
3 while True do
4
for each ai ∈A do
5
for each zj ∈aiz do
6
BSzj ←Sort slots in ascending order based on individual influence;
7
c ←−1; S
′
i ←−∅; Si ←−∅; I(S
′
i) ←−0; I(Si) ←−0;
8
while I(S
′
i) < σi and BSzj̸ = ∅do
9
S
′
i ←−S
′
i ∪BSzj[c];
10
I(S
′
i) ←−I(S
′
i) + I(BSzj[c]);
11
BSzj ←−BSzj \ (BSzj[c]);
12
c ←−c + 1
13
end
14
while σi > I(Si) and BSzj̸ = ∅do
15
P ←Sample
|BSzj |
|S′
i|
log 1
ϵ many elements from BSzj \ Si;
16
s∗←argmax
s∈P
R(Si)−R(Si∪{s})
σ({s})
;
17
Si ←Si ∪{s∗};
18
BSzj ←BSzj \ {s∗};
19
end
20
end
21
end
22
|Au| ←0;
23
for each ai ∈A do
24
Nz ←0; count ←0;
25
for each zj ∈aiz do
26
Nz ←Nz + 1;
27
if σi < I(Si) then
28
count ←count + 1;
29
end
30
end
31
if count̸ = Nz then
32
|Au| ←|Au| + 1
33
end
34
end
35
if |Au| ≥2 then
36
Au ←Sort each advertiser ai ∈Au based on ascending order of ui
σi ;
37
BSz ←Si ∈Au[1];
38
A ←−A \ Au[1];
39
end
40
else
41
return Y;
42
end
43 end
objective is to achieve an allocation such that total regret is minimized. First, instead
14

---

of an empty set of billboard slot set, the final non-empty advertisers set returned by
Algorithm 3 is considered the input of the ‘RAE’ approach. In Line No. 3, make a
copy of Yfinal as Ytemp, and Line No. 4 For Loop will iterates for all the advertisers,
ai ∈A whereas For Loop at Line No. 5 iterates for all the advertisers aj ∈A \ {ai}.
Now, in Line No. 6 if there exist Si ∈ai, Sj ∈aj such that exchange [Si, Sj] will min-
imize the total regret of Ytemp then exchanging of slots between advertiser ai and aj
is performed in Line No. 7 to 9. Therefore, after completion of For Loop in Line No.
4 to 12 a new allocation of billboard slots to the advertisers is achieved. If total regret
in new allocation Ytemp is less than the total regret of previous allocation Yfinal then
Ytemp becomes Yfinal and again iterates over Line No. 2 to 13 and this will continue
till While Loop gets true but when the condition at Line No. 14 gets false then Line
No. 17 to 19 executes and While Loop breaks and return Yfinal.
Algorithm 4: Randomized Advertiser Exchange Approach for Regret Mini-
mization Problem
Data: Trajectory Database D, Billboard Slot Information BS, Advertiser Database
A, and the Influence Function I().
Result: An allocation Y of the billboard slots that minimizes the total regret
1 Yfinal ←RandomizedSynchronousGreedy(D, BS, A, Y);
2 while True do
3
Ytemp ←Yfinal
4
for each ai ∈A do
5
for each aj ∈A \ {ai} do
6
if
∃Si ∈ai, Sj ∈aj such that exchange [Si, Sj] will minimize R(Ytemp)
then
7
ai ←ai ∪Sj;
8
aj ←aj ∪Si;
9
ai ←ai \ Si;
10
aj ←aj \ Sj;
11
end
12
end
13
end
14
if
R(Ytemp) < R(Yfinal) then
15
Yfinal ←Ytemp
16
end
17
else
18
return Yfinal;
19
end
20 end
Complexity Analysis. Now, we analyze the time and space requirement of
Algorithm 4. First, in Line No. 1 ‘RSG’ approach will take O(n.k.ℓlog ℓ+ n.k.ℓ.t +
n.k.ℓ.
|BSzj |
ℓ
log 1
ϵ + n log n) time in total as shown in Algorithm 3. Next, in Line No 3
copying Ytemp to Yfinal will take O(ℓ) time in the worst case. In-Line No. 4 For Loop
will execute for O(n) time and For Loop at Line No. 5 will execute for n −1 times as
total n number of advertisers are there. At Line No. 6 in the worst case, exchanging
slots between ai with aj will take O(ℓ) time and to calculate regret of Ytemp we need
15

---

to compute the influence of ℓnumber of slots that will take O(n2.ℓ.t) time where t is
the number of tuple in the trajectory database. In Line No. 7 to 10 will take O(n2)
time to execute. Hence, from Line No. 4 to 13 will take O(n2.ℓ.t + n2.ℓ+ n2) time. In
Line No. 14 regret will be calculated twice and it will take O(2.n2.ℓ.t) time. Finally, in
Line No. 15 copying from Ytemp to Yfinal will take O(n) time. Therefore, Algorithm
4 will take total O(n2.ℓ.t+n2.ℓ+n2 +2.n2.ℓ.t+n2) i.e., O(n2.ℓ.t) time to execute one
iteration of the While Loop in Line no 2. Now, the additional space requirement for
Algorithm 4 is for Yfinal and Ytemp will be O(n) and O(n) respectively. Hence, total
space requirement of Algorithm 4 will be O(n + n) i.e., O(n).
4.5 An Illustrative Example
Consider, an influence provider owns thirteen billboard slots, BS = {bs1, bs2, . . . , bs13}
with corresponding individual influence as reported in Table No. 1a. These bill-
board slots are divided into three demographic zones i.e., Z1, Z2, Z3. Let, zone Z1,
Z2 and Z3 contains billboard slots {bs1, bs6, bs11, bs10}, {bs2, bs5, bs8, bs7, bs13} and
{bs3, bs4, bs9, bs12} respectively. Now, five advertisers, A = {a1, a2, . . . a5} approach
to the influence provider with their required zone-specific influence demand with bud-
get constraints as shown in Table No. 1b. To address this at first, the influence
provider sorts the advertisers based on budget effectiveness in descending order i.e.,
{a1, a4, a2, a3, a5} and allocate billboard slots to each advertiser one by one using
‘RG’ approach to satisfy their zone specific influence requirements. After allocation,
we found that advertisers a3, and a5 are still unsatisfied due to billboard slots running
out while the remaining advertisers are satisfied as presented in Table No. 1c. After
this allotment, the ‘RSG’ approach applied to release unsatisfied advertisers one by
one and allot released advertisers allocated slots to remaining unsatisfied advertisers.
So, less budget effective advertiser {a5} removed and released slot, {bs13} is belongs to
zone Z2 of {a5}. But, advertiser {a3} have influence requirements from Z3. So, adver-
tisers a3 still remain unsatisfied, and unsatisfied regret(UR) of advertisers a3 increases
as shown in Table No. 1d. As our allocation scheme is based on randomization there
may exist another better allocation on top of the current allocation. Next, the ‘RAE’
approach is applied to the current allocation. We observe that exchange of billboard
slots between advertiser {a3} and {a4} make the advertisers {a3} satisfied and reduce
unsatisfied regret(UR) of advertiser {a3} and excessive regret (ER) of advertiser {a4}.
Finally, all the remaining advertisers i.e., {a1, a2, . . . a4} are satisfied and overall regret
is minimized as shown in Table No. 1e.
5 Experimental Setup
In this section, we describe the experimental setup to determine the effectiveness and
efficiency of the proposed solution methodologies. Initially, we start by describing the
datasets.
16

---

BSi
bs1
bs2
bs3
bs4
bs5
bs6
bs7
bs8
bs9
bs10
bs11
bs12
bs13
σ(bsi)
4
6
5
3
3
2
3
2
3
3
2
5
3
(a) Billboard Slots information.
A
a1
a2
a3
a4
a5
σi
σ1(Z1) = 3;
σ1(Z2) = 2;
σ1(Z3) = 2
σ2(Z1) = 3;
σ2(Z2) = 3;
σ2(Z3) = 3
σ3(Z1) = 1;
σ3(Z2) = 5;
σ3(Z3) = 4
σ4(Z1) = 1;
σ4(Z2) = 1;
σ4(Z3) = 2
σ5(Z1) = 3;
σ5(Z2) = 2;
σ5(Z3) = 3
ui
$15
$16
$15
$8
$7
(b) Advertisers information.
A
a1
a2
a3
a4
a5
BSi
Z1 = {bs10};
Z2 = {bs5};
Z3 = {bs9}
Z1 = {bs1};
Z2 = {bs7};
Z3 = {bs3}
Z1 = {bs11};
Z2 = {bs2};
Z3 = {bs4}
Z1 = {bs6};
Z2 = {bs8};
Z3 = {bs12}
Z1
=
{};
Z2 = {bs13};
Z3 = {}
Satisfied
Yes
Yes
No
Yes
No
(c) Initial allotment using the ‘RG’ approach.
A
a1
a2
a3
a4
BSi
Z1
=
{bs10};
Z2
=
{bs5};
Z3 = {bs9}
Z1
=
{bs1};
Z2
=
{bs7};
Z3 = {bs3}
Z1
=
{bs11};
Z2
=
{bs2};
Z3 = {bs4}
Z1
=
{bs6};
Z2
=
{bs8};
Z3 = {bs12}
Satisfied
Yes
Yes
No
Yes
Regret
ER: Yes, UR: No
ER: Yes, UR: No
ER: Yes, UR:Yes
ER:Yes, UR: No
(d) Allotment after the ‘RSG’ approach.
A
a1
a2
a3
a4
BSi
Z1
=
{bs10};
Z2
=
{bs5};
Z3 = {bs9}
Z1
=
{bs1};
Z2
=
{bs7};
Z3 = {bs3}
Z1
=
{bs6};
Z2
=
{bs8};
Z3 = {bs12}
Z1
=
{bs11};
Z2
=
{bs2};
Z3 = {bs4}
Satisfied
Yes
Yes
Yes
Yes
Regret
ER: Yes, UR: No
ER: Yes, UR: No
ER: Yes, UR: No
ER: Yes, UR: No
(e) Final allotment after the ‘RAE’ approach.
5.1 Dataset Descriptions
We conduct experiments on two real-world trajectory datasets, check-ins for New York
City (NYC) and Los Angeles (LA). A total of 227, 428 check-ins were recorded in
NYC3 between April 12, 2012, and February 16, 2013, while 74, 170 entries of user
data from 15 streets in LA4 included street names, GPS locations, timestamps, and
other information. We have crawled billboard datasets from LAMAR5, one of the
largest billboard providers worldwide. All the essential characteristics of datasets are
summarized in Table 2. In trajectory information, |T |, |U|, and Avgdist represent
trajectory size, number of unique users, and average distance each user covers. On the
other hand, in billboard information B, BS′, BS′′, and Avgdist denote the number of
billboards, the number of billboard slots, the number of non-zero influential billboard
3https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
4https://github.com/Ibtihal-Alablani
5http://www..lamar.com/InventoryBrowser
17

---

slots, and the average distance between each billboard place in the respective city.
Additionally, we divide the billboard datasets for New York City into five geographic
regions based on latitude and longitude: The Bronx, Brooklyn, Manhattan, Queens,
and Staten Island, and Los Angeles billboard dataset is divided into 3 different zones
based on 15 different streets.
Dataset
Trajectory Information
Billboard Information
|T |
|U|
Avgdist
|B|
|BS′|
|BS′′|
Avgdist
NYC
227428
1083
3.12 km
716
1031040
11048
15.07 km
LA
74170
2000
0.61 km
1483
2135520
4712
10.26 km
Table 2: Dataset Description
5.2 Parameter Setting
In this study, the following parameter values need to be fixed, and we describe them
briefly. All key parameters and their corresponding values are summarized in Table 3.
Parameter
Values
δ
40%, 60%, 80%, 100%, 120%
λ
1%, 2%, 5%, 10%, 20%
ϵ
0.01, 0.05, 0.1, 0.15, 0.2
γ
0, 0.25, 0.5, 0.75, 1
η
25m, 50m, 100m, 125m, 150m
Table 3: Key Parameters
Demand-Supply Ratio (δ)
It denotes the ratio of the global influence demand over the influence provider’s supply,
i.e., δ = σA/σh, where σA = P|A|
a=1 σa refers the global demand, and σh refers the
total influence supply, i.e., σh = P
b∈BS σ(b).
Average-Individual Demand Ratio (λ)
It refers to the ratio of individual demand of advertisers and the influence provider’s
supply, i.e., λ =
σA/|A|
σh
. By adjusting the λ value, we can control the individual
demand of an advertiser.
Penalty Ratio (γ)
It decides how much penalty should be imposed on an influence provider due to the
advertiser’s dissatisfaction. As described in Equation 3, two extreme case arises: (1)
when γ = 0, the influence provider does not receive any payment if the advertiser is
not satisfied. (2) when γ = 1, the influence provider will receive the same fraction of
payment as the fraction of influence it provides to the advertiser.
18

---

Accuracy Speed-up parameter (ϵ)
It is a user-defined parameter that decides the sample set size from which a slot is
chosen to allocate in Algorithm 2. The ϵ value is set to 0.01, 0.05, 0.1, 0.15, and 0.2 to
simulate different sample set sizes in our experiment.
Advertiser’s Demand (σ)
Each advertisers demand in the Advertiser dataset is generated using λ, and σh. It can
be represented as σa = ⌊α.σa.λ⌋, where α is a parameter randomly chosen between
0.8 to 1.2 to generate different demand values of the advertiser.
Advertiser’s Payment (u)
Previous studies [23, 31] considered cost is proportional to its corresponding influence.
So, we generate the advertiser’s payment as u = ⌊β.σa⌋, where β is a factor randomly
chosen between 0.9 to 1.1.
Environment Setup
All proposed and baseline methods have been implemented in Python using the
Jupyter Notebook platform. All experiments are conducted in a Ubuntu-operated
desktop system with 64 GB RAM and an Xeon(R) 3.50 GHz processor.
Performance Measurement
We have conducted each experiment three times, and average results are reported.
In our experiment, we calculate two types of regret: Unsatisfied and Excessive, which
leads to total regret.
5.3 Methods in the Experimentation
5.3.1 Baseline Methodologies
We have made a comparison of our proposed approaches with existing baseline solution
methodologies.
Random Allocation
In this method, first, sort each advertiser in descending order based on budget effective-
ness, i.e., total budget over total influence demand. Next, billboard slots are allocated
uniformly at random to the advertisers one by one to fulfill their zone-specific influ-
ence demand. This allocation scheme will continue till all advertisers are satisfied or
billboard slots run out.
Top-k Allocation
At first, the individual influence of all billboard slots is computed, and based on
influence value, slots are sorted in descending order. Similarly, advertisers are also
sorted based on budget effectiveness in descending order. Next, from this sorted list,
billboard slots are allocated to each advertiser one by one till the influence demand of
all the advertisers is satisfied or no more slots remain to allocate.
19

---

5.3.2 Proposed Methodologies
Here, we describe our proposed methods briefly.
Budget-Effective Greedy (RG)
Budget Effective Greedy is the heuristic approach where, in each step, we compute
the marginal gain for all billboard slots and pick one slot among them, which reduces
the total regret best. This process will continue till all the advertisers are satisfied or
billboard slots run out.
Randomized Budget-Effective Greedy (RG)
It is a randomized heuristic greedy approach where in each step, instead of computing
marginal gain for all billboard slots, we compute marginal gain from randomly sam-
pling out a billboard slot set P of size
|BSzj |
|S′
i| log 1
ϵ , which in turn overlaps with BSzj
with the probability of (1 −ϵ), and pick out billboard slot which reduces the regret
best. These slots are allocated to the advertisers one by one until all advertisers are
satisfied or no billboard slots remain to allocate.
Randomized Synchronous Greedy (RSG)
We introduce the Randomized Synchronous Greedy Approach to overcome the draw-
backs of both the ‘BG’ and ‘RG’ approaches. The ‘BG’ satisfied many advertisers
with minimal regret but took substantial computational time. On the other hand,
‘RG’ compromises with regret but reduces computational time. Both approaches suf-
fer from higher total regret in which, in most cases, an unsatisfied penalty plays an
important role. To resolve this issue, ‘RSG’ first allocates billboard slots to the adver-
tisers using the ‘RG’ approach. Next, if more than two advertisers are still unsatisfied,
remove them one by one according to less budget effectiveness. In that way, we can
reduce unsatisfied regret. However, excessive regret increases, and the overall regret
decreases compared to the ‘RG’.
Randomized Advertiser Exchange Approach (RAE)
The ‘RAE’ approach is a randomized local search approach. After allocating billboard
slots to the advertisers using the ‘RSG’ approach, there may always be a chance that
a better allocation exists compared to the current allocation. To address this, in the
‘RAE’ approach, we exchange billboard slots among advertisers; if swapping slots
will minimize total regret, then exchange occurs. In that way, we finally get a better
allocation on top of the ‘RSG’ approach.
5.4 Goals of Our Experimentation
We fix the following research questions:
• RQ1: What will happen if the influence provider’s maximum supply, (σh) is far
below, near, or exceeded by the total global demand, (σA) of all advertisers?
• RQ2: Which kind of advertiser is more beneficial to the influence provider in terms
of reducing regret?
20

---

• RQ3: Varying δ with a fixed value of λ, and |A|, how the regret value change?
• RQ4: Varying δ with a fixed value of λ, and |A|, how the computational cost change?
• RQ5: How the penalty ratio, γ and the speed-up parameter, ϵ impact on minimizing
regret?
6 Results and Discussions
In this section, we discuss the experimental results and the impacts of different param-
eters on the NYC and LA datasets. We formulate total regret by combining two
components: unsatisfied regret and excessive regret, as described in definition 3. To
address RQ1, we vary the demand-supply ratio (δ), from 40% to 120%. When δ value
is very low, i.e., maximum influence supply (σh) is high and global demand (σA)
is low, almost all the advertisers are satisfied. However, when the δ value is higher,
then σA is also higher or even exceeds the total influence supply. So, the number of
satisfied advertisers becomes less. Next, to answer RQ2, we vary the average individ-
ual demand-supply ratio from 1% to 20%, which represents the individual demand of
advertisers from low to high. In the following, to address the research questions RQ3,
RQ4, and RQ5, we present the experimental results of both the NYC and LA datasets.
6.1 Effectiveness Study
We represent our results under four significant cases of the NYC and LA datasets. To
describe total regret in the results, we use stacked bars, and two components in each
bar denote the percentage of unsatisfied regret and excessive regret, respectively. It
is possible that in the results, only one component is in the stacked bar (e.g., when
all the advertisers are fully satisfied, then unsatisfied regret is zero). Next, we discuss
experimental observations over the NYC dataset.
6.1.1 Observations over NYC dataset
Case 1: δ ≤80%, λ ≤5% (parts (a, b, c, f, g, h, k, ℓ, m) of Figure 2. This refers
to the situation where both global and individual demand are low. So, the influence
provider has advertisers whose influence demand is minimal. As the δ value is low, the
influence supply is higher than the global influence demand of the advertisers. However,
in most cases, zone-specific influence demand is not satisfied for a few advertisers, and
they remain unsatisfied. Total regret consists of excessive and unsatisfied regret in most
cases except the ‘RSG’ and ‘RAE’. Now, we have two main observations. First, when
δ increases, excessive regret decreases, and unsatisfied regret increases. This is because
when δ increases, the zone-specific global influence demand also increases. As every
zone has only a limited number of billboard slots, the zone-specific influence demand
of each advertiser is not satisfied. Second, in most experiments, ‘RSG’ and ‘RAE’
control the unsatisfied regret much better than ‘BG’ and ‘RG’. The ‘RSG’ can satisfy
more advertisers because it releases unsatisfied advertisers individually and allocates
released slots to the remaining unsatisfied ones. The ‘RAE’ exchanges billboard slots
between advertisers according to the solution of ’RSG’. So, ‘RAE’ can satisfy more or
an equal number of advertisers than ’RSG’. Third, in the base case where δ = 40%
21

---

and λ = 1%, i.e., the global influence demand is deficient compared to the influence
supply. The influence provider has advertisers with small influence demand. However,
a few advertisers are unsatisfied due to not fulfilling zone-specific influence demand.
For example, ‘RG’, ‘BG’, ‘RSG’ and ‘RAE’ numbers of satisfied advertisers are 64, 66,
69, and 69, respectively. The ‘RSG’ and ‘RAE’ outperform ‘RG’ by about 47% and
49%, respectively.
Unsatisfied Regret
Excessive Regret
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
3 5 k
R e g r e t
A l g o r i t h m
s
2 . 0 %
9 8 . 0 %
2 . 0 %
9 8 . 0 %
4 3 . 0 %
5 7 . 0 %
4 3 . 0 %
5 7 . 0 %
4 7 . 0 %
5 3 . 0 %
6 9 . 0 %
3 1 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
R e g r e t
A l g o r i t h m
s
8 1 . 0 %
1 9 . 0 %
7 0 . 0 %
3 0 . 0 %
5 7 . 0 %
4 3 . 0 %
5 4 . 0 %
4 6 . 0 %
2 . 0 %
9 8 . 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
R e g r e t
A l g o r i t h m
s
8 5 . 0 %
1 5 . 0 %
8 2 . 0 %
1 8 . 0 %
7 2 . 0 %
2 8 . 0 %
6 8 . 0 %
3 2 . 0 %
6 . 0 %
9 4 . 0 %
4 . 0 %
9 6 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
R e g r e t
A l g o r i t h m
s
5 . 0 %
9 5 . 0 %
6 . 0 %
9 6 . 0 %
7 6 . 0 %
2 4 . 0 %
7 9 . 0 %
2 1 . 0 %
8 8 . 0 %
1 2 . 0 %
9 0 . 0 %
1 0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
9 3 . 0 %
7 . 0 %
9 5 . 0 %
5 . 0 %
9 1 . 0 %
9 . 0 %
8 2 . 0 %
1 8 . 0 %
8 . 0 %
9 2 . 0 %
9 . 0 %
9 1 . 0 %
(a) δ = 40%
(b) δ = 60%
(c) δ = 80%
(d) δ = 100%
(e) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
3 3 . 0 %
6 7 . 0 %
4 5 . 0 %
5 5 . 0 %
8 3 . 0 %
1 7 . 0 %
8 7 . 0 %
1 3 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
3 5 k
4 0 k
4 5 k
R e g r e t
A l g o r i t h m
s
8 9 . 0 %
1 1 . 0 %
9 1 . 0 %
9 . 0 %
7 6 . 0 %
2 4 . 0 %
6 7 . 0 %
3 3 . 0 %
1 3 . 0 %
8 7 . 0 %
1 1 . 0 %
8 9 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
8 . 0 %
9 2 . 0 %
7 4 . 0 %
2 6 . 0 %
8 7 . 0 %
1 3 . 0 %
9 7 . 0 %
3 . 0 %
9 9 . 0 %
1 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
9 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 0 %
1 . 0 %
9 9 . 5 %
0 . 5 %
9 3 . 0 %
7 . 0 %
8 7 . 0 %
1 3 . 0 %
1 9 . 0 %
8 1 . 0 %
1 6 . 0 %
8 4 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
3 0 . 0 %
7 0 . 0 %
3 1 . 0 %
6 9 . 0 %
9 2 . 0 %
8 . 0 %
9 7 . 0 %
3 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
(f) δ = 40%
(g) δ = 60%
(h) δ = 80%
(i) δ = 100%
(j) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
3 5 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
9 4 . 0 %
6 . 0 %
7 2 . 0 %
2 8 . 0 %
5 3 . 0 %
4 7 . 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
R e g r e t
A l g o r i t h m
s
3 8 . 0 %
6 2 . 0 %
4 0 . 0 %
6 0 . 0 %
8 9 . 0 %
1 1 . 0 %
9 7 . 0 %
3 . 0 %
9 3 . 0 %
7 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
9 9 . 5 %
0 . 5 %
9 8 . 0 %
2 . 0 %
9 6 . 0 %
4 . 0 %
8 3 . 0 %
1 7 . 0 %
8 7 . 0 %
1 3 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
9 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
9 8 . 0 %
2 . 0 %
9 9 . 0 %
1 . 0 %
9 8 . 0 %
2 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
1 2 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
1 0 0 %
0 . 0 %
9 9 . 0 %
1 . 0 %
9 7 . 0 %
3 . 0 %
9 2 . 0 %
8 . 0 %
9 2 . 0 %
8 . 0 %
(k) δ = 40%
(l) δ = 60%
(m) δ = 80%
(n) δ = 100%
(o) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
3 5 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
9 8 . 0 %
2 . 0 %
9 9 . 0 %
1 . 0 %
9 0 . 0 %
1 0 . 0 %
9 0 . 0 %
1 0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
9 8 . 0 %
2 . 0 %
9 8 . 0 %
2 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
9 0 . 0 %
1 0 . 0 %
9 0 . 0 %
1 0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
9 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
1 2 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
(p) δ = 40%
(q) δ = 60%
(r) δ = 80%
(s) δ = 100%
(t) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
3 5 k
4 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 5 k
3 0 k
4 5 k
6 0 k
7 5 k
9 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
1 2 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
(u) δ = 40%
(v) δ = 60%
(w) δ = 80%
(x) δ = 100%
(y) δ = 120%
Fig. 2: Regret varying δ, when λ = 1%, |A| = 100 (a, b, c, d, e), when λ = 2%, |A| = 50
(f, g, h, i, j), when λ = 5%, |A| = 20 (k, ℓ, m, n, o), when λ = 10%, |A| = 10
(p, q, r, s, t), when λ = 20%, |A| = 5 (u, v, w, x, y), for NYC dataset
22

---

Case 2: δ ≤80%,, λ ≥10% (parts (p, q, r, u, v, w) of Figure 2. This refers to a
situation where global influence demand is low. However, individual influence demand
is high. The influence provider has a small number of advertisers, and each advertiser’s
influence demand is high. We have three observations. First, as individual influence
demand is high, excessive regret for all the proposed and baseline methods drops in
most results. The number of satisfied advertisers is much less; as a result, unsatis-
fied penalty plays a significant role in total regret. Second, due to higher individual
influence demand, influence providers allocate more billboard slots to the advertisers.
When δ increases from 40% to 80%, the unsatisfied regret rises for all the proposed
and baseline approaches. Third, the ‘RSG’ and ‘RAE’ return minimum total regret
by releasing advertisers individually. The ‘RAE’ has a more extensive search space to
exchange billboard slots among advertisers to reduce total regret. For example, con-
sider a scenario when δ = 40%, λ = 10%, and |A| = 10 then ‘RAE’ outperforms ‘RG’,
and ‘BG’ by about 89%, and 88%, respectively.
Case 3: δ ≥100%,, λ ≤5% (parts (d, e, i, j, n, o) of Figure 2. This represents a
scenario where global demand is very high, but individual influence demand is low. The
influence provider has a large number of advertisers with small individual influence
demand. We have two main observations. First, in the context of a significantly higher
global demand, it is evident that none of the algorithms can satisfy the requirements
of all advertisers. Hence, the unsatisfied penalty becomes higher and substantially
contributes to total regret. Here, two cases arise: (1) when δ = 100%, the global
demand and supply are equal. However, there is unsatisfied regret as the excessive
regret can not be minimized. (2) when δ = 120%, the global influence demand exceeds
the total influence supply. So, unsatisfied regret increases. Second, the ‘RSG’ and
‘RAE’ reduce total regret compared to the ‘RG’ and ‘BG’ but scarifies the majority
of unsatisfied advertisers. For example, consider a scenario when δ = 100%, λ = 1%,
and |A| = 100 then ‘RAE’ outperforms ‘RG’ and ‘BG’ by about 82%, and 80%,
respectively. However, the ‘RAE’ satisfies equal or more advertisers than ‘BG’ and
‘RG.’
Case 4: δ ≥100%,, λ ≥10% (parts (s, t, x, y) of Figure 2. According to case 4,
we have a situation where both global and individual influence demand is very high.
The influence provider has a small number of advertisers whose influence demand is
very high. We have two main observations. First, the unsatisfied regret is very high
with higher δ and λ values. However, no excessive regret exists as the advertiser’s zone-
specific influence demand is unsatisfied. Hence, all the proposed and baseline approach
suffers from higher unsatisfied regret. Second, when λ value increases from 10% to
20%, the individual demand also increases. So, the unsatisfied penalty becomes much
higher. All the proposed and baseline approaches produce higher regret except ‘RSG’
and ‘RAE’. The ‘RSG’ reduces total regret and releases many unsatisfied advertisers.
6.1.2 Observations over LA dataset
In our experiments, we have different observations on the LA dataset compared to
the NYC dataset. Here, we discuss experimental results over the LA dataset in four
different cases.
23

---

Case 1: δ ≤80%, λ ≤5% (parts (a, b, c, f, g, h, k, ℓ, m) of Figure 3. Correspond-
ing to case 1, we have low λ, low δ, and this arises a situation where both the global
and individual influence demand is low. The influence provider has a large number of
advertisers with low individual influence demand. we have three main observations.
First, no unsatisfied regret exists because every zone has sufficient billboard slots to
allocate. When δ increases, the excessive regret for all the algorithms drops. Second,
among baseline methods, ‘Top-k’ controls excessive regret better. This is because ‘Top-
k’ allocates the most influential billboard slots individually to the advertisers. So, it
is easy to fulfill the influence demand of all the advertisers with fewer billboard slots.
Now, among the proposed approach the ‘RAE’ performs better than the ‘RG’, and
‘RSG’ methods. Third, all the advertisers are satisfied in a scenario in which δ = 40%
and λ = 1%. The ‘Top-k’ and ‘Random’ outperform the proposed approaches because
they control excessive regret better.
Case 2: δ ≤80%,, λ ≥10% (parts (p, q, r, u, v, w) of Figure 3. Correspond-
ing to case 2, we have low δ and high λ, representing a situation where influence
provider have fewer advertisers with high individual influence demand. We have two
observations. First, although higher individual influence demand, all the advertisers
are satisfied. This is because when λ increases, the number of advertisers becomes less,
and influence provider have to satisfy fewer advertisers. Second, total regret decreases
when the δ value increases from 40% to 80% for all the proposed approaches. As
advertisers have higher individual influence demand, the influence provider can allo-
cate more billboard slots to each. So, the ‘RAE’ has a more extensive search space to
exchange billboard slots between each advertiser. Consequently, ‘RAE’ outperforms
all the proposed approaches, although ‘Random’ and ‘Top-k’ still perform well.
Case 3: δ ≥100%,, λ ≤5% (parts (d, e, i, j, n, o) of Figure 3. This represents
a situation where global influence demand is high and individual influence demand
is low. The influence provider has a larger advertiser base in which advertisers have
a small individual influence demand. We have two main observations. First, with a
high δ value 100% to 120%, the advertiser’s demand equals or exceeds the influence
provider supply. So, the proposed approaches can only satisfy some advertisers as the
excessive regret cannot be diminished. When δ = 120%, none of the algorithms can
satisfy all the advertisers as their influence demand is much less than the influence
supply by the influence provider. Second, the ‘RSG’ and ‘RAE’ impact is much better
than other proposed and baseline methods in reducing total regret. It is important
to highlight that the deployment of slots to the advertisers when the δ value is very
high. However, there is a risk of losing more advertisers as global influence demand
is very high compared to the influence provider supply. The ‘RSG’ and ‘RAE’ handle
the risk best. They averagely outperform the ‘RG’ and ‘BG’ by four times and two
times, respectively.
Case 4: δ ≥100%,, λ ≥10% (parts (s, t, x, y) of Figure 3. According to
case 4, we have a situation where both the global and individual influence demand is
very high. Hence, the influence provider has fewer advertisers with higher individual
influence demand. We have two main observations. First, higher δ and λ will lead
to higher unsatisfied regret to the influence provider. Hence, all the algorithms suffer
from higher regret, and no one can satisfy all the advertisers. The influence provider
24

---

Unsatisfied Regret
Excessive Regret
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 5 k
3 0 k
4 5 k
6 0 k
7 5 k
9 0 k
R e g r e t
A l g o r i t h m
s
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
R e g r e t
A l g o r i t h m
s
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
4 0 . 0 %
6 0 . 0 %
3 8 . 0 %
6 2 . 0 %
3 3 . 0 %
6 7 . 0 %
3 3 . 0 %
6 7 . 0 %
3 . 0 %
9 7 . 0 %
3 . 0 %
9 7 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
5 5 . 0 %
4 5 . 0 %
5 8 . 0 %
4 2 . 0 %
4 8 . 0 %
5 2 . 0 %
4 9 . 0 %
5 1 . 0 %
4 . 0 %
9 6 . 0 %
0 . 0 %
1 0 0 %
(a) δ = 40%
(b) δ = 60%
(c) δ = 80%
(d) δ = 100%
(e) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
1 1 . 0 %
8 9 . 0 %
1 1 . 0 %
8 9 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
1 4 . 0 %
8 6 . 0 %
7 3 . 0 %
2 7 . 0 %
7 4 . 0 %
2 6 . 0 %
7 9 . 0 %
2 1 . 0 %
8 0 . 0 %
2 0 . 0 %
(f) δ = 40%
(g) δ = 60%
(h) δ = 80%
(i) δ = 100%
(j) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 k
4 k
6 k
8 k
1 0 k
1 2 k
1 4 k
1 6 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 9 . 0 %
5 1 . 0 %
5 3 . 0 %
4 7 . 0 %
4 3 . 0 %
5 7 . 0 %
4 0 . 0 %
6 0 . 0 %
4 1 . 0 %
5 9 . 0 %
4 5 . 0 %
5 5 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
R e g r e t
A l g o r i t h m
s
4 9 . 0 %
5 1 . 0 %
5 0 . 0 %
5 0 . 0 %
7 6 . 0 %
2 4 . 0 %
7 6 . 0 %
2 4 . 0 %
7 5 . 0 %
2 5 . 0 %
7 8 . 0 %
2 2 . 0 %
(k) δ = 40%
(l) δ = 60%
(m) δ = 80%
(n) δ = 100%
(o) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 k
4 k
6 k
8 k
1 0 k
1 2 k
1 4 k
1 6 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 k
4 k
6 k
8 k
1 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 k
4 k
6 k
8 k
1 0 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
R e g r e t
A l g o r i t h m
s
9 1 . 0 %
9 . 0 %
9 5 . 0 %
5 . 0 %
8 9 . 0 %
1 1 . 0 %
8 9 . 0 %
1 1 . 0 %
8 3 . 0 %
1 7 . 0 %
8 5 . 0 %
1 5 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
1 2 0 k
1 4 0 k
1 6 0 k
R e g r e t
A l g o r i t h m
s
8 7 . 0 %
1 3 . 0 %
8 6 . 0 %
1 4 . 0 %
9 7 . 0 %
3 . 0 %
9 7 . 0 %
3 . 0 %
9 9 . 0 %
1 . 0 %
9 9 . 0 %
1 . 0 %
(p) δ = 40%
(q) δ = 60%
(r) δ = 80%
(s) δ = 100%
(t) δ = 120%
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 k
2 k
3 k
4 k
5 k
6 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 k
2 k
3 k
4 k
5 k
6 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 k
2 k
3 k
4 k
R e g r e t
A l g o r i t h m
s
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
1 2 0 k
1 4 0 k
R e g r e t
A l g o r i t h m
s
9 5 . 0 %
5 . 0 %
9 5 . 0 %
5 . 0 %
9 4 . 0 %
6 . 0 %
9 6 . 0 %
4 . 0 %
9 7 . 0 %
3 . 0 %
9 9 . 0 %
1 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 0 k
1 0 0 k
1 5 0 k
2 0 0 k
2 5 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 0 %
1 . 0 %
9 9 . 0 %
1 . 0 %
9 9 . 0 %
1 . 0 %
9 9 . 0 %
1 . 0 %
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
(u) δ = 40%
(v) δ = 60%
(w) δ = 80%
(x) δ = 100%
(y) δ = 120%
Fig. 3: Regret varying δ, when λ = 1%, |A| = 100 (a, b, c, d, e), when λ = 2%, |A| = 50
(f, g, h, i, j), when λ = 5%, |A| = 20 (k, l, m, n, o), when λ = 10%, |A| = 10 (p, q, r, s, t),
when λ = 20%, |A| = 5 (u, v, w, x, y), for LA dataset
sacrifices more advertisers due to a low influence supply. Second, when λ increases
from 10% to 20%, the excessive regret decreases while the total regret rises due to
higher unsatisfied regret. Here, one must highlight that the ‘BG’ leads to much higher
unsatisfied regret than other proposed approaches. The ‘RAE’ and ‘RSG’ still perform
better but sacrifice more advertisers to minimize unsatisfied regret. They outperform
the ‘RG’ and ‘BG’ by about four times and three times, respectively.
25

---

Revisit RQ1, RQ2, and RQ3.
After analyzing four NYC and LA datasets cases, we can answer RQ1, RQ2, and RQ3.
(1) As previously discussed, excessive regret dominates total regret when the global
demand is deficient. So, it is difficult to select advertisers for deploying billboard slots
to minimize the total regret. Based on our observations, when the advertiser’s demand
is equal or at most two times larger than the average influence of billboard slots, we
experience higher excessive regret. However, with the increment of advertiser’s demand
by five times or more, the excessive regret decreases, as shown in Figure 2,3 (a, b, c). (2)
Increasing global demand reduces excessive influence, but at the same time, it will lead
to unsatisfied penalties (e.g., Figure 2,3 (d, e, i, j)). We observe that a large number
of small or medium individual-demanded advertisers are ideal for influence providers.
These advertisers are more flexible in allocating billboard slots and will return the
minimum amount of unsatisfied regret to the influence provider. (3) To address RQ3,
we vary δ and λ from 40% to 120% and 1% to 20%. Corresponding observations are
already discussed in four cases, as shown in Figures 2 and 3.
6.2 Efficiency Study
Efficiency is important in such cases where more than a thousand advertisers daily
come to the influence provider with their zone-specific influence requirements, and the
influence provider needs to handle more than a thousand billboards in a city like New
York and Los Angeles. We have conducted experiments over different δ and λ values
for both NYC and LA datasets, as reported in Figures 4 and 5. We have a couple of
observations.
First, the ‘RG’ takes less time than other proposed approaches to deploy billboard
slots to advertisers. The ‘RSG’ and ‘RAE’ approaches take more time than the ‘RG’
because they use the allocation provided by the ‘RG’ as their initial allocation and
further try to improve the effectiveness by releasing advertisers or exchanging billboard
slots among advertisers. The ‘BG’ takes more time than the ‘RG’ because, in each
iteration, it computes the marginal gain for all the billboard slots, while in the ‘RG’,
each iteration only computes the marginal gain for a randomly chosen subset of slots.
Second, when the δ value increases from 40% to 120%, all algorithms’ computa-
tional cost increases except the ‘RAE’. This is because when δ rises, the individual
influence demand of each advertiser also increases. Then, the influence provider must
allocate more billboard slots to the advertisers, producing more extensive search space
and taking more time. Additionally, the number of unsatisfied advertisers and unsat-
isfied regret increases with the rising δ value. Hence, the ‘RSG’ takes more time to
release unsatisfied advertisers and allocate released slots to other unsatisfied ones.
Third, with an increase of λ value from 1% to 20%, all algorithms’ computational
cost decreases except the ‘BG’. When λ increases, the number of advertisers decreases,
and the influence provider needs to allocate billboard slots to a few advertisers. How-
ever, the time requirement for the ‘BG’ is consistent with the increasing λ because of
the large number of marginal gain computations in each iteration.
Fourth, the ‘RAE’ approach increases computational time with the δ increase.
However, in some cases, when exchanging billboard slots does not minimize the total
26

---

regret, or no further improvement occurs during allocation, the algorithm exits, and
its computational time is not much increased as represented in Figure 4 and 5.
Fifth, One thing that needs to be highlighted is that when the δ value increases,
the computational time difference between different δ values is huge in the case of
the ‘RAE’. However, this difference is much less in the case of all other baseline and
proposed algorithms.
Random
Top-k
RG
BG
RSG
RAE
4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

(a) λ = 1%, |A| = 100
(b) λ = 2%, |A| = 50
(c) λ = 5%, |A| = 20
(d) λ = 10%, |A| = 10
(e) λ = 20%, |A| = 5
Fig. 4: Efficiency Study on NYC
Random
Top-k
RG
BG
RSG
RAE
4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

4 0 %
6 0 %
8 0 %
1 0 0 %
1 2 0 %
1 0
1
1 0
2
1 0
3
1 0
4
1 0
5
1 0
6
T i m
e ( S e c . )

(a) λ = 1%, |A| = 100
(b) λ = 2%, |A| = 50
(c) λ = 5%, |A| = 20
(d) λ = 10%, |A| = 10
(e) λ = 20%, |A| = 5
Fig. 5: Efficiency Study on LA
6.3 Additional Parameters Study
This section discusses the additional parameters used in our experiments, e.g., η, γ,
and ϵ. First, we observe that the total regret for all the proposed and baseline meth-
ods increases with the increase of distance (η). As one billboard slot can influence
more trajectories, the influence provider’s supply, σh, increases. While increasing σh
but fixing the value of δ and λ, the advertiser’s demand increases, and consequently,
regret rises proportionally. Second, we observed that γ plays a key role in the increase
of unsatisfied regret. As we previously discussed in Definition 3, γ controls the unsat-
isfied regret for the unsatisfied advertisers. When the γ value is very small, influence
providers suffer from higher regret. However, when the γ value increases, the unsatis-
fied regret decreases, as represented in Figure 6 and 7. Third, the accuracy speed-up
parameter, ϵ, plays a crucial role in the ‘RG’, ‘RSG’, and ‘RAE’ algorithms, and from
Figure 8 and 9, it is clear that when ϵ value increases, total regret also increases, but
computational time decreases.
27

---

Unsatisfied Regret
Excessive Regret
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
8 7 . 0 %
1 3 . 0 %
8 7 . 0 %
1 3 . 0 %
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
1 0 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
9 9 . 0 %
1 . 0 %
6 8 . 0 %
3 2 . 0 %
6 8 . 0 %
3 2 . 0 %
1 0 0 %
0 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 5 k
3 0 k
4 5 k
6 0 k
7 5 k
9 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
9 9 . 5 %
0 . 5 %
9 9 . 0 %
1 . 0 %
9 8 . 0 %
2 . 0 %
9 8 . 0 %
2 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
8 0 . 0 %
2 0 . 0 %
8 2 . 0 %
1 8 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
9 9 . 5 %
0 . 5 %
7 9 . 0 %
2 1 . 0 %
7 9 . 0 %
2 1 . 0 %
1 0 0 %
0 . 0 %
1 0 0 %
0 . 0 %
(a) γ = 0
(b) γ = 0.25
(c) γ = 0.5
(d) γ = 0.75
(e) γ = 1
Fig. 6: Regret on varying γ, when λ = 5%, |A| = 20, ϵ = 0.01 for NYC dataset
Unsatisfied Regret
Excessive Regret
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
R e g r e t
A l g o r i t h m
s
7 8 . 0 %
2 2 . 0 %
6 3 . 0 %
3 7 . 0 %
8 1 . 0 %
1 9 . 0 %
6 3 . 0 %
3 7 . 0 %
7 5 . 0 %
2 5 . 0 %
7 6 . 0 %
2 4 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
R e g r e t
A l g o r i t h m
s
7 3 . 0 %
2 7 . 0 %
5 8 . 0 %
4 2 . 0 %
5 0 . 0 %
5 0 . 0 %
5 2 . 0 %
4 8 . 0 %
5 1 . 0 %
4 9 . 0 %
5 4 . 0 %
4 6 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 9 . 0 %
5 1 . 0 %
5 3 . 0 %
4 7 . 0 %
4 3 . 0 %
5 7 . 0 %
4 0 . 0 %
6 0 . 0 %
4 1 . 0 %
5 9 . 0 %
4 5 . 0 %
5 5 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
3 k
6 k
9 k
1 2 k
1 5 k
1 8 k
2 1 k
2 4 k
R e g r e t
A l g o r i t h m
s
4 6 . 0 %
5 4 . 0 %
4 6 . 0 %
5 4 . 0 %
3 5 . 0 %
6 5 . 0 %
3 5 . 0 %
6 5 . 0 %
3 5 . 0 %
6 5 . 0 %
3 6 . 0 %
6 4 . 0 %
R a n d o m
T o p - K
R G
B G
R S G
R A E
0
4 k
8 k
1 2 k
1 6 k
2 0 k
R e g r e t
A l g o r i t h m
s
3 6 . 0 %
6 4 . 0 %
5 0 . 0 %
5 0 . 0 %
2 2 . 0 %
7 8 . 0 %
1 9 . 0 %
8 1 . 0 %
2 5 . 0 %
7 5 . 0 %
1 8 . 0 %
8 2 . 0 %
(a) γ = 0
(b) γ = 0.25
(c) γ = 0.5
(d) γ = 0.75
(e) γ = 1
Fig. 7: Regret on varying γ, when λ = 5%, |A| = 20, ϵ = 0.01 for LA dataset
Unsatisfied Regret
Excessive Regret
R G
R S G
R A E
0
1 5 k
3 0 k
4 5 k
6 0 k
7 5 k
9 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
9 8 . 0 %
2 . 0 %
9 8 . 0 %
2 . 0 %
R G
R S G
R A E
0
1 0 k
2 0 k
3 0 k
4 0 k
5 0 k
6 0 k
7 0 k
8 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
8 2 . 0 %
1 8 . 0 %
8 2 . 0 %
1 8 . 0 %
R G
R S G
R A E
0
1 5 k
3 0 k
4 5 k
6 0 k
7 5 k
9 0 k
R e g r e t
A l g o r i t h m
s
1 0 0 %
0 . 0 %
8 8 . 0 %
1 2 . 0 %
8 8 . 0 %
1 2 . 0 %
R G
R S G
R A E
0
2 0 k
4 0 k
6 0 k
8 0 k
R e g r e t
A l g o r i t h m
s
9 9 . 5 %
0 . 5 %
7 6 . 0 %
2 4 . 0 %
7 6 . 0 %
2 4 . 0 %
R G
R S G
R A E
0
1 5 k
3 0 k
4 5 k
6 0 k
7 5 k
9 0 k
R e g r e t
A l g o r i t h m
s
7 3 . 0 %
2 7 . 0 %
7 3 . 0 %
2 7 . 0 %
1 0 0 %
0 . 0 %
(a) ϵ = 0.01
(b) ϵ = 0.05
(c) ϵ = 0.1
(d) ϵ = 0.15
(e) ϵ = 2
Fig. 8: Regret on varying ϵ, when λ = 5%, |A| = 20, γ = 0.5 for NYC dataset
Revisit RQ4, and RQ5.
Based on our observations in section 6.2 and 6.3, we can answer RQ4 and RQ5.
(1) when we vary the δ value from 40% to 120%, the computational cost for all the
algorithms also rises for both the NYC and LA datasets. With the increasing value of
δ, each advertiser’s individual influence demand and unsatisfied regret also increases.
(2) when γ value increases from 0 to 1, the total regret of an advertiser decreases.
γ = 0 provides higher regret while γ = 1 provides lower regret as only the fraction of
influence provided to the advertiser is returning as regret. Next, with the increase ϵ, an
advertiser’s total regret increases because the randomly selected sample size decreases
and degrades the solution quality.
28

---

Unsatisfied Regret
Excessive Regret
R G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 0 . 0 %
6 0 . 0 %
4 1 . 0 %
5 9 . 0 %
4 5 . 0 %
5 5 . 0 %
R G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 1 . 0 %
5 9 . 0 %
3 9 . 0 %
6 1 . 0 %
4 3 . 0 %
5 7 . 0 %
R G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 8 . 0 %
5 2 . 0 %
3 6 . 0 %
6 4 . 0 %
3 9 . 0 %
6 1 . 0 %
R G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 2 . 0 %
5 8 . 0 %
3 9 . 0 %
6 1 . 0 %
4 2 . 0 %
5 8 . 0 %
R G
R S G
R A E
0
5 k
1 0 k
1 5 k
2 0 k
2 5 k
3 0 k
R e g r e t
A l g o r i t h m
s
4 2 . 0 %
5 8 . 0 %
4 0 . 0 %
6 0 . 0 %
4 3 . 0 %
5 7 . 0 %
(a) ϵ = 0.01
(b) ϵ = 0.05
(c) ϵ = 0.1
(d) ϵ = 0.15
(e) ϵ = 2
Fig. 9: Regret on varying ϵ, when λ = 5%, |A| = 20, γ = 0.5 for LA dataset
7 Conclusion and Future Directions
In this paper, we have studied the problem of regret minimization in billboard adver-
tisements under zonal influence constraint in a multi-advertiser setting. We have
proposed a Budget-Effective Greedy algorithm to allocate billboard slots to the adver-
tisers. To improve its performance further, we proposed the ‘RG’, ‘RSG’, and ‘RAE’
algorithms. All the methods have been analyzed to understand their time and space
requirements. They have been implemented with real-world datasets and compared
with existing methods to show their effectiveness and efficiency. Our future study of
this problem will focus on developing more efficient local search techniques to improve
the performance further.
References
[1] Li, Y., Fan, J., Wang, Y., Tan, K.-L.: Influence maximization on social graphs:
A survey. IEEE Transactions on Knowledge and Data Engineering 30(10), 1852–
1872 (2018) https://doi.org/10.1109/TKDE.2018.2807843
[2] Wang, L., Yu, Z., Guo, B., Yang, D., Ma, L., Liu, Z., Xiong, F.: Data-
driven targeted advertising recommendation system for outdoor billboard. ACM
Transactions on Intelligent Systems and Technology (TIST) 13(2), 1–23 (2022)
[3] Zhang, P., Bao, Z., Li, Y., Li, G., Zhang, Y., Peng, Z.: Towards an optimal outdoor
advertising placement: when a budget constraint meets moving trajectories. ACM
Transactions on Knowledge Discovery from Data (TKDD) 14(5), 1–32 (2020)
[4] Wang, L., Yu, Z., Yang, D., Ma, H., Sheng, H.: Efficiently targeted billboard
advertising using crowdsensing vehicle trajectory data. IEEE transactions on
industrial informatics 16(2), 1058–1066 (2019)
[5] Zhang, Y., Bao, Z., Mo, S., Li, Y., Zhou, Y.: Itaa: An intelligent trajectory-
driven outdoor advertising deployment assistant. Proc. VLDB Endow. 12(12),
1790–1793 (2019) https://doi.org/10.14778/3352063.3352067
[6] Lotfi, R., Mehrjerdi, Y.Z., Mardani, N.: A multi-objective and multi-product
29

---

advertising billboard location model with attraction factor mathematical mod-
eling and solutions. International journal of applied logistics (IJAL) 7(1), 64–86
(2017)
[7] Zhang, Y., Li, Y., Bao, Z., Zheng, B., Jagadish, H.: Minimizing the regret of
an influence provider. In: Proceedings of the 2021 International Conference on
Management of Data, pp. 2115–2127 (2021)
[8] Ali, D., Banerjee, S., Prasad, Y.: Influential billboard slot selection using pruned
submodularity graph. In: International Conference on Advanced Data Mining and
Applications, pp. 216–230 (2022). Springer
[9] Ali, D., Bhagat, A.K., Banerjee, S., Prasad, Y.: Efficient algorithms for regret
minimization in billboard advertisement (student abstract). In: Proceedings of
the AAAI Conference on Artificial Intelligence, vol. 37, pp. 16148–16149 (2023)
[10] Zhang, Y., Li, Y., Bao, Z., Mo, S., Zhang, P.: Optimizing impression counts for
outdoor advertising. In: Proceedings of the 25th ACM SIGKDD International
Conference on Knowledge Discovery & Data Mining, pp. 1205–1215 (2019)
[11] Cabello, S., Langerman, S., Seara, C., Ventura, I.: Reverse Facility Location
Problems. Citeseer, ??? (2006)
[12] Cabello, S., D´ıaz-B´a˜nez, J.M., Langerman, S., Seara, C., Ventura, I.: Facility loca-
tion problems in the plane based on reverse nearest neighbor queries. European
Journal of Operational Research 202(1), 99–106 (2010)
[13] Du, Y., Zhang, D., Xia, T.: The optimal-location query. In: Bauzer Medeiros, C.,
Egenhofer, M.J., Bertino, E. (eds.) Advances in Spatial and Temporal Databases,
pp. 163–180. Springer, Berlin, Heidelberg (2005)
[14] Xia, T., Zhang, D., Kanoulas, E., Du, Y.: On computing top-t most influential
spatial sites. In: Proceedings of the 31st International Conference on Very Large
Data Bases. VLDB ’05, pp. 946–957. VLDB Endowment, ??? (2005)
[15] Stanoi, I., Riedewald, M., Agrawal, D., Abbadi, A.E.: Discovery of influence sets
in frequently updated databases. In: Proceedings of the 27th International Con-
ference on Very Large Data Bases. VLDB ’01, pp. 99–108. Morgan Kaufmann
Publishers Inc., San Francisco, CA, USA (2001)
[16] Zhou, Z., Wu, W., Li, X., Lee, M.L., Hsu, W.: Maxfirst for maxbrknn. In: 2011
IEEE 27th International Conference on Data Engineering, pp. 828–839 (2011).
https://doi.org/10.1109/ICDE.2011.5767892
[17] Huang, J., Wen, Z., Qi, J., Zhang, R., Chen, J., He, Z.: Top-k most influential
locations selection. In: Proceedings of the 20th ACM International Conference on
Information and Knowledge Management. CIKM ’11, pp. 2377–2380. Association
30

---

for Computing Machinery, New York, NY, USA (2011). https://doi.org/10.1145/
2063576.2063971 . https://doi.org/10.1145/2063576.2063971
[18] Wang, S., Bao, Z., Culpepper, J.S., Cong, G.: A survey on trajectory data
management, analytics, and learning. ACM Comput. Surv. 54(2) (2021) https:
//doi.org/10.1145/3440207
[19] Guo, L., Zhang, D., Cong, G., Wu, W., Tan, K.-L.: Influence maximization
in trajectory databases. In: 2017 IEEE 33rd International Conference on Data
Engineering (ICDE), pp. 27–28 (2017). https://doi.org/10.1109/ICDE.2017.20
[20] Zhang, Y., Li, Y., Bao, Z., Mo, S., Zhang, P.: Optimizing impression counts for
outdoor advertising. In: Proceedings of the 25th ACM SIGKDD International
Conference on Knowledge Discovery & Data Mining. KDD ’19, pp. 1205–1215.
Association for Computing Machinery, New York, NY, USA (2019). https://doi.
org/10.1145/3292500.3330829 . https://doi.org/10.1145/3292500.3330829
[21] Wang, L., Yu, Z., Yang, D., Ma, H., Sheng, H.: Efficiently targeted bill-
board advertising using crowdsensing vehicle trajectory data. IEEE Transactions
on Industrial Informatics 16(2), 1058–1066 (2020) https://doi.org/10.1109/TII.
2019.2891258
[22] Zahr´adka, J., Machov´a, V., Kuˇcera, J.: What is the price of outdoor advertising:
A case study of the czech republic? Ad Alta: Journal of Interdisciplinary Research
(2021)
[23] Zhang, P., Bao, Z., Li, Y., Li, G., Zhang, Y., Peng, Z.: Trajectory-driven influential
billboard placement. In: Proceedings of the 24th ACM SIGKDD International
Conference on Knowledge Discovery & Data Mining, pp. 2748–2757 (2018)
[24] Ali, D., Banerjee, S., Prasad, Y.: Influential billboard slot selection using spa-
tial clustering and pruned submodularity graph. arXiv preprint arXiv:2305.08949
(2023)
[25] Wang, L., Yu, Z., Guo, B., Yang, D., Ma, L., Liu, Z., Xiong, F.: Data-driven
targeted advertising recommendation system for outdoor billboard. ACM Trans.
Intell. Syst. Technol. 13(2) (2022) https://doi.org/10.1145/3495159
[26] Liu, D., Weng, D., Li, Y., Bao, J., Zheng, Y., Qu, H., Wu, Y.: Smartadp: Visual
analytics of large-scale taxi trajectories for selecting billboard locations. IEEE
Transactions on Visualization and Computer Graphics 23, 1–10 (2017)
[27] Nanongkai, D., Sarma, A.D., Lall, A., Lipton, R.J., Xu, J.: Regret-minimizing
representative databases. Proc. VLDB Endow. 3(1–2), 1114–1124 (2010) https:
//doi.org/10.14778/1920841.1920980
[28] Peng, P., Wong, R.C.-W.: Geometry approach for k-regret query. In: 2014 IEEE
31

---

30th International Conference on Data Engineering, pp. 772–783 (2014). https:
//doi.org/10.1109/ICDE.2014.6816699
[29] Xie, M., Wong, R.C.-W., Li, J., Long, C., Lall, A.: Efficient k-regret query algo-
rithm with restriction-free bound for any dimensionality. In: Proceedings of the
2018 International Conference on Management of Data. SIGMOD ’18, pp. 959–
974. Association for Computing Machinery, New York, NY, USA (2018). https:
//doi.org/10.1145/3183713.3196903 . https://doi.org/10.1145/3183713.3196903
[30] Xie, M., Wong, R.C.-W., Lall, A.: Strongly truthful interactive regret mini-
mization. In: Proceedings of the 2019 International Conference on Management
of Data. SIGMOD ’19, pp. 281–298. Association for Computing Machinery,
New York, NY, USA (2019). https://doi.org/10.1145/3299869.3300068 . https:
//doi.org/10.1145/3299869.3300068
[31] Aslay, C., Lu, W., Bonchi, F., Goyal, A., Lakshmanan, L.V.S.: Viral marketing
meets social advertising: Ad allocation with minimum regret. Proc. VLDB Endow.
8(7), 814–825 (2015) https://doi.org/10.14778/2752939.2752950
32

---

