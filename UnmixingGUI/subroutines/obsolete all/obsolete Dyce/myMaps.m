clc;
map = colormap(gray(256));
mapRed = zeros(size(map));
mapGreen = zeros(size(map));
mapBlue = zeros(size(map));

mapRed(:,1) = map(:,1);
mapGreen(:,2) = map(:,2);
mapBlue(:,3) = map(:,3);