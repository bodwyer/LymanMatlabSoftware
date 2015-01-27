
N_EXPERIMENTS = 1000000;
N_REPS = 2;
SAMPS_PER_EXPERIMENT = 1;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
T_MIN = 400; % ns
T_MAX = 800; % ns
T_STEP = 25;
LASER_INIT_TIME = 4E3; % nano seconds (1us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
LASER_INIT_REPS = LASER_INIT_TIME/LONG_DELAY_TIME; % for long delay command
RISE_TIME = 50; % ns
DELAY = 800 + RISE_TIME; %ns
DELAY_REPS = DELAY/LONG_DELAY_TIME; % for the long delay command
WAIT_TIME = 1.5e3; % ns
WAIT_REPS = WAIT_TIME/LONG_DELAY_TIME;
POWER = -7; % dBm

timeout = 120;

MWTimeVec = T_MIN:T_STEP:T_MAX;

% MWTimeVec_Random = MWTimeVec(randperm(length(MWTimeVec)));
counts = nan(size(MWTimeVec));



N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);

% LastLocation(); % Go to most recent NV location

fprintf(N9310A, ':RFOUTPUT:STATE ON');
[location, trackHandle] = ReTrack('turnongreen', true);
LastLocation(location{1}, location{2}, location{3});
tic;

for it = 1:length(MWTimeVec)
    pulseTime = MWTimeVec(it);  
    delay = pulseTime;
    countsArray = zeros(1, N_SAMPLES);
    disp(['Experiment ', num2str(it), ' of ' , num2str(length(MWTimeVec))]);
    
    for i = 1:N_REPS
        [status, task] = SetPulseWidthMeas(N_SAMPLES);
        
        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        loop = PBesrInstruction(0, 'ON', 'LOOP', N_EXPERIMENTS, 400);
        PBesrInstruction(2^5, 'ON', 'LONG_DELAY', LASER_INIT_REPS,LONG_DELAY_TIME);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME);
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        if delay > 640
            delayLong = idivide(int32(delay), int32(320));
            delayShort = mod(delay, 320);
            PBesrInstruction(0, 'ON', 'LONG_DELAY', delayLong, 320);
            PBesrInstruction(0, 'ON', 'CONTINUE', 0, delayShort);
        else
            PBesrInstruction(0, 'ON', 'CONTINUE', 0, delay);
        end
        PBesrInstruction(2^7, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, T_MAX/2 - delay/2 + 100);
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, T_MAX/2 - delay/2 + 100);
        PBesrInstruction(0, 'ON', 'END_LOOP', loop, 400);
        cnt = PBesrInstruction(0, 'ON', 'CONTINUE', 0, 500);
        PBesrInstruction(0, 'ON', 'BRANCH', cnt, 100);
        PBesrStopProgramming();
        
        
        PBesrStart();
        DAQmxStartTask(task);
        
        
        [status, readArray] = ReadCounter(task, N_SAMPLES, timeout);
        countsArray = countsArray + readArray;
        PBesrStop();
        PBesrClose();

        DAQmxStopTask(task);
        DAQmxClearTask(task);


        
    end
    
    counts(it) = mean(countsArray)/(1e9*1000*N_REPS*READOUT_PULSE);
    elapsedTime = toc
    if elapsedTime > 30
        [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);
        LastLocation(location{1}, location{2}, location{3});
        tic
    end
 
end


fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);

% countsSort = [MWTimeVec_Random', MWCountsVec'];
% countsSorted = sortrows(countsSort, 1);
% MWCountsVec = countsSorted(:, 2)';

fig = figure();
plot(MWTimeVec, counts, '-g+');
xlabel('Delay (+) ns'); ylabel('Counts');
title('Delay for green')

    

