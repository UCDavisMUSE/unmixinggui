function maxSpec = CalculateMaxSpectra(cube)
N  = size(cube);
for i = 1:N(3)
    maxSpec(i) = max(max(cube(:,:,i)));
end
maxSpec = maxSpec';