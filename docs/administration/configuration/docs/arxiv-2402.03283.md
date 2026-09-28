# Towards a Flexible Scale-out Framework for Efficient Visual Data Query Processin

> 来源: https://arxiv.org/pdf/2402.03283

Towards a Flexible Scale-out Framework for Efficient
Visual Data Query Processing
Rohit Verma
rohit1.verma@intel.com
Intel Labs
India
Arun Raghunath
arun.raghunath@intel.com
Intel Labs
USA
ABSTRACT
There is growing interest in visual data management systems that
support queries with specialized operations ranging from resizing
an image to running complex machine learning models. With a
plethora of such operations, the basic need to receive query re-
sponses in minimal time takes a hit, especially when the client
desires to run multiple such operations in a single query. Existing
systems provide an ad-hoc approach where different solutions are
clubbed together to provide an end-to-end visual data management
system. Unlike such solutions, the Visual Data Management System
(VDMS) [27] natively executes queries with multiple operations,
thus providing an end-to-end solution. However, a fixed subset of
native operations and a synchronous threading architecture limit
its generality and scalability.
In this paper, we develop VDMS-Async that adds the capabil-
ity to run user-defined operations with VDMS and execute opera-
tions within a query on a remote server. VDMS-Async utilizes an
event-driven architecture to create an efficient pipeline for execut-
ing operations within a query. Our experiments have shown that
VDMS-Async reduces the query execution time by 2 −3X compared
to existing state-of-the-art systems. Further, remote operations cou-
pled with an event-driven architecture enables VDMS-Async to
scale query execution time linearly with the addition of every new
remote server. We demonstrate a 64X reduction in query execution
time when adding 64 remote servers.
CCS CONCEPTS
• Information systems →Data management systems; DBMS
engine architectures.
KEYWORDS
visual data queries, VDBMS, event-driven architecture
ACM Reference Format:
Rohit Verma and Arun Raghunath. 2018. Towards a Flexible Scale-out
Framework for Efficient Visual Data Query Processing. In Proceedings of
Make sure to enter the correct conference title from your rights confirma-
tion emai (Conference acronym ’XX). ACM, New York, NY, USA, 13 pages.
https://doi.org/XXXXXXX.XXXXXXX
Permission to make digital or hard copies of all or part of this work for personal or
classroom use is granted without fee provided that copies are not made or distributed
for profit or commercial advantage and that copies bear this notice and the full citation
on the first page. Copyrights for components of this work owned by others than ACM
must be honored. Abstracting with credit is permitted. To copy otherwise, or republish,
to post on servers or to redistribute to lists, requires prior specific permission and/or a
fee. Request permissions from permissions@acm.org.
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
© 2018 Association for Computing Machinery.
ACM ISBN 978-1-4503-XXXX-X/18/06...$15.00
https://doi.org/XXXXXXX.XXXXXXX
1
INTRODUCTION
Streaming, virtual reality, IoT, and Smart City becoming house-
hold terms has re-ignited the interest in visual data management
research [29, 30, 33]. Visual data applications require several data
processing tasks (filtering, merging, cropping, etc.) as well as spe-
cialized operations (resizing, AI/ML inference like object detection,
etc.). All these tasks have to be performed quickly for a better user
experience. Here, emphasis must be put on the term "quickly", tied
to the query execution time, which is a crucial metric linked to user
experience. A quicker execution time would be possible through
efficient visual data management and intelligent query processing.
However, several challenges arise when addressing the problem of
optimal query execution time.
The first challenge with visual data management is linked to
applications executing multiple operations in a pipeline. In the
absence of an end-to-end system, these applications work with
multiple solutions, each performing a different task. For example,
an image classification application will require (i) creating the image
metadata based on the features required by the classification model,
(ii) filtering the data based on constraints, (iii) pre-processing the
data based on the model requirements, and (iv) executing the model
on the images to classify. This pipeline would require (i) solution
to extract and label necessary metadata (feature engineering tool),
(ii) metadata filtering solution (like MySQL [22]), (iii) pre-processing
tool, and (iv) client to execute the classification model. Thus, four
different solutions are required to perform the classification pipeline
instead of running it from a single DBMS like MySQL. Stitching
together multiple disparate solutions is difficult to manage, often
error-prone, and requires a separate programming lifecycle for each
solution. Moreover, moving large amounts of data back and forth
between these distinct processes is inefficient.
The second challenge arises when operations are compute-intensive
enough to require a long processing time and thus stall the overall
query execution.
Availability of resources poses the third challenge, especially in
resource-constrained environments where the visual data manage-
ment systems might not have sufficient compute to perform the
compute-intensive operations in a timely manner. Further, such
systems often have a limited available storage footprint. Hence,
utilizing capable remote servers to assist with the computing and
data storage tasks becomes an important consideration. Offloading
further adds to the challenges of handling low network bandwidth,
communication failure, and stalling.
A majority of the existing solutions work with ad-hoc application
designs that implement different operations using disparate/distinct
frameworks. For example, Facebook utilizes Tao [31], Haystack [2],
arXiv:2402.03283v1  [cs.DB]  5 Feb 2024

---

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Rohit Verma and Arun Raghunath
and f4 [21], alongwith MySQL for their photo management applica-
tions. In contrast to such ad-hoc solutions, VDMS [27] provides an
end-to-end solution that stores and manages both visual data and
related metadata. However, VDMS does not support user-defined
operations or remote computation of operations. Moreover, it fol-
lows a synchronous model to execute an operation pipeline that
could lead to execution delays (Details in Section 3). Other existing
video data management systems [7, 14, 25] are also synchronous
or use a restricted parallelization approach. Furthermore, these so-
lutions do not support operation execution at a remote server and
require an ad-hoc setup to achieve remote execution.
In light of the limitations of the existing systems, we have devel-
oped an improved version of VDMS (VDMS-Async) that provides
an end-to-end solution to address the issues linked to compute-
intensive operation pipelines, limited resource availability, and
synchronous query execution. The key contributions are:
• A design that allows adding user-defined operations (UDF)
as part of a query pipeline. This capability expands the reach
of VDMS to run any type of operation over its data store.
• A flexible query interface providing a plug-and-play mech-
anism for executing UDF on remote servers with no code
changes to VDMS.
• An asynchronous event-driven architecture for visual query
processing that avoids stalls in the query pipeline due to com-
munication delays or compute-intensive operations. VDMS-
Async is the first system in literature to utilize an asynchro-
nous event-driven architecture for visual data management
resulting in lower query duration and higher throughput
than its counterparts.
• Detailed benchmarking and analysis to highlight the scale-
out benefits of remoting coupled with an asynchronous
threading model by using an ecosystem of remote servers
Our experiments performed on image and video datasets show
that VDMS-Async decreases the query execution time by 2 −3X
when compared to existing systems for both simple and compute-
intensive queries. VDMS-Async shows 3X reduction in execution
time for both video and images when multiple parallel clients (as
high as 128 parallel clients) perform compute-intensive queries.
Furthermore, scaling out to additional servers decreases the exe-
cution time linearly with the addition of new remote servers. Our
experiments show that the query execution time is reduced by 64X
when 64 remote servers are used.
In the next section, we provide an overview of the existing sys-
tems and their limitations (§ 2), followed by an overview of VDMS
(§ 3) in the following section. We then discuss the design of re-
mote operations functionality of VDMS along with user-defined
operations (§ 4). The following section describes the asynchronous
execution model (§ 5). We evaluate VDMS-Async over video and im-
age datasets and compare its performance with respect to existing
systems (§ 6). We then finally conclude in § 7.
2
RELATED WORK
Works like Chabot [23] and QBIC [5] led the foundation of research
in the area of visual data management. These were followed by a
large set of visual data management systems that were designed to
address different aspects of visual data, such as efficient data store
(Strg-index [18]), intelligent query systems (Jacob [16]), efficient
metadata management (Oh et al. [24]), and efficient data mining
for application design (Zhu et al. [34]). However, these systems
addressed different disjoint aspects and especially are not designed
to work with compute-intensive operations leading to the need for
efficient visual data management systems that would club all above
mentioned aspects of visual data management.
A majority of the current end-to-end systems rely on ad-hoc
solutions that require stitching together multiple disparate tools
to create an end-to-end application. Furthermore, most of these
solutions either cater to only videos or only images. Facebook cre-
ated their photo management application as an ad-hoc solution
of Tao [31] (data store), Haystack [2] (object store), f4 [21] (blob
storage system), and MySQL [22] (metadata storage). Many solu-
tions have been developed recently to cater to video data specifi-
cally [1, 4, 7, 13, 14, 17, 25]. Scanner [25] is an open-source system
designed for efficient video processing. It provides tools and APIs
to perform a variety of video processing operations such as object
detection, face detection, pose detection, etc. LightDB [7] is another
video-only solution designed especially for virtual reality videos at
scale. It, too, provides support to execute specialized operations on
the data store. However, LightDB works with angles instead of pix-
els, and thus all operations have to map the two coordinate systems,
which could lead to complications. NoScope [14] is a specialized
video data management system designed to support deep learning
operations at scale. But, it does not support any operations that
do not require deep learning models. Moreover, these solutions as-
sume the availability of capable servers that can perform expensive
computing tasks locally.
Current iterations of MySQL [22] support storing images and
videos as binary data. It is also possible to execute user-defined
operations using SQL functions, but most specialized operations,
such as executing machine learning classification tasks, need to be
performed using an external client, requiring moving data back and
forth, which is inefficient. PostgreSQL [20] also provides a similar
storage solution with a much broader scope for executing special-
ized operations using Python libraries. However, parallelization
of these operations is limited by the number of available CPUs
and might lead to stalling when working with a large dataset or
long-running compute-intensive operations.
Several works have tried to optimize query execution time us-
ing different techniques [10, 12, 26, 28]. Recent techniques like
LPCE [32] utilize machine learning techniques for cardinality es-
timation to decrease the overall query execution time. However,
these solutions either need to know what type of query is being
performed or historical query information, rendering them less
effective for queries with user-defined operations (UDF). Works
like Voodoo [9] provide a method to optimize query execution time
for UDFs using indexing but are limited to images only.
3
VDMS OVERVIEW
The Visual Data Management System (VDMS) [27] was designed
for swift visual data access by influencing how the data is treated in
the storage system. VDMS uses an in-memory persistent graph data
store [6] to enable fast meta-data access. VDMS runs as a server
listening for client queries for data management.

