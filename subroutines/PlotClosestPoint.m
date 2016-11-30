function PlotClosestPoint( XI, YI, mask)
% function PlotClosestPoint( XI, YI, mask)
%
% For the point (XI,YI), finds the closest point in the 'mask'.
% Plots crosses on two points
%
% N. Bozinovic 08/15/08

%Puti(mask,'mask',1);

PutCross(XI,YI,gcf,[1 0 0]);
[X,Y] = ConvertContourToVector(mask);
TRI = delaunay(X,Y);
K = dsearch(X,Y,TRI,XI,YI);
PutCross(X(K),Y(K),gcf,[0 1 0]);