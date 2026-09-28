# Poisson&#39;s CDF applied to Flexible Skylines

> 来源: https://arxiv.org/pdf/2201.10217

1 
 
Poisson’s CDF applied to Flexible Skylines 
Jaime Pons Garrido 
Politecnico di Milano 
Milan, Italy 
jaime.pons@mail.polimi.it 
Abstract 
The evolution of skyline and ranking queries has created new archetypes like flexible skylines, which have proven to 
be an efficient method to select relevant data from large datasets using multi objective optimization. This paper aims 
to study the possible applications of Poisson distribution mass function as a monotonic scoring function in flexible 
skyline processes, especially those featuring schemas whose attributes can be translated to constant mean rates. 
Moreover, a method to express user’s requirement by means of the Ƒ-dominant set of tuples will be proposed using 
parametrical variations in Ƒ [1], simultaneously, algorithm construction and potential applications will be studied. 
Keywords: Flexible skylines, Poisson Distribution, Ranking queries, Skyline queries 
1 Introduction 
Dealing with data, especially when the amount is big, is a complex matter at several levels. In this regard, 
selecting significant relevant data from a large dataset is one of the processes that have hoarded many 
investigation resources to create a method to perform such operations in DBMS. Ranking and skyline 
queries have been de facto solutions for addressing such problems for long periods of time. 
 
Ranking queries (or top-k queries) propose a weighted scoring system in which the query’s output is the 
result of a ranking in which each data tuple is ranked according to a weighted scoring function and ordered 
in consequence [11]. The advantages brough by this model are many, first it allows one to control the 
cardinality of the result desired (top-k) by selecting the k-tuples with best score. Moreover, the weighted 
function allows users to express their criteria or preferences by modifying weights. 
 
On the other hand, this type of query has major disadvantages in terms of efficiency and scalability since a 
weight change means all the previous computations are invalid. This may lead to several repetitions of the 
whole process until appropriate results are provided, thus, potentially wasting system resources in rankings 
that eventually will be obsolete. 
 
Skyline queries implement a different approach, instead of grouping parameters and compare scalar values, 
tuples are treated like vectors and a dominance criterion is defined [2]. This criterion stablishes that a tuple 
is dominant over another if it contains at least one attribute greater than the same exact attribute of the other 
tuple and all the other ones are greater or equals than their counterparts. To be precise, let 𝑡1, 𝑡2 be tuples: 
 
SKY(R) = {t1|∀t2 ∈R, ∃ait1(ai) > t2(ai) ∧∀ai, i = 1, … n, t1(ai) ≥t2(ai)} 
 
(1) 
 
This solution provides much better scalability since all computations are susceptible to be reused plus it 
does not maintain an order, instead it creates two subsets of dominated and non-dominated tuples. In return, 
its weaknesses match ranking strengths by not having control over the cardinal of the non-dominated set of 
tuples, very limited expression capabilities regarding user preferences, plus O(n2) efficiency. 

---

2 
 
1.1 Flexible skyline queries 
Flexible skyline, also known as F-Skyline, queries intend to provide an in between solution able to be 
computationally affordable but also provide certain control over cardinality and user preferences. If Skyline 
queries were based on Pareto’s Dominance concept [3,12], this new approach intends to combine it with 
the method applied in top-k queries. 
 
Let r be a relational schema belonging to DBMS and let Α = (Α1, Α2, … , Α𝑛) be the set of normalized ([0,1] 
- valued) attributes related to r. Let Ɱ be the family of all monotonic scoring functions (𝑓: [0,1] →ℝ), like 
the one that may be used in ranking queries. Flexible skylines now define the concept of  Ƒ -dominance [1] 
as a Pareto Dominance applied to 𝑒𝑖, 𝑒𝑗 ∈𝑟 where 𝑒𝑖 will dominate 𝑒𝑗 if and only if 𝑒𝑖 attributes have always 
better or equal scores than 𝑒𝑗 attributes with respect to the function subset  Ƒ ⊂Ɱ. 
 
