# GridTuner: Reinvestigate Grid Size Selection for Spatiotemporal Prediction Model

> 来源: https://arxiv.org/pdf/2201.03244

GridTuner: Reinvestigate Grid Size Selection for
Spatiotemporal Prediction Models
Jiabao Jin ∗, Peng Cheng ∗, Lei Chen †, Xuemin Lin #,∗, Wenjie Zhang #
∗East China Normal University, Shanghai, China
jiabaojin@163.com, pcheng@sei.ecnu.edu.cn
†The Hong Kong University of Science and Technology, Hong Kong, China
leichen@cse.ust.hk
#The University of New South Wales, Australia
lxue@cse.unsw.edu.au, wenjie.zhang@unsw.edu.au
Abstract—With the development of trafﬁc prediction tech-
nology, spatiotemporal prediction models have attracted more
and more attention from academia communities and industry.
However, most existing researches focus on reducing model’s
prediction error but ignore the error caused by the uneven
distribution of spatial events within a region. In this paper, we
study a region partitioning problem, namely optimal grid size
selection problem (OGSS), which aims to minimize the real error
of spatiotemporal prediction models by selecting the optimal grid
size. In order to solve OGSS, we analyze the upper bound of real
error of spatiotemporal prediction models and minimize the real
error by minimizing its upper bound. Through in-depth analysis,
we ﬁnd that the upper bound of real error will decrease then
increase when the number of model grids increase from 1 to
the maximum allowed value. Then, we propose two algorithms,
namely Ternary Search and Iterative Method, to automatically
ﬁnd the optimal grid size. Finally, the experiments verify that the
error of prediction has the same trend as its upper bound, and
the change trend of the upper bound of real error with respect
to the increase of the number of model grids will decrease then
increase. Meanwhile, in a case study, by selecting the optimal grid
size, the order dispatching results of a state-of-the-art prediction-
based algorithm can be improved up to 13.6%, which shows the
effectiveness of our methods on tuning the region partition for
spatiotemporal prediction models.
I. INTRODUCTION
Recently, many spatiotemporal prediction models are pro-
posed to predict the number of events (e.g., online car-hailing
requests [1], [2], [3], or street crimes [4], [5]) within a region
(e.g., a gird of 1km×1km) in a period (e.g., next 30 minutes)
[6], [7], [8]. With the help of predicted information of events,
we can improve the platform revenue of online car-hailing
systems (e.g., Uber [9]), or reduce crimes effectively through
optimizing patrol route of police [5].
One common assumption of spatiotemporal prediction mod-
els is that the distribution of spatial events within a region is
uniform [1], [6], [2], which is in fact almost never true in real
scenarios. In addition, the selection of region size is mostly
decided by experts’ experience or simple experimental tests
without detailed analysis in many existing research studies:
• “We use 20×30 = 600 grids to cover the cities and one grid
represents a 0.01 (longitude)×0.01 (latitude) square” [1]
• The authors use 32×32 grids to cover Beijing area and 16×8
grids for New York City area [6].
Fig. 1: Forecast and Actual Distribution of Orders in Grids
• “For the prediction model, DeepST, we set the default grid
size as 2km×2km ...” [2]
Under the uniform region assumption, the spatiotemporal
prediction models are optimized to minimize the model error
in model grids (i.e., the difference between the predicted and
actual number of spatial events in grids used in the prediction
model), which may lead to dramatic real errors in some smaller
regions (i.e., the difference between the predicted and the
actual number of spatial events in smaller and homogeneous
grids). Then, the overall performance of frameworks utilizing
spatiotemporal prediction models will not be optimized for
real applications. For example, with careful grid size selection,
the overall performance of a state-of-the-art prediction based
online spatial crowdsourcing framework [1] can be increased
up to 13.6% (shown in a case study in Section V).
We illustrate this challenge with the following example:
Example 1. As shown in Figure 1, the solid black lines divide
the space into four model grids to be predicted. The blue dot
lines further divide each model grid into four smaller grids.
We can use spatiotemporal prediction models to predict the
number of events in each model grid. In the absence of prior
knowledge of the distribution of events within a model grid, the
models generally assume that the distribution of events within
a model grid is uniform, which means that the number of
events in each smaller grid within a same model grid is equal
to each other. Thus, we can estimate the predicted number of
each smaller grid through averaging the predicted result of the
corresponding model grid. The red number shown in Figure 1
denotes the predicted number of events for each smaller grid.
arXiv:2201.03244v1  [cs.DB]  10 Jan 2022

---

The predicted result for each model grid is the summation of
the number of events for all its smaller grids. We can directly
calculate the model error of the prediction model on large
grids is 3 (= |8−9|+|2−1|+|4−4|+|4−5|). Nevertheless,
if the model error is calculated based on smaller grids, it will
increase to 10 (= |2 −3| + |2 −2| + |0.5 −0| + |0.5 −0| +
|2 −3| + |2 −1| + |0.5 −0| + |0.5 −1| + |1 −0| + |1 −3| +
|1 −1| + |1 −1| + |1 −0| + |1 −1| + |1 −1| + |1 −2|). The
reason is that the distribution of events in each large grid is
uneven, which is ignored in almost all existing studies.
Why not directly predict the spatial events for each smaller
grid? The reason is twofold. Firstly, due to the uncertainty of
spatial events, it is too hard to accurately predict the number of
spatial events in a very small grid (e.g., 100m×100m). When
the size of grid is too small, there will be no enough historical
data for prediction model to learn the distribution of the spatial
events in each small area. In addition, the number of spatial
events in a small grid is also small, then the accuracy (relative
error) of prediction models will be dramatically affected by
the randomness of the spatial events, since the uncertainty
of spatial events is inevitable [10], [1], [11]. Secondly, the
computation complexity of prediction models will increase re-
markably when the number of grids increases [10], [12]. Thus,
almost all spatiotemporal prediction models still use relatively
large grids (e.g., grids of 2km×2km) as the prediction units.
Can we have an automatic and theoretic-guaranteed opti-
mal grid size selection method to minimize the overall real
error of spatiotemporal prediction models? To overcome this
long-standing challenge, in this paper we study the optimal
grid size selection (OGSS) problem to guide the conﬁguration
of grid size such that the real errors are minimized for
spatiotemporal prediction models in real applications.
In this paper, we reinvestigate the grid size selection prob-
lem in spatiotemporal prediction models in detail. We assume
that the distribution of the spatial events in a small enough grid
(e.g., 100m×100m) can be considered homogeneous. Then,
the real error of a spatiotemporal prediction model is evaluated
through the total difference between the predicted number
and real number of spatial events among all small grids.
Speciﬁcally, we decompose the real error of the prediction
models into the model error and the expression error. Here,
the model error indicates the inherent error of the prediction
models, and the expression error stands for the error of using
the predicted number of events in a large grid to express
the future events in its inner smaller grids (as illustrated in
Example 1). We prove that the summation of model error
and expression error of a spatiotemporal prediction model is
an upper bound of its real error. We also verify that for any
spatiotemporal prediction model, with the increase of the size
of grids, the upper bound of its real error will ﬁrst decrease
then increase. Based on our theoretical analysis, we propose
two algorithms, namely Ternary Search algorithm and Iterative
algorithm, to quickly ﬁnd the optimal size of model grids for
a given spatiotemporal prediction model.
To summarize, we make the following contributions:
• We formally deﬁne a novel metric, real error, to measure
the deviation between the model’s forecast and the actual
number of events for homogeneous grids. Then, we propose
a new problem, namely optimal grid size selection (OGSS),
to automatically ﬁnd the optimal grid size for a given
spatiotemporal prediction model in Section II
• We analyze the upper bound of the real error and the
relationship between the number of model grids and the
upper bound in Section III. Then, we propose two algorithms
to ﬁnd the optimal grid size to minimize the upper bound
of real error in Section IV.
• We conduct sufﬁcient experiments on different spatiotem-
poral prediction models to explore the inﬂuencing factors
of real errors in Section V.
We review the related studies in Section VI and conclude
this paper in Section VII.
II. PRELIMINARIES
In this section, we will introduce some basic concepts and
present the formal deﬁnition of model grid, homogeneous grid,
model error, expression error and real error. We prove that the
summation of model error and expression error is an upper
bound of real error.
A. Basic Concepts
Without loss of generality, in this paper, we consider that
the spatiotemporal prediction models will ﬁrst divide the
whole space into n rectangular model grids, then predict the
number of spatial events for each model grid in a given future
time period. When the size of a grid is small enough (e.g.,
100m×100m), the distribution of spatial events can be consid-
ered uniform for most application scenarios (e.g., online car-
hailing systems). Under this assumption, each model grid will
be further divided into m smaller homogeneous grids, where
predicted spatial events is considered uniformly distributed in
each homogeneous grid. To ensure HGrids are small enough,
it is required that the number of HGrids is larger than N (i.e.,
mn > N). We note N as the minimum number that makes the
distribution of spatial events in each HGrid itself is uniform.
We propose a method to select a proper value of N in Section
III. We formally deﬁne the model grids and the homogeneous
grids as follows:
Deﬁnition 1 (Model Grid, MGrid). The whole space is divided
into n same-sized model grids {r1, r2, · · · , rn}. The number
of actual spatial events happening in ri in the next period
is noted as λi. A spatiotemporal prediction model will predict
the number, ˆλi, of spatial events that happening in each model
grid ri in the next period.
Deﬁnition 2 (Homogeneous Grid, HGrid). Each model grid
ri can be further evenly divided into m homogeneous grids
{ri1, ri2, · · · , rim}. For a homogeneous grid rij, the number
of actual spatial events happening in it in the next period is
marked as λij (i.e., λi = Pm
j=1 λij).

