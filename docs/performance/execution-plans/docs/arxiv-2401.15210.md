# Robust Plan Evaluation based on Approximate Probabilistic Machine Learning

> 来源: https://arxiv.org/pdf/2401.15210

Robust Plan Evaluation based on Approximate Probabilistic
Machine Learning
Amin Kamali
skama043@uottawa.ca
University of Ottawa
Ottawa, Canada
Verena Kantere
vkantere@uottawa.ca
University of Ottawa
Ottawa, Canada
Calisto Zuzarte
Calisto@ca.ibm.com
IBM Canada Lab
Markham, Canada
Vincent Corvinelli
vcorvine@ca.ibm.com
IBM Canada Lab
Markham, Canada
ABSTRACT
Query optimizers in RDBMSs search for execution plans expected
to be optimal for given queries. They use parameter estimates, often
inaccurate, and make assumptions that may not hold in practice.
Consequently, they may select plans that are suboptimal at run-
time, if estimates and assumptions are not valid. Therefore, they
do not sufficiently support robust query optimization. Using ML
to improve data systems has shown promising results for query
optimization. Inspired by this, we propose Robust Query Optimizer,
(Roq), a holistic framework based on a risk-aware learning approach.
Roq includes a novel formalization of the notion of robustness in
the context of query optimization and a principled approach for its
quantification and measurement based on approximate probabilis-
tic ML. It also includes novel strategies and algorithms for query
plan evaluation and selection. Roq includes a novel learned cost
model that is designed to predict the cost of query execution and
the associated risks and performs query optimization accordingly.
We demonstrate that Roq provides significant improvements in
robust query optimization compared with the state-of-the-art.
PVLDB Reference Format:
Amin Kamali, Verena Kantere, Calisto Zuzarte, and Vincent Corvinelli.
Robust Plan Evaluation based on Approximate Probabilistic Machine
Learning. PVLDB, 18(8): XXX-XXX, 2025.
doi:XX.XX/XXX.XX
PVLDB Artifact Availability:
The source code, data, and/or other artifacts have been made available at
https://github.com/M2oDA-Lab/Roq.
1
INTRODUCTION
Executing queries in database management systems involves ac-
cessing, joining, and aggregating data from various sources. These
queries have multiple execution plans, with significant variations
in performance. To find the best plan at compile-time, query opti-
mizers use limited search algorithms and a cost model. The cost
model evaluates each plan based on parameters such as cardinal-
ities, which are estimated as they are unknown at compile-time.
Moreover, the cost model makes certain assumptions that may not
hold in practice. Consequently, the plan selected by the optimizer
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 18, No. 8 ISSN 2150-8097.
doi:XX.XX/XXX.XX
may be suboptimal at runtime, lacking robustness against estima-
tion errors and non-conforming environments. Query optimization
approaches that are less sensitive to estimation errors and do not
rely on consequential simplifying assumptions are considered ro-
bust. This work focuses on the robustness in the context of plan
optimization. Robustness in other phases of query optimization
and processing, like query rewrite and execution, is beyond the
scope of this research. While various approaches are proposed in
the literature for robust query optimization, they are rarely adopted
in practice due to their limitations. Some require intrusive changes
in the query execution engine [2, 24, 27], have unreasonable com-
pilation overhead [8, 16, 17], or make unrealistic consequential
assumptions [5, 6, 36]. With the advent of new approaches based
on ML, some of these limitations are mitigated. For example, Neo
[23] shows some robustness to misestimation of the input parame-
ters, and Bao [22] demonstrates minimal regressions for the tested
workloads. However, ML-based approaches suffer from significant
errors when there is a drift in the data or workload distributions
[14]. While ML-based techniques show promising advantages for re-
ducing the maintenance and tuning overheads of query optimizers,
a successful transition to such approaches relies on addressing con-
cerns about their robustness. Given the limitations in prior work, a
practical approach to solve the robustness problem needs to a) have
limited compilation overheads, b) avoid making consequential or
unjustified simplifying assumptions, and c) demonstrate robustness
based on well-defined robustness measures. We propose Roq, a
novel approach for robust query optimization using approximate
probabilistic ML. Our contributions are:
• We formalize the problem of robust query optimization.
• We formalize the notion of plan and cost model robustness
to enable an objective evaluation of these characteristics.
• We formalize theoretical methods for quantifying uncertain-
ties and risks in the context of plan evaluation and selection
based on approximate probabilistic ML.
• We propose a new model architecture for a learned cost
model that supports measuring uncertainties and provides
improved performance compared with the state-of-the-art.
• We propose novel strategies and algorithms for plan eval-
uation and selection that outperform the state-of-the-art
approaches by accounting for uncertainties and risks.
• We demonstrate the robustness of the proposed approaches
to workload shifts and their limited compilation overhead.
• We conduct an ablation study of the impacts of accounting
for different types of risk in the risk-aware strategies.
The proposed risk quantification and measurement techniques,
along with the risk-aware strategies, are not tightly coupled with
the proposed model architecture. Any NN-based learned cost model
arXiv:2401.15210v3  [cs.DB]  25 May 2025

---

can benefit from employing these techniques to enhance perfor-
mance and robustness with minimal overhead.
In the rest of the paper: Section 2 presents the problem of robust
query optimization. Section 3 describes the theoretical framework
of Roq. Section 4 introduces the architecture of a risk-aware learned
cost model. Section 5 presents the experimental study. Section 6
discusses related work, and Section 7 concludes the paper.
2
PROBLEM STATEMENT
Query optimization involves exploring a large space of candidate
execution plans, recursively evaluating a set of plan fragments
(sub-plans), selecting the one with the minimum expected cost,
and constructing larger plans from smaller fragments, until the
creation of a complete plan. In comparing plan fragments, query
optimizers do not consider the uncertainty of cost estimations; i.e.,
they practically assume that the estimated costs have zero variance.
Therefore, they target expected optimality, but not robustness.1
Although we recognize the differences among the optimization
approaches of data systems, to the best of our knowledge, the limi-
tations impacting their robustness are prevalent in the major ones.
In the following, Section 2.1 discusses intuitively the robustness
problem and defines types of risk. Section 2.2 provides formal prob-
lem definitions using two alternative approaches which are later
used in the proposed plan selection strategies in Section 3.3.
2.1
Problem Discussion
Uncertainty in sub-plan evaluation and selection is traced back to
three main sources: uncertainty rooted in the (a) plan structure and
the data that flow through the plan nodes, (b) limitations of the
estimation method, and (c) a crude comparison of a set of plans. We
use the terms risk and risky to point out a high level of uncertainty
in each of these dimensions. We use the term robust if the sensitivity
to uncertainty is low. Hence, a plan can be considered robust if its
execution cost is not sensitive to changes in the parameter estimates
and the environment variables. The level of plan robustness is
influenced by its structural characteristics, the operators used in the
plan, the patterns of error propagation, and the characteristics of the
underlying data. Similarly, an estimation method can be considered
robust if it is not sensitive to inaccurate parameter estimates and
non-conforming environments. Also, an estimation method should
quantify the expected uncertainty for each estimate in order to
support robustness. Classic cost models are not robust since they
are sensitive to inaccurate parameter estimates and non-conforming
environments, and do not quantify estimation uncertainties. Due
to the uncertainties rooted in the plan structure and data, and the
limitations of the cost estimation method, picking a plan from a
set of plans is also an uncertain task, as there is a risk that the
selected plan will be suboptimal at runtime. We define the sources
of uncertainty (or else, risk) in plan evaluation and selection:
Definition 2.1. Plan risk is the uncertainty inherent to the plan,
influenced by predicates and operators involved in the plan, the plan
structure, error propagation patterns, and the data characteristics.
1In this paper, when we attribute characteristics to query optimizers, we refer to that
of Db2 as a representative of the state-of-the-art commercial RDBMSs.
Definition 2.2. Estimation risk is the uncertainty in cost esti-
mates due to limited knowledge of the design and parameters of the
ideal cost model. It is influenced by limitations in cost modeling, such
as simplifying assumptions and error-prone parameter estimates.
Definition 2.3. Suboptimality risk is the likelihood of a plan,
selected as optimal from a set of plans, being suboptimal at runtime.
2.2
Problem Formulation
We first formulate the classical problem of optimal plan selection;
based on this, we provide two alternative formulations of the prob-
lem of robust plan selection. The latter are the basis for the proposed
risk-aware plan selection strategies presented in Section 3.3.
Optimal plan selection problem: Given a finite set of candi-
date execution plans P = {𝑝1, 𝑝2, . . . , 𝑝𝑛}, and a cost function (𝑓(.))
that estimates the cost of executing any plan {𝑝𝑖, ∀𝑖∈{1, . . . ,𝑛}},
find the plan 𝑝∗such that: 𝑝∗= arg min𝑝𝑖∈P 𝑓(𝑝𝑖).□
The above problem formulation ignores that estimated costs are
inherently inaccurate and that they may lead to selecting plans that
are suboptimal at runtime. In contrast, robust query optimization is
defined as "an effort to minimize the sub-optimality risk by accepting
the fact that estimates could be inaccurate [38]." Accordingly, we
formulate the problem of robust plan selection as follows:
Robust plan selection problem (Approach 1): Given a finite
set of candidate execution plans P = {𝑝1, 𝑝2, . . . , 𝑝𝑛}, a cost func-
tion 𝑓(.) and a robustness function𝑔(.) that estimate the cost and ro-
bustness of any plan {𝑝𝑖, ∀𝑖∈{1, . . . ,𝑛}} respectively, find the plan
𝑝∗such that: 𝑝∗= arg min𝑝𝑖∈P 𝑆𝑂𝑅(𝑝𝑖) where 𝑆𝑂𝑅(𝑝𝑖) is the sub-
optimality risk of the plan 𝑝𝑖compared to the alternatives, defined
as a function 𝑘(., .) of 𝑓(.) and 𝑔(.), i.e. 𝑆𝑂𝑅(𝑝𝑖) = 𝑘(𝑓(𝑝𝑖),𝑔(𝑝𝑖)).
□
This approach formalizes the problem as a risk minimization
problem, where solving it requires providing approximations for the
cost function ˆ𝑓(.), the robustness function ˆ𝑔(.) and a formulation for
the suboptimality risk function 𝑘(., .). We use this formalization to
propose a risk-aware plan selection strategy based on suboptimality
risk in Section 3.3.1
Alternatively, we can formalize the problem using an approach
that jointly optimizes both cost and robustness. This formalization
can be formulated in various ways, such as multi-objective opti-
mization, optimizing a nonlinear combination of the two objectives.
Enumerating all such formulations is beyond the scope of this study.
Inspired by approaches proposed in the literature [1], we choose to
construct a linear combination of cost and robustness functions, as
a joint objective function.
Robust plan selection problem (Approach 2): Given a finite
set of candidate execution plans P = {𝑝1, 𝑝2, . . . , 𝑝𝑛}, a cost func-
tion 𝑓(.) and a robustness function 𝑔(.) that estimate the cost and
robustness of any plan {𝑝𝑖, ∀𝑖∈{1, . . . ,𝑛}} respectively, find the
plan 𝑝∗such that: 𝑝∗= arg min𝑝𝑖∈P (𝛼· 𝑓(𝑝𝑖) + (1 −𝛼) · 𝑔(𝑝𝑖)) □
Solving the problem based on this formalization necessitates pro-
viding an approximation for the cost function ˆ𝑓(.), the robustness
function ˆ𝑔(.), and a principled approach for determining a suitable
weight parameter 𝛼.
Most of the prior work has been concerned with providing a
better approximation for the cost function ˆ𝑓(.) [4, 13, 22, 23, 33, 41].
However, providing clear definitions and approximation methods

