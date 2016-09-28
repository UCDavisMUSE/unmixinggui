clc;
close all;
x = [1:100, 1:100];
map = [0 0 0; 0.25 0.25 0.25;0.5 0.5 0.5;1 1 1 ];% 0 0 1];

blob(:,:,1) = 1000*fspecial('Gaussian',[100,100],5);
tblob(:,:,1) = double(im2bw(blob(:,:,1),0.2));

blob(:,:,2) = wshift('2d',blob(:,:,1),[5 5]);
tblob(:,:,2) = double(im2bw(blob(:,:,2),0.2));

blob(:,:,3) = wshift('2d',blob(:,:,1),[-5 5]);
tblob(:,:,3) = double(im2bw(blob(:,:,3),0.2));

blob(:,:,4) = wshift('2d',blob(:,:,1),[-25 25]);
tblob(:,:,4) = double(im2bw(blob(:,:,4),0.2));

blob(:,:,5) = wshift('2d',blob(:,:,1),[-25 -25]);
tblob(:,:,5) = double(im2bw(blob(:,:,5),0.2));

%maps;
imagesc(sum(tblob,3));
colormap(map);
axis image off
