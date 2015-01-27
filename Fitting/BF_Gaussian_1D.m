function [best_fit_gaussian, fit_params, exitFlag] = BF_Gaussian_1D(data, xVec)


	guess_params = [xVec(find(data == max(data))),(max(data) - mean(data)), abs(xVec(end) - xVec(1))/2, mean(data)]

	fit_fun = @(params)Gauss_fit(params, data, xVec);
	lb = [xVec(1), 0, xVec(2) - xVec(1), 0];
	ub = [xVec(end), 1.5*(max(data)), abs(range(xVec)), max(data)];


	[fit_params, resNorm, residual, exitFlag] = lsqnonlin(fit_fun, guess_params, lb, ub);

	best_fit_gaussian = Gaussian_1D(fit_params, xVec);


	function [res] = Gauss_fit(params, im, xx)

		gauss = Gaussian_1D(params, xx);
		res = gauss - im;

	end

end