---

Fig. 2: An Illustration of Relationships between Basic Concepts.
In the absence of any prior knowledge of the distribution
of the spatial events in a model, we assume that the number
of spatial events of each HGrid in the MGrid is same to each
other according to the principle of maximum entropy [13].
Thus, with the actual number, λi, of spatial events in MGrid
ri, the estimated number of spatial events of HGrid rij is
denoted as ¯λij = λi
m =
Pm
j=1 λij
m
. Similarly, with the predicted
number, ˆλi, of spatial events of MGrid ri, we can have the
predicted number of spatial events of HGrid rij as ˆλij =
ˆλi
m .
The differences between λij, ¯λij and ˆλij lead to three types
of errors: model error, expression error and real error. Figure
2 illustrates the three types of errors. The frameworks utilizing
spatiotemporal prediction models is hard to get the information
about the real distribution of spatial events from the models.
Thus, the prediction result ˆλi of a MGrid ri will be divided
equally into HGrids without any prior information. The real
error describes the difference between the actual number of
spatial events λij and the predicted result ˆλij of HGrid rij.
However, it is difﬁcult to calculate the real error directly.
Therefore, ¯λij is introduced to decompose the real error into
expression error and model error. We formally deﬁne the real
error model error and expression error as follows:
Deﬁnition 3 (Real Error). For a HGrid rij, its real error
Er(i, j) is deﬁned as the mean/average of difference between
its predicted and actual numbers of spatial events in the
corresponding same time periods of the historical days for
the next period. It means Er (i, j) = Eλij ∼P (|ˆλij −λij|), where
λij follows a given distribution P.
In practice, it is difﬁcult to calculate the difference |ˆλij−λij|
without the information about the number λij of events in
next period. Thus, we deﬁne the real error as the mean of
the difference |ˆλij −λij|. However, due to the lack of a
sufﬁcient number of samples, it is difﬁcult for us to calculate
Er (i, j) accurately because λij does not follow the same
distribution for different time periods. Another factor is that
the environment is prone to change over a long period, so the
number of events does not follow the same distribution either.
As a result, we use the number of events in the same time
period on each day of the previous one month to estimate
real error. Suppose that we have a set Λij of the actual events
number, λij, and its corresponding prediction number, ˆλij, we
can estimate Er (i, j) as follows:
Er (i, j) = Eλij ∼P (|ˆλij −λij|) =
1
|Λij|
X
(ˆλij ,λij )∈Λij
|ˆλij −λij|
Deﬁnition 4 (Model Error). For a HGrid rij, its model
error Em(i, j) is the mean/average of difference between
its predicted and estimated numbers of spatial events in the
corresponding same time periods of the historical days for the
next period. It means Em(i, j) = Eλij ∼P (|ˆλij −¯λij|), where λij
follows a given distribution P.
Deﬁnition 5 (Expression Error). For a HGrid rij, its expres-
sion error Ee(i, j) is the mean/average of difference between
its estimated and actual numbers of spatial events in the
corresponding same time periods of the historical days for
the next period. It means Ee(i, j) = Eλij ∼P (|¯λij −λij|), where
λij follows a given distribution P.
In the previous analysis, we explained that the grid size
selection would signiﬁcantly affect the real error. This paper
aims to ﬁnd an optimal size that minimizes the summation of
real errors in all HGrids. We formally deﬁne the problem as
follows:
Deﬁnition 6 (Optimal Grid Size Selection Problem, OGSS).
For a given number of all HGrids N, and a given model to
predict the number of spatial events for MGrids in next period,
the optimal grids size selection problem is to ﬁnd the optimal
n to minimize the summation of real error of all HGrids under
the constraint nm > N, which is:
min
n
n
X
i=1
m
X
j=1
Er(i, j)
(1)
s.t.
nm > N
where m represents the minimum required number of HGrids
in each MGrid satisfying nm > N.
B. Upper Bound of Real Error
We denote the summation of model error and expression
error as Eu (i, j) (= Em (i, j) + Ee (i, j)). We can prove that
Eu (i, j) is an upper bound on Er (i, j) by the theorem II.1.
Theorem II.1 (Upper Bound of Real Error). Eu (i, j) is an
upper bound of real error Er (i, j)
Proof. We prove it through the following inequalities:
Er (i, j) = E

|ˆλij −λij|

= E

|ˆλij −¯λij + ¯λij −λij|

≤E

|ˆλij −¯λij| + |¯λij −λij|

= E

|ˆλij −¯λij|

+ E
 ¯λij −λij

= Em (i, j) + Ee (i, j) = Eu (i, j)
Meanwhile, we obtain the upper bound of the difference
between Eu (i, j) and Er (i, j) by the following scaling:
Eu(i, j) −Er(i, j) ≤E

2 min

|ˆλij −¯λij|, |¯λij −λij|

= 2 min

E
 |¯λij −λij|

, E

|ˆλij −¯λij|

= 2 min (Ee(i, j), Em(i, j))
This indicates that we can ensure that the Er (i, j) is small
when Eu (i, j) is minimized. Therefore, we will minimize
Eu (i, j) as much as possible to optimize OGSS in the

---

TABLE I: Symbols and Descriptions.
Symbol
Description
ri
a MGrid
rij
a HGrid in MGrid ri
n
the number of MGrids
m
the number of HGrids for each MGrid
¯λij
the estimated number of spatial events for HGrid rij
λij
the actual number of spatial events in HGrid rij
λi
the actual number of spatial events in MGrid ri
ˆλi
the prediction of λi
αij
the temporal mean of λij
Er (i, j)
the real error of HGrid rij
Ee (i, j)
the expression error of HGrid rij
Em (i, j)
the model error of HGrid rij
following sections of this paper. Finally, Table I shows some
important notations used in this paper.
III. ERROR ANALYSIS
In this section, we ﬁrst explain how to select a proper N
such that each HGrid is small enough and can be considered
uniform. Then, we discuss the property of expression error and
propose two algorithms to quickly calculate expression error.
Finally, we analyze the model error.
A. Select A Suitable N
We explain how to choose a suitable N in this section. Most
of spatiotemporal prediction models are based on experience
to divide the whole space into many same-sized MGrids (e.g.,
2km×2km grid). However, these methods ignore the uneven
distribution of spatial events within a MGrid.
We divide the whole space into
√
N ×
√
N (i.e., nm = N)
same-sized HGrids. Let αij be the mean number of events
for HGrid rij in the next period, which can be estimated as
the average number of the historical records (i.e., nearest one
month’s data) of rij.
Here, we give the deﬁnition of the uniformly distribution
for a grid as follows:
Deﬁnition 7 (Uniformly Distributed Grid). Given a grid rij
with the expected spatial events number αij and a positive
integer K ∈Z+, we divide the grid into K smaller grids with
the expected spatial events number αijk, k = 1, 2, ..., K. Grid rij
is uniformly distributed if and only if αijk =
αij
K
for any
1 ≤k ≤K.
Then, we introduce a metric to measure the degree of the
uneven distribution for spatial events in HGrids, which is
deﬁned as the following formula:
Dα (N) =
n
X
i=1
m
X
j=1
|αij −¯αN| ,
(2)
where
¯αN
=
1
N
Pn
i=1
Pm
j=1 αij. We notice that when N in-
creases, Dα (N) will also increase. However, when N is large
enough (i.e., spatial events can be considered evenly dis-
tributed in each HGrid), Dα (N) will not signiﬁcantly increase
any more. We prove this with the following theorem:
Theorem III.1. Assume that N is suitable (sufﬁciently large)
such that the spatial events are uniformly distributed in each
HGrid, then Dα (N) = Dα (NK), for any K ∈Z+.
Proof. We divide each HGrid rij into smaller grids denoted
as rijk (k = 1, 2, . . . , K), where the mean number of events
for each smaller grid is denoted as αijk. Due to the uniformity
of each HGrid, we have αijk = αij
K . Thus, we have
Dα (NK)
=
n
X
i=1
m
X
j=1
K
X
k=1
|αijk −¯αNK|
(3)
=
n
X
i=1
m
X
j=1
K

αij
K
−1
K ¯αN
 = Dα (N)
