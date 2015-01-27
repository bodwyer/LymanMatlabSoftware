function [plane] = FitPlane(image)

[sy, sx] = size(image);

perim = NaN(sy, sx);
perim(1,:) = image(1,:);
perim(sy,:) = image(sy,:);
perim(:,1) = image(:,1);
perim(:,sx) = image(:,sx);

x = 1:sx;
y = 1:sy;
[X, Y] = meshgrid(x, y);
plane_fun = @(plane_par)plane_fit(plane_par, perim, sx, sy, X, Y);
guess = [0.01, 0.01, 1];

best_par = fminsearch(plane_fun, guess);



plane = best_par(1)*X + best_par(2)*Y + best_par(3);

function [Diff] = plane_fit(plane_par, perimeter,nx,ny, xx, yy)

    plane = plane_par(1)*X + plane_par(2)*Y + plane_par(3);

    diff = NaN(ny,nx);
    diff(1,:) = plane(1,:)-perimeter(1,:);
    diff(ny,:) = plane(ny,:)-perimeter(ny,:);
    diff(:,1) = plane(:,1)-perimeter(:,1);
    diff(:,nx) = plane(:,nx) - perimeter(:,nx);
    Diff = nansum(nansum(abs(diff)));

end
end
