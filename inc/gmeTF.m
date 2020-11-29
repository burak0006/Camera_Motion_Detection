function Iout=gmeTF(Iin,M,black)
% Affine transformation function (Rotation, Translation, Resize)
% This function transforms a volume with a 3x3 transformation matrix 
%
% Iout=affine_transform_2d_double(Iin,Minv,black)
%
% inputs,
%   Iin: The input image
%   Minv: The (inverse) 3x3 transformation matrix
%   black: If true pixels from outside the image are set to zero 
%           if false to the nearest old pixel.
% output,
%   Iout: The transformed image
%
% example,
%   % Read image
%   I=im2double(imread('lenag2.png'))
%   % Make a transformation matrix
%   M=make_perspective_matrix([2 3],[1.0 1.1 0],[20 20]);
%   % Transform the image
%   Iout=rigid_transform_2d_double(I,M)
%   % Show the image
%   figure, imshow(Iout);
%
% Function is written by D.Kroon University of Twente (February 2009)
M = [M 1];
M=reshape(M,3,3);
M = inv(M');
  
% Make all x,y indices
[y,x]=ndgrid(0:size(Iin,1)-1,0:size(Iin,2)-1);

% Calculate the Transformed coordinates
Tlocalx = M(1,1) * x + M(1,2) *y + M(1,3) * 1;
Tlocaly = M(2,1) * x + M(2,2) *y + M(2,3) * 1;
%
factor = 1./(M(3,1)*x+M(3,2)*y+M(3,3));
Tlocalx = Tlocalx.*factor;
Tlocaly = Tlocaly.*factor;

% All the neighborh pixels involved in linear interpolation.
xBas0=floor(Tlocalx); 
yBas0=floor(Tlocaly);
xBas1=xBas0+1;           
yBas1=yBas0+1;

% Linear interpolation constants (percentages)
xCom=Tlocalx-xBas0; 
yCom=Tlocaly-yBas0;
perc0=(1-xCom).*(1-yCom);
perc1= xCom.*(1-yCom);
perc2 = (1-xCom).*yCom;
perc3=xCom.*yCom;

% limit indexes to boundaries
xBas0(xBas0<0)=0;
xBas0(xBas0>(size(Iin,2)-1)) = size(Iin,2)-1;
yBas0(yBas0<0)=0;
yBas0(yBas0>(size(Iin,1)-1)) = size(Iin,1)-1;
xBas1(xBas1<0)=0;
xBas1(xBas1>(size(Iin,2)-1))=size(Iin,2)-1;
yBas1(yBas1<0)=0;
yBas1(yBas1>(size(Iin,1)-1))=size(Iin,1)-1;

Iout=zeros(size(Iin));

for i=1:size(Iin,3);    
    Iin_one=Iin(:,:,i);
    % Get the intensities
    intensity_xyz0=Iin_one(1+yBas0+xBas0*size(Iin,1));
    intensity_xyz1=Iin_one(1+yBas0+xBas1*size(Iin,1)); 
    intensity_xyz2=Iin_one(1+yBas1+xBas0*size(Iin,1));
    intensity_xyz3=Iin_one(1+yBas1+xBas1*size(Iin,1));
    Iout_one=intensity_xyz0.*perc0+intensity_xyz1.*perc1+intensity_xyz2.*perc2+intensity_xyz3.*perc3;
    Iout(:,:,i) = reshape(Iout_one, [size(Iin,1) size(Iin,2)]);
end
    