function [] =  SetTriggeredSweep(fMin, fMax, nSteps, dt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function programs the Agilent N9310A signal generator to
% perform a frequency sweep, starting on an external trigger.
% 
% inputs:
%
% * fMin (double) (kHz): start frequency for the sweep
% * fMax (double) (kHz): stop frequency for the sweep
% * nSetps (int): number of frequency steps between fMin and fMax
% * dt (double) (ms): amount of time to remain at each frequency step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Open connection to Agilent N9310A Signal generator
	N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
	fopen(N9310A);
	fprintf(N9310A, ':MOD:STATE OFF');
	fprintf(N9310A, ':IQ:STATE OFF');
	fprintf(N9310A, ':RFOUTPUT:STATE ON');

	% Set start and stop frequencies for RF sweep
	fprintf(N9310A, [':SWEEP:RF:START ', num2str(fMin), ' kHz']);
	fprintf(N9310A, [':SWEEP:RF:STOP ', num2str(fMax), ' kHz']);

	% Set number of points to take between start and stop frequencies
	fprintf(N9310A, [':SWEEP:STEP:POINTS ', num2str(nSteps)]);
	fprintf(N9310A, [':FREQUENCY:RF:SCALE LIN']);

	% Set dwell time for each frequency, in ms
	% fprintf(N9310A, [':SWEEP:STEP:DWELL ', num2str(dt), 'ms']);
	% fprintf(N9310A, [':SWEEP:TYPE STEP']);

	% Repeat once
	fprintf(N9310A, [':SWEEP:REPEAT SINGLE']);

	% External trigger
	%
	% To use an external trigger, the sweep trigger must be set to 
	% KEY and the point trigger set to EXT
	
	fprintf(N9310A, ':SWEEP:RF:STATE ON');
	fprintf(N9310A, [':SWEEP:STRG:SLOPE EXTP']);
	fprintf(N9310A, [':SWEEP:STRG EXT']);
	fprintf(N9310A, [':SWEEP:PTRG EXT']);


	% Close connection
	fclose(N9310A);

end


