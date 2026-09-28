# In-Database Data Imputation

> 来源: https://arxiv.org/pdf/2401.03359

In-Database Data Imputation
Massimo Perini
Milos Nikolic
{massimo.perini, milos.nikolic}@ed.ac.uk
University of Edinburgh
Abstract
Missing data is a widespread problem in many domains, creating challenges in data analysis and
decision making.
Traditional techniques for dealing with missing data, such as excluding incomplete
records or imputing simple estimates (e.g., mean), are computationally efficient but may introduce bias
and disrupt variable relationships, leading to inaccurate analyses. Model-based imputation techniques
offer a more robust solution that preserves the variability and relationships in the data, but they demand
significantly more computation time, limiting their applicability to small datasets.
This work enables efficient, high-quality, and scalable data imputation within a database system using
the widely used MICE method. We adapt this method to exploit computation sharing and a ring abstrac-
tion for faster model training. To impute both continuous and categorical values, we develop techniques
for in-database learning of stochastic linear regression and Gaussian discriminant analysis models. Our
MICE implementations in PostgreSQL and DuckDB outperform alternative MICE implementations and
model-based imputation techniques by up to two orders of magnitude in terms of computation time, while
maintaining high imputation quality.
Keywords: missing data, incomplete data, MICE, ring, factorized computation
1
Introduction
Missing data is pervasive in real-world datasets across various domains, posing significant challenges in
drawing accurate and reliable conclusions from incomplete information. Missing data may introduce bias,
reduce statistical power, and undermine the validity of analyses and predictive models [66, 40, 20]. Moreover,
traditional machine learning techniques, typically designed to operate on complete datasets, are ill-equipped
to handle missing data effectively [18, 26, 33, 67]. Therefore, handling missing data effectively is essential for
the validity and robustness of data analysis.
Various techniques are commonly used to handle datasets with missing information, including disregard-
ing records with missing data, incorporating indicator variables to capture the missing pattern, and imputing
alternative values in place of the missing values. Common imputation methods involve mean imputation,
which replaces missing values with the mean of the column; last observation carried forward (LOCF), which
substitutes missing values with the most recent observed value [36]; and hot deck imputation, which utilizes
similarity criteria within the column [4]. Although these techniques are easy to implement and computation-
ally efficient, they offer limited guarantees regarding the quality of the imputed data. They can potentially
distort value distributions, underestimate data variance, disrupt variable relationships, and introduce bias
in statistical measures such as the mean, leading to subpar analytics and machine learning models over the
imputed data [66, 16, 13, 36].
Model-based imputation methods can overcome these problems and capture complex missingness patterns
while preserving the underlying data distribution.
These methods learn models over observed data to impute
missing data. Popular iterative imputation methods include MissForest [65], which utilizes random forests,
and Multivariate Imputation by Chained Equations (MICE) [68], which allows using a different model for
each attribute with missing values. Recent generative imputation methods exploit generative adversarial
networks, like in GAIN [69], and deep learning, like in MIDASpy [37] and MIRACLE [35]. Despite their
1
arXiv:2401.03359v1  [cs.DB]  7 Jan 2024

---

2 x 10
1
8 x 10
1
3 × 10
1
4 × 10
1
6 × 10
1
RMSE
100
101
102
103
104
Time (s)
MICE
Mean
MissForest
GAIN
MIRACLE
LOCF Random
MIDASpy
Figure 1: Imputation quality and runtime of Python-based imputation methods on a flight dataset [51] with
5M rows and 20% missing values. Imputation quality is measured as the root mean square error (RMSE) of
the linear regression model trained over an imputed dataset to predict flight duration.
effectiveness, such model-based methods suffer from high computation costs. Figure 1 illustrates the trade-
off between the quality of imputation, measured by the performance of a linear regression model trained on
imputed data, and the time needed for imputation using different methods on a real dataset. Compared to
model-free imputation methods such as mean and random imputation, complex methods such as MICE and
MIRACLE yield models with lower root mean squared errors (RMSE), indicating higher quality, but demand
orders of magnitude more time for model training and data imputation.
We next identify the challenges involved in enabling high-quality imputation on large datasets.
Challenge 1: Enabling Model-Based Imputation in DBMSs. Model-based imputation methods
are commonly implemented in external tools such as scikit-learn [52] and R [68], operating independently of
the DBMS environment. To impute a dataset stored in a DBMS using these methods, we need to export
the dataset to the external tool for imputation and import the imputed dataset back into the DBMS for
further analyses. These steps can significantly increase the computation time. Moreover, as the external tool
typically lacks support for out-of-memory computation, this approach works only with datasets small enough
to fit into memory.
Challenge 2:
Long Imputation Time.
Despite the benefits offered by model-based imputation
methods, simpler techniques such as dropping rows with missing values and mean imputation continue to
be prevalent in practice and are often the default option in statistical packages such as R and SAS. The
reluctance to adopt more complex imputation methods primarily stems from their higher computational time
and limited ability to handle large datasets [20, 13, 60]. For instance, MissForest and MICE impute missing
data by employing an iterative process of predictive modeling [20, 65], retraining models from scratch on
every iteration. Data practitioners utilizing complex imputation methods may experience extended waiting
periods, potentially lasting several hours, for the imputation process to converge [14].
Therefore, these
complex methods are typically viable only for small datasets.
Challenge 3: Avoiding Data Explosion. Model-based imputation methods implemented in external
tools can only train models on data available in a single table. Therefore, data practitioners need to preprocess
the dataset before exporting it to the external tool, which may involve joining relations if the dataset is
normalized and performing one-hot encoding of categorical features. These preprocessing steps introduce
redundancy in both data and computation, significantly increasing the size of the training dataset and
prolonging the overall computation time [64, 15, 63].
Our Goal. This work aims to enable efficient and high-quality data imputation within database systems.
By moving imputation closer to data, we want to harness the performance and scalability of database systems
to accelerate both model training and data imputation, effectively addressing the above challenges.
2

---

This work studies in-database data imputation using the MICE method [13, 68]. This method can impute
incomplete multivariate data comprising mixtures of continuous and categorical values. For each attribute
with missing values, MICE learns a model – a regressor or a classifier depending on the attribute’s type –
using all other attributes as predictors. The imputation proceeds one attribute at a time in a round-robin
fashion, incorporating previously imputed values into the prediction models for subsequent attributes.
We focus on MICE for three compelling reasons: 1) MICE offers flexibility and can utilize various predic-
tive models, including those that can be efficiently trained inside database systems; 2) In terms of imputation
quality, MICE competes with or outperforms other state-of-the-art imputation methods, including recent gen-
erative approaches [73, 69]; 3) MICE has been extensively studied in the past, widely used across diverse
domains [68, 45, 24, 3], and implemented in popular statistical tools [68, 72].
We leave studying other
model-based imputation methods as future work.
Our contributions. We next highlight our main contributions.
To support MICE within a database system (Challenge 1), we introduce techniques for in-database train-
ing of two novel models: stochastic linear regression [13], used for imputing continuous values, and Gaussian
discriminant analysis, used for imputing categorical values (Section 3).
The former builds upon existing
work on learning regression models [64, 49] by incorporating random noise into predictions to capture the
uncertainty associated with the imputation process.
The latter transforms a multinomial classification prob-
lem into a database problem, computing the model parameters using a single database query over normalized
data, without the need for prior one-hot encoding and materialization of the training dataset. To the best of
our knowledge, no prior work has explored classification methods in this setting.
Interestingly, both models
compute the same set of database aggregates in the training phase, despite their distinct characteristics.
To reduce imputation time (Challenge 2), we adapt the MICE algorithm to exploit computation sharing
across iterations while preserving its accuracy, regardless of the proportion of missing data (Section 4). To
unlock the sharing potential, we select stochastic linear regression and Gaussian discriminant analysis as
the models for imputing continuous and categorical attributes, respectively. As mentioned, training these
models within a database system relies on computing the same set of aggregate values. We observe that
MICE computes these aggregates over overlapping subsets of records.
The extent of overlap increases as the
proportion of missing values decreases. For datasets with low missing rates, we propose a rewriting of the
MICE algorithm that:
1) performs the most expensive computation over the entire dataset once, outside
the iterative loop; and 2) performs less expensive incremental computations over (smaller) incomplete parts
of the dataset inside the iterative loop.
This rewriting accelerates model training over datasets with less
than 20% missing values, based on our experimental results. We further devise partitioning strategies to
minimize redundant computation and avoid repetitive scans of the entire dataset, tailoring to both low and
high missing rate scenarios.
Our improvements of the MICE algorithm are applicable not only within a
database system but also in other tools and libraries implementing MICE.
To avoid materialization of large datasets (Challenge 3), we optimize the computation of MICE aggregates
using the mathematical notion of ring1. We leverage the cofactor ring from prior work [49, 50] to compactly
encode the needed aggregates as ring values and compute them using the sum and product from the ring.
When imputing a normalized dataset, we exploit the algebraic properties of the ring to push the aggregate
computation past joins, eliminating the need to materialize the joined relation. Furthermore, to avoid the size
explosion caused by one-hot encoding of categorical attributes, we utilize the generalized cofactor ring [50]
to uniformly encode the needed aggregates over continuous and categorical attributes as generalized multiset
relations [31]. This representation accounts for only the interactions between attributes that exist in the
dataset, avoiding the sparsity of one-hot encoding. Finally, the ring-based representations is essential for
our optimized MICE implementation because it allows the aggregates to be incrementally computed as new
values are imputed.
We implemented our data imputation approach in PostgreSQL and DuckDB, including the procedures
for in-database learning of ridge linear regression, stochastic linear regression, and Gaussian discriminant
analysis models. To efficiently compute the aggregates required for training these models, our implementation
harnesses the power of the cofactor ring, representing the first instance of incorporating this abstraction into
1A ring is a set R with two binary operations, + (addition) and ∗(multiplication), such that (R, +) is an abelian group,
(R, ∗) is a monoid, and ∗is distributive over +.
3

---

