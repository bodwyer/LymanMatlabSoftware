MIN_FREQ = 2.5e6; % kHz;
MAX_FREQ = 2.9e6; % kHz;
N_POINTS = 200;
N_PER_TRACK = 200;
DUTY = 0.5;
DT = 400; % ms;
N_REPS = 1;
POWER = -12; % dBm
TIMEOUT = 5*N_POINTS*DT*1e-3;



% trackingInfo = struct();
% trackingInfo.Initial.sData.Large

% 
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl(':RFOUTPUT:STATE ON');

% LastLocation(); % Go to most recent NV location

freqVec = linspace(MIN_FREQ, MAX_FREQ, N_POINTS);
countsVec = zeros(size(freqVec));
countsVecRef = zeros(size(freqVec));

axes(expAxes);
hold on
h1 = plot(freqVec, countsVec, '-ro');
h2 = plot(freqVec, countsVecRef, '-go');
legend('Signal', 'Reference');
xlabel('Frequency (kHz)'); ylabel('Counts'); title('CWESR');

if N_POINTS > N_PER_TRACK
    nGroups = idivide(int32(N_POINTS), N_PER_TRACK);
    remainder = mod(N_POINTS, N_PER_TRACK);
    nSampPoints = N_PER_TRACK;
else
    nGroups = 1;
    remainder = 0;
    nSampPoints = N_POINTS;
end
    


[status, task] = SetPulseWidthMeas(N_POINTS*2);



saveStr = GenerateSaveFolders(handles.saveStr, 'CWESR');

% ScanBigImage('initial');
% ReTrack(hObject, handles, false);
% ZTrack(hObject, handles, false);
DynamicReTrack(hObject, handles);


for n = 1:nGroups
    p0 = (n - 1)*N_PER_TRACK + 1;
    pf = n*N_PER_TRACK;
    SetTriggeredSweep(freqVec(p0), freqVec(pf), nSampPoints, 2*DT);
    for in = 1:N_REPS

        PBesrProgramSweep(DT, nSampPoints, DUTY); % Program pulseblaster
        DAQmxStartTask(task);
        
        
        PBesrStart();

        [status, readArray] = ReadCounter(task, nSampPoints*2, TIMEOUT);

        DAQmxStopTask(task);
        PBesrStop();
        PBesrClose();
        countsVecRef(p0:pf) = countsVecRef + readArray(2:2:end);
        countsVec(p0:pf) = countsVec(p0:pf) + readArray(1:2:end);

        set(h1, 'YData', countsVec);
        set(h2, 'YData', countsVecRef);

        drawnow;

        % ReTrack(hObject, handles, false);
        % ZTrack(hObject, handles, false);
        
        DynamicReTrack(hObject, handles);    
        
    end
    
end
if remainder ~= 0
    for in = 1:N_REPS
        SetTriggeredSweep(freqVec(length(freqVec) - remainder), freqVec(end), remainder, DT);
        PBesrProgramSweep(DT, remainder, DUTY); % Program pulseblaster
        DAQmxStartTask(task);
        
        PBesrStart();
        

        [status, readArray] = ReadCounter(task, remainder*2, TIMEOUT);

        DAQmxStopTask(task);
        PBesrStop();
        PBesrClose();

        countsVec((end - remainder + 1):end) = countsVec((end - remainder + 1):end) + readArray(1:2:end);
        countsVecRef((end - remainder + 1):end) = countsVecRef((end - remainder + 1):end) + readArray(2:2:end);

        set(h1, 'YData', countsVec);
        set(h2, 'YData', countsVecRef);

        drawnow;

        % ReTrack(hObject, handles, false);
        % ZTrack(hObject, handles, false);
        DynamicReTrack(hObject, handles);

    end
end
    

    

    


DAQmxClearTask(task);

AgilentSGControl(':RFOUTPUT:STATE OFF');

delete(instrfind);

countsVecNorm = (countsVec - countsVecRef)./countsVecRef;


fig = figure();
plot(freqVec, countsVecNorm, '-bo');
xlabel('Frequency (kHz)');
ylabel('Counts (kCounts/sec)');
title('CWESR Sweep')

hold on

[gauss, params, exiftlag] = BF_Gaussian_1D_Inverted(countsVecNorm, freqVec);

plot(freqVec, gauss, 'r');
text(params(1), params(4), ['f = ', num2str(params(1)*1e-6), ' GHz']);
title('CWESR');
legend('Data', 'Fit');
% 
savefig(fig, [saveStr, '_Figs']);
saveData = {freqVec, countsVec, countsVecNorm, gauss, params};
save([saveStr, '_DATA'], 'saveData');
save([saveStr, '_ALL_VARS'], '-v7.3');
% saveFigures = [fig];
% saveData = {freqVec, countsVec, gauss, params};






