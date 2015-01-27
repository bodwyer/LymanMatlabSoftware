function [] = AddMarkerToPlot(hObject, handles)
    % Get x and y coordinates on mouse click
	[x, y, button, ax] = ginputc(1, 'Color', 'k', 'Linewidth', 1.5);
    if ax == handles.Axes1
        hold(handles.Axes1, 'on');
        plot(handles.Axes1, x, y, 'mx', 'MarkerSize', 28, 'LineWidth', 2);
        hold(handles.Axes1, 'off');
    end

    guidata(hObject, handles);

end

