FREQ = 2.8304e6 - 4e3; % kHz % kHz, detuned by 4 mHz from resonance
N_EXPERIMENTS = 99999;
SAMPS_PER_EXPERIMENT = 3;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
N_REPS = 8;
TAU_MIN = 12.5; % ns
TAU_MAX = 10e3; % ns
TAU_STEP = 20;
LASER_INIT_TIME = 2E3; % nano seconds (2us)
LASER_INIT_REPS = LASER_INIT_TIME/LONG_DELAY_TIME;
READOUT_PULSE = 300; % ns
RISE_TIME = 50; % ns
DELAY = 800 + RISE_TIME; %ns
WAIT_TIME = 2e3; % ns
PI_TIME_TWO = 17; % ns
PI_TIME = 34;
POWER = -4; % dBm

% LastLocation();
pause(.2)


tauVec = TAU_MIN:TAU_STEP:TAU_MAX;
tauVecRandom = tauVec(randperm(length(tauVec)));

allfilenamessofar = cell(length(tauVec), N_REPS);
tictocvec = zeros(length(tauVec), N_REPS);
countsVec = nan(size(tauVec));
sigVec = zeros(size(tauVec));
refVec = zeros(size(tauVec));
refVecDark = zeros(size(tauVec));





% sData = cell(size(tauVec));

N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);

timeout = 600;
fileBase = [date, '_Ramsey_Corr'];
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

fprintf(N9310A, ':RFOUTPUT:STATE ON');
[location, trackHandle] = ReTrack('turnongreen', true);
LastLocation(location{1}, location{2}, location{3});
tic;

zTime = 0;
for i = 1:N_REPS
    countsBright = zeros(size(tauVec));
    countsDark = zeros(size(tauVec));
    countsRamsey = zeros(size(tauVec));
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
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % turn off and wait
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME_TWO); % pi/2 pulse
        % wait for free precession time tau. If tau = 0, skip. If tau >
        % 640, we have to do some 'long delay' type pulses, with regular
        % 'continue' pulses for the remainder. This is because the 400MHz
        % pulseblaster uses a separate command for anything longer than
        % 640ns for some reason...
        if tau >= 12.5
            PBInst(0, 'ON', 'CONTINUE', 0, tau);
        end
        
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME_TWO); % pi/2 pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % wait a little while
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); % Readout with green
        PBInst(2^5 + 2^15 + 2^7 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % turn off briefly
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); % readout bright state ref
        PBInst(2^5 + 2^15 + 2^7 + 2^17, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        PBInst(2^5 + 2^15, 'ON', 'CONINUE', 0, LASER_INIT_TIME); % init
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME); % pi pulse
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME); % wait
        PBInst(2^5 + 2^15, 'ON', 'CONTINUE', 0, DELAY); % read out dark
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
        
        countsRamsey(it) = countsRamsey(it) + sum(readArray(1:3:end));
        countsBright(it) = countsBright(it) + sum(readArray(2:3:end));
        countsDark(it) = countsDark(it) + sum(readArray(3:3:end));
        
        DAQmxStopTask(task);
        DAQmxClearTask(task);

        sData.data = readArray;

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
        
        save([saveStr, '_Rep', num2str(i), '_tau', num2str(tau)], 'sData', '-v7.3');
        allfilenamessofar{it, i} = [saveStr, date, '\', fileBase, '_Rep', num2str(i)];
    end
    sigVec = sigVec + countsRamsey;
    refVec = refVec + countsBright;
    refVecDark = refVecDark + countsDark;
    
 
end

countsVec = (sigVec - refVecDark)./(refVec - refVecDark);

fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);

countsMean = countsVec - mean(countsVec);
NFFT = 2^nextpow2(length(tauVec));
countsVec_FFT = fft(countsMean, NFFT);
freq = 1/(2*TAU_STEP*1e-9)*linspace(0, 1, NFFT/2 + 1);

fig1 = figure();
subplot(1, 2, 1)
plot(tauVec, countsVec);
xlabel('Free precession time (ns)')
ylabel('Normalized counts')
title('Ramsey, detuning = 4 MHz')


subplot(1, 2, 2);
plot(freq, 2*abs(countsVec_FFT(1:NFFT/2 + 1)));
xlabel('Frequency (Hz)');
ylabel('|F(counts)|');
title('Ramsey FFT');

save([saveStr, '_ALL_VARS'],'-v7.3')

fig2 = figure();
k = plot(tauVec, sigVec,'Color', 'r');
hold on
plot(tauVec, refVec,'Color', 'b');
plot(tauVec, refVecDark, 'Color', 'g');
% set(bright, 'XDataSource', 'tauVec');set(bright, 'YDataSource', 'refVec');
% set(signal, 'XDataSource', 'tauVec');set(signal, 'YDataSource', 'sigVec');
% set(dark, 'XDataSource', 'tauVec');set(dark, 'YDataSource', 'refVecDark');
xlabel('Free precession time (ns)');
ylabel('Counts (kCounts/sec)');
title('reference and signal');
legend('Ramsey Signal', 'Bright State', 'Dark State')


