function composite = CreateComposite(spectra, nMax, scaled)
% function composite = CreateComposite(spectra, nMax, scaled)
%
% Purpose: To create a composite image from components

N = size(spectra(1).component);
composite = zeros(N(1), N(2), 3);

for i = 1:nMax
    if spectra(i).show
        if scaled
            spectra(i).component = (2^16-1)*spectra(i).component/max(max(spectra(i).component));
        end
        
        composite = composite + BWToRGB(spectra(i).component, spectra(i).color);
    end
end
composite = uint16((2^16 - 1)*(composite/max(composite(:))));

% 
% %scales RGB image to 255
% handles.RGBImage = uint8(250 * handles.RGBImage./max(handles.RGBImage(:)));
% handles.wavelength = wavelength;
% handles.colorWeight = colorWeight;
% 
% 
% % There are 8 color maps
% cMap = [1 0 0; 0 1 0; 0 0 1; ...
%         0.7 0 0.7; 0 0.7 0.7; 0.7 0.7 0; ...
%         0.7 0 0.5; 0 0.7 0.5; 0.7 0.5 0; ....
%         0.5 0.5 0.5];
% 
% for i = 1:N(3)
%      compositeTemp = components(:,:,i);
%      ma = max( compositeTemp(:));
%      if ma ~= 0 
%         compositeTemp = compositeTemp / ma;
%         compositeTemp = compositeTemp .* ( compositeTemp > 0);
%      else
%         compositeTemp = zeros( N(1), N(2));
%      end
%      
%      subplot(subplotSize(1), subplotSize(2), i);
%      PutImage(250*compositeTemp,['component ' num2str(i) ' '  myTitle]); 
%      ma = max( compositeTemp(:));
%      mi = min( compositeTemp(:));
%      threshTemp = compositeTemp > threshold * ( ma - mi ) + mi;
%      %threshTemp = DilateMask( DilateMask( ErodeMask( ErodeMask( threshTemp))));
%           
%      compositeImage = compositeImage + BWToRGB( compositeTemp, cMap(i,:));
%      
% end
% % shold be changed
% % PutImageAt( compositeImage, ['Composite image - ' myTitle], 3);
% % PutImageAt( thresholdedImage, ['Thresholded composite image - ' myTitle], 4);
% Pos(3)
% imagesc( Scale(compositeImage,0,1,min(compositeImage(:)),max(compositeImage(:))));
% axis image off
% title(['Composite image ' myTitle]);
% % Pos(4)
% % imagesc( Scale(thresholdedImage,0,1,min(thresholdedImage(:)),max(thresholdedImage(:))));
% % axis image off
% % title(['Thresholded image ' myTitle]);