Algorithm 1: MICE
Input
:
X
incomplete dataset with attributes X1, ..., Xm
mattrs
indices of incomplete attributes
Output:
˜X
imputed dataset
1 ˜X ←X with initial imputations for all missing values
2 repeat
3
foreach i ∈mattrs do
4
θ ←Train(data = ˜Xi=obs, target = Xi)
5
˜X ←Predict(data = ˜Xi=miss, target = Xi, model = θ)
6
end
7 until stopping condition;
fully-fledged database systems. Our ring-based implementation improves the performance of computing these
aggregates in PostgreSQL and DuckDB by up to 6x over a single table and up to 12x over multiple tables.
Our experiments show that our in-database imputation outperforms the fastest competitor, SystemDS [12,
7], by 3-13x when using PostgreSQL and 86-346x when using DuckDB, depending on the fraction of missing
values. For datasets comprising multiple tables, our imputation method can leverage factorized evaluation
to bring a 6x improvement compared to imputing over the joined table. Our MICE method is on par with
other model-based methods in terms of imputation quality but requires up to two orders of magnitude less
time, under various missing rates and patterns.
The rest of the paper is organized as follows.
Section 2 introduces background material.
Section 3
shows how to support stochastic linear regression and Gaussian discriminant analysis within a database
system. Section 4 presents our adapted MICE algorithm and its implementation in Section 5. Section 6 gives
experimental results, followed by a discussion of related work and conclusion.
Our implementation of the above machine learning and imputation methods in PostgreSQL and DuckDB
is publicly available at https://github.com/eddbase/db-imputation.
2
Background
We next introduce the MICE algorithm for imputing missing values and review the relevant prior work on
in-database learning.
Notation.
Consider an incomplete dataset X consisting of records over attributes X1, . . . , Xm. We
denote by ˜X a complete version of X with the missing values replaced by imputed values. We write ˜Xi=miss
(or ˜Xi=obs) to denote the records from ˜X for which the value of attribute Xi was originally missing (or
observed).
2.1
The MICE Algorithm
Multivariate Imputation by Chained Equations (MICE) is an imputation method for handling missing data
in multivariate datasets [68]. The method iteratively imputes missing values in each attribute based on the
observed values in the other attributes. This imputation process accounts for the patterns present in the data,
preserving correlations among attributes and yielding more accurate imputations than model-free methods
(e.g., mean imputation).
The MICE method, shown in Algorithm 1, starts by imputing the missing data with initial guesses,
typically the mean/mode values. For each attribute Xi with missing values, the algorithm fits a model over
the observed part ˜Xi=obs with Xi as target and then uses this model to generate new imputations of Xi
in the missing part ˜Xi=miss. This iterative process continues until a stopping criterion is satisfied or the
maximum number of iterations specified by the user is reached. The MICE algorithm offers flexibility by
allowing the use of distinct models for different attributes, making it capable of imputing missing values of
both continuous and categorical attributes.
4

---

We refer to one round of imputations of all incomplete attributes as one iteration step. While the MICE
algorithm offer no convergence guarantees, it generally converges within a small number of iterations in
practice, typically between 5 and 20 iterations [13].
Example 1. Consider an incomplete flight dataset with three attributes, two continuous (Distance and
AirTime) and one categorical (Diverted), each with missing values. The MICE algorithm first imputes the
missing values in each attribute with the mean or mode, depending on the attribute’s type. It then trains a
regression model to predict Distance given AirTime and Diverted over the subset of records with complete
Distance values. The trained model serves to impute missing Distance values. The second regression model
predicts AirTime, while the third classification model predicts Diverted. The algorithm refines the imputed
values in a round-robin way until convergence or a fixed number of iterations.
□
The MICE algorithm involves retraining models for every incomplete attribute in every iteration, making
it potentially prohibitively expensive on large datasets with many incomplete attributes.
2.2
In-Database Linear Regression
Consider a training dataset X consisting of N training examples with attributes X1, . . . , Xm. Without loss
of generality, assume that X1 = 1 for all examples in X, and Xm is the target attribute. The goal of linear
regression is to find the parameters θ = [θ1 . . . θm]T , with θm = −1, that minimize the squared error loss
L = (Xθ)T Xθ.
Batch gradient descent solves this optimization problem by iteratively updating the learned parameters
in the opposite direction of the gradient of L until convergence, while θm is fixed to −1:
θ(k+1) = θ(k) −αXT (Xθ(k))
where α is the learning rate and θ(k) are the parameter values in iteration k.
Repeatedly scanning the
complete dataset to compute XT (Xθ(k)) can be time-consuming, especially with large datasets.
A more efficient approach precomputes XT X once and reuses it in each iteration, effectively decoupling
the computation over the training dataset from the parameter convergence [64]:
θ(k+1) = θ(k) −α C θ(k)
where C = XT X is the cofactor matrix of size m × m, which quantifies the level of correlation for each
combination of attributes. The one-off computation of XT X takes O(Nm2) time. Using the precomputed
cofactor matrix, each iteration now takes time O(m2) instead of O(Nm), yielding faster convergence as
usually N ≫m.
Cofactor Matrix Computation. Let us first assume that all attributes are continuous. The cofactor
matrix XT X accounts for the interactions SUM(Xi * Xj) of all pairs (Xi, Xj) of attributes. Thus, computing
the cofactor matrix amounts to executing a database query with O(m2) sum aggregates over the training
dataset.
When the training dataset X is the result of a join, a na¨ıve way of computing the cofactor matrix is to first
calculate the join result and then calculate the cofactor aggregates. Based on our experimental evaluation,
existing query optimizers make no attempts to factorize the evaluation of many aggregates, that is, to perform
partial preaggregation by pushing SUMs past joins [38].
Prior work shows how to express the cofactor matrix computation as the computation of one compound
aggregate. This aggregate is a triple (N, s, Q), where N is the size of the dataset, SUM(1); s is a vector of
sums of values for each attribute, si = SUM(Xi); and Q is a matrix of sums of products of values for any
two attributes, Q(i,j) = SUM(Xi * Xj). The computation over triples is captured by the cofactor (degree-m
matrix) ring [50, 49].
The cofactor ring defines the addition and multiplication operations over triples. Let R be a set of triples
(Z, Rm, Rm×m), for fixed m ∈N. For any a = (Na, sa, Qa) ∈R and b = (Nb, sb, Qb) ∈R, the addition and
multiplication operations on R are defined as:
a +R b = (Na + Nb, sa + sb, Qa + Qb)
a ∗R b = (Na Nb, Nb sa + Na sb, Nb Qa + Na Qb + sasT
b + sbsT
a )
5

---

where +R uses scalar and matrix addition, and ∗R uses matrix addition and scalar and matrix multiplication.
The additive identity (zero) is (0, 0m×1, 0m×m) and the multiplicative identity (one) is (1, 0m×1, 0m×m),
where 0m×n is the zero matrix of size m × n.
The function λcon maps values of continuous attribute X to triples from R such that λcon(x, i) = (1, s, Q),
where i is the index of X in the cofactor matrix, and s and Q contain all zeros except si = x and Q(i,i) = x2.
We refer to λcon as a lifting function. For brevity, we omit the index i in λcon, assuming a fixed order of
attributes.
Example 2. For the flight dataset from Example 1, we can compute the cofactor matrix over the attributes
Distance and AirTime using one aggregate query, which returns a triple from the cofactor ring:
SELECT SUM(λcon(Distance) * λcon(AirTime)) FROM Flight
The function λcon maps a Distance value d to (1, [ d 0 ], [ d2 0 ; 0 0 ]) and similarly an AirTime value a to
(1, [ 0 a ], [ 0 0 ; 0 a2 ]).
The triple multiplication yields (1, [ d a ], [ d2 da ; ad a2 ]).
The SUM operator uses the
addition +R from the cofactor ring. The result encodes the cofactor aggregates: SUM(1), SUM(D), SUM(A),
SUM(D*D), SUM(D*A), and SUM(A*A), where D and A stand for Distance and AirTime, respectively.
□
When computing the cofactor matrix over joins, this ring-based approach allows for the SUM to be pushed
past the joins, leveraging the distributivity of multiplication over addition in R. This eliminates the need to
compute the entire join result in advance and promotes the sharing of aggregate computation.
Handling Categorical Attributes. Most machine learning algorithms require numerical input and
cannot work directly with discrete categories. One-hot encoding is often employed to represent categorical
attributes as indicator vectors. But this encoding step can cause data explosion as each category yields a
new binary attribute.
The cofactor matrix of a one-hot encoded dataset comprises the following aggregates:
SUM(Xi * Xj)
when Xi and Xj are continuous; SUM(Xi) group by Xj when Xi is continuous and Xj is categorical; and
SUM(1) group by Xi, Xj when Xi and Xj are categorical [64].
To avoid one-hot encoding and operate directly over categorical values, prior work [50] generalizes the
cofactor ring with the ring over relations [31] to uniformly treat aggregates with continuous and categorical
attributes. The triple structure remains unchanged except that N, s, and Q contain relations instead of
scalars. Each relation is a mapping from tuples to scalars. The operations +R and ∗R remain unchanged
except that scalar addition is replaced by union and scalar multiplication is replaced by join. A scalar c is
represented as the relation {() 7→c} mapping the empty tuple to c.
The generalized cofactor ring requires new functions for mapping attribute values to ring values. For a
categorical attribute X with index i in the cofactor matrix, the lifting function λcat maps categories of X to
triples such that λcat(x) = (1, s, Q), where 1 is {() 7→1}, and s and Q contain all empty relations except
si = {x 7→1} and Q(i,i) = {x 7→1}. The lifting function λcon returns a triple as before but with every scalar
c replaced by {() 7→c}.
Example 3. For the flight dataset from Example 1, we can compute the cofactor matrix over AirTime
(continuous) and Diverted (categorical) using a query over the generalized cofactor ring:
SELECT SUM(λcon(AirTime) * λcan(Diverted)) FROM Flight
Each tuple (a, d) over the two attributes is mapped to (N, s, Q), where N = {() 7→1}, s = [ {()7→a} {d7→1} ],
and Q = [ {()7→a2} {d7→a} ; {d7→a} {d7→1} ]). The final aggregate (N, s, Q) encodes: SUM(1) in N; SUM(A) and
SUM(1) group by D in s; SUM(A * A) and SUM(A) group by D in Q, where A and D stand for AirTime and
Diverted, respectively.
□
3
In-Database Imputation Methods
This section presents two methods for learning models needed for the imputation of continuous and categorical
values, within a database management system. The first method extends the approach for learning regression
models from Section 2.2 to incorporate random noise into predictions. The second method is a novel approach
for in-database classification using Gaussian discriminant analysis. Seemingly disparate, both methods rely
on the aggregates that can be computed using the generalized cofactor ring.
6

---

