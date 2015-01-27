function [status, readArray] = ReadCounter(counterTask, nSamples, timeOut)
	samplesPerChan = nSamples;
	readArray = zeros(1, nSamples);
	arraySize = nSamples;
	samplesPerChanRead = libpointer('int32Ptr', 0);
	[status, readArray] = DAQmxReadCounterF64(counterTask, samplesPerChan, timeOut, readArray, arraySize, samplesPerChanRead);
	DAQmxErr(status)
end