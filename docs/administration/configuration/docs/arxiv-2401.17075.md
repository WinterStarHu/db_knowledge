# Non-central panorama indoor dataset

> 来源: https://arxiv.org/pdf/2401.17075

Non-central panorama indoor dataset
A Preprint
Bruno Berenguel-Baeta∗
Instituto de Investigacion en Ingenieria de Aragon
Department of Computer Science and Systems Engineering
University of Zaragoza, Zaragoza, Spain
berenguel@unizar.es
Jesus Bermudez-Cameo
Instituto de Investigacion en Ingenieria de Aragon
Department of Computer Science and Systems Engineering
University of Zaragoza, Zaragoza, Spain
bermudez@unizar.es
Jose J. Guerrero
Instituto de Investigacion en Ingenieria de Aragon
Department of Computer Science and Systems Engineering
University of Zaragoza, Zaragoza, Spain
josechu.guerrero@unizar.es
Abstract
Omnidirectional images are one of the main sources of information for learning based scene
understanding algorithms. However, annotated datasets of omnidirectional images cannot
keep the pace of these learning based algorithms development. Among the different panora-
mas and in contrast to standard central ones, non-central panoramas provide geometrical
information in the distortion of the image from which we can retrieve 3D information of the
environment [2]. However, due to the lack of commercial non-central devices, up until now
there was no dataset of these kinds of panoramas. In this data paper, we present the first
dataset of non-central panoramas for indoor scene understanding. The dataset is composed
by 2574 RGB non-central panoramas taken in around 650 different rooms. Each panorama
has associated a depth map and annotations to obtain the layout of the room from the image
as a structural edge map, list of corners in the image, the 3D corners of the room and the
camera pose. The images are taken from photorealistic virtual environments and pixel-wise
automatically annotated.
Keywords Computer Vision, Indoor Scene Understanding, Non-central Panoramas,
Omnidirectional Vision, Monocular Depth Estimation, Layout Estimation
∗Corresponding author.
A final version of this article can be found at https://doi.org/10.1016/j.dib.2022.108375
arXiv:2401.17075v1  [cs.DB]  30 Jan 2024

---

Floor extraction and door detection
A Preprint
Specifications Table
Subject
Computer Science: Computer Vision and Pattern Recognition
Specific
subject
area
Non-central circular panoramas for indoor scene understanding.
Type of data
RGB Image (.png)
Color code depth maps (.png)
Layout annotations (.png, .npy, .txt, .mat)
How the data were
acquired
Random generation of virtual environments.
Ad-hoc programmable camera projection model for image rendering via ray tracing.
The RGB images are rendered with POV-Ray2 and the depth maps with Mega-
POV3.
Layout annotations are obtained from the 3D model of the virtual environment.
Data format
Raw
Filtered
Description of data
collection
From the generated virtual environments, we randomly place the non-central
acquisition system in different locations inside the environment. The radius of
acquisition is 1 meter. The size of the panoramas is 1024x512 pixels. Once acquired
the non-central panoramas, we exclude those that will be physically imposible to
acquire in a real situation (i.e. the non-central acquisition system goes through an
object or a wall, creating a black hole in the image).
Data source loca-
tion
Institution: University of Zaragoza, Department of Computer Science and Systems
Engineering
City/Town/Region: Zaragoza, Aragon
Country: Spain
Latitude and longitude for collected samples/data:
41.68390649378424 N -
0.8887470805962938 E
Data accessibility
Repository name: Google Drive (via Github repository to make it easier for the
user)
URL
to
Github
repository:
https://github.com/jesusbermudezcameo/
NonCentralIndoorDataset
URL to data (Google Drive shared folder):
https://drive.google.com/drive/
folders/18OQXpbZsr3RBphU0kJC0OS2OXr-3BrkV?usp=sharing
Related research
article
B. Berenguel-Baeta, J. Bermudez-Cameo and J.J. Guerrero, Atlanta Scaled Layouts
from Non-central Panoramas. Pattern Recognition (2022). DOI:https://doi.org/
10.1016/j.patcog.2022.108740
Value of the Data
• The presented dataset is the first existing dataset with non-central panoramas. Besides it includes
annotations for different purposes as layout recovery, line extraction and depth estimation.
• Researchers who want to take advantage of the geometrical properties of non-central systems can find
in this dataset a perfect source of information for evaluation and development of new algorithms.
• Since it is the first non-central dataset, it can be used to adapt existing algorithms for
omnidirectional central images to the no-central case. Besides, in the related research [1], only the
RGB images and layout annotations have been used, leaving the depth maps for future research
topics.
Data Description
The dataset contains a set of gravity oriented panoramas. We make this specification since non-central
panoramas cannot be rotated as a data augmentation in a different axis that the revolution axis of the
non-central system. The dataset includes the folders: img contains the RGB non-central panoramas are
located; depth_coded contains depth maps coded in 3 channels (RGB channels) associated with the RGB
2The Persistence of Vision Raytracer.http://www.povray.org (accessed May 2022)
3MegaPOV. http://megapov.inertart.net (accessed May 2022)
2

