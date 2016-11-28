clc;
t = 0:0.01:10;
a = sin(t);
b = diff(a)./diff(t);
plot(t,a,t(1:size(t,2)-1),b)