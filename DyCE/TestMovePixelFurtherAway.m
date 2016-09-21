N = [10,10];
x1 = 7;
y1 = 8;
x2 = 6;
y2 = 6;

[newX,newY] = MovePixelFurtherAway([x1,y1],[x2,y2],N);
%newX = pixel(1);
%newY = pixel(2);
Puti(makeb(N(1),1,x1,y1) + makeb(N(1),1,x2,y2),'',1)
Puti(makeb(N(1),1,x1,y1) + makeb(N(1),1,x2,y2) +makeb(N(1),1,newX,newY),'',2)
