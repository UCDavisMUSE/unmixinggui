% Redraws graph for InteractiveDerivative when the sliders are changed
global x
global signal
global derivative
global Exponent
global Order
global SmoothWidth
global Exponent
global Scale
  axes(h);
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
         otherwise
              Exponent=-9;
              derivativelabel=['Derivative Order = ' num2str(Order)];
     end
  PlotRange=[SmoothWidth.*3:length(x)-SmoothWidth.*3];
   if Order > 0,
       derivative=signal;
     for k=1:Order,
      derivative=deriv(derivative);
      derivative=fastbsmooth(derivative, SmoothWidth);
     end
   else
     derivative=signal;
   end
  derivative=fastbsmooth(derivative, SmoothWidth);
  h=figure(1);
  plot(x(PlotRange),derivative(PlotRange))
  figure(1);
  title('Interactive Derivative')
  text(.1.*length(x),.9.*Scale.*10^Exponent,derivativelabel);
  text(.1.*length(x),.8.*Scale.*10^Exponent,['Smooth Width = ' num2str(SmoothWidth) ])
 xlabel([ 'Derivative Order = ' num2str(Order) '   Smooth Width = ' num2str(SmoothWidth) '    Signal range= ' num2str(range(derivative(PlotRange))) ])
  h2=gca;
  if Order==0,
        axis([x(1) x(length(x)) -Scale/10.*10^Exponent Scale.*10^Exponent]);
  else
        axis([x(1) x(length(x)) -Scale.*10^Exponent Scale.*10^Exponent]);
  end