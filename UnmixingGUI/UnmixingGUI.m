function varargout = UnmixingGUI(varargin)
% UnmixingGUI M-file for UnmixingGUI.fig
%      UnmixingGUI, by itself, creates a new UnmixingGUI or raises the existing
%      singleton*.
%
%      H = UnmixingGUI returns the handle to a new UnmixingGUI or the handle to
%      the existing singleton*.
%
%      UnmixingGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UnmixingGUI.M with the given input arguments.
%
%      UnmixingGUI('Property','Value',...) creates a new UnmixingGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before UnmixingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UnmixingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UnmixingGUI

% Last Modified by GUIDE v2.5 17-Jan-2011 19:39:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UnmixingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @UnmixingGUI_OutputFcn, ...
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

% --- Executes just before UnmixingGUI is made visible.
function UnmixingGUI_OpeningFcn(hObject, eventdata, handles, varargin)

% cosmetics:
clc;
set(handles.figure1,'Name','UnmixingGUI');
axes(handles.axes1);
cla;
axis image
set(handles.axes1,'YTickLabel',[])
set(handles.axes1,'XTickLabel',[])
title('');

xlabel(handles.axes2,'Wavelength (nm)');
ylabel(handles.axes2,'Intensity');
set(handles.axes2,'YTickLabel',[])
set(handles.axes2,'XTickLabel',[])
title('');

handles.doChangeCloseAllKey = 0;
handles.defaultCloseAllKey = 'tab';

% checks if there is a default path file in the current folder
% lets for now have 4 default folders for images, spectra, flatField, and
% unmixed components
%
[path1, name1, ext1] = fileparts(which(mfilename));
path2 = path1(1: find(path1 == filesep, 1, 'last'));
% Add path to ASE functions
addpath([path2,'subroutines'])
fid = fopen(fullfile(path2,'subroutines','DefaultPath.txt'));
%fid = fopen(which('DefaultPath.txt'));
if fid == -1
    handles.imagesPathname = which(mfilename);
    handles.spectraPathname = which(mfilename);
    handles.FFPathname = which(mfilename);
    handles.unmixedImagesPathname = which(mfilename);
    handles = changeDefaultPath_Callback(hObject, eventdata, handles);
else
    handles.imagesPathname = fgetl(fid);
    handles.spectraPathname = fgetl(fid);
    handles.FFPathname = fgetl(fid);
    handles.unmixedImagesPathname = fgetl(fid);
    fclose(fid);
end

% sets display panel 
set(handles.displayRaw, 'Value', 0);
set(handles.displayScaled, 'Value', 1);
set(handles.brightnessSlider,'Value',0.5);
set(handles.contrastSlider,'Value',0.5);
set(handles.displayRgb,'Value',1);
set(handles.displayStack,'Value',0);

% set spectra panel
% we have three columns, 1) draw, 2) select, 3) name
handles.maxNumberOfSpectra = 10;
handles.tempSpectrumIndex = handles.maxNumberOfSpectra + 1;

% make sure that if you change number of checkboxes to add more in the figure
% and also add more colors
handles.markerColors = {...
    [255,   0,   0]/255, ...
    [  0, 255,   0]/255, ...
    [  0,   0, 255]/255, ...
    [255, 192,   0]/255, ...
    [238,   0, 238]/255, ...
    [150,  50,   0]/255, ... 
    [255, 182, 179]/255, ...
    [  0, 206, 209]/255, ...
    [255, 255, 255]/255, ...
    [  0,   0,   0]/255, ...
    [  0, 127,   0]/255};  % this last one is a tempSpectra color
handles.markerColorNames = {...
    'Red', ...
    'Green', ...
    'Blue', ...
    'Yellow', ...
    'Magenta', ...
    'Brown', ...
    'Pink', ...
    'Cyan', ...
    'White', ...
    'Black', ...
    'Greenish'};
% For colors, google 'rgb values'. The first link is:
% http://cloford.com/resources/colours/500col.htm

% set colors behind the name
for i = 1:handles.maxNumberOfSpectra
    eval(['set(handles.name' num2str(i) ',''BackgroundColor'','... 
        'handles.markerColors{' num2str(i) '});']);
    eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[0.8 0.8 0.8]);']);
end

% sets various things 
set(handles.indexText,'String','');
set(handles.showMarker, 'Value',1);  % will be using patch function 
handles.numberOfAllowedHotPixels = 5;
handles.setup.bitDepth = 14;

handles.setup.filterWidth = 10; % in nm
handles.setup.cameraMaxValue = 2^handles.setup.bitDepth - 1;
handles.setup.kodakTable = csvread('KodakSensorData.csv');

handles.boolForMouseMotionInsideAxes1 = 0;

handles.colorbarState = 0;

handles.output = hObject;

handles.mouseButtonPressed = 0;

% we will store the handles.index in the UserData of figure.
% the reason is that it seems 'KeyPreessed' and 'Scrol Wheell' don't want
% to store things back in the handles variable.

set(handles.figure1, 'UserData', 1);

% handles = LoadStack_Callback(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% Choose default command line output for UnmixingGUI
function varargout = UnmixingGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% Menu
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
delete(handles.figure1)

function closeAll_Callback(hObject, eventdata, handles)
ButtonName = questdlg('Do you want to close Composite too?', ...
                         'Close composite');
 
h = findobj('type','figure');
disp(num2str(length(h)))
for i = 1:length(h)
    switch h(i).Name
        case 'UnmixingGUI'
        case 'ShowComposite' 
            if strcmp(ButtonName, 'Yes')
                close(h(i))
            end
        otherwise
            close(h(i))
    end
end

% --------------------------------------------------------------------
% to be updated
function saveRGBImage_Callback(hObject, eventdata, handles)
myCell = {'*.tif', 'TIFF (8 bit) (*.tif)'; ...
        '*.jpg','JPG (*.jpg)'};
[filename, pathname, filterindex] = uiputfile( myCell, ...
        'Save RGB images as',handles.unmixedImagesPathname);
    
if size(pathname,2) == 1
    return;
end

handles.unmixedImagesPathname = pathname;
saveToDefaultPathTxtFile(handles);

[junk1, junk2, ext] = fileparts(filename);
if isempty(ext)
    if filterindex == 1 
        ext = '.tif';
    end
    if filterindex == 2 
        ext = '.jpg';
    end
    filename = [filename ext];
end
if strcmp(ext,'.tif')
    imwrite(handles.RGBImage,fullfile(pathname, filename));
elseif strcmp(ext,'.jpg')
    % imwrite(uint16(handles.RGBImage), fullfile(pathname, filename),'Bitdepth',12);
    imwrite(uint8(255*double(handles.RGBImage)/double(max(handles.RGBImage(:)))),fullfile(pathname, filename),'jpg','Bitdepth',8); % 'mode', 'lossy', 'Quality', 85);
