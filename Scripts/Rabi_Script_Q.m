FREQ = 2.4605e6; % kHz
N_EXPERIMENTS = 500000;
N_REPS = 2;
SAMPS_PER_EXPERIMENT = 2;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
T_MIN = 15; % ns
T_MAX = 120; % ns
T_STEP = 2.5;
LASER_INIT_TIME = 2E3; % nano seconds (1us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
LASER_INIT_REPS = LASER_INIT_TIME/LONG_DELAY_TIME; % for long delay command
RISE_TIME = 50; % ns
DELAY = 800; %ns
DELAY_REPS = DELAY/LONG_DELAY_TIME; % for the long delay command
WAIT_TIME = 2e3; % ns
WAIT_REPS = WAIT_TIME/LONG_DELAY_TIME;
IQ_WIDTH = 30;
POWER = 11.9; % dBm
LoadNVParams;

timeout = 120;

MWTimeVec = T_MIN:T_STEP:T_MAX;

% MWTimeVec_Random = MWTimeVec(randperm(length(MWTimeVec)));

MWCountsVec = nan(size(MWTimeVec));
refCountsVec = nan(size(MWTimeVec));

axes(expAxes)
h1 = plot(MWTimeVec, MWCountsVec, 'r');
hold on;
h2 = plot(MWTimeVec, refCountsVec, 'g');
xlabel('t (ns)');
ylabel('Counts');
title('Rabi')
legend('Signal', 'Reference');
drawnow;


N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
fprintf(N9310A, ':IQ:STATE ON');
fprintf(N9310A, ':MOD:STATE ON');


saveStr = GenerateSaveFolders(handles.saveStr,'Rabi');

fprintf(N9310A, ':RFOUTPUT:STATE ON');

for it = 1:length(MWTimeVec)
    DynamicReTrack(hObject, handles);
    handles= guidata(hObject);

    pulseTime = MWTimeVec(it);   
    countsArray = zeros(1, N_SAMPLES);
    disp(['Experiment ', num2str(it), ' of ' , num2str(length(MWTimeVec))]);
    
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
        PBInst(2^13, 'ON', 'CONTINUE', 0, IQ_WIDTH);
        PBInst(2^3 + 2^13, 'ON', 'CONTINUE', 0, pulseTime);
        PBInst(2^13, 'ON', 'CONTINUE', 0, IQ_WIDTH);
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
    
    MWCounts = mean(countsArray(1:2:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
    refCounts = mean(countsArray(2:2:end))/(READOUT_PULSE*1e-9*1000*N_REPS);
    MWCountsVec(it) = MWCounts;
    refCountsVec(it) = refCounts;
    
    set(h1, 'YData', MWCountsVec);
    set(h2, 'YData', refCountsVec);
    drawnow;

    
    
 
end


fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);


fig = figure();
subplot(1, 2, 1);
plot(MWTimeVec, MWCountsVec, 'r');
hold on
plot(MWTimeVec, refCountsVec, 'b');
xlabel('Pulse Duration (ns)');
ylabel('flourescence (kCounts/sec)');
title(saveStr);
legend('with RF', 'Reference');

normData = (refCountsVec - MWCountsVec)./(refCountsVec);

[params, fit, exitFlag] = FitSineWave(MWTimeVec, normData);
if exitFlag > 0
    handles.NVParams.Pi_Time = round(params(2));
    handles.NVParams.Pi_Power = POWER;
end

subplot(1, 2, 2)
plot(MWTimeVec, normData, 'go');
hold on
plot(MWTimeVec, fit, 'm');
xlabel('Pulse Duration (ns)');
ylabel('flourescence change');
title(['\pi time = ', num2str(params(2)), ' ns ', 'power = ', num2str(POWER), ' dBm']);
legend('Data', 'Fit')

savefig(fig, [saveStr, '_Figs']);
saveData = {MWTimeVec, MWCountsVec, refCountsVec, fit, params, normData};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');

TurnOffGreen;