function [] =  PBesrProgramSweep(period, nReps, dutyCycle)
	tON = period*dutyCycle;
	tOFF = (period - tON);
	tON = round(tON*1e6);
	tOFF = round(tOFF*1e6);

    PBesrClose;
	PBesrInit();
    PBesrStop;
    PBesrSetClock(400);
    PBesrStartProgramming();
    loop = PBInst(0 , 'ON', 'LOOP', nReps, 20);
    PBInst(2^8 + 2^3, 'ON', 'CONTINUE',0, tOFF); % Laser ON, RF gate ON, RF Trig OFF
    PBInst(2^5 + 2^3 + 2^7 , 'ON', 'CONTINUE', 0, tON); % Laser ON, RF gate ON, counter gate ON
    PBInst(0, 'ON', 'CONTINUE', 0, tOFF);
    PBInst(2^5 + 2^7, 'ON', 'CONTINUE', 0, tON);
    PBInst(0 , 'ON', 'END_LOOP', loop, 20);
    brnch = PBInst(0, 'ON', 'CONTINUE', 0, 500);
    PBInst(0 , 'ON', 'BRANCH', brnch, 500);
    PBesrStopProgramming();
end 

