FREQ = 2.843e6; % kHz
POWER = -10; % dBm
LASER_INIT_TIME = 10E3; % nano seconds (2us)
READOUT_PULSE = 400; % ns
DELAY = 800; %ns
PI_TIME = 4e3; % ns

% N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
% fopen(N9310A);
% fprintf(N9310A, [':AMPLITUDE:CW ', num2str(POWER), ' dBm']);
% fprintf(N9310A, [':FREQUENCY:CW ', num2str(FREQ), ' kHz']);
% 
% 
% fprintf(N9310A, ':RFOUTPUT:STATE ON');

N_EXPERIMENTS = 1000000;
pulseTime = 100;
% [location, trackHandle] = ReTrack(true);
PBesrInit();
        PBesrSetClock(400);
        PBesrStartProgramming(); 
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        PBesrInstruction(0, 'ON', 'LONG_DELAY', 1e5, 500);
        loop = PBesrInstruction(0, 'ON', 'CONTINUE', 0, 600);
        PBesrInstruction(2^5 + 2^15, 'ON', 'BRANCH', loop, 300);
%         PBesrInstruction(2^5, 'ON', 'LONG_DELAY', LASER_INIT_REPS + DELAY_REPS,LONG_DELAY_TIME);
%         PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME);
% %        PBesrInstruction(0, 'ON', 'LONG_DELAY',  WAIT_REPS, LONG_LONG_DELAY_LONG_DELAY_TIME);
%        start = PBesrInstruction(2^3 + 2^4, 'ON', 'CONTINUE', 0, pulseTime);
%         PBesrInstruction(0, 'ON', 'CONTINUE', 0, 400);
%         
%        PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME);
%         PBesrInstruction(2^5, 'ON', 'LONG_DELAY', DELAY_REPS, LONG_DELAY_TIME);
%         PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, READOUT_PULSE);
%         PBesrInstruction(2^5, 'ON', 'LONG_DELAY', LASER_INIT_REPS, LONG_DELAY_TIME);
%         PBesrInstruction(0, 'ON', 'LONG_DELAY', WAIT_REPS, LONG_DELAY_TIME);
%         PBesrInstruction(2^5, 'ON', 'LONG_DELAY', DELAY_REPS, LONG_DELAY_TIME);
%         PBesrInstruction(2^5 + 2^7, 'ON', 'CONTINUE', 0, READOUT_PULSE);
%         PBesrInstruction(0, 'ON', 'CONTINUE', 0, T_MAX - pulseTime + 100);

      
        
        PBesrStopProgramming();

PBesrStart();

% tic
% for i = 1:100
%     pause(30);
%     if toc > 30
%         PBesrStop();
%         PBesrClose();
%         [location, trackHandle] = ReTrack(true, location, trackHandle);
%         
%         PBesrInit();
%         PBesrSetClock(100);
%         PBesrStartProgramming(); 
%         loop = PBesrInstruction(2^7, 'ON', 'CONTINUE', 0, 800);
%         PBesrInstruction(2^5, 'ON', 'CONTINUE', 0, LASER_INIT_TIME);
%         PBesrInstruction(0, 'ON', 'CONTINUE', 0, 1e3);
%         PBesrInstruction(2^3, 'ON', 'CONTINUE', 0, PI_TIME);
%         PBesrInstruction(0, 'ON', 'CONTINUE', 0, 1e3);
%         PBesrInstruction(2^5, 'ON', 'BRANCH', loop, READOUT_PULSE);
%         PBesrStopProgramming();
%         
%         PBesrStart();
%         tic;
%     end
% end