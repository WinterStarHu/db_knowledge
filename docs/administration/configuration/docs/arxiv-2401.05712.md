# BOD: Blindly Optimal Data Discovery

> 来源: https://arxiv.org/pdf/2401.05712

BOD: Blindly Optimal Data Discovery
Thomas Hoang
Denison University
USA
hoang_t2@denison.edu
ABSTRACT
Combining discovery and augmentation is important in the era
of data usage when it comes to predicting the outcome of tasks.
However, having to ask the user the utility function to discover
the goal to achieve the optimal small rightful dataset is not an
optimal solution. The existing solutions do not make good use of
this combination, hence underutilizing the data. In this paper, we
introduce a novel goal-oriented framework, called BOD: Blindly
Optimal Data Discovery, that involves humans in the loop and
comparing utility scores every time querying in the process without
knowing the utility function. This establishes the promise of using
BOD: Blindly Optimal Data Discovery for modern data science
solutions.
PVLDB Reference Format:
Thomas Hoang. BOD: Blindly Optimal Data Discovery. PVLDB, 14(1):
XXX-XXX, 2024.
doi:XX.XX/XXX.XX
PVLDB Artifact Availability:
The source code, data, and/or other artifacts have been made available at
https://github.com/Thomas12012002/BOD.
1
INTRODUCTION
When data scientists have multiple datasets, each contains various
variables, and scientists want to know what they could get from
the data, determining the outcome after joining multiple relational
tables. Assume all the datasets augmenting are valid candidates, the
values are integers, no overlapping values with different attributes
and each has no missing number value; scientists often want to find
the goal from the datasets after augmenting in which they want
to know what data can do with or predicting what based on the
datasets, for example housing prices are often based on location
(which contains near urban center or a place where the criminal
status is low) and goverment policies (which has taxes incentive)
or the home values ( including the age and size of the house). To
predict the housing price, scientists with their expertise in the field,
rank each variable in each dataset one at a time until there is no
variable in any dataset remaining and augment the datasets which
are location, government policies in the area, home values.
The process of using machine learning application and causal
relationship tasks to predict the outcome requires a utility func-
tion that users have to know exactly beforehand. This would be
This work is licensed under the Creative Commons BY-NC-ND 4.0 International
License. Visit https://creativecommons.org/licenses/by-nc-nd/4.0/ to view a copy of
this license. For any use beyond those covered by this license, obtain permission by
emailing info@vldb.org. Copyright is held by the owner/author(s). Publication rights
licensed to the VLDB Endowment.
Proceedings of the VLDB Endowment, Vol. 14, No. 1 ISSN 2150-8097.
doi:XX.XX/XXX.XX
Figure 1: Augmenting data from tables and filtering out items
based on human feedback of their ranking for variables
abundant for users to walk them through the process of finding
utility functions based on data in datasets when users do not know
their exact information. We solve this problem by introducing BOD:
Blindly Optimal Data Discovery by eliminating the finding utility
function process and by asking a small number of questions based
on variables of datasets to output a small subset of rightful tuples,
which is the goal of predicting the future.
The work of algorithms: The query first asks the user to pick
the most important variable in each dataset. For example, if a user
want to predict housing price without knowing their utility func-
tion, the query asks user to rank each variable in each of the datasets
once at a time in multiple rounds. Based on the user’s ranking, the
query selects all the tuples that meet the user’s preferences based on
utility score, and the process continues working with these selected
tuples. The query then outputs all the desirable tuples whenever
user stops ranking the variables.
2
RELATED STUDIES
Machine Learning. To leverage data effectively for prediction or
understanding what insights the data can offer, the technique of
using machine learning as proposed in [5] requires the user’s utility
function. However, this approach is limited when the user’s utility
function is unknown. In such cases, the work of [9] only selects a
nearly optimal solution without fully understanding the potential
of the data. Our algorithm, the Blindly Optimal Data Discovery,
combines the advantages of these two approaches—enabling the
discovery of data insights without requiring the user’s utility func-
tion.
Top-k. The Top-K algorithm has lasted with many developments
over time, as highlighted in [4], [11], [12], [18], [20], [21], [10], and
[25]. Despite these advancements, the algorithm requires the user’s
arXiv:2401.05712v3  [cs.DB]  18 Aug 2024

---

