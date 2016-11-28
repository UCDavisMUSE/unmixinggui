function varargout = LoadCube(varargin)
% function varargout = LoadCube(varargin)
% varargout = [cube, name, pathname];
% varargin = (pathname, rect, Nstart, Nlength);
% If any input is ommited function takes care of it.
%
% N.Bozinovic, 08/27/08

if nargin < 1
    [filename, pathname] = uigetfile({'*.tif'},'Load cube','C:\Hillman_062607\DYCE Day 0\');
    temp = double(imread([pathname filename]));
    rect = [1 1 size(temp,1) size(temp,2)];
    counter = HowManyTiffsInTheFolder(pathname);
    Nstart = 1;
    Nlength = min(counter,100);
elseif nargin == 1
    pathname = varargin{1};
    tiffStruct = LoadTiffsFromFolder(pathname,1,1);
    temp = double(imread([pathname tiffStruct(1).name]));
    rect = [1 1 size(temp,1) size(temp,2)];
    Nstart = 1;
    Nlength = HowManyTiffsInTheFolder(pathname);
elseif nargin == 2
    pathname = varargin{1};
    rect = varargin{2};
    Nstart = 1;
    Nlength = HowManyTiffsInTheFolder(pathname);
elseif nargin == 4
    pathname = varargin{1};
    rect = varargin{2};
    Nstart = varargin{3};
    Nlength = varargin{4};
    counter = HowManyTiffsInTheFolder(pathname);
    if Nlength > counter
        msgbox(textwrap({'There are not that many tiffs in the folder'},25));
        return;
    end   
end
tiffStruct = LoadTiffsFromFolder(pathname,Nstart,Nlength);
[cube, name] = LoadCubeFromStruct(pathname, tiffStruct, rect);

if nargout == 1
    varargout{1} = cube;
elseif nargout == 2
    varargout{1} = cube;
    varargout{2} = name;
elseif nargout == 3
    varargout{1} = cube;
    varargout{2} = name;
    varargout{3} = pathname;
end