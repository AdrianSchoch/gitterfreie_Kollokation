x = 200;
L1_error_array = zeros(x, 1);
L2_error_array = zeros(x, 1);
Linf_error_array = zeros(x, 1);
cond_array = zeros(x,1);
for i = 1:x
    disp("i = " + num2str(i));
    model = praktikum_elliptisch_model(0.5);
    discr = diskretisierung(100, 100, 0, model, 0.5);
    [A, b] = lgs_assembler(model, discr);
    c = A\b;
    cond_array(i) = cond(A);
    [N, S, L1_error_array(i), L2_error_array(i), Linf_error_array(i)] = grid_evaluation(50, c, discr, model);
end
figure(1)
plot(cond_array, L2_error_array, 'b.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
figure(2)
plot(cond_array, Linf_error_array, 'r.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')