FREQ = 2.5485e6; % kHz, detuned by 4 mHz from resonance
N_EXPERIMENTS = 333333; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 10; % Number of times to repeat whole process (all Tau)
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 16; % ns
PI_TIME = 32; % ns
POWER = 3.0; % dBm
timeout = 300;
IQ_WIDTH = 20;
N_PTS = 2;
PiPulseChan = 2^13;  % I or Q
tau = 15; % nanoseconds


sigVec = nan(1, N_PTS); % Signal
refVec = nan(1, N_PTS); % Reference (bright)
refVecDark = nan(1, N_PTS); % Reference (dark)

% Set up data plot in GUI
repsVec = 1:1:N_PTS;
axes(expAxes);
hold on;
h1 = plot(repsVec, sigVec, 'r');
h2 = plot(repsVec, refVec, 'g');
h3 = plot(repsVec, refVecDark, 'k');
legend('Signal', 'Reference (Bright)', 'Reference (Dark)');


% Set up and turn on signal generator (MW)
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':MOD:STATE ON');
AgilentSGControl(':IQ:State ON');
AgilentSGControl(':RFOUTPUT:STATE ON');

saveStr = GenerateSaveFolders(handles.saveStr, 'Field_Alignment');

DynamicReTrack(hObject, handles);
for it = 1:N_PTS
    for in = 1:N_REPS
    	DynamicReTrack(hObject, handles);

    	[status, task] = SetPulseWidthMeas(N_SAMPLES); % Set up DAQ

    	PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 0.2e9); % Wait for DAQ to start up (200 ms)
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 20);
        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        PBInst(0, 'ON', 'CONTINUE', 0, tau);
        PBInst(PiPulseChan, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + PiPulseChan, 'ON', 'CONTINUE', 0, PI_TIME);
        PBInst(PiPulseChan, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(0, 'ON', 'CONTINUE', 0, tau);

        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

        ReadOut;

        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

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

        set(h1, 'YData', sigVec);
        set(h2, 'YData', refVec);
        set(h3, 'YData', refVecDark);
        drawnow;

    end
end

AgilentSGControl(':RFOUTPUT:STATE OFF');

countsNorm = (sigVec - refVecDark)./(refVec - refVecDark);
% tauVec = tauVec + PI_TIME_TWO/2 + PI_TIME_TWO + IQ_WIDTH*2;

saveFig = figure();
plot(repsVec, countsNorm, 'r');
xlabel('N');
ylabel('P(|0>)');
title(['Pi pulse is channel ', num2str(PiPulseChan)]);


savefig(saveFig, [saveStr, '_Figs']);
saveData = {repsVec, sigVec, refVec, refVecDark, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');

