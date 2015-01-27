function LoadNIDAQmx

if ~libisloaded('mynidaqmx')
    disp('Matlab: Load nicaiu.dll')
    DLL_LOCATION = 'C:\Windows\System32\nicaiu.dll';
   % HEADER_LOCATION = 'C:\Program Files (x86)\National Instruments\Shared\ExternalCompilerSupport\C\include\NIDAQmx.h';
    LIB_LOCATION = 'C:\Program Files (x86)\National Instruments\Shared\ExternalCompilerSupport\C\lib64\msvc\';
    HEADER_LOCATION = 'C:\Users\MAXWELL\Documents\MATLAB\NV\mytoolboxes\nidaqmx\NIDAQmx.h';

    alias = 'mynidaqmx';

    addpath(LIB_LOCATION);

    loadlibrary(DLL_LOCATION, HEADER_LOCATION, 'alias', alias);
end
disp('Matlab: NIDAQmx dll loaded')
