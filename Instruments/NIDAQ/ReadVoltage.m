function Voltage = ReadVoltage(Device)
DAQmx_Val_Volts= 10348; % measure volts
DAQmx_Val_Cfg_Default =-1; % Default

[ status, TaskName, taskHandle ] = DAQmxCreateTask([]);
status = DAQmxCreateAIVoltageChan(taskHandle,Device,'',DAQmx_Val_Cfg_Default,-10.0,10.0,DAQmx_Val_Volts,[]);
[status, Voltage] = DAQmxReadAnalogScalarF64(taskHandle);
status = DAQmxClearTask(taskHandle);

if status ~= 0
    disp(['Error in reading voltage in Device ' Device]);
end
