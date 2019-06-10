model = praktikum_elliptisch_model(0.5);
L1_error_array = zeros(100, 1);
L2_error_array = zeros(100, 1);
Linf_error_array = zeros(100, 1);
for i = 1:500
    discr = diskretisierung(200, 200, 0, model, 0.01);
    disp(i)
    [A, b] = lgs_assembler(model, discr);
    c = A\b;
    [N, S, L1_error_array(i), L2_error_array(i), Linf_error_array(i)] = grid_evaluation(100, c, discr, model);
    if L1_error_array(i) > 1
        L1_error_array(i) = NaN;
    end
    if L2_error_array(i) > 1
        L2_error_array(i) = NaN;
    end
    if Linf_error_array(i) > 1
        Linf_error_array(i) = NaN;
    end
end
figure(1)
histogram(L1_error_array, 50);
disp(length(find(isnan(L1_error_array))));
figure(2)
histogram(L2_error_array, 50);
disp(length(find(isnan(L2_error_array))));
figure(3)
histogram(Linf_error_array, 50);
disp(length(find(isnan(Linf_error_array))));