end

guidata(hObject, handles);

% imwrite(handles.RGBImage,fullfile(pathname,filename));
 % --------------------------------------------------------------------
 % to be updated
function loadRGBImage_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.*'},'Open Image', handles.unmixedImagesPathname);
if size(pathname,2) == 1
    return;
end

handles.unmixedImagesPathname = pathname;
saveToDefaultPathTxtFile(handles);

handles.RGBImage = uint8(imread([pathname filename]));
axes(handles.axes1);
imagesc(handles.RGBImage);
axis image off
set(handles.axes1,'Tag','axes1');
title(filename, 'FontSize',10,'Interpreter','none');
set(handles.displayRgb,'Value',1);
guidata(hObject, handles);

% --------------------------------------------------------------------
function changeFilterWidth_Callback(hObject, eventdata, handles)
a = inputdlg('Enter new CCD filter width', 'Setup',1, {num2str(handles.setup.filterWidth)});
if ~isempty(a) && ~isnan((str2double(a)))
    handles.setup.filterWidth = str2double(a);
    guidata(hObject,handles);
end
% --------------------------------------------------------------------
function changeBitDepth_Callback(hObject, eventdata, handles)
a = inputdlg('Enter new bit depth', 'Setup', 1, {num2str(handles.setup.bitDepth)});
if ~isempty(a) && ~isnan((str2double(a)))
    handles.setup.bitDepth = str2double(a);
    guidata(hObject,handles);
end

% ---------------------------
% 1) simple means of loading
% ---------------------------
function handles = InitializeSpectrum(handles, i)
handles.spectra(i).x = zeros(20,1);  % no need for more then 20 pixels in the marker
handles.spectra(i).y = zeros(20,1);
handles.spectra(i).data = zeros(handles.N(3),1);
handles.spectra(i).max = 0;
handles.spectra(i).exist = 0;
handles.spectra(i).show = 0;
handles.spectra(i).color = handles.markerColors{i};
handles.spectra(i).name = handles.markerColorNames{i};
handles.spectra(i).component = zeros(handles.N(1), handles.N(2));

function handles = InitializeSpectra(handles)
for i = 1:handles.maxNumberOfSpectra
    handles = InitializeSpectrum(handles, i);
    eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[1 0.82 0.82]);']);
    eval(['set(handles.select' num2str(i) ',''Value'',0);']);
    eval(['set(handles.name' num2str(i) ',''String'',handles.spectra(' num2str(i) ').name);']);
end
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.legend = CreateLegend(handles);

% --- Executes on button press in LoadStack.
function handles = LoadStack_Callback(hObject, eventdata, handles)

% theText = 'All the data for the current stack will be lost. Continue?';
% button = questdlg(textwrap({theText}, 25));
% if ~strcmp(button,'Yes')
%   return;
% end

[filename, pathname] = uigetfile({'*.tif'},'Load images', handles.imagesPathname);

if size(pathname,2) == 1
    return;
end

handles.imagesPathname = pathname;

saveToDefaultPathTxtFile(handles);


[handles.cube, handles.filenames] = LoadCube(pathname);

handles.pathname = pathname;

% from now on we will have two cubes, one with raw data, and one for
% display

handles.N = size(handles.cube);
% I think the reason for this is to ensure that N is length three
% with N(3) = 1 if handles.cube is a 2D array
handles.N(3) = size(handles.cube,3);

handles = InitializeSpectra(handles);

% Computes RGB image
handles.wavelength = zeros(handles.N(3), 1);
handles.colorWeight = zeros(handles.N(3), 3);
handles.RGBImage = zeros(handles.N(1), handles.N(2), 3);

for i = 1:handles.N(3) 
    handles.images(i).rawData = double(handles.cube(:,:,i));
    handles.images(i).displayData = uint16(handles.cube(:,:,i));
    handles.images(i).backupData = zeros(handles.N(1),handles.N(2));
    handles.images(i).ffData = zeros(handles.N(1),handles.N(2));
    handles.images(i).wavelength = GetWavelengthFromName(handles.filenames(i).name);
    % for that wavelength and CCD filterWidth, I find area under the three
    % RGB curves of the Kodak sensor
    handles.images(i).colorWeight = CalculateWeightFromWavelength(handles.images(i).wavelength, handles.setup.kodakTable, handles.setup.filterWidth);  
    handles.RGBImage = handles.RGBImage + BWToRGB( handles.images(i).rawData, handles.images(i).colorWeight);
    handles.wavelength(i) = handles.images(i).wavelength;
end

handles.maxRGBImage = max(handles.RGBImage(:));
handles.minRGBImage = min(handles.RGBImage(:));

% converts RGBImage to scaled uint16
handles.RGBImage = handles.RGBImage - handles.minRGBImage;
handles.RGBImage = uint16((2^16-1)*handles.RGBImage/handles.maxRGBImage);

% handles.cube = uint16(handles.cube); % uint16 

% initializes interface 
handles.index = 1;
handles = UpdateSlider(handles);

set(handles.displayRaw, 'Value', 0);
set(handles.displayScaled, 'Value', 1);
set(handles.brightnessSlider,'Value',0.5);
set(handles.contrastSlider,'Value',0.5);
set(handles.displayRgb,'Value',1);
set(handles.displayStack,'Value',0);

set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});
set(handles.figure1,'WindowKeyPressFcn',{@KeyPressed, handles});

handles = UpdateAxes2(handles);

handles.updateAxes1 = 1;

guidata(hObject, handles);

if isfield(handles, 'FF')
   ButtonName = questdlg('Apply correction with existing flat field?', ...
                         'Flat fielding');
   if strcmp(ButtonName,'Yes')
       handles = FlatFieldCorrection(handles);
   end
       
end
guidata(hObject, handles);
Update_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function CorrectWithFlatField_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile({'*.tif'},'Load flat field images', handles.FFPathname);
if size(pathname,2) == 1
    return;
