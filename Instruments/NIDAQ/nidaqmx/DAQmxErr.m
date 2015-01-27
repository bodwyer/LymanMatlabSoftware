function DAQmxErr(errorCode)

bufferSize = 500;
errorString = char(ones(1,bufferSize));
[status,errorString]=calllib('mynidaqmx','DAQmxGetErrorString', ...
    errorCode, errorString, bufferSize);
if errorCode == 0
    return;
end
errorString
if ~isempty(errorString)
    disp(['Error ' num2str(errorCode) ':' errorString]);
end
    