function varargout = LaserIIGui(varargin)
% LASERIIGUI MATLAB code for LaserIIGui.fig
%      LASERIIGUI, by itself, creates a new LASERIIGUI or raises the existing
%      singleton*.
%
%      H = LASERIIGUI returns the handle to a new LASERIIGUI or the handle to
%      the existing singleton*.
%
%      LASERIIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LASERIIGUI.M with the given input arguments.
%
%      LASERIIGUI('Property','Value',...) creates a new LASERIIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LaserIIGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LaserIIGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LaserIIGui

% Last Modified by GUIDE v2.5 19-Jan-2015 17:11:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LaserIIGui_OpeningFcn, ...
                   'gui_OutputFcn',  @LaserIIGui_OutputFcn, ...
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


% --- Executes just before LaserIIGui is made visible.
function LaserIIGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LaserIIGui (see VARARGIN)

% Choose default command line output for LaserIIGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LaserIIGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LaserIIGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xMinAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xMinAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xMinAx2 as text
%        str2double(get(hObject,'String')) returns contents of xMinAx2 as a double


% --- Executes during object creation, after setting all properties.
function xMinAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xMinAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xMaxAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xMaxAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xMaxAx2 as text
%        str2double(get(hObject,'String')) returns contents of xMaxAx2 as a double


% --- Executes during object creation, after setting all properties.
function xMaxAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xMaxAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xPointsAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xPointsAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xPointsAx2 as text
%        str2double(get(hObject,'String')) returns contents of xPointsAx2 as a double


% --- Executes during object creation, after setting all properties.
function xPointsAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xPointsAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x0Ax2_Callback(hObject, eventdata, handles)
% hObject    handle to x0Ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0Ax2 as text
%        str2double(get(hObject,'String')) returns contents of x0Ax2 as a double


% --- Executes during object creation, after setting all properties.
function x0Ax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0Ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yMinAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yMinAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yMinAx2 as text
%        str2double(get(hObject,'String')) returns contents of yMinAx2 as a double


% --- Executes during object creation, after setting all properties.
function yMinAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yMinAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yMaxAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yMaxAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yMaxAx2 as text
%        str2double(get(hObject,'String')) returns contents of yMaxAx2 as a double


% --- Executes during object creation, after setting all properties.
function yMaxAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yMaxAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yPointsAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yPointsAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yPointsAx2 as text
%        str2double(get(hObject,'String')) returns contents of yPointsAx2 as a double


% --- Executes during object creation, after setting all properties.
function yPointsAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yPointsAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y0Ax2_Callback(hObject, eventdata, handles)
% hObject    handle to y0Ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y0Ax2 as text
%        str2double(get(hObject,'String')) returns contents of y0Ax2 as a double


% --- Executes during object creation, after setting all properties.
function y0Ax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y0Ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xOffsetAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xOffsetAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xOffsetAx2 as text
%        str2double(get(hObject,'String')) returns contents of xOffsetAx2 as a double


% --- Executes during object creation, after setting all properties.
function xOffsetAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xOffsetAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yOffsetAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yOffsetAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yOffsetAx2 as text
%        str2double(get(hObject,'String')) returns contents of yOffsetAx2 as a double


% --- Executes during object creation, after setting all properties.
function yOffsetAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yOffsetAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dtAx2_Callback(hObject, eventdata, handles)
% hObject    handle to dtAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtAx2 as text
%        str2double(get(hObject,'String')) returns contents of dtAx2 as a double


% --- Executes during object creation, after setting all properties.
function dtAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scanNumAx2_Callback(hObject, eventdata, handles)
% hObject    handle to scanNumAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scanNumAx2 as text
%        str2double(get(hObject,'String')) returns contents of scanNumAx2 as a double


% --- Executes during object creation, after setting all properties.
function scanNumAx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scanNumAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scanButtonAx2.
function scanButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to scanButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in goToButtonAx2.
function goToButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to goToButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveButtonAx2.
function saveButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to saveButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in zoomButtonAx2.
function zoomButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to zoomButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in getLocationButtonAx2.
function getLocationButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to getLocationButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetZoomButtonAx2.
function resetZoomButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to resetZoomButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in setToCurrentAx2.
function setToCurrentAx2_Callback(hObject, eventdata, handles)
% hObject    handle to setToCurrentAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in addMarkerButtonAx2.
function addMarkerButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to addMarkerButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clearMarkersButtonAx2.
function clearMarkersButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to clearMarkersButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in yPlusButtonAx2.
function yPlusButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yPlusButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in yMinusButtonAx2.
function yMinusButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yMinusButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in xPlusButtonAx2.
function xPlusButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xPlusButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in xMinusButtonAx2.
function xMinusButtonAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xMinusButtonAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in xCheckAx2.
function xCheckAx2_Callback(hObject, eventdata, handles)
% hObject    handle to xCheckAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xCheckAx2


% --- Executes on button press in yCheckAx2.
function yCheckAx2_Callback(hObject, eventdata, handles)
% hObject    handle to yCheckAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yCheckAx2


% --- Executes on button press in clearTrackAx2Button.
function clearTrackAx2Button_Callback(hObject, eventdata, handles)
% hObject    handle to clearTrackAx2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in storeTrackAx2.
function storeTrackAx2_Callback(hObject, eventdata, handles)
% hObject    handle to storeTrackAx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ax2TrackingDT_Callback(hObject, eventdata, handles)
% hObject    handle to ax2TrackingDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax2TrackingDT as text
%        str2double(get(hObject,'String')) returns contents of ax2TrackingDT as a double


% --- Executes during object creation, after setting all properties.
function ax2TrackingDT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2TrackingDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ax2DeltaX_Callback(hObject, eventdata, handles)
% hObject    handle to ax2DeltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax2DeltaX as text
%        str2double(get(hObject,'String')) returns contents of ax2DeltaX as a double


% --- Executes during object creation, after setting all properties.
function ax2DeltaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2DeltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ax2DeltaY_Callback(hObject, eventdata, handles)
% hObject    handle to ax2DeltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ax2DeltaY as text
%        str2double(get(hObject,'String')) returns contents of ax2DeltaY as a double


% --- Executes during object creation, after setting all properties.
function ax2DeltaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax2DeltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