end
handles.FFPathname = pathname;

saveToDefaultPathTxtFile(handles);

% handles.FFpathname = 'C:\Users\nesa\ForRichard\ForRichard\Transmission\FlatFieldTrans_Stack\';
[handles.FF, handles.FFfilenames] = LoadCube(pathname);
handles = FlatFieldCorrection(handles);
guidata(hObject, handles);
Update_Callback(hObject, eventdata, handles);

function handles = FlatFieldCorrection(handles)

% stores radData in backupData
if sum(handles.images(1).backupData(:)) == 0
    for i = 1:handles.N(3)
        handles.images(i).backupData = handles.images(i).rawData;
    end
end

mi = 2^16;
ma = 0;
% calculates new cube
if sum(size(handles.images(1).backupData) == size(handles.FF(:,:,1))) < 2
    msgbox('Can not correct with flat field because of image size mismatch', 'modal');
    return;
end

for i = 1:handles.N(3)
    handles.images(i).ffData = handles.FF(:,:,i);
    handles.images(i).rawData = -log10(handles.images(i).backupData ./ handles.images(i).ffData);
    % if '-log10' created few infinities, modifies them to some
    % reasonable median values, should be only few pixels anyway.
    handles.images(i).rawData(isinf(handles.images(i).rawData)) = median(handles.images(i).rawData(:));
    handles.images(i).rawData = handles.images(i).rawData .* (handles.images(i).rawData > 0);
    mi = min(mi, min(handles.images(i).rawData(:)));
    ma = max(ma, max(handles.images(i).rawData(:)));
    handles.cube(:,:,i) = handles.images(i).rawData;
    
end

% Computes new RGB image
handles.RGBImage = zeros(handles.N(1), handles.N(2), 3);
for i = 1:handles.N(3) 
    handles.RGBImage = handles.RGBImage + BWToRGB( handles.images(i).rawData, handles.images(i).colorWeight);
end

handles.maxRGBImage = max(handles.RGBImage(:));
handles.minRGBImage = min(handles.RGBImage(:));
handles.RGBImage = handles.RGBImage - handles.minRGBImage;
handles.RGBImage = uint16((2^16-1)*handles.RGBImage/handles.maxRGBImage);

% inverts the RGB image 
handles.RGBImage = (2^16) - 1 - handles.RGBImage;

% scales the displayData to some reasonable values

for i = 1:handles.N(3)
    % sum(sum(handles.images(i).rawData < 0))  % negative values turn out to be less then 5%
    handles.images(i).displayData = handles.images(i).rawData;
    handles.images(i).displayData = handles.images(i).displayData / ma;
    handles.images(i).displayData = (2^handles.setup.bitDepth-1)*(handles.images(i).displayData);
    handles.images(i).displayData = uint16(handles.images(i).displayData);    
end

% initializes interface 
handles.index = 1;
handles = UpdateSlider(handles);

set(handles.displayRaw, 'Value', 0);
set(handles.displayScaled, 'Value', 1);
set(handles.brightnessSlider,'Value',0.5);
set(handles.contrastSlider,'Value',0.5);
set(handles.displayRgb,'Value',1);
set(handles.displayStack,'Value',0);

set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
set(handles.figure1,'WindowScrollWheelFcn',{@ScrollWheel, handles});
set(handles.figure1,'WindowKeyPressFcn',{@KeyPressed, handles});

handles = UpdateAxes2(handles);

handles.updateAxes1 = 1;

function displayRgb_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.displayStack,'Value',0);
else
    set(handles.displayStack,'Value',1);
end
Update_Callback(hObject, eventdata, handles);

function displayStack_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.displayRgb,'Value',0);
else
    set(handles.displayRgb,'Value',1);
end
Update_Callback(hObject, eventdata, handles)

function displayScaled_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.displayRaw, 'Value', 0);
%     set(handles.brightnessSlider,'Value',1);
%     set(handles.contrastSlider,'Value',0);
%     set(handles.brightnessSlider,'Value',0);
%     set(handles.contrastSlider,'Value',0);
%     set(handles.gammaSlider,'Value',0);
else
    set(handles.displayRaw, 'Value', 1);
%     handles.minScale = 0;
%     handles.maxScale = handles.setup.cameraMaxValue;
%     set(handles.brightnessSlider,'Value',0);
%     set(handles.contrastSlider,'Value',1);
%     set(handles.brightnessSlider,'Value',0.5);
%     set(handles.contrastSlider,'Value',0.5);
%     set(handles.gammaSlider,'Value',0.5);
end;
guidata(hObject, handles);
Update_Callback(hObject, eventdata, handles);

function displayRaw_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.displayScaled, 'Value', 0);
else
    set(handles.displayScaled, 'Value', 1);
end
Update_Callback(hObject, eventdata, handles);

function brightnessSlider_Callback(hObject, eventdata, handles)
set(handles.displayRaw,'Value',1);
set(handles.displayScaled,'Value',0);
Update_Callback(hObject,eventdata,handles);

function contrastSlider_Callback(hObject, eventdata, handles)
set(handles.displayRaw,'Value',1);
set(handles.displayScaled,'Value',0);
Update_Callback(hObject,eventdata,handles);

function handles = UpdateSlider(handles)
if handles.N(3) == 0
    set(handles.indexSlider, 'Value', 0);
    set(handles.indexSlider, 'SliderStep', [1, 0.1]);
elseif handles.N(3) == 1
    set(handles.indexSlider, 'Value', 0);
    set(handles.indexSlider, 'SliderStep', [1, 0.1]);
else
    set(handles.indexSlider,'Value', (handles.index-1)/(handles.N(3)-1));
    %set(handles.indexSlider, 'SliderStep', [1/(handles.N(3)-1), 0.1]);
    % The above code was throwing a warning. Changed to
    set(handles.indexSlider, 'SliderStep', [1/(handles.N(3) - 1), 1/(handles.N(3) - 1)]);
end
set(handles.indexText,'String', ['# ' num2str(handles.index) ' / ' ...
    num2str(handles.N(3)) '         ' num2str(handles.images(handles.index).wavelength) ' nm']);

% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
% info = getCursorInfo(handles.axes1)
if strcmp(get(handles.colorbarToggle,'State'),'on')
    handles.colorbarState = 1;
end

handles = UpdateSlider(handles);

% Updates axes1
axes(handles.axes1);
% cla;
if ~isfield(handles, 'images')
    msgbox('Load stack first');
    return
