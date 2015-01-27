N_FREQ = 60;
F_MIN = 2.80e6;
F_MAX = 2.875e6;
N_EXPERIMENTS = 500000; % Number of repetitions of experiment
SAMPS_PER_EXPERIMENT = 2; % number of times gate is on for each experiment
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS; % Total number of samples to take (length vector)
N_REPS = 4; % Number of times to repeat whole process (all Tau)
LASER_INIT_TIME = 2E3; % nano seconds (2us)
READOUT_PULSE = 300; % ns (gate ON)
RISE_TIME = 50; % ns (for AOM)
DELAY = 800 + RISE_TIME; %ns (delay for laser to turn on)
WAIT_TIME = 2e3; % ns (pause before reading out to let metastable state decay)
PI_TIME = 855; % ns
POWER = 7.2; % dBm
WAIT_TIME = 2e3; % ns
IQ_WIDTH = 30;
PI_TIME = 40;
timeout = 120;


LoadNVParams;

% Vector of free precession times
freqVec = linspace(F_MIN, F_MAX, N_FREQ);

saveStr = GenerateSaveFolders(handles.saveStr, 'Pulsed_ESR');


countsVec = nan(size(freqVec)); % Spin echo signal vector
countsVecRef = nan(size(freqVec)); % Bright state reference

axes(expAxes);
hold on
h1 = plot(freqVec, countsVec, '-r');
h2 = plot(freqVec, countsVecRef, '-g');
legend('Signal', 'Reference');
xlabel('Frequency (kHz)'); ylabel('Counts'); title('Pulsed ESR');


% Turn on RF
N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, ':RFOUTPUT:STATE ON');


for i = 1:N_REPS
    for it = 1:length(freqVec)

        freq = freqVec(it);
        
        disp(['Frequency = ', num2str(freq), '. Rep # ', num2str(i)]);
        
        fprintf(N9310A, [':FREQUENCY:CW ', num2str(freq), ' kHz']);
      
        DynamicReTrack(hObject, handles);
        handles = guidata(hObject);

        [status, task] = SetPulseWidthMeas(N_SAMPLES);

        PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 

        PBInst(0, 'ON', 'CONTINUE', 0, 0.2e9);
        
        loop = PBesrInstruction(0, 'ON', 'LOOP', N_EXPERIMENTS, 40);
        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        ReadOut;

        % Init;
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        % PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        % PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        % PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        % ReadOut;

        Reference;
        PBInst(0, 'ON', 'CONTINUE', 0, 800);
        PBInst(0, 'ON', 'END_LOOP', loop, 400);
       

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
        
        if isnan(countsVec(it))
            countsVec(it) = sum(readArray(1:2:end));
            countsVecRef(it) = sum(readArray(2:2:end));
        else
            countsVec(it) = countsVec(it) + sum(readArray(1:2:end));
            countsVecRef(it) = countsVecRef(it) + sum(readArray(2:2:end));
        end

        
        DAQmxStopTask(task);
        DAQmxClearTask(task);

        set(h1, 'YData', countsVec);
        set(h2, 'YData', countsVecRef);

        drawnow;

        newHandles = guidata(hObject);
      
    end

    
 
end

fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);

TurnOffGreen;

countsNorm = (countsVec - countsVecRef)./countsVecRef;

[gauss, params, exitflag] = BF_Gaussian_1D_Inverted(countsNorm, freqVec);
%if exitflag > 0
 %   handles.NVParams.ESR = params(1);
%end

saveFig = figure();
plot(freqVec, countsNorm, '-b.', 'MarkerSize', 5);
hold on
plot(freqVec, gauss, 'r');
text(params(1), params(4), ['f = ', num2str(params(1)*1e-6), ' GHz']);
legend('Data', 'Fit');
title(saveStr);

saveData = {freqVec, countsNorm, params, gauss};
savefig(saveFig, [saveStr, '_Figs']);
save([saveStr, '_DATA'], 'saveData');