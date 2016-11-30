function myCellNew = RemoveTrailingPositionsInCell(myCell)
i = length(myCell);
while i ~= 0 && (size(myCell{i},1) == 0)
    i = i  - 1;
end
if i == 0
    myCellNew = [];
else
    myCellNew = myCell(1:i);
end

