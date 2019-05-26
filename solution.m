n = 0;
m = 10;
discr = diskretisierung(n, m);
model = praktikum_poisson_model();

plot(discr.Xh(1:n, 1), discr.Xh(1:n, 2), 'r.');
hold on
plot(discr.Xh(n+1:end,1), discr.Xh(n+1:end,2), 'b.');

glob = discr.Xh_strich;

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
