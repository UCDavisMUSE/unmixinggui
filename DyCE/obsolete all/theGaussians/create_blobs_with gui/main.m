function varargout = main(varargin)
% MAIN M-file for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the mean1, property value pairs are
%      applied to the GUI before main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help main
% Last Modified by GUIDE v2.5 24-Jun-2008 17:44:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
%clc;

N = [30 30 100];
handles.map = colormap(gray(256));
handles.colorbar = 'EastOutside';
handles.numberOfBlobls = 0;
handles.N = N;
handles.x = zeros(N);
handles.loadSpectraIndicator = 0;

axes(handles.axes1); image(handles.x(:,:,1)); colormap('gray'); colorbar('EastOutside'); axis image off;

for i = 1:9
    handles.blob(i) = struct('cube',{zeros(N)},'profile',{zeros(1,N(3))},'populated',{0},'type',{1},'position',{[15,15]},'maxIntensity',{1},'spatialSigma',{0.1},'mean1',{0.5},'temporalSigma',{0.1});
end

set(handles.maxIntensity,'String',num2str(250));
set(handles.spatialSigma,'String',num2str(3));
set(handles.mean1,'String',num2str(0.5));
set(handles.temporalSigma,'String',num2str(3));
%set(handles.currentBlobPopUp);
clc;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in addBlob.
function addBlob_Callback(hObject, eventdata, handles)
% hObject    handle to addBlob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bool = true;
currentBlob = get(handles.currentBlobPopUp,'Value') - 1;
if currentBlob == 0
    errordlg('Choose nonzero current blob','Error');
    return;
end
maxIntensity = str2double(get(handles.maxIntensity, 'String'));
if isnan(maxIntensity)
    bool = false;
end
spatialSigma = str2double(get(handles.spatialSigma, 'String'));
if isnan(spatialSigma)
    bool = false;
end
if handles.loadSpectraIndicator == 0 
    mean1 = str2double(get(handles.mean1, 'String'));
    if isnan(mean1)
        bool = false;
    end
    temporalSigma = str2double(get(handles.temporalSigma, 'String'));
    if isnan(temporalSigma)
        bool = false;
    end
    handles.blob(currentBlob).mean1 = mean1;
    handles.blob(currentBlob).temporalSigma = temporalSigma;
    if bool
        profile = fspecial('gaussian',[1 handles.N(3)],temporalSigma);
        profile = wshift('1d',profile,round(handles.N(3)*(0.5 - mean1)));
        handles.blob(currentBlob).profile = maxIntensity*profile/max(profile);
    end
end

if bool    
    if handles.blob(currentBlob).populated == 1
        button = questdlg('Overwrite?');
        if ~strcmp(button,'Yes')
            msgbox('Blob was not added');
            return;
        end
    end
 
    %determine the point coordinates
    bool1 = true;
    while bool1
        [mouseY,mouseX] = getpts(handles.axes1);
        if length(mouseX) ~= 1
            msgbox('Chose only one point','Note','modal');
            clear mouseX mouseY
        else bool1 = false;
        end
    end

  
    blob = fspecial('Gaussian',[handles.N(1), handles.N(2)],spatialSigma);
    blob = wshift('2d',blob,...
        round([ handles.N(1)/2 + 1 - mouseX, handles.N(2)/2 + 1 - mouseY]));
    blob = blob/max(blob(:));
    for i = 1:handles.N(3)
        temp = blob.*handles.blob(currentBlob).profile(i);
        if max(max(temp)) > eps
            handles.blob(currentBlob).cube(:,:,i) = temp;
        end
    end
   
    handles.blob(currentBlob).maxIntensity = maxIntensity;
    handles.blob(currentBlob).spatialSigma = spatialSigma;
    handles.blob(currentBlob).position(1) = mouseX;
    handles.blob(currentBlob).position(2) = mouseY;
    handles.blob(currentBlob).populated = 1;
    
else
    errordlg('Inputs must be a numbers','Error');
end

temp = zeros(handles.N);
for i = 1:9
    temp = temp + handles.blob(i).cube;
end
handles.x = temp; 
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in removeBlob.
function removeBlob_Callback(hObject, eventdata, handles)
% hObject    handle to removeBlob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if 
handles.blob(handles.currentBlobPopUp) = struct('maxIntensity',{1},'sigma',{0.1},'position',{0,0},'left',{0},'right',{0},'populated',{0},'type',{1});
handles.numberOfBlobs = handles.numberOfBlobs - 1;
handles.currentBlobPopUp = handles.currentBlobPopUp - 1;

