function varargout = CreateBlobsFinal(varargin)
% CREATEBLOBSFINAL M-file for CreateBlobsFinal.fig
%      CREATEBLOBSFINAL, by itself, creates a new CREATEBLOBSFINAL or raises the existing
%      singleton*.
%
%      H = CREATEBLOBSFINAL returns the handle to a new CREATEBLOBSFINAL or the handle to
%      the existing singleton*.
%
%      CREATEBLOBSFINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEBLOBSFINAL.M with the given input arguments.
%
%      CREATEBLOBSFINAL('Property','Value',...) creates a new CREATEBLOBSFINAL or raises the
%      existing singleton*.  Starting from the mean1, property value pairs are
%      applied to the GUI before main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateBlobsFinal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help CreateBlobsFinal
% Last Modified by GUIDE v2.5 11-Feb-2011 02:02:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateBlobsFinal_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateBlobsFinal_OutputFcn, ...
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

% --- Executes just before CreateBlobsFinal is made visible.
function CreateBlobsFinal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateBlobsFinal (see VARARGIN)

% Choose default command line output for CreateBlobsFinal
handles.output = hObject;
clc;

% handles.N = str2num(get(handles.N3,'String'));
contents = get(handles.N3,'String');
handles.N = str2num(contents{get(handles.N3,'Value')});

handles.maxNumberOfBlobs = 4;

handles.maxCameraValue = 4095;
handles.defaultPath = which(mfilename);

handles = Initialize(handles);

for i = 1:handles.maxNumberOfBlobs
    eval(['set(handles.edit' num2str(i) '1, ''String'', ''0.5'');']);
    eval(['set(handles.edit' num2str(i) '2, ''String'', ''0.2'');']);
    eval(['set(handles.edit' num2str(i) '3, ''String'', ''0.1'');']);
    eval(['set(handles.edit' num2str(i) '4, ''String'', ' num2str(1 - 0.1*i) ');']);
end

set(handles.figure1,'Name','Blob Creator');
axes(handles.axes1);
axis image % off;

set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});
set(handles.figure1,'UserData',handles.currentSlide);
handles = darkNoiseEdit_Callback(hObject, eventdata, handles);

% updatecube handles structure
guidata(hObject, handles);

Update(handles);

function handles = InitializeBlob(handles, i)
handles.blob(i).temporalMean = 0;
handles.blob(i).temporalSigma = 0;
handles.blob(i).spatialSigma = 0;
handles.blob(i).amplitude = 0;
handles.blob(i).i = 0;
handles.blob(i).j = 0;
handles.blob(i).subCube = zeros(handles.N);
handles.blob(i).selected = 0;
eval(['set(handles.checkbox' num2str(i) ',''Value'',0);']);

function ScrollWheel(hObject, eventdata, handles)
% guidata writing doesn't work here, but we can readout from it
handles = guidata(hObject);

currentSlide = get(hObject,'UserData');
currentSlide = currentSlide + eventdata.VerticalScrollCount;
if currentSlide >= handles.N(3) 
    currentSlide = handles.N(3);
end
if currentSlide <= 1;
    currentSlide = 1;
end
handles.currentSlide = currentSlide;
handles = UpdateSlider(handles);
set(hObject,'UserData',currentSlide);
guidata(hObject, handles);

Update(handles);

function handles = UpdateSlider(handles)
if handles.N(3) == 0
    set(handles.slider, 'Value', 0);
    set(handles.slider, 'SliderStep', [1, 0.1]);
elseif handles.N(3) == 1
    set(handles.slider, 'Value', 0);
    set(handles.slider, 'SliderStep', [1, 0.1]);
else
    set(handles.slider,'Value', handles.currentSlide/handles.N(3));
    set(handles.slider, 'SliderStep', [1/(handles.N(3)-1), 0.1]);
end
set(handles.currentSlideText,'String', ['# ' num2str(handles.currentSlide) ' / ' num2str(handles.N(3))]);

% --- Outputs from this function are returned to the command line.
function varargout = CreateBlobsFinal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function draw1_Callback(hObject, eventdata, handles)
handles = InitializeBlob(handles, 1);
%determine the point coordinates
axes(handles.axes1);
[x,y] = ginput(1);
set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});

% after ginput scroll wheel functionality disappears

