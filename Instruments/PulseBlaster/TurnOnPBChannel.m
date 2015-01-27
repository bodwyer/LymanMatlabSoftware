function [] = TurnOnPBChannel(varargin)
    channels = 0;
    for ic = 1:length(varargin)
        channels = channels + 2^(varargin{ic});
    end
    
	PBesrInit();%initialize PBesr
	% sets the clock frequency. for PBESR-PRO-400, it's 400MHz
	% for PBESR-PRO-333, it's 333.3MHz
	PBesrSetClock(400); 

	PBesrStartProgramming(); % enter the programming mode

	label = PBesrInstruction(channels,'ON', 'CONTINUE', 0, 100);
	PBesrInstruction(channels,'ON', 'BRANCH', label, 100);

	PBesrStopProgramming(); % exit the programming mode

	PBesrStart(); %start pulsing. it will start pulse sequence which were progammed/loaded to PBESR card before.

	PBesrStop(); %stop pulsing
	PBesrClose(); %close PBesr
end