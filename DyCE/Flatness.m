function costFunction = Flatness(cube, insideContour, outsideContour, mixedSpectrum, autoSpectrum, parameters)
% function costFunction = Flatness(cube, mixedSpectrum, autoSpectrum,
% parameters)
% This function outputs the value 'costFunction' depending on two
% parameters 'magnitude' and 'offset'.
% The costFunction is used to be minimized later, and optimal 'magnitude' and 'offset' are to be found.
%
% N. Bozinovic, 08/19/08

magnitude = parameters(1);
if length(parameters) == 1 
    offset = 0;
elseif length(parameters) == 2 
    offset = parameters(2);
else
    msgbox('number of parameters is neither 1 nor 2');
    return;
end

% N = size( cube);
% for i = 1 : N(3)
%     inside = mean(mean ( cube(:,:,i) . * mask(:,:,2) ))
% end
spectra = zeros(size(cube,3), 2);
spectra(:,1) = autoSpectrum;
spectra(:,2) = mixedSpectrum + offset - magnitude * autoSpectrum;

coeffReshaped = FindCoeff( spectra, cube, 1);

% Pos(3); PresentContour( BWToRGB(coeffReshaped(:,:,1)), outsideContour, insideContour);
costFunction = abs ( MyMean2D(coeffReshaped(:,:,1),insideContour) - MyMean2D(coeffReshaped(:,:,1),outsideContour) )^2;
% PutImageAt(coeffReshaped(:,:,1),'',1);
% close;

