function [] = LargeScanTrack(initial, retrack)

	% Pull scans out of structs
	initIm_Forward = initial.scanA;
	retrackIm_Forward = retrack.scanA;
    
    xVolts = ReadVoltage('Dev1/_ao0_vs_aognd');
	yVolts = ReadVoltage('Dev1/_ao1_vs_aognd');

	% Volts per pixel
	dx = initial.xValues(2) - initial.xValues(1);
	dy = initial.yValues(2) - initial.yValues(1);



	% Check forward images
	CCImage = xcorr2(retrackIm_Forward, initIm_Forward);
	[max_cc, imax] = max(abs(CCImage(:)));
	[yPeak, xPeak] = ind2sub(size(CCImage), imax(1));
    disp('Corr offset:')
	yOffsetPix_Forward = (yPeak - size(retrackIm_Forward, 1));
	xOffsetPix_Forward = (xPeak - size(retrackIm_Forward, 2));
    disp(['\Delta X = ', num2str(dx*xOffsetPix_Forward)])
    disp(['\Delta Y = ', num2str(dy*yOffsetPix_Forward)])


	% Backward images
	initIm_Reverse = initial.scanB;
	retrackIm_Reverse = retrack.scanB;

	CCImage_Reverse = xcorr2(retrackIm_Reverse, initIm_Reverse);
	[max_cc, imax] = max(abs(CCImage_Reverse(:)));
	[yPeak, xPeak] = ind2sub(size(CCImage_Reverse), imax(1));
	yOffsetPix_Reverse = (yPeak - size(retrackIm_Reverse, 1));
	xOffsetPix_Reverse = (xPeak - size(retrackIm_Reverse, 2));

	% Calculate how closely the forward and backward image offsets agree
	% the x offsets have a plus value, since reverse shold be -1*forward
	similarity = (xOffsetPix_Forward - xOffsetPix_Reverse)^2 + (yOffsetPix_Reverse - yOffsetPix_Forward)^2;

% 	if similarity > 10 % If the two images don't agree on offset 
% 		error('Tracking lost. Could not retrack');
% 	else
		% Center over "new" location of NV
		x0 = xVolts + dx*xOffsetPix_Forward;
		y0 = yVolts + dy*yOffsetPix_Forward;

		WriteVoltageXYZ(1, x0);
		WriteVoltageXYZ(2, y0);
% 	end

end
		