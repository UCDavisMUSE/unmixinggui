function num = CalculateCoefficients(vector, den, i, j, cube)

N = size(cube);

% for k = 1:N(3)
%     num = num + vector(k)*cube(i,j,k);
% end
num = vector'*shiftdim(cube(i,j,:));

num = num/den;