3.1
Stochastic Linear Regression
Using linear regression for data imputation carries the risk of overstating the strength of the relationship
between the target and predictor attributes. Stochastic regression imputation [13] is a refinement of regression
imputation that attempts to address this correlation bias by adding noise to the predictions. By doing so,
imputed data will randomly deviate from the regression line, capturing the inherent uncertainty of the
imputation process.
For convenience, we summarize the setup from Section 2.2. A training dataset X consists of N training
examples over continuous attributes X1, . . . , Xm, where Xm denotes the target and X1 is fixed to 1. Linear
regression learns the parameters θ = [θ1, . . . , θm]T , with θm = −1 , minimizing the squared error loss
L = (Xθ)T Xθ.
Stochastic linear regression estimates the parameters θ under the linear model but adds random noise to
predictions: f(x) = xT θ′ + ϵ, where x ∈Rm−1, θ′ = [θ1 . . . θm−1]T , and ϵ ∼N(0, σ2) with the variance σ2
calculated from the vector of residuals, r = Xθ. Since the mean of residuals is zero in linear regression, we
can compute the residual variance as: σ2 = rT r
N = θT XT Xθ
N
, where N, θ, and XT X are already calculated in
the training phase.
Database perspective.
We compute the aggregates for training and prediction using one query over the
generalized cofactor ring:
SELECT SUM(λcon(X1) * . . . * λcon(Xm)) FROM Xdataset
where λcon is the lifting function for the generalized cofactor ring (cf. Section 2.2). Here, we assume that
all attributes are continuous. When an attribute Xi is categorical, we use the lifting function λcat to map
Xi-categories into ring values. In the presence of categorical attributes, the computed aggregate is a compact
representation of the cofactor matrix computed over the one-hot encoded dataset.
We utilize user-defined functions to unpack the computed aggregate into a real-valued matrix, learn
parameters θ, and compute variance σ2. We generate predictions for a given test dataset as:
SELECT (θ1 * X1 + . . . + θm-1 * Xm-1 + ϵ) AS prediction FROM Xtest
where ϵ is a sample from N(0, σ2) computed using the Box-Muller transform: ϵ = √−2 ln U1 cos(2πU2) · σ,
where U1 and U2 are independent samples from the uniform distribution.
3.2
Gaussian Discriminant Analysis
We consider Gaussian discriminant analysis (GDA) for categorical data imputation. It is a type of generative
classifier that models the distribution of the input features for each class as a multivariate Gaussian distri-
bution. To classify a new instance, GDA estimates the posterior probability of each class given the input
features using Bayes’ rule and chooses the class with the highest probability.
We focus here on Linear Discriminant Analysis (LDA), a variant of GDA where all classes share the same
covariance matrix, thus yielding linear decision boundaries among classes. The following discussion can serve
as a blueprint for other types of classifiers such as Quadratic Discriminant Analysis, another variant of GDA
that uses class-specific covariance matrices, and Na¨ıve Bayes classifiers.
Setup.
Consider a training dataset X consisting of N training examples (x1, y1), . . . , (xN, yN), where the
features xi ∈Rm and the targets yi take on values from a set of classes {1, . . . , C}2. GDA assumes the
class-conditional densities are normally distributed:
Pr(x | y = c) =
1
(2π)m/2|Σ|1/2 exp

−1
2(x −µc)T Σ−1(x −µc)

2Without loss of generality, we assume that classes are encoded as integers.
7

---

where m is the dimension of the features, µc is the class-specific mean vector, and Σ is the shared covariance
matrix for all the classes. Using Bayes’ rule, we can compute the class posterior as:
Pr(y = c | x) =
Pr(x | y = c) Pr(y = c)
PC
k=1 Pr(x | y = k) Pr(y = k)
We then classify a sample x into class: argmaxc Pr(y = c | x).
Training.
We estimate the class-specific mean and shared covariance matrix from the training data. Let
1yi=c denote an indicator function that returns 1 if the i-th training example belongs to class c and 0
otherwise. Let πc be the prior Pr(y = c) for class c. To simplify notation, let θ denote the parameters
(µ1, . . . , µC, Σ, π1, . . . , πC).
The likelihood of data is given as:
L(θ) = Pr(X; θ) =
N
Y
i=1
C
Y
c=1
Pr(xi|yi = c)1yi=c Pr(yi = c)1yi=c
By maximizing L with respect to the parameters θ, we find the maximum likelihood estimate of the
parameters as:
πc =
PN
i=1 1yi=c
N
µc =
PN
i=1 1yi=cxi
PN
i=1 1yi=c
(1)
Σ = 1
N
C
X
c=1
N
X
i=1
1yi=c(xi −µc)(xi −µc)T
(2)
The class prior πc is the proportion of training examples that belong to the class c. The class-specific
mean vector µc is the mean of the features of the class c. The shared covariance matrix Σc is the weighted
average of the covariance matrix of every class.
Prediction.
We can classify a sample x by finding the class c that maximizes the class posterior Pr(y =
c | x). After maximizing the log-posterior and dropping terms common to all classes, we obtain the classifi-
cation function:
f(x) = argmax
c
ln πc −1
2(x −µc)T Σ−1(x −µc)
We can simplify f by expanding the second argmax term, exploiting the symmetry of Σ, and dropping terms
common to all classes:
f(x) = argmax
c
aT
c x + bc
(3)
where ac = Σ−1µc and bc = ln πc −1
2µT
c Σ−1µc.
Database Perspective.
We next show how to compute the aggregates needed to estimate the LDA param-
eters: πc, µc, and Σ. Let Nc denote the number of training examples with class c, that is, Nc = PN
i=1 1yi=c.
The SUM(1) aggregate counts the number of examples in the training dataset, while SUM(1) group by Y counts
the number of examples per class. These aggregates suffice to calculate the prior πc = Nc
N for each class c.
To compute the class-specific mean vectors µc, we also need a batch of aggregates SUM(Xi) group by Y for
each feature attribute Xi, where i ∈[m].
To compute the shared covariance matrix, we first rewrite the expression from Equation (2) considering
that PN
i=1 1yi=cxi = Ncµc:
Σ = 1
N
C
X
c=1
N
X
i=1
1yi=cxixT
i −1
N
C
X
c=1
NcµcµT
c
8

---

The first term sums up the class-specific cofactor matrices computed over disjoint subsets of the training
datasets. This summation computes the normalized cofactor matrix
1
N (X-Y )T X-Y , where X-Y is the pro-
jection of X without the target attribute Y .
We can compute all the required aggregates using one database aggregate query over the generalized
covariance ring:
SELECT SUM(λcon(X1) * . . . * λcon(Xm) * λcat(Y)) FROM Xdataset
where λcon and λcat are the lifting functions for the generalized covariance ring. Here, we assume that all
input features are continuous. The query returns a triple (N, s, Q) of aggregates. The matrix Q of size
(m + 1) × (m + 1) encodes the following aggregates as relations (we omit the symmetric lower part of Q):


SUM(X1*X1)
· · ·
SUM(X1*Xm)
SUM(X1) group by Y
...
...
...
SUM(Xm*Xm)
SUM(Xm) group by Y
SUM(1) group by Y


Using the computed triple of aggregates, we can now calculate the maximum likelihood estimates of the
LDA parameters as:
Nc = Q(m+1,m+1)(c)
µc =
[Q(1,m+1)(c) · · · Q(m,m+1)(c)]T
Nc
πc = Nc
N
Σ = 1
N Q(1...m, 1...m) −1
N
C
X
c=1
NcµcµT
c
where Q(1...m, 1...m) is the upper-left submatrix of Q of size m × m.
When a feature attribute Xi is categorical, we use λcat(Xi) in the query computing the cofactor aggre-
gate. A user-defined function extracts the computed parameters into real-valued matrices and evaluates the
classification function from Equation (3).
4
MICE with Computation Sharing
The MICE algorithm iteratively trains models one after the other. During each iteration, for each attribute
with missing data, the algorithm trains a model over the subset of data where the target attribute is not
missing. The MICE algorithm from Section 2 retrains models from scratch, discarding previous computations.
We next present our improvements over this approach.
In-Database ML. We start by incorporating in-database learning into the MICE algorithm. We opt
for stochastic linear regression and linear discriminant analysis as the models for imputing continuous and
categorical data.
These models are efficiently trainable and compute the cofactor matrix XT X during
training, allowing for further optimizations.
Figure 2a visualizes this approach. After the initial imputation,
for the attribute A with missing data, we compute the cofactor matrix over the subset of records with observed
(non-missing) A values, train a model, and impute the missing A values. The same steps are repeated for
other incomplete attributes.
This approach benefits from faster training of individual models but still computes the cofactor matrix
over the observed data for each incomplete attribute, in each iteration. When the fraction of missing values
is low, as often the case in practice, recomputing the cofactor matrix due to small changes is unnecessarily
expensive.
Incremental Maintenance of Cofactor Matrices.
We can improve the previous approach using
incremental computation. We precompute the cofactor matrix over the observed data for each incomplete
attribute once.
When new imputations are created, we maintain each cofactor matrix by adjusting the
contribution of the affected records before and after the imputation.
We exploit here that the cofactor
aggregates are ring values supporting + and −.
9

---

(a) MICE with in-database ML
(b) MICE with in-database ML and computation sharing
Figure 2: Two improvements of the MICE algorithm. Colored blocks with the same color in both figures
contain the same data.
The drawback of this approach is that it stores and maintains multiple cofactor matrices. Every time
imputed values are updated for one attribute, each of the cofactor matrices might be affected due to the
overlap among the datasets used for their computation.
Shared Computation of Cofactor Matrices.
We next present two optimizations designed to boost
the performance of MICE by enabling computation sharing across iteration. The first optimization targets
datasets with low missing rates, while the second optimization applies to both low and high missing rate
datasets.
(1) Shared Computation with Low Missing Rates.
In practice, the observed data is often much larger than
the missing data. We leverage this observation to compute one global cofactor matrix over the entire (initially
imputed) data once, and use it to derive the cofactor matrix for each attribute on-the-fly, by scanning only
the missing data. This approach effectively moves the expensive computation over the observed data outside
the iteration loop.
Algorithm 2 shows our MICE algorithm with computation sharing.
After the initial imputation, we
compute the global cofactor matrix over the imputed dataset ˜X (Line 2). To compute the cofactor matrix
for an attribute Xi, we remove the contribution of the records with missing Xi-values, ˜Xi=miss, from the
global cofactor matrix since these records are not used for training (Lines 5-6). After training the model and
imputing new values, we update the global matrix to account for the new imputations (Lines 9-10), making
it ready for the next iteration. Figure 2b visualizes this approach. The colored blocks denote the same data
in the two approaches, with and without sharing the cofactor matrix computation.
(2) Shared Computation with Data Partitioning. We can further accelerate the cofactor matrix computa-
tion by partitioning the data into partitions based on the number of missing values in each record. We start
with two observations. First, the records containing no missing values are part of every training dataset and
contribute equally to the cofactor matrix computed in each iteration. Thus, we can form a partition of such
records, precompute their contribution once, and reuse it in every iteration. Second, the records containing
missing values in all incomplete attributes are not part of any training dataset, thus we can skip such records
during model training and only impute them at the end of each iteration.
For datasets with low missing rates, we want to ensure fast access to (small) incomplete data, ˜Xi=miss,
needed by Algorithm 2.
Before starting the imputation, we split each dataset into four partitions: one
stores records without missing values, one stores records with only missing values, one stores records with
exactly one missing value, and one stores records with at least two missing values. We further recursively
partition the third partition containing records with one missing values into subpartitions, one for each
incomplete attribute. Then, accessing the records with missing values in a given attribute requires scanning
two partitions: the subpartition of the given attribute and the third (‘overflow’) partition. When the fraction
of missing values is low, both of these partitions tend to be small, allowing fast access to the needed records.
10

---

