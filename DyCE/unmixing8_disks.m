% umixing.m
% This function umixes given components obtained by RCA
% input: organList (stacked images of components)
%        cube (stacked raw images)
% -----------------------
%% first initialization
%% 0. basic input
clc;
close all;
N = [100 100 100]; % imagesize in one dimension
trueSpectra = zeros(N(3),1); 
bgMax = 10;
SBR = 1; 
% SpanGauss(N, [X, Y, spatialSigma], [temporalMean, temporalSigma, maxIntenisty]);
[cube1, trueSpectra(:,1)] = SpanGauss(N,3*[15,15,10],[0.5,0.5,bgMax]);
[cube2, trueSpectra(:,2)] = SpanGauss(N,3*[17,17,2],[0.4,0.05,SBR*bgMax]);
%[cube3, trueSpectra(:,3)] = SpanGauss(N,3*[17,17,4],[0.6,0.08,20]);
%cube = double( 0.33*( double( cube1) + double( cube2) + double( cube3)));
cube = double( 0.5*( double( cube1) + double( cube2)));
cube = AddNoise( cube, 0.3 * bgMax);
cube = cube .* ( cube >= 0);

x = cube; % duplicate of the cube, in case we want to change something so we don't mess up the original cube
N = size(x);
organList = rca_function(x, 5, 1, '1 2');
close;
M = size(organList); % organList's first component is a background, the rest are organs.
%ForPresentation(organList, 'RCA components');
mask = zeros(M); % stores the masks of the background and organs
finalSpectra = zeros(N(3),M(3)); % will store the pure background and organs' spectra
fitOffset = 0; % ('-1' for [mag,offset] = [1 0]), 
               % ('0' for [mag,offset] = [variable 0]),
               % ('1' for [mag,offset] = [variable variable]).
        
excludeOverlapRegions = 0; 
truncateSpectraZeros = 1;
showSpectraIndicator = 1;
existTrue = 1;
smoothDelta = 1;%round(N(3)/10);

% finds the true reconstruction
if existTrue    
    compositeImage = Composite(FindCoeff(trueSpectra, x, 1),'True spectra',0.2, [1 3]);
else
    compositeImage = BWToRGB(mean(x,3));
end

% ------------------------
%% segment organs, obtains variable 'mask'
% 1. Components are segmented and variable 'mask' is obtained (so far
% program only thresholds them; can be improved).
% 2. Finds convex hulls of masks.
% 3. Overall background mask and background spectrum are determined.
% 4. Overlaps masks and true reconstructions.
% 5. Main part: Calculates the finalSpectra. 
%
%   Idea: For every organ mask, two contoures are computed, one inside and one outside the mask. The outside contour goes 
%   just enough to obtain spectra that is distincive enough.

%   Implementation: 
%   5.1. Finds the inside and initial outside contours. 
%   5.2. For all the points on the outside contour computes the pure spectrum of the organ 
%    using the closest point at the inside contour.
%   5.3. If the spectrum is distinctive enough program FIXES that point. If not, moves 
%    the contour one pixel further away.
%   5.4. Finds the new contour. TO BE DONE
%   5.5. Repeats until the new outside contour is not expanding anymore.
%
% 6. Presents the solution 

% ------------------------------------------------------------------------
%% 1. Components are segmented and variable 'mask' is obtained (so far program only thresholds them; can be improved)
for i = 1:M(3)
    image = organList(:,:,i);
    % different mask for background (i=1) and the rest of the organs
    if i == 1
        mask(:,:,i) = image > 0.10 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    else
        mask(:,:,i) = image > 0.7 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    end
end

% %% 2. Finds convex hulls of masks for the organs - NOT A GOOD IDEA
% for i = 2:M(3)
%     mask(:,:,i) = FindConvexRegion(mask(:,:,i));
% end

% 2.1 Overall background mask and spectrum are determined
% Background mask is found by excluding organs masks that are first
% dilated (see FindBackgroundMask.m function for details)

mask(:,:,1) = FindBackgroundMask(mask);
finalSpectra(:,1) = MyMean3D( x, mask(:,:,1) );
finalSpectra(:,1) = (smooth(finalSpectra(:,1), smoothDelta,'lowess'))';
%Pos(3);  plot(finalSpectra(:,1));  title('Background');
%PresentComponents(mask, 2, [1,M(3)]);

%% 3.1 Excludes overlap regions

duplicate = mask;
% mask(:,:,2) = duplicate(:,:,2) - duplicate(:,:,3) > 0;
% mask(:,:,3) = duplicate(:,:,3) - duplicate(:,:,2) > 0;

%% 4. Overlaps masks and true reconstructions (if true reconstruction doesn't exist 'compositeImage' is mean of the cube)
overlaped = zeros(N(1),N(2),3,M(3));
for i = 1 : M(3)
    overlaped(:,:,:,i) = 0.9 * compositeImage + 0.1 * BWToRGB( mask(:,:,i));
end
%PresentComponentsRGB(overlaped, 3, [1,M(3)]);
% -------------------------------------------------------------------------

%% 5. Main part: Calculates the finalSpectra 

for i = 2:M(3)
    % 5.1. 
    % finds the two contours for organ 'i'
    insideContour = FindInsideContour( mask(:,:,i));
    outsideContour = FindOutsideContour(mask(:,:,i));
    if excludeOverlapRegions 
        maskOfAllOtherOrgans = sum( mask(:,:,KickOutNumber(2:M(3),i)),3) >0;
        outsideContour = outsideContour - maskOfAllOtherOrgans > 0;
    end    
    Pos(4);
    PresentContour(compositeImage, outsideContour, insideContour);
    title(['organ ' num2str(i)]);
    outsideSpectrum =  MyMean3D(cube, outsideContour);
    insideSpectrum = MyMean3D(cube, insideContour);
    % finds the pure spectrum
    [spectrum, parameters] = ComputePureSpectrumGlobaly(cube, insideContour, outsideContour, fitOffset);
    if showSpectraIndicator
        Pos(2)
        plot( insideSpectrum,'g');
        hold on
        plot( outsideSpectrum,'r');
        hold on
        plot( insideSpectrum - outsideSpectrum,'b');
        hold on
        plot( spectrum,'c');
        legend('inside','outside','insideSpectrum - outsideSpectrum', 'pure');
        title(['magnitude = ' num2str(parameters(1)), ', offset = ' num2str(parameters(2))]);
    end
    finalSpectra(:,i) = spectrum;
end

%% 6. Presents the solution 

if truncateSpectraZeros 
    finalSpectra = finalSpectra .* (finalSpectra>0);
    MyTitle = 'reconstuction, truncated zeros';
else
    MyTitle = 'reconstuction';
end
Pos(3); plot(NormalizeSpectra(finalSpectra)); title('Reconstructed spectra');
Composite(FindCoeff( finalSpectra, x, 1), MyTitle, 0.2, [1 3]);
