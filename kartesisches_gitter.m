%Dieses Programm verteilt Punkte gleichmäßig als Gitter im Inneren des
%Gebietes, sodass der Abstand zweier benachbarter Punkte im Inneren 1/n
%beträgt, außerdem werden m Punkte gleichmäßig auf dem Rnd verteilt.
%Tipp: wählt man m= 8*n so wird das Gitter auf dem Rand fortgesetzt.


function glob = kartesisches_gitter(n,m) 
glob = [cartesiangrid_inner_1(n);cartesiangrid_inner_2(n);...
        cartesiangrid_inner_3(n);cartesiangrid_boundary(m)];

%DieserTeil des Programms verteilt m Punkte gleichmäßig auf dem Rand 
%des Gebietes. Dazu teilt das Programm das Intervall [0,8-k]
%in m Teile ein und bestimmt dann für die jeweiligen Zahlen genau wie in
%random_center die Koordinaten des Punktes.
%Dabei teilt man nur das Intervall [0,8-k] ein, da für 8 der gleiche Punkt
%herauskommen würde wie für 0, und dieser dann doppelt vertreten wäre.
function [rec] = cartesiangrid_boundary(m)
k = 8/m;
A=linspace(0,8-k,m);
fc = @firstcoordinate;
sc = @secondcoordinate;
B = arrayfun(fc,A);
C = arrayfun(sc,A);
rec = [B.',C.'];
end

function [x] = firstcoordinate(k)
if 0 <= k & k< 2
    x = k-1;
elseif 2 <= k & k < 3
    x = 1;
elseif 3 <= k & k < 4
    x = 4-k;
elseif 4 <= k & k < 5
    x = 0;
elseif 5 <= k & k < 6
    x = 5-k;
elseif 6 <= k & k <= 8
    x = -1;
end
end

function [y] = secondcoordinate(k)
if 0 <= k & k < 2
    y = -1;
elseif 2 <= k & k < 3
    y = k-3;
elseif 3 <= k & k < 4
    y = 0;
elseif 4 <= k & k < 5
    y = k-4;
elseif 5 <= k & k < 6
    y = 1;
elseif 6 <= k & k <= 8
    y = 7-k;
end
end
%Bis hierhin haben wir nur die Punkte auf dem Rand verteilt. Nun kommen die
%inneren Punkte dran.
function res =cartesiangrid_inner_1(n)
    %Nun zum ersten Teilquadrat
    n=n-1;
    x1 = linspace(-1,0,n+2);
    y1 = linspace(0,1,n+2);
    x1 = x1(2:end-1);
    y1 = y1(1:end-1);
    [X1,Y1] = meshgrid(x1,y1);
    res = zeros(n*(n+1),2);
    for i=1:(n*(n+1))
        res(i,1)= X1(i);
        res(i,2)= Y1(i);
    end
end
%zweites Teilquadrat
function res =cartesiangrid_inner_2(n)
    n=n-1;
    x2 = linspace(-1,0,n+2);
    y2 = linspace(-1,0,n+2);
    x2 = x2(2:end-1);
    y2 = y2(2:end-1);
    [X2,Y2] = meshgrid(x2,y2);
    res = zeros((n*(n+1))-n,2);
    for i=1:(n*(n+1))-n
        res(i,1)= X2(i);
        res(i,2)= Y2(i);
    end
end
%drittes Teilquadrat
function res =cartesiangrid_inner_3(n)
    n=n-1;
    x3 = linspace(0,1,n+2);
    y3 = linspace(-1,0,n+2);
    x3 = x3(1:end-1);
    y3 = y3(2:end-1);
    [X3,Y3] = meshgrid(x3,y3);
    res = zeros(n*(n+1),2);
    for i=1:(n*(n+1))
        res(i,1)= X3(i);
        res(i,2)= Y3(i);
    end
end

end

