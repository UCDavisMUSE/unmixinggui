function varargout = main1(varargin)
% MAIN1 M-file for main1.fig
%      MAIN1, by itself, creates a new MAIN1 or raises the existing
%      singleton*.
%
%      H = MAIN1 returns the handle to a new MAIN1 or the handle to
%      the existing singleton*.
%
%      MAIN1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN1.M with the given input arguments.
%
%      MAIN1('Property','Value',...) creates a new MAIN1 or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before main1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main1

% Last Modified by GUIDE v2.5 17-Jun-2008 15:41:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main1_OpeningFcn, ...
                   'gui_OutputFcn',  @main1_OutputFcn, ...
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


% --- Executes just before main1 is made visible.
function main1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main1 (see VARARGIN)

% Choose default command line output for main1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%vars = evalin('base','who');
x = evalin('base','x');
map = colormap(gray(256));
%map = evalin('base','map');

%set(handles.listbox1,'String',vars)
%var_index = get(handles.listbox1,'Value');
clc;
%figure(handles.axes1);
axes(handles.axes1)
%handles
imagesc(x(:,:,10));

handles.x = x;

colormap('gray')
colorbar('East');
axis image off

guidata(hObject,handles)

%set(handles.figure1,'Colormap',map,'Axis','Off')
% UIWAIT makes main1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_position = get(hObject,'Value');
current_slide = round(size(handles.x,3)*slider_position);
axes(handles.axes1);
imagesc(handles.x(:,:,current_slide));
axis image off
colorbar('East');
handles.current_slide = current_slide;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in collect_point_pushbutton.
function collect_point_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to collect_point_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

organ_index = get(handles.organ_popup, 'Value');

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

% plots the profile at the rightFrame axes screen 
axes(handles.axes2);
plot(shiftdim(handles.x(round(mouseY),round(mouseX),:),1));

%makes sure that the rightFrame organ is selected
button = questdlg(['Current organ is ' num2str(organ_index) '. Do you want to keep it?   .']);
if strcmp(button,'Yes')
elseif strcmp(button,'No')
    answer = inputdlg(['Enter the new name:';
        '                   ';
        '1 - lungs          ';
        '2 - Heart          ';
        '3 - Brain          ';
        '4 - Kidneys        ';
        '5 - Liver          ';
        '6 - Food           ';
        '7 - Various1       ';
        '8 - Various2       ';
        '9 - Various3       ']);
    str2num(answer{1});
else
    msgbox('Program terminated');
    return
end

% saves the data
handles.organs(organ_index).mouseX = mouseX;
handles.organs(organ_index).mouseY = mouseY;
guidata(hObject,handles);

% --- Executes on selection change in organ_popup.
function organ_popup_Callback(hObject, eventdata, handles)
% hObject    handle to organ_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns organ_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organ_popup


% --- Executes during object creation, after setting all properties.
function organ_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to organ_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in collect_ROI_pushbutton.
function collect_ROI_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to collect_ROI_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rect = getrect(handles.axes1);
organ_index = get(handles.organ_popup, 'Value')

organs(organ_index).upperRight = [rect(2) rect(1)];
organs(organ_index).lowerLeft = [rect(2) + rect(4) rect(1) + rect(3)];

set(handles.ROI_text,'String','de si be');
%assignin('base','ROI',ROI)
%get(handles.ROI_text)
handles.organs = organs;
guidata(hObject,handles);



function ROI_list_Callback(hObject, eventdata, handles)
% hObject    handle to ROI_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_list as text
%        str2double(get(hObject,'String')) returns contents of ROI_list as a double


% --- Executes during object creation, after setting all properties.
function ROI_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ROI_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
get(hObject)




% --- Executes on button press in leftFrame.
function leftFrame_Callback(hObject, eventdata, handles)
handles.organs(organ_index).leftFrame = handles.current_slide;

% --- Executes on button press in rightFrame.
function rightFrame_Callback(hObject, eventdata, handles)
handles.organs(organ_index).rightFrame = handles.current_slide;

