function newCube = Scale(cube, cubeNewMin, cubeNewMax, cubeMin, cubeMax)
% function newCube = scale(cube, cubeNewMin, cubeNewMax, cubeMin, cubeMax)
%
% Scales images of 'cube' from [cubeMin,cubeMax] to [cubeNewMin,cubeNewMax]
% If cubeMin and cubeMax are ommited they are calculated for each frame
% separately.
%
% N.Bozinovic 08/19/08

N = size(cube);
newCube = zeros(N);
if size(N,2) == 2 
    N(3) = 1;
end

%h = waitbar(0,'Rescaling ...');
for i = 1 : N(3)
%    waitbar( i / N(3), h);
    if nargin < 4
        cubeMin = min( min( cube(:,:,i)));
        cubeMax = max( max( cube(:,:,i)));
    end
    if cubeMin == cubeMax
        newCube(:,:,i) = ones( N(1), N(2) ) * cubeMin;
    else
        newCube(:,:,i) = cubeNewMin + (cubeNewMax - cubeNewMin) * (cube(:,:,i) - cubeMin) / (cubeMax - cubeMin);
    end
end
%close(h)