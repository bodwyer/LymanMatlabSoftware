function [gauss] = Gaussian_2D_Sym(params, xx, yy)
        
        x_0 = params(1);
        y_0 = params(2);
        A = params(3);
        sigma = params(4);
        
        gauss = A*exp(-1/(2*sigma^2)*((xx - x_0).^2 + (yy - y_0).^2));
        
    end