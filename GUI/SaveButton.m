function [] = SaveButton(hObject, eventdata, handles)
	% Executes on press of "Save" button in scan controls. Saves a copy of the data in
	% The current scan window to a file in the save path folder
    scanNum = str2num(get(handles.scanCounter, 'String'));
	dataObjs = get(handles.Axes1, 'Children');
	dataObjs = dataObjs(end);


	sData = struct();
	sData.XData = get(dataObjs, 'XData');
	sData.YData = get(dataObjs, 'YData');
	sData.ZData = get(dataObjs, 'CData');

	savePath = [handles.saveStr, '\scanData'];
 
    if ~exist(savePath, 'dir')
        mkdir(savePath);
    end
    
    save([savePath, '\scan', num2str(scanNum)], 'sData');
%     imwrite(sData.ZData, [savePath, '\scan', num2str(scanNum)])

end


