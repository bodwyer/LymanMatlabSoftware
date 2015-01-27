function [status] = CleanUpDAQmx(varargin)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Cleans up and closes all DAQmx tasks
	% passed to it.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



	for it = 1:length(varargin)
		iTask = varargin{it};
		status = DAQmxStopTask(iTask);
		status = status + DAQmxClearTask(iTask);
		if status ~= 0
			error('Error stopping task!')
		end
	end

end
