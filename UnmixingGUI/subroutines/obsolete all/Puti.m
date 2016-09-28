function PutImageAt(varargin)
%function Puti(X,myTitle,windowPosition,axisScale)
X = varargin{1};
myTitle = varargin{2};
windowPosition = varargin{3};
Pos(windowPosition);
if nargin == 3
   imagesc(X);
end

if nargin == 5
    text1 = varargin{4};
    var1 = varargin{5};
    if strcmp(text1, 'scale')
        imagesc(X, var1);
    elseif strcmp(text1, 'colorbar')
        imagesc(X);
        if strcmp(var1, 'on') 
            colorbar;
        end
    end
end

if nargin == 7
    text1 = varargin{4};
    var1 = varargin{5};
    text2 = varargin{6};
    var2 = varargin{7};
    
    if strcmp(text1, 'scale')
        imagesc(X, var1);
    elseif strcmp(text1, 'colorbar')
        imagesc(X);
        if strcmp(var1, 'on') 
            colorbar;
        end
    end
    
    if strcmp(text2, 'scale')
        imagesc(X, var2);
    elseif strcmp(text2, 'colorbar')
        imagesc(X);
        if strcmp(var2, 'on') 
            colorbar;
        end
    end
end

axis off image;
colormap(gray);
title(myTitle);