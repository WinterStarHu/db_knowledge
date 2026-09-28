# Learning Approximation Sets for Exploratory Queries

> 来源: https://arxiv.org/pdf/2401.17059

LEARNING APPROXIMATION SETS FOR EXPLORATORY QUERIES
Susan B.Davidson
University of Pennsylvania
susan@seas.upenn.edu
Tova Milo
Tel Aviv University
Tel Aviv, Israel
milo@cs.tau.ac.il
Kathy Razmadze
Tel Aviv University
Tel Aviv, Israel
kathyr@mail.tau.ac.il
Gal Zeevi
Tel Aviv University
Tel Aviv, Israel
galzeevi@mail.tau.ac.il
January 31, 2024
ABSTRACT
In data exploration, executing complex non-aggregate queries over large databases can be time-
consuming. Our paper introduces a novel approach to address this challenge, focusing on finding
an optimized subset of data, referred to as the approximation set, for query execution. The goal is
to maximize query result quality while minimizing execution time. We formalize this problem as
Approximate Non-Aggregates Query Processing (ANAQP) and establish its NP-completeness. To
tackle this, we propose an approximate solution using advanced Reinforcement Learning architecture,
termed ASQP-RL. This approach overcomes challenges related to the large action space and the
need for generalization beyond a known query workload. Experimental results on two benchmarks
demonstrate the superior performance of ASQP-RL, outperforming baselines by 30% in accuracy and
achieving efficiency gains of 10 −35X. Our research sheds light on the potential of reinforcement
learning techniques for advancing data management tasks. Experimental results on two benchmarks
show that ASQP-RL significantly outperforms the baselines both in terms of accuracy (30% better)
and efficiency (10-35X). This research provides valuable insights into the potential of RL techniques
for future advancements in data management tasks.
1
Introduction
In the data exploration phase of data science, users execute a variety of queries, including both aggregate and complex
non-aggregate queries, often in an iterative manner Bar El, Milo, and Somech 2020. However, when the database is
large and the queries are complex, calculating exact answers for exploratory queries can be time-consuming, prompting
users to prefer faster but approximate query results. Approximate Query Processing (AQP) K. Li and G. Li 2018 has
been proposed to accelerate the processing of aggregate queries, but does not address the complex, non-aggregate, SQL
queries that are common in data exploration.
For example, a recent study of the IMDB Database Leis et al. 2015 showed that in the query workload of data exploration
sessions, only about 50% of the queries were aggregate queries. The remaining half were complex select-project-join
(SPJ) queries. These complex queries had an average processing time of 25 minutes, and 30% of them exceeded 1 hour,
even with result limits being imposed, making the wait time impractical.
This paper extends the scope of approximate query processing to non-aggregate queries, presenting a solution that
accelerates the execution of such queries while providing high accuracy.
Approximating complex non-aggregates queries
Our work focuses on (1) defining what a reasonable approxi-
mation is for complex non-aggregate queries, and (2) providing an efficiently computed subset of the data, called an
arXiv:2401.17059v1  [cs.DB]  30 Jan 2024

---

approximation set, for evaluating complex non-aggregate queries. While approximate answers are well understood for
aggregate queries, extending this idea to non-aggregate queries requires careful consideration. Our premise is that an
approximation for a non-aggregate query should encompass some, but not necessarily all, tuples in the query result.
This stance is grounded in practicality: when the query output becomes excessively large for human comprehension,
users may not discern that the result is approximated.
Unlike in AQP, where the quality metric for approximation remains consistent across queries, the critical factor in
non-aggregate queries is the portion of the result that a user can thoroughly analyze. In scenarios where the user
can analyze the entire result, the approximation must be highly accurate, covering the entire result set. However,
in queries with exceptionally large results, the approximation should provide the user with an understanding of the
query answer without necessarily containing more than the user can observe. As with aggregate queries, complex
non-aggregate queries can take a long time to execute. Drawing parallels to users’ willingness to accept extended,
offline pre-processing times for fast, accurate approximate query processing in AQP, we posit a similar situation holds
for our scenario: Users are willing to accept an extending pre-processing time that calculates a good approximation set
which can then be used to produce fast, high quality approximate answers for queries. However, there are a number of
challenges that must be addressed in order to find a good approximation set.
Challenges
Selecting an approximation set for subsequent querying presents various challenges: (C1) The vast
combinatorial space, created by the number of combinations of tuples from different tables. (C2) Understanding the
search space, due to the cost of executing the complete query workload. (C3) The varying size of query results, which
introduces different importance levels for tuples, e.g. tuples from queries with smaller result sizes are more significant
than ones from larger result sizes. (C4) Generalizing for future, potentially dissimilar queries, since the query workload
only captures what is already known. (C5) Detecting when there is a drift in user interest.
Inadequacy of Existing Approaches
Despite the perception that existing solutions may address these challenges,
there are several shortcomings. Online Analytical Processing (OLAP), for example, demands significant storage
resources for data cubes, which can be up to ten times the size of the original dataset. OLAP also relies on proficient
Database Administrators (DBAs) who are familiar with its unique syntax, limiting its accessibility for general users (see
Section 2). While AQP solutions seem promising, recent approaches using generative models (e.g., Thirumuruganathan
et al. 2020) often produce false tuples when applied to non-aggregate queries. This deficiency is critical when
presenting non-aggregate query results, since false tuples may mislead users and lead to attempts to query irrelevant
data. Other AQP works which create data subsets for subsequent model training (e.g., Yongjoo Park et al. 2018; Ma
and Triantafillou 2019) also prove inadequate for non-aggregate queries (comparisons with AQP baselines are given in
Section 6). Classical methods, including diverse sampling techniques and caching in managed database systems, are
also considered in Section 6, but do not produce satisfactory results for non-aggregate queries.
Our solution
We offer an innovative approach for efficiently approximating non-aggregate query results. Given
an initial query workload and database (which could be multiple tables), our method involves creating a subset of
the data, called an approximation set, to enable faster queries when the runtime for executing queries on the full
database is excessive. To gauge an approximation set’s quality with respect to the query workload, we define a metric.
Unfortunately, optimizing with respect to this metric is NP-hard, so we turn to Reinforcement Learning (RL) for an
approximate solution.
Our system, ASQP-RL, initiates a comprehensive data and query workload pre-processing phase, resulting in an initial
reduced subset of the data (C2). This subset is translated into the RL action space, where, at each training step, the
model predicts the next tuples to include in the approximation set based on the current state. This predictive action
aims to maximize the reward, representing the quality of results for queries encountered so far. ASQP-RL employs a
reinforcement learning model utilizing critic-actor networks with Proximal Policy Optimization (PPO), specifically
tailored for tabular data. The model encompasses a well-crafted environment and transformed action definitions (C1,
C4). A specialized reward function that aligns with the goal of selecting rows for accurate approximations (C3). This
combination yields a robust, adaptive solution that significantly improves the efficiency and accuracy of non-aggregate
query approximations. Additionally, our system is equipped to detect drift in user interests, enabling model fine-tuning
for better approximate results (C5).
While not explicitly addressed, our approach can also handle aggregate queries in the query workload by rewriting
them to SPJ queries. Users can subsequently include aggregate queries in their data exploration sessions and obtain
surprisingly good results, as shown in Section 6.
Benefits
Our solution offers several benefits:
1. A versatile mediator adaptable to any database, enhancing flexibility across diverse environments.
2

---

