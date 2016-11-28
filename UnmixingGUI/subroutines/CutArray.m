function newArray = cutArray(array, a, b)
% function newArray = cutArray(array, start, end)

N = length(array);
newArray = [];
j = 0;
for i = 1:N
    if (a <= array(i)) && (b >= array(i))
        j = j+1;
        newArray(j) = array(i);
    end
end