The increase of N will not contribute to the increase of
Dα (N) when N is large enough, which means that Dα (N)
can be an indicator to help us to select N. In other words,
we should choose a sufﬁciently large N so that Dα (N) is
maximized in practice.
B. Analysis and Calculation of Expression Error
We assume that the number λij of events in a HGrid rij
follows a poisson distribution Pois with parameter of αij (αij
is the mean number of events for HGrid rij), which is veriﬁed
in our previous work [3], [14].
Calculation of Expression Error. We ﬁrst analyze how to
calculate expression error for a given HGrid rij. Due to λij ∼
Pois(αij), we have
P (λij = kh) = e−αij αij
kh
kh!
, kh ∈N
(4)
Then, we deﬁne the random variable λi,̸=j as the mean
of the number of events for all HGrids in MGrid ri ex-
cluding the HGrid rij (i.e., λi,̸=j = P
g̸=j λig), and have
λi,̸=j ∼Pois(P
g̸=j αig) because of the additivity of Poisson
distribution. Let ¯λi,̸=j = 1
mλi,̸=j, we have
P (¯λi,̸=j = km
m ) = e−P
g̸=j αig
P
g̸=j αig
km
km!
, km ∈N
(5)
Since λij and ¯λi,̸=j is independent of each other, P(|¯λij −
λij|) can be expressed by
P (|¯λij −λij| = kd
m )
=
P (| m −1
m
λij −¯λi,̸=j| = kd
m )
=
X
| m−1
m
kh−km
m |= kd
m
P (λij = kh) P

¯λi,̸=j = km
m

=
X
(m−1)kh−km
m
=± kd
m
p (rij, kh, km)
(6)
where p (rij, kh, km) = e−Pm
j=1 αij (P
g̸=j αig)km(αij)kh
km!kh!
de-
noting the probability when the number of events in HGrid
rij is kh and the number of events in MGrid ri is kh + km.
Then, we have:
Ee (i, j)
=
E(|λij −¯λij|) =
∞
X
kd=0
kd
m P (|λij −¯λij| = kd
m )
=
∞
X
kd=0
kd
m
X
(m−1)kh−km
m
=± kd
m
p (rij, kh, km)
=
∞
X
kh=0
∞
X
km=0
bkhkm
(7)
where
bkhkm
=
 (m−1)kh−km
m
 p (rij, kh, km).
Here,
p (rij, kh, km) represents the probability when the number of
events in MGrid ri is km + kh and the number of events in
HGrid rij is kh, and the single expression error of HGrid rij
in this situation is
 (m−1)kh−km
m
. Thus, Equation 7 can be
regarded as a weighted average of the single expression error
in all possible cases.

---

We can use Equation 7 to calculate the expression error of
HGrid rij, which also indicates that the expression error is
only related to the αij of each HGrid rij and m.
Properties of expression error. We show that the upper bound
of expression error Ee (i, j) is positively correlated to αij and
m. In other words, when αij or m increases, the upper bound
of expression error Ee (i, j) will also increase. This relationship
is presented with the following lemma:
Lemma III.1. ∀M1, M2 ∈Z+, we have
M1
X
kh=0
M2
X
km=0
bkhkm < (1 −2
m )αij +
Pm
k=1 αik
m
.
Proof.
M1
X
kh=0
M2
X
km=0
bkhkm =
M1
X
kh=0
M2
X
km=0

(m −1)kh −km
m
 p (rij, kh, km)
≤
M1
X
kh=0
M2
X
km=0
 (m −1)kh
m
+ km
m

p (rij, kh, km)
(8)
Considering the ﬁrst term of right hand side of Inequation 8,
we have
M1
X
kh=0
M2
X
km=0
(m −1)kh
m
p (rij, kh, km)
=
M1
X
kh=0
M2
X
km=0
(m −1)kh
m
e
−Pm
j=1 αij (P
g̸=j αig)km(αij)kh
km!kh!
=
(m −1)
m
M1
X
kh=1
e−αij (αij)kh
(kh −1)!
M2
X
km=0
e
P
g̸=j αig (P
g̸=j αig)km
km!
(9)
<
(m −1)
m
M1
X
kh=1
e−αij (αij)kh
(kh −1)!
(10)
=
(m −1)αij
m
M1
X
kh=1
e−αij (αij)kh−1
(kh −1)!
=
(m −1)αij
m
M1−1
X
kh=0
e−αij (αij)kh
kh!
(11)
<
(m −1)
m
αij
(12)
The item
e−P
g̸=j αig (P
g̸=j αig)km
km!
in Equation 9 can be
regarded as the probability of ˜
P (x = km) where ˜
P is a Poisson
with the mean of P
g̸=j αig. Besides, the item
e−αij (αij )kh
kh!
in Equation 11 can also be regarded as the probability of
˜
P (x = kh) where
˜
P is a Poisson with the mean of αij. in-
equalities 10 and 12 hold, because as the integral of a Poisson
distribution on a part of the whole range is smaller than 1.
Then, we can do the same thing to simplify the second term
of right hand side of Inequality 8::
M1
X
kh=0
M2
X
km=0
km
m p (rij, kh, km)
=
1
m
M1
X
kh=0
e−αij (αij)kh
kh!
M2
X
km=1
e−P
g̸=j αig (P
g̸=j αig)km
(km −1)!
<
1
m
X
g̸=j
αig
Thus, we have PM1
kh=0
PM2
km=0 bkhkm < (1−2
m)αij+
Pm
k=1 αig
m
Then, we can get the upper bound of the summa-
tion
of
Ee (i, j)
for
all
HGrids
is
Pn
i=1
Pm
j=1 Ee (i, j)
≤
2
 1 −
1
m
 Pn
i=1
Pm
j=1 αij.
According to Theorem II.1, to minimize the overall real
error, we need to minimize the overall expression error. With
Lemma III.1, to minimize expression error Ee (i, j), we can
minimize αij or m. However, αij is an inner property of
HGrid rij and not determined by the prediction algorithms.
For example, αij on weekdays and weekends in the same
HGrid rij is quite different. On the other hand, the mean
number of events in the same grid can vary greatly in different
time periods of the day. Then, to minimize expression errors,
we should select the appropriate n to minimize m under the
constraint nm > N. Since nm > N, in order to minimize m, we
should maximize n.
Convergence of Expression Error. We notice that Equation
7 is a summation of an inﬁnite series. For a HGrid rij, we
explain that Equation 7 to calculate expression error Ee (i, j)
can converge:
Lemma III.2. Equation 7 to calculate Expression error
Ee (i, j) can converge.
Proof. Considering that bkhkm for any kh, km is positive and
PM1
kh=0
PM2
km=0 bkhkm is bounded according to the Lemma III.1,
we can prove that Equation 7 can converge. Let S (M2, M1) =
PM2
km=0
PM1
kh=0 bkhkm. Lemma III.1 shows ∃M > 0 make the
S (M2, M1) ≤M hold for any M2 ∈Z. Since S (M2, M1) is mono-
tonically increasing with respect to M2, limM2→∞S (M2, M1) can
converge, and we have limM2→∞S (M2, M1) ≤M, that is:
∞
X
km=0
M1
X
kh=0
bkhkm ≤M ⇔
M1
X
kh=0
∞
X
km=0
bkhkm ≤M
Let
T (M1)
=
PM1
kh=0
P∞
km=0 bkhkm,
and
we
have
limM1→∞T (M1)
=
Ee (i, j).
In
the
same
way,
we
can
prove
that
Ee (i, j)
can
converge,
which
means
Ee (i, j)
=
limM1→∞T (M1)
≤
M because of the monotone
increase with respect to M1.
Since Equation 7 can converge, we will introduce algorithms
to calculate expression error.
Algorithm to Calculate Expression Error. Equation 7 shows
how to calculate the expression error Ee (i, j) for a HGrid rij.
In fact, we cannot compute the expression error exactly, but
we can prove that the expression error can be approximated
to arbitrary precision through the below theorem.
Theorem III.2. For any ε, there is a number K that makes
the following inequality holds:

K
X
kh=0
(m−1)K
X
km=0
bkhkm −Ee (i, j)

< ε
Proof. Lemma III.2 shows that Ee (i, j) can converge. We
have
lim
˜k1→∞
˜k1
X
kh=0
∞
X
km
bkhkm = Ee (i, j)
According to the deﬁnition of limit, there will be M1 for
any ε > 0 that we have
−ε
2
<
˜k1
X
kh=0
∞
X
km
bkhkm −Ee (i, j) < ε
2
when ˜k1 > M1, which means
−ε
2
+ Ee (i, j) <
˜k1
X
kh=0
∞
X
km
bkhkm < ε
2 + Ee (i, j)

---

Algorithm 1: Expression Error Calculation
Input: the number m of HGrids per MGrid, αij for each
HGrid rij in the MGrid ri, a hyper-parameter K
Output: the expression error Ee(i, j) of the HGrid rij
1 Ee(i, j) ←0
2 αi,̸=j ←Pm
g̸=j αig
3 p1 ←e−αij
4 for kh = 1 to K do
5
p2 ←e−αi,̸=j
6
for km = 1 to (m −1)K do
7
∆←
 (m−1)kh−km
m
 p1p2
8
Ee(i, j) ←Ee(i, j) + ∆
9
p2 ←−p2αi,̸=j
km
10
p1 ←p1αij
kh
11 return Ee(i, j)
Since the series P˜k1
kh=0
P∞
km bkhkm are bounded (shown by
Lemma III.1), we can switch the order of the series.
˜k1
X
kh=0
∞
X
km
bkhkm =
∞
X
km
˜k1
X
kh=0
bkhkm
We can also ﬁnd M2 for a positive number ε that meets
−ε
2
<
˜k1
X
kh=0
˜k2
X
km
bkhkm −
∞
X
km
˜k1
X
kh=0
bkhkm < ε
2
Based on the deﬁnition of the limit when ˜k2 > M2, we have
−ε <
˜k1
X
kh=0
˜k2
X
km
bkhkm −Ee (i, j) < ε
We select a number K which meets the constraints of K >
M1 and (m −1)K > M2. Thus, we have

