clc;

h = fspecial('Gaussian',9,6);
[lp1,hp1] = lowPassHighPass(y1,h);
[lp2,hp2] = lowPassHighPass(y2,h);

[C1,D1] = FindFocusArea(hp1);
[C2,D2] = FindFocusArea(hp2);

%put(C1,'focus region of x1',3);
%put(C2,'focus region of x2',4);