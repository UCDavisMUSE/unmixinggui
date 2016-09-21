function maskOutput = ErodeMask(maskInput,delta)
% function maskOutput = ErodeMask(maskInput,delta)
%
% This function SHRINKS (i.e. erodes) the 'maskInput' for (more or less) 'delta' pixels.
% Its primarely used to calculate inner region for the organ. Default:
% delta = 1. 'maskInput' should be mask od zeros and ones
% 
% N.Bozinovic 08/15/08

if nargin < 2
    delta = 1;
end
if sum(maskInput(:)) < 0 
    error('mask is negative');
    return;
end

maskOutput = 1 - maskInput;
if sum(maskOutput(:)) < 0 
    error('mask has values larger then one');
    return;
end

maskOutput = conv2(double(maskOutput), ones(delta), 'same');
maskOutput = maskOutput > eps;
maskOutput = 1 - maskOutput;