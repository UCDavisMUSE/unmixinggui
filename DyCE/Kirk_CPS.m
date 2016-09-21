function sPure = CalculatePureSpectra(sMixed, sAuto, fitOffset)

% this function outputs the optimal pure spectrum ('sPure') for given
% 'sMixed' and 'sAuto' (from autofluorescence)

% using optimal parameters

sPure = zeros(size(sMixed));

%err = Autoflerr(sMixed, sAuto, mag, off)


if(fitOffset)
    output = fminsearch(func, [1, -5]);
else
    output = fminsearch(func, [1]);
end

mag = output(1);
if length(output) > 1
    off = output(2);
else
    off = 0;
end
sPure = sMixed + off - mag * sAuto;