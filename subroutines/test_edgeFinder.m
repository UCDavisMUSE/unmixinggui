% edge finder;
function edgeFinder

Nstart = 10; % default
rect = [16 207 493 461]; %load CRI_margins;
N(1) = rect(3)-rect(1)+1 ; % imagesize in one dimension
N(2) = rect(4)-rect(2)+1;
N(3) = 60; %default
handles.rect = [1 1 N(2) N(1)];

%% path
dir1 = 'C:\Hillman_062607\DYCE Day 0\';
mouse = 'Mouse 12 ventral  rotated';

temp = uint16(imread([dir1 mouse '\' mouse '_' num2str(Nstart + 64 -1,'%03g') '.tif']));
temp = temp(rect(1):rect(3),rect(2):rect(4));

%puti(temp,'',2)
map = colormap(gray);
BW = im2bw(temp,0.005);
%level = graythresh(temp)
%BW = im2bw(temp,level);
figure; imshow(BW);