2. Flexible training within time constraints, providing estimated guarantees and managing the tradeoff between
running time and result quality.
3. Efficient query interpretation through vector-based techniques, enabling a rapid reduction of the initial space,
facilitating swift training processes and contributing to overall system efficiency.
4. Incorporating a predictive model and query interpretation assesses the likelihood of missing answers, enhancing
result accuracy.
5. The ability to detect interest drift, enabling fine-tuning to evolving exploration needs. This is achieved through
the generation of initial query workloads and dynamic fine-tuning of the model with adapted queries.
These benefits position ASQP-RL as a comprehensive tool for efficient and effective data exploration.
Contributions and Outline
In addition to providing a comprehensive tool for data exploration, this work is among
the first applications of advanced RL concepts. Specific contributions include:
1. Problem Definition and Metric Introduction (Section 3): We define the problem of approximating non-
aggregate queries and introduce a novel metric for evaluating the quality of approximations.
2. Comprehensive RL-Based Solution (Sections 4 and 5): We present a holistic solution based on RL, specifi-
cally ASPQ-RL. This includes the training of a model to create an approximation set. Additionally, we address
challenges such as determining when to use the approximation set for answering queries, when to fine-tune the
model in response to a drift in user interests, and how to handle an unknown query workload.
3. Experiments Demonstrating Efficiency and Quality (Section 6): We conduct comprehensive experiments
showcasing the efficiency and quality of ASQP-RL for non-aggregate queries. The results highlight its
adaptability to diverse time constraints and superior performance in managing the trade-off between running
time and result quality.
Section 2 presents related work, and Section 7 concludes the paper.
2
Related work
We provide an overview of key areas closely related to our study, categorizing them into five groups. These fields
collectively provide a comprehensive understanding of existing literature and highlight the unique contributions of our
work.
OLAP
In Online Analytical Processing (OLAP), especially within Multidimensional OLAP (MOLAP), the focus is
on aggregate operators managed through data cubes relying on past query workloads (Nanda, Gupta, and Vijrania 2019;
Dhanasree and Shobabindu 2016).However, MOLAP poses several challenges: Spatial requirements for these cubes,
highlighted in Leung et al. 2020, are substantial, about ten times the original dataset size, imposing significant storage
overhead; Implementing MOLAP systems demands DBAs with specific OLAP syntax expertise, limiting accessibility
to average data scientistsIBM n.d.(a); The setup process, per IBM n.d.(b), is intricate, potentially taking several days.
These limitations reduce OLAP tools’ accessibility in the data science community, making them less suitable for our
specific problem.
Approximate Query Processing (AQP) and Generative Models
In AQP, two main approaches aim to provide
approximate answers to aggregation queries(K. Li and G. Li 2018): (1) Retaining a small number of tuples with
metadata: such as recent sampling methods for this purpose Galakatos et al. 2017; Cormode 2017; Agarwal et al.
2013, aim to expedite query processing by reducing tuples at the cost of exactness. While those methods are less
effective for non-aggregate queries in our specific use case (Section 6), we draw inspiration from Yongjoo Park et al.
2018 to generate an initial subset of joined tuples from relevant tables in the query workload. This subset forms the
basis for training a model that produces a high-performing subset for non-aggregate query approximation tasks. (2)
Generating new tuples using generative models: Generative models, such as generative adversarial networks (GANs)
and Variational Autoencoders (VAEs), have been extensively explored for generating synthetic or representative samples
in the context of tabular data Fan et al. 2020; Thirumuruganathan et al. 2020. These models offer advantages like
explicit probabilistic modeling and capturing complex data distributions. However, as demonstrated in Section 6,
generated tuples may significantly deviate from real tuples, leading to issues where user queries produce minimal or no
results, return nonsensical outcomes, or even mislead the user. This makes them unsuitable for our particular case.
3

---

Data Summarization and Sampling
These techniques provide essential tools for various data processing tasks.
Cluster-based representative selection aims to maximize data diversity by selecting instances from clustered data Liu
and Jagadish 2009. In visualization, row sampling reduces data points while minimizing error Y. Park, Cafarella,
and Mozafari 2016. Query result diversification selects rows with both relevance and diversity, often utilizing greedy
algorithms Vieira et al. 2011. However, as demonstrated in Section 6, these approaches, optimized for different
objectives, are unsuitable for our specific use case.
Data Reduction, Sketches and others
Data sketches and reduction techniques, including HyperLogLog and Count-
Min Sketch Cormode 2017; Rehman et al. 2016, are impactful for data processing tasks. However, they may lose critical
data details needed for accurate selection query results, making them unsuitable for our purposes. Approaches like
the skyline operator Papadias et al. 2005, caching operations Ahmad, Qadir, and Sanaullah 2008, and view selection
materialization with space constraints (Mami and Bellahsene 2012) are relevant but prove inferior for our use case, as
demonstrated in our experiments.
3
Problem Definition and Complexity
We now introduce the problem of Approximate Non-Aggregate Query Processing (ANAQP). We begin by defining
the problem in a simplified scenario with a known query workload, and give a metric to assess the quality of a set of
subsets of tuples with respect to the given workload. In the next section we extend these concepts to scenarios where
the query workload is unknown.
ANAQP Problem Definition
Consider a set of relational instances T = {T1, ..., Tn} and query workload Q consisting
of select-project-join (SPJ, non-aggregate) queries over T . We denote w as a function w : Q →[0, 1] that assigns a
weight to each query, satisfying the constraint P
q∈Q w(q) = 1.
We assume limits on the size of the available memory (k) as well as on the maximum result size that users can
cognitively process (frame size F). In practice, F may vary from 10 rows (the default data view size in pandas) to 500
rows (the default result size in PostgreSQL), and is configurable.
Metric
Our metric function, score(S), measures the quality of a set of subsets of the relational instances in T ,
S = {S1, ..., Sn} where Si ⊆Ti, with respect to (T , Q, w, k, F):
score(S) =
1
|Q|
X
q∈Q
w(q) · min(1,
|q(S)|
min(F, |q(T )|))
(1)
Intuitively, if a query returns more tuples than the frame size F, there is no need to include in S more than F tuples
from the query result since the user may not be able to cognitively process them. Conversely, if a query returns only
a few tuples, then each tuple carries significant importance in the result. The metric takes into account the weight
assigned to each query and calculates the average score over all queries in Q.
ANAQP Goal
Given an instance T , a set of queries Q, weight function w, and positive integers k and F, the goal of
ANAQP is to find a set S of subsets of tables in T where P
Si∈S |Si| < k such that score(S) is maximized.
Problem Hardness
The ANAQP problem is already hard when queries are over a single table, n = 1. In this
case, a naive approach to is to consider all subsets S ⊆T of size k, and find the one that maximizes score(S). This
is obviously computationally intractable. Worse yet, this naive solution cannot be significantly improved since the
ANAQP problem is NP-hard. This can be shown by reduction to the max-k-vertex cover problem Manurangsi 2018.
We create an ANAQP instance from the input to the max-k-vertex cover problem as follows: For each vertex v ∈V , we
create a tuple tv ∈T, and for each edge e = {u, v} ∈E, we create a query qe(T) = {tu, tv} that includes the tuples
corresponding to the edge’s endpoints qe(T) = {tu, tv}. The query weights are set to the weights of the corresponding
edges in the graph. The limit on the number of informative tuples, F is set to 1, and the memory size is set to k (the
input to the max-k-vertex problem). Observe that a solution to the ANAQP formulation of the problem is a solution to
the max-k-vertex problem, as the score function score(S) defined in Equation 1 is equivalent to the objective function
of the max-k-vertex cover problem.
In the case where multiple tables are involved (n > 1) the problem is combinatorially even worse, since all possible
combinations of subsets of each relation must be considered.
4

---

User Input
Dataset
Query
Workload
Query embeddings
Choosing
representatives
T
1
...
n
Action space
Initial subset/
Variational
subsampling
Data embedding
Environment
Action Mask
T
1
...
m
(m tuples)
Agent
Actor
Critic
(next action)
1
2
3
(reward for action)
(current state, mask)
CLIP
Loss
At step 
(a) Training process
(b) Inference
Compute
reward
Query execution
Output
approximation
set
(size k)
Agent
Environment
(current state,mask)
action
After k steps
System
Can answer
query?
Query
Yes
Yes
No
No
Answer from
DB
FC
FC
FC
Finetune
Decision
S
1
...
k
SOFTMAX
FC
FC
FC
Query
relaxation
Data
preprocessing
Query
preprocessing
Figure 1: ASQP-RL architecture.
Parameter Settings
As can be seen from the problem formulation, the choice of parameter settings significantly
impacts the overall performance of a solution: The frame size (F) directly affects the score function. The available
memory (k) determines how large the subsets can be and therefore affects the accuracy and coverage of query results.
Increasing k enables a larger number of tuples to be kept, leading to a higher likelihood of obtaining exact query outputs
and improved coverage for a wide range of queries. We show the effectiveness of our system under different parameter
settings in Section 6.
Aggregate Queries
Aggregate queries are important in data exploration but are not directly addressed in our problem
formulation, which focuses on SPJ queries. Our approach to handling aggregate queries in the initial query workload is
to transform them into SPJ queries over T by removing the aggregate and group operators. We show in Section 6.4 that
this naive approach yields surprisingly good results when compared with Approximate Query Processing techniques.
Unknown Query Workloads
We have introduced ANAQP using a simplified scenario with a known query workload.
However, the query workload is typically a subset of all possible user queries – users continually issue new queries
which may differ from the original workload. Even worse, the query workload may be unknown. We address this
problem in Section 4.2.
Due to the hardness of finding an exact solution to ANAQP, as well as the cost of executing queries over large relations
to evaluate score(S), we show in the next section how to use Reinforcement Learning (RL) to find a good approximate
solution.
4
Approximation using RL
In this section, we outline our approach to employing Reinforcement Learning (RL) for Approximate Non-Aggregates
Query Processing (ANAQP). We introduce the ASQP-RL framework, which serves as our solution for approximate non-
aggregate query processing using RL (Section 4.1). The framework is subsequently detailed, covering the preprocessing
steps for input tables and query workloads, along with addressing scenarios without a known query workload (Section
4.2). High-level descriptions of the RL training and inference steps are provided in Sections 4.3 and 4.4. Further details
of the RL components are deferred to Section 5. Lastly, we discuss additional enhancements, including a light version
of the system for improved running times and the scenario where no queries are initially available (Section 4.5).
4.1
Overview of ASQP-RL
In our RL approach, an approximation set consisting of tuples from the input tables is learned through trial-and-error
interactions. The RL agent starts with some initial state (approximation set), and at each step predicts the next action
(tuples selection) based on the current state. This predictive action aims to maximize the reward, representing the
5

---