---

VDMS-Async
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Figure 1: VDMS query with operation pipeline
VDMS provides the capability to run specialized functions on
visual data. These operations can be executed while adding the
visual data or querying the database. VDMS natively provides a
small set of OpenCV [3] operations, such as crop, trim, rotate, etc.
All VDMS operations can be executed in a pipeline. For example,
in Figure 1, an image search query is run that also requests a resize,
followed by a rotate operation on the returned images matching
the query. VDMS ensures that the operations are executed on all
the images that match the search criteria in the order specified by
the user. Further, VDMS also provides specific queries on metadata
that could be used to perform analytics, such as similarity search.
The prime advantage of VDMS versus other visual data man-
agement systems is the capability to provide end-to-end support
for performing visual data queries. However, there exist some key
limitations of the current version of VDMS. First, VDMS does not
have the support to execute user-defined operations on the visual
data. Although the native operations are suitable for a large subset
of visual data queries [27], the absence of support for user-defined
operations restricts the type of operations required for real-world
applications, as discussed in Section 1. Second, VDMS does not
support executing operations on a remote server, which might be a
crucial requirement for different applications (Section 1). Finally,
VDMS executes the operation pipeline synchronously. Hence, if
it takes 𝑡seconds to execute all operations on one image, for 10
images, the total query execution time will be ≈(𝑡∗10) seconds.
4
USER-DEFINED AND REMOTE OPERATIONS
In this section, we describe how we extend VDMS to support user-
defined and remote operations. User-defined operation adds the
capability to run specialized operations designed by a user as part
of the VDMS operation pipeline without requiring any manual
stitching. Remote operations add the capability to offload operations
to a remote server from VDMS such that the VDMS server can
continue working on other tasks.
4.1
User-Defined Operations
As discussed in the previous section, VDMS only provides support
to run basic OpenCV operations on the visual data, which severely
limits the reach of VDMS. Although the existing set of operations
can be used to perform a large set of visual data queries in compar-
ison to existing state-of-the-art solutions [27], complex tasks like
running machine learning models or complex visual data process-
ing would require an ad-hoc solution. Such ad-hoc solutions would
query VDMS to perform some basic operations, retrieve all the
visual data responses and then execute the complex operations in a
separate process. It is easy to understand that this would be ineffi-
cient, especially for pipelines with complex operations book-ended
by other native or complex operations. Such pipelines currently
require multiple separate VDMS queries to be invoked.
VDMS
User-defined 
Operation
Message Queue
Path to entity and 
UDF parameters
Updated Entity
Query
Figure 2: Architecture for User Defined Operations
User-Defined Operations (UDFs) ensure that users can define
their own operations and plug the same into VDMS to execute. As
shown in Figure 2, our design utilizes message queues to communi-
cate between VDMS and the user-defined operation running as a
separate process. Utilizing the message queue as the inter-process
communication mechanism allows asynchronous working of the
VDMS server and the UDF process. Also, message queues increase
reliability owing to the data persistence at the queues. Moreover,
when using message queues, if parallel clients increase the load
of the system, the requests can be sent out to the queue without
worrying about collision.
Figure 3: Example User-defined operation
A user can query VDMS the same as in Figure 1, adding an
operation entry for the new user-defined operation as shown in
Figure 3. The message queue port is an input required from the
user to connect VDMS to the same message queue connected to
the UDF. The UDF capability also includes an encapsulation to add
all UDF parameters inside the 𝑜𝑝𝑡𝑖𝑜𝑛𝑠attribute.
4.2
Remote Operations
The requirement of remote operations becomes crucial when we
consider situations when the VDMS server itself is not competent
enough to run compute-intensive operations. Moreover, with in-
creasing data load, one can reduce the execution time by offloading
the task to remote servers. Offloading opens the VDMS server for
performing other tasks. As discussed earlier, such remoting capabil-
ity is not available in VDMS. Similar to UDFs, this is a sub-optimal
approach contrary to having the support in-built.
We design a similar architecture as UDFs for remote operations
where we utilize HTTP APIs (we implemented these using the
Flask Python library.) to communicate with the remote server that
is running an operation. We transmit the visual data and operation

