function [M,mx,my] = findMaxInMatrix(a) 
[junk,mx] = max(max(a,[],2));
[junk,my] = max(max(a,[],1));
M = a(mx,my);
