function [status, counterTask, clockTask] = SetCounter(frequency, nSamps, clockSource)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Function to be called after introducing a clock, either from 
	% DigPuleTrainCont or from external source. If source is external,
	% clockSource must be a string specifying what channel the clock
	% should be read from. This function triggers off of a rising
	% signal. One must still call DAQmxStartTask(counterTask) to use
	% the counter, and also clean up both channels afterwards
	%
	% Inputs:
	%
	% * frequency (double): The frequency at which the clock is running
	% 	(the measurement frequency)
	% * nSamps (int): number of samples to take
	% * clockSource (str): source of the timing signal. Either a string
	% 	specifying a channel on Dev1, or 'INTERNAL', which will default to
	% 	the DAQ internal clock.
	%
	% Outputs:
	%
	% * status (int): will be 0 if all chanels were initialized properly
	% * counterTask: handle to the counter channel
	% * clockTask: handle to the clock channel
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Constants to talk to DAQmx functions 
	DAQmx_Val_Rising = 10280; % Rising
	DAQmx_Val_CountUp = 10128; % Count Up
	DAQmx_Val_ContSamps =10123; % Continuous Samples


	 % Create the counter task
	[ counterStatus, TaskName, counterTask ] = DAQmxCreateTask([]);
	counterStatus = counterStatus +  DAQmxCreateCICountEdgesChan(counterTask,'Dev1/ctr0','',DAQmx_Val_Rising , 0, DAQmx_Val_CountUp);

	% if using internal colock, set it up and start it.
	if strcmp(clockSource, 'INTERNAL')
		[clockStatus, clockTask] = DigPulseTrainCont(frequency, 0.5, nSamps);
		clockStatus = clockStatus + DAQmxStartTask(clockTask);
		counterStatus = counterStatus + DAQmxCfgSampClkTiming(counterTask,'/Dev1/PFI13',frequency, DAQmx_Val_Rising,DAQmx_Val_ContSamps ,nSamps);
	else % Else set up the external clock. This must be started manually.
		counterStatus = counterStatus + DAQmxCfgSampClkTiming(counterTask,['/Dev1/', clockSournce],frequency, DAQmx_Val_Rising,DAQmx_Val_ContSamps ,nSamps);
		% Don't need to return a task ID for an external clock
		clockTask = -1;
	end

	% Check to make sure all DAQmx functions executed properly.
	status = counterStatus + clockStatus;

	if status ~= 0
		error('Unable to create counter and clock channels!')
	end

end

