function [pureSpectrum, parameters] = ComputePureSpectrumGlobaly(cube, insideContour, outsideContour, fitOffset)
% function [pureSpectrum, parameters] = ComputePureSpectrum1(cube,
% mixedSpectrum, autoSpectrum, fitOffset)s
%
% This function outputs the OPTIMAL pure spectrum ('pureSpectrum') for given
% 'mixedSpectrum' and 'autoSpectrum' (name originates from autofluorescence)
% The optimal parameters are found first ('magnitude' and 'offset'), then pureSpectrum.
% If 'fitOffset' is false, function assumes 'offset' = 0.
%
% N.Bozinovic 08/15/08

autoSpectrum =  MyMean3D(cube, outsideContour);
mixedSpectrum = MyMean3D(cube, insideContour);
% Pos(1)
% plot(autoSpectrum);
% hold on
% plot(mixedSpectrum,'g');
% close

%options = optimset('TolFun',0.001);
options = optimset('Display','iter','TolFun',0.00001);
if fitOffset == 1
    [parameters,fVal,exitflag,output] = fminsearch( @(parameters) Flatness(cube, insideContour, outsideContour, mixedSpectrum, autoSpectrum, parameters), [3, 0], options);
elseif fitOffset == 0
    [parameters,fVal,exitflag,output] = fminsearch( @(parameters) Flatness(cube, insideContour, outsideContour, mixedSpectrum, autoSpectrum, parameters), [3], options);
    parameters(2) = 0;
else
    parameters = [1 0];
end
magnitude = parameters(1);
if length(parameters) == 1
    offset = 0;
else
    offset = parameters(2);
end

pureSpectrum = mixedSpectrum + offset - magnitude * autoSpectrum;
% disp(['parameters: ' num2str(parameters)]);