---

Figure 1: Cost Model Uncertainty Decomposition
for ˆ𝑔(.) and ˆ𝑘(., .) are missing in the literature. In this paper, we
aim at filling in this gap.
3
THEORETICAL FRAMEWORK
We study the sources of uncertainty in the context of plan evalu-
ation and selection towards formalizing the notion of robustness.
Section 3.1 presents a study and definitions for the notions of plan
robustness and cost model robustness, and forms a foundation for
the design of a robust cost model. Section 3.2 presents quantification
measures for the three types of risks tailored for an ML-based cost
model. Section 3.3 presents plan evaluation and selection strategies
and algorithms that employ risk measures to ensure robustness.
3.1
Studying and Modeling Robustness
The uncertainty of a plan cost estimate is rooted in two main
sources: a) the plan structure and the data that flow through the
plan operators and b) the limitations of the cost model.
3.1.1
Plan and Cost Estimation Uncertainty Modeling. Plan robust-
ness can be formalized based on cost behavior given various pa-
rameter values [36]. The plan cost is represented by a Parametric
Cost Function (PCF) in a multidimensional parameter space, which
includes all combinations of values of different error-prone param-
eters that impact the plan cost. Previous works have suggested
various properties of the PCF to measure plan robustness, such as
the slope of the PCF and its area under the curve [36]. We formalize
this notion by modeling the uncertainty in the PCF and how it can
be decomposed into uncertainties from various sources, including
the plan structure and the parameters of the cost model.
Consider a PCF 𝑓𝜃(X) with error-prone input parameters X =
{𝑥1, ...,𝑥𝑛}, and a set of model parameters 𝜃. The uncertainty in the
estimation provided by 𝑓𝜃(X) can be traced back to the uncertainty
in a) input parameter estimates X and b) model parameters 𝜃. This
uncertainty can be decomposed using the law of total variance:
Var(𝑓𝜃(X)|X = X∗) = 𝐸[Var(𝑓𝜃(X)|X∗,𝜃)]
+ Var(𝐸[𝑓𝜃(X)|X∗,𝜃])
(1)
where X∗is the estimated distribution of the input parameters.
Figure 2: Scenarios for plan cost uncertainties for an expected
optimal plan and an alternative (second-best) plan.
Theorem 3.1. The term 𝐸[Var(𝑓𝜃(X)|X∗,𝜃)] represents the un-
certainty rooted in the plan structure and its sensitivity to cardinality
misestimations and the term Var(𝐸[𝑓𝜃(X)|X∗,𝜃]) represents the un-
certainty rooted in model parameters. □
The decomposition provided in Theorem 3.1 is illustrated in
Figure 1, with a simple linear cost model with one error-prone
cardinality parameter. The first term (𝐸[Var(𝑓𝜃(X)|X∗,𝜃)]) has a
direct relationship with a) the error in the input cardinality and b)
the slope of 𝑓𝜃(X) which determines its sensitivity to the error in
the input. Therefore, its quantification is a suitable measure for plan
robustness. The second term (Var(𝐸[𝑓𝜃(X)|X∗,𝜃])), on the other
hand, is directly influenced by the uncertainty in model parameters,
and is a suitable measure for model robustness. This represents the
uncertainty rooted in our lack of knowledge about an ideal cost
model. A proof for Theorem 3.1 is provided in Appendix A.1.
3.2
Ensuring Robustness via Risk
Quantification
We recognized the probabilistic nature of cost estimates and pro-
vided a decomposition model for their uncertainties. We continue
with the definition of quantification measures of the three types of
risks, which will be employed to ensure robustness. The proposed
quantification is tailored to an ML-based cost model and employs
approximate probabilistic ML. We describe an example with sce-
narios of plan cost uncertainties that is used in the discussion of
the proposed measures.
Example 3.1. Figure 2 illustrates various scenarios of cost uncer-
tainties. Each plot shows the probability density function (PDF) of the
estimated cost of two alternative plans. The costs are assumed to have
a normal distribution. In each case, assuming the optimizer estimates
the most likely cost for each plan, the plan with the minimum expected
cost is selected as the optimal. The alternative plan, while having a
higher expected cost, is also likely to be optimal at runtime with a non-
zero probability. Note that the best-case scenario for the optimizer is
when the plan costs are consistently accurate, as the optimizer naively
assumes (Figure 2a). In such a case, the likelihood of plan X being
more expensive than plan Y is low. More likely, however, the estimates
have various levels of uncertainty. Figure 2b/c/d represent such sce-
narios. If one of the two estimates is relatively more uncertain, the

---

risk can increase substantially (Figure 2b/c). The worst case is when
both estimates are highly uncertain (Figure 2d), as the risk of choosing
the expected optimal plan increases further. This example highlights
the importance of taking into account the distributions of the cost
estimates rather than solely the expected values. □
3.2.1
Uncertainty Modeling in ML. The uncertainties captured in
Equation 1 depend on the marginal distribution 𝑝(𝑓𝜃(X)|X∗,𝜃).
This distribution is conditioned on the cost model parameters and
the input parameters. In the context of learned cost models, the
model parameters are obtained through training based on labeled
samples D = {(𝑥𝑖,𝑦𝑖)| ∀𝑖∈{1, . . . ,𝑛}}. Therefore, the distribution
must be conditioned on the training samples D: 𝑝(𝑓𝜃(X)|X∗, D).
Making inferences through this distribution comes down to evalu-
ating the following equation and is called Bayesian inference [15]:
𝑝(𝑓𝜃(X)|X∗, D) =
∫
𝑝(𝑓𝜃(X)|X∗,𝜃)𝑝(𝜃|D) 𝑑𝜃
(2)
The marginal distribution 𝑝(𝜃|D) represents the uncertainty in
the parameters of the model given the training samples D. This
term captures the additional variance existing in a learned model
compared with an analytical (classical) model, and is caused by the
stochastic nature of the training process. Therefore, the decompo-
sition of the total variance provided in Equation 1 can be rewritten
as follows:
Var(𝑓𝜃(X)|X = X∗) = 𝐸[Var(𝑓𝜃(X)|X∗, D)]
+ Var(𝐸[𝑓𝜃(X)|X∗, D])
(3)
The first term in Equation 3 is aleatoric (or data) uncertainty and
the second term is epistemic (or model) uncertainty [19]. The vari-
ability of the behavior of the real-world phenomena is explained
by data uncertainty. Data uncertainty can also be caused by noisy
input vectors or labels, as well as low-dimensional input vectors
that do not adequately explain the sample [15]. Model uncertainty
captures the variability of predictions due to lack of knowledge
about an ideal model. This is rooted in limitations in model archi-
tecture, training procedure, or the coverage of the training data
[10]. For a learned cost model, these notions can be quantified using
various techniques from the ML literature [10]. In the following, we
explain our approach to quantify these two types of uncertainty.
Data and Model Uncertainties A neural network can be de-
signed to predict the parameters of probability distribution [30]. i.e.
it not only predicts the conditional expected value but also the con-
ditional variance of the target given the training data and the input
sample (𝐸[𝑉𝑎𝑟(𝑦|𝑥∗, 𝐷)] with 𝑦= 𝑓𝜃(X)). This is done by adding a
second branch to the output of the neural network, which predicts
the variance. Optimizing the following loss function corresponds
to maximizing the log-likelihood with a Gaussian prior [30]:
Loss = 1
𝑁
𝑁
∑︁
𝑖=1
 
ln(𝜎2
𝑖)
2
+ (𝑦𝑖−𝜇𝑖)2
2𝜎2
𝑖
+ 1
2 ln 2𝜋
!
(4)
where 𝑁is the number of samples in 𝐷, 𝜇𝑖is plugged in from the
first branch of the output layer, 𝜎2
𝑖from the second one, and 𝑦𝑖
from the labels.
Model uncertainty is captured by the variance of the condi-
tional expected values of the target (𝑉𝑎𝑟(𝐸[(𝑦|𝑥∗, 𝐷)])). To cap-
ture this, we use approximate variational inference by Monte Carlo
(MC) Dropout [9]. In this method, the neural network is trained
by applying dropout on hidden layers with a Bernoulli distribu-
tion. At inference time, 𝑇predictions are made with dropout ap-
plied randomly to the hidden layers, resulting in variations in the
weight matrices, hence in the 𝑇predicted values. With a Gaussian
prior, this corresponds to combining multiple Gaussian distribu-
tions {𝑁(𝜇ˆ𝜃𝑡, 𝜎2
ˆ𝜃𝑡)}𝑇
𝑡=1 into one 𝑁( ˆ𝜇, ˆ𝜎2). Given each draw of model
weights results in two estimated parameters, we have a set of pa-
rameter estimates {( ˆ𝜇𝑡, ˆ𝜎2
𝑡)}𝑇
𝑡=1. The predicted mean is:
ˆ𝜇= 𝐸𝑦∼𝑝(𝑦|𝑥∗,𝐷) [𝑦] ≈1
𝑇
𝑇
∑︁
𝑡=1
( ˆ𝜇𝑡)
(5)
The data, model, and total uncertainties are captured by the
following equations respectively [19]:
ˆ𝜎2
𝑑= 𝐸[𝑉𝑎𝑟(𝑦|𝑥∗, 𝐷)] = 1
𝑇
𝑇
∑︁
𝑡=1
( ˆ𝜎2
𝑡)
(6)
ˆ𝜎2
𝑚= Var  𝐸[(𝑦|𝑥∗, 𝐷)] = 𝐸
h
𝐸

(𝑦|𝑥∗, 𝐷)
2i
− 𝐸

(𝑦|𝑥∗, 𝐷)
2
= 1
𝑇
𝑇
∑︁
𝑡=1
ˆ𝜇2
𝑡−
 
