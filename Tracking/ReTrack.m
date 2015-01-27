function [xValues, yValues, scanXY, xyFitParams, bestFitXY, exitFlag] = ReTrack(hObject, handles, turnOnGreen)
   

	if isfield(handles, 'TrackingLocations')
    	loc = handles.TrackingLocations;
    else
    	loc = {[], [], [], []};
    end


	%%%%%%%%%%%%%
	% Constants
	%%%%%%%%%%%%%
	N = 25; % Number of pixels in each direction
	BOX_SIZE = 0.025; % Volts
	Z_BOX_SIZE = 5;
	TIMEOUT = 10; % Seconds
	DT = str2num(get(handles.dtTrackingBox, 'String')); % Seconds

	% Get current position of each channel (in volts)
	xVolts = ReadVoltage('Dev1/_ao0_vs_aognd');
	yVolts = ReadVoltage('Dev1/_ao1_vs_aognd');
	zVolts = ReadVoltage('Dev1/_ao2_vs_aognd');
    
    

	% Set up a small scan
	xValues = linspace(xVolts - BOX_SIZE, xVolts + BOX_SIZE, N);
	yValues = linspace(yVolts - BOX_SIZE, yVolts + BOX_SIZE, N);
    
    if turnOnGreen == true
        TurnOnGreen();
    end


    [scanXY, scanXYReverse] = ScanXY(xValues, yValues, DT);

	[bestFitXY, xyFitParams, exitFlag, resnorm] = BF_Gaussian(scanXY, xValues, yValues);
    
 	if isempty(loc{1})
 		delta = 0;
 	else
 		xLocs = loc{1};
 		yLocs = loc{2};
 		deltaX = xLocs(end) - xyFitParams(1);
 		deltaY = yLocs(end) - xyFitParams(2);
 		delta = sqrt(deltaX^2 + deltaY^2);
 	end
 		

    
	% if exitFlag <= 0
	% 	disp('lsqnonlin did not converge.')
	% 	figure()
	% 	subplot(1, 2, 1)
	% 	imagesc(xValues, yValues, scanXY);
	% 	title('Data')
	% 	subplot(1, 2, 2)
	% 	imagesc(xValues, yValues, bestFitXY);
	% 	title('Fit');
		
	% 	% FindNVFromFile(hObject, handles);

        
        
	% else
	% Best fit center (x0, y0)
		x0 = xyFitParams(1);
		y0 = xyFitParams(2);
        WriteVoltageXYZ(1, x0);
        WriteVoltageXYZ(2, y0);
        
        
        
        % Either update the plot or create a new one if no arguments passed
	    if isempty(loc{1})

	        imagesc(xValues, yValues, scanXY, 'Parent', handles.tracking1);
	         % Plot most recent scan
		    imagesc(xValues, yValues, scanXY, 'Parent', handles.tracking3);
		    % Plot most recent fit
		    imagesc(xValues, yValues, bestFitXY, 'Parent', handles.tracking4);
		    drawnow;
            guidata(hObject, handles);
	        
	    else
		    % Plot most recent scan
		    ax3 = get(handles.tracking3, 'Children');
		    set(ax3, 'CData', scanXY);
		    % Plot most recent fit
		    ax4 = get(handles.tracking4, 'Children');
		    set(ax4, 'CData', bestFitXY);
		end

        % handles.PeakValue = max(scanXY(:));


	    loc{1} = [loc{1}, x0];
	    loc{2} = [loc{2}, y0];
	   	loc{3} = [loc{3}, zVolts];
	   	loc{4} = [loc{4}, clock]; % Keep track of time for each track, because why not?
	    
        
	    handles.TrackingLocations = loc;



	   	% Plot markers on top of initial scan
	    hold(handles.tracking1, 'on');
	    plot(handles.TrackingLocations{1}, handles.TrackingLocations{2}, '--gs', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'Parent', handles.tracking1);
	    hold(handles.tracking1, 'off');

	    set(handles.currentX, 'String', num2str(x0));
	    set(handles.currentY, 'String', num2str(y0));

	    rects = findobj(handles.Axes1, 'Type', 'Rectangle');
	    if ~isempty(rects)
	    	delete(rects);
	    end
	    hold(handles.Axes1, 'on');
	    rectangle('Position', [xValues(1), yValues(1), range(xValues), range(yValues)], 'linewidth', 2, 'Parent', handles.Axes1);
	    crosses = findobj(handles.Axes1, 'Type', 'Line', 'Marker', '+');
        if ~isempty(crosses)
            delete(crosses);
        end
        plot(handles.Axes1, x0, y0, 'k+', 'MarkerSize', 28, 'linewidth', 2, 'Parent', handles.Axes1);
        hold(handles.Axes1, 'off');
	    drawnow;

    

    % end
  
 
    guidata(hObject, handles);
   
     

  


end
