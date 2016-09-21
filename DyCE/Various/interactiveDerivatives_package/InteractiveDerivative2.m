function InteractiveDerivative2(n,h)
% Re-draws graph when Scale slider is changed
% Tom O'Haver, July 2006
global x
global signal
global derivative
global Exponent
global Order
global SmoothWidth
global Exponent
global Scale
Scale=10^n;
InteractiveDerivativeRedraw