1
𝑇
𝑇
∑︁
𝑡=1
ˆ𝜇𝑡
!2
(7)
ˆ𝜎2 = ˆ𝜎2
𝑑+ ˆ𝜎2
𝑚
(8)
3.2.2
Risk Quantification. With the base concepts of uncertainty
modeling in ML, in this section the risks associated with plan eval-
uation and selection are quantified. In addition, the assumptions
made and the computation overheads involved are discussed too.
Plan Risk As explained in Section 3.1, data uncertainty captures
the uncertainty rooted in input parameters and the sensitivity of
the plan to those uncertainties. Therefore, we relate the riskiness
(or robustness) of a plan to data uncertainty and quantify it by
the function provided in Equation 6. Consider the optimal plan in
Figure 2c. Let us assume the variance of the distributions represents
the data uncertainty (i.e., the model uncertainty is zero). Although
the expected cost of this plan is lower than that of the alternative
plan, its potential deviation at runtime is larger. Running this plan
in various conditions and in presence of different parameter values,
is likely to lead to longer execution times in some scenarios. The
cost for the alternative plan, however, has a tighter distribution
while having a higher expected cost. In this example, the parameter
representing the deviation of the cost distribution can be considered
as the risk inherent to the plan itself.
Estimation Risk Estimates are inherently subject to errors.
Therefore, regardless of how robust a plan is, the estimate of its
cost is also subject to uncertainties. We use as a measure for the
Estimation Risk the model uncertainty as quantified using the func-
tion in Equation 7. The scenario represented in Figure 2c can be
studied assuming that the deviation represents model uncertainty
(i.e., data uncertainty is zero). In such a case, the deviation of the
cost from the expected value quantifies the uncertainty rooted in
the modeling limitations. Therefore, a plan with a wider distribution
will have a higher estimation risk.
Suboptimality Risk As stated in the problem formulation with
Approach 1, the goal of robust query optimization is to find a plan
with minimum risk of suboptimality. This can be formalized as

---

Table 1: Computation of risks associated with selecting the
optimal plan at different uncertainty levels
Scenario
𝝈𝒙
𝝈𝒚
√︃
𝝈2𝒙+ 𝝈2𝒚
z-score
P(C(X)-C(Y)>0)
a
1
1
√
2
≈1.41
≈7.9%
b
1
4
√
17
≈0.49
≈31.6%
c
4
1
√
17
≈0.49
≈31.6%
d
4
4
√
32
≈0.35
≈36.3%
the likelihood of the plan being suboptimal compared with the
alternative plan(s). To explain this, let us revisit Example 3.1. We
assume that the cost of the optimal plans in all scenarios is 8, and it
is 10 for the alternative plans. The difference between the scenarios
is the standard deviation of the cost distributions. Let us assume the
cost for the optimal plan (plan X) is denoted by 𝐶(𝑋) ∼N (𝜇𝑥, 𝜎2𝑥)
and the cost for the alternative plan (plan Y) is denoted by 𝐶(𝑌) ∼
N (𝜇𝑦, 𝜎2𝑦). Also, let us assume the covariance between 𝐶(𝑋) and
𝐶(𝑌) is denoted as Cov(𝑥,𝑦). Then the probability of the alternative
plan being cheaper than the optimal plan is denoted by:
𝑅(𝑝𝑋, 𝑝𝑌) = 𝑃(𝐶(𝑋) −𝐶(𝑌) > 0)
(9)
where 𝑅(𝑝𝑋, 𝑝𝑌) is the risk of picking 𝑋over 𝑌. Note that:
𝐷= 𝐶(𝑋) −𝐶(𝑌) ∼N (𝜇𝑥−𝜇𝑦, 𝜎2
𝑥+ 𝜎2
𝑦−2Cov(𝑥,𝑦))
(10)
For the sake of simplicity, let us assume 𝑋and 𝑌are independent
variables, therefore Cov(𝑥,𝑦) = 0. Then:
𝐷= 𝐶(𝑋) −𝐶(𝑌) ∼N (𝜇𝑥−𝜇𝑦, 𝜎2
𝑥+ 𝜎2
𝑦)
(11)
The probability of 𝐶(𝑋) −𝐶(𝑌) > 0 is then obtained by comput-
ing the z-score for 𝐶(𝑋) −𝐶(𝑌) = 0:
zscore ≈0 −(𝜇𝑥−𝜇𝑦)
√︃
𝜎2𝑥+ 𝜎2𝑦
=
𝜇𝑦−𝜇𝑥
√︃
𝜎2𝑥+ 𝜎2𝑦
(12)
In all 4 scenarios, 𝜇𝑥= 8, 𝜇𝑦= 10, and 𝜇𝑦−𝜇𝑥= 2. Table 1
outlines the computation of the risk associated with choosing the
optimal plan for all scenarios illustrated in Figure 2.
Note that the computed risks are consistent with the qualitative
study of the graphs in Figure 2. These computations can be gen-
eralized to compute the risk for choosing the optimal plan in the
presence of several alternative plans to give the Suboptimality Risk.
This can be computed as the average risk of picking the target plan
over any other plan in the search space, as follows:
SOR(𝑝𝑖) =
1
𝑆−1
𝑆
∑︁
𝑗=1,𝑗≠𝑖
𝑅(𝑝𝑖, 𝑝𝑗)
(13)
where 𝑆is the total number of plans in the search space, SOR(𝑝𝑖) is
Suboptimality Risk for plan 𝑝𝑖in the presence of every other 𝑆−1
plan, and 𝑅(𝑝𝑖, 𝑝𝑗) is the risk of picking the plan 𝑝𝑖over plan 𝑝𝑗.
Note that this risk factor can be computed using either model or
data uncertainty for 𝜎values. The former gives the risk rooted in
modeling limitations while the latter gives the risk rooted in the
plan structure. In Roq, we choose to compute this value using the
total uncertainty to account for both types of risk. We demonstrate
in Appendix A.2 that SOR(𝑝𝑖) is a function of the expected cost
and robustness of all plans in the search space.
Computation Overheads In order to minimize the compila-
tion overheads, the computation of SOR can be vectorized, such
Figure 3: Target distributions before and after transformation
that at each step of comparing several plan fragments 𝑅(𝑝𝑖, 𝑝𝑗)
is computed as a matrix 𝑅𝑛×𝑛where 𝑛is the number of plans to
be compared and 𝑅𝑖,𝑗= 𝑅(𝑝𝑖, 𝑝𝑗). To this end, we define 𝐷𝑛×𝑛
where 𝐷𝑖,𝑗= 𝜇𝑖−𝜇𝑗and 𝑆𝑛×𝑛where 𝑆𝑖,𝑗=
√︃
𝜎2
𝑖+ 𝜎2
𝑗. Then the
z-scores for comparing different pairs of plans can be computed
as: 𝑍𝑛×𝑛= −𝐷𝑛×𝑛⊘𝑆𝑛×𝑛
, where the ⊘symbol denotes the
Hadamard (elementwise) division. The computation overheads us-
ing this vectorization approach are negligible as demonstrated in
the experimental study.
The Independence Assumption Let us now revisit Equation
9 without assuming independence. Note that the covariance com-
ponent can be computed as:
Cov(𝑥,𝑦) = 𝐸(𝐶(𝑋) · 𝐶(𝑌)) −𝐸(𝐶(𝑋)).𝐸(𝐶(𝑌))
An accurate estimation of the risk associated with selecting the
plan 𝑋over the plan 𝑌would require the probability distribution
of the cost for each plan, as well as the pairwise joint distribu-
tion 𝐶(𝑋) ·𝐶(𝑌). Assuming independence between 𝐶(𝑋) and 𝐶(𝑌)
results in overestimating the risk by increasing the variance of
𝐶(𝑋) −𝐶(𝑌). We assume independence for two reasons: a) the
computation is impractical and the overhead is prohibitive, and
b) even with the independence assumption made, the risk quan-
tification provides significant improvements. The effectiveness of
the simplified quantification, as demonstrated in the experimental
study, can be explained by the fact that the overestimation effect
for all pairs of plans is consistent, effectively canceling each other
out.
The Probability Distribution The cost and execution time are
not inherently normally distributed variables, as assumed by the
loss function (Equation 4). However, the targets can be transformed
so that they approximately conform to a normal distribution. This
is handled in the preprocessing phase as explained in Section 5.1.
The impact of the transformation on the target values is shown
in Figure3, where the latency distributions of the JOB benchmark
before and after the preprocessing step are shown.
The above discussions support that the assumptions made in
Roq are both justified and inconsequential as stated in the design
objective (b) in the introduction.
3.3
Risk-aware Plan Evaluation
Classic optimizers select a plan from a set of plans solely based on
expected cost. They assume that the estimated expected costs have
zero uncertainties. In contrast, when the uncertainties, and, thus,
risk, are quantified, a new family of plan evaluation and selection
methods can be devised that account for them. We propose three
risk-aware plan evaluation strategies. While the first two use risk

---

