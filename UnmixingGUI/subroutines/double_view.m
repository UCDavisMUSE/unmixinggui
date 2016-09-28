function varargout = double_view(varargin)
% DOUBLE_VIEW M-file for double_view.fig
%      DOUBLE_VIEW, by itself, creates a new MAIN12_FOR_DOUBLE_VIEW or raises the existing
%      singleton*.
%
%      H = DOUBLE_VIEW returns the handle to a new MAIN12_FOR_DOUBLE_VIEW or the handle to
%      the existing singleton*.
%
%      DOUBLE_VIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN12_FOR_DOUBLE_VIEW.M with the given input arguments.
%
%      DOUBLE_VIEW('Property','Value',...) creates a new MAIN12_FOR_DOUBLE_VIEW or raises the
%      existing singleton*.  Starting from the leftFrame, property value pairs are
%      applied to the GUI before double_view_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main12_for_double_view_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main12_for_double_view

% Last Modified by GUIDE v2.5 04-Aug-2008 16:53:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @double_view_OpeningFcn, ...
                   'gui_OutputFcn',  @double_view_OutputFcn, ...
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


% --- Executes just before double_view is made visible.
function double_view_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to double_view (see VARARGIN)

%% basic initialization: image size, staring frame, number of frames.
% this is not a good call because it is going to create exactly the same
% window, and we need new window
%handles.axes = varargin{2};
clc;

%instead we can do the following
handles.x = varargin{2}.x;
handles.rect = varargin{2}.rect;
handles.deriv = varargin{2}.deriv;
handles.N = varargin{2}.N;
handles.colorbar = varargin{2}.colorbar;
handles.currentSlide = varargin{2}.currentSlide;
handles.colormap = varargin{2}.colormap;
handles.organs = varargin{2}.organs;
handles.organIndex = varargin{2}.organIndex;
set(handles.organPopup,'Value',handles.organIndex);
set(handles.currentSlideNumber,'String',num2str(handles.currentSlide));
set(handles.slider,'Value',handles.currentSlide/handles.N(3));

handles.ROI1 = [handles.rect(2):handles.rect(2) + handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1) + handles.rect(3)-1];
set(handles.leftText,'String',num2str(handles.organs(handles.organIndex).leftFrame));
set(handles.rightText,'String',num2str(handles.organs(handles.organIndex).rightFrame));

% puts the 1st image just to look good
axes(handles.axes1);
imagesc(handles.x(handles.ROI1,handles.ROI2,1));
axis image off; colorbar off; colorbar(handles.colorbar); colormap(handles.colormap);
axes(handles.axes2);
imagesc(handles.deriv(handles.ROI1,handles.ROI2,1));
axis image off; colorbar off; colorbar(handles.colorbar); colormap(handles.colormap);
update_Callback(hObject, eventdata, handles);
guidata(hObject,handles);

% next line is CRUCIAL
uiwait;

