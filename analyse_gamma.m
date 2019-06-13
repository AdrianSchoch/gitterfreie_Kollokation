y = 10;
L2_error_array = zeros(36, y);
Linf_error_array = zeros(36, y);
temp = linspace(0.001, 0.009, 9);
gamma_array = [temp, 10*temp, 100*temp, 1000*temp];
for i = 1:36
    disp("i = " + num2str(i));
    model = praktikum_elliptisch_model(0.5);
    for j = 1:y
        discr = diskretisierung(100, 100, 0, model, gamma_array(i));
        [A, b] = lgs_assembler(model, discr);
        c = A\b;
        [N, S, L1_error, L2_error_array(i, j), Linf_error_array(i, j)] = grid_evaluation(50, c, discr, model);
    end
end
plot(gamma_array, median(L2_error_array.'), 'b');
hold on
plot(gamma_array, median(Linf_error_array.'), 'r');
set(gca, 'XScale', 'log');
ylim([0 1]);