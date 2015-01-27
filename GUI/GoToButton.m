function [] = GoToButton(hObject, eventdata, handles)
	% Function called by the "GoTo" button in the scan panel. Turns the mouse into a cursor
	% so that a point on the scan may be selected. Instuments are then sent to that location
	% (galvos, piezos) and the relevent fields are updated.

	% Get x and y coordinates on mouse click
	[x, y, button, ax] = ginputc(1, 'Color', 'k', 'Linewidth', 1.5);
    
    delete(findobj(handles.Axes1, 'Type', 'Line', 'Marker', '+'));
	% Determine which axes are "on"
	xAxOn = get(handles.xCheckBox, 'Value');
	yAxOn = get(handles.yCheckBox, 'Value');
	zAxOn = get(handles.zCheckBox, 'Value');

	allAxOn = [xAxOn, yAxOn, zAxOn];

	axInd = find(allAxOn == 1);
	axMap = ['x', 'y', 'z'];

	% Check to make sure user actually clicked on the coorect axes (Axes1)
	if ax == handles.Axes1

		% Set first axis to new value, including boxes
		ax1 = axMap(axInd(1));
		set(eval(['handles.current', upper(ax1)]), 'String', num2str(x));
		WriteVoltageXYZ(axInd(1), x);
		if sum(allAxOn) == 2
			% If there is a second axis, move to axis 2 position and set boxes
			ax2 = axMap(axInd(2));
			set(eval(['handles.current', upper(ax2)]), 'String', num2str(y));
			WriteVoltageXYZ(axInd(2), y);
        end
        hold on;
        plot(handles.Axes1, x, y, 'k+', 'MarkerSize', 28, 'linewidth', 2);
	else
		% If user did not click on Axes1, do nothing
		h = msgbox('Please select a point within the scan window.');
    end
    guidata(hObject, handles);

end
