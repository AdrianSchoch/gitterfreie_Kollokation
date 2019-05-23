function model = praktikum_elliptisch_model(params);
%function model = praktikum_elliptisch_model(params)
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
% with exact solution u(x) = exp(-(x_1-1)^2-(x_2-1)^2), 
% i.e. 
% f(x) = -2*exp(-(x_1-1)^2-(x_2-1)^2)*(2(x_1)^3+2*x_1*(x_2)^2 -4*x_1*x_2
% +4*(x_2)^2-7*(x_1)-8*(x_2)+5 
%
% 
model = [];

% Falls keine Parameter angegeben werden, sind params die leere Menge
if nargin<1
  params = [];
end;

% Überprüfen, ob der Rand ein reiner Dirichletrand sein soll
if ~isfield(params,'all_dirichlet_boundary')
  params.all_dirichlet_boundary = 1;
end;

% Anlegen der Lösungsfunktion für Fehlerberechnungen oder Ahnliches
 model.solution = @(glob,params) ...
     exp(-(glob(:,1)-1).^2 -(glob(:,2)-1).^2);
% Bestimmen des Gradienten mithilfe des Differenzenquotienten 
 ds = 1e-5;
 model.solution_gradient = @(glob,params)...
     [(model.solution(glob+repmat([ds/2,0],size(glob,1),1))-...
     model.solution(glob-repmat([ds/2,0],size(glob,1),1)))/ds,...
     (model.solution(glob+repmat([0,ds/2],size(glob,1),1))-...
      model.solution(glob-repmat([0,ds/2],size(glob,1),1)))/ds];
% Anlegen aller nötigen Funktionen
model.source= @(glob,params)...
    -2*exp(-(glob(:,1)-1).^2 -(glob(:,2)-1).^2)*(2*(glob(:,1)).^3 ...
    +2*(glob(:,1)).*(glob(:,2)).^2 ...
    -4*(glob(:,1)).*(glob(:,2)) ... 
    +4*(x_2).^2 ...
    -7*(glob(:,1))-8*(glob(:,2))+5);
model.reaction = @(glob,params) zeros(size(glob,1),1);
model.velocity = @(glob,params) zeros(size(glob,1),1);
model.diffusivity = @(glob,params) glob(:,1)+2;
model.diffusivity_gradient= @(glob,params)...
    [(model.diffusivity(glob+repmat([ds/2,0],size(glob,1),1))-...
     model.diffusivity(glob-repmat([ds/2,0],size(glob,1),1)))/ds,...
     zeros(size(glob,1),1)];
% Die Ableitung der zwiten Koordinate ist konstant 0, da die Diffusivität
% unabhängig von x_2 ist
%Soweit so gut, nun kommt noch die ganze Randgeschichte....