end
        
if get(handles.displayRgb,'Value')
    % display RGB image
    if get(handles.displayRaw,'Value')
        % display raw
        % here I first get the values from the sliders
        b = get(handles.brightnessSlider, 'Value');
        c = get(handles.contrastSlider, 'Value');
        % then find out the lower and upper boundary that will be used by imadjust
        lower = max(1-b - (1-c), 0);
        upper = min(1-b + (1-c), 1);
        if upper<=lower 
            upper = lower + 0.001;
        end
        if lower>=upper 
            lower = upper - 0.001;
        end
        J = imadjust(handles.RGBImage, [lower*ones(1,3); upper*ones(1,3)],[]); 
    else
        % display scaled
        J = handles.RGBImage;
    end
    
    
    oldXLim = handles.axes1.XLim;
    oldYLim = handles.axes1.YLim;
    imshow(J);
    if any(oldXLim ~= [0, 1]) || any(oldYLim ~= [0, 1])
        set(handles.axes1,'XLim',oldXLim,'YLim',oldYLim);
    end
    
    set(handles.axes1,'Tag','axes1');
    handles.updateAxes1 = 0;   
    title(GetLastFolderNameFromPathname(handles.pathname),...
          'FontSize',10,'Interpreter','none');
      
    set(handles.indexText,'String','RGB image')
    
%         
else  % end of rgb
    % display image from the stack
    if get(handles.displayRaw,'Value')
        % display raw
        
        % here I first get the values from the sliders
        b = get(handles.brightnessSlider, 'Value');
        c = get(handles.contrastSlider, 'Value');
        % then find out the lower and upper boundary that will be used by imadjust
        lower = max(1-b - (1-c), 0);
        upper = min(1-b + (1-c), 1);
        if upper<=lower 
            upper = lower + 0.001;
        end
        if lower>=upper 
            lower = upper - 0.001;
        end
        J = imadjust(handles.images(handles.index).displayData, [lower upper]/2^(16 - handles.setup.bitDepth),[]);  % adjusts for the camera bit depth   
    else
        % display scaled
        % % finds the tolerance for hot pixels
        tol = handles.numberOfAllowedHotPixels/(handles.N(1)*handles.N(2));
        % finds limits to contrast strech
        a = stretchlim(handles.images(handles.index).displayData,tol);
        % adjust auto-contrast
        J = imadjust(handles.images(handles.index).displayData, a, []);
    end
    oldXLim = handles.axes1.XLim;
    oldYLim = handles.axes1.YLim;
    imshow(J);
    if any(oldXLim ~= [0, 1]) || any(oldYLim ~= [0, 1])
        set(handles.axes1,'XLim',oldXLim,'YLim',oldYLim);
    end
    set(handles.axes1,'XLim',oldXLim,'YLim',oldYLim);
    set(handles.axes1,'Tag','axes1');
    handles.updateAxes1 = 0;
    title([GetLastFolderNameFromPathname(handles.pathname) filesep handles.filenames(handles.index).name],...
            'FontSize',10,'Interpreter','none');
        
    % show stack of images - old
%         if (get(handles.displayScaled,'Value') == 0)
%             if get(handles.displayStack,'Value')
%                 temp = BWToRGB( handles.cube(:,:,handles.index), handles.colorWeight(handles.index,:));
%                 imagesc(uint8(250*temp/max(temp(:))));
%             else
%                 % most popular
%                 temp = handles.cube(:,:,handles.index);
%                 if get(handles.showMarker,'Value')
%                     temp = BWToRGB(handles.cube(:,:,handles.index));
%                     temp = uint8(250*temp/max(temp(:)));
%                     
%                     d = 1;
%                     for j = 1:handles.maxNumberOfSpectra
%                         if handles.spectra(j).show
%                              for  i = 1:length(handles.spectra(j).x)
%                                 xx = handles.spectra(j).x(i);
%                                 yy = handles.spectra(j).y(i);
%                                 temp(xx + (-d:d), yy + (-d:d),1) = 250*handles.spectra(j).color(1);
%                                 temp(xx + (-d:d), yy + (-d:d),2) = 250*handles.spectra(j).color(2);
%                                 temp(xx + (-d:d), yy + (-d:d),3) = 250*handles.spectra(j).color(3);                               
%                              end
%                         end
%                     end
%                 end
%                 
%                 axes(handles.axes1);
%                 % imagesc(temp);
%                 imshow(temp)
%                 
%             end
%             set(handles.axes1,'Tag','axes1');
%             handles.updateAxes1 = 0;    
%         else
%             if get(handles.displayStack,'Value')
%                 temp = BWToRGB( handles.cube(:,:,handles.index), handles.colorWeight(handles.index,:));
%                 imagesc( temp/max(temp(:)), [handles.minScale, handles.maxScale]);                
%             else
%                 %imagesc(handles.cube(:,:,handles.index),[handles.minScale, handles.maxScale]);
%                 %brightness = (2*get(handles.brightnessSlider,'Value') - 1);
%                 % map = colormap(gray(handles.maxScale - handles.minScale));
%                 % map = brighten(brightness);
%                 imshow(handles.cube(:,:,handles.index), [handles.minScale, handles.maxScale]);
%             end
%             set(handles.axes1,'Tag','axes1');
%             handles.updateAxes1 = 0;
%         end
%         colormap(gray);
end
% axis image; % off; 
if get(handles.showMarker,'Value')
         for j = 1:handles.maxNumberOfSpectra
             if handles.spectra(j).show
                 h = patch(handles.spectra(j).y, handles.spectra(j).x,'w','LineWidth',2,'EdgeColor',handles.spectra(j).color);
                 % h = fill(handles.spectra(j).y, handles.spectra(j).x,'w','LineWidth',2,'EdgeColor',handles.spectra(j).color,'Type','open');
                 % get(h)
             end
         end
end 

if handles.colorbarState == 1
    colorbar
end

function handles = UpdateAxes2(handles)
axes(handles.axes2);
cla;
for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).show
        plot(handles.axes2, handles.wavelength, handles.spectra(i).data, 'Color',handles.spectra(i).color);
        hold on
    end
end
% b = axis;
% axis([handles.images(1).wavelength handles.images(handles.N(3)).wavelength, b(3), b(4)]);
xlabel('Wavelength (nm)');
ylabel('Intensity');