quality of results for queries encountered thus far (Equation 1). The use of RL ensures the fitness of selected tuples to
the queries, while exploration introduces diversity in tuple selection.
The workflow of ASQP-RL is presented in Figure 1. The training phase shown in (a) begins by pre-preprocessing
the database D and the query workload Q to address some of the challenges mentioned earlier, and provide the input
to the RL model. The RL model is then trained. In the inference phase shown in (b), the framework generates an
approximation set using the trained model. When a query is issued by the user, the system decides whether to use the
approximation set or query the full database, based on an estimation of how close the query is to those used to train the
model.
4.2
Data and Query Pre-processing
The pre-processing phase depicted in Figure 1(a) prepares the data and queries for input to the RL phase and addresses
several challenges: the combinatorial size of the solution space (C1), and the high cost of executing the query workload
(C2). We describe how queries and data are pre-processed and how these challenges are addressed in the context of the
RL framework. We then discuss how to generalize for future queries (C4).
Query Pre-processing
Queries are first generalized before creating their vector representations. For this, we use
existing query relaxation methods query_relaxation, which loosen or modify query conditions when strict adherence
to the original conditions do not yield sufficient results. In our setting, these modifications enlarge the result set for each
query, thereby making the query more general. This also adds in tuples that are beyond what is returned by the current
workload, helping to generalize for future, not yet known, queries. Vector representations of the generalized queries
are then created using a modified version of sentence-BERT sentence-BERT. We adapt the transformer-based model
to capture similar queries by embedding queries into a vector space. Finally, we use a clustering algorithm over the
embedded queries to select what we call the query representatives to be used in the score function.
Data Pre-processing
Data pre-processing starts by removing data that is not used in any query representative. This is
done by executing the query representatives over the full dataset and keeping only their output. The output is further
reduced through subsampling in order to create the action space to be used for training the model. This reduced subset of
tuples (the action space) is then transformed into a vector representation to be ingested by the RL model and to ease the
learning. The subsampling technique used for reducing the results of the executed query representatives is variational
subsampling Yongjoo Park et al. 2018, a technique that uses probabilistic models, particularly in Bayesian inference, to
approximate intractable likelihoods by introducing latent variables and optimizing their variational parameters. The
transformation into a vector representation is achieved using another modified version of sentence-BERT. This version
is designed to be more suitable for tabular rows, incorporating modifications such as including column names as tokens
to capture both the meaning of the column as well as the value.
Addressing challenges C1, C2 and C4
In the RL framework, challenge C1 becomes one of the size of the action
space. This space constrains the RL algorithm to valid tuple selections aligned with table structures, data distribution,
and the provided query workload. Notably, selecting tuples separately from each table may lead to unjoinable tuples
(Yongjoo Park et al. 2018; Kandula et al. 2016). In our approach this is addressed in the data pre-processing phase, which
creates a smaller set of tuples based on the generalized query workload, which may contain joins. The second challenge,
C2, is the cost of executing queries in the query workload, in particular to evaluate the quality of an approximation
set. This is addressed during the query pre-processing phase by choosing a smaller set of query representatives, and
during the data pre-processing phase by selecting a smaller dataset over which to execute the queries. To overcome
the challenge of a future, unknown workload (C4), we use a fine-tuning strategy (detailed next). Moreover, the use of
query relaxation introduces more distinct tuples into the action space and avoids overfitting to the given query workload.
The RL builtin exploration phase also makes it return a more diverse solution, further addressing this challenge.
4.3
Training
The RL formulation of our problem treats it as a sequential decision-making process. The RL components during the
training phase of ASQP-RL, depicted in Figure 1(a), are defined as follows.
Action Space
The database is transformed into an action space which serves as input for the RL model during
training. Training involves formulating a policy for selecting actions from this space based on a given state. Since it is
infeasible to consider all subsets of tuples across all tables, we create a significantly reduced action space as described
in Section 4.2.
6

---

State and Environment
The state, a crucial element capturing relevant information for the decision-making policy in
Reinforcement Learning (RL) models, in our case is represented as the set of actions previously selected by the model.
Recall that an action, in this context, encompass multiple tuples sourced from different tables. Thus, the state effectively
encapsulates the approximation set chosen thus far. The environment, serving as the external system or context with
which the RL agent interacts, defines how states are represented and how the action space is made available to the
agent for policy definition. Specifically, we formalize the ASQP-RL environment in GSL form, a description further
elaborated upon in Section 5. In that section, an alternative approach is also discussed, which, due to its limitations, was
not incorporated into the algorithm. Nonetheless, the results of this alternative approach are presented in Section 6.
Reward
The reward, furnished by the environment, plays a pivotal role in updating the policy network. Our reward
function is the score shown in Equation 1, which is defined by the current batch of queries. To expedite the training
process and foster stability in the learned policy, we implement a common technique of batch training and loss
computation. Each epoch in the model training uses a distinct batch of queries, directly influencing the reward function.
In essence, a high reward signifies that the chosen action (representative of several tuples) encompasses the majority or
even all the results from the current batch of queries.
Agent
The agent considers the current state and then selects an action based on the learned policy, πθ. In ASQP-RL,
our agent uses the actor-critic method Mnih et al. 2016. This method incorporates several actor networks and a critic
network operating asynchronously. The actor networks are used to choose actions based on πθ, while the critic networks
update the policy based on the received reward. In Section 6 we conduct an ablation study, justifying each component
of the agent in our system.
Overall training process
The training process, shown in Figure 1(a) and detailed in Algorithm 1, takes as input the
database D and the query workload Q, which are first pre-processed. In this phase, queries from the training workload
are generalized and prepared for evaluation (lines 1 −2). The results of these modified queries (line 3) are then used to
construct the action space A (line 4). The training step begins with the iterative selection of the approximation set using
the RL model. Each epoch of the training process processes batches of queries retained from the pre-processing stage
(line 6), evaluating the chosen action and subsequently updating the model (lines 7 −10).
Specifically, each state denoted as sk represents the state after k epochs of the model, indicating that k actions were
previously selected from the action space A. The agent, represented by the actor network, takes sk as input and
computes the probability of each action, denoted as πθ(a|s) = p(a|s, θ), where a ∈A. A higher probability indicates a
larger expected long-term reward for the corresponding action. This implies that the final approximation set is more
likely to satisfy the query workload the model was trained upon. Multiple actor-critic networks operate asynchronously
during this process to expedite training by considering more policies.
Given the fact that actions represent tuples, we use action masking action_masking to enforce the constraint that a
tuple may only enter the approximation set once. In this technique, the environment provides the model along with the
state a mask that shows the valid actions the model can choose from.
The critic network estimates the long-term reward of the current state, and together with the returned reward, computes
the loss error (see Section 5 for more). The two networks are then updated for optimized action selection.
Addressing Challenges C3, C4
In the RL context, challenges C3 (diversity and balance in results) and C4 (gen-
eralization for future queries) necessitate a well-crafted reward system and an effective exploration strategy. (C3)
is addressed by formulating a reward system that carefully balances diversity and relevance. The reward associated
with selecting an action for a query with a modest result size holds significant value, emphasizing a balance between
diversity and ensuring relevance. This reward mechanism is crucial during the exploitation phase, guiding the selection
of actions for the creation of the approximation set. To tackle Challenge (C4), ensuring selected tuples generalize
effectively for future unseen queries, we employ a policy-based RL framework. This framework systematically chooses
actions, incorporating an exploration strategy. The exploration strategy aims to explore diverse combinations of actions
that are potentially relevant not only to the queries in the current workload but also to future queries. This approach
enhances the model’s ability to generalize effectively, accommodating a broader spectrum of queries beyond the ones
encountered during training.
4.4
Inference and User’s Interaction
The inference phase, depicted in Figure 1(b) and detailed in Algorithm 2, occurs after training the RL model. Using the
query workload and database, the model outputs the approximation set. Tuple selection for the approximation set is
sequential, where groups of tuples are chosen based on the learned policy obtained during model training.
7

---