This approach allows computational efficiency since modifying the subset  Ƒ  only requires computing the 
additional functions added and deprecate those removed, but the ones that remain after the modification do 
not require additional computations. Moreover, user priorities or preferences may be expressed through 
constraint inclusions in the set Ƒ  and cardinality of the result is able to be reduced by considering specific 
output subsets such as ND and PO [1,2,4].  
 
DEFINITION 1.1: Let Ƒ be a set of monotone scoring functions. A tuple t Ƒ-dominates another tuple s ≠ t, 
denoted by t ≺Ƒ  s, if and only if  ∀𝑓∈Ƒ, 𝑓(𝑡) ≤𝑓(𝑠). 
 
DEFINITION 1.2: (ND). Let Ƒ ⊆ Ɱ be a set of monotone scoring functions. The non-dominated flexible 
skyline of r with respect to Ƒ, denoted by ND (r; Ƒ), is defined as the following set of tuples: 
 
ND(r; Ƒ ) = {t ∈r|∄s ∈r. s ≺Ƒ t} 
 
 
 
(2) 
 
DEFINITION 1.3: (PO). Let Ƒ ⊆ Ɱ be a set of monotone scoring functions. The potentially optimal flexible 
skyline of r with respect to Ƒ, denoted by PO (r; Ƒ), is defined as: 
 
 
 
 
 
PO(r; Ƒ ) = {t ∈r|∃Ƒ ∈Ɱ , ∀s ∈r, s ≠t →f(t) < 𝑓(𝑠)}  
 
(3) 
 
1.2 Poisson distribution 
The Poisson Distribution is a discrete probability distribution that has been prominent in the statistics field 
due to its convenient capability to express the probability of occurrence for a determined number of events 
in a fixed interval, usually of time. Poisson requires events to occur at constant mean rate and independently 
of the last event time of occurrence.[5] 
 
DEFINITION 1.4: (Mass function) Let X be a discrete random variable. X has Poisson distribution with 𝜆 
parameter, 𝑋~𝑃𝑜(𝜆) if the probability of having k occurrences is, where 𝐾∈ ℤ+: 
 
𝑃(𝑋= 𝐾) =
𝜆𝑘𝑒−𝜆
𝐾! 
 
 
 
 
(4) 
 
DEFINITION 1.5: (Cumulative Distribution Function) Let X be a discrete random variable. X has Poisson 
distribution with 𝜆 parameter, 𝑋~𝑃𝑜(𝜆) if the probability of having K or less occurrences is: 
 
𝑃(𝑋≤𝐾) =
𝛤(⌊𝐾+1⌋,𝜆)
⌊𝐾⌋!
  
 
 
      (5) 
Where 𝛤 represents the incomplete gamma distribution. 

---

3 
 
 
After this brief introduction about the Poisson distribution one can realize that Poisson and, in general, all 
probabilistic distributions have a parametrical family in their CDF. In Poisson’s case this family depends 
on 𝜆 as a unique parameter. We provide a previous definition from the F-skyline theoretical development 
[1,2]. 
 
DEFINITION 1.6: A set F of scoring functions is said to be tuple-distinguishing if the following holds: 
 
∀𝑡, 𝑠∈[0,1]𝑑, 𝑡≠𝑠→(∃𝑓∈Ƒ . 𝑓(𝑡) ≠𝑓(𝑠))  
 
(6) 
 
PROPOSITION 1.1: Let 𝑃(𝛼1…𝛼𝑛) be the subset conformed of Poisson CDF functions depending on an arbitrary 
n number of parameters → 𝑃(𝛼1…𝛼𝑛) is also a subset of monotonic (non-decreasing) functions where 𝑓∈
𝑃(𝛼1…𝛼𝑛) is of the form 𝑓: ℝ→[0,1] plus it is tuple-distinguishing. 
Proof: 
 
