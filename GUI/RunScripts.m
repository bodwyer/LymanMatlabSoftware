function [] = RunScripts(hObject, eventdata, handles)


	failScript = 'CleanUp.m'; % Script to run in event of an error. Will clean up devices.

	scriptList = get(handles.scriptListBox, 'String'); % List of scripts to run
	nReps = str2num(get(handles.repeatNTimesBox, 'String')); % Number of times to repeat scripts

    % State variable to keep track of whether a script is currently being executed
    handles.ScriptRunning = true; 

    % Name of axes handle where all data taken during an experiment should be plotted.
    % All calls to plot in a script should use this axes.
	expAxes = handles.AxesData;

    % Set GUI text to indicate that a script is running.
	set(handles.isRunningText, 'String', 'Running');
	set(handles.isRunningText, 'ForegroundColor', [1,0,0]);

    numNVs = 1;
    if get(handles.repeatCheckBox, 'Value')
        NVList = get(handles.NVListBox, 'String');
        if ~isempty(NVList)
            numNVs = length(NVList);
        end
    end

    for iNV = 1:numNVs
        ClearTrackingData(hObject, eventdata, handles);
        handles = guidata(hObject);
        if exist('NVList', 'var') && ~isempty(NVList)
            currentNV = NVList{iNV} % Get current NV from list
            NVName = currentNV(1:(end - 4)); % remove the .mat extension for folder management
            currentNVPath = [handles.saveStr, currentNV];

            % Each NV data should be saved in its own folder
            currentSavePath = [get(handles.savePathBox, 'String'), NVName, '\']
            if ~exist(currentSavePath, 'dir')
                mkdir(currentSavePath);
            end
            handles.saveStr = currentSavePath;

            % Go to currently selected NV
            set(handles.NVListBox, 'Value', iNV);
            [xyStatus, zStatus] = FindNV(hObject, handles, currentNVPath);
        end
    
        for in = 1:nReps % For all repetitions

            % Refresh any stored NV parameters
            if isfield(handles, 'NVParams')
                handles = rmfield(handles, 'NVParams');
            end
            % Refresh stored tracking data
            if isfield(handles, 'PeakValue')
                handles = rmfield(handles, 'PeakValue');
            end
            guidata(hObject, handles);
            handles = guidata(hObject);
            
            for is = 1:length(scriptList) % For each script
                cla(expAxes, 'reset'); % Clear the plotting axes
                currentScript = scriptList{is}; % Get current script
                set(handles.scriptListBox, 'Value', is); % Highlight current script
                guidata(hObject, handles);
                drawnow;

                rehash path; % Refreshes any changes to scripts in queue. You can make changes up until the script starts running and have the changes be implemented.

                try 
                    run(currentScript); % Run current script
                    copyfile(['C:\Users\MAXWELL\Dropbox\NV_Programs\Scripts\', currentScript], [saveStr]); % Save a copy of the current script, with all vairables etc as they are for this particular run.

                catch ME
                    % If script fails for any reason, report the error and run the 'failScript' to clean up the instruments
                    errorMessage = sprintf('Error in myScrip.m.\nThe error reported by MATLAB is:\n\n%s', ME.message);
                    % save([handles.saveStr, datestr(now), '_DATA_DUMP.mat']);
                    uiwait(warndlg(errorMessage));
                    handles.saveStr = get(handles.savePathBox, 'String');

                    run(failScript);
                    guidata(hObject, handles);
                    return;
                end

                
            
            end
            handles.saveStr = get(handles.savePathBox, 'String');
            guidata(hObject, handles);
        end
    end

    handles.saveStr = get(handles.savePathBox, 'String');
    
    % Turn off power strip instruments if box is checked
    turnOffInstruments = get(handles.turnOffCheckBox, 'Value');
    if turnOffInstruments
    	PowerStripControl('ALL', 'OFF');
    end


    % Set state variable to indicate that no scripts currently running
    handles.ScriptRunning = false;

    % Set GUI text to indicate that no scripts are running
    set(handles.isRunningText, 'String', 'Idle');
	set(handles.isRunningText, 'ForegroundColor', [0,1,0]);
	guidata(hObject, handles);

end

