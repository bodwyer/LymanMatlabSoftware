function [] = ReTrackButton(hObject, eventdata, handles)
	% Executes on Retrack button press. If no retrack window exists, will create one.
	% Otherwise retrack is plotted over currently existing retrack figure.
	%
	% Will retrack in xy or z or both depending on which boxes are checked in the
	% Tracking box.
	%
	% This function primarily uses the functions ReTrack and ZTrack.

	xyOn = get(handles.xyTrackCheck, 'Value');
	zOn = get(handles.zTrackCheck, 'Value');

	
	if xyOn
		ReTrack(hObject, handles, true);
        handles = guidata(hObject);
	end
	if zOn
		ZTrack(hObject, handles, true);
        handles = guidata(hObject);
	end 



end

		