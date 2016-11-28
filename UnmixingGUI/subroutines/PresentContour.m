function PresentContour(compositeImage, outsideContour, insideContour)
%
% function PresentContour(compositeImage, outsideContour, insideContour)
%
% Draws components' inside and outside contours on the composite image.
%
% N. Bozinovic 08/18/08

PutImage( 0.8 * compositeImage + 0.1 * BWToRGB(outsideContour) + ...
                                 0.1 * BWToRGB(insideContour),'contours');