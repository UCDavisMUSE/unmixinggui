% finding spatial regions for every component
% input: imageList
% output: comx,comy  - center of mass x (y)
%         mx,my  - maximum x,y
%a = makeb(100,10,10,10) + makeb(100,10,80,40);
%figure;
clc
close all
posf(1)
N = size(organList,3);
for i = 1:min(N,8)
    subplot(2,4,i);
    a = organList(:,:,i);
    imagesc(a);
    axis image off
    colormap gray
    [junk,mx,my] = findMaxInMatrix(a);
    ROI = findRectAroundPoint(a,mx,my);
    
    [comx,comy] = centerOfMass(a);
    putCross(gcf,comx,comy,[0.5 1 1]);%old center of mass
    
    [comx,comy] = centerOfMass(a(ROI(1):ROI(1)+ROI(3)-1,ROI(2):ROI(2)+ROI(4)-1));
    comx = comx + ROI(1); % new center of mass
    comy = comy + ROI(2);
    putCross(gcf,comx,comy,[1 0.5 1]);
    ROI = findRectAroundPoint(a,comx,comy);
    createRectUsingROI(a,ROI);
    putCross(gcf,mx,my,[1 1 0.5]);
    
end
posf(2)
if N > 8
    for i = 9:N
        subplot(2,4,i-8);
        a = organList(:,:,i);
        imagesc(a);
        axis image off
        colormap gray
        [junk,mx,my] = findMaxInMatrix(a);
        ROI = findRectAroundPoint(a,mx,my);

        [comx,comy] = centerOfMass(a);
        putCross(gcf,comx,comy,[0.5 1 1]);%old center of mass

        [comx,comy] = centerOfMass(a(ROI(1):ROI(1)+ROI(3)-1,ROI(2):ROI(2)+ROI(4)-1));
        comx = comx + ROI(1); % new center of mass
        comy = comy + ROI(2);
        putCross(gcf,comx,comy,[1 0.5 1]);
        ROI = findRectAroundPoint(a,comx,comy);
        createRectUsingROI(a,ROI);
        putCross(gcf,mx,my,[1 1 0.5]);
    end
end
