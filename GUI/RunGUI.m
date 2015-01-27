function varargout = RunGUI(varargin)
% RUNGUI MATLAB code for RunGUI.fig
%      RUNGUI, by itself, creates a new RUNGUI or raises the existing
%      singleton*.
%
%      H = RUNGUI returns the handle to a new RUNGUI or the handle to
%      the existing singleton*.
%
%      RUNGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNGUI.M with the given input arguments.
%
%      RUNGUI('Property','Value',...) creates a new RUNGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RunGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RunGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RunGUI

% Last Modified by GUIDE v2.5 07-Dec-2014 23:25:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RunGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RunGUI_OutputFcn, ...
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


% --- Executes just before RunGUI is made visible.
function RunGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RunGUI (see VARARGIN)

% Choose default command line output for RunGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RunGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Add paths
% Add Spincore API files
addpath(genpath('C:\SpinCore\SpinAPI'));
addpath(genpath(GetPath()));

% Load drivers
LoadDrivers;

% Set default parameters
SetDefaults(hObject, eventdata, handles);


% --- Outputs from this function are returned to the command line.
function varargout = RunGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ScanButton.
function ScanButton_Callback(hObject, eventdata, handles)
% hObject    handle to ScanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[hObject, eventdata, handles] = ScanButton(hObject, eventdata, handles);



function xMax_Callback(hObject, eventdata, handles)
% hObject    handle to xMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xMax as text
%        str2double(get(hObject,'String')) returns contents of xMax as a double


% --- Executes during object creation, after setting all properties.
function xMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xPoints_Callback(hObject, eventdata, handles)
% hObject    handle to xPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xPoints as text
%        str2double(get(hObject,'String')) returns contents of xPoints as a double


% --- Executes during object creation, after setting all properties.
function xPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xCheckBox.
function xCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to xCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xCheckBox
set(handles.currentDt, 'String', '0.001');
guidata(hObject, handles);

% --- Executes on button press in yCheckBox.
function yCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to yCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yCheckBox
set(handles.currentDt, 'String', '0.001');
guidata(hObject, handles);

% --- Executes on button press in dtCheckBox.
function dtCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to dtCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dtCheckBox


% --- Executes on button press in zCheckBox.
function zCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to zCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zCheckBox
set(handles.currentDt, 'String', '0.1');
guidata(hObject, handles);


function xMin_Callback(hObject, eventdata, handles)
% hObject    handle to xMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xMin as text
%        str2double(get(hObject,'String')) returns contents of xMin as a double


% --- Executes during object creation, after setting all properties.
function xMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentX_Callback(hObject, eventdata, handles)
% hObject    handle to currentX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentX as text
%        str2double(get(hObject,'String')) returns contents of currentX as a double


% --- Executes during object creation, after setting all properties.
function currentX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yMax_Callback(hObject, eventdata, handles)
% hObject    handle to yMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yMax as text
%        str2double(get(hObject,'String')) returns contents of yMax as a double


% --- Executes during object creation, after setting all properties.
function yMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yPoints_Callback(hObject, eventdata, handles)
% hObject    handle to yPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yPoints as text
%        str2double(get(hObject,'String')) returns contents of yPoints as a double


% --- Executes during object creation, after setting all properties.
function yPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yMin_Callback(hObject, eventdata, handles)
% hObject    handle to yMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yMin as text
%        str2double(get(hObject,'String')) returns contents of yMin as a double


% --- Executes during object creation, after setting all properties.
function yMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentY_Callback(hObject, eventdata, handles)
% hObject    handle to currentY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentY as text
%        str2double(get(hObject,'String')) returns contents of currentY as a double


% --- Executes during object creation, after setting all properties.
function currentY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zMax_Callback(hObject, eventdata, handles)
% hObject    handle to zMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zMax as text
%        str2double(get(hObject,'String')) returns contents of zMax as a double


% --- Executes during object creation, after setting all properties.
function zMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zPoints_Callback(hObject, eventdata, handles)
% hObject    handle to zPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zPoints as text
%        str2double(get(hObject,'String')) returns contents of zPoints as a double


