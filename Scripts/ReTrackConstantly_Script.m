POWER = -17; % dBm


[location, trackHandle] = ReTrack();
AgilentSGControl([':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
AgilentSGControl(':RFOUTPUT:STATE ON');
TurnOnPBChannel(5, 3);
tic
while toc < 5*60
    [location, trackHandle] = ReTrack(location, trackHandle);
end

AgilentSGControl(':RFOUTPUT:STATE OFF');
