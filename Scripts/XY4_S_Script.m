FREQ = 2.4651e6; % kHz
N_EXPERIMENTS = 333333; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 1; % Number of times to repeat whole process (all Tau)
TAU_MIN = 50; % ns
TAU_MAX = 200; % ns
TAU_STEP = 10; % ns. Steps really need to be 5 ns or more (e.g. no 2.5 ns, which will screw up pulse times)
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 20; % ns
PI_TIME = 40; % ns
POWER = 2.0; % dBm
timeout = 300;
IQ_WIDTH = 20;
N_XY = 1;

LoadNVParams;


% Create vector of free precession times and vectors to hold data
tauVec = TAU_MIN:TAU_STEP:TAU_MAX;
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

saveStr = GenerateSaveFolders(handles.saveStr, 'XY4');

DynamicReTrack(hObject, handles);

for i = 1:N_REPS
	for it = 1:length(tauVec)
    
		tau = tauVec(it) - PI_TIME_TWO;
        disp(['Tau/2 = ', num2str(tau)]);
		DynamicReTrack(hObject, handles);
        handles = guidata(hObject);

		[status, task] = SetPulseWidthMeas(N_SAMPLES); % Set up DAQ

		PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 0.2e9); % Wait for DAQ to start up (200 ms)
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 20);
        Init;
        % Pi/2 (x)
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);

            xyLoop = PBInst(2^12, 'ON', 'LOOP', N_XY, tau);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^12, 'ON', 'CONTINUE', 0, tau);
            PBInst(2^13, 'ON', 'CONTINUE', 0, tau);
            % Pi_y
            PBInst(2^3 + 2^13 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, tau);
            PBInst(2^12, 'ON', 'CONTINUE', 0, tau);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^12, 'ON', 'CONTINUE', 0, tau);
            PBInst(2^13, 'ON', 'CONTINUE', 0, tau);
            % Pi_y
            PBInst(2^3 + 2^13 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            PBInst(2^13, 'ON', 'CONTINUE', 0, tau/2)
            PBInst(2^12, 'ON', 'END_LOOP', xyLoop, tau/2);
        % Pi/2 and read out
        PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        % PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

        ReadOut;

        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

        ReadOut; % Dark state

        Reference; % Reference

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


saveFig = figure();
plot(tauVec, countsNorm, 'r');
xlabel('\tau (ns)');
ylabel('P(|0>)');
title(['XY4 (S) With N = ', num2str(N_XY)]);

figure()
sigVec2 = sigVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVec2 = refVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVecDark2 = refVecDark/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
plot(tauVec, sigVec2, 'r', tauVec, refVec2, 'g', tauVec, refVecDark2, 'k');


savefig(saveFig, [saveStr, '_Figs']);
saveData = {tauVec, sigVec, refVec, refVecDark, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');
