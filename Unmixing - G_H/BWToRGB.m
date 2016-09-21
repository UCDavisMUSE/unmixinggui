function RGBImage = BWToRGB( BWImage, weight)
% function RGBImage = BWToRGB( BWImage, weight)
%
% This file converts grayscale to RGB image with appropriate weights.
% Default: weight = [1 1 1].
%
% N.B. 08/15/08

if nargin < 2
    weight = [1 1 1];
end
N = size(BWImage);
RGBImage = zeros(N(1), N(2), 3);
ma = max(BWImage(:));
if ma ~=0
    for i = 1:3
        RGBImage(:,:,i) = BWImage * weight(i);
    end
    % if for some reason you want to scale maximum to 1;
    %     RGBImage = RGBImage.*(RGBImage>0)/max(RGBImage(:));
end