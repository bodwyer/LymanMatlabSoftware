function [sData] = ScanBigImage(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes a large area scan, centered at current galvo position, for use 
% when retrack fails. An initial large scan should be taken before staring
% any experiment, and if the retrack routine fails, another large area
% scan is taken. This can be compared with the original scan to attempt to
% retrieve the NV.
%
% Inputs:
%
% * scanType (str): only used for saving files. Can be either 'initial' or 'retrack'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	BOX_SIZE = 1; % Volts
	BOX_PIX = 200; % Pixels
	DT = 0.008; % Seconds

	% Current x and y position of Galvos (presumably on NV)
	x0 = ReadVoltage('Dev1/_ao0_vs_aognd');
	y0 = ReadVoltage('Dev1/_ao1_vs_aognd');

	% Set scan window limits (abs not to exceed 4.0 volts)
	xMin = max([x0 - BOX_SIZE, -7.0]);
	xMax = min([x0 + BOX_SIZE, 7.0]);
	yMin = max([y0 - BOX_SIZE, -7.0]);
	yMax = min([y0 + BOX_SIZE, 7.0]);

	xValues = linspace(xMin, xMax, BOX_PIX);
	yValues = linspace(yMin, yMax, BOX_PIX);


	TurnOnGreen(); % Make sure laser is on

	% Take a scan
	[bigImage, bigImageFlip] = ScanXY(xValues, yValues, DT);

	% Go back go original position
	WriteVoltageXYZ(1, x0);
	WriteVoltageXYZ(2, y0);

	% Build a struct to store all the scan data
	sData = struct();
	sData.scanA = bigImage;
	sData.scanB = bigImageFlip;
	sData.xValues = xValues;
	sData.yValues = yValues;
	sData.x0 = x0;
	sData.y0 = y0;

	% Filename
	if ~isempty(varargin)
		scanType = varargin{1};
		if strcmp('initial', scanType)
			fileName = 'LargeAreaScan_Initial';
		elseif strcmp('retrack', scanType)
			fileName = 'LargeAreaScan_Retrack';
		else
			error('Unrecognized scan type.')
		end

		figure
		imagesc(xValues, yValues, bigImage);
		xlabel('xVolts'); ylabel('yVolts');
		title('Large Tracking Image');
		box = [x0 - 15, y0 - 15, 30, 30];
		hold on
		rectangle('Position', box, 'LineWidth', 4, 'EdgeColor', 'k');

		save(fileName, 'sData');
	end


end
		


