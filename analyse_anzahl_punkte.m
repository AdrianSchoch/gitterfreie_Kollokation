model = praktikum_elliptisch_model(0.5);
x = 15;
L2_error_array = zeros(x);
Linf_error_array = zeros(x);
grid_array = zeros(x,1);
for k = 1:x
    grid_array(k) = 3 * k * k + 2 * k;
end
for i = 1:x
    disp("i = " + num2str(i))
    for j = 1:x
        disp("j = " + num2str(j))
        discr = diskretisierung(grid_array(i), grid_array(j), -1, model, 0.01);
        [A, b] = lgs_assembler(model, discr);
        c = A\b;
        [N, S, L1_error, L2_error_array(i, j), Linf_error_array(i, j)] = grid_evaluation(50, c, discr, model);
    end
end
figure(1)
surf(grid_array, grid_array, L2_error_array);
zlim([0 1]);
figure(2)
surf(grid_array, grid_array, Linf_error_array);
zlim([0 1]);