MIN_FREQ = 2.07e6; % kHz;
MAX_FREQ = 2.1e6; % kHz;
N_POINTS = 50;
DT= 0.2; % seconds;
N_SAMPLES = 2;
POWER =  -23; % dBm
NReps = 6;

N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
fopen(N9310A);
fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
fprintf(N9310A, ':IQ:STATE OFF');
fprintf(N9310A, ':MOD:STATE OFF');


freqVec = linspace(MIN_FREQ, MAX_FREQ, N_POINTS);
countsVec = nan(size(freqVec));
countsVecRef = nan(size(freqVec));
fprintf(N9310A, [':FREQUENCY:CW ', num2str(freqVec(1)), ' kHz']);


saveStr = GenerateSaveFolders(handles.saveStr, 'CWESR');

axes(expAxes);
hold on
h1 = plot(freqVec, countsVec, '-r');
h2 = plot(freqVec, countsVecRef, '-g');
legend('Signal', 'Reference');
xlabel('Frequency (kHz)'); ylabel('Counts'); title('CWESR');



fprintf(N9310A, ':RFOUTPUT:STATE ON');

for in = 1:NReps

	for ifreq = 1:length(freqVec)
		if mod(ifreq, 3) == 0 || ifreq == 1
			DynamicReTrack(hObject, handles);
        	handles = guidata(hObject);
		end
    
    	[status, counterT, clockT] = SetCounter(1/DT, N_SAMPLES, 'INTERNAL');
    	if status ~= 0
        	CleanUpDAQmx(counterT, clockT);
        	error('Error creating counter and clock channels')
    	end
    	pause(0.1);

		freq = freqVec(ifreq);
		disp(['Frequency is ', num2str(freq), ' kHz']);
		TurnOnPBChannel(5, 3);

		fprintf(N9310A, [':Frequency:CW ', num2str(freq), ' kHz']);
		DAQmxStartTask(counterT);
		[status, readArray] = ReadCounter(counterT, N_SAMPLES, 30);
		if isnan(countsVec(ifreq))
			countsVec(ifreq) = diff(readArray);
		else
			countsVec(ifreq) = countsVec(ifreq) + diff(readArray);
		end
		DAQmxStopTask(counterT);

		TurnOnPBChannel(5);

		DAQmxStartTask(counterT);
		[status, readArray] = ReadCounter(counterT, N_SAMPLES, 30);
		if isnan(countsVecRef(ifreq))
			countsVecRef(ifreq) = diff(readArray);
		else
			countsVecRef(ifreq) = countsVecRef(ifreq) + diff(readArray);
		end
		DAQmxStopTask(counterT);
    
    	CleanUpDAQmx(counterT, clockT);


		set(h1, 'YData', countsVec);
    	set(h2, 'YData', countsVecRef);
    	drawnow;



	end
end

fprintf(N9310A, ':RFOUTPUT:STATE OFF');
fclose(N9310A);

TurnOffGreen;

countsNorm = (countsVec - countsVecRef)./countsVecRef;

[gauss, params, exitflag] = BF_Gaussian_1D_Inverted(countsNorm, freqVec);
if exitflag > 0
	handles.NVParams.ESR = params(1);
end

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





