function [] = SetToCurrentValues(hObject, eventdata, handles, marker)
	% Moves current positon to x0, y0, z0. Called before a scan begins 
	% and also called by the GoTo button.

	% Take values entered in boxes, set value of box to
	% that value.
    %
    % marker is a boolean. If true, a marker is drawn at current laser
    % position in x, y
    
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
        pause(0.2);
		WriteVoltageXYZ(2, y0);
        pause(0.2);
		WriteVoltageXYZ(3, z0);
        if xStatus == 1 && yStatus == 1 && marker
            crosses = findobj(handles.Axes1, 'Type', 'Line', 'Marker', '+');
            if ~isempty(crosses)
                delete(crosses);
            end
            hold(handles.Axes1, 'on');
            plot(handles.Axes1, x0, y0, 'k+', 'MarkerSize', 28, 'linewidth', 2);
        end
        
		pause(1.0);
		guidata(hObject, handles);

	else
		error('Values in the (x0, y0, z0) boxes must be numbers.')
	end

end

