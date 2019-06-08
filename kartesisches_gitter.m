%Dieses Programm verteilt Punkte gleichmäßig als Gitter im Inneren des
%Gebietes, sodass der Abstand zweier benachbarter Punkte im Inneren 1/n
%beträgt, außerdem werden m Punkte gleichmäßig auf dem Rnd verteilt.
%Tipp: wählt man m= 8*n so wird das Gitter auf dem Rand fortgesetzt.


function glob = kartesisches_gitter(n, m, model)
glob = [cartesiangrid_inner(n, model); cartesiangrid_boundary(m, model)];

%DieserTeil des Programms verteilt m Punkte gleichmäßig auf dem Rand 
%des Gebietes. Dazu teilt das Programm das Intervall [0,8-k]
%in m Teile ein und bestimmt dann für die jeweiligen Zahlen genau wie in
%random_center die Koordinaten des Punktes.
%Dabei teilt man nur das Intervall [0,8-k] ein, da für 8 der gleiche Punkt
%herauskommen würde wie für 0, und dieser dann doppelt vertreten wäre.
function [rec] = cartesiangrid_boundary(m, model)
if model.area_type == 0
    k = 4/m;
    A=linspace(0,4-k,m);
    B = arrayfun(@firstcoordinate_1,A);
    C = arrayfun(@secondcoordinate_1,A);
    rec = [B.',C.'];
elseif model.area_type == -1
    k = 8/m;
    A=linspace(0,8-k,m);
    B = arrayfun(@firstcoordinate_2,A);
    C = arrayfun(@secondcoordinate_2,A);
    rec = [B.',C.'];
end
end

function [x] = firstcoordinate_2(k)
switch floor(k)
    case 0
        x = k-1;
    case 1
        x = k-1;
    case 2
        x = 1;
    case 3
        x = 4-k;
    case 4
        x = 0;
    case 5
        x = 5-k;
    case 6
        x = -1;
    case 7
        x = -1;
end
end

function [y] = secondcoordinate_2(k)
switch floor(k)
    case 0
        y = -1;
    case 1
        y = -1;
    case 2
        y = k-3;
    case 3
        y = 0;
    case 4
        y = k-4;
    case 5
        y = 1;
    case 6
        y = 7-k;
    case 7
        y = 7-k;
end
end

function [x] = firstcoordinate_1(k)
switch floor(k)
    case 0
        x = 2*k-1;
    case 1
        x = 1;
    case 2
        x = 5-2*k;
    case 3
        x = -1;
end
end

function [y] = secondcoordinate_1(k)
switch floor(k)
    case 0
        y = -1;
    case 1
        y = 2*k-3;
    case 2
        y = 1;
    case 3
        y = 7-2*k;
end
end
%Bis hierhin haben wir nur die Punkte auf dem Rand verteilt. Nun kommen die
%inneren Punkte dran.
function res = cartesiangrid_inner(n, model)
if model.area_type == 0
    res = cartesiangrid_inner_0(n);
elseif model.area_type == -1
    res = [cartesiangrid_inner_1(n); cartesiangrid_inner_2(n); cartesiangrid_inner_3(n)];
end
end

%Nun zum ersten Teilquadrat
function res =cartesiangrid_inner_1(n)
    n = round(sqrt(n/3));
    x1 = linspace(-1,0,n+2);
    y1 = linspace(0,1,n+2);
    x1 = x1(2:end-1);
    y1 = y1(1:end-1);
    res = [reshape(repmat(x1,length(y1),1),[length(x1)*length(y1),1]), repmat(y1,1,length(x1)).'];
end
%zweites Teilquadrat
function res =cartesiangrid_inner_2(n)
    n = round(sqrt(n/3));
    x2 = linspace(-1,0,n+2);
    y2 = linspace(-1,0,n+2);
    x2 = x2(2:end-1);
    y2 = y2(2:end-1);
    res = [reshape(repmat(x2,length(y2),1),[length(x2)*length(y2),1]), repmat(y2,1,length(x2)).'];
end
%drittes Teilquadrat
function res =cartesiangrid_inner_3(n)
    n = round(sqrt(n/3));
    x3 = linspace(0,1,n+2);
    y3 = linspace(-1,0,n+2);
    x3 = x3(1:end-1);
    y3 = y3(2:end-1);
    res = [reshape(repmat(x3,length(y3),1),[length(x3)*length(y3),1]), repmat(y3,1,length(x3)).'];
end

function res = cartesiangrid_inner_0(n)
    x = linspace(-1,1,round(sqrt(n))+2);
    x = x(2:end-1);
    res = [reshape(repmat(x,length(x),1),[length(x)*length(x),1]), repmat(x,1,length(x)).'];
end
end

