FREQ = 2.0866e6; % kHz
N_EXPERIMENTS = 100000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 4; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 10; % Number of times to repeat whole process (all Tau)
TAU_MIN = 300; % ns
TAU_MAX =  330; % ns
N_POINTS = 20;
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800; %ns (delay for laser to turn on)
WAIT_TIME = 1e3; % ns (pause before reading out to let metastable state decay)
PI_TIME_TWO = 20; % ns
PI_TIME = 40; % ns
POWER = 5.8; % dBm
timeout = 300;
IQ_WIDTH = 30;
N_XY = 4;
initTime = 4e3 + 800;
readoutTime = 1200;
referenceTime = 5.9e3;

LoadNVParams;


% Create vector of free precession times and vectors to hold data
%tauStepEx = round((TAU_MAX - TAU_MIN)/N_POINTS);
tauStep = 2.5;
tauVec = TAU_MIN:tauStep:TAU_MAX;
sigVec = nan(size(tauVec)); % Signal
sigVecOne = nan(size(tauVec)); % |1> projection
refVec = nan(size(tauVec)); % Reference (bright)
refVecDark = nan(size(tauVec)); % Reference (dark)

% Set up data plot in GUI
axes(expAxes);
hold on;
h1 = plot(N_XY*16*tauVec, sigVec, 'r');
h2 = plot(N_XY*16*tauVec, sigVecOne, 'b');
h3 = plot(N_XY*16*tauVec, refVec, 'g');
h4 = plot(N_XY*16*tauVec, refVecDark, 'k');

xlabel('Total precession time'); ylabel('Counts');
legend('|0>', '|1>', 'Reference (Bright)', 'Reference (Dark)');


% Set up and turn on signal generator (MW)
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl([':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
AgilentSGControl(':MOD:STATE ON');
AgilentSGControl(':IQ:State ON');
AgilentSGControl(':RFOUTPUT:STATE ON');

saveStr = GenerateSaveFolders(handles.saveStr, 'Align_XY8');

DynamicReTrack(hObject, handles);

for i = 1:N_REPS
	for it = 1:length(tauVec)

        timePerExp = (20 + 6*IQ_WIDTH + N_XY*16*PI_TIME + 3*PI_TIME + PI_TIME_TWO +  WAIT_TIME + 2*DELAY + 4*initTime + 3*readoutTime + referenceTime)*1e-9;
        timeNotTau = (N_REPS - i + 1)*N_EXPERIMENTS*(timePerExp)*length(tauVec);
        tauTime = 2*16*N_XY*1e-9*N_EXPERIMENTS*((N_REPS - i)*sum((tauVec - PI_TIME_TWO)) + sum(tauVec(it:end) - PI_TIME_TWO));

        timeRemainSec = timeNotTau + tauTime + (N_REPS - i)*length(tauVec)*2.2;
        [days, hours, minutes, seconds] = TimeDivide(timeRemainSec);
    
		tau = tauVec(it) - PI_TIME_TWO;

        disp(['Tau/2 = ', num2str(tauVec(it))]);
        disp(['Repetition = ', num2str(i)]);
        disp(['Time remaining is ', num2str(days), ' days, ', num2str(hours), ' hours, ', num2str(minutes), ' minutes']);
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

        % PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME + DELAY);

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
            sigVecOne(it) = 0;
        end
        sigVec(it) = sigVec(it) + sum(readArray(1:4:end));
        sigVecOne(it) = sigVecOne(it) + sum(readArray(2:4:end));
        refVecDark(it) = refVecDark(it) + sum(readArray(3:4:end));
        refVec(it) = refVec(it) + sum(readArray(4:4:end));

        sData = struct();
        sData.data = readArray;
        sData.rep = i;
        sData.tau = 2*tau;

        save([saveStr, '_Rep', num2str(i), '_tau', num2str(tau*2)], 'sData', '-v7.3');


        set(h1, 'YData', sigVec);
        set(h2, 'YData', sigVecOne)
        set(h3, 'YData', refVec);
        set(h4, 'YData', refVecDark);
        drawnow;

    end
end

AgilentSGControl(':RFOUTPUT:STATE OFF');

countsNorm = (sigVec - refVecDark)./(refVec - refVecDark);


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
sigVec1 = sigVecOne/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
sigVec2 = sigVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVec2 = refVec/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
refVecDark2 = refVecDark/(READOUT_PULSE*1e-9*N_EXPERIMENTS*N_REPS*1000);
plot(tauVec, sigVec1, 'b', tauVec, sigVec2, 'r', tauVec, refVec2, 'g', tauVec, refVecDark2, 'k');
title(saveStr);


savefig(saveFig, [saveStr, '_Figs']);
saveData = {tauVec, sigVec, sigVecOne, refVec, refVecDark, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');