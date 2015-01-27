function [] = NVScriptRunner(script, failScript)

    try 
        eval(script);
    catch ME
        errorMessage = sprintf('Error in myScrip.m.\nThe error reported by MATLAB is:\n\n%s', ME.message);
        uiwait(warndlg(errorMessage));
        eval(failScript);
    end
        


end

