function [] = UpdatePlotScale(hObject, eventdata, handles)
	% Function executes when either of the image slider controls are manipulated.
	% Scales colors of Axes1 image proportional to the maximum value of the image.
	% Does not eliminate data (setting sliders back to default value will return plot to original)

	% Make sure a 2 axis scan
	xAxOn = get(handles.xCheckBox, 'Value');
	yAxOn = get(handles.yCheckBox, 'Value');
	zAxOn = get(handles.zCheckBox, 'Value');

	allAxOn = [xAxOn, yAxOn, zAxOn];
	numAxes = sum(allAxOn);
	if numAxes == 2

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

		% Replot 
		ax = get(handles.Axes1, 'Children');
		ax = ax(end);
		set(ax, 'CData', plotImageAdjusted);
		drawnow();
	else
		error('Need a two axis scan to adjust color map.');
	end
	guidata(hObject, handles);
end