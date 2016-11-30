%high pass filter
%function hp(image,sigma);
image = a(:,:,2);

sigma = 1;
N = size(image);
h = fspecial('Gaussian',N,sigma);
put(h,'',1)
h = h./max(h(:));
put(h,'',2)
h = 1-h;
put(h,'',3)
ft = fft2(image);
ftx = fftshift(ft).*h;
imageReconstructed = (ifft2(ftx)); 
%B = imfilter(a(:,:,2),h);
put(abs(imageReconstructed),'',4);
put(image,'',2);