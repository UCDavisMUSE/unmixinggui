function  [cube, name] = LoadCubeFromStruct(pathname, tiffStruct, rect)
% function  [cube, name] = LoadCubeFromStruct(pathname, tiffStruct, rect)
% loads the tiffs into the 'cube' from 'tiffStruct'
%
% N.Bozinovic, 08/27/08
N(1) = rect(3) - rect(1) + 1; % imagesize in one dimension
N(2) = rect(4) - rect(2) + 1;
N(3) = length(tiffStruct);
cube = zeros(N); 
for i = 1 : N(3)
    temp = double(imread([pathname tiffStruct(i).name]));
    cube(:,:,i) = temp(rect(1):rect(3),rect(2):rect(4));
end
name = tiffStruct(1).name(1:size(tiffStruct(1).name,2)-8);