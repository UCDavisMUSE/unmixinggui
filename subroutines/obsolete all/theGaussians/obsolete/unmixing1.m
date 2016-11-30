clc;
close all;
clear x;
x = cube;
N = size(x);

% section that converts x to y by stacking images as columns
y = zeros(N(1)*N(2),N(3));
for i = 1:N(3) 
    temp = x(:,:,i); 
    y(:,i) = temp(:); 
end
y = y';

% find the true reconstruction
[sImage, tImage] = FindCoeff(Atrue,y,N,1);
close all;
%% segment organs, obtains variable mask
M = size(organList);
mask = zeros(M);
clear A;
A = zeros(N(3),M(3));
% 1) segments the organs (so far only thresholds them, can be improved)
% 2) find the convex hulls and posibly dilates them
% 3) calculate overlaping and non-overlaping regions and gives the percentage of overlap for each organ
% 4) calulate the spectra based on everything
%     4.1) find the "pure" spectra using non overlap region
%     4.2) finds the "mixed" spectra usign overlap region

% 1) segments the organs (so far only thresholds them, can be improved)
for i = 1:M(3)
    image = organList(:,:,i);
    % different mask for background
    if i == 1
        mask(:,:,i) = image > 0.10 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    else
        mask(:,:,i) = image > 0.5 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    end
    Puti(mask(:,:,i),num2str(i),i,[0,1]);
end

% 2) find the convex hulls
for i = 1:M(3)
    mask(:,:,i) = FindConvexRegion(mask(:,:,i));
    Puti(mask(:,:,i),num2str(i),i,[0,1]);
end

% % 3) calculate the non-overlaping regions
% duplicate = mask;
% for i = 1:M(3)
%     if i == 1
%         % excludes organs region from background spectra calcuation
%         mask(:,:,1) = duplicate(:,:,1) - sum(duplicate(:,:,2:M(3)),3);
%         mask(:,:,1) = mask(:,:,1) > 0;
%         % find the background imediatelly
%         for j = 1:N(3)
%             A(j,1) = mean(mean(  x(:,:,j).*mask(:,:,1)) );
%         end
%     else
%         % excludes background and other organ regions from spectra
%         % calculation
%         mask(:,:,i) = duplicate(:,:,i) - sum(duplicate(:,:,KickOutNumber(2:M(3),i)),3);
%         mask(:,:,i) = mask(:,:,i) > 0;
%     end
%     Puti(mask(:,:,i),num2str(i),i);
% end

% % 4) finds background spectra only
% excludes organs region from background spectra calcuation
maskAllOrgans = DilateMask ( DilateMask ( DilateMask ( sum(mask(:,:,2:M(3)),3) ) ) );
mask(:,:,1) = duplicate(:,:,1) - maskAllOrgans;
mask(:,:,1) = mask(:,:,1) > 0; 
% finds the background spectrum imediatelly
for j = 1:N(3)
    A(j,1) = mean(mean(  x(:,:,j).*mask(:,:,1)) );
end
pos(3);  A = NormalizeSpectra(A); plot(A);  title('A background');


for i = 2:M(3)
    Puti(0.9 * sImage + 0.1 * BWToRGB(mask(:,:,i)),num2str(i),i,[0,1]);
