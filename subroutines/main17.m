function varargout = main17(varargin)
% MAIN17 M-file for main17.fig
%      MAIN17, by itself, creates a new MAIN17 or raises the existing
%      singleton*.
%
%      H = MAIN17 returns the handle to a new MAIN17 or the handle to
%      the existing singleton*.
%
%      MAIN17('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN17.M with the given input arguments.
%
%      MAIN17('Property','Value',...) creates a new MAIN17 or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before main17_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main17_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main17

% Last Modified by GUIDE v2.5 25-Aug-2008 15:26:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main17_OpeningFcn, ...
                   'gui_OutputFcn',  @main17_OutputFcn, ...
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


% --- Executes just before main17 is made visible.
function main17_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main17 (see VARARGIN)

% Choose default command line output for main17
handles.output = hObject;

%% basic initialization: image size, staring frame, number of frames.
clc;
path(path,'D:\Dyce main\common');
path(path,'D:\Dyce main\Dyce');
path(path,'D:\Dyce main\Dyce\1_RCA');
Nstart = 1; % default
set(handles.startingFrame,'String','15');
rect = [16 207 493 461]; %load CRI_margins;
N(1) = rect(3) - rect(1) + 1 ; % imagesize in one dimension
N(2) = rect(4) - rect(2) + 1;
N(3) = 100; %default
set(handles.numberOfFrames,'String',num2str(N(3)));

handles.rect = [1 1 N(2) N(1)];
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];

%% loads one mouse and puts one image just to look good.
handles.path = 'C:\Hillman_062607\DYCE Day 0\Mouse1 - first 150\';
[x, mouse, junk] = LoadCube(handles.path, rect, Nstart, N(3));
handles.mouse = mouse;
set(handles.pathStaticText,'String',[handles.path handles.mouse]);
handles.BW = EdgeFinder(x(:,:,N(3)-5));

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
handles.rollingRCAIndicator = 0;

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
        'rect',{[1 1 N(2) N(1)]},'leftFrame',{1},'rightFrame',{N(3)},'populated',{0},'timeSampled',{1:N(3)});
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
handles.organIndex = 1;
handles.currentSlide = 1;
handles.timeSampled = 1:handles.N(3);
set(handles.currentSlideNumber,'String',num2str(handles.currentSlide));
handles.choose = 1;
set(handles.chooseBox,'Value', 1);
set(handles.RCAwidth,'String','10');
set(handles.maxRepetitions,'String','10');
handles.CRIrect = [16 207 493 461]; %CRI margins;

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

% UIWAIT makes main17 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = main17_OutputFcn(hObject, eventdata, handles) 
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
% axes handles.line = ([X(i) X(i)],[0 profileMax]);
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
rect = round(getrect(handles.axes1));
N = handles.N;
if (rect(1) <= 0) || (rect(1) > N(2)) || ...
   (rect(2) <= 0) || (rect(2) > N(1)) || ...
   (rect(1) + rect(3) > N(2)) || ...
   (rect(2) + rect(4) > N(1))
    msgbox('ROI out of bounds');
    return;
end
handles.organs(handles.organIndex).rect = rect;
mouseX = rect(2) + rect(4)/2;
mouseY = rect(1) + rect(3)/2;
handles.organs(handles.organIndex).X = round(mouseX);
handles.organs(handles.organIndex).Y = round(mouseY);
if (handles.organs(handles.organIndex).populated == 0)
    handles.organs(handles.organIndex).populated = 1;
end
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);


% --- Executes on button press in leftFrame.
function leftFrame_Callback(hObject, eventdata, handles)
i = handles.organIndex;
handles.organs(i).leftFrame = handles.currentSlide;
set(handles.leftText,'String',handles.currentSlide);
handles.organs(i).populated = 1;
handles.timeSampled = handles.organs(i).leftFrame : handles.organs(i).rightFrame ;
update_Callback(handles.update,eventdata,handles);
guidata(hObject,handles);