handles.blob(1).i = round(y);
handles.blob(1).j = round(x);
handles = UpdateSubCube(handles, 1);
set(handles.checkbox1,'Value',1);
handles.blob(1).selected = 1;
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function draw2_Callback(hObject, eventdata, handles)
handles = InitializeBlob(handles, 2);
%determine the point coordinates
axes(handles.axes1);
[x,y] = ginput(1);
set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});
handles.blob(2).i = round(y);
handles.blob(2).j = round(x);
handles = UpdateSubCube(handles, 2);
set(handles.checkbox2,'Value',1);
handles.blob(2).selected = 1; 
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function draw3_Callback(hObject, eventdata, handles)
handles = InitializeBlob(handles, 3);
%determine the point coordinates
axes(handles.axes1);
[x,y] = ginput(1);
set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});
handles.blob(3).i = round(y);
handles.blob(3).j = round(x);
handles = UpdateSubCube(handles, 3);
set(handles.checkbox3,'Value',1);
handles.blob(3).selected = 1; 
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function draw4_Callback(hObject, eventdata, handles)
handles = InitializeBlob(handles, 4);
%determine the point coordinates
axes(handles.axes1);
[x,y] = ginput(1);
set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});
handles.blob(4).i = round(y);
handles.blob(4).j = round(x);
handles = UpdateSubCube(handles, 4);
set(handles.checkbox4,'Value',1);
handles.blob(4).selected = 1; 
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function checkbox1_Callback(hObject, eventdata, handles)
handles.blob(1).selected = get(hObject,'Value');
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function checkbox2_Callback(hObject, eventdata, handles)
handles.blob(2).selected = get(hObject,'Value');
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function checkbox3_Callback(hObject, eventdata, handles)
handles.blob(3).selected = get(hObject,'Value');
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function checkbox4_Callback(hObject, eventdata, handles)
handles.blob(4).selected = get(hObject,'Value');
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
currentSlide = ceil(handles.N(3)*get(hObject,'Value') + eps);
if currentSlide > handles.N(3)
    currentSlide = handles.N(3);
end
handles.currentSlide = currentSlide;
handles = UpdateSlider(handles);
% set(handles.currentSlideText,'String',num2str(currentSlide));
guidata(hObject, handles);
Update(handles);

% --- Executes on button press in exportTiffs.
function exportTiffs_Callback(hObject, eventdata, handles)
% hObject    handle to exportTiffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;

[filename, pathname] = uiputfile( '*.tif', ...
        'Save stack as tiffs', fullfile(handles.defaultPath, 'blob'));
if size(pathname,2) == 1
    return;
end
handles.defaultPath = pathname;
guidata(hObject, handles);

[junk, stripedName, ext] = fileparts(filename);

if isempty(ext)
   ext = '.tif';
end

for i = 1:handles.N(3);
    imwrite(uint16(handles.cube(:,:,i)), fullfile(pathname, [stripedName '_' num2str(i,'%02g') ext]));
end

ExportParameters(handles);
save(fullfile(handles.defaultPath, stripedName), 'handles');
msgbox('Exporting done','modal');

function ExportParameters(handles)
fid = fopen(fullfile(handles.defaultPath,'parameters.txt'),'w');
fprintf(fid, '%s\n', ['N = ' num2str(handles.N)]);  
fprintf(fid, '%s\n', ['dark noise = ' num2str(handles.darkNoiseLevel)]);
for i = 1:handles.maxNumberOfBlobs
    if handles.blob(i).selected
        eval(['fprintf(fid, ''%s\n'', ''blob' num2str(i) ': '');' ]);  
        eval(['fprintf(fid, ''%s\n'', [''param' num2str(i) '1: '' get(handles.edit' num2str(i) '1,''String'')]); ']);  
        eval(['fprintf(fid, ''%s\n'', [''param' num2str(i) '2: '' get(handles.edit' num2str(i) '2,''String'')]); ']);  
        eval(['fprintf(fid, ''%s\n'', [''param' num2str(i) '3: '' get(handles.edit' num2str(i) '3,''String'')]); ']);  
        eval(['fprintf(fid, ''%s\n'', [''param' num2str(i) '4: '' get(handles.edit' num2str(i) '4,''String'')]); ']);  
        eval(['fprintf(fid, ''%s\n'', [''i: '' num2str(handles.blob(' num2str(i) ').i)]); ']);  
        eval(['fprintf(fid, ''%s\n'', [''j: '' num2str(handles.blob(' num2str(i) ').j)]); ']);  
    end
end
fclose(fid);

% --- Executes on button press in UpdateCube.
function handles = UpdateSubCube(handles, i)
% 1) read all the values,
eval(['temporalMean = str2num(get(handles.edit' num2str(i) '1, ''String''));']);
eval(['temporalSigma =  str2num(get(handles.edit' num2str(i) '2, ''String''));']);
eval(['spatialSigma =  str2num(get(handles.edit' num2str(i) '3, ''String''));']);
eval(['amplitude =  str2num(get(handles.edit' num2str(i) '4, ''String''));']);

% 2) calculate temporal subcube
temporalProfile = fspecial('gaussian',[1 3*handles.N(3)], temporalSigma*handles.N(3));
temporalProfile = wshift('1d', temporalProfile, round(handles.N(3)*(0.5 - temporalMean)));
temporalProfile = temporalProfile(handles.N(3) + (1:handles.N(3)));

spatialProfile = fspecial('gaussian',[3*handles.N(1) 3*handles.N(2)], spatialSigma*handles.N(1));
spatialProfile = wshift('2d', spatialProfile, ...
    round([ handles.N(1)/2 + 1 - handles.blob(i).i, ...
    handles.N(2)/2 + 1 - handles.blob(i).j]));