To prove that P is a subset of monotonic, more precisely, non-decreasing functions. It suffices with reasoning 
that the derivative of a Poisson CDF is its mass function. Following Def 1.4: 𝑃(𝑋= 𝑘) =
𝜆𝑘𝑒−𝜆
𝑘! . It is trivial to check 
it is a coefficient between two positive factors that cannot be null. Therefore, CDF derivative is always positive which 
implies P is a subset of non-decreasing functions. 
 
The fact that CDF is non-decreasing implies  ∀𝑡, 𝑠, 𝑡≠𝑠→𝑓(𝑡) ≠𝑓(𝑠), 𝑤ℎ𝑒𝑟𝑒 𝑓 𝑖𝑠 𝑎 𝐶𝐷𝐹. If we consider t and s 
such as 𝑡≠ 𝑠 composed by two suitable attributes but include the condition 𝑓(𝑡) = 𝑓(𝑠)  each we have the following: 
 
𝑃(𝑋≤𝑠[1]) + 𝑃(𝑋≤𝑠[2]) = 𝑃(𝑋≤𝑡[1]) + 𝑃(𝑋≤𝑡[2]) → 
𝑃(𝑋≤𝑠[1]) −𝑃(𝑋≤𝑡[1]) = 𝑃(𝑋≤𝑡[2]) −𝑃(𝑋≤𝑠[2]) 
 
However, this implies the area integrated between s[1] and t[1] which is the increased mass of probabilistic density 
between both points is equal to the one between t[2] and s[2]. And this must fulfill for all possible Poisson distributions 
included in the family. 
 
Considering that Poisson CDF derivative (Mass function) is always positive, but certainly not constantly positive. It 
can be stated that increases along the different areas of the CDF are not constant which means that the areas enclosed 
Figure 1: Poisson CDF iterating on several lambda values 

---

4 
 
between two different pairs of point, may be equal for a particular case but that equality cannot be extended if 
parametrical values change since derivatives will do too and not at the same rate. Implying: 
 
𝑃(𝑋≤𝑠[1]) −𝑃(𝑋≤𝑡[1]) ≠𝑃(𝑋≤𝑡[2]) −𝑃(𝑋≤𝑠[2])  
 
An equivalent assumption could be derived considering K as fixed value and instead using t and s parameters as mean 
constant rates (𝜆).∎ 
 
Considering what has been previously stated, one could make the argument that CDFs are, indeed, viable 
parametrical candidates to be applied to F-skylines. This paper aims to provide an initial overview about 
the possible use of Poisson CDF in F-skylines processes, this englobes: 
 
- 
A brief theoretical introduction to Poisson Distribution, its asymptotic behavior. 
- 
An approach to the possible methods to use Poisson CDF in the already developed F-skylines. 
- 
A discussion about its possible potential applications, followed by final conclusions regarding 
overall advantages and disadvantages of the implementation. 
2 Poisson CDF applied to F-skyline queries 
 
The application of Poisson distribution to F-skylines must be strongly linked to the need of modelling 
Poisson-like processes within those queries. Nowadays, selection processes, ranking computations and 
many other procedures where the use of F-skylines is a viable option depend more on dynamic to be 
anticipated, not considered once they become a fact, for example the number of orders that will arrive to a 
warehouse at a determined time. A simple adaptation to this phenomenon may consist in making different 
use of the attributes stored at a relational schema and the usual constraints introduced to adapt to the user’s 
preferences to create scoring functions able to take into account this kind of factor. 
 
The solution proposed follows the following structure: let r be a relational schema and 𝑎𝑖∈𝑟 is an attributed 
belonging to the model. Now let 𝑎𝑖 be the mean (expected value) of a dynamical process relative to the 
schema. (i.e., Let r be modelling a restaurant, then 𝑎𝑖 may be the expected number of guests from 8pm to 
9pm), obviously the value of the attribute has been obtained by statistical inference. 
 
PROPOSITION 2.1: Let X be a Poisson random variable, then its expected value is 𝜆 
Proof: Stated in reference [5] page 1. 
 
