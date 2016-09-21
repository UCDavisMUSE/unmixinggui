% Self-contained demo of the application of differentiation to
% the detection of peaks superimposed on a strong, variable 
% background. Generates a peak signal, adds random noise and 
% a variable background, then differentiates and smooths it, and 
% measures the signal range and signal-to-noise ratio (SNR). 
%
% Interactive sliders allow you to control the following variables:
% Amp: The amplituide (peak height) of the peak signal.  
%      Default range: 0-3
% Back1: The amplituide of the background. 
%        Default range: 0 to 20
% Back2: The position of the background. 
%        Default range: -800 to +800
% Noise: Random white noise added to the signal.  
%         Default range: 0 - 0.5
% Order: Derivative order. Default range: 0-4
% Scale: Scale expansion of the y-axis. 
%        Default range: 0.1 - 10.
% Smooth: Width of the smoothing function, in data points. 
%         Default range: 0 - 100
% Resample: Applies different random noise samples, to demonstrate 
%           the low-frequency noise that remains after smoothing. 
% Tom O'Haver, July 2006. Slider function by Matthew Jones.
figure(1);
close
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
t=[1:1000];
amp=.8 ;  % Amplitude of the peak
pos=500;   % Position of the peak
wid=200;   % Width of the peak
Noise=.01;  % Random noise added to simulated signal
Background=6;  % Background signal amp[litude
BackgroundPosition=-160; % Position of background peak
Exponent=0;  % Exponent of y-axis scale
Scale=6;  % Y-axis scale
Order=0;   % Derivative order
SmoothWidth=75;  % Initial value of smooth width

% Generate signal
signal=amp.*gaussian(t,pos,wid);  % Generate peak of width wid
NoiseArray=randn(size(t));  % Create noise array
signal=signal+(Background.*gaussian(t,BackgroundPosition,1000));  % Add background
signal=signal+Noise.*NoiseArray;    % Add noise to signal
SmoothSignal=bsmooth(signal, SmoothWidth);

% Plot signal
PlotRange=[SmoothWidth.*3:length(t)-SmoothWidth.*3];  % Plot range to ignore artifacts at ends of signal
h=figure(1);
plot(t(PlotRange),SmoothSignal(PlotRange))
figure(1);
title([ ' Amp = ' num2str(amp)  '    Background = ' num2str(Background)   '/' num2str(BackgroundPosition) '    Noise = ' num2str(Noise) ])
xlabel([ 'Derivative Order = ' num2str(Order)   '    Smooth Width = ' num2str(SmoothWidth) '    Signal range= ' num2str(range(SmoothSignal(PlotRange))) ])
text(50,.9.*Scale.*10^Exponent,'Original signal');
text(50,.8.*Scale.*10^Exponent,['Smooth ratio = ' num2str(SmoothWidth./wid) ]);
h2=gca;  
axis([0 1000 -Scale/10.*10^Exponent Scale.*10^Exponent]);
warning off MATLAB:divideByZero

% Draw the control sliders
% Left sliders (top to bottom)
rtslid(h,@DerivativeHeight,h2,1,'Scale',[0 3],'Def',amp,'Back',[1 1 1],'Label','Amp','Position',[0.02 0.78 0.03 0.17]);
rtslid(h,@DerivativeBackground,h2,0,'Scale',[0 20],'Def',Background,'Back',[1 1 1],'Label','Back1','Position',[0.02 0.53 0.03 0.17]);
rtslid(h,@DerivativeSlope,h2,0,'Scale',[-800 800],'Def',BackgroundPosition,'Back',[1 1 1],'Label','Back2','Position',[0.02 0.28 0.03 0.17]);
rtslid(h,@DerivativeNoise,h2,0,'Scale',[0 .5],'Def',Noise,'Back',[1 1 1],'Label','Noise','Position',[0.02 0.03 0.03 0.17]);

% Right sliders (top to bottom)
rtslid(h,@DerivativeOrder,h2,0,'Scale',[0 4],'Def',Order,'Back',[1 1 1],'Label','Order','Position',[0.95 0.78 0.03 0.17]);
rtslid(h,@DerivativeScale,h2,0,'Scale',[10 .1],'Def',Scale,'Back',[1 1 1],'Label','Scale','Position',[0.95 0.53 0.03 0.17]);
rtslid(h,@DerivativeSmoothWidth,h2,0,'Scale',[1 100],'Def',SmoothWidth,'Back',[1 1 1],'Label','Smooth','Position',[0.95 0.28 0.03 0.17]);
rtslid(h,@DerivativeResample,h2,0,'Scale',[0 1],'Def',0,'Back',[1 1 1],'Label','Resample','Position',[0.95 0.03 0.03 0.17]);

