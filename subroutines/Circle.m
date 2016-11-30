function I = circle(N1,N2,r)
%function I = circle(N1,N2,r);
%makes N1 x N2 matrix with r radius of a circle

if nargin < 3
    r = (min(N1,N2)-1)/2;
end

I = zeros(N1,N2);
xc = (N1+1)/2;
yc = (N2+1)/2;
for i=1:N1;
    for j=1:N2;
        if sqrt( ( i - xc )^2 + (j - yc )^2 ) < r
            I(i,j) = 1;
        end
    end
end