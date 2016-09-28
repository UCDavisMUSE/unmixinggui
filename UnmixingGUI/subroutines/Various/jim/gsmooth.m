function I = gsmooth(I, sigma, dir, zero)
%  gsmooth - smooth a 2D image using a Gaussian filter
%  
%  gsmooth(I)        - smooth with Gaussian sigma = 1 pixel
%  gsmooth(I, sigma) - smooth with Gaussian of width sigma


%% ====================================================================
%% Copyright (c) 1995-2000 Michael Leventon.  
%%                         MIT AI Lab
%%                         All rights reserved.
%% 
%% Use of this source code is permitted with or without modification.
%% Distribution of this code must contain this header.
%% 
%% THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
%% WARRANTIES ARE DISCLAIMED.  
%% 
%% ====================================================================

I(isnan(I)) = 0;

if (nargin < 2), sigma = 1; end
if (isempty(sigma)), sigma = 1; end
sigma = sigma(1);
if (nargin < 3), dir = []; end
if (nargin < 4), zero = 0; end

if (sigma == 0), return; end

I = I - zero;

% maybe should be x = 0:100?
x = 0:200;

mask = exp(- 1/sigma/sigma * x.^2);
mask = mask / sum(mask);
% out = find(mask < 0.01);
thresh = 0.01 * max(mask)^3;
out = find(mask < thresh);
out = out(1)-1;
mask = [mask(out:-1:2) mask(1:out)];
mask = mask / sum(mask);
% plot(mask)

if (length(size(I)) == 2)
  if (isempty(dir))
    I = conv2(mask, mask, I, 'same');
  else
    perm = [2 1];
    for i = 1:2 
      I = permute(I, perm);
      if (~isempty(find(i == dir)))
        I(:,:) = conv2(mask, 1, I(:,:), 'same');
      end
    end
  end    
else
  ndim = length(size(I)) 
  perm = [ndim 1:ndim-1];
  for i = 1:ndim 
    I = permute(I, perm);
    I(:,:) = conv2(mask, 1, I(:,:), 'same');
  end
end

I = I + zero;
