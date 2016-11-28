
y = zeros(size(x,1)*size(x,2),size(x,3));
for i = 1:size(x,3) 
    temp = x(:,:,i); 
    y(:,i) = temp(:); 
end

% %% PCA
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
%% recovery
xr = pinv(S)*y';
pos(1);
for i = 1:size(xr,1);
    subplot(2,2,i);
    imagesc(reshape(xr(i,:),size(x,1),size(x,2)));
    colormap(gray);
    axis off;
    colorbar;
    title(['comp ' num2str(i)]);
end
%% end section
%%%%%%%%%%%%%%%%

