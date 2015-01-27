FREQ =2.8135e6; % kHz, detuned by 4 mHz from resonance
N_EXPERIMENTS = 333333; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 3; % Number of times to repeat whole process (all Tau)
TAU_MIN = 50; % ns
TAU_MAX = 10e3; % ns
TAU_STEP = 50; % ns
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800 + RISE_TIME; %ns (delay for laser to turn on)
WAIT_TIME = 2e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 23.5; % ns
PI_TIME = 47; % ns
POWER = 0; % dBm


PowerStripControl('ALL', 'ON');
% LastLocation();
pause(.2)

% Vector of free precession times
tauVec = TAU_MIN:TAU_STEP:TAU_MAX;



allfilenamessofar = cell(length(tauVec), N_REPS); %list of all file names
tictocvec = zeros(length(tauVec), N_REPS); % list of all times betweeen retracks

sigVec = zeros(size(tauVec)); % Spin echo signal vector
refVec = zeros(size(tauVec)); % Bright state reference
refVecDark = zeros(size(tauVec)); % Dark state reference


% Set up RF generator
RF_FREQ = 5.05e6; % 5.05 MHz
RF_AMPL = .050; % 100mV VPP
state = RigolControl(':OUTPUT1:STATE?');
RigolControl([':SOURCE1:APPLY:SINUSOID ', num2str(RF_FREQ), ',', num2str(RF_AMPL), ',0,0']);
if strcmp(state, 'OFF')
    RigolControl(':OUTPUT1:STATE ON');
end


% Start up signal generator
N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);

timeout = 120; % for DAQ readcounter

% Set up directory and filenames for saving all data.
% If folder exists with same name, create new folder with num + 1
% at the end
saveStr = GenerateSaveFolders('AC_MAG');
% Turn on RF
fprintf(N9310A, ':RFOUTPUT:STATE ON');
% Retrack
[location, trackHandle] = StoreNVLocation('initial', saveStr);
LastLocation(location{1}, location{2}, location{3});
tic;
zTime = 0;

for i = 1:N_REPS
    countsBright = zeros(size(tauVec));
    countsDark = zeros(size(tauVec));
    countsRamsey = zeros(size(tauVec));
    
    tauVecRandom = tauVec(randperm(length(tauVec)));
    
    for it = 1:length(tauVec)
        tau = tauVecRandom(it)/2; 
        sData = struct();
        sData.RepNum = i;
        sData.tauVec = tau*2;
        disp(['tau/2 = ', num2str(tau)]);
        disp(['Rep # = ', num2str(i)]);

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
     
        if tau >= 12.5
            PBInst(0, 'ON', 'CONTINUE', 0, tau);
            PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, PI_TIME);
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
%         allfilenamessofar{it, i} = [saveStr, date, '\', fileBase, '_Rep', num2str(i)];
    end
    
    dataMat = [tauVecRandom; countsRamsey; countsBright; countsDark];
    out = sortrows(dataMat', 1)';
    sigVec = sigVec + out(2, :);
    refVec = refVec + out(3, :);
    refVecDark = refVecDark + out(4, :);
    
%     sigVec = sigVec + countsRamsey;
%     refVec = refVec + countsBright;
%     refVecDark = refVecDark + countsDark;
    
 
end


countsVec = (sigVec - refVecDark)./(refVec - refVecDark);

fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
RigolControl(':OUTPUT1:STATE OFF');
delete(instrfind);

countsMean = countsVec - mean(countsVec);
NFFT = 2^nextpow2(length(tauVec));
countsVec_FFT = fft(countsMean, NFFT);
freq = 1/(TAU_STEP*1e-9)*linspace(0, 1, NFFT/2 + 1);

fig1 = figure();
subplot(1, 2, 1)
plot(tauVec, countsVec);
xlabel('Free precession time (ns)')
ylabel('Normalized counts')
title('Spin Echo')


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
xlabel('Free precession time (ns)');
ylabel('Counts (kCounts/sec)');
title('reference and signal');
legend('Spin echo Signal', 'Bright State', 'Dark State')

% PowerStripControl('ALL', 'OFF');
