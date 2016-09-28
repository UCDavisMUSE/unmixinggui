function rect1 = flipROI(rect,N)
rect1 = rect;
rect1(2) = N(1) - rect(2) - rect(4);