---

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Rohit Verma and Arun Raghunath
VDMS
Remote 
Server
Flask API
Path to entity and 
Operation parameters
Updated Entity
Query
Figure 4: Architecture for Remote Operations
Figure 5: Example Remote operation
parameters as POST attributes to the remote server and receive the
modified visual data files back. A sample remote operation query
is shown in Figure 5. The URL is the API end-point VDMS will
query to execute the operation. These end-points can also be set
to execute operations that the user wants to perform, effectively
providing a capability to run UDFs on a remote server.
5
ASYNCHRONOUS OPERATION PIPELINE
VDMS follows the classic run-to-completion threading model, where
each client query is handled by one thread. This VDMS thread per-
forms operations on one entity at a time, and only when all opera-
tions in the query pipeline are executed does it move to the next
entity. Moreover, customized user operations might be compute-
intensive and hence slow. With the existing synchronous execution
model, the VDMS thread sending operations to the remote server
would have to idle-wait, delaying the overall execution time.
A straightforward solution to this stalling problem would be us-
ing multiple threads to execute operations on multiple entities. This
multi-threaded solution has two major limitations. First, working
with extra threads results in extra resource utilization that would
put an unnecessary load on the system. Second, such a solution
is limited by resource availability and the number of entities in
the response. Low-end devices would be unable to support many
parallel threads, and thus we would wind back to the same problem
of VDMS stalling until the threads are free. Although high-end
servers will be able to spawn a larger number of threads, if the
number of entities becomes huge, then at some point, we again
reach a similar impasse of stalling while waiting for the threads
to complete. The other solution could be to utilize batching and
multi-threading with remote operations, where each thread handles
multiple entities and operations are offloaded to a remote server.
But, like the high-end server scenario, the batching approach also
effectively delays the evident stalling to a longer time since it does
not address the fundamental issue of a thread idle waiting for a
remote server to complete the operation on an entity (or batch of
entities).
Considering the above challenges, we design an event-driven
architecture that considers all operations as events and works asyn-
chronously with only two additional threads.
5.1
Asynchronous Execution with EventLoops
We consider every operation as a unique event and modify VDMS
to follow an event-driven architecture to execute the operation
pipeline. As shown in Figure 6, the architecture is divided into
two modules; (a) the main VDMS-Async thread, which takes care
of communicating with the client, filtering based on constraints,
populating the data store, and communicating with the event loop,
and (b) the Event Loop, that catches each event and asynchronously
executes them. The event loop maintains two threads to handle two
types of events/operations, viz., native (𝑇ℎ𝑟𝑒𝑎𝑑2) and UDF/remote
(𝑇ℎ𝑟𝑒𝑎𝑑3). The VDMS-Async main thread (𝑇ℎ𝑟𝑒𝑎𝑑1) enqueues all
entities on 𝑇ℎ𝑟𝑒𝑎𝑑2 of the event loop. Following this, the event
loop design takes care of how to handle the entities along with
their operations asynchronously. We next describe both of these
sub-modules.
5.1.1
Main VDMS-Async Thread. The main VDMS-Async thread
(𝑇ℎ𝑟𝑒𝑎𝑑1 in Figure 6) takes care of all the tasks except the operation
execution, which it offloads to the event loop. 𝑇ℎ𝑟𝑒𝑎𝑑1 receives a
query from a client and filters out the entities based on the con-
straints provided by the client. 𝑇ℎ𝑟𝑒𝑎𝑑1 maintains the entities as
in-memory Visual Compute Library (VCL) objects [27]. 𝑇ℎ𝑟𝑒𝑎𝑑1
then updates each entity object to add the operations as provided
by the client. These entities are then one by one enqueued on the
event loop 𝑄𝑢𝑒𝑢𝑒1. It should be noted that not the actual objects
but the pointer to these objects are added to the queue.
Unlike VDMS, VDMS-Async threads can move on to the following
entity instead of waiting for all the operations to complete. Hence,
when 𝑇ℎ𝑟𝑒𝑎𝑑2 of the event loop starts processing these entities,
𝑇ℎ𝑟𝑒𝑎𝑑1 can independently continue enqueueing all the entities.
Once all entities are enqueued, 𝑇ℎ𝑟𝑒𝑎𝑑1 waits for the event loop to
terminate. 𝑇ℎ𝑟𝑒𝑎𝑑1 and the event loop use a dictionary as a shared
object that includes all updates made to the entities. 𝑇ℎ𝑟𝑒𝑎𝑑1 only
reads from this dictionary on the event loop’s termination and sends
back the response to the client.
5.1.2
The Event Loop. The event loop works with two queues
and two threads to execute the event-driven architecture. 𝑇ℎ𝑟𝑒𝑎𝑑2
handles the native VDMS operations, which take less time, while
𝑇ℎ𝑟𝑒𝑎𝑑3 handles the UDF/remote operations. Four types of events
are considered in the architecture design– (i) Q1-Enqueue: An en-
tity is added to𝑄𝑢𝑒𝑢𝑒1 by𝑇ℎ𝑟𝑒𝑎𝑑1 or𝑇ℎ𝑟𝑒𝑎𝑑3, (ii) R-UDF:𝑇ℎ𝑟𝑒𝑎𝑑2
encounters a non-native operation in the operation pipeline, (iii) Q2-
Enqueue: An entity is added to 𝑄𝑢𝑒𝑢𝑒2 by 𝑇ℎ𝑟𝑒𝑎𝑑2, (iv) R-UDF-
Response: A remote server or the UDF process sends the response
back to 𝑇ℎ𝑟𝑒𝑎𝑑3. We next describe how each of these events is
handled.
Q1-Enqueue: 𝑇ℎ𝑟𝑒𝑎𝑑2 keeps track of entities in 𝑄𝑢𝑒𝑢𝑒1 and starts
executing operations on the head entity if free. Otherwise, it com-
pletes the current execution before dequeuing the next entity. All
native operations on these dequeued entities are performed locally
within the VDMS-Async context.
R-UDF: When 𝑇ℎ𝑟𝑒𝑎𝑑2 encounters a remote operation or a user-
defined operation, it enqueues the entity into 𝑄𝑢𝑒𝑢𝑒2 and releases
control on the entity.𝑇ℎ𝑟𝑒𝑎𝑑2 then continues to work on the native
operations of the entity currently at the head of 𝑄𝑢𝑒𝑢𝑒1.

---

VDMS-Async
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Filter based on 
constraints
Return response
Enqueue Entity
For every entity
Perform Operations 𝑬𝟏
Operation 1 of 
𝑬𝟏
Operation 2 
(remote) of 𝑬𝟏
start
Operation 3 of 
𝑬𝟏
Send HTTP Query f𝐨𝐫𝑬𝟏
Perform Operations 𝑬𝟏
Operation 1 of 
𝑬𝟐
Operation 2 
(remote) of 𝑬𝟐
start
Operation 2 
(remote) of 𝑬𝟏
end
Operation 3 of 
𝑬𝟐
Operation 2 
(remote) of 𝑬𝟐
end
Send HTTP Query for 𝑬𝟐
Wait for the Event Loop 
to terminate
Encode Entity
𝑬𝟐
……
𝑬𝒏
𝑬𝟏
Other Entities …..
Other Responses …..
Event Loop
𝑬𝟐
……
𝑬𝒏
𝑬𝟏
Entity Response Dictionary
To Event Loop queue
From Event Loop queue
To Entity Response Dictionary
From Entity Response Dictionary
Legend
Figure 6: Asynchronous Operation Architecture for VDMS-Async
Q2-Enqueue: 𝑇ℎ𝑟𝑒𝑎𝑑3 handles the entities that are enqueued in
𝑄𝑢𝑒𝑢𝑒2. It dequeues each entity from the queue and sends it either
to the remote server or the UDF process. It then moves on to the
next entity in the queue.
R-UDF-Response: A callback method on 𝑇ℎ𝑟𝑒𝑎𝑑3 listens for a
response on the entities sent to a remote server or the UDF process.
Once an entity’s response arrives, this callback method updates the
𝐸𝑛𝑡𝑖𝑡𝑦𝑅𝑒𝑠𝑝𝑜𝑛𝑠𝑒𝐷𝑖𝑐𝑡𝑖𝑜𝑛𝑎𝑟𝑦(𝐸𝑅𝐷) and enqueues the entity back to
𝑄𝑢𝑒𝑢𝑒1 to be processed by 𝑇ℎ𝑟𝑒𝑎𝑑2. It should be noted that both
𝑇ℎ𝑟𝑒𝑎𝑑2 and𝑇ℎ𝑟𝑒𝑎𝑑3 work on different entities at a time and hence
do not cause any conflict. Similarly, the 𝐸𝑅𝐷is also updated by the
threads for different entities at any time. There is a possibility of
conflict between 𝑇ℎ𝑟𝑒𝑎𝑑1 and 𝑇ℎ𝑟𝑒𝑎𝑑3 while enqueueing 𝑄𝑢𝑒𝑢𝑒1,
which is handled by a standard lock mechanism.
5.2
Example Use-Case
Consider a user wants to query the VDMS-Async data store for
images with a set of constraints– (𝑐𝑎𝑡𝑒𝑔𝑜𝑟𝑦= 𝑐𝑒𝑙𝑒𝑏𝑟𝑖𝑡𝑦and 21 ≤
𝑎𝑔𝑒≤40) and operations– Resize image (Native) →Detect and
mark face (Remote) →Threshold image (Native)
The corresponding VDMS-Async query is as shown in Figure 8.
We illustrate the working of VDMS-Async to perform the query in
Figure 7. The details are described next.
On receiving this query, 𝑇ℎ𝑟𝑒𝑎𝑑1 filters out the images (say 100
images based on the constraints) and adds the three operations (re-
size, facedetect, and threshold) to all the VCL image objects.𝑇ℎ𝑟𝑒𝑎𝑑1
then starts enqueueing pointers to the image objects to 𝑄𝑢𝑒𝑢𝑒1 and
continues the task until all 100 images have been enqueued.
In the meantime, 𝑇ℎ𝑟𝑒𝑎𝑑2 starts operating on the first image,
resizes the image as per the operation parameters (400, 500), and
updates the 𝐸𝑅𝐷. Next, it encounters a remote operation and en-
queues the pointer to the image object on 𝑄𝑢𝑒𝑢𝑒2. Thus, 𝑇ℎ𝑟𝑒𝑎𝑑2
releases the first image and continues with the second to perform
the resize operation. After resizing the second image, it updates the
𝐸𝑅𝐷, encounters the remote operation for the second image and
enqueues the pointer to the image on 𝑄𝑢𝑒𝑢𝑒2. It then moves on to
the third image and so on.
Meanwhile, 𝑇ℎ𝑟𝑒𝑎𝑑3 encounters an update to 𝑄𝑢𝑒𝑢𝑒2 and cre-
ates an HTTP Post request to query the remote server for the first
image. It makes the query, releases the first image and moves on to
the second image. As 𝑇ℎ𝑟𝑒𝑎𝑑2 keeps populating 𝑄𝑢𝑒𝑢𝑒2, 𝑇ℎ𝑟𝑒𝑎𝑑3
keeps making the HTTP requests. Whenever there is a response
from the remote server for an image, note that this need not be in
order as some images might take more time for operation execution,
𝑇ℎ𝑟𝑒𝑎𝑑3 pauses the HTTP query context and executes a callback
that updates the image for which the response has arrived. It also
updates the 𝐸𝑅𝐷with the updated image. 𝑇ℎ𝑟𝑒𝑎𝑑3 then enqueues
this image onto 𝑄𝑢𝑒𝑢𝑒1 and switches back to the HTTP querying
task. When 𝑇ℎ𝑟𝑒𝑎𝑑2 encounters the image for which remote opera-
tion has been completed, it then executes the threshold operation
on it and updates the 𝐸𝑅𝐷. We update the 𝐸𝑅𝐷after every opera-
tion to ensure we have the latest updates to the entity if any failure
occurs. After the third operation is executed, the image is released
by all threads. Once both 𝑄𝑢𝑒𝑢𝑒2 and 𝑄𝑢𝑒𝑢𝑒3 are empty, and both
𝑇ℎ𝑟𝑒𝑎𝑑2 and 𝑇ℎ𝑟𝑒𝑎𝑑3 are free, the event loop is terminated.
On the event loop’s termination, 𝑇ℎ𝑟𝑒𝑎𝑑1 starts retrieving the
images from the updated 𝐸𝑅𝐷and processes the images to finally
send a response to the user.
5.3
Scaling-out with Remoting
The availability of remote operations gives VDMS-Async the ad-
vantage of offloading the operation execution to a remote server.
Furthermore, the event-driven architecture makes offloading to
multiple servers at the same time feasible. Consider a situation

