FREQ = 2.1257e6; % kHz
N_EXPERIMENTS = 500000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 3; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 4; % Number of times to repeat whole process (all Tau)
POWER_MIN = 6.5; % dBm
POWER_MAX = 7.5; % dBm
POWER_STEP = 0.1;
TAU = 55;
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 20; % ns
PI_TIME = 40; % ns
POWER = 9.6; % dBm
timeout = 300;
IQ_WIDTH = 30;
N_XY = 8;

LoadNVParams;


powVec = POWER_MIN:POWER_STEP:POWER_MAX;

%powVec = TAU_MIN:5:TAU_MAX;
sigVec = nan(size(powVec)); % Signal
refVec = nan(size(powVec)); % Reference (bright)
refVecDark = nan(size(powVec)); % Reference (dark)

% Set up data plot in GUI
axes(expAxes);
hold on;
h1 = plot(powVec, sigVec, 'r');
h2 = plot(powVec, refVec, 'g');
h3 = plot(powVec, refVecDark, 'k');
xlabel('Total precession time'); ylabel('Counts');
legend('Signal', 'Reference (Bright)', 'Reference (Dark)');


% Set up and turn on signal generator (MW)
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':MOD:STATE ON');
AgilentSGControl(':IQ:State ON');
AgilentSGControl(':RFOUTPUT:STATE ON');

saveStr = GenerateSaveFolders(handles.saveStr, 'XY8_Power_Sweep');

DynamicReTrack(hObject, handles);

initTime = 4e3 + 800;
readoutTime = 1200;
referenceTime = 5.9e3;



for i = 1:N_REPS
	for it = 1:length(powVec)
        power = powVec(it);
        AgilentSGControl([':AMPLITUDE:CW ', num2str(power), ' dBm']);

        timePerExp = (20 + 4*IQ_WIDTH + N_XY*8*PI_TIME + 2*PI_TIME + WAIT_TIME + 2*DELAY + 3*initTime + 2*readoutTime + referenceTime)*1e-9;
        timeNotTau = (N_REPS - i + 1)*N_EXPERIMENTS*(timePerExp)*length(powVec);
        tauTime = 16*N_XY*1e-9*N_EXPERIMENTS*(N_REPS - i)*(TAU);

        timeRemainSec = timeNotTau + tauTime + (N_REPS - i)*length(powVec)*2.2;
        [days, hours, minutes, seconds] = TimeDivide(timeRemainSec);
    
        disp(['Repetition = ', num2str(i)]);
        disp(['Time remaining is ', num2str(days), ' days, ', num2str(hours), ' hours, ', num2str(minutes), ' minutes']);
		DynamicReTrack(hObject, handles);
        handles = guidata(hObject);
        tic;

		[status, task] = SetPulseWidthMeas(N_SAMPLES); % Set up DAQ

		PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 0.2e9); % Wait for DAQ to start up (200 ms)
        loop = PBInst(0, 'ON', 'LOOP', N_EXPERIMENTS, 20);
        Init;
        % Pi/2 (x)
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
      %  PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);

            xyLoop = PBInst(2^12, 'ON', 'LOOP', N_XY, TAU);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^12, 'ON', 'CONTINUE', 0, TAU);
            PBInst(2^13, 'ON', 'CONTINUE', 0, TAU);
            % Pi_y
            PBInst(2^3 + 2^13 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, TAU);
            PBInst(2^12, 'ON', 'CONTINUE', 0, TAU);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^12, 'ON', 'CONTINUE', 0, TAU);
            PBInst(2^13, 'ON', 'CONTINUE', 0, TAU);
            % Pi_y
            PBInst(2^3 + 2^13 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, 2*TAU);
            % Pi_y
            PBInst(2^3 + 2^13 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
            % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, TAU);
            PBInst(2^12, 'ON', 'CONTINUE', 0, TAU);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
             % Tau
            PBInst(2^12, 'ON', 'CONTINUE', 0, TAU);
            PBInst(2^13, 'ON', 'CONTINUE', 0, TAU);
            % Pi_y
            PBInst(2^3 + 2^13 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);
             % Tau
            PBInst(2^13, 'ON', 'CONTINUE', 0, TAU);
            PBInst(2^12, 'ON', 'CONTINUE', 0, TAU);
            % Pi_x
            PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME);

            PBInst(2^12, 'ON', 'END_LOOP', xyLoop, TAU);
        % Pi/2 and read out
  %      PBInst(2^3 + 2^12 + 2^0, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
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
        toc
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

[bestFitParams, fit, exitflag] = FitLogSineWave(powVec, countsNorm);

saveFig = figure();
plot(powVec, countsNorm, 'ro', powVec, fit, 'b');
legend('Data', 'Fit');
xlabel('Power (dBm)');
ylabel('P(|0>)');
title(['XY8 With N = ', num2str(N_XY)]);


figure()
sigVec2 = sigVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVec2 = refVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVecDark2 = refVecDark/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
plot(powVec, sigVec2, 'r', powVec, refVec2, 'g', powVec, refVecDark2, 'k');
title(saveStr);


savefig(saveFig, [saveStr, '_Figs']);
saveData = {powVec, sigVec, refVec, refVecDark, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');
