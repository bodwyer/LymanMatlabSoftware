function [] = TurnOffGreen()
	PBesrInit();%initialize PBesr
	% sets the clock frequency. for PBESR-PRO-400, it's 400MHz
	% for PBESR-PRO-333, it's 333.3MHz
	PBesrSetClock(100); 

	PBesrStartProgramming(); % enter the programming mode

	label = PBesrInstruction(bin2dec('00000000'),'ON', 'CONTINUE', 0, 100);
	PBesrInstruction(bin2dec('00000000'),'ON', 'BRANCH', label, 100);

	PBesrStopProgramming(); % exit the programming mode

	PBesrStart(); %start pulsing. it will start pulse sequence which were progammed/loaded to PBESR card before.

	PBesrStop(); %stop pulsing
	PBesrClose(); %close PBesr
end