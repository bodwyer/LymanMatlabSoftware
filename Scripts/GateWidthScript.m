FREQ = 2.8348e6; % kHz resonance
N_EXPERIMENTS = 500000;
SAMPS_PER_EXPERIMENT = 2;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
N_REPS = 4;
TAU_MIN = 290; % ns
TAU_MAX = 360; % ns
TAU_STEP = 2.5;
LONG_DELAY_TIME = 50;
LASER_INIT_TIME = 4E3; % nano seconds (4us)
LASER_INIT_REPS = LASER_INIT_TIME/LONG_DELAY_TIME;
READOUT_PULSE = 350; % ns
RISE_TIME = 50; % ns
DELAY = 800 + RISE_TIME; %ns
DELAY_REPS = DELAY/LONG_DELAY_TIME;
WAIT_TIME = 2e3; % ns
WAIT_REPS = WAIT_TIME/LONG_DELAY_TIME;
PI_TIME_TWO = 16.5; % ns
PI_TIME = 33;
POWER = -2; % dBm

% LastLocation();
pause(.2)


tauVec = TAU_MIN:TAU_STEP:TAU_MAX;
tauVecRandom = tauVec(randperm(length(tauVec)));

countsVecB = zeros(size(tauVec));
countsVecD = zeros(size(tauVec));



N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);

timeout = 120;




fprintf(N9310A, ':RFOUTPUT:STATE ON');

[location, trackHandle] = ReTrack('turnongreen', true);
[z0, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
LastLocation(location{1}, location{2}, z0);
tic;
zTime = 0;

for i = 1:N_REPS
    

    for it = 1:length(tauVec)
        tau = tauVec(it); 
        disp(['Rep: ', num2str(i), ' of ', num2str(N_REPS)]);
        disp(['tau = ', num2str(tau), ' ns']);
        


        [status, task] = SetPulseWidthMeas(N_SAMPLES);

        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500); % Give DAQ some time
        loop = PBesrInstruction(0, 'ON', 'LOOP', N_EXPERIMENTS, 20);
        PBesrInstruction(2^5, 'ON', 'LONG_DELAY', DELAY_REPS, LONG_DELAY_TIME); % laser init
        PBesrInstruction(2^5, 'ON', 'LONG_DELAY', LASER_INIT_REPS, LONG_DELAY_TIME);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME); % turn off and wait
        PBesrInstruction(2^5, 'ON', 'LONG_DELAY', DELAY_REPS, LONG_DELAY_TIME); % Readout with green
        if tau > 640
            tauLong = idivide(int32(tau), int32(320));
            tauShort = mod(tau, 320);
            PBesrInstruction(2^5 + 2^7, 'ON', 'LONG_DELAY', tauLong, 320);
            PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, tauShort);
        else
            PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, tau);
        end
        PBesrInstruction(2^5, 'ON', 'LONG_DELAY', LASER_INIT_REPS, LONG_DELAY_TIME); % Initialize
        PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME); % turn off briefly
        PBesrInstruction(2^3, 'ON', 'CONTINUE', 0, PI_TIME); % pi pulse
%         PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME); % wait
        PBesrInstruction(2^5, 'ON', 'LONG_DELAY', DELAY_REPS, LONG_DELAY_TIME); % read out dark
        if tau > 640
            tauLong = idivide(int32(tau), int32(320));
            tauShort = mod(tau, 320);
            PBesrInstruction(2^5 + 2^7, 'ON', 'LONG_DELAY', tauLong, 320);
            PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, tauShort);
        else
            PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, tau);
        end
        % keep pulse trains same length with this last instruction
        endTime = TAU_MAX - tau + 100;
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, endTime);
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, endTime);
        PBesrInstruction(0, 'ON', 'END_LOOP', loop, 200);
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 200);
        PBesrStopProgramming();

        PBesrStart();
        DAQmxStartTask(task);

        [status, readArray] = ReadCounter(task, N_SAMPLES, timeout);
  
        PBesrStop();
        PBesrClose();
        
        if status ~= 0
            CleanUp;
            error('Could not read array. Terminating run.');
        end

        
        DAQmxStopTask(task);
        DAQmxClearTask(task);

        countsVecB(it) = countsVecB(it) + sum(readArray(1:2:end));
        countsVecD(it) = countsVecD(it) + sum(readArray(2:2:end));
        elapsedTime = toc
        zTime = zTime + elapsedTime;
        if elapsedTime > 30
            [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);

            if zTime > 180
                [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);
                [z0, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
                LastLocation(location{1}, location{2}, z0);
                zTime = 0;
            else
                z0 = location{3};
            end
            LastLocation(location{1}, location{2}, z0);
            tic;
        end
    end
end




fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);

countsVecB = countsVecB./(N_REPS*1e-9*N_EXPERIMENTS*1000*tauVec);
countsVecD = countsVecD./(N_REPS*1e-9*N_EXPERIMENTS*1000*tauVec);

contrastVec = countsVecB - countsVecD;
figure();
subplot(1, 2, 1);
plot(tauVec, countsVecB, '-g+', tauVec, countsVecD, '-k+');
xlabel('Window Size (ns)'); ylabel('kCounts/sec');
title('Contrast');

subplot(1, 2, 2);
plot(tauVec, contrastVec, '-r+');
xlabel('Window size (ns)');
ylabel('contrast (arbitrary units)');
title('Readout Window for best contrast');