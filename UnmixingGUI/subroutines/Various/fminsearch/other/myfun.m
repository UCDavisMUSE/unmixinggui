
% a = x(1);
% b = x(2);


banana = @(x)100*(x(2)-x(1)^2)^2+(1-x(1))^2;
[x,fval] = fminsearch(banana,[-1.2, 1])

% t1 = -200:10:300;
% t2 = -20000:1000:50000;
% [x1,x2] = meshgrid(t1,t2);
% ban = 100*(x2 - x1.^2).^2 + (1 - x1).^2;
% mesh(x1,x2,ban)