function coeffReshaped = FindCoeff(spectra, cube, index)
% function coeffreshaped = findCoeff(spectra, cube, index)
%
% Converts 'cube' to 'stackedCube' (see StackCube.m).
% Solves the equation stackedCube = spectra * coeff, for coeff variable.
%
% Dimensions are: 
% [N(3) x N(1)*N(2)] = [N(3) x numberOfComponents] * 
%                      [numberOfComponents x N(1)*N(2)].
% where: 
%   N = size(cube),
%   stackedCube - each column represents one pixel's intensity in time,
%   spectra - each column represents organ time spectrum,
%   coeff - column of coeff represents contributions of organs at the
%   corresponding pixel i.e. every column of coeff represents the unmixing
%   coefficients.
%
% input: 'spectra' - each column represents organ's pure time spectra,
%        'cube' - each row represents intensity of one pixel in time
%        'index' - chooses reconstruction method to be used:
%                1) pseudo-inverse,
%                2) normal equations (this is what Kirk is using),
%                3) non-negative least square method.
% 
% N. Bozinovic, 08/18/08
N = size(cube);
stackedCube = StackCube(cube);
numberOfComponents = size( spectra, 2);
coeff = zeros( numberOfComponents, N(1) * N(2));
switch index
    case 1
        coeff = pinv( spectra) * stackedCube;
    case 2
        % normal equations: (A' * A)^-1 * A' * y 
        coeff = inv( spectra' *spectra)* spectra' * stackedCube;
    case 3
        h = waitbar( 0, 'Please wait ...');
        for i = 1 : N(1) * N(2)
            waitbar(i / N(1) / N(2), h);
            coeff(:,i) = lsqnonneg( spectra, stackedCube(:,i));
        end
        close(h)
end

coeffReshaped = zeros( N(1), N(2), numberOfComponents);
for i = 1 : numberOfComponents
    coeffReshaped(:,:,i) = reshape( coeff(i,:), N(1), N(2));
end