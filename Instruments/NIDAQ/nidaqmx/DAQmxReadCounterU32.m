function [status, readArray, aux]=DAQmxReadCounterU32(taskHandle, numSampsPerChan,...
    timeout, readArray, arraySizeInSamps, sampsPerChanRead )

[status,readArray, aux]=calllib('mynidaqmx','DAQmxReadCounterU32',taskHandle, numSampsPerChan, ...
    timeout, readArray, arraySizeInSamps, sampsPerChanRead,[]);