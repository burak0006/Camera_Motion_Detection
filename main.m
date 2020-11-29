%% Real Time Global Motion Estimation and Compensation in H.264/AVC Compressed Domain
%
% Description: Extracts H.264 Baseline Profile Encoded Video features including
% MVs and variable block sizes. The block motion vectors are automatically
% converted into their 4x4 subblocks. For example, a 16x8 slice can be split
% to 8 4x4 blocks, all same motion vectors being equal.
%
%
% This script is created by Burak Y
% Contact: yldrmburak0006@gmail.com
% 
%
% Please cite when using the codes. Thanks
% B. Yıldırım and H. A. Ilgın, "Motion vector outlier removal using dissimilarity measure", Digit. Signal Process., vol. 46, pp. 1-9, Nov. 2015.
% https://www.sciencedirect.com/science/article/abs/pii/S105120041500250X
% 
% Some part of the codes were downloaded from below studies:

% References

% [1] https://www.researchgate.net/publication/258938629_OR_GME_software
% (Thanks to Ivan Bajic)
% Y.-M. Chen and I.V. Bajic, Motion Vector Outlier Rejection Cascade for Global Motion Estimation, IEEE Signal Processing Letters, 17 (2010) 197-200.
% [2] https://uk.mathworks.com/matlabcentral/fileexchange/40359-h-264-baseline-codec-v2
% (Thanks to Abdullah Al Muhit)
% A A Muhit, M R Pickering, M R Frater and J F Arnold, Video Coding using Elastic Motion Model and Larger Blocks, IEEE Trans. Circ. And Syst. for Video Technology, vol. 20, no. 5, pp. 661-672, 2010.
% A A Muhit, M R Pickering, M R Frater and J F Arnold, Video Coding using Geometry Partitioning and an Elastic Motion Model, accepted for publication in Journal of Visual Communication and Image Representation. 


SEG_PATH = '';

% You need to specify your video path
seq_in = '/Users/burakyildirim/Desktop/GMC Video/coastguard_cif.yuv';
% Width and height of the Frame
pR=288;
pC=352;
FrameMax=280;
% You need to specify your mv path
mv_path='/Users/burakyildirim/Desktop/GMC Video/';
disp('test sequence -- coastguard, 150 frames')
TITLE='Global Motion Compensation -- Coastguard';
     
% Convergence to final parameters
MAXITER =1;
% reject rate 0.1. 10% out of total blocks are discarded               
rOUTLIERS = 0.9;
REJRATE = 0.7;


% block size (H.264)
blkSize = 4; 
% Perspective Transformation (GMMODE = 4) 
GMMODE=4;
% Padding of center for MVs
bR=pR/blkSize;
bC=pC/blkSize;
[coorBlkY,coorBlkX]=ndgrid(1:bR,1:bC);
coorX = coorBlkX.*blkSize-blkSize/2;
coorY = coorBlkY.*blkSize-blkSize/2;


% Reading one frame from sequence
[fid_seq_in message]= fopen(seq_in,'rb');
tic;
for FrameNum=1:FrameMax
    %% Read one yuv Frame  
    [yCurr, uCurr, vCurr] = readOneFrame(fid_seq_in, pR, pC);
    if(FrameNum==1)
    iniMM=[];
    else
    % Extracting MVs and blocksize parameters from H.264 encoded video
    load([mv_path,int2str(floor(FrameNum/100)),int2str(floor((mod(FrameNum,100)/10))),int2str(FrameNum-floor(FrameNum/10)*10),'.mat'],'mv_x','mv_y','ind_block')
        %% GMC using DM-GD
        % Dissimilarity measure is used to remove outliers
        [iMap]=o_rej(mv_x, mv_y, pR, pC, blkSize, rOUTLIERS);
        mm0 = mvGME_NR_test(GMMODE, mv_x(:), mv_y(:), iMap(:),... 
            coorX(:), coorY(:), MAXITER, REJRATE, iniMM);
        iniMM = mm0(MAXITER+1,:); 
        psnr(FrameNum-1,:) = psnrGMC(yPrev, yCurr, iniMM); 
        fig = segshow(yCurr, iMap, coorX, coorY, blkSize);
        imwrite(fig/255,['fig',int2str(FrameNum),'.png']);
        axis equal
    end  
    yPrev=yCurr;
%calculate PSNR between two frames using bilinear interpolation
end
toc;