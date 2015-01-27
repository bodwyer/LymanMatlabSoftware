function [] = ChooseSaveDirectory(hObject, eventdata, handles)


	pathName = uigetdir();
	if pathName ~= 0
		set(handles.savePathBox, 'String', pathName);
		handles.saveStr = pathName;
	end