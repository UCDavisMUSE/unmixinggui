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
% SpanGauss(N, [X, Y, spatialSigma], [temporalMean, temporalSigma, maxIntenisty]);
[cube1, trueSpectra(:,1)] = SpanGauss(N,3*[15,15,10],[0.5,0.5,50]);
[cube2, trueSpectra(:,2)] = SpanGauss(N,3*[15,15,2],[0.4,0.05,10]);
%[cube3, trueSpectra(:,3)] = SpanGauss(N,3*[17,17,4],[0.6,0.08,20]);
%cube = double( 0.33*( double( cube1) + double( cube2) + double( cube3)));
cube = double( 0.5*( double( cube1) + double( cube2)));
cube = AddNoise( cube, 0.5);
cube = cube .* ( cube >= 0);

x = cube; % duplicate of the cube, in case we want to change something so we don't mess up the original cube
N = size(x);
organList = rca_function(x, 5, 1, '1 2 3');
M = size(organList); % organList's first component is a background, the rest are organs.
ForPresentation(organList, 'RCA components');
mask = zeros(M); % stores the masks of the background and organs
finalSpectra = zeros(N(3),M(3)); % will store the pure background and organs' spectra
fitOffset = 1; % ('-1' for [mag,offset] = [1 0]), 
               % ('0' for [mag,offset] = [variable 0]),
               % ('1' for [mag,offset] = [variable variable]).
        
excludeOverlapRegions = 1; 
truncateSpectraZeros = 1;
showSpectraIndicator = 0;
existTrue = 1;
smoothDelta = round(N(3)/10);

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
        mask(:,:,i) = image > 0.25 * ( max(image(:)) - min(image(:)) ) + min(image(:));
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
PresentComponents(mask, 2, [1,M(3)]);

%% 3.1 Excludes overlap regions

duplicate = mask;
% mask(:,:,2) = duplicate(:,:,2) - duplicate(:,:,3) > 0;
% mask(:,:,3) = duplicate(:,:,3) - duplicate(:,:,2) > 0;

