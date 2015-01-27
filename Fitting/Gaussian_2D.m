function [gauss] = Gaussian_2D(params, xx, yy)
        
        x_0 = params(1);
        y_0 = params(2);
        A = params(3);
        sigma_x = params(4);
        sigma_y = params(5);
        theta = params(6);
        
        a = cos(theta)^2/(2*sigma_x^2) + sin(theta)^2/(2*sigma_y^2);
        b = -sin(2*theta)/(4*sigma_x^2) + sin(2*theta)/(4*sigma_y^2);
        c = sin(theta)^2/(2*sigma_x^2) + cos(theta^2)/(2*sigma_y^2);
        
        gauss = A*exp(-(a*(xx - x_0).^2 + 2*b*(xx - x_0).*(yy - y_0) + c*(yy - y_0).^2));
        
    end