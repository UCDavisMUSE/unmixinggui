function [ratio,snr] = getSNRAndRatio(firstComponent,image)

threshold = 0.4;
[snr, mask] = getSNR(image,threshold);
ratio = getRatio(firstComponent,image);

% put(firstComponent,'1st component',2)
% put(image,'heart',2)