---

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Rohit Verma and Arun Raghunath
Long running operation
𝑬𝟏
𝑬𝟐
𝑬𝟏𝟎𝟎
Resize
Facedetect
Response
Facedetect
HTTP Query
Threshold
Other Images
Other Images
Other Images
Other Images
Other Images
Other Images
Other Images
Pause HTTP Querying 
to Enqueue 𝑸𝒖𝒆𝒖𝒆
𝟏
with 𝑬𝟏
Resume HTTP 
Querying
Entity
Response
Dictionary 
(ERD)
VDMS--Async Query 
Response
Time
Legend
Event
Event that 
updates
ERD
Figure 7: An illustration of how use-case in Section 5.2 is by VDMS-Async. Multiple updates of 𝐸𝑛𝑡𝑖𝑡𝑦𝑅𝑒𝑠𝑝𝑜𝑛𝑠𝑒𝐷𝑖𝑐𝑡𝑖𝑜𝑛𝑎𝑟𝑦(𝐸𝑅𝐷)
not shown for simplicity. Images are used from the Labeled Faces in the Wild [11] dataset. (Not to scale)
Figure 8: VDMS-Async query for the use-case in Section 5.2
where a large number of clients are querying VDMS-Async at the
same time. Although we can offload a task to one server asyn-
chronously, the remote server itself will become a bottleneck owing
to its own resource constraints. Especially when the query itself is
compute-intensive. If, instead, we have an ecosystem of 𝜅such re-
mote servers, then theoretically, the workload on the remote server
will be reduced by 𝜅. This workload reduction will lead to 𝜅times
reduction in the query execution time too.
The capability to expand to𝜅remote servers to offload operations
asynchronously helps to scale out VDMS-Async to serve a much
larger number of entities and parallel clients at the same time.
6
EVALUATION
In this section, we evaluate different aspects of VDMS-Async cov-
ering query execution time, resource utilization, and how VDMS-
Async fares with respect to the existing systems. We evaluate VDMS-
Async with both image and video datasets. Furthermore, we also
analyze the improvements we gain with VDMS-Async when we
scale out by using multiple remote servers.
6.1
Image Dataset
We next describe the Labeled Faces in the Wild [11] dataset that
we use to evaluate VDMS-Async with images and the queries we
use to perform the benchmarking.
6.1.1
Dataset Description. The Labeled Faces in the Wild (LFW)
dataset [11] is a public benchmarking dataset with 13000 images of
human faces. We add images into VDMS-Async using the 𝐴𝑑𝑑𝐼𝑚𝑎𝑔𝑒
query and two metadata entries, viz., 𝑛𝑎𝑚𝑒, provided as part of the
dataset and 𝑐𝑎𝑡𝑒𝑔𝑜𝑟𝑦as ”𝑙𝑓𝑤”.
6.1.2
Benchmarking Queries. We design a set of nine bench-
marking queries that are described below. Each of these queries
first filters images based on user constraints and then performs
the specific operation described in the query description. Unless
specified, all these queries are performed as a UDF on a remote
server, and the parameters provided by the users are defined in the
𝑜𝑝𝑡𝑖𝑜𝑛𝑠attribute of the operation entry.
• Crop (IQ1) - Crop the image to a size of (ℎ𝑒𝑖𝑔ℎ𝑡,𝑤𝑖𝑑𝑡ℎ),
starting from the coordinate (𝑥,𝑦).
• Grayscale (IQ2) - Change the image colour to grayscale.
• Blur (IQ3) - Blur the image using Gaussian Blur. The user
provides the ℎ𝑒𝑖𝑔ℎ𝑡and 𝑤𝑖𝑑𝑡ℎof the Gaussian kernel that
will be used to blur the image, both of which should be
positive and odd. The user can also provide the standard
deviation, 𝑆𝑖𝑔𝑚𝑎𝑋and 𝑆𝑖𝑔𝑚𝑎𝑌(default value is 0 if not spec-
ified).
• Box (IQ4) - Detect a face in the image and create a box
around it.
• Mask (IQ5) - Create a circular mask at the centre of the face
in the image of radius 𝑟provided by the user.
• Upsample (IQ6) - Increase image resolution by 𝑋times
along x-axis and 𝑌times along y-axis. 𝑋and 𝑌are specified
by the user.

---