% --- Executes on button press in rightFrame.
function rightFrame_Callback(hObject, eventdata, handles)
i = handles.organIndex;
handles.organs(i).rightFrame = handles.currentSlide;
set(handles.rightText,'String',handles.currentSlide);
handles.organs(i).populated = 1;
handles.timeSampled = handles.organs(i).leftFrame : handles.organs(i).rightFrame ;
update_Callback(handles.update,eventdata,handles);
guidata(hObject,handles);

%% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
%% this part updates axes1
axes(handles.axes1);
index = get(handles.show,'Value');
ROI1 = handles.ROI1;
ROI2 = handles.ROI2;
currentSlide = handles.currentSlide;
switch index
    case(1)
        if get(handles.scale,'Value') == 1
            imagesc(handles.x(ROI1,ROI2,currentSlide));
        else
            imagesc(handles.x(ROI1,ROI2,currentSlide),[handles.minScale,handles.maxScale]);
        end
    case(2)
        if get(handles.scale,'Value') == 1
            imagesc(handles.deriv(ROI1,ROI2,currentSlide));
        else
            imagesc(handles.deriv(ROI1,ROI2,currentSlide),[handles.minScale,handles.maxScale]);
        end
    case(3)
        if get(handles.scale,'Value') == 1
            imagesc(handles.deriv2(ROI1,ROI2,currentSlide));
        else
            imagesc(handles.deriv2(ROI1,ROI2,currentSlide),[handles.minScale,handles.maxScale]);
        end
    case(4)
        if get(handles.scale,'Value') == 1
            imagesc(handles.concat(ROI1,ROI2,currentSlide));
        else
            imagesc(handles.concat(ROI1,ROI2,currentSlide),[handles.minScale,handles.maxScale]);
        end
end

axis image off; 
colorbar; colormap(handles.colormap);

%% this part updates axes2
organIndex = handles.organIndex;
rect = handles.organs(organIndex).rect;
ROI1 = [rect(2):rect(2)+rect(4)-1];
ROI2 = [rect(1):rect(1)+rect(3)-1];

l = handles.organs(organIndex).leftFrame;
r = handles.organs(organIndex).rightFrame;
handles.timeSampled = l:r;

handles.organs(organIndex).array = zeros(1,handles.N(3));
handles.organs(organIndex).array(l:r) = shiftdim( mean(mean( ...
        handles.x(ROI1,ROI2,l:r),1),2),1);
handles.organs(organIndex).derivarray = zeros(1,handles.N(3));
handles.organs(organIndex).derivarray(l:r) = shiftdim( mean(mean( ...
        handles.deriv(ROI1,ROI2,l:r),1),2),1);

axes(handles.axes2);
value = get(handles.show,'Value');
clear temp;
switch value 
    case 1
        temp = handles.organs(handles.organIndex).array;
    case 2
        temp = handles.organs(handles.organIndex).derivarray;
    case 3
        temp = handles.organs(handles.organIndex).deriv2array;
    case 4
        temp = handles.organs(handles.organIndex).concatarray;
end
plot(temp);
%hold on;
line([handles.currentSlide  handles.currentSlide],[0 max(temp)*1.1],'LineStyle','--');

%handles.colormap = colormapEditBox(gray(round(str2double(get(hObject,'String')))));

%% this part updates organs info
s = [];
for i = 1:9
    s = str2mat(s,[handles.organs(i).name ' ' num2str(handles.organs(i).rect) '            p.' num2str(handles.organs(i).populated) ...
               '           T1: '  num2str(handles.organs(i).leftFrame) ' Tend: '  num2str(handles.organs(i).rightFrame) ]);
end
set(handles.organInfo,'String',s);

%% this part updates variable and organ list
c = fieldnames(handles);
s = CellArrayToString(sort(c));
set(handles.variableList,'String',s);

c = fieldnames(handles.organs);
s = CellArrayToString(sort(c));
set(handles.organVariableList,'String',s);
guidata(hObject,handles);

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
name = inputdlg('Enter the name for the mouse:');
if size(name) ~= 0
    organs = handles.organs;
    uisave('organs',[handles.path name{1} 'OrganList']);
end

% assignin('base',[name{1} 'OrganList'],handles.organs);