% handles.legend = CreateLegend(handles);
% if isempty(handles.legend)
%     legend hide
% else
%     legend(handles.legend)
% end
% --- Executes on button press in scaleToMax.
function scaleToMax_Callback(hObject, eventdata, handles)
% hObject    handle to scaleToMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'spectra')
    return;
end

if get(hObject,'Value')
    
    % find the max values for all the spectra
    handles.maxMaxSpectraValue = 0;
    for i = 1:handles.maxNumberOfSpectra
        handles.maxMaxSpectraValue = max(max(handles.spectra(i).data), handles.maxMaxSpectraValue);
        handles.spectra(i).max = max(handles.spectra(i).data(:));
    end
    
    % scale spectra
    for i = 1:handles.maxNumberOfSpectra
        % handles.spectra(i).data = handles.spectra(i).data / handles.maxSpectraValue;
        if handles.spectra(i).exist && handles.spectra(i).max ~= 0
            handles.spectra(i).data = handles.spectra(i).data / handles.spectra(i).max;
        end
    end
    handles = UpdateAxes2(handles);
    axis([handles.images(1).wavelength, handles.images(handles.N(3)).wavelength, 0 , 1.1]);
else
    % scale back the spectra 
    for i = 1:handles.maxNumberOfSpectra
        % handles.spectra(i).data = handles.spectra(i).data * handles.maxMaxSpectraValue;
        handles.spectra(i).data = handles.spectra(i).data * handles.spectra(i).max;
    end
    handles = UpdateAxes2(handles);
    axis([handles.images(1).wavelength, handles.images(handles.N(3)).wavelength, 0 , 1.1*handles.maxMaxSpectraValue + 0.01]);
end
set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});

guidata(hObject,handles);
xlabel('Wavelength (nm)');
ylabel('Intensity');
% --- Executes on slider movement.
function indexSlider_Callback(hObject, eventdata, handles)
slider_position = get(hObject,'Value');
handles.index = round((handles.N(3) - 1)*slider_position + 1);
% exception when slider goes all the way to the end
if handles.index > handles.N(3)
    handles.index = handles.N(3);
end
if handles.index < 1
    handles.index = 1;
end
set(handles.figure1,'UserData',handles.index);
guidata(hObject, handles);
Update_Callback(hObject, eventdata, handles);

% ---------------------------
% 3) Spectral selection
% ---------------------------
% -------------------
% Live Spectra
% -------------------
% Idea on how to store spectra in the component:
% 1: click on draw button
% 2: mouse press down, and inside the boundaries, start acquiring. As you
% are acquiring store the mean so as the points are added,
% you don't need to average all again
%     keep a track of a number of points by pointNumber variable, with this
%     you won't have to remove trailing zeros
% 3: mouse button up, stop acquiring, plot the temp averaged spectrum

% % some variation of MouseMotion
% function MouseMotion1(src, eventdata, handles)
% % next version might read out guidata as:
% % handles = guidata(src);
% 
% % read and understand this:
% % http://www.mathworks.com/matlabcentral/newsreader/view_thread/132061
% 
% % reads current point from the axes1
% pt = get(handles.axes1,'CurrentPoint');
% % for some reason, 'pt' has two similar rows and extra coordinate, only one row and two coordinates are needed
% pt = pt(1,[1,2]);
% x = get(handles.axes1,'XLim');
% y = get(handles.axes1,'YLim');
% if pt(1) > x(1) && pt(1) < x(2) && pt(2) > y(1) && pt(2) < y(2)
%     pt = round(pt);
%     % for now, handles.tempSpectrumIndex is going to be 11th spectrum, helping us to store
%     % temporary spectrum
%     temp = shiftdim(handles.cube(pt(2), pt(1),:));
%     plot(handles.axes2, 1:21, temp, 'Color', [1 0 0]);
%     
%     if handles.mouseButtonPressed
%         % handles.current = get(handles.axes1,'UserData');
%         a = get(handles.axes1,'UserData');
%         a = a + 1
%         handles.current = handles.current + 1;
%         % disp(handles.current)
%         handles.store(handles.current).x = pt(2);
%         handles.store(handles.current).y = pt(1);
%         handles.store(handles.current).data = temp;
%         set(handles.axes1,'UserData',a);
%         % handles.spectra(handles.tempSpectrumIndex).data = handles.spectra(handles.tempSpectrumIndex).data + double(temp);
%         
%         % scale to one's max - live, to be implemented ...
% %         if get(handles.scaleToMax,'Value')
% %             handles.maxScale = max(max(temp),handles.maxScale);
% %         else
% %             handles.maxScale = 1;
% %         end    
%         
%         % set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
%         % set(handles.figure1,'WindowButtonUpFcn',{@MouseButtonUp, handles});
%            
%      end
%    
% end


function MouseMotion(hObject, eventdata, handles)
% next version might read out guidata as:
% handles = guidata(hObject);

% also read and understand this, might help speed this up:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/132061

% reads current point from the axes1
pt = get(handles.axes1,'CurrentPoint');
% for some reason, 'pt' has two similar rows and extra coordinate, only one row and two coordinates are needed
pt = pt(1,[1,2]);

% set(handles.figure1,'WindowButtonUpFcn',{@MouseButtonUp, handles});    

% determines boundaries in the case when the image is zoomed.
% note: axes are not matrix based but image based
x = get(handles.axes1,'XLim');
y = get(handles.axes1,'YLim');
% if the mouse pointer is inside the image boundaries, plots the spectra
if pt(1) > x(1) && pt(1) < x(2) && pt(2) > y(1) && pt(2) < y(2)
    pt = round(pt);
    if pt(1) == 0 
        pt(1) = 1;
    end
    if pt(2) == 0 
        pt(2) = 1;
    end
    
    % for now, handles.tempSpectrumIndex is going to be 11th spectrum, helping us to store
    % temporary spectrum
    temp = shiftdim(handles.cube(pt(2), pt(1),:));
    
    if handles.mouseButtonPressed
        handles.current = handles.current + 1;
        handles.spectra(handles.tempSpectrumIndex).x(handles.current) = pt(2);
        handles.spectra(handles.tempSpectrumIndex).y(handles.current) = pt(1);
        handles.spectra(handles.tempSpectrumIndex).data = handles.spectra(handles.tempSpectrumIndex).data + double(temp);
        
        % scale to one's max - live, to be implemented ...