spatialProfile = spatialProfile(handles.N(1) + (1:handles.N(1)), handles.N(2) + (1:handles.N(2)));

spatialProfile = amplitude * spatialProfile / max(spatialProfile(:));

handles.blob(i).subCube = zeros(handles.N);
for j = 1:handles.N(3)
    handles.blob(i).subCube(:,:,j) = spatialProfile * temporalProfile(j);
end
handles.blob(i).subCube =  handles.maxCameraValue* amplitude * handles.blob(i).subCube / max(handles.blob(i).subCube(:));

function handles = UpdateCube(handles)
handles.cube = zeros(handles.N);
for i = 1:handles.maxNumberOfBlobs
    if handles.blob(i).selected
        handles.cube = handles.cube + handles.blob(i).subCube;
    end
end
handles.cube = handles.cube + handles.darkNoise;
if get(handles.AddShotNoise,'Value')
    handles.cube = random('norm', handles.cube, sqrt(handles.cube), handles.N);
end
handles.cube = uint16(handles.cube);


% --- Executes on button press in UpdateCube.
function UpdateCube_Callback(hObject, eventdata, handles)
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles)

function Update(handles)
% puts the image according to the slider position
axes(handles.axes1); 

imagesc(handles.cube(:,:,handles.currentSlide), [0, max(handles.cube(:))+eps]);

% % finds limits to contrast strech
% a = stretchlim(handles.cube(:,:,handles.currentSlide), 0.001);
% % adjust auto-contrast
% J = imadjust(handles.cube(:,:,handles.currentSlide), a, []);
% % J = handles.cube(:,:,handles.currentSlide);
% % imshow(J,[0 10000]);
% imshow(J);

colormap(gray)
if get(handles.colorbar,'Value')
    colorbar;
end
axis image off; 

function edit11_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 1);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit12_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 1);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit13_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 1);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);
 
function edit14_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 1);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit21_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 2);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit22_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 2);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit23_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 2);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit24_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 2);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit31_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 3);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit32_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 3);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit33_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 3);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit34_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 3);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit41_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 4);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit42_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 4);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit43_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 4);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function edit44_Callback(hObject, eventdata, handles)
handles = UpdateSubCube(handles, 4);
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

function handles = darkNoiseEdit_Callback(hObject, eventdata, handles)
handles.darkNoiseLevel = handles.maxCameraValue * str2double(get(handles.darkNoiseEdit,'String'));
handles.darkNoise = random('norm', handles.darkNoiseLevel, sqrt(handles.darkNoiseLevel), handles.N);

handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

% --- Executes on button press in AddShotNoise.
function AddShotNoise_Callback(hObject, eventdata, handles)
handles = UpdateCube(handles);
guidata(hObject, handles);
Update(handles);

% --- Executes on button press in colorbar.
function colorbar_Callback(hObject, eventdata, handles)
Update(handles);

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
axes(handles.axes1);
for i = 1:handles.N(3)
    imagesc(handles.cube(:,:,i), [0, max(handles.cube(:))+eps]);
    axis image off;
    handles.currentSlide = i;
    handles = UpdateSlider(handles);
    pause(0.2)
end

% --- Executes on button press in loadStack.
function loadStack_Callback(hObject, eventdata, handles)
[filename, pathname, filterindex] = uigetfile( '*.tif', ...
        'Load stack of tif files');
[handles.cube, filenames] = LoadCube(pathname);
guidata(hObject, handles);
handles.currentSlide = 1;
handles = UpdateSlider(handles);
Update(handles);

for i = 1:handles.maxNumberOfBlobs
    handles = InitializeBlob(handles, i);
    eval(['set(handles.edit' num2str(i) '1, ''String'', ''0.5'');']);
    eval(['set(handles.edit' num2str(i) '2, ''String'', ''0.2'');']);
    eval(['set(handles.edit' num2str(i) '3, ''String'', ''0.1'');']);
    eval(['set(handles.edit' num2str(i) '4, ''String'', ' num2str(1 - 0.1*i) ');']);
    eval(['set(handles.checkbox' num2str(i) ',''Value'', 0)']);
end
guidata(hObject, handles);

% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
buttonName = questdlg('Are you sure?', 'Clear all');
if strcmp(buttonName, 'Yes')
    handles = Initialize(handles);
end
guidata(hObject, handles);

function handles = Initialize(handles)
handles.cube = zeros(handles.N);
handles.currentSlide = 1;
handles = UpdateSlider(handles);
Update(handles);
for i = 1:handles.maxNumberOfBlobs
    handles = InitializeBlob(handles, i);
    eval(['set(handles.checkbox' num2str(i) ',''Value'', 0)']);
end

function N3_Callback(hObject, eventdata, handles)
contents = get(hObject,'String');
handles.N = str2num(contents{get(hObject,'Value')});
handles = Initialize(handles);
handles = darkNoiseEdit_Callback(hObject, eventdata, handles);
guidata(hObject, handles);

