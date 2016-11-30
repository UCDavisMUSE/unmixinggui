XI = 6;
YI = 6;
mask = Makeb(10,3,2,7);
Puti(mask,'',1);
PutCross(XI,YI);

[X,Y] = ConvertContourToVector(mask);
TRI = delaunay(X,Y);
K = dsearch(X,Y,TRI,XI,YI);
PutCross(X(K),Y(K));