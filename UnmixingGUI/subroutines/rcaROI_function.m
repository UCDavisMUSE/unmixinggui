%% main program begins
function organList = PCA_function(cube,componentsNumber,title)
cube = double(cube);
cube = cube - min(min(min(cube)));
path(path,'D:\Dyce main');
% profile on
N = size(cube);
if nargin < 2 
    maxComponents = 5;
else 
    maxComponents = componentsNumber;
end 
belowError = false;
errorLimit = 0.01;

vector = zeros(N(3),1);  % this variable contains spectra that will be written in the endmember matrix as a column
scaler = zeros(N(1),N(2)); % this is an image
baseImage = zeros(N(1),N(2));
endMembers = zeros(N(3), maxComponents);  % containes spectra of those maxComponents RCA components
organList = zeros(N(1),N(2), maxComponents); % containes images of the RCA components

vector = CalculateMeanSpectra(cube);
baseImage = mean(cube,3);
rawMax = max(max(baseImage));
maxError = rawMax * errorLimit;
totalContribution = sum(sum(baseImage));
h = waitbar(0,'Calculating RCA components ...');
cube1 = cube;
index = 1;
while(~belowError && index <= maxComponents)
    waitbar(index/maxComponents,h);
    % Add the current vector to the set of selected End-members
    endMembers(:,index) = vector;
    %Calculate the best fit scale factors accross the cube. This is a single spectrum unmixing
    scaler = CalculateWeightMatrix(vector, cube1);
    % Store current image before subtracting off scaled vector
    oldImage = mean(cube1,3);
    % Subtract off scaled vector component from current data set
    cube1 = SubtractSpectra(vector, scaler, cube1);
    % Store new image with vector subtracted off
    image = mean(cube1,3);
    % Check to see if new image is now less than error threshold
    currentMax = max(max(image));
    if (maxError > currentMax) 
        bellowError = true;
    else
        bellowError = false;
    end
    % Subtract new image from oldImage to see what was associated with current vector
    % Just using oldImage for storage so I don't have to create another array in memory
    oldImage = oldImage - image;
    % Find contribution in difference image
    percent = round(100*currentMax/rawMax);
    name = [num2str(index) ' - ' num2str(percent) ' percents'];
    organList(:,:,index) = oldImage;
    % I want to determine the new End-member based on what is stored in image
    vector = FindNextVector(cube1,image);
    index = index + 1;
end
close(h)
forPresentation(organList,title);
% profile off
% profile viewer

            
            

			
          