% --- Outputs from this function are returned to the command line.
function varargout = double_view_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (se

% Get default command line output from handles structure
varargout{1} = handles.organs;
close;

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

update_Callback(hObject, eventdata, handles);
guidata(hObject,handles);

%% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in organPopup.
function organPopup_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns organPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from organPopup

handles.organIndex = get(hObject, 'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function organPopup_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%
function collectROI_Callback(hObject, eventdata, handles)

% determines the ROI region for the organ in the popup menu
rect = round(getrect(handles.axes2));
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

%% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
rect = handles.organs(handles.organIndex).rect;
ROI1 = [rect(2):rect(2)+rect(4)-1];
ROI2 = [rect(1):rect(1)+rect(3)-1];
organIndex = handles.organIndex;

%% update axes1 and axes2
axes(handles.axes1);
imagesc(handles.x(handles.ROI1, handles.ROI2, handles.currentSlide));
axis image off; colorbar off; colorbar(handles.colorbar);colormap(handles.colormap);
axes(handles.axes2);
imagesc(handles.deriv(handles.ROI1, handles.ROI2, handles.currentSlide));
axis image off; colorbar off; colorbar(handles.colorbar);colormap(handles.colormap);

%% this part updates organs array, derivArray, arraySquared and
%% derivarraySquared
l = handles.organs(organIndex).leftFrame;
r = handles.organs(organIndex).rightFrame;

handles.organs(organIndex).array = zeros(1,handles.N(3));
handles.organs(organIndex).array(l:r) = shiftdim( mean(mean( ...
        handles.x(ROI1,ROI2,l:r),1),2),1);
handles.organs(organIndex).derivarray = zeros(1,handles.N(3));
handles.organs(organIndex).derivarray(l:r) = shiftdim( mean(mean( ...
        handles.deriv(ROI1,ROI2,l:r),1),2),1);
        
%% this part updates organs info
s = [];
for i = 1:9
    s = str2mat(s,[handles.organs(i).name ' ' num2str(handles.organs(i).rect) '            p.' num2str(handles.organs(i).populated) ...
               '           T1: '  num2str(handles.organs(i).leftFrame) ' Tend: '  num2str(handles.organs(i).rightFrame) ]);
end
set(handles.organInfo,'String',s);

%% this part updates axes3

contents = get(handles.listbox1,'String');
index1 = contents{get(handles.listbox1,'Value')};
contents = get(handles.listbox2,'String');
index2 = contents{get(handles.listbox2,'Value')};
rect = handles.organs(organIndex).rect;
axes(handles.axes3);
if strcmp(index1,'Raw') & strcmp(index2,'Original')
    axes3Plot = handles.organs(organIndex).array;
end
if strcmp(index1,'Raw') & strcmp(index2,'Absolute')
    axes3Plot = abs(handles.organs(organIndex).array);
end
if strcmp(index1,'Derivative') & strcmp(index2,'Original')
    axes3Plot =  handles.organs(organIndex).derivarray;
end
if strcmp(index1,'Derivative') & strcmp(index2,'Absolute')
    axes3Plot =  abs(handles.organs(organIndex).derivarray);
end

plot(axes3Plot);
hold on;
line([handles.currentSlide  handles.currentSlide],[min(axes3Plot) max(axes3Plot)*1.1],'LineStyle','--');
hold off;
handles.axes3Plot = axes3Plot;
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
set(handles.organPopup,'Value',1);

update_Callback(hObject,eventdata,handles);

guidata(hObject,handles);

function exportTiffs_Callback(hObject, eventdata, handles)
% hObject    handle to exportTiffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = scale_Callback(hObject, eventdata, handles);
h1 = msgbox({'tiffs ' num2str(handles.organs(handles.organIndex).timeSampled) ' and ROI ' num2str(handles.organs(handles.organIndex).rect)});
pos = get(h1,'Position');
set(h1,'Position',[pos(1)-50,pos(2)-50,pos(3)+50,pos(4)+20]);
uiwait(h1);
ROI1 = handles.ROI1;
ROI2 = handles.ROI2;

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
    end
    close(h)
end


% --- Executes during object creation, after setting all properties.
function currentSlideNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentSlideNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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
end
guidata(hObject,handles);
update_Callback(hObject, eventdata, handles);

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

handles.rect = [1 1 handles.N(2) handles.N(1)];
handles.ROI1 = [handles.rect(2):handles.rect(2)+handles.rect(4)-1];
handles.ROI2 = [handles.rect(1):handles.rect(1)+handles.rect(3)-1];
update_Callback(handles.update, eventdata, handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)

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

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function minSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;

% --- Executes on button press in ROI.
function ROI_Callback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function uipanel6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function loadOrgans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadOrgans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in leftFrame.
function leftFrame_Callback(hObject, eventdata, handles)
handles.organs(handles.organIndex).leftFrame = handles.currentSlide;
set(handles.leftText,'String',handles.currentSlide);
handles.organs(handles.organIndex).populated = 1;
update_Callback(handles.update,eventdata,handles);
guidata(hObject,handles);

% --- Executes on button press in rightFrame.
function rightFrame_Callback(hObject, eventdata, handles)
handles.organs(handles.organIndex).rightFrame = handles.currentSlide;
set(handles.rightText,'String',handles.currentSlide);
handles.organs(handles.organIndex).populated = 1;
guidata(hObject,handles);
update_Callback(handles.update,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function rightText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function leftText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function rightFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in fitGaussian.
function fitGaussian_Callback(hObject, eventdata, handles)
% hObject    handle to fitGaussian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_Callback(handles.update,eventdata,handles);
array = (handles.axes3Plot)';
t = (1:size(array,1))';

[fittedArray, fitParameters] = FitGaussian(array);
close;
axes(handles.axes3);
h = get(handles.axes3);

plot(t,array,'o',t,fittedArray,'--');
leg = str2mat(['a = ' num2str(fitParameters.a,'%8g')], ['b = ' num2str(fitParameters.b,'%8g')], ... 
           ['c = ' num2str(fitParameters.c,'%8g')], ['d = ' num2str(fitParameters.d,'%8g')]);
text(length(t)*0.7,max(array(:))*0.8,leg);