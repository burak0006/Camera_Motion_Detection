%% pSNR calculation for GMC.
% GME vectors replace the original MVs.
% The residual between Global motion compansated frame and the current frame are calculated as PSNR 

function [psnr,D] = psnrGMC(yPrev, yCurr, M)
yWarp=gmeTF(yCurr, M, 1);
D=yWarp-yPrev;
[pR, pC] = size(D);
mse=sum(D(:).*D(:))/(pC*pR);
psnr=10*log10(255^2/mse); % PSNR for affine motion model
