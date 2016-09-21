function sm = medfcube(data)
% MEDFILT Runs a 3 point mean filter along the spectral dimension
% of an image cube
% Syntax: sm = medfcube(data);

[x, y, z] = size(data);
sm = zeros(size(data));

sm(:,:,1) = (data(:,:,1) + data(:,:,2)) / 2;
sm(:,:,2:end-1) = (data(:,:,1:end-2) + data(:,:,2:end-1) + data(:,:,3:end)) / 3;
sm(:,:,end) = (data(:,:,end-1) + data(:,:,end))/ 2;
   