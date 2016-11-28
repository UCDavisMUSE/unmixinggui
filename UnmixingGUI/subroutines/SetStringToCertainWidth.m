function newString = setStringToCertainWidth(oldString,N)
% function newString = setStringToCertainWidth(oldString,N)
newString = [oldString blanks(size(oldString,2) - N)];