function [zScan] = ZScan(zValues, dt)


	% Set up the counter on DAQ
    timeout = dt*length(zValues)*5;
	[status, counterT, clockT] = SetCounter(1/dt, 2, 'INTERNAL');
    if status ~= 0
        CleanUpDAQmx(counterT, clockT);
        error('Error creating counter and clock channels')
    end
    zValues = [zValues(1), zValues]; % To fix weird problem where first point is always way too high
    zScan = nan(size(zValues));
    
	for iz = 1:length(zValues)
		vZ = zValues(iz);
		WriteVoltageXYZ(3, vZ);
		if iz == 1
			pause(5.0);
		end
		% Start counter
		DAQmxStartTask(counterT);
		% Start scanning
		pause(dt);
		DAQmxStopTask(counterT);
		[status, readArray] = ReadCounter(counterT, 2, timeout);
        
        % Check to make sure data was successfully read from DAQ. If not,
        % clean up and stop.
        if status ~= 0
            CleanUpDAQmx(counterT, clockT);
            error('Error reading values from DAQ');
        end
        
		zScan(iz) = diff(readArray)/(1000*dt);
    end

	CleanUpDAQmx(counterT, clockT);

	zScan = zScan(2:end);
end