K
X
kh=0
(m−1)K
X
km=0
bkhkm −Ee (i, j)

< ε
(13)
Theorem III.2 shows that we can achieve the result close
to the expression error by selecting a suitable K. We ﬁrst
need to compute p (rij, kh, km), which needs O (kh + km) time
to compute. Then, the complexity of the whole calcula-
tion of Equation 7 is O
 m2K3. However the calculation of
p (rij, kh, km) can be simpliﬁed as follows:
p (rij, kh, km + 1) =
Pm
g̸=j αig
km + 1
p (rij, kh, km)
(14)
Based on Equation 14, Algorithm 1 is proposed to approx-
imately computing the expression error Ee (i, j) of the HGrid
rij. Since the complexity of computing p (rij, kh, km) is O (1),
the complexity of Algorithm 1 is O
 mK2.
Algorithm Optimization. Considering the large number of
HGrids, even though the time needed to calculate the expres-
sion error of each HGrid is only about 0.1 second, the ﬁnal
time cost needed to calculate the summation of expression
error of all HGrids with Algorithm 1 is about 4 hours.
Therefore, we introduce a more efﬁcient algorithm with time
complexity of O (mK) in this section based on a more in-depth
analysis of Equation 7.
According to theorem III.2, we can approximate Equation
7 with the following equations:
K
X
kh=0
(m−1)K
X
km=0

(m −1)kh −km
m
 p (rij, kh, km)
(15)
=
(m −1)
m
K
X
kh=0
(m−1)K
X
km=0
khI ((m −1) kh −km) p (rij, kh, km)
−
1
m
K
X
kh=0
(m−1)K
X
km=0
kmI ((m −1) kh −km) p (rij, kh, km)
(16)
where I(x) is a indicator function and satisﬁes:
I(x) =

1,
x > 0
−1,
x ≤0
We transform the ﬁrst term of right hand side of Equation
16 (denoted as e1) to the following formula:
(m −1)
m
K
X
kh=1
(m−1)K
X
km=0
khI((m −1)kh −km)p(rij, kh, km)
=
(m −1)
m
K
X
kh=1
kh(2
(m−1)kh
X
km=0
p(rij, kh, km) −
(m−1)K
X
km=0
p(rij, kh, km))
=
(m −1)
m
K
X
kh=1
e
−Pm
j=1 αij (αij)kh
(kh −1)! e
′
1(kh)
(17)
Let e
′
1 (kh) denote a function with respect to km, as follows:
−
(m−1)K
X
km=0
P
g̸=j αig
km
km!
+ 2
(m−1)kh
X
km=0
P
g̸=j αig
km
km!
(18)
The time complexity of the direct calculation of e
′
1 (kh + 1) is
O (mK) based on Equation 18; as a result, the time complexity
of calculating e1 is
O
 mK2. However, we can build the
connection between e
′
1 (kh + 1) and e
′
1 (kh) as follows:
e
′
1 (kh + 1) −e
′
1 (kh)
=
2
(m−1)(kh+1)
X
km=0
P
g̸=j αig
km
km!
−2
(m−1)kh
X
km=0
P
g̸=j αig
km
km!
=
2
(m−1)(kh+1)
X
km=(m−1)kh
P
g̸=j αig
km
km!
(19)
Therefore, e
′
1 (kh + 1) can be calculated through the result of
e
′
1 (kh) so that the time complexity of e
′
1 (kh) can be reduced
to O (m). Then we can do the same analysis for the second
term e2 of right hand side of Equation 16:
1
m
K
X
kh=0
(m−1)K
X
km=0
kmI((m −1)kh −km)p (rij, kh, km)
=
1
m
K
X
kh=0
e
−Pm
j=1 αij (αij)kh
kh!
e
′
2 (kh)
where
e
′
2 (kh)
=
−P(m−1)K
km=1
P
g̸=j αig
km
(km−1)!
+
2 P(m−1)kh
km=1
P
g̸=j αig
km
(km−1)!
, and we can do a similar analysis as
Equation 19.
Algorithm 2 is proposed through the above analysis. By
reducing the time complexity of e
′
1 (kh) and e
′
2 (kh) from
O (mK) to O (m), the time complexity of Algorithm 2
becomes O (mK).

---

Algorithm 2: Fast Expression Error Calculation
Input: the number m of HGrids per MGrid, αij for each
HGrid rij in the MGrid ri, a hyper-parameter K
Output: the expression error Ee(i, j) of the HGrid rij
1 p2 ←1; e
′
1, e
′
2 ←0
2 for km = 0 to (m −1)K do // initialize e
′
1 and e
′
2
3
p2 ←p2
P
g̸=j αig
4
e
′
2 ←e
′
2 −p2
5
p2 ←p2/(km + 1)
6
e
′
1 ←e
′
1 −p2
7 p1 ←e−Pm
j=1 αij
8 p2 ←1; e1, e2 ←0
9 for kh = 1 to K do // calculate the value of e1 and e2
10
for km = (m −1) (kh −1) to (m −1) kh do
11
e
′
2 ←e
′
2 + 2p2
12
p2 ←
p2
km+1
13
e
′
1 ←e
′
2 + 2p2
14
p2 ←p2
P
g̸=j αig
15
e1 ←e
′
1p1 + e1
16
p1 ←
p1αij
kh
17
e2 ←e
′
2p1 + e2
18 Ee(i, j) ←m−1
m e1 −e2
m
19 return Ee(i, j)
C. Analysis of Model Error
In this section, we can estimate model error with the mean
absolute error for each HGrid. Suppose we use the model f
to predict the event number ˆλi (i.e., ˆλi = f(xi)) for the next
stage of the MGrid through the historical information of the
events X. Let denote the dataset of each MGrid ri as Xi, and
we have ∪n
i=1Xi = X. Meanwhile, the number of samples in Xi
for each MGrid ri is
|X|
n . We deﬁne the mean absolute error
of f as MAE(f) (i.e., MAE(f) =
P
xi∈X |f(xi)−λi|
|X|
), and we have
lim
|X|→∞MAE (f)
=
lim
|X|→∞
P
xi∈X |f(xi) −λi|
|X|
=
1
n
n
X
i=1
lim
|Xi|→∞
P
xj ∈Xi |f(xj) −λj|
|Xi|
=
1
n
n
X
i=1
E
ˆλi −λi


We can get the relationship between the model error Em (i, j)
and MAE (f):
n
X
i=1
m
X
j=1
Em (i, j)
=
n
X
i=1
m
X
j=1
E
ˆλij −λij


=
n
X
i=1
mE
ˆλij −λij


=
n
X
i=1
E
ˆλi −λi


≈nMAE(f)
(20)
According to Equation 20, the total model error will in-
crease when n increases. However, based on the analyses in
Section III-B, the total expression error will decrease when n
increases. We have proved that the summation of expression
error and model error is a upper bound of real error, which
will ﬁrst decrease then increase when n increase from 1 to N.
Thus, to minimize the total real error, we will propose two
efﬁcient algorithms to select a proper n in next section.
Algorithm 3: UpperBound (n, N, X, Model)
Input: the number of MGrid n, the number of all HGrids
N, dataset X, a prediction method Model
Output: e(√n)
1 m ←
q
N
n
2
2 f ←Model (X)
3 e ←nMAE (f)
4 divide the global space into N HGrids and estimate the αij
for each HGrid rij
5 for i = 1 to n do
6
for j = 1 to m do
7
e ←e + Ee (i, j) // calculated by Algorithm 2
8 return e
IV. SEARCH FOR OPTIMAL GRID SIZE
From the analysis in Section III, the size of n will affect
expression error and model error of each HGrid rij, which will
further affect the upper bound of real error. A straightforward
algorithm that checks all the values of n can achieve the
optimal solution for OGSS with the complexity of O(
√
N),
which is not efﬁcient. Therefore, we will propose two more
efﬁcient algorithms to solve OGSS in this section. We ﬁrst
introduce the upper bound calculation of real error.
A. Calculation of Upper Bound for Real Error
In practice, it is difﬁcult to directly estimate the real error
of each HGrid, and then select the optimal partitioning size.
Theorem II.1 proves that the summation of expression error
and model error is an upper bound of real error. Thus, we
can turn to minimize expression error and model error, whose
calculations have been discussed in Section III. Speciﬁcally,
we can use Algorithm 2 to calculate expression errors and
Equation 20 to estimate model errors.
Based on the analysis in Section III, we propose our
algorithm showed in Algorithm 3 to calculate e(√n) (i.e.,
e(√n) = Pn
i=1
Pm
j=1 Eu (i, j)), which is an approximate problem
of OGSS. The time cost of training the model is considerable
when calculating the error e(√n). Therefore, we will introduce
two algorithms with fewer computations of e(√n).
B. Ternary Search
Without any prior information, we cannot make any opti-
mization of the most straightforward algorithm. Fortunately,
it can be concluded from the analysis in Section III that the
model error will increase and the expression error will de-
crease when n increases. It means there exists an equilibrium
point that minimizes the summation of the expression error
and the model error. Consider an extreme case (i.e., n = 1),
the prediction model only needs to predict the number of
events for the whole space in the future, which can be very
accurate. For example, according to the historical information
of New York City (NYC), the number of spatial events (e.g.,
rider’s order) on weekdays almost keeps a relatively stable
value without dramatic ﬂuctuations. At this time, the model
error is small, but the expression error is considerable. Even if

