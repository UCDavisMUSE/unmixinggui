% Creates a test signal, then calls InteractiveDerivative
% Tom O'Haver, July 2006
x=[0:1000];
noise=.01;
signal=5.*gaussian(x,length(x)/2,200)+noise.*randn(size(x));
InteractiveDerivative