% --- Executes during object creation, after setting all properties.
function zPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zMin_Callback(hObject, eventdata, handles)
% hObject    handle to zMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zMin as text
%        str2double(get(hObject,'String')) returns contents of zMin as a double


% --- Executes during object creation, after setting all properties.
function zMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentZ_Callback(hObject, eventdata, handles)
% hObject    handle to currentZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentZ as text
%        str2double(get(hObject,'String')) returns contents of currentZ as a double


% --- Executes during object creation, after setting all properties.
function currentZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dtMax_Callback(hObject, eventdata, handles)
% hObject    handle to dtMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtMax as text
%        str2double(get(hObject,'String')) returns contents of dtMax as a double


% --- Executes during object creation, after setting all properties.
function dtMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dtPoints_Callback(hObject, eventdata, handles)
% hObject    handle to dtPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtPoints as text
%        str2double(get(hObject,'String')) returns contents of dtPoints as a double


% --- Executes during object creation, after setting all properties.
function dtPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dtMin_Callback(hObject, eventdata, handles)
% hObject    handle to dtMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtMin as text
%        str2double(get(hObject,'String')) returns contents of dtMin as a double


% --- Executes during object creation, after setting all properties.
function dtMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currentDt_Callback(hObject, eventdata, handles)
% hObject    handle to currentDt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentDt as text
%        str2double(get(hObject,'String')) returns contents of currentDt as a double


% --- Executes during object creation, after setting all properties.
function currentDt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentDt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GoToButton.
function GoToButton_Callback(hObject, eventdata, handles)
% hObject    handle to GoToButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GoToButton(hObject, eventdata, handles);

% --- Executes on button press in GetButton.
function GetButton_Callback(hObject, eventdata, handles)
% hObject    handle to GetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetToCurrentValues(hObject, eventdata, handles, true);

