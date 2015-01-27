function [] = RemoveScriptFromQueue(hObject, eventdata, handles)
	% Removes the selected script from the script queue and updates list accordingly

	
	fileList = get(handles.scriptListBox, 'String'); % Get full list of scripts
	fileToRemove = get(handles.scriptListBox, 'Value'); % Get index of script to be removed
	if fileToRemove <= length(fileList)
		fileList(fileToRemove) = []; % Delete script from queue
	end
	set(handles.scriptListBox, 'Value', max([1, fileToRemove - 1]));
	set(handles.scriptListBox, 'String', fileList); % Set list to edited list

	guidata(hObject, handles);

end