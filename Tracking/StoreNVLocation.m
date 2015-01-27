function [xyFitParams, zFitParams] = StoreNVLocation(hObject, handles, fileStr)
	% Stores location of NV as struct containing small, medium, and large 
	% images which can be used to re-find the NV at a later time via
	% cross correlation. 
	%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Inputs
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% * hObject (struct): GUI handle
	% * handles (struct): GUI handles
	% * fileStr (str): file name (including path) to save data to. If no filename is
	% entered, will use default save directory



	% Structure to contain small, medium, large scans for cross correlative 
	% finding if NV is lost
	sData = struct();

	% sData.Large = ScanBigImage(); % Large area scan, with NV at center
	sData.Med = ScanMedImage(); % Medium area scan (higher resolution)
	[xValues, yValues, xyScan, xyFitParams, bestFitXY] = ReTrack(hObject, handles, true); % Small scan (retrack)

	% Set remaining values
	SmallScan= struct();
	SmallScan.scanA = xyScan;
	SmallScan.Fit = bestFitXY;
	SmallScan.FitParams = xyFitParams;
	SmallScan.xValues = xValues;
	SmallScan.yValues = yValues;

	sData.Small = SmallScan;

	% Take z scan
	[zFitParams, zValues, scanZ, bestFitZ] = ZTrack(hObject, handles, true);
	

	% Assign values to struct
	ZScan = struct();
	ZScan.zValues = zValues;
	ZScan.zScan = scanZ;
	ZScan.zFit = bestFitZ;
	ZScan.params = zFitParams;
	sData.Zdata = ZScan;


	% Save data to file in .mat format
	save([fileStr], 'sData');

	guidata(hObject, handles);

end




