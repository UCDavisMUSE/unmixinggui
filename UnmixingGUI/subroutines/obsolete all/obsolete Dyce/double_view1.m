function varargout = double_view1(varargin)
% This is the GUI for comparing raw and 1st derivative images

% Last Modified by GUIDE v2.5 22-Jul-2008 13:25:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @double_view1_OpeningFcn, ...
                   'gui_OutputFcn',  @double_view1_OutputFcn, ...
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

% --- Executes just before double_view1 is made visible.
function double_view1_OpeningFcn(hObject, eventdata, handles, varargin)

% this function is called from the main GUI function as 
% handles.organs = double_view1(eventdata, handles);
% so varargin{2} is equivalent of handles.
% handles.organs is going to be comprised of handles.organs(i).timeSampled and
% handles.organs(i).rect 

% initialization
handles.x = varargin{2}.x;
handles.rect = varargin{2}.rect;
handles.deriv = varargin{2}.deriv;
handles.organs = varargin{2}.organs;
handles.N = varargin{2}.N;
handles.colorbar = varargin{2}.colorbar;
handles.organIndex = 1;
set(handles.organPopup,'Value',1);
handles.currentSlide = 1;
handles.map = varargin{2}.colormap;
%set(handles.currentSlideNumber,'String','1');
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];

% puts the 1st image just to look good
axes(handles.axes3);
imagesc(handles.x(handles.ROI1,handles.ROI2,1));
axis image off; colorbar off; colorbar(handles.colorbar); colormap(handles.map);
axes(handles.axes4);
imagesc(handles.deriv(handles.ROI1,handles.ROI2,1));
axis image off; colorbar off; colorbar(handles.colorbar); colormap(handles.map);

% initializes output
handles.output{1} = handles.organs;
guidata(hObject,handles);

% next line is CRUCIAL
uiwait;

%% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

% determines the current slide position
slider_position = get(hObject,'Value');
currentSlide = round(handles.N(3)*slider_position);
set(handles.currentSlideNumber,'String',num2str(currentSlide));

% puts the image according to the slider position
axes(handles.axes3);
imagesc(handles.x(handles.ROI1,handles.ROI2,currentSlide));
axis image off; colorbar off; colorbar(handles.colorbar);colormap(handles.map);
axes(handles.axes4);
imagesc(handles.deriv(handles.ROI1,handles.ROI2,currentSlide));
axis image off; colorbar off; colorbar(handles.colorbar);colormap(handles.map);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function axes3_CreateFcn(hObject, eventdata, handles)
function axes4_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in chooseROI.
function chooseROI_Callback(hObject, eventdata, handles)

handles.organs(handles.organIndex).rect = round(getrect(handles.axes4));
guidata(hObject,handles);
update_Callback(handles.update, eventdata, handles);

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

if (handles.organs(handles.organIndex).populated == 0)
    handles.organs(handles.organIndex).populated = 1;
    handles.populated = handles.populated + 1; 
end

guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox2_Callback(hObject, eventdata, handles)
function listbox2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)

contents = get(handles.listbox1,'String');
index1 = contents{get(handles.listbox1,'Value')};
contents = get(handles.listbox2,'String');
index2 = contents{get(handles.listbox2,'Value')};
rect = handles.rect;

if strcmp(index1,'Raw') & strcmp(index2,'Abs')
    for i = 1:handles.N(3)
        profile(i) = mean(mean( abs(handles.x(handles.ROI1,handles.ROI2,i)) ));
    end
end
if strcmp(index1,'Raw') & strcmp(index2,'Square')
    for i = 1:handles.N(3)
        profile(i) = mean(mean( (handles.x(handles.ROI1,handles.ROI2,i)).^2 ));
    end
end
if strcmp(index1,'Derivative') & strcmp(index2,'Abs')
    for i = 1:handles.N(3)
        profile(i) = mean(mean( abs(handles.deriv(handles.ROI1,handles.ROI2,i)) ));
    end
end
if strcmp(index1,'Derivative') & strcmp(index2,'Square')
    for i = 1:handles.N(3)
        profile(i) = mean(mean( (handles.deriv(handles.ROI1,handles.ROI2,i)).^2 ));
    end
end
handles.profile = profile;
axes(handles.axes5);

stem(profile);
guidata(hObject,handles);

%% --- Executes on button press in determineSampling.
function determineSampling_Callback(hObject, eventdata, handles)

profile = handles.profile;
profileMax = max(profile);
profileMin = min(profile);

% finds the regions of high and low profile
%bin = (profile > profileMin + ( profileMax - profileMin )/10) ;
%finds the first and last index of a high region
%n1 = find(bin,1,'first');
%n1 = 2;
%n2 = find(bin,1,'last');

%  old code for 4 points input
% axes(handles.axes5);
% [mouseX,mouseY] = ginput;
% format short
% lengthX = size(mouseX,1);
% while mod(lengthX,2) ~= 0
%     msgbox('click even number of times');
%     [mouseX,mouseY] = ginput;
% end
% X = round(mouseX);
% for i=1:lengthX
%     line([X(i) X(i)],[0 profileMax]);
% end

% new code for two points input only
axes(handles.axes5);
[mouseX,mouseY] = ginput;
format short
while mod(lengthX,2) ~= 0
    msgbox('click even number of times');
    [mouseX,mouseY] = ginput;
end
lengthX = size(mouseX,1);
X = round(mouseX);
for i = 1:lengthX
    line([X(i) X(i)],[0 profileMax]);
end

% line([n1 n1],[0 profileMax]);
% line([n2 n2],[0 profileMax]);
% 
button = questdlg('Are you happy with the borders?  .');
if strcmp(button,'No')
    msgbox('Press button again');
    return;
else
    %time = 1:size(profile,2);
    timeSampled = [X(1):X(2)];
    %timeSampled = [1:5:X(1)-1,X(1):X(2),X(2)+1:5:X(3)-1,X(3):X(4),X(4)+1:5:size(profile,2)];
    profileSampled = profile(timeSampled);
    axes(handles.axes5);
    stem(timeSampled,profileSampled);
end
handles.output = timeSampled;
guidata(hObject,handles);

% next line is CRUCIAL
uiresume;

function varargout = double_view1_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.rect;

% --- Executes on selection change in organPopup.
function organPopup_Callback(hObject, eventdata, handles)
% hObject    handle to organPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns organPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organPopup

handles.organIndex = get(hObject, 'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function organPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to organPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


