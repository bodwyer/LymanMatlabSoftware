function [reply] = AgilentSGControl(command)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opens Agilent N9310 signal generator and supplies command (string) to it.
% Possible commands are:
%
% ':FREQUENCY:CW <val> <unit>': set frequency to <val>
% ':FREQUENCY:CW?': Query for current frequency
% 
% ':AMPLITUDE:CW <val> <unit>': sets the amplitude of CW output
% ':AMPLITUDE:CW?': query returns the current amplidue output
%
% ':RFOUTPUT:STATE <ON>|<OFF>': enables or disables RF output
% ':RFOUTPUT:STATE?': query returns current RF output state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    N9310A = visa('ni', 'USB::0x0957::0x2018::0115000525::INSTR');
    fopen(N9310A);
    
    fprintf(N9310A, command);
    
    if strcmp(command(end), '?')
        reply = fscanf(N9310A);
    else
        reply = 0;
    end
    
    
    fclose(N9310A);
    delete(instrfind);
    

end

