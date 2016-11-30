% Interactive smoothing for your own data, with sliders to control 
% derivative order, smooth width, and scale expansion.  To use it, 
% place your signal in the global variables "x" and "signal" and then
% execute this m-file. The smoothed derivative is placed in global 
% variable "derivative". The actual differentiation is performed by the 
% function  InteractiveDerivativeRedraw, which is called when the sliders
% are moved. If you wish, you can change the maximum range of the smooth 
% width slider (MaxSmoothwidth in line 14) and the  maximum range of the 
% derivative order slider (MaxDerivativeOrder in line 15). You can also
% change the smoothing function by replacing "fastsbmooth" in 
% InteractiveDerivativeRedraw with any other smoothing function.
% Tom O'Haver, July 2006. Slider function by Matthew Jones.
figure(1);
close
global x
global signal
global derivative
global Exponent
global Order
global SmoothWidth
global Exponent
global Scale
SmoothWidth=25;
MaxSmoothWidth=100;
MaxDerivativeOrder=4;
Exponent=0;
Scale=5;
Order=0;
h=figure(1);
derivative=fastbsmooth(signal, SmoothWidth);
plot(x,derivative)
figure(1);
title('Interactive Derivative')
  text(.1.*length(x),.9.*Scale.*10^Exponent,'Original signal')
xlabel([ '  Derivative Order = ' num2str(Order)  '    Smooth Width = ' num2str(SmoothWidth)   '    P-P signal range= ' num2str(range(signal)) ])
h2=gca;axis([x(1) x(length(x)) -Scale/10.*10^Exponent Scale.*10^Exponent]);

rtslid(h,@InteractiveDerivative4,h2,1,'Scale',[0 MaxDerivativeOrder],'Def',Order,'Back',[0.9 0.9 0.9],'Label','Order','Position',[0.02 0.5 0.03 0.35]);
rtslid(h,@InteractiveDerivative2,h2,0,'Scale',[-5 5],'Def',log10(Scale),'Back',[0.9 0.9 0.9],'Label','Scale','Position',[0.95 0.1 0.03 0.8]);
rtslid(h,@InteractiveDerivative1,h2,1,'Scale',[1 MaxSmoothWidth],'Def',SmoothWidth,'Back',[0.9 0.9 0.9],'Label','Smooth','Position',[0.02 0.05 0.03 0.35]);

