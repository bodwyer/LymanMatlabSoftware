function [lastInst] = Init()
	PBInst(2^5, 'ON', 'CONTINUE', 0, 2e3 + 800);
	lastInst = PBInst(0, 'ON', 'CONTINUE', 0, 2e3);
end
