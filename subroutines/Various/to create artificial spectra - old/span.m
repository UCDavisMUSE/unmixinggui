function x = span(box1,n1,n2);

N = 30; % picture size
n = 100; % numberOfImages
t = (1:n);

x = zeros(N,N,n);

mid = (n1+n2)/2;
A = [n1^2 n1 1; mid^2 mid 1 ; n2^2 n2 1];
b = [0;1;0];
alpha = inv(A)*b;

intensity = zeros(1,n);
intensity = alpha(1)*t.^2 + alpha(2)*t + alpha(3);
intensity(1:n1) = 0;
intensity(n2:n) = 0;
plot(t,intensity);
for i = n1+1:n2-1
    x(:,:,i) = intensity(i).*box1;
end