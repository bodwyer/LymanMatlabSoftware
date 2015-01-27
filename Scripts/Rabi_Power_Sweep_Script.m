FREQ = 2.0969e6; % kHz
N_EXPERIMENTS = 500000;
N_REPS = 10;
SAMPS_PER_EXPERIMENT = 2;
N_SAMPLES = SAMPS_PER_EXPERIMENT*N_EXPERIMENTS;
POWER_MIN = 2.0; % dBm
POWER_MAX = 8.0; % dBm
POWER_STEP = 0.2;
LASER_INIT_TIME = 2E3; % nano seconds (1us)
READOUT_PULSE = 300; % ns
LONG_DELAY_TIME = 50;
RISE_TIME = 50; % ns
DELAY = 800; %ns
WAIT_TIME = 2e3; % ns
IQ_WIDTH = 30;
PI_TIME = 40;
PI_TIME_TWO = 20;

LoadNVParams;

timeout = 120;

MWPowVec = POWER_MIN:POWER_STEP:POWER_MAX;

% MWTimeVec_Random = MWTimeVec(randperm(length(MWTimeVec)));

MWCountsVec = nan(size(MWPowVec));
refCountsVec = nan(size(MWPowVec));
% piTwoCountsVec = nan(size(MWPowVec));

axes(expAxes)
h1 = plot(MWPowVec, MWCountsVec, 'r');
hold on;
h2 = plot(MWPowVec, refCountsVec, 'g');
% h3 = plot(MWPowVec, piTwoCountsVec, 'b');
xlabel('Power (dBm)');
ylabel('Counts');
title('Rabi Power Sweep')
legend('Signal', 'Reference');
drawnow;


N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
fprintf(N9310A, ':IQ:STATE ON');
fprintf(N9310A, ':MOD:STATE ON');


saveStr = GenerateSaveFolders(handles.saveStr,'Power_Sweep');

fprintf(N9310A, ':RFOUTPUT:STATE ON');

for i = 1:N_REPS
    for it = 1:length(MWPowVec)
        DynamicReTrack(hObject, handles);
        handles = guidata(hObject);

        pulsePower = MWPowVec(it);
        fprintf(N9310A, [':AMPLITUDE:CW ', num2str(pulsePower), ' dBm']);
        countsArray = zeros(1, N_SAMPLES);
        disp(['Experiment ', num2str(it), ' of ' , num2str(length(MWPowVec))]);
    
        


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

        MWCounts = sum(countsArray(1:2:end));
        refCounts = sum(countsArray(2:2:end));

        if isnan(MWCountsVec(it))
            MWCountsVec(it) = 0;
            refCountsVec(it) = 0;
        end
        MWCountsVec(it) =MWCountsVec(it) +  MWCounts;
        refCountsVec(it) = refCountsVec(it) + refCounts;
        
        set(h1, 'YData', MWCountsVec);
        set(h2, 'YData', refCountsVec);

        drawnow;

        newHandles = guidata(hObject);
        if ~newHandles.ScriptRunning
            CleanUp;
            return;
        end
            
    end
    
   

    
    
 
end


fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);
delete(instrfind);

countsNorm = (refCountsVec - MWCountsVec)./refCountsVec;
% halfCountsNorm = (refCountsVec - piTwoCountsVec)./(refCountsVec - MWCountsVec);
[bestFitParams, fit, peakPower, exitFlag] = FitLogSineWave(MWPowVec, countsNorm);
handles.NVParams.Pi_Power = roundn(peakPower, -1);

saveFig = figure();
plot(MWPowVec, countsNorm, '-b.', MWPowVec, fit, 'r');
legend('Data', 'Fit')
xlabel('Power (dBm)');
ylabel('Contrast');
title(saveStr);

% subplot(1, 2, 2)
% plot(MWPowVec, halfCountsNorm, 'b');
% xlabel('Power (dBm)'); 
% ylabel('Contrast');
% title('\pi/2 pulse, normalized');

savefig(saveFig, [saveStr, '_Figs']);
saveData = {MWPowVec, MWCountsVec, refCountsVec, countsNorm};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');




