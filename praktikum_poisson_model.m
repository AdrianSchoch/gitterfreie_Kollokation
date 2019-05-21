function model = praktikum_poisson_model(params);
%function model = praktikum_poisson_model(params)
%
% small example of a model, i.e. a structure describing the data
% functions and geometry information of a general elliptic equation consisting 
% of diffusion, convection, reaction equation:
%
% - div ( a(x) grad u(x)) + div (b(x) u(x)) + c(x) u(x) = f(x)    on Omega
%                                                 u(x)) = g_D(x)  on Gamma_D
%                                       a(x) grad u(x)) = g_N(x)  on Gamma_N
% 
%  Here, we denote the functions as
%                   u: solution (if known, useful for validation purpose)
%                   f: source
%                   a: diffusivity
%                   b: velocity
%                   c: reaction
%                 g_D: Dirichlet boundary values
%                 g_N: Neumann boundary values
%
% Each function allows the evaluation in many points
% simultaneuously by
%
%        model.source(glob)
% or     model.source(glob,params)
%
% where glob is a n times 2 matrix of row-wise points. The result
% is a n times 1 vector of resulting values of f.
%
% additionally, the model has a function, which determines, whether
% a point lies on a Dirichlet or Neumann boundary:
%        
%           model.boundary_type(glob)
%                0 no boundary (inner edge or point)
%               -1 indicates Dirichlet-boundary
%               -2 indicates Neumann-boundary
%
% The data functions given in this model are the simple poisson
% equation with Gamma_D = boundary(Omega), Gamma_N = {}
%
%    -div (grad u) = f
%            u = 0   on   Gamma_D
%
% with exact solution u(x) = x_1(1-x_1)x_2(1-x_2), 
% i.e. f(x) = 2 (x_1 + x_2 - x_1^2 - x_2^2)
%
% params is an optional parameter, which allows to select either
% all dirichlet boundary or mixed boundary setting. In the latter
% case, one edge of the domain is set to Neumann-data

% B. Haasdonk 23.11.2010

model = [];

if nargin<1
  params = [];
end;

% check if user wants to have pure dirichlet boundary:
if ~isfield(params,'all_dirichlet_boundary')
  params.all_dirichlet_boundary = 1;
end;

% solution is known for debugging and error analysis 
model.solution = @(glob,params) ...
    glob(:,1).*(1-glob(:,1)).*glob(:,2).*(1-glob(:,2));
ds = 1e-5;
model.solution_gradient = @(glob,params) ...
    [(model.solution(glob+repmat([ds/2,0],size(glob,1),1))-...
     model.solution(glob-repmat([ds/2,0],size(glob,1),1)))/ds,...
     (model.solution(glob+repmat([0,ds/2],size(glob,1),1))-...
      model.solution(glob-repmat([0,ds/2],size(glob,1),1)))/ds];

% params is an optional parameter, perhaps useful later
model.source = @(glob,params) ...
            2 * (glob(:,1)+ glob(:,2)- glob(:,1).^2 - glob(:,2).^2);
model.reaction = @(glob,params) zeros(size(glob,1),1);
model.velocity = @(glob,params) zeros(size(glob,1),1);
model.diffusivity = @(glob,params) ones(size(glob,1),1);
model.diffusivity_gradient = @(glob,params) zeros(size(glob,1),2);

model.reaction = @(glob,params) zeros(size(glob,1),1);

%  Dirichlet everywhere or mixed, see functions below.
model.boundary_type = @mixed_boundary_type;
if params.all_dirichlet_boundary
  model.boundary_type = @all_dirichlet_boundary_type;
end;
model.dirichlet_values = @(glob,params) zeros(size(glob,1),1);
model.normals = @my_normals;
model.neumann_values = @(glob,params) ... 
    model.diffusivity(glob).*...
    sum(model.solution_gradient(glob).*model.normals(glob),2);

% all edges of unit square are dirichlet, other inner
function res = all_dirichlet_boundary_type(glob,params)
res = zeros(size(glob,1),1);
i  = find(glob(:,1)<=1e-10);
i  = [i, find(glob(:,1)>=1-1e-10)];
i  = [i, find(glob(:,2)<=1e-10)];
i  = [i, find(glob(:,2)>=1-1e-10)];
res(i) = -1;

function res = mixed_boundary_type(glob,params)
res = zeros(size(glob,1),1);
i  = find(glob(:,1)<=1e-10);
res(i) = -1;
i  = find(glob(:,1)>=1-1e-10);
res(i) = -1;
i  = find(glob(:,2)<=1e-10);
res(i) = -1;
i  = find(glob(:,2)>=1-1e-10);
res(i) = -2;

function res = my_normals(glob,params);
res = zeros(size(glob,1),2); % each row one normal
i  = find(glob(:,1)>1-1e-10);
res(i,1)= 1.0;
i  = find(glob(:,1)<-1+1e-10);
res(i,1)= -1.0;
i  = find(glob(:,2)>1-1e-10);
res(i,2)= 1.0;
i  = find(glob(:,2)<-1+1e-10);
res(i,2)= -1.0;
% remove diagonal normals
i = find (sum(abs(res),2)>1.5);
res(i,1)= 0;