Algorithm 2: MICE with computation sharing
Input
:
X
incomplete dataset with attributes X1, ..., Xm
mattrs
indices of incomplete attributes
Output:
˜X
imputed dataset
1 ˜X ←X with initial imputations for all missing values
2 C ←˜X
T ˜X
3 repeat
4
foreach i ∈mattrs do
5
∆C ←( ˜Xi=miss)T ˜Xi=miss
6
Ctrain ←C −∆C
7
θ ←Train(cofactor = Ctrain, target = Xi)
8
˜X ←Predict(data = ˜Xi=miss, target = Xi, model = θ)
9
∆C ←( ˜Xi=miss)T ˜Xi=miss
10
C ←Ctrain + ∆C
11
end
12 until stopping condition;
For datasets with high missing rates, we want to ensure fast access to (small) observed data, ˜Xi=obs, to
speed up the model training in Algorithm 1. The partitioning strategy in this case is the complete opposite
of that in the case with low missing rates: partitioning uses the same criteria but based on the number of
observed (not missing) values of incomplete attributes in each record. The partition containing records with
only observed values is used to precompute a partial cofactor aggregate once, outside the iteration loop. The
rest of the training dataset for an incomplete attribute contains records from two partitions: one subpartition
storing records with exactly one observed value for the given attribute and one partition storing records with
at least two observed values. The model training in each iteration now needs to scan only these two partitions,
often much smaller than the entire dataset when its missing rate is high.
5
Implementation
We next discuss how to implement our data imputation methods in existing DBMSs. We opt for an in-
database implementation instead of building a specialized tool for several reasons:
• Providing a solution integrated with widely-used DBMSs facilitates its adoption, eliminating the need
for adding yet another tool to already complex data pipelines.
• DBMSs are mature systems with robust mechanisms for handling large data and recovering from
failures, in contrast to data imputation implementations in tools such as R.
• DBMSs offer highly-optimized techniques for query evaluation, including parallel execution, allowing
us to focus on more high-level aspects of the imputation process.
We implemented our imputation methods in PostgreSQL and DuckDB, two open-source database systems
with row-oriented and column-oriented storage models, respectively. Our approach can be implemented in
any other database system that supports defining custom data types of variable size and aggregate functions
operating over values of these types. Our implementation assumes that categorical values are encoded as
integers; if they are not, we can map categorical values to integers in a preprocessing step.
5.1
In-Database ML Implementation
We provide libraries in PostgreSQL and DuckDB for in-database training of ridge linear regression, stochastic
linear regression, and LDA models, and for generating predictions under each model.
The core library
component is the implementation of the generalized cofactor ring. We refer to this data structure as Triple.
11

---

In PostgreSQL, Triple is a custom data type of variable size. A Triple value is a struct that comprises an
array storing the numerical aggregates over continuous attributes, followed by an array storing the relational
aggregates over continuous and categorical attributes. The struct occupies a contiguous memory chunk with
no external pointers to allow for fast allocation/de-allocation.
DuckDB, instead, offers native support for nested data types such as arrays and structs, allowing for
a simpler Triple implementation based on using an array of numerical values and an array of key-value
structs.
In both cases, we implement the ring operations, addition, subtraction, and multiplication, over Triple
values, as user-defined functions. Instead of the lifting functions λcon and λcat, we provide a more efficient
bulk version λ that takes as input a list of continuous attributes and a list of categorical attributes and maps
their values to a Triple aggregate at once, avoiding triple multiplication.
SELECT SUM( λ( [Xi1, . . . ,Xik], [Xj1, . . . ,Xjl] )) FROM Xdataset
DuckDB supports a faster way of computing Triples via a custom aggregate operator that operates
directly over attribute values:
SELECT SUM_TRIPLE(Xi1, . . . ,Xik, Xj1, . . . ,Xjl) FROM Xdataset
In the implementation, the aggregate operator SUM TRIPLE takes as input a list of value vectors of a fixed size,
together with their type (continuous or categorical), and aggregates these values to a Triple in bulk, rather
than one record at a time.
Factorized Computation of the Cofactor Matrix. When computing the cofactor matrix over joins,
we can exploit the algebraic properties of the cofactor ring to achieve factorized evaluation, that is, compute
partial Triple values over individual tables and then combine these triples to produce the final result.
Example 4. Consider relations R(A, B) and S(B, C, D), where C is categorical and the others are continu-
ous. We can compute the cofactor triple for A, C, and D over the join of R and S as:
SELECT SUM( λ( [A,D], [C] )) FROM R, S WHERE R.B = S.B
The factorized query computes partial triples before the join:
SELECT SUM(t1.T * t2.T) FROM
(SELECT B, SUM(λ( [A], [ ] )) AS T FROM R GROUP BY B) AS t1,
(SELECT B, SUM(λ( [D], [C] )) AS T FROM S GROUP BY B) AS t2
WHERE t1.B = t2.B
This optimization often pays off when the domain of B is small.
□
In the current implementation, we refactor input queries like in Example 4 before passing them to the
query optimizer. As future work, we aim to enable this optimization in the query optimizer.
The Triple value computed over the training dataset is passed to the functions for model training and
prediction, along with other parameters such the index of the target attribute, learning rate, and regular-
ization factor. LDA relies on LAPACK routines [5] to solve systems of linear equations and perform matrix
operations, necessary in model training and prediction.
5.2
In-Database MICE Implementation
We implemented our imputation methods as driver functions in PL/pgSQL for PostgreSQL and in C++ for
DuckDB. We provide three functionally-equivalent implementations of the MICE algorithm:
1. Baseline implements the logic from Algorithm 1 using the generalized cofactor ring, without any
partitioning strategy;
2. Low implements the shared cofactor computation from Algorithm 2 using the partitioning strategy for
datasets with low missing rates;
12

---

3. High implements the shared cofactor computation using the partitioning strategy for datasets with
high missing rates.
Each implementation creates a copy of the dataset that needs to be imputed in the preprocessing step,
outside the iteration loop. The Baseline version repeatedly scans the entire copy to train models over
subsets of records with complete values for different incomplete attribute. The other two versions create a
partitioned copy and compute partial cofactor aggregates in the preprocessing step, as discussed in Section 4.
This partitioning can accelerate the retrieval of matching records, reducing the per-iteration cost at the
expense of increasing the preprocessing cost.
Reducing Update Overhead. Both PostgreSQL and DuckDB use multi-version concurrency control
(MVCC) to maintain data consistency. When imputing new values using an UPDATE command, MVCC creates
new versions of the affected objects. As the algorithm proceeds iteratively, updating imputed values leads to
increasingly many obsolete versions, causing significant overheads and eventually becoming the bottleneck in
our implementation.
A potential solution is to store each attribute’s imputed values in another table, re-created every time
these values are updated. The main drawback of this solution, however, is that it requires joining all tables
of imputed values every time a model is trained.
We reduce the update overhead with the following optimizations:
• Swapping columns (DuckDB). We changed the internals of DuckDB to support pointer-based column
swaps between tables (70 LOC), inspired by a similar approach from prior work [23]. We create a
temporary table with one column containing new imputed values and then move this column in place
of an existing one in the corresponding table partition.
• Recreating subpartitions (DuckDB & PostgreSQL). The subpartitions storing records with one missing
value are completely changed in each iteration. In PostgreSQL, we recreate such subpartitions with
new imputations but update in-place other affected partitions. In DuckDB, we always swap a fresh
column with new imputations into affected partitions.
• Enabling heap-only-tuples (PostgreSQL). This optimization in PostgreSQL aims to store multiple ver-
sions of one row on the same page, reducing update overheads. For partitions updated in-place (e.g.,
those storing records with at least two missing values), we reduce their page fill factor to 75%.
• Using shorter transactions (PostgreSQL). The vacuum processes in PostgreSQL can only remove row
versions that are older than any currently active transaction. Repeatedly updating the same rows in a
single transaction leads to accumulating obsolete versions and degrading performance. Thus, we start
a new transaction on imputing each attribute.
6
Experiments
We compare our techniques for in-database learning and data imputation in DuckDB and PostgreSQL against
the following systems: Apache SystemDS [7], a data science platform for large-scale data analysis and machine
learning; Apache MADlib [6], a PostgreSQL library for in-database machine learning; MindsDB [47], a layer
on top of database systems for training machine learning models; and five alternative imputation methods
implemented in Python.
Our experimental findings can be summarized as follows:
• Using the cofactor ring for computing cofactor aggregates improves the training performance by up to
6x, regardless of the dataset and DBMS. Factorized computation of the cofactor aggregates can further
improve the performance up to 12x if the denormalized database is highly redundant.
• When imputing a single table, our DuckDB implementation outperforms the fastest competitor, Sys-
temDS, in terms of per-iteration cost by 86x to 346x as the rate of missing values ranges between 5%
and 80%. The imputation time scales linearly with the number of incomplete attributes.
13

---

• When imputing missing values over a normalized dataset, employing factorized evaluation can be faster
than denormalizing the dataset before imputation by up to 6 times in PostgreSQL and up to 1.7 times
in DuckDB.
• Our MICE implementations are competitive with or outperform state-of-the-art imputation methods
in terms of imputation quality, while offering up to two orders of magnitude faster imputation, under
various missing rates and patterns.
Experimental Setup. We run all experiments on a server with 2 x AMD EPYC 7302 16-Core Processor,
64 threads, 512 GB RAM running Ubuntu 20.04. We use PostgreSQL 12.12 and DuckDB 0.8.1. We run each
experiment 3 times with a timeout of 200 minutes and report averaged results, unless stated otherwise.
Datasets.
We consider three real-world datasets: (1) Flight Delays and Cancellations [51] contains
information about U.S. flights. It consists of 3 tables, 60M rows and 31 columns, of which 5 are categorical.
(2) Retailer [64] contains historical inventory data of stores at different locations. It consists of 5 tables
arranged in a snowflake schema, 84M rows and 25 columns, of which 4 are categorical. (3) Taiwan’s Air
Quality [2] contains information about Taiwan’s air quality in the years 2016-2021. It is a single table with
3.5M rows, 11 numerical columns, and 6% missing values.
The Flight and Retailer datasets are complete, containing no missing values. These datasets serve as
the foundation for our benchmarks, where we randomly remove different quantities of values to evaluate
performance under various scenarios.
6.1
In-Database Learning
We evaluate the performance of training a linear regression model inside DuckDB and PostgreSQL when the
training dataset is formed by joining the input tables. We consider three different evaluation approaches
for DuckDB and PostgreSQL. The baseline approach uses standard SQL with scalar SUM aggregates to
compute the cofactor matrix, the second approach adopts the cofactor ring (ring), and the third approach
additionally includes factorized evaluation (ring + fact). We also compare our library with MADlib. We
run this experiment over the Flight and Retailer datasets considering only continuous and both continuous
and categorical attributes. MADlib assumes a single table is available, therefore, we need to precompute
and materialize the joined relation. We are unable to compute the cofactor aggregates with a standard SQL
query over categorical attributes, because the number of aggregates after one-hot encoding exceeds the limits
in PostgreSQL and DuckDB.
Figure 3 shows the performance of these approaches.
In the case of continuous-only attributes, the
adoption of the ring structure leads to 4 to 6 times higher performance, regardless of the DBMS used due
to the compact representation of the cofactor aggregates. While the addition of categorical attributes slows
down the computation, the performance improvement over MADlib is even higher, as one-hot encoding in
MADlib takes 450s for Flight and 980s for Retailer, in addition to materialization of the joined result.
Computing the cofactor aggregates using factorized evaluation affects the performance differently ac-
cording to the dataset used. In DuckDB, training a model over the normalized Retailer dataset improves
the performance by 8.7x with continuous-only attributes and by 1.4x with mixed attributes compared with
non-factorized evaluation. The smaller speedup with categorical attributes is due to increased memory man-
agement pressure caused by resizing the data structures that store categorical values. With the Flight dataset,
factorized evaluation leads to a higher runtime because joining the input tables does not produce many re-
dundant values: the fact table already contains most of the data, with the other tables being 15% of its size.
In Retailer, joining the input tables brings more redundancy as the fact table has only 4 attributes, with the
other tables being less than 1% of its size. The computation saved by factorized evaluation is therefore more
pronounced in Retailer than Flight.
6.2
Single-Table Imputation
We compare our three MICE implementations from Section 5.2 – Baseline, Low, and High – in PostgreSQL
and DuckDB against SystemDS, MADlib, and MindsDB, measuring the time required to execute one round of
the MICE algorithm, that is, impute values in each incomplete attribute once. Since every competitor except
14

