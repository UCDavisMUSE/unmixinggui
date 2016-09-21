function [ratio,snr,image] = getOrgan(organList,threshold)

image = organList(:,:,2); %ones(size(cube,1),size(cube,2));
firstComponent = organList(:,:,1);

% 
[snr2,mask2] = getSNR(organList(:,:,2),threshold);
snr = snr2;
% [snr3,mask3] = getSNR(organList(:,:,3),threshold);
% if snr2 > snr3
%     snr = snr2;
%     %image = organList(:,:,2).*mask2;
%     %firstComponent = organList(:,:,1).*mask2;    
%     
%     image = organList(:,:,2);
%     firstComponent = organList(:,:,1);    
% else
%     snr = snr3;
%     %image = organList(:,:,3).*mask3;
%     %firstComponent = organList(:,:,1).*mask3;
%     image = organList(:,:,3);
%     firstComponent = organList(:,:,1);
% end
ratio = getRatio(firstComponent,image);
put(firstComponent,'1st component',2)
put(image,'heart',2)
