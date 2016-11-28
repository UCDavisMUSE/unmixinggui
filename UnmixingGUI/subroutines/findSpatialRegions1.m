% finding spatial regions for every component
% input: imageList
% output: comx,comy  - center of mass x (y)
%         mx,my  - maximum x,y
%a = makeb(100,10,10,10) + makeb(100,10,80,40);
%figure;
clc
close all
f1 = posf(1);
f2 = posf(2);
N = size(organList,3);
for i = 1:min(N,8)
    figure(f1);
    subplot(2,4,i);
    a = organList(:,:,i);
    [maks, mx, my] = findMaxInMatrix(a);
    
    imagesc(a);
    axis off image;
    colormap(gray)
    
    figure(f2);
    subplot(2,4,i);
    
    b = a.*(a > maks/2);
    %%b = kmeans(a,2);
    %b = hist(a(:),50);
    %plot(b(10:50));
    %colormap(gray);
    imagesc(b);
    axis off image;
    colormap(gray)
    
    [comx,comy] = centerOfMass(b);
    putCross(gcf,comx,comy,[0.5 1 1]);
end

f1 = posf(1);
f2 = posf(2);
for i = 9:10
    figure(f1);
    subplot(2,4,i-8);
    a = organList(:,:,i);
    [maks, mx, my] = findMaxInMatrix(a);
    imagesc(a);
    axis off image;
    colormap(gray)
    
    
    figure(f2);
    subplot(2,4,i-8);
    b = a.*(a > maks/2);
    %b = hist(a(:),50);
    %plot(b(10:50));
    %colormap(gray);
    imagesc(b);
    axis off image;
    colormap(gray)
    
    [comx,comy] = centerOfMass(b);
    putCross(gcf,comx,comy,[0.5 1 1]);
end
