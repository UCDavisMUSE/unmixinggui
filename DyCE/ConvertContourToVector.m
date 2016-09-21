function [X,Y] = ConvertContourToVector( contour)
% function [X,Y] = ConvertContourToVector( contour)
%
% This is an auxilary function for the DSEARCH.
% 
% N. Bozinovic 08/15/08
N = size(contour);
k = 0;
for i = 1:N(1)
    for j = 1:N(2)
        if contour(i,j) == 1
            k = k + 1;
            X(k) = i;
            Y(k) = j;
        end
    end
end