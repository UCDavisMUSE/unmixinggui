clc;
x = [1:100, 1:100];
blob1 = 20000*fspecial('Gaussian',[100,100],5);
blob2 = wshift('2d',blob1,[5 5]);
blob2temp = im2bw(blob2,0.4);
blob2 = (blob2 + 128).*blob2temp;

maps;
%map = mapRed;
map = [mapRed ; mapGreen];
imagesc(blob1 + blob2,[0,256]);
colormap(map);
colorbar
