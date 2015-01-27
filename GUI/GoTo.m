function [] = GoTo(hObject, eventdata, handles)
	% Moves current laser positon to x0, y0, z0 as set in boxes. Called before a scan begins 
	% and also called by the GoTo button after boxes are updated.

	% Take values entered in boxes, set value of box to
	% that value.
	[x0, xStatus] = str2num(get(handles.currentX, 'String'));
	[y0, yStatus] = str2num(get(handles.currentY, 'String'));
	[z0, zStatus] = str2num(get(handles.currentZ, 'String'));
	[dt, dtStatus] = str2num(get(handles.currentDt, 'String'));

	% Check to see if conversions worked (meaning that boxes contained numbers)
	if xStatus + yStatus + zStatus + dtStatus == 4
		set(handles.currentX, 'Value', x0);
		set(handles.currentY, 'Value', y0);
		set(handles.currentZ, 'Value', z0);
		set(handles.currentDt, 'Value', dt);


		% Write (x0, y0, z0) to DAQ. Out of range handling is done by WriteVoltage.
		WriteVoltageXYZ(1, x0);
		WriteVoltageXYZ(2, y0);
		WriteVoltageXYZ(3, z0);
		pause(1.0);
		guidata(hObject, handles);

	else
		error('Values in the (x0, y0, z0) boxes must be numbers.')
	end

end