% fid = fopen([handles.path handles.mouse '.txt'],'w');
% 
% fprintf(fid,'%s\n',handles.path);
% 
% fprintf(fid,'name       populated    X    Y    rect    array\n');
% 
% for i = 1:9
%     fprintf(fid,'%s %3d %6.2f %6.2f %s %s\n',handles.organs(i).name,handles.organs(i).populated,...
%     handles.organs(i).X, handles.organs(i).Y, ...
%     num2str(handles.organs(i).rect), num2str(handles.organs(i).array));
% end
% fclose(fid);
% 
% msgbox(['File ' handles.path handles.mouse '.txt was created.         .']);

% --- Executes on button press in loadOrgans.
function loadOrgans_Callback(hObject, eventdata, handles)
%msgbox('under construction');
[filename, pathname] = uigetfile('*.mat','Select mat file with the organs info',handles.path);
load([pathname filename]);
%uiload(handles.path);
handles.organs = organs;%evalin('base','organs');
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);


% --- Executes on button press in playMovie.
function playMovie_Callback(hObject, eventdata, handles)

% section for making and displying the playMovie

for i = 1:handles.N(3)
    M(i) = im2frame(scale(round(handles.x(:,:,i)),1,handles.colormapSize), handles.colormap);
end
figure;
axis square off;
G = resizeMovie(M);
movie(G,1)
close;

% --- Executes on button press in findOrgans.
function findOrgans_Callback(hObject, eventdata, handles)

organList = handles.organList;
ForPresentation(organList, 'organs')
choose = inputdlg('Choose organ(s) to exclude:');
if size(choose,1) == 0  % when pressed the 'cancel button'
    return;
else 
    choose = str2num(choose{1});
    if size(choose,1) ~= 0   % when user typed in something  
        for k = 1:size(choose,2)
            organList(:,:,choose(k)) = 0;
        end
    end
end

M = size(organList,3);
if M < 5
    Composite(organList, handles.mouse, 0.4, [1,M]);
elseif M < 9
    Composite(organList, handles.mouse, 0.4, [2,4]);
elseif M < 17
    Composite(organList(:,:,1:8), handles.mouse, 0.4, [2,4]);
    Composite(organList(:,:,9:16), handles.mouse, 0.4, [2,4]);
end


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
function loadMouse_Callback(hObject, eventdata, handles, correct)
% hObject    handle to loadMouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% find which mouse is to be loaded
rect = handles.CRIrect;
N(1) = rect(3) - rect(1) + 1; % imagesize in one dimension
N(2) = rect(4) - rect(2) + 1;
Nstart = str2num(get(handles.startingFrame,'String'));
Nlength = str2num(get(handles.numberOfFrames,'String'));
N(3) = Nlength;

%% saves the old mouse organ data
 button = questdlg('Do you want to save data for the current mouse?  .');
if strcmp(button,'Yes')
    saveOrgans_Callback(handles.saveOrgans, eventdata, handles);
elseif strcmp(button,'Cancel')
    return;
end

%% loads the data 
rmfield(handles,'x');
if nargin == 4
    [x, mouse, pathname] = LoadCube(handles.path, rect, Nstart, Nlength);
