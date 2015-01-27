figure(1);
hold on;




NVNum6 = [17, 16, 21, 22, 12];
T26 = [99, 154, 88.8, 173, 32.7];
T2_Err6 = 2*[7.41, 12, 6.66, 10, 1.65];
depth6 = [8.3, 11, 9, 12, 6];
depth_Err6 = [0.4, 0.5, .05, 10.4];

rates6 = 1./T26;

rates_Err6 = 0.5*abs(1./(T26 + T2_Err6) - 1./(T26 - T2_Err6));

errorbar(depth6, rates6, rates_Err6,'.', 'MarkerSize', 20, 'Color', [0, 0.8, 1.0])

NVNum8 = [1, 2, 4, 9];
T28 = [141, 32.2, 78, 9.89];
T2_Err8 = 2*[14.8, 1.7, 6.52, .765];
depth8 = [5.9, 2.8, 5.1, 2.6];

rates8 = 1./T28;
rates_Err8 = 0.5*abs(1./(T28 + T2_Err8) - 1./(T28 - T2_Err8));

errorbar(depth8, rates8, rates_Err8, '.y', 'MarkerSize', 20);
% [h, icons, plots, legendLabels] = legend();
% legendLabels = [legendLabels, 'Sample 00106', 'Sample 00108'];
% 
% legend(legendLabels);
