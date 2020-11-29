%% MV Outlier Rejection Algorithm using Dissimilarity Measure 
% Author Burak Y
% Dissimilarity measure for motion vectors is very useful for detecting outlier 
% MVs in our approach. This measure is commonly used as a “Similarity Measure” 
% to determine motion similarity between two frames. In “Similarity Measure”, 
% horizontal and vertical components of input MV are half wave rectified into 
% nonnegative channels. Accordingly the angle between two MVs is mapped to [0°,90°]. 
% Motion similarity using these channels are then calculated between two frames using
% motion descriptors. The similarity measure is referred to as Nonnegative Channels Normalized Correlation (NCNC)

function [MV_ind]=o_rej(MV_XT,MV_YT,rows,cols,blkSize,rate)

MVmap=zeros(1,rows/blkSize*cols/blkSize);
MV_ind=ones(rows/blkSize,cols/blkSize);
%3x3 Neighbouring vectors
%--------------------------------------------------------------------------

expx = wextend('2D','sym',MV_XT,1);
expy = wextend('2D','sym',MV_YT,1);

MVx8adj(1,:)= reshape(expx(1:end-2, 1:end-2),1,[]);
MVx8adj(2,:)= reshape(expx(1:end-2, 2:end-1),1,[]);
MVx8adj(3,:)= reshape(expx(1:end-2, 3:end),1,[]);
MVx8adj(4,:)= reshape(expx(2:end-1, 3:end),1,[]);
MVx8adj(5,:)= reshape(expx(3:end, 3:end),1,[]);
MVx8adj(6,:)= reshape(expx(3:end, 2:end-1),1,[]);
MVx8adj(7,:)= reshape(expx(3:end, 1:end-2),1,[]);
MVx8adj(8,:)= reshape(expx(2:end-1, 1:end-2),1,[]);

MVy8adj(1,:)= reshape(expy(1:end-2, 1:end-2),1,[]);
MVy8adj(2,:)= reshape(expy(1:end-2, 2:end-1),1,[]);
MVy8adj(3,:)= reshape(expy(1:end-2, 3:end),1,[]);
MVy8adj(4,:)= reshape(expy(2:end-1, 3:end),1,[]);
MVy8adj(5,:)= reshape(expy(3:end, 3:end),1,[]);
MVy8adj(6,:)= reshape(expy(3:end, 2:end-1),1,[]);
MVy8adj(7,:)= reshape(expy(3:end, 1:end-2),1,[]);
MVy8adj(8,:)= reshape(expy(2:end-1, 1:end-2),1,[]);

MV_XS=reshape(MV_XT,1,rows*cols/(blkSize^2));
MV_YS=reshape(MV_YT,1,rows*cols/(blkSize^2));
MV_XS=repmat(MV_XS,8,1);
MV_YS=repmat(MV_YS,8,1);


% Removing the vectors having a zero magnitude
%--------------------------------------------------------------------------
mind=find((MVx8adj.^2+MV_XS.^2+MVy8adj.^2+MV_YS.^2)==0);
MVmap(mind)=0;

% Phase and magnitude simmilarity calculation
%--------------------------------------------------------------------------
gos=find((MVx8adj.^2+MV_XS.^2+MVy8adj.^2+MV_YS.^2)~=0);
eHTheta(gos) = angle(MV_XS(gos), MV_YS(gos),MVx8adj(gos),MVy8adj(gos));

eHTheta(gos) = abs(eHTheta(gos));
nrm_min(gos) = min((MV_XS(gos).^2+MV_YS(gos).^2),...
                (MVx8adj(gos).^2+MVy8adj(gos).^2));
nrm_max(gos) = max((MV_XS(gos).^2+MV_YS(gos).^2),...
                (MVx8adj(gos).^2+MVy8adj(gos).^2));
girdi(gos)=nrm_min(gos)./nrm_max(gos);
MVmap(gos)   = eHTheta(gos).*girdi(gos);

% Summing the similarity values
%--------------------------------------------------------------------------

top=vec2mat(MVmap,8);
top=sum(top(:,1:8)');
top=reshape(top,rows/(blkSize),cols/(blkSize));

% Rejection of MVs with a 1-rate
[sortedValues,sortIndex] = sort(top(:),'descend');  
minIndex = sortIndex(1:floor((length(MV_XT(:))*(1-rate)))); 
MV_ind(minIndex)=0;







