function discr = diskretisierung(n, m)
discr.Xh = random_center(n, m);
discr.Xh_strich = discr.Xh;
discr.gamma = 1;
discr.last_inner = n;
discr.last_dirichlet = n+m;
discr.size = n+m;