function [] = PlusMinusButton(hObject, eventdata, handles, axis, pm)
% Executes step in plus/minus direction as specified by axis. pm is either
% 1 or -1, indicating the direction to step. Step size is
% specified in this function and may be changed if necessary. Steps are in
% volts
STEP_SIZE = .01; % Volts
xyz = 'XYZ'; % map from numbers to axis labels

% Read current voltage for axis to be updated
currentV = ReadVoltage(['Dev1/_ao', num2str(axis - 1), '_vs_aognd']);
newV = currentV + pm*STEP_SIZE; % Add (subtract) STEP_SIZE incriment
WriteVoltageXYZ(axis, newV); % Write the updated voltage to the appropriate channel

% Set GUI box to reflect new position
set(eval(['handles.current', xyz(axis)]), 'String', num2str(newV));

if axis == 1 || axis == 2
    delete(findobj(handles.Axes1, 'Type', 'Line', 'Marker', '+'));
    x0 = str2double(get(handles.currentX, 'String'));
    y0 = str2double(get(handles.currentY, 'String'));
    hold on;
    plot(handles.Axes1, x0, y0, 'k+', 'MarkerSize', 28, 'linewidth', 2);
end

% Update GUI
guidata(hObject, handles);


end

