function [] = SetRangeToAxes(hObject, eventdata, handles, state)
% This function has two purposes: 
%
% 1. Set x/y min/max, as well as number of points, to coencide with Axes1
% limits after zooming in or out. It is called on the Zoom button press,
% and is defined by state = 'Current'
%
% 2. To reset the image displayed in Axes1 after resetting the zoom. This
% function is called by the reset zoom button press and is defined by state
%  = 'Original

% Make sure this is an xy scan
xChecked = get(handles.xCheckBox, 'Value');
yChecked = get(handles.yCheckBox, 'Value');

if xChecked && yChecked
    dataObjs = get(handles.Axes1, 'Children');
    dataObjs = dataObjs(end); % In case there are any other children of axes1
    xdata = get(dataObjs, 'XData'); % Get full scan x data
    if iscell(xdata)
        xdata = xdata{end}; % if there is a marker on the plot, need second field
    end
    ydata = get(dataObjs, 'YData'); % Get full scan y data
    if iscell(ydata)
        ydata = ydata{end}; % if there is a marker on the plot, this is second field
    end
    
    if strcmp(state, 'Current') % get xlims, ylims from plot
        xlims = get(handles.Axes1, 'XLim'); 
        ylims = get(handles.Axes1, 'YLim');
        xpoints = str2num(get(handles.xPoints, 'String'));
        ypoints = str2num(get(handles.yPoints, 'String'));
        % determine number of points corresponding to zoomed scale
%         xpoints = round((range(xlims)/range(xdata))*length(xdata));
%         ypoints = round((range(ylims)/range(ydata))*length(ydata));
    elseif strcmp(state, 'Original');
        % Set to full scan limits
        xlims = [xdata(1), xdata(end)];
        ylims = [ydata(1), ydata(end)];
        % Full number of points
        xpoints = length(xdata);
        ypoints = length(ydata);
        set(handles.Axes1, 'XLim', xlims);
        set(handles.Axes1, 'YLim', ylims);
    end
        
    % Set scan control boxes
    set(handles.xMin, 'String', num2str(xlims(1)));
    set(handles.xMax, 'String', num2str(ylims(end)));
    set(handles.xPoints, 'String', num2str(xpoints));
    
    set(handles.yMin, 'String', num2str(ylims(1)));
    set(handles.yMax, 'String', num2str(xlims(end)));
    set(handles.yPoints, 'String', num2str(ypoints));
end
guidata(hObject, handles);

end

