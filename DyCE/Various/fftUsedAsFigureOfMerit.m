clc;

figureOfMerit = zeros(1,8);
fftBrain1 = log(abs(fftshift(fft2(brain1))));
% figure;
% imagesc(fftBrain1)
% colormap(gray);
figure;
for i = 1:8
    B = organList(:,:,i);
    B = B./max(B(:));
%%    
%     figureOfMerit(i) = sum(sum(B.*brain1));
%     if i == 8 
%         stem(figureOfMerit)
%     end
%%      
%     subplot(2,4,i);
%     plot((sum(B,2)))
%%
%     subplot(2,4,i);
%     plot((sum(B,2)))
%%
      subplot(2,4,i);
      fftB = log(abs(fftshift(fft2(B))));
      imagesc(fftB);
      colormap(gray);
      figureOfMerit(i) = sum(sum( fftB.*fftBrain1));
      if i == 8 
          figure;
        stem(figureOfMerit);
      end
end