---

DuckDB + ring + fact.
DuckDB + ring
DuckDB
Postgres + ring + fact.
Postgres + ring
Postgres
DuckDB + ring (prejoined)
DuckDB (prejoined)
Postgres + ring (prejoined)
Postgres (prejoined)
MADlib
0
50
100
150
200
Time (s)
8.8
2.2
9.8
20.1 20.7
89.2
6.1
12.0
143.1
205.2
222.0
Train
Compute cofactor
Materialize join
(a) Flight dataset (cont. only)
DuckDB + ring + fact.
DuckDB + ring
DuckDB
Postgres + ring + fact.
Postgres + ring
Postgres
DuckDB + ring (prejoined)
DuckDB (prejoined)
Postgres + ring (prejoined)
Postgres (prejoined)
MADlib
0
50
100
150
200
250
300
350
400
Time (s)
0.6
5.2
17.1 10.0
38.3
240.2
15.1 25.2
202.1
424.5
342.0
Train
Compute cofactor
Materialize join
(b) Retailer dataset (cont. only)
DuckDB + ring + fact.
DuckDB + ring
Postgres + ring + fact.
Postgres + ring
DuckDB + ring (prejoined)
Postgres + ring (prejoined)
MADlib
0
100
200
300
400
500
600
700
800
Time (s)
23.4
3.5
38.7
50.0
7.9
157.7
843.0
Train
Compute cofactor
1-HOT
Materialize join
(c) Flight dataset (cont. & cat.)
DuckDB + ring + fact.
DuckDB + ring
Postgres + ring + fact.
Postgres + ring
DuckDB + ring (prejoined)
Postgres + ring (prejoined)
MADlib
0
250
500
750
1000
1250
1500
1750
Time (s)
7.4
10.6
24.2
102.3
18.9
262.1
1720.0
Train
Compute cofactor
1-HOT
Materialize join
(d) Retailer dataset (cont. & cat.)
Figure 3: Breakdown of execution time for training a linear regression model in DuckDB, PostgreSQL,
and MADlib over the join of the input tables from the Retailer and Flight datasets, with continuous only
and continuous + categorical attributes. The ring variants use the covariance ring, fact uses factorized
evaluation, and prejoined materializes the join result first.
ours assumes a single table as input, we precompute the join result for the Flight and Retailer datasets. We
randomly remove different quantities of missing values from 7 columns in each dataset to measure their impact
on the runtime.
SystemDS and MADlib implement MICE with linear regression and logistic regression.
Both implementations produce predictions similar to ours obtained using stochastic linear regression and
LDA; the difference of RMSE on Flight and Retailer is less than 1% after convergence.
MindsDB uses
gradient boosting decision trees (LightGBM) for MICE.
Figure 4 reports the time required to run a single round of MICE over 7 columns (in blue) and the
preprocessing time (in orange) over Flight and Retailer when the percentage of missing values varies between
5% and 80%. Our baseline implementations in DuckDB and PostgreSQL achieve lower per-iteration costs
than all other competitors on both datasets, regardless of the fraction of missing values.
Compared to
the leading competitor, SystemDS, our DuckDB baseline is increasingly faster per iteration as the missing
rate increases, ranging from 86x to 176x on Flight and from 106x to 346x on Retailer. The performance
improvement is due to several reasons. All other competitors perform one-hot encoding in the preprocessing
stage, increasing the size of the training dataset. SystemDS and MADlib use the direct solve method for
linear regression, computing the cofactor matrix and its inverse. MindsDB executes expensive training of
decision trees for every column. Our methods, instead, use gradient descent for regression, computing one
compound aggregate in one pass over the dataset, without the need for prior one-hot encoding. DuckDB
15

---

DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
19.3
4.2
19
4.6
13
12.4
155
107
156
206
133
487
140
1067
566
3070
161
11838
5% missing values
Iteration cost
Preprocessing cost
(a) Flight 5% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
18.3
4.9
14.6
8.9
12.1
12.2
157
212
142
365
124
524
145
1272
570
3153
166
11833
10% missing values
Iteration cost
Preprocessing cost
(b) Flight 10% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
18
6.5
14.5
9.4
12.4
12.6
161
461
134
634
121
657
143
1462
572
3216
162
11837
20% missing values
Iteration cost
Preprocessing cost
(c) Flight 20% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
16.6
10
16.7
6.3
12.1
11.5
195
1075
124
945
140
947
144
1567
546
4155
167
11832
40% missing values
Iteration cost
Preprocessing cost
(d) Flight 40% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
14.9
16.1
15.2
7.4
12.9
10.1
212
1494
152
1200
162
1246
140
1695
552
4387
163
11836
60% missing values
Iteration cost
Preprocessing cost
(e) Flight 60% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
15.4
20.2
16.4
6.4
12.9
10.2
284
1902
180
1390
266
1659
145
1796
552
4587
162
11837
80% missing values
Iteration cost
Preprocessing cost
(f) Flight 80% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
21.6
5.8
20.4
9.3
20.7
26
286
221
187
399
164
993
150
2770
1099
9155
172
11828
5% missing values
Iteration cost
Preprocessing cost
(g) Retailer 5% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
22.2
8.3
20.5
13.1
18.7
26
293
463
190
717
168
1107
149
2922
1272
10033 178
11822
10% missing values
Iteration cost
Preprocessing cost
(h) Retailer 10% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
25.8
14.1
21.4
18
17.7
23.4
301
991
190
1249
187
1354
151
3049
1162
10219 177
11823
20% missing values
Iteration cost
Preprocessing cost
(i) Retailer 20% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
24.9
22.4
20.9
14.6
17.6
17.7
312
2843
198
2640
199
2656
150
3370
1667
10111 174
11826
40% missing values
Iteration cost
Preprocessing cost
(j) Retailer 40% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
23.5
24.8
11.7
22
15.1
19
306
3614
188
3010
189
3207
146
3509
1667
10333
182
11818
60% missing values
Iteration cost
Preprocessing cost
(k) Retailer 60% missing
DuckDB Low
DuckDB High
DuckDB Baseline
Postgres Low
Postgres High
Postgres Baseline
SystemDS
MADlib
MindsDB
0
2000
4000
6000
8000
10000
12000
Time (s)
27.1
25.2
10.1
20.3
10.7
18.7
300
4082
197
2569
191
3692
155
3698
1667
10333
184
11816
80% missing values
Iteration cost
Preprocessing cost
(l) Retailer 80% missing
Figure 4: Single-table imputation using MICE. The time needed to run a single round of MICE over Flight
and Retailer with different percentages of missing values, divided into preprocessing time (done once) and
iteration time (repeated every round). The baseline, low, and high versions denote our implementations
described in Section 5.2. The red labels indicate a timeout.
16

---

1
2
4
6
Number of columns
0
50
100
150
200
250
300
350
Time (s)
5% missing values
1
2
4
6
Number of columns
20% missing values
Initial cofactor
Cofactor partition 1
Cofactor partition 2
Impute partition 1
Impute partition 2
(a) PostgreSQL
1
2
4
6
Number of columns
0
1
2
3
4
5
6
7
Time (s)
5% missing values
1
2
4
6
Number of columns
20% missing values
Initial cofactor
Cofactor partition 1
Cofactor partition 2
Impute partition 1
Impute partition 2
(b) DuckDB
Figure 5: Single-table imputation using the Low implementations with varying numbers of incomplete
attributes. The runtime for a single round of MICE on the Flight dataset with randomly generated 5% and
20% of missing values in each column.
further benefits from columnar-vectorized aggregation and inexpensive updates via column swapping. The
performance advantage of our PostgreSQL baseline over SystemDS decreases with more missing values due
to increased update overheads.
SystemDS and DuckDB exploit the full parallelism of 64 threads, while
PostgreSQL does sequential updates and limits its scan parallelism to 8 threads for the two datasets.
Figure 4 also shows the effectiveness of our computation sharing techniques (cf. Section 4). The Low
implementation, tailored to datasets with low missing rates, reduces the per-iteration baseline cost by 3x in
DuckDB and 4.5x in PostgreSQL on the Flight dataset with 5% of missing values, at the expense of increasing
the one-off preprocessing costs; similar holds on Retailer (cf. Figures 4a and 4g). The results evidence that the
Low implementation pays off on datasets containing up to 20% missing values. The High implementation,
although initially designed for datasets with high missing rates, outperforms the baseline in both low and
high missing rate scenarios: in the former, this is mainly due to precomputing partial cofactor aggregates
over complete records outside the iteration loop, which reduces the iteration cost by 2.7x in DuckDB and
2.4x in PostgreSQL on Flight, and similarly on Retailer; in the latter, this is also due to processing data
partitions that are smaller with more missing values, which makes the model training less expensive.
Varying the Number of Incomplete Attributes. We measure the impact of the number of attributes
with missing values on the performance of our Low implementations. Figure 5 reports the breakdown of the
runtime for both PostgreSQL and DuckDB over the Flight dataset as the number of incomplete attributes
varies between 1 and 6. The runtime is split into five components: the initial time to compute the cofactor
aggregates over the entire table, and, for each of the two affected partitions with missing values, the time
needed to compute the cofactor aggregates in that partition, and the time needed to update the imputed
values in that partition.
17

---

