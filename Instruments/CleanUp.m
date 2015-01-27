

if exist('task', 'var')
    DAQmxStopTask(task);
    DAQmxClearTask(task);
end


if exist('N9310A', 'var')
    fprintf(N9310A, ':RFOUTPUT:STATE OFF');
    fclose(N9310A);
    delete(instrfind);
else
    AgilentSGControl(':RFOUTPUT:STATE OFF');
end
    

if exist('counterT', 'var')
    DAQmxStopTask(counterT);
    DAQmxClearTask(counterT);
end

if exist('clockT', 'var')
    DAQmxStopTask(clockT);
    DAQmxClearTask(clockT);
end

if exist('handles', 'var')
	if isfield(handles, 'counterT')
	    CleanUpDAQmx(handles.counterT);
	end
	if isfield(handles, 'clockT')
	    CleanUpDAQmx(handles.clockT)
	end
end

% Set state variable to indicate that no scripts currently running
handles.ScriptRunning = false;

% Set GUI text to indicate that no scripts are running
set(handles.isRunningText, 'String', 'Idle');
set(handles.isRunningText, 'ForegroundColor', [0,1,0]);
guidata(hObject, handles);