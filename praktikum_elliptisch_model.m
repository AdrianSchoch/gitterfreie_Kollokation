function model = praktikum_elliptisch_model(beta,params);
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

%Falls Beta=0 ist, so ist der Rand ein reiner Dirichletrand 
%Umsetzung noch nicht klar
%Mit if probieren, sodass if Beta<= 1e-10, dann all_dirichlet_boundary_type
%ausführen, sonst mixed_boundary_type

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
    -2*exp(-(glob(:,1)-1).^2 -(glob(:,2)-1).^2).*(2*(glob(:,1)).^3 ...
    +2*(glob(:,1)).*(glob(:,2)).^2 ...
    -4*(glob(:,1)).*(glob(:,2)) ... 
    +4*(glob(:,2)).^2 ...
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
model.dirichlet_values= @(glob,params)...
    exp(-(glob(:,1)-1).^2 -(glob(:,2)-1).^2);
model.neumann_values= @(glob,params)...
    2*(2 + glob(:,1)).* exp(-(glob(:,1)-1).^2 -(glob(:,2)-1).^2);
    
%Nun die Funktion, die für einen Punkt entscheidet, ob er auf dem Rand 
%liegt, und wenn ja auf welchem Rand.

model.boundary_type = @mixed_boundary_type;
if beta <=1e-10
  model.boundary_type = @all_dirichlet_boundary_type;
end;
model.normals = @my_normals;


%Es gibt nur den Dirichletrand, also Beta=0
function res = all_dirichlet_boundary_type(glob,params)
res = zeros(size(glob,1),1);
%rechte und linke Kante
i  = find(glob(:,1)<=-1+1e-10);
res(i) = -1;
i  = find(glob(:,1)>=1-1e-10);
res(i) = -1;
%obere und untere Kante
i  = find(glob(:,2)<=-1+1e-10);
res(i) = -1;
i  = find(glob(:,2)>=1-1e-10);
res(i) = -1;
%mittlere x-Kante
i  = find(glob(:,2)>=-1e-10 & glob(:,2)<=1e-10 & glob(:,1)>=-1e-10);
res(i) = -1;
%mittlere y-Kante
i  = find(glob(:,1)>=-1e-10 & glob(:,1)<=1e-10 & glob(:,2)>=-1e-10);
res(i) = -1;
end

%Es gibt auch Neumannrand, also 1>Beta>0 
function res = mixed_boundary_type(glob,params)
res = zeros(size(glob,1),1);
%rechte und linke Kante 
i  = find(glob(:,1)<=-1+1e-10);
res(i) = -1;
i  = find(glob(:,1)>=1-1e-10);
res(i) = -1;
%obere und untere Kante des L's
i  = find(glob(:,2)<= -1+1e-10);
res(i) = -1;
i  = find(glob(:,2)>= 1-1e-10);
res(i) = -1;
%mittlere x-Kante
i  = find(glob(:,2)>=-1e-10 & glob(:,2)<=1e-10 & glob(:,1)>=-1e-10 & ...
     glob(:,1)<=beta);
res(i) = -2;
i =  find(glob(:,2)>=-1e-10 & glob(:,2)<=1e-10 & glob(:,1)>beta);
res(i) = -1;
%mittlere y-Kante
i  = find(glob(:,1)>=-1e-10 & glob(:,1)<=1e-10 & glob(:,2)>=-1e-10 & ...
    glob(:,1)<=beta);
res(i) = -2;
i =  find(glob(:,1)>=-1e-10 & glob(:,1)<=1e-10 & glob(:,2)>beta);
res(i) = -1;
end

%Nun die noch die normals Funktion 

function res = my_normals(glob,params);
res = zeros(size(glob,1),2); % each row one normal
%rechte und linke Kante erster Eintrag 
i  = find(glob(:,1)<=-1+1e-10);
res(i,1) = -1;
i  = find(glob(:,1)>=1-1e-10);
res(i,1) = 1;
%obere und untere Kante des L's
i  = find(glob(:,2)<= -1+1e-10);
res(i,2) = -1;
i  = find(glob(:,2)>= 1-1e-10);
res(i,2) = 1;
%mittlere x-Kante
i  = find(glob(:,2)>=-1e-10 & glob(:,2)<=1e-10 & glob(:,1)>=-1e-10);
res(i,2) = 1;
%mittlere y-Kante
i  = find(glob(:,1)>=-1e-10 & glob(:,1)<=1e-10 & glob(:,2)>=-1e-10);
res(i,1) = 1;
% remove diagonal normals
i = find (sum(abs(res),2)>1.5);
res(i,1)= 0;
end

end