% if handles.currentBlobPopUp == 1
%     handles.currentBlobPopUp = 0;
%     %set(handles.leftText,'String',handles.currentSlide);
% else
%    handles.currentBlobPopUp = 1;
%    %set(handles.current,'String',handles.currentSlide);
   



function maxIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to maxIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIntensity as text
%        str2double(get(hObject,'String')) returns contents of maxIntensity as a double


% --- Executes during object creation, after setting all properties.
function maxIntensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temporalSigma_Callback(hObject, eventdata, handles)
% hObject    handle to temporalSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temporalSigma as text
%        str2double(get(hObject,'String')) returns contents of temporalSigma as a double


% --- Executes during object creation, after setting all properties.
function temporalSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temporalSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in shape.
function shape_Callback(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns shape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shape


% --- Executes during object creation, after setting all properties.
function shape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

% --- Executes on button press in playMovie.
function playMovie_Callback(hObject, eventdata, handles)
% hObject    handle to playMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% section for making and displying the movie
for i = 1:handles.N(3)
    M(i) = im2frame( 1 + round(handles.x(:,:,i)/2),colormap(gray(236)));
end
figure;
axis square off;
G = resizeMovie(M);
movie(G,1)
close;
%avifile('c:\movie_nesa');
%movie2avi(G,'c:\movie_nesa.avi');

function mean1_Callback(hObject, eventdata, handles)
% hObject    handle to mean1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mean1 as text
%        str2double(get(hObject,'String')) returns contents of mean1 as a double


% --- Executes during object creation, after setting all properties.
function mean1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mean1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of right as text
%        str2double(get(hObject,'String')) returns contents of right as a double


% --- Executes during object creation, after setting all properties.
function right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function spatialSigma_Callback(hObject, eventdata, handles)
% hObject    handle to spatialSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spatialSigma as text
%        str2double(get(hObject,'String')) returns contents of spatialSigma as a double


% --- Executes during object creation, after setting all properties.
function spatialSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spatialSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in currentBlobPopUp.
function currentBlobPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to currentBlobPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns currentBlobPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from currentBlobPopUp


% --- Executes during object creation, after setting all properties.
function currentBlobPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentBlobPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% determines the current slide position

slider_position = get(hObject,'Value');
currentSlide = round(handles.N(3)*slider_position);
%set(handles.currentSlideNumber,'String',num2str(currentSlide));
handles.currentSlide = currentSlide;

% puts the image according to the slider position
axes(handles.axes1); image(handles.x(:,:,currentSlide)); axis image off; colorbar off; colorbar(handles.colorbar);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in exportTiffs.
function exportTiffs_Callback(hObject, eventdata, handles)
% hObject    handle to exportTiffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Begin export ...');
if (exist('tiff','dir') == 0) 
    mkdir('tiff');
    name = 'raw';
else
    button = questdlg('Do you want to to change the name (default is ''raw'')?     .');
    if strcmp(button,'Yes')
        msgbox('Enter the new name in the matlab command window.             .','modal');
        name = input('Enter name and press enter: ','s');
    elseif  strcmp(button,'No')
        button1 = questdlg('Do you want to overwrite data?  .');
        if strcmp(button1,'Yes')
            name = 'raw';
        else
            disp('Export was canceled.'); 
            return;
        end
    else
        disp('Export was canceled.'); 
        return;
    end
end

map = colormap(gray(256));
for i = 1:size(handles.x,3)
    imwrite(255*handles.x(:,:,i)./max(handles.x(:)),map,['tiff\' name '_' num2str(i,'%03g') '.tif']);
end
disp('export ended.');



% --- Executes on button press in loadSpectra.
function loadSpectra_Callback(hObject, eventdata, handles)
% hObject    handle to loadSpectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid1 = uigetfile('.txt');
fid = fopen(fid1);
g = fgets(fid);
a = fscanf(fid,'%g',[11 inf]);
a = a';
for i = 1:9
    handles.blob(i).profile = a(:,i+1);
end
fclose(fid);
handles.loadSpectraIndicator = 1;
guidata(hObject,handles);
