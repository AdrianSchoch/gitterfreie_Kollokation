n = 200;
m = 200;
model = praktikum_elliptisch_model(0.5);
discr = diskretisierung(n, m, 0, model, 1);

case_array = model.boundary_type(discr.Xh_strich);
last_inner = length(discr.Xh_strich(case_array==0));
last_dirichlet = length(discr.Xh_strich(case_array==-1)) + last_inner;
glob = [discr.Xh_strich(case_array==0,:); discr.Xh_strich(case_array==-1,:); discr.Xh_strich(case_array==-2,:)];
figure(1)
plot(glob(1:last_inner, 1), glob(1:last_inner, 2), 'r.');
hold on
plot(glob(last_inner+1:last_dirichlet,1), glob(last_inner+1:last_dirichlet,2), 'b.');
hold on
plot(glob(last_dirichlet+1:end,1), glob(last_dirichlet+1:end,2), 'g.');

[A, b] = lgs_assembler(model, discr);
c = A\b;

grid_width_temp = 100;

X = linspace(-1, 1, grid_width_temp);
Y = linspace(-1, 1, grid_width_temp);
R = zeros(grid_width_temp, grid_width_temp);
S = zeros(grid_width_temp, grid_width_temp);
for k = 1:grid_width_temp
    for j = 1:grid_width_temp
        if k > grid_width_temp/2 && j > grid_width_temp/2
            R(k,j) = 0;
            S(k,j) = 0;
        else
            R(k,j) = sum(c .* discr.eval([X(k), Y(j)]));
            S(k,j) = model.solution([X(k), Y(j)]);
        end
    end
end

% L1_error = abs(sum(sum(R-S))/(grid_width_temp*grid_width_temp*3/4));
% disp("L_1-Norm = " + num2str(L1_error))
L2_error = sqrt(sum(sum((R-S).^2))/(grid_width_temp*grid_width_temp*3/4));
disp("L_2-Norm = " + num2str(L2_error))
Linf_error = max(max(abs(R-S)));
disp("L_unendlich-Norm = " + num2str(Linf_error))
figure(2)
surf(X,Y,R);
figure(3)
surf(X,Y,S);
figure(4)
surf(X,Y,abs(R-S));

% L2_array = zeros(100,1);
% Linf_array = zeros(100,1);
% for i = 1:100
%     discr_i = diskretisierung(n, m, -1, model, 0.001*i);
%     [A, b] = lgs_assembler(model, discr_i);
%     c = A\b;
%     grid_width_temp = 50;
%     X = linspace(-1, 1, grid_width_temp);
%     Y = linspace(-1, 1, grid_width_temp);
%     R = zeros(grid_width_temp, grid_width_temp);
%     S = zeros(grid_width_temp, grid_width_temp);
%     for k = 1:grid_width_temp
%         for j = 1:grid_width_temp
%         R(k,j) = sum(c .* discr_i.eval([X(k), Y(j)]));
%          S(k,j) = model.solution([X(k), Y(j)]);
%          if k > grid_width_temp/2 && j > grid_width_temp/2
%                 R(k,j) = 0;
%                 S(k,j) = 0;
%          end
%         end
%     end
%     disp(i);
%     L2_array(i) = sqrt(sum(sum((R-S).^2))/(grid_width_temp*grid_width_temp*3/4));
%     Linf_array(i) = max(max(abs(R-S)));
% end
% 
% plot(linspace(0.001,0.1,100), L2_array, 'b', linspace(0.001,0.1,100), Linf_array, 'r');
% ylim([0 2]);