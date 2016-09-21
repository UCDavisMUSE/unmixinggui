function ROI = findRectAroundPoint(image,x,y)
% function ROI = findRectAroundPoint(image,px,py)
% finds the ROI around the point (px,py) with the maximal area
dist = zeros(1,4);
N = size(image);
dist(1) = y;
dist(2) = N(1) - x;
dist(3) = N(2) - y;
dist(4) = x;
[m,I] = sort(dist);
dist
disp(['the closest side is ', num2str(I(1))]);

switch I(1) 
    case 1
        d = y;
    case 2
        d = N(1) - x;
    case 3
        d = N(2) - y;
    case 4
        d = x;
end
ROI = [x-d+1,y-d+1,2*d-1,2*d-1];
disp(['ROI is : ' num2str(ROI)])