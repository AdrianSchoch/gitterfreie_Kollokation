model = praktikum_elliptisch_model(0.5);
x = 100;
L2_error_array = zeros(x, 10);
Linf_error_array = zeros(x, 10);
for i = 1:x
    disp("i = " + num2str(i))
    for j = 1:10
        discr = diskretisierung(i, x - i, 0, model, 0.5);
        [A, b] = lgs_assembler(model, discr);
        c = A\b;
        [N, S, L1_error, L2_error_array(i, j), Linf_error_array(i, j)] = grid_evaluation(50, c, discr, model);
    end
end
figure(1)
plot(linspace(1, x, x), median(L2_error_array.'), 'b');
hold on
plot(linspace(1, x, x), median(Linf_error_array.'), 'r');
ylim([0 1])