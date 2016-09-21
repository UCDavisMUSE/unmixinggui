function [lp,hp] = lowPassHighPass(y,h)
%h_lp = fspecial('gaussian',9,7);
lp = imfilter(y,h);
hp = y - lp;