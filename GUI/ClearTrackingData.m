function [] = ClearTrackingData(hObject, eventdata, handles)
% Executes on Clear button press in the tracking box. This function clears the tracking Axes
% and erases all stored tracking locations

	% Delete tracking locations. These are stored both as useful data
	% and as a way to check if a tracking image is currently being stored
	if isfield(handles, 'TrackingLocations')
		handles = rmfield(handles, 'TrackingLocations');
	end 
	% Clear axes
	cla(handles.tracking1, 'reset');
	cla(handles.tracking2, 'reset');
	cla(handles.tracking3, 'reset');
	cla(handles.tracking4, 'reset');
	if isfield(handles, 'PeakValue')
		handles = rmfield(handles, 'PeakValue');
	end
	rects = findobj(handles.Axes1, 'Type', 'Rectangle');
    if ~isempty(rects)
    	delete(rects);
    end
    drawnow;

	guidata(hObject, handles);
end


