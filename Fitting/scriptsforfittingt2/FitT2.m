function [fitresult] = FitT2(fileName, NVName)


	runData = load([fileName, '_DATA.mat']);
	saveData = runData.saveData;
	tauVec = 2*saveData{1};
    tauVec = tauVec(1:2:end);
	countsNorm = saveData{5};
    countsNorm = countsNorm(1:2:end);
	totalT = tauVec;
    aveLst = mean(countsNorm((end-2):end));





	fitTol = 1e-11; % Fit tolerance


	[xData, yData] = prepareCurveData( totalT, countsNorm);

	% Set up fittype and options.
	ft = fittype( 'a.*exp(-(x./b).^c) + d', 'independent', 'x', 'dependent', 'y' , 'coefficients',{'a','b','c', 'd'});
	opts = fitoptions( 'Method', 'NonlinearLeastSquares' ,'MaxFunEvals',2000,'MaxIter',2000, 'TolFun', fitTol);
	opts.Display = 'Off';
	opts.Lower = [.2 5 0 aveLst - 0.05];
	opts.StartPoint = [0.5 10e3 1 aveLst];
	opts.Upper = [1.5 1e6 3 aveLst + 0.05];
	% opts.Weights = weights; % If we ever need to weight by sigma

	% Fit model to data.
	[fitresult, gof] = fit( xData, yData, ft, opts );

	a_fit = fitresult.a;
	b_fit = fitresult.b;
	c_fit = fitresult.c;

	Berr = confint(fitresult, 0.682);

	% Plot fit with data.
	fig = figure( 'Name', 'T2_Fit' );
	hold on
	plot(xData, yData , '-g.', 'Linewidth', 2)
	h = plot( fitresult);
	legend('Data', 'Fit', 'Location', 'NorthEast' );
	% Label axes
	xlabel( 'Free precession time (ns)' );
	ylabel( 'P(|0>)' );
	title({['Fit model: ',formula(fitresult)];...
    ['T_2: ', num2str(1e-3*b_fit, 3),'\pm', num2str(1e-3*(Berr(2,2)-b_fit),3),' \mu s'];...
    ['Hahn Echo',', Fit power: ',num2str(c_fit,3),' \pm ',num2str(Berr(2,3)-c_fit,2)]},...
    'FontWeight','bold','FontSize',16);

    save([fileName, '_Fit'], 'fitresult');
    savefig(fig, [fileName, 'Fit_Figure']);

end