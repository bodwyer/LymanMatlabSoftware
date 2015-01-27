function [] = Scan(hObject, eventdata, handles)
	% Performs a scan along selected axes with parameters
	% gathered from the Scan Controls panel

%     if isfield(handles, scanNum)
%         handles.scanNum = handles.scanNum + 1;
%     else
%         handles.scanNum = 1;
%     end
	% Update parameters to most current set in boxes
	GoTo(hObject, eventdata, handles);

	% Determine which scan axes are checked
	xAxOn = get(handles.xCheckBox, 'Value');
	yAxOn = get(handles.yCheckBox, 'Value');
	zAxOn = get(handles.zCheckBox, 'Value');
	dt = get(handles.currentDT, 'Value');

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
	ax1Min = eval(['get(handles.', ax1Str, 'Min, "Value")']);
	ax1Max = eval(['get(handles.', ax1Str, 'Max, "Value")']);
	ax1Points = eval(['get(handles.', ax1Str, 'Points, "Value")']);
	ax1Curr = eval(['get(handles.current', upper(ax1Str), '"Value")']);
	ax1Values = linspace(ax1Min, ax1Max, ax1Points);

	% Set up second scan axis, if there is one
	if numAxes == 2
		ax2 = axInd(2);
		ax2Str = axMap(ax2);
		ax2Min = eval(['get(handles.', ax2Str, 'Min, "Value")']);
		ax2Max = eval(['get(handles.', ax2Str, 'Max, "Value")']);
		ax2Points = eval(['get(handles.', ax2Str, 'Points, "Value")']);
		ax2Curr = eval(['get(handles.current', upper(ax2Str), '"Value")']);
		ax2Values = linspace(ax2Min, ax2Max, ax2Points);
	end

	% Initilize the scan window for  a 1 or 2 dimensional scan, with axis labels
	InitScanWindow(axInd);

	if numAxes == 1
		SingleAxisScan(axInd, ax1Values);
	else
		TwoAxisScan(axInd, ax1Values, ax2Values);
	end

	% Return to starting values
	x0 = get(handles.currentX, 'Value'); WriteVoltageXYZ(1, x0);
	y0 = get(handles.currentY, 'Value'); WriteVoltageXYZ(2, y0);
	z0 = get(handles.currentZ, 'Value'); WriteVoltageXYZ(3, z0);


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
    		plot(handles.Axes1, handles.ax1Values, handles.imData);
    		xlabel([axMap(numAxes), 'Voltage']);
    		ylabel('Florescence (kCounts/sec)');

    	elseif length(numAxes) == 2
    		imagesc(handles.Axes1, handles.ax1Values, handles.ax2Values, handles.imData, 'Parent', handles.Axes1);
    		SetColorMap(hObject, eventdata, handles);
    		cb = colorbar('peer', handles.Axes1, 'location', 'EastOutside');
    		xlabel([axMap(numAxes(1)), ' Voltage'])
    		ylabel([axMap(numAxes(2)), ' Voltage'])
    	end
    end


    % A single axis scan is either a continuous galvo scan (x or y) or a stepping z scan
    function [] =  SingleAxisScan(scanAxis, axValues)
    	if scanAxis == 1 || scanAxis == 2
    		imData = RowScan(scanAxis, axValues, dt);
    	else
    		imData = zScan(axValues, dt);
    	end
    	PlotScan(1, imData);
    end

    % For a two axis scan, we have a slow axis and a fast axis. Slow axis is stepped through
    % and a full row scan is taken, then move to the next slow axis value. The 2D image is 
    % updated with each new row. Fast axis will always be a row.
    function [] = TwoAxisScan(scanAxis, ax1Values, ax2Values, imData)
    	for iy = 1:len(ax2Values)
    		vSlow = ax2Values(iy);
    		WriteVoltageXYZ(scanAxis(2), vSlow);
    		scanRow = RowScan(scanAxis(1), ax1Values, dt);
    		imData(iy, :) = scanRow;
    		PlotScan(2, imData);
    	end
    end

end









    		
