function [sData] = RowScan(channel, voltsVec, dt)

	voltsVecDouble = [voltsVec, fliplr(voltsVec)];

	% Set up the counter on DAQ
	[status, counterT, clockT] = SetCounter(1/dt, length(voltsVecDouble), 'INTERNAL');
	% Set up a voltage scan for galvo on DAQ
	[status, scanT] = SetScanRow(voltsVecDouble, 1/dt, ['ao', num2str(channel - 1)]);

	% Make sure the green laser is on
	TurnOnGreen();

	% Start counter
	DAQmxStartTask(counterT);
	% Start scan
	DAQmxStartTask(scanT);

	% Wait for scan & stop
	DAQmxWaitUntilTaskDone(scanT, 2*dt*length(voltsVecDouble));
	DAQmxStopTask(scanT);

	% Read counter, with + 1 space to account for diff operation below
	[status, readArray] = ReadCounter(counterT, length(voltsVecDouble) + 1, 10);

	% Stop counter
	DAQmxStopTask(counterT);

	% Read row of x counts from DAQ. It is a running count, so we take the differnec
	% to get the number of counts at each pixel.
	sData = diff(readArray)/(dt*1000);

	% Clean up DAQ tasks
	CleanUpDAQmx(counterT, clockT, scanT);
end