function arrayNew = RemoveTrailingZeros(array)

i = length(array);
while (i ~= 0) && (array(i) == 0)
    i = i - 1;
end
if i == 0
    arrayNew = [];
else
    arrayNew = array(1:i);
end