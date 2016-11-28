function [newX,newY] = MovePixelFurtherAway( point1, point2, N)
% function [newX,newY] = MovePixelFurtherAway( point2, point1, N)
%
% This function find the pixel next to the (x2,y2) pixel that is further
% away from (x1,y1) pixel. This function is used to find the outside
% contour in the unmixing function.
%
% N. Bozinovic 08/15/08
x2 = point2(1);
y2 = point2(2);
x1 = point1(1);
y1 = point1(2);

d = sqrt( ( x1 - x2 )^2 + (y1 - y2)^2 );
for i = -1 : 1
    for j = -1 : 1
        newD = sqrt( ( x1 - (x2 + i) )^2 + (y1 - (y2 + j))^2 );
        if newD > d
            newX = x2 + i;
            newY = y2 + j;
            d = newD;
        end
    end
end

if ~InBounds (N, [newX,newY])
    msgbox('there is no further');
    newX = x2;
    newY = y2;
end
point3 = [newX,newY];