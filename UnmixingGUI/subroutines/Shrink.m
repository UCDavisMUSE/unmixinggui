function organSpectrum = Shrink(organSpectrum, background)
% 
% %% old shrink
% % function background = shrink(organSpectrum,background)
% % it shrinks the background and subtracts it from the organSpectrum  
% % pos(1)
% % plot(organSpectrum,'r');
% % hold on
% % plot(background,'g');
% 
% [junk,I] = min( organSpectrum ./ background );
% background = background * ( organSpectrum(I) / background(I) );
% 
% % pos(2)
% % plot(organSpectrum,'r');
% % hold on
% % plot(background,'g');
% 
% % 
% organSpectrum = organSpectrum - background;
% % pos(3)
% % plot(organSpectrum,'r');

%% new Shrink

organSpectrum = CalculatePureSpectra(organSpectrum, background, 1)