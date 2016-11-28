clc;
dir1 = cd; 
x = double(imread([ dir1 '\Mouse9\Mouse9_141.tif']));
%%
imagesc(x);
colormap(gray)
%%
BW = EDGE(x,'sobel');
imagesc(BW);
colormap(gray)
