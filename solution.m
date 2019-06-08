n = 500;
m = 200;
model = praktikum_elliptisch_model(0.5);
discr = diskretisierung(n, m, -1, model, 0.01);

[glob, last_inner, last_dirichlet] = point_sorter(discr.Xh_strich, model);
disp(length(glob))
% disp(last_inner);
% disp(last_dirichlet);

% figure(1)
% plot(glob(1:last_inner, 1), glob(1:last_inner, 2), 'r.');
% hold on
% plot(glob(last_inner+1:last_dirichlet,1), glob(last_inner+1:last_dirichlet,2), 'b.');
% hold on
% plot(glob(last_dirichlet+1:end,1), glob(last_dirichlet+1:end,2), 'g.');

[A, b] = lgs_assembler(model, discr, last_inner, last_dirichlet);
c = A\b;

grid_width_temp = 50;

X = linspace(-1, 1, grid_width_temp);
Y = linspace(-1, 1, grid_width_temp);
R = zeros(grid_width_temp, grid_width_temp);
S = zeros(grid_width_temp, grid_width_temp);
for k = 1:grid_width_temp
    for j = 1:grid_width_temp
        R(k,j) = sum(c .* discr.eval([X(k), Y(j)]));
        S(k,j) = model.solution([X(k), Y(j)]);
        if k > grid_width_temp/2 && j > grid_width_temp/2
            R(k,j) = 0;
            S(k,j) = 0;
        end
    end
end

% L1_error = abs(sum(sum(R-S))/(grid_width_temp*grid_width_temp*3/4));
% disp("L_1-Norm = " + num2str(L1_error))
% L2_error = sqrt(sum(sum((R-S).^2))/(grid_width_temp*grid_width_temp*3/4));
% disp("L_2-Norm = " + num2str(L2_error))
% Linf_error = max(max(abs(R-S)));
% disp("L_unendlich-Norm = " + num2str(Linf_error))
% figure(2)
% surf(X,Y,R);
% figure(3)
% surf(X,Y,S);
% figure(4)
% surf(X,Y,abs(R-S));

L2_array = zeros(100,1);
Linf_array = zeros(100,1);
for i = 1:100
    discr_i = diskretisierung(n, m, -1, model, 0.001*i);
    [glob, last_inner, last_dirichlet] = point_sorter(discr_i.Xh_strich, model);
    [A, b] = lgs_assembler(model, discr_i, last_inner, last_dirichlet);
    c = A\b;
    grid_width_temp = 50;
    X = linspace(-1, 1, grid_width_temp);
    Y = linspace(-1, 1, grid_width_temp);
    R = zeros(grid_width_temp, grid_width_temp);
    S = zeros(grid_width_temp, grid_width_temp);
    for k = 1:grid_width_temp
        for j = 1:grid_width_temp
        R(k,j) = sum(c .* discr_i.eval([X(k), Y(j)]));
         S(k,j) = model.solution([X(k), Y(j)]);
         if k > grid_width_temp/2 && j > grid_width_temp/2
                R(k,j) = 0;
                S(k,j) = 0;
         end
        end
    end
    disp(i);
    L2_array(i) = sqrt(sum(sum((R-S).^2))/(grid_width_temp*grid_width_temp*3/4));
    Linf_array(i) = max(max(abs(R-S)));
end

plot(linspace(0.001,0.1,100), L2_array, 'b', linspace(0.001,0.1,100), Linf_array, 'r');
ylim([0 2]);


function [A, b] = lgs_assembler(model, discr, last_inner, last_dirichlet)
A = zeros(length(discr.Xh),length(discr.Xh_strich));
for i = 1:last_inner
    temp_func = @(x)(model.diffusivity(x) * discr.grad(discr.eval, x));
    A(i,:) = -discr.div(temp_func, discr.Xh_strich(i,:));
end
for i = last_inner+1:last_dirichlet
    A(i,:) = discr.eval(discr.Xh_strich(i,:));
end
for i = last_dirichlet+1:length(discr.Xh_strich)
    temp = discr.grad(discr.eval, discr.Xh_strich(i,:)).*model.normals(discr.Xh_strich(i,:));
    A(i,:) = model.diffusivity(discr.Xh_strich(i,:))*(temp(:,1)+temp(:,2));
end
b1 = model.source(discr.Xh_strich(1:last_inner,:));
b2 = model.dirichlet_values(discr.Xh_strich(last_inner+1:last_dirichlet,:));
b3 = model.neumann_values(discr.Xh_strich(last_dirichlet+1:end,:));
b = [b1; b2; b3];
end

function [sorted_list, last_inner, last_dirichlet] = point_sorter(glob, model)
case_array = model.boundary_type(glob);
last_inner = length(glob(case_array==0));
last_dirichlet = length(glob(case_array==-1)) + last_inner;
sorted_list = [glob(case_array==0,:); glob(case_array==-1,:); glob(case_array==-2,:)];
end