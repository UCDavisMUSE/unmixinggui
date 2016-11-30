function bool = SpectrumDistinctiveEnough(pureSpectrum, mixedSpectrum, percentage)
% function bool = SpectraDistinctiveEnough(pureSpectrum, mixedSpectrum, percentage)
%
% Finds if 'pureSpectrum' is distincive enough from the 'mixedSpectrum'.
% The criterion is that 'pureSpectrum's peak-to-peak is bigger then 'percentage' percents 
% (default 10%) of 'mixedSpectrum's peak-to-peak.
% 
% N. Bozinovic, 08/27/08

if nargin < 3
    percentage = 0.3;
end

maxMixed = max(mixedSpectrum(:));
minMixed = min(mixedSpectrum(:));

maxPure = max(pureSpectrum(:));
minPure = min(pureSpectrum(:));

bool =  ( maxPure - minPure ) > percentage * ( maxMixed - minMixed );