function [zFitParams, zValues, scanZ, bestFitZ, exitFlag] = ZTrack(hObject, handles, turnOnGreen)

	Z_BOX_SIZE = 2;
	N = 25; % Number of z steps
	DT = 0.2; % Seconds
    



  	% Get current z voltage
	zVolts = ReadVoltage('Dev1/_ao2_vs_aognd');
	 % Make sure z is not out of bounds, and if it is, set boundaries as
    % limits
    zMax = min([zVolts + Z_BOX_SIZE, 10]);
    zMin = max([zVolts - Z_BOX_SIZE, -10]);


    % Set up a list of z voltages for scan
    zValues = linspace(zMin, zMax, N);

    % Turn on green laser
    if turnOnGreen == true
        TurnOnGreen();
    end

    % Take a z scan
    scanZ = ZScan(zValues, DT);

    % Fit gaussian to data
    [bestFitZ, zFitParams, exitFlag] = BF_Gaussian_1D(scanZ, zValues);

    % If fit failed, return to old position. Else set z = zfit
    if exitFlag <= 0 || abs(zFitParams(1)) > 10
		disp('lsqnonlin did not converge.')
        z0 = zVolts;
        WriteVoltageXYZ(3, z0);
        figure
        plot(zValues, scanZ, 'bo', zValues, bestFitZ, 'r', lineX, lineY, 'k', 'Parent', handles.tracking2);
        title('Error: z track did not converge')
        FindNVFromFile(hObject, handles);
	else
		z0 = zFitParams(1);
    end
    WriteVoltageXYZ(3, z0);

    lineX = z0*ones(size(zValues));
    lineY = linspace(0, zFitParams(2) + zFitParams(4), length(zValues));


    % Plot result
    plot(zValues, scanZ, 'bo', zValues, bestFitZ, 'r', lineX, lineY, 'k', 'Parent', handles.tracking2);
    % xlabel('z Voltage'); ylabel('Counts');
    % title('Z Tracking');
    set(handles.currentZ, 'String', num2str(z0));

    drawnow;
    guidata(hObject, handles);
    
    pause(1.0); % Wait to equilibrate with oil objective



end

