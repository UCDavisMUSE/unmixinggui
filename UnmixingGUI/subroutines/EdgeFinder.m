function BW = EdgeFinder(image)
% function BW = edgeFinder(image)
%
% N.Bozinovic, 08/29/08

BW = uint16(im2bw(image,0.005));

