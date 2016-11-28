function createRectUsingROI(image,ROI,color)
% function createRectUsingROI(image,ROI,color)
if nargin < 3 
    color = [0 0.5 1];
end
% old code
% x = ROI(1);
% y = ROI(2);
% dx = ROI(3);
% dy = ROI(4);
% h = patch([y y+dy y+dy y],[x x x+dx x+dx],[1 0.5 0],'FaceColor','none','EdgeColor',color);
%puti(image,'',1);
figure(gcf);
x = ROI(2);
y = ROI(1);
dx = ROI(4);
dy = ROI(3);
h = patch([y y+dy y+dy y],[x x x+dx x+dx],[1 0.5 0],'FaceColor','none','EdgeColor',color);