
% Constants
N_REPS = 1000000; % Repetitions (for a given pulse time)
PULSE_DURATION = 350; % nanoseconds
LASER_INIT_TIME = 2e3; % nano seconds (100 us)

delayVec = 10:10:1200;


% Pulseblaster Binary codes
LASER_ON_COUNTER_ON = bin2dec('10100000');
LASER_OFF_COUNTER_OFF = bin2dec('00000000');
LASER_ON_COUNTER_OFF = bin2dec('00100000');
LASER_OFF_COUNTER_ON = bin2dec('10000000');

% Load function libraries for DAQ and PulseBlaster
LoadNIDAQmx;
LoadPBESR;

countsVec = nan(size(delayVec));

fig1 = figure();
h = plot(delayVec, countsVec);
xlabel('delay time (ns)');
ylabel('flourescence (Counts)');
title('Optimal delay');
set(h, 'YDataSource', 'countsVec');
set(h, 'XDataSource', 'delayVec');

[location, trackHandle] = ReTrack(true);
tic
for ip = 1:length(delayVec)
     delay = delayVec(ip);
    disp(['Run number ', num2str(ip)])
    
    [status, task] = SetPulseWidthMeas(N_REPS);
    
    
    PBesrInit();
    PBesrSetClock(400);
    PBesrStartProgramming(); 
    PBesrInstruction(LASER_OFF_COUNTER_OFF, 'ON', 'CONTINUE', 0, 0.5E9);
    loop = PBesrInstruction(LASER_OFF_COUNTER_OFF, 'ON', 'LOOP', N_REPS, LASER_INIT_TIME);
    if delay < 0
        if abs(delay) > PULSE_DURATION
            PBesrInstruction(LASER_OFF_COUNTER_ON, 'ON', 'CONTINUE', 0, PULSE_DURATION);
            PBesrInstruction(LASER_OFF_COUNTER_OFF, 'ON', 'CONTINUE', 0, abs(delay) - PULSE_DURATION);
            PBesrInstruction(LASER_ON_COUNTER_OFF, 'ON', 'CONTINUE', 0, PULSE_DURATION);
        elseif delay ~= 0
            PBesrInstruction(LASER_OFF_COUNTER_ON, 'ON', 'CONTINUE', 0, abs(delay));
            PBesrInstruction(LASER_ON_COUNTER_ON, 'ON', 'CONTINUE', 0, PULSE_DURATION - abs(delay));
            PBesrInstruction(LASER_ON_COUNTER_OFF, 'ON', 'CONTINUE', 0, abs(delay));
        end
    else
        if delay > PULSE_DURATION
            PBesrInstruction(LASER_ON_COUNTER_OFF, 'ON', 'CONTINUE', 0, PULSE_DURATION);
            PBesrInstruction(LASER_OFF_COUNTER_OFF, 'ON', 'CONTINUE', 0, delay - PULSE_DURATION);
            PBesrInstruction(LASER_OFF_COUNTER_ON, 'ON', 'CONTINUE', 0, PULSE_DURATION);
        else
            PBesrInstruction(LASER_ON_COUNTER_OFF, 'ON', 'CONTINUE', 0, delay);
            PBesrInstruction(LASER_ON_COUNTER_ON, 'ON', 'CONTINUE', 0, PULSE_DURATION - delay);
            PBesrInstruction(LASER_OFF_COUNTER_ON, 'ON', 'CONTINUE', 0, delay);
        end
    end
    PBesrInstruction(LASER_OFF_COUNTER_OFF, 'ON', 'END_LOOP', loop, 100);
    PBesrStopProgramming();
    
    PBesrStart();
    DAQmxStartTask(task);
    timeout = 60; % Seconds
    [status, readArray] = ReadCounter(task, N_REPS, timeout);
    countsVec(ip) = sum(readArray);
    
    PBesrStop();
    PBesrClose();
    DAQmxClearTask(task);
   
    
    refreshdata(fig1);
       if toc > 20
        [location, trackHandle] = ReTrack(true, location,trackHandle);
        tic
    end
 end
    
TurnOffGreen();

