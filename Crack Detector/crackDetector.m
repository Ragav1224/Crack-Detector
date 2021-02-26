function varargout = crackDetector(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crackDetector_OpeningFcn, ...
                   'gui_OutputFcn',  @crackDetector_OutputFcn, ...
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


% --- Executes just before crackDetector is made visible.
function crackDetector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crackDetector (see VARARGIN)

% Choose default command line output for crackDetector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crackDetector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = crackDetector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in imageSelectButton.
function imageSelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageSelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global image

%Getting i,age input from user.
[filename pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
imageN = strcat(pathname, filename);
image = imread(imageN);

%Show image in axes1
axes(handles.axes1);
imshow(image)


% --- Executes on button press in crackDetectButton.
function crackDetectButton_Callback(hObject, eventdata, handles)
% hObject    handle to crackDetectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global image
global r

grayImage = image;

%Finding threshold value
r = rgb2gray(grayImage);
thresh=graythresh(r);

%Setting threshold value on slider and slider text
set(handles.slider1,'value',thresh);
set(handles.threshold,'string',thresh);

regionSeperat=imbinarize(r,thresh);
j = medfilt2(regionSeperat);

%Function call for process the image to find the cracks
er = processImage(j);

%Showing crack detected image in axes2
axes(handles.axes2); 
imshow(er);

%Calculating the cracked area in pixel
measurements = regionprops(er, 'Area');
set(handles.crakedArea,'string',measurements.Area);



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global r

%Get slider value and display it on text
a = get(handles.slider1,'value');
set(handles.threshold,'string',a);

regionSeperat=imbinarize(r,a);
j = medfilt2(regionSeperat);


%Function call for process the image to find the cracks
er = processImage(j);

%Showing crack detected image in axes2
axes(handles.axes2); 
imshow(er);

%Calculating the cracked area in pixel
measurements = regionprops(er, 'Area');
set(handles.crakedArea,'string',measurements.Area);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setThresh.
function setThresh_Callback(hObject, eventdata, handles)
% hObject    handle to setThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = str2double(get(handles.threshold,'string'));
set(handles.slider1,'value',val);

global r

%Getting slider value and show it in text
a = get(handles.slider1,'value');
set(handles.threshold,'string',a);

regionSeperat=imbinarize(r,a);
j = medfilt2(regionSeperat);

%Function call for process the image to find the cracks
er = processImage(j);

%Showing crack detected image in axes2
axes(handles.axes2); 
imshow(er);

%Calculating the cracked area in pixel
measurements = regionprops(er, 'Area');
set(handles.crakedArea,'string',measurements.Area);


function crakedArea_Callback(hObject, eventdata, handles)
% hObject    handle to crakedArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of crakedArea as text
%        str2double(get(hObject,'String')) returns contents of crakedArea as a double


% --- Executes during object creation, after setting all properties.
function crakedArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to crakedArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
