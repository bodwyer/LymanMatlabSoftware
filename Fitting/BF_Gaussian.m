function [best_fit_gaussian, fit_params, exitFlag, resnorm] = BF_Gaussian(data, xVec, yVec)

	[xx, yy] = meshgrid(xVec, yVec);

	data = data - FitPlane(data);
    
    lb = [xVec(1), yVec(1), 0, range(xVec)/1000, range(yVec)/1000, 0];
    ub = [xVec(end), yVec(end), 5*max(data(:)), 100*(range(xVec)^2 ...
        + range(yVec)^2), 100*(range(xVec)^2 ...
        + range(yVec)^2), 2*pi];
    
	guess_params = [xVec(round(length(xVec)/2)), yVec(round(length(yVec)/2)),...
        max(data(:)), range(xVec)/4, range(yVec)/4, pi/6];

	fit_fun = @(params)Gauss_fit(params, data, xx, yy);


	[fit_params, resnorm, residual, exitFlag] = lsqnonlin(fit_fun, guess_params, lb, ub);

	best_fit_gaussian = Gaussian_2D(fit_params, xx, yy);



	function [res] = Gauss_fit(params, im, xx, yy)

		gauss = Gaussian_2D(params, xx, yy);
		res = gauss - im;

	end

end
