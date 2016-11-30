clc;

%B1 = B(100:500,300:700);
N = size(B);
M = [4,4];
C = zeros(N-M);

h = waitbar(0,'Please wait...');
    
for i=1:N(1)-M(1)
    waitbar(i/(N(1)-M(1)),h)
    for j=1:N(2)-M(2)
        temp = double(B(i:i+M(1)-1,j:j+M(2)-1));
        C(i,j) = std(temp(:));
    end
end
close(h)