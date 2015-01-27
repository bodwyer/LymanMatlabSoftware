function [lastInst] = ReadOut();
	PBInst(2^5, 'ON', 'CONTINUE', 0, 800);
	lastInst = PBInst(2^5 + 2^7, 'ON', 'CONTINUE', 0, 300);
end