%% 4. Overlaps masks and true reconstructions (if true reconstruction doesn't exist 'compositeImage' is mean of the cube)
overlaped = zeros(N(1),N(2),3,M(3));
for i = 1 : M(3)
    overlaped(:,:,:,i) = 0.9 * compositeImage + 0.1 * BWToRGB( mask(:,:,i));
end
PresentComponentsRGB(overlaped, 3, [1,M(3)]);
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

    % next three lines are preparation to use DSEARCH (matlab function for finding nearest point). 
    % 'X' and 'Y' are vector representation of the 'insideContour'.
    % 'TRI' is the 'finalSpectra' simplex (i.e. filled poligon) of the 'insideContour'.
    % 'XI' and 'YI' are vector representation of the 'outsideContour'.

    [X,Y] = ConvertContourToVector(insideContour);
    TRI = delaunay(X,Y);
    [XI,YI] = ConvertContourToVector(outsideContour);
    
    % Puti(0.5 * compositeImage + 0.25 * BWToRGB(insideContour) + 0.25 * BWToRGB(maskEroded(:,:,i)),num2str(i),i,[0,1]);
    % Puti(insideContour(:,:,i),num2str(i),i,[0,1]);

    numberOfPoints = length(XI);
    
    % Variable 'checked' is the map of pixels that are fixed (see introduction for explanation).
    % Its purpose is to skip calculations for spectra that have already been calculated.
    checked = zeros(M(1), M(2));
    l = 1;
    % S will contain sum of checked values. If this sum is not changing,
    % that means outside contour might expand too much.
    clear S;
    clear mag;
    clear offset;
    S(l) = 0;
    
    % Variable 'finalOrganSpectra' is going to store all the fixed spectra
    % in columns.
    finalOrganSpectra = zeros( N(3), numberOfPoints);
    
    % initialization for 5.4.
    newOutsideContour = outsideContour;
        
    % our algorithm will stop when all the points become fixed.
    h = waitbar(0,['Organ ' num2str(i) ' ...']);
    bool = 1;
    while bool
        bool = 0;
        waitbar(l/20, h);
        l = l + 1;
        for j = 1 : numberOfPoints
            % j is the current point.
            if checked( XI(j), YI(j) ) == 0
                % 5.2. 
                % find the index ('K') of the closest point (X(K) and Y(K)
                % will then be coordinates).
                K = dsearch( X, Y, TRI, XI(j), YI(j));

                % find the spectrum of outside and inside point (insideSpectrum can be
                % precalculated in the future)
                [outsideSpectrum, pointsUsedOutside] = SpectrumAroundPoint( x, newOutsideContour, XI(j), YI(j), 2);
                [insideSpectrum, pointsUsedInside] = SpectrumAroundPoint( x, insideContour, X(K), Y(K), 2);
                % presents the spectra
                inside = { pointsUsedInside, [X(K), Y(K)], insideSpectrum};
                outside = { pointsUsedOutside, [XI(j), YI(j)], outsideSpectrum};
                
                % finds the pure spectrum
                [spectrum, parameters] = ComputePureSpectrum(insideSpectrum, outsideSpectrum, fitOffset);  
%                 size(outsideSpectrum)
%                 size(spectrum)
                spectrum = (smooth(spectrum, smoothDelta,'lowess'))';
                insideSpectrum = (smooth(insideSpectrum, smoothDelta,'lowess'))';
                outsideSpectrum = (smooth(outsideSpectrum, smoothDelta,'lowess'))';
%                 size(insideSpectrum)
%                 size(spectrum)
                % 5.3. 
                %if SpectrumDistinctiveEnough(smooth(spectrum, smoothDelta), smooth(insideSpectrum, smoothDelta))
                if SpectrumDistinctiveEnough(spectrum, insideSpectrum)
                    %fix the point [XI(j), YI(j)]
                    outsideContour(XI(j), YI(j)) = 1;
                    checked( XI(j), YI(j) ) = 1;
                    finalOrganSpectra(:,j) = spectrum;
                    mag(j) = parameters(1);
                    if size(parameters,2) > 1
                        offset(j) = parameters(2);
                    else
                        offset (j) = 0;
                    end
                
                    if showSpectraIndicator && i ==3
                        ShowSpectra( compositeImage, inside, outside, spectrum, parameters);
                        close;
                    end
                else
                    % move the outsideContour pixel [XI(j), YI(j)] further away.
                    outsideContour( XI(j), YI(j)) = 0;
                    [XI(j), YI(j)] = MovePixelFurtherAway([ X(K), Y(K)],[ XI(j), YI(j)],[ M(1), M(2)]);
                    [XI(j), YI(j)] = MovePixelFurtherAway([ X(K), Y(K)],[ XI(j), YI(j)],[ M(1), M(2)]);
                    outsideContour( XI(j), YI(j)) = 1;
                    checked( XI(j), YI(j) ) = 0;
                    if showSpectraIndicator && i ==3
                        ShowSpectra( compositeImage, inside, outside, spectrum, parameters);
                        close;
                    end
                end
        %        PresentContour(compositeImage, outsideContour, insideContour);
                bool = 1;
                if (numberOfPoints - sum(checked(:))) < numberOfPoints / 15;
                    bool = 0;
                end
                if l > 15
                    bool = 0;
                end
            end
        end
        % 5.4.
        S(l) = sum(checked(:))
        newOutsideContour = createNewContour( outsideContour);
        % 5.5.
        % bool = ( numberOfPoints ~= sum(checked(:)) );
        % Pos(1); PresentContour(compositeImage, outsideContour, insideContour);
        % close;
    end
    % averageMag = mean(mag)
    % averageOffset = mean(offset)
    % [finalSpectra(:, i), parameters] = ComputePureSpectrumGlobaly(cube, insideContour, outsideContour, 1);
    finalSpectra(:, i) = mean( finalOrganSpectra, 2);
    parameters                
    Pos(2); PresentContour( compositeImage, outsideContour, insideContour);
    title(['organ ' num2str(i)]);
%     for k = 1:N(3)
%         R(k) = mean(mean(x(:,:,k).*outsideContour));
%     end
%     Pos(4);
%     plot(R);
%     title(['outsideSpectra for organ ' num2str(i)]);
    
    % disp(['Average mag = ' num2str(mean(parameters(1))) ', Average offset = ' num2str(mean(parameters(2)))]);
    % Puti( checked, num2str(i) , 1);
    close(h);
end

%% 6. Presents the solution 

if truncateSpectraZeros 
    finalSpectra = finalSpectra .* (finalSpectra>0);
    MyTitle = 'reconstuction, truncated zeros';
else
    MyTitle = 'reconstuction';
end
Pos(3); plot(NormalizeSpectra(finalSpectra));
Composite(FindCoeff( finalSpectra, x, 1), MyTitle, 0.2, [1 3]);
