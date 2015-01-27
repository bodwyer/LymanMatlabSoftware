FREQ = 2.2429e6 - 4e3; % kHz, detuned by 4 mHz from resonance
N_EXPERIMENTS = 300000;
SAMPS_PER_EXPERIMENT = 3;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
N_REPS = 3;
TAU_MIN = 0; % ns
TAU_MAX = 2e3; % ns
TAU_STEP = 20;
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 350; % ns
DELAY = 800; %ns
PI_TIME_TWO = 60; % ns
PI_TIME = 110;;
POWER = -14; % dBm
RISE_TIME = 50; % ns

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

timeout = 120;
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
[location, trackHandle] = ReTrack(true);
LastLocation(location{1}, location{2}, location{3});
tic;

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
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 0.2e9); % Give DAQ some time
        loop = PBesrInstruction(2^5, 'ON', 'LOOP', N_EXPERIMENTS, DELAY); % laser init
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, LASER_INIT_TIME);
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 2e3); % turn off and wait
        PBesrInstruction(2^3, 'ON', 'CONTINUE', 0, PI_TIME_TWO); % pi/2 pulse
        if tau ~= 0
            PBesrInstruction(0, 'ON', 'CONTINUE', 0, tau); % wait for free precession time tau
        end
        PBesrInstruction(2^3, 'ON', 'CONTINUE', 0, PI_TIME_TWO); % pi/2 pulse
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 2e3); % wait a little while
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, DELAY + RISE_TIME); % Readout with green
        PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % Initialize
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 2e3); % turn off briefly
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, DELAY + RISE_TIME); % readout bright state ref
        PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, READOUT_PULSE*4);
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, LASER_INIT_TIME); % init
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 2e3);
        PBesrInstruction(2^3, 'ON', 'CONTINUE', 0, PI_TIME); % pi pulse
        PBesrInstruction(0, 'ON', 'CONTINUE', 0, 1e3); % wait
        PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, DELAY + RISE_TIME); % read out dark
        PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, READOUT_PULSE);
        PBesrInstruction(0, 'ON', 'END_LOOP', loop, TAU_MAX - tau + 100);
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
        
        countsRamsey(it) = countsRamsey(it) + sum(readArray(1:3:end));
        countsBright(it) = countsBright(it) + sum(readArray(2:3:end));
        countsDark(it) = countsDark(it) + sum(readArray(3:3:end));
        
        DAQmxStopTask(task);
        DAQmxClearTask(task);

        sData.data = readArray;

        elapsedTime = toc
        tictocvec(it, i) = elapsedTime;
        if elapsedTime > 60
            [location, trackHandle] = ReTrack(true, location, trackHandle);
            LastLocation(location{1}, location{2}, location{3});
            tic
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

% saveStr = ['C:\Users\MAXWELL\Documents\MATLAB\NV\Dave\Data\'];
% fileBase = [date, 'Ramsey_Corr_'];
% listDir = what(saveStr);
% 
% 
% matches = regexp(listDir.mat, [fileBase, '[0-9]*'], 'match');
% matchesTrue = ~cellfun(@isempty, matches);
% indMatch = find(matchesTrue, 1, 'last');
% if isempty(indMatch)
%     maxNum = 1;
% else
%     maxStr = matches{indMatch};
%     maxNum = round(str2doubble(maxStr(length(fileBase):end)));
%     maxNum = maxNum + 1;
% end
% 
% 
% save([saveStr, fileBase, num2str(maxNum)], 'sData', '-v7.3');
% countsSort = [tauVecRandom', countsVec'];
% countsSorted = sortrows(countsSort, 1);
% 
% countsVec = countsSorted(:, 2)';

countsMean = countsVec - mean(countsVec);
NFFT = 2^nextpow2(length(tauVec));
countsVec_FFT = fft(countsMean, NFFT);
freq = 1/(TAU_STEP*1e-9)*linspace(0, 1, NFFT/2 + 1);


% fig1 = figure();
% subplot(1, 2, 1);
% h = plot(tauVec, countsVec);
% xlabel('Free precession time (ns)');
% ylabel('Contrast');
% title('Ramsey');

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


