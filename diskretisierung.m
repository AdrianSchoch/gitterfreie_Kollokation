function discr = diskretisierung(n, m, type)
if type == 0
    discr.Xh = random_center(n, m);
    discr.Xh_strich = discr.Xh;
elseif type == -1
        discr.Xh = kartesisches_gitter(n,m);
        discr.Xh_strich = discr.Xh;
end

discr.gamma = 0.01;
discr.ds = 1e-5;
discr.grad = @gradient;
discr.div = @divergence;
discr.eval = @evaluation;

    function res = gradient(f, x)
        res = [(f(x+[discr.ds/2,0])-f(x-[discr.ds/2,0]))/discr.ds,(f(x+[0,discr.ds/2])-f(x-[0,discr.ds/2]))/discr.ds];
    end
    function res = divergence(f, x)
        temp1 = f(x+[discr.ds/2, 0]);
        temp2 = f(x-[discr.ds/2,0]);
        temp3 = f(x+[0,discr.ds/2]);
        temp4 = f(x-[0,discr.ds/2]);
        res = (temp1(:,1)-temp2(:,1))/discr.ds+(temp3(:,2)-temp4(:,2))/discr.ds;
    end
    function res = evaluation(x)
        res = exp(-discr.gamma *((x(1) - discr.Xh(:,1)).^2 + (x(2) - discr.Xh(:,2)).^2));
    end
end