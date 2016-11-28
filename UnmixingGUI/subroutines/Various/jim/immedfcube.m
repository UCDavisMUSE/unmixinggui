function result = immedfcube(data, window)
% Median filters an image cube image-by-image
% Syntax: result = immedfcube(data, window);

if nargin < 2
  window = [4 4];
end

for i = 1:size(data,3)
  result(:,:,i) = medfilt2(data(:,:,i), [window]);
end
