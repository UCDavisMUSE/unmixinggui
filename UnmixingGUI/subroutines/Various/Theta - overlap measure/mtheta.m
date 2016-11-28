clc;
N = 200;
M = 100;
t = 1:N;

sigma1 = 5;
c1 = -20;
x1 = fspecial('Gaussian',[1 M], sigma1);
y1 = zeros(1,N);
y1(N/2+c1 - M/2: N/2+c1+M/2 -1) = x1;
y1 = y1./max(y1);
j = 0;
clear theta
for i = 60:20:140
    sigma2 = 10;
    c2 = i-M;
    x2 = fspecial('Gaussian',[1 M], sigma2);
    y2 = zeros(1,N);
    y2(N/2+c2 - M/2: N/2+c2+M/2 -1) = x2;
    y2 = y2./max(y2);
    j = j+1;
    subplot(2,5,j);
    plot(t,y1,t,y2,'r');
    axis off
    theta(j) = acos(y1*y2'/(norm(y1)*norm(y2)));
    title( num2str(theta(j)));
end
subplot(5,2,[6:10]);
stem(theta);
axis([0.7 5.3 0 2])


