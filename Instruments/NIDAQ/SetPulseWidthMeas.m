function [status, pulseWidthTask] = SetPulseWidthMeas(nSamples)

	DAQmx_Val_Seconds =10364; % Seconds
	DAQmx_Val_Rising = 10280; % Rising
	DAQmx_Val_FiniteSamps = 10178; % Finite Samples
	DAQmx_Val_Ticks =10304; % Ticks
	DAQmx_Val_ContSamps =10123; % Continuous Samples

	MIN_TICKS = 0;
	MAX_TICKS = 100E3;
	[ status, TaskName, pulseWidthTask ] = DAQmxCreateTask([]);
	DAQmxErr(status);
	status = DAQmxCreateCIPulseWidthChan(pulseWidthTask, 'Dev1/ctr0','',...
		MIN_TICKS, MAX_TICKS,DAQmx_Val_Ticks,DAQmx_Val_Rising,'');
	DAQmxErr(status);
	status = DAQmxCfgImplicitTiming(pulseWidthTask, DAQmx_Val_ContSamps ,nSamples);
	DAQmxErr(status);
	result = DAQmxGet(pulseWidthTask, 'CI.CtrTimebaseSrc', 'Dev1/ctr0');
	DAQmxSet(pulseWidthTask, 'CI.CtrTimebaseSrc', 'Dev1/ctr0', '/Dev1/PFI8');
	DupCount = DAQmxGet(pulseWidthTask, 'CI.DupCountPrevent', 'Dev1/ctr0');
	DAQmxSet(pulseWidthTask, 'CI.DupCountPrevent', 'Dev1/ctr0',1);


end


