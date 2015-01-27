function [] = AddNVToList(hObject, handles, typeIs)


	currentList = get(handles.NVListBox, 'String');
	if isempty(currentList)
        set(handles.NVListBox, 'Value', 1);
		cla(handles.AxesBatch, 'reset');

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% FIX THIS:
		% Should probably modify the slider function to do this plot also? or
		% just figure out how to copy directly from axes rather than perform all
		% of these steps again...
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% get values from sliders
		minThreshold = get(handles.minCutoffSlider, 'Value');
		maxThreshold = get(handles.maxCutoffSlider, 'Value');

		% Check that values make sense
		if maxThreshold < minThreshold
			error('Minimum threshold exceeds maximum threshold')
		end

		% Plot currently on axes
		plotImage = handles.imData;
		% Find max value of 2d scan
		maxPlt = max(plotImage(:));

		% Replace values above/below cutoffs with nan
		plotImageAdjusted = plotImage;
		plotImageAdjusted(plotImageAdjusted > maxThreshold*maxPlt) = nan;
		plotImageAdjusted(plotImageAdjusted < minThreshold*maxPlt) = nan;
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		imagesc(handles.ax1Values, handles.ax2Values, plotImageAdjusted,...
    			'Parent', handles.AxesBatch);
        drawnow;
	end

	if strcmp(typeIs, 'new')
	
		NVNum = get(handles.NVName, 'String');
		NVName = ['NV', NVNum, '.mat'];
		saveName = [handles.saveStr, NVName];
		[xyFitParams, zFitParams] = StoreNVLocation(hObject, handles, saveName);
		x0 = xyFitParams(1);
		y0 = xyFitParams(2);

		currentList{length(currentList) + 1} = NVName;
			set(handles.NVName, 'String', num2str(str2num(NVNum) + 1));
	elseif strcmp(typeIs, 'file')

		NVName = uigetfile('*.mat');
		currentList{length(currentList) + 1} = NVName;
        
        data = load(NVName);
		data = data.sData;
		fitParams = data.Small.FitParams;
		x0 = fitParams(1);
		y0 = fitParams(2);

	end

	hold(handles.AxesBatch, 'on');
	pair = struct();
	pair.marker = plot(x0, y0, 'mo', 'linewidth', 2, 'markersize', 10, 'Parent', handles.AxesBatch);
	pair.text = text(x0, y0, NVName(1:(end - 4)), 'Parent', handles.AxesBatch, 'fontsize', 10);
	hold(handles.AxesBatch, 'off');
	if isfield(handles, 'markerList')
		handles.markerList(NVName) = pair;
	else
		handles.markerList = containers.Map(NVName, pair);
	end

	set(handles.NVListBox, 'String', currentList);
   


	guidata(hObject, handles);

end
		




