function stackedCube = StackCube(cube)
% function stackedCube = StackCube(cube)
%
% Converts 'cube' by stacking images as columns 
% so each row represents intensity of one pixel in time.
% Obtained 'stackedCube' is then transposed for later calculations (see
% FindCoeff.m description).
% This function is used in function 'FindCoeff.m'.
%
% N. Bozinovic, 8/19/08

N = size(cube);
stackedCube = zeros( N(1) * N(2), N(3));
for i = 1 : N(3) 
    temp = cube(:,:,i); 
    stackedCube(:,i) = temp(:); 
end
stackedCube = stackedCube';