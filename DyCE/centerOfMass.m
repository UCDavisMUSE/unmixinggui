function [xc,yc] = centerOfMass(image)
% function [xc,yc] = centerOfMass(image)
% input: image
% output: center of mass coordinates (matrix notation)
N = size(image);
[X,Y] = meshgrid(1:N(1),1:N(2));
X = X';
Y = Y';
M = image(:);
xc = round(M'*X(:)/sum(M));
yc = round(M'*Y(:)/sum(M));