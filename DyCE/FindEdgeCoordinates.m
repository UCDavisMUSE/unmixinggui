clc;
close all
bw = edge(a);
k = 0;
clear X Y
for i = 1:N(1)
    for j = 1:N(2)
        if bw(i,j) == 1
            k = k + 1;
            X(k) = i;
            Y(k) = j;
        end
    end
end
clear K
K = convhull(X,Y);
temp = zeros(size(bw));
temp1 = zeros(size(bw));
for i = 1:size(K,1)
    temp(X(K(i)),Y(K(i))) = 1;
%     if i ~= size(K,1)
%         line([ X(K(i)) X(K(i+1))],[ Y(K(i)) Y(K(i+1))]);
%         hold on
%     end
end
% de = zeros(zeros(size(bw)));
% de = delaunay(X(K),Y(K));
%puti( fill(X(K),Y(K), [ 1 0 1]) ,'',1);
%%
puti(temp,'',1);
pos(2);
fill(X(K),Y(K), [ 1 0 1]);
axis image
pos(3)
pArea = polyarea(X(K),Y(K));
pos(4)
plot(X(K),Y(K));
axis image
%%
xx = 1:N(1);
yy = 1:N(2);
[XX,YY] = meshgrid(xx,yy);
IN = inpolygon(YY,XX,X(K),Y(K));
puti(IN,'',1);
