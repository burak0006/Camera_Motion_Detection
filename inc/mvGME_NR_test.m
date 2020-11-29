function mIter = mvGME_NR_test(GMMODE, npx, npy, iMap, coorX, coorY, MAXITER, STEP, iniMM)

% start from the preprocessed MV field
oriIn = find(iMap==1);
% initialize global motion parameters..
N = sum(iMap(:));
idxIt = 1;

if ~isempty(iniMM)
    m = iniMM;
else
    m = zeros(1,8);
    m(1) = 1;
    m(5) = 1;
    m(3) = sum(npx(oriIn))/N;
    m(6) = sum(npy(oriIn))/N;
end
mIter(idxIt, :) = m; % get the initial set of GMP
idxIt = idxIt + 1;

% try 4 motion model (translationa, isotropic, affine, perspective)

for num = 1:MAXITER
    % get residual
    [rcoorX, rcoorY] = coorEst(m, coorX, coorY);  % estimate reference coordinate
    emvx = npx-rcoorX+coorX;
    emvy = npy-rcoorY+coorY;
    emv = emvx.^2+emvy.^2;
    in_emv = emv(oriIn);

    % get 70% of MVs as inliers
    [B,IX] = sort(in_emv);
    IXIN = IX(1:round(N*STEP));
    rM = oriIn(IXIN);

    if GMMODE == 1 % translational model
        [m, adm] = transEst(rM, emvx, emvy, m);
        mIter(idxIt, :) = m; % get the initial set of GMP
        idxIt = idxIt + 1;
        if (adm(1)<1e-3) && (adm(2)<1e-3) && (im > 1)
%                 break;
        end
    elseif GMMODE == 2 % isotropic model
        [m, adm] = isotroEst(rM, emvx, emvy, coorX, coorY, m);
        mIter(idxIt, :) = m; % get the initial set of GMP
        idxIt = idxIt + 1;
        if (adm(3)<1e-3) && (adm(4)<1e-3) && (adm(1)<1e-5) && (adm(2)<1e-5)
%                 break;
        end
    elseif GMMODE == 3 % affine model
        [m, adm] = affineEst(rM, emvx, emvy, coorX, coorY, m);
        mIter(idxIt, :) = m; % get the initial set of GMP
        idxIt = idxIt + 1;
        if (adm(3)<1e-3) && (adm(6)<1e-3) && (adm(1)<1e-5) ...
                && (adm(2)<1e-5) && (adm(4)<1e-5) && (adm(5)<1e-5) 
%                 break;
        end
    elseif GMMODE == 4 % perspective model
        [m, adm] = prespEst(rM, emvx, emvy, coorX, coorY, rcoorX, rcoorY, m);
        mIter(idxIt, :) = m; % get the initial set of GMP
        idxIt = idxIt + 1;
        if (adm(3)<1e-3) && (adm(6)<1e-3) && (adm(1)<1e-5) ...
                && (adm(2)<1e-5) && (adm(4)<1e-5) && (adm(5)<1e-5)...
                && (adm(7)<1e-5) && (adm(8)<1e-5)
%                 break;
        end
    end

end

% replicate the GMP if the convergence occurs early
if num ~= MAXITER
    for jj = num+1:MAXITER
        mIter(idxIt, :) = m;
        idxIt = idxIt + 1;
    end
end


function [m, adm] = prespEst(rM, emvx, emvy, coorX, coorY, rcoorX, rcoorY, m)

[dexdm, deydm] = d_persp(coorX, coorY, rcoorX, rcoorY, rM, m);
A = a_calc(dexdm, deydm, 8);
B = b_calc(emvx, emvy, rM, dexdm, deydm, 8);

%
dm = A\B'; % directly inversion of matrix

% pseudo-inverse...
%             A_pseu = pseuInv(A);
%             dm = A_pseu * B';

adm = abs(dm);
m = m + dm';

function  [m, adm] = affineEst(rM, emvx, emvy, coorX, coorY, m)

[dexdm, deydm] = d_affin(coorX, coorY, rM);
A = a_calc(dexdm, deydm, 6);
B = b_calc(emvx, emvy, rM, dexdm, deydm, 6);

%
dm = A\B'; % directly inversion of matrix

% pseudo-inverse...
%             A_pseu = pseuInv(A);
%             dm = A_pseu * B';

adm = abs(dm);
pdm = zeros(1,8);
pdm(1:6) = dm(:);
m = m + pdm;

function [m, adm] = isotroEst(rM, emvx, emvy, coorX, coorY, m)

[dexdm, deydm] = d_isotr(coorX, coorY, rM);
A = a_calc(dexdm, deydm, 4);
B = b_calc(emvx, emvy, rM, dexdm, deydm, 4);

%
dm = A\B'; % directly inversion of matrix

