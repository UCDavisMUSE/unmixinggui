function Shim(X, n, N, myTitle)
Pos(n, N)
scaleMaxIntensity = 1;
if scaleMaxIntensity
    imagesc(X,[0, max(X(:))]);
else
    imagesc(X);
end
axis image off;
colormap(gray);
title(myTitle)
colorbar