clc;
a = [434, 12];
b = [1000 1003];

x1 = double(imread('image08.jpg'));
y1 = x1(a(2):b(2),a(1):b(1),1);
put(y1,'',1);

x2 = double(imread('image20.jpg'));
y2 = x2(a(2):b(2),a(1):b(1),1);
put(y2,'',2);