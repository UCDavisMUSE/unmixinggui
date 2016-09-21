function varargout = main2(varargin)
% MAIN2 M-file for main2.fig
%      MAIN2, by itself, creates a new MAIN2 or raises the existing
%      singleton*.
%
%      H = MAIN2 returns the handle to a new MAIN2 or the handle to
%      the existing singleton*.
%
%      MAIN2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN2.M with the given input arguments.
%
%      MAIN2('Property','Value',...) creates a new MAIN2 or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before main2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main2

% Last Modified by GUIDE v2.5 17-Jun-2008 17:13:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main2_OpeningFcn, ...
                   'gui_OutputFcn',  @main2_OutputFcn, ...
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


% --- Executes just before main2 is made visible.
function main2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main2 (see VARARGIN)

% Choose default command line output for main2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

x = evalin('base','x'); handles.x = x;
N = size(x,3); handles.N = N;

% puts one image, just to look good
axes(handles.axes1); imagesc(x(:,:,10)); colormap('gray'); colorbar('EastOutside'); axis image off;
handles.colorbar = 'EastOutside';
% handles initialization
for i = 1:9
    handles.organs(i) = struct('array',{zeros(1,N)},'rect',{[1 1 size(x,2) size(x,1)]},'X',{1},'Y',{1},'leftFrame',{1},'rightFrame',{N});
end
%assignin('base','organs',organs);
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

guidata(hObject,handles);

% UIWAIT makes main2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = main2_OutputFcn(hObject, eventdata, handles) 
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
currentSlide = round(size(handles.x,3)*slider_position);

% puts the image according to the slider position
axes(handles.axes1); imagesc(handles.x(:,:,currentSlide)); axis image off; colorbar off; colorbar(handles.colorbar);

handles.currentSlide = currentSlide;
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
%handles.organIndex
%handles.organs(handles.organIndex).leftFrame
%handles.organs(handles.organIndex).rightFrame
array = shiftdim(handles.x(round(mouseY),round(mouseX), ...
    handles.organs(handles.organIndex).leftFrame : handles.organs(handles.organIndex).rightFrame ),1);
plot(array);

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
handles.organs(handles.organIndex).X = mouseX
handles.organs(handles.organIndex).Y = mouseY
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

handles.organs(handles.organIndex).rect = getrect(handles.axes1);

%organs(organIndex).upperRight = [rect(2) rect(1)];
%organs(organIndex).lowerLeft = [rect(2) + rect(4) rect(1) + rect(3)];
%set(handles.ROI_text,'String','de si be');
%assignin('base','ROI',ROI)
%get(handles.ROI_text)

guidata(hObject,handles);


function ROI_list_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_list as text
%        str2double(get(hObject,'String')) returns contents of ROI_list as a double


% --- Executes during object creation, after setting all properties.
function ROI_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ROI_text_CreateFcn(hObject, eventdata, handles)
get(hObject)

% --- Executes on button press in leftFrame.
function leftFrame_Callback(hObject, eventdata, handles)
%handles.organIndex
%handles.currentSlide
handles.organs(handles.organIndex).leftFrame = handles.currentSlide;
handles.organs(handles.organIndex).array(1:handles.currentSlide) = 0;
guidata(hObject,handles);

% --- Executes on button press in rightFrame.
function rightFrame_Callback(hObject, eventdata, handles)
handles.organs(handles.organIndex).rightFrame = handles.currentSlide
handles.organs(handles.organIndex).array(handles.currentSlide:handles.N) = 0;
guidata(hObject,handles);

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
axes(handles.axes2);
plot(handles.organs(handles.organIndex).array);
%handles.names(handles.organIndex);
s = [];
for i = 1:9
    s = vertcat(s,[handles.names(i,:) ' ' num2str(handles.organs(i).rect,'% 20g')])
end
set(handles.variableInfo,'String',s);

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

