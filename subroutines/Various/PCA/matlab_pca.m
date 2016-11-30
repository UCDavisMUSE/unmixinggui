% this is the m-file for matlab PCA, uses princomp
N = size(cube);
%% section that converts x to y by stacking images as columns
y = zeros(N(1) * N(2), N(3));
for i = 1:N(3) 
    temp = cube(:,:,i); 
    y(:,i) = temp(:); 
end
map = colormap(gray(256));
close;

%% PCA section
[coeff, score] = princomp(y);
figure; 
for i = 1:10
    subplot(2,5,i)
    imagesc(reshape(score(:,i),N(1),N(2)));  
    colormap gray; 
    colorbar;
    axis square off;
    axis image;
end
