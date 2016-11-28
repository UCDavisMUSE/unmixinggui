function spectraOutput = NormalizeSpectra(spectraInput)
% function spectraOutput = NormalizeSpectra(spectraInput)
% 
% Normalizes spectra (stacked in columns of 'spectraInput'), spectrum
% by spectrum.
%
% N.Bozinovic 8/15/08

for i = 1:size(spectraInput,2)
    temp = spectraInput(:,i);
    ma = max(temp(:));
    if ma ~= 0 
        temp = temp / ma;
    else
        temp = zeros(size(spectraInput(:,i)));
    end
    spectraOutput(:,i) = temp;
end