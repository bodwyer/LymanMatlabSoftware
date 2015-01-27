FREQ = 2.8376e6; % kHz
N_EXPERIMENTS = 5000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 50; % Number of times to repeat whole process (all Tau)
TAU_MIN = 50; % ns
TAU_MAX = 0.7e6; % ns
N_POINTS = 50;
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 20; % ns
PI_TIME = 40; % ns
POWER = 8.4; % dBm
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

saveStr = GenerateSaveFolders(handles.saveStr, 'T1');

initTime = 4e3 + 800;
readoutTime = 1200;
referenceTime = 5.9e3;


for i = 1:N_REPS
    sigRun = nan(size(tauVec));
    brightRun = nan(size(tauVec));
    darkRun = nan(size(tauVec));



    for it = 1:length(tauVec)

        timePerExp = (20 + IQ_WIDTH + PI_TIME + WAIT_TIME + 2*DELAY + 2*initTime + 2*readoutTime + referenceTime)*1e-9;
        timeNotTau = (N_REPS - i + 1)*N_EXPERIMENTS*(timePerExp)*length(tauVec);
        tauTime = 1e-9*N_EXPERIMENTS*((N_REPS - i)*sum((tauVec)) + sum(tauVec(it:end)));

        timeRemainSec = timeNotTau + tauTime + (N_REPS - i)*length(tauVec)*2.2;
        [days, hours, minutes, seconds] = TimeDivide(timeRemainSec);

        disp(['Tau/2 = ', num2str(tauVec(it))]);
        disp(['Repetition = ', num2str(i)]);
        disp(['Time remaining is ', num2str(days), ' days, ', num2str(hours), ' hours, ', num2str(minutes), ' minutes']);
    
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
        
        PBInst(0, 'ON', 'CONTINUE', 0, tau);

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
        signal = sum(readArray(1:3:end));
        refBright = sum(readArray(3:3:end));
        refDark = sum(readArray(2:3:end));

        sigVec(it) = sigVec(it) + signal;
        refVecDark(it) = refVecDark(it) + refDark;
        refVec(it) = refVec(it) + refBright;

        sigRun(it) = signal;
        brighRun(it) = refBright;
        darkRun(it) = refDark;

        set(h1, 'YData', sigVec);
        set(h2, 'YData', refVec);
        set(h3, 'YData', refVecDark);
        drawnow;

    end
    runData = struct();
    runData.runNum = i;
    runData.bright = brightRun;
    runData.dark = darkRun;
    runData.signal = sigRun;

    save([saveStr, '_Rep', num2str(i)], 'runData', '-v7.3');

end

AgilentSGControl(':RFOUTPUT:STATE OFF');

countsNorm = (sigVec - refVecDark)./(refVec - refVecDark);



saveFig = figure();
subplot(1, 2, 1)
plot(tauVec, countsNorm, 'r');
xlabel('t (ns)');
ylabel('P(|0>)');
xlabel('Free precession time (ns)')
ylabel('Contrast')
title(saveStr);

subplot(1, 2, 2);
sigVec2 = sigVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVec2 = refVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVecDark2 = refVecDark/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
plot(tauVec, sigVec2, 'r', tauVec, refVec2, 'g', tauVec, refVecDark2, 'k');
xlabel('t (ns)')
title('T1');

savefig(saveFig, [saveStr, '_Figs']);
saveData = {tauVec, sigVec, refVec, refVecDark, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');

TurnOffGreen;

