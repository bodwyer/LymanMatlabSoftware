function [scanXY, scanXY_Reverse] = ScanXY(xValues, yValues, dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N = length(xValues);
xValuesDouble = [xValues, fliplr(xValues)];

scanXY = nan(length(xValues), length(yValues));
scanXY_Reverse = scanXY;

timeout = 5*dt*length(xValuesDouble);

% Set up the counter on DAQ
[status1, counterT, clockT] = SetCounter(1/dt, length(xValuesDouble), 'INTERNAL');
% Set up a voltage scan for x galvo on DAQ
[status2, scanT] = SetScanRow(xValuesDouble, 1/dt, 'ao0');

% Check to make sure DAQ processes were successfully initialized. If not,
% clean up and stop.
if status1 + status2 ~= 0
    CleanUpDAQmx(counterT, clockT, scanT);
    error('Error setting up scan');
end
% perform a small xy scan using xValues, yValues for galvo
	% voltages. Y values are looped through, while each row of x is scanned
	% continuously. 
	for iy = 1:length(yValues)
		% Step in y
		vY = yValues(iy);
		WriteVoltageXYZ(2, vY);

		% Start counter
		DAQmxStartTask(counterT);
		% Start scanning
		DAQmxStartTask(scanT);

		% Wait until x scan is finished
		try 
			DAQmxWaitUntilTaskDone(scanT, 2*dt*length(xValuesDouble));
		catch ME 
			errorMessage = sprintf('Error in myScrip.m.\nThe error reported by MATLAB is:\n\n%s', ME.message);
        	uiwait(warndlg(errorMessage));
        	CleanUpDAQmx(counterT, clockT, scanT);
        	rethrow;
        end

		DAQmxStopTask(scanT);

		% Read row of x counts from DAQ. It is a running count, so we take the differnec
		% to get the number of counts at each pixel.
		[status, readArray] = ReadCounter(counterT, length(xValuesDouble) + 1, timeout);

        % Check to make sure data was read from DAQ. If not, clean up and
        % stop.
        if status ~= 0
            CleanUpDAQmx(counterT, clockT, scanT);
            error('Error reading data from DAQ')
        end
        
		% Stop counter & scan
		DAQmxStopTask(counterT);

	
		scanRow = diff(readArray);
        
        scanXY(iy, :) = scanRow(1:N)/dt;
        scanXY_Reverse(iy, :) = fliplr(scanRow(N + 1:end))/dt;
        
    end
    
    % Clean up DAQ tasks
	CleanUpDAQmx(counterT, clockT, scanT);
    
    scanXY = scanXY - FitPlane(scanXY);
        
end


