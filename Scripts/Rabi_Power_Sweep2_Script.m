FREQ = 2.4652e6; % kHz
N_EXPERIMENTS = 500000;
N_REPS = 10;
SAMPS_PER_EXPERIMENT = 2;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
POWER_MIN = 3.0; % dBm
POWER_MAX = 3.01; % dBm
N_STEPS = 20;
LASER_INIT_TIME = 2E3; % nano seconds (1us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
LASER_INIT_REPS = LASER_INIT_TIME/LONG_DELAY_TIME; % for long delay command
RISE_TIME = 50; % ns
DELAY = 800; %ns
DELAY_REPS = DELAY/LONG_DELAY_TIME; % for the long delay command
WAIT_TIME = 2e3; % ns
WAIT_REPS = WAIT_TIME/LONG_DELAY_TIME;
IQ_WIDTH = 20;
PI_TIME = 40;
PI_TIME_TWO_MIN = 18;
PI_TIME_TWO_MAX = 24;
POWER = 2.8;
N_PTS = 4;

LoadNVParams;

timeout = 120;

piOverTwoTimeVec = PI_TIME_TWO_MIN:2.5:PI_TIME_TWO_MAX;
% MWTimeVec_Random = MWTimeVec(randperm(length(MWTimeVec)));

MWCountsVecPi = nan(size(piOverTwoTimeVec));
MWCountsVecPiTwo = nan(size(piOverTwoTimeVec));
refCountsVec = nan(size(piOverTwoTimeVec));

axes(expAxes)
h1 = plot(piOverTwoTimeVec, MWCountsVecPi, 'k');
hold on;
h2 = plot(piOverTwoTimeVec, refCountsVec, 'g');
h3 = plot(piOverTwoTimeVec, MWCountsVecPiTwo, 'r');
xlabel('Power (dBm)');
ylabel('Counts');
title('Rabi Power Sweep')
legend('Signal', 'Reference', '1/2 signal');
drawnow;


N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, ':IQ:STATE ON');
fprintf(N9310A, ':MOD:STATE ON');


saveStr = GenerateSaveFolders(handles.saveStr,'Power_Sweep');

fprintf(N9310A, ':RFOUTPUT:STATE ON');

for it = 1:length(piOverTwoTimeVec)
    DynamicReTrack(hObject, handles);
    handles= guidata(hObject);
    countsArray = zeros(size(piOverTwoTimeVec));
    PI_TIME_TWO = piOverTwoTimeVec(it);
    disp(['Experiment ', num2str(it), ' of ' , num2str(length(MWPowVec))]);
    
    for i = 1:N_REPS
        newHandles = guidata(hObject);
        if ~newHandles.ScriptRunning
            CleanUp;
            return;
        end


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

        Init;
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^12, 'ON', 'CONTINUE', 0, PI_TIME_TWO);
        PBInst(2^12, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(0, 'ON', 'CONTINUE', 0, WAIT_TIME);
        ReadOut;

        Reference;
        PBInst(0, 'ON', 'CONTINUE', 0, 800);
        PBInst(0, 'ON', 'END_LOOP', loop, 400);
        PBesrStopProgramming();
        
        
        PBesrStart();
        DAQmxStartTask(task);
        
        [status, readArray] = ReadCounter(task, N_SAMPLES, timeout);
        countsArray = countsArray + readArray;
        PBesrStop();
        PBesrClose();

        DAQmxStopTask(task);
        DAQmxClearTask(task);


        
    end
    
    MWCountsPi = mean(countsArray(1:3:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
    MWCountsPiTwo = mean(countsArray(2:3:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
    refCounts = mean(countsArray(3:3:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
    MWCountsVecPi(it) = MWCountsPi;
    MWCountsVecPiTwo(it) = MWCountsPiTwo;
    refCountsVec(it) = refCounts;
    
    set(h1, 'YData', MWCountsVecPi);
    set(h2, 'YData', refCountsVec);
    set(h3, 'YData', MWCountsVecPiTwo);
    drawnow;

    
    
 
end


fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);

countsNorm = (refCountsVec - MWCountsVecPiTwo)./(refCountsVec - MWCountsVecPi);


saveFig = figure();
plot(piOverTwoTimeVec, countsNorm, 'r');
xlabel('N');
ylabel('Contrast');
title('\pi \pi/2 Pulse Contrast');

% savefig(saveFig, [saveStr, '_Figs']);
% saveData = {MWPowVec, MWCountsVecPi, refCountsVec, countsNorm};
% save([saveStr, '_DATA'], 'saveData');
% save([saveStr, '_ALL_VARS'], '-v7.3');




