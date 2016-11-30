% Re-draws the graph for DerivativeDemo when the sliders are changed
% Tom O'Haver, July 2006. Slider function by Matthew Jones.
global t
global signal
global Scale
global Order
global SmoothWidth
global Exponent
global amp
global pos
global wid
global Noise
global NoiseArray
global Background
global BackgroundPosition
  axes(h);
  purespectrum=amp.*gaussian(t,pos,wid);  % Generate peak of width wid
  purespectrum=purespectrum+(Background.*gaussian(t,BackgroundPosition,1000));  % Add background
  signal=purespectrum+Noise.*NoiseArray; % Add noise to peak
  PlotRange=[SmoothWidth.*3:length(t)-SmoothWidth.*3];
  signal=bsmooth(signal, SmoothWidth);
     switch Order
         case 0, 
             Exponent=0;
             derivativelabel='Original signal';
         case 1, 
             Exponent=-2;
             derivativelabel='First Derivative';
         case 2, 
             Exponent=-3.8;
             derivativelabel='Second Derivative';
         case 3, 
             Exponent=-5.6;
             derivativelabel='Third Derivative';
         case 4, 
             Exponent=-7.3;
             derivativelabel='Fourth Derivative';
     end
   SmoothNoise=Noise.*NoiseArray;  
   if Order > 0,
       SmoothDerivative=signal;
     for k=1:Order,
      SmoothDerivative=deriv(SmoothDerivative);
      SmoothNoise=deriv(SmoothNoise);
      SmoothDerivative=bsmooth(SmoothDerivative, SmoothWidth);
      SmoothNoise=bsmooth(SmoothNoise, SmoothWidth);
     end
   else
     SmoothDerivative=signal;
   SmoothNoise=bsmooth(SmoothNoise, SmoothWidth);
   end
  SignalRange=range(SmoothDerivative(PlotRange));
  h=figure(1);
  plot(t(PlotRange),SmoothDerivative(PlotRange))
  figure(1);
title([ ' Amp = ' num2str(amp)  '    Background = ' num2str(Background)   '/' num2str(BackgroundPosition) '    Noise = ' num2str(Noise) ])
xlabel([ 'Derivative Order = ' num2str(Order) '   Smooth Width = ' num2str(SmoothWidth) '    Signal range= ' num2str(SignalRange) ])
text(50,.9.*Scale.*10^Exponent,derivativelabel);
text(50,.8.*Scale.*10^Exponent,['Smooth ratio = ' num2str(SmoothWidth./wid) ]);
text(50,.7.*Scale.*10^Exponent,['Signal-to-noise ratio = ' num2str(SignalRange./std(SmoothNoise)) ]);
h2=gca;
  if Order==0,
        axis([0 1000 -Scale/10.*10^Exponent Scale.*10^Exponent]);
  else
        axis([0 1000 -Scale.*10^Exponent Scale.*10^Exponent]);
  end
