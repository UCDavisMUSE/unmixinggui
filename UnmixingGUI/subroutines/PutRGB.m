function PutRGB(X,myTitle,windowPosition,axisScale)
%function PutRGB(X,myTitle,windowPosition,axisScale)

Pos(windowPosition);
if nargin == 4
    imagesc(X,[axisScale]);
else
    imagesc(X);
end
axis off image;
colormap(gray);
title(myTitle);
%colorbar;