function [] = AddScriptToQueue(hObject, eventdata, handles)
% Adds a new script to list of scripts to be executed. If file does not exist in current path,
% an error is thrown. If the box is left blank, a dialog box to manually select a 
% file is opened.

	scriptName = get(handles.scriptAdderBox, 'String');
	queueList = get(handles.scriptListBox, 'String');

	if isempty(scriptName) % If no file specified, get manually
		scriptName = uigetfile('*.m');
		if scriptName == 0
			return
		end
	elseif ~exist(scriptName, 'file') % If file does not exist, error
		error('No such script exists to add to queue!')
		return
	end 

	% update list of scripts to run
	queueList{length(queueList) + 1} = scriptName;
	set(handles.scriptListBox, 'Value', 1);
	set(handles.scriptListBox, 'String', queueList);

	guidata(hObject, handles);

end