By proposition 2.1 we can see that if we were to model the random variable relative to 𝑎𝑖 as a Poisson 
distribution, the parameter lambda corresponding to it would be 𝑎𝑖. Therefore, the relationship between the 
attribute and the distribution already generates a CDF function parametric family as a function of a K 
parameter, obtaining a subset: 
 
Ƒ = {𝑃(𝑋≤𝐾)|𝐾∈[0,+∞), 𝑋~𝑃𝑜(𝑎𝑖)} 
 
 
(7) 
 
K parameter is intended as a user preferences-oriented parameter which expresses the number of 
occurrences for the treated phenomenon desired by the user. 
 

---

5 
 
2.1 Poisson CDR asymptotic behavior as a scoring function 
PROPOSITION 2.2 Let be X a Poisson distributed variable with fixed 𝜆, then lim
 K→0(𝑃(𝑋≤𝐾) − 𝑃(𝑋≤𝐾+ 1)) =
 0 and lim
 K→+∞(𝑃(𝑋≤𝐾) − 𝑃(𝑋≤𝐾+ 1)) = 0.  Proof: Stated in reference [6] 
 
The previous result indicates that the probability mass of a Poisson distribution is highly concentrated 
around 𝜆, this means that when used as a scoring function, the expected behavior will be to experience 
significant scoring fluctuations between values close to the mean. However, for those values far enough, 
whether the number of occurrences is extremely high or low, the difference in scoring between then will 
not be relevant. [5, 6] A colloquial approach to this would be to expect that the phenomenon measured by 
the CDF will lose relevance in comparison to other attributes when located far away from the mean. 
 
Regarding F-skylines, the usual implementation considers that tuples with lower scores are the best 
ones[1,2], however this is just a design choice and, obviously, depending on the results we expect there are 
several naïve transformations that can be applied to the scoring function to encourage different types of 
behaviors. For example, if higher scores are wished for a low constant K: 𝑓≔1 −𝑃(𝑋≤𝐾) ≡𝑃(𝑋> 𝐾) 
is a viable scoring function. On another case, if high scores are wished for K values close to the average 
number of occurrences expected (𝜆), function (8) can be used.: 
 
𝑓(𝑋) = 1𝑘<𝜆∙𝑃(𝑋≤𝐾) + 1𝑘≥𝜆∙𝑃(𝑋> 𝐾) 
where  
(8) 
 
