function task = WriteVoltage(Device,Voltage)

aoN = eval(Device(length((Device))));
if aoN == 0 | aoN == 1
    if abs(Voltage) > 4.00
        disp('Error: The Voltage cannot exceed 4 Volts');
        return;
    end
end

[ status, TaskName, task ] = DAQmxCreateTask([]);
status = status + DAQmxCreateAOVoltageChan(task,Device,-10,10);
status = status + DAQmxWriteAnalogScalarF64(task,1,0,Voltage);
if status ~= 0
    disp(['Error in writing voltage in Device ' Device]);
end

disp([num2str(Voltage) ' Volts written in ' Device]);

status = DAQmxClearTask(task);
if status ~= 0
    disp(['Error in clearing task in ' Device]);
end
