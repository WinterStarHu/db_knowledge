# A Fuzzy Approach to Record Linkages

> 来源: https://arxiv.org/pdf/2402.03464

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
1
 Abstract—Record Linkage is the process of identifying and 
unifying records from various independent data sources. Existing 
strategies, which can be either deterministic or probabilistic, often 
fail to link records satisfactorily under uncertainty. This paper 
describes an indigenously developed fuzzy linkage method, based 
on fuzzy set techniques, which can effectively account for this 
uncertainty prevalent in the disparate data sources and address the 
shortcomings of the existing approaches. Extensive testing, 
evaluation and comparisons have demonstrated the efficacy of this 
fuzzy approach for record linkages. 
 
Index 
Terms—Record 
Linkage, 
Deterministic 
Linkage, 
Probabilistic Linkage, Fuzzy Linkage, Fuzzy Matching, Fuzzy Set 
Theory, Fuzzy Logic, Fuzzy Weights, Fuzzy System, Fuzzy 
Clustering. 
I. INTRODUCTION 
ata comes in different shapes, sizes, and quality from 
multiple different sources with many idiosyncrasies. 
Personal information, encapsulated as strings, often contains 
typographical and data entry errors and misspellings, over time 
changes, false, or missing information. Spouses and/or children 
of a family can use the primary member’s information. 
Households may not have been identified. Therefore, there is a 
pressing need in every organization to unify, align and merge 
data gathered from multiple disparate data sources. 
Record linkage [1-3] is the task of linking or finding data 
from multiple data sources that refer to the same entity. There 
are two main types of linkage algorithms, namely, deterministic 
and probabilistic. Choosing the best algorithm to use in a given 
situation depends on many interacting factors, such as time, 
resources, the research question, and the quantity and quality of 
the variables or columns available to link, including the degree 
to which they individually and collectively are able to identify 
an individual uniquely. The key is to develop algorithms to 
extract and make use of enough meaningful information to 
arrive at sound decisions. Here, we consider record linkages 
based only on columns whose values are strings (textual). 
Deterministic algorithms determine if record pairs agree or 
disagree on a given set of identifiers (attributes) through exact 
pattern matching, where agreement on a given identifier is 
assessed as a discrete—all-or-nothing—outcome. Match status 
is determined in a single or in multiple steps. Accordingly, there 
are two types, namely, exact and approximate or iterative 
record matching. Exact deterministic matching is a single step 
strategy that requires an exact match on the full set of identifiers 
all at once. Approximate or iterative matching is a multi-step 
strategy that requires an exact match on one of the several 
rounds of matching but not on all possible identifiers. In this 
strategy, records are matched in a series of progressively less 
 
 
Pratik K. Biswas is with Artificial Intelligence and Data Science, Verizon 
Communications, 
Basking 
Ridge, 
NJ, 
USA 
07920 
(e-mail: 
Pratik.Biswas@verizonwireless.com).  
restrictive steps where pairs that do not meet a first round of 
match criteria are passed to a next round. If a record pair meets 
the criteria at any step, it is classified as a match. Otherwise, it 
is a non-match. The iterative deterministic strategy may consist 
of a sequence of deterministic matches using different match 
criteria in each successive round. 
Probabilistic 
algorithms 
determine 
the 
likelihood 
(probability) of agreement between record pairs on a given set 
of identifiers through inexact (approximate or fuzzy) 
string/pattern matching (attribute values). Comparison space 
can be reduced by searching only those matched pairs that meet 
certain basic criteria – this is known as blocking. Probabilistic 
strategies look at the discriminatory power of each identifier. 
The weight assigned to agreement or disagreement on each 
identifier is assessed as a likelihood ratio, comparing the m- and 
u- probabilities [2], where m-probability estimates the 
probability that two records agree on a particular identifier 
when they are true matches while the u-probability estimates 
the probability that two records agree on a particular identifier 
merely by chance. When two records agree on an identifier, an 
agreement weight is calculated by dividing the m-probability 
by the u-probability and taking the log2 of the quotient. When 
two records disagree on an identifier, a disagreement weight is 
calculated by dividing (1 - m-probability) by (1 - u-probability) 
and taking the log2 of the quotient. The total linkage weight for 
each record pair is obtained by summing the individual linkage 
weights for each linked identifier (column). The total linkage 
weights of each record pair is then compared with a pre-defined 
probability threshold and those record pairs whose weights are 
above this threshold (standard = 0.5) are considered as linkages. 
In information-poor yet business critical scenarios, where the 
collected data is of inferior quality, deterministic linkages may 
result in too few True Positives, while probabilistic linkages 
may result in very high False Positives or False Negatives 
depending on the chosen cut-off probability threshold.  
The quantification of uncertainties can be based on either 
probability theories, using random variables, or fuzzy set 
theories, using interval and fuzzy variables. Fuzzy set-based 
techniques are increasingly being used for design problems 
where there is random uncertainty, but information on the 
statistics of the uncertainty is sketchy. Fuzzy models are for 
uncertainties due to vagueness and can often perform better if 
little information is available. 
In this paper, we present a novel and flexible fuzzy record 
linkage solution that combines fuzzy matching, fuzzy set theory, 
fuzzy logic, fuzzy constraint, fuzzy weights, fuzzy rule-based 
inferencing and fuzzy clustering to provide record linkages that 
are more purposeful than either deterministic or probabilistic 
solutions in uncertain scenarios with imprecise and inadequate 
information.  
 
A Fuzzy Approach to Record Linkages 
Pratik K. Biswas 
D 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
2
II. RELATED WORK 
Related research falls into two categories: 1) record linkages 
and 2) fuzzy techniques associated with the proposed method. 
Herzog et al. [1] reviewed the different record linkage 
techniques. Fellegi and Sunter [2] provided the theory of 
probabilistic linkages. Christen [3] represented the record 
linkage procedure as a workflow, whose steps were cleaning, 
indexing, comparing, classifying and evaluation. The classified 
record pairs could be fed back to improve the previous step. 
Zadeh [4] proposed the fuzzy set theory in 1965 in order to 
model the uncertain and vague situations more precisely. 
Dubois and Prade [5] defined the concept of a fuzzy number 
and Novak [6] alluded to the triangular fuzzy number as the 
most used type of fuzzy number. Ali et al. [7] described many 
arithmetic operations on the triangular fuzzy number. Yue et al. 
[8] extended the traditional definition of neighborhood 
coverings to fuzzy ones, consisting of membership functions 
that formed an approximate distribution of neighborhood 
belongingness.  
Zadeh [4] also introduced the notion of fuzzy logic along 
with his proposal of fuzzy set theory. Furthermore, he [9-11] 
developed the concept of linguistic variables, which was 
subsequently formalized by Zimmerman [12]. Borovička [13] 
described the transformation process of linguistic terms to 
fuzzy numbers. Chen and Hwang [14] discussed the conversion 
scale. Wang et al. [15] also showed how to calculate fuzzy 
weights from linguistic terms. Bellman [16] described the fuzzy 
decision process as a multi-objective programming problem 
involving fuzzy goals and fuzzy constraints. Ruttkay [17] 
considered fuzzy constraint as a fuzzy relation. Mamdani [18] 
developed a new method of fuzzy inference systems, known as 
Mamdani-Type Fuzzy Inference. Beginning in 1987, various 
solutions to the Fuzzy Weighted Average (FWA) problem have 
been provided. Dong and Wong [19] presented the first FWA 
algorithm; Liou and Wang [20] presented an improved FWA 
(IFWA) algorithm; and Lee and Park [21] presented an EFWA. 
All three algorithms were based on -cuts. Other solutions 
included those in [22-25]. Ahmed et al. [26] compared and 
analyzed the performances of the different algorithms for Fuzzy 
Analytic Hierarchy Process (FAHP). Bezdek [27] introduced 
Fuzzy c-means clustering, while Li and Lewis [28] reviewed 
the application of various fuzzy clustering algorithms. 
Finally, Abril et al. [29] introduced a distance-based record 
linkage method which used Choquet integral to compute the 
distance between records as well as supervised learning to 
determine the optimal fuzzy measure for the linkage. 
III. PRELIMINARIES – CONCEPTS AND TERMINOLOGIES 
In this section, we clarify key concepts and terminologies and 
explain certain technologies, which provide the foundation for 
our work. 
A. Fuzzy Set Theory 
In this subsection, we will review only those concepts of 
fuzzy set theory [4-5, 7] that are relevant for us. 
Let 𝑋 denotes the classical set of objects called the universe, 
the generic elements of which are marked as 𝑥. A fuzzy set 𝐴 
is defined as: 𝐴= {(𝑥, 𝜇𝐴(𝑥)) | 𝑥 ∈𝑋, 𝜇𝐴(𝑥) ∈ [0,1]}. In the 
pair (𝑥, 𝜇𝐴(𝑥)), the first element belongs to the classical set and  
the second element 𝜇𝐴(𝑥), called membership function, belongs 
to the interval  [0,1]. We can say that A is a subset of X that has 
no sharp boundaries. 
 The kernel of a fuzzy set 𝐴 is defined as 𝐾𝑒𝑟(𝐴) =
{𝑥 | 𝜇𝐴(𝑥) = 1}, while the support of fuzzy set 𝐴 is defined 
as: 𝑆𝑢𝑝(𝐴) = {𝑥 | 𝜇𝐴(𝑥) > 0}. 
 Given  ∈ [0, 1], the 𝜶-cut of a fuzzy set 𝐴 is defined as a 
