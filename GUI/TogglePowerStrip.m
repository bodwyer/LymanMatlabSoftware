function [] = TogglePowerStrip(hObject, eventdata, handles, device)
% Toggles between on/off for Laser, APD1, and APD2 connected to the remote
% controled power strip. Also fills in (blanks) the radio button. Called by
% clicking on radio button in gui
state = get(eval(['handles.', device, 'Button']), 'Value');
if state % if currently on, turn off
    PowerStripControl(device, 'ON');
else % if currently off, turn on
    PowerStripControl(device, 'OFF');
end

guidata(hObject, handles);

end

