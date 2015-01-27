if isfield(handles, 'NVParams')

	if isfield(handles.NVParams, 'ESR')
	    FREQ = handles.NVParams.ESR;
	end

	if isfield(handles.NVParams, 'Pi_Power')
	    POWER = handles.NVParams.Pi_Power;
	end

	if isfield(handles.NVParams, 'Pi_Time')
	    PI_TIME = handles.NVParams.Pi_Time;
	    PI_TIME_Two = round(PI_TIME/2);
	end
end