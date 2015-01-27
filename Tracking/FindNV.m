function [xyStatus, zStatus] = FindNV(hObject, handles, trackingFileName)

	offsetX = str2num(get(handles.offsetX, 'String')); % This is a good idea. Add box in GUI for this.
	offsetY = str2num(get(handles.offsetY, 'String'));
	% Load parameters from a data taking run. This should be the file
	% filename_NV_Tracking_Info.mat
	trackingData = load(trackingFileName);
	imData = trackingData.sData;
	% lastScanLarge = imData.Large; % 1X1 Volt scan
	lastScanMed = imData.Med; % 0.5X0.5 Volt scan
	lastScanSmall = imData.Small; % Single NV image
	lastScanFit = imData.Small.Fit;
	lastScanZ = imData.Zdata; % Z scan for NV

	lastScanFitParams = lastScanSmall.FitParams;

	x0 = lastScanFitParams(1) + offsetX;
	y0 = lastScanFitParams(2) + offsetY;

	% Preprocessing:
	% What makes the most sense for preprocessing?
	% * low pass filter
	% * lowered Gaussian convolution
	% * slowly varying Gaussian convolution
	% * Subtract plane



	% Go to optimal focus and position of NV
	WriteVoltageXYZ(1, x0);
	WriteVoltageXYZ(2, y0);
% 	WriteVoltageXYZ(3, lastScanZ.params(1));
	pause(0.2); % Wait to equilibrate

	% ImLarge = ScanBigImage();

	% Translate X and Y so that new image overlaps with original stored image
	% LargeScanTrack(lastScanLarge, ImLarge);

	% Do the same thing with medium sized scan (more accuracy)
	newScanMed = ScanMedImage();
	LargeScanTrack(lastScanMed, newScanMed);

	% Center on NV using retrack routines
	[xVals, yVals, xyScan, xyfitparams, xyFit, xyStatus] = ReTrack(hObject, handles, true);
	[zFitParams, zValues, scanZ, zFit, zStatus] = ZTrack(hObject, handles, true);



	% Plot the results
	findFig = figure();
	hold on;

	% Large scan from file
	% subplot(2, 4, 1)
	% imagesc(lastScanLarge.xValues, lastScanLarge.yValues, lastScanLarge.scanA); 
	% rectangle('Position', [lastScanMed.xValues(1), lastScanMed.yValues(1),...
	% 	range(lastScanMed.xValues), range(lastScanMed.yValues)], 'LineWidth', 2); % Rectangle showing medium scan area
	% title('Old scan (large)')

	% Medium scan from file
	subplot(2, 4, 2)
	imagesc(lastScanMed.xValues, lastScanMed.yValues, lastScanMed.scanA); 
	rectangle('Position', [lastScanSmall.xValues(1), lastScanSmall.yValues(1), ...
		range(lastScanSmall.xValues), range(lastScanSmall.yValues)], 'LineWidth', 2); % Rectangle showing small scan area
	title('Old scan (medium)')

	% Single NV scan from file (most recent retrack)
	subplot(2, 4, 3)
	imagesc(lastScanSmall.xValues, lastScanSmall.yValues, lastScanSmall.scanA);
	hold on
	plot(x0, y0, 'k+', 'LineWidth', 2, 'MarkerSize', 10); % Central position of NV
	title('Old scan (small)')

	% Z scans + fits, showing relative positions
	subplot(2, 4, 4)
	plot(lastScanZ.zValues, lastScanZ.zScan, 'ro', lastScanZ.zValues, lastScanZ.zFit, 'b',...
	 zValues, scanZ, 'go', zValues, zFit, 'm');
	legend('Old (data)', 'Old (fit)', 'New (data)', 'New (fit)');

	% % Large scan for retracking
	% subplot(2, 4, 5)
	% imagesc(ImLarge.xValues, ImLarge.yValues, ImLarge.scanA);
	% rectangle('Position', [newScanMed.xValues(1), newScanMed.yValues(1), ...
	% 	range(newScanMed.xValues), range(newScanMed.yValues)], 'LineWidth', 2); % Rectangle showing medium scan range
	% title('New scan (large)')

	% Medium scan for retracking
	subplot(2, 4, 6)
	imagesc(newScanMed.xValues, newScanMed.yValues, newScanMed.scanA);
	rectangle('Position', [xVals(1), yVals(1), range(xVals), range(yVals)], 'LineWidth', 2); % Rectangle showing small scan range
	title('New scan (medium)')

	% Single NV retrack scan
	subplot(2, 4, 7)
	imagesc(xVals, yVals, xyScan);
	hold on
	plot(xyfitparams(1), xyfitparams(2), 'k+', 'LineWidth', 2, 'MarkerSize', 10); % Fitted center of NV
	title('New scan (small)')

	% Z scans, showing difference in peak sizes + shapes
	subplot(2, 4, 8)
	scaledZPrevious = lastScanZ.zValues - lastScanZ.params(1)*ones(size(lastScanZ.zValues));
	scaledZNew = zValues - zFitParams(1)*ones(size(zValues));
	plot(scaledZPrevious, lastScanZ.zFit, 'r', ...
		scaledZNew, zFit, 'b')
	legend('Old scan (scaled)', 'New scan (scaled)')

	% Goodness of find parameters?
	% * RMS value
	% * diff height (Z)
	% * diff volume (XY)
	% disp('Here are some of the parameters to compare:')
	% RMS_large = sum((lastScanLarge.scanA(:) - bestImLarge.scanA(:)).^2)
	% RMS_med = sum((lastScanMed.scanA(:) - newScanMed.scanA(:)).^2)
	% RMS_small = sum((lastScanFit(:) - xyFit(:)).^2)

	
	% deltaZ = abs(zFitParams(1) - lastScanZ.params(1))

	% lastScanZ.params(1) = 0;
	% zFitParams(1) = 0;

	% zOldCentered = Gaussian_1D(lastScanZ.params, scaledZPrevious);
	% zNewCentered = Gaussian_1D(zFitParams, scaledZNew);
	% RMS_Z = sum((zOldCentered - zNewCentered).^2);

	% [nPixX, nPixY] = size(xyFit);



	% deltaVolume = abs(sum(lastScanFit(:)) - sum(xyFit(:)))/(nPixX*nPixY);




end