function [] = FindNVFromFile(hObject, handles)
	getFile = get(handles.findNVFileName, 'String');
	if isempty(getFile)
		[getFile, pathName] = uigetfile('*.mat');
		if getFile == 0
			return
		end
	elseif ~exist(getFile, 'file')
		error('No such file exists. Try a different filename.');
	end

	[xyStatus, zStatus] = FindNV(hObject, handles, [pathName, '\', getFile]);
	if (xyStatus <= 0) || (zStatus <= 0)
		error('Unable to find NV! All is lost!')
	end
end
