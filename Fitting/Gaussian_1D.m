function [gauss] = Gaussian_1D(params, xVec)
        
        x_0 = params(1);
        A = params(2);
        sigma_x = params(3);
        const = params(4);

        gauss = A*exp(-1/(2*sigma_x^2).*(xVec - x_0).^2) + const;
        
    end