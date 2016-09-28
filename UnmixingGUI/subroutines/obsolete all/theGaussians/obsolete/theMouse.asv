clc;
close all;
N = 30; % picture size
n = 100; % numberOfImages
t = (1:n); % time or wavelength
maps;

% x is our observation x(:,:,1) is the first image, x(:,:,2) the second
% and so on. size(x) = [imagesize(1),imagesize(2), number of images]
% y is the converted matrix where every image is a column; size(y) =
% [imagesize(1)*imagesize(2),number of images]

% S is a matrix that containes spectra of each "organ";
% size(S) = [number of images, number of "organs"]

% Definition of the problem:  y = S*coeff;
% which can be solved as xr = pinv(S)*y;
% then every column of xr represents the unmixed "organ"

numberOfBoxes = 3;
trueS = zeros(n,1);

%% conversion to y
y = zeros(size(x,1)*size(x,2),size(x,3));
for i = 1:size(x,3) 
    temp = x(:,:,i); 
    y(:,i) = temp(:); 
end

map = colormap(gray(256));
close;

%%%%%%%%%%%%%%
% section for the profiles
imagesc(sum(x,3));
colormap(gray);
axis square off;
[X,Y] = ginput;
close;
numberOfDots = size(X,1);
%mydot = [12,12;       17,17;       22,22];
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
S = myprofile';
% end section
%%%%%%%%%%%%%%



%%%%%%%%%%%%%%
%% section for making the movie

for i = 1:n
    M(i) = im2frame( 1 + round(x(:,:,i)),map);
end
pos(2);
axis square off;
G = resizeMovie(M);
movie(G,1)
close;
%% end section
%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%
% %% PCA section
% [coeff, score] = princomp(y);
% figure; 
% for i = 1:4
%     subplot(2,2,i)
%     imagesc(reshape(score(:,i),size(x,1),size(x,2)));  
%     colormap gray; 
%     colorbar;
%     axis off;
%     axis square;
% end
% %% end section
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
%% recovery analysis
xr = pinv(S)*y';
pos(1);
for i = 1:size(xr,1);
    subplot(2,2,i);
    switch i
        case 1
            map = mapBlue;
        case 2 
            map = mapGreen;
        case 3 
            map = mapRed;
    end
    %subimage(250*uint8(reshape(xr(i,:),size(x,1),size(x,2))/max(xr(i,:))),map);
    %image(250*uint8(reshape(xr(i,:),size(x,1),size(x,2))/max(xr(i,:))));
    image(100*reshape(xr(i,:),size(x,1),size(x,2))); colormap(gray(256));   
    axis square off;
    title(['comp ' num2str(i)]);
end
subplot(2,2,4);
imagesc(sum(x,3));
colormap(gray);
axis square off;
%% end section

% %%%%%%%%%%%%%%%%
% %% plot spectra is for the mice case unknown
% pos(3)
% plot(trueS)
% leg = (1:numberOfBoxes)';
% legend(num2str(leg));
% title('true spectra');
% %%%%%%%%%%%%%%%%