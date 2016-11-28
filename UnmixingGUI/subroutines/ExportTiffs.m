function exportTiffs( cube, s)
% function exportTiffs(cube, 'scaled' or 'nonscaled')
% Default is non-scaled.
%
% N. Bozinovic 08/19/08

if nargin < 2 
    s = 'nonscaled';
end
if ~( strcmp(s,'scaled') || strcmp(s,'nonscaled') )
    error('input can be ''scaled'' or ''nonscaled''.');
    return;
end
if strcmp(s,'nonscaled')
    mi = min(cube(:));
    ma = max(cube(:));
end
% function exportTiffs(cube)
N = size(cube);
map = colormap(gray(256));
[filename, pathname] = uiputfile({'*.*'},'Save tifs as');
if (size(pathname,2) ~= 1)
    h = waitbar(0,'Exporting tiffs ...');
    for i = 1:N(3)
        waitbar(i/N(3),h);
        if strcmp(s,'scaled') 
            imwrite( Scale( cube(:,:,i), 0, 256), map, [pathname filename '_' num2str(i,'%03g') '.tif']);
        end
        if strcmp(s,'nonscaled') 
            imwrite( Scale( cube(:,:,i), 0, 256, mi, ma), map, [pathname filename '_' num2str(i,'%03g') '.tif']);
        end
    end
    close(h);
end