Algorithm 1 Plan Selection by SubOpt Risk (P, C)
1: Inputs:
P = {𝑝𝑖| ∀𝑖∈{1, . . . ,𝑆}} Set of plans to be evaluated
C = {𝐶𝑝𝑖∼𝑁(𝜇𝑝𝑖, 𝜎2𝑝𝑖) | ∀𝑖∈{1, . . . ,𝑆}} cost distributions
2: Output: Selected plan 𝑃∗
3: for 𝑝𝑖∈P do
4:
Δ𝑖𝑗∼𝑁(𝜇𝑖−𝜇𝑗, 𝜎2
𝑖+ 𝜎2
𝑗) for all 𝑗≠𝑖
5:
𝑅(𝑝𝑖) =
1
𝑆−1
Í
𝑗≠𝑖𝑃(Δ𝑖𝑗> 0)
6: end for
7: 𝑃∗= arg min𝑝𝑖∈P 𝑅(𝑝𝑖)
8: return 𝑃∗
Algorithm 2 Conservative Plan Selection (P, C, 𝑓𝑠)
1: Inputs:
P = {𝑝𝑖| ∀𝑖∈{1, . . . ,𝑆}} Set of plans to be evaluated
C = {𝐶𝑝𝑖∼𝑁(𝜇𝑝𝑖, 𝜎2𝑝𝑖) | ∀𝑖∈{1, . . . ,𝑆}} cost distributions
𝑓𝑠: a value greater than 0
2: Output: Selected plan 𝑃∗
3: 𝑃∗= arg min𝑝𝑖∈P (𝜇𝑝𝑖+ 𝑓𝑠· 𝜎𝑝𝑖)
4: return 𝑃∗
measures directly for selecting plans, the third uses risk to prune the
search space. We design algorithms that implement these strategies.
3.3.1
Plan Selection by Suboptimality Risk. This strategy follows
the first approach to the problem formulation where the problem
is defined as a risk minimization one. The suboptimality risk is
computed for every plan in the search space, and the one with the
minimum risk is selected, based on the risk quantification method
suggested in Section 3.2. Given a set P = {𝑝𝑖| ∀𝑖∈{1, . . . ,𝑆}}
of 𝑆plans, it computes the suboptimality risk 𝑅(𝑝𝑖) for every 𝑝𝑖.
The plan with a minimum 𝑅(𝑝𝑖) is selected. The algorithm can use
either plan or estimation risk, or a combination of the two.
3.3.2
Conservative Plan Selection. This strategy assumes that each
plan has a higher execution cost than its estimated cost, and this
difference is proportional to the standard deviation of its estimated
cost. It eliminates risky plans (i.e., plans with high standard de-
viation) that happen to be low cost. Given a set P = {𝑝𝑖| ∀𝑖∈
{1, . . . ,𝑆}} of 𝑆plans, where each 𝑝𝑖has a cost distribution 𝐶𝑝𝑖∼
𝑁(𝜇𝑝𝑖, 𝜎2𝑝𝑖), rather than picking the plan with minimum 𝜇𝑝𝑖, it
picks the plan with minimum 𝜇𝑝𝑖+ 𝑓𝑠· 𝜎𝑝𝑖, where 𝑓𝑠is a parameter
tuned on a validation set. The algorithm can be specialized to use
either the plan or the estimation risk, or both. It follows the second
approach to the problem formulation where a linear combination
of the two objectives 𝛼· 𝜇𝑝𝑖+ (1 −𝛼) · 𝜎𝑝𝑖is minimized, where
𝑓𝑠= 1−𝛼
𝛼.
3.3.3
Search Space Pruning by Plan and Estimation Risks. This strat-
egy prunes the search space to eliminate highly risky plans, based
on the plan or the estimation risks. Algorithm 3 implements this
strategy: given a set P = {𝑝𝑖| ∀𝑖∈{1, . . . ,𝑆}} of 𝑆plans along
with their plan and estimation risks (𝑅𝑝and 𝑅𝑒respectively), and
fractions of plans to be pruned with the highest plan and estimation
risks (𝑓𝑝𝑟and 𝑓𝑒𝑟respectively), thresholds 𝜑𝑝𝑟and 𝜑𝑒𝑟are com-
puted for plan and estimation risks, respectively. Any plan with
Algorithm
3
Pruning
by
plan
and
estimation
risks
(P, 𝑅𝑒, 𝑅𝑝, 𝑓𝑒𝑟, 𝑓𝑝𝑟)
1: Inputs:
P = {𝑝𝑖| ∀𝑖∈{1, . . . ,𝑆}}: a set of plans to be evaluated
𝑅𝑒= {𝑅𝑒(𝑝𝑖) | ∀𝑖∈{1, . . . ,𝑆}}: a set of estimation risks
𝑅𝑝= {𝑅𝑝(𝑝𝑖) | ∀𝑖∈{1, . . . ,𝑆}}: a set of plan risks
𝑓𝑒𝑟: a fraction of plans to be pruned by estimation risk
𝑓𝑝𝑟: a fraction of plans to be pruned by plan risk
2: Output: 𝑃′ ⊂P: pruned search space
3: 𝜑𝑒𝑟= sorted(𝑅𝑒)[⌊|P| × 𝑓𝑒𝑟⌋]
4: 𝜑𝑝𝑟= sorted(𝑅𝑝)[⌊|P| × 𝑓𝑝𝑟⌋]
5: 𝑃′ = {𝑝𝑖∈P | 𝑅𝑒(𝑝𝑖) ≤𝜑𝑒𝑟and 𝑅𝑝(𝑝𝑖) ≤𝜑𝑝𝑟}
6: return 𝑃′
either plan or estimation risks above the thresholds is eliminated.
Parameters 𝑓𝑝𝑟and 𝑓𝑒𝑟are tuned using the samples in the validation
set. Choosing the plan from the remaining ones relies on a plan
selection strategy.
4
RISK-AWARE LEARNED COST MODEL
We propose a robust learned cost model, which infers the execution
time, and the plan, estimation, and suboptimality risks. Figure 4-a
illustrates the model’s architecture. It takes as input queries and
plans and predicts the execution time along with expected variance.
It includes two main modules: The first learns the representation of
query and plan combinations; the second takes this representation
and learns the query-plan associations and their impact on runtime.
Query and Plan Encoding. The model employs the following
encoding of input queries and plans.
Query Encoding. We use the query’s join graph to encode tables,
local predicates, join predicates, aggregations, etc, similarly to pre-
vious work [39]. In this work, we encode table statistics, such as
cardinality and selectivity from local predicates and correlations
between predicate columns (captured by the optimizer statistics)
as node attributes. We incorporate characteristics of joins, such as
join type, join predicate operator, join column skewness and join
selectivity, as edge attributes. The optimizer statistics are extended
to capture the join characteristics, too. In addition to node and edge
attributes, we capture high-level characteristics of the join graph,
such as the number of tables and joins, and the join graph topology,
as global attributes. This representation is agnostic to the plan (join
orders and plan operators) that will be used to execute the query.
Plan Encoding. We use a vectorized plan tree that preserves the
structure of the plan [23]. Each node corresponds to a plan operator
and captures the operator type, including different access, join,
and aggregate operators, using one-hot encoding. In addition, it
captures the table(s) in the subgraph originating at the node using
an embedding learned by the Query Processor (see Figure 4-a).
Representation Learning. The representation learning module
produces query embeddings (Query Processor) and plan embed-
dings (Plan Processor). Although we partially borrow the architec-
ture of the Plan Processor from prior work [23], the architecture of
the Query Processor and the output that feeds the Plan Processor
are novel and support the robustness of the proposed model.

---

Figure 4: a) Architecture of the risk-aware learned cost model, including representation learning and estimator components.
This architecture allows quantification of model and data uncertainties, b) Architecture of the extended transformerConv GNN
model block that enables receiving and processing graph level attributes in addition to node and edge attributes
Query Processor. We use Graph Neural Nets (GNNs) to process the
encoded join graph and learn query and table representations. Each
GNN layer serves as a message passing step in which each table
receives information from its adjacent tables, each additional layer
adding to the depth of the message passing in the graph. This al-
lows learning a representation for each table such that it contains
information about its adjacent tables and the whole join graph.
Additionally, we use mean and max pooling to aggregate the infor-
mation from all tables and produce a representation for the whole
join graph. Although there are various GNN implementations, we
use TransformerConv [32] in our architecture. The Transformer-
Conv uses an attention mechanism [34] to condition the amount
of information each node receives from its neighboring nodes by
the attributes of the target node, the neighboring nodes, and the
edges connecting them to the target node. This is a suitable option
for processing the join graphs as the amount of data processed
through a subgraph should be conditioned by the tables and the
joins involved. We extend TransformerConv as illustrated in Figure
4-b, to receive and process graph-level attributes, broadcast them
to every node, and apply mean and max pooling to aggregate them
back into a graph level embedding. This novel architecture allows
us to effectively produce query embeddings.
Plan Processor. The Plan Processor takes the vectorized plan tree as
input and augments nodes with the embedding of the correspond-
ing table(s) produced by the Query Processor. If a node involves
multiple tables, their corresponding embeddings are aggregated
using mean-pooling before being concatenated to the plan node.
The augmented plan tree is then processed through multiple layers
of Tree Convolutional Neural Networks (TCNN), ultimately aggre-
gated into a one-dimensional vector using dynamic pooling [26].
This architecture is proven to be effective in processing query plan
trees by prior works [22, 23, 39]. In our tests, TCNN was superior
to alternative architectures for processing trees such as GNNs or
Tree-LSTMs [40]. The embeddings generated by the final layer of
this model serve as the representation of the query plan.
Estimation Module. The Estimation Module takes the query
and plan representations as input. These two are concatenated into
a single vector which is then processed through a multi-layered per-
ceptron (MLP) module. This module learns the association between
the query and plan representations. The output of this module is
then fed to two separate branches of MLPs. The first branch predicts
the expected execution time, while the second branch predicts the
expected variance (uncertainty) of the execution time.
Novelty of Roq’s Model Architecture. While some compo-
nents of Roq’s model are derived from prior works, to the best of
our knowledge, their composition and extension in this architecture
towards learning cost and quantifying risks are novel. Specifically,
the novelty lies in the adoption and extension of the state-of-the-
art GNNs to learn generalizable representations for tables and join
graphs and their integration into TCNNs, as well as the employ-
ment of two separate branches of MLPs for predicting the plan cost
and risk simultaneously.
5
EXPERIMENTAL STUDY
We experimentally compare Roq with the state-of-the-art.
5.1
Experimental Setup
5.1.1
Database and environment settings. We use IBM Db2 for com-
piling and running the queries. Plans obtained from the Db2 op-
timizer and the best-performing plans are used as baselines for
evaluating the plans selected by the proposed approaches. We con-
sider the plan with the minimum execution time among all plans
in the search space as the best performing plan.
5.1.2
Datasets and workloads. We use the following benchmarks:
The Join Order Benchmark (JOB) [20], the Cardinality Estimation
Benchmark (CEB) [29], and the Decision Support Benchmark (DSB)
[28]. The characteristics of the workloads used are summarized in
Table 2. Training data includes pairs of queries and plans, encoded
to be consumable by an ML model, as described in the following.
CEB 1000 queries are randomly sampled from query templates in
CEB with up to 12 joins over 21 tables from the IMDB dataset. These
are split to non-overlapping subsets of 800, 100, and 100 queries for
training, validation, and test. Each experiment is repeated 5 times
with different random seeds and the average results are reported.
JOB contains 113 queries with up to 27 joins over 21 tables
from the IMDB dataset. Given the small sample size, 10-folds cross

---

