function [stdMatrix,meanMatrix] = FindFocusArea(myImage)

N = size(myImage);
M = [4,4];
stdMatrix = zeros(N-M);
meanMatrix = zeros(N-M);

h = waitbar(0,'Please wait ...');
    
for i=1:N(1)-M(1)
    waitbar(i/(N(1)-M(1)),h)
    for j=1:N(2)-M(2)
        temp = double(myImage(i:i+M(1)-1,j:j+M(2)-1));
        stdMatrix(i,j) = std(temp(:));
        meanMatrix(i,j) = mean(temp(:));
    end
end
close(h)

