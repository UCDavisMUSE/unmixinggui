function colorPresentation(imageList,mouseEdge);
MyMaps;
Posf(2);
N = size(imageList);
% makes sure that method doesn't crash if 'imageList' containes only one
% image
if length(N) == 2 
   N(3) = 1;
end

%% plots organs in different colors
for i = 1:N(3)  
    %for contours only
    %subimage(250*uint8(coeffReshaped(:,:,i)/max(max(coeffReshaped(:,:,i)))),map);
    subplot(2,4,i);
     switch i
        case 1
            myMap = mapBlue;
        case 2 
            myMap = mapGreen;
        case 3 
            myMap = mapRed;
        case 4
            myMap = mapBlue;
        case 5 
            myMap = mapGreen;
        case 6 
            myMap = mapRed;
        case 7
            myMap = mapBlue;
        case 8 
            myMap = mapGreen;
     end
    if max(max(imageList(:,:,i))) > eps 
        temp = round(250*imageList(:,:,i)/max(max(imageList(:,:,i))));
    else
        temp = zeros(N(1),N(2));
    end
    
    subimage(temp,myMap);
    axis image off;
    title(['Component ' num2str(i)]);
end

%% finds and plots the composit image. Composite image is RGB image 
% this way of having only three colors is the only way I've found so far

% swapImages
temp = imageList(:,:,1);
imageList(:,:,1) = imageList(:,:,3);
imageList(:,:,3) = temp;

% adds them up
composite = zeros(N(1),N(2),3);
for i = 1:N(3)
    composite(:,:,mod(i-1,3)+1) = composite(:,:,mod(i-1,3)+1) + Scale(imageList(:,:,i),0,1);
end
% scale all R, G and B components from 0 to 0.8
% the rest of 0.2 will be used for the mouse edge.
composite = scale(composite,0,0.8);

% adds the edge if asked
if nargin == 2
    for i = 1:3
        composite(:,:,i) = composite(:,:,i) + 0.2*mouseEdge;
    end
end

% plots the composit image
subplot(2,4,8);
image(composite);
axis image off;
title('Composite');

Posf(2);
image(composite);
axis image off;
title('Composite');




