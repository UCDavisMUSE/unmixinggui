function bool = InBounds(N,array)
% function bool = InBounds(N,array)
%
% Check if array members are inside the box
%
% N. Bozinovic 08/15/08

if size(N) ~= size(array)
    msgbox('N and ''array'' do not have same size');
    bool = -1;
    return;
end
bool = 1;
for i = 1 : length(array)
    if (array(i) < 1) || ( array(i) > N(i))
        bool = 0;
        return;
    end
end 