---

Algorithm 4: Ternary Search
Input: dataset X, prediction model Model
Output: partition size n that minimize e(√n)
1 use the method analyzed in Section III to select N
2 l ←1; r ←
√
N
3 while r −l > 1 do
4
mr ←
 2
3r + 1
3l

5
ml ←
 1
3r + 2
3l

6
e(ml) ←UpperBound
 m2
l , N, X, Model

7
e(mr) ←UpperBound
 m2
r, N, X, Model

8
if e(ml) > e(mr) then
9
l ←ml
10
else
11
r ←mr
12 if e(l) > e(r) then
13
n ←r2
14 else
15
n ←l2
16 return n
we could know the exact number of orders in the whole NYC
for speciﬁc timestamp, it would not help for us to dispatch
orders for drivers in a particular street area of NYC. When
n = N, the forecasting model needs to predict a mass of grids’
events accurately, which will leads to huge model errors due
to the uncertainty of human behavior. While the area of a grid
is very small, the uncertainty of human activity will lead huge
different of prediction. Therefore, we assume that the trend of
e(√n) with the increase of n will ﬁrst go down and then up
(This assumption will be conﬁrmed in Section V-C).
We propose a ternary search algorithm to ﬁnd the optimal
partition size. Given that n is a perfect square, we need to ﬁnd
the optimal n among
√
N numbers. Let l be the minimum of √n
and r be the maximum of √n. The main idea of ternary search
is to take the third-equinox between r and l in each round and
then compare the corresponding error of the two third-equinox
points denoted as mr, ml. If e(mr) > e(ml), let r = mr
for next round; otherwise, let l = ml. The ternary search
algorithm showed in Algorithm 4 will drop
1
3 of possible
values for n each time, which results in the convergence.
If the graph of function e(√n) has only one minimum point,
then the ternary search will ﬁnd the optimal solution. However,
the graph of function e(√n) is not always ideal, but the ternary
search algorithm can also ﬁnd a good solution.
Time Complexity. For a given N, we can mark the algorithm
complexity as T (
√
N). We know that the algorithm will drop 1
3
of the possible values from the above analysis, thus converting
the original problem into a subproblem. Therefore, we have:
T (
√
N) = T ( 2
3
√
N) + 2. We can infer that the time complexity of
Algorithm 4 is O(log
√
N) according to the master theorem.
C. Iterative Method
Although the ternary search algorithm reduces the algorithm
complexity from O(
√
N) to O(log
√
N) based on the traversal
algorithm, the experiments in Section V show that the ternary
search algorithm may miss the optimal global solution in
Algorithm 5: Iterative Method
Input: dataset X, prediction model Model
Output: partition size n that minimize e(√n)
1 use the method analyzed in Section III to select N
2 p ←16; b ←4
3 flag ←true
4 while flag do
5
flag ←false
6
for i = b to 1 do
7
e(p + i) ←UpperBound
 (p + i)2, N, X, Model

8
e(p −i) ←UpperBound
 (p −i)2, N, X, Model

9
if e(p) > e(p + i) then
10
p ←p + i
11
flag ←true
12
break
13
if e(p) < e(p −i) then
14
p ←p −i
15
flag ←true
16
break
17 n ←p2
18 return n
some situations. Therefore, we will introduce an iteration-
based algorithm with a greater probability of achieving the
optimal n in this section.
Considering that the upper bound on the real error is large
when n is either large or small, the global optimal value for n
tends to be somewhere in the middle. We can roughly choose
the possible value p of the optimal solution through practical
experience and then take this value as the initial position to
conduct a local search. We set a search boundary b, and if the
size of error for the current position is smaller than all possible
regions within the boundary b, the current position is likely
to be the optimal solution. In order to speed up the search
process, we start the current position of searching from the
boundary b to avoid local traversal when e(√n) is monotonous.
The details of the algorithm is shown in Algorithm 5.
In Algorithm 5, the choice of the initial position p and the
setting of the search boundary b signiﬁcantly affect the quality
of its result and its efﬁciency. Based on the experience from the
existing studies [2], we use the default grid of 2km×2km (i.e.,
approximately 16 × 16) as the corresponding initial position
to speed up the search for the global optimal n. On the other
hand, the search boundary b has an essential inﬂuence on the
properties of the solution and the algorithm’s efﬁciency. When
the search boundary is large, the probability of the algorithm
ﬁnding the optimal solution will increase, but the efﬁciency
of the algorithm execution will decrease. On the contrary, the
algorithm can converge quickly when the search boundary is
small with a small probability of ﬁnding the optimal solution.
V. EXPERIMENTAL STUDY
A. Data Set
We use realistic data to study the property of expression
error and model error.

---

New York Taxi Trip Dataset. New York Taxi and Limou-
sine Commission (TLC) Taxi Trip Data [15] includes the taxi
orders in NYC. We use the Taxi Trip Dataset from January
to May 2013 (i.e., January to April as training set, May 1st
to 27th as validation set, and May 28th as test set). There
are 282,255 orders in test set. The size of the whole space
is 23km × 37km (i.e., −73.77°∼−74.03°, 40.58°∼40.92°).
Since the number of other types of taxis in NYC is much
smaller than that of yellow taxi, we only use the trip data of
yellow taxi. Each order record contains the pick-up and drop-
up locations, the pick-up timestamp, and the driver’s proﬁt.
Chengdu Taxi Trip Dataset. DiDi Chuxing GAIA Open
Dataset [16] provides taxi trips in Chengdu, China. We use
the taxi trip records from November 1st, 2016 to November
25th, 2016 as training set, November 26th to 29th, 2016 as
validation set and November 30th, 2016 as test data set. There
are 238,868 orders in test set. The size of Chengdu is also
23km × 37km (i.e., 103.93°∼104.19°, 30.50°∼30.84°).
Xi’an Taxi Trip Dataset. DiDi Chuxing GAIA Open
Dataset [16] also provides a dataset of taxi trips in Xi’an,
China. We use the taxi trip records from October 1st, 2016
to October 25th, 2016 as training data set, October 26th to
29th, 2016 as validation set and October 30th, 2016 as test
set. There are 109,753 orders in test set. The size of Xi’an is
8.5km × 8.6km (i.e., 108.91°∼109.00°, 34.20°∼34.28°).
Please refer to Appendix A for the distributions of the
datasets.
B. Experiment Conﬁguration
We use three prediction models to predict the numbers of
future spatial events in different regions:
Multilayer Perceptron (MLP) [17]: We use a neural
network consisting of six fully connected layers. The numbers
of hidden units on each layer are 1024, 1024, 512, 512, 256
and 256. When the size of MGrid is n, we can get the model
input (8, √n, √n), which represents the number of all regions
in nearest eight time slots, and we use a ﬂatten layer to map
the original input to a vector with the size of 8 × n before it
is fed into the model.
DeepST [6]: DeepST divides a day into 48 time slots (i.e.,
30 minutes per time slot) and calculates inﬂow and outﬂow
of the events. As a result, DeepST can calculate the number
of events in the next time slot by predicting the inﬂow and
outﬂow status of events in the next time slot. It uses three
types of historical information: closeness, period and trend.
Closeness expresses the number of events in the nearest eight
time slots, period expresses the number of events at the same
time slot of the previous eight days, and trend represents
the number of events at the same time slot of the previous
eight weeks. DeepST mainly utilizes the spatial information
to predict the spatial events for next time slot.
Dmvst-Net [10]: Dmvst-Net models the correlations be-
tween future demand and recent historical data via long short
term memory (LSTM) and models the local spatial correlation
via convolutional neural network (CNN). Moreover, Dmvst-
Net models the correlations among regions sharing similar
TABLE II: Experiment Setting for Training Model
Symbol
Setting
N
128 × 128
n
4×4,. . . ,16×16,. . . ,75×75,76×76
time slot
30 minutes
prediction model
MLP, DeepST, Dmvst-Net
temporal patterns. Compared with DeepST, Dmvst-Net utilizes
both spatial and temporal information, which leads to a better
performance of the prediction model.
Since the size of model input for DeepST and Dmvst-Net is
different in the experiment, we need to map the original input
to the same shape to ensure that the model structure does not
change signiﬁcantly through a conditional deconvolution layer.
When the number of MGrid is n, that is, the input dimension of
the model is (2, √n, √n), the size k of the convolution kernel
and step size s of the convolutional layer can be obtained
through the following formula:
s
=
shape
n −1

