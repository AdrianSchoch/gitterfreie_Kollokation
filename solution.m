n = 500;
m = 200;
discr = diskretisierung(n, m);
model = praktikum_poisson_model();

plot(discr.Xh(1:n, 1), discr.Xh(1:n, 2), 'r.');
hold on
plot(discr.Xh(n+1:end,1), discr.Xh(n+1:end,2), 'b.');

[glob, last_inner, last_dirichlet] = point_sorter(discr.Xh_strich, model);
glob

[A, b] = lgs_assembler(model, discr);

function res = evaluation(x, discr)
res = exp(-discr.gamma *((x(1) - discr.Xh(:,1)).^2 + (x(2) - discr.Xh(:,2)).^2));
end

function [A, b] = lgs_assembler(model, discr)
A = zeros(discr.size, discr.size);
for i = 1:discr.last_inner
    TODO
end
for i = discr.last_inner+1:discr.last_dirichlet
    A(i,:) = evaluation(discr.Xh_strich(i,:), discr);
end
for i = discr.last_dirichlet+1:discr.size
    TODO
end
b1 = model.source(discr.Xh_strich(1:discr.last_inner,:));
b2 = model.dirichlet_values(discr.Xh_strich(discr.last_inner+1:discr.last_dirichlet,:));
b3 = model.neumann_values(discr.Xh_strich(discr.last_dirichlet+1:end,:));
b = [b1; b2; b3];
end

function [sorted_list, last_inner, last_dirichlet] = point_sorter(glob, model)
temp_inner = [];
temp_dirichlet = [];
temp_neumann = [];
for x = glob
    switch model.boundary_type(x)
        case 0
            temp_inner.append(x)
        case -1
            temp_dirichlet.append(x)
        case -2
            temp_neumann.append(x)
    end
end
last_inner = size(temp_inner(1));
last_dirichlet = size(temp_dirichlet(1)) + last_inner;
sorted_list = [temp_inner; temp_dirichlet; temp_neumann];
end