else
    [filename, pathname] = uigetfile({'*.tif'},'Load cube','C:\Hillman_062607\DYCE Day 0\');
    [x, mouse, pathname] = LoadCube(pathname, rect, Nstart, Nlength);
end
if strcmp(mouse,'');
    msgbox('loading didn''t work');
    return;
end

%% updates handles
handles.mouse = mouse;
handles.path = pathname;
handles.N = N;
handles.x = x;
handles.deriv = zeros(N);
handles.deriv2 = zeros(N);
handles.timeSampled = 1:N(3);
handles.rect = [1 1 N(2) N(1)];
handles.ROI1 = [handles.rect(2) : handles.rect(2) + handles.rect(4) - 1];
handles.ROI2 = [handles.rect(1) : handles.rect(1) + handles.rect(3) - 1];
set(handles.pathStaticText,'String',[handles.path mouse]);

% handles.BW = EdgeFinder(handles.mouse);

%dir1 = 'D:\Dyce main\theBoxes\tiffs2\';
%rect = [1 1 N(2) N(1)];

%% clears organs' data for the new mouse
handles = clearOrgans(handles);
set(handles.organ_popup,'Value',1);

%% puts the first image
axes(handles.axes1);
set(handles.show,'Value',1);
imagesc(handles.x(:,:,1));
axis image off; colorbar off; colorbar(handles.colorbar);
set(handles.currentSlideNumber,'String','1');
handles.currentSlide = 1;
set(handles.slider,'Value',0);
update_Callback(hObject,eventdata,handles);
guidata(hObject,handles);


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
N = handles.N;
deltaSpace = round( str2double(get(handles.deltaSpace,'String'))); %delta determines spatialy
deltaTime = round( str2double(get(handles.deltaTime,'String'))); %delta determines spatialy
if isdir([handles.path 'deriv' num2str(deltaSpace) 'x' num2str(deltaTime)])
    Nstart = str2num(get(handles.startingFrame,'String'));
    Nlength = str2num(get(handles.numberOfFrames,'String')); 
    [handles.deriv, junk1, junk2] = LoadCube([handles.path 'deriv5x5\' ], [1 1 N(1) N(2)], Nstart, Nlength);
    msgbox('Derivatives loaded');
else
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
end

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
%            filename = 'raw';            
            for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.x(ROI1,ROI2,handles.timeSampled(i)), ...
                    0,handles.colormapSize-1, ...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'],'Compression','none')
            end
        case(2)
%            filename = 'deriv';
             for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.deriv(ROI1,ROI2,handles.timeSampled(i)), ...
                    0,handles.colormapSize-1, ...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'],'Compression','none')
            end
        case(3)
%            filename = 'deriv2';
             for i = 1:size(handles.timeSampled,2)
                waitbar(i/size(handles.timeSampled,2),h)
                imwrite(scale(handles.deriv2(ROI1,ROI2,handles.timeSampled(i)),...
                    0,handles.colormapSize-1,...
                    handles.minScale,handles.maxScale), ...
                    handles.colormap,[pathname filename '_' num2str(handles.timeSampled(i),'%03g') '.tif'],'Compression','none')
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

handles.organs = double_view(eventdata, handles);
guidata(hObject,handles);
update_Callback(hObject, eventdata, handles);

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
if strcmp(variable,'organs')
    index = get(handles.organVariableList,'Value');
    contents = get(handles.organVariableList,'String');
    variable = contents{index};
    currentOrgan = get(handles.organ_popup,'Value');
    assignin('base',variable,eval(['handles.organs(' num2str(handles.organIndex) ').' variable]));
else
    assignin('base',variable,eval(['handles.' variable]));
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
if strcmp(variable,'organs')
    index = get(handles.organVariableList,'Value');
    contents = get(handles.organVariableList,'String');
    variable = contents{index};
    currentOrgan = get(handles.organ_popup,'Value');
    %[organVariable num2str(currentOrgan)]
    %['handles.organs(' num2str(currentOrgan) ').' organVariable]
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
function axes1_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.

function axes2_CreateFcn(hObject, eventdata, handles)
% --- Executes on selection change in organVariableList.
function organVariableList_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function organVariableList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function deltaTime_Callback(hObject, eventdata, handles)

%% --- Executes during object creation, after setting all properties.
function deltaTime_CreateFcn(hObject, eventdata, handles)
set(hObject,'String','5');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% DataCursor
function dataCursor_Callback(hObject, eventdata, handles)
% hObject    handle to dataCursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.dataCursor,'Value') == 1
    datacursormode on;
else
    datacursormode off;
end

% 
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

sigma = round(str2double(get(handles.noiseLevel,'String'))); %delta determines spatialy 
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
%s = inputdlg('Enter the name of the variable to be saved');
%path = handles.path;
%s = [handles.path s{1}];
%s = s{1};
%organList = handles.organList;
%save(s,'organList');


%% RCA method will be applied on the cube that is selected in that moment,
%% and will used spatial and temporal ROIs indicated in the organ info list
function handles = rca_Callback(hObject, eventdata, handles)
% hObject    handle to rca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.rollingRCAIndicator
    l = handles.organs(handles.organIndex).leftFrame;
    r = handles.organs(handles.organIndex).rightFrame;
    handles.timeSampled = l:r;
end
timeSampled = handles.timeSampled;

value = get(handles.show, 'Value');
if isfield(handles,'organList') 
    handles = rmfield(handles,'organList');
end

componentsNumber = round( str2double(get(handles.componentsNumber,'String')));
i = 1;
choose = handles.choose;

j = 0; % in case when we choose organs, 'j' will count how many organs we have selected. 
       % At the end of the loop, 'j' will contain the total number of organs we have choosen.

numberOfPopulatedOrgans = 0; 
choosenOrganList =  zeros(handles.N(1),handles.N(2), 10);
while (i <= 9)
    if (handles.organs(i).populated == 1)
        numberOfPopulatedOrgans = numberOfPopulatedOrgans + 1;
        ROI1 = [handles.organs(i).rect(2): handles.organs(i).rect(2) + handles.organs(i).rect(4) - 1];
        ROI2 = [handles.organs(i).rect(1): handles.organs(i).rect(1) + handles.organs(i).rect(3) - 1];
        %timeSampled = handles.organs(i).leftFrame : handles.organs(i).rightFrame ;
        
        switch value
            case 1
                myTitle = ['RCA applied on raw images, frames - ' num2str(timeSampled(1)) ' to ' num2str(timeSampled(end))];
                organList = rca_function(handles.x(ROI1,ROI2,timeSampled), componentsNumber, choose);     
            case 2
                myTitle = ['RCA applied on derivative images, frames - ' num2str(timeSampled(1)) ' to ' num2str(timeSampled(end))];
                organList = rca_function(handles.deriv(ROI1,ROI2,timeSampled), componentsNumber, choose);
            case 3
                myTitle = ['deriv2, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.deriv2(ROI1,ROI2,timeSampled),componentsNumber, choose);
            case 4
                myTitle = ['concat, ' get(handles.deltaSpace,'String') 'x' get(handles.deltaTime,'String') ];
                organList = rca_function(handles.concat(ROI1,ROI2,timeSampled),componentsNumber, choose);
        end
        %close;
        if (size(organList,1) == 1 && size(organList,2) == 1)
            handles.organList = 0;
            return;
%             button = questdlg('Do you want to stop RCA');
%             if strcmp(button,'Yes')
%                 error('RCA stoped by the user');
%                 bool = 0;
%                 return;
%             end
        end
        %myTukeyWindow = MyTukey([size(organList,1), size(organList,2)],0.2);
        myTukeyWindow = ones(size(organList,1), size(organList,2));
        for k = 1 : size(organList, 3)
            organList(:,:,k) = organList(:,:,k).*myTukeyWindow;
        end
        
        if choose
            choosenOrganList(ROI1, ROI2, j + 1 : j + size(organList,3) ) = organList;
            j = j + size(organList, 3);
            ForPresentation(organList, myTitle);
            %close;
        else
            choosenOrganList(ROI1, ROI2, 1:size(organList,3)) = organList;
            ForPresentation(organList, myTitle);
        end
        
        %segment(organList);
    end
    i = i + 1;
end
if j == 0
    msgbox('Please choose organ(s)');
    return;
end
if (numberOfPopulatedOrgans == 1 && ~choose)
    handles.organList = organList;
else
    if j ~= 0
        choosenOrganList = choosenOrganList(:,:, 1:j);
        handles.organList = choosenOrganList;
        % ForPresentation(choosenOrganList, 'choosen organs');
    end
end
handles.myTitle = myTitle;    
guidata(hObject,handles);
update_Callback(handles.update, eventdata, handles);
if numberOfPopulatedOrgans == 0
    msgbox('Populate organs.');
end

% --- Executes on button press in rollingRCA.
function rollingRCA_Callback(hObject, eventdata, handles)
% hObject    handle to rollingRCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chooseBox,'Value',1);
handles.choose = 1;
handles.rollingRCAIndicator = 1;
frame1 = handles.organs(handles.organIndex).leftFrame;
frameEnd = handles.organs(handles.organIndex).rightFrame;
RCAwidth = str2double(get(handles.RCAwidth,'String'));
maxRepetitions = str2double(get(handles.maxRepetitions,'String'));

repetitions = frameEnd - RCAwidth + 1 - frame1;
repetitions = min(repetitions, maxRepetitions);
ratio = zeros(1,repetitions);
snr = zeros(1,repetitions);
beginning = round(linspace(frame1, frameEnd - RCAwidth + 1, repetitions));
ending = round(linspace(frame1 + RCAwidth - 1, frameEnd, repetitions));
organDynamics = zeros(handles.N(1), handles.N(2), repetitions);
organIndex = handles.organIndex;
myTitleList = '';
rawArrayList = handles.organs(organIndex).array;
derivArrayList = handles.organs(organIndex).derivarray;
timeSampledArray = zeros(2,repetitions);

for j = 1:repetitions
    handles.timeSampled = [beginning(j) : ending(j)];
    timeSampledArray(1,j) = beginning(j);
    timeSampledArray(2,j) = ending(j);
    guidata(hObject, handles);
    handles = rca_Callback(hObject, eventdata, handles);
    handles.timeSampled;
    if handles.organList == 0
        handles.rollingRCAIndicator = 0;
        guidata(hObject, handles);
        return;
    end
    [ratio(j), snr(j)] = getSNRAndRatio(handles.organList(:,:,1),handles.organList(:,:,2));
    myTitleList = str2mat(myTitleList, handles.myTitle);
    organDynamics(:,:,j) = handles.organList(:,:,2);
end
myTitleList = myTitleList(2:size(myTitleList,1),:);
handles.myTitleList = myTitleList;
variable = 'myTitleList';
assignin('base',variable,eval(['handles.' variable]));

handles.snr = snr;
variable = 'snr';
assignin('base',variable,eval(['handles.' variable]));

handles.ratio = ratio;
variable = 'ratio';
assignin('base',variable,eval(['handles.' variable]));

handles.organDynamics = organDynamics;
variable = 'organDynamics';
assignin('base',variable,eval(['handles.' variable]));

handles.rawArrayList = rawArrayList;
variable = 'rawArrayList';
assignin('base',variable,eval(['handles.' variable]));

handles.derivArrayList = derivArrayList;
variable = 'derivArrayList';
assignin('base',variable,eval(['handles.' variable]));

handles.timeSampledArray = timeSampledArray;
variable = 'timeSampledArray';
assignin('base',variable,eval(['handles.' variable]));
NicePresentation(organDynamics,myTitleList,timeSampledArray,rawArrayList,derivArrayList);

Pos(1);
plot(ratio);
title('ratio');
Pos(2);
plot(snr)
title('snr');
PresentOrganList(organDynamics,handles.myTitleList);
handles.rollingRCAIndicator = 0;
guidata(hObject,handles);

% l = handles.organs(organIndex).leftFrame;
% r = handles.organs(organIndex).rightFrame;
% handles.timeSampled = l:r;
% guidata(hObject, handles);

% --- Executes on button press in fullRCA.
function fullRCA_Callback(hObject, eventdata, handles)
% hObject    handle to fullRCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N = handles.N;
for i = 1:9
    handles.organs(i).rect = [1 1 N(2) N(1)];
    handles.organs(i).leftFrame = 1;
    handles.organs(i).rightFrame = N(3);
    handles.organs(i).timeSampled = 1:N(3);
    handles.organs(i).populated = 0;
end
handles.organs(1).populated = 1;
handles = rca_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function addNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to addNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function rightText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object deletion, before destroying properties.
function addNoise_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to addNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in saveAsAvi.
function saveAsAvi_Callback(hObject, eventdata, handles)
% hObject    handle to saveAsAvi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.show,'Value');
switch value 
    case 1
        M = makeMovie(handles.x);
    case 2
        M = makeMovie(handles.deriv);
    case 3
        M = makeMovie(handles.deriv2);
end
[filename, pathname] = uiputfile('*.avi', 'Save as',handles.path);
fps_cell = inputdlg('Enter the rate of the movie');
fps = str2num(fps_cell{1});
movie2avi(M,[pathname filename],'fps',fps);
 
%% --- Executes on button press in findStartingFrameButton.
function findStartingFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to findStartingFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% finds reference frame by fitting gaussian onto the absolute derivative projection of the whole cube;
% y = a*exp(b*(x-c).^2) + d.
if sum(handles.deriv(:)) == 0
    msgbox('Calulate derivatives first.');
    return;
end
value = str2num(get(handles.startingFrame,'String'));
if value ~= 1
    button  = questdlg(str2mat('Seem you have already found the starting frame?   .','Do you want to continue?'));
    if ~strcmp(button,'Yes')
       return;
    end
end
array = (abs(shiftdim( mean(mean( handles.deriv(handles.ROI1,handles.ROI2,1:handles.N(3)),1),2),1)))';

[fittedArray,fitParameters] = fitGaussian(array);
startingFrame = fitParameters.c;

set(handles.startingFrame,'String',num2str(round(startingFrame) - 15));


% --- Executes on button press in correct.
function correct_Callback(hObject, eventdata, handles)
% hObject    handle to correct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadMouse_Callback(hObject, eventdata, handles, 1);

% --- Executes on button press in loadBlobs.
function loadBlobs_Callback(hObject, eventdata, handles)
% hObject    handle to loadBlobs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% find which blob is to be loaded

rect = [1 1 100 100]; %blob margins
%rect = [1 1 1040 1392];
% rect = [113 51 113+90-1 51+178-1]; %kidney margins, one time only, doubt
% I'm gonna need it again

N(1) = rect(3) - rect(1) + 1; % imagesize in one dimension
N(2) = rect(4) - rect(2) + 1;
Nstart = str2num(get(handles.startingFrame,'String'));
Nlength = str2num(get(handles.numberOfFrames,'String'));
N(3) = Nlength;

% %% saves the old mouse organ data
%  button = questdlg('Do you want to save data for the current mouse?  .');
% if strcmp(button,'Yes')
%     saveOrgans_Callback(handles.saveOrgans, eventdata, handles);
% elseif strcmp(button,'Cancel')
%     return;
% end

%% loads the data 
rmfield(handles,'x');
[filename, pathname] = uigetfile({'*.tif'},'Load cube','C:\Hillman_062607\DYCE Day 0\');
[x, mouse, pathname] = LoadCube(pathname, [1 1 N(1) N(2)], Nstart, Nlength);
if strcmp(mouse,'');
    msgbox('loading didn''t work');
    return;
end
%% updates handles
handles.mouse = mouse;
handles.path = pathname;
handles.N = N;
handles.x = x;
handles.deriv = zeros(N);
handles.deriv2 = zeros(N);
handles.timeSampled = 1:N(3);
handles.rect = [1 1 N(2) N(1)];
handles.ROI1 = [handles.rect(2) : handles.rect(2) + handles.rect(4) - 1];
handles.ROI2 = [handles.rect(1) : handles.rect(1) + handles.rect(3) - 1];
set(handles.pathStaticText,'String',[handles.path mouse]);

%% clears organs' data for the new mouse
handles = clearOrgans(handles);
set(handles.organ_popup,'Value',1);

%% puts the first image
axes(handles.axes1);
set(handles.show,'Value',1);
imagesc(handles.x(:,:,1));
axis image off; colorbar off; colorbar(handles.colorbar);
set(handles.currentSlideNumber,'String','1');
handles.currentSlide = 1;
set(handles.slider,'Value',0);

guidata(hObject,handles);
update_Callback(hObject,eventdata,handles);


% --- Executes on button press in chooseBox.
function chooseBox_Callback(hObject, eventdata, handles)
% hObject    handle to chooseBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chooseBox

handles.choose = get(handles.chooseBox,'Value');
guidata(hObject,handles);
update_Callback(hObject,eventdata,handles);



function RCAwidth_Callback(hObject, eventdata, handles)
% hObject    handle to RCAwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RCAwidth as text
%        str2double(get(hObject,'String')) returns contents of RCAwidth as a double


% --- Executes during object creation, after setting all properties.
function RCAwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCAwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function maxRepetitions_Callback(hObject, eventdata, handles)
% hObject    handle to maxRepetitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxRepetitions as text
%        str2double(get(hObject,'String')) returns contents of maxRepetitions as a double


% --- Executes during object creation, after setting all properties.
function maxRepetitions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxRepetitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


