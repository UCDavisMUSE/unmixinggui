function x = MyHann(N, bool)
%function x = MyHann(N, bool)
%
% Modified Hanning window of size N = [N(1),N(2)], bool is 1(0) for
% ascend(descend). Function is used in MyHann.m.
%
% N.Bozinovic
% 08/22/08

t = 0:N-1;
if bool 
    x = 1/2 * (1 - cos( pi * t / (N - 1)));
else
    x = 1 - 1/2 * (1 - cos( pi * t / (N - 1)));
end
x = x';