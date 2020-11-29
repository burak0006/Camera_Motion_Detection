function [eHTheta] = angle(px, py, mpx, mpy)


M1 = (px.^2 + py.^2).^0.5;
M2 = (mpx.^2 + mpy.^2).^0.5;
M = M1 .* M2;
eM = px.*mpx+py.*mpy;
eHTheta = (abs(acos(eM(:)./M(:)))/(2*pi))*360;

end