function I = Gauss(offsetx,offsety,sigma)
% I = Gauss(offsetx,offsety,sigma) outputs Gaussians with given offset and
% sigma
if nargin < 3 sigma = 3; end
x = fspecial('Gaussian',[15,15],sigma);
%put(x,'',1)
I = zeros(30,30);
I(9+offsetx:15+8+offsetx,9+offsety:15+8+offsety) = x;
%put(I,'',1)