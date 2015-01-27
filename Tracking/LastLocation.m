function [] = LastLocation(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(varargin) == 0
    load('previousCoordinates.mat');
    WriteVoltageXYZ(1, x0);
    WriteVoltageXYZ(2, y0);
    WriteVoltageXYZ(3, z0);
else
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    
    x0 = x(end);
    y0 = y(end);
    z0 = z(end);
    save('previousCoordinates.mat', 'x0', 'y0', 'z0');
end

end

