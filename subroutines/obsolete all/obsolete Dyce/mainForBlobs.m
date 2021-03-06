function varargout = mainForBlobs(varargin)
% MAINFORBLOBS M-file for mainForBlobs.fig
%      MAINFORBLOBS, by itself, creates a new MAINFORBLOBS or raises the existing
%      singleton*.
%
%      H = MAINFORBLOBS returns the handle to a new MAINFORBLOBS or the handle to
%      the existing singleton*.
%
%      MAINFORBLOBS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFORBLOBS.M with the given input arguments.
%
%      MAINFORBLOBS('Property','Value',...) creates a new MAINFORBLOBS or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before mainForBlobs_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainForBlobs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help mainForBlobs

% Last Modified by GUIDE v2.5 24-Jul-2008 11:53:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainForBlobs_OpeningFcn, ...
                   'gui_OutputFcn',  @mainForBlobs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainForBlobs is made visible.
function mainForBlobs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainForBlobs (see VARARGIN)

% Choose default command line output for mainForBlobs
handles.output = hObject;

%% basic initialization: image size, staring frame, number of frames.
clc;
Nstart = 10; % default
set(handles.startingFrame,'String','10');
rect = [16 207 493 461]; %load CRI_margins;
N(1) = rect(3)-rect(1)+1 ; % imagesize in one dimension
N(2) = rect(4)-rect(2)+1;
N(3) = 100; %default
handles.rect = [1 1 N(2) N(1)];
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];
set(handles.numberOfFrames,'String',num2str(N(3)));


