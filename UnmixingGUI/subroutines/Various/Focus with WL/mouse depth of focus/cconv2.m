function z=cconv2(x,y,N1,N2);
%circular convolution using fft2
%x and y are matrices
z=abs(ifft2(fft2(x,N1,N2).*fft2(y,N1,N2)));