DuckDB ring + fact
DuckDB ring
Postgres ring + fact
Postgres ring
0
50
100
150
200
250
300
Time (s)
10.3
17.0
34.5
283.0
5% missing values
DuckDB ring + fact
DuckDB ring
Postgres ring + fact
Postgres ring
10.6
17.5
42.4
293.5
10% missing values
DuckDB ring + fact
DuckDB ring
Postgres ring + fact
Postgres ring
10.6
18.4
66.2
317.0
20% missing values
Impute
Compute delta cofactor
Compute initial cofactor
Materialize join
(a) Retailer dataset
DuckDB ring + fact
DuckDB ring
Postgres ring + fact
Postgres ring
0
100
200
300
400
500
600
700
Time (s)
38.2
12.8
162.4
207.9
5% missing values
DuckDB ring + fact
DuckDB ring
Postgres ring + fact
Postgres ring
45.8
12.8
416.9
387.6
10% missing values
DuckDB ring + fact
DuckDB ring
Postgres ring + fact
Postgres ring
50.7
14.6
700.0
700.2
20% missing values
Impute
Compute delta cofactor
Compute initial cofactor
Materialize join
(b) Flight dataset
Figure 6: Imputation over normalized data using the Low implementations with materialization of the join
result and with factorized evaluation that avoids the join materialization. The runtime for a single round of
MICE with DuckDB and PostgreSQL over Retailer and Flight with different percentages of missing values,
randomly generated in the fact table of each dataset.
For both DBMSs, the figure shows a linear increase in the runtime with respect to the number of attributes
with missing values, where the missingness ratio dictates the increase quantity. A higher number of columns
with missing values also increases the size of the partition containing rows with at least two missing values,
prolonging also the cofactor computation and imputation time.
PostgreSQL and DuckDB have different bottlenecks: in the former, updating imputed values is the
slowest phase, while in the latter, it is the computation of cofactor aggregates. This is due to their different
architectures. PostgreSQL uses a row-based engine with MVCC, which despite our optimizations, still causes
significant overheads during the execution of update queries. DuckDB, instead, adopts a column-oriented
approach, which we exploit to implement lightweight column swapping to instantiate new imputed values.
6.3
Imputation over Normalized Data
We now consider the case when the dataset is normalized, and the imputation takes into account the attributes
from all tables. We compare the performance of our Low implementations running over the materialized join
result and its factorized version that pushes the aggregate computation past the joins. We use the Flight and
Retailer datasets as they consist of multiple tables, and randomly generate missing values in the fact table
18

---

0.0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
R2
Missforest
Python MICE
Miracle
DuckDB MICE
Postgres MICE
MIDASpy
GAIN
Mean
(a) R2
0.00
0.05
0.10
0.15
0.20
RMSE
Missforest
Python MICE
Miracle
DuckDB MICE
Postgres MICE
MIDASpy
GAIN
Mean
(b) RMSE
0
1000
2000
3000
4000
Time (s)
1109.2
192.1
1821.3
6.2
54.1
4574.7
199.6
0.8
Missforest
Python MICE
Miracle
DuckDB MICE
Postgres MICE
MIDASpy
GAIN
Mean
(c) Imputation time
Figure 7: Imputation quality on the Air Quality dataset. The quality of a regression model that predicts the
air quality index given attributes with missing values, measured by R2 (higher is better) and RMSE (lower
is better). The time needed to impute the dataset using different imputation approaches.
only so that in both cases the algorithm generates the same imputations; otherwise, joining incomplete tables
can create copies of the same missing value, which might be imputed differently by the two approaches.
Figure 6 shows the performance of the two approaches over a single MICE round for Retailer and Flight,
consisting of 1 and 7 attributes with missing values, respectively. As previously discussed, in the Flight
dataset, joining its tables does not introduce many redundant values, thus imputing values over a normalized
database is slower than using the joined table. On the Retailer dataset, instead, we get the opposite result.
As the joined result is more redundant, imputing values directly over normalized relations in PostgreSQL
is from 4.8 to 8.2x faster than using the joined result, mainly because of the long time to materialize the
joined table and compute the cofactor aggregates over redundant values. The imputation time is also faster:
PostgreSQL writes a full row when a new value is imputed, and updating a table with just 4 attributes
is faster than updating 25 attributes of the joined table. DuckDB also imputes faster over the normalized
dataset than over the joined dataset, albeit with a smaller improvement of 1.7x than PostgreSQL, mainly
due to faster in-memory join materialization and aggregation.
6.4
Imputation Quality
We compare different imputation methods in terms of imputation quality, measured as the performance of a
linear regression model trained over imputed data. We consider the following methods: MICE DuckDB and
MICE PostgreSQL, our MICE implementations (Low versions); MICE Python, the MICE implementation
from scikit-learn using linear and logistic regression; MissForest [65], which uses random forests; GAIN [69],
which uses generative adversarial networks; MIRACLE [35], which uses causally-aware refinements, MI-
DASpy [37], which uses autoencoders; and mean/mode imputation. We use the Python implementation of
the competitors from HyperImpute [25]. We use 5 iterations for the MICE methods.
Figure 7 shows the imputation quality over the Taiwan’s Air Quality dataset, where the task is to predict
the air quality index given its pollutants. Although the dataset contains only 6% of missing values, mean
imputation performs significantly worse than the other methods, reducing the R2 score of the regression
model by 0.05 and increasing its root mean squared error (RMSE) by 0.05. MICE outperforms GAIN and
achieves similar performance to MissForest, MIDASpy, and MIRACLE. Figure 7c reports the imputation
time of each method. MICE DuckDB is faster than GAIN by 32x, MICE Python by 38x, MIDASpy by 778x,
and only 5.4 seconds slower than mean imputation in Python.
Missing Patterns. We analyze imputation quality under three widely-used mechanisms for injecting
missing values: missing completely at random (MCAR), missing at random (MAR), and missing not at
random (MNAR) [40]. To allow all competitors to finish within a 30-minute timeout, we restrict the Flight
19

---

Pattern Method
Missing Rate
Imp. Time
0.05
0.1
0.2
0.4
0.6
0.8
secs
norm
MCAR
MICE DuckDB
0.180 ± 0.009 0.181 ± 0.002 0.161 ± 0.005 0.175 ± 0.016 0.173 ± 0.012 0.175 ± 0.021
5.4
1.0
MICE Python
0.180 ± 0.005 0.183 ± 0.002 0.158 ± 0.003 0.174 ± 0.010 0.172 ± 0.012 0.173 ± 0.018
189.6
34.9
Mean
0.286 ± 0.009 0.359 ± 0.009 0.473 ± 0.008 0.642 ± 0.025 0.774 ± 0.012 0.889 ± 0.012
0.4
0.1
MissForest
0.235 ± 0.004 0.275 ± 0.011 0.333 ± 0.005 0.431 ± 0.021 0.476 ± 0.005 0.461 ± 0.070
407.5
75.0
GAIN
0.286 ± 0.038 0.350 ± 0.001 0.460 ± 0.015 0.633 ± 0.019 0.756 ± 0.020 0.864 ± 0.129
82.0
15.1
MIRACLE
0.179 ± 0.003 0.180 ± 0.001 0.175 ± 0.003 0.169 ± 0.002 0.166 ± 0.001 0.168 ± 0.002
788.4
145.1
MAR
MICE DuckDB
0.176 ± 0.021 0.175 ± 0.043 0.268 ± 0.013 0.336 ± 0.078 0.331 ± 0.009 0.344 ± 0.068
5.5
1.0
MICE Python
0.174 ± 0.016 0.172 ± 0.039 0.266 ± 0.012 0.337 ± 0.071 0.339 ± 0.012 0.342 ± 0.038
186.6
34.2
Mean
0.487 ± 0.035 0.597 ± 0.020 0.723 ± 0.001 0.845 ± 0.005 0.913 ± 0.002 0.958 ± 0.004
0.4
0.1
MissForest
0.367 ± 0.003 0.431 ± 0.013 0.510 ± 0.001 0.557 ± 0.095 0.499 ± 0.006 0.486 ± 0.081
415.5
76.1
GAIN
0.384 ± 0.137 0.485 ± 0.092 0.674 ± 0.129 0.868 ± 0.133 0.917 ± 0.179 0.923 ± 0.001
81.0
14.8
MIRACLE
0.191 ± 0.025 0.217 ± 0.036 0.257 ± 0.007 0.397 ± 0.077 0.538 ± 0.044 0.632 ± 0.536
785.6
143.9
MNAR
MICE DuckDB
0.194 ± 0.011 0.193 ± 0.018 0.199 ± 0.037 0.280 ± 0.023 0.203 ± 0.041 0.231 ± 0.068
5.5
1.0
MICE Python
0.192 ± 0.008 0.195 ± 0.021 0.184 ± 0.029 0.279 ± 0.021 0.210 ± 0.043 0.229 ± 0.053
186.2
33.9
Mean
0.289 ± 0.012 0.365 ± 0.034 0.475 ± 0.004 0.651 ± 0.065 0.779 ± 0.039 0.893 ± 0.039
0.4
0.1
MissForest
0.239 ± 0.014 0.280 ± 0.010 0.347 ± 0.073 0.436 ± 0.017 0.487 ± 0.045 0.490 ± 0.086
553.6
100.8
GAIN
0.284 ± 0.039 0.355 ± 0.089 0.463 ± 0.048 0.633 ± 0.058 0.759 ± 0.110 0.898 ± 0.110
79.4
14.5
MIRACLE
0.186 ± 0.007 0.191 ± 0.037 0.182 ± 0.009 0.185 ± 0.099 0.200 ± 0.099 0.223 ± 0.102
795.4
144.8
(a) Flight
Pattern Method
Missing Rate
Imp. Time
0.05
0.1
0.2
0.4
0.6
0.8
secs
norm
MCAR
MICE DuckDB
0.228 ± 0.013 0.241 ± 0.024 0.249 ± 0.029 0.254 ± 0.009 0.283 ± 0.036 0.296 ± 0.013
5.7
1.0
MICE Python
0.233 ± 0.009 0.237 ± 0.016 0.248 ± 0.026 0.252 ± 0.004 0.282 ± 0.038 0.294 ± 0.015
128.3
22.6
Mean
0.316 ± 0.015 0.382 ± 0.045 0.491 ± 0.015 0.645 ± 0.010 0.755 ± 0.022 0.841 ± 0.011
0.8
0.1
MissForest
0.267 ± 0.011 0.304 ± 0.002 0.361 ± 0.028 0.446 ± 0.001 0.519 ± 0.046 0.558 ± 0.010
212.7
37.5
GAIN
0.294 ± 0.003 0.357 ± 0.149 0.449 ± 0.103 0.571 ± 0.128 0.673 ± 0.253 0.735 ± 0.010
81.0
14.3
MIRACLE
0.268 ± 0.044 0.320 ± 0.102 0.378 ± 0.113 0.611 ± 0.133 0.749 ± 0.215 0.791 ± 0.271
995.1
174.5
MAR
MICE DuckDB
0.226 ± 0.006 0.242 ± 0.009 0.245 ± 0.023 0.261 ± 0.019 0.277 ± 0.016 0.296 ± 0.028
5.7
1.0
MICE Python
0.234 ± 0.005 0.239 ± 0.008 0.247 ± 0.019 0.260 ± 0.019 0.275 ± 0.013 0.299 ± 0.029
125.7
22.1
Mean
0.316 ± 0.022 0.384 ± 0.057 0.489 ± 0.026 0.638 ± 0.007 0.740 ± 0.028 0.841 ± 0.027
0.8
0.1
MissForest
0.268 ± 0.008 0.303 ± 0.006 0.360 ± 0.026 0.449 ± 0.029 0.520 ± 0.009 0.551 ± 0.031
227.1
39.9
GAIN
0.294 ± 0.019 0.352 ± 0.073 0.459 ± 0.025 0.595 ± 0.171 0.670 ± 0.054 0.744 ± 0.031
78.4
13.8
MIRACLE
0.251 ± 0.075 0.378 ± 0.167 0.342 ± 0.021 0.595 ± 0.219 0.783 ± 0.013 0.823 ± 0.219
984.1
173.8
MNAR
MICE DuckDB
0.227 ± 0.061 0.239 ± 0.073 0.245 ± 0.061 0.258 ± 0.069 0.279 ± 0.018 0.296 ± 0.037
5.8
1.0
MICE Python
0.232 ± 0.056 0.238 ± 0.069 0.249 ± 0.065 0.256 ± 0.064 0.279 ± 0.015 0.294 ± 0.034
127.0
22.0
Mean
0.309 ± 0.149 0.365 ± 0.176 0.468 ± 0.152 0.615 ± 0.184 0.698 ± 0.136 0.824 ± 0.191
0.8
0.1
MissForest
0.263 ± 0.081 0.296 ± 0.133 0.350 ± 0.165 0.429 ± 0.167 0.487 ± 0.021 0.539 ± 0.166
255.4
44.3
GAIN
0.283 ± 0.053 0.337 ± 0.056 0.423 ± 0.229 0.552 ± 0.280 0.656 ± 0.041 0.732 ± 0.018
78.7
13.6
MIRACLE
0.228 ± 0.075 0.256 ± 0.039 0.441 ± 0.104 0.601 ± 0.161 0.670 ± 0.159 0.850 ± 0.156
997.1
172.3
(b) Retailer
Figure 8: Imputation quality and runtime for different missing rates and patterns on the restricted Flight
and Retailer datasets. The quality is measured by the RMSE of a regression model predicting flight duration
for Flight and inventory stock for Retailer from the imputed data. The imputation times (absolute and
normalized to MICE DuckDB) are for the missing rate of 20%.
20

