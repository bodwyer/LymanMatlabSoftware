%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment parameters
N_EXPERIMENTS = 500000;
N_REPS = 4;
SAMPS_PER_EXPERIMENT = 2;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;

% System Constants
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
RISE_TIME = 50; % ns
DELAY = 800; %ns
WAIT_TIME = 2e3; % ns

% Arb parameters
% T_MIN = 10e3; % seconds (pulse length)
% T_MAX = 10e3; % seconds (pulse length)
% T_STEP = .1e3;
F_MIN = 4e6; 
F_MAX = 6e6;
N_FREQ = 20;

ARB_AMPLITUDE = 0.100; % 300 mV
% ARB_FREQ = 5.05e6; % 5.05 MHz
N_POINTS_ARB = 1000;
timeout = 120;

% MW Parameters
PI_TIME = 855; % ns
FREQ = 2.8141e6; % kHz
POWER = -27; % dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveStr = GenerateSaveFolders('NMR_FREQ');

RFFreqVec = linspace(F_MIN, F_MAX, N_FREQ);

% RFTimeVec_Random = RFTimeVec(randperm(length(RFTimeVec)));

RFCountsVec = nan(size(RFFreqVec));
refCountsVec = nan(size(RFFreqVec));
normVec = [nan];
refVec = [nan];

RigolSetAmpl(ARB_AMPLITUDE, 'VPP', 1); % Set arb amplitude
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':RFOUTPUT:STATE ON');


pulseTime = 15e3;
[location, trackHandle] = StoreNVLocation('initial', saveStr);
tic;
zTime = 0;
for it = 1:length(RFFreqVec)
    arbFreq = RFFreqVec(it);
    pulseTimeSec = pulseTime*1e-9;
    pulseFreq = 1/pulseTimeSec;
    RigolSetFreq(pulseFreq, 1);

    countsArray = zeros(1, N_SAMPLES);

    % Make waveform
    
    times = linspace(0, pulseTimeSec, N_POINTS_ARB);
    data = sin(2 * arbFreq * pi * times);
    tzero = times(round(length(times)/2));
    twidth = pulseTimeSec/2;
%     env = exp(-(times - tzero).^2/twidth^2);
%     data = data .* env;

%     Send it to arb
    ProgramRigolArb(data, 1);

%     setrigolburst((pulseTime*1e-9)/2, 5.05e6, 0)
    
    for i = 1:N_REPS
        
%         repsVec = [repsVec, i];
        sData = struct();
        sData.RepNum = i;
        sData.pulseLen = pulseTime;

        disp(['Frequency: ', num2str(arbFreq), ' Hz']);
        disp(['Rep number ', num2str(i)]);

        [status, task] = SetPulseWidthMeas(N_SAMPLES);
        
        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 200e6); % Give the DAQ some time to start
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 400); % Start of loop

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize with green
        PBInst(0, 'ON', 'CONTINUE',0, WAIT_TIME); % Turn off briefly
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % GHz Pi pulse - m_S = 0 -> m_S = -1
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % Wait briefly
        PBInst(2^9 + 2^19, 'ON', 'CONTINUE', 0, pulseTime); % NMR Pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);


        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % Back to |0>, or nothing if nuclear spin flipped

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY);
        PBInst(2^5 + 2^15 + 2^7 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE); % Read out

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize with green
        PBInst(0, 'ON', 'CONTINUE',0, WAIT_TIME); % Turn off briefly
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY);
        PBInst(2^5 + 2^7 + 2^15 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE); % Read out Reference

        PBInst(0, 'ON', 'CONTINUE', 0, 2*pulseTime); % Keep each run same length

 
        PBInst(0, 'ON', 'END_LOOP', loop, 400);
        PBesrStopProgramming();
        
        
        DAQmxStartTask(task);
        PBesrStart();
        
        
        
        [status, readArray] = ReadCounter(task, N_SAMPLES, timeout);
        DAQmxStopTask(task);
        DAQmxClearTask(task);

        sData.data = readArray;
        save([saveStr, '_Rep', num2str(i), '_pulseTime', num2str(pulseTime)], 'sData', '-v7.3');
        
        PBesrStop();
        PBesrClose();
        
        countsArray = countsArray + readArray;
        
        
     
        
        elapsedTime = toc
        zTime = zTime + elapsedTime;
        if elapsedTime > 120
            [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);

            if zTime > 300
                [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);
                [params, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
                z0 = params(1);
                LastLocation(location{1}, location{2}, z0);
                zTime = 0;
            else
                z0 = location{3};
            end
            LastLocation(location{1}, location{2}, z0);
            tic;
        end

        


        
    end
    
    RFCounts = sum(countsArray(1:2:end));
    refCounts = sum(countsArray(2:2:end));

    RFCountsVec(it) = RFCounts;
    refCountsVec(it) = refCounts;
    
 
end


AgilentSGControl(':RFOUTPUT:STATE OFF');

% PowerStripControl('ALL', 'OFF');


fig = figure();
subplot(1, 2, 1);
plot(RFFreqVec, RFCountsVec, 'r');
hold on
plot(RFFreqVec, refCountsVec, 'g');
xlabel('Frequency');
ylabel('flourescence (kCounts/sec)');
title('Nuclear Rabi');
legend('NMR Rabi', 'Reference Bright');

normData = (RFCountsVec - refCountsVec)./(refCountsVec);

[params, fit] = FitSineWave(RFFreqVec, normData);

subplot(1, 2, 2)
plot(RFFreqVec, normData, 'ko');
hold on
plot(RFFreqVec, fit, 'm');
xlabel('Frequency');
ylabel('flourescence change');
title(['\pi time = ', num2str(pi/params(2)), ' ns']);
legend('Data', 'Fit')

[location, trackHandle] = StoreNVLocation('final', fileStr, location, trackHandle);


savefig([fig, trackHandle], [saveStr, '_Figs']);
save([saveStr, '_ALL_VARS'],'-v7.3')


    