1𝑘<𝜆≔{1 if 𝑘< 𝜆 
0 else
 
 
This function formulated like this may be understood as a non-monotonic function, however it is the 
addition of 2 monotonic functions that are independent and do not overlap, thus it can be decomposed 
therefore not supposing a problem for the evaluation of the score. 
 
There is one last relevant problem to be addressed regarding CDFs application to F-skylines. If Ɱ is stated 
as the family of monotonic scoring functions (𝑓: [0,1] →ℝ) and Ƒ ⊂Ɱ. We can directly see that Poisson 
CDF has inversed domains. 
 
Figure 2: 1-CDF Poisson iterating on several lambda values 

---

6 
 
2.2 Domain inversion between Poisson CDF and Ƒ 
 
There are two possibilities to address the domain inversion between both sets of functions. The first one 
implies limiting the CDF domain using the asymptotic behavior previously explained and the other one is 
simple, use the inverse of the CDF function (CDF−1). 
 
- 
The first solution tackles both domain and codomain problems, being the first one the most 
problematic. Domain of a CDF states that K that can be any real positive number, however the 
results in Proposition 2.1 indicate that for high K values the increment in CDF dismisses tending 
to 0. Thus, if chosen a C (constant) high enough, we can turn our domain 𝐾∈ℝ+ into 𝐾∈[0, C] 
which is limited. Afterwards, there is no possibility to reduce it to [0,1] without heavily altering 
the function’s behavior. 
 
Now regarding the codomain problematic, having a codomain of [0,1] is not such a big issue since 
actually many scoring functions act in this way. However, if there are functions in Ƒ that score 
values over 1 and there is a proportional decompensation, multiplying the results of the CDF times 
a scalar factor suffices to bypass the problem. It could be understood as applying a weight to the 
function. 
 
- 
 Calculating CDF−1 directly solves all domain problems, but changes the meaning of the 
distribution, which now does not calculate an accumulated probability but given one it returns its 
associated value K. This kind of function may also have several potential use cases. 
 
These modifications are important to take into consideration, moving onwards Poisson CDF will be kept 
as the function to study without applying these changes for simplicity issues. 
2.3 Computation procedures 
Let the following result be considered from [1,2]: 
 
PROPOSITION 2.3: For any set Ƒ of monotone scoring functions, 𝑃𝑂(𝑟, Ƒ) ⊆𝑁𝐷(𝑟, Ƒ) ⊆𝑆𝐾𝑌(𝑟) 
Proof: Stated in reference [1], section 3.1, Prop 1. 
 
 Two algorithms proposed by Ciaccia & Martinenghi [1] (SVE1F and POND) which can compute ND 
and PO subsets respectively, have been considered with the purpose of calculating those subsets using 
Poisson CDF. This only implies including an optimization feature able to take advantage of Poisson 
asymptotic behavior. The following subset type Ƒ will be considered: 
 
Ƒ = {𝑃(𝑋> 𝑤1) + 𝑎2 ∙𝑤2 + ⋯+ 𝑎𝑛∙𝑤𝑛|𝑋~𝑃𝑜(𝑎1),𝑤𝑖∈[0,1]∀𝑖≠1,𝑤1 ∈[0, +∞]} 
  (9)
 
 
PROPOSITION 2.4: Let X be a random variable of the form  𝑋~𝑃𝑜(𝜆).This implies Var (𝑋) = 𝜆 
Proof: Stated in reference [5], page 5. 
 
The modification in SVE1F takes place when the algorithm starts calculating the scores of a particular 
tuple in the Ƒ  subset and it needs to calculate a score based with Poisson CDF as scoring function. 
Moreover, consists of assigning asymptotic limits to K values when they fall of the range of two typical 
deviations from the mean. The mean in this case is 𝑎1 (9) which will be the constant mean rate that was 
stored in the schema attributes. The asymptotic limit introduced will vary if the asymptotic limit tends 
towards 0 or towards 1. The following lines provide pseudocode for the modification. 
 

---

7 
 
 
 
⋮𝑐𝑜𝑚𝑝𝑢𝑡𝑒 𝑣= ∑
𝑤𝑖
(𝑙)𝑠[𝐴𝑖]𝑝
𝑑
𝑖=2
//𝑚𝑜𝑟𝑒 𝑟𝑒𝑓𝑒𝑟𝑒𝑛𝑐𝑒𝑠 𝑎𝑏𝑜𝑢𝑡 𝑡ℎ𝑖𝑠 𝑜𝑝𝑒𝑟𝑎𝑡𝑖𝑜𝑛 𝑖𝑛 [1] 
 
⋮𝒊𝒇 𝑤1 ∈[𝑎1 −2√𝑎1, 𝑎1 + 2√𝑎1] 𝒕𝒉𝒆𝒏 𝑐𝑜𝑚𝑝𝑢𝑡𝑒 𝑣= 𝑃(𝑋> 𝑤1) + 𝑣, 𝑋~𝑃𝑜(𝑎1)//𝑃𝑜𝑖𝑠𝑠𝑜𝑛 𝐶𝐷𝐹 𝑐𝑎𝑠𝑒 
 
⋮𝒆𝒍𝒔𝒆 𝒊𝒇 𝑤1 ≥𝑎1 −2√𝑎1 𝒕𝒉𝒆𝒏 𝑐𝑜𝑚𝑝𝑢𝑡𝑒 𝑣= 1 + 𝑣//𝑜𝑝𝑝𝑜𝑠𝑖𝑡𝑒 𝑐𝑎𝑠𝑒 𝑤𝑜𝑢𝑙𝑑 𝑎𝑝𝑝𝑒𝑎𝑟 𝑖𝑓 𝑃(𝑋≤𝑤1)  
 
 
In the previous pseudocode, the first line calculates the sum of the non-Poisson parameters scores, 
the second one checks that w1 falls within [𝑎1 −2√𝑎1, 𝑎1 + 2√𝑎1] range, further explained in the 
following paragraph, if it does, it calculates its value following Poisson CDF. Otherwise, when the 
condition is not met, there are two possibilities, if the value is higher than the range, the third line computes 
v = 1 directly. If it turns out the value is lower than the range the associated probability will tend towards 
zero, thus nothing is added. 
 
The reason behind this implementation choice is that in most distributions a large percentage of the 
probability mass falls within the range of two typical deviations. This is a well-known fact further explained 
in references [7,8] and empirically supported by the 68-95-99.7 rule. By doing this we pretend to save 
computational power by not effectuating Poisson CDF calculations that will return values extremely close 
to zero or one. As previously stated, mass function is the derivative of the CDF so, if the values of the first 
are close to zero outside of the range of two typical deviations, we can assume that the increase in CDF 
value will be minimal, which makes feasible to substitute its value for an asymptotic limit. 
 
To select the potentially optimal subset (PO), the process proposed in reference [1], section 5.2 is followed. 
In this process, ND(r, Ƒ) subset tuples discard any combination Ƒ-dominated by a convex combination of 
ND tuples as stated in Theorem 11(Potential optimality test) [1], section 4.2. The question to make now is 
if CDF requires a different criterion rather than the exposed in that theorem to proof a tuple is PO. 
Considering Ƒ still is a sum of weighted monotonic scoring functions with single attributes, Theorem 11) 
[1] should also be applicable to this case. POND algorithm is explicitly described in reference [1], section 
5.2. 
3 Potential applications 
The inclusion of CDFs and more precisely Poisson’s into F-skylines could be a potential improvement to 
adapt this process to different fields in which a stochastic processing of data is encouraged, therefore 
augmenting the probabilities of creating relational schemas whose attributes are suitable to be valued by a 
CDF. Some of these applications will be reviewed now and are also disclosed in [9, 10, 12]: 
 