---

dataset to year 2015 (5M rows) and the Retailer dataset to two dates with ids 501 and 508 (1M rows). For
the former, the task is to predict flight duration given predictors (e.g., distance between airports); for the
latter, the task is to predict inventory stock given predictors (e.g., population in the area).
We use the generator from HyperImpute [25] to inject missing values in 7 attributes in each dataset. With
MCAR, we generate missing values with a uniform distribution. With MAR, the fraction of missing values
depends on flight duration in Flight and inventory stock in Retailer. With MNAR, we generate missing
values taking all 7 incomplete attributes as input for each dataset.
Figure 8 reports the performance of these imputation methods on the two restricted datasets. On the
Flight dataset, the MICE methods and MIRACLE outperform the other methods in terms of quality, achiev-
ing the lowest RMSEs under all three patterns and all missing rates. But in terms of imputation time, MICE
DuckDB is 145x faster than MIRACLE and 35x faster than MICE Python. The deep learning approaches,
GAIN and MIDASpy, generate increasingly worse imputations as the fraction of missing values increases.
Mean imputation performs the worst in terms of imputation quality in all scenarios. We observe similar
trends on the Retailer dataset in terms of MICE’s runtime performance and imputation quality.
7
Related Work
Data Imputation. Simple techniques for handling missing data, such as removing tuples with missing
values, mean/mode imputation, indicator imputation, and Last Observation Carried Forward [36], are fast but
only work under restrictive assumptions, produce biased analytics, and might distort the value distribution.
Model-based imputation aims to address these issues.
This includes approaches that learn the joint
distribution of data based on matrix completion [44], generative adversarial networks [69, 70], diffusion
models [73], autoencoders [53, 43], and the EM algorithm [40]. Discriminative approaches to data imputation
include deep denoising autoencoders [37], graph neural networks [71], and conditional modeling strategies
such as MICE [68] and MissForest [65]. Specific imputation methods are designed for particular domains,
such as time-series [8, 17, 29, 30] and non-numerical data [11]. Imputation methods can also be based on
multiple models: HoloClean [57] does broader data cleaning using statistical analysis, integrity constraints,
and external data, while MIRACLE [35] learns both imputation function and missingness graph.
While these methods offer high imputation quality, they also require external tools, can only impute
values in a single table, and have a long imputation time, which hinders their applicability on large datasets:
most of them consider datasets with at most few hundreds of thousands records, while their imputation
times range from 1.7K to 96K seconds on a 1M dataset [46]. Some systems try to avoid lengthy imputation.
SampleClean [32] estimates the result of a query over dirty data by cleaning only a sample of the dataset.
ImputeDB [14] incorporates the imputation process into the query optimizer, imputing only the relevant
data; this can generate biased models. EDIT [46] addresses the high cost of training deep learning models
by reducing the training dataset, estimating the importance of each sample. Such importance estimates,
however, are often erroneous for deep networks [9].
Compared to simple data imputation techniques, our approach offers a similar runtime while providing
significantly better imputation quality. With respect to model-based imputation tools, our approach avoids
the problem of moving data between different systems, imputes data directly over multiple tables, and
significantly improves the imputation time. Compared to hybrid systems such as SampleClean, ImputeDB
and EDIT, our approach does not reduce the dataset size to improve performance and does not require
preprocessing such as joining relations or one-hot encoding.
Systems for Treating Missing Values.
There are systems that try to adapt tasks to work over
incomplete databases, such as entity resolution [58], discovery of functional dependencies [10], or machine
learning training [55, 27, 41]. Other systems try to repair missing values using different approaches, such as
human supervision [48, 42], functional dependencies [59], ensemble of tools [1], by generating interpretable
data repair rules [54], or synthesizing completely missing tuples over database schema [22]. Missing values
might also not be clearly recognizable, prompting systems for the discovery of hidden missing values [56] and
the evaluation of the quality of incomplete databases [39, 61].
In-Database Learning. This line of work aims to enable machine learning tasks within a database
system, delivering faster training and prediction times, lower data movement and storage costs, and better
21

---

data security.
MADLib [21] and Bismarck [19] implement ML tasks inside user-defined functions, thus
removing the need for data movementm, but without exploiting the structure of the data to improve learning
performance. LMFAO [63] and AC/DC [28] support learning various ML models over normalized tables
by sharing computation, Orion [34] supports generalized linear models, and Morpheus [15] supports linear
algebra operations over a normalized database.
F-IVM [49, 50] introduces the cofactor ring to support
incremental computation of ML models.
Compared to this prior work, we make several novel contributions: we present a new method for in-
database training of linear discriminant analysis models, we adapt the widely-used MICE algorithm to exploit
computation sharing, and instead of developing specialized tools, we implement our approach in two popular
database systems, offering high data imputation quality at low cost.
8
Conclusion
This paper introduces a novel and efficient method for generating high-quality data imputation. We show
how to enhance the widely-used MICE algorithm to exploit computation sharing and scalable execution,
tailoring it specifically for the implementation within a database system. We implement our imputation
methods in DuckDB and PostgreSQL and demonstrate their superiority when compared to other methods,
resulting in faster imputation time without compromising the quality of imputed data.
Looking ahead, we plan to enrich our open-source library with new methods for in-database learning
and data cleaning, offering data practitioners a powerful tool to effectively address the challenges presented
by missing data. Our library already supports other ML algorithms not elaborated in this paper, such as
Na¨ıve Bayes and Quadratic Discriminant Analysis classifiers. We believe it is possible to further empower
in-database data cleaning tasks with learning algorithms such as decision trees, k-means, random forests, and
gradient boosting [23, 62, 15], including their integration into MICE, albeit the opportunities for computation
sharing across models and iterations might not always exist. In that context, we want to pursue support
for shared and incremental learning of models in iterative database tasks, like in this work. Going further,
deep learning and deep generative models pose a significant challenge at the moment for a fully in-database
implementation due to their non-linearity, thus efficiently training such high-capacity models over relational
databases stands as an open problem.
References
[1] Z. Abedjan, X. Chu, D. Deng, R. C. Fernandez, I. F. Ilyas, M. Ouzzani, P. Papotti, M. Stonebraker, and
N. Tang. Detecting Data Errors: Where Are We and What Needs to Be Done? Proc. VLDB Endow.,
9(12):993–1004, 2016.
[2] T. E. P. Administration. Taiwan air quality data, 2016 - 2021.
[3] G. Ambler, R. Z. Omar, and P. Royston. A Comparison of Imputation Techniques for Handling Missing
Predictor Values in a Risk Model with a Binary Outcome. Statistical Methods in Medical Research,
16(3):277–298, 2007.
[4] R. R. Andridge and R. J. A. Little.
A Review of Hot Deck Imputation for Survey Non-response.
International Statistical Review, 78(1):40–64, 2010.
[5] E. Angerson, D. Sorensen, Z. Bai, J. Dongarra, A. Greenbaum, A. McKenney, J. Du Croz, S. Hammar-
ling, J. Demmel, and C. Bischof. LAPACK: A Portable Linear Algebra Library for High-Performance
Computers. In Supercomputing, pages 2–11, 1990.
[6] Apache MADlib. https://madlib.apache.org, 2023.
[7] Apache SystemDS. https://systemds.apache.org, 2023.
[8] P. Bansal, P. Deshpande, and S. Sarawagi. Missing Value Imputation on Multidimensional Time Series.
Proc. VLDB Endow., 14(11):2533–2545, 2021.
22

---

[9] S. Basu, P. Pope, and S. Feizi. Influence Functions in Deep Learning Are Fragile. In ICLR, 2021.
[10] L. Berti-´Equille, H. Harmouch, F. Naumann, N. Novelli, and S. Thirumuruganathan.
Discovery of
Genuine Functional Dependencies from Relational Data with Missing Values.
Proc. VLDB Endow.,
11(8):880–892, 2018.
[11] F. Biessmann, D. Salinas, S. Schelter, P. Schmidt, and D. Lange. ”Deep” Learning for Missing Value
Imputationin Tables with Non-Numerical Data. In CIKM, pages 2017–2025, 2018.
[12] M. Boehm, M. W. Dusenberry, D. Eriksson, A. V. Evfimievski, F. M. Manshadi, N. Pansare, B. Reinwald,
F. R. Reiss, P. Sen, A. C. Surve, and S. Tatikonda. SystemML: Declarative Machine Learning on Spark.
Proc. VLDB Endow., 9(13):1425–1436, 2016.
[13] S. v. Buuren. Flexible Imputation of Missing Data. CRC Press, 2nd edition, 2018.
[14] J. Cambronero, J. K. Feser, M. J. Smith, and S. Madden. Query Optimization for Dynamic Imputation.
Proc. VLDB Endow., 10(11):1310–1321, 2017.
[15] L. Chen, A. Kumar, J. Naughton, and J. M. Patel. Towards Linear Algebra over Normalized Data.
Proc. VLDB Endow., 10(11):1214–1225, 2017.
[16] X. Chu, I. F. Ilyas, S. Krishnan, and J. Wang. Data Cleaning: Overview and Emerging Challenges. In
SIGMOD, pages 2201–2206, 2016.
[17] X. Ding, H. Wang, J. Su, Z. Li, J. Li, and H. Gao. Cleanits: A Data Cleaning System for Industrial
Time Series. Proc. VLDB Endow., 12(12):1786–1789, 2019.
[18] T. Emmanuel, T. Maupong, D. Mpoeleng, T. Semong, B. Mphago, and O. Tabona. A Survey on Missing
Data in Machine Learning. Journal of Big Data, 8(1):1–37, 2021.
[19] X. Feng, A. Kumar, B. Recht, and C. R´e. Towards a Unified Architecture for In-RDBMS Analytics. In
SIGMOD, pages 325–336, 2012.
[20] J. W. Graham. Missing Data Analysis: Making It Work in the Real World. Annual Review of Psychology,
60(1):549–576, 2009.
[21] J. M. Hellerstein, C. R´e, F. Schoppmann, D. Z. Wang, E. Fratkin, A. Gorajek, K. S. Ng, C. Welton,
X. Feng, K. Li, and A. Kumar. The MADlib Analytics Library: or MAD Skills, the SQL. Proc. VLDB
Endow., 5(12):1700–1711, 2012.
[22] B. Hilprecht and C. Binnig. ReStore – Neural Data Completion for Relational Databases. In SIGMOD,
pages 710–722, 2021.
[23] Z. Huang, R. Sen, J. Liu, and E. Wu. JoinBoost: Grow Trees Over Normalized Data Using Only SQL,
2023.
[24] M. H. Huque, J. B. Carlin, J. A. Simpson, and K. J. Lee. A Comparison of Multiple Imputation Methods
for Missing Data in Longitudinal Studies. BMC Medical Research Methodology, 18(1):168, 2018.
[25] D. Jarrett, B. Cebere, T. Liu, A. Curth, and M. van der Schaar. HyperImpute: Generalized Iterative
Imputation with Automatic Model Selection. In ICML, pages 9916–9937, 2022.
[26] S. J¨ager, A. Allhorn, and F. Bießmann. A Benchmark for Data Imputation Methods. Frontiers in Big
Data, 4:1–16, 2021.
[27] B. Karlaˇs, P. Li, R. Wu, N. M. G¨urel, X. Chu, W. Wu, and C. Zhang. Nearest Neighbor Classifiers
over Incomplete Information: From Certain Answers to Certain Predictions.
Proc. VLDB Endow.,
14(3):255–267, 2020.
23

