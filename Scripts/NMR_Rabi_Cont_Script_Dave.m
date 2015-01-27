%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment parameters
N_EXPERIMENTS = 100000;
N_REPS = 1000;
SAMPS_PER_EXPERIMENT = 2;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;

% System Constants
LASER_INIT_TIME = 2E3; % nano seconds (1us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
RISE_TIME = 50; % ns
DELAY = 800; %ns
WAIT_TIME = 2e3; % ns

% Arb parameters
T_MIN = 20e3; % seconds (pulse length)
T_MAX = 20e3; % seconds (pulse length)
T_STEP = .1e3;
ARB_AMPLITUDE = 0.25; % 300 mV
ARB_FREQ = 5.05e6; % 5.05 MHz
N_POINTS_ARB = 1000;
timeout = 60;

% RF Parameters
PI_TIME = 627; % ns
FREQ = 2.835e6; % kHz
POWER = -29; % dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up directory and filenames for saving all data.
% If folder exists with same name, create new folder with num + 1
% at the end
% fileBase = [date, '_Nuclean_Rabi'];
% directory = 'C:\Users\MAXWELL\Documents\MATLAB\NV\Dave\Data\';
% 
% listDir = dir(directory);
% isub = [listDir(:).isdir]; % logical vector
% nameFolds = {listDir(isub).name};
% 
% matches = regexp(nameFolds, [date, '_run_', '[0-9]*'], 'match');
% matchesTrue = ~cellfun(@isempty, matches);
% indMatch = find(matchesTrue, 1, 'last');
% if isempty(indMatch)
%     maxNum = 1;
% else
%     maxStr = matches{indMatch};
%     maxStr = maxStr{1};
%     maxNum = round(str2double(maxStr(length([date, '_run_']) + 1:end)));
%     maxNum = maxNum + 1;
% end
% 
% folder = [date, '_run_', num2str(maxNum)];
% mkdir(directory, folder)
% saveStr = ['C:\Users\MAXWELL\Documents\MATLAB\NV\Dave\Data\', folder, '\', fileBase];


RFTimeVec = T_MIN:T_STEP:T_MAX;

% RFTimeVec_Random = RFTimeVec(randperm(length(RFTimeVec)));

RFCountsVec = nan(size(RFTimeVec));
refCountsVec = nan(size(RFTimeVec));
normVec = [nan];

RigolControl(':OUTPUT1:STATE?')
RigolSetAmpl(ARB_AMPLITUDE, 'VPP', 1); % Set arb amplitude
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':RFOUTPUT:STATE ON');

% LastLocation(); % Go to most recent NV location

repsVec = [1];
rCounts = [nan];
RFCounts = [nan];
fig = figure();
subplot(1, 2, 1)
h = plot(repsVec, normVec);
xlabel('Rep');
ylabel('\Delta brightness');
title('NMR');
subplot(1, 2, 2)
g = plot(repsVec, rCounts, 'g');
hold on
k = plot(repsVec, RFCounts, 'r');
xlabel('Rep #'); ylabel('Total counts');
title('Raw counts');
legend('Reference', 'RF Pulse');
set(h, 'YDataSource', 'normVec');
set(h, 'XDataSource', 'repsVec');
set(g, 'YDataSource', 'rCounts');
set(g, 'XDataSource', 'repsVec');
set(k, 'YDataSource', 'RFCounts');
set(k, 'XDataSource', 'repsVec');

[location, trackHandle] = ReTrack('turnongreen', true);
[params, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
z0 = params(1);
LastLocation(location{1}, location{2}, z0);
tic;
zTime = 0;
for it = 1:length(RFTimeVec)
    pulseTime = RFTimeVec(it);
    pulseTimeSec = pulseTime*1e-9;
    pulseFreq = 1/pulseTimeSec;
    RigolSetFreq(pulseFreq, 1);

    countsArray = zeros(1, N_SAMPLES);

    % Make waveform
    
    times = linspace(0, pulseTimeSec, N_POINTS_ARB);
    data = sin(2 * ARB_FREQ * pi * times);
    tzero = times(round(length(times)/2));
    twidth = pulseTimeSec/2;
%     env = exp(-(times - tzero).^2/twidth^2);
%     data = data .* env;

%     Send it to arb
    ProgramRigolArb(data, 1);

%     setrigolburst((pulseTime*1e-9)/2, 5.05e6, 0)
    
    for i = 1:N_REPS
        pause(.2);
        repsVec = [repsVec, i];
        sData = struct();
        sData.RepNum = i;
        sData.pulseLen = pulseTime;

        disp(['Pulse time: ', num2str(pulseTime), ' ns']);
        disp(['Rep number ', num2str(i)]);

        [status, task] = SetPulseWidthMeas(N_SAMPLES);
        
        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, .2e9); % Give the DAQ some time to start
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 400); % Start of loop

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize with green
        PBInst(0, 'ON', 'CONTINUE',0, WAIT_TIME); % Turn off briefly
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % GHz Pi pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % Wait briefly
        PBInst(2^9 + 2^19, 'ON', 'CONTINUE', 0, pulseTime); % NMR Pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);

%         PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY);
%         PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, READOUT_PULSE); % Gently back to |0>
% 
%         PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % Back to |-1>
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        
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
%         save([saveStr, '_Rep', num2str(i), '_pulseTime', num2str(pulseTime)], 'sData', '-v7.3');
        

        countsArray = readArray;
        PBesrStop();
        PBesrClose();
        
        RFCountsTot = sum(countsArray(1:2:end));
        refCounts = sum(countsArray(2:2:end));

        
        normalized = (RFCountsTot - refCounts)/refCounts;
        normVec(i) = normalized;
        normVec = [normVec, nan];
        rCounts(i) = refCounts;
        rCounts = [rCounts, nan];
        RFCounts(i) = RFCountsTot;
        RFCounts = [RFCounts, nan];
        refreshdata(fig);
        drawnow;
        
        elapsedTime = toc
        zTime = zTime + elapsedTime;
        if elapsedTime > 120
            [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);

            if zTime > 500
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




fig = figure();
subplot(1, 2, 1);
plot(RFTimeVec, RFCountsVec, 'r');
hold on
plot(RFTimeVec, refCountsVec, 'g');
xlabel('Pulse Duration (ns)');
ylabel('flourescence (kCounts/sec)');
title(['Rabi, power = ', num2str(POWER), ' dBm']);
legend('NMR Rabi', 'Reference Bright');

normData = (RFCountsVec - refCountsVec)./(refCountsVec);

[params, fit] = FitSineWave(RFTimeVec, normData);

subplot(1, 2, 2)
plot(RFTimeVec, normData, 'ko');
hold on
plot(RFTimeVec, fit, 'm');
xlabel('Pulse Duration (ns)');
ylabel('flourescence change');
title(['\pi time = ', num2str(pi/params(2)), ' ns']);
legend('Data', 'Fit')

% savefig([fig1, trackHandle], [saveStr, '_Figs']);
% save([saveStr, '_ALL_VARS'],'-v7.3')


    

