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

%% segment organs, obtains variable mask
M = size(organList);
mask = zeros(M);
clear A;

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
        mask(:,:,i) = image > 0.25 * ( max(image(:)) - min(image(:)) ) + min(image(:));
    end
    Puti(mask(:,:,i),num2str(i),i,[0,1]);
end

% 2) find the convex hulls and posibly dilates them
for i = 1:M(3)
    mask(:,:,i) = FindConvexRegion(mask(:,:,i));
    Puti(mask(:,:,i),num2str(i),i,[0,1]);
end
% 3) find the wider mask by dilatation
maskWider = mask;
for i = 1:M(3)
    maskWider(:,:,i) = MaskDilate(mask(:,:,i));
    maskWider(:,:,i) = MaskDilate(maskWider(:,:,i)); 
    maskWider(:,:,i) = maskWider(:,:,i) - mask(:,:,i);
    maskWider(:,:,i) = maskWider(:,:,i) > 0;
    Puti(maskWider(:,:,i),num2str(i),i,[0,1]);
end



% 3) calculate overlaping and non-overlaping regions and gives the percentage of overlap for each organ
duplicate = mask;
overlap = zeros([M M(3)]); 
for i = 1:M(3)
    if i == 1
        % excludes organs region from background spectra calcuation
        mask(:,:,1) = duplicate(:,:,1) - sum(duplicate(:,:,2:M(3)),3);
        mask(:,:,1) = mask(:,:,1).*(mask(:,:,1)>0);
    else
        % excludes background and other organ regions from spectra
        % calculation
        overlap(:,:,i,k) = duplicate(:,:,i) + duplicate(:,:,k);
        overlap(:,:,i,k) = ( overlap(:,:,i,k) == 0 );
        
        sum(duplicate(:,:,KickOutNumber(2:M(3),i)),3);      
    end
    Puti(mask(:,:,i),num2str(i),i);
    mask(:,:,i) = mask(:,:,i).*(mask(:,:,i)>0);
    Puti(mask(:,:,i),num2str(i),i);
    
    %mask(:,:,i) = maskErode(mask(:,:,i));
    %mask(:,:,i) = maskErode(mask(:,:,i));
    
    Puti(mask(:,:,i),num2str(i),i);
    
    for j = 1:N(3)
        A(j,i) = mean(mean(  x(:,:,j).*mask(:,:,i)));
        B(j,i) = mean(mean(  deriv(:,:,j).*mask(:,:,i)));
    end
end
Pos(4); A = NormalizeSpectra(A); plot(A);

%% third iteration - subtract background
for i = 2:M(3)
    A(:,i) = Shrink(A(:,i),A(:,1));
end
A(:,2) = Shrink(A(:,2),A(:,3));
A(:,3) = Shrink(A(:,3),A(:,2));
Pos(4); A = NormalizeSpectra(A); plot(A);

%% 
FindCoeff(A,y,N,1);