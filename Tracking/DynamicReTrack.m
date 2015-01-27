function [] = DynamicReTrack(hObject, handles)

	newHandles = guidata(hObject);
    if isfield(newHandles, 'ScriptRunning') && ~newHandles.ScriptRunning
        error('User aborted run. Script terminated.');
    elseif get(handles.trackingOnCheckbox, 'Value')
		timeout = 8;
		threshold = 0.95;
		dt = 0.5;
		[status, counterT, clockT] = SetCounter(1/dt, 2, 'INTERNAL');
		if status ~= 0
			CleanUpDAQmx(clounterT, clockT);
			error('Error creating counter and clock channels')
	    end
	   	TurnOnGreen;
	    DAQmxStartTask(counterT);
	    [status, readArray] = ReadCounter(counterT, 2, timeout);
	    DAQmxStopTask(counterT);
	    
	    % Check to make sure data was successfully read from DAQ. If not,
	    % clean up and stop.
	    CleanUpDAQmx(counterT, clockT);
	    if status ~= 0
	        error('Error reading values from DAQ');
	    end

	    counts = diff(readArray)/(dt*1000);

	    if isfield(handles, 'PeakValue') && counts > threshold*handles.PeakValue
	    	disp('No retrack needed.');
	    	disp(['Counter is ', num2str(counts), ', Previous threshold was ', num2str(handles.PeakValue)]);
	    else
	    	disp('Counter has dropped below 95%. Retracking.')
	    	set(handles.trackingText, 'Visible', 'on');
	    	guidata(hObject, handles);
	    	drawnow;
	    	if get(handles.xyTrackCheck, 'Value')
	    		ReTrack(hObject, handles, true);
            end
            handles = guidata(hObject);
	    	TurnOnGreen;
            [status, counterT, clockT] = SetCounter(1/dt, 2, 'INTERNAL');
		    DAQmxStartTask(counterT);
		    [status, readArray] = ReadCounter(counterT, 2, timeout);
		    DAQmxStopTask(counterT);
		    
		    % Check to make sure data was successfully read from DAQ. If not,
		    % clean up and stop.
		    CleanUpDAQmx(counterT, clockT);
		    if status ~= 0
		        error('Error reading values from DAQ');
		    end

		    if get(handles.zTrackCheck, 'Value')
	            if ~isfield(handles, 'PeakValue') || diff(readArray)/(dt*1000) < threshold*handles.PeakValue
	            	disp('Z Track also needed.')
	                ZTrack(hObject, handles, true);

	                [status, counterT, clockT] = SetCounter(1/dt, 2, 'INTERNAL');
	                if status ~= 0
	                    CleanUpDAQmx(clounterT, clockT);
	                    error('Error creating counter and clock channels')
	                end
	                TurnOnGreen;
	                DAQmxStartTask(counterT);
	                [status, readArray] = ReadCounter(counterT, 2, timeout);
	                DAQmxStopTask(counterT);
	                if status ~= 0
	                    error('Error reading values from DAQ');
	                end

	                % Check to make sure data was successfully read from DAQ. If not,
	                % clean up and stop.
	                CleanUpDAQmx(counterT, clockT);
	            end

			    
		

			    handles.PeakValue = max([counts, diff(readArray)/(dt*1000)]);
		    	
		    end
		end
	    set(handles.trackingText, 'Visible', 'off');
	end

	guidata(hObject, handles);
    	

end