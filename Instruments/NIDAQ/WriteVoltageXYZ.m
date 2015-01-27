%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function: WriteVoltageXY(channel, voltage)
%
% inputs: 
% * channel (int) OR (str): either 1 for 'x', 2 for 'y', 3 for 'z', or the device
% channel passed as a string. Determines which galvo to move
% * voltage (double): voltage to send to galvo
%
% useage: Outputs a voltage to DAQ channel ao0 or ao1 or a02 in order to move the
% galvos.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function WriteVoltageXYZ(Device, voltage)


    if isnumeric(Device)

    % channel ao0 will be for x, a01 for y, a02 for z.
        switch Device
            case 1
                Device = 'Dev1/ao0';
            case 2
                Device = 'Dev1/ao1';
            case 3
                Device = 'Dev1/ao2';
            case 4
                Device = 'Dev2/ao0';
            case 5
                Device = 'Dev2/ao1';
            otherwise
                error(['Supplied channel ', num2str(channel), ', which is not x, y, or z'])
        end
    % Otherwise check to see if the channel is specified by a string.
    elseif ~isempty(regexp(Device, 'Dev[1-2]/ao[0-2]', 'ONCE'))
        % Do nothing
    else
        error(['Supplied device: ', Device, 'not recognized.'])
    end

   % Check that voltage is within accepted limits
    if strcmp(Device, 'Dev1/ao0') || strcmp(Device, 'Dev1/ao1')
        if abs(voltage) > 10
            error('Abs(voltage) cannot exceed 4 volts for Thorlabs galvos.');
        end
        vMax = 5;
        vMin = -5;
    elseif strcmp(Device, 'Dev2/ao0') || strcmp(Device, 'Dev2/ao1')
        if voltage > 5 || voltage < 0 
            error('Voltage must be between 0 and 5 volts for Oxford galvos.');
        end
        vMax = 5;
        vMin = 0;
    else
        if abs(voltage) > 10
            error('Abs(voltage) cannot exceed 10 volts for z piezo.');
        end
        vMax = 10;
        vMin = -10;
    end


    % Create task on NIDAQ
    [status, TaskName, task] = DAQmxCreateTask([]);

    % Create an analog voltage out channel on device
    status = DAQmxCreateAOVoltageChan(task,Device,vMin, vMax);

    % Check to make sure creating a channel succeeded. Success means status ==
    % 0
    if status
        DAQmxClearTask(task);
        error(['Error creating voltage channel. Code ', int2str(status)]);
    end

    % Now write value voltage to voltage channel created above.
    status = DAQmxWriteAnalogScalarF64(task,1,0,voltage);

    % Check to make sure this succeeded
    if status
        DAQmxClearTask(task);
        error(['Error writing voltage channel. Code ', int2str(status)]);
    end

    % Clean up task
    DAQmxClearTask(task);


end