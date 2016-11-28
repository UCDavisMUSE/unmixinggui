% maps.m creates three colormaps, mapGreen, mapRed, map Blue;
clc;
map = colormap(gray(128));
mapRed = zeros(size(map));
mapGreen = zeros(size(map));
mapBlue = zeros(size(map));

mapRed(:,1) = map(:,1);
mapGreen(:,2) = map(:,2);
mapBlue(:,3) = map(:,3);