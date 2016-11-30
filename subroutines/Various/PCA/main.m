clc;
close all;
x = cube;
%% section that converts x to y by stacking images as columns
y = zeros(size(x,1)*size(x,2),size(x,3));
for i = 1:size(x,3) 
    temp = x(:,:,i); 
    y(:,i) = temp(:); 
end
map = colormap(gray(256));
close;

%% PCA section
[coeff, score] = princomp(y);
figure; 
for i = 1:4
    subplot(2,2,i)
    imagesc(reshape(score(:,i),size(x,1),size(x,2)));  
    colormap gray; 
    colorbar;
    axis image off;
end
