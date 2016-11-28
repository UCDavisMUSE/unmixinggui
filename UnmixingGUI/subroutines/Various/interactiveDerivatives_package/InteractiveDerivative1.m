function InteractiveDerivative1(n,h)
% Re-draws graph when Smoothwidth slider is changed
% Tom O'Haver, July 2006
global x
global signal
global derivative
global Exponent
global Order
global SmoothWidth
global Exponent
global Scale
SmoothWidth=round(n);
InteractiveDerivativeRedraw