Algorithm 1 ASQP-RL Training
Input: Database D, query workload Q
Output: A trained RL model
1: vec_generalized_Q = Emb_sql(relaxation(Q))
2: ˆQ = rep_selection(vec_generalized_Q)
3: ˆD = ˆQ(D)
4: initial_set = Emb_tab(variational_subsampling( ˆD))
5: for each episode during training do
6:
batch_Q = batch( ˆQ)
7:
action ak is sampled based on p(ak|sk, θ), ak ∈A
8:
sk+1 = sk union ak
9:
Reward r is then computed based on state and ak matching to batch_Q
10:
Use the reward to calculate loss and update the network
11:
if early stopping (loss) then
12:
break
13:
end if
14: end for
15: return M
User Interaction
After the initial approximation set is obtained, the user can issues queries. For each such query,
the system estimates whether the model is likely to contain relevant tuples. This estimation is based on the query’s
closeness to the training workload seen by the model, using the aforementioned query embeddings and the existing
model’s performance on the training workload.
If the system deems the query answerable, it provides the answer derived from the approximation set. Otherwise, it
queries the original database. As will be seen in Section 6, our system attains high accuracy in predicting whether a
query is answerable. This accuracy significantly contributes to the overall precision of the results presented to the user,
minimizing the likelihood of displaying partial results and potentially introducing bias into their analysis.
Identifying Interest Drift
Interest drift is identified when user queries deviate from the initial model training query
workload. When three or more queries deviate from the training workload with confidence scores surpassing 0.8,
our model initiates a fine-tuning process tailored to the specific characteristics of these queries, addressing C5. The
parameters outlined above that are used to trigger this process is a deliberate effort to strike a balance between optimizing
system performance and minimizing running time costs associated with fine-tuning, as detailed in Section 6.
Aggregate Queries
Recall that in Section 3, we discussed how aggregate queries in the query workload are trans-
formed into SPJ queries. However, users may also use aggregates when querying our system. As will be shown in
Section 6, even though the system was not explicitly trained for aggregate queries, it achieves surprisingly good results.
Similar to non-aggregate queries, when the estimator perceives a query to be significantly different from the query
workload (after transforming it into a non-aggregate query in a similar manner), it queries the database and provides the
user with an accurate answer.
Algorithm 2 ASQP-RL Inference
Input: Database D, trained model M, req_size- optional
Output: Approximation Set S
1: while |S| < req_size do
2:
Action ak is sampled based on p(a|sk, θ), a ∈A
3:
// p(a|sk, θ) is output by the model’s M policy π
4:
append the tuples of ak to S
5: end while
6: return S
4.5
Further Improvements
ASQP-Light
We introduce an enhanced version of the ASQP-RL algorithm named ASQP-Light in this section. While
the core of the algorithm remains unaltered, specific adjustments have been made to improve its efficiency. These
8

---

modifications involve implementing an early-stopping threshold, increasing the learning rate, and reducing the number
of queries considered during the training’s pre-processing phase. Despite a slight loss of 10% in quality, these
adjustments significantly reduce the running time from an hour to just 30 minutes, as demonstrated in Section 6.
Notably, ASQP-Light maintains its superior performance compared to competitors.
Adaptive Configuration
Users now have the flexibility to control various factors in our system, offering a range of
settings between the lightest version and our best-performing configuration in terms of quality. Considering the user’s
time constraints and the portion of the training query workload to execute (given as input), our system dynamically
determines the optimal setting for the use case. The RL model is then trained accordingly. This adaptive approach
optimizes the trade-off between running time and the quality of the calculated approximation set, tailoring our system
to the specific needs of users.
Diversity
While our metric function does not explicitly include diversity, our chosen RL solution incorporates an
exploration policy. This inherent feature leads to a diverse solution, enriching the variety of query results provided to the
user. In Section 6, we present experiments comparing the diversity of our solution against other methods, showcasing
its superiority over competitors.
Unknown Query Workloads
In Section 3, we define the problem as optimizing a metric function with respect
to a given workload. To address scenarios where the query workload is unknown, we draw inspiration from works
employing generated query workloads MLQueryOptimization; Ma and Triantafillou 2019. Our system utilizes
statistical information collected from the tables, such as the mean and standard deviation of numerical columns, a
sampled set of categorical columns (with repetition to account for popularity of certain values), and standard query
templates, to generate query workloads. While the query workload generated this way is adequate, as demonstrated
in Section 6, we conduct additional query generation alongside user input queries during system interactions to
ensure alignment with user interests. During the user’s queries on the resulting approximation set, there exists an
iterative process of generating new queries that align with the user’s interests and possibly fine-tuning the system. This
incorporates both the user’s queries and the newly generated queries, aiming for better alignment with user preferences.
5
Reinforcement Learning Model Implementation
Our agent’s policy is governed by a reinforcement learning model. We begin by introducing the actor-critic networks
and how proximal policy optimization contributes to the creation of a faster and more suitable approximation set
(Section 5.1). Subsequently, we delve into a discussion about the selected environment and explore alternatives along
with their limitations. Notably, this research marks the inaugural application of advanced RL concepts, specifically
proximal policy optimization, for tabular data purposes. In this domain, the action space is exceptionally large, and the
state representation is highly intricate, posing challenges for adapting RL methods.
Algorithm 3 Actor Critic Proximal Policy Optimization
Input: Action space A
Output: actor critic networks with parameters θ
1: while not to the max iterations do
2:
for actor = [1, . . . , N] do
3:
Run policy πθold in environment for T timesteps
4:
compute advantage estimates ˆ
A1 . . . ˆ
AT
5:
end for
6:
Optimize surrogate L w.r.t. θ, with K epochs and mini-batch size M ≤T · N
7:
θold ←θ
8: end while
5.1
Actor-Critic with Proximal Policy Optimization in ASQP-RL
In the ASQP-RL system (discussed in 4), the agent’s policy takes the state representation as input, inferring the optimal
action for the next step, a pivotal aspect of the RL model. However, the conventional policy network faces challenges in
achieving good performance due to potential high variance in the returned rewards. To address this, the actor-critic
method is employed. Additionally, to prevent the selection of many similar tuples, an entropy regularization technique is
used to fine-tune the objective function for the selection of diverse tuples. Typical policy-based reinforcement learning
methods, akin to classic RL algorithms like REINFORCE Kaelbling, Littman, and Moore 1996, primarily focus on
9

---

optimizing the parameterized policy concerning the expected long-term reward. Specifically, the objective of the policy
network is to maximize J(θ), defined as follows:
J(θ) = Eπθ[R(τ)] =
X
τ
p(τ|θ)
T
X
t=1
rt
Where τ = (s1, a1, . . . ST , aT ), represents a trajectory leading to a selected approximation, i.e. approx_set =
[a1, ...aT ]. The aim is to increase the probability of selecting the trajectory τ given a high reward R(τ). The algorithm
REINFORCE a uses gradient ascent to update the parameters θ in the direction of the gradient:
∇J(θ) = Eπθ(
T
X
t=0
∇θ log πθ(at|st)
T
X
t=1
rt)
Motivation of actor-critic networks
The REINFORCE algorithm introduces in high variability in cumulative reward
values (PT
t=1 rt) , leading to instability and slow convergence during training Sutton and Barto 2018. To mitigate this,
the actor-critic network strategy is employed. The actor network learns the policy distribution for action selection,
while the critic network estimates the baseline, acting as the expected long-term reward under a certain state (explained
further in Mnih et al. 2016).
The forward pass of the actor and critic networks is first introduced, followed by an explanation of how the networks
are updated based on the reward and baseline.
The actor-critic network
The actor-critic network comprises two main components: the actor and the critic. The
actor employs a policy function π(at|st; θ), parameterized by θ, to select actions, while the critic estimates action
values using a value function V π(st; θv), parameterized by θv. Due to the inability to compute the value function
directly, it is estimated using a forward view and a mix of n-step returns to update both the policy and value function.
The policy and value function are updated either after every tmax actions or when a terminal state is reached. The
training stability is enhanced through the use of parallel actor-learners, accumulating updates for improved convergence.
Both actor and critic networks are implemented as neural networks (NN), with a large input layer matching the action
space’s size, followed by smaller fully-connected layers. These layers capture significant patterns between tuples in
the database tables. In the critic network, a softmax layer outputs the policy distribution πθ(st) = Softmax(NN(st)),
defining the action probabilities. For the critic network, a linear output provides the value function V (st; θV ).
Our system trains the RL model with 32 actor and critic networks, asynchronously (as first presented at Nair et al. 2015).
This parallelization enhances exploration by allowing actors to explore different parts of the environment independently.
Different exploration policies are explicitly used in each actor-critic to maximize diversity. This approach stabilizes
learning and offers practical benefits such as reduced training time, linearly dependent on the number of parallel
actor-learners.
Training the actor critic networks
Recap that in the REINFORCE, the high variance of cumulative rewards previously
defined, leads to unstable and inefficient training. To address this, we use the V value as a baseline to be subtracted
by the rewards for reducing the variance which is produced by the critic network and it is proved that this does not
introduce any bias Sutton and Barto 2018. To be specific, we use A(st, at) = Qπ(st, at) −V π(st) (where Qπ(st, at)
is the expected return starting from state st, taking action at, then following policy π) to replace the cumulative reward
PT
t=1 rt, because it is an estimate of Qπ(st, at) and V π(st) is the baseline. Hence, the gradient becomes,
∇J(θ) ≈
T
X
t=0
[∇θlogπθ(at|st)A(st, at)]
where A(st, at) can be estimated by rt + V π(st+1) −V π(st), named by temporal-difference (TD) error. From another
perspective, since the baseline, i.e. the V value, is the expected long-term reward of a state, the TD error reflects the
advantages and disadvantages of different actions from the state. Then we discuss how to update the critic network.
To estimate the V value accurately, the difference between rt + V π(st+1) and V π(st) should be as small as possible.
Hence, we can find that the TD error can also be used to update the critic. To be specific, the loss function should be
written as Lφ = (rt + V π(st+1) −V π(st))2.
Concretely, during each episode, the policy and value function estimates are updated using the following rule:
∇θ′ log π(at|st; θ′) · A(st, at; θ, θv), where θ and θv represent the parameters for the policy and value function,
10

---

