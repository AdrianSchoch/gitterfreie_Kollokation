function [A, b] = lgs_assembler(model, discr)
case_array = model.boundary_type(discr.Xh_strich);
last_inner = length(discr.Xh_strich(case_array==0));
last_dirichlet = length(discr.Xh_strich(case_array==-1)) + last_inner;
glob = [discr.Xh_strich(case_array==0,:); discr.Xh_strich(case_array==-1,:); discr.Xh_strich(case_array==-2,:)];
A = zeros(length(discr.Xh),length(glob));
for i = 1:last_inner
    temp_func = @(x)(model.diffusivity(x) * discr.grad(discr.eval, x));
    A(i,:) = -discr.div(temp_func, glob(i,:));
end
for i = last_inner+1:last_dirichlet
    A(i,:) = discr.eval(glob(i,:));
end
for i = last_dirichlet+1:length(glob)
    temp = discr.grad(discr.eval, glob(i,:)).*model.normals(glob(i,:));
    A(i,:) = model.diffusivity(glob(i,:))*(temp(:,1)+temp(:,2));
end
b1 = model.source(glob(1:last_inner,:));
b2 = model.dirichlet_values(glob(last_inner+1:last_dirichlet,:));
b3 = model.neumann_values(glob(last_dirichlet+1:end,:));
b = [b1; b2; b3];