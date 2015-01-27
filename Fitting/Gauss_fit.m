function [fit_pars] = Gauss_fit(monopole_vec, microns_per_row, microns_per_col)
    fit_pars = [];
    for m = 1:length(monopole_vec)
        monopole = monopole_vec(m);
        data = monopole.data;
        data = data - FitPlane(data);
        [x_guess, y_guess] = find(data == max(data(:)));
        x_guess = x_guess(1); y_guess = y_guess(1);
        width = monopole.W;
        height = monopole.H;
       
        [dat_rows, dat_cols] = size(data);
        
        
        
        y = linspace(-width/2*microns_per_row, width/2*microns_per_row, dat_rows);
        x = linspace(-height/2*microns_per_col, height/2*microns_per_col, dat_cols);
        
        guess_params = [x(x_guess), y(y_guess), max(data(:)), width/4, height/4, 0];
        
        [xx, yy] = meshgrid(x, y);
        
        fit_fun = @(params)Gauss_fit(params, data, xx, yy);
        
        % optimoptions(@lsqnonlin, 'FinDiffRelStep')
        
        [fit_params, res] = lsqnonlin(fit_fun, guess_params)


        figure
        subplot(2, 2, 1)
        imagesc(x, y, data)
        title(strcat('Monopole ', num2str(m), ' data'))
        subplot(2, 2, 3)
        plot(x, data(x_guess, :));
        subplot(2, 2, 2)
        fitted_Gaussian = Gaussian_2D(fit_params, xx, yy);
        imagesc(x, y, fitted_Gaussian);
        title(strcat('Monopole ', num2str(m), ' Fit, A = ', num2str(fit_params(3))));
        subplot(2, 2, 4)
        plot(x, fitted_Gaussian(x_guess, :));
        
        ft = struct('data', data, 'fit_im', fitted_Gaussian, 'fits', fit_params, 'residual', res);
        fit_pars = [fit_pars, ft];
        

        
    end
    
    function [res] = Gauss_fit(params, im, xx, yy)
        
        gauss = Gaussian_2D(params, xx, yy);
        
        res = gauss - im;
    end


end

