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
[signals, PC, V] = pca2(y');
figure; 
size(signals)
size(PC)
size(V)
%% 
for i = 1:10
    subplot(2,5,i)
    imagesc(reshape(signals(i,:),N(1),N(2)));  
    colormap gray; 
    colorbar;
    axis square off;
    axis image;
end