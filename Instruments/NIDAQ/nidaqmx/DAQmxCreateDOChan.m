function [status] = DAQmxCreateDOChan(taskHandle, strLines,...
    strNameToAssignToLines, lineGrouping);

[status] = calllib('mynidaqmx','DAQmxCreateDOChan',taskHandle, strLines, ...
    strNameToAssignToLines, lineGrouping);