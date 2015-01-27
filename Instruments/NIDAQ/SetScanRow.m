function [aoStatus, aoTask] = SetScanRow(vVec, sampleRate, device)
	% Constants
	DAQmx_Val_Rising = 10280; % Rising
	DAQmx_Val_FiniteSamps = 10178; % Finite Samples
	DAQmx_Val_GroupByChannel = 0; % Group per channel

	nSamples = length(vVec);
	[aoStatus, aoTaskName, aoTask] = DAQmxCreateTask([]);
	aoStatus = aoStatus + DAQmxCreateAOVoltageChan(aoTask, ['Dev1/', device], -10, 10);
	aoStatus = aoStatus + DAQmxCfgSampClkTiming(aoTask, '/Dev1/PFI13', sampleRate, ...
		DAQmx_Val_Rising, DAQmx_Val_FiniteSamps, nSamples);

	zero_ptr = libpointer('int32Ptr',zeros(1,nSamples));

	aoStatus = aoStatus + DAQmxWriteAnalogF64(aoTask, nSamples, 0, 10,...
	    DAQmx_Val_GroupByChannel, vVec, zero_ptr);


	if aoStatus ~= 0
		error('Could not create continuous scan channel!')
	end

end

