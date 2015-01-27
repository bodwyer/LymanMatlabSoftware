function [locations, figureTrackingHandle] = ReTrack_Cross(locations, figureTrackingHandle)

	%%%%%%%%%%%%%
	% Constants
	%%%%%%%%%%%%%
	N = 20; % Number of pixels
	N_REPS = 4;
	BOX_SIZE = 0.14; % Volts
	Z_BOX_SIZE = 3;
	TIMEOUT = 10; % Seconds
	DT = 0.018; % Seconds
	SHOW_PLOTS = false;

    


    for irep = 1:N_REPS
		% Start with scan along X
		xVolts = ReadVoltage('Dev1/_ao0_vs_aognd');
		xValues = linspace(xVolts - BOX_SIZE, xVolts + BOX_SIZE, N);
		
		xScan = RowScan('ao0', xValues, DT);
		xScanForward = xScan(1:N);
		% xScanBackward = xScan(N + 1:end);

		% Now fit the curves and pick out center of Gaussian
		[gaussForward, paramsForward, exitFlag1] = BF_Gaussian_1D(xScanForward, xValues);
		% [gaussBackward, paramsBackward, exitFlag2] = BF_Gaussian_1D(xScanBackward, xValues);

		if SHOW_PLOTS
			figure
			subplot(1, 2, 1)
			plot(xValues, xScanForward, 'ro')
			hold on
			plot(xValues, xScanBackward, 'bo')
			plot(xValues, gaussForward, 'r');
			plot(xValues, gaussBackward, 'b')
			xlabel('Voltage');
			ylabel('Counts');
			title('XScan');
			legend('forward', 'backward', 'forward (fit)', 'backward (fit)')
		end

		% check to make sure the fits converged
		if (exitFlag1 > 0)
			x0 = (paramsForward(1));
			WriteVoltageXYZ(1, x0);
		else
			CleanUp
			error('Fit did not converge.')
		end


		% Now do scan along Y
		yVolts = ReadVoltage('Dev1/_ao1_vs_aognd');
		yValues = linspace(yVolts - BOX_SIZE, yVolts + BOX_SIZE, N);

		yScan = RowScan('ao1', yValues, DT);
		yScanForward = yScan(1:N);
		% yScanBackward = yScan(N + 1:end);

		% Now fit the curves and pick out center of Gaussian
		[gaussForward, paramsForward, exitFlag1] = BF_Gaussian_1D(yScanForward, yValues);
		% [gaussBackward, paramsBackward, exitFlag2] = BF_Gaussian_1D(yScanBackward, yValues);

		if SHOW_PLOTS
			subplot(1, 2, 2)
			plot(yValues, yScanForward, 'ro')
			hold on
			plot(yValues, yScanBackward, 'bo')
			plot(yValues, gaussForward, 'r');
			plot(yValues, gaussBackward, 'b')
			xlabel('Voltage');
			ylabel('Counts');
			title('YScan');
			legend('forward', 'backward', 'forward (fit)', 'backward (fit)');
		end

		% Check to make sure the fits converged
		if (exitFlag1 > 0) 
			y0 = (paramsForward(1));
			WriteVoltageXYZ(2, y0);
		else
			CleanUp
			error('Fit did not converge')
		end

    end
    
    zVolts = ReadVoltage('Dev1/_ao2_vs_aognd');
        % Make sure z is not out of bounds, and if it is, set boundaries as
    % limits
    if zVolts + Z_BOX_SIZE >= 10
        zMax = 10;
    else
        zMax = zVolts + Z_BOX_SIZE;
    end
    
    if zVolts - Z_BOX_SIZE <= -10
        zMin = -10;
    else
        zMin = zVolts - Z_BOX_SIZE;
    end

    zValues = linspace(zMin, zMax, N*5);
    % Set up the counter on DAQ
	[status, counterT, clockT] = SetCounter(1/DT, 2, 'INTERNAL');
    zScan = nan(size(zValues));

	for iz = 1:length(zValues)
		vZ = zValues(iz);
		WriteVoltageXYZ(3, vZ);
		% Start counter
		DAQmxStartTask(counterT);
		% Start scanning
		pause(DT);
		DAQmxStopTask(counterT);
		[status, readArray] = ReadCounter(counterT, 2, TIMEOUT);
		zScan(iz) = diff(readArray)/DT;
    end

	CleanUpDAQmx(counterT, clockT);

	[bestFitZ, zFitParams, exitFlag] = BF_Gaussian_1D(zScan, zValues);

	if exitFlag <= 0 || abs(zFitParams(1)) > 10
		disp('lsqnonlin did not converge.')
        WriteVoltageXYZ(3, zVolts);
        z0 = zVolts;
	else
		z0 = zFitParams(1);
		WriteVoltageXYZ(3, z0);
    end
    
    


	% update list of tracking locations
	locations{1} = [locations{1}, ReadVoltage('Dev1/_ao0_vs_aognd')];
	locations{2} = [locations{2}, ReadVoltage('Dev1/_ao1_vs_aognd')];
    locations{3} = [locations{3}, ReadVoltage('Dev1/_ao2_vs_aognd')];

	% Plot new tracking position on figure
	figure(figureTrackingHandle);
	subplot(1, 2, 1)
	hold on;
	plot(locations{1}, locations{2}, '--gs', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', 'b');
    xlabel('xVolts')
    ylabel('yVolts')
    title('Tracking')

    pause(0.05);

end





