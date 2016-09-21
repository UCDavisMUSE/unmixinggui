function mask = ConvertVectorToMask(X,Y,N)
% function mask = ConvertVectorToMask(X,Y)
%
% This is an auxilary function for FindInsideContour.
% 
% N. Bozinovic 08/15/08
mask = zeros(N);
for i = 1: length(X)
    mask(X(i),Y(i)) = 1;
end