---

[28] M. A. Khamis, H. Q. Ngo, X. Nguyen, D. Olteanu, and M. Schleich. AC/DC: In-Database Learning
Thunderstruck. In DEEM, pages 1–10, 2018.
[29] M. Khayati, I. Arous, Z. Tymchenko, and P. Cudr´e-Mauroux. ORBITS: Online Recovery of Missing
Values in Multiple Time Series Streams. Proc. VLDB Endow., 14(3):294–306, 2020.
[30] M. Khayati, A. Lerner, Z. Tymchenko, and P. Cudr´e-Mauroux.
Mind the Gap: An Experimental
Evaluation of Imputation of Missing Values Techniques in Time Series. Proc. VLDB Endow., 13(5):768–
782, 2020.
[31] C. Koch. Incremental Query Evaluation in a Ring of Databases. In PODS, pages 87–98, 2010.
[32] S. Krishnan, J. Wang, M. Franklin, K. Goldberg, T. Kraska, T. Milo, and E. Wu. Sampleclean: Fast
and reliable analytics on dirty data. IEEE Data Eng. Bull., 38:59–75, 2015.
[33] A. Kumar, M. Boehm, and J. Yang. Data Management in Machine Learning: Challenges, Techniques,
and Systems. In SIGMOD, pages 1717–1722, 2017.
[34] A. Kumar, J. Naughton, and J. M. Patel. Learning generalized linear models over normalized data,
2015.
[35] T. Kyono, Y. Zhang, A. Bellot, and M. van der Schaar. MIRACLE: Causally-Aware Imputation via
Learning Missing Data Mechanisms. Advances in Neural Information Processing Systems, 34:23806–
23817, 2021.
[36] J. M. Lachin. Fallacies of Last Observation Carried Forward Analyses. Clinical Trials, 13(2):161–168,
2016.
[37] R. Lall and T. Robinson. The MIDAS Touch: Accurate and Scalable Missing-Data Imputation with
Deep Learning. Political Analysis, 30(2):179–196, 2022.
[38] P.-A. Larson. Data Reduction by Partial Preaggregation. In ICDT, pages 706–715, 2002.
[39] X. Liang, Z. Shang, S. Krishnan, A. J. Elmore, and M. J. Franklin. Fast and reliable missing data
contingency analysis with predicate-constraints. In Proceedings of the 2020 ACM SIGMOD International
Conference on Management of Data, pages 285–295. Association for Computing Machinery, 2020.
[40] R. J. A. Little and D. B. Rubin. Statistical Analysis with Missing Data. Wiley, 3rd edition, 2019.
[41] T. Liu, J. Fan, Y. Luo, N. Tang, G. Li, and X. Du. Adaptive Data Augmentation for Supervised Learning
over Missing Data. Proc. VLDB Endow., 14(7):1202–1214, 2021.
[42] M. Mahdavi and Z. Abedjan. Baran: Effective Error Correction via a Unified Context Representation
and Transfer Learning. Proc. VLDB Endow., 13(12):1948–1961, 2020.
[43] P.-A. Mattei and J. Frellsen. MIWAE: Deep Generative Modelling and Imputation of Incomplete Data
Sets. In ICML, pages 4413–4423, 2019.
[44] R. Mazumder, T. Hastie, and R. Tibshirani. Spectral Regularization Algorithms for Learning Large
Incomplete Matrices. Journal of Machine Learning Research, 11(80):2287–2322, 2010.
[45] M. Mera-Gaona, U. Neumann, R. Vargas-Canas, and D. M. L´opez. Evaluating the Impact of Multivariate
Imputation by MICE in Feature Selection. PLOS ONE, 16(7):1–28, 2021.
[46] X. Miao, Y. Wu, L. Chen, Y. Gao, J. Wang, and J. Yin. Efficient and Effective Data Imputation with
Influence Functions. Proc. VLDB Endow., 15(3):624–632, 2021.
[47] MindsDB. https://mindsdb.com/, 2023.
24

---

[48] M. Musleh, M. Ouzzani, N. Tang, and A. Doan. CoClean: Collaborative Data Cleaning. In SIGMOD,
pages 2757–2760, 2020.
[49] M. Nikolic and D. Olteanu. Incremental View Maintenance with Triple Lock Factorization Benefits. In
SIGMOD, pages 365–380, 2018.
[50] M. Nikolic, H. Zhang, A. Kara, and D. Olteanu. F-IVM: Learning over Fast-Evolving Relational Data.
In SIGMOD, pages 2773–2776, 2020.
[51] U. D. of Transportation. Flight Delays and Cancellations, 2015.
[52] F. Pedregosa, G. Varoquaux, A. Gramfort, V. Michel, B. Thirion, O. Grisel, M. Blondel, P. Pretten-
hofer, R. Weiss, V. Dubourg, J. Vanderplas, A. Passos, D. Cournapeau, M. Brucher, M. Perrot, and
´E. Duchesnay. Scikit-learn: Machine learning in python. J. Mach. Learn. Res., 12(null):2825–2830, 2011.
[53] I. Peis, C. Ma, and J. M. Hern´andez-Lobato.
Missing Data Imputation and Acquisition with Deep
Hierarchical Models and Hamiltonian Monte Carlo. Advances in Neural Information Processing Systems,
35:35839–35851, 2022.
[54] J. Peng, D. Shen, N. Tang, T. Liu, Y. Kou, T. Nie, H. Cui, and G. Yu. Self-Supervised and Interpretable
Data Cleaning with Sequence Generative Adversarial Networks. Proc. VLDB Endow., 16(3):433–446,
2022.
[55] J. Picado, J. Davis, A. Termehchy, and G. Y. Lee. Learning Over Dirty Data Without Cleaning. In
SIGMOD, pages 1301–1316, 2020.
[56] A. A. Qahtan, A. Elmagarmid, R. Castro Fernandez, M. Ouzzani, and N. Tang. FAHES: A Robust
Disguised Missing Values Detector. In KDD, pages 2100–2109, 2018.
[57] T. Rekatsinas, X. Chu, I. F. Ilyas, and C. R´e. HoloClean: Holistic Data Repairs with Probabilistic
Inference. Proc. VLDB Endow., 10(11):1190–1201, 2017.
[58] W. Ren, X. Lian, and K. Ghazinour. Online Topic-Aware Entity Resolution Over Incomplete Data
Streams. In SIGMOD, pages 1478–1490, 2021.
[59] E. K. Rezig, M. Ouzzani, W. G. Aref, A. K. Elmagarmid, A. R. Mahmood, and M. Stonebraker. Horizon:
Scalable Dependency-Driven Data Cleaning. Proc. VLDB Endow., 14(11):2546–2554, 2021.
[60] J. L. Schafer and J. W. Graham. Missing Data: Our View of the State of the Art. Psychological Methods,
7(2):147–177, 2002.
[61] S. Schelter, D. Lange, P. Schmidt, M. Celikel, F. Biessmann, and A. Grafberger. Automating Large-Scale
Data Quality Verification. Proc. VLDB Endow., 11(12):1781–1794, 2018.
[62] M. Schleich and D. Olteanu. Lmfao: An engine for batches of group-by aggregates: Layered multiple
functional aggregate optimization. Proc. VLDB Endow., 13(12):2945–2948, 2020.
[63] M. Schleich, D. Olteanu, M. Abo Khamis, H. Q. Ngo, and X. Nguyen. A Layered Aggregate Engine for
Analytics Workloads. In SIGMOD, pages 1642–1659, 2019.
[64] M. Schleich, D. Olteanu, and R. Ciucanu. Learning Linear Regression Models over Factorized Joins. In
SIGMOD, pages 3–18, 2016.
[65] D. J. Stekhoven and P. B¨uhlmann. MissForest – Non-Parametric Missing Value Imputation for Mixed-
Type Data. Bioinformatics, 28(1):112–118, 2012.
[66] J. Stoyanovich, B. Howe, and H. V. Jagadish. Responsible Data Management. Proc. VLDB Endow.,
13(12):3474–3488, 2020.
25

---

[67] E. Toussaint, P. Guagliardo, L. Libkin, and J. Sequeda. Troubles with Nulls, Views from the Users.
Proc. VLDB Endow., 15(11):2613–2625, 2022.
[68] S. van Buuren and K. Groothuis-Oudshoorn. mice: Multivariate Imputation by Chained Equations in
R. Journal of Statistical Software, 45(3):1–67, 2011.
[69] J. Yoon, J. Jordon, and M. van der Schaar. GAIN: Missing Data Imputation using Generative Adversarial
Nets. In ICML, volume 80, pages 5689–5698, 2018.
[70] S. Yoon and S. Sull. GAMIN: Generative Adversarial Multiple Imputation Network for Highly Missing
Data. In CVPR, pages 8453–8461, 2020.
[71] J. You, X. Ma, Y. Ding, M. J. Kochenderfer, and J. Leskovec. Handling Missing Data with Graph
Representation Learning. Advances in Neural Information Processing Systems, 33:19075–19087, 2020.
[72] Y. C. Yuan. Multiple Imputation for Missing Data: Concepts and New Development (Version 9.0). SAS
Institute Inc, Rockville, MD, 49(1-11):12, 2010.
[73] S. Zheng and N. Charoenphakdee. Diffusion Models for Missing Value Imputation in Tabular Data. In
NeurIPS 2022 First Table Representation Workshop, 2022.
26

---