Table 2: Benchmarks used in the experiments
Queries
Templates
Max Joins
Dataset
Tables
CEB
1000
16
12
IMDB
21
JOB
113
33
28
IMDB
21
DSB
1000
15
13
TPC-DS
24
validation is used to train models using this dataset. In each fold,
80% are used for training, 10% for validation, and 10% for testing,
such that over the 10 folds each query appears in the test set exactly
once. The aggregated test results from different folds are reported.
DSB 1000 queries are generated based on the Decision Support
Benchmark (DSB) [7], an extension of TPC-DS that enhances data
generation by introducing more realistic, skewed, and correlated
data distributions rather than the mostly independent, uniform
distributions in TPC-DS. It augments query templates with pred-
icate filters for fine-grained data slicing and adds new templates
featuring more complex join patterns (such as non-equi and many-
to-many joins), resulting in many more distinct query instances.
The queries are generated based on 15 distinct query templates and
are split into 800, 100, and 100 queries for training, validation, and
test sets, respectively. Each experiment is repeated 5 times with
different random seeds and the average results are reported.
Plan Generation Each query is compiled with various hint sets
and the different plans generated by the optimizer are captured.
The first compilation is done without any constraints, leading to
the use of the default plan chosen by the optimizer. Additionally,
each query is compiled using 13 hint sets (see Appendix A.3). Hint
sets produce locally optimal plans that are expected to be better
than the optimizer’s plan in some scenarios, as shown by Bao [22].
Although this does not represent the way the optimizer traverses
the search space, it is sufficient for providing a diversified set of
potentially optimal plans for the purpose of this study.
Collecting Labels Each query is executed using each of the
guidelines and the execution time is measured. A timeout threshold
is used to terminate too long executions. This threshold is dynam-
ically set to be 10 times the time it takes to run the query using
the best performing plan found so far, rounded up to the nearest
greater integer. This threshold allows a higher level of exploration
to obtain information on more risky plans.
Preprocessing Preprocessing is performed for all splits based
on the statistics obtained from the training data. Min-max scaling
is applied to bring the range of the values for each feature between
zero and one: 𝑋𝑡=
𝑋−min(𝑋)
max(𝑋)−min(𝑋) . We apply logarithmic trans-
formation and min-max scaling to labels. The execution times can
range greatly and typically exhibit a large skewness towards zero.
Log transformation is applied to the labels to reduce skewness. This
is performed with the following formula, where 𝑦𝑙𝑜𝑔represents
the transformed label: 𝑦𝑙𝑜𝑔= log10(𝑦). The Min-Max scaling then
brings the range of values between zero and one. This is a desirable
range for deep learning models that use the Sigmoid activation
function in their output layers: 𝑦𝑡=
𝑦𝑙𝑜𝑔−min(𝑦𝑙𝑜𝑔)
max(𝑦𝑙𝑜𝑔)−min(𝑦𝑙𝑜𝑔) .
5.1.3
Model Training and Parameter Tuning. To avoid over-fitting,
three mechanisms are used in training: early stopping, dropout, and
reducing learning rate on plateau. Applying dropout at every layer
is necessary to enable the variational inference needed to obtain
model uncertainty. The dropout rate along with other parameters
such as the number of layers, number of neurons, and learning
rate are tuned using the Asynchronous Successive Halving Algo-
rithm [21]. This allows for exploring a large number of parameter
combinations while limiting the total time needed for tuning.
5.1.4
Baselines. We compare Roq against a classical RDBMS opti-
mizer, that of IBM Db2, as well as four prominent works, Neo [23],
Bao [22], Lero [43], and Balsa [37]. Neo and Bao are selected due
to their demonstrated robustness to errors in input features. Balsa
is selected due its to demonstrated robustness to workload shifts.
Lero is selected due to its demonstrated minimization of regressions.
Each one is evaluated for its ability to select a robust plan from the
same set of plans for a given query. To this end, the search space is
identical for all approaches and is enumerated as explained.
IBM Db2 serves as a baseline representing the state-of-art clas-
sical query optimizers in our experiments. In our tests, Db2’s op-
timizer captures Column Group Statistics (CGS) to account for
correlations between database attributes. This feature reduces the
impact of the independence assumption which leads to severe cardi-
nality and cost underestimations. The performance and robustness
of the plans selected by Db2 serve as a baseline.
Neo is a fully learned query optimizer that uses deep neural
networks and reinforcement learning to generate efficient query
execution plans. It starts by bootstrapping from traditional optimiz-
ers and then continuously refines its decision-making by learning
from actual query execution times 2.
Bao uses a more lightweight cost model that takes plans as input
and predicts latency. At each node of the vectorized plan tree, in
addition to node type, it captures the estimated cardinality and cost.
Balsa is a learned query optimizer that avoids relying on expert
demonstrations. It bootstraps from a simple simulator and then
fine-tunes its deep reinforcement learning model using real query
execution latency feedback.
Lero is a more recent work that proposes a learning-to-rank
approach to a learned query optimizer. It learns to compare pairs
of plans in the search space and create a total order. The model
is trained using a pairwise ranking loss function. Additionally, it
enumerates pairs of subplans traversed during search and uses
them as additional samples to train the model.
5.1.5
Evaluation Measures. We design five sets of experiments to
evaluate Roq based on prediction error, correlations with runtime,
robustness to workload shifts, the inference overheads, and an
ablation study on the role of plan and estimation risks.
Prediction Error. The predictive performance of the model is
evaluated using various measures depending on the subject under
consideration. The accuracy of the predicted execution times is
evaluated by the Q-error [25]. Given the actual label 𝑦and the
estimated value ˆ𝑦, Q-error is defined as: 𝑄𝑒𝑟𝑟𝑜𝑟= max(𝑦, ˆ𝑦)
min(𝑦, ˆ𝑦) .
Correlation. We measure the correlations between the estimates
(or the optimizer’s Cost) and the actual execution times using Spear-
man’s rank coefficient rather than the more widely used Pearson’s
2Our implementation of Neo uses one-hot encoding for table representation. In order
to provide it with the knowledge of the underlying data, we add cardinality estimates
to encodings for each plan node.

---

Figure 5: Roq’s predictive performance vs. the baselines. (a) q-
error, and (b) Spearman’s correlation with respect to latency.
The Cost baseline refers to the optimizer’s cost estimate
coefficient. While Pearson’s coefficient measures the linear relation-
ships between two variables, Spearman’s coefficient measures the
monotonic relationships, whether linear or not. Therefore, given
the estimated costs or execution times are used to rank the plans,
Spearman’s coefficient is a more suitable measure of correlation.
Plan Suboptimality. The quality of plans is evaluated using
the suboptimality measure, suggested for end-to-end robustness
[11]. The suboptimality of a plan 𝑝𝑖is computed with respect to
the best plan 𝑝∗: Subopt(𝑝𝑖) = 𝐸𝑇(𝑝𝑖)
𝐸𝑇(𝑝∗) ∈R; 1 < Subopt(𝑝𝑖) <
∞, where 𝐸𝑇(𝑝𝑖) is the execution time of the plan 𝑝𝑖, and 𝑝∗=
𝑎𝑟𝑔𝑚𝑖𝑛𝑖∈{1,...,𝑆}𝐸𝑇(𝑝𝑖). The tail-end of the distribution of subopti-
mality over all plans, selected by a method, characterizes the worst-
case performance degradation of that method compared with an
oracle that always selects the best plan.
Runtime. Improving the tail-end suboptimality as a measure
of robustness may lead to picking plans that are more robust but
more expensive than the optimal plan. While the main goal of our
work is to improve robustness, we need to demonstrate that robust
query optimization does not cause a major slowdown for a given
workload. Therefore, the total runtime of the workload is measured
for each approach.
Inference Overheads. Using the risk-aware plan evaluation al-
gorithms has an overhead for the inference time since multiple
predictions must be made using the base model. We measure the
inference time for these algorithms for various inference iterations
while evaluating the impact on plan suboptimality and runtime.
5.2
Experimental Results
Prediction Accuracy. The average predictive performance of
Roq’s base model (without uncertainty quantification) consistently
outperforms the baselines. Roq’s prediction’s q-error is superior to
the baselines in all tested scenarios based on CEB, JOB, and DSB,
as shown in Figure 5a. 3 The correlation of the predicted runtime
with the actual runtime is more significant for Roq compared with
either the baseline ML-based approaches or the Db2 optimizer’s
cost (denoted as Cost), as shown in Figure 5b. In these evaluations
we only use the raw predictions from each model and do not use MC
dropout variational inference to obtain a more accurate prediction.
3Note that Lero is not included in this evaluation as it is a learning-to-rank model,
and that, similar to the optimizer’s cost, the absolute values of its predictions do not
correspond to latency. Therefore, its q-error is not meaningful.
Model Architecture. Better average predictive accuracy may
not necessarily lead to selecting a better plan. Therefore, we per-
form experiments to evaluate the quality of the generated plans
based on their suboptimality and runtime. The plans selected by
the risk-aware strategies using Roq demonstrate greater robust-
ness based on tail-end plan suboptimality and increased runtime
improvements compared with the baselines, as shown in Figures
6a and 6b, respectively.
To isolate the impact of the plan selection strategies as imple-
mented by Algorithms 1, 2, and 3, Roq is tested once without risk
quantification, similar to the baselines. This scenario is denoted
as Roq-Base. On average, Roq’s base model improves the mean
and the 99𝑡ℎpercentile of suboptimality compared with the opti-
mizer by 26.9% and 28.0%, respectively. In addition, it improves the
same measures compared with the ML-based baselines on aver-
age by 30.8.3% and 44.9.8% respectively, and it improves runtime
compared with the ML-based baselines on average by 22.5%. These
improvements are attributed to Roq’s architecture using GNNs for
producing node embeddings from the join graph, which enables
enhanced generalization to the unseen test queries.
Plan Selection Strategies. The risk-aware plan selection strate-
gies effectively increase the number of improved queries and im-
prove the overall performance and robustness. As demonstrated in
Figure 6, in comparison with the ML-based baselines, plan selec-
tion by subopt risk (denoted by Roq-Risk) yields the greatest level
of robustness by improving the mean and the 99𝑡ℎpercentile of
suboptimality on average by 24.5% and 44.4% respectively. Con-
servative plan selection (denoted by Roq-Cons) improves the same
measures by 22.5% and 44.4% respectively. These two strategies
improve runtime compared with the ML-based baseline on average
by 23.0% and 17.3% respectively. Roq-Risk and Roq-Cons improve
the 99𝑡ℎpercentile of suboptimality compared with Roq-Base by
19.6% and 19.4%, respectively. While both Roq-Risk and Roq-Cons
improve the tail-end performance similarly, the former was more
effective at improving the overall runtime. These two strategies are
combined with plan pruning based on plan and estimation risks,
(denoted by Risk-Roq-Prun and Risk-Cons-Prun). Pruning did not
have a significant impact on the performance of either Roq-Risk
or Roq-Cons over the three benchmarks. This is expected as these
strategies adjust the predictions according to their uncertainties
and effectively eliminate risky predictions by default.
Plan vs. Estimation Risks. To evaluate the roles of the plan
risk (quantified by data uncertainty) and estimation risks (quanti-
fied by model uncertainty) on plan selection, we run an ablation
study in which the risk-aware plan selection strategies are tested
using either model, data, or total uncertainties. The quality of the
resulting plans is evaluated based on mean, median, 95th and 99th
percentiles of the suboptimality of the resulting plans for all three
tested benchmarks (Table 3). Using either model or data uncertainty
for quantifying risks provides significant improvements compared
with the base model and using total uncertainties provides max-
imum improvements. This suggests that the plan and estimation
risks each play a role in improving Roq’s performance and the im-
pact is maximized if they are used together. In addition, the impact
of accounting for plan risk is more significant for achieving better

