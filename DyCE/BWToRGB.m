function RGBImage = BWToRGB( BWImage, weight)
% function RGBImage = BWToRGB( BWImage, weight)
%
% Converts grayscale to RGB image with appropriate weights.
% Default: weight = [1 1 1].
% Zeros will be truncated and maximum of the image scaled to 1;
%
% N.Bozinovic 08/15/08
% Credits Tsung-Han Chan (Virginia Tech)

if nargin < 2
    weight = [1 1 1];
end
N = size(BWImage);
RGBImage = zeros(N(1),N(2),3);
ma = max(BWImage(:));
if ma ~=0
    for i = 1:3
        RGBImage(:,:,i) = BWImage * weight(i);
    end
    RGBImage = RGBImage.*(RGBImage>0)/max(RGBImage(:));
end