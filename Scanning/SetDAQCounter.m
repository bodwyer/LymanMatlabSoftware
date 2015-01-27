function [hCounter, hClock, status] = SetDAQCounter(freq, nSamps)

	[status, hCounter, hClock] = SetCounter(freq, nSamps, 'INTERNAL');
	status = status + DAQmxStartTask(hCounter);

end
