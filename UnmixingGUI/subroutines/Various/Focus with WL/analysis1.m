clc;

h = fspecial('Gaussian',9,6);

[C1,D1] = FindFocusArea(y1);
[C2,D2] = FindFocusArea(y2);

[lp1,hp1] = lowPassHighPass(C1,h);
[lp2,hp2] = lowPassHighPass(C2,h);



put(lp1,'focus region of x1',3);
put(lp2,'focus region of x2',4);