---

Figure 6: The performance of plans selected by each approach illustrated by (a) suboptimality distribution and (b) improved,
regressed, and unchanged percentage of queries, as well as total runtime improvement percentage compared with Db2’s plan
Table 3: Comparing the impacts of the risk-based plan selection strategies using model, data, and total uncertainties in
suboptimaility distribution for CEB, JOB, and DSB queries.
CEB
JOB
DSB
Suboptimality
median
mean
95th
99th
median
mean
95th
99th
median
mean
95th
99th
base model
1.05
1.16
1.44
2.68
1.18
1.26
1.86
2.87
6.33
5.85
13.35
16.58
conservative model uncertainty
1.14
1.16
1.59
1.85
1.17
1.20
1.72
1.94
5.49
6.02
12.87
14.75
conservative data uncertainty
1.10
1.13
1.27
1.80
1.17
1.18
1.56
1.83
8.44
7.05
13.94
17.10
conservative total uncertainty
1.10
1.13
1.27
1.80
1.17
1.18
1.56
1.84
4.60
5.10
11.96
14.96
risk model uncertainty
1.14
1.16
1.47
1.85
1.17
1.21
1.72
1.94
4.32
5.72
12.03
14.08
risk data uncertainty
1.09
1.13
1.44
1.80
1.17
1.21
1.72
1.94
6.50
6.60
12.97
15.28
risk total uncertainty
1.14
1.16
1.47
1.85
1.17
1.19
1.64
1.94
3.76
5.36
11.15
14.17
runtime performance since it effectively avoids long-running plans
and thus significantly reduces regressions.
Robustness to Workload Shifts. A major challenge of using
ML-based techniques in query optimization is dealing with the
problem of generalization to out-of-distribution test samples. A
learned model becomes obsolete if the characteristics of the test
query differ significantly from the ones used in training. While
model retraining is possible, it takes time, and therefore the opti-
mizer would typically need to still rely on the obsolete model in
the meantime. We evaluate the impact of a workload shift for Roq
in comparison to the baselines using two simulations.
In a minor workload shift simulation, the baseline model is
trained using all query templates in the DSB benchmark. The base-
line model is tested on making predictions for two selected tem-
plates query025 and query101, due to their unique characteristics 4.
4query025 is a 7-join query with a complex join graph involving three aliases of the
‘DATE_DIM‘ table, each used for fine-grained temporal slicing of a different fact table
with overlapping time windows. It includes many-to-many joins between the fact
tables STORE_SALES and STORE_RETURNS using multiple join predicates. query101 is
The second model is trained using the other 13 query templates in
the DSB and tested on the two selected templates.
A major workload shift scenario is simulated using the CEB
and JOB. The baseline model is trained and tested on JOB. This
represents an ideal scenario where the test workload is identically
distributed as the training workload. The model representing a
workload shift is trained on CEB and tested on JOB. This constitutes
a major workload shift as the query templates in CEB are entirely
different than those in JOB. In addition, our CEB queries have up
to 12 joins while JOB has up to 28 joins.
The results shown in Figure 7 demonstrate Roq’s robustness to
out-of-distribution data caused by a minor workload shift in the first
scenario. Figures 7a and 7b show that while the baseline models’ q-
error and correlation degrade significantly with a minor workload
shift, Roq’s predictive performance degradation is minimal. These
results confirm a greater robustness of Roq to out-of-distribution
a query with 9 joins, involving a self-join over the DATE_DIM table and many-to-many
joins between the fact tables STORE_SALES, STORE_RETURNS, and WEB_SALES.

---

Figure 7: Roq’s generalization to out-of-distribution samples
compared with the baselines. a) average q-error, b) Spear-
man’s correlation with runtime
Figure 8: JOB runtime changes after a severe workload shift
demonstrated by (a) runtime improvements vs. regressions
(b) workload cumulative runtime
data caused by workload shifts. We also evaluate the impact of
workload shift on runtime in the major workload shift scenario. As
demonstrated in Figures 8a and 8b, the performance of three out
of four baseline models degrades significantly. Lero’s performance
slightly improves, which can be attributed to the fact that it does
not need to make accurate predictions as long as it can properly
rank the plans. Roq’s base model’s performance also improves com-
pared to the baselines. This can be attributed to the use of GNNs
for learning generalizable table and query representations from the
CEB workload and use that effectively to make accurate predic-
tions on JOB queries and the fact that our CEB workload includes
1000 queries compared to JOB that includes 113. The additional
samples enable a greater performance on an unseen test set when
generalizable representations are learned. The Conservative and
the Risk strategies, further reduce regressions leading to greater
net improvements in runtime. Therefore, Roq and its risk-aware
strategies meet the design objective (c) of demonstrating robustness
based on well-defined measures.
Inference Overheads. Capturing estimation risk using the MC
Dropout method requires multiple inferences. A higher number of
inferences should provide a more accurate estimate of the expected
values and the uncertainties. However, this incurs additional over-
head for the query compilation phase, which is on the critical path
of query execution and must be kept at a minimum. We experi-
ment with inference iterations ranging from 5 to 100. We use plan
selection by suboptimality risk as it is expected to have a larger
overhead compared to the conservative plan selection strategy,
given the more complex computations. We evaluate the inference
time, the runtime, and the suboptimality of selected plans. We re-
port an average over 10 runs for each experiment. Inference times
are captured using a single thread on the CPU, typically available
for query compilation. As shown in Figure 9a, they grow substan-
tially with the number of iterations. Figures 9b and 9c illustrate
the impact of increasing the number of inference iterations on the
suboptimality and the runtime of the selected plans. Increasing
the number of inferences does not have a major impact on mean
suboptimality. The median suboptimality has a sharp decline from
5 to 10 inferences but does not show a significant improvement
with larger values. The changes in plan runtimes are not significant
either. This means the accuracy provided by 10 inferences should
be sufficient for selecting robust plans. This demonstrates that our
approach is robust to making a limited number of inferences. Figure
9d demonstrates the inference overheads of the risk-aware strate-
gies compared with the baselines 5. This time measurement does
not include plan generation, as this is identical for all alternatives.
Overheads for Roq-Cons and Roq-Risk are around 70 and 89 millisec-
onds, respectively. As expected, plan selection by suboptimality
risk is slightly more expensive than doing so by the conservative
strategy. Note that these measurements are performed based on a
prototype code in Python and can be significantly reduced with
more optimized implementations. Therefore, Roq and its risk-aware
strategies meet the design objective (a) of limiting the compilation
overheads at a practical level.
Overview of Findings. Roq produces predictions with a higher
level of accuracy and correlations with runtime. The risk quan-
tification methods and plan selection strategies have significant
benefits in selecting robust plans. Our experiments show the role of
accounting for plan or estimation risks in the plan selection strate-
gies. The proposed strategies demonstrate significant robustness
to shifts in workload characteristics. The quality of the resulting
plans is robust to a limited number of inference iterations used
to quantify risks. Therefore, the proposed techniques can be used
with minimal inference overheads. Our observations suggest that
Roq-Risk and Roq-Cons demonstrate similar results. However, from
our experience, Roq-Risk is preferable as it is non-parametric if the
computation overheads can be tolerated. Also, pruning by plan or
estimation risk does not provide significant improvements for these
strategies. Lastly, our ablation study suggests that accounting for
Plan Risk is more beneficial than accounting for Estimation Risk.
6
RELATED WORK
Query optimization robustness has been studied with a focus on
one of the following: re-optimization, parameter value discovery,
robustness quantification, adaptive processing, and employing ML.
5Balsa and Lero use Neo and Bao’s value networks respectively. Therefore, their
inference overheads are identical to Neo and Bao. While Lero is a learning to rank
model, it does not require multiple inferences to create a total order [43].

---

Figure 9: The impact of the inference iterations on (a) the inference time, (b) suboptimality, (c) the accumulated runtime of the
selected plans and (d) inference overheads for risk-based plan selection methods with 10 inference iterations vs. the baselines
Re-optimization Techniques use intervals instead of point es-
timates to identify robust plans within parameter ranges [2, 24, 27].
These plans are used at run-time, while actual parameter values or
intervals are discovered either via execution or sampling. When
values are outside of the robustness range of the plan, the optimizer
suggests another plan expected to be robust in the new range. The
plan execution terminates prematurely and switches to the new
plan. These approaches necessitate intrusive modifications to ex-
tend the plans and the execution engine to allow for re-optimization.
Discovery-based Techniques eliminate reliance on parameter
estimations by exploring the entire parameter space during com-
pilation. They use mechanisms to iteratively execute plans within
time budgets, discarding results when a plan exceeds its allocated
time [8, 16, 17]. These methods suffer from significant compila-
tion overheads, making them suitable primarily for OLAP-style
environments. Also, they assume a perfect correlation between the
optimizer’s cost function and the execution time, and they require
partial execution of suboptimal plans to discover parameter values.
Robustness Quantification Techniques incorporate robust-
ness alongside optimality in plan selection. One work uses "Least
Expected Cost" instead of "Least Specific Cost", deriving a PDF of
plan costs [6]. This enables selection based on the expected cost
across the parameter space rather than a specific parameter setting.
Deriving the distribution of cost analytically, however, is not a triv-
ial task given the large number of error-prone parameters involved.
Other works propose a framework to estimate an upper bound for
cost given cardinality estimation errors [18, 25]. While this can
quantify plan robustness, it depends on prior knowledge of the
cardinality errors. Another work evaluates robustness based on the
derivative and area under the curve of the PCF [36]. This approach
overlooks the probabilistic nature of the estimated parameters and
assumes they are uniformly distributed. [12]. In addition, it relies
on classical cost models built by making simplifying assumptions
[5], potentially leading to poor performance even with accurate
parameter estimates. Moreover, this approach assumes the PCF is a
linear function, which does not hold in practice.
Adaptive Techniques delay some optimization decisions to
runtime, when true statistics are obtained. Adaptive Join Algorithm
(AJA) [31, 41] switches a hash join to a nested-loops join after de-
termining the true cardinality of the built hash table. Look-ahead
Information Passing (LIP) [42] generalizes a semijoin optimization
to a pipeline of equijoins, typically observed in left-deep plans
based on star schema queries. Smooth Scan [3] proposes a new ac-
cess operator that morphs between a sequential and an index scan
depending on statistics at runtime. These approaches reduce sensi-
tivity to cardinality misestimations [41]. They are complementary
to learning-based techniques, as they improve query processing at
runtime while the latter improve query optimization.
Learning-based Techniques aim to learn the execution cost
from runtime [13, 22, 23, 33]. These works employ learning from
a set of queries and corresponding plans using supervised or rein-
forcement learning. While one study shows some robustness with
respect to estimation errors [23], these works still face uncontrolled
predictive uncertainties inherent in learning-based methods. They
do not address the issue of potential performance regressions com-
pared to classic optimizers. Hybrid Cost Model [35] proposes a meta-
model that learns to route queries to suitable cost models (either
learned or classic ones) when they are expected to produce better
plans, but it does not account for uncertainties or show robustness
to out-of-distribution data. A similar study [39] proposes a hybrid
approach that combines learning-based cost models with traditional
optimizers, selecting partial left-deep join orders based on the pre-
dictions of the model. It uses uncertainty estimates to eliminate
highly uncertain plans, with a fallback to the classic optimizer when
all plans are highly uncertain. It does not demonstrate the robust-
ness of produced plans or robustness to out-of-distribution samples.
Also, it does not acknowledge that a highly uncertain plan may
still be substantially cheaper than a robust plan and that pruning
may not be beneficial. In comparison, Roq’s risk-aware strategies
use uncertainties not only for pruning but also for plan evaluation
and selection by employing suboptimality risk quantification or
conservative plan selection strategies. In addition, they allow one
to prioritize robustness over optimality (or vice versa). Also, they
demonstrate strong robustness not only for unseen queries but also
for out-of-distribution samples.
7
CONCLUSION
We present Roq, a novel approach based on approximate proba-
bilistic ML that enhances the robustness of query optimization in
RDBMSs. We establish a theoretical framework to formalize the
concepts of robustness and risk for plan evaluation and selection,
including techniques for quantifying plan and estimation risks. We
propose risk-aware strategies for plan evaluation and selection that
leverage these risk measures, along with a learned cost model incor-
porating GNN-based query and plan embeddings. In comprehensive
experiments, Roq demonstrates superior predictive accuracy, im-
proved robustness to workload shifts, and significant performance
gains over state-of-the-art approaches, while maintaining practical
compilation overheads.

