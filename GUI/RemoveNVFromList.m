function [] = RemoveNVFromList(hObject, handles)

	currentList = get(handles.NVListBox, 'String');
	toRemove = get(handles.NVListBox, 'Value');
	NVtoRemove = currentList(toRemove);


	if toRemove <= length(currentList)
		currentList(toRemove) = []; % Delete NV from list

		pairList = handles.markerList;
		if sum(strcmp(NVtoRemove, pairList.keys())) > 0
			markerPair = pairList(NVtoRemove{1});
			delete(markerPair.marker);
			delete(markerPair.text);
			remove(handles.markerList, NVtoRemove{1});
		end
    end
    

    set(handles.NVListBox, 'Value', max(length(currentList), 1));
	set(handles.NVListBox, 'String', currentList);
	guidata(hObject, handles);

end
