function LoadPBESR

if ~libisloaded('mypbesr')
    disp('Matlab: Load spinapi.dll')
    % Added by Sungkun
    % spinapi.h C:\Program Files\SpinCore\SpinAPI\dll
    % spinapi.dll C:\Program Files\SpinCore\SpinAPI\dll
    funclist = loadlibrary('spinapi64.dll','spinapi.h','alias','mypbesr');
end
disp('Matlab: dll loaded')
