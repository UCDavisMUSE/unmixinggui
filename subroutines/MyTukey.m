function w = MyTukey( N, delta)
% function w = MyTukey( N, delta)
%
% Creates modified Tukey window of size N = [N(1), N(2)], with 'delta' percentage
% (default 10% = 0.1) of the edges tapered. Function uses modifies Hanning
% function as well.
%
% N.Bozinovic, 08/22/08
% credits Matlab

if nargin < 2
    delta = 0.2;
end
%%
n = N(1);
m = N(2);
w1 = [ MyHann(round(delta*n),1);  ones(n - 2*round(delta*n),1); MyHann(round(delta*n),0)];
w2 = [ MyHann(round(delta*m),1);  ones(m - 2*round(delta*m), 1); MyHann(round(delta*m),0)];

ww1 = w1*ones(1,m);
ww2 = ones(n,1)*w2';
w = ww1 .* ww2;
% PutImageAt(ww1,'',1)
% PutImageAt(ww2,'',1)

% PutImageAt(ww1.*ww2,'',1)
% Pos(2)
% mesh(ww1.*ww2)

