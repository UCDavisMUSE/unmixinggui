function M = MakeMovie( varargin)
% function M = MakeMovie( cube),
% or,
% function M = MakeMovie( cube, 'Scale', 'on').
% 
% Set scale 'off' if you want all images to be with the same grayscale
% (default).
% Switch it 'on' if you want every frame to have maximal contrast (good only
% for presentation not for quantitative things).
% 
% Use it together with movie2avi( M, title, 'fps', 15);
%
% N. Bozinovic, 08/18/08

% codec used here can have grayscale size up to 236, according to Matlab
myMap = colormap(gray(236));

cube = varargin{1};
if nargin == 1
    scaleIndicator = 'on';
elseif  nargin == 3
    scaleText = varargin{2};
    scaleIndicator = varargin{3};
else
    error(['Number of input arrguments should be 1 or 3.' ...
    ' Usage: function M = MakeMovie( cube),' ...
    ' or, function M = MakeMovie( cube, ''Scale'', ''off'') ']);
end

N = size(cube);

cubeMax = max(cube(:));
cubeMin = min(cube(:));
if strcmp(scaleIndicator,'on')
   %scaled
   x = Scale(cube, 1, 236);
else
   %non-scaled
   x = Scale(cube, 1, 236, cubeMin, cubeMax);
end

for i = 1:N(3)
    % M(i) = im2frame(flipud(x(:,:,i)),myMap);
     M(i) = im2frame( x(:,:,i), myMap);
end

% play movie
% figure;
% axis square off;
% %G = resizeMovie(M);
% movie(M,1)
% close;