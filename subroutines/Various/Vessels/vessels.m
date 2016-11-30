% to get veasels
close all
clc;
path(path,'D:\Dyce main\');
pathname = 'C:\Hillman_062607\DYCE Day 0\Mouse 12 ventral  rotated\veasels\'
%[filename,pathname] = uigetfile({'*.tif'},'',dir1);
filename= 'raw_023.tif';
a1 = double(imread([pathname filename]));
filename= 'raw_031.tif';
a2 = double(imread([pathname filename]));
puti(a1,'1',1)
puti(a2,'2',2)
 g = ginput;
 g = round(g);
%g = getrect;

a1t = a1./a1(g(2),g(1));
a2t = a2./a2(g(2),g(1));
% puti(a1t,'',1);
% puti(a2t,'',2);
a(:,:,1) = a1t;
a(:,:,2) = a2t;
% organList = rca_function(a,4,''); 
%puti(a1t - a2t,'difference',3);


%%

% h = fspecial('Gaussian',10,2);
% put(h,'',1)
% h = h./max(h(:));
% put(h,'',2)
% h = 1-h;
% put(h,'',3)
% B = imfilter(a(:,:,2),h);
% put(B,'',1);

