model = praktikum_elliptisch_model(0.5);
x = 100;
y = 10;
L2_error_array = zeros(x, y);
Linf_error_array = zeros(x, y);
for i = 1:x
    disp("i = " + num2str(i))
    for j = 1:y
        discr = diskretisierung(2*i, 2*i, 0, model, 0.5);
        [A, b] = lgs_assembler(model, discr);
        c = A\b;
        [N, S, L1_error, L2_error_array(i, j), Linf_error_array(i, j)] = grid_evaluation(50, c, discr, model);
    end
end
figure(1)
plot(linspace(1, 2*x, x), median(L2_error_array.'), 'b');
hold on
plot(linspace(1, 2*x, x), median(Linf_error_array.'), 'r');
ylim([0 1]);