VDMS-Async
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
• Downsample (IQ7) - Decrease image resolution by 𝑋times
along x-axis and 𝑌times along y-axis. 𝑋and 𝑌are specified
by the user.
• Caption (IQ8) - Add text to the image at user specified
coordinates. The user provides both text and coordinates.
• Manipulation (IQ9) - Identify a face in the image, create a
circular mask around it and black out all other parts of the
image such that only the face is visible.
6.2
Video Dataset
We next describe the Kinetics400 Human Action Video Dataset [15]
that we use to evaluate VDMS-Async with videos and the queries
we use to perform the benchmarking.
6.2.1
Dataset Description. The Kinetics400 Human Action Video
Dataset [15] is designed to detect different types of human actions
in a video. The Kinetics400 version has 306,245 videos, each last-
ing around 10 seconds. We add videos into VDMS-Async using
the 𝐴𝑑𝑑𝑉𝑖𝑑𝑒𝑜query. We add two metadata entries to each video;
(a) 𝑐𝑎𝑡𝑒𝑔𝑜𝑟𝑦as ”𝑎𝑐𝑡𝑖𝑣𝑖𝑡𝑦”, and (b) 𝑎𝑐𝑡𝑖𝑣𝑖𝑡𝑦, which specifies the ac-
tivity being performed in the video.
6.2.2
Benchmarking Queries. We design a set of nine bench-
marking queries that are described below. Each of these queries
first filters videos based on user constraints and then performs
the specific operation described in the query description. Unless
specified, all these queries are performed as a UDF on a remote
server, and the parameters provided by the users are defined in the
𝑜𝑝𝑡𝑖𝑜𝑛𝑠attribute of the operation entry.
• Select (VQ1) - Select an interval in the video between 𝑡1
and 𝑡2 provided by the user. Then crop the frames in the
interval into rectangles of size (ℎ𝑒𝑖𝑔ℎ𝑡, 𝑤𝑖𝑑𝑡ℎ), starting at
coordinates (𝑥,𝑦), both of which are provided by the user.
• Grayscale (VQ2) - Convert the whole video into grayscale.
• Blur (VQ3) - Blur the whole video using Gaussian Blur. The
user provides the ℎ𝑒𝑖𝑔ℎ𝑡and 𝑤𝑖𝑑𝑡ℎof the Gaussian kernel
that will be used to blur the video frames, both of which
should be positive and odd. The user can also provide the
standard deviation, 𝑆𝑖𝑔𝑚𝑎𝑋and 𝑆𝑖𝑔𝑚𝑎𝑌(default value is 0
if not specified).
• Box (VQ4) - Detect faces in all the video frames and mark
them with a box. The resulting video should have these boxes
on all faces in all frames.
• Mask (VQ5) - Detect faces in all the video frames and create
a circular mask at the centre of the faces in the frames of
radius 𝑟provided by the user.
• Upsample (VQ6) - Increase video resolution by 𝑋times
along x-axis and 𝑌times along y-axis. 𝑋and 𝑌are specified
by the user.
• Downsample (VQ7) - Decrease video resolution by 𝑋times
along x-axis and 𝑌times along y-axis. 𝑋and 𝑌are specified
by the user.
• ActivityRecognition (VQ8) - Detect an activity in a video
frame and add a text in the frame specifying the activity. The
resulting video should have activity text in all frames.
• Manipulation (VQ9) - Identify a face in video frames, create
a circular mask around it and black out all other parts of the
frame such that only the face is visible.
6.3
Competing Systems
As discussed in Section 2, no other existing systems provide the
visual data management capabilities provided by VDMS for both
images as well as videos. Instead, relational database systems like
MySQL and PostgreSQL have support to work with videos and
images. However, the support is very limited with MySQL when
considering user-defined operations. Hence, we utilize the Post-
greSQL relational database system to compare the effectiveness of
VDMS-Async along with VDMS.
6.3.1
PostgreSQL [20]. : PostgreSQL is an open-source object-
relational database system frequently utilized in the literature. Un-
like MySQL, PostgreSQL has more flexibility for defining user-
defined operations as PostgreSQL functions. Furthermore, Post-
greSQL supports concurrent writing without locks and implements
transaction isolation, leading to faster parallel UDF execution. Exist-
ing works have also shown that PostgreSQL can be used for working
with visual data operations [9]. We implement the UDFs required
for the benchmarking queries as internal PostgreSQL functions.
6.3.2
VDMS [27]. : The existing version of VDMS acts as another
competing system. As VDMS does not support user-defined op-
erations, we ensure a fair comparison by including the UDF and
remote operations capability in the existing version of VDMS for the
experiments. Unlike VDMS-Async, VDMS follows a synchronous
operation execution approach.
6.3.3
Scanner [25]. : Scanner is a distributed visual data manage-
ment system that is designed to suit video processing applications at
scale. Scanner takes every frame as a separate entity, and operations
are performed on a frame-by-frame basis. Scanner creates a compu-
tation graph model to design the workflow that includes extracting
frames from the video, performing operations on the frames, and
generating the resulting video. Optimization is achieved by employ-
ing scheduling, parallelization, and frame compression to H.264
byte streams [19] to speed up the video processing tasks. Scanner
does not support cropping (VQ1), activity recognition (VQ8), and
manipulation (VQ9). Also, video resizing (VQ6-7) is only supported
with static height and width. Hence, we design our own operations
and incorporate them into Scanner for the tests. As Scanner does not
support images, we only provide results for video benchmarking.
6.4
Experiment Setup
We run all competing systems, including VDMS-Async, on an Ubuntu
18.04 dual socket server. The server runs with Intel®Xeon®Gold
6252 CPU with 96 cores @ 2.10GHz and has 376 GB of DDR4 DRAM.
The remote server we use for remote operations runs a dual-socket
Ubuntu 22.04 server with Intel®Xeon®Gold 6140 CPU with 35 cores
@ 2.3 GHz and has 384 GB of DDR4 DRAM. A client making a query
runs on a third machine running a dual-socket Ubuntu 22.04 server
with Intel®Xeon®Platinum 8180 CPU with 28 cores @ 2.5 GHz and
has 188 GB of DDR4 DRAM
We utilize three metrics, viz. query execution time, entities pro-
cessed per time unit and CPU utilization, to evaluate VDMS-Async

---

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Rohit Verma and Arun Raghunath
and the competing systems. We perform separate experiments for
images and videos, which means no single query expects both im-
ages and videos in the response. We execute every query for 15
independent runs and average over the metrics to report the re-
sults. We also analyze the results when the systems have to support
multiple clients concurrently. In our experiments, we vary the num-
ber of concurrent clients from 2 to 128 by doubling the number
of clients every time. As our analysis is more dependent on the
operation execution capability of the systems rather than the size
of the dataset only, for all our experiments, we use a subset of the
datasets with 5000 images and 500 videos selected at random. We
perform three categories of experiments for both datasets;
C1 One client executes one of the nine queries without con-
straints. The response is all the entities (5000 images or 500
videos) modified by the operation specified in the query.
C2 One client executes a custom query with no constraints but
multiple operations. The response is all the entities modified
by the operation pipeline. The following pipeline is used;
– Image: Resize →Box →Manipulation →Rotate. Here,
Resize and Rotate are native operations performed locally.
– Video: Activity Recognition →Resize →Select →Ma-
nipulation. Here, Resize is an operation performed locally.
C3 Multiple clients execute the same custom query as C2 at the
same time. It should be noted that the total number of entities
that match the query and require processing increases pro-
portionally with multiple clients. For example, the systems
must process 40𝑘images and 4𝑘videos with eight clients.
6.5
Evaluation of VDMS-Async: Image Dataset
We evaluate the systems using the image benchmarking queries
over the LFW dataset for each of the three categories of experiments
(C1 - C3).
IQ1
IQ2
IQ3
IQ4
IQ5
IQ6
IQ7
IQ8
IQ9
Operation
0.0
50.0
100.0
150.0
200.0
250.0
300.0
Execution Time (seconds)
PostgreSQL
VDMS
VDMS-Async
Figure 9: [Image-C1]: Query Duration
6.5.1
Image-C1: In the first set of experiments, we query the
system with each of the nine benchmarking queries one at a time.
As is evident from Figure 9, VDMS takes the maximum time
to execute the query owing to the absence of any parallelization.
Although PostgreSQL gains compared to VDMS due to its ability
to execute functions in parallel, the gain is not too high as there
are limitations to the number of parallel transactions that can be
generated. VDMS-Async, on the other hand, gains considerably
IQ1
IQ2
IQ3
IQ4
IQ5
IQ6
IQ7
IQ8
IQ9
Operation
0.0
10.0
20.0
30.0
40.0
50.0
60.0
70.0
80.0
Images per second
PostgreSQL
VDMS
VDMS-Async
Figure 10: [Image-C1]: Throughput
IQ1
IQ2
IQ3
IQ4
IQ5
IQ6
IQ7
IQ8
IQ9
Operation
0.0
5.0
10.0
15.0
20.0
25.0
30.0
Percentage CPU Utilization
PostgreSQL
VDMS
VDMS-Async
Figure 11: [Image-C1]: Average Resource Usage
compared to the other two systems because of the event-driven
architecture that minimizes any stalling that could occur.
Using an event loop where we switch to another image instead
of waiting ensures that VDMS-Async can process a higher number
of images for all the benchmarking queries (Figure 10).
With equivalent work being done by all systems, the CPU uti-
lization is nearly similar for all three (Figure 11).
PostgreSQL
VDMS
VDMS-Async
Competing Systems
0.0
100.0
200.0
300.0
400.0
500.0
600.0
Execution Time (seconds)
PostgreSQL
VDMS
VDMS-Async
Figure 12: [Image-C2]: Query Duration
6.5.2
Image-C2: In the next set of experiments, we query the
system with an operation pipeline, Resize →Box →Manipulation
→Rotate.