k
=
shape −s (n −1)
Here, we set shape = 128 in our experiment. Finally, we add
a convolution layer with the same stride and the same size as
the deconvolution layer as the last layer of DeepST.
As the dataset used in this experiment is the Taxi Trip
Dataset, Order Count Bias is used as the metric of model
error, expression error and real error in this experiment.
Model error represents the difference between the predicted
order quantity and the estimated order quantity; expression
error represents the difference between the estimated order
quantity and the actual order quantity; real error represents the
difference between the actual order quantity and the predicted
order quantity. Considering that we will constantly change
the grid size in the experiment, it is meaningless to consider
the error of a single grid; therefore, the errors we discuss in
subsequent experiments are the summation of errors of all
grids, unless otherwise speciﬁed.
In order to calculate the expression error of a HGrid, we
need to estimate the mean number of events αij for the grid
rij in advance. Over a long period, grid environments will
change signiﬁcantly so that the number of events for the
same grid does not follow the same distribution. On the other
hand, when sample size is small, the estimate of the mean
number for events will produce a considerable bias. Therefore,
when estimating the mean number of events, we need to
choose the appropriate range of adoption. At the same time,
considering the remarkable difference about the number of
events at different periods in a day and the great difference in
the willingness of people to travel on weekdays and workdays,
this experiment takes the average number of events at the same
period of all workdays in last one month as the mean number
αij of events in the HGrid rij. In subsequent experiments, we
estimate αij by using the number of events between 8 : 00
A.M. and 8 : 30 A.M. as default unless otherwise stated.
The above experimental settings are summarized in Table II
where the default parameters are in bold. Our experiments are
run on AMD Ryzen 5-5600H with 32 GB RAM and GeForce
RTX 3050 in Python, while LS, POLAR and DAIF in Java.

---

Fig. 3: Effect of n on Expression
Error in Different Cities
(a) Chengdu
(b) NYC
(c) Xi’an
Fig. 4: Effect of n on the Model Error
(a) Real Error in Xi’an
(b) Real Error in Chengdu
(c) Real Error in NYC
Fig. 5: Effect of n on Real Error in Different Cities with Different Prediction Models
C. Relationship between Real Error and n
In this section, we mainly show the effect of n on the
expression error and the model error as analyzed in Section
III and verify that real error has the same change trend as its
upper bound.
Expression Error. We use Algorithm 2 to calculate the
expression errors in different cities, which all decrease with
the increase of n as shown in Figure 3. Since orders in NYC
are more evenly distributed than in Chengdu, therefore, the
expression error of Chengdu is smaller than that of NYC when
n is the same. Additionally, the order quantity of Xi’an is much
smaller than that of the other two cities. Meanwhile, the order
distribution of Xi’an is more uniformly distributed compared
with the other two cities. As a result, the expression error of
Xi’an is much smaller than that of other cities. We analyze
the relationship between expression error and the uniformity
of order distribution in detail in Appendix B.
Model Error. We test the performance of three prediction
models (i.e., MLP, DeepST and Dmvst-Net) on the datasets of
NYC and Chengdu as shown in Figures 4. The experimental
results show that the model error of the three prediction models
all increase with the increase of n on the two data sets. The
model errors of DeepST and Dmvst-Net are much smaller
than that of MLP with relatively simple model structure, while
Dmvst-Net makes use of time information of historical data
so that it performs better than DeepST.
Real Error. Figure 5 shows the relationship between real error
and its upper bound in different cities while using different
prediction models. The real error and its upper bound have
the same trend, all falling ﬁrst and then rising while changing
n. Comparing with Chengdu, the expression error of NYC
is larger, which makes the optimal n of NYC larger than
that of Chengdu when the same prediction model is used.
For example, the real error of NYC based on Dmvst-Net is
also small when n is 30 × 30 as shown in Figure 5(c). On
the other hand, the prediction model with higher accuracy
makes the real error signiﬁcantly smaller, and also leads to the
increase of n that minimizes the real error. Taking NYC as an
example, the optimal value of n is 23 when using Dmvst-Net
as prediction model; when the prediction model is DeepST,
the optimal value of n is 16; when the prediction model is
MLP, the optimal value of n is 13. In the case of models
with high accuracy, a larger n helps to reduce expression
error. Moreover, when we use MLP as a prediction model to
forecast the number of orders in Chengdu, Figure 5(b) shows
that the real error increases varying n as the model error plays
a dominant role in the real error while the expression error of
Chengdu is small and the model error of MLP is large. In
addition, because the space size of the Xi’an dataset is much
smaller than that of Chengdu and NYC, the optimal n of Xi’an
is smaller than that of the other two cities.
D. Case Study on Effect of Minimizing Real Error
In this section, we explore the effect of real error on two
crowdsourcing problems (i.e., task assignment [14], [1] and
route planning [2]). We test two prediction models: Dmvst-
Net and DeepST in the experiment.
Task
Assignment. Task assignment refers to sending
location-based requests to workers, based on their current
positions, such as ride-hailing. We use two state-of-the-art
prediction-based task assignment algorithms (i.e., LS [14],
POLAR [1]) to dispatch orders under different values of n.
The goal of LS is to maximize total revenue while the goal
of POLAR is to maximize the number of served orders. Thus,
we use the total revenue and order quantity as metrics for
the two algorithms. We compare the performance of the two

---

(a) Order Quantity
(b) Total Revenue
Fig. 6: Effect of n on Task Assignment (NYC)
(a) Order Quantity
(b) Total Revenue
Fig. 7: Effect of n on Task Assignment (Chengdu)
algorithms using different prediction models in this paper.
Speciﬁc experimental setup in this paper is as the same as
the default setting in our previous work [14].
Figure 6∼8 show that total revenue and order quantity of the
prediction-based dispatching algorithms vary under different
values of n. When using the predicted results, both algorithms
show an increasing ﬁrst and then decreasing trend in revenue,
because the real error is large when n is too small or too
large. When POLAR and LS use real order data such that
the model error becomes 0, the real error is equivalent to the
expression error. It means that the real error decreases as n
increases. Therefore, the performance of Polar and LS will not
decrease due to the large n when using the real order data,
which is also consistent with the changing trend of the real
error. In addition, the order distribution of Xi’an is more even
than that of the other two cities because of its smaller area.
Therefore, the optimal n in Xi’an is less than that in the other
two cities. In short, the experimental results verify that the real
error is an important factor affecting the performance of the
algorithms in task assignment.
Route Planning. Route planning is a central issue in shared
mobility applications such as ride-sharing, food delivery and
crowdsourced parcel delivery. We use the state-of-the-art al-
gorithm, DAIF [2], to verify the effect of n on route planning
problem. We use the default parameters of the original paper
[2] in this experiment, and take the number of served requests
and the uniﬁed cost as the metrics of DAIF. Figure 9 shows
that the number of served requests of DAIF ﬁrst increases
then decreases when n increases. The uniﬁed cost of DAIF
is minimized when n = 16 × 16. Using the actual number of
orders, DAIF gets better performance with a large n. Although
route planning problem is affected less by real error compared
with task assignment problem, the size of grid affects the
performance of prediction-based algorithms.
Table III shows the improvement of the original algorithm
by selecting the optimal grid size with DeepST as the predic-
(a) Order Quantity
(b) Total Revenue
Fig. 8: Effect of n on Task Assignment (Xi’an)
(a) Served Requests
(b) Uniﬁed Cost
Fig. 9: Effect of n on Route Planning (NYC)
tion model on NYC. Original n represents the default value
of n set in [1], [14], [2], while optimal n denotes the optimal
grid size found by our GridTuner. The results show that both
POLAR and DAIF can achieve performance gains with the
optimal grid size. Due to the selection of the default n in the
existing paper [1] is close to the optimal n, the performance
of LS has no obvious improvement.
TABLE III: Promotion of the prediction-based algorithms
Metric
Algorithm
Optimal n
Original n
Improve ratio
Served Order Number
POLAR
16 × 16
50 × 50
13.6%
Total Revenue
POLAR
16 × 16
50 × 50
8.97%
Total Revenue
LS
20 × 20
16 × 16
0.13%
Served Order Number
LS
20 × 20
16 × 16
0.7%
Uniﬁed Cost
DAIF
16 × 16
12 × 12
0.76%
Served Requests
DAIF
20 × 20
12 × 12
3.35%
E. Experiment Result of Optimization Searching Algorithms
Since the mean of the event quantity in the same grid varies
in different periods of a day, the expression error of each time
slot is different, leading to the different optimal solutions of
each time slot. In this section, we use the algorithms proposed
in Section IV to calculate the optimal partition scheme of
different cities and compare the performance of them with the
Brute-force Search (i.e., traverses all the values to ﬁnd the
optimal n). We use three indicators to measure the quality
of the solution found by the algorithm and the efﬁciency
of the algorithm: cost denotes the cost of time; probability
denotes the probability of obtaining the optimal solution (i.e.,
the number of ﬁnding out the optimal solution divided by
the number of time slots); optimal ratio (OR) is denoted as
OR = oa
or , where or denotes the optimal order count served
by driver while using the POLAR as dispatching algorithm in
NYC and oa represents the results optimized by the algorithm.
The experimental results in Table IV show that Ternary
Search and Iterative Method both can greatly reduce the time
cost of ﬁnding the optimal solution compared with the Brute-
force Search. Meanwhile, both algorithms can ﬁnd the global

---

