FREQ = 1.8404e6; % kHz
N_EXPERIMENTS = 100000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 40; % Number of times to repeat whole process (all Tau)
TAU_MIN = 50; % ns
TAU_MAX = 20e3; % ns
N_POINTS = 51;
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 20; % ns
PI_TIME = 40; % ns
POWER = 6.8; % dBm
timeout = 300;
IQ_WIDTH = 30;

LoadNVParams;


% Create vector of free precession times and vectors to hold data
tauStepEx = round((TAU_MAX - TAU_MIN)/N_POINTS);
tauStep = 5*(idivide(tauStepEx*10, int32(50)));
tauVec = TAU_MIN:tauStep:TAU_MAX;
sigVec = nan(size(tauVec)); % Signal
refVec = nan(size(tauVec)); % Reference (bright)
refVecDark = nan(size(tauVec)); % Reference (dark)

% Set up data plot in GUI
axes(expAxes);
hold on;
h1 = plot(tauVec, sigVec, 'r');
h2 = plot(tauVec, refVec, 'g');
h3 = plot(tauVec, refVecDark, 'k');
legend('Signal', 'Reference (Bright)', 'Reference (Dark)');


% Set up and turn on signal generator (MW)
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':MOD:STATE ON');
AgilentSGControl(':IQ:State ON');
AgilentSGControl(':RFOUTPUT:STATE ON');

saveStr = GenerateSaveFolders(handles.saveStr, 'Hahn_Echo');


for i = 1:N_REPS
    for it = 1:length(tauVec)
    
        tau = tauVec(it);
        DynamicReTrack(hObject, handles);
        handles= guidata(hObject);

        [status, task] = SetPulseWidthMeas(N_SAMPLES); % Set up DAQ

        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 0.2e9); % Wait for DAQ to start up (200 ms)
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 20);
        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        PBInst(2^12, 'ON', 'CONTINUE', 0, tau - PI_TIME_TWO);
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME);
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^12, 'ON', 'CONTINUE', 0, tau - PI_TIME_TWO);

        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        ReadOut;

        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME);
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^12, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

        ReadOut;

        Reference;

        PBInst(0, 'ON', 'END_LOOP', loop, DELAY);
        PBesrStopProgramming();

        PBesrStart();
        DAQmxStartTask(task);

        [status, readArray] = ReadCounter(task, N_SAMPLES, timeout);
  
        PBesrStop();
        PBesrClose();
        DAQmxStopTask(task);
        DAQmxClearTask(task);


        
        if status ~= 0
            CleanUp;
            error('Could not read array. Terminating run.');
        end

        if isnan(sigVec(it))
            sigVec(it) = 0;
            refVec(it) = 0;
            refVecDark(it) = 0;
        end
        sigVec(it) = sigVec(it) + sum(readArray(1:3:end));
        refVecDark(it) = refVecDark(it) + sum(readArray(2:3:end));
        refVec(it) = refVec(it) + sum(readArray(3:3:end));

        sData = struct();
        sData.data = readArray;
        sData.rep = i;
        sData.tau = 2*tau;

        save([saveStr, '_Rep', num2str(i), '_tau', num2str(tau*2)], 'sData', '-v7.3');

        set(h1, 'YData', sigVec);
        set(h2, 'YData', refVec);
        set(h3, 'YData', refVecDark);
        drawnow;

    end
end

AgilentSGControl(':RFOUTPUT:STATE OFF');

countsNorm = (sigVec - refVecDark)./(refVec - refVecDark);
tauVec = tauVec + PI_TIME_TWO/2 + PI_TIME_TWO + IQ_WIDTH*2;


saveFig = figure();
plot(tauVec, countsNorm, 'r');
xlabel('\Tau (ns)');
ylabel('P(|0>)');
title(saveStr);

figure()
subplot(1, 2, 1);
sigVec2 = sigVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVec2 = refVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVecDark2 = refVecDark/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
plot(tauVec, sigVec2, 'r', tauVec, refVec2, 'g', tauVec, refVecDark2, 'k');
title('Hahn Echo');

Fs = 1/TAU_STEP;
NFFT = 2^(nextpow2(length(tauVec)));
transform = fft(countsNorm, NFFT)/length(tauVec);
fDomain = Fs/2*linspace(0, 1, NFFT/2 + 1);

freqPlot = 2*abs(transform(1:NFFT/2 + 1));

subplot(1, 2, 2);
plot(fDomain, freqPlot);
xlabel('Frequency')
ylabel('Signal');
title('FFT(Echo)')


savefig(saveFig, [saveStr, '_Figs']);
saveData = {tauVec, sigVec, refVec, refVecDark, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');

TurnOffGreen;

