function b = makeb(n,m,i,j)
% b = makeb(n,m,i,j)
%
%  n       = linear size of field.
%  m       = size of indicator
%  i,j     = location of pixel
%   
%  b       =  nxn matrix of zeros except in the mxm block 
%             with corner at (i,j).
%
%  Makes a field of all zeros except for an mxm block of ones with corner at
%  (i,j) 

% W. C. Karl 9/96

b=zeros(n,n);
c=ones(m,m);
b(i:i+m-1,j:j+m-1)=c;
