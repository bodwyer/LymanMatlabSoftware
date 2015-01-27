function [status, task] = DigPulseTrainCont(Freq,DutyCycle,Samps)

DAQmx_Val_ContSamps =10123; % Continuous Samples
DAQmx_Val_Hz = 10373; % Hz
DAQmx_Val_Low =10214; % Low

[s,a,task] = DAQmxCreateTask('');
DAQmxErr(s);
s = DAQmxCreateCOPulseChanFreq(task,'Dev1/ctr1','',DAQmx_Val_Hz,DAQmx_Val_Low,0.0,Freq, DutyCycle);
DAQmxErr(s);
status = s + DAQmxCfgImplicitTiming(task,DAQmx_Val_ContSamps,Samps);
DAQmxErr(s);
