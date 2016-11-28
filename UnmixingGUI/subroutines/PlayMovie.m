function PlayMovie( mov, position)
% function PlayMovie(mov)
%
% N. Bozinovic, 08/19/08
if nargin < 2
    position = 2;
end

handle = Posf(position);
movie( handle, mov, 1, 15, [200 200 0 0]);
close(handle);