%% path
dir1 = 'C:\Hillman_062607\DYCE Day 0\';
mouse = 'Mouse 12 ventral  rotated';
handles.mouse = mouse;
handles.path = [dir1 mouse '\'];
set(handles.pathStaticText,'String',[handles.path handles.mouse]);
%handles.BW = edgeFinder(mouse);
handles.BW = ones(N(1),N(2));

%% loads one mouse and puts one image just to look good.
x = zeros(N);
for i = 1:N(3)
    temp = double(imread( ...
        [dir1 mouse '\' mouse '_' num2str(Nstart + i -1,'%03g') '.tif']));
    x(:,:,i) = handles.BW.*temp(rect(1):rect(3),rect(2):rect(4));
end

axes(handles.axes1); imagesc(x(:,:,1)); colormap('gray'); colorbar('EastOutside'); axis image off;
handles.colorbar = 'EastOutside';

%% colormapEditBox

handles.colormapSize = 256;
handles.colormap = colormap(gray(handles.colormapSize));
set(handles.colormapEditBox,'String',num2str(handles.colormapSize));
set(handles.maxSlider,'Value',1);
set(handles.minSlider,'Value',0.5);
set(handles.scale,'Value',1);
handles.minScale = 0;
handles.maxScale = 4095;

%% assign to handles
%x = evalin('base','x'); 
handles.x = x;
handles.N = N;
handles.deriv = zeros(handles.N);
handles.deriv2 = zeros(handles.N);
handles.concat = zeros(handles.N);
handles.stdWidth = 11;
%% organs initialization
for i = 1:9
    handles.organs(i) = struct('name',{''},'array',{zeros(1,N(3))},'derivarray',{zeros(1,N(3))},'deriv2array',{zeros(1,N(3))},'concatarray',{zeros(1,2*N(3))},...
        'rect',{[1 1 N(2) N(1)]},'X',{1},'Y',{1},'leftFrame',{1},'rightFrame',{N(3)},'populated',{0},'timeSampled',{1:N(3)});
end
handles.organs(1).name = '1 - lungs       ';
handles.organs(2).name = '2 - Heart       ';
handles.organs(3).name = '3 - Brain       ';
handles.organs(4).name = '4 - Kidneys     ';
handles.organs(5).name = '5 - Liver       ';
handles.organs(6).name = '6 - Food        ';
handles.organs(7).name = '7 - Various1    ';
handles.organs(8).name = '8 - Various2    ';
handles.organs(9).name = '9 - Various3    ';


%% more initialization
handles.populated = 0;
handles.organIndex = 1;
handles.currentSlide = 1;
handles.timeSampled = 1:handles.N(3);
set(handles.currentSlideNumber,'String',num2str(handles.currentSlide));

% %% setting the right left controls
% set(handles.leftText,'String',num2str(handles.organs(handles.organIndex).leftFrame));
% set(handles.rightText,'String',num2str(handles.organs(handles.organIndex).rightFrame));

%assignin('base','organs',handles.organs);
update_Callback(handles.update,eventdata,handles);
set(handles.variableList,'Value',43);
set(handles.organVariableList,'Value',5);
set(handles.noiseLevel,'String','20');
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);

% UIWAIT makes mainForBlobs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = mainForBlobs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (se

% Get default command line output from handles structure
varargout{1} = handles.output;

%% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% determines the current slide position
slider_position = get(hObject,'Value');
currentSlide = round(handles.N(3)*slider_position);
set(handles.currentSlideNumber,'String',num2str(currentSlide));
handles.currentSlide = currentSlide;

% puts the image according to the slider position
update_Callback(handles.update, eventdata, handles);

guidata(hObject,handles);

%% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% --- Executes on button press in collect_point_pushbutton.
function collect_point_pushbutton_Callback(hObject, eventdata, handles)

%% determine the point coordinates
bool = true;
while bool 
    [mouseY, mouseX] = getpts(handles.axes1);
    if length(mouseX) ~= 1 
        msgbox('Chose only one point','Note','modal');
        clear mouseX mouseY
    else bool = false;
    end
end

%% updates array, derivarray and deriv2array
d = 0;
areaX = round(mouseX) - d: round(mouseX) + d;
areaY = round(mouseY) - d: round(mouseY) + d;

handles.organs(handles.organIndex).X = round(mouseX);
handles.organs(handles.organIndex).Y = round(mouseY);
handles.organs(handles.organIndex).array = shiftdim( mean(mean( handles.x(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
handles.organs(handles.organIndex).derivarray = shiftdim( mean(mean( handles.deriv(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
handles.organs(handles.organIndex).deriv2array = shiftdim( mean(mean( handles.deriv2(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
handles.organs(handles.organIndex).concatarray = shiftdim( mean(mean( handles.concat(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);

if (handles.organs(handles.organIndex).populated == 0)
    handles.organs(handles.organIndex).populated = 1;
    handles.populated = handles.populated + 1; 
end
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);

% --- Executes on selection change in organ_popup.
function organ_popup_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns organ_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organ_popup

handles.organIndex = get(hObject, 'Value');
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function organ_popup_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in collect_ROI_pushbutton.
function collect_ROI_pushbutton_Callback(hObject, eventdata, handles)

% determines the ROI region for the organ in the popup menu
% organIndex = handles.organIndex;

rect = round(getrect(handles.axes1));
handles.organs(handles.organIndex).rect = rect;
mouseX = rect(2) + rect(4)/2;
mouseY = rect(1) + rect(3)/2;

%% updates array, derivarray and deriv2array (copy-pasted from collect
%% point method)
areaX = round(mouseX) - 5: round(mouseX) + 5;
areaY = round(mouseY) - 5: round(mouseY) + 5;

handles.organs(handles.organIndex).X = round(mouseX);
handles.organs(handles.organIndex).Y = round(mouseY);
handles.organs(handles.organIndex).array = shiftdim( mean(mean( handles.x(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
handles.organs(handles.organIndex).derivarray = shiftdim( mean(mean( handles.deriv(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
handles.organs(handles.organIndex).deriv2array = shiftdim( mean(mean( handles.deriv2(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);
        handles.organs(handles.organIndex).concatarray = shiftdim( mean(mean( handles.concat(areaX,areaY, ...
            handles.organs(handles.organIndex).leftFrame : ...
            handles.organs(handles.organIndex).rightFrame ),1),2),1);

if (handles.organs(handles.organIndex).populated == 0)
    handles.organs(handles.organIndex).populated = 1;
    handles.populated = handles.populated + 1; 
end

guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);


% --- Executes on button press in leftFrame.
function leftFrame_Callback(hObject, eventdata, handles)
handles.organs(handles.organIndex).leftFrame = handles.currentSlide;
handles.organs(handles.organIndex).array(1:handles.currentSlide) = 0;
set(handles.leftText,'String',handles.currentSlide);
handles.organs(handles.organIndex).populated = 1;
update_Callback(handles.update,eventdata,handles);
guidata(hObject,handles);

% --- Executes on button press in rightFrame.
function rightFrame_Callback(hObject, eventdata, handles)
handles.organs(handles.organIndex).rightFrame = handles.currentSlide;
handles.organs(handles.organIndex).array(handles.currentSlide:handles.N(3)) = 0;
set(handles.rightText,'String',handles.currentSlide);
handles.organs(handles.organIndex).populated = 1;
update_Callback(handles.update,eventdata,handles);
guidata(hObject,handles);

%% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)

%% this part updates axes2
axes(handles.axes2);
value = get(handles.show,'Value');
switch value 
    case 1
        plot(handles.organs(handles.organIndex).array);
    case 2
        plot(handles.organs(handles.organIndex).derivarray);
    case 3
        plot(handles.organs(handles.organIndex).deriv2array);
    case 4
        plot(handles.organs(handles.organIndex).concatarray);
end

%handles.colormap = colormapEditBox(gray(round(str2double(get(hObject,'String')))));

%% this part updates organs info
s = [];
for i = 1:9
    if handles.organs(i).populated == 1
        timeSampled = cutArray(handles.organs(i).timeSampled, handles.organs(i).leftFrame, handles.organs(i).rightFrame);
    else
        timeSampled = handles.organs(i).timeSampled;
    end
    str = [handles.organs(i).name ' ' num2str(handles.organs(i).rect) '            p.' num2str(handles.organs(i).populated) ...
               '           T1: '  num2str(timeSampled(1)) ' Tend: '  num2str(timeSampled(end)) ];
%       '           T1: '  num2str(handles.organs(i).timeSampled(1)) '
%       Tend: '  num2str(handles.organs(i).timeSampled(end)) ];
    s = vertcat(s,[str blanks(80 - size(str,2))]);
end
set(handles.organInfo,'String',s);
%% this part updates axes1
axes(handles.axes1);
index = get(handles.show,'Value');
ROI1 = handles.ROI1;
ROI2 = handles.ROI2;
switch index
    case(1)
        if get(handles.scale,'Value') == 1
            imagesc(handles.x(ROI1,ROI2,handles.currentSlide));
        else
            imagesc(handles.x(ROI1,ROI2,handles.currentSlide),[handles.minScale,handles.maxScale]);
        end
    case(2)
        if get(handles.scale,'Value') == 1
            imagesc(handles.deriv(ROI1,ROI2,handles.currentSlide));
        else
            imagesc(handles.deriv(ROI1,ROI2,handles.currentSlide),[handles.minScale,handles.maxScale]);
        end
    case(3)
        if get(handles.scale,'Value') == 1
            imagesc(handles.deriv2(ROI1,ROI2,handles.currentSlide));
        else
            imagesc(handles.deriv2(ROI1,ROI2,handles.currentSlide),[handles.minScale,handles.maxScale]);
        end
    case(4)
        if get(handles.scale,'Value') == 1
            imagesc(handles.concat(ROI1,ROI2,handles.currentSlide));
        else
            imagesc(handles.concat(ROI1,ROI2,handles.currentSlide),[handles.minScale,handles.maxScale]);
        end
end

axis image off; colorbar; colormap(handles.colormap);

%% this part updates variable and organ list
c = fieldnames(handles);
s = cellArrayToString(sort(c));
set(handles.variableList,'String',s);

c = fieldnames(handles.organs);
s = cellArrayToString(sort(c));
set(handles.organVariableList,'String',s);


%% --- Executes on button press in colorbar_radio.
function colorbar_radio_Callback(hObject, eventdata, handles)
% hObject    handle to colorbar_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colorbar_radio
if get(hObject,'Value') == 1
    handles.colorbar = 'EastOutside';
else
    handles.colorbar = 'East';
end
axes(handles.axes1);
colorbar off;
colorbar(handles.colorbar);
guidata(hObject,handles);

% --- Executes on button press in saveOrgans.
function saveOrgans_Callback(hObject, eventdata, handles)
%assignin('base','organs',handles.organs);
fid = fopen([handles.path handles.mouse '.txt'],'w');

fprintf(fid,'%s\n',handles.path);

fprintf(fid,'name       populated    X    Y    rect    array\n');

for i = 1:9
    fprintf(fid,'%s %3d %6.2f %6.2f %s %s\n',handles.organs(i).name,handles.organs(i).populated,...
    handles.organs(i).X, handles.organs(i).Y, ...
    num2str(handles.organs(i).rect), num2str(handles.organs(i).array));
end
fclose(fid);

msgbox(['File ' handles.path handles.mouse '.txt was created.         .']);

% --- Executes on button press in loadOrgans.
function loadOrgans_Callback(hObject, eventdata, handles)
%msgbox('under construction');
handles.organs = evalin('base','organs');
handles.populated = 0;
for i = 1:size(handles.organs,2)
      handles.populated = handles.populated + handles.organs(i).populated;    
end
handles.populated
guidata(hObject,handles);

function G = resizeMovie(M,ROI)
% G = resizeMovie(M,ROI); resizes playMovie M for a factor of ROI

if nargin == 1
    zoom = floor(500/size(M(1).cdata,2));
end

G = M;
a = ones(zoom);
for i = 1:size(M,2)
    G(i).cdata = flipud(uint8(kron(double(M(i).cdata),double(a))));
end

% --- Executes on button press in playMovie.
function playMovie_Callback(hObject, eventdata, handles)

% section for making and displying the playMovie

for i = 1:handles.N(3)
    M(i) = im2frame(scale(round(handles.x(:,:,i)),1,handles.colormapSize,handles.minScale,handles.maxScale), handles.colormap);
end
%movie2avi(M,'film');
figure;
axis square off;
G = resizeMovie(M);
movie(G,1)
close;

% --- Executes on button press in findOrgans.
function findOrgans_Callback(hObject, eventdata, handles)

y = zeros(size(handles.x,1)*size(handles.x,2),size(handles.x,3));
for i = 1:handles.N(3) 
    temp = handles.x(:,:,i); 
    y(:,i) = temp(:); 
end

handles.mapRed = zeros(size(handles.colormap));
handles.mapGreen = zeros(size(handles.colormap));
handles.mapBlue = zeros(size(handles.colormap));
handles.mapRed(:,1) = handles.colormap(:,1);
handles.mapGreen(:,2) = handles.colormap(:,2);
handles.mapBlue(:,3) = handles.colormap(:,3);

i = 0;
j = 1;
while j<=size(handles.organs,2) 
    if handles.organs(j).populated == 1 
        i = i + 1;
        A(:,i) = (handles.organs(j).array)';
    end
    j = j + 1;
end
disp('handles.populated')
handles.populated

coeff = pinv(A)*y';

coeffReshaped = zeros(size(handles.x,1),size(handles.x,2),handles.populated);
h = figure;
set(h,'Position',[50 50 1800 1000]);



for i = 1:handles.populated;
    subplot(1,handles.populated + 1,i);
    switch i
        case 1
            handles.colormap = handles.mapRed;
        case 2 
            handles.colormap = handles.mapGreen;
        case 3 
            handles.colormap = handles.mapBlue;
        case 4
            handles.colormap = handles.mapRed + handles.mapGreen;
        case 5 
            handles.colormap = handles.mapGreen + handles.mapBlue;
        case 6 
            handles.colormap = handles.mapBlue + handles.mapRed;
    end
    coeffReshaped(:,:,i) = reshape(coeff(i,:),size(handles.x,1),size(handles.x,2));
    
    %for contours only
    subimage(250*uint8(coeffReshaped(:,:,i)/max(max(coeffReshaped(:,:,i)))),handles.colormap);
    
    %subimage(uint8(400*(coeffReshaped(:,:,i))),handles.colormap); %can be made better, but its working
    %image(200*coeffReshaped(:,:,i)); colormapEditBox(gray)
    axis image off;
    title(['comp ' num2str(i)]);
end
assignin('base','coeff',coeffReshaped);

subplot(1,handles.populated + 1,handles.populated + 1);
size(coeffReshaped)
image((coeffReshaped - min(coeffReshaped(:)))/max(coeffReshaped(:) - min(coeffReshaped(:))));
axis image off;
title('Components combined');
assignin('base','coeff',coeffReshaped);
guidata(hObject,handles);

% --- Executes on button press in clearOrgan.
function clearOrgan_Callback(hObject, eventdata, handles)

handles.organs(handles.organIndex).array = zeros(1,handles.N(3));
handles.organs(handles.organIndex).rect = [1 1 handles.N(2) handles.N(1)];
handles.organs(handles.organIndex).X = 1;
handles.organs(handles.organIndex).Y = 1;
handles.organs(handles.organIndex).leftFrame = 1;
handles.organs(handles.organIndex).rightFrame = handles.N(3);
handles.organs(handles.organIndex).populated = 0;

handles.organIndex = 1;
set(handles.organ_popup,'Value',1);

update_Callback(hObject,eventdata,handles);

guidata(hObject,handles);

% --- Executes on selection change in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns show contents as cell array
%        contents{get(hObject,'Value')} returns selected item from show

handles = scale_Callback(handles.scale, eventdata, handles);
update_Callback(handles.update,eventdata, handles);

% --- Executes on button press in standardDeviation.
function standardDeviation_Callback(hObject, eventdata, handles)
% hObject    handle to standardDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of standardDeviation


function stdWidth_Callback(hObject, eventdata, handles)
% hObject    handle to stdWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stdWidth as text
%        str2double(get(hObject,'String')) returns contents of stdWidth as a double

handles.stdWidth = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function stdWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stdWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'String','11');

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in loadMouse.
function loadMouse_Callback(hObject, eventdata, handles)
% hObject    handle to loadMouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% find which mouse is to be loaded
%dir1 = 'C:\Hillman_062607\DYCE Day 0\';
dir1 = 'D:\Dyce main\theBoxes\tiffs2\';
[filename, pathname, FILTERINDEX] = uigetfile({'*.tif'},'',dir1);
if pathname == 0 
    return
end

%contents = get(handles.mouseList,'String');
%mouse = contents{get(handles.mouseList,'Value')};
mouse = filename(1:size(filename,2)-8);
handles.path = pathname;
handles.mouse = mouse;

%% check and reports if the number of frames asked is too big

D = dir(handles.path);
lengthD = size(D,1) - 2;
imageTemp = double(imread([pathname D(10).name]));
N = size(imageTemp);
N(3) = min(str2num(get(handles.numberOfFrames,'String')),length(D));
Nstart = str2num(get(handles.startingFrame,'String'));

rect = [1 1 N(2) N(1)];
% rect = [16 207 493 461] ; %load CRI_margins;
N(1) = rect(3)-rect(1)+1 ; % imagesize in one dimension
N(2) = rect(4)-rect(2)+1 ;

if Nstart + N(3) -1 > lengthD
    msgbox(['There are only ' num2str(lengthD - 2,'%03g') ' images in the folder.            .';
            'Maximum number '                             ' of frames will be returned.         .']); 
    set(handles.numberOfFrames,'String',num2str(N(3)));
end

%% saves the old mouse organ data
button = questdlg('Do you want to save data for the current mouse?  .');
if strcmp(button,'Yes')
    saveOrgans_Callback(handles.saveOrgans, eventdata, handles);
elseif strcmp(button,'Cancel')
    return;
end

%% clears organs' data for the new mouse
for i = 1:9
    handles.organs(i).array = zeros(1,N(3));
    handles.organs(i).derivarray = zeros(1,N(3));
    handles.organs(i).deriv2array = zeros(1,N(3));
    handles.organs(i).concatarray = zeros(1,N(3));
    handles.organs(i).rect = [1 1 N(2) N(1)];
    handles.organs(i).X = 1;
    handles.organs(i).Y = 1;
    handles.organs(i).leftFrame = 1;
    handles.organs(i).rightFrame = N(3);
    handles.organs(i).populated = 0;
    handles.organs(i).timeSampled = 1:N(3); 
end
set(handles.organ_popup,'Value',1);
update_Callback(hObject,eventdata,handles);


%% loads the data 

%handles.BW = edgeFinder(handles.mouse);
%handles.BW = double(ones(handles.N(1),handles.N(2)));
rmfield(handles,'x');
for i = 1:N(3)
    temp = double(imread( ...
         [pathname mouse '_' num2str(Nstart + i - 1,'%03g') '.tif']));
    %x(:,:,i) = handles.BW.*temp(rect(1):rect(3),rect(2):rect(4));
    x(:,:,i) = temp(rect(1):rect(3),rect(2):rect(4));
    %x(:,:,i) = temp;
end

%% updates handles
handles.N = N;
handles.x = x;
handles.deriv = zeros(handles.N);
handles.deriv2 = zeros(handles.N);
handles.timeSampled = 1:handles.N(3);
handles.rect = [1 1 handles.N(2) handles.N(1)];
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];
set(handles.pathStaticText,'String',[handles.path handles.mouse]);


%% puts the first image
axes(handles.axes1);
set(handles.show,'Value',1);
imagesc(handles.x(:,:,1));
axis image off; colorbar off; colorbar(handles.colorbar);
currentSlide = 1;
set(handles.currentSlideNumber,'String',num2str(currentSlide));
handles.currentSlide = currentSlide;
set(handles.slider,'Value',0);

guidata(hObject,handles);


% --- Executes on selection change in mouseList.
function mouseList_Callback(hObject, eventdata, handles)
% hObject    handle to mouseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns mouseList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mouseList


% --- Executes during object creation, after setting all properties.
function mouseList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in findDerivatives.
function findDerivatives_Callback(hObject, eventdata, handles)
% hObject    handle to findDerivatives (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.deriv = zeros(handles.N);
handles.deriv2 = zeros(handles.N);
deltaSpace = round( str2double(get(handles.deltaSpace,'String'))); %delta determines spatialy 
deltaTime = round( str2double(get(handles.deltaTime,'String'))); %delta determines spatialy 
h = waitbar(0,'Finding derivatives ...');
temp = zeros(handles.N(3),1);
for i = deltaSpace + 1 : handles.N(1) - deltaSpace
    waitbar(i/handles.N(1),h)
    for  j = deltaSpace + 1 : handles.N(2) - deltaSpace
        if handles.BW(i,j) ~= 0
            temp = smooth ( shiftdim(mean(mean( ...
                handles.x( i - round((deltaSpace-1)/2) : i + round((deltaSpace-1)/2), ...
                j - round((deltaSpace-1)/2) : j + round((deltaSpace-1)/2), :) ,1),2),1) , deltaTime);
            temp1 = [0; diff(temp)];
            temp2 = [0; 0; diff(temp1)];
            for k = 1:handles.N(3)
                handles.deriv(i,j,k) = temp1(k);
                handles.deriv2(i,j,k) = temp2(k);
            end
        else
            handles.deriv(i,j,:) = 0;
            handles.deriv2(i,j,:) = 0;
        end
    end
end
%handles.concat = [ handles.x handles.deriv];
close(h)
guidata(hObject,handles);

% --- Executes on button press in ROI.
function ROI_Callback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.rect = round(getrect(handles.axes1));
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];
update_Callback(handles.update, eventdata, handles);
guidata(hObject,handles);

function startingFrame_Callback(hObject, eventdata, handles)

function startingFrame_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function numberOfFrames_Callback(hObject, eventdata, handles)

function numberOfFrames_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function A = scale(B,Bnewmin,Bnewmax,Bmin,Bmax)
% Scales image B from [Bmin,Bmax] to [0,n]
if nargin < 4
    Bmin = min(B(:));
    Bmax = max(B(:));
end
if Bmin == Bmax 
    A = ones(size(B)).*min(B(:)) + 1 ;
else
    A = Bnewmin + (Bnewmax-Bnewmin)*(B - Bmin)/(Bmax - Bmin);
end

function exportTiffs_Callback(hObject, eventdata, handles)
% hObject    handle to exportTiffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = scale_Callback(hObject, eventdata, handles);
h1 = msgbox({'tiffs ' num2str(handles.timeSampled) ' and ROI ' num2str(handles.rect)});
pos = get(h1,'Position');
set(h1,'Position',[pos(1)-50,pos(2)-50,pos(3)+50,pos(4)+20]);
uiwait(h1);
ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];

[filename, pathname] = uiputfile({'*.*'},'Save tifs as',handles.path);
if (size(pathname,2) ~= 1)
    h = waitbar(0,'Exporting tiffs ...');
    index = get(handles.show,'Value');
    switch index
        case(1)
            %         if (exist([handles.path 'tiff\raw'],'dir') == 0)
            %             mkdir([handles.path 'tiff\raw']);
            %         end
            %         name = 'raw';
            filename = 'raw';
            for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.x(ROI1,ROI2,handles.timeSampled(i)),...
                    0,handles.colormapSize-1, ...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'])
            end
        case(2)
            %         if (exist([handles.path 'tiff\deriv'],'dir') == 0)
            %             mkdir([handles.path 'tiff\deriv']);
            %         end
            %         name = 'deriv';
            filename = 'deriv';
             for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.deriv(ROI1,ROI2,handles.timeSampled(i)),...
                    0,handles.colormapSize-1,...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'])
            end
        case(3)
            %         if (exist([handles.path 'tiff\deriv2'],'dir') == 0)
            %             mkdir([handles.path 'tiff\deriv2']);
            %         end
            %         name = 'deriv2';
            filename = 'deriv2';
             for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.deriv2(ROI1,ROI2,handles.timeSampled(i)),...
                    0,handles.colormapSize-1,...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'])
             end
        case(4)
            %         if (exist([handles.path 'tiff\deriv2'],'dir') == 0)
            %             mkdir([handles.path 'tiff\deriv2']);
            %         end
            %         name = 'deriv2';
            filename = 'concat';
             for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.concat(ROI1,ROI2,handles.timeSampled(i)),...
                    0,handles.colormapSize-1,...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'])
            end
    end
    close(h)
end


% --- Executes during object creation, after setting all properties.
function currentSlideNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentSlideNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in doubleView.
function doubleView_Callback(hObject, eventdata, handles)
% hObject    handle to doubleView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.organs = main12_for_double_view(eventdata, handles);
guidata(hObject,handles);

function deltaSpace_Callback(hObject, eventdata, handles)
% hObject    handle to deltaSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaSpace as text
%        str2double(get(hObject,'String')) returns contents of deltaSpace as a double


% --- Executes during object creation, after setting all properties.
function deltaSpace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','5');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scale.
function handles = scale_Callback(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of scale

switch get(handles.show,'Value')
    case 1
        handles.minScale = min(min(min(handles.x)));
        handles.maxScale = max(max(max(handles.x)));
        set(handles.minSlider,'Value',(1/9000)*handles.minScale + 0.5);
        set(handles.maxSlider,'Value',(1/9000)*handles.maxScale + 0.5);
    case 2
        handles.minScale = min(min(min(handles.deriv)));
        handles.maxScale = max(max(max(handles.deriv)));
        set(handles.minSlider,'Value',(1/9000)*handles.minScale + 0.5);
        set(handles.maxSlider,'Value',(1/9000)*handles.maxScale + 0.5);
    case 3
        handles.minScale = min(min(min(handles.deriv2)));
        handles.maxScale = max(max(max(handles.deriv2)));
        set(handles.minSlider,'Value',(1/9000)*handles.minScale + 0.5);
        set(handles.maxSlider,'Value',(1/9000)*handles.maxScale + 0.5);
    case 4
        handles.minScale = min(min(min(handles.deriv2)));
        handles.maxScale = max(max(max(handles.deriv2)));
        set(handles.minSlider,'Value',(1/9000)*handles.minScale + 0.5);
        set(handles.maxSlider,'Value',(1/9000)*handles.maxScale + 0.5);
end
guidata(hObject,handles);
update_Callback(hObject, eventdata, handles);

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function colormapEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to colormapEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colormapEditBox as text
%        str2double(get(hObject,'String')) returns contents of colormapEditBox as a double

handles.colormap = colormap(gray(round(str2double(get(hObject,'String')))));
guidata(hObject,handles);

% --- Executes on slider movement.
function maxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to maxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.maxScale = (2*get(hObject,'Value')-1)*4095;
guidata(hObject,handles);

% --- Executes on slider movement.
function minSlider_Callback(hObject, eventdata, handles)
% hObject    handle to minSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hanldes.minScale = (2*get(hObject,'Value')-1)*4095;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function colormapEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormapEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function maxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ROIReset.
function ROIReset_Callback(hObject, eventdata, handles)
% hObject    handle to ROIReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROIReset

handles.rect = [1 1 handles.N(2) handles.N(1)];
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];
update_Callback(handles.update, eventdata, handles);
guidata(hObject,handles);

% --- Executes on button press in zoomOriginal.
function zoomOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
if get(hObject,'Value') == 0
    zoom off;
else
    zoom on;
end

% --- Executes on button press in saveVariable.
function saveVariable_Callback(hObject, eventdata, handles)
% hObject    handle to saveVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index = get(handles.variableList,'Value');
contents = get(handles.variableList,'String');
variable = contents{index};
if (variable == 'organs')
    index = get(handles.organVariableList,'Value');
    contents = get(handles.organVariableList,'String');
    variable = contents{index};
    currentOrgan = get(handles.organ_popup,'Value');
    assignin('base',[variable num2str(currentOrgan)],eval(['handles.organs(' num2str(currentOrgan) ').' variable]));
else
    assignin('base',[variable num2str(currentOrgan)],eval(['handles.' variable]));
end

% --- Executes on button press in loadVariable.
function loadVariable_Callback(hObject, eventdata, handles)
% hObject    handle to loadVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('needs some more work so be careful ... ');
contents = get(handles.variableList,'String');
index = get(handles.variableList,'Value');
variable = contents{index};
if (variable == 'organs')
    contents = get(handles.organVariableList,'String');
    index = get(handles.organVariableList,'Value');
    organVariable = contents{index};
    currentOrgan = get(handles.organ_popup,'Value');
    [organVariable num2str(currentOrgan)]
    ['handles.organs(' num2str(currentOrgan) ').' organVariable]
    eval(['handles.organs(' num2str(currentOrgan) ').' organVariable]) = evalin('base',[organVariable num2str(currentOrgan)]);
else
    eval(['handles.' variable]) = evalin('base',[variable num2str(currentOrgan)]);
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in variableList.
function variableList_Callback(hObject, eventdata, handles)
% hObject    handle to variableList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns variableList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variableList

% --- Executes during object creation, after setting all properties.
function variableList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variableList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox8


% --- Executes during object creation, after setting all properties.
function listbox8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2




% --- Executes on selection change in organVariableList.
function organVariableList_Callback(hObject, eventdata, handles)
% hObject    handle to organVariableList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns organVariableList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organVariableList


% --- Executes during object creation, after setting all properties.
function organVariableList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to organVariableList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function deltaTime_Callback(hObject, eventdata, handles)
% hObject    handle to deltaTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaTime as text
%        str2double(get(hObject,'String')) returns contents of deltaTime as a double


% --- Executes during object creation, after setting all properties.
function deltaTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

set(hObject,'String','5');

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in dataCursor.
function dataCursor_Callback(hObject, eventdata, handles)
% hObject    handle to dataCursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.dataCursor,'Value') == 1
    datacursormode on;
else
    datacursormode off;
end

% --- Executes on button press in rca.
function rca_Callback(hObject, eventdata, handles)
% hObject    handle to rca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path(path,'D:\Dyce main\gui\1_RCA');
value = get(handles.show, 'Value');
if isfield(handles,'organList') 
    handles = rmfield(handles,'organList');
end

componentsNumber = round( str2double(get(handles.componentsNumber,'String')));
i = 1;
j = 0;
%choosenOrgans = zeros(handles.N(1),handles.N(2),10);
while (i <= 9)
    if (handles.organs(i).populated == 1)
        ROI1 = [handles.organs(i).rect(2):handles.organs(i).rect(2)+handles.organs(i).rect(4)-1];
        ROI2 = [handles.organs(i).rect(1):handles.organs(i).rect(1)+handles.organs(i).rect(3)-1];
        timeSampled = handles.organs(i).timeSampled;
               
        switch value
            case 1
                title = ['raw, number of images - ' num2str(handles.N(3))];
                organList = rca_function(handles.x(ROI1,ROI2,timeSampled),componentsNumber,title);     
            case 2
                title = ['deriv, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.deriv(ROI1,ROI2,timeSampled),componentsNumber,title);
            case 3
                title = ['deriv2, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.deriv2(ROI1,ROI2,timeSampled),componentsNumber,title);
            case 4
                title = ['concat, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.concat(ROI1,ROI2,timeSampled),componentsNumber,title);
        end
        update_Callback(handles.update, eventdata, handles);

        choose = inputdlg('Choose frame(s):');
        if size(choose,1) == 0 
            return
        end
        choose = str2num(choose{1});
        for k = 1:size(choose,2)
            j = j + 1;
            choosenOrgans(ROI1,ROI2,j) = organList(:,:,choose(k));
        end
%         assignin('base','organList',handles.organList);
%         s = inputdlg('Enter the name of the variable to be saved');
%         if size(s) ~= 0 
%             s = [handles.path s{1}];
%             organList = handles.organList;
%             save(s,'organList');
%         end
    end
    i = i + 1;
end
assignin('base','choosenOrgans',choosenOrgans);

function componentsNumber_Callback(hObject, eventdata, handles)
% hObject    handle to componentsNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of componentsNumber as text
%        str2double(get(hObject,'String')) returns contents of componentsNumber as a double

% --- Executes during object creation, after setting all properties.
function componentsNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to componentsNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String','1');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in addNoise.
function addNoise_Callback(hObject, eventdata, handles)
% hObject    handle to addNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sigma = round( str2double(get(handles.noiseLevel,'String'))); %delta determines spatialy 
handles.x = handles.x + sigma *randn(handles.N); % adds white Gaussian noise to X
guidata(hObject, handles);
update_Callback(hObject, eventdata, handles);

function noiseLevel_Callback(hObject, eventdata, handles)
% hObject    handle to noiseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noiseLevel as text
%        str2double(get(hObject,'String')) returns contents of noiseLevel as a double


% --- Executes during object creation, after setting all properties.
function noiseLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in exportOrganList.
function exportOrganList_Callback(hObject, eventdata, handles)
% hObject    handle to exportOrganList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','organList',handles.organList);
s = inputdlg('Enter the name of the variable to be saved');
path = handles.path;
s = [handles.path s{1}];
%s = s{1};
organList = handles.organList;
save(s,'organList');


% --- Executes on button press in rollingRCA.
function rollingRCA_Callback(hObject, eventdata, handles)
% hObject    handle to rollingRCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile({'*.*'},'Save tifs as',handles.path);
if (size(pathname,2) ~= 1)
    path(path,'D:\Dyce main\gui\1_RCA');
    value = get(handles.show, 'Value');
    if isfield(handles,'organList')
        handles = rmfield(handles,'organList');
    end

    componentsNumber = 2;
    ROI1 = handles.ROI1
    ROI2 = handles.ROI2    

    h = waitbar(0,'Rolling RCA ...');
    for i = 1:5
        %waitbar(i/(handles.N(3)-1),h)
        waitbar(i/10,h)
        timeSampled = [10*i:10*i+9];
        switch value
            case 1
                title = ['raw, number of images - ' num2str(handles.N(3))];
                organList = rca_function(handles.x(ROI1,ROI2,timeSampled),componentsNumber,title);
            case 2
                title = ['deriv, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.deriv(ROI1,ROI2,timeSampled),componentsNumber,title);
            case 3
                title = ['deriv2, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.deriv2(ROI1,ROI2,timeSampled),componentsNumber,title);
            case 4
                title = ['concat, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.concat(ROI1,ROI2,timeSampled),componentsNumber,title);
        end
        imwrite(scale(organList(:,:,1),...
            0,handles.colormapSize-1, ...
            min(min(organList(:,:,1))),max(max(organList(:,:,1)))), ...
            handles.colormap,[pathname filename '_' num2str(i,'%03g') '_1.tif'])
        imwrite(scale(organList(:,:,2),...
            0,handles.colormapSize-1, ...
            min(min(organList(:,:,2))),max(max(organList(:,:,2)))), ...
            handles.colormap,[pathname filename '_' num2str(i,'%03g') '_2.tif'])
%         imwrite(scale(organList(:,:,3),...
%             0,handles.colormapSize-1, ...
%             min(min(organList(:,:,3))),max(max(organList(:,:,3)))), ...
%             handles.colormap,[pathname filename '_' num2str(i,'%03g') '_3.tif'])
%         imwrite(scale(organList(:,:,4),...
%             0,handles.colormapSize-1, ...
%             min(min(organList(:,:,4))),max(max(organList(:,:,4)))), ...
%             handles.colormap,[pathname filename '_' num2str(i,'%03g') '_4.tif'])
    end
end
close(h)

% --- Executes on button press in fullRCA.
function fullRCA_Callback(hObject, eventdata, handles)
% hObject    handle to fullRCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path(path,'D:\Dyce main\gui\1_RCA');
value = get(handles.show, 'Value');
if isfield(handles,'organList') 
    handles = rmfield(handles,'organList');
end

componentsNumber = round( str2double(get(handles.componentsNumber,'String')));
i = 1;
j = 1;
ROI1 = handles.ROI1;
ROI2 = handles.ROI2;
timeSampled = 1:handles.N(3);
switch value
    case 1
        title = ['raw, number of images - ' num2str(handles.N(3))];
        handles.organList = rca_function(handles.x(ROI1,ROI2,timeSampled),componentsNumber,title);
    case 2
        title = ['deriv, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
        handles.organList = rca_function(handles.deriv(ROI1,ROI2,timeSampled),componentsNumber,title);
    case 3
        title = ['deriv2, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
        handles.organList = rca_function(handles.deriv2(ROI1,ROI2,timeSampled),componentsNumber,title);
    case 4
        title = ['concat, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
        handles.organList = rca_function(handles.concat(ROI1,ROI2,timeSampled),componentsNumber,title);
end
update_Callback(handles.update, eventdata, handles);

assignin('base','organList',handles.organList);
s = inputdlg('Enter the name of the variable to be saved');
if size(s) ~= 0
    s = [handles.path s{1}];
    organList = handles.organList;
    save(s,'organList');
end

guidata(hObject,handles);

i = i + 1;