Recommendation-based systems: Those based on the concept of human-choice simulation are prone to 
incorporate this new type of F-subsets if they use the F-skyline procedure. This enables them to improve 
their response to user or environment interactions by consider statistically inferred measurements in 
conjunction to CDFs to evaluate the best response to a stimulus. For example, using Poisson distribution to 
retrieve the user’s most performed interaction after K occurrences of an event calculating the probability 
of those K occurrences taking place and offering adjusted recommendations in consequence. 
 
Managerial systems: Relying heavily on their capability to improve the efficiency of resource allocation 
within large companies or systems, if they use large database systems to select the best options to allocate 
or free resources, then applying CDF to their selection processes using F-skylines may result on a drastic 
improvement. These types of uses are wide ranged, for example: 
 

---

8 
 
- 
Public health system tracking the number of emergency ambulances arriving to each hospital 
during certain critical periods of time, may use this to compute efficient destinations for personal, 
or medical equipment by selecting ND elements of F-skylines. 
- 
Security forces can compute at large scale optimal routes to patrol the streets with higher 
probability of a certain number of violent events happening during nighttime periods. 
 
Machine learning applied to ranking: In this kind of system filtering relevant information is vital to 
achieve quality results. Many big data sets come within a lot of irrelevant information; therefore, using F-
skylines as selection process to identify relevant data can help to speed up processes. In this context, being 
able to select tuples who have higher probability of a determined future behavior may be useful information 
to feed the system. 
 
