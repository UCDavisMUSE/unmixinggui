function varargout = main19(varargin)
% MAIN19 M-file for main19.fig
%      MAIN19, by itself, creates a new MAIN19 or raises the existing
%      singleton*.
%
%      H = MAIN19 returns the handle to a new MAIN19 or the handle to
%      the existing singleton*.
%
%      MAIN19('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN19.M with the given input arguments.
%
%      MAIN19('Property','Value',...) creates a new MAIN19 or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before main19_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main19_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main19

% Last Modified by GUIDE v2.5 30-Aug-2008 05:17:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main19_OpeningFcn, ...
                   'gui_OutputFcn',  @main19_OutputFcn, ...
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


% --- Executes just before main19 is made visible.
function main19_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main19 (see VARARGIN)

% Choose default command line output for main19
handles.output = hObject;

%% basic initialization: image size, staring frame, number of frames.
clc;
path(path,'D:\Dyce main\DyCE');
Nstart = 1; 
set(handles.startingFrame,'String',num2str(Nstart));
rect = [16 207 493 461]; %load CRI_margins;
N(1) = rect(3) - rect(1) + 1 ; % imagesize in one dimension
N(2) = rect(4) - rect(2) + 1;
N(3) = 120; 
set(handles.numberOfFrames,'String',num2str(N(3)));

handles.rect = [1 1 N(2) N(1)];
handles.ROI1 = [handles.rect(2) : handles.rect(2) + handles.rect(4) - 1];
handles.ROI2 = [handles.rect(1) : handles.rect(1) + handles.rect(3) - 1];

%% loads one mouse and puts one image just to look good.
[filename, handles.path] = uigetfile({'*.tif'},'Load cube','C:\Hillman_062607\DYCE Day 0\');
[x, mouse, junk] = LoadCube(handles.path, rect, Nstart, N(3));
handles.mouse = mouse;
set(handles.pathStaticText,'String',[handles.path handles.mouse]);

% not a perfect way to find mouse edge but its working
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


%% assign to handles 
handles.x = x;
handles.N = N;
handles.deriv = zeros(N);

%% organs initialization
for i = 1:9
    handles.organs(i) = struct('name',{''},'array',{zeros(1,N(3))},'derivarray',{zeros(1,N(3))},'deriv2array',{zeros(1,N(3))},...
        'rect',{[1 1 N(2) N(1)]},'leftFrame',{1},'rightFrame',{N(3)},'populated',{0},'timeSampled',{1:N(3)});
end
handles.organs(1).name = '1 - Lungs       ';
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
handles.timeSampled = 1 : N(3);
set(handles.currentSlideNumber,'String',num2str(handles.currentSlide));
handles.choose = 0;
set(handles.chooseBox,'Value', handles.choose);
set(handles.RCAwidth,'String','10');
set(handles.maxRepetitions,'String','10');
handles.CRIrect = [16 207 493 461]; %CRI margins;
handles.rollingIndicator = 0;
set(handles.leftText,'String',num2str(handles.organs(handles.organIndex).leftFrame));
set(handles.rightText,'String',num2str(handles.organs(handles.organIndex).rightFrame));
set(handles.variableList,'Value',1);
set(handles.organVariableList,'Value',1);
set(handles.ROIindicator,'Value',1);
handles = loadDerivatives_Callback(hObject, eventdata, handles);
update_Callback(handles.update,eventdata,handles);
guidata(hObject,handles);
handles.tukeyIndicator = 1;
set(handles.tukey,'Value',handles.tukeyIndicator);

% --- Outputs from this function are returned to the command line.
function varargout = main19_OutputFcn(hObject, eventdata, handles) 
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
end
axis image off; 
colorbar; colormap(handles.colormap);

if get(handles.ROIindicator,'Value')
    rect = handles.organs(handles.organIndex).rect;
    x = rect(2);
    y = rect(1);
    dx = rect(4);
    dy = rect(3);
    h = patch([y y+dy y+dy y],[x x x+dx x+dx],[1 0.5 0],'FaceColor','none','EdgeColor',[1 0 0.5]);
end

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


value = get(handles.show,'Value');
switch value 
    case 1
        temp = handles.organs(handles.organIndex).array;
    case 2
        temp = handles.organs(handles.organIndex).derivarray;
end
axes(handles.axes2);
plot(temp);
line([handles.currentSlide  handles.currentSlide],[min(temp) max(temp)*1.1],'LineStyle','--');

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

organs = handles.organs;
uisave('organs',[handles.path handles.mouse 'OrganList']);

% --- Executes on button press in loadOrgans.
function loadOrgans_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile('*.mat','Select ''.mat'' file with the organs info',handles.path);
load([pathname filename]);
handles.organs = organs;
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
G = ResizeMovie(M);
movie(G,1)
close;

% --- Executes on button press in findOrgans.
function findOrgans_Callback(hObject, eventdata, handles)

organList = handles.organList;
hh = ForPresentation(organList, 'organs');
choose = inputdlg('Choose organ(s) to exclude (leave blank otherwise):');
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
close;

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
function handles = loadMouse_Callback(hObject, eventdata, handles, correct)
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
theText = ['All the data for the current mouse will be lost. Continue?'];
button = questdlg(textwrap({theText},25));
if ~strcmp(button,'Yes')
  return;
end

%% loads the data 
rmfield(handles,'x');
if nargin == 4
    % with correct button we don't need
    [x, mouse, pathname] = LoadCube(handles.path, rect, Nstart, Nlength); 
else
    % normal loading
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
handles = loadDerivatives_Callback(hObject, eventdata, handles);
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
handles.deriv = zeros(handles.N);
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
            end
        else
            handles.deriv(i,j,:) = 0;
        end
    end
end
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

handles.maxScale = (2*get(hObject,'Value')-1)*4095;
guidata(hObject,handles);
update_Callback(hObject,eventdata,handles);

% --- Executes on slider movement.
function minSlider_Callback(hObject, eventdata, handles)

handles.minScale = (2*get(hObject,'Value')-1)*4095;
update_Callback(hObject,eventdata,handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function colormapEditBox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function maxSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ROIReset.
function ROIReset_Callback(hObject, eventdata, handles)

handles.rect = [1 1 handles.N(2) handles.N(1)];
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];
update_Callback(handles.update, eventdata, handles);
guidata(hObject,handles);

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
    assignin('base',variable,eval(['handles.organs(' num2str(handles.organIndex) ').' variable]));
else
    assignin('base',variable,eval(['handles.' variable]));
end

% if you need to save variable in .mat use this:
% uisave('variable',[handles.path variable]);

% --- Executes on selection change in variableList.
function variableList_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function variableList_CreateFcn(hObject, eventdata, handles)

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

% --- Executes on button press in showRCAresults.
function showRCAresults_Callback(hObject, eventdata, handles)

hh = ForPresentation(handles.organList, ['Selected RCA components for ' num2str(handles.mouse) ...
    ', region ' num2str(handles.organs(handles.organIndex).name)]);

%% RCA method will be applied on the cube that is selected in that moment,
%% and will used spatial and temporal ROIs indicated in the organ info list
function handles = rca_Callback(hObject, eventdata, handles)

if ~handles.rollingIndicator
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
isAnyPopulated = 0;
while (i <= 9)
    if (handles.organs(i).populated == 1)
        numberOfPopulatedOrgans = numberOfPopulatedOrgans + 1;
        ROI1 = [handles.organs(i).rect(2): handles.organs(i).rect(2) + handles.organs(i).rect(4) - 1];
        ROI2 = [handles.organs(i).rect(1): handles.organs(i).rect(1) + handles.organs(i).rect(3) - 1];
        %timeSampled = handles.organs(i).leftFrame : handles.organs(i).rightFrame ;
        
        switch value
            case 1
                myTitle = ['RCA applied on raw images, region - ' ...
                    handles.organs(i).name ', frames - ' num2str(timeSampled(1)) ' to ' num2str(timeSampled(end))];
                organList = RcaFunction(handles.x(ROI1,ROI2,timeSampled), componentsNumber);     
            case 2
                myTitle = ['RCA applied on derivative images, region - ' ...
                    handles.organs(i).name ', frames - ' num2str(timeSampled(1)) ' to ' num2str(timeSampled(end))];
                organList = RcaFunction(handles.deriv(ROI1,ROI2,timeSampled), componentsNumber);
        end
        
        if get(handles.tukey,'Value')
            myTukeyWindow = MyTukey([size(organList,1), size(organList,2)],0.2);
        else
            myTukeyWindow = ones(size(organList,1), size(organList,2));
        end
        for k = 1 : size(organList, 3)
            organList(:,:,k) = organList(:,:,k).*myTukeyWindow;
        end
        
        if choose
            hh = ForPresentation(organList,'RCA components');
            chooseDefault = '1';
            chooseCell = inputdlg('For all, type ''all''. To skip, leave blank','Choose RCA components',1,{chooseDefault});
            chooseString = chooseCell{1}; % convert to string
            chooseNumber = str2num(chooseString); % conver to number
            if size(chooseNumber,1) ~= 0
                if strcmp(chooseString,'all') || strcmp(chooseString,'All')
                    chooseNumber = 1:size(organList,3);
                end
                for k = 1 : size(chooseNumber,2)
                    j = j + 1;
                    choosenOrganList(ROI1, ROI2, j : j - 1 + size(chooseNumber,2) ) = organList(:,:,chooseNumber(k));
                end
            end
            close(hh);
        else
            for k = 1:size(organList,3)
                choosenOrganList(ROI1, ROI2, k) = organList(:,:,k);
            end
            choosenOrganList = choosenOrganList(:,:, 1:size(organList,3));
            handles.organList = choosenOrganList;
            hh = ForPresentation(handles.organList, myTitle);
        end
        isAnyPopulated = 1;
    end
    i = i + 1;
end
if isAnyPopulated == 0
    msgbox('Please choose organ(s)');
    return;
end
if j ~= 0
    choosenOrganList = choosenOrganList(:,:, 1:j);
    handles.organList = choosenOrganList;
    if ~handles.rollingIndicator
        hh = ForPresentation(handles.organList, myTitle);       
    end 
end
handles.myTitle = myTitle;    
guidata(hObject,handles);
update_Callback(handles.update, eventdata, handles);


function rollingRCA_Callback(hObject, eventdata, handles)
set(handles.chooseBox,'Value',1);
handles.choose = 1;
handles.rollingIndicator = 1;
stopRolling = 0;
frame1 = handles.organs(handles.organIndex).leftFrame;
frameEnd = handles.organs(handles.organIndex).rightFrame;
RCAwidth = str2double(get(handles.RCAwidth,'String'));
maxRepetitions = str2double(get(handles.maxRepetitions,'String'));

repetitions = frameEnd - RCAwidth + 1 - frame1;
repetitions = min(repetitions, maxRepetitions);
% ratio = zeros(1,repetitions);
sbr = zeros(1,repetitions);
beginning = round(linspace(frame1, frameEnd - RCAwidth + 1, repetitions));
ending = round(linspace(frame1 + RCAwidth - 1, frameEnd, repetitions));
organDynamics = zeros(handles.N(1), handles.N(2), repetitions);
organIndex = handles.organIndex;
myTitleList = '';
rawArrayList = handles.organs(organIndex).array;
derivArrayList = handles.organs(organIndex).derivarray;
timeSampledArray = zeros(2,repetitions);
if isfield(handles,'organList')
    rmfield(handles,'organList');
end
for j = 1:repetitions
    update_Callback(hObject,eventdata,handles);
    handles.timeSampled = [beginning(j) : ending(j)];
    timeSampledArray(1,j) = beginning(j);
    timeSampledArray(2,j) = ending(j);
    guidata(hObject, handles);
    handles = rca_Callback(hObject, eventdata, handles);
    if ~isfield(handles,'organList')
        button = questdlg(textwrap({'Do you want to skip this one?'},25));
        if strcmp(button,'Yes')
            organDynamics(:,:,j) = 0;
            sbr(j) = 0;
            myTitleList = str2mat(myTitleList, handles.myTitle);
        else
            button1 = questdlg(textwrap({'Do you want to stop RCA?'},25));
            if strcmp(button1,'Yes')
                stopRolling = 1;
                guidata(hObject, handles);
            end
        end
    elseif size(image,3) > 1
        msgbox(textwrap({'You have choosen more then one component?'},25));
        stopRolling = 1;
    else
        component = handles.organList;
        [sbr(j), junk] = getSNR(component,0.4);
        myTitleList = str2mat(myTitleList, handles.myTitle);
        organDynamics(:,:,j) = component;
    end
    if stopRolling
        return;
    end
end
myTitleList = myTitleList(2:size(myTitleList,1),:);
handles.myTitleList = myTitleList;
handles.sbr = sbr;
handles.organDynamics = organDynamics;
variable = 'organDynamics';
assignin('base',variable,eval(['handles.' variable]));

Pos(2);
plot(sbr)
title('sbr');
PresentOrganList(organDynamics,handles.myTitleList);
handles.rollingIndicator = 0;
guidata(hObject,handles);

function fullRCA_Callback(hObject, eventdata, handles)
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

function rightText_CreateFcn(hObject, eventdata, handles)

function saveAsAvi_Callback(hObject, eventdata, handles)
value = get(handles.show,'Value');
switch value 
    case 1
        M = makeMovie(handles.x);
    case 2
        M = makeMovie(handles.deriv);
end
[filename, pathname] = uiputfile('*.avi', 'Save as',handles.path);
fps_cell = inputdlg('Enter the rate of the movie');
fps = str2num(fps_cell{1});
movie2avi(M,[pathname filename],'fps',fps);
 

function findStartingFrameButton_Callback(hObject, eventdata, handles)

% finds reference frame by fitting gaussian onto the absolute derivative projection of the whole cube;
% y = a*exp(b*(x-c).^2) + d.
if sum(handles.deriv(:)) == 0
    msgbox('Calulate derivatives first.');
    return;
end
value = str2num(get(handles.startingFrame,'String'));
if value ~= 1
    button  = questdlg(textwrap({'Seems you have already found the starting frame? Do you want to continue?'},25));
    if ~strcmp(button,'Yes')
       return;
    end
end
array = (abs(shiftdim( mean(mean( handles.deriv(handles.ROI1,handles.ROI2,1:handles.N(3)),1),2),1)))';

[fittedArray, fittedParameters] = FitGaussian(array);
startingFrame = round(fittedParameters.c) - 15;
set(handles.startingFrame,'String',startingFrame);
Nlength = str2num(get(handles.numberOfFrames,'String'));
NlengthOld = Nlength;
set(handles.numberOfFrames,'String',num2str( min(Nlength,120-startingFrame+1)));
Nlength = str2num(get(handles.numberOfFrames,'String'));

set(handles.startingFrame,'String',min(Nlength, startingFrame));
theText = ['Do you want to load a mouse with a new starting frame (' num2str(startingFrame) ')?'];
button = questdlg(textwrap({theText},25));

if strcmp(button,'Yes')
    if Nlength ~= NlengthOld
        msgbox(textwrap({[num2str(Nlength) ' images are going to be loaded.']},25));
    end
    handles = loadMouse_Callback(hObject, eventdata, handles, 1);
end
guidata(hObject,handles);

function loadBlobs_Callback(hObject, eventdata, handles)
% find which blob is to be loaded

rect = [1 1 100 100]; %blob margins

N(1) = rect(3) - rect(1) + 1; % imagesize in one dimension
N(2) = rect(4) - rect(2) + 1;
Nstart = str2num(get(handles.startingFrame,'String'));
Nlength = str2num(get(handles.numberOfFrames,'String'));
N(3) = Nlength;

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

function chooseBox_Callback(hObject, eventdata, handles)
handles.choose = get(handles.chooseBox,'Value');
guidata(hObject,handles);
update_Callback(hObject,eventdata,handles);

function RCAwidth_Callback(hObject, eventdata, handles)

function RCAwidth_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxRepetitions_Callback(hObject, eventdata, handles)

function maxRepetitions_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function saveDerivatives_Callback(hObject, eventdata, handles)
deriv = handles.deriv;
deltaSpace = get(handles.deltaSpace,'String'); %delta determines spatialy
deltaTime = get(handles.deltaTime,'String'); %delta determines spatialy
uisave('deriv',[handles.path handles.mouse 'deriv' deltaSpace 'x' deltaTime]);

function handles = loadDerivatives_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('*.mat','Select ''.mat'' file for derivatives', handles.path);
load([pathname filename]);
Nstart = str2num(get(handles.startingFrame,'String'));
Nlength = str2num(get(handles.numberOfFrames,'String'));
handles.deriv = deriv(:,:,Nstart:Nstart+Nlength-1);
guidata(hObject, handles);
update_Callback(handles.update, eventdata, handles);

function ROIindicator_Callback(hObject, eventdata, handles)
update_Callback(handles.update,eventdata,handles);

function tukey_Callback(hObject, eventdata, handles)



% --- Executes on selection change in RCAListbox.
function RCAListbox_Callback(hObject, eventdata, handles)
% hObject    handle to RCAListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns RCAListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RCAListbox


% --- Executes during object creation, after setting all properties.
function RCAListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCAListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveRCA.
function saveRCA_Callback(hObject, eventdata, handles)
% hObject    handle to saveRCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index = get(handles.RCAListbox,'Value');
switch index
    case 1
        ExportTiffs(handles.organList);
    case 2
        ExportTiffs(handles.organDynamics);
end
