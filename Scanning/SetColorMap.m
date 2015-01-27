function [colorMap] = SetColorMap(hObject, eventdata, handles)
	% Updates color map from drop down menu. Executes during scan setup and 
	% whenever the color map drop down menu is adjusted.

	mapList = get(handles.colorSchemeMenu, 'String'); % List of availible color maps
	currentMap = get(handles.colorSchemeMenu, 'Value'); % Map currently selected
	currentMapString = mapList(currentMap);


	colormap(handles.Axes1, eval(currentMapString{1})); % Set color map to currently selected
	drawnow; % Refresh image
	colorMap = currentMapString;
end