User Oriented comparation systems: Poisson distribution is especially useful measuring probabilities 
related with mass transit through a determined place. This supposes at differential factor when a system 
must reduce the viable alternatives available to perform a task or travel to a location. 
Medical healthcare apps provide the option to schedule medical appointments in several locations. A 
dynamic phenomenon increasing its relevancy regarding these selections is crowd avoiding. By registering 
the most booked hours at every center, the app should be able to use Poisson CDF and constant mean rates 
to concede more priority to those centers without much transit probability at the time of the appointment. 
By reflecting that positive attribute as a stochastic probability in the scoring function. 
The opposite type of use is also a possibility, for example when searching viable leisure activities which 
significantly improve as the number of concurrent users performing them increases. 
 
Example 3.1: In this example a medical application helps a client to select the best hospital to schedule an 
appointment considering distance and the number of concurrent patients visiting the hospital as factors to 
make a choice. 
 
Let a simple relational schema r with two attributes be considered. Ar=(AverageFrequency, Distance). 
Where AverageFrequency is the average number of patients arriving to a hospital on a determined time 
interval and Distance is a [0,1]- valued parameter representing distance to the location.The dominance 
relation between elements of r is defined as in Definition 1.1 and subset Ƒ as: 
 
Ƒ = {𝑃(𝑋> 𝑘1) ∙ 𝑤1 + 𝐷𝑖𝑠𝑡𝑎𝑛𝑐𝑒∙ 𝑤2|𝑋~𝑃𝑜(𝐴𝑣𝑒𝑟𝑎𝑔𝑒𝑃𝑎𝑡𝑖𝑒𝑛𝑡𝑠), 𝑤𝑖∈[0,1], ∑ 𝑤𝑖= 1, 𝑤𝑖< 𝑤𝑖+1,
𝑘𝑖∈[0, ∞] } 
 
 
 
 
 
 
 
 
 
           (10)
 
 
A first parametrical choice is made when selecting 𝑘1, in our case, 𝑘1= 8. Now, our main interest is 
obtaining ND and PO sets, a process detailed in [1], sections 4, 5. This must be done variating the possible 
constraints in set 𝑤𝑖. In this case, we have considered a small subset conformed by five hospitals. 
 
 
Figure 3: F-skyline regarding the most convenient medical centers nearby. 

---

9 
 
 
 
We can see that ND ≡{H1, H3, H5} and PO ≡{H1, H3}, Therefore, now the system is able to provide a 
better selection based on these results. This example also identifies some of the limitations of Poisson CDF 
regarding computation of ND and PO subsets. In the previous analysis the set k𝑖 was fixed and 𝑤𝑖 was the 
set of constraints subject to variation to find the subsets. The opposite could also be made, obtaining 
different results. However, the analysis gets much more complicated if both sets of constraints are subject 
to variation, that case is out of the scope of this paper and is practical utility may yet to be discussed. 
4 Conclusions 
The inclusion of new subsets of functions to already well formularized methodologies like flexible skylines 
may suppose an advantage in terms of expanding the capabilities of those. CDFs are natural candidates due 
to their suitability to form F subsets. Moreover, the inclusion of dynamic factors and statistical parameters 
into data structures makes more feasible to find indicators (i.e., mean, variance, etc.) in databases subject 
to F-skylines operations, therefore, being able to use CDF poses an intrinsic advantage in many more cases 
because it allows to consider probabilities associated to these indicators when the adequate distribution to 
model the events is selected. 
 
Focusing on Poisson distribution it seems that including it into an Ƒ subset mixed with low-grade 
polynomial functions commonly used in F-skyline procedures [1,2] allows to keep using the standard 
algorithmic procedures. Plus, as discussed on Section 2, knowledge about asymptotic behavior and 
derivatives may be useful in optimization terms when the inserted values are extreme. In addition, Poisson 
unique characteristics, especially the one formulated in Proposition 2.1, provide unparalleled simplicity to 
store the relevant statistical indicators and a clear path to involve them as parametrical values once the 
Poisson CDF starts being treated like a scoring function within Ƒ. 
 
On the other hand, if other statistical distributions were evaluated for suitability, it would not be such a 
simple implementation due to the large variability between probabilistic distribution’s properties. This 
would imply more expensive computations to find a valid parameter for those distributions while in 
Poisson’s case the mean is acceptable. Moreover, there are still many unresolved matters to study regarding 
Poisson CDF, to mention some examples: 
 
