function varargout = CPSfunction(varargin)
% Last Modified by GUIDE v2.5 30-Nov-2010 00:51:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CPSfunction_OpeningFcn, ...
                   'gui_OutputFcn',  @CPSfunction_OutputFcn, ...
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

% --- Executes just before CPSfunction is made visible.
function CPSfunction_OpeningFcn(hObject, eventdata, handles, varargin)
clc;
handlesOriginal = varargin{1};
handles.maxNumberOfSpectra = handlesOriginal.maxNumberOfSpectra;
handles.wavelength = handlesOriginal.wavelength;
handles.legend = handlesOriginal.legend;
handles.spectra = handlesOriginal.spectra;
handles.cube = handlesOriginal.cube;
handles.markerColors = handlesOriginal.markerColors;
for i = 1:handles.maxNumberOfSpectra
    eval(['set(handles.name' num2str(i) ',''String'',handles.spectra(' num2str(i) ').name);']); 
    eval(['set(handles.name' num2str(i) ',''BackgroundColor'','... 
        'handles.markerColors{' num2str(i) '});']);
    eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[0.8 0.8 0.8]);']);
end

j = 0;
foundFirstAvailable = 0;
for i = 1:handles.maxNumberOfSpectra
    % eval(['set(handles.select' num2str(i) ',''String'',''Component #' num2str(i) ''');']); 
    if handles.spectra(i).show
        j = j + 1;
        selectedNamesStruct{j} = handles.spectra(i).name;
        handles.match(j) = i;
        eval(['set(handles.select' num2str(i) ',''Value'',1);']); 
        eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[0.2 0.2 0.2]);']); 
    else
        if ~handles.spectra(i).show && ~foundFirstAvailable 
            firstAvailable = i;
            foundFirstAvailable = 1;
        end
    end
    allNamesStruct{i} = handles.spectra(i).name;
end

if ~isfield(handles,'match')
    close
    msgbox('Select more components','modal');
    return;
else
    set(handles.Aselection,'String', selectedNamesStruct);
    set(handles.Aselection,'Value',1);
    set(handles.Aselection,'BackgroundColor', handles.spectra(handles.match(1)).color);
end
if size(handles.match,2) == 1 % make sure match{2} exists
    close
    msgbox('Select more components','modal');
    return;
else
    set(handles.Bselection,'String', selectedNamesStruct);
    set(handles.Bselection,'Value',2);
    set(handles.Bselection,'BackgroundColor', handles.spectra(handles.match(2)).color);
end

set(handles.Cselection,'String', allNamesStruct);
set(handles.Cselection,'BackgroundColor', handles.spectra(firstAvailable).color);
set(handles.Cselection,'Value',firstAvailable);

Update_Callback(hObject, eventdata, handles);

% Choose default command line output for CPSfunction
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CPSfunction wait for user response (see UIRESUME)
uiwait;

% --- Outputs from this function are returned to the command line.
function varargout = CPSfunction_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
if isfield(handles, 'spectra')
   varargout{1} = handles.spectra;
   close;
else
    varargout{1} = [];
end

function select1_Callback(hObject, eventdata, handles)
if handles.spectra(1).exist
    handles.spectra(1).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end
function select2_Callback(hObject, eventdata, handles)
if handles.spectra(2).exist
    handles.spectra(2).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end
function select3_Callback(hObject, eventdata, handles)
if handles.spectra(3).exist
    handles.spectra(3).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end
function select4_Callback(hObject, eventdata, handles)
if handles.spectra(4).exist
    handles.spectra(4).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end
function select5_Callback(hObject, eventdata, handles)
if handles.spectra(5).exist
    handles.spectra(5).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end
function select6_Callback(hObject, eventdata, handles)
if handles.spectra(6).exist
    handles.spectra(6).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end
function select7_Callback(hObject, eventdata, handles)
if handles.spectra(7).exist
    handles.spectra(7).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end

function select8_Callback(hObject, eventdata, handles)
if handles.spectra(8).exist
    handles.spectra(8).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end

function select9_Callback(hObject, eventdata, handles)
if handles.spectra(9).exist
    handles.spectra(9).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end

function select10_Callback(hObject, eventdata, handles)
if handles.spectra(10).exist
    handles.spectra(10).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in scaled.
function scaled_Callback(hObject, eventdata, handles)
% --- Executes on selection change in sign.

% --- Executes on selection change in Aselection.
function Aselection_Callback(hObject, eventdata, handles)
number = get(hObject,'Value');
set(handles.Aselection,'BackgroundColor', handles.spectra(handles.match(number)).color);

% contents = get(hObject,'String');
% contents{get(hObject,'Value')}

% --- Executes on selection change in Bselection.
function Bselection_Callback(hObject, eventdata, handles)
number = get(hObject,'Value');
set(handles.Bselection,'BackgroundColor', handles.spectra(handles.match(number)).color);

% --- Executes on selection change in Cselection.
function Cselection_Callback(hObject, eventdata, handles)
number = get(hObject,'Value');
set(handles.Cselection,'BackgroundColor', handles.spectra(number).color);

% --- Executes on button press in Update.
function handles = Update_Callback(hObject, eventdata, handles)
axes(handles.axes2);
cla;

for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).show
        plot(handles.axes2, handles.wavelength, handles.spectra(i).data, 'Color',handles.spectra(i).color);
        hold on
    end
end
b = axis;
axis([min(handles.wavelength), max(handles.wavelength), 0 , b(4)]);
xlabel('Wavelength (nm)');
ylabel('Intensity');

% handles.legend = CreateLegend(handles);
% if isempty(handles.legend)
%     legend hide
% else
%     legend(handles.legend)
% end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)

Aindex = handles.match(get(handles.Aselection,'Value'));
Bindex = handles.match(get(handles.Bselection,'Value'));
Cindex = get(handles.Cselection,'Value');
sign = double(get(handles.sign,'Value'));
if ~get(handles.scaled,'Value')
   
    if sign == 2
        sign = -1;
    end
    
    temp = sign*(handles.spectra(Aindex).data - handles.spectra(Bindex).data);
    temp = temp.*(temp>0);
        
    % cosmetics
else
    % this is the ASE alghorithm
    cube1 = handles.cube;
    if sign ~= 1
        vector = handles.spectra(Aindex).data;
    else
        vector = handles.spectra(Bindex).data;
    end
            
    scaler = FindCoeff( vector, cube1, 1);
    
    cube1 = SubtractSpectra( vector, scaler, cube1);
    
    temp = FindNextVector( cube1, mean(cube1,3));
    
end
handles.spectra(Cindex).data = temp;
handles.spectra(Cindex).exist = 1;
handles.spectra(Cindex).show = 1;

eval(['set(handles.select' num2str(Cindex) ',''Value'',1);']);
eval(['set(handles.draw' num2str(Cindex) ',''BackgroundColor'',[0.2 0.2 0.2]);']);

Update_Callback(hObject, eventdata, handles);

% find first available for Cselection
foundFirstAvailable = 0;
for i = 1:handles.maxNumberOfSpectra
    if ~handles.spectra(i).show && ~foundFirstAvailable 
            firstAvailable = i;
            foundFirstAvailable = 1;
    end
end

set(handles.Cselection,'BackgroundColor', handles.spectra(firstAvailable).color);
set(handles.Cselection,'Value',firstAvailable);

eval(['set(handles.select' num2str(Aindex) ',''Value'',0);']);
handles.spectra(Aindex).show = 0;

guidata(hObject, handles);

% --- Executes on button press in saveAndClose.
function saveAndClose_Callback(hObject, eventdata, handles)
uiresume;

function name1_Callback(hObject, eventdata, handles)
handles.spectra(1).name = get(hObject,'String');
guidata(hObject, handles);
function name2_Callback(hObject, eventdata, handles)
handles.spectra(2).name = get(hObject,'String');
guidata(hObject, handles);
function name3_Callback(hObject, eventdata, handles)
handles.spectra(3).name = get(hObject,'String');
guidata(hObject, handles);
function name4_Callback(hObject, eventdata, handles)
handles.spectra(4).name = get(hObject,'String');
guidata(hObject, handles);
function name5_Callback(hObject, eventdata, handles)
handles.spectra(5).name = get(hObject,'String');
guidata(hObject, handles);
function name6_Callback(hObject, eventdata, handles)
handles.spectra(6).name = get(hObject,'String');
guidata(hObject, handles);
function name7_Callback(hObject, eventdata, handles)
handles.spectra(7).name = get(hObject,'String');
guidata(hObject, handles);
function name8_Callback(hObject, eventdata, handles)
handles.spectra(8).name = get(hObject,'String');
guidata(hObject, handles);
function name9_Callback(hObject, eventdata, handles)
handles.spectra(9).name = get(hObject,'String');
guidata(hObject, handles);
function name10_Callback(hObject, eventdata, handles)
handles.spectra(10).name = get(hObject,'String');
guidata(hObject, handles);
