function [] = StartTimeTrace(hObject, eventdata, handles)
	% Clears Axes2 and starts a continuous trace of flourescence vs time 
	% on Axes 2. Must click "Stop" to abort, although clicking "Start" a second
	% time will have the same effect.

	%%%%%%%%%%%%%%%%%%%%%%
	% Constants
	%%%%%%%%%%%%%%%%%%%%%%
	PLOT_BUFFER_SIZE = 25; % 
	REFRESH_TIME = 0.5; % How often plot is refreshed (seconds)

	% Check to see if a time trace is already running
	if isfield(handles, 'timeTraceRunning') && handles.timeTraceRunning == true
		StopTimeTrace(hObject, eventdata, handles);
		handles = guidata(hObject);
    else
        cla(handles.Axes2, 'reset'); % Clear old time trace
        handles.timeTraceRunning = true; % Tell system a time trace is currently running
		dt = str2double(get(handles.timeTraceDT, 'String'));
		freq = 1/dt;
		timeOut = 2*REFRESH_TIME;

		% Create vector of times (in seconds)
		tVec = linspace(0, PLOT_BUFFER_SIZE*dt, PLOT_BUFFER_SIZE);
		countsVec = nan(size(tVec));

		nSamps = round(freq*REFRESH_TIME) + 1;
		[status, hCounter, hClock] = SetCounter(freq, nSamps, 'INTERNAL'); % Set up internal DAQ counter
		% Keep track of DAQ process handles by storing them in GUI
		handles.hCounter = hCounter; 
        handles.hClock = hClock;

        DAQmxStartTask(handles.hCounter); % Start counter

        guidata(hObject, handles); % Update GUI handles

        % Set up plot (Axes2)
		handles.h = plot(tVec, countsVec,  'r', 'Parent', handles.Axes2);
		xlabel('Time (seconds)');
		ylabel('kCounts/Sec');
        
		set(handles.h, 'YDataSource', 'countsVec');
		set(handles.h, 'XDataSource', 'tVec');


		pos = 1;
		while handles.timeTraceRunning == true % Continue collecting data until user stops
			if pos > length(tVec)
				% Resize t and counts vectors as needed
				tVec = [tVec, linspace(tVec(end) + dt, tVec(end) + PLOT_BUFFER_SIZE*dt, PLOT_BUFFER_SIZE)];
				countsVec = [countsVec, nan(1, PLOT_BUFFER_SIZE)];
            end
            newHandles = guidata(hObject); % Check if user has stopped time trace
            if newHandles.timeTraceRunning == false
                handles = newHandles;
                guidata(hObject, handles);
                return;
            end
            
            % Get counts from DAQ
			[status, A] = ReadCounter(handles.hCounter, nSamps, timeOut);
			counts = mean(diff(A))/(1000*dt); % Calculate kCounts/sec
            set(handles.CPSText, 'String', num2str(counts)); % Also display in CPS box
			countsVec(pos) = counts;
			pos = pos + 1;
            refreshdata(handles.h, 'caller'); % Refresh plot
			drawnow();

		end

	end
	
	guidata(hObject, handles);

end








