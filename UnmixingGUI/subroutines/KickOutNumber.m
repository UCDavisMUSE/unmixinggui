function newArray = KickOutNumber(array,number)
% function newArray = KickOutNumber(array,number)
% Kicks out number from array, for example, 
% KickOutNumber(1:4,3) gives [1 2 4].
% This function is used when 'maskOfAllOtherOrgans' in unmixing.m program
% wants to be found.
%
% N.Bozinovic, 08/27/08

newArray = zeros(1,length(array) - 1);
index = find(array == number);
j = 0;
for i = 1:length(array)
    if i ~= index
        j = j + 1;
        newArray(j) = array(i);
    end
end