crisp set 𝐴𝛼(𝑜𝑟 𝐴[]) = {𝑥 | 𝜇𝐴(𝑥) ≥ 𝛼]}. 
A fuzzy number [5] is a fuzzy set 𝐴 on ℝ that must possess 
at least the following three properties, (i) 𝐴 must be a normal 
fuzzy set; (ii) 𝐴𝛼 must be closed interval for every 𝛼 ∈ [0,1], 
(iii) the support of 𝐴, 𝐴0+, must be bounded. A fuzzy number 
intuitively represents a value, which is inaccurate. 
A triangular fuzzy number [6] represented with three 
points as follows: 𝐴= (𝑎, 𝑏, 𝑐), 𝑤ℎ𝑒𝑟𝑒 𝑎 ≤ 𝑏 ≤ 𝑐. Its 
membership function has the shape of a triangle, formalized as: 
𝜇𝐴(𝑥) = 
{  
  0,   𝑥 < 𝑎, 𝑥 > 𝑐
𝑥−𝑎
𝑏−𝑎, 𝑎≤𝑥≤𝑏
𝑐−𝑥
𝑐−𝑏, 𝑏≤𝑥≤𝑐
1, 𝑥= 𝑏                 
   (3.1) 
The left and right triangular fuzzy number can be formally 
written as 𝐴𝑙= (𝑎, 𝑏, 𝑏), and 𝐴𝑟= (𝑏, 𝑏, 𝑐), with membership 
functions [30] as follows: 
𝜇𝐴𝑙(𝑥) = {
   0,
𝑥 < 𝑎, 𝑥 > 𝑝
𝑥−𝑎
𝑏−𝑎,   𝑎≤𝑥≤𝑏
1,
𝑏≤𝑥≤𝑝  
(3.2) 
𝜇𝐴𝑟(𝑥) = {
   0,
𝑥 < 0, 𝑥 > 𝑐
𝑐−𝑥
𝑐−𝑏,   𝑏≤𝑥≤𝑐 
1,
0 ≤𝑥≤𝑏  
(3.3) 
The 𝜶-cut of a triangular fuzzy number A = (a, b, c) is 
defined as 𝐴𝑎 (𝑜𝑟 𝐴[]) = [𝑎+ (𝑏−𝑎), 𝑐−(𝑐−𝑏)] (3.4) 
A fuzzy neighborhood of 𝑥∈𝑋 is defined as  
𝐹𝑁(𝑥) = {(𝑦, 𝜇𝐹𝑁(𝑥)(𝑦))  | 𝑦 ∈𝑋, ∀𝑥, 𝑥∈𝑋, 𝑑(𝑥, 𝑦) < 𝜆,
𝜇𝐹𝑁(𝑥)(𝑦) ∈ [0, 1]  & 𝜇𝐹𝑁(𝑥)(𝑦) = 𝑓(𝑑(𝑥, 𝑦)) },  where 𝑑(•) 
is distance function and 𝜆 is the threshold. 𝑓(𝑑(𝑥, 𝑦)) can be 
(1 −𝑑(𝑥, 𝑦)/max (𝑑(𝑥, 𝑦))).   
Further, 𝐹𝑁𝑋= {𝐹𝑁(𝑥1), 𝐹𝑁(𝑥2), . . , 𝐹𝑁(𝑥𝑛)},   i.e., the set 
of fuzzy neighborhoods of data samples forms the fuzzy 
neighborhood covering of the data space 𝑋. 
A binary fuzzy relation R between crisp sets 𝑋 and 𝑌 is a 
set 
of 
ordered 
pairs {((𝑥, 𝑦), 𝜇𝑅 (𝑥, 𝑦))| 𝑥 ∈𝑋, 𝑦 ∈
𝑌, 𝑅 ⊆ 𝑋× 𝑌, 𝜇𝑅(𝑥, 𝑦) ∈ [0, 1]}. The membership function 
indicates the intensity of the relation between 𝑥 and 𝑦. 
A fuzzy constraint 𝐶 is a n-ary fuzzy relational mapping 
from product of finite domain of variables to the [0,1] interval 
and is defined as:  
𝐶= {(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉, 𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉)) | 〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉 
∈𝐷1 × 𝐷2 ×⋅⋅× 𝐷𝑛,
𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉) ∈ [0,1]}  (3.5) 
We call the membership function 𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉) the 
degree of satisfaction of the constraint 𝐶. If 𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅
, 𝑥𝑛〉) = 1, then we say that 〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉 fully satisfies 𝐶 (crisp 
constraint). If 𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉) = 0, then we say that 〈𝑥1, 𝑥2,⋅⋅

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
3
, 𝑥𝑛〉 fully violates 𝐶. We define the support set of 𝐶 
as 𝑆𝑢𝑝(𝐶) = {〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉 | 𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉) > 0}. 
For 
elements which satisfy the constraint better than a given 
threshold 𝛼, where   1 ≥𝛼> 0. The 𝛼−𝑠𝑢𝑝𝑝𝑜𝑟𝑡 set is 
defined as follows: 𝑆𝑢𝑝(𝐶)𝛼 (𝑜𝑟 𝑆𝑢𝑝(𝐶)[]) = {〈𝑥1, 𝑥2,⋅⋅
, 𝑥𝑛〉 | 𝜇𝐶(〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉) ≥ 𝛼} . 
B. Fuzzy Logic, Linguistic Variables and Fuzzy System 
Fuzzy logic [4] may be defined as many-valued logic in 
which the truth value of variables may be expressed through 
linguistic terms and may be any real number between 0 and 1. 
It is employed to handle the concept of partial truth, where the 
truth value may range between completely true and completely 
false. Fuzzy logic is an approach to computing based on 
degrees of truth rather than on true or false (1 or 0) as in 
Boolean Logic. Fuzzy logic is based on the observation that 
people make decisions based on imprecise and non-numerical 
information. 
A fuzzy or linguistic variable [4, 9-11, 13, 15] is a variable 
that can accept non-numeric values, i.e., linguistic terms to 
facilitate expression of facts and rules. Because natural 
languages do not always contain enough value terms to express 
a fuzzy value scale [14], it is common practice to modify 
linguistic values with adjectives or adverbs. 
In general, a linguistic variable has values that are words and 
the meanings of these words are fuzzy sets in a certain universe. 
The values of a linguistic variable are called terms. Typical 
examples of this type of variable could be age, height, 
intelligence, etc. Their values could be terms like young, high, 
clever, etc. Each term can be represented by a triangular (or 
trapezoidal) fuzzy number. 
A fuzzy system [18] is a repository of fuzzy expert 
knowledge that can reason data in vague terms instead of precise 
Boolean logic. The expert knowledge is a collection of fuzzy 
membership functions and fuzzy rules, used to infer an output 
based on input variables. Unlike in crisp logic, the antecedent 
and the consequence of a fuzzy rule can be true to a degree, 
instead of being entirely true or entirely false. Fuzzy inference 
can be viewed as decision making with a fuzzy system 
employing fuzzy implications and fuzzy rules of inference. 
Defuzzification converts fuzzy values into crisp quantities, that 
is, it links a single point to a fuzzy set, given that the point 
belongs to the support of the fuzzy set. 
C. Fuzzy Analytic Hierarch Process 
Fuzzy Analytic Hierarchy Process (FAHP) [26, 31] is a 
method that combines Analytic Hierarchy Process (AHP) with 
fuzzy logic theory. FAHP is a multi-criterion technique that 
works similarly as the AHP method, but scales into a triangular 
fuzzy number scale for representing the criteria relevance. 
FAHP can be used to infer fuzzy weights from linguistic terms 
for fuzzy (linguistic) variables using either geometric mean 
method [30] or extent analysis method or entropy-based 
method. These fuzzy weights can be further defuzzified. 
D. Fuzzy Weighted Average 
We have defined the Fuzzy Weighted Average as in [22] by 
applying Zadeh’s extension principle with -cut to the non-
fuzzy weighted average (𝑤𝑎). Let 𝑋1, 𝑋2,⋅⋅, 𝑋𝑛 (variables), 
and 𝑊1, 𝑊2,⋅⋅, 𝑊𝑛 (weights) be the fuzzy numbers, then the 
fuzzy weighted average (𝑓𝑤𝑎 )is an interval defined as:  
𝑓𝑤𝑎(𝑋1, 𝑋2,⋅⋅, 𝑋𝑛, 𝑊, 𝑊2,⋅⋅, 𝑊𝑛)[],1 ≤𝑖≤𝑛 
= {𝑤𝑎(𝑥1, 𝑥2,⋅⋅, 𝑥𝑛, 𝑤1, 𝑤2,⋅⋅, 𝑤𝑛)|𝑥𝑖 ∈ 𝑋𝑖[𝛼], 𝑤𝑖∈ 𝑊𝑖[𝛼]} 
= {∑
𝑥𝑖 
𝑛
𝑖=1
∗𝑤𝑖 | 𝑥𝑖 ∈ 𝑋𝑖[𝛼], 𝑤𝑖∈ 𝑊𝑖[𝛼];  ∑
 𝑤𝑖
𝑛
𝑖=1
= 1}  (3.6)   
 We will consider weights which are triangular fuzzy numbers, 
i.e., 𝑊𝑖= (𝑙𝑖, 𝑚𝑖, 𝑟𝑖). The condition of fwa-normality is 
∑
 𝑚𝑖
𝑛
𝑖=1
= 1, i.e., their modal values add up to unity. When a 
set of fuzzy weights is not fwa-normal, they can be made 
normal by normalizing it. We have used the algorithm in [22] 
to compute the fuzzy weighted average. 
E. Fuzzy C-means Clustering 
Fuzzy c-means clustering (FCM) [27, 32] is a soft 
clustering [28] approach, where each data point is assigned a 
membership score that indicates the degree to which it belongs 
to a cluster. The main advantage of fuzzy c-means clustering is 
that it allows gradual memberships of data points to clusters 
measured as degrees in [0,1]. This gives the flexibility to 
express overlapping membership, i.e., that data points can 
belong to more than one cluster.  
F. Fuzzy Matching 
Fuzzy matching, also called Approximate String Matching, 
is a technique that helps identify two elements of text, strings, 
or entries that are approximately similar but are not exactly the 
same. It is called fuzzy because of the inexact nature of the 
matching involved. The closeness of a match, known as edit 
distance, is measured in terms of the number of primitive 
operations necessary to convert the string into an exact match.  
IV.  FUZZY RECORD LINKAGE 
This section provides a description of a fuzzy linkage technique 
that we are proposing for linking database records. This record 
linkage technique uniquely integrates approximate (fuzzy) 
string/pattern matching, fuzzy logic, search space reduction 
through fuzzy constraints, fuzzy weighted linkage estimation 
using fuzzy (linguistic) weights, fuzzy rule-based inferences and 
fuzzy clustering through a 5-step sequential procedure/method.  
The procedure is highly parameterized. The list of parameters 
to the proposed procedure includes: Constraint Type, Field & 
Value (default: “None/False”), Link Columns, Match Algorithms, 
Logic Type (default: “Fuzzy”), Thresholds (default: 0.9), Linkage 
Type (default: “crisp”), Crisp Weight Vector (default: <1,1,1>), 
Linguistic Terms (default = (“low”, “medium”, “high”), Fuzzy 
Number Scale, FAHP Method (default: “geometric mean”), Fuzzy 
Rule Base, No. of Fuzzy Clusters (default: 3). Parameters will be 
italicized in text. 
The procedure supports “crisp” & “fuzzy” Constraint Types 
“Boolean” & “Fuzzy” Logic Types and “crisp” & “fuzzy” 
Linkage Types for record linkages. “Boolean” Logic Type is 
associated only with “crisp” Linkage Type and Crisp Weight 
Vector (or default weights of 1 for the Link Columns) to establish 
record linkages. “Fuzzy” Logic Type is associated with either 
“crisp” or “fuzzy” Linkage Type and FAHP generated crisp 
(ignoring the Crisp Weight Vector) or fuzzy weights for the Link 
Columns to establish record linkages. FAHP is used to generate 
fuzzy weights from Linguistic Terms describing the relevance of 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
4
the Link Columns, i.e., the columns to be linked in a record pair. 
Fuzzy rules from inputted fuzzy rule base connect match scores 
of the linked columns to the total linkage score for the record pair 
by treating them all as fuzzy variables. “Fuzzy” Logic Type and 
“fuzzy” Linkage Type employ Mamdani type [18] fuzzy 
inference triggering fuzzy rules. The objective of the procedure 
is two-fold. First, to associate a total linkage score to each linked 
record pair indicating the quality of the linkage so that it can be 
ranked individually if needed, and second, to cluster the 
linked record pairs into a pre-specified number of fuzzy clusters 
based on their linkage qualities so that the different clusters can 
be interpreted and treated differently as per user requirements. 
Fig. 1 shows the steps of this procedure.  
 
Fig.1: Proposed Fuzzy Record Linkage Solution 
Next, we take a look at all the key steps of this Fuzzy Record 
Linkage (FRL) procedure and discuss their implementations. 
A. Linkage Model 
This is the first step of the procedure where it sets up the 
linkage query using the inputted parameter values. It consists of 
the following two activities: 
i. 
Define the linkage model with the parameters to the 
procedure, i.e., Link Columns, Match Algorithms, Logic 
Type, Thresholds, Linkage Type, etc. 
ii. 
Construct a linkage query with the linkage model using the 
inputted values to the aforesaid parameters 
The result provides definition and invocation of the linkage 
model. A linkage query can support either “Boolean” or 
“Fuzzy” Logic Types and “crisp” or “fuzzy” Linkage Types. 
B. Search Space 
This step sets up the constrained search space using the input 
data sets and the constraints (if any). The constraint can be crisp 
(exact) or fuzzy. This step consists of the following activities: 
i. 
Merge the input data sets. With 2 data sets, e.g., 𝐴 & 𝐵 of 
sizes: 𝑚 & 𝑛; the search space is 𝐴× 𝐵 and has 𝑚∗𝑛 
(size) record pairs 
ii. 
Constrain the search space{(𝑥, 𝑦) | 𝑥∈𝐴 & 𝑦∈𝐵} using 
blocking with either crisp (𝜇𝐶(〈𝑥, 𝑦〉) = 1) or fuzzy 
constraint, i.e., its 𝛼−𝑠𝑢𝑝𝑝𝑜𝑟𝑡 set with 𝜇𝐶(〈𝑥, 𝑦〉) ≥, 
defined 
through 
either 
crisp 
(exact) 
or 
fuzzy 
neighborhoods (i.e., fuzzy neighborhood covering), 
whose memberships (𝜇𝐹𝑁(𝑥)(𝑦)) can be determined 
using either the edit distances or physical distances (in 
case of locations) 
The result is a merged data set for a constrained search 
space consisting of paired records. 
C. Record Pair Linkage 
Our focus here is on linking record pairs through the match 
scores on the linked columns, whose original values are strings. 
So, this step links each record pair in the constrained search 
space by applying the selected fuzzy (approximate) string 
Matching Algorithm on the Link Columns (columns to be 
linked) to generate the corresponding match scores in [0, 1] and 
then transforming them if needed depending on the chosen 
Logic Type. It consists of the following two activities: 
i. 
Execute 
the 
linkage 
query 
by 
applying 
fuzzy 
(approximate) string matching on the Link Columns to 
generate the respective match scores 
ii. 
If Logic Type is “Boolean” then 
a. 
For every Link Column in a record pair, set match 
score to 1, if match score ≥ match Threshold; 
otherwise set it to 0 
b. Ensure that Linkage Type is set to “crisp” 
The result is the constrained data set from step A, with each 
linked record pair now additionally including either replaced 
(1 or 0) or raw match scores in [0, 1] for each Link Column. 
D. Linkage Score Estimation 
Linkage score estimation is the most important step of this 
procedure. Total linkage score (TS) reflects the quality, i.e., 
strength of record linkage. This step computes the total linkage 
score for each linked record pair from the match scores and the 
weights associated with the Link Columns, based on the Logic 
and Linkage Types. If “Boolean” Logic Type is chosen then 
Linkage type can only be “crisp”, and normalized Crisp Weight 
Vector (or default weight of 1 for each Link Column) is used to 
compute the total linkage score of each record pair. FAHP is 
used only with "Fuzzy” Logic Type for record linkages. It is used 
to estimate fuzzy weights (triangular fuzzy numbers) from the 
specified Linguistic Terms, reflecting the relative importance of 
the columns to be linked, and the inputted Number Scale (both 
parameters to the procedure). This relative importance of the Link 
Columns can come from either the customers (users) or the owner 
of the data sources based on their experience and understanding 
of the data usage. Furthermore, if the chosen Linkage Type is 
“crisp” then the fuzzy weights for the Link Columns are 
defuzzified and normalized (ignoring the Crisp weight Vector) for 
computing the weighted average of the match scores reflecting 
the total linkage score for the record pair. For example, if two data 
sets are to be linked on three columns: Name, Address, and City 
and their deemed relevancies are “low”, “medium” and “high”, 
then FAHP with a 3-point number scale can yield their fuzzy 
weights as (0.1, 0.16, 0.33), (0.15, 0.3, 0.6), (0.28, 0.54, 0.96), 
which can be further defuzzified, if needed, into 0.17, 0.31, and 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
5
0.52 to serve as their normalized crisp weights. However, if the 
Linkage Type is “fuzzy” then fuzzy weights (from FAHP) and 
match score intervals (represented as triangular fuzzy numbers) 
of the Link Columns are used to estimate the fuzzy weighted 
average to represent the interval of the total linkage score of the 
linked record pair, also as a triangular fuzzy number. The match 
scores of the Link Columns and the total linkage score of the 
linked record pair become fuzzy variables whose values can be 
Linguistic Terms, which are fuzzy sets represented by triangular 
fuzzy numbers based on the intervals and distributions of their 
original values. Fuzzy rules are used to connect the fuzzy 
variables, i.e., fuzzy match scores of the Link Columns in the 
antecedent to the fuzzy weighted average (reflecting the total 
linkage score) in the consequence. A Mamdani type [18] fuzzy 
controller applying fuzzy inference on these fuzzy rules can then 
infer a defuzzified crisp total linkage score for each linked record 
pair from the raw match scores (of the Link Columns). In this 
context, we establish a formal framework for the two types of 
record linkages supported by the proposed procedure. 
Definition 4.1: A crisp linkage is a record linkage whose 
quality is estimated as a weighted average (𝑤𝑎) of match scores 
of the linked columns, where the match scores and weights are 
both crisp numbers.  
Definition 4.2: A fuzzy linkage is a record linkage whose 
quality is estimated as a fuzzy weighted average (𝑓𝑤𝑎) of match 
scores of the linked columns, where the match scores and weights 
are both fuzzy numbers. 
Let 𝑆= 〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉 and 𝑊= 〈𝑤1, 𝑤2,⋅⋅, 𝑤𝑛〉 be the match 
scores ([0, 1]) and normalized crisp weights of the Link 
Columns 〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉. 
Proposition 4.1: Crisp linkage is a mapping from 𝑋 (〈𝑥1, 𝑥2,⋅
⋅, 𝑥𝑛〉) 𝑡𝑜 ℝ that results in a crisp relation defined as:  
𝐶𝐿= {(〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉, 𝑇𝑆) | 𝑇𝑆 𝜀 ℝ 𝑎𝑛𝑑 𝑇𝑆= 𝑤𝑎(𝑠1, 𝑠2,⋅⋅
, 𝑠𝑛, 𝑤1, 𝑤2,⋅⋅, 𝑤𝑛) = 𝑆• 𝑊}.  
Let 〈𝐹𝑆1, 𝐹𝑆2,⋅⋅, 𝐹𝑆𝑛〉 and 〈𝐹𝑊1, 𝐹𝑊2,⋅⋅, 𝐹𝑊𝑛〉 be the fuzzy 
match scores & fuzzy weights of the Link Columns 〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉. 
Proposition 4.2: Fuzzy linkage is a mapping from 𝑋 (〈𝑥1, 𝑥2,⋅
⋅, 𝑥𝑛〉) ⨯ℝ 𝑡𝑜 [0,1] that results in a fuzzy relation defined as:  
𝐹𝐿= {((〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉, 𝑇𝑆), 𝜇𝐹𝐿(〈𝑠1, 𝑠2,⋅⋅
, 𝑠𝑛〉, 𝑇𝑆)) |  𝜇𝐹𝐿(〈𝑠1, 𝑠,⋅⋅, 𝑠𝑛〉, 𝑇𝑆) ∈ [0, 1], 𝜇𝐹𝐿(〈𝑠1, 𝑠2,⋅⋅
, 𝑠𝑛〉, 𝑇𝑆) = 𝜇𝐹𝐿(𝑇𝑆);  𝑇𝑆= 𝑓𝑤𝑎(𝐹𝑆1, 𝐹𝑆2,⋅⋅, 𝐹𝑆𝑛, 𝐹𝑊1, 𝐹𝑊2,⋅
⋅, 𝐹𝑊𝑛)[],  ∈ [0, 1]}. 
Let 𝑆𝐶𝐿& 𝑆𝐹𝐿 represent the intervals of total linkage scores 
(𝑇𝑆) from crisp and fuzzy linkages, and let ⊂ denotes sub-
interval, then the following can be remarked about the intervals 
in our context. 
Remark 4.1: 𝑆𝐶𝐿⊆[0, 1] 
 Proof: The total linkage score for crisp linkage is estimated as 
the weighted average of match scores (𝑠𝑖) and normalized crisp 
weights (𝑤𝑖) of the Link Columns, i.e., ∑
𝑠𝑖
𝑛
𝑖=1
∗𝑤𝑖. Since 0 ≤
 𝑠𝑖 ≤ 1, and ∑
𝑤𝑖
𝑛
𝑖=1
= 1, we have 0 ≤ ∑
𝑠𝑖
𝑛
𝑖=1
∗𝑤𝑖 ≤ 1. This 
implies that 𝑆𝐶𝐿⊆[0 1].  
 Remark 4.2: 𝑆𝐹𝐿 ⊆[0, 1] 
Proof: The total linkage score for fuzzy linkage is estimated as 
the fuzzy weighted average (𝑓𝑤𝑎) of fuzzy match scores (𝐹𝑆𝑖) 
and fuzzy weights (𝐹𝑊𝑖) of the Link Columns. The -cuts of 
𝐹𝑆𝑖 &  𝐹𝑊𝑖 are intervals and let them be denoted by 
[𝐹𝑆𝑖− ,𝐹𝑆𝑖𝛼+] & [𝐹𝑊𝑖− ,𝐹𝑊𝑖𝛼+]. From Eqn. (3.6), for 0 ≤≤1,  
𝑓𝑤𝑎(𝐹𝑆1, 𝐹𝑆2,⋅⋅, 𝐹𝑆𝑛, 𝐹𝑊1, 𝐹𝑊2,⋅⋅, 𝐹𝑊𝑛)[]  =  { ∑
𝑓𝑠𝑖
𝑛
𝑖=1
∗
𝑓𝑤𝑖 | 𝑓𝑠𝑖∈[𝐹𝑆𝑖− ,𝐹𝑆𝑖𝛼+], 𝑓𝑤𝑖∈ [𝐹𝑊𝑖− ,𝐹𝑊𝑖𝛼+]; ∑
𝑓𝑤𝑖
𝑛
𝑖=1
=
 1 } is also an interval. Now, it has been shown in [22] that this 
interval for 𝑓𝑤𝑎 can be given by [∑
𝐹𝑆𝑖−
𝑛
𝑖=1
∗ 𝐹𝑊𝑖−
′ ,
∑
𝐹𝑆𝑖+
𝑛
𝑖=1
∗ 𝐹𝑊𝑖𝑎+
′
] where 𝑖, 𝐹𝑊𝑖−≤𝐹𝑊𝑖𝑎−
′
≤𝐹𝑊𝑖+ ,
𝐹𝑊𝑖−≤𝐹𝑊𝑖𝑎+
′
≤𝐹𝑊𝑖+ & 𝐹𝑊𝑖𝑎−
′
≤𝐹𝑊𝑖𝑎+
′
. Now, 
𝐹𝑆𝑖− & 𝐹𝑆𝑖+ are elements of -cuts of fuzzy set 𝐹𝑆𝑖, defined 
over the interval [0, 1] of 𝑠𝑖. So, 𝑖, 0 ≤𝐹𝑆𝑖−≤ 1 and 0 ≤
𝐹𝑆𝑖+ ≤ 1. Also, by definition of 𝑓𝑤𝑎, we have ∑
𝐹𝑊𝑖−
′
𝑛
𝑖=1
=
 1 and ∑
𝐹𝑊𝑖𝑎+
′
𝑛
𝑖=1
= 1.  This 
yields 
0 ≤ ∑
𝐹𝑆𝑖−
𝑛
𝑖=1
∗
 𝐹𝑊𝑖−
′
≤ 1 and 0 ≤ ∑
𝐹𝑆𝑖+
𝑛
𝑖=1
∗ 𝐹𝑊𝑖𝑎+
′
≤ 1. So, the interval 
of 𝑓𝑤𝑎 is bounded by 0 and 1, which are its endpoints, i.e., 
[∑
𝐹𝑆𝑖−
𝑛
𝑖=1
∗𝐹𝑊𝑖𝛼−

 , ∑
𝐹𝑆𝑖+
𝑛
𝑖=1
∗𝐹𝑊𝑖+

] ⊆[0, 1]. 
This 
implies 𝑆𝐹𝐿 ⊆[0, 1]. 
From Remarks 4.1 & 4.2, we can conclude that 𝑆𝐶𝐿= 𝑆𝐹𝐿. 
Finally, this step consists of the following activities: 
i. 
If Logic Type is “Fuzzy”, use FAHP to infer fuzzy weights 
(triangular fuzzy numbers) associated with the Linguistic 
Terms (for the column-relevance) using the Fuzzy Number 
Scale and the specified FAHP Method 
ii. 
If Linkage Type is “crisp” then 
a. If Logic Type is “Boolean”, then either use the 
normalized Crisp Weight Vector (or default weights of 1 
for Link Columns); else if Logic Type is “Fuzzy”, then 
defuzzify the fuzzy weights (step i) to generate 
normalized crisp weight for each Linguistic Term 
describing each linked column’s relevance/importance 
b. Calculate total linkage score for each linked record pair 
as 𝑇𝑆= 𝑆• 𝑊, along with the weighted score (𝑠𝑖∗
𝑤𝑖) of each Link Column i, where 𝑆 = < 𝑠1, 𝑠2,⋅⋅, 𝑠𝑛> 
be score vector and 𝑊= <𝑤1, 𝑤2,… , 𝑤𝑛>  be the 
normalized crisp weight vector for the Link Columns  
iii. 
If Linkage Type is “fuzzy” then 
a. Extract the -cuts from the triangular fuzzy numbers 
representing score intervals (with modes) and the 
fuzzy weights of the Link Columns using Eqn. (3.4) 
b. Compute total linkage score (𝑇𝑆) as a fuzzy weighted 
average of the -cuts of the fuzzy scores and weights 
using Eqn. (3.6) and represent it as a triangular fuzzy 
number (interval) [e.g., fuzzy match scores of [(0, 
0.25, 1), (0.23, 0.55, 1), (0, 0, 1)] and fuzzy weights 
of [(0.1, 0.16, 0.33), (0.15, 0.3, 0.6), (0.28, 0.54, 
0.96)] for the 3 Link Columns: Name, Address, and 
City of a record pair produce a fuzzy weighted average 
of (0.04, 0.21, 1) using Eqn. (3.6)] 
c. Define fuzzy sets for the Linguistic Terms using sub-
intervals from the intervals and distributions of the 
match scores of the Link Columns, as well as the 
computed interval for 𝑇𝑆 (from iii. b) [e.g., Fig. 2 
shows 3 fuzzy sets for 3 Linguistic Terms: “low”, 
“medium” and “high” covering the full intervals of 
match scores of the 3 Link Columns: Name, Address, 
City, and TS (Score) of the linked record pairs] 
d. Define a Mamdani type [18] fuzzy controller [33] using 
the fuzzy sets for the match scores & TS and the fuzzy 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
6
rules (inputted fuzzy rule-base) connecting the linked 
column scores to the total linkage score [e.g., a fuzzy 
rule based on Fig. 2, using the 3 Link Columns may 
have the form:  
rule1 ← Rule(Name['high'] & Address['high'] & 
City['low'], Score['medium']), where Name, Address, 
& City are fuzzy variables, taking values from 
Linguistic Terms: “low”, “medium” & “high”. Fig. 3a 
shows the structure of a fuzzy rule, where the nodes 
represent antecedents, consequent, and terms] 
e. Simulate the controller and employ fuzzy inference to 
estimate defuzzified total linkage score for each linked 
record pair from the match scores of Link Columns 
[Fig. 3b shows the defuzzified total linkage score, i.e., 
TS (Score) for a record pair] 
The result is the data set from the previous step, with each 
linked record pair additionally including weighted match 
scores for the Link Columns (crisp linkage) and the estimated 
total linkage score (TS). 
 
Fig. 2: Fuzzy Sets for Linguistic Terms describing the match scores 
of Link Columns (fuzzy variables: City, Address, Name, & Score) 
 
Fig. 3: A Fuzzy Rule from Fuzzy Rule-base and an estimated 
Defuzzified Total Linkage Score (TS) for a record pair 
E. Fuzzy Clustering 
This is the last step of the main procedure and consists of 
the following two activities: 
i. 
Use fuzzy c-means clustering on the total linkage scores 
from the previous step and generate specified number 
(No. of Fuzzy Clusters) of overlapping clusters 
ii. 
For each linked record pair, identify the cluster with the 
highest membership value as the best match 
The result is the data set from the previous step with each 
linked record pair now including the best linguistic cluster to 
which it belongs. Algorithm 1 formalizes this entire procedure. 
Algorithm 1 
Algorithm for Fuzzy Record Linkages 
Inputs: : Input Sets (A, B), Constraint (C, 𝜆), Link Columns 
(linkColumns), Match Algorithm (MA), Logic Type (logicType), 
threshold (th), Linkage Type (linkageType), Linguistic Terms 
(terms: {“low”, “medium”, “high”}, Crisp Weight Vector (CW), 
Fuzzy Number Scale (ns), FAHP-method (FAHP), FWA- (), 
Fuzzy Rule Base (FRB), No. of Fuzzy Clusters (k) 
Output: Linked record pairs with designated fuzzy cluster 
FRL(𝐶, 𝑙𝑖𝑛𝑘𝐶𝑜𝑙𝑢𝑚𝑛𝑠, 𝑀𝐴, 𝑙𝑜𝑔𝑖𝑐𝑇𝑦𝑝𝑒, 𝑙𝑖𝑛𝑘𝑎𝑔𝑒𝑇𝑦𝑝𝑒, 𝜆, 𝑡ℎ, 
, 𝑡𝑒𝑟𝑚𝑠, 𝑛𝑠, 𝐹𝐴𝐻𝑃, 𝐹𝑅𝐵, 𝑘) 
𝑛 ← ∣𝑙𝑖𝑛𝑘𝐶𝑜𝑙𝑢𝑚𝑛𝑠∣ 
𝑥 ←  〈𝑥1, 𝑥2,⋅⋅, 𝑥𝑛〉, where 𝑥𝑖 𝜀 𝑙𝑖𝑛𝑘𝐶𝑐𝑜𝑙𝑢𝑚𝑛𝑠 
𝑦 ←  〈𝑦1, 𝑦2,⋅⋅, 𝑦𝑛〉, where 𝑦𝑖 𝜀 𝑙𝑖𝑛𝑘𝐶𝑐𝑜𝑙𝑢𝑚𝑛𝑠 
𝑋𝑌 ←{(𝑥, 𝑦) | 𝜇𝐶(𝑥, 𝑦) ≥ 𝜆, (𝑥, 𝑦) ∈𝐴× 𝐵, 𝑦∈𝐹𝑁(𝑥),
𝜇𝐶(𝑥, 𝑦) ∈ [0,1], 𝜇𝐹𝑁(𝑥)(𝑦) ∈ [0, 1],
𝜇𝐶(𝑥, 𝑦) ← 𝜇𝐹𝑁(𝑥)(𝑦), 𝜇𝐹𝑁(𝑥)(𝑦)
←(1 − 𝑑(𝑥, 𝑦)/𝑑𝑚𝑎𝑥) , 𝑑𝑚𝑎𝑥
←max (𝑑(𝑥, 𝑦)} 
𝑚 ← ∣𝑋𝑌∣ 
𝑆 ←{〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉𝑗| 〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉←𝑀𝐴(𝑥, 𝑦), 𝑠𝑖 ∈ [0,1],
1 ≤𝑖 ≤𝑛, 1 ≤𝑗 ≤𝑚} 
𝐢𝐟 𝑙𝑜𝑔𝑖𝑐𝑇𝑦𝑝𝑒 == "Boolean" 𝐭𝐡𝐞𝐧 
      𝑆 ←{〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉𝑗 |  𝑠𝑖 ←(0, 𝑖𝑓 𝑠𝑖≤th; 1, 𝑖𝑓 𝑠𝑖> 𝑡ℎ),  
1 ≤𝑖 ≤𝑛, 1 ≤𝑗 ≤𝑚} 
      𝐢𝐟 𝑙𝑖𝑛𝑘𝑎𝑔𝑒𝑇𝑦𝑝𝑒 ≠"crisp" 𝐭𝐡𝐞𝐧  
              𝑙𝑖𝑛𝑘𝑎𝑔𝑒𝑇𝑦𝑝𝑒 ←  "crisp" 
      if CW then 
            𝑇𝑆 ← {𝑇𝑆1, 𝑇𝑆2,⋅⋅, 𝑇𝑆𝑚 | 𝑇𝑆𝑗←𝑆𝑗• 𝐶𝑊′ ,  𝑆𝑗 ←
                                〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉𝑗; 𝐶𝑊′ ←〈𝑤1
′, 𝑤2
′,⋅⋅, 𝑤𝑛
′〉,   𝑤𝑖
′ ←
                                𝑤𝑖∑
𝑤𝑖,
𝑛
𝑖=1
⁄
 𝐶𝑊 ←〈𝑤, 𝑤2,⋅⋅, 𝑤𝑛〉; 1 ≤𝑖≤𝑛} 
      else 
              𝑇𝑆 ← {𝑇𝑆1, 𝑇𝑆2,⋅⋅, 𝑇𝑆𝑚 | 𝑇𝑆𝑗 ← 𝑆𝑗• 𝑊,    𝑆𝑗 
← 〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉𝑗, 𝑊← 〈1/𝑛, 1/𝑛,⋅⋅, 1/𝑛〉} 
else (𝑙𝑜𝑔𝑖𝑐𝑇𝑦𝑝𝑒 == "Fuzzy") 
   𝑤𝑖 ←(𝑎, 𝑏, 𝑐) ←𝐹𝐴𝐻𝑃(𝑡𝑒𝑟𝑚𝑠, 𝑛𝑠),   𝑎 ≤ 𝑏≤𝑐, 1 ≤𝑖 ≤𝑛 
 
  if 𝑙𝑖𝑛𝑘𝑎𝑔𝑒𝑇𝑦𝑝𝑒== "crisp" 𝐭𝐡𝐞𝐧 
 
 
 
 
W ← 〈𝑑𝑤1, 𝑑𝑤2,⋅⋅, 𝑑𝑤𝑛〉 ← defuzzify(𝑤𝑖), 1 ≤𝑖 ≤𝑛 
       𝑇𝑆 ← {𝑇𝑆1, 𝑇𝑆2,⋅⋅, 𝑇𝑆𝑚 | 𝑇𝑆𝑗 ← 𝑆𝑗• 𝑊,
  𝑆𝑗 ← 〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉𝑗}    
       else (𝑙𝑖𝑛𝑘𝑎𝑔𝑒𝑇𝑦𝑝𝑒 == "fuzzy") 
          𝑠𝑖′ ←(𝑝𝑖, 𝑞𝑖, 𝑟𝑖),
𝑝𝑖 ≤ 𝑞𝑖≤𝑟𝑖, 𝑝𝑖 ←𝑚𝑖𝑛(𝑠𝑖) ,
𝑞𝑖 ←𝑚𝑜𝑑𝑒(𝑠𝑖) , 𝑟𝑖←𝑚𝑎𝑥(𝑠𝑖) ,
1 ≤𝑖 ≤𝑛,   
         𝑇𝑆←(𝑢, 𝑣, 𝑧) ←𝑓𝑤𝑎(𝑠1′, 𝑠2′,⋅⋅, 𝑠𝑛′, 𝑤1, 𝑤2,⋅⋅, 𝑤𝑛)[], 
𝑢 ≤ 𝑣≤ 𝑧 
               for 𝑖= 1 𝑡𝑜 𝑛 𝐝𝐨 
                       𝑥𝑖 ["low"]" ← (𝑑𝑖, 𝑑𝑖, 𝑒𝑖), 𝑑𝑖< 𝑒𝑖, 𝑝𝑖 ≤ 𝑑𝑖         
                       𝑥𝑖 ["medium"] ←(𝑒𝑖, 𝑓𝑖, 𝑔𝑖),
𝑒𝑖 < 𝑓𝑖< 𝑔𝑖 
                     𝑥𝑖 ["high"] ← (𝑔𝑖, ℎ𝑖, ℎ𝑖), 𝑔𝑖 < ℎ𝑖, ℎ𝑖 ≤ 𝑟𝑖   
 
               TS["low"] ← (𝑙, 𝑙, 𝑚1), 𝑙< 𝑚1, 𝑢 ≤𝑙 
                 𝑇𝑆["medium"] ←(𝑚1, 𝑚2, 𝑚3), 𝑚1 < 𝑚2 < 𝑚3 
               TS["high"] ← (𝑚3, 𝑜, 𝑜), 𝑚3 < 𝑜, 𝑜 ≤𝑧 
 
                𝑟𝑖←𝑇𝑆[𝑡] ←𝑥1[𝑡] & 𝑥2[𝑡] & ⋅⋅& 𝑥𝑛[𝑡], 𝑡 ∈ 𝑡𝑒𝑟𝑚𝑠 
       
  FRB ← {𝑟1, 𝑟2,⋅⋅, 𝑟3𝑛 | 3𝑛∶number of rules}  
 
 
 
  controller ← fuzzyController(FRB) 
               linkage ← simulation(controller) 
    𝑇𝑆 ← {𝑇𝑆1, 𝑇𝑆2,⋅⋅, 𝑇𝑆𝑚 | 𝑇𝑆𝑗
← 𝑓𝑢𝑧𝑧𝑦𝐼𝑛𝑓𝑒𝑟(𝑙𝑖𝑛𝑘𝑎𝑔𝑒(𝑆𝑗)),
 𝑆𝑗 ← 〈𝑠1, 𝑠2,⋅⋅, 𝑠𝑛〉𝑗, 1 ≤𝑗 ≤𝑚} 
𝑚 ←𝐹𝐶𝑀(𝑇𝑆, 𝑘), where k is the number of clusters 
𝑐𝑚 ←𝑎𝑟𝑔𝑚𝑎𝑥(𝑚, 𝑎𝑥𝑖𝑠= 0) 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
7
V. PERFORMANCE EVALUATION 
We have evaluated the performance of the proposed fuzzy 
record linkage method on benchmark US hospital data sets and 
compared its performance with those of deterministic and 
probabilistic linkage methods on the same data sets using both 
crisp and fuzzy constraints as well as Boolean and Fuzzy logic. 
A. Experimental Setup 
We implemented the fuzzy record linkage method in a python 
based Jupyter Notebook, using packages like pandas, numpy, 
swifter, recordlinkage and scikit-fuzzy (skfuzzy). For the fuzzy 
controller and the clustering algorithm, we used the control and 
the cluster.cmeans modules from skfuzzy. We tested the proposed 
method on two publicly-available benchmark data sets of US 
medical facilities [34], one consisting of 5339 records and the 
other consisting of 2697 records. The first was an internal data 
set that contained basic hospital account number, name and 
ownership information. The second data set contained hospital 
information (called provider) as well as the number of discharges 
and Medicare payments for specific Heart Failure procedures. 
The constrained search space, comprising of either “exact same 
state” (crisp constraint) based record pairs from the two data sets 
or the fuzzy neighborhoods (using edit distances) of the “same 
state” (fuzzy constraint) based record pairs, included 475,830 and 
998,860 record pairs respectively. The records from the two data 
sets were exactly matched on City and approximately matched 
(fuzzy string matching) on 2 other fields, namely, Hospital Name 
and Hospital Address using Levenshtein and Jaro-winkler edit 
distances. We used both Boolean and Fuzzy logic as well as crisp 
and fuzzy linkages. We considered relevance criteria of “low”, 
“medium” and “high” for Hospital Name, Hospital Address and 
City respectively, for estimating their fuzzy weights. Accordingly 
for fuzzy linkages, we defined 3 fuzzy sets for each of the 3 Link 
Columns based on the distribution of their match scores, as 
shown in Fig. 2. We included a fuzzy rule-base associating the 
three Link Columns (fuzzy variables) with a fuzzy score variable 
and employed a Mamdani type fuzzy controller [18, 33] to infer 
total linkage score (TS) for each record pair (Fig. 3b). We applied 
fuzzy c-means clustering algorithm on the estimated total linkage 
scores of the linked record pairs and generated 3 overlapping 
clusters: namely, Matches, Possible Matches and Non-matches. 
We compared our model performance with those from open-
source, off-the-shelf packages like recordlinkage (exact 
deterministic) [35] and splink (probabilistic) [36] only on the 
crisply constrained search space, as these packages did not 
support fuzzy constraints. For non-package-specific strategy 
comparisons, we used the fuzzily constrained search space. 
B. Evaluation Metrics 
We evaluated our method for its effectiveness. For evaluation 
of the effectiveness of our method, we have considered the 
number of Matches and Possible Matches amongst the linked 
record pairs in the constrained search spaces. We have 
compared our method with deterministic and probabilistic 
linkages on only the number of Matches. Note that 
deterministic linkage results in discrete all-or-nothing outcome. 
Therefore, there are only Matches or Non-matches but no 
Possible Matches. For probabilistic linkage, we have 
considered 0.5 (model standard) as cut-off probability threshold 
and a probability ≥ 0.5 as a Match. For us, Non-matches were 
those record pairs that neither matched nor possibly matched, 
i.e. , (𝑇𝑜𝑡𝑎𝑙 𝑛𝑢𝑚𝑏𝑒𝑟 𝑜𝑓 𝑙𝑖𝑛𝑘𝑒𝑑 𝑟𝑒𝑐𝑜𝑟𝑑 𝑝𝑎𝑖𝑟𝑠 – (𝑀𝑎𝑡𝑐ℎ𝑒𝑠 +
 𝑃𝑜𝑠𝑠𝑖𝑏𝑙𝑒 𝑀𝑎𝑡𝑐ℎ𝑒𝑠)). They are not shown in Figs. 4 and 5 as 
their numbers were much larger compared to the other two 
clusters and were not the focus of our interest. 
C. Discussion on Results and Model Comparisons 
Fig. 4 compares the performance of the proposed method 
with those of recordlinkage (for exact deterministic) and splink 
(for probabilistic) packages on the crisply constrained search 
space consisting of 475,830 linked record pairs. For the 
proposed solution, we used: i) Boolean logic to evaluate the 
results of approximate string matching on the Link Columns, to 
be consistent with the results from the other packages (any 
match score ≥ 0.9 was a Match and resulted in a score of 1), and 
ii) crisp linkage with both user provided weights as well as the 
default weight of 1 for each Link Column to compute the total 
linkage score (TS) for each record pair. For user provided 
weights, we used the normalized defuzzified weight vector of 
<0.17, 0.31, 0.52> from the Linguistic Terms of “low”, 
“medium” and “high” for Hospital Name, Hospital Address and 
City. Fig. 4 shows that the proposed solution with user provided 
and default weights found 2669 and 2701 Matches, which were 
in between 2207 and 2740, the number of Matches found by 
recordlinkage and splink. It also displays that the proposed 
solution found 6862 and 6882 Possible Matches in the two 
cases. 
 
Fig. 4: Comparison with Existing Packages (Crisp Constraint) 
Fig. 5 compares the performances of the proposed method 
with those of deterministic and probabilistic linkages on the 
fuzzily constrained search space consisting of 998,860 linked 
record pairs. We implemented deterministic linkages by using 
exact string matching (on all Link Columns), “Boolean” Logic 
Type, “crisp” Linkage Type with the default weight of 1 for each 
linked column and estimated the total linkage score (TS) for 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
8
each record pair as the average of the match scores of the Link 
Columns.  For probabilistic linkages, we calculated the m- and 
u-probabilities from a small sample of the constrained search 
space and then computed a probabilistic weight vector for the 
Link Columns using these probabilities. Subsequently, we 
estimated the total linkage score (TS) for each record pair as the 
dot product of the probabilistic weight vector and the raw 
match scores from the string matches for that pair. For proposed 
crisp linkages (using “Fuzzy” Logic Type and “crisp” Linkage 
Type), we estimated the total linkage score (TS) of each record 
pair using steps ii. a. & ii. b. of the Linkage Score Estimation 
algorithm (Section IV D); while for proposed fuzzy linkages 
(using “Fuzzy” Logic Type and “fuzzy” Linkage Type), we 
estimated the same using steps iii. a. – iii. e. of the same 
algorithm. Fig. 5 shows that the proposed solution found 9367 
& 2459 Matches, which were in between 2207 and 99841, the 
number of Matches found by deterministic and probabilistic 
linkages respectively. Besides, it also displays that the proposed 
solution found 392792 & 8460 Possible Matches in the two 
cases. 
 
Fig. 5: Comparison with Existing Strategies (Fuzzy Constraint) 
Fig. 6 shows the results of proposed fuzzy linkages of two 
record 
pairs 
from 
Hospital 
Accounts 
and 
Hospital 
Reimbursements (i.e., the two tables used in this experiment) 
around the boundary between the two clusters, i.e., Matches and 
Possible Matches, based on the Link Columns, Hospital Name, 
Hospital Address and City in the order of importance: “low”, 
“medium” and “high”. The record pair at the top represents a 
member assigned to the cluster of Matches with the lowest 
estimated total linkage score (TS), while the pair at the bottom 
represents a member assigned to the cluster of Possible Matches 
with the highest estimated total linkage score (TS). Note that 
the record pair at the top matches fully on City, Hospital 
Address and partially on Hospital Name. The record pair at the 
bottom also has full matches on City and Hospital Address and 
only a partial match on Hospital Name. However, the record 
pair at the top matches on more words than the pair at the 
bottom (3 against 1, with the name on the right being fully 
included in the name on the left in the top pair) on the Hospital 
Name, which has the lowest importance. Hence, the two record 
pairs have eventually ended up in two different clusters at their 
boundary. 
 
Fig. 6: Match and Possible Match of record pairs between Hospital 
Accounts & Hospital Reimbursements 
VI. CONCLUSION 
In this paper, we have presented a fuzzy record linkage 
technique to address some of the challenges associated with 
deterministic and probabilistic record linkages, with regards to 
their low true positives or high false positives (false negatives), 
under uncertainty with imprecise information. We have 
combined fuzzy string matching, fuzzy set theory, fuzzy logic, 
fuzzy constraints, fuzzy weights, fuzzy rules and inferences with 
fuzzy clustering to generate clusters of Matches and Possible 
Matches of linked record pairs, to provide a solution that has 
several advantages over the existing ones. Firstly, it provides a 
highly parameterized, flexible solution with a wide range of 
choices. Secondly, it combines multiple strategies to benefit 
from their complementary advantages. Thirdly, it produces a 
more balanced, controllable and an objective solution to the 
desired level of granularity. The number of Matches can be 
expected or controlled to be between those of deterministic and 
probabilistic linkages to overcome shortcomings associated 
with either low true positives or high false positives. Lastly, it 
can serve multiple purposes with results of both Matches and 
Possible Matches, thereby better accommodating user interests. 
For example, a service provider using door-to-door marketing 
campaigns can target customers linked as Matches, whereas the 
same provider can target the Possible Matches for web or email 
based bulk promotions. It may be noted here that probabilistic 
linkage can also generate non-overlapping intervals of Matches 
and Possible Matches, using multiple (2) crisp cut-off 
probability thresholds. However, such classification would then 
become very subjective in nature, based purely on user’s choice 
of the thresholds. Finally, we have established the effectiveness 

---

 
Copyright © 2020 Verizon.  All Rights Reserved. 
Information contained herein is provided AS IS and subject to change without notice.  All trademarks used herein are property of their 
respective owners. 
9
of the proposed record linkage solution through extensive 
evaluations and performance comparisons. 
Currently efforts are underway to link and unify Verizon 
customers and prospects, associated with multiple disparate 
data sources, with global identification using the proposed 
technique.  
CONFLICT OF INTEREST STATEMENT 
The author states that he is an employee of Verizon and this 
paper addresses work performed in course of the author’s 
employment. There is also a Verizon filed US Patent 
application, currently pending on this invention. 
REFERENCES 
[1] T. N. Herzog, F. J Scheuren and W. E. Winkler, “Data quality and record 
linkage techniques,” Springer, vol. 1, 2007. 
[2] I. P. Fellegi, and A. B. Sunter, “A theory for record linkage.” Journal of 
the American Statistical Association 64(328):1183–1210, 1969. 
[3] P. Christen, “Data matching: concepts and techniques for record linkage, 
entity resolution, and duplicate detection,” Springer Science & Business 
Media, 2012. 
[4] L. A. Zadeh, Fuzzy sets. Information and Control 8(3): 338–353, 1965. 
[5] D. Dubois, H. Prade, Fuzzy Sets and Systems: Theory and Applications. 
New York: Academic Press. 1980. 
[6] V. Novak, Základy fuzzy modelování. Praha:BEN, 2000. 
[7] M. Y. Ali, A. Sultana, A.F.M.K. Khan, “Comparison of Fuzzy 
Multiplication Operation on Triangular Fuzzy Number,” IOSR Journal of 
Mathematics, vol. 12, issue 4, pp. 35-41. 
[8] X. D. Yue, Y. F. Chen, D. Q. Miao, H. Fujita, “Fuzzy neighborhood 
covering for three-way classification,” Information Sciences, vol. 507, pp. 
795-808, 2020. 
[9] L. A. Zadeh,  “The concept of a linguistic variable and its application to 
approximate reasoning – I,” Information Sciences 8(3): 199–249, 1975a. 
[10] L. A. Zadeh,  “The concept of a linguistic variable and its application to 
approximate reasoning – II,” Information Sciences 8(4): 301–357, 1975b. 
[11] L. A. Zadeh,  The concept of a linguistic variable and its application to 
approximate reasoning – III. Information Sciences 9(1): 43–80, 1975c. 
[12] H. J. Zimmermann, Fuzzy Set Theory and its Applications. Boston: 
Kluwer academic Publishers, 1991. 
[13] A. Borovička, “Fuzzy weights estimation method based on the linguistic 
expression of criteria relevance”, Central European Review of Economic 
Issues, 17, 2014. 
[14] S. J. Chen, C. L. Hwang, “Fuzzy Multiple Attribute Decision Making: 
Methods and Applications,” Berlin: Springer-Verlag, 1992. 
[15] M. Wang and L. Wang, "Fuzzy weight's calculation method," 2010 6th 
International Conference on Advanced Information Management and 
Service (IMS), 2010, pp. 172-175. 
[16] R .E. Bellman, L. A. Zadeh, “Decision making in a fuzzy environment,” 
Management Science, 17(4): 141–164, 1970. 
[17] Z. Ruttkay, "Fuzzy constraint satisfaction," Proceedings of 1994 IEEE 
3rd International Fuzzy Systems Conference, pp. 1263-1268 vol.2, 1994. 
[18] E. H. Mamdani, "Application of fuzzy algorithms for control of simple 
dynamic 
plant,” Proceedings 
of 
the 
Institution 
of 
Electrical 
Engineers. 121 (12): 1585–1588, 1974. 
[19] W. M. Dong and F. S. Wong, “Fuzzy weighted averages and 
implementation of the extension principle,” Fuzzy Sets Syst., vol. 21, pp. 
183–199, 1987. 
[20] T. S. Liou and M.-J. J. Wang, “Fuzzy weighted average: An improved 
algorithm,” Fuzzy Sets Syst., vol. 49, pp. 307–315, 1992. 
[21] D. H. Lee and D. Park, “An efficient algorithm for fuzzy weighted 
average,” Fuzzy Sets Syst., vol. 87, pp. 39–45, 1997. 
[22] P. V. Broek and J. Noppen, "Fuzzy Weighted Average: Alternative 
approach," NAFIPS 2006 - 2006 Annual Meeting of the North American 
Fuzzy Information Processing Society, 2006, pp. 126-130. 
[23] Y.-Y. Guh, C.-C. Hon, K.-M. Wang, and E. S. Lee, “Fuzzy weighted 
average: A max-min paired elimination method,” Comput. Math. 
Applicat. vol. 32, pp. 115–123, 1996. 
[24] F. Liu and J. M. Mandel. “Aggregation using the Fuzzy Weighted 
Average as Computed by Kernik-Mandel Algorithms,” IEEE Trans. On 
Fuzzy Systems, vol. 16, no. 1, pp. 1-12. 
[25] O. Pavlacka and J. Talasová. “Applications of the Fuzzy Weighted 
Average of Fuzzy Numbers in Decision Making Models,” EUSFLAT 
Conf., 2007. 
[26] F. Ahmed, K. Kilic, “Fuzzy Analytic Hierarchy Process: A performance 
analysis of various algorithms,” Fuzzy Sets and Systems, vol. 362, pp. 
110-128, 2019.  
[27] J.C. Bezdek, Pattern Recognition with Fuzzy Objective Function 
Algorithms, Plenum  Press, New York 1981. 
[28] J. Li and H. W. Lewis, "Fuzzy Clustering Algorithms — Review of the 
Applications," 2016 IEEE International Conference on Smart Cloud 
(SmartCloud), pp. 282-288, 2016. 
[29] D. Abriel,  G. Navarro-Arribas, V. Torra, “Choquet integral for record 
linkage,” Annals of Operations Research, 195, pp. 97-110, 2012. 
[30] M. Gupta and D. Bhattacharjee, “Multi objective problem in fuzzy 
environment where resources are triangular fuzzy number,” European 
Journal of Scientific Research 46(1): 99–106. 2010. 
[31] J. J. Buckley, “Fuzzy Hierarchical Analysis,” Fuzzy Sets and 
Systems, 17, pp. 233-247, 1985. 
[32] Fuzzy c-means Clustering. 
[33] Fuzzy Controller 
[34] Practical Business Python 
[35] Python Record Linkage Toolkit 
[36] Splink 
 
   

---

