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

% S is a matrix that containes spectra of each box;
% size(S) = [number of images, number of boxes]

% Definition of the problem:  y = S*coeff;
% which can be solved as xr = pinv(S)*y;
% then every column of xr represents the unmixed box

numberOfBoxes = 3;
S = zeros(n,1);
[box1, S(:,1)] = span(100*makeb(N,10,10,1),0.1*n,0.3*n);
[box2, S(:,2)] = span(200*makeb(N,10,15,4),0.2*n,0.5*n);
[box3, S(:,3)] = span(150*makeb(N,10,17,7),0.5*n,0.7*n);
x = 0.33*(box1 + box2 + box3);

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
% end section
%%%%%%%%%%%%%%

S = myprofile';

% %%%%%%%%%%%%%%
% %% section for making the movie
% 
% for i = 1:n
%     M(i) = im2frame( 1 + round(x(:,:,i)),map);
% end
% pos(2);
% axis off;
% G = resizeMovie(M);
% movie(G,1)
% close;
% %% end section
% %%%%%%%%%%%%%%

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
    subimage(250*uint8(reshape(xr(i,:),size(x,1),size(x,2))/max(xr(i,:))),map);
    %image(250*uint8(reshape(xr(i,:),size(x,1),size(x,2))/max(xr(i,:))));
    %image(reshape(xr(i,:),size(x,1),size(x,2))); colormap(gray(256));   
    axis off;
    title(['comp ' num2str(i)]);
end
subplot(2,2,4);
imagesc(sum(x,3));
colormap(gray);
axis square;
axis off;
%% end section

%%%%%%%%%%%%%%%%
%% plot spectra
pos(3)
plot(S)
leg = (1:numberOfBoxes)';
legend(num2str(leg));
title('guessed spectra');
%%%%%%%%%%%%%%%%