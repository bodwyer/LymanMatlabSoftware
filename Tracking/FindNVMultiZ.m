function [xyStatus, zStatus] = FindNVMultiZ(hObject, handles, trackingFileName)

	% List of all Z values to be scanned. Will find Z for 
	% besty matching cross correlation
	z0 = ReadVoltage('Dev1/_ao3_vs_aognd');
	zMin = max([-8, z0 - 2]);
	zMax = min([8, z0 + 2]);
	zValues = linspace(zMin, zMax, 5);

	% Load parameters from a data taking run. This should be the file
	% filename_NV_Tracking_Info.mat
	trackingData = load(trackingFileName);
	imData = trackingData.sData;
	lastScanLarge = imData.Large; % 1X1 Volt scan
	lastScanMed = imData.Med; % 0.5X0.5 Volt scan
	lastScanSmall = imData.Small; % Single NV image
	lastScanFit = imData.Small.Fit;
	lastScanZ = imData.Zdata; % Z scan for NV

	% Preprocessing:
	% What makes the most sense for preprocessing?
	% * low pass filter
	% * lowered Gaussian convolution
	% * slowly varying Gaussian convolution
	% * Subtract plane


	% Find Z value that most closely matches the stored scans
	bestXCorr = -1; % Looking for largest cross correlation, so start small
	for iz = 1:length(zValues)
		zVolts = zValues(iz);
		WriteVoltageXYZ(3, zVolts); % Go to z
		pause(0.2); % Wait for stripline to relax

		im = ScanBigImage() % Take 1X1 Volt scan
		imXCorr = xcorr2(im.scanA, lastScanLarge.scanA); % Cross correlation with old image
		[max_cc, imax] = max(abs(imXCorr)); % Extract max value
		
		% If best so far, remember this image & z voltage
		if imax > bestXCorr
			bestXCorr = imax;
			bestImLarge = im;
			bestZ = zVolts;
		end
	end

	% Go to optimal focus
	WriteVoltageXYZ(3, bestZ);
	pause(0.2); % Wait to equilibrate

	% Translate X and Y so that new image overlaps with original stored image
	LargeScanTrack(lastScanLarge, bestImLarge);

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
	subplot(2, 4, 1)
	imagesc(lastScanLarge.xValues, lastScanLarge.yValues, lastScanLarge.scanA); 
	rectangle('Position', [lastScanMed.xValues(1), lastScanMed.yValues(1),...
		range(lastScanMed.xValues), range(lastScanMed.yValues)], 'LineWidth', 2); % Rectangle showing medium scan area
	title('Old scan (large)')

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
	if strcmp(scan, 'Final')
		plot(xLast, yLast, 'k+', 'LineWidth', 2, 'MarkerSize', 10); % Central position of NV
	end
	title('Old scan (small)')

	% Z scans + fits, showing relative positions
	subplot(2, 4, 4)
	plot(lastScanZ.zValues, lastScanZ.zScan, 'ro', lastScanZ.zValues, lastScanZ.zFit, 'b',...
	 zValues, scanZ, 'go', zValues, zFit, 'm');
	legend('Old (data)', 'Old (fit)', 'New (data)', 'New (fit)');

	% Large scan for retracking
	subplot(2, 4, 5)
	imagesc(bestImLarge.xValues, bestImLarge.yValues, bestImLarge.scanA);
	rectangle('Position', [newScanMed.xValues(1), newScanMed.yValues(1), ...
		range(newScanMed.xValues), range(newScanMed.yValues)], 'LineWidth', 2); % Rectangle showing medium scan range
	title('New scan (large)')

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
	title('Old scan (small)')

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
	disp('Here are some of the parameters to compare:')
	RMS_large = sum((lastScanLarge.scanA(:) - bestImLarge.scanA(:)).^2)
	RMS_med = sum((lastScanMed.scanA(:) - newScanMed.scanA(:)).^2)
	RMS_small = sum((lastScanFit(:) - xyFit(:)).^2)

	
	deltaZ = abs(zFitParams(1) - lastScanZ.params(1))

	lastScanZ.params(1) = 0;
	zFitParams(1) = 0;

	zOldCentered = Gaussian_1D(lastScanZ.params, scaledZPrevious);
	zNewCentered = Gaussian_1D(zFitParams, scaledZNew);
	RMS_Z = sum((zOldCentered - zNewCentered).^2)

	[nPixX, nPixY] = size(xyFit);



	deltaVolume = abs(sum(lastScanFit(:)) - sum(xyFit(:)))/(nPixX*nPixY)




end