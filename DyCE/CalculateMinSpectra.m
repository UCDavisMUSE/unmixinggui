function minSpec = CalculateMinSpectra(cube)
N  = size(cube);
for i = 1:N(3)
    minSpec(i) = min(min(cube(:,:,i)));
end
minSpec = minSpec';