respectively. A(st, at; θ, θv) is an approximation of the advantage function, which quantifies the advantage of taking
action at in state st.
Proximal update of the policy
We can further improve the quality of the selected tuples by updating more moderately
the weights of the network by the adjusting the loss function to contain proximal policy, results in creating trust region
and clipping the surrogate objective, so the updates of the policy will be more moderate, as the maximization of the
surrogate objective without a constraint will lead to an excessively large policy update. The major difference is its use
of gradient clipping which constrain the policy updates to be within a certain ε range preventing large updates that can
cause instability.
LCLIP (θ) = ˆEt[min(rt(θ) ˆ
At, clip(rt(θ), 1 −ε, 1 + ε) ˆ
At)
were rt(θ) denotes the probability ratio rt(θ) =
πθ(at|st)
πθold(at|st). Maximizing the surrogate objective alone ˆEt[rt(θ) ˆ
At]
without a constraint will lead to excessively large policy update.
Further improvements
To encourage exploration, we incorporates the entropy of the policy π into the objective
function, mainly adding to each step component λ∇θH(πθ(·|st)). In this way, the agent is motivated to explore different
actions and learn a more diverse and effective policy. In addition, to avoid selecting the same tuple multiple times, we
implemented action masking Huang and Ontañón 2020 for each algorithm. Action masking enforces a constraint that
forbids the agents from selecting certain actions, specifically in our case, those that would result in the repetition of
a tuple. To try promote diversity among the selected tuples, we employ a regularization function that quantifies the
degree of diversity in the chosen subset using a number in [0, 1] and add that to the objective function. This approach is
based on the state of the art regularization techniques in Tian and Zhang 2022.
Overall training algorithm
Algorithm 3 summarizes the above proposed process. REINFORCE first initializes the
parameters (Line 1). In each iteration (Line 2-7), the system selects a batch of tuples from different tables using the
learned policy (Line 3). Then it computes the gradient for each trajectories (Line 4) to update the parameter (Line 6-7).
Finally, it outputs a well-trained actor-critic network, with an optimized policy of selecting tuples for approximating
non-aggregated queries.
5.2
Transforming Tabular Domain to RL Environment
Unlike the domain of computer games, where images and simple discrete information (such as remaining lives or earned
points) serve as the main source of state and simple actions such as going one unit in a given direction describe the
actions, the tabular domain has seen few algorithms utilizing database tuples as potential actions or tabular data in the
environment’s state. Our work focuses on constructing an optimal environment specifically designed for our use case
and suitable for an RL model. In this section, we elaborate on the chosen environment (briefly introduced previously in
Section 4.3) and discuss alternative environments examined in ablation studies during our experiments (Section 6).
Gradual-Set-Learning (GSL) environment
The selected environment in our system is "gradual-set-learning" (GSL).
This environment is initialized with an empty set. An action involves adding several tuples from different tables, drawn
from the action space created during the pre-processing phase. After performing an action at and reaching a state St+1,
the system evaluates the score of the new state using the metric described in Section 3, Score(St+1),which serves as
the reward for the RL agent. An episode concludes either when a terminal state is reached or when the agent reaches k
tuples (the k’th action.)
Drop-One (DRP) environment
Another alternative environment for our use case is the "drop-one" (DRP) environ-
ment. In this setup, an RL agent concludes an episode when a terminal state is reached or when a predetermined horizon
time limit is reached. The environment is initialized as a set of k tuples. Each iteration involves selecting a pair of two
actions: first, removing a tuple from the current state, and second, adding another tuple to the state. Alternatively, the
agent may choose not to change the current set. After performing an action at and reaching a state St+1 (comprising k
tuples), the environment evaluates the score of the new state using the metric described in Section 3. The reward is
calculated as the difference score(St+1) −score(St). The episode concludes when the horizon is reached, with the
default set to 100,000-500,000, adjustable by the user.
Discussion
The primary limitation of the DRP method lies in its vulnerability to becoming trapped in a non-optimal
approximation set, struggling to eliminate redundant tuples and replace them with more relevant ones. Furthermore, the
initialization phase is crucial and unstable, leading to performance variations. Despite exploring various initialization
11

---

strategies, none completely alleviated these drawbacks. Several alternative environments were also examined, particu-
larly those that combine the GSL and DRP environments. However, none of these environments achieved results as
optimal as GSL alone, and additionally, they exhibited larger deviations, indicating less stability. For a more in-depth
exploration of potential approaches to tabular data and a comprehensive understanding, further discussions and insights
are available in the ablation studies within the experiments section (Section 6).
6
Experiments
We conducted a comprehensive experimental evaluation of our system, ASQP-RL, in this section we present the results
of our experiments.
Summary of Findings
Our experiments consistently showcase the superior performance of subsets chosen by
ASQP-RL over alternatives (Figure 2). With a memory size of 15, 000 tuples (approximately 0.1% of the data), our
approach achieves an impressive 80% quality, while alternative approaches struggle to reach 60% (Figure 8). Even
under extreme memory constraints of only 1000 tuples, ASQP-RL maintains an average quality of 65%, surpassing
baselines struggling to achieve 40%. Our solution demonstrates efficiency, generating a high-quality subset in just
one hour compared to 30 −40 hours required by some baselines (Figure 2). This timeframe is practical for offline
generation of the approximation set before data exploration sessions. Additionally, in Section 4.5, we introduced a
lighter version, ASQP-Light, which, according to experimental results, creates the approximation set in 30 minutes with
a minor drop in quality. Ablation studies support default parameters and allow for user customization. The impact of
different components in our RL system is elucidated, justifying the current system architecture. Preliminary results
suggest that ASQP-RL performs well for aggregate queries, obviating the need for additional data storage beyond the
proposed subsets.
6.1
Experimental Setting
Datasets
We evaluated the performance of our system over several datasets:
1. IMDB-JOB - This dataset Leis et al. 2015 contains both data and a query workload. The data is about movies
and tv shows, and comes from IMDB. Its size is 34 million tuples.
2. MAS - The MAS dataset Microsoft 2016 contains data about researchers and publications. Its size is 600K
tuples. The query workload comes from Arad, Deutch, and Frost 2022.
3. FLIGHTS - This dataset contains information about flight delays. The data is taken from Eichmann et al.
2020 and queries are generated according to Kaoudi et al. 2020.
Baselines
To assess the effectiveness of ASQP-RL, we conduct comparisons with various baselines designed to
address related tasks and potentially offer candidate solutions for the ASQP problem (as detailed in Section 2). The
considered baselines are categorized as naive, database-oriented, and generative models, with each category featuring
advanced and diverse representatives:
Naive baselines:
1. Random sampling (RAN) - Randomly select rows from the large dataset.
2. Brute Force (BRT) - An algorithm that exhaustively checks different combinations of k tuples to find the
optimal solution. It evaluates all possible combinations to determine the best subset of tuples. To manage the
computational complexity, a time constraint of 48 hours is imposed on the algorithm. Additionally, parallel
processing with 1000 processes is used to expedite the search process by evaluating multiple combinations
simultaneously. We then return the best subset found during this process.
3. Greedy sampling (GRE) - In each iteration, take the row that achieves the largest marginal gain with respect to
the metric, eliminate this row, and repeat. The running time is limited to 48 hours and 500 processes are used
to expedite the process.
4. Top queried tuples (TOP) - Choose a random subset from each query answer. Choose queries that appear in
the most queries first, until reaching k tuples.
12

---

Baseline
IMDB
MAS
Score
setup(m)
QueryAvg(m)
Score
setup(m)
QueryAvg(m)
ASQP-RL
0.64±0.06
60 ± 7
0.16 ± 0.1
0.75425 ±0.025
30 ± 2
0.1 ± 0.12
ASQP-Light
0.53±0.09
32 ± 2
0.16 ± 0.1
0.61 ±0.04
15 ± 0.3
0.1 ± 0.12
VAE
0.0025±0.002
1920 ± 3.5
5 ± 0.03
0.045 ± 0.001
720 ± 3
2.5 ± 0.22
CACH
0.084±0.06
330 ± 12.5
0.16 ± 0.1
0.2207 ±0.085
34 ± 1.2
0.1 ± 0.12
RAN
0.29±0.03
0.72 ± 0.08
0.16 ± 0.1
0.20275 ±0.034
0.68 ± 0.024
0.1 ± 0.12
QUIK
0.343±0.04
160 ± 2
0.16 ± 0.1
0.25025 ±0.0317
60 ± 3.1
0.1 ± 0.12
VERD
0.471±0.021
200 ± 5
0.16 ± 0.1
0.3045 ±0.0467
90 ± 2.3
0.1 ± 0.12
SKY
0.347±0.001
1500 ± 1
0.16 ± 0.1
0.33362 ± 0.001
480 ± 3
0.1 ± 0.12
BRT
0.297±0.007
2880 ± 0.
0.16 ± 0.1
0.3975 ±0.001
2880 ± 0.
0.1 ± 0.12
QRD
0.3215±0.06
1800 ± 1
0.16 ± 0.1
0.377 ±0.03
35 ± 2
0.1 ± 0.12
TOP
0.2707±0.0
338 ± 21
0.16 ± 0.1
0.4592 ±0.0
36 ± 2.3
0.1 ± 0.12
GRE
N/A
2880 ± 0.
N/A
0.5177 ±0.02
2880 ± 0.
0.1 ± 0.12
Figure 2: Quality and Running time
Baselines from databases domain:
5. Caching (CACH) - Simulates a database’s cache Ahmad, Qadir, and Sanaullah 2008 by preserving tuples from
the last executed query. This involves managing limited memory to store frequently accessed data, evicting the
least recently used (LRU) pages to accommodate new ones.1
6. Query result diversification (QRD) - An algorithm based on Liu and Jagadish 2009. It follows an iterative
approach where it selects the medoids of clusters and then re-assigns the data points to their nearest medoids.
7. Skyline (SKY) - A technique for summarizing a dataset presented in Papadias et al. 2005. While a skyline is
typically used with numerical values, we extended it to handle categorical columns by comparing two values
based on their frequency.
8. Verdict (VERD) - A method for solving AQP proposed in the paper Yongjoo Park et al. 2018, that relies on
sampling, rewriting queries and adjusting the answers returned from samples.
9. QuickR (QUIK) - Another AQP method, proposed in the paper Kandula et al. 2016. QuickR relies on sampling
and table statistics to keep a catalog of plans and samples and an algorithm for choosing the right samples at
the right time.
Generative model baseline:
8. Generative Model (VAE) - We utilized a Variational Autoencoder (VAE) from Thirumuruganathan et al. 2020
as a representative of state-of-the-art generative model for approximate query processing for aggregate queries.
The VAE is used to generate fictitious tuples, and queries are executed on the generated data.
Hyperparmeters
The actor network we use consists of an input layer followed by 2 fully-connected layers and a
softmax layer for getting the logits for choosing the actions. The critic follows a similar architecture except the output
is a single number as it is used for estimating the value function. We use a learning rate of 5 · 10−5, KL coefficient
of 0.2 and entropy coefficient of 0.001. All hyperparameters choices are validated in the experiments. Finally, The
problem definition requires us to set values for parameters F, k as is explained in section 3. By default we set k = 1000
which is small enough to make the problem interesting but still large enough to make the chosen subset perform well
for queries in the workload. Additionally, we set F = 50 which is close to real world values (for example the Pandas
python library uses a 20 row limit) but still small enough to be informative for a human. We experiment with different
values for both these parameters as will be demonstrated later on. Finally, be default the system executes all the queries
given during training, this too is changed and tested in the following experiments.
Environment
ASQP-RL is implemented in Python 3.9.13 and is an open source library anonymous 2023. It can
therefore be used, e.g. in common Exploratory Data Analysis (EDA) environments such as Jupyter notebooks, to load
subsets of any database. We used Ray Moritz et al. 2018 for Reinforcement Learning, OpenAI’s Gym Brockman et al.
2016 for the environment interface and Pytorch Paszke et al. 2019 for the models. The experiments were run on an Intel
Xeon CPU- based server with 24 cores and 96 GB of RAM as well as 2 NVIDIA GeForce RTX 3090 GPUs.
1In realistic scenarios, the order of query execution may not be neatly separated by user interests, as different users could query
the same database with diverse interests, simultaneously. In our experiments, we assume this realistic use case.
13

---

Figure 5: answer
estimator
Figure 8: tuning mem
size
Figure 9: tuning frame
size
Figure 6: synthesized
workload
Figure 7: finetuning
model
Figure 11: RL param
tuning
Figure 12: AQP task
(a) Quality
(b) Time
Figure 10: Tuning 
Figure 4: Query times
Problem Justification
We begin by showing a simple experiment that shows how much were it going to take if we
simply query the database directly, in order to heighten the need for solutions such as ours. We take several versions
of the IMDB dataset, each one larger then the other (by blowing up the data). We then query the databases with the
workload in different orders and average out the time taken for each query - accumulating the results as the number
of executed queries grow. Looking at Figure 4 - one can see that even at the relatively small size of 1GB after seven
queries on average we have already passed the 5 hour mark.
6.2
Overall Evaluation
In this section, we conduct a comprehensive comparison of our system’s performance, focusing on both quality and
running time, in contrast to the baselines, across various databases. To facilitate this, we partition the workload Q into a
training set (Qtrain) and a test set (Qtest). For all baselines, the setup utilizes Qtrain (if necessary), and the evaluation
occurs over Qtest using the defined approximation quality metric (Equation 1, Section 3). To ensure reliability, we
perform multiple train-test partitions, presenting both averaged results and variance. The presented results align with
the default system parameters, and any deviations are investigated through an ablation study, revealing differences in
performance.
Quality Assessment
The comparative evaluation of our system’s quality against other baselines is succinctly pre-
sented in Figure 2, emphasizing the Score column, a reflection of our quality metric. This comprehensive examination
spans two diverse databases, namely IMDB and MAS. A stringent time limit of 48 hours was enforced uniformly across
all baselines. Our assessment encompassed both datasets, systematically appraising the efficacy of the approximation
set chosen by our algorithm vis-à-vis offerings from alternative baselines. It is imperative to underscore that the greedy
(GRE) and brute-force (BRT) baselines failed to conclude their execution within the stipulated 48-hour timeframe,
even when executed in a multi-process environment. Consequently, we present the optimal results achieved within the
imposed temporal constraints.
As evident in Figure 2, our method unequivocally outperforms conventional standard approaches. Notably, the
performance of other algorithms diverged when applied to distinct databases. This variance can be ascribed to the
relative size and intricacy of the dataset and workload. "Naive" algorithms such as brute-force (BRT) and top-k (TOP)
exhibited diminished performance when confronted with larger and more intricate workloads. Intriguingly, the VAE
algorithm garnered a subpar score due to its inability to generate realistic-looking tuples that align with query filters and
its failure to generalize over the workload. This accentuates the shortcomings in data generation concerning selection
queries.
Additionally, we present the scores achieved by ASQP-Light, an instantiation of ASQP-RL with a reduced training set,
equivalent to 25% of its original size, and a high learning rate of 0.1 (elaborated upon in subsequent discussions).
Noteworthy is the observation that this version attains an average score of 57%, while concurrently exhibiting improved
running time, as detailed in ensuing discussions.
14

---

Efficiency in Running Time
Our system’s running time is compared with other methods, focusing on both set-up
and query execution time, as delineated in Figure 2 under the setup and QueryAvg columns, respectively. The former
represents the time (in minutes) each method requires to furnish a queryable subset to the user, while the latter signifies
the time it takes to answer a given 10 queries from the workload. These measurements derive from the execution of
numerous queries, the same across baselines, with presented results being averages. ASQP-RL consistently demonstrates
competitive performance, exhibiting a brief setup time compared to most baselines.
Although naive baselines like Random (RAN) may consume less time, their quality, as indicated in the Score column,
is notably lower. Divergence exists in the operation of some baselines, notably generative approaches like the VAE,
necessitating additional time to provide an answer once a query is submitted by the user (approximately five minutes,
compared to seconds for other baselines). Noteworthy is the failure of the greedy approach to complete within the
allotted 48-hour constraint, rendering it unqueryable. An additional observation pertains to ASQP-Light (presented
earlier), showcasing a remarkable enhancement in the setup time of the system, requiring only 32 minutes for the larger
and more intricate IMDB dataset. This signifies a noteworthy stride towards efficiency in our system’s operational
timelines.
Answers Estimation Quality
A pivotal aspect of our system during the inference phase revolves around the estimator,
which, when presented with a user query, gauges whether the existing approximation set, crafted by the trained model
(as expounded in Section 4.4), can effectively address the query. To validate the efficacy of the estimator, we conducted
a series of experiments, the results of which are elucidated in Figure 5. The experimental setup involved acquiring
a set of test and training queries, generating an approximation set from our system, and subsequently querying the
estimator about the answerability of each test query. This information is then juxtaposed with the scores assigned
to the queries over the approximation set by our metric, as defined in Equation 1. Adopting a threshold of 0.5 and
above as "answerable," we calculated recall and precision to quantitatively compare the estimator’s responses with
real-world values. Impressively, as depicted in the figure, our approach achieves a remarkable 0.95 recall and 0.90
precision. Further iterations of this process involved progressively limiting the system’s access to training queries in the
training phase. As anticipated, this decrement in familiarity with queries impacted the estimator’s performance on the
test set queries. Nevertheless, even with reduced training queries (50% utilization), the precision and recall remained
noteworthy, attaining 0.75 precision and 0.85 recall.
Building upon our estimator, we implemented the full version of our algorithm. In this variant, the actual database
is queried whenever the estimator predicts a query to be unanswerable, allowing users the flexibility to decide on a
per-query basis whether they are willing to endure the requisite time for a complete answer. The first version, which
queries the database for predictions falling below 60% (according to Equation 1), attains an average score of 85% (in
contrast to an average of 70% in Figure 2). As expected, this results in a rise in "QueryAvg" time to approximately 24
minutes due to the necessity of querying the database. In a second iteration, the database is queried for predictions
below 80%, the average score is 76%, with just a ∼5-minute increase in query response time.
Handling the No Query Workload Use Case
To tackle scenarios where the query workload is not initially provided,
as elaborated in Section 4, we evaluate the system’s performance using the FLIGHTS dataset (Figure 6). The system
commences by generating multiple queries while simultaneously prompting the user to contribute a subset of queries
for refining the generated ones. After incorporating the user-provided queries into our system and constructing an
approximation set, we assess the quality of the approximated answers concerning the user’s queries. As the user
iteratively submits additional queries, the system refines its model through fine-tuning, leading to a performance
increase. Throughout this experiment, the user initiates five additional queries at each step, aiding the system in
generating more pertinent queries aligned with the user’s interests and thereby fine-tuning the model on increasingly
relevant queries.
The obtained results highlight a substantial enhancement in answer quality over successive queries, surpassing alternative
methods. We compare our approach against Random (RAN) and QRD, both capable of running without a workload.
While RAN exhibits a lack of consideration for data or workload, QRD utilizes inherent data patterns. However, QRD
lags behind our method, failing to surpass 70% accuracy, whereas our approach attains an impressive 90%.
Fine-Tuning Importance
As detailed in Section 4.4, our system performs a fine-tuning process when it captures an
interest drift in users queries. This is captured by utilizing the system’s estimator to respond to given queries with
the previously created approximation set. Figure 7 summarizes the improvement in quality following the fine-tuning
process. We start by dividing our workload into three different subtasks using a clustering algorithm on the embedded
version of queries, ensuring that the addition of new queries induces an interest drift. We then select a test sample from
each cluster for querying the system. Initially, we train the system on the first cluster and query it with the corresponding
workload. We gradually introduce parts of the test set matching the training workload the system hasn’t seen. As
15

---

anticipated, the estimator flags these queries as unanswerable, prompting the initiation of fine-tuning by providing
the training set of the second cluster. This process is repeated, incorporating the remaining training set. The results
demonstrate a rapid enhancement in the quality of the created approximation set when fine-tuning is introduced, making
it more aligned with the user’s interests.
Diversity Comparison with Other Baselines
Besides the superior quality and reduced running time of our solutions
compared to alternative methods, we conducted experiments to assess the diversity in the approximated query answers
provided by our system versus those from other baselines. Although a diversity factor was initially considered for
addition to the overall score function and later omitted due to reduced performance, we measured result diversity using a
standard metric based on pairwise Jaccard distance among query answers. A comprehensive evaluation was conducted
using the IMDB dataset, drawing inspiration from various diversity metrics in prior research (e.g., Wu et al. 2015;
Seleznova et al. 2020; Drosou and Pitoura 2010; Amsterdamer and Goldreich 2020). For an average query in the dataset
(when executed with LIMIT 100), the diversity in the answers retrieved directly from the database reached 58%. In
contrast, our solution achieved an average diversity of 52%, showcasing a minimum of 14% higher diversity compared
to any other baseline. Notably, our approach competes closely with the RAN baseline, which randomly selects tuples
from the database but significantly lags behind in terms of the quality of approximation.
6.3
System Ablation Studies and Parameters Optimization
Effects of Memory Size Constraint (k) on Quality
We investigate how the performance of all baselines is influ-
enced by changes in the memory size (k). In this experiment, we test for k in the range [103, 5 · 103, 10 · 103, 15 · 103].
As expected, all tested approaches should show improvement as the size of the subsets increases. The results in Figure
8 demonstrate that our method consistently outperforms other baselines even with increasing memory size. It achieves
an average score of 80% at k = 15 · 103, which is double the score of the GRE approach and 20% higher than SKY or
QRD.
Effects of Frame Size Constraint (F) on Quality
Similar to the previous experiment, we varied the value of the
frame size (F), incrementing it within the range of [25, 50, 75, 100]. Increasing the frame size while keeping the
memory size fixed makes the problem more challenging, as more tuples are needed for each query, leading to an overall
decrease in quality. Despite this added difficulty, ASQP-RL consistently outperforms all other baselines, as depicted in
the results presented in Figure 9. For comparison, observe SKY, which starts at 40% and decreases to 20%, struggling
with the heightened complexity. It is important to note that a reasonable value for F should not exceed a few dozen
tuples.
Effects of Training Set Size ( ˆQ) on Quality and Time
As mentioned in Section 4.1, our system takes a set of train-
ing queries denoted as ˆQ and utilizes an embedding model to determine the most significant queries to execute, denoted
as ˆQtrain. This improves overall training time, as running queries can be expensive and time-consuming. However, it
comes at the cost of quality since exposing the system to fewer queries may impact its ability to accurately answer
similar queries from the test set Qtest when training concludes. In Figure 10a, we observe the change in quality as the
size of ˆQtrain decreases, with our method maintaining reasonable quality compared to other baselines. Additionally, in
Figure 10b, we see the training time for the same set of experiments, with training reaching a very low threshold of
approximately 30 minutes.
RL Hyper-parameter Tuning
We test the influence of tuning the main hyper-parameters in the RL algorithms
and present here the results in terms of quality. Shown in Figure 11 is the tuning of the entropy coefficient in range
[0, 0.001, 0.0015, 0.01, 0.015, 0.02], the learning rate in range [5·10−5, 5·10−4, 5·10−3, 5·10−2] and the kl coefficient
in range [0.2, 0.3, 0.5, 0.7, 0.9]. We conclude that the entropy coefficient has a crucial impact on the success of the
algorithm and we’ve set it to 0.001.
RL Ablation Studies
Figure 3 summarizes ablation studies conducted on our RL architecture, aiming to validate the
contribution of each component to the overall system performance. Different environments, detailed in Section 5, were
examined, specifically crafted to transform our problem into a tabular RL environment (Environment column). For
each environment, we assessed the impact of removing individual components from our agent, such as the actor-critic
architecture and loss clipping (-ac and -ppo in the Agent column). The results indicate that the GSL environment is
most suitable for our use case. Moreover, the utilization of our actor-critic architecture, along with clip loss, proves
crucial for achieving high system performance.
16

---

Environment
Agent
IMDB
MAS
Score
Total Time (min)
Score
Total Time (min)
GSL
ASQP-RL
0.64±0.06
60 ± 7
0.75425 ± 0.025
30 ± 2
GSL
ASQP-RL - ppo
0.5360±0.003
47 ± 5.3
0.623 ± 0.071
23 ± 3
GSL
ASQP-RL - ppo - ac
0.496±0.0015
72 ± 4.3
0.618 ± 0.021
44 ± 2.2
DRP
ASQP-RL
0.3646±0.33
180 ± 12.3
0.455 ±0.0281
97 ± 3.5
DRP
ASQP-RL - ppo
0.3642 ± 0.0042
165 ± 9.3
0.429 ± 0.001
83 ± 2.5
DRP
ASQP-RL - ppo - ac
0.40120±0.016
203 ± 7.3
0.423 ± 0.011
82 ± 2
DRP + GSL
ASQP-RL
0.569±0.02
73 ± 5.1
0.619 ±0.001
49 ± 3.6
DRP + GSL
ASQP-RL - ppo
0.51±0.01
71 ± 3.3
0.59 ± 0.024
43 ± 2.9
DRP + GSL
ASQP-RL - ppo - ac
0.391±0.012
82 ± 5.3
0.51 ± 0.0015
44 ± 3.5
Figure 3: Reinforcement Learning Ablation Study
6.4
Evaluation for Aggregate queries
While our primary focus is on non-aggregate queries rather than aggregates, we conducted experiments to evaluate
the performance of our method in handling aggregate queries. This was done for two reasons: (1) Understanding
Distribution: Aggregate queries allow us to assess whether the distribution of data for specific groupings remains
consistent after creating the subset of tuples. This is crucial for understanding if our method preserves the relevant data
distribution for the user’s query workload. (2) Exploration Phase Performance: Aggregate queries are commonly used
in the exploration phase of data analysis. Testing our system’s performance on aggregate queries helps determine how
well it performs in this phase, in addition to handling non-aggregate queries.
For the AQP task, we compared our solution to two recent leading approaches: gAQP Thirumuruganathan et al. 2020
and DeepDB Hilprecht et al. 2019. gAQP uses Variational Autoencoders to generate tuples and execute AQP queries on
the generated data. DeepDB, on the other employs Sum-Product Networks to estimate the query answers. We utilized
the FLIGHTS dataset and a workload of 1000 aggregate queries generated by Eichmann et al. 2020. These queries
were divided into train-test sets for evaluation. For gAQP, we recreated the experiments on the FLIGHTS dataset
mentioned in Thirumuruganathan et al. 2020, using a memory size of 1%.
To evaluate the results, we employed a common metric for AQP tasks known as relative error (used in both Thirumu-
ruganathan et al. 2020, Hilprecht et al. 2019). This metric compares the predicted answer (apred) to the true answer
(atruth) of the query. For group by queries, the relative error is computed for each group individually and then averaged.
In cases where there are missing groups in the output, the relative error is set to 1 to indicate a complete mismatch
between the predicted and true answers. This metric allows us to quantitatively assess the accuracy of our system’s
predictions in comparison to the ground truth values. The relative error is defined as follows:
relative error = |apred −atruth|
|atruth|
(2)
In Figure 12, we present the relative errors for different query categories, including queries with sum (G+SUM, SUM),
average (G+AVG, AVG), and count (G+CNT, CNT) operators, both with and without group by clauses (respectively).
Notably, none of the existing approaches outperforms our system across all operators. In half of the operators, our
system attains the lowest error rate, surpassing state-of-the-art approaches, while in the remaining cases, we exhibit
comparable performance to at least one baseline. These preliminary results for the AQP task are promising, especially
considering that our method is not optimized for this task. Fine-tuning our method to better suit this task is left for
future work.
7
Conclusions and Future Directions
This paper defines the problem of approximating answers to non-aggregate queries, ANAQP, by creating a subset
of the dataset (an approximation set) over which queries can be executed to provide fast, high quality results. Since
it is infeasible to solve the problem exactly, we use RL to provide a good approximate solution. Offline training,
completed within 1 hour, enables on-demand calculation of the approximation set. User queries are then executed
over the approximation set with significantly reduced processing times (seconds) compared to executing them over
the full dataset (tens of minutes). ASQP-RL overcomes numerous challenges, such as the size of the action-space and
the need to generalize beyond the known workload. Experiments show ASQP-RL’s efficiency and quality compared
to other baselines. They also show that our approach performs surprisingly well for aggregate queries compared to
17

---

state-of-the-art techniques. Future work includes fine-tuning the approach, for example using more dataset statistics,
ensuring diversity in the query results, and more directly addressing aggregate queries.
References
Agarwal, Sameer et al. (2013). “BlinkDB: queries with bounded errors and bounded response times on very large data”.
In: Proceedings of the 8th ACM European Conference on Computer Systems, pp. 29–42.
Ahmad, Munir, Muhammad Abdul Qadir, and Muhammad Sanaullah (2008). “Query processing over relational
databases with semantic cache: A survey”. In: 2008 IEEE International Multitopic Conference. IEEE, pp. 558–564.
Amsterdamer, Yael and Oded Goldreich (2020). “Diverse User Selection for Opinion Procurement”. In: Proceedings of
the 23rd International Conference on Extending Database Technology, EDBT 2020, Copenhagen, Denmark, March
30 - April 02, 2020, pp. 486–497.
anonymous (2023). ASQP Github Repository. URL: https://anonymous.4open.science/r/SAQP-C90C/.
Arad, Dana, Daniel Deutch, and Nave Frost (2022). “LearnShapley: Learning to Predict Rankings of Facts Contribution
Based on Query Logs”. In: Proceedings of the 31st ACM International Conference on Information & Knowledge
Management, pp. 4788–4792.
Bar El, Ori, Tova Milo, and Amit Somech (2020). “Automatically generating data exploration sessions using deep
reinforcement learning”. In: Proceedings of the 2020 ACM SIGMOD International Conference on Management of
Data, pp. 1527–1537.
Brockman, Greg et al. (2016). “Openai gym”. In: arXiv preprint arXiv:1606.01540.
Cormode, Graham (2017). “Data sketching”. In: Communications of the ACM 60.9, pp. 48–55.
Dhanasree, K and C Shobabindu (2016). “A survey on OLAP”. In: 2016 IEEE International Conference on Computa-
tional Intelligence and Computing Research (ICCIC). IEEE, pp. 1–9.
Drosou, Marina and Evaggelia Pitoura (Sept. 2010). “Search Result Diversification”. In: SIGMOD Rec. 39.1, pp. 41–47.
ISSN: 0163-5808. DOI: 10.1145/1860702.1860709. URL: https://doi.org/10.1145/1860702.1860709.
Eichmann, Philipp et al. (2020). “Idebench: A benchmark for interactive data exploration”. In: Proceedings of the 2020
ACM SIGMOD International Conference on Management of Data, pp. 1555–1569.
Fan, Ju et al. (2020). “Relational data synthesis using generative adversarial networks: A design space exploration”. In:
arXiv preprint arXiv:2008.12763.
Galakatos, Alex et al. (June 2017). “Revisiting Reuse for Approximate Query Processing”. In: Proc. VLDB Endow.
10.10, pp. 1142–1153. ISSN: 2150-8097. DOI: 10.14778/3115404.3115418. URL: https://doi.org/10.
14778/3115404.3115418.
Hilprecht, Benjamin et al. (2019). “Deepdb: Learn from data, not from queries!” In: arXiv preprint arXiv:1909.00607.
Huang, Shengyi and Santiago Ontañón (2020). “A closer look at invalid action masking in policy gradient algorithms”.
In: arXiv preprint arXiv:2006.14171.
IBM (n.d.[a]). URL: https://www.ibm.com/topics/tm1.
– (n.d.[b]). URL: https://www.ibm.com/docs/sr/planning-analytics/2.0.0?topic=tier-tm1-server-
installation.
Kaelbling, Leslie Pack, Michael L Littman, and Andrew W Moore (1996). “Reinforcement learning: A survey”. In:
Journal of artificial intelligence research 4, pp. 237–285.
Kandula, Srikanth et al. (2016). “Quickr: Lazily approximating complex adhoc queries in bigdata clusters”. In:
Proceedings of the 2016 international conference on management of data, pp. 631–646.
Kaoudi, Zoi et al. (2020). “ML-based cross-platform query optimization”. In: 2020 IEEE 36th International Conference
on Data Engineering (ICDE). IEEE, pp. 1489–1500.
Leis, Viktor et al. (2015). “How good are query optimizers, really?” In: Proceedings of the VLDB Endowment 9.3,
pp. 204–215.
Leung, Carson K et al. (2020). “Machine learning and OLAP on big COVID-19 data”. In: 2020 IEEE International
Conference on Big Data (Big Data). IEEE, pp. 5118–5127.
Li, Kaiyu and Guoliang Li (2018). “Approximate query processing: What is new and where to go? A survey on
approximate query processing”. In: Data Science and Engineering 3, pp. 379–397.
Liu, B. and H. V. Jagadish (2009). “Using Trees to Depict a Forest”. In: Proc. VLDB Endow. 2, pp. 133–144.
Ma, Qingzhi and Peter Triantafillou (2019). “Dbest: Revisiting approximate query processing engines with machine
learning models”. In: Proceedings of the 2019 International Conference on Management of Data, pp. 1553–1570.
Mami, Imene and Zohra Bellahsene (2012). “A survey of view selection methods”. In: Acm Sigmod Record 41.1,
pp. 20–29.
Manurangsi, Pasin (2018). “A Note on Max k-Vertex Cover: Faster FPT-AS, Smaller Approximate Kernel and Improved
Approximation”. In: arXiv preprint arXiv:1810.03792.
Microsoft (2016). Microsoft academic search. URL: http://academic.research.microsoft.com.
18

---

Mnih, Volodymyr et al. (2016). “Asynchronous methods for deep reinforcement learning”. In: International conference
on machine learning. PMLR, pp. 1928–1937.
Moritz, Philipp et al. (2018). “Ray: A distributed framework for emerging AI applications”. In: 13th USENIX Symposium
on Operating Systems Design and Implementation (OSDI) 18), pp. 561–577.
Nair, Arun et al. (2015). “Massively parallel methods for deep reinforcement learning”. In: arXiv preprint
arXiv:1507.04296.
Nanda, Adhish, Swati Gupta, and Meenu Vijrania (2019). “A comprehensive survey of OLAP: recent trends”. In:
2019 3rd International Conference on Electronics, Communication and Aerospace Technology (ICECA). IEEE,
pp. 425–430.
Papadias, Dimitris et al. (2005). “Progressive Skyline Computation in Database Systems”. In: ACM Trans. Database
Syst. 30.1, pp. 41–82. ISSN: 0362-5915. DOI: 10.1145/1061318.1061320. URL: https://doi.org/10.1145/
1061318.1061320.
Park, Y., M. Cafarella, and B. Mozafari (2016). “Visualization-aware sampling for very large databases”. In: ICDE.
Park, Yongjoo et al. (2018). “Verdictdb: Universalizing approximate query processing”. In: Proceedings of the 2018
International Conference on Management of Data, pp. 1461–1476.
Paszke, Adam et al. (2019). “Pytorch: An imperative style, high-performance deep learning library”. In: Advances in
neural information processing systems 32.
Rehman, Muhammad Habib ur et al. (2016). “Big data reduction methods: a survey”. In: Data Science and Engineering
1, pp. 265–284.
Seleznova, Mariia et al. (2020). “Guided exploration of user groups”. In: PVLDB 13.9, pp. 1469–1482.
Sutton, Richard S and Andrew G Barto (2018). Reinforcement learning: An introduction. MIT press.
Thirumuruganathan, Saravanan et al. (2020). “Approximate query processing for data exploration using deep generative
models”. In: 2020 IEEE 36th international conference on data engineering (ICDE). IEEE, pp. 1309–1320.
Tian, Yingjie and Yuqi Zhang (2022). “A comprehensive survey on regularization strategies in machine learning”. In:
Information Fusion 80, pp. 146–166.
Vieira, Marcos R et al. (2011). “On query result diversification”. In: 2011 IEEE 27th International Conference on Data
Engineering. IEEE, pp. 1163–1174.
Wu, Ting et al. (2015). “Hear the Whole Story: Towards the Diversity of Opinion in Crowdsourcing Markets”. In:
PVLDB 8.5.
19

---