---

VDMS-Async
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
PostgreSQL
VDMS
VDMS-Async
Competing Systems
0.0
2.5
5.0
7.5
10.0
12.5
15.0
17.5
Images per second
PostgreSQL
VDMS
VDMS-Async
Figure 13: [Image-C2]: Throughput
PostgreSQL
VDMS
VDMS-Async
Competing Systems
0.0
5.0
10.0
15.0
20.0
25.0
30.0
Percentage CPU Utilization
PostgreSQL
VDMS
VDMS-Async
Figure 14: [Image-C2]: Average Resource Usage
Gains of VDMS-Async with respect to the other two systems
are much higher compared to C1 for query duration (Figure 12)
and throughput (Figure 13) because of the higher workload lead-
ing to longer stalling and idle waits for VDMS and PostgreSQL.
VDMS-Async has an overall gain of 2.5X compared to both VDMS
and PostgreSQL in terms of query duration. VDMS-Async can also
process > 2𝑋images per second than the other competing systems.
Such gains with VDMS-Async are linked to the fact that when ex-
ecuting an operation pipeline, the HTTP requests to the remote
server and the native operations execute simultaneously on sepa-
rate threads on different images. So, neither the VDMS server nor
the remote server has to idle-wait. On the contrary, VDMS can only
work with one image at a time and idle waits when the operation
is being performed at the remote server. Similarly, with VDMS, the
remote server has to idle-wait when VDMS is executing the native
operations. Due to these idle wait periods, VDMS spends more time
executing the entire operation pipeline per entity.
Although PostgreSQL can spawn multiple processes under load
to enable parallelism, providing a slight edge over VDMS, the num-
ber of available CPUs limits this vector of parallelism. More im-
portantly, these processes still need to wait for a response from
the remote server before proceeding to the subsequent entities
matching the query constraints. Similarly, the remote server has
to idle-wait for the next set of images when PostgreSQL performs
native operations on the current set of images.
We see a change in the trend for CPU Utilization (Figure 14)
owing to the idle-wait times in VDMS and PostgreSQL. Since the
servers running VDMS and PostgreSQL are waiting to receive the
response from the remote server, the CPU utilization is close to
zero. However, for VDMS-Async, there is negligible idle waiting
involved, and all the threads are active throughout the processing
pipeline unless their task is complete. This leads to a higher CPU
utilization for VDMS-Async compared to the competing systems.
2
4
8
16
32
64
128
Parallel Clients
0.0
1000.0
2000.0
3000.0
4000.0
5000.0
Execution Time (seconds)
PostgreSQL
VDMS
VDMS-Async
Figure 15: [Image-C3]: Query Duration
2
4
8
16
32
64
128
Parallel Clients
0.0
50.0
100.0
150.0
200.0
Images per second
PostgreSQL
VDMS
VDMS-Async
Figure 16: [Image-C3]: Throughput
2
4
8
16
32
64
128
Parallel Clients
0.0
20.0
40.0
60.0
80.0
Percentage CPU Utilization
PostgreSQL
VDMS
VDMS-Async
Figure 17: [Image-C3]: Average Resource Usage

---

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Rohit Verma and Arun Raghunath
6.5.3
Image-C3: We next query the operation pipeline used in
C2, but now multiple clients query the system concurrently. We
increase the number of concurrent clients from 2 to 128 by doubling
every run.
With multiple clients, VDMS-Async achieves much lower exe-
cution time ( 2X as shown in Figure 15) and doubles the number
of images processed per second (Figure 16). We see similar trends
as C2 for CPU utilization (Figure 17). However, the difference in
CPU utilization between the three systems starts diminishing with
increasing clients as PostgreSQL and VDMS get much lower idle
time because of the continuous processing of requests from the
higher number of clients.
6.6
Evaluation of VDMS-Async: Video Dataset
We evaluate the systems using the video benchmarking queries over
the Kinetics dataset for each of the three categories of experiments
(C1 - C3).
VQ1
VQ2
VQ3
VQ4
VQ5
VQ6
VQ7
VQ8
VQ9
Operation
0.0
10.0
20.0
30.0
40.0
50.0
60.0
70.0
80.0
Execution Time (minutes)
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 18: [Video-C1]: Query Duration
VQ1
VQ2
VQ3
VQ4
VQ5
VQ6
VQ7
VQ8
VQ9
Operation
0
20
40
60
80
100
120
Frames per Second
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 19: [Video-C1]: Throughput
6.6.1
Video-C1: In the first set of experiments, we query the
system with each of the nine benchmarking queries one at a time.
We see similar trends with the video dataset (Figure 18) as we
saw for the image dataset1. The gain is much higher for compute-
intensive tasks such as face detection (VQ4) and video manipulation
1It should be noted that we have reported the execution time here in minutes, and
hence the relative difference looks less compared to images.
VQ1
VQ2
VQ3
VQ4
VQ5
VQ6
VQ7
VQ8
VQ9
Operation
0.0
5.0
10.0
15.0
20.0
25.0
30.0
Percentage CPU Utilization
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 20: [Video-C1]: Average Resource Usage
(VQ9), for which the competing systems PostgreSQL and VDMS
take 3𝑋the time than VDMS-Async to complete the query. Scanner
performs similarly to VDMS-Async owing to the speed-up provided
by the computation graph (§ 6.3.3).
The relative gain for the number of frames processed per second
is higher than we have seen for images (Figure 19). For instance,
the number of images processed for IQ9 is 45, while for VQ9, the
number of frames processed per second is 62. A higher gain is ob-
served with frames as the operations receive the frames packaged
as a video in a single call, while for images, there has to be a sepa-
rate call every time, resulting in greater communication overheads.
Overall, VDMS-Async fares better than the PostgreSQL and VDMS
with higher gains for compute-intensive queries.
Again a more compute-intensive task than operating over im-
ages leads to more compute requirements for videos (Figure 20).
Longer idle times for PostgreSQL and VDMS result in negligible
CPU utilization during those periods leading to lower average CPU
Utilization. On the contrary, Scanner that is always active owing to
working frame by frame has higher CPU utilization. Compared to
Scanner, VDMS-Async too is always active, but with more threads
and hence shows a higher resource utilization.
PostgreSQL
VDMS
Scanner
VDMS-Async
Competing Systems
0.0
50.0
100.0
150.0
200.0
Execution Time (seconds)
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 21: [Video-C2]: Query Duration
6.6.2
Video-C2: In the next set of experiments, we query the
system with an operation pipeline, Activity Recognition →Resize
→Select →Manipulation.
All three plots (Figure 21- 23) follow a similar trend as in C1 for all
except Scanner. However, the gains of VDMS-Async are much higher

---

