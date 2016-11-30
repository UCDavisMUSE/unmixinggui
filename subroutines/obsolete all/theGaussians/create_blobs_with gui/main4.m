function varargout = main3(varargin)
% MAIN3 M-file for main3.fig
%      MAIN3, by itself, creates a new MAIN3 or raises the existing
%      singleton*.
%
%      H = MAIN3 returns the handle to a new MAIN3 or the handle to
%      the existing singleton*.
%
%      MAIN3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN3.M with the given input arguments.
%
%      MAIN3('Property','Value',...) creates a new MAIN3 or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before main3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main3

% Last Modified by GUIDE v2.5 18-Jun-2008 15:00:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main3_OpeningFcn, ...
                   'gui_OutputFcn',  @main3_OutputFcn, ...
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


% --- Executes just before main3 is made visible.
function main3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main3 (see VARARGIN)

% Choose default command line output for main3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

clc;
x = evalin('base','x'); handles.x = x;
N = size(x,3); handles.N = N;

% puts one image, just to look good
axes(handles.axes1); imagesc(x(:,:,1)); colormap('gray'); colorbar('EastOutside'); axis image off;
handles.colorbar = 'EastOutside';
% organs initialization
for i = 1:9
    handles.organs(i) = struct('array',{zeros(1,N)},'rect',{[1 1 size(x,2) size(x,1)]},'X',{1},'Y',{1},'leftFrame',{1},'rightFrame',{N},'populated',{0});
end
handles.populated = 0;


handles.map = colormap(gray(256));
handles.organIndex = 1;
handles.currentSlide = 1;
handles.names(1,:) = '1 - lungs          ';
handles.names(2,:) = '2 - Heart          ';
handles.names(3,:) = '3 - Brain          ';
handles.names(4,:) = '4 - Kidneys        ';
handles.names(5,:) = '5 - Liver          ';
handles.names(6,:) = '6 - Food           ';
handles.names(7,:) = '7 - Various1       ';
handles.names(8,:) = '8 - Various2       ';
handles.names(9,:) = '9 - Various3       ';


set(handles.currentSlideNumber,'String',num2str(handles.currentSlide));
set(handles.leftText,'String',num2str(handles.organs(handles.organIndex).leftFrame));
set(handles.rightText,'String',num2str(handles.organs(handles.organIndex).rightFrame));


%assignin('base','organs',handles.organs);
guidata(hObject,handles);

% UIWAIT makes main3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = main3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% determines the current slide position
slider_position = get(hObject,'Value');
currentSlide = round(handles.N*slider_position);
set(handles.currentSlideNumber,'String',num2str(currentSlide));
handles.currentSlide = currentSlide;

% puts the image according to the slider position
axes(handles.axes1); imagesc(handles.x(:,:,currentSlide)); axis image off; colorbar off; colorbar(handles.colorbar);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in collect_point_pushbutton.
function collect_point_pushbutton_Callback(hObject, eventdata, handles)

%determine the point coordinates
bool = true;
while bool 
    [mouseX, mouseY] = getpts(handles.axes1);
    if length(mouseX) ~= 1 
        msgbox('Chose only one point','Note','modal');
        clear mouseX mouseY
    else bool = false;
    end
end

% plots the profile at the right frame axes screen 
axes(handles.axes2);
array = shiftdim(handles.x(round(mouseY),round(mouseX), ...
                           handles.organs(handles.organIndex).leftFrame : handles.organs(handles.organIndex).rightFrame ),1);
plot(array);
%axis([1 handles.N 0 1000]);

if (handles.organs(handles.organIndex).populated == 0)
    handles.populated = handles.populated + 1;
    handles.organs(handles.organIndex).populated = 1;
end

% %makes sure that the rightFrame organ is selected
% button = questdlg(['Current organ is ' num2str(handles.organIndex) '. Do you want to keep it?   .']);
% if strcmp(button,'Yes')
% elseif strcmp(button,'No')
%     answer = inputdlg(['Enter the new name:';
%         '                   ';
%         '1 - lungs          ';
%         '2 - Heart          ';
%         '3 - Brain          ';
%         '4 - Kidneys        ';
%         '5 - Liver          ';
%         '6 - Food           ';
%         '7 - Various1       ';
%         '8 - Various2       ';
%         '9 - Various3       ']);
%     str2num(answer{1});
% else
%     msgbox('Program terminated');
%     return
% end