- 
ND and PO behavior in F subsets composed purely of Poisson CDFs and those which are mixed. 
How does the election of k𝑖 parameters affect the cardinality of both sets? Is it efficient to search ND and 
PO taking k𝑖 parameters into account? 
 
- 
Perform empirical simulations of F-skyline processes including Poisson CDFs to evaluate their 
efficiency and complexity, followed by a comparation against other relevant methodologies able to offer 
similar results in terms of non-dominated tuples. 
 
- 
Further study the application of F-skylines to build complex stochastic models like Markov Chains 
based on Poisson processes. 
 
- 
Evaluate and compare Poisson’s characteristics to identify other suitable distributions to be 
included into Ƒ subsets in meaningful ways regarding their capabilities as stochastic quantifiers. 
 
 
 

---

10 
 
References 
[1] Paolo Ciaccia, Davide Martinenghi. Reconciling skyline and ranking queries. In Proceedings of the VLDB 
Endowment, Volume 10, Issue 11, August 2017, pages 1454–1465. Proceedings of the VLDB Endowment, 2017. 
DOI: https://doi.org/10.14778/3137628.3137653. 
[2] Paolo Ciaccia, Davide Martinenghi. Flexible skylines: Dominance for arbitrary sets of monotone functions. ACM 
Transactions 
on 
Database 
Systems, 
Volume 
45(Issue 
4):1–45, 
December 
2020. 
DOI: 
https://doi.org/10.1145/3406113. 
[3] Mock W.B.T. (2011) Pareto Optimality. In: Chatterjee D.K. (eds) Encyclopedia of Global Justice. Springer, 
Dordrecht. https://doi.org/10.1007/978-1-4020-9160-5_341 
[4] Paolo Ciaccia, Davide Martinenghi. Beyond skyline and ranking queries: Restricted skylines (extended abstract). 
In Beyond Skyline and Ranking Queries: Restricted Skylines (Extended Abstract),SEBD 2018, June 24-27, 2018, 
Castellaneta Marina, Italy, pages 1–8. SEBD, 2018. CEUS-WS: https://http://ceur-ws.org/Vol-
2161/paper20.pdf. 
[5] Glen 
Cowan. 
Derivation 
of 
the 
Poisson 
distribution. 
RHUL 
Physics. 
1 
December, 
2009:   
https://www.pp.rhul.ac.uk/~cowan/stat/notes/PoissonNote.pdf 
[6] Hwang, H. (1999). Asymptotics of poisson approximation to random discrete distributions: An analytic approach. 
Advances in Applied Probability, 31(2), 448-491. doi:10.1239/aap/1029955143 
[7] Huber, Franz (2018). A Logical Introduction to Probability and Induction. New York, N.Y.: Oxford University 
Press. p. 80. ISBN 9780190845414. https://doi.org/10.1239/aap/1029955143 
[8] Pukelsheim, Friedrich. “The Three Sigma Rule.” The American Statistician 48, no. 2 (1994): 88–91. 
https://doi.org/10.2307/2684253. 
[9] Wagner Meira Jr. Mohammed J. Zaki. Data Mining and Machine Learning: Fundamental Concepts and 
Algorithms. Data Mining and Machine Learning. Cambridge University Press, 2020 
[10] Stirzaker, David. Stochastic Processes & Models, Oxford University Press, 2005 
[11] Mohamed A. Soliman Ihab F. Ilyas, George Beskales. A survey of top-k query processing techniques in relational 
database 
systems. 
ACM 
Computing 
Surveys, 
Volume 
40(Issue 
4):1–58, 
October 
2008. 
https://doi.org/10.1145/1391729.1391730 
[12] Börzsönyi, S., Kossmann, D., & Stocker, K. (2001). The Skyline operator. Proceedings 17th International 
Conference on Data Engineering, 421-430. 

---

