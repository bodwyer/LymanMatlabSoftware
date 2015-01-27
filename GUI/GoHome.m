function [ output_args ] = GoHome(hObject, eventdata, handles)
% Returns galvos to x0, y0 and piezo to z0
% Return to starting values
    x0 = get(handles.currentX, 'Value'); WriteVoltageXYZ(1, x0);
    y0 = get(handles.currentY, 'Value'); WriteVoltageXYZ(2, y0);
    z0 = get(handles.currentZ, 'Value'); WriteVoltageXYZ(3, z0);


end

