function y = slideStd(x,n);
N = size(x,2);
y = zeros(size(x));
d = round(n/2) - 1;

for i = d + 1: N - d
    y(i) = std(x(i - d : i + d));
end