% pseudo-inverse...
%             A_pseu = pseuInv(A);
%             dm = A_pseu * B';
adm = abs(dm);
m(1) = m(1) + dm(1);
m(2) = m(2) + dm(2);
m(3) = m(3) + dm(3);
m(4) = -m(2);
m(5) = m(1);
m(6) = m(6) + dm(4);

function [m, adm] = transEst(rM, emvx, emvy, m)
[dexdm, deydm] = d_trans(rM);
A = a_calc(dexdm, deydm, 2);
B = b_calc(emvx, emvy, rM, dexdm, deydm, 2);

%
dm = A\B'; % directly inversion of matrix

% pseudo-inverse...
%             A_pseu = pseuInv(A);
%             dm = A_pseu * B';

adm = abs(dm);
m(3) = m(3) + dm(1);
m(6) = m(6) + dm(2);

function A = a_calc(dexdm, deydm, dim)
for kk = 1:dim
    for ll = 1:dim
        A(kk, ll) = sum(dexdm(kk, :).*dexdm(ll, :))+sum(deydm(kk, :).*deydm(ll, :));
    end
end

function B = b_calc(emvx, emvy, rM, dexdm, deydm, dim)
for ii = 1:dim
    B(ii) = -sum(emvx(rM)'.*dexdm(ii, :))-sum(emvy(rM)'.*deydm(ii, :));
end

function [rcoorX, rcoorY] = coorEst(m, coorX, coorY)       
factor = m(7).*coorX+m(8).*coorY+1;
rcoorX = (m(1).*coorX+m(2).*coorY+m(3))./factor;
rcoorY = (m(4).*coorX+m(5).*coorY+m(6))./factor;

function A_pseu = pseuInv(A)
[m,n]=size(A);
[U,S,V]=svd(A);
rs=rank(S);
SR=S(1:rs,1:rs);
SRc=[SR^-1 zeros(rs,m-rs);zeros(n-rs,rs) zeros(n-rs,m-rs)];
A_pseu=V*SRc*U.';

function [dexdm, deydm] = d_trans(rM)
dexdm(1, :) = -ones(size(rM));
dexdm(2, :) = zeros(size(rM));
deydm(1, :) = zeros(size(rM));
deydm(2, :) = -ones(size(rM));
% [mm, nn] = size(rM);
% dexdm(1, :) = -ones(1, mm);
% dexdm(2, :) = zeros(1, mm);
% deydm(1, :) = zeros(1, mm);
% deydm(2, :) = -ones(1, mm);

function [dexdm, deydm] = d_isotr(coorX, coorY, rM)
[mm, nn] = size(rM);
dexdm(1, :) = -coorX(rM);
dexdm(2, :) = -coorY(rM);
dexdm(3, :) = -ones(1, mm);
dexdm(4, :) = zeros(1, mm);

deydm(1, :) = -coorY(rM);
deydm(2, :) = coorX(rM);
deydm(3, :) = zeros(1, mm);
deydm(4, :) = -ones(1, mm);

function [dexdm, deydm] = d_affin(coorX, coorY, rM)
[mm, nn] = size(rM);
dexdm(1, :) = -coorX(rM);
dexdm(2, :) = -coorY(rM);
dexdm(3, :) = -ones(1, mm);
dexdm(4, :) = zeros(1, mm);
dexdm(5, :) = zeros(1, mm);
dexdm(6, :) = zeros(1, mm);

deydm(1, :) = zeros(1, mm);
deydm(2, :) = zeros(1, mm);
deydm(3, :) = zeros(1, mm);
deydm(4, :) = -coorX(rM);
deydm(5, :) = -coorY(rM);
deydm(6, :) = -ones(1, mm);

function [dexdm, deydm] = d_persp(coorX, coorY, rcoorX, rcoorY, rM, m)
[mm, nn] = size(rM);
DD = coorX(rM).*m(7)+coorY(rM).*m(8)+1;
dexdm(1, :) = -coorX(rM)./DD;
dexdm(2, :) = -coorY(rM)./DD;
dexdm(3, :) = -ones(1, mm)./DD';
dexdm(4, :) = zeros(1, mm);
dexdm(5, :) = zeros(1, mm);
dexdm(6, :) = zeros(1, mm);
dexdm(7, :) = rcoorX(rM).*coorX(rM)./DD;
dexdm(8, :) = rcoorX(rM).*coorY(rM)./DD;

deydm(1, :) = zeros(1, mm);   
deydm(2, :) = zeros(1, mm);  
deydm(3, :) = zeros(1, mm);  
deydm(4, :) = -coorX(rM)./DD;
deydm(5, :) = -coorY(rM)./DD;
deydm(6, :) = -ones(1, mm)./DD';
deydm(7, :) = rcoorY(rM).*coorX(rM)./DD;
deydm(8, :) = rcoorY(rM).*coorY(rM)./DD;
