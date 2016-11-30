clc;
close all;

% Main program. 
%
% Problem: 
%   Segment areas in a user-defined movie. The default movie containes 3 gaussians.
%
% Mathematial definition of the problem:  
%   Solve equation: y = A*coeff for coeff;
%   y - column of y represents one pixel's intensity in time;
%   A - column of A represents organ time spectra;
%   coeff - column of coeff represents contributions of organs at the
%   corresponding pixel i.e. every column of coeff represents the unmixing coefficients.
% 
% Solution: the easiest one (but far from ideal) is coeff = pinv(A)*y.
%
% Code explanation:
%   1) Program first creates a 3D matrix, x, which is our observation (x(:,:,1) is the first image, x(:,:,2) the second
%   and so on). Program then converts x to y, which is the 2D matrix where images are represented as columns.
%   2) Program then loads spectra i.e. determines matrix A (manually or otherwise).
%   3) Solves the problem
%   4) Display results

%% basic input
N = 30; % imagesize in one dimension
n = 100; % numberOfImages
t = (1:n); % time or wavelength
maps; % creates R,G,B colormaps
numberOfOrgans = 3;

%% creates a 3D matrix, x.
trueA = zeros(n,1); 
[box1, trueA(:,1)] = span(10000*Gauss(2,2),0.1*n,0.3*n);
[box2, trueA(:,2)] = span(20000*Gauss(0,0),0.3*n,0.5*n);
[box3, trueA(:,3)] = span(15000*Gauss(-2,-2),0.5*n,0.7*n);
x = 0.33*(box1 + box2 + box3);

%% section that converts x to y by stacking images as columns
y = zeros(size(x,1)*size(x,2),size(x,3));
for i = 1:size(x,3) 
    temp = x(:,:,i); 
    y(:,i) = temp(:); 
end
map = colormap(gray(256));
close;

%% section for the profiles
button = questdlg('Do you want to manually to determine spectra?   .');
if strcmp(button,'Yes')
    imagesc(sum(x,3));
    title('Click at the 3 points, then press enter')
    colormap(gray);
    axis square off;
    [X,Y] = ginput;
    close;
    numberOfDots = size(X,1);
    mydot = [X Y];
    myprofile = zeros(numberOfDots,n);
    for i = 1:numberOfDots
        for j = 1:n
            myprofile(i,j) = x(round(mydot(i,2)),round(mydot(i,1)),j);
        end
    end
    pos(4);
    plot(t,myprofile,'-.','Linewidth',4);
    leg = (1:numberOfDots)';
    legend(num2str(leg));
    title('Choosen profiles');

    A = myprofile'; 
    note = 'Manualy determined spectra was used.         .';

elseif strcmp(button,'No') 
    A = trueA; 
    note = 'True spectra was used.';
else
    msgbox('Program terminated');
    break
end


%% section for making and displying the movie
button = questdlg('Do you want to see the movie?   .');
if strcmp(button,'Yes')
    for i = 1:n
        M(i) = im2frame( 1 + round(x(:,:,i)),map);
    end
    pos(2);
    axis square off;
    G = resizeMovie(M);
    movie(G,1)
    close;
elseif strcmp(button,'No')
else
    msgbox('Program terminated');
    return
end


% %% PCA section
% [coeff, score] = princomp(y);
% figure; 
% for i = 1:4
%     subplot(2,2,i)
%     imagesc(reshape(score(:,i),size(x,1),size(x,2)));  
%     colormap gray; 
%     colorbar;
%     axis square off;
%     axis square;
% end

%% section that finds the coefficients which is the purpose of this program
coeff = pinv(A)*y';
coeffReshaped = zeros(N,N,numberOfOrgans);
pos(1);
for i = 1:size(coeff,1);
    subplot(2,2,i);
    switch i
        case 1
            map = mapRed;
        case 2 
            map = mapGreen;
        case 3 
            map = mapBlue;
    end
    coeffReshaped(:,:,i) = reshape(coeff(i,:),size(x,1),size(x,2));
    
    %for contours only
    %subimage(250*uint8(coeffReshaped(:,:,i)/max(max(coeffReshaped(:,:,i)))),map);
    
    subimage(uint8(400*(coeffReshaped(:,:,i))),map); %can be made better, but its working
    %image(200*coeffReshaped(:,:,i)); colormap(gray)
    axis square off;
    title(['comp ' num2str(i)]);
end
subplot(2,2,4);
image((coeffReshaped - min(coeffReshaped(:)))/max(coeffReshaped(:) - min(coeffReshaped(:))));
axis square off;
title('Components combined');

%% section that plots true spectra
pos(3)
plot(trueA)
leg = (1:numberOfOrgans)';
legend(num2str(leg));
title('true spectra');

%% notes
msgbox(note,'Note','modal');