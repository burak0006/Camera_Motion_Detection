## Real Time Camera_Motion_Detection in H.264 Compressed Domain

Global motion estimation (GME) is basically performed to detect and extract camera motion. As being one of the most important tools in video processing field with many applications, it is mainly carried out in pixel or compressed domain. Since those based on the pixels have drawbacks such as high computational complexity, most researches are oriented to the compressed domain in which motion vectors are utilized.  On the other hand, there are many unwanted existing outliers in motion vector based global motion estimation because of noise or foreground effects. In this work, proposed motion vector dissimilarity measure is used to remove the outliers to provide fast and accurate motion vector based global motion estimation. For coastguard.yuv sequence to download

http://trace.eas.asu.edu/yuv/

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

This project comprises performing super fast real time GME based on motion vectors. The only decoded information from bitstream is MVs enabling very low latency that can be used in many applications such as video retrieval and indexing, image registration, background modeling, moving object segmentation, scene analysis, object-oriented coding, and MPEG-7 video descriptors. In other words, wherever you want!. In video processing research community, my personel opinion is that there is a difficulty regarding how to get features like MVs from high efficient compressed domains such as H.264/AVC or H.265/HEVC. I basically extracted MVs both using JM reference software and Matlab for ```coastguard_cif``` sequence. In this project, MVs obtained by variable block size motion estimation are used to estimate camera motion parameters. In the end, how far the camera moved in terms of pan, tilt and zoom are calculated through the estimated parameters using perspective transformation and Newton Rapson gradient descent algorithms. Our dissimilarity measure is very efficient and used to detect outlier MVs, which can be both noise or foreground that disrupt the camera motion performance. Our proposed algorithm automatically detects which MVs are more likely to be an outlier! The general steps are:

1. Motion vector extraction from bitstream
2. Detection MV outliers
3. Performing GME using the rest of MVs.
4. Performing GMC (optional)

### Code Explanations

```main.m```          : you can simply run this code to see the results. You need to change yuv sequence and mv_path
```readOneFrame.m```  : reads one frame from the YUV sequence
```segshow.m```       : outlier MV regions are shown in black 
```psnrGMC.m```       : PSNR Calculation between the current and GMC frames
```o_rej.m```         : Our MV Dissimilarity Measure
```mvGME_NR_test.m``` : Newton Raphson Gradient Descent Algorithm
```gmeTF.m```         : Affine transformation function (Rotation, Translation, Resize)

### Input Sequence

Input     : Coastguard.yuv
Width     : 352
Height    : 288
Profile   : H.264 Baseline IPPPP...
Rate      : 30 Hz, 15 GOP

<img src="https://github.com/burak0006/Camera_Motion_Detection/blob/main/images/coastguard_frame64.png?raw=true" width = "352" height = "288"/> <img src="https://github.com/burak0006/Camera_Motion_Detection/blob/main/images/coastguard_frame_64mvs.png?raw=true" width = "352" height = "288"/> 

Coastguard 64 th.frame and its MV field

### Requirements

- MacOS X,Linux or Windows

### The Results 

The processed frames are shown in below figure. The blacked regions are having outlier MVs so they are omitted during GME. These are generally located at the edges of the frame or borders of a frame 

<img src="https://github.com/burak0006/Camera_Motion_Detection/blob/main/images/coastguardprocessed.gif?raw=true" width = "352" height = "288"/>

### The References

[1] https://www.researchgate.net/publication/258938629_OR_GME_software
(Thanks to Ivan Bajic)
Y.-M. Chen and I.V. Bajic, Motion Vector Outlier Rejection Cascade for Global Motion Estimation, IEEE Signal Processing Letters, 17 (2010) 197-200.
[2] https://uk.mathworks.com/matlabcentral/fileexchange/40359-h-264-baseline-codec-v2
(Thanks to Abdullah Al Muhit)
A A Muhit, M R Pickering, M R Frater and J F Arnold, Video Coding using Elastic Motion Model and Larger Blocks, IEEE Trans. Circ. And Syst. for Video Technology, vol. 20, no. 5, pp. 661-672, 2010.
