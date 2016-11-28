function puts(X,r);
%function put(image,'title');
imagesc(X);
axis square;
colormap(gray);
title(r);
colorbar;
axis off;