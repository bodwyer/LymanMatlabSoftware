function [] = StoreNVLocationButton(hObject, eventdata, handles)
	saveLocation = get(handles.findNVFileName, 'String');
	if isempty(saveLocation)
		saveLocation = handles.saveStr;
	end



	directory = [saveLocation, 'NVLocations\'];

	currentFiles = what(directory);
	currentLocations = currentFiles.mat;


	matches = regexp(currentLocations, [date, '_NV', '[0-9]+'], 'match');
	matchesTrue = ~cellfun(@isempty, matches);
	numMatches = sum(matchesTrue);
	maxNum = numMatches + 1;

	savePath = [directory, date, '_NV', num2str(maxNum)];
	StoreNVLocation(hObject, handles, savePath);

	set(handles.findNVFileName, 'String', [savePath, '_NV_Tracking_Info.mat']);
	guidata(hObject, handles);

end