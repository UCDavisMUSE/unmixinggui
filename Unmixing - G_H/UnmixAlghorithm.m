function componentsReshaped = UnmixAlghorithm(spectra, cube, method)
% function componentsreshaped = findcomponents(spectra, cube, method)
%
% 1) Converts 'cube' to 'stackedCube' (see StackCube.m).
% 2) Solves the equation stackedCube = spectra * components, for components variable.
%
% Dimensions are: 
% [N(3) x N(1)*N(2)] = [N(3) x numberOfComponents] * 
%                      [numberOfComponents x N(1)*N(2)].
% where: 
%   N = size(cube),
%   stackedCube - each column represents one pixel's intensity in time,
%   spectra - each column represents organ time spectrum,
%   components - column of components represents contributions of organs at the
%   corresponding pixel i.e. every column of components represents the unmixing
%   componentsicients.
%
% input: 'spectra' - each column represents organ's pure time spectra,
%        'cube' - each row represents intensity of one pixel in time
%        'method' - chooses reconstruction delimiter to be used:
%                1) pseudo-inverse,
%                2) normal equations (this is what Kirk is using),
%                3) non-negative least square delimiter.
% 
% N. Bozinovic, 08/18/08
N = size(cube);
stackedCube = StackCube(cube);
numberOfComponents = size( spectra, 2);
components = zeros( numberOfComponents, N(1) * N(2));
switch method
    case 1
        components = pinv( spectra) * stackedCube;
    case 2
        % normal equations: (A' * A)^-1 * A' * y 
        % components = inv( spectra' *spectra)* spectra' * stackedCube;
        components = ( (spectra' *spectra) \ spectra' ) * stackedCube;
    case 3
        h = waitbar( 0, 'Please wait ...');
        for i = 1 : N(1) * N(2)
            waitbar(i / N(1) / N(2), h);
            components(:,i) = lsqnonneg( spectra, sparse(stackedCube(:,i)));
        end
        close(h)
end

componentsReshaped = zeros( N(1), N(2), numberOfComponents);
for i = 1 : numberOfComponents
    componentsReshaped(:,:,i) = reshape( components(i,:), N(1), N(2));
end