---

REFERENCES
[1] B. Babcock and S. Chaudhuri. 2005. Towards a robust query optimizer: A princi-
pled and practical approach. 119–130. https://doi.org/10.1145/1066157.1066172
[2] Shivnath Babu, Pedro Bizarro, and David DeWitt. 2005. Proactive re-optimization.
In ACM SIGMOD. 107–118.
[3] Renata Borovica-Gajic, Stratos Idreos, Anastasia Ailamaki, Marcin Zukowski,
and Campbell Fraser. 2018. Smooth Scan: robust access path selection without
cardinality estimation. 27, 4 (2018), 521–545. https://doi.org/10.1007/s00778-
018-0507-8
[4] Tianyi Chen, Jun Gao, Hedui Chen, and Yaofeng Tu. 2023. LOGER: A Learned
Optimizer Towards Generating Efficient and Robust Query Execution Plans. 16,
7 (2023), 1777–1789.
[5] S. Christodoulakis. 1984. Implications of certain assumptions in database perfor-
mance evauation. 9, 2 (1984), 163–186.
[6] Francis Chu, Joseph Halpern, and Johannes Gehrke. 2002. Least expected cost
query optimization: what can we expect?. In ACM PODS. 293–302.
[7] Bailu Ding, Surajit Chaudhuri, Johannes Gehrke, and Vivek Narasayya. 2021.
DSB: a decision support benchmark for workload-driven and traditional database
systems. Proc. VLDB Endow. 14, 13 (Sept. 2021), 3376–3388. https://doi.org/10.
14778/3484224.3484234
[8] Anshuman Dutt and Jayant R. Haritsa. 2016. Plan Bouquets: A Fragrant Approach
to Robust Query Processing. 41, 2 (2016), 11:1–11:37.
[9] Yarin Gal and Zoubin Ghahramani. 2016. Dropout as a Bayesian Approximation:
Representing Model Uncertainty in Deep Learning. In Proceedings of The 33rd
International Conference on Machine Learning (2016-06-11). PMLR, 1050–1059.
ISSN: 1938-7228.
[10] Jakob et al Gawlikowski. 2023. A survey of uncertainty in deep neural networks.
Artificial Intelligence Review 56, 1 (2023), 1513–1589.
[11] Jayant R. Haritsa. 2020. Robust query processing: mission possible. 13, 12 (2020),
3425–3428.
[12] Axel Hertzschuch, Guido Moerkotte, Wolfgang Lehner, Norman May, Florian
Wolf, and Lars Fricke. 2021. Small Selectivities Matter: Lifting the Burden of
Empty Samples. In Proceedings of the 2021 International Conference on Manage-
ment of Data (New York, NY, USA, 2021-06-09) (SIGMOD ’21). Association for
Computing Machinery, 697–709.
[13] Benjamin Hilprecht and Carsten Binnig. 2022. One Model to Rule them All:
Towards Zero-Shot Learning for Databases. In CIDR.
[14] Benjamin Hilprecht, Andreas Schmidt, Moritz Kulessa, Alejandro Molina, Kris-
tian Kersting, and Carsten Binnig. 2020. DeepDB: learn from data, not from
queries! Proc. VLDB Endow. 13, 7 (March 2020), 992–1005. https://doi.org/10.
14778/3384345.3384349
[15] Eyke Hüllermeier and Willem Waegeman. 2021. Aleatoric and epistemic uncer-
tainty in machine learning: an introduction to concepts and methods. 110, 3
(2021), 457–506. https://doi.org/10.1007/s10994-021-05946-3
[16] Srinivas Karthik, Jayant R. Haritsa, Sreyash Kenkre, and Vinayaka Pandit. 2016.
Platform-independent robust query processing. In IEEEICDE. 325–336.
[17] Srinivas Karthik, Jayant R. Haritsa, Sreyash Kenkre, and Vinayaka Pandit. 2018.
A concave path to low-overhead robust query processing. Proc. VLDB Endow. 11,
13 (Sept. 2018), 2183–2195. https://doi.org/10.14778/3275366.3284964
[18] Fisnik Kastrati and Guido Moerkotte. 2016. Optimization of conjunctive pred-
icates for main memory column stores.
9, 12 (2016), 1125–1136.
https:
//doi.org/10.14778/2994509.2994529
[19] Alex Kendall and Yarin Gal. 2017. What uncertainties do we need in Bayesian deep
learning for computer vision?. In International Conference on Neural Information
Processing Systems. 5580–5590.
[20] Viktor Leis, Andrey Gubichev, Atanas Mirchev, Peter Boncz, Alfons Kemper, and
Thomas Neumann. 2015. How good are query optimizers, really? Proc. VLDB
Endow. 9, 3 (nov 2015), 204–215. https://doi.org/10.14778/2850583.2850594
[21] Liam Li, Kevin Jamieson, Afshin Rostamizadeh, Ekaterina Gonina, Moritz
Hardt, Benjamin Recht, and Ameet Talwalkar. 2020. A System for Massively
Parallel Hyperparameter Tuning.
https://doi.org/10.48550/arXiv.1810.05934
arXiv:1810.05934 [cs, stat]
[22] Ryan Marcus, Parimarjan Negi, Hongzi Mao, Nesime Tatbul, Mohammad Al-
izadeh, and Tim Kraska. 2024. Bao: Making Learned Query Optimization Practi-
cal. In Proceedings of the 2021 International Conference on Management of Data
(2021-06-18) (SIGMOD ’21). Association for Computing Machinery, 1275–1288.
[23] Ryan Marcus, Parimarjan Negi, Hongzi Mao, Chi Zhang, Mohammad Alizadeh,
Tim Kraska, Olga Papaemmanouil, and Nesime Tatbul. 2019. Neo: a learned
query optimizer. Proc. of VLDB Endow. 12, 11 (2019), 1705–1718.
[24] Volker Markl, Vijayshankar Raman, David Simmen, Guy Lohman, Hamid Pira-
hesh, and Miso Cilimdzic. 2004. Robust query processing through progressive
optimization. In ACM SIGMOD. 659–670.
[25] Guido Moerkotte, Thomas Neumann, and Gabriele Steidl. 2009. Preventing Bad
Plans by Bounding the Impact of Cardinality Estimation Errors. 2, 1 (2009),
982–993. https://doi.org/10.14778/1687627.1687738
[26] Lili Mou, Ge Li, Lu Zhang, Tao Wang, and Zhi Jin. 2016. Convolutional neural
networks over tree structures for programming language processing. In Proceed-
ings of the Thirtieth AAAI Conference on Artificial Intelligence (Phoenix, Arizona,
2016-02-12) (AAAI’16). AAAI Press, 1287–1293.
[27] Chiraz Moumen, Franck Morvan, and Abdelkader Hameurlain. 2016. Handling
Estimation Inaccuracy in Query Optimization. In Web Technologies and Applica-
tions (Cham). 355–367.
[28] Raghunath Othayoth Nambiar and Meikel Poess. 2006. The Making of TPC-DS..
In VLDB (2006), Vol. 6. 1049–1058.
[29] Parimarjan Negi, Ryan Marcus, Andreas Kipf, Hongzi Mao, Nesime Tatbul,
Tim Kraska, and Mohammad Alizadeh. 2021. Flow-Loss: Learning Cardinal-
ity Estimates That Matter. Proc. VLDB Endow. 14, 11 (jul 2021), 2019–2032.
https://doi.org/10.14778/3476249.3476259
[30] D.A. Nix and A.S. Weigend. 1994. Estimating the mean and variance of the target
probability distribution. In Proceedings of 1994 IEEE International Conference on
Neural Networks (ICNN’94) (1994-06), Vol. 1. 55–60 vol.1.
[31] Joe Sack. 2019.
Introducing Batch Mode Adaptive Joins.
https:
//techcommunity.microsoft.com/t5/sql-server-blog/introducing-batch-
mode-adaptive-joins/ba-p/385411
[32] Yunsheng Shi, Zhengjie Huang, Shikun Feng, Hui Zhong, Wenjin Wang, and
Yu Sun. 2021. Masked Label Prediction: Unified Message Passing Model for
Semi-Supervised Classification.
https://doi.org/10.48550/arXiv.2009.03509
arXiv:2009.03509 [cs, stat]
[33] Tarique Siddiqui, Alekh Jindal, Shi Qiao, Hiren Patel, and Wangchao Le. 2020.
Cost Models for Big Data Query Processing: Learning, Retrofitting, and Our
Findings. In ACM SIGMOD. 99–113.
[34] Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones,
Aidan N Gomez, Łukasz Kaiser, and Illia Polosukhin. 2017. Attention is All
you Need. In Advances in Neural Information Processing Systems (2017), Vol. 30.
Curran Associates, Inc. https://proceedings.neurips.cc/paper_files/paper/2017/
hash/3f5ee243547dee91fbd053c1c4a845aa-Abstract.html
[35] Ning Wang, Amin Kamali, Verena Kantere, Calisto Zuzate, Vincent Corvinelli,
Brandon Frendo, and Steve Donoghue. 2023. A Hybrid Cost Model for Evaluating
Query Execution Plans. In 2023 IEEE Sixth International Conference on Artificial
Intelligence and Knowledge Engineering (AIKE) (2023-09). 133–138. https://doi.
org/10.1109/AIKE59827.2023.00030 ISSN: 2831-7203.
[36] Florian Wolf, Michael Brendle, Norman May, Paul R. Willems, Kai-Uwe Sat-
tler, and Michael Grossniklaus. 2018. Robustness metrics for relational query
execution plans. 11, 11 (2018), 1360–1372.
[37] Zongheng Yang, Wei-Lin Chiang, Sifei Luan, Gautam Mittal, Michael Luo, and
Ion Stoica. 2022. Balsa: Learning a Query Optimizer Without Expert Demonstra-
tions. In Proceedings of the 2022 International Conference on Management of Data
(Philadelphia, PA, USA) (SIGMOD ’22). Association for Computing Machinery,
New York, NY, USA, 931–944. https://doi.org/10.1145/3514221.3517885
[38] Shaoyi Yin, Abdelkader Hameurlain, and Franck Morvan. 2015. Robust Query
Optimization Methods With Respect to Estimation Errors: A Survey. 44, 3 (2015),
25–36.
[39] Xiang Yu, Chengliang Chai, Guoliang Li, and Jiabin Liu. 2022. Cost-Based or
Learning-Based? A Hybrid Query Optimizer for Query Plan Selection. 15, 13
(2022), 3924–3936. https://doi.org/10.14778/3565838.3565846
[40] Xiang Yu, Guoliang Li, Chengliang Chai, and Nan Tang. 2020. Reinforcement
Learning with Tree-LSTM for Join Order Selection. In 2020 IEEE 36th International
Conference on Data Engineering (ICDE). 1297–1308.
https://doi.org/10.1109/
ICDE48307.2020.00116
[41] Yunjia Zhang, Yannis Chronis, Jignesh M. Patel, and Theodoros Rekatsinas. 2023.
Simple Adaptive Query Processing vs. Learned Query Optimizers: Observations
and Analysis. 16, 11 (2023), 2962–2975. https://doi.org/10.14778/3611479.3611501
[42] Jianqiao Zhu, Navneet Potti, Saket Saurabh, and Jignesh M. Patel. 2017. Looking
ahead makes query plans robust: making the initial case with in-memory star
schema data warehouse workloads. 10, 8 (2017), 889–900. https://doi.org/10.
14778/3090163.3090167
[43] Rong Zhu, Wei Chen, Bolin Ding, Xingguang Chen, Andreas Pfadler, Ziniu Wu,
and Jingren Zhou. 2023. Lero: A Learning-to-Rank Query Optimizer. Proc. VLDB
Endow. 16, 6 (Feb. 2023), 1466–1479. https://doi.org/10.14778/3583140.3583160
A
APPENDICES
A.1
Proof of Theorem 3.1
Proof. Let us consider a cost model that is linear with respect
to the size of a single error-prone cardinality (Figure 1):
𝑓𝜃(𝑥) = 𝑎𝑥+ 𝑏;
𝜃= {𝑎,𝑏}
(14)
where 𝑎and 𝑏have normal errors: 𝑎∼N (𝜇𝑎, 𝜎2𝑎), and 𝑏∼
N (𝜇𝑏, 𝜎2
𝑏), and 𝑥= 𝑥∗∼N (𝜇𝑥∗, 𝜎2
𝑥∗) is the approximated cardinal-
ity distribution for the input plan. The expected value 𝐸[𝑓𝜃(𝑥)|𝑥=
𝑥∗] can be computed a follows:

---

𝐸[𝑓𝜃(𝑥)|𝑥= 𝑥∗] = 𝐸[𝑎.𝑥∗+ 𝑏] = 𝐸[𝑎.𝑥∗] + 𝐸[𝑏]
= 𝐸[𝑎].𝐸[𝑥∗] + 𝐸[𝑏] (a and x are independent)
= 𝜇𝑎.𝜇𝑥∗+ 𝜇𝑏
(15)
The total variance Var(𝑓𝜃(𝑥)|𝑥= 𝑥∗) can be decomposed using
the law of total uncertainty:
Var(𝑓𝜃(𝑥)|𝑥= 𝑥∗) = 𝐸[Var(𝑓𝜃(𝑥)|𝑥∗,𝜃)] + Var(𝐸[𝑓𝜃(𝑥)|𝑥∗,𝜃])
(16)
The first and the second components can be computed as follows:
𝐸[Var(𝑓𝜃(𝑥)|𝑥∗,𝜃)] = 𝐸[Var(𝑎𝑥+ 𝑏|𝑥∗,𝑎,𝑏)] = 𝐸[𝑎2Var(𝑥∗)]
= 𝐸[𝑎2𝜎2
𝑥∗]
= 𝜎2
𝑥∗𝐸[𝑎2];𝑎2 ∼𝜒2(d.o.f = 1)
= 𝜎2
𝑥∗(𝜇2
𝑎+ 𝜎2
𝑎)
(17)
Equation 17 captures the variance that is influenced by the error
in cardinality 𝑥∗and the sensitivity of the cost model to such errors.
This component has a direct relationship with the uncertainty in
the input data (𝜎2
𝑥∗) on the one hand and the mean and variance of
the slope (i.e. the first derivative) (𝜇2𝑎+𝜎2𝑎) of 𝑓𝜃(𝑥) on the other. The
term 𝜇2𝑎+ 𝜎2𝑎determines the level of sensitivity to cardinality error.
Therefore, mapping the term 𝐸[Var(𝑓𝜃(𝑥)|𝑥∗,𝜃)] to the robustness of
the plan is justified as it captures both the error rooted in the input
cardinality and the sensitivity of the plan to this error. Note that this
component is reduced to zero if 𝜎2
𝑥∗= 0 or 𝜇2𝑎+ 𝜎2𝑎= 0.
Var(𝐸[𝑓𝜃(𝑥)|𝑥∗,𝜃]) = Var(𝐸[𝑎.𝑥+ 𝑏|𝑥∗,𝑎,𝑏]) = Var(𝑎.𝐸[𝑥∗] + 𝑏)
= Var(𝑎.𝜇𝑥∗+ 𝑏)
= 𝜇2
𝑥∗.Var(𝑎) + Var(𝑏) + 2Cov(𝑎.𝜇𝑥∗,𝑏)
= 𝜇2
𝑥∗.𝜎2
𝑎+ 𝜎2
𝑏+ 2𝜇𝑥∗.Cov(𝑎,𝑏)
(18)
Equation 18 captures the uncertainty rooted in the model pa-
rameters 𝜎2𝑎and 𝜎2
𝑏, and their covariance Cov(𝑎,𝑏). This is the
uncertainty rooted in the limitations of the cost model. Therefore,
mapping the term Var(𝐸[𝑓𝜃(𝑥)|𝑥∗,𝜃]) to the uncertainty rooted in
model parameters is justified. Note that the term Var(𝐸[𝑓𝜃(𝑥)|𝑥∗,𝜃])
is reduced to zero if and only if 𝜎2𝑎= 0, 𝜎2
𝑏= 0, and Cov(𝑎,𝑏) = 0.
In such a scenario, the total variance of the plan’s cost estimate will
be determined by the cardinality errors and the sensitivity of the
cost to those errors.
Note that the assumption of a normal distribution for 𝑎, 𝑏, and 𝑥∗
is made to facilitate the discussion and that it is inconsequential to
the conclusions. The same applies to the assumption of linearity.
□
A.2
Extended Discussion on the Formulation of
SOR
To instantiate SOR with a Gaussian prior, let us rewrite Equation
11 as:
𝛿= 𝐶𝑥−𝐶𝑦∼N (𝜇𝛿, 𝜎2
𝛿)
where 𝜇𝛿= 𝜇𝑥−𝜇𝑦, 𝜎2
𝛿= 𝜎2𝑥+ 𝜎2𝑦The probability density function
F (𝛿) for a variable 𝛿with normal distribution N (𝜇𝛿, 𝜎2
𝛿) is:
F (𝛿) =
1
√︃
2𝜋𝜎2
𝛿
𝑒−(𝛿−𝜇𝛿)2
2𝜎2
By substituting 𝛿, 𝜇𝛿and 𝜎2
𝛿this equation can be expanded as:
F (𝛿) =
1
√︃
2𝜋(𝜎2𝑥+ 𝜎2𝑦)
𝑒
−
(𝐶𝑥−𝐶𝑦−(𝜇𝑥−𝜇𝑦))2
2(𝜎2𝑥+𝜎2𝑦)
The risk of suboptimality of plan 𝑥over plan 𝑦(i.e. 𝑅(𝑥,𝑦)) can
be computed as:
𝑅(𝑥,𝑦) = 𝑃(𝐶𝑥> 𝐶𝑦) = 𝑃(𝛿> 0) =
∫∞
0
F (𝛿)𝑑𝛿
where as demonstrated above, F (𝛿) is a function of 𝐶𝑥, 𝐶𝑦, 𝜇𝑥,
𝜇𝑦, 𝜎𝑥, and 𝜎𝑦.
This demonstrates that SOR(𝑝𝑖), which is the average risk of
suboptimality of plan 𝑝𝑖as given in Equation 13, is a function of
the expected value and variance of cost (and hence robustness) of
all plans in the search space.
A.3
Hint Sets Used for Plan Generation
Inspired by the finding reported by Bao [22], these hint sets were
used which include the most influential among the total 46 hint sets:
[disable nljn], [disable nljn, disable iscan], [disable hsjn], [disable
hsjn, disable iscan], [disable mgjn], [disable mgjn, disable iscan],
[disable nljn, disable mgjn ], [disable nljn, disable mgjn, disable
iscan], [disable nljn, disable hsjn ], [disable nljn, disable hsjn, disable
iscan], [disable mgjn, disable hsjn ], [disable mgjn, disable hsjn,
disable iscan]

---

