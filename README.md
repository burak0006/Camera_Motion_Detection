## Real Time Camera_Motion_Detection in H.264 Compressed Domain

Global motion estimation (GME) is basically performed to detect and extract camera motion. As being one of the most important tools in video processing field with many applications, it is mainly carried out in pixel or compressed domain. Since those based on the pixels have drawbacks such as high computational complexity, most researches are oriented to the compressed domain in which motion vectors are utilized.  On the other hand, there are many unwanted existing outliers in motion vector based global motion estimation because of noise or foreground effects. In this work, proposed motion vector dissimilarity measure is used to remove the outliers to provide fast and accurate motion vector based global motion estimation

#### Our publication: 
Please cite when using the codes. Thanks

B. Yıldırım and H. A. Ilgın, "Motion vector outlier removal using dissimilarity measure", Digit. Signal Process., vol. 46, pp. 1-9, Nov. 2015.
https://www.sciencedirect.com/science/article/abs/pii/S105120041500250X

### Variable Block Size Motion Vectors 

<img src="https://github.com/burak0006/Camera_Motion_Detection/blob/main/images/mbpartitions.png?raw=true" width = "500" height = "200"/>

In H.264, multiple reference frames and variable block size are used in interframe coding. A macroblock of 16x16 size can be divided to the partitions with the size of 16x8, 8x16 or 8x8.  Each 8x8 block can further then be divided into the sub partitions 8x4, 4x8 or 4x4 as shown above.

<img src="https://github.com/burak0006/Camera_Motion_Detection/blob/main/images/blockmv.png?raw=true" width = "500" height = "200"/>

In encoding step (previously done), if a block whose size is larger than 4x4, MV belongs to this block is assigned to its all covered 4x4 blocks illustrated above. In this figure, two  4x8  block  MVs  are  assigned  to  their  4x4  sub levels.  This  makes  MVs  uniformly  sampled

### The Scope of the Project

This project comprises performing super fast real time GME based on motion vectors. The only decoded information from bitstream is MVs enabling very low latency that can be used in many applications such as video retrieval and indexing, image registration, background modeling, moving object segmentation, scene analysis, object-oriented coding, and MPEG-7 video descriptors. In other words, wherever you want!. In video processing research community, my personel opinion is that there is a difficulty regarding how to get features like MVs from high efficient compressed domains such as H.264/AVC or H.265/HEVC. I basically extracted MVs both using JM reference software and Matlab for ```coastguard_cif``` sequence. In this project, MVs obtained by variable block size motion estimation are used to estimate camera motion parameters. In the end, how far the camera moved in terms of pan, tilt and zoom are calculated through the estimated parameters using perspective transformation and Newton Rapson gradient descent algorithms. Our dissimilarity measure is very efficient and used to detect outlier MVs, which can be both noise or foreground that disrupt the camera motion performance. Our proposed algorithm automatically detects which MVs are more likely to be outlier! The project is performed basically as follows respectively:

1. Motion vector extraction from bitstream
2. Detection MV outliers
3. Performing GME using the rest of MVs.
4. Performing GMC (optional)

### Requirements

- MacOS X,Linux or Windows
