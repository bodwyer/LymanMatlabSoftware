FREQ = 2.4605e6; % kHz
N_EXPERIMENTS = 50000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 30; % Number of times to repeat whole process (all Tau)
TAU_MIN = 290; % ns
TAU_MAX =  430; % ns
TAU_STEP = 5; % ns. Steps really need to be 5 ns or more (e.g. no 2.5 ns, which will screw up pulse times)
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 20; % ns
PI_TIME = 40; % ns
POWER = 11.8; % dBm
timeout = 300;
IQ_WIDTH = 30;
N_XY = 8;

LoadNVParams;


% Create vector of free precession times and vectors to hold data
tauVec = TAU_MIN:TAU_STEP:TAU_MAX;
sigVecZero = nan(size(tauVec)); % Signal
sigVecOne = nan(size(tauVec)); % Reference (bright)


% Set up data plot in GUI
axes(expAxes);
hold on;
h1 = plot(N_XY*16*tauVec, sigVecZero, 'g');
h2 = plot(N_XY*16*tauVec, sigVecOne, 'k');
xlabel('Total precession time'); ylabel('Counts');
legend('|0>', '|1>');


% Set up and turn on signal generator (MW)
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':MOD:STATE ON');
AgilentSGControl(':IQ:State ON');
AgilentSGControl(':RFOUTPUT:STATE ON');

saveStr = GenerateSaveFolders(handles.saveStr, 'XY8');

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
            % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, 2*tau);
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
             % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, tau);
            PBInst(2^12, 'ON', 'CONTINUE', 0, tau);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);

            PBInst(2^12, 'ON', 'END_LOOP', xyLoop, tau);
        % Pi/2 and read out
        PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        ReadOut;


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
            % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, 2*tau);
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
             % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, tau);
            PBInst(2^12, 'ON', 'CONTINUE', 0, tau);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);

            PBInst(2^12, 'ON', 'END_LOOP', xyLoop, tau);
        % Pi/2 and read out
        PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, 3*PI_TIME_TWO);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);

        % PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

        ReadOut;

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

        if isnan(sigVecZero(it))
        	sigVecZero(it) = 0;
        	sigVecOne(it) = 0;
        end
        sigVecZero(it) = sigVecZero(it) + sum(readArray(1:2:end));
        sigVecOne(it) = sigVecOne(it) + sum(readArray(2:2:end));

        set(h1, 'YData', sigVecZero);
        set(h2, 'YData', sigVecOne);
        drawnow;

    end
end

AgilentSGControl(':RFOUTPUT:STATE OFF');

countsNorm = (sigVecZero - sigVecOne)./(sigVecZero + sigVecOne);


saveFig = figure();
subplot(1, 2, 1);
plot(2*tauVec, countsNorm, 'r');
xlabel('\tau (ns)');
ylabel('P(|0>)');
title(['XY8 With N = ', num2str(N_XY)]);
subplot(1, 2, 2)
plot(N_XY*16*tauVec, countsNorm, 'r')
ylabel('P(|0>)');
xlabel('Total evolution time (ns)');
title(['XY8 With N = ', num2str(N_XY)]);

figure()
sigVec2 = sigVecZero/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVec2 = sigVecOne/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
plot(tauVec, sigVec2, 'g', tauVec, refVec2, 'k');
title(saveStr);


savefig(saveFig, [saveStr, '_Figs']);
saveData = {tauVec, sigVecZero, sigVecOne, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');
