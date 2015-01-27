function [] = StopTimeTrace(hObject, eventdata, handles)
	% Stops a currently runnign time trace. If no time trace is running, does nothing.
	% This function is called by the Stop Time Trace button press and if the Start button
	% is pressed while a time trace is currently in progress.

	if isfield(handles, 'hCounter') && isfield(handles, 'hClock') % Check to see if time trace running
		CleanUpDAQmx(handles.hCounter, handles.hClock); % Clear DAQ tasks
        handles = rmfield(handles, {'hCounter', 'hClock'}); % Clear DAQ task handles
	end 
	handles.timeTraceRunning = false; % Set system state to no scan running
    guidata(hObject, handles); % Update handles

end
