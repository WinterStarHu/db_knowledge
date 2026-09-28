# Dimensionality Reduced Clustered Data and Order Partition and Stepwise Dimension

> 来源: https://arxiv.org/pdf/2401.02858

arXiv:2401.02858v1  [cs.DB]  5 Jan 2024
Dimensionality Reduced Clustered Data and Order
Partition and Stepwise Dimensionality Increasing
Indices
Alexander Thomasian
Thomasian & Associates
Pleasantville, NY 10570 USA
alexthomasian@gmail.com
ABSTRACT
One of the goals of NASA funded project at IBM T. J.
Watson Research Center was to build an index for sim-
ilarity searching satellite images, which were character-
ized by high-dimensional feature image texture vectors.
Reviewed is our eﬀort on data clustering, dimensional-
ity reduction via Singular Value Decomposition - SVD
and indexing to build a smaller index and more eﬃ-
cient k-Nearest Neighbor - k-NN query processing for
similarity search.
k-NN queries based on scanning of
the feature vectors of all images is obviously too costly
for ever-increasing number of images. The ubiquitous
multidimensional R-tree index and its extensions were
not an option given their limited scalability dimension-
wise. The cost of processing k-NN queries was further
reduced by building memory resident Ordered Partition
indices on dimensionality reduced clusters. Further re-
search in a university setting included the following:
(1) Clustered SVD was extended to yield exact k-NN
queries by issuing appropriate less costly range queries,
(2) Stepwise Dimensionality Increasing - SDI index out-
performed other known indices, (3) selection of optimal
number of dimensions to reduce query processing cost,
(4) two methods to make the OP-trees persistent and
loadable as a single ﬁle access.
1.
INDEXING USING DIMENSIONAL-
ITY REDUCTION AND CLUSTERING
We describe an aspect of a NASA-sponsored project
at IBM T. J. Watson Research Center. Similarity search
was to be carried out on images generated at a high vol-
ume (281 GB/day) by Earth Observing System - EOS
platforms launched in 1998 and 2000 [52].
Three options for conducting content search were con-
sidered and the third option adopted.
1-Flat ﬁles:
Each image treated as Binary Large OBject - BLOB.
Such databases do not scale well due to image sizes and a
large number of images. 2-Graph-based: The seman-
tics of each object extracted and stored in a graph [29].
3-Feature-based: Image texture, shape, and color ex-
tracted and stored as its attributes.
Copyright is held by author/owner(s).
Representing images by their feature vectors and search-
ing for similarity according to Euclidean distances of the
points representing them in high dimensional space via
k-nearest neighbor - k-NN queries to a target image is
a popular similarity search paradigm [12].
Query by Image Content - QBIC was an early project
in this area at IBM’s Almaden Research Center - ARC
[44].
QBIC utilized Content-Based Image Retrieval -
CBIR for similarity search [44]. Images were ﬁrst char-
acterized by their features and similarity measures de-
ﬁned. In a second step features such as color, texture,
and shape were extracted. Only texture was considered
in this project, although color is also applicable.
The similarity of images represented as points in high-
dimensional space is determined by k-NN queries which
are preferable to range queries, although they are more
expensive [47].
This is so since range queries with a
large (resp.
small) radius may yield too many (resp.
too few) similar images.
The performance of similarity retrieval from satellite
image databases by using diﬀerent sets of spatial and
transformed-based texture features comparison led to
the conclusion that the proposed feature set is superior
for the satellite images [36].
A benchmark consisting
of 37 satellite image clips from various satellite instru-
ments was used for the experiments. The result indi-
cated that more than 25% of the benchmark patterns
can be retrieved with more than 80% accuracy by using
Euclidean distances.
Feature extraction is a general term for methods of
constructing combinations of the variables to get around
problems, while still describing the data with suﬃcient
accuracy. Texture features extraction from satellite im-
ages is described in [53],[42],[24]. Gray Level Co-occurrence
Matrix - GLCM is formulated to obtain statistical tex-
ture features.
A number of texture features may be
extracted from GLCM.
Higher dimensionality reduction is achieved by apply-
ing Singular Value Decomposition - SVD [26],[18],[49],[21]
to feature vectors in individual clusters, as quantiﬁed by
the Normalized Mean Square Error - NMSE given below
by Eq. (6). Signiﬁcant improvement in processing cost
via Clustered SVD - CSVD vs SVD and no dimension-
ality reduction by sequential scan are quantiﬁed. Re-
cursive CSVD - RCSVD is a generalization of CSVD,
but clustering was applied once in our studies [57, 58,

---

59]
The cost of processing k-NN queries is further reduced
by indexing structures suited for k-NN queries such as
the extended Ordered-Partition - OP-tree [28] utilized in
[13] and the Stepwise Dimensionality Increasing - SDI-
tree index described and implemented in [62].
The paper is organized as follows. Nearest neighbor
queries are discussed in Section 2. Dimensionality re-
duction methods are discussed in Section 3. Clustering
methods for large and high dimensional datasets in Sec-
tion 4.
Clustering methods combined with DVD are
discussed in Section 5. Steps taken to build a CSVD
index for k-NN queries are discussed in Section 6. NN
query processing with multiple clusters is discussed in
Section 7 Indexes for k-NN search on dimensionality re-
duced data are discussed in Section 8. OP-tree and SDI
indexes are discussed in Subsections 8.1 and 8.2. Con-
clusions and further work are discussed in Section 9
2.
NEAREST NEIGHBOR QUERIES
k-NN queries are based on the Euclidean distance cor-
responding to p = 2 in Eq. (1) between a target point
(v) and points in a dataset (u) represented with n di-
mensions.
D2(u, v) =
" n
X
i=1
|ui −vi|p
#1/p
.
(1)
Given precomputed norms, only requires the computa-
tion of the inner product of the vectors.
D2(u, v) = ||u||2 + ||v||2 −2u × v
More complex distance functions such as Mahalanobis
distance [18] were not considered in this study.
https://en.wikipedia.org/wiki/Mahalanobis_distance
k-NN queries can be implemented by a sequential scan
of the dataset holding the feature vectors of all images
with running time O(MN), where M is the dataset car-
dinality (number of images) and N is the dimensional-
ity (number of features). Interestingly, sequential scan
may outperform multidimensional indexing methods for
higher dimensions, since a high number of pages are ac-
cessed and it is more eﬃcient to access all pages sequen-
tially without incurring individual positioning time per
page. 1
Clustering combined with SVD attains higher CBIR
eﬃciency, since higher dimensionality reduction is at-
tained by taking advantage of local correlations in clus-
tered data [58]. Clustering potentially reduces the cost
of k-NN search by the number of clusters (H) on the av-
erage, given an almost equal number of points per clus-
ter and that one or just a few clusters need be searched.
We postulate that clusters can be represented by hy-
perspheres speciﬁed by their centroid, which is the mean
over all dimensions, and radius, which is the distance of
the farthest point in the cluster from the centroid. The
hyperspheres may intersect.
1Interestingly a reference to a page in a ﬁle results in
the prefetching of the whole ﬁle by some operating sys-
tems, making a measurement study diﬃcult, but there
are ways to suppress prefetching.
A higher level index is used to select the clusters to be
visited, i.e., the cluster with the closest centroid or the
one with the closest hypersphere surface. The farthest
K-NN point from a query point constitutes its hyper-
sphere. When it intersects the hypersphere of another
cluster that cluster need be searched.
Most indexing structures, such as R-trees [22] perform
poorly for higher dimensions, since multiple Minimum
Bounding Rectangles - MBRs with possible overlap need
to be searched. According to [46] R-trees for fanout > 2
are robust for at least 20 dimensions
R∗-trees support point and spatial data at the same
time with implementation cost slightly higher than R-
trees guarantee 50% space eﬃciency [5].
The perfor-
mance of R∗-trees is compared with R-trees and shown
to be superior. R∗-trees were adopted in [44] attaining
70% space eﬃciency. The Karhunen-Lo`eve Transform
(KLT) discussed in the next section was used in the
study for dimensionality reduction. Two other indexing
structures are considered in our studies OP-trees [28] in
[13] and the SDI-tree in [63].
3.
DIMENSIONALITY REDUCTION
Principal Component Analysis (PCA), Singular Value
Decomposition (SVD), and KLT are related methods to
reduce the number of dimensions after rotating coor-
dinates to attain the minimal information loss (in the
form of variance) for the desired level of data compres-
sion [18],[11].
Consider matrix X whose M rows are feature vectors
of images. Each image has N features which constitute
the columns of X. The feature vectors are normalized
or studentized as
(Xi,j−¯xi)/si, 1 ≤i ≤N where siis the std deviation , ∀j.
The SVD of X is given as the product of three matrices
[18]:
X = UΣV T ,
(2)
where U is an M × N column-orthonormal matrix, V
is an N × N unitary matrix of eigenvectors, and Σ is
a diagonal matrix of singular values. Without loss of
generality we can arrange columns such that:
σi ≥σi+1, i = 1, . . . , N −1.
The rank of X is the number of singular values, which
are not zero or close to zero [18]. The cost of comput-
ing eigenvalues using SVD is O(MN 2). PCA is based
on eigenvalue decomposition of the covariance matrix
deﬁned as:
C = 1
M XT X = V ΛV T ,
(3)
where V is the matrix of eigenvectors as in Eq. (2) and
the diagonal matrix Λ = λ1, . . . , lambdaN holds the
eigenvalues. Since C is positive-semideﬁnite its N eigen-
vectors are orthonormal and its eigenvalues are nonneg-
ative [21].
In addition to the cost of computing C, which is
O(MN 2) the cost of computing the eigenvalues is O(N 3).

---

Assuming that λi similarly to the singular values, are
in nonincreasing order, it follows from Eq. 4
λi = σ2
i /M and conversely σi =
√
Mλi, 1 ≤i ≤N.
C = 1
M XT X = 1
M (V ΣU T )(UΣV T ) = 1
M V Σ2V T . (4)
The eigenvectors constitute the principal components
of X, hence the following transformation yields uncor-
related features:
Y = XV.
(5)
Retaining the ﬁrst n dimensions of Y maximizes the
fraction of preserved variance and minimizes the NMSE
for the given dimensionality reduction:
NMSE =
PM
i=1
PN
j=n+1 y2
i,j
PM
i=1
PN
j=1 y2
i,j
=
PN
j=n+1 λj
PN
j=1 λj
(6)
Dimensionally reduced data via SVD allows approxi-
mate processing of k-NN queries. The quality of approx-
imate retrieval is usually quantiﬁed with two metrics:
Recall R and Precision P.
Let A(q) denote the subset of the data set contain-
ing the k most similar objects to a query point q. To
account for the approximation, one may request a re-
sult set B(q) containing more than k elements.
Let
C(q) = A(q) ∩B(q).
The precision P is the expected fraction of the re-
sult sets whose elements are among the desired k closest
points to q.
P = E[|C(q)|/|B(q)|].
Recall R is the expected fraction of the desired k
closest objects to q that are retrieved by the query, The
expectation E is taken with respect to the measure that
generated the data set):
R = E[|C(q|)
|(Bq)|].
R can be increased at the expense of P by increasing
the size of B(q) and vice-versa. The number of results
that must be retrieved for a k-NN query to yield a pre-
cision P and recall R is K∗(k) = kR/P
Data reduction methods are surveyed in [4]. SVD was
used in [31] to compress data so that it can be ﬁtted into
main memory for k-NN query processing.
The SVD
code provided in “Numerical Recipes” [49] was used in
results presented in [58, 59], while the IBM’s Engineer-
ing and Scientiﬁc Subroutine Library - ESSL [25] was
used in [13]. In computing the Euclidean distance with
dimensionally reduced data, we used the method de-
scribed in the Appendix of [64], which is more eﬃcient
method than the one in [31]
4.
CLUSTERING METHODSFOR LARGE
AND HIGH DIMENSIONAL DATA
Cluster analysis partitions a set of objects speciﬁed by
multidimensional feature vectors into clusters. Clusters
can be speciﬁed simply by a centroid and a radius where
each hypersphere may intersect with one or more hyper-
spheres. Thus in higher dimensional spaces some points
assigned to a cluster may be inside the hypersphere of
multiple clusters.
Clustering of high dimensional data is classiﬁed as:
(1) subspace, (2) pattern-based, and (3) correlation clus-
tering in [34]. All clustering algorithms tend to break
down in high dimensional spaces, because of the inher-
ent sparsity of the points.
The problem clustering very large datasets and mini-
mizing I/O costs. was addressed in [72] which presents
the Balanced Iterative Reducing and Clustering using
Hierarchies - BIRCH method, and demonstrates that it
is especially suitable for very large databases. BIRCH
incrementally and dynamically clusters incoming multi-
dimensional metric data points to try to produce the
best quality clustering with the available resources While
a single scan of the data is usually adequate, the cluster-
ing quality improves with additional scans. According
to [30] BIRCH reduces the problem of clustering a very
large data sets into the one of clustering the set of “sum-
maries” which are potentially much smaller.
DBSCAN connects regions of suﬃciently high den-
sities into clusters [16].
As such it does a better job
ﬁnding elongated clusters than most of the algorithms.
It uses an R∗tree to achieve good performance.
STING is a hierarchical cell structure that stores sta-
tistical information (e.g., density) about the objects in
the cells [66]. Clustering can be achieved by using the
stored information with only one scan of the dataset,
but without recourse to the individual objects.
A spatial data mining algorithm Clustering Large Ap-
plications based upon RANdomized Search - CLARANS
on spatial data is presented in [43]. While it represents
a signiﬁcant improvement on large data sets over tra-
ditional clustering methods its computational complex-
ity is quite high. While it is claimed that CLARANS
is linearly proportional to the number of points (M),
the algorithm is inherently at least quadratic, which
is because CLARANS applies a random search-based
method to ﬁnd an “optimal” clustering. This observa-
tion is consistent with the results of experiments in [66]
and [16] which show that the performance of CLARANS
is close to quadratic in the number of points.
More-
over, the quality of the results for large M can not be
guaranteed, since randomized search is used in the algo-
rithm. is addition CLARANS assumes that all objects
are stored in main memory, which limits the size of the
database to which CLARANS can be applied. A perfor-
mance comparisons of BIRCH versus CLARANS shows
that BIRCH is consistently superior.
5.
COMBINED CLUSTERING AND SVD
Clustering allows SVD to take advantage of local cor-
relations, which result in a smaller NMSE versus apply-
ing SVD to the whole datasets. Consider points in three
ellipsoid surrounding nonintersecting straight lines in 3-
dimensions, where each can be speciﬁed by a single di-
mension after clustering, i.e., a 3-fold reduction in space
requirements and computational cost for k-NN queries.
Subspace clustering ﬁnds clusters in diﬀerent lower-

---

Predicted
Positive (PP)
Negative (PN)
Actual
Positive (P)
True +ve (TP)
False -ive (FN)
Negative (N)
False +ve (FP)
True -ive (TN)
Table 1: A small confusion table.
dimensional subspaces of a dataset taking advantage
of the fact that many dimensions in high dimensional
datasets are redundant and hide clusters in noisy data
[34] A recent comprehensive survey of this topic is [50].
CLustering In QUEst - CLIQUE (a data mining
project at IBM’s ARC) combined density and grid based
clustering [3]. An a priori style Association Rule Mining
- ARM search method is used to ﬁnd dense subspaces
[3]. Once the dense subspaces are found they are sorted
by coverage and only subspaces with the greatest cov-
erage are kept and the rest are pruned. The algorithm
then looks for adjacent dense grid units in each of the se-
lected subspaces using a depth ﬁrst search. Clusters are
formed by combining these units using a greedy growth
scheme. The algorithm starts with an arbitrary dense
unit and greedily grows a maximal region in each di-
mension, until the union of all the regions covers the
entire cluster. The weakness of this method is that the
subspaces are aligned with the original dimensions.
Projected Clustering (ProClus) uses an algorith-
mic framework to determine the number of dimensions
in each such cluster-speciﬁc subspace [1].
ORiented
projected CLUSter (ORCLUS) diﬀers in that sim-
ilarly to Clustered SVD (CSVD) [58] it looks for non-
axes parallel subspaces [2]. The algorithm can be di-
vided into three steps: (1) Assign phase assigns data
points to the nearest cluster centers. (2) Subspace de-
termination redeﬁnes the subspace associated with each
cluster by calculating the covariance matrix. for PCA.
(3) Merge phase merge clusters that are near each other.
The number of clusters and the subspace dimensional-
ity must be speciﬁed and a general scheme for selecting
suitable values is provided, A statistical measure called
the cluster sparsity coeﬃcient is provided, which can
be inspected after clustering to evaluate the choice of
subspace dimensionality.
The confusion matrix as deﬁned below for several ex-
periments is presented.
The matrix allows visualiza-
tion of the performance of an algorithm. Each row of
the matrix represents the instances in an actual class,
while each column represents the instances in a pre-
dicted class.
https://en.wikipedia.org/wiki/Confusion_matrix
Given a total population = P+N, where P stands for
Positive and N for Negative (as in cancer) we have Ta-
ble 1,
The accuracy of the clustering is determined by match-
ing of points in input of output clusters.
One of the
weaknesses of this study is that it uses synthetic datasets.
Algorithm 4C - Computing Correlation Con-
nected Clusters in [6] combining PCA and density-
based clustering - DBSCAN paradigm was determined
to be robust against noise. 4C has superior performance
over competing methods such as DBSCAN, ORCLUS,
and Clustering in Quest - CLIQUE, which is a simple
grid-based method.
Local Dimensionality Reduction - LDR gener-
ates SVD-friendly clusters in an attempt to attain a
higher dimensionality reduction [14]. LDR takes advan-
tage of Lower Bounding Property - LBP [32] to attain
exact query processing. It produces fewer false alarms
by incorporating the reconstruction distance (the squared
distance of all dimensions that have been eliminated) as
an additional dimension with each point. It is shown
experimentally in [13] that CSVD outperforms LDR in
over 90% of cases. A succinct description of the LDR
method given in the Appendix of [13] was the basis of
an independent implementation. Exact processing of k-
NN queries on dimensionality reduced data is discussed
in [32] and the method used in [64] is described in Sub-
section 7.1.
Ratio of the number dimensions retained by SVD to
the number of dimensions retained (resp. volume) by
CSVD and LDR as a function of the NMSE is given by
Figure 4 (a) (resp. 4 (b) in [13] As the number of clusters
is increased CSVD shows signiﬁcant improvement.
To deal with huge amounts of information generated
by Twitter requires a method of automatically detect-
ing topics.
One such method is K-means clustering.
Given that the large dimensions become an obstacle to
applying clustering SVD was used to reduce the dimen-
sion of the data prior to clustering.
The accuracy of
the combination of SVD and K-means Clustering meth-
ods showed comparative results, while the computation
time required is likely to be faster than the method of
K-means clustering without any reduction in advance.
6.
CSVD INDEX FOR K-NN QUERIES
The following steps are followed for combining SVD
and clustering in [13]:
Select an objective function: (1) Index Space Com-
pression - ISC which is the ratio of the the original
size, which is N · M to the size attained after ap-
plying SVD to H clusters, denoted by V given by
Eq.
7; (2) NMSE given by Eq. (6); (3) desired
recall.
V = N · H +
H
X
h=1
(N · ph + mh · ph)),
(7)
where mh is the number of points and ph the num-
ber of dimensions retained in the hth cluster after
rotating coordinates, denoted by Y(h) (refer to
Eq. 5). The ﬁrst term Eq. 7 for the space re-
quired by the centroids of H clusters, while N · ph
is the space occupied by the projection matrix
and mh · ph is the space required by the projected
points.
Selecting the number of clusters: H can be speci-
ﬁed by the user or determined by database size.
Some clustering algorithms determine the desired
number of clusters.
Partitioning: This step divides the row of table X into
H clusters: X(h), h = 1, . . . , H with m1, . . . , mH
points. The k-means method does not scale well to

---

high dimensions. CSVD supports a wide range of
classical clustering methods such as Linde-Buzo-
Gray - LBG [40], The reported results were ob-
tained with a standard LBG clustering algorithm,
where the seeds were produced by a tree struc-
tured vector.
For each cluster, this step deter-
mines the centroid µ(h), and the cluster radius
R(h), i.e., the distance of the farthest point from
the centroid. The coordinates of the centroid µ(h)
are subtracted from each group of vectors X(h).
Rotating partitions: For X(h), h = 1, . . . , H the eigen-
vectors are computed according to Eq. (2) or Eq. (3)
for the partition.
The coordinates of points in
partitions are rotated into uncorrelated frames of
reference separately for each cluster according to
Eq. 5.
Dimensionality reduction. This is a global proce-
dure, which depends on the selected objective func-
tion. The products of λ(h)
i
mh, ∀i, ∀h are sorted in
ascending order to produce an ordered list L of
H ·N elements. Each element j of the list contains
the label κj of the corresponding cluster, and the
dimension ∂j associated with the eigenvalue. The
list L is scanned starting from its head. During
step j, the ∂th
j
dimension of the κth
j
cluster is dis-
carded. The process ends when the target value
of the objective function is reached:
Index space compression: The index volume is
computed using Eq. (7). and the NMSE is
recomputed using Eq. (8).
NMSE =
PH
h=1
Pmh
i=1
PN
j=nh+1(y(h)
i,j )2
PH
h=1
Pmh
i=1
PN
j=1(y(h)
i,j )2
(8)
=
PH
h=1 mh
PN
j=nh+1 λ(h)
j
PH
h=1 mh
PN
j=1 λ(h)
j
.
Ensuring recall: As dimensions are omitted an
experiment is run to determine the recall with
a suﬃciently large number of sample queries
[13].
Constructing the within-cluster index: Build index
for cluster Y(h), 1 ≤h ≤H.
7.
NEAREST-NEIGHBORSQUERIESWITH
MULTIPLE CLUSTERS
k-NN queries follow a branch-and-bound algorithm.
At ﬁrst the feasible region of the search problem is the
entire space and the partition is given by the clustering.
During the search the target function is upper-bounded
by the distance of the current kth neighbor. The fea-
sible regions are pruned by discarding clusters having
distance larger than the running upper-bound. The fol-
lowing steps are used in carrying out the k-NN queries:
Preprocessing and primary cluster identiﬁcation.
The query vector qorig is preprocessed to yield q
For k-means and LBG the primary cluster is the
one with closest centroid.
Computation of distances from clusters: The dis-
tance between the preprocessed query point q and
cluster i is deﬁned as:
max
nh
D(q, µ(i) −R(i)i
, 0
o
.
The clusters are sorted in increasing order of dis-
tance in a list L with the primary cluster in ﬁrst
position.
Searching the primary cluster: This step produces
a list of k-NN points ordered in increasing order of
distance. Let dmax be the distance of the farthest
point in the list.
Searching the other clusters: If the distance to the
next cluster in the list of clusters K does not ex-
ceed dmax, then the cluster is searched, otherwise,
the search is terminated. While searching a clus-
ter, if points closer to the query than dmax are
found, they are added to the list of k current best
results, and dmax is updated.
Precision P as a function of NMSE parameterized by
the number of clusters for R = 0.9 and R = 0.8 is
given in Figures 6(a) and 6(b). The number of clusters
is varied 1:32 and the improvement in precision is more
signiﬁcant in the latter case.
Speedups attained by CSVD are given in [13] CSVD
with OP-tree indexes retrieves data between ﬁve and 20
times faster than with within-cluster sequential scan.
7.1
Exactversus Approximate k-NN Queries
Post-processing to attain exact k-NN processing takes
advantage of the Lower-Bounding Property - LBP [18]
(also Lemma 1 in [32]):
Given that the distance of points in the sub-
space with reduced dimensions is less than
the original distance, a range query guar-
antees no false dismissals.
False alarms are discarded by referring to the original
dataset. Noting the relationship between range and k-
NN queries, the latter can be processed as follows [32]:
(1) Find the k nearest neighbors of the query point Q
in the subspace.
(2) Determine the farthest actual distance to Q among
these k-NN points, denoting it by dmax.
(3) Issue a range query centered on Q with radius dmax.
(4) For all points obtained in this manner ﬁnd their
original distances to Q,
by referring to the original dataset and rank the points,
i.e., select the k-NNs.
The exact k-NN processing method was extended to
multiple clusters in [60], where we compare the CPU
cost of the two methods as the NMSE is varied. An of-
ﬂine experiment was used to determine k∗, which yields
a recall R ≈1. The CPU time required by the exact
method for a sequential scan is lower than the approxi-
mate method, even for R = 0.8. This is attributable to

---

the fact that the exact method issues a k-NN query only
once and this is followed by less costly range queries.
Optimal data dimensionality reduction [38] is studied
in the context of the exact query processing [64]. At
one extreme retaining all dimensions does not require
post processing, while at the other extreme the cost of
the initial K-NN processing step is reduced with few
dimensions, but there is an increase in postprocessing
cost, so that a minimum CPU cost is observed as the
NMSE is varied.
8.
HIGH-DIMENSIONAL INDICES
Points are best represented by Point Access Methods
- PAMs, since otherwise Spatial Access Methods - SAMs
have MBRs with overlapping diagonal edges, so that the
space requirement for points is doubled [20]
Multidimensional indexing structures can be classi-
ﬁed as Data Partitioning (DP), such as R-tree [22] and
its descendants, SS-tree [68], SR-trees [27] and Space
Partitioning (SP), such as KDB-tree [55], OP-tree [28],
hB-tree [41].
With the increasing dimensionality of feature vectors,
most multi-dimensional indices lose their eﬀectiveness
due to so-called dimensionality curse [18, 12]. This re-
sults in an increased overlap among the nodes of the
index and a low fanout, which results in increased in-
dex height.
In memory (resp.
disk resident) indices
CPU time (resp.
number of disk pages accesses) are
performance metrics of interest.
Indexing structures are discussed in [12],[56].
8.1
Ordered Partition (OP)-Tree
The OP-tree index described in [28] for eﬃcient pro-
cessing of k-NN queries recursively equi-partitions data
points one dimension at a time in a round-robin man-
ner until the data points can ﬁt into a leaf node. The
two properties of OP-trees are ordering and partition-
ing.
Ordering partitions the search space and parti-
tioning rejects unwanted space without actual distance
computation. A fast k-NN search algorithm by reduc-
ing the distance based on the structure is described in
[28].
An OP-tree with the following twelve data points with
one point per partition is shown in Figures 1. The struc-
ture of the trees is shown in Figure 2.
1 :(1, 2, 5), 2 :(3, 8, 7), 3 :(9, 10, 8),
4 :(12, 9.2), 5 :(8, 7, 20), 6 :(6.6.23),
7 :(0, 3, 27), 8 :(2, 13.9), 9 :(11, 11, 15),
10 :(14, 17, 13), 11 :(7, 14, 12), 12 :(10, 12, 3).
The original OP-tree index with one point per par-
tition was extended to allow multiple points per parti-
tion in [13]. The modiﬁed OP-tree recursively divides
the space into regions which contain approximately the
same number of data elements. Partitioning is carried
out with dimensions selected in a round-robin fashion.
Although probably not the optimum method, it has sev-
eral appealing properties:
(1) using dimensions in decreasing (non-increasing) or-
der of eigenvalues;
(2) it produces equal-sized buckets, which can be se-
lected to be a database page,
(3) each split has ﬁxed fan-out;
 
 
 
 
 
A
B
C
D
E
F
G
H
I
J
 
 
 
K
L
1
s
t
d
i
m
2
n
d
d
i
m
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
 .
.
.
.
.
.
.
.
.
.
 .
.
Figure 1: An OP-tree with 12 points with one
point per partition
A
B
C
D
E
F
G
H
I
J
K
L
4
 
w
a
y
s
 
p
a
r
t
i
t
i
o
n
 
a
t
f
i
r
s
t
 
d
i
m
e
n
s
i
o
n
3
 
w
a
y
s
 
p
a
r
t
i
t
i
o
n
 
a
t
s
e
c
o
n
d
 
d
i
m
e
n
s
i
o
n
Figure 2: The corresponding linked-list hierar-
chical structure.
(4) splits are not constrained to be binary, between three
and ﬁve is best,
2 (5) the tree can be easily represented using an array
and searched eﬃciently,
(6) with the Euclidean distance, analyzing a node re-
quires at most two ﬂoating point operations (multiply-
add) and two tests; it is trivial to determine the distance
between the query point and the current hyperplane;
there is no overlap between the regions indexed by in-
ternal and leaf nodes. The OP-tree is 5-20 faster than
sequential scans [13].
The building of a persistent semi-dynamic OP-tree
index is presented in [61, 63]. Serialization is used to
compact the dynamically allocated nodes of the OP-tree
in main memory, which form linked lists, into contiguous
memory locations. Alternatively, the index can be build
directly to fulﬁll this condition. The index can then be
saved onto disk as a single ﬁle and loaded into main
memory with a single data transfer.
This takes less
time than loading individual index pages one at a time,
because of the high positioning time which would be
incurred per page.
Disk access time is a sum of seek, rotational latency
and transfer time Seek time is improving slowly and
latency is one half of disk rotation time for small block
2It is said elsewhere “ﬁve is the default, since in experi-
ments, 4-way to 6-way splits yield better results”. Split
was probably 5-way.

---

accesses, i.e.
60,000/(2 RPM), e.g., 8.33 ms for 7200
RPM disks, and transfer times tends to be less than a
ms for small blocks, since there are ≈1000 512 B blocks
on a track, e.g. 8 × (8.333/1000) ≈0.067
8.2
StepwiseDimensionality Increasing-tree
This index is aimed at reducing disk access and CPU
processing cost [62].
The index is built using feature
vectors transformed via PCA. Dimensions are retained
in nonincreasing order of their variance according to a
parameter p (discussed below). The SDI-tree shown in
Figure 3 is a disk-resident index with each node corre-
sponding to a disk page. Starting with a few features at
the highest level, the number of retained feature vector
elements is increased to include all of the dimensions.
SDI-tree
Figure 3: The SDI-tree representation
A node of the index is an array of entries EntrySize,
which is a function of the dimensionality. Given page
size S and nℓ≤N as the number of dimensions at level
ℓthe fanout at level ℓis: Fℓ≈S/EntrySize(nℓ). The
nodes of the tree are organized as hyperspheres, with
both the centroid and the radius calculated based on nℓ
dimensions.
To determine the number of dimensions nℓand the
fanout Fℓat level ℓ, a parameter p specifying the frac-
tion of increased variance at successive levels of the in-
dex is employed, starting with the highest level, until
100% variance is achieved. The number of dimensions
selected at level ℓ≥1 satisﬁes:
Xnℓ
k=1 λk/
XN
k=1 λk ≥min(ℓ× p, 1).
Figure 4(a) shows the cumulative normalized variance
versus the number of dimensions for dataset COLH64 in
[13]. With p = 0.20 the number of dimensions at level
one through ﬁve is 2, 4, 8, 16 and 64. Figure 4(b) shows
the case for dataset TXT55 with p = 0.30. The number
of dimensions at level one through four is 2, 8, 21, and
55.
The ∆-tree is a main memory index structure, which
represents each level with a diﬀerent number of dimen-
sions [15]. The number of dimensions increases towards
the leaf level, which contains full dimensions of the data.
The SDI index diﬀers from the ∆-tree in that it is a disk
resident index structure with ﬁxed node sizes, while the
∆-tree is a main memory resident index with variable
node sizes and ﬁxed fanouts.
The Telecsopic Vector - TV-tree is an indexing method
for high dimensional objects, which beneﬁts from its
Figure 4: Cumulative variance v.s.
number of
dimensions. (top) COLH64. (bottom) TXT55.
ability to dynamically use a variable number of dimen-
sions to distinguish between objects [39]. Since the num-
ber of required dimensions is usually small, the method
saves space and this leads to a larger fan-out. Fewer
disk accesses are required since the tree is shallow. The
SDI-tree diﬀers from the TV-tree in that it uses a sin-
gle parameter, specifying the fraction of variance to be
added to each level, without the risk of having a large
number of active dimensions.
SDI trees are compared to VAMSR-trees and the VA-
ﬁle indexes in [62]. The VAMSR-tree uses the same split
algorithm as VAMSplit R-tree [69], but it is based on
an SR-tree structure. Experiments reported in [62] have
shown that SDI-trees access fewer disk pages and incur
less CPU time than SR-trees [27], VAMSR-trees, Vector
Approximation - VA-Files, and the iDistance method.
In CPU time SDI outperforms the sequential scan and
OMNI methods.
9.
CONCLUSIONSAND FURTHER WORK
CSVD combines clustering with SVD providing high
eﬃciency in processing k-NN queries [10, 13].
Unlike B+ trees [51] and the R-tree, the OP-tree and
the SDI index have the drawback of not being dynamic,
i.e., not allowing additions, while deleted points can be

---

speciﬁed as such by a single bit. Given that the original
OP-tree is static, the OP-tree has to be rebuild in main
memory as new points are added.
Four methods supporting inserting new points in semi-
dynamic OP-trees and their performance and space ef-
ﬁciency is compared in Section 4.5.1 in [70] and [61, 63].
Techniques for performing SVD-based dimensionality
reduction in dynamic databases are discussed in [54],
The dynamic R∗index in [54] allows point insertions
and deletions, but the issue is the degradation in query
precision, when the data distribution changes consider-
ably. The SVD transform incorporates existing index
structure, but recomputes the SVD-transform using ag-
gregate data from the existing index rather than the en-
tire data. This technique reduces the SVD-computation
time without compromising query precision. We explore
ways to eﬃciently incorporate the recomputed SVD-
transform in the existing index structure without de-
grading subsequent query response times. These tech-
niques reduce the computation time by a factor of 20.
The error due to approximate computation of SVD is
less than 10
Specialized Concurrency Control CC methods are re-
quired for updating index structures [33]. The CC method
is based on an extension of “the link” technique devel-
oped for B-trees [35], which avoids holding locks on the
nodes of a tree during I/Os.
Repeatable read isola-
tion is achieved with an eﬃcient hybrid locking mech-
anism, which combines traditional two-phase locking -
2PL with predicate locking [17]. Performance analysis
of various CC methods are presented in [65].
A scheme for approximate similarity search based on
hashing is examined in [23]. Hashing ensures that the
probability of collision is much higher for objects that
are close to each other than for those that are far apart.
The key idea in Locality-Sensitive Hashing - LSH is that
using several hash functions so as to ensure that, for
each function, the probability of collision is much higher
for objects, which are close to each other than for those
which are far apart.
The algorithm retrieves k near-
est neighbors from ℓclusters and merges them based
on distance. Signiﬁcant improvement in running time
over high dimensions indexing methods (the SR-tree)
was observed Experimental results also indicate that our
scheme scales well even for a relatively large number of
dimensions (over 50). LSH results in a signiﬁcant im-
provement in the number of disk accesses compared to
SR trees.
Solid-State Drives - SSDs based on NAND ﬂash tech-
nology are replacing magnetic disks mainly due to their
high throughput/low latency. shock resistance, absence
of mechanical parts, low power consumption.
Flash
aware indexing is discussed in [19], SSDs have idiosyn-
crasies, like erase-before-write, wear-out and asymmet-
ric read/write, which may lead to poor performance.
Indexing techniques designed primarily for HDDs need
reinvention for SDDs In addition to a concise overview of
the SSD technology and the challenges it poses. 62 ﬂash-
aware indexes for various data types are analyzed and
their main advantages and disadvantages commented.
Acknowledgements
At IBM Research the author collaborated with Dr Chung
Sheng Li (PwC) and Dr Vittorio Castelli (AWS), who
in 2000 received IBM’s Outstanding Innovation Award
for major contributions to this project The NASA pro-
posal was due to Dr. Harold Stone at IBM Research,
before joining NEC Research as a Fellow. The author
left IBM in 1998 on a two year bridge to academic re-
tirement. A patent dealing with building the index is
[8] and searching it [9]. The discussion of CSVD in [10]
which was submitted to IEEE TKDE was shortened due
to a a request to compare CSVD with the LDR method
in [14], which led to [13].
The research at New Jersey Inst.
of Technology -
NJIT was conducted by two PhD students: Yue Li [37]
and Lijuan Zhang [70]. Our publications have appeared
in various journals and this publication is intended to
serve as a pointer to them.
10.
REFERENCES
[1] C. C. Aggarwal, C. M., Procopiuc, J. L. Wolf,
P.S. Yu, J. S. Park. Fast algorithms for projected
clustering. In Proc. ACM SIGMOD Int’l Conf. on
Management of Data, 1999, 61-72.
[2] C. C. Aggarwal and P. S. Yu. Finding generalized
projected clusters in high dimensional spaces. In
Proc. ACM SIGMOD Int’l Conf. on Management
of Data, 2000, 70–81.
[3] R. Agrawal, J. Gehrke, D. Gunopulos, and P.
Raghavan. Automatic subspace clustering of high
dimensional data for data mining applications. In
Proc. ACM SIGMOD Int’l Conf. on Management
of Data, SIGMOD 1998, pp. 94-105.
[4] D. L. Barbara, W. DuMouchel, C. Faloutsos, P. J.
Haas, J. M. Hellerstein, Y. E. Ioannidis, H. V.
Jagadish, T. Johnson, R. T. Ng, V. Poosala, K.
A. Ross, K. C. Sevcik. The New Jersey data
reduction report. IEEE Data Engineering Bulletin
20, 4 (1997), 3-45.
[5] N. Beckmann, H.-P. Kriegel, R. Schneider, and B.
Seeger: The R∗-Tree: An eﬃcient and robust
access method for points and rectangles. In Proc.
ACM SIGMOD Conf. on Management of Data,
SIGMOD 1990: 322-331.
[6] C. B¨ohm, J. Kailing, P. Kr¨oger, and A. Zimek.
Computing clusters of correlation connected
objects. In Proc. ACM SIGMOD Int’l Conf. on
Management of Data, 2004, 455-466
[7] V. Castelli, L. D. Bergman, I. Kontoyiannis, C.-S.
Li, J. T. Robinson, and J. Turek: Progressive
search and retrieval in large image archives. IBM
J. Research & Development 42, 2 (1998), 253-268.
[8] V. Castelli, C.S. Li, and A. Thomasian
Multidimensional data clustering and dimension
reduction for indexing and searching. US Patent:
6122628, Sept. 2000.
[9] V. Castelli, C. S. Li, and A. Thomasian Searching
multidimensional indexes using associated
clustering and dimension reduction information.
Patent number: 6134541, OCT. 2000.

---

[10] V. Castelli, A. Thomasian, and C. S. Li. CSVD:
Clustering and Singular Value Decomposition for
Approximate Similarity Searches in High
Dimensional Spaces IBM Research RC 21755
(98001), 30 May 2000.
https://dominoweb.draco.res.ibm.com/
afadd8abb2045247852568fd006680db.html
[11] V. Castelli and L. D. Bergman. Image Databases:
Search and Retrieval of Digital Imagery. Wiley
Interscience, 2002.
[12] V. Castelli. Multidimensional indexing structures
for content-based retrieval. Chapter 14 in [11].
[13] V. Castelli, A. Thomasian, and C. S. Li. CSVD:
Clustering and Singular Value Decomposition for
approximate similarity search in high dimensional
spaces. IEEE Trans. on Knowledge and Data
Engineering 14(3): 671-685 (2003).
[14] K. Chakrabarti and S. Mehrotra. Local
dimensionality reduction: A new approach to
indexing high dimensional space. In Proc. Int’l
Conf. on Very Large Data Bases - VLDB, 2000,
pp. 89-100.
[15] B. Cui, B. C. Ooi, J. Su, and K. L. Tan. Indexing
high-dimensional data for eﬃcient in-memory
similarity search. IEEE Trans. on Knowledge and
Data Engineering - TKDE 17, 3 (March 2005),
339-353.
[16] M. Ester, H.P. Kriegel, J. Sander and X. Xu. A
density-based algorithm for discovering clusters in
large spatial databases with noise. In Proc. 2nd
Int’l Conf. Knowledge Discovery and Data
Mining, 1996, 226–231
[17] K.P.Eswaran, J.N.Gray, R. A. Lorie, and L.
L.Traiger. The notion of consistency and
predicate locks in database systems. Commun. of
the ACM 19,11 (Nov. 1976), 624-633.
[18] C. Faloutsos. Searching Multimedia Databases by
Content (Advances in Database Systems).
KAP/Springer 1996/2012.
[19] A. Fevgas, L. Akritidis, P. Bozanis, and Y.
Manolopoulos. Indexing in ﬂash storage devices: a
survey on challenges, current approaches, and
future trends. VLDB J. 29, 1 (2020), 273–311.
[20] V. Gaede and O. Gunther: Multidimensional
access methods. ACM Computing Surveys 30(2):
170-231 (1998).
[21] G. H. Golub and C. F. Van Loan Matrix
Computations, 4th ed. John Hopkins Univ. 2012.
[22] A. Guttman. R-trees: A dynamic index structure
for spatial searching. In Proc. ACM SIGMOD
Int’l Conf. on Management of Data, SIGMOD
1984, 47–57.
[23] A. Gionis, P. Indyk, and R. Motwani. Similarity
search in high dimensions via hashing. In Proc. 25
Int’l Conf on Very Large Data Bases - VLDB
1999, 518-529
[24] C.-C. Hung, E. Song, and Y. Lan. Image Texture
Analysis: Foundations, Models and Algorithms
Springer 2019.
[25] IBM Corp. Engineering and Scientiﬁc Subroutine
Library for AIX, Guide and Reference.
SA22-7272-03, edition 4, 2000.
https://www.cenapad.unicamp.br/
parque/manuals/Essl/html/essl.html
[26] I.T. Jolliﬀe. Principal Component Analysis.
Springer Verlag, 1986
[27] N. Katayama and S. Satoh. The SR-tree: An
index structure for high-dimensional nearest
neighbor queries. In Proc. ACM SIGMOD Int’l
Conf. on Management of Data, SIGMOD 1997,
369-380.
[28] B. Kim and S. Park. A fast k-nearest-neighbor
ﬁnding algorithm based on the ordered partition.
IEEE Trans. Pattern Analysis and Machine
Intelligence 8, 6 (1986), 761-766.
[29] A. Kitamato, C. Zhou, and M. Takagi. Similarity
retrieval of NOAA satellite images by graph
matching. In Proc. SPIE 1908, Storage and
Retrieval for Image and Video Databases.
February 1993.
[30] J. Kogan. Introduction to Clustering Large and
High-Dimensional Data. Cambridge Univ. Press,
2006.
[31] F. Korn, H.V. Jagadish, and C. Faloutsos.
Eﬃciently supporting ad hoc queries in large
datasets of time sequences. In Proc. ACM
SIGMOD Int’l Conf.on Management of Data
1997, 289-300.
[32] F. Korn, N. Sidiropoulos, C. Faloutsos, E. Siegel,
and Z. Protopapas. Fast and eﬀective retrieval of
medical tumor shapes: nearest neighbor search in
medical image databases, IEEE Trans. Knowledge
and Data Engineering 10(6): 889-904 (1998).
[33] M. Kornacker, C. Mohan, J. M. Hellerstein:
Concurrency and recovery in generalized search
trees. In Proc. ACM SIGMOD Conf. on
Management of Data, SIGMOD 1997, 62-72.
[34] H. P. Kriegel, P. Kr¨oger, and A. Zimek.
Clustering high-dimensional data: A survey on
subspace clustering, pattern-based clustering, and
correlation clustering. ACM Trans. on Knowledge
Discovery from Data 3, 1 (March 2009), 1–58.
[35] P.L.Lehmann and S.B.Yao. Eﬃcient locking for
concurrent operations on B-Trees. ACM TODS 6,
4 (Dec. 1981), 650-670.
[36] C.-S. Li and V. Castelli: Deriving texture feature
set for content-based retrieval of satellite image
database. In Proc. Int’l Conf. on Image
Processing - ICIP 1997: pp. 586-589.
[37] Y. Li. Eﬃcient Similarity Search in High
Dimensional Data Spaces. PhD Thesis, Computer
Science Dept., NJIT, May 2004.
[38] Y. Li, A. Thomasian, and L. Zhang: Optimal
subspace dimensionality for k-NN search on
clustered datasets. In Proc. Database and Expert
Systems Applications, 15th Int’l Conf. DEXA
2004 Lecture Notes in Computer Science 3180,
Springer 2004, 201-211
[39] K.-I. Lin, H. V. Jagadish, and C. Faloutsos. The
TV-tree: An index structure for high-dimensional

---

data. VLDB Journal 3, 517–542 (1994).
[40] Y. Linde, A. Buzo, and R. Gray. An algorithm for
vector quantizer design. IEEE Trans. on
Communications 28(1): 84-95 (1980).
[41] D. B. Lomet and B. Salzberg. The hB-tree: A
multiattribute indexing method with good
guaranteed performance. ACM Trans. Database
Systems 15(4): 625-658 (1990).
[42] B. S. Manjunath and W.-Y. Ma. Textures
Features for Image Retrieval. Chapter 12 in [11]
[43] R. Ng and J. Han. Eﬃcient and eﬀective
clustering method for spatial data mining. In
Proc. Int’l Conf. Very Large Data Bases - VLDB
1994, 144- 155,
[44] W. Niblack, R. Barber, W. Equitz, M. Flickner,
E. H. Glasman, D. Petkovic, P. Yanker, C.
Faloutsos, and G. Taubin. The QBIC project:
Querying images by content, using color, texture,
and shape. In Proc. SPIE Vol. 1908: Storage and
Retrieval for Image and Video Databases, 173-187.
[45] K. Nuraini, I. Najahaty, L. Hidayati, H. Murﬁ,
and S. Nurrohmah. Combination of singular value
decomposition and K-means clustering methods
for topic detection on twitter. In Proc. Int’l Conf.
on Advanced Computer Science and Information
Systems - ICACSIS 2015, 138-143.
[46] M. Otterman. Approximate Matching with High
Dimensionality R-trees. M.Sc. scholarly paper,
Dept.of Computer Science, Univ. of Maryland,
College Park, MD, 1992. supervised by C.
Faloutsos.
[47] A. Papadopoulos and Y. Manolopoulos.
Performance of nearest neighbor queries in
R-Trees. In Proc. 6th Int’l Conf. on Database
Theory - ICDT 1997, 394-408.
[48] L. Parsons, E. Haque, H. Liu, 2004. Subspace
clustering for high dimensional data: a review.
SIGKDD Explorations 6, 1 (2004), 90-105.
[49] W.H. Press, S.A. Teukolsky, W.T. Vetterling, and
B.P. Flannery. Numerical Recipes: The Art of
Scientiﬁc Computing in C. New York: Cambridge
Univ. Press, 1998.
numerical.recipes
[50] W. Qu, X. Xiu, H. Chen, and L. Kong. A survey
on high-dimensional subspace clustering
Mathematics 2023, 11, 2 (2023), 436.
[51] R. Ramakrishnan and J. Gehrke. Databases
Management Systems. McGraw-Hill, 2003.
[52] H. K. Ramapriyan. Satellite Imagery in Earth
Science Applications. Chapter 3 in [11]
[53] A. R. Rao. A Taxonomy of Texture Description
and Identiﬁcation. Springer-Verlag, 1990.
[54] K. V. Ravi Kanth, D. Agrawal, and A. Singh.
Dimensionality-reduction for similarity searching
in dynamic databases. In Proc. ACM SIGMOD
Int’l Conf. on Management of Data, pp. 166-176.
[55] J. T. Robinson. The k-d-b tree: A search
structure for large multidimensional dynamic
indexes. In Proc. ACM SIGMOD Int’l Conf. on
Management of Data, SIGMOD 1981, pp. 10–18.
[56] H. Samet. Foundations of Multidimensional and
Metric Data Structure. Elsevier, 2006.
[57] A. Thomasian, V. Castelli, and C.-S. Li, RCSVD:
Recursive Clustering with Singular Value
Decomposition for Dimension Reduction in
content-based retrieval of large image/video
databases. IBM T. J. Watson Research Report
RC 20704, IBM, Jan. 1997.
[58] A. Thomasian, V. Castelli, and C. S. Li. RCSVD:
Recursive Clustering and Singular Value
Decomposition for approximate
high-dimensionality indexing. In Proc. ACM Int’l
Conf. on Information and Knowledge
Management - CIKM 1998, pp. 201-207.
[59] A. Thomasian, V. Castelli, C. S. Li. Approximate
nearest neighbor searching in high-dimensionality
spaces the clustering and singular value
decomposition method, In Proc. Voice, Video and
Data Communication - SPIE Photonic East 1998,
pp. 144-154.
[60] A. Thomasian, Y. Li, L. Zhang. Exact k-NN
queries on clustered SVD datasets. Information
Processing Letters 94, 6 (2005), 247-252..
[61] A. Thomasian and L. Zhang. The stepwise
Dimensionality Increasing - SDI index for high
dimensional data. The Computer Journal 49, 5
(2006), 609-618.
[62] A. Thomasian and L. Zhang: Persistent
semi-dynamic ordered partition index. Computer
J. 49, 6 (2006), 670-684.
[63] A. Thomasian and L. Zhang. Persistent clustered
main memory index for accelerating k-NN queries
on high dimensional datasets. Multimedia Tools &
Applications 38, 2 (2008, 253-270.
[64] A. Thomasian, Y. Li, L. Zhang. Optimal subspace
dimensionality for k-nearest-neighbor queries on
clustered and dimensionality reduced datasets
with SVD. Multimedia Tools & Applications 40, 2
(2008), 241-259.
[65] A. Thomasian. Concurrency control: Methods,
performance, and analysis. ACM Computing
Surveys 30, 1 (March 1988), 70-119.
[66] W. Wang, J. Yang, and R. Muntz. STING: A
statistical information grid approach to spatial
data mining. In Proc. 23rd Very Large Data Base
- VLDB 1997, 186–195.
[67] R. Weber, H. Schek, and S.Blott. A quantitative
analysis and performance study for similarity
search methods in high dimensional Spaces. In
Proc. 24th Int’l Conf. Very Large Data Bases -
VLDB 1998, 194-205.
[68] D. A. White and R. C. Jain: Similarity indexing
with the SS-tree. In Proc. 12th Int’l Conf. on
Data Engineering - ICDE 1996, 516-523.
[69] D. A. White and R. C. Jain: Similarity indexing:
Algorithms and performance. In Proc. Storage
and Retrieval for Image and Video Databases
(SPIE) 1996: 62-73.
[70] L. Zhang. High-Dimensional Indexing Methods
Utilizing Clustering and and Dimensionality

---

Reduction. PhD Thesis, Computer Science Dept.,
NJIT, May 2005.
https://digitalcommons.njit.edu/cgi/
viewcontent.cgi?article=1776&context=dissertations
[71] L. Zhang, A. Thomasian: Persistent clustered
main memory index for accelerating k-NN queries
on high dimensional datasets. In Proc. Second
Int’l Workshop on Computer Vision meets
Databases, CVDB 2005, pp. 65-70
[72] T. Zhang, R. Ramakrishnan, and M. Livny.
BIRCH: A new data clustering algorithm and its
applications. J. Data Mining and Knowledge
Discovery, 1, 2 (1997), 141–182.

---

