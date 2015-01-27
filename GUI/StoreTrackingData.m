function [] = StoreTrackingData(hObject, eventdata, handles, saveStr)
	% Stores tracking data to a file specifed by saveStr. When called by Store button
	% in tracking window, saveStr is handles.SaveStr, but this function may be called by
	% a script with the script's save directory as well. Saves the tracking figure and 
	% the locations struct.
	if isfield(handles, 'TrackingLocations')
		figToSave = figure();
		copyobj(handles.AxesTrack, saveFig);
		savefig(figToSave, [saveStr, 'Tracking_Figure']);
		save([saveStr, 'Tracking_Locations'], 'handles.TrackingLocations');
		close(figToSave);
	end

end