VDMS-Async
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
PostgreSQL
VDMS
Scanner
VDMS-Async
Competing Systems
0.0
2.5
5.0
7.5
10.0
12.5
15.0
17.5
Frames per Second
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 22: [Video-C2]: Throughput
PostgreSQL
VDMS
Scanner
VDMS-Async
Competing Systems
0.0
5.0
10.0
15.0
20.0
25.0
30.0
Percentage CPU Utilization
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 23: [Video-C2]: Average Resource Usage
owing to a more compute-intensive workload. Both PostgreSQL
and VDMS spend more time idle-waiting when the operations are
being performed. Scanner, on the other hand, is not optimized for
operation pipelines. Hence, for every frame, it performs all the
operations and stores the resulting frame as a row in the output
table. This process is repeated for all frames of all videos, thus
increasing the overall execution time. Resource utilization trend is
also similar to C1 with low utilization for PostgreSQL and VDMS
and comparatively higher utilization for Scanner and VDMS-Async.
2
4
8
16
32
64
128
Parallel Clients
0.0
100.0
200.0
300.0
400.0
500.0
600.0
700.0
Execution Time (minutes)
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 24: [Video-C3]: Query Duration
6.6.3
Video-C3: We next query the operation pipeline used in
C2, but with multiple clients querying the system concurrently. We
2
4
8
16
32
64
128
Parallel Clients
0
200
400
600
800
Frames per Second
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 25: [Video-C3]: Throughput
2
4
8
16
32
64
128
Parallel Clients
0.0
20.0
40.0
60.0
80.0
Percentage CPU Utilization
PostgreSQL
VDMS
VDMS-Async
Scanner
Figure 26: [Video-C3]: Average Resource Usage
increase the number of concurrent clients from 2 to 128 by doubling
every run.
VDMS-Async fares better than other systems, and the gain is
considerably better compared to the other two categories owing to
the higher compute requirement with the parallel clients coming
into the picture. For any set of clients, VDMS-Async has a gain
in query duration by at least 2X of that of the competing systems
(Figure 24). The gain for the number of frames processed per second
goes to 3X for the higher number of clients (32, 64) (Figure 25).
However, with the workload becoming much higher for the server
with 128 clients, this gain drops to 2.5X. The CPU utilization trends
(Figure 26) are similar to Image-C3 as with more parallel clients,
the CPU usage goes higher for all systems.
6.7
Result Analysis
We next analyse the reason behind the results in the benchmarking
experiments. For this analysis, we utilize the Visual Road Dataset [8]
that has long videos of ≈60 minutes and ≈200MB in size and
≈100k frames. The longer videos ensure that there is visible idle-
waiting time to observe and also show the effectiveness of VDMS-
Async with longer videos. The dataset has 64 different videos, but we
perform this analysis with ten videos such that the results are easier
to understand. The experiment setup is the same as the previous
experiments with the VDMS server, remote server and the client at
three different machines. In these experiments, we use VQ7.
Both PostgreSQL and VDMS have periods of idle waiting (Fig-
ure 27), resulting in longer query duration but very low average

---

Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
Rohit Verma and Arun Raghunath
0
1000
2000
3000
4000
Time (in seconds)
0
20
40
60
80
100
CPU Utilization (%)
VDMS-Async
Scanner
VDMS
PostgreSQL
Figure 27: CPU Utilization over time for Competing Systems
PostgreSQL
VDMS
Scanner
VDMS-Async
Competing Systems
0.0
10.0
20.0
30.0
40.0
50.0
Percentage CPU Utilization
(a) Average CPU Utilization
PostgreSQL
VDMS
Scanner
VDMS-Async
Competing Systems
0.0
1000.0
2000.0
3000.0
4000.0
Execution Time (seconds)
(b) Query Duration
Figure 28: Average CPU Utilization during query execution
and Query Duration. VDMS-Async completes ≈3.5𝑋faster
than PostgreSQL and VDMS, and ≈12𝑋faster than Scanner.
CPU utilization (Figure 28(a)). Scanner works on a frame-by-frame
basis with 100k frames resulting in the CPU being almost always
active (Figure 27). However, the utilization for a single frame is low
(indicated by the smaller peaks), leading to overall low CPU Utiliza-
tion (Figure 28(a)) but a fairly longer running time. VDMS-Async
completes the entire query with a short burst of high activity (Fig-
ure 27). A higher level of parallelization with two threads active for
the entire query duration leads to a CPU utilization of ≈50% on av-
erage (Figure 28(a)). The event-driven architecture of VDMS-Async
eliminates idle waiting and utilizes the available CPU resources to
guarantee faster query completion. As seen in Figure 28(b), there
is a 3-12X improvement in query duration against the competing
systems. We believe this is a suitable trade-off for a visual data
management system that deals with compute-intensive operations.
We note that the higher level of parallelization enabled by VDMS-
Async places a higher load on the remote server(s) and the network.
The system-wide effects of such load need to be considered, espe-
cially in larger deployments with multiple tenants. Future research
in this space could include intelligent offloading with system-wide
resource awareness, as well as QoS policies for service differentia-
tion.
6.8
Scale-out Results
We next evaluate the impact of scaling out with remote operations.
We use a set of AWS Instances to set up an ecosystem of remote
servers. All these instances run the Ubuntu 20.04 dual-socket server
with AMD EPYC 7R13 CPUs @ 2.65GHz with 192 cores and have
376 GB of DDR4 DRAM. We run our tests on the LFW dataset and
execute the query IQ4 on VDMS-Async. We vary the number of
remote servers from 1 to 64 and run two experiments with 32k and
320k images by employing 64 parallel clients querying simultane-
ously. All results are based on averaging over 15 runs.
1
2
4
8
16
32
64
Number of Remote Servers
0.0
10.0
20.0
30.0
40.0
50.0
60.0
T(1)/T( )
(a) 32k Images
1
2
4
8
16
32
64
Number of Remote Servers
0.0
10.0
20.0
30.0
40.0
50.0
60.0
T(1)/T( )
(b) 320k Images
Figure 29: Relative performance gains with remote servers
Figure 29 shows the ratio of query execution time when one
remote server is used to the query execution time when 𝜅remote
servers are used (𝑇(1)
𝑇(𝜅) ), where 𝑇(𝑥) is the query execution time
when 𝑥remote servers are used. It is evident that employing 𝜅
remote servers decreases the execution time by 𝜅times. Effectively,
increasing the number of remote servers from 1 to 64 decreases
the query execution time by 64X. It should be noted that a limit
of 64 servers is kept to show the linear increase in gain, and no
scaling limits are reached. The linear reduction will be true for a
larger number of servers. The linear scaling of VDMS-Async opens
the possibility for large-scale deployments to significantly reduce
overall execution time, or handle large numbers of clients, by simply
adding more remote servers.
7
CONCLUSION
The increasing utilization of visual data in a plethora of applications
has brought up the need for efficient visual data management sys-
tems. However, these systems need to address various challenges
like optimizing query execution time, multitasking, end-to-end
framework support, supporting a large number of clients, and edge
deployments with resource constraints. In light of this, we develop
VDMS-Async, which is an improvement over VDMS, an existing
visual data management system. Our upgrade overhauls the exist-
ing VDMS architecture to support asynchronous query processing
as well as includes support for user-defined operations and remote
operations. These capabilities further help scale to a much larger
number of clients. Our experiments on VDMS-Async show that
for both image and video data, VDMS-Async reduces the query
execution time by at least half compared to the existing state-of-
the-art systems. Moreover, when provided with 𝜅remote servers,
VDMS-Async reduces the execution time by 𝜅times.
VDMS-Async thus provides an efficient and fast visual data man-
agement system that could be utilized by a large number of applica-
tions for both images and videos. There do exist some key directions
that require further research. (a) Designing a distributed version
of VDMS-Async that works on a single data store at a remote loca-
tion could further increase the scalability. (b) VDMS-Async works
with videos by extracting all frames, further research is required to
devise strategies such that a subset of frames could suffice. (c) An
intelligent setup can be designed that decides when to offload the
tasks to a remote server and to what number of remote servers
based on the workload and the available resources.

---

