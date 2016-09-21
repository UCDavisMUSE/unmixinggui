function G = ResizeMovie( M, zoomFactor)
% function G = resizeMovie( M, zoomFactor)
%
% Resizes movie M for a factor of 'zoomFactor' (default is to make it
% looks big enough).
% M is a struct M.cdata.
%
% N. Bozinovic, 08/18/08

if nargin == 1
    zoomFactor = floor(500/size(M(1).cdata,2));
end

G = M;
a = ones(zoomFactor);
for i = 1:size(M,2)
    G(i).cdata = flipud(uint8(kron(double(M(i).cdata),double(a))));
end