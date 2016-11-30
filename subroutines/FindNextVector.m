function newVect = FindNextVector(cube, image)

topSpectra = FindMaxPixels(image,25);

% Calculate average spectrum from topSpectra list
newVect = shiftdim(mean(mean(cube(topSpectra.location1,topSpectra.location2,:))));