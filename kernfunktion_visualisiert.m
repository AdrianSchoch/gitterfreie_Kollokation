T = linspace(-1, 1, 100);
[X,Y] = meshgrid(T, T);
F = test(X, Y, 0.2, 0.5, 10);
surf(X, Y, F);

function res = test(x, y, x0, y0, gamma)
res = exp(-gamma * ((x-x0).^2+(y-y0).^2));
end