VDMS-Async
Conference acronym ’XX, June 03–05, 2018, Woodstock, NY
REFERENCES
[1] Favyen Bastani, Oscar Moll, and Sam Madden. 2020. Vaas: video analytics at
scale. (2020).
[2] Doug Beaver, Sanjeev Kumar, Harry C Li, Jason Sobel, and Peter Vajgel. 2010.
Finding a needle in haystack: Facebook’s photo storage. In 9th USENIX Symposium
on Operating Systems Design and Implementation (OSDI 10).
[3] Gary Bradski. 2000. The openCV library. Dr. Dobb’s Journal: Software Tools for
the Professional Programmer 25, 11 (2000), 120–123.
[4] Maureen Daum, Brandon Haynes, Dong He, Amrita Mazumdar, and Magdalena
Balazinska. 2021. TASM: A tile-based storage manager for video analytics. In 2021
IEEE 37th International Conference on Data Engineering (ICDE). IEEE, 1775–1786.
[5] Myron Flickner, Harpreet Sawhney, Wayne Niblack, Jonathan Ashley, Qian
Huang, Byron Dom, Monika Gorkani, Jim Hafner, Denis Lee, Dragutin Petkovic,
et al. 1995. Query by image and video content: The QBIC system. computer 28, 9
(1995), 23–32.
[6] Vishakha Gupta-Cledat, Luis Remis, and Christina R Strong. 2017. Addressing
the Dark Side of Vision Research: Storage.. In HotStorage.
[7] Brandon Haynes, Amrita Mazumdar, Magdalena Balazinska, Luis Ceze, and Alvin
Cheung. 2018. Lightdb: A dbms for virtual reality video. Proceedings of the VLDB
Endowment 11, 10 (2018).
[8] Brandon Haynes, Amrita Mazumdar, Magdalena Balazinska, Luis Ceze, and Alvin
Cheung. 2019. Visual road: A video data management benchmark. In Proceedings
of the 2019 International Conference on Management of Data. 972–987.
[9] Wenjia He, Michael R Anderson, Maxwell Strome, and Michael Cafarella. 2020.
A method for optimizing opaque filter queries. In Proceedings of the 2020 ACM
SIGMOD International Conference on Management of Data. 1257–1272.
[10] Joseph M Hellerstein and Michael Stonebraker. 1993. Predicate migration: Opti-
mizing queries with expensive predicates. In Proceedings of the 1993 ACM SIGMOD
international conference on Management of data. 267–276.
[11] Gary B Huang and Erik Learned-Miller. 2014. Labeled faces in the wild: Updates
and new reporting procedures. Dept. Comput. Sci., Univ. Massachusetts Amherst,
Amherst, MA, USA, Tech. Rep 14, 003 (2014).
[12] Eaman Jahani, Michael J Cafarella, and Christopher Ré. 2011. Automatic opti-
mization for MapReduce programs. arXiv preprint arXiv:1104.3217 (2011).
[13] Daniel Kang, Peter Bailis, and Matei Zaharia. 2018. BlazeIt: optimizing declarative
aggregation and limit queries for neural network-based video analytics. arXiv
preprint arXiv:1805.01046 (2018).
[14] Daniel Kang, John Emmons, Firas Abuzaid, Peter Bailis, and Matei Zaharia. 2017.
NoScope: Optimizing Deep CNN-Based Queries over Video Streams at Scale.
Proc. VLDB Endow. 10, 11 (2017), 1586–1597.
[15] Will Kay, Joao Carreira, Karen Simonyan, Brian Zhang, Chloe Hillier, Sudheendra
Vijayanarasimhan, Fabio Viola, Tim Green, Trevor Back, Paul Natsev, et al. 2017.
The kinetics human action video dataset. arXiv preprint arXiv:1705.06950 (2017).
[16] Marco La Cascia and Edoardo Ardizzone. 1996. Jacob: Just a content-based query
system for video databases. In 1996 IEEE International Conference on Acoustics,
Speech, and Signal Processing Conference Proceedings, Vol. 2. IEEE, 1216–1219.
[17] Ziliang Lai, Chenxia Han, Chris Liu, Pengfei Zhang, Eric Lo, and Ben Kao. 2021.
Top-K Deep Video Analytics: A Probabilistic Approach. In Proceedings of the 2021
International Conference on Management of Data. 1037–1050.
[18] JeongKyu Lee, JungHwan Oh, and Sae Hwang. 2005. Strg-index: Spatio-temporal
region graph indexing for large video databases. In Proceedings of the 2005 ACM
SIGMOD international conference on Management of data. 718–729.
[19] Detlev Marpe, Thomas Wiegand, and Gary J Sullivan. 2006. The H. 264/MPEG4
advanced video coding standard and its applications. IEEE communications
magazine 44, 8 (2006), 134–143.
[20] Bruce Momjian. 2001. PostgreSQL: introduction and concepts. Vol. 192. Addison-
Wesley New York.
[21] Subramanian Muralidhar, Wyatt Lloyd, Sabyasachi Roy, Cory Hill, Ernest Lin,
Weiwen Liu, Satadru Pan, Shiva Shankar, Viswanath Sivakumar, Linpeng Tang,
et al. 2014. f4: Facebook’s warm {BLOB} storage system. In 11th USENIX Sym-
posium on Operating Systems Design and Implementation (OSDI 14). 383–398.
[22] AB MySQL. 2001. MySQL.
[23] Virginia E Ogle and Michael Stonebraker. 1995. Chabot: Retrieval from a relational
database of images. Computer 28, 9 (1995), 40–48.
[24] JungHwan Oh and Kien A Hua. 2000. Efficient and cost-effective techniques for
browsing and indexing large video databases. In Proceedings of the 2000 ACM
SIGMOD international conference on Management of data. 415–426.
[25] Alex Poms, Will Crichton, Pat Hanrahan, and Kayvon Fatahalian. 2018. Scanner:
Efficient video analysis at scale. ACM Transactions on Graphics (TOG) 37, 4 (2018),
1–13.
[26] Karthik Ramachandra, Kwanghyun Park, K Venkatesh Emani, Alan Halverson,
César Galindo-Legaria, and Conor Cunningham. 2017. Froid: Optimization of
imperative programs in a relational database. Proceedings of the VLDB Endowment
11, 4 (2017), 432–444.
[27] Luis Remis and Chaunté W Lacewell. 2021. Using VDMS to index and search
100M images. Proceedings of the VLDB Endowment 14, 12 (2021), 3240–3252.
[28] Astrid Rheinländer, Arvid Heise, Fabian Hueske, Ulf Leser, and Felix Naumann.
2015. SOFA: An extensible logical optimizer for UDF-heavy data flows. Informa-
tion Systems 52 (2015), 96–125.
[29] SensorTower. 2021. The State of Streaming Apps. https://go.sensortower.com/
rs/351-RWH-315/images/state-of-streaming-apps.pdf
[30] SOFTWARETESTINGHELP. 2023. Future Of Virtual Reality – Market Trends And
Challenges. https://www.softwaretestinghelp.com/future-of-virtual-reality/
[31] Venkateshwaran Venkataramani, Zach Amsden, Nathan Bronson, George Cabr-
era III, Prasad Chakka, Peter Dimov, Hui Ding, Jack Ferris, Anthony Giardullo,
Jeremy Hoon, et al. 2012. Tao: how facebook serves the social graph. In Proceed-
ings of the 2012 ACM SIGMOD International Conference on Management of Data.
791–792.
[32] Fang Wang, Xiao Yan, Man Lung Yiu, Shuai LI, Zunyao Mao, and Bo Tang.
2023. Speeding Up End-to-end Query Execution via Learning-based Progressive
Cardinality Estimation. Proceedings of the ACM on Management of Data 1, 1
(2023), 1–25.
[33] Ziqian Zhao. 2022. An Analysis and Prospect of Video Streaming Industry:
Evidence from Netflix Inc. In 2022 2nd International Conference on Enterprise
Management and Economic Development (ICEMED 2022). Atlantis Press, 311–317.
[34] Xingquan Zhu, Xindong Wu, Ahmed K Elmagarmid, Zhe Feng, and Lide Wu. 2005.
Video data mining: Semantic indexing and event detection from the association
perspective. IEEE Transactions on Knowledge and Data engineering 17, 5 (2005),
665–677.

---

