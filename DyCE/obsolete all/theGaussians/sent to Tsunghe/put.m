function put(X,r,k)
%put(image,title,position), creates image with certain title and position 
pos(k);
imagesc(X);
%axis square;
colormap(gray);
title(r);
colorbar;
axis off;