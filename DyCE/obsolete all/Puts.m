function puts(X,r,k);
%function put(image,'title');
pos(k)
imagesc(X);
axis square;
colormap(gray);
title(r);
colorbar;
axis off;