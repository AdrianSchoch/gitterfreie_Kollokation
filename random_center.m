% Konstruktionsidee:
% Für die Konstruktion von Ansatzzentren als zufällige Punkte, die
% im Inneren und auf dem Rand des Gebietes Omega liegen,
% konstruieren wir eine Funktion random_center mit zwei Variabeln als
% Input, wobei der erste Variabel die gewünschte Anzahl der inneren Punkte 
% und der zweite Variabel die gewünschte Anzahl der Randpunkte ist.

% Funktionsweise von random_center:
% Die Funktion random_center konstruiert für einen Input (n,m) 
% eine (n+m,2)-Matrix C = [A ; B]. Dabei ist A eine durch die Funktion
% random_inner_center erzeugte (nx2)-Matrix und wird als die Menge der
% zufällig genierten Punkte im Inneren von Omega interprtiert.
% Analog ist B eine durch die Funktion random_edge_center(m) erzeugte
% (mx2)-Matrix und wird als Menge der auf dem Rand von Omege zufällig
% genierten Punkte interpretiert. Dabei wird die erste Spalte als
% die x-Koordinate und die zweite Spalte als y-Koordinate interpretiert.

function [C] = random_center(n, m, model)
C = [random_inner_center(n, model); random_edge_center(m, model)];
end

% Funktionsweise von random_inner_center:
% Bei einer Eingabe von n werden jeweils n Punkte im zweiten, dritten und
% vierten Quadranten erzeugt.

function [ric] = random_inner_center(n, model)
if model.area_type == 0
    ric = [-1+2*rand(n,1), -1+2*rand(n,1)];
elseif model.area_type == -1
    n = round(n/3);
    v_1 = -1 + rand(n,1);
    v_2 = rand(n,1);
    v_3 = -1 + rand(n,1);
    v_4 = -1 + rand(n,1);
    v_5 = rand(n,1);
    v_6 = -1 + rand(n,1);
    ric = [v_1, v_2; v_3, v_4; v_5, v_6 ];
end
end

% Funktionsweise von random_edge_center:
% Wir wollen $m$ zufällige Punkte auf dem Rand von Omega. Wir
% interpretieren den Rand des Gebietes Omega als das Intervall [0,8).
% Zunächst wird eine (mx1)-Matrix A konstruiert, wobei jedes ihrer
% Einträge eine zufällige Zahl in [0,8) ist. Die Funktionen
% firstcoordinate und secondcoordinate ordnen dann jeder Zahl
% die entsprechenden Koordinaten seines auf dem Rand von Omega liegenden
% korrespondieren Punktes zu. Die Vektoren B und C sind die punktweise
% Anwendung der Funktionen auf jeden Eintrag von A. Schließlich
% müssen sie nur noch zusammengesetzt werden.

function [rec] = random_edge_center(m, model)
if model.area_type == 0
    A = 4.*rand(m,1);
    B = arrayfun(@firstcoordinate_1,A);
    C = arrayfun(@secondcoordinate_1,A);
    rec = [B,C];
elseif model.area_type == -1
    A = 8.*rand(m,1);
    B = arrayfun(@firstcoordinate_2,A);
    C = arrayfun(@secondcoordinate_2,A);
    rec = [B,C];
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
