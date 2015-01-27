 PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBInst(0, 'ON', 'CONTINUE', 0, 0.2e9); % Wait for DAQ to start up (200 ms)

        loop = PBInst(0, 'ON', 'CONTINUE', 0, 50);
        PBInst(2^3, 'ON', 'CONTINUE', 0, 17.5);
        PBInst(0, 'ON', 'CONTINUE', 0, 200);
        PBInst(2^3, 'ON', 'CONTINUE', 0, 40);
        PBInst(0, 'ON', 'BRANCH', loop, 100);

        PBesrStopProgramming();

        PBesrStart();
       

        % PBesrStop();
        % PBesrClose();