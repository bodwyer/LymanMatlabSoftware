scanNoMW = load('scan195.mat')
xValues = scanNoMW.sData.XData;
yValues = scanNoMW.sData.YData;
scanNoMW = scanNoMW.sData.ZData;

scanMW = load('scan196.mat');
scanMW = scanMW.sData.ZData;

CCImage = xcorr2(scanNoMW, scanMW);
[max_cc, imax] = max(abs(CCImage(:)));
[yPeak, xPeak] = ind2sub(size(CCImage), imax(1));

yOffsetPix_Forward = (yPeak - size(scanNoMW, 1))
xOffsetPix_Forward = (xPeak - size(scanNoMW, 2))

figure
imagesc(CCImage)

figure
imagesc(xValues, yValues, scanNoMW - scanMW);