end
% 4) finds the dilated and eroded masks
for i = 2:M(3)
    maskDilated1(:,:,i) = DilateMask(mask(:,:,i));
    maskDilated2(:,:,i) = DilateMask(maskDilated1(:,:,i));
    maskDilated3(:,:,i) = DilateMask(maskDilated2(:,:,i));
    maskDilated4(:,:,i) = DilateMask(maskDilated3(:,:,i));
    maskDilated(:,:,i) = maskDilated4(:,:,i) - maskDilated3(:,:,i);
    %maskDilated(:,:,i) = maskDilated(:,:,i) - mask(:,:,i);
    maskDilated(:,:,i) = maskDilated(:,:,i) > 0;
    
    maskEroded1(:,:,i) = ErodeMask(mask(:,:,i));
    maskEroded2(:,:,i) = ErodeMask(maskEroded1(:,:,i));
    maskEroded3(:,:,i) = ErodeMask(maskEroded2(:,:,i));
    maskEroded4(:,:,i) = ErodeMask(maskEroded3(:,:,i));  
    maskEroded(:,:,i) = maskEroded4(:,:,i) - maskEroded3(:,:,i);  
    % maskEroded(:,:,i) = maskEroded(:,:,i) - mask(:,:,i);
    maskEroded(:,:,i) = maskEroded(:,:,i) < 0;
    
    Puti(0.5 * sImage + 0.25 * BWToRGB(maskDilated(:,:,i)) + 0.25 * BWToRGB(maskEroded(:,:,i)),num2str(i),i,[0,1]);
    %Puti(maskEroded(:,:,i),num2str(i),i,[0,1]);
end


% 5) find the spectra
% we use dsearch function

for i = 2:M(3)
    clear X Y TRI XI YI;
    % new three lines are preparation to use dsearch, the idea is to match spectra pairwise
    % with maskEroded and maskDilated
    [X,Y] = ConvertMaskToVector(maskEroded(:,:,i));
    TRI = delaunay(X,Y);
    [XI,YI] = ConvertMaskToVector(maskDilated(:,:,i));
    %
    clear spectra K;
    for j = 1:length(XI)
        K(j) = dsearch(X,Y,TRI,XI(j),YI(j));
        [spectraOut, pointsUsedOut] = SpectraAroundPoint(x,maskDilated(:,:,i),XI(j),YI(j), 5 );
        [spectraIn, pointsUsedIn] = SpectraAroundPoint(x,maskEroded(:,:,i),X(K(j)),Y(K(j)), 5 );
        [spectra(:,j),parameters] = CalculatePureSpectra(spectraIn, spectraOut, 1);
%         disp(['magnitude = ' num2str(parameters(1))]);
%         disp(['offset = ' num2str(parameters(2))]);
        if 2 == 3
%% the presentation part    
        close all
        Posf(1);
        subplot(2,2,[1 2]);   
        partMaskOut = zeros(M(1), M(2));
        partMaskIn = zeros(M(1), M(2));
        for k = 1:length(pointsUsedOut.X)
            partMaskOut(pointsUsedOut.X(k),pointsUsedOut.Y(k)) = 1;
        end
        for k = 1:length(pointsUsedIn.X)
            partMaskIn(pointsUsedIn.X(k),pointsUsedIn.Y(k)) = 1;
        end
        PutImage( 0.8 * sImage + 0.1 * BWToRGB(partMaskOut) + 0.1 * BWToRGB(partMaskIn),['perfect one, ' ... 
            'puo:' num2str(length(pointsUsedOut.X)) ', pui:' num2str(length(pointsUsedIn.X))])
        TestClosestPoint(XI(j),YI(j),maskEroded(:,:,i));
        %subplot(2,2,2);
        %PutImage(maskDilated(:,:,i) + maskEroded(:,:,i),['puo:' num2str(pointsUsedOut) ', pui:' num2str(pointsUsedIn)]);
        TestClosestPoint(XI(j),YI(j),maskEroded(:,:,i));
        subplot(2,2,3);
        plot( spectraOut ,'r');
        hold on
        plot( spectraIn,'g');
        legend('red - outisde','green - inside')
        subplot(2,2,4);
        plot(spectra(:,j));
        axis([0 100 -100 200]);
        title(['magnitude = ' num2str(parameters(1)), ', offset = ' num2str(parameters(2))]);
        close ;
        end
%% end of presentation part
    end
    A(:,i) = mean(spectra,2);
end
pos(3);  A = NormalizeSpectra(A); plot(A);  title('A');
for i = 2:M(3)
    A(:,i) = CalculatePureSpectra( A(:,i), A(:,1),1);
end
Pos(4); A = NormalizeSpectra(A); plot(A); title('A after shrinking');

%% 
[sImage, tImage] = FindCoeff(A,y,N,1);