TABLE IV: Performance of the algorithms.
City
Algorithm
Cost (h)
Probability
OR
NYC
Ternary Search
7.03
52.08%
97.83%
NYC
Iterative Method
5.58
81.25%
98.77%
NYC
Brute-force Search
47.43
100.00%
100.00%
Chengdu
Ternary Search
6.32
70.83%
98.35%
Chengdu
Iterative Method
4.53
95.83%
99.77%
Chengdu
Brute-force Search
43.26
100.00%
100.00%
Xi’an
Ternary Search
3.90
60.42%
97.98%
Xi’an
Iterative Method
3.31
91.67%
99.57%
Xi’an
Brute-force Search
21.76
100.00%
100.00%
optimal solution with high probabilities. With the reasonable
choice of bound and initial position of Iterative Method, its
execution efﬁciency and probability of ﬁnding the optimal
solution are better than that of Ternary Search. According to
Table IV, sub-optimal solutions achieved by Ternary Search
are at most 3% less than the optimal results (and 1.5% for
Iterative Method), which shows the effectiveness of our grid
size selection algorithms.
Summary: The experimental results show that the larger
real error often leads to the decrease of the payoff of the
dispatching algorithms. At the same time, Ternary Search and
Iterative Method proposed in this paper can effectively ﬁnd the
optimal solution to the OGSS by minimizing the upper bound
of the real error. Furthermore, this paper improves the effect
of the original algorithm by selecting a reasonable size n.
Specially, the performance of POLAR improves by 13.6% on
served order number and 8.97% on total revenue. Finally, this
paper also studies the inﬂuence of different trafﬁc prediction
algorithms on the optimal size of MGrids. The results show
that when the accuracy of the prediction algorithm is high, the
whole space can be divided into more MGrids to reduce the
expression error. On the contrary, when the accuracy of the
prediction algorithm is low, we need to make the area of a
MGrid larger to reduce the model error.
VI. RELATED WORK
In recent years, with the rise of various online taxi-hailing
platforms, more and more researchers have been working on
how to assign tasks to workers. Summarized the publishing
models in [18], the task assignment problem mainly is classi-
ﬁed in two modes: worker selected task and server assigned
task. Compared with the former, the latter is easier to ﬁnd
the optimal global solution, and the major online taxi-hailing
platforms mainly adopt the latter, which attracts more and
more researchers’ attention.
There are two main modes of order distribution on the
platform: online [1], [3], [19], [2], [20] and the other is ofﬂine
[21], [22], [23], [24]. The online task assignment faces more
tremendous challenges than the ofﬂine task assignment due to
the lack of follow-up order information. However, the emer-
gence of trafﬁc prediction technology [6], [10], [25] has solved
this problem well. With the continuous improvement of these
trafﬁc forecasting work, the demand-aware algorithm [1], [3],
[2], [26], [20] for task assignment has more advantages than
some traditional algorithm [18], [27], [24], [21]. The optimal
solution of task assignment based on the supply and demand
can be approximately equivalent to the optimal solution of
ofﬂine task assignment problem when the prediction result of
the trafﬁc prediction algorithm is close to the real.
Several trafﬁc prediction methods [6], [10], [25], [28], [29]
divides the entire space into grids based on latitude and longi-
tude and then predicts the number of orders in each region. The
residual network is introduced into the trafﬁc prediction in [6]
so that the deep neural network can better reduce the deviation
between the predicted results and the actual results. [10] tries
to combine different perspectives to predict future order data,
including time perspective, space perspective, and semantic
perspective. The results show that the multi-view spatiotem-
poral network can improve the prediction performance of the
model. In addition, an attention mechanism is introduced in
[25] to mine the dynamic spatiotemporal correlation of trafﬁc
data to optimize the prediction performance.
Combining the result of predicted future distribution of
tasks, algorithms for task assignment can better solve the prob-
lem. The work [3] proposed a framework based on queuing
theory to guide the platform for order dispatching, which used
queuing theory combined with the distribution of future orders
and drivers in the region to predict the waiting time of drivers
before they received the next order after sending the current
order to the destination. In addition, a two-stage dispatching
model is proposed in [1]. In the ﬁrst stage, the platform will
pre-assign drivers based on the predicted number of regional
orders and direct them to the likely location of the orders,
while in the second stage, it will assign the actual orders.
The accuracy of trafﬁc prediction will signiﬁcantly affect the
performance of this algorithm. However, The order dispatching
algorithms pay attention to the model error and the expression
error caused by the uneven distribution of orders in the grids.
Our problem mainly focuses on how to divide model grid to
balance the model error and the expression error to improve
the effectiveness of the order dispatching algorithm based on
supply and demand prediction.
VII. CONCLUSION
In this paper, we propose a more ﬁne-grained measure
of prediction bias, namely real error, and investigate how to
minimize it. The real error is mainly composed of expression
error and model error. Expression error is caused by using
the order quantity of large regions to estimate the number of
spatial events of HGrids, while model error is the inner error
of the prediction model. We show that the summation of the
expression error and the model error is the upper bound on
the real error. We solve expression error and model error and
analyze the relationship between them and MGrids. Through
the above analysis, we propose two algorithms to minimize
the real error as much as possible by minimizing its upper
bound. Finally, we verify the effectiveness of our algorithm
through experiments and analyze the role of real error for
spatiotemporal prediction models.

---