% saves the data
handles.organs(handles.organIndex).X = mouseX;
handles.organs(handles.organIndex).Y = mouseY;
handles.organs(handles.organIndex).array = array;
guidata(hObject,handles);

% --- Executes on selection change in organ_popup.
function organ_popup_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns organ_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organ_popup

handles.organIndex = get(hObject, 'Value');
guidata(hObject,handles);

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

handles.organs(handles.organIndex).rect = round(getrect(handles.axes1));

%organs(organIndex).upperRight = [rect(2) rect(1)];
%organs(organIndex).lowerLeft = [rect(2) + rect(4) rect(1) + rect(3)];
%set(handles.ROI_text,'String','de si be');
%assignin('base','ROI',ROI)
%get(handles.ROI_text)

guidata(hObject,handles);

% --- Executes on button press in leftFrame.
function leftFrame_Callback(hObject, eventdata, handles)

handles.organs(handles.organIndex).leftFrame = handles.currentSlide;
handles.organs(handles.organIndex).array(1:handles.currentSlide) = 0;
set(handles.leftText,'String',handles.currentSlide);
guidata(hObject,handles);

% --- Executes on button press in rightFrame.
function rightFrame_Callback(hObject, eventdata, handles)
handles.organs(handles.organIndex).rightFrame = handles.currentSlide
handles.organs(handles.organIndex).array(handles.currentSlide:handles.N) = 0;
set(handles.rightText,'String',handles.currentSlide);
guidata(hObject,handles);

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
axes(handles.axes2);
plot(handles.organs(handles.organIndex).array);

s = [];
for i = 1:9
    str = [handles.names(i,:) ' ' num2str(handles.organs(i).rect) '            p.' num2str(handles.organs(i).populated)];
    s = vertcat(s,[str blanks(80 - size(str,2))]);
end
set(handles.organInfo,'String',s);

% --- Executes on button press in colorbar_radio.
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
assignin('base','organs',handles.organs);
warndlg('Save the variable ''organs'' imediatelly!         .','Do it');

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

function G = resizeMovie(M,zoom)
% G = resizeMovie(M,zoom); resizes movie M for a factor of zoom

if nargin == 1
    zoom = floor(500/size(M(1).cdata,2));
end

G = M;
a = ones(zoom);
for i = 1:size(M,2)
    G(i).cdata = flipud(uint8(kron(double(M(i).cdata),double(a))));
end

% --- Executes on button press in movie.
function movie_Callback(hObject, eventdata, handles)

% section for making and displying the movie
for i = 1:handles.N
    M(i) = im2frame( 1 + round(handles.x(:,:,i)),handles.map);
end
figure;
axis square off;
G = resizeMovie(M);
movie(G,1)
close;

% --- Executes on button press in findOrgans.
function findOrgans_Callback(hObject, eventdata, handles)

y = zeros(size(handles.x,1)*size(handles.x,2),size(handles.x,3));
for i = 1:handles.N 
    temp = handles.x(:,:,i); 
    y(:,i) = temp(:); 
end

handles.mapRed = zeros(size(handles.map));
handles.mapGreen = zeros(size(handles.map));
handles.mapBlue = zeros(size(handles.map));
handles.mapRed(:,1) = handles.map(:,1);
handles.mapGreen(:,2) = handles.map(:,2);
handles.mapBlue(:,3) = handles.map(:,3);

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
            handles.map = handles.mapRed;
        case 2 
            handles.map = handles.mapGreen;
        case 3 
            handles.map = handles.mapBlue;
        case 4
            handles.map = handles.mapRed + handles.mapGreen;
        case 5 
            handles.map = handles.mapGreen + handles.mapBlue;
        case 6 
            handles.map = handles.mapBlue + handles.mapRed;
    end
    coeffReshaped(:,:,i) = reshape(coeff(i,:),size(handles.x,1),size(handles.x,2));
    
    %for contours only
    subimage(250*uint8(coeffReshaped(:,:,i)/max(max(coeffReshaped(:,:,i)))),handles.map);
    
    %subimage(uint8(400*(coeffReshaped(:,:,i))),handles.map); %can be made better, but its working
    %image(200*coeffReshaped(:,:,i)); colormap(gray)
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


% --- Executes on button press in clearArray.
function clearArray_Callback(hObject, eventdata, handles)

handles.organ(handles.organIndex).array = zeros(1,handles.N);
guidata(hObject,handles);
