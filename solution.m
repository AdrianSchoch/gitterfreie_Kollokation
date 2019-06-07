n = 200;
m = 100;
model = praktikum_elliptisch_model(0.5);
discr = diskretisierung(n, m, -1, model);

[glob, last_inner, last_dirichlet] = point_sorter(discr.Xh_strich, model);
disp(length(glob))
% disp(last_inner);
% disp(last_dirichlet);

figure(1)
plot(glob(1:last_inner, 1), glob(1:last_inner, 2), 'r.');
hold on
plot(glob(last_inner+1:last_dirichlet,1), glob(last_inner+1:last_dirichlet,2), 'b.');
hold on
plot(glob(last_dirichlet+1:end,1), glob(last_dirichlet+1:end,2), 'g.');

[A, b] = lgs_assembler(model, discr, last_inner, last_dirichlet);
c = A\b;

grid_width_temp = 100;
X = linspace(-1, 1, grid_width_temp);
Y = linspace(-1, 1, grid_width_temp);
R = zeros(grid_width_temp, grid_width_temp);
S = zeros(grid_width_temp, grid_width_temp);
for i = 1:grid_width_temp
    for j = 1:grid_width_temp
        R(i,j) = sum(c .* discr.eval([X(i), Y(j)]));
        S(i,j) = model.solution([X(i), Y(j)]);
        if i > 50 & j > 50
            R(i,j) = 0;
            S(i,j) = 0;
        end
    end
end
disp(abs(sum(sum(R-S))/(grid_width_temp*grid_width_temp*3/4)))
figure(2)
surf(X,Y,R);
figure(3)
surf(X,Y,S);
figure(4)
surf(X,Y,abs(R-S));


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