REFERENCES
[1] Y. Tong, L. Wang, Z. Zimu, B. Ding, L. Chen, J. Ye, and K. Xu,
“Flexible online task assignment in real-time spatial data,” Proceedings
of the VLDB Endowment, vol. 10, no. 11, pp. 1334–1345, 2017.
[2] J. Wang, P. Cheng, L. Zheng, C. Feng, L. Chen, X. Lin, and Z. Wang,
“Demand-aware route planning for shared mobility services,” Proceed-
ings of the VLDB Endowment, vol. 13, no. 7, pp. 979–991, 2020.
[3] P. Cheng, C. Feng, L. Chen, and Z. Wang, “A queueing-theoretic
framework for vehicle dispatching in dynamic car-hailing,” in 2019 IEEE
35th International Conference on Data Engineering (ICDE), pp. 1622–
1625, IEEE, 2019.
[4] G. O. Mohler, M. B. Short, P. J. Brantingham, F. P. Schoenberg, and
G. E. Tita, “Self-exciting point process modeling of crime,” Journal of
the American Statistical Association, vol. 106, no. 493, pp. 100–108,
2011.
[5] C. Huang, J. Zhang, Y. Zheng, and N. V. Chawla, “Deepcrime: Attentive
hierarchical recurrent networks for crime prediction,” in Proceedings of
the 27th ACM International Conference on Information and Knowledge
Management, CIKM ’18, p. 1423–1432, Association for Computing
Machinery, 2018.
[6] J. Zhang, Y. Zheng, and D. Qi, “Deep spatio-temporal residual networks
for citywide crowd ﬂows prediction,” in Proceedings of the AAAI
Conference on Artiﬁcial Intelligence, vol. 31, 2017.
[7] Y. Li, Y. Zheng, H. Zhang, and L. Chen, “Trafﬁc prediction in a bike-
sharing system,” in Proceedings of the 23rd SIGSPATIAL International
Conference on Advances in Geographic Information Systems, SIGSPA-
TIAL ’15, Association for Computing Machinery, 2015.
[8] K. Zhao, D. Khryashchev, J. Freire, C. Silva, and H. Vo, “Predicting
taxi demand at high spatial resolution: Approaching the limit of pre-
dictability,” in 2016 IEEE International Conference on Big Data (Big
Data), pp. 833–842, 2016.
[9] online, “uber.” https://www.uber.com.
[10] H. Yao, F. Wu, J. Ke, X. Tang, Y. Jia, S. Lu, P. Gong, J. Ye, and Z. Li,
“Deep multi-view spatial-temporal network for taxi demand prediction,”
in Proceedings of the AAAI Conference on Artiﬁcial Intelligence, vol. 32,
2018.
[11] M. Chen, X. Yu, and Y. Liu, “Pcnn: Deep convolutional networks
for short-term trafﬁc congestion prediction,” IEEE Transactions on
Intelligent Transportation Systems, vol. 19, no. 11, pp. 3550–3559, 2018.
[12] H. Yu, Z. Wu, S. Wang, Y. Wang, and X. Ma, “Spatiotemporal recurrent
convolutional networks for trafﬁc prediction in transportation networks,”
Sensors, vol. 17, no. 7, p. 1501, 2017.
[13] S. Guiasu and A. Shenitzer, “The principle of maximum entropy,” The
mathematical intelligencer, vol. 7, no. 1, pp. 42–48, 1985.
[14] P. Cheng, J. Jin, L. Chen, X. Lin, and L. Zheng, “A queueing-theoretic
framework for vehicle dispatching in dynamic car-hailing [technical
report],” arXiv preprint arXiv:2107.08662, 2021.
[15] online, “Nyc taxi & limousine commission trip record data.” https://
www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page.
[16] online,
“Gaia
open
dataset.”
https://outreach.didichuxing.com/
appEn-vue/ChengDuOct2016?id=7.
[17] F. Rosenblatt, “Principles of neurodynamics. perceptrons and the theory
of brain mechanisms,” tech. rep., Cornell Aeronautical Lab Inc Buffalo
NY, 1961.
[18] L. Kazemi and C. Shahabi, “Geocrowd: enabling query answering
with spatial crowdsourcing,” in Proceedings of the 20th international
conference on advances in geographic information systems, pp. 189–
198, 2012.
[19] Y. Tong, J. She, B. Ding, L. Chen, T. Wo, and K. Xu, “Online
minimum matching in real-time spatial data: experiments and analysis,”
Proceedings of the VLDB Endowment, vol. 9, no. 12, pp. 1053–1064,
2016.
[20] M. Asghari and C. Shahabi, “Adapt-pricing: a dynamic and predictive
technique for pricing to maximize revenue in ridesharing platforms,” in
Proceedings of the 26th ACM SIGSPATIAL International Conference on
Advances in Geographic Information Systems, pp. 189–198, 2018.
[21] L. Zheng, L. Chen, and J. Ye, “Order dispatch in price-aware rideshar-
ing,” Proceedings of the VLDB Endowment, vol. 11, no. 8, pp. 853–865,
2018.
[22] S. Ma, Y. Zheng, and O. Wolfson, “T-share: A large-scale dynamic taxi
ridesharing service,” in 2013 IEEE 29th International Conference on
Data Engineering (ICDE), pp. 410–421, IEEE, 2013.
[23] R. S. Thangaraj, K. Mukherjee, G. Raravi, A. Metrewar, N. Annamaneni,
and K. Chattopadhyay, “Xhare-a-ride: A search optimized dynamic ride
sharing system with approximation guarantee,” in 2017 IEEE 33rd
International Conference on Data Engineering (ICDE), pp. 1117–1128,
IEEE, 2017.
[24] L. Chen, Q. Zhong, X. Xiao, Y. Gao, P. Jin, and C. S. Jensen, “Price-
and-time-aware dynamic ridesharing,” in 2018 IEEE 34th International
Conference on Data Engineering (ICDE), pp. 1061–1072, IEEE, 2018.
[25] S. Guo, Y. Lin, N. Feng, C. Song, and H. Wan, “Attention based spatial-
temporal graph convolutional networks for trafﬁc ﬂow forecasting,” in
Proceedings of the AAAI Conference on Artiﬁcial Intelligence, vol. 33,
pp. 922–929, 2019.
[26] Y. Zhao, K. Zheng, Y. Cui, H. Su, F. Zhu, and X. Zhou, “Predictive
task assignment in spatial crowdsourcing: a data-driven approach,” in
2020 IEEE 36th International Conference on Data Engineering (ICDE),
pp. 13–24, IEEE, 2020.
[27] R. M. Karp, U. V. Vazirani, and V. V. Vazirani, “An optimal algorithm for
on-line bipartite matching,” in Proceedings of the twenty-second annual
ACM symposium on Theory of computing, pp. 352–358, 1990.
[28] Z. He, J. Cao, and X. Liu, “High quality participant recruitment in
vehicle-based crowdsourcing using predictable mobility,” in 2015 IEEE
Conference on Computer Communications (INFOCOM), pp. 2542–2550,
IEEE, 2015.
[29] N. Cressie and C. K. Wikle, Statistics for spatio-temporal data. John
Wiley & Sons, 2015.
APPENDIX
A. Distributions of Order Datasets
Figure 10 shows the distribution of orders in test data set
from 8:00 A.M. to 8:30 A.M.
The number of trips in the testing day is: 282,255 for NYC
dataset, 238,868 for Chengdu, and 109,753 for Xi’an. We also
analyze the distribution of the length of the trips in three
cities as shown in Figure 11. The lengths of trips in Chengdu
are generally evenly distributed, but the number of long trips
(longer than 45 km) is more than 1,000. The taxi trips in
NYC mainly happened in Manhattan district, thus most trips
are shorter than 15 km. For Xi’an dataset, since the spatial
area is relatively small, most trips are shorter than 10 km.
B. Relationship between Expression Error and the Uniformity
of the Distribution
Expression error refers to the error caused by estimating
the number of events ˆλij in a HGrid rij with the prediction
result ˆλi of the MGrid ri. The uniformity of the distribution of
events within the MGrid will lead to a large expression error.
We use Dα (N) to represent the degree of unevenness in the
distribution of events within a MGrid. In the experiment, we
set the parameter m as 8 × 8 with n = 16 × 16, which means
each MGrid has an area of 3.7578 km2. Then we calculate the
imbalance Dα (64) of event distribution within each MGrid
and the summation of the expression error E (i, j) of each
HGrid rij in the MGrid ri. Then, we plot the corresponding
relationship between them into a scatter diagram.
Figure 13 shows that the expression error gradually in-
creases with the increase of imbalance of event distribution

---

(a) NYC
(b) Chengdu
(c) Xi’an
Fig. 10: Order Distributions in NYC, Chengdu and Xi’an
(a) Chengdu
(b) NYC
(c) Xi’an
Fig. 11: Distribution of Trip Length in Different Cities
(a) a Grid with Dα = 25.87
(b) a Grid with Dα = 8.8
Fig. 12: Two instances of event distribution
within a MGrid. On the other hand, we ﬁnd that many MGrids
has Dα (64) < 10 because events are unevenly distributed in
New York City, leading to the scarcity of events in several
grids.
The distribution of events in two different MGrids shown
in Figure 12 where each point denotes a spatial event. The
event distribution shown in Figure 12(a) is uneven. There is a
large empty area in the upper left corner, and there is a long
main road in the middle with lots of events. On the contrary,
the event distribution in Figure 12(b) is more uniform. The
Dα (64) of the right grid is 25.87 with the expression error
of 39.90, while the Dα (64) of the left grid is 8.47 with the
expression error of 8.8.
Fig. 13: Effect of Dα (N) on Ee (i, j)
C. Results on HGrid Division
The real error is deﬁned in the HGrids. Thus, how to divide
the whole space into HGrids becomes a crucial problem. We
cannot guarantee that events are evenly distributed within a
HGrid while the area of each HGrid is enormous. On the other
hand, the calculation complexity of the expression error will
be too high if the area of each HGrid is tiny.
We calculate Dα (N) over the whole grids with different
values of N based on Equation 2. Then we plot the change
in Dα (N) with respect to N in two different way to estimate
αij.
Figure 14 shows that Dα (N) increases with N and the
growth rate of Dα (N) slows down while N is greater than a
turning point (i.e., approximately 76), which indicates that the
distribution of events within the HGrid is uniform when N
is greater than 76 × 76. However, Dα (N) continues to grow

---

Fig. 14: Effect of N on Dα (N)
Fig. 15: Effect of m on Expression Error, Model Error, Real Error
quickly when N is greater than 76×76 due to the estimation of
αij with the sample of a week or three months. Subsequent
increases in Dα (N) are mainly attributed to the inaccurate
estimation of the value of αij.
We set n to 16 and keep increasing m to ﬁgure out the
inﬂuence of N on real error, model error and expression error.
Figure 15 shows that the real error and the expression error
increase as m increases. When m is large, the area of grids
decreases, leading to the inaccurate estimation of the value of
αij. Thus, the expression error and the real error continually
increase. In this paper, we want to reduce the inﬂuence of such
inaccuracy on the expression error, and make the expression
error to reﬂect the uneven distribution of events. As a result,
we set N = 128×128 in our experiments, which allows us to
reduce the inﬂuence of the inaccurate estimation of the value
of αij and guarantee homogeneous for HGrids.
D. Results on Calculation of Expression Error
We explore the performance of Algorithms 1 and 2 on
the calculation of expression error. We N = 128 × 128,
n = 16 × 16 and m = 8 × 8. In this case, we calculate the
expression error of a HGrid by Algorithms 1 and 2. Theorem
III.2 proves that the accuracy of expression error calculation
increases with the increase of K. However, the increase in K is
accompanied by a rapid increase in computing costs. Figure 16
shows that the cost of the most straightforward algorithm (i.e.,
no optimizations are made) increases rapidly with the increase
of K, and the calculation cost of Algorithm 1 is linearly related
to K. However, the calculation time of Algorithm 2 is always
kept at a low level, which indicates the effectiveness of the
algorithm.
We generally choose to set K as 250 based on the result of
Figure 16 to obtain a more accurate result of expression error
while avoiding too much computing cost.
Fig. 16: Effect of K on efﬁciency for computing expression and
accuracy of Algorithm 2
Fig. 17: Effect of bound on
the Solution and the Cost of
Algorithm 5
Fig. 18: Distribution of Optimal
solutions in different time slots
Fig. 19: Effect of the Size of Dataset on the Performance of Different
Crowdsourcing Algorithm
E. Inﬂuence of bound on the Performance of Iterative Method
Figure 17 shows the effect of the selection of bound on
Algorithm 5. With the increase of bound, the probability of
Algorithm 5 ﬁnding the optimal solution increases gradually,
and the cost of the algorithm also increases. In addition, Figure
18 shows the distribution of optimal selections of n in 48
periods of a day, which shows that the optimal value of n is
17 for most times.
F. Effect of the size of dataset
The size of dataset should not be too large or too small. For
example, 3 months data for training can harm the performance
as the distribution may change, thus the estimation of αij can
be inaccurate and cannot ﬁnd the optimal n. As for training
with too small dataset (e.g., one week), the performance also
drops since the data is not sufﬁcient to train the prediction
models. As shown in Figure 19, the results are best when we
use 4 weeks’ data as the training set.

---

