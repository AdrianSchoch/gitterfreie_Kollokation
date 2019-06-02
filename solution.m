n = 500;
m = 200;
discr = diskretisierung(n, m);
model = praktikum_elliptisch_model(0.5);

[glob, last_inner, last_dirichlet] = point_sorter(discr.Xh_strich, model);
disp(last_inner);
disp(last_dirichlet);

plot(glob(1:last_inner, 1), glob(1:last_inner, 2), 'r.');
hold on
plot(glob(last_inner+1:last_dirichlet,1), glob(last_inner+1:last_dirichlet,2), 'b.');
hold on
plot(glob(last_dirichlet+1:end,1), glob(last_dirichlet+1:end,2), 'g.');

[A, b] = lgs_assembler(model, discr, last_inner, last_dirichlet);

function [A, b] = lgs_assembler(model, discr, last_inner, last_dirichlet)
A = zeros(length(discr.Xh),length(discr.Xh_strich));
for i = 1:last_inner
    TODO
end
for i = last_inner+1:last_dirichlet
    A(i,:) = discr.eval(discr.Xh_strich(i,:));
end
for i = last_dirichlet+1:length(discr.Xh_strich)
    A(i,:) = model.diffusivity(discr.Xh_strich(i,:))*discr.grad(discr.eval, discr.Xh_strich(i,:))*model.normals(discr.Xh_strich(i,:));
end
b1 = model.source(discr.Xh_strich(1:last_inner,:));
b2 = model.dirichlet_values(discr.Xh_strich(last_inner+1:last_dirichlet,:));
b3 = model.neumann_values(discr.Xh_strich(last_dirichlet+1:end,:));
b = [b1; b2; b3];
end

function [sorted_list, last_inner, last_dirichlet] = point_sorter(glob, model)
case_array = model.boundary_type(glob);
temp_inner = find(case_array==0);
temp_dirichlet = find(case_array==-1);
temp_neumann = find(case_array==-2);
%last_inner = size(temp_inner(1));
last_inner = length(temp_inner);
last_dirichlet = length(temp_dirichlet) + last_inner;
sorted_list = [glob(temp_inner,:); glob(temp_dirichlet,:); glob(temp_neumann,:)];
end