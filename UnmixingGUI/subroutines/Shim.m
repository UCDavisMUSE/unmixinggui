function Shim(X,n, myTitle)
if nargin < 3
    myTitle = '';
end
if nargin < 2 
    n = 1;
end
Pos(n)
imagesc(X);
axis image off;
colormap(gray);
title(myTitle)
colorbar