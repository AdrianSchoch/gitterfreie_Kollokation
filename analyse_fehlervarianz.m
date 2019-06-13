model = praktikum_elliptisch_model(0.5);
x = 500;
y = 10;
L1_error_array = zeros(x, 1);
L2_error_array = zeros(x, 1);
Linf_error_array = zeros(x, 1);
L1_error_array_2 = zeros(x, 1);
L2_error_array_2 = zeros(x, 1);
Linf_error_array_2 = zeros(x, 1);
for i = 1:x
    discr = diskretisierung(200, 200, 0, model, 0.01);
    disp(i)
    [A, b] = lgs_assembler(model, discr);
    c = A\b;
    [N, S, L1_error_array(i), L2_error_array(i), Linf_error_array(i)] = grid_evaluation(100, c, discr, model);
    L1_error_array_2(i) = L1_error_array(i);
    L2_error_array_2(i) = L2_error_array(i);
    Linf_error_array_2(i) = Linf_error_array(i);
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
histogram(L2_error_array, round(x/10));
disp(length(find(isnan(L2_error_array))));
figure(2)
histogram(Linf_error_array, round(x/10));
disp(length(find(isnan(Linf_error_array))));
figure(3)
histogram(sum(reshape(L2_error_array_2, [round(x/y), y]))/y, round(x/(10*y)));
figure(4)
histogram(sum(reshape(Linf_error_array_2, [round(x/y), y]))/y, round(x/(10*y)));
figure(5)
histogram(median(reshape(L2_error_array_2, [round(x/y), y])), round(x/(10*y)));
figure(6)
histogram(median(reshape(Linf_error_array_2, [round(x/y), y])), round(x/(10*y)));