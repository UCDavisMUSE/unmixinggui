function putCross(x,y,fig,color,s)
% function putCross(x,y,fig,color,s)
% puts cross at the point (x,y) of figure fig. Default color is cyan [0.5 1 1], and
% default size s is 3x3 pixels
if nargin < 5
    s = 1;
end
if nargin < 4
    color = [0.5 1 1];
end
if nargin < 3
    fig = gcf;
end

figure(fig);
h1 = patch([y-s y+s],[x-s x+s],'w','LineWidth',2,'EdgeColor',color);
h2 = patch([y+s y-s],[x-s x+s],'w','LineWidth',2,'EdgeColor',color);