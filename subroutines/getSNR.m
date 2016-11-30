function [snr, mask] = getSNR(image, threshold)

mask = image > threshold*(max(image(:)) - min(image(:))) + min(image(:));
temp1 = image .* mask;
temp2 = image .* (1-mask);
% PutImageAt(temp1,'temp1',1);
% PutImageAt(temp2,'temp2',2);
if mean(temp2(:)) < eps
    snr = 0;
else
    snr = mean(temp1(:)) / mean(temp2(:));
end