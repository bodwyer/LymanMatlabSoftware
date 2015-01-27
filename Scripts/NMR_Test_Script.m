%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment parameters
N_EXPERIMENTS = 333333;
N_REPS = 1;
SAMPS_PER_EXPERIMENT = 3;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;

% System Constants
LASER_INIT_TIME = 2E3; % nano seconds (1us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
RISE_TIME = 50; % ns
DELAY = 800; %ns
WAIT_TIME = 2e3; % ns

% Arb parameters
T_MIN = 10e3; % seconds (pulse length)
T_MAX = 15e3; % seconds (pulse length)
T_STEP = 1e3;
ARB_AMPLITUDE = 0.300; % 300 mV
ARB_FREQ = 5.05e6; % 5.05 MHz
N_POINTS_ARB = 1000;
timeout = T_MAX*10;

% RF Parameters
PI_TIME = 500; % ns
FREQ = 2.8141e6; % kHz
POWER = -27; % dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




MWTimeVec = T_MIN:T_STEP:T_MAX;

% MWTimeVec_Random = MWTimeVec(randperm(length(MWTimeVec)));

MWCountsVec = nan(size(MWTimeVec));
refCountsVec = nan(size(MWTimeVec));
darkCountsVec = nan(size(MWTimeVec));


AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);

% LastLocation(); % Go to most recent NV location
RigolSetAmpl(ARB_AMPLITUDE, 'VPP', 1); % Set arb amplitude

AgilentSGControl(':RFOUTPUT:STATE ON');
% [location, trackHandle] = ReTrack('turnongreen', true);
% [z0, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
% LastLocation(location{1}, location{2}, z0);
tic;
zTime = 0;
for it = 1:length(MWTimeVec)
    pulseTimePB = MWTimeVec(it);
    pulseTime = pulseTimePB*1e-9;
    pulseFreq = 1/(pulseTime);
    RigolSetFreq(pulseFreq, 1);

    countsArray = zeros(1, N_SAMPLES);
    disp(['Experiment ', num2str(it), ' of ' , num2str(length(MWTimeVec))]);

    % Make waveform
    times = linspace(0, pulseTime, N_POINTS_ARB);
    data = sin(2 * ARB_FREQ * pi * times);
    tzero = times(round(length(times)/2));
    twidth = pulseTime/5;
    env = exp(-(times - tzero).^2/twidth^2);
    data = data .* env;
%     figure
%     plot(times, ARB_AMPLITUDE*data)
%     xlabel('Time (sec)'); ylabel('Ampl (Volts)');

    % Send it to arb
    ProgramRigolArb(data, 1);

    
    for i = 1:N_REPS
%         [status, task] = SetPulseWidthMeas(N_SAMPLES);
        
        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 2e6); % Give the DAQ some time to start
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 400); % Start of loop

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize with green
        PBInst(0, 'ON', 'CONTINUE',0, WAIT_TIME); % Turn off briefly
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % GHz Pi pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % Wait briefly
%         PBInst(2^9 + 2^19, 'ON', 'CONTINUE', 0, pulseTimePB); % NMR Pulse
%         PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY);
        PBInst(2^5 + 2^7 + 2^15 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE); % Read out

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize with green
        PBInst(0, 'ON', 'CONTINUE',0, WAIT_TIME); % Turn off briefly
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % GHz Pi pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % Wait briefly
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY);
        PBInst(2^5 + 2^7 + 2^15 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE); % Read out Dark

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % Turn off briefly
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); 
        PBInst(2^5 + 2^7 + 2^15 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE); % Read out bright

        PBInst(0, 'ON', 'CONTINUE', 0, T_MAX - pulseTime + 40); % Keep each run same length

        PBInst(0, 'ON', 'END_LOOP', loop, 400);
        PBesrStopProgramming();
        
        
        PBesrStart();
%         DAQmxStartTask(task);
        pause(30);
%         
%         [status, readArray] = ReadCounter(task, N_SAMPLES, timeout);
%         countsArray = countsArray + readArray;
        PBesrStop();
        PBesrClose();
% 
%         DAQmxStopTask(task);
%         DAQmxClearTask(task);


        
    end
    
%     MWCounts = mean(countsArray(1:3:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
%     refCounts = mean(countsArray(3:3:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
%     darkCounts = mean(countsArray(2:3:end)/(READOUT_PULSE*1e-9*1000*N_REPS);
%     MWCountsVec(it) = MWCounts;
%     refCountsVec(it) = refCounts;
%     darkCountsVec(it) = darkCounts;
    
    elapsedTime = toc
    zTime = zTime + elapsedTime;
%     if elapsedTime > 30
%         [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);
%       
%         if zTime > 180
%             [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);
%             [z0, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
%             LastLocation(location{1}, location{2}, z0);
%             zTime = 0;
%         else
%             z0 = location{3};
%         end
%         LastLocation(location{1}, location{2}, z0);
%         tic;
%     end
 
end


AgilentSGControl(':RFOUTPUT:STATE OFF');




fig = figure();
subplot(1, 2, 1);
plot(MWTimeVec, MWCountsVec, 'r');
hold on
plot(MWTimeVec, refCountsVec, 'b');
plot(MWTimeVec, darkCountsVec, 'k');
xlabel('Pulse Duration (ns)');
ylabel('flourescence (kCounts/sec)');
title(['Rabi, power = ', num2str(POWER), ' dBm']);
legend('NMR Rabi', 'Reference Bright', 'Reference Dark');

normData = (MWCountsVec - darkCounts)./(refCountsVec - darkCountsVec);

[params, fit] = FitSineWave(MWTimeVec, normData);

subplot(1, 2, 2)
plot(MWTimeVec, normData, 'go');
hold on
plot(MWTimeVec, fit, 'm');
xlabel('Pulse Duration (ns)');
ylabel('flourescence change');
title(['\pi time = ', num2str(pi/params(2)), ' ns']);
legend('Data', 'Fit')

    

