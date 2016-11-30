function meanSpec = CalculateMeanSpectra(cube)
N  = size(cube);
for i = 1:N(3)
    meanSpec(i) = mean(mean(cube(:,:,i)));
end
meanSpec = meanSpec';