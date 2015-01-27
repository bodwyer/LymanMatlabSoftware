function [] = PulseBlasterControls(hObject, eventdata, handles, onOff)
% Turns selected pulse blaster channels on and all others off
channels = 0;

if strcmp(onOff, 'ON')
    for i = 0:8
        turnOn = get(eval(['handles.chan', num2str(i)]), 'Value');
        if turnOn
            channels = channels + 2^i;
        end
    end
    set(handles.PBIndicator, 'ForegroundColor', [0, 1, 0]); % set to green
else
    set(handles.PBIndicator, 'ForegroundColor', [1, 0, 0]); % set to red
end
set(handles.PBIndicator, 'String', onOff);
PBesrInit();
PBesrSetClock(400); % 400 MHz clock
PBesrStartProgramming();
label = PBesrInstruction(channels,'ON', 'CONTINUE', 0, 100);
PBesrInstruction(channels,'ON', 'BRANCH', label, 100);

PBesrStopProgramming(); % exit the programming mode

PBesrStart(); %start pulsing. it will start pulse sequence which were progammed/loaded to PBESR card before.

PBesrStop(); %stop pulsing
PBesrClose(); %close PBesr

guidata(hObject, handles);

end