% --- Executes on slider movement.
function minCutoffSlider_Callback(hObject, eventdata, handles)
% hObject    handle to minCutoffSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
UpdatePlotScale(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function minCutoffSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minCutoffSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxCutoffSlider_Callback(hObject, eventdata, handles)
% hObject    handle to maxCutoffSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
UpdatePlotScale(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function maxCutoffSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxCutoffSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in colorSchemeMenu.
function colorSchemeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to colorSchemeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colorSchemeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorSchemeMenu
SetColorMap(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function colorSchemeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorSchemeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startTimeTraceButton.
function startTimeTraceButton_Callback(hObject, eventdata, handles)
% hObject    handle to startTimeTraceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StartTimeTrace(hObject, eventdata, handles);

% --- Executes on button press in stopTimeTraceButton.
function stopTimeTraceButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopTimeTraceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StopTimeTrace(hObject, eventdata, handles);

% --- Executes on button press in clearTimeTraceButton.
function clearTimeTraceButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearTimeTraceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function timeTraceDT_Callback(hObject, eventdata, handles)
% hObject    handle to timeTraceDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeTraceDT as text
%        str2double(get(hObject,'String')) returns contents of timeTraceDT as a double


% --- Executes during object creation, after setting all properties.
function timeTraceDT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeTraceDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveScanButton.
function saveScanButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveScanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveButton(hObject, eventdata, handles);

% --- Executes on button press in zoomButton.
function zoomButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Axes1);
if handles.zoomedIn
    zoom off;
    handles.zoomedIn = false;
else
    zoom on;
    handles.zoomedIn = true;
end
guidata(hObject, handles);
SetRangeToAxes(hObject, eventdata, handles, 'Current');


% --- Executes on button press in resetZoomButton.
function resetZoomButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetZoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off;
SetRangeToAxes(hObject, eventdata, handles, 'Original');

% --- Executes on button press in setCurrentButton.
function setCurrentButton_Callback(hObject, eventdata, handles)
% hObject    handle to setCurrentButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetToCurrentValues(hObject, eventdata, handles, true);

% --- Executes on button press in findNVsButton.
function findNVsButton_Callback(hObject, eventdata, handles)
% hObject    handle to findNVsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in NVListBox.
function NVListBox_Callback(hObject, eventdata, handles)
% hObject    handle to NVListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NVListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NVListBox


% --- Executes during object creation, after setting all properties.
function NVListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NVListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addNVButton.
function addNVButton_Callback(hObject, eventdata, handles)
% hObject    handle to addNVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AddNVToList(hObject, handles, 'new');

% --- Executes on button press in removeNVButton.
function removeNVButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeNVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RemoveNVFromList(hObject, handles);


function findNVFileName_Callback(hObject, eventdata, handles)
% hObject    handle to findNVFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findNVFileName as text
%        str2double(get(hObject,'String')) returns contents of findNVFileName as a double


% --- Executes during object creation, after setting all properties.
function findNVFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findNVFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findNVButton.
function findNVButton_Callback(hObject, eventdata, handles)
% hObject    handle to findNVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FindNVFromFile(hObject, handles);

% --- Executes on button press in chan0.
function chan0_Callback(hObject, eventdata, handles)
% hObject    handle to chan0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan0


% --- Executes on button press in chan1.
function chan1_Callback(hObject, eventdata, handles)
% hObject    handle to chan1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan1


% --- Executes on button press in chan2.
function chan2_Callback(hObject, eventdata, handles)
% hObject    handle to chan2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan2


% --- Executes on button press in chan3.
function chan3_Callback(hObject, eventdata, handles)
% hObject    handle to chan3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan3


% --- Executes on button press in chan4.
function chan4_Callback(hObject, eventdata, handles)
% hObject    handle to chan4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan4


% --- Executes on button press in chan5.
function chan5_Callback(hObject, eventdata, handles)
% hObject    handle to chan5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan5


% --- Executes on button press in chan6.
function chan6_Callback(hObject, eventdata, handles)
% hObject    handle to chan6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan6


% --- Executes on button press in chan7.
function chan7_Callback(hObject, eventdata, handles)
% hObject    handle to chan7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan7


% --- Executes on button press in chan8.
function chan8_Callback(hObject, eventdata, handles)
% hObject    handle to chan8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chan8


% --- Executes on button press in PBOnButton.
function PBOnButton_Callback(hObject, eventdata, handles)
% hObject    handle to PBOnButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PulseBlasterControls(hObject, eventdata, handles, 'ON');


% --- Executes on button press in PBOffButton.
function PBOffButton_Callback(hObject, eventdata, handles)
% hObject    handle to PBOffButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PulseBlasterControls(hObject, eventdata, handles, 'OFF');

% --- Executes on button press in trackNowButton.
function trackNowButton_Callback(hObject, eventdata, handles)
% hObject    handle to trackNowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.trackingText, 'Visible', 'on');
ReTrackButton(hObject, eventdata, handles);
set(handles.trackingText, 'Visible', 'off');

% --- Executes on button press in trackingOnCheckbox.
function trackingOnCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to trackingOnCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trackingOnCheckbox


% --- Executes on button press in showTrackingCheckbox.
function showTrackingCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to showTrackingCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showTrackingCheckbox


% --- Executes on button press in customTrackCheckbox.
function customTrackCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to customTrackCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of customTrackCheckbox



function trackBoxWidth_Callback(hObject, eventdata, handles)
% hObject    handle to trackBoxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trackBoxWidth as text
%        str2double(get(hObject,'String')) returns contents of trackBoxWidth as a double


% --- Executes during object creation, after setting all properties.
function trackBoxWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackBoxWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savePathBox_Callback(hObject, eventdata, handles)
% hObject    handle to savePathBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savePathBox as text
%        str2double(get(hObject,'String')) returns contents of savePathBox as a double


% --- Executes during object creation, after setting all properties.
function savePathBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savePathBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openSavePathButton.
function openSavePathButton_Callback(hObject, eventdata, handles)
% hObject    handle to openSavePathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathName = uigetdir();
if pathName ~= 0
  set(handles.savePathBox, 'String', [pathName, '\']);
  handles.saveStr = [pathName, '\'];
end

% --- Executes on button press in setSavePathButton.
function setSavePathButton_Callback(hObject, eventdata, handles)
% hObject    handle to setSavePathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.saveStr = get(handles.savePathBox, 'String');
guidata(hObject, handles);
% TO DO: if folder does not exist, create? Or at least throw error.

% --- Executes on button press in startCPSButton.
function startCPSButton_Callback(hObject, eventdata, handles)
% hObject    handle to startCPSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stopCPSButton.
function stopCPSButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopCPSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in xPlusButton.
function xPlusButton_Callback(hObject, eventdata, handles)
% hObject    handle to xPlusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlusMinusButton(hObject, eventdata, handles, 1, 1);

% --- Executes on button press in xMinusButton.
function xMinusButton_Callback(hObject, eventdata, handles)
% hObject    handle to xMinusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlusMinusButton(hObject, eventdata, handles, 1, -1);

% --- Executes on button press in yMinusButton.
function yMinusButton_Callback(hObject, eventdata, handles)
% hObject    handle to yMinusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlusMinusButton(hObject, eventdata, handles, 2, -1);

% --- Executes on button press in yPlusButton.
function yPlusButton_Callback(hObject, eventdata, handles)
% hObject    handle to yPlusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlusMinusButton(hObject, eventdata, handles, 2, 1);

% --- Executes on button press in zPlusButton.
function zPlusButton_Callback(hObject, eventdata, handles)
% hObject    handle to zPlusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlusMinusButton(hObject, eventdata, handles, 3, 1);

% --- Executes on button press in zMinusButton.
function zMinusButton_Callback(hObject, eventdata, handles)
% hObject    handle to zMinusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlusMinusButton(hObject, eventdata, handles, 3, -1);

% --- Executes on selection change in scriptListBox.
function scriptListBox_Callback(hObject, eventdata, handles)
% hObject    handle to scriptListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scriptListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scriptListBox


% --- Executes during object creation, after setting all properties.
function scriptListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scriptListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scriptAdderBox_Callback(hObject, eventdata, handles)
% hObject    handle to scriptAdderBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scriptAdderBox as text
%        str2double(get(hObject,'String')) returns contents of scriptAdderBox as a double


% --- Executes during object creation, after setting all properties.
function scriptAdderBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scriptAdderBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadConstantsCheckBox.
function loadConstantsCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to loadConstantsCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadConstantsCheckBox



function constantFileNameBox_Callback(hObject, eventdata, handles)
% hObject    handle to constantFileNameBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of constantFileNameBox as text
%        str2double(get(hObject,'String')) returns contents of constantFileNameBox as a double


% --- Executes during object creation, after setting all properties.
function constantFileNameBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantFileNameBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function repeatNTimesBox_Callback(hObject, eventdata, handles)
% hObject    handle to repeatNTimesBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeatNTimesBox as text
%        str2double(get(hObject,'String')) returns contents of repeatNTimesBox as a double


% --- Executes during object creation, after setting all properties.
function repeatNTimesBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeatNTimesBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in turnOffCheckBox.
function turnOffCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to turnOffCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of turnOffCheckBox


% --- Executes on button press in removeFromQueueButton.
function removeFromQueueButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeFromQueueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RemoveScriptFromQueue(hObject, eventdata, handles);

% --- Executes on button press in repeatCheckBox.
function repeatCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to repeatCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of repeatCheckBox



function multipleNVFileBox_Callback(hObject, eventdata, handles)
% hObject    handle to multipleNVFileBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multipleNVFileBox as text
%        str2double(get(hObject,'String')) returns contents of multipleNVFileBox as a double


% --- Executes during object creation, after setting all properties.
function multipleNVFileBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multipleNVFileBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openMultipleNVButton.
function openMultipleNVButton_Callback(hObject, eventdata, handles)
% hObject    handle to openMultipleNVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveMultipleNVButton.
function saveMultipleNVButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveMultipleNVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LASERButton.
function LASERButton_Callback(hObject, eventdata, handles)
% hObject    handle to LASERButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LASERButton
TogglePowerStrip(hObject, eventdata, handles,'LASER');

% --- Executes on button press in APD1Button.
function APD1Button_Callback(hObject, eventdata, handles)
% hObject    handle to APD1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of APD1Button
TogglePowerStrip(hObject, eventdata, handles,'APD1');

% --- Executes on button press in APD2Button.
function APD2Button_Callback(hObject, eventdata, handles)
% hObject    handle to APD2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of APD2Button
TogglePowerStrip(hObject, eventdata, handles,'APD2');

% --- Executes on button press in RFButton.
function RFButton_Callback(hObject, eventdata, handles)
% hObject    handle to RFButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RFButton


% --- Executes on button press in openPBGUIButton.
function openPBGUIButton_Callback(hObject, eventdata, handles)
% hObject    handle to openPBGUIButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in xyTrackCheck.
function xyTrackCheck_Callback(hObject, eventdata, handles)
% hObject    handle to xyTrackCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xyTrackCheck


% --- Executes on button press in zTrackCheck.
function zTrackCheck_Callback(hObject, eventdata, handles)
% hObject    handle to zTrackCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zTrackCheck


% --- Executes on button press in ClearTracking.
function ClearTracking_Callback(hObject, eventdata, handles)
% hObject    handle to ClearTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ClearTrackingData(hObject, eventdata, handles);

% --- Executes on button press in StoreButton.
function StoreButton_Callback(hObject, eventdata, handles)
% hObject    handle to StoreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StoreTrackingData(hObject, eventdata, handles, handles.saveStr);


% --- Executes on button press in addToQueue.
function addToQueue_Callback(hObject, eventdata, handles)
% hObject    handle to addToQueue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AddScriptToQueue(hObject, eventdata, handles);


% --- Executes on button press in runScriptButton.
function runScriptButton_Callback(hObject, eventdata, handles)
% hObject    handle to runScriptButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RunScripts(hObject, eventdata, handles);


% --- Executes on button press in StopScript.
function StopScript_Callback(hObject, eventdata, handles)
% hObject    handle to StopScript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ScriptRunning = false;
guidata(hObject, handles);


% --- Executes on button press in storeNVButton.
function storeNVButton_Callback(hObject, eventdata, handles)
% hObject    handle to storeNVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StoreNVLocationButton(hObject, eventdata, handles);



function scanCounter_Callback(hObject, eventdata, handles)
% hObject    handle to scanCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scanCounter as text
%        str2double(get(hObject,'String')) returns contents of scanCounter as a double


% --- Executes during object creation, after setting all properties.
function scanCounter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scanCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NVName_Callback(hObject, eventdata, handles)
% hObject    handle to NVName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NVName as text
%        str2double(get(hObject,'String')) returns contents of NVName as a double


% --- Executes during object creation, after setting all properties.
function NVName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NVName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadNVFromFile.
function loadNVFromFile_Callback(hObject, eventdata, handles)
% hObject    handle to loadNVFromFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AddNVToList(hObject, handles, 'file');



function dtTrackingBox_Callback(hObject, eventdata, handles)
% hObject    handle to dtTrackingBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtTrackingBox as text
%        str2double(get(hObject,'String')) returns contents of dtTrackingBox as a double


% --- Executes during object creation, after setting all properties.
function dtTrackingBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtTrackingBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addMarkerButton.
function addMarkerButton_Callback(hObject, eventdata, handles)
% hObject    handle to addMarkerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AddMarkerToPlot(hObject, handles);


% --- Executes on button press in clearMarkersButton.
function clearMarkersButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearMarkersButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(findobj(handles.Axes1, 'Type', 'Line', 'Marker', 'x'));



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offsetY_Callback(hObject, eventdata, handles)
% hObject    handle to offsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offsetY as text
%        str2double(get(hObject,'String')) returns contents of offsetY as a double


% --- Executes during object creation, after setting all properties.
function offsetY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
