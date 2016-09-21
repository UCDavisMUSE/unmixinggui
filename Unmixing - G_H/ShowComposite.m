function varargout = ShowComposite(varargin)

% Last Modified by GUIDE v2.5 18-Jan-2011 00:23:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShowComposite_OpeningFcn, ...
                   'gui_OutputFcn',  @ShowComposite_OutputFcn, ...
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


% --- Executes just before ShowComposite is made visible.
function ShowComposite_OpeningFcn(hObject, eventdata, handles, varargin)
clc;
handlesOriginal = varargin{1};
handles.spectra = handlesOriginal.spectra;
handles.markerColors = handlesOriginal.markerColors; 
handles.maxNumberOfSpectra = handlesOriginal.maxNumberOfSpectra;
handles.pathname = handlesOriginal.pathname;
handles.imagesPathname = handlesOriginal.imagesPathname;
handles.spectraPathname = handlesOriginal.spectraPathname;
handles.FFPathname = handlesOriginal.FFPathname;
handles.unmixedImagesPathname = handlesOriginal.unmixedImagesPathname;

for i = 1:handles.maxNumberOfSpectra
    eval(['set(handles.name' num2str(i) ',''String'',handles.spectra(' num2str(i) ').name);']); 
    eval(['set(handles.name' num2str(i) ',''BackgroundColor'','... 
        'handles.markerColors{' num2str(i) '});']);
    if handles.spectra(i).show
        eval(['set(handles.select' num2str(i) ',''Value'',1);']); 
    else
        eval(['set(handles.select' num2str(i) ',''Visible'',''off'');']); 
        eval(['set(handles.name' num2str(i) ',''Visible'',''off'');']); 
    end
end

handles.composite = CreateComposite(handles.spectra, handles.maxNumberOfSpectra, 0);
Update(handles);

% Choose default command line output for ShowComposite
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ShowComposite wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ShowComposite_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

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

% --- Executes on button press in select1.
function select1_Callback(hObject, eventdata, handles)
handles.spectra(1).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select2_Callback(hObject, eventdata, handles)
handles.spectra(2).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select3_Callback(hObject, eventdata, handles)
handles.spectra(3).show = get(hObject,'Value');
guidata(hObject, handles);
handles = Update(handles);
guidata(hObject, handles);
function select4_Callback(hObject, eventdata, handles)
handles.spectra(4).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select5_Callback(hObject, eventdata, handles)
handles.spectra(5).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select6_Callback(hObject, eventdata, handles)
handles.spectra(6).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select7_Callback(hObject, eventdata, handles)
handles.spectra(7).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select8_Callback(hObject, eventdata, handles)
handles.spectra(8).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select9_Callback(hObject, eventdata, handles)
handles.spectra(9).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);
function select10_Callback(hObject, eventdata, handles)
handles.spectra(10).show = get(hObject,'Value');
handles = Update(handles);
guidata(hObject, handles);

function handles = Update(handles)
handles.composite = CreateComposite(handles.spectra, handles.maxNumberOfSpectra, ...
    get(handles.scaleComponents,'Value'));
axes(handles.axes1);
imagesc(handles.composite);
axis image off;
title('Composite');

% --------------------------------------------------------------------
function exportComponentsAsTiffs_Callback(hObject, eventdata, handles)
myCell = {'*.tif', 'TIFF (16 bit) (*.tif)'; ...
        '*.jpg','JPG (*.jpg)'};
   
myTitle = GetLastFolderNameFromPathname(handles.pathname);
[filename, pathname, filterindex] = uiputfile( myCell, ...
        'Save components as', fullfile(handles.unmixedImagesPathname, myTitle));
if size(pathname,2) == 1
    return;
end

handles.unmixedImagesPathname = pathname;
saveToDefaultPathTxtFile(handles);
guidata(hObject,handles);

[junk, stripedName, ext] = fileparts(filename);
if isempty(ext)
    if filterindex == 1 
        ext = '.tif';
    end
    if filterindex == 2 
        ext = '.jpg';
    end
    filename = fullfile(stripedName, ext);
end

if strcmp(ext, '.tif')
    j = 0;
    bool = 0;
    for i = 1:handles.maxNumberOfSpectra
        if handles.spectra(i).show
            j = j + 1;
            % for transmision values are low, less then for example 10
            if (mean(handles.spectra(i).component(:)) < 10)
                if ~get(handles.scaleComponents,'Value')
                    imwrite(uint16(1000*handles.spectra(i).component), ...
                        fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_raw', ext]));
                else            
                    imwrite(uint16((2^16-1)*handles.spectra(i).component/max(max(handles.spectra(i).component))), ...
                        fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_scaled', ext]));
                    % bool = 1;
                end
            else
                % this is fluorescence case
                if ~get(handles.scaleComponents,'Value')
                    imwrite(uint16(handles.spectra(i).component), ...
                        fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_raw', ext]));
                else
                    imwrite(uint16((2^16-1)*handles.spectra(i).component/max(max(handles.spectra(i).component))), ...
                        fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_scaled', ext]));
                end
            end
        end
    end
    
    % if bool
    %     imwrite(uint8(1000*handles.composite),fullfile(pathname, ['composite_raw', ext]));
    %     imwrite(uint8((2^16-1)*handles.composite/max(max(max(handles.composite)))), fullfile(pathname, ['composite_scaled', ext]));
    % else
    if ~get(handles.scaleComponents,'Value')
        imwrite(uint16(handles.composite),fullfile(pathname, [stripedName '_composite', ext]));
    else
        imwrite(uint16(handles.composite),fullfile(pathname, [stripedName '_composite_scaled', ext]));
    end
        
        
    % imwrite(uint8((2^16-1)*handles.composite/max(max(max(handles.composite)))), fullfile(pathname, ['composite_scaled', ext]));
    % end
end % of tif case
if strcmp(ext, '.jpg')
    for i = 1:handles.maxNumberOfSpectra
        if handles.spectra(i).show
            % here the image is always scaleComponents ; 
            imwrite(uint8(255*double(handles.spectra(i).component)/ ...
                    double(max(handles.spectra(i).component(:)))), ...
                    fullfile(pathname, [stripedName, '_' handles.spectra(i).name, '_scaled', ext]),'Quality',100);
        end
    end   
    imwrite(uint8(255*double(handles.composite)/ ...
                    double(max(handles.composite(:)))), ...
                    fullfile(pathname, [stripedName, '_composite', ext]),'Quality',100);
end % of jpg case
msgbox('Exporting done','modal');

function saveToDefaultPathTxtFile(handles)
[path1, name1, ext1] = fileparts(which(mfilename));
fid = fopen(fullfile(path1,'DefaultPath.txt'), 'wt');

fprintf(fid, '%s\n', handles.imagesPathname);
fprintf(fid, '%s\n', handles.spectraPathname);
fprintf(fid, '%s\n', handles.FFPathname);
fprintf(fid, '%s\n', handles.unmixedImagesPathname);
fclose(fid);


% --- Executes on button press in selectAll.
function selectAll_Callback(hObject, eventdata, handles)

for i = 1:handles.maxNumberOfSpectra
    if strcmp(eval(['get(handles.select' num2str(i) ',''Visible'')']),'on')
        handles.spectra(i).show = 1;
        eval(['set(handles.select' num2str(i) ',''Value'',1);']);
    end
end

handles = Update(handles);
guidata(hObject, handles);


% --- Executes on button press in scaleComponents.
function scaleComponents_Callback(hObject, eventdata, handles)
handles = Update(handles);
guidata(hObject, handles);
