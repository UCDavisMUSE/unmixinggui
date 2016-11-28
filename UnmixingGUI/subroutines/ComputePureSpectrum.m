function [pureSpectrum, parameters] = ComputePureSpectrum(mixedSpectrum, autoSpectrum, fitOffset)
% function [pureSpectrum, parameters] = ComputePureSpectrum(mixedSpectrum,
% autoSpectrum, fitOffset)
%
% This function outputs the OPTIMAL pure spectrum ('pureSpectrum') for given
% 'mixedSpectrum' and 'autoSpectrum' (name originates from autofluorescence)
% The optimal parameters are found first ('magnitude' and 'offset'), then pureSpectrum.
% If 'fitOffset' is false, function assumes 'offset' = 0.
%
% N.Bozinovic 08/15/08
% Credits K.Gossage

if fitOffset == 1
    parameters = fminsearch( @(parameters) SpectraDifferenceError(mixedSpectrum, autoSpectrum, parameters), [1, 0]);
elseif fitOffset == 0
    parameters = fminsearch( @(parameters) SpectraDifferenceError(mixedSpectrum, autoSpectrum, parameters), [1]);
    parameters(2) = 0;
else
    parameters = [1 0];
end

magnitude = parameters(1);
offset = parameters(2);
pureSpectrum = mixedSpectrum + offset - magnitude * autoSpectrum;