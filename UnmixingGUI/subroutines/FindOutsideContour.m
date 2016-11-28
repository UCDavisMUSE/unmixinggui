function outsideContour = FindOutsideContour( mask);
% function outsideContour = FindOutsideContour( mask);
% Dilates 'mask' for 3 pixels pixels and finds contour as a difference of two
% dilated masks.
%
% N. Bozinovic 08/15/08
N = size(mask);
temp1 = DilateMask(mask,10);

% function FILL is not filling properly
% this section filles temp1 in case it has holes
% temp2 = ErodeMask( temp1, 3);    
% insideContour = temp1 - temp2 == 1;
% [X,Y] = ConvertContourToVector(insideContour);
% xx = 1:N(1);
% yy = 1:N(2);
% [XX,YY] = meshgrid(xx,yy);
% temp1 = inpolygon(XX',YY',X,Y);
% % ----------
% 
% PutImageAt(temp1,'',1);
% close

temp2 = DilateMask( temp1, 3);    
outsideContour = temp2 - temp1 > 0;