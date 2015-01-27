function [] = SetDefaults(hObject, eventdata, handles)
	% Sets default values for each text box in GUI
	% Runs on startup of GUI
  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add paths
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Add Spincore API files
	addpath(genpath('C:\SpinCore\SpinAPI'));
	% Add all GUI related files. Current location is set in GetPath, which should be
	% updated if location of GUI files is changed.
	addpath(genpath(GetPath()));

	handles.saveStr = get(handles.savePathBox, 'String');

    x0 = ReadVoltage('Dev1/_ao0_vs_aognd');
	set(handles.currentX, 'String', num2str(x0));
	
    y0 = ReadVoltage('Dev1/_ao1_vs_aognd');
	set(handles.currentY, 'String', num2str(y0));
	
    z0 = ReadVoltage('Dev1/_ao2_vs_aognd');
	set(handles.currentZ, 'String', num2str(z0));
	


	% imageLst = dir('Startup_Images'); imageLst = {imageLst.name};
	% imNum = randi([3, length(imageLst)], 1);
	% imName = strjoin(imageLst(imNum));
	% image(imread(['Startup_Images\',imName]),'Parent', handles.Axes1);


	set(handles.chan5, 'Value', true);
	TurnOnGreen;

	set(handles.LASERButton, 'Value', true);
	PowerStripControl('LASER', 'ON');

	handles.scanRunning = false;

    handles.zoomedIn = false;

	guidata(hObject, handles);

end
