function [fitresult] = FitT2DD(fileName, nXY, NVName)


	runData = load([fileName, '_DATA.mat']);
	saveData = runData.saveData;
	tauVec = 2*saveData{1};
%     tauVec(5:7) = [];
    tauVec(1) = [];
	% tauVec = [tauVec(7:21), tauVec(28:end)];
	countsNorm = saveData{5};
%     countsNorm(5:7) = [];
    countsNorm(1) = [];
	% countsNorm = [countsNorm(7:21), countsNorm(28:end)];
	totalT = 16*nXY*tauVec;
    
%     totalT(6:8) = [];
%     countsNorm(6:8) = [];





	fitTol = 1e-11; % Fit tolerance


	[xData, yData] = prepareCurveData( totalT, countsNorm);

	% Set up fittype and options.
	ft = fittype( 'a.*(1 - exp(-(x./b).^c))', 'independent', 'x', 'dependent', 'y' , 'coefficients',{'a','b','c'});
	opts = fitoptions( 'Method', 'NonlinearLeastSquares' ,'MaxFunEvals',2000,'MaxIter',2000, 'TolFun', fitTol);
	opts.Display = 'Off';
	opts.Lower = [.3 5 0];
	opts.StartPoint = [0.5 40e3 1];
	opts.Upper = [.7 1e7 3];
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
    ['Number of \pi-pulses: ',num2str(nXY*8),', Fit power: ',num2str(c_fit,3),' \pm ',num2str(Berr(2,3)-c_fit,2)]},...
    'FontWeight','bold','FontSize',16);

    save([fileName, '_Fit'], 'fitresult');
    savefig(fig, [fileName, 'Fit_Figure']);


end