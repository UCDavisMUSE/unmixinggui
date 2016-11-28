clc;
a = [434, 12];
b = [1100 1003];

x1 = imread('image08.jpg');
y1 = x1(a(2):b(2),a(1):b(1),1);
put(y1,'',1);

x2 = imread('image30.jpg');
y2 = x2(a(2):b(2),a(1):b(1),1);
put(y2,'',1);

%C1 = FindFocusArea(y1);
C2 = FindFocusArea(y2);

%put(C1,'focus of x1',3);
put(C2,'focus of x1',4);
