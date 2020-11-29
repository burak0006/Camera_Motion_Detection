% 
% File: func_read_yuv.m
%
% Description: read YUV 411 video file and show the Y component
% continuously.
%
% Yue-Meng Chen At SFU
%
% Contact: yuemengc@sfu.ca
% 

function [img_y, img_u, img_v] = readOneFrame(fid, nRow, nColumn)
%reading Y component 
img_y = fread(fid, nRow * nColumn, 'uchar');
img_y = reshape(img_y, nColumn, nRow);
img_y = img_y';

%reading U component
img_u = fread(fid, nRow * nColumn / 4, 'uchar');
img_u = reshape(img_u, nColumn/2, nRow/2);
img_u = img_u';

%reading V component
img_v = fread(fid, nRow * nColumn / 4, 'uchar');
img_v = reshape(img_v, nColumn/2, nRow/2);
img_v = img_v';
