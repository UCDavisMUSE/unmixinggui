function scaler = CalculateWeightMatrix(vector, cube)
N = size(cube);
den = vector' * vector;
for i = 1:N(1)
    for j = 1:N(2)
        scaler(i,j) = vector' * shiftdim(cube(i,j,:)) / den;
        % scaler(i,j) = CalculateCoefficients(vector, den, i, j, cube);
    end
end