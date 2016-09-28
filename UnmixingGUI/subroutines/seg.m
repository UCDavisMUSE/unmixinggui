%% Detecting a Cell Using Image Segmentation
% An object can be easily detected in an image if the object has sufficient
% contrast from the background. We use edge detection and basic morphology
% tools to detect a prostate cancer cell.
%
% Copyright 2004 The MathWorks, Inc.


%% Step 1: Read image
function seg(image)
I = image;
subplot(1,2,1)
map = colormap(gray(256));
imagesc(I); title('original image');
colormap(gray);
axis image off
%colorbar

%% Step 2: Detect entire cell
% Two cells are present in this image, but only one cell can be seen in its
% entirety. We will detect this cell. Another word for object detection is
% segmentation. The object to be segmented differs greatly in contrast from
% the background image. Changes in contrast can be detected by operators
% that calculate the gradient of an image. One way to calculate the
% gradient of an image is the Sobel operator, which creates a binary mask
% using a user-specified threshold value.We determine a threshold value
% using the |graythresh| function. To create the binary gradient mask, we use
% the |edge| function.

BWs = edge(I, 'sobel', (graythresh(I)*3));
%figure, imshow(BWs), title('binary gradient mask');

%% Step 3: Dilate the image
% The binary gradient mask shows lines of high contrast in the image. These
% lines do not quite delineate the outline of the object of interest.
% Compared to the original image, you can see gaps in the lines surrounding
% the object in the gradient mask. These linear gaps will disappear if the
% Sobel image is dilated using linear structuring elements, which we can
% create with the |strel| function.

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

%%
% The binary gradient mask is dilated using the vertical structuring
% element followed by the horizontal structuring element. The |imdilate|
% function dilates the image.

BWsdil = imdilate(BWs, [se90 se0]);
%figure, imshow(BWsdil), title('dilated gradient mask');

%% Step 4: Fill interior gaps 
% The dilated gradient mask shows the outline of the cell quite nicely, but
% there are still holes in the interior of the cell. To fill these holes we
% use the imfill function.

BWdfill = imfill(BWsdil, 'holes');
%figure, imshow(BWdfill);
%title('binary image with filled holes');

%% Step 6: Remove connected objects on border
% The cell of interest has been successfully segmented, but it is not the
% only object that has been found. Any objects that are connected to the
% border of the image can be removed using the imclearborder function. The
% connectivity in the imclearborder function was set to 4 to remove
% diagonal connections.

BWnobord = imclearborder(BWdfill, 4);
%figure, imshow(BWnobord), title('cleared border image');

%% Step 7: Smoothen the object
% Finally, in order to make the segmented object look natural, we smoothen
% the object by eroding the image twice with a diamond structuring element.
% We create the diamond structuring element using the |strel| function.

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
subplot(1,2,2)
subimage(BWfinal), title('segmented image');
axis off image
%%
% An alternate method for displaying the segmented object would be to place
% an outline around the segmented cell. The outline is created by the
% |bwperim| function.

% BWoutline = bwperim(BWfinal);
% Segout = I; 
% Segout(BWoutline) = 255; 
% figure, imshow(Segout), title('outlined original image');
