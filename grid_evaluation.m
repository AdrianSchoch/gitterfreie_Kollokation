function [N, S, L1_error, L2_error, Linf_error] = grid_evaluation(grid_steps, c, discr, model)
X = linspace(-1, 1, grid_steps);
Y = linspace(-1, 1, grid_steps);
N = zeros(grid_steps, grid_steps);
S = zeros(grid_steps, grid_steps);
for k = 1:grid_steps
    for j = 1:grid_steps
        if k > grid_steps/2 && j > grid_steps/2
            N(k,j) = 0;
            S(k,j) = 0;
        else
            N(k,j) = sum(c .* discr.eval([X(k), Y(j)]));
            S(k,j) = model.solution([X(k), Y(j)]);
        end
    end
end
L1_error = abs(sum(sum(N-S))/(grid_steps*grid_steps*3/4));
L2_error = sqrt(sum(sum((N-S).^2))/(grid_steps*grid_steps*3/4));
Linf_error = max(max(abs(N-S)));