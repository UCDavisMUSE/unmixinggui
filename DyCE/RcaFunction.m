function organList = RcaFunction(cube, numberOfComponents, chooseIndicator, chooseDefault)
% function organList = RcaFunction(cube, numberOfComponents, chooseIndicator)
%
% This is the main function for finding RCA components.
% Input is a 'cube' and a 'numberOfComponents' we wish to find. If
% 'chooseIndicator' is true, the function will ask user to choose organs 
% and only choosen organs will be returned as output 'choosenOrganList'. 
% In the case when user leaves choosen organs blank or writes 'all', 
% all of the organs will be returned in choosenOrganList.
% 
% N. Bozinovic, 08/22/08
% Credits K. Gossage

if nargin < 4
    chooseDefault = '1 2';
end
        
cube = double(cube);
cube = cube - min(cube(:));

N = size(cube);
if nargin < 2 
    maxComponents = 5;
else 
    maxComponents = numberOfComponents;
end 
belowError = false;
errorLimit = 0.01;

vector = zeros(N(3), 1);  % this variable contains spectra that will be written in the endmember matrix as a column
scaler = zeros(N(1), N(2)); % this is an image
baseImage = zeros(N(1), N(2));
endMembers = zeros(N(3), maxComponents);  % containes spectra of those maxComponents RCA components
organList = zeros(N(1), N(2), maxComponents); % containes images of the RCA components

cube1 = cube;

h = waitbar(0, 'Calculating RCA components ...');
vector = CalculateMeanSpectra( cube1);
index = 1;
while(index <= maxComponents)
    waitbar(index / maxComponents,h);
    
    % Add the current vector to the set of selected end-members
    endMembers(:,index) = vector;
    % Calculate the best fit scale factors accross the cube. This is a
    % single spectrum unmixing!
    scaler = FindCoeff( vector, cube1, 1);
    
    % mean before scaling
    oldImage = mean(cube1,3);
    cube1 = SubtractSpectra( vector, scaler, cube1);
    % mean after scaling
    newImage = mean(cube1,3);
    
    organList(:,:,index) = oldImage - newImage;
    
    vector = FindNextVector( cube1, newImage);
    
    index = index + 1;
%     Pos(1)
%     subplot(2,2,1)
%     PutImage(scaler,'scaler','colorbar','on');
%     subplot(2,2,2)
%     PutImage(oldImage,'oldImage','colorbar','on');
%     subplot(2,2,4)
%     PutImage(newImage,'newImage','colorbar','on');
%  %   close;
end
close(h)
