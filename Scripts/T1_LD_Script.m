FREQ = 2.87e6; % kHz, detuned by 4 mHz from resonance
N_EXPERIMENTS = 10000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 2; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 50; % Number of times to repeat whole process (all Tau)
TAU_MIN = 100; % ns
TAU_MAX = 3e6; % ns
TAU_STEP = 100e3; % ns
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800 + RISE_TIME; %ns (delay for laser to turn on)
WAIT_TIME = 2e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 35; % ns
PI_TIME = 70; % ns
POWER = 0; % dBm

% LastLocation();
% pause(.2)

% Vector of free precession times
tauVec = TAU_MIN:TAU_STEP:TAU_MAX;
% Randomized free precession times
tauVecRandom = tauVec(randperm(length(tauVec)));

allfilenamessofar = cell(length(tauVec), N_REPS); %list of all file names
tictocvec = zeros(length(tauVec), N_REPS); % list of all times betweeen retracks

sigVec = zeros(size(tauVec)); % Spin echo signal vector
refVec = zeros(size(tauVec)); % Bright state reference

% 
% % Start up signal generator
% N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
% fopen(N9310A);
% fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
% fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);

timeout = 5*TAU_MAX*1e-9*N_SAMPLES; % for DAQ readcounter

% Set up directory and filenames for saving all data.
% If folder exists with same name, create new folder with num + 1
% at the end
fileBase = [date, '_T1_'];
directory = 'C:\Users\MAXWELL\Documents\MATLAB\NV\Dave\Data\';

listDir = dir(directory);
isub = [listDir(:).isdir]; % logical vector
nameFolds = {listDir(isub).name};

matches = regexp(nameFolds, [date, '_run_', '[0-9]*'], 'match');
matchesTrue = ~cellfun(@isempty, matches);
indMatch = find(matchesTrue, 1, 'last');
if isempty(indMatch)
    maxNum = 1;
else
    maxStr = matches{indMatch};
    maxStr = maxStr{1};
    maxNum = round(str2double(maxStr(length([date, '_run_']) + 1:end)));
    maxNum = maxNum + 1;
end

folder = [date, '_run_', num2str(maxNum)];
mkdir(directory, folder)
saveStr = ['C:\Users\MAXWELL\Documents\MATLAB\NV\Dave\Data\', folder, '\', fileBase];
% 
% % Turn on RF
% fprintf(N9310A, ':RFOUTPUT:STATE ON');
% Retrack
[location, trackHandle] = ReTrack('turnongreen', true);
[z0, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
LastLocation(location{1}, location{2}, z0); % Record current location
tic;
zTime = 0;

for i = 1:N_REPS
    countsBright = zeros(size(tauVec));
    countsT1 = zeros(size(tauVec));
    for it = 1:length(tauVec)
        tau = tauVec(it); 
        sData = struct();
        sData.RepNum = i;
        sData.tauVec = tau;


        [status, task] = SetPulseWidthMeas(N_SAMPLES);

        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500); % Give DAQ some time
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 20);
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); % laser init
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME);
        
        PBInst(0, 'ON', 'CONTINUE', 0, tau + DELAY);
   

        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); % Readout with green
        PBInst(2^5 + 2^15 + 2^7 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % turn off briefly
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); % readout bright state ref
        PBInst(2^5 + 2^15 + 2^7 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        % keep pulse trains same length with this last instruction
        endTime = TAU_MAX - tau + 100;
        PBInst(0, 'ON', 'CONTINUE', 0, endTime);
  
        PBInst(0, 'ON', 'END_LOOP', loop, 20);
        cnt = PBInst(0, 'ON', 'CONTINUE', 0, 500);
        PBInst(0, 'ON', 'BRANCH', cnt, 100);

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
        
        countsT1(it) = countsT1(it) + sum(readArray(1:2:end));
        countsBright(it) = countsBright(it) + sum(readArray(2:2:end));
        
        DAQmxStopTask(task);
        DAQmxClearTask(task);

        sData.data = readArray;

        elapsedTime = toc
        zTime = zTime + elapsedTime;
        tictocvec(it, i) = elapsedTime;
        if elapsedTime > 30
            [location, trackHandle] = ReTrack('turnongreen', true, 'location', location, 'fig', trackHandle, 'show', true);
      
            if zTime > 180
                [z0, trackHandle] = ZTrack('turnongreen', true, 'figurehandle', trackHandle);
                LastLocation(location{1}, location{2}, z0);
                zTime = 0;
               
            else
                z0 = location{3};
            end
            LastLocation(location{1}, location{2}, z0);
            tic;
        end
        
        save([saveStr, '_Rep', num2str(i), '_tau', num2str(tau)], 'sData', '-v7.3');
        allfilenamessofar{it, i} = [saveStr, date, '\', fileBase, '_Rep', num2str(i)];
    end
    sigVec = sigVec + countsT1;
    refVec = refVec + countsBright;
    
 
end

countsVec = (sigVec - refVec)./(refVec);



fig1 = figure();
plot(tauVec, countsVec);
xlabel('Free precession time (ns)')
ylabel('Normalized counts')
title('T_1')



fig2 = figure();
k = plot(tauVec, sigVec,'Color', 'r');
hold on
plot(tauVec, refVec,'Color', 'b');
xlabel('Free precession time (ns)');
ylabel('Counts (kCounts/sec)');
title('reference and signal');
legend('T_1 signal', 'Bright State')


save([saveStr, '_ALL_VARS'],'-v7.3')
PowerStripCotrol('ALL', 'OFF');
