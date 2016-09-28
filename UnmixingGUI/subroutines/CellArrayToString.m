function s = cellArrayToString(c)
N = size(c,1);
maxLength = 0;
for i = 1:N
    tempLength = size(c(i),2);
    if tempLength > maxLength
        maxLength = tempLength;
    end
end
s = [];
for i = 1:N
    tempString = SetStringToCertainWidth(c(i),maxLength);
    s = [s ; tempString];
end