---

Floor extraction and door detection
A Preprint
panoramas; EM_gt contains one channel images where the structural lines of the environments are defined;
DataPython and DataMatLab contains ground truth information used to evaluate the work presented in [1],
including the 3D position of the corners of the room (3D_gt), the camera location (cam_pose), the labelling
for the floor-wall and ceiling-wall intersections as spherical coordinates of the projecting rays (label_ang)
and the pixel coordinates of the 3D corners in the panoramas (label_cor).
The main folder follows the following distribution.
• NonCentralIndoorDataset
– img
– depth_coded
– EM_gt
– DataPython
∗3D_gt
∗cam_pose
∗label_ang
∗label_cor
– DataMatLab
∗mat_gt
Experimental design, materials and methods
The data of this dataset is obtained from environments randomly and synthetically generated. We first
generate a random layout constrained by different structural limits (see Table 2). These limits include
minimum and maximum: area of the room, number of walls, wall length, angle between walls (if
non-Manhattan), room height and Manhattan ratio.
Table 2: Layout limits for randomized generation.
Parameter
Min.
Max.
Area [m2]
25
110
n. walls
4
14
wall length [m]
0.5
8
walls angle [degs]
25
100
Room height [m]
2.5
4.25
Manhattan ratio
0.7
The first version of each layout is a Manhattan layout constrained by the previous limits. Then, depending
on the Manhattan ratio, a set of random vertical planes clip the layout introducing oblique walls in angles
with respect to the previous walls in the range of the walls angle limit. After the layout clip, we evaluate the
final layout, checking if it meets the constraints. If any of the constraints is not satisfied, the layout is deleted
and a new one is generated.
Once the structure of the room is obtained, we randomly set different kinds of walls containing doors,
windows, colors and textures. These characteristics of the walls are randomly selected from different pools
(e.g. we have different models of doors and windows to select). At this point we select the color and textures
of the ceiling and floor of the room. Once defined the 3D structure of the room, we include objects in it. For
that purpose, we build a free space map where we can place different kinds of objects. First we consider the
kind of objects that are placed next to a wall in a fixed orientation (beds, wardrobes, desks). Then we place
objects in the room in a random position and orientation (chairs, sofas, carpets). Finally, we place objects
that are placed on top of other objects (cups, clocks, clothes) and we also place lighting sources for a more
realistic rendering. All of these objects are randomly picked from different pools depending on the object
class. Besides, the ambient illumination conditions are also randomly picked from 3 different configurations.
Once defined our room, we have all the necesary information to generate the ground truth and the labelling
of the dataset (see Fig. 1). The next step is to render the RGB non-central panoramas and generate the
depth maps. The color images are rendered with the ray tracing software POV-Ray while the depth maps
are obtained with the use of MegaPOV. The non-central panoramic camera is modeled by using an ad-hoc
programmable camera projection model included in last versions of POV-Ray. For each scene we can render
3

---

Floor extraction and door detection
A Preprint
-2
5
0
2
Z
4
X
0
6
-5
Y
0
-5
5
-6
-4
-2
0
2
4
6
X
-5
-4
-3
-2
-1
0
1
2
3
4
5
Y
(a)
5
-2
4
0
2
X
2
0
Z
Y
0
4
-2
6
-5
-4
-6
-4
-2
0
2
4
6
X
-4
-3
-2
-1
0
1
2
3
4
Y
(b)
Figure 1: Layout generation and non-central panorama rendering examples. (a) Manhattan random room.
(b) Atlanta random room.
different acquisitions modifying the position and the orientation of the camera. In the case of the proposed
dataset, the camera is always oriented with the gravity direction. Notice that, by contrast with central
panoramas (e.g. equirectangular images), we can not post-process a single render for obtaining different
panoramas with different orientations.
Acknowledgments
Funding: This work was supported by RTI2018-096903-B-100 (AEI/ FEDER, UE).
References
[1] B.Berenguel-Baeta, J.Bermudez-Cameo and J.J.Guerrero. Atlanta scaled layouts from non-central
panoramas. Pattern Recognition. (2022). https://doi.org/10.1016/j.patcog.2022.108740
[2] J. Bermudez-Cameo, O. Saurer, G. Lopez-Nicolas, J.J. Guerrero and M. Pollefeys. Exploiting line
metric reconstruction from non-central circular panoramas. Pattern Recognition Letters, 94, 30-37.
(2017). https://doi.org/10.1016/j.patrec.2017.05.006
4

---

