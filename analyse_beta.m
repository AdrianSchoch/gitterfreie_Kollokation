x = 100;
y = 10;
L1_error_array = zeros(x, y);
L2_error_array = zeros(x, y);
Linf_error_array = zeros(x, y);
for i = 1:x
    disp("i = " + num2str(i));
    model = praktikum_elliptisch_model(i * 0.01);
    for j = 1:y
        discr = diskretisierung(100, 100, 0, model, 0.5);
        [A, b] = lgs_assembler(model, discr);
        c = A\b;
        [N, S, L1_error_array(i, j), L2_error_array(i, j), Linf_error_array(i, j)] = grid_evaluation(50, c, discr, model);
    end
end
plot(linspace(0.01, 1, 100), median(L1_error_array.'), 'r');
hold on
plot(linspace(0.01, 1, 100), median(L2_error_array.'), 'g');
hold on
plot(linspace(0.01, 1, 100), median(Linf_error_array.'), 'b');