%         if get(handles.scaleToMax,'Value')
%             handles.maxScale = max(max(temp),handles.maxScale);
%         else
%             handles.maxScale = 1;
%         end    
        
        set(hObject,'WindowButtonMotionFcn',{@MouseMotion, handles});
        set(hObject,'WindowButtonUpFcn',{@MouseButtonUp, handles});
    end
    
    if get(handles.scaleToMax,'Value')
        maxTemp = max(temp);
        temp = temp / maxTemp;
    end
    
     
    % updates axes2
    
    axes(handles.axes2);
        
    % cla;
    % scale to one's max - live, to be implemented
%     if get(handles.scaleToMax,'Value')
%         handles.maxScale = max(max(temp),handles.maxScale);
%     else
%         handles.maxScale = 1;
%     end
    
    for i = 1:handles.maxNumberOfSpectra
        if handles.spectra(i).show
            plot(handles.axes2, handles.wavelength, handles.spectra(i).data,'Color',handles.spectra(i).color);
            hold on
        end
    end

    plot(handles.axes2, handles.wavelength, temp, 'Color', handles.spectra(handles.tempSpectrumIndex).color);
    hold off
    xlabel('Wavelength (nm)');
    ylabel('Intensity');
%     drawnow('expose'); 
    
    % standard guidata doesn't work for mouse motion, but works with mouse down and
    % mouse up
    handles.boolForMouseMotionInsideAxes1 = 1; 
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
% else
%     if handles.boolForMouseMotionInsideAxes1
%         axes(handles.axes2);
%         for i = 1:handles.maxNumberOfSpectra
%             if handles.spectra(i).show
%                 plot(handles.axes2, handles.wavelength, handles.spectra(i).data,'Color',handles.spectra(i).color);
%                 hold on
%             end
%         end
%         hold off
%         xlabel('Wavelength (nm)');
%         ylabel('Intensity');
%         handles.boolForMouseMotionInsideAxes1 = 0; 
%         set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
%     end
end


function MouseButtonDown(src, eventdata, handles)
handles.current = 0;
handles.mouseButtonPressed = 1;
set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});

function MouseButtonUp(src, eventdata, handles)

set(handles.drawIndicator,'Value',0);
handles = SetAllDrawColors(handles);

% if ~isfield(handles, 'lastSelected')
%     set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
%     return;
% end

handles.mouseButtonPressed = 0;

handles.spectra(handles.lastSelected).x = RemoveTrailingZeros(handles.spectra(handles.tempSpectrumIndex).x);
handles.spectra(handles.lastSelected).y = RemoveTrailingZeros(handles.spectra(handles.tempSpectrumIndex).y);
handles.spectra(handles.lastSelected).data = handles.spectra(handles.tempSpectrumIndex).data / handles.current;
handles.spectra(handles.lastSelected).exist = 1;

% scale it if needed
if get(handles.scaleToMax,'Value')
    handles.spectra(handles.lastSelected).max = max(handles.spectra(handles.lastSelected).data);
    handles.spectra(handles.lastSelected).data = handles.spectra(handles.lastSelected).data / ...
    handles.spectra(handles.lastSelected).max;
    if handles.spectra(handles.lastSelected).max > handles.maxMaxSpectraValue
        handles.maxMaxSpectraValue = handles.spectra(handles.lastSelected).max;
    end
end

eval(['set(handles.select' num2str(handles.lastSelected) ',''Value'', 1);']);
handles.spectra(handles.lastSelected).show = 1;

handles = UpdateAxes2(handles);
guidata(handles.figure1, handles);

set(handles.figure1,'WindowButtonDownFcn','');
set(handles.figure1,'WindowButtonUpFcn','');
set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
Update_Callback(src, eventdata, handles);

function KeyPressed(src, eventdata, handles)

% guidata writing doesn't work here, but we can readout from it
handles = guidata(src);
handles.index = get(src,'UserData');

if strcmp(eventdata.Key, 'rightarrow') || strcmp(eventdata.Key, 'uparrow')
    handles.index = handles.index + 1;
    if handles.index >= handles.N(3) 
        handles.index = handles.N(3);
    end
elseif strcmp(eventdata.Key, 'leftarrow') || strcmp(eventdata.Key, 'downarrow')
    handles.index = handles.index - 1;
    if handles.index <= 1;
        handles.index = 1;
    end
elseif strcmp(eventdata.Key, handles.defaultCloseAllKey)  
    closeAll_Callback(src, eventdata, handles)
else 
    if handles.doChangeCloseAllKey
        handles.defaultCloseAllKey = eventdata.Key;
        handles.doChangeCloseAllKey = 0;
        msgbox(['Clear all key changed to ' eventdata.Key],'modal');
        guidata(handles.figure1, handles);
        set(handles.figure1,'WindowKeyPressFcn',{@KeyPressed, handles});
    else
        return
    end
end
set(src,'UserData',handles.index);
Update_Callback(src, eventdata, handles)


function ScrollWheel(src, eventdata, handles)
% guidata writing doesn't work here, but we can readout from it
handles = guidata(src);
handles.index = get(src,'UserData');
handles.index = handles.index + eventdata.VerticalScrollCount;
if handles.index >= handles.N(3) 
    handles.index = handles.N(3);
end
if handles.index <= 1;
    handles.index = 1;
end
set(src,'UserData',handles.index);
Update_Callback(src, eventdata, handles)

% -------------------

function handles = SetAllDrawColors(handles)
set(handles.drawIndicator,'Value',1);
for i = 1:handles.maxNumberOfSpectra
    eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[0.8 0.8 0.8]);']);
end

function draw1_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.axes1,'UserData',0);
set(handles.draw1,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 1;
guidata(hObject,handles);
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});  
function draw2_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw2,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 2;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw3_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw3,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 3;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw4_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw4,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 4;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw5_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw5,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 5;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw6_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw6,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 6;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw7_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw7,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 7;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw8_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw8,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 8;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw9_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw9,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 9;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});
function draw10_Callback(hObject, eventdata, handles)
zoom(handles.figure1, 'off');
handles = SetAllDrawColors(handles);
set(handles.draw10,'BackgroundColor',[0.2 0.2 0.2]);
handles = InitializeSpectrum(handles, handles.tempSpectrumIndex);
handles.lastSelected = 10;
set(handles.figure1,'WindowButtonDownFcn',{@MouseButtonDown, handles});

function select1_Callback(hObject, eventdata, handles)
if handles.spectra(1).exist
    handles.spectra(1).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end

function select2_Callback(hObject, eventdata, handles)
if handles.spectra(2).exist
    handles.spectra(2).show = get(hObject,'Value');
    guidata(hObject, handles);
    Update_Callback(hObject, eventdata, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end

function select3_Callback(hObject, eventdata, handles)
if handles.spectra(3).exist
    handles.spectra(3).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select4_Callback(hObject, eventdata, handles)
if handles.spectra(4).exist
    handles.spectra(4).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select5_Callback(hObject, eventdata, handles)
if handles.spectra(5).exist
    handles.spectra(5).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select6_Callback(hObject, eventdata, handles)
if handles.spectra(6).exist
    handles.spectra(6).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select7_Callback(hObject, eventdata, handles)
if handles.spectra(7).exist
    handles.spectra(7).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select8_Callback(hObject, eventdata, handles)
if handles.spectra(8).exist
    handles.spectra(8).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select9_Callback(hObject, eventdata, handles)
if handles.spectra(9).exist
    handles.spectra(9).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end
function select10_Callback(hObject, eventdata, handles)
if handles.spectra(10).exist
    handles.spectra(10).show = get(hObject,'Value');
    Update_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
    UpdateAxes2(handles);
    set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
end

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


% ---------------------------
% 3.4) Save/Load spectra
% ---------------------------
function loadSpectraMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadSpectraMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.mat'},'Load Spectra', handles.spectraPathname);
if filename == 0
    return;
end

load([pathname filename]);
handles.spectraPathname = pathname;
saveToDefaultPathTxtFile(handles);
guidata(hObject, handles);

% find first non-zero spectra in the new spectra
k = 1;
while (k <= handles.maxNumberOfSpectra) && (mean(spectra(k).data(:)) == 0)
    k = k + 1;
end
if k == handles.maxNumberOfSpectra + 1
    msgbox('Spectra file is empty','modal');
end 

if (mean(handles.cube(:)) > 100 * mean(spectra(k).data(:))) || ...
   (mean(spectra(k).data(:)) > 100 * mean(handles.cube(:)))
    msgbox('Incompatible spectra','modal');
    return;
end

if handles.N(3) ~= length(spectra(1).data)
    msgbox('Incompatible spectra','modal');
    return;
end

handles.spectra = spectra;


for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).exist
        eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[0.2 0.2 0.2]);']);
    end
    if handles.spectra(i).show
        eval(['set(handles.select' num2str(i) ',''Value'', 1);']);
    end
    eval(['set(handles.name' num2str(i) ',''String'', handles.spectra(' num2str(i) ').name);']);
   
end

guidata(hObject, handles);
UpdateAxes2(handles);
set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
Update_Callback(hObject, eventdata, handles)

function saveSpectraMenu_Callback(hObject, eventdata, handles)

name = ParsePathname(handles.pathname);

[filename, pathname] = uiputfile({'*.mat'},'Save Spectra',fullfile(handles.spectraPathname, name));
if filename == 0
    return;
end

handles.spectraPathname = pathname;
saveToDefaultPathTxtFile(handles);
guidata(hObject, handles);

spectra = handles.spectra;

for i = 1:numel(spectra)
    spectra(i).component = zeros(handles.N(1), handles.N(2));
end

save(fullfile(pathname,filename), 'spectra');


% count the number of spectra
n = 0;
for i = 1: handles.maxNumberOfSpectra
    if handles.spectra(i).show
        n = n + 1;
    end
end
matrixSpectra = zeros(handles.N(3), n);

% create matrixSpectra
j = 0;
for i = 1: handles.maxNumberOfSpectra
    if handles.spectra(i).show
        j = j + 1;
        matrixSpectra(:,j) = handles.spectra(i).data;
    end
end

[junk1, name, junk2] = fileparts(filename);

name = [name '.txt'];
temp = [handles.wavelength, matrixSpectra];
dlmwrite(fullfile(pathname, name), temp,'newline','pc');
% --------------------------------------------------------------------
% 4) unmixing (perhaps with non-negativity constraints), 
% ---------------------------

% --- Executes on button press in unmixButton.
function unmixButton_Callback(hObject, eventdata, handles)
set(handles.figure1,'WindowButtonMotionFcn','');

% count the number of spectra
n = 0;
for i = 1: handles.maxNumberOfSpectra
    if handles.spectra(i).show
        n = n + 1;
    end
end
matrixSpectra = zeros(handles.N(3), n);

% create matrixSpectra, which will then be used in UnmixAlgorithm
j = 0;
for i = 1: handles.maxNumberOfSpectra
    if handles.spectra(i).show
        j = j + 1;
        matrixSpectra(:,j) = handles.spectra(i).data;
%         handles.componentsColorWeight(i,:) = CalculateColorWeightsFromSpectrum( ...
%                         handles.wavelength, handles.spectra(i).data, handles.setup.kodakTable);    
    end
end

% Unmix (last parameter of the UnmixAlgorithm function is the unmixing method, 1 is pseudoinverse and is
% exactly the same as 2: normal matrix method.
components = UnmixAlgorithm(matrixSpectra, handles.cube, 1);

% Approximate the solution to positive values only
handles.negativeComponentsPart = components < 0;
components = components.*(components > 0) + 0.001;

numberOfShownSpectra = 0;
for i = 1:handles.maxNumberOfSpectra
    numberOfShownSpectra = numberOfShownSpectra + handles.spectra(i).show;
end

j = 0;
for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).show
        j = j + 1;
        handles.spectra(i).component = components(:,:,j);
        Shim(handles.spectra(i).component, j, numberOfShownSpectra, handles.spectra(i).name );
        
%         if get(handles.showNegativeAreas,'Value')
%             Shim(handles.negativeComponentsPart(:,:,j), j, handles.spectra(i).name );
%         end
       
    end
end
guidata(hObject, handles);

ShowComposite(handles);
set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});
guidata(hObject, handles);

% handles.composite = CreateComposite(handles.spectra, handles.maxNumberOfSpectra);
% Shim(handles.composite, n + 1, 'Composite' );
% colorbar off;

% --------------------------------------------------------------------
% ASE option
% --------------------------------------------------------------------
function ase_Callback(hObject, eventdata, handles)
handles.numberOfASEComponents = str2double(get(handles.numberOfASEComponentsToSearch,'String'));
handles.aseComponents = AseFunction(handles.cube, handles.numberOfASEComponents);
guidata(hObject, handles);
showASEComponents_Callback(hObject, eventdata, handles)
function showASEComponents_Callback(hObject, eventdata, handles)
if ~isfield(handles,'aseComponents')
    return;
end
for i = 1: handles.numberOfASEComponents
    % 'Border','tight'
    Shim(handles.aseComponents(:,:,i), i, handles.numberOfASEComponents, ['ASE component # ' num2str(i)]);
end

% --------------------------------------------------------------------
% CPS option
% --------------------------------------------------------------------
% --- Executes on button press in cpsButton.
function cpsButton_Callback(hObject, eventdata, handles)
% hObject    handle to cpsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp = CPSfunction(handles);
if ~isempty(temp)
    handles.spectra = temp;
end
guidata(hObject,handles);
handles = UpdateAxes2(handles);
for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).exist
        eval(['set(handles.draw' num2str(i) ',''BackgroundColor'',[0.2 0.2 0.2]);']); 
        if handles.spectra(i).show
            eval(['set(handles.select' num2str(i) ',''Value'',1);']);
            eval(['set(handles.name' num2str(i) ',''String'',handles.spectra(' num2str(i) ').name);']); 
        else
            eval(['set(handles.select' num2str(i) ',''Value'',0);']);
        end
    end
end
guidata(hObject,handles);

set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});

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
                imwrite(uint16(1000*handles.spectra(i).component), ...
                    fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_raw', ext]));
                imwrite(uint16((2^16-1)*handles.spectra(i).component/max(max(handles.spectra(i).component))), ...
                    fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_scaled', ext]));
                bool = 1;
            else
                % this is fluorescence case
                imwrite(uint16(handles.spectra(i).component), ...
                    fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_raw', ext]));
                imwrite(uint16((2^16-1)*handles.spectra(i).component/max(max(handles.spectra(i).component))), ...
                    fullfile(pathname, [stripedName '_' handles.spectra(i).name, '_scaled', ext]));
            end
        end
    end
    
    % if bool
    %     imwrite(uint8(1000*handles.composite),fullfile(pathname, ['composite_raw', ext]));
    %     imwrite(uint8((2^16-1)*handles.composite/max(max(max(handles.composite)))), fullfile(pathname, ['composite_scaled', ext]));
    % else
    imwrite(uint16(handles.composite),fullfile(pathname, [stripedName '_composite', ext]));
    % imwrite(uint8((2^16-1)*handles.composite/max(max(max(handles.composite)))), fullfile(pathname, ['composite_scaled', ext]));
    % end
end % of tif case
if strcmp(ext, '.jpg')
    for i = 1:handles.maxNumberOfSpectra
        if handles.spectra(i).show
            % here the image is always scaled ; 
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

% --- Executes on button press in showMarker.
function showMarker_Callback(hObject, eventdata, handles)
Update_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function handles = changeDefaultPath_Callback(hObject, eventdata, handles)
% hObject    handle to changeDefaultPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = uigetdir(handles.imagesPathname, 'Pick a Default RAW IMAGES Directory');
if size(pathname,2) ~= 1
    handles.imagesPathname = pathname;
else
    return
end

pathname = uigetdir(handles.spectraPathname, 'and a default SPECTRA directory');
if size(pathname,2) ~= 1
    handles.spectraPathname = pathname;
else
    return
end

pathname = uigetdir(handles.spectraPathname, 'and a default FLAT FIELD directory');
if size(pathname,2) ~= 1
    handles.FFPathname = pathname;
else
    return
end

pathname = uigetdir(handles.unmixedImagesPathname, 'and a default RGB, UNMIXED AND COMPOSITE IMAGES directory');
if size(pathname,2) ~= 1
    handles.unmixedImagesPathname = pathname;
else
    return
end

guidata(hObject, handles);
saveToDefaultPathTxtFile(handles);

function saveToDefaultPathTxtFile(handles)
[path1, name1, ext1] = fileparts(which(mfilename));
%fid = fopen(fullfile(path1,'subroutines','DefaultPath.txt'), 'wt');
fid = fopen(which('DefaultPath.txt'), 'wt');

fprintf(fid, '%s\n', handles.imagesPathname);
fprintf(fid, '%s\n', handles.spectraPathname);
fprintf(fid, '%s\n', handles.FFPathname);
fprintf(fid, '%s\n', handles.unmixedImagesPathname);
fclose(fid); 


% --------------------------------------------------------------------
function changeNumberOfAllowedHotPixels_Callback(hObject, eventdata, handles)
% hObject    handle to changeNumberOfAllowedHotPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in drawIndicator.
function drawIndicator_Callback(hObject, eventdata, handles)
% hObject    handle to drawIndicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drawIndicator


% --- Executes on button press in clearSpectra.
function clearSpectra_Callback(hObject, eventdata, handles)

theText = 'All the spectra will be lost. Continue?';
button = questdlg(textwrap({theText}, 25));
if ~strcmp(button,'Yes')
  return;
end

handles = InitializeSpectra(handles);
guidata(hObject, handles);
handles = UpdateAxes2(handles);
Update_Callback(hObject, eventdata, handles)
set(handles.clearSpectra,'Value',0');
set(handles.figure1,'WindowButtonMotionFcn',{@MouseMotion, handles});


% --- Executes on button press in showNegativeAreas.
function showNegativeAreas_Callback(hObject, eventdata, handles)

numberOfShownSpectra = 0;
for i = 1:handles.maxNumberOfSpectra
    numberOfShownSpectra = numberOfShownSpectra + handles.spectra(i).show;
end

j = 0;
for i = 1:handles.maxNumberOfSpectra
    if handles.spectra(i).show
        j = j + 1;
        Shim(handles.negativeComponentsPart(:,:,j), j, numberOfShownSpectra, handles.spectra(i).name);
    end
end

% --------------------------------------------------------------------
function changeCloseAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to changeCloseAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% figure(1);
% set(handles.figure1,'WindowKeyPressFcn',{@KeyPressedChangeCloseAll, handles});
% msgbox('Press new ''Close all'' key');

% this is unstable for some reason

handles.doChangeCloseAllKey = 1;
guidata(hObject, handles);
set(handles.figure1,'WindowKeyPressFcn',{@KeyPressed, handles});
msgbox('Click anywhere on a main window and press the key','Modal');
