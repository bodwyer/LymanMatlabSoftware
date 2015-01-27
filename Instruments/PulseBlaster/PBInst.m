function [pulseNum] = PBInst(channels, flag, instType, nReps, duration)  
MAX_TIME = 640; % maximum duration (ns) for normal instructions
PULSE_LEN = 320; % since 'LONG_DELAY' must go for at least two repetitions, long pulses are split into
				% multiple 320 ns pulses
MAX_LONG_LEN = 100e6; % 100 ms, longest pulse duration even for the 'LONG_DELAY' instruction
MIN_TIME = 12.5; % minimum pulse time
MAX_REPS = 1048576; % max Repetitions in a loop


if duration > MAX_TIME && duration <= MAX_LONG_LEN
	reps = idivide(int32(duration), int32(PULSE_LEN));
	longPulse = PULSE_LEN;
    shortPulse = mod(duration, PULSE_LEN);


    if shortPulse < MIN_TIME
    	if shortPulse == 0

    		if reps <= 2
	    		longPulse = longPulse/2;
	    		reps = 2*reps;
	    	end
	    	shortPulse = longPulse;
	    	reps = reps - 1;
		
    	else
    		shortPulse = MIN_TIME;
    	end
    end

    if shortPulse == 0
    	error('Short pulse is 0!');
    elseif reps < 2
    	error('Too few reps!')
    elseif longPulse < 20
    	error('longPulse too short!')
    elseif shortPulse < 12.5
    	error('ShortPulse < 12.5!')
    end

    if strcmp(instType, 'CONTINUE')

    	pulseNum = PBesrInstruction(channels, flag, 'LONG_DELAY', reps, longPulse);
	    PBesrInstruction(channels, flag, 'CONTINUE', 0, shortPulse);

    elseif strcmp(instType, 'LOOP')

    	if nReps > MAX_REPS
    		error(['Loop repetitions must be less than ', num2str(MAX_REPS)]);
    	else
	    	pulseNum = PBesrInstruction(channels, flag, 'LOOP', nReps, shortPulse);
	    	PBesrInstruction(channels, flag, 'LONG_DELAY', reps, longPulse);
	    end

    elseif strcmp(instType, 'END_LOOP')

    	PBesrInstruction(channels, flag, 'LONG_DELAY', reps, longPulse);
    	pulseNum = PBesrInstruction(channels, flag, 'END_LOOP', nReps, shortPulse);

    elseif strcmp(instType, 'BRANCH')

    	PBesrInstruction(channels, flag, 'LONG_DELAY', reps, longPulse);
    	pulseNum = PBesrInstruction(channels, flag, 'BRANCH', shortPulse);
    	
    end

elseif duration > MAX_LONG_LEN
	superLongReps = idivide(int32(duration), int32(MAX_LONG_LEN));
	rTime = mod(duration, MAX_LONG_LEN);
    longReps = idivide(int32(rTime), PULSE_LEN);
    shortPulse = mod(rTime, PULSE_LEN);
    pulseNum = -1;
    if longReps >= 2 
        pulseNum = PBesrInstruction(channels, flag, 'LONG_DELAY', longReps, PULSE_LEN);
    end
    if shortPulse >= MIN_TIME
        PBesrInstruction(channels, flag, 'CONTINUE', 0, shortPulse);
    end

	for irep = 1:superLongReps
		pulseNum = PBesrInstruction(channels, flag, 'LONG_DELAY', 2e5, 500);
	end

else
	pulseNum = PBesrInstruction(channels, flag, instType, nReps, duration);

end
	
    	


end

