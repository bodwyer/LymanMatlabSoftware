function [hObject, eventdata, handles] = ScanButton(hObject, eventdata, handles)
	% Performs a scan along selected axes with parameters
	% gathered from the Scan Controls panel

	if handles.scanRunning == false

        
        if isfield(handles, 'scanNum')
            handles.scanNum = handles.scanNum + 1;
        else
            handles.scanNum = 1;
        end
        scanNum = str2num(get(handles.scanCounter, 'String'));
        set(handles.scanCounter, 'String', num2str(scanNum + 1));
        
		handles.scanRunning = true;
        cla(handles.Axes1, 'reset');
		% Update parameters to most current set in boxes
		SetToCurrentValues(hObject, eventdata, handles, false);

		% Determine which scan axes are checked
		xAxOn = get(handles.xCheckBox, 'Value');
		yAxOn = get(handles.yCheckBox, 'Value');
		zAxOn = get(handles.zCheckBox, 'Value');
		dt = get(handles.currentDt, 'Value');

		allAxOn = [xAxOn, yAxOn, zAxOn];
		numAxes = sum(allAxOn);

		% Check to make sure proper number of axes checked
		if numAxes > 3 || numAxes == 0
			error('Please select 1 or 2 scan axes.')
		end

		axMap = ['x', 'y', 'z']; % Map between axis number and cartesian label (x, y, z)
		axInd = find(allAxOn == 1); % List of ON axes

		% Set up first axis parameters
		ax1 = axInd(1);
		ax1Str = axMap(ax1);
		ax1Min = str2double(get(eval(['handles.', ax1Str, 'Min']),'String'));
		ax1Max = str2double(get(eval(['handles.', ax1Str, 'Max']),'String'));
		ax1Points = str2double(get(eval(['handles.', ax1Str, 'Points']),'String'));
        ax1Curr = str2double(get(eval(['handles.current', upper(ax1Str)]), 'String'));
		handles.ax1Values = linspace(ax1Min, ax1Max, ax1Points);

		% Set up second scan axis, if there is one
		if numAxes == 2
			ax2 = axInd(2);
			ax2Str = axMap(ax2);
			ax2Min = str2double(get(eval(['handles.', ax2Str, 'Min']),'String'));
            ax2Max = str2double(get(eval(['handles.', ax2Str, 'Max']),'String'));
            ax2Points = str2double(get(eval(['handles.', ax2Str, 'Points']),'String'));
            ax2Curr = str2double(get(eval(['handles.current', upper(ax2Str)]), 'String'));
			handles.ax2Values = linspace(ax2Min, ax2Max, ax2Points);
		end

		% Initilize the scan window for  a 1 or 2 dimensional scan, with axis labels
		InitScanWindow(axInd);

		if numAxes == 1
			SingleAxisScan(axInd, handles.ax1Values);
		else
			TwoAxisScan(axInd, handles.ax1Values, handles.ax2Values);
		end

		% Return to starting values
		GoHome(hObject, eventdata, handles);

		% Set sliders to min and max value, respectively
		set(handles.minCutoffSlider, 'Value', 0);
		set(handles.maxCutoffSlider, 'Value', 1);
        handles.scanRunning = false;
		guidata(hObject, handles);
    else
        handles.scanRunning = false;
        pause(2);
        guidata(hObject, handles);
		GoHome(hObject, eventdata, handles);
        return;
	end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	function PlotScan(nDims, imData)
	    if nDims == 1
	        updateField = 'YData';
	    else
	        updateField = 'CData';
	    end
	    ax = get(handles.Axes1, 'Children');
	    set(ax, updateField, imData);
        
	    drawnow
	end

	% Sets up scan window for Axes1 with labels, etc. Plot will be updated during actual scan.
    function [] = InitScanWindow(numAxes)

    	if length(numAxes) == 1
    		handles.imData = nan(size(handles.ax1Values));
    		plot(handles.ax1Values, handles.imData, 'r', 'Parent', handles.Axes1);
    		xlabel([axMap(numAxes), 'Voltage']);
    		ylabel('Florescence (kCounts/sec)');

    	elseif length(numAxes) == 2
    		handles.imData = nan(length(handles.ax2Values), length(handles.ax1Values));
    		imagesc(handles.ax1Values, handles.ax2Values, handles.imData,...
    			'Parent', handles.Axes1);
    		SetColorMap(hObject, eventdata, handles);
    		handles.cb = colorbar('peer', handles.Axes1, 'location', 'EastOutside');
    		xlabel(handles.Axes1,[axMap(numAxes(1)), ' Voltage'], 'HandleVisibility', 'off');
    		ylabel(handles.Axes1, [axMap(numAxes(2)), ' Voltage'], 'HandleVisibility', 'off');
            title(handles.Axes1, [axMap(numAxes(1)), '-', axMap(numAxes(2)), ' Scan'], 'HandleVisibility', 'off');
            
    	end
    end


    % A single axis scan is either a continuous galvo scan (x or y) or a stepping z scan
    function [] =  SingleAxisScan(scanAxis, axValues)
    	if scanAxis == 1 || scanAxis == 2
    		handles.imData = RowScan(scanAxis, axValues, dt);
        else
    		handles.imData = ZScan(axValues, dt);
    	end
    	PlotScan(1, handles.imData);
    end

    % For a two axis scan, we have a slow axis and a fast axis. Slow axis is stepped through
    % and a full row scan is taken, then move to the next slow axis value. The 2D image is 
    % updated with each new row. Fast axis will always be a row.
    function [] = TwoAxisScan(scanAxis, ax1Values, ax2Values)
    	for iy = 1:length(ax2Values)
            % Necessary for second button press to stop the scan... handles
            % are not updated in original function of ScanButton is called
            % again, so original scanRunning is not set to false unless
            % guidata called here (but can't just replace everyting,
            % because we lose some handles in "stop" function call)
            newHandles = guidata(hObject);
    		if newHandles.scanRunning == true
	    		vSlow = ax2Values(iy);
	    		WriteVoltageXYZ(scanAxis(2), vSlow);
	    		scanRow = RowScan(scanAxis(1), ax1Values, dt);
	    		handles.imData(iy, :) = scanRow(1:length(ax1Values));
	    		PlotScan(2, handles.imData);
            else
                handles.scanRunning = false;
	    		GoHome(hObject, eventdata, handles);
	    		return;
	    	end
    	end
    end

end









    		