utility function, which can be difficult to obtain and is not always
applicable where user preferences are not well-defined.
Skyline. Numerous studies have explored this algorithm, in-
cluding [11], [13], [14], [1], [2], [23], [22], [17], [8], [24], and [26].
A drawback of the Skyline algorithm is the uncontrolled size of
the output, which can include uninteresting tuples. In contrast, it
may exclude tuples dominated by others but still of interest to the
user. To address this issue, researchers proposed combining the
techniques of Top-k and Skyline, as seen in [15], to control the
output size more effectively.
K-Dominance. This algorithm, explored in [3], [6], and [19], of-
fers a method for refining the results by considering the dominance
of data points across multiple dimensions, providing a balance
between comprehensiveness and output size.
Pareto Optimality. Pareto optimality is central to multi-objective
optimization, with contributions from studies such as [27] and [7].
This approach seeks to identify optimal solutions that cannot be
improved on one objective without worsening another, offering a
rigorous framework for decision-making in complex scenarios.
Blindly Optimal Data Discovery. Our algorithm involves hu-
man interaction with the data to rank the variables within each
dataset iteratively. After each ranking phase, we filter out promis-
ing tuples based on their utility scores, progressively refining the
results for optimal data points without requiring predefined utility
functions.
3
PROBLEM DEFINITION
Let (𝑆1, . . . ,𝑆𝑛) denote a relation table over 𝑛attributes, 𝑆𝑖de-
notes the 𝑖th attribute. 𝐷composes the list of tuples with a table
(𝑆1, . . . ,𝑆𝑛) such that every tuples 𝑡∈𝑇is an instance of the table.
Linear function:
• 𝐿𝐼𝑁𝐸𝐴𝑅= {𝑓|𝑓(𝑥) =
𝑑Í
𝑖=1
𝑓(𝑥𝑖)
{where each 𝑓(𝑥𝑖) is a linear function.}
Assume we want to predict the housing price in an area, we have
datasets including location, government policies in the area, and
home values. In detail, the dataset location composes a relational
table that has two attributes that are Near Urban and Criminal
Free, the dataset government policies composes table that has one
attribute which is Tax, while the dataset home values composes a
tables that has two attributes which are Size and Age of the house.
After augmenting all the datasets, we have a dataset composes five
attributes and six instances after augmenting the tables as shown
in the table 2
Then we scale down the values in the range of {0, 1} by the
highest value in each variables and we calculate 𝑦𝑚𝑖𝑛𝑖after asking
the user to rank the variables in the original tables as shown in
table 3.
Suppose the user rank Near urban , Tax, and Size as the first
priority in the first interaction with the algorithm, we then calculate
the summation of each instance and find the maximum calculation
in this round, which is 𝑦𝑚𝑖𝑛1 = 2.83 in this case as shown in table
4.
Based on the information from the first interaction, we find the
tuples that have 𝑦𝑚𝑖𝑛1 ≤𝑦1 ≤𝑦𝑚𝑎𝑥1 that are House 3 and House
6 since 2.83 ≤𝑦1 ≤3.89. The table 5 shown the result from the
first interaction. The final interaction which is the second ranking
would result in only House 3.
4
BOD: BLINDLY OPTIMAL DATA DISCOVERY
Since we scale down each value in a variable by a factor of max
value of the variable such that every value now in the variable
is in the range of {0, 1} and we scale the values in every variable
after augmenting all the datasets. For each of the relational tables,
We ask the user to pick the first most important variable in each
of dataset, knowing that the number of variables in each table is
varied, called 𝑛𝑖. We then find the maximum sum of values from
the most first important variables from the original tables after
augmenting, called 𝑦𝑚𝑖𝑛1. Then, we find 𝑦𝑚𝑎𝑥1 from the row with
the maximum sum 𝑦𝑚𝑖𝑛1, which is the sum of all values in that
row. After that, we select the items that have their utility score, 𝑦1 ,
which is the sum of all variables, in which 𝑦𝑚𝑖𝑛1 ≤𝑦1 ≤𝑦𝑚𝑎𝑥1. We
then use these items in a new dataset and begin the second phase,
and so on, until we get to the last variable in any table or the user
wants to stop ranking the variables in each dataset.
Algorithm 1 Blindly Optimal Data Discovery
Require: The tables 𝑆𝑖that has 𝐷tuples.
Ensure: return a subset 𝑡of 𝐷.
1: Let 𝑆𝑖= 1
2: while 𝑆𝑖≤length of 𝑆do
3:
for 𝑖in the length of 𝑆𝑖do
4:
Let the user rank the attributes in each table 𝑆𝑖until the
user stops
5:
𝑆𝑖+ = 1
6: Find the maximum length of each 𝑆𝑖in 𝑆, called 𝑚𝑎𝑥𝑛𝑖
7: Concatenate DataFrames/Tables horizontally along columns
8: 𝑑𝑖= 1
9: for 𝑑𝑖≤𝑑do
10:
find max value called 𝑆𝑚𝑎𝑥𝑖
11:
Scale down all values by dividing 𝑆𝑚𝑎𝑥𝑖
12:
𝑑𝑖+ = 1
13: Update the new 𝑆
14: for 𝑖in range 𝑚𝑎𝑥𝑛𝑖do
15:
Based one user ranking in 𝑖th time, calculate𝑦𝑚𝑖𝑛𝑖and𝑦𝑚𝑎𝑥𝑖
accordingly
16:
If 𝑦𝑚𝑖𝑛𝑖≤𝑦𝑖≤𝑦𝑚𝑎𝑥𝑖
17:
Select all tuples 𝑡that satisfies and let update 𝑆
18: return 𝑡
5
BOD’S PERFORMANCE GUARANTEE
We show that Blindly Optimal Data Discovery can identify the
optimal solution in exactly 𝑑queries and returns a nearly optimal
solutions in a maximum of 𝑑queries since the number of questions
depends on the amount of the total attributes after augmenting all
2

---

Table 1: Notation and meaning
𝐷
The set of all tuples
𝑑
The total attributes of the final table after augmenting all the datasets
𝑆
The table of all the relational tables augmented over 𝑛𝑖attributes
𝑡
The specific tuple that has an instance schema
𝑦𝑚𝑖𝑛𝑖
The maximum values’s summation based on user’s 𝑖th ranking
𝑦𝑚𝑎𝑥𝑖
The summation of all values based on user’s 𝑖th ranking
𝑦𝑖
The summation of all values of the instance
Price
Near Urban
Criminal Free
Tax
Size
Age
House 1
26
5
90
1500
150
house 2
35
2
20
1300
120
House 3
45
3
78
2000
95
House 4
9
2
46
1700
50
House 5
6
4
65
1800
25
house 6
47
7
30
1450
75
Table 2: Example of the tables after augmenting
Price
Near Urban
Criminal Free
Tax
Size
Age
Sum
House 1
0.55
0.71
1
0.75
1
4.01
house 2
0.74
0.29
0.22
0.65
0.8
2.7
House 3
0.96
0.43
0.87
1
0.63
3.89
House 4
0.19
0.29
0.51
0.85
0.33
2.17
House 5
0.13
0.57
0.72
0.9
0.17
2.49
house 6
1
1
0.33
0.73
0.5
3.56
Table 3: Example of the query scaling down all the values in
all variables after augmenting
Price
Near Urban
Tax
Size
Near Urban + Tax + Size
House 1
0.55
1
0.75
2.3
house 2
0.74
0.22
0.65
1.61
House 3
0.96
0.87
1
2.83
House 4
0.19
0.51
0.85
1.55
House 5
0.13
0.72
0.9
1.75
house 6
1
0.33
0.73
2.06
Table 4: Example of the query when user rank Near Urban,
Tax, and Size as the first priorities
Price
Near Urban
Criminal Free
Tax
Size
Age
Sum
House 3
0.96
0.43
0.87
1
0.63
3.89
house 6
1
1
0.33
0.73
0.5
3.56
Table 5: The results of the algorithm
the datasets. The performance runs far better than any previously
known algorithms.
Figure 2: Changes in number of attributes
6
EXPERIMENTAL EVALUATION
We assume the augmentation part is correct, with no error from
the scientist’s domain; all values are valid, not missing, and all
are in positive integers. We tested the algorithm using Google
Collaboration, which runs on GL65 Leopard 10SCXK, an x64-based
PC, on Microsoft Windows 11 Home Single Language. We test on
three synthetic datasets, each dataset has 10000 tuples and a range
of 3 to 9 variables. The values in each cell are randomly generated
in the range of 1, 1000. Then, We test on three synthetic datasets in
the range of 5000, 10000, and 15000 tuples, each with six variables.
The values in each cell are randomly generated in the range of
{1, 1000}.
The precision comparison among different algorithms, as de-
picted in Figure 4, provides important insights into the performance
of the Blindly Optimal Data Discovery (BOD) algorithm and other
established algorithms: Top-K, Skyline, K-Dominance, and Pareto
Optimality, when applied to a dataset testing on 5000 tuples. The
BOD algorithm achieved a precision of 0.505, which outperforms
the Top-K algorithm, which had a precision of 0.4. This result is
important as it demonstrates that BOD can accurately identify rel-
evant data points without requiring a predefined utility function,
unlike Top-K, which is heavily dependent on the user’s utility func-
tion to rank the tuples. The slight advantage of BOD over Skyline
(0.5) suggests that BOD not only matches but slightly exceeds the
ability of Skyline to find optimal solutions under these conditions.
3

---

Figure 3: Changes in number of tuples
The Pareto Optimality algorithm also performed closely to BOD,
with a precision of 0.503. This similarity in performance highlights
that both BOD and Pareto Optimality are capable of yielding com-
patible outcomes in terms of precision, even though they approach
the problem from different theoretical foundations. Pareto Optimal-
ity, which is observed in multi-objective optimization, and BOD,
without predefined utility functions, with its application in rank-
ing and filtering, achieve a high level of precision. However, the
K-Dominance algorithm yielded a precision of 0.0 in this scenario.
This let us know that K-Dominance may struggle with identifying
relevant data points in larger datasets, particularly when the data
is highly multidimensional or when the criteria for dominance are
not easily satisfied. The results highlight the accuracy of the BOD
algorithm in achieving high precision without requiring predefined
user preferences, making it suitable in data discovery tasks. Its per-
formance, on par with established methods like Pareto Optimality
and surpassing Top-K and Skyline, under certain conditions, un-
derscores its potential as a reliable alternative for scenarios where
utility functions are unknown or difficult to define.
7
ANALYSIS OF MAE COMPARISON AMONG
ALGORITHMS
The results, as depicted in Figure 5, let us know about that the BOD
algorithm consistently achieved the lowest MAE across all dataset
sizes which demonstrates that BOD is the most effective in selecting
values that are closest to the actual housing prices. On the other
hand, the Top-K algorithm shows the highest MAE score among the
four algorithms tested which is a deviation from the actual housing
prices. The Skyline and Pareto Optimality algorithms demonstrated
intermediate performance, with MAE values that were consistently
higher than those of BOD but lower than those of Top-K. Thus,
BOD has the most precise accuracy among all algorithms.
Figure 4: Precision Comparison Among Algorithms for 5000
Tuples
Figure 5: Mean Absolute Error (MAE) Comparison Among
Algorithms with increasing number of Tuples
8
ANALYSIS OF ALGORITHM PRECISION AND
STABILITY
8.1
Mean Precision Comparison
As shown in the chart in Figure 6, among the algorithms, the Blindly
Optimal Data Discovery (BOD) algorithm illustrates the highest
mean precision of 0.663, which is the most effective at identify-
ing relevant data points under the given experimental conditions.
The Top-K algorithm followed with a mean precision of 0.590, sug-
gesting that it also performs reasonably well, although it requires
knowledge of the user’s utility function. The Skyline and Pareto
Optimality algorithms yielded nearly identical mean precisions of
0.495 and 0.494, respectively, which means that both algorithms
are somewhat less effective in this context as effectively as BOD or
Top-K. The K-Dominance algorithm, however, failed to identify any
relevant data points, resulting in a mean precision of 0.000. Thus,
BOD again is the most effective among all algorithms.
4

---

Figure 6: Mean Precision Comparison Among Algorithms
8.2
Precision Stability Analysis
The precision stability of each algorithm is presented in Figure 7
across multiple iterations. Despite its high mean precision, the BOD
algorithm shows a standard deviation of 0.340, which is somewhat
variable and could be due to the sensitivity of the BOD algorithm
to the specific characteristics of the dataset. In addition, While Top-
K’s mean precision was lower than BOD’s, it demonstrated better
stability with a standard deviation of 0.158. Skyline and Pareto
Optimality algorithms illustrate very low standard deviations of
0.006 and 0.009, respectively.
Figure 7: Precision Standard Deviation Comparison Among
Algorithms
The analysis highlights a trade-off between precision and stabil-
ity across the algorithms tested. BOD offers the highest precision
but suffers from instability, while Skyline and Pareto Optimality
provide highly stable but less precise outcomes. Top-K strikes a
balance, offering moderate precision with relatively good stability.
The K-Dominance algorithm’s poor performance suggests it may
not be suitable for the types of datasets and criteria used in these
experiments.
8.3
Testing on Boston Housing dataset
Figure 8: Mean MAE Comparison Among Algorithms (Boston
Housing Dataset)
The chart in Figure 8 [16] presents a comparison of the Mean Abso-
lute Error (MAE) among four algorithms—BOD, Top-K, Skyline, and
Pareto Optimality—applied to the Boston Housing Dataset. In detail,
the BOD algorithm demonstrated superior performance, achieving
the lowest mean MAE of 3.217, which is the most accurate predic-
tion when compared to the true housing prices. In contrast, the
Top-K algorithm showed the poorest performance with a mean
MAE of 14.804, indicating significantly less accurate predictions.
Both the Skyline and Pareto Optimality algorithms performed mod-
erately, with mean MAEs of 8.676 and 8.688, respectively. The close
MAE values for Skyline and Pareto Optimality suggest that these
two algorithms provide similar levels of prediction accuracy, though
they are less precise than BOD.
9
CONCLUSION
The BOD algorithm shows better performance compared to other
algorithms such as Top-K, Skyline, and Pareto Optimality in terms
of accuracy for the task of predicting housing prices with vari-
ous datasets and environments. In addition, the BOD algorithm
achieves lower Mean Absolute Error (MAE) and higher precision,
which makes it an optimal choice for tasks involving complex
decision-making and prediction. This also makes BOD valuable
for applications such as housing price predictions and similar data-
driven tasks for data scientists and analysts. Would open questions
be better techniques/algorithms than BOD in terms of accuracy,
scalability, and running time?
10
CITATIONS
REFERENCES
[1] C. Chan, H. Jagadish, K. Tan, A. Tung, and Z. Zhang. 2006. Finding k-dominant
skylines in high dimensional space. In Proceedings of the ACM SIGMOD Interna-
tional Conference on Management of Data.
[2] C. Chan, H. Jagadish, K. Tan, A. Tung, and Z. Zhang. 2006. On high dimensional
skylines. In Advances in Database Technology-EDBT 2006. Springer, 478–495.
[3] Chee-Yong Chan, H. V. Jagadish, Kian-Lee Tan, Anthony Kum Hoe Tung, and
Zhenjie Zhang. 2006. Finding k-dominant skylines in high dimensional space.
Proceedings of the 2006 ACM SIGMOD international conference on Management of
data (2006). https://api.semanticscholar.org/CorpusID:207159539
5

---

[4] P. Fraternali, D. Martinenghi, and M. Tagliasacchi. 2012. Top-k bounded diversi-
fication. In Proceedings of the 2012 International Conference on Management of
Data.
[5] Sainyam Galhotra, Yue Gong, and Raul Castro Fernandez. 2023. Metam: Goal-
Oriented Data Discovery. 2023 IEEE 39th International Conference on Data En-
gineering (ICDE) (2023), 2780–2793. https://api.semanticscholar.org/CorpusID:
258187398
[6] Lei gang Dong and Xiao wei Cui. 2014. Finding k-Dominant Skyline for Combined
Dataset. Applied Mechanics and Materials 568-570 (2014), 1534 – 1538. https:
//api.semanticscholar.org/CorpusID:122882490
[7] Marc Geilen, Twan Basten, Bart D. Theelen, and Ralph Otten. 2005. An algebra
of Pareto points. Fifth International Conference on Application of Concurrency
to System Design (ACSD’05) (2005), 88–97.
https://api.semanticscholar.org/
CorpusID:11381
[8] M. Goncalves and M. Yidal. 2005. Top-k skyline: a unified approach. In On the
Move to Meaningful Internet System 2005.
[9] Yue Gong, Zhiru Zhu, Sainyam Galhotra, and Raul Castro Fernandez. 2021. Ver:
View Discovery in the Wild. 2023 IEEE 39th International Conference on Data
Engineering (ICDE) (2021), 503–516. https://api.semanticscholar.org/CorpusID:
252545411
[10] Cherry Khosla and Parveen Kakkar. 2015. Top-k Query Processing Techniques in
Uncertain Databases: A Review. International Journal of Computer Applications
120 (2015), 33–37. https://api.semanticscholar.org/CorpusID:18266015
[11] Jongwuk Lee, Gae won You, and Seung won Hwang. 2009. Personalized top-k
skyline queries in high-dimensional space. Information Systems 34, 1 (2009),
45–61.
[12] X. Lian and L. Chen. 2009. Top-k dominating queries in uncertain databases.
In Proceedings of International Conference on Extending Database Technology:
Advances in Database Technology.
[13] X. Lin, Y. Yuan, Q. Zhang, and Y. Zhang. 2007. Selecting stars: The k most
representative skyline operator. In Proceedings of International Conference on
Data Engineering.
[14] D. Mindolin and J. Chomicki. 2009. Discovering relative importance of skyline
attributes. In Proceedings of the VLDB Endowment.
[15] Kyriakos Mouratidis, Keming Li, and Bo Tang. 2021. Marrying Top-k with
Skyline Queries: Relaxing the Preference Input While Producing Output of Con-
trollable Size. In Proceedings of the 2021 International Conference on Management
of Data (Virtual Event, China) (SIGMOD/PODS ’21). Association for Computing
Machinery, New York, NY, USA, 1317–1330.
[16] Altavish Nair. 2021. Boston Housing Dataset. https://www.kaggle.com/datasets/
altavish/boston-housing-dataset Accessed: [Insert Date of Access].
[17] D. Papadias, Y. Tao, G. Fu, and B. Seeger. 2005. Progressive skyline computation
in database systems. In ACM Transactions on Database Systems (TODS), Vol. 30.
ACM, 41–82.
[18] L. Qin, J. Yu, and L. Chang. 2012. Diversifying top-k results. In Proceedings of the
VLDB Endowment.
[19] Mohammad Anisuzzaman Siddique and Yasuhiko Morimoto. 2012. Efficient
k-dominant Skyline Computation for High Dimensional Space with Domination
Power Index. J. Comput. 7 (2012), 608–615.
https://api.semanticscholar.org/
CorpusID:10057450
[20] M. Soliman, I. Ilyas, and K. Chen-Chuan Chang. 2007. Top-k query process-
ing in uncertain databases. In Proceedings of International Conference on Data
Engineering. IEEE, 896–905.
[21] Mohamed A. Soliman, Ihab F. Ilyas, and Kevin Chen-Chuan Chang. 2007. Top-k
Query Processing in Uncertain Databases. 2007 IEEE 23rd International Conference
on Data Engineering (2007), 896–905. https://api.semanticscholar.org/CorpusID:
206782514
[22] Y. Tao, L. Ding, and J. Pei. 2009. Distance-based representative skyline. In
Proceedings of International Conference on Data Engineering.
[23] Y. Tao, X. Xiao, and J. Pei. 2007. Efficient Skyline and Top-k Retrieval in Subspaces.
In TKDE.
[24] T. Xia, D. Zhang, and Y. Tao. 2008. On skylineing with flexible dominance relation.
In Proceedings of International Conference on Data Engineering.
[25] Guoqing Xiao, Fan Wu, Xu Zhou, and Keqin Li. 2016. Probabilistic top-k range
query processing for uncertain databases. J. Intell. Fuzzy Syst. 31 (2016), 1109–
1120. https://api.semanticscholar.org/CorpusID:35783156
[26] Huo Ying and Jian de Zhang. 2020. A nonlinear service composition method
based on the Skyline operator. Journal of Systems Engineering and Electronics
(2020). https://api.semanticscholar.org/CorpusID:225331780
[27] Wenhui Yu, Jinfei Liu, Jian Pei, Li Xiong, Xu Chen, and Zheng Qin. 2019. Efficient
Contour Computation of Group-Based Skyline. IEEE Transactions on Knowledge
and Data Engineering 32 (2019), 1317–1332.
https://api.semanticscholar.org/
CorpusID:88495466
6

---

