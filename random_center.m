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

function [C] = random_center(n,m)
A = random_inner_center(n);
B = random_edge_center(m);
C = [A ; B];
end

% Funktionsweise von random_inner_center:
% Wir wollen n zufällige Punkte im Inneren von Omega.
% Zunächst konstruieren wir mit firstcoordinatevector eine
% (nx1)-Matrix v_1 mit zufälligen Einträgen im Intervall [-1,1].
% Ein solcher Eintrag wird als die erste Koordinate eines Punktes
% interpretiert. Durch die Anwendung der Funktion inner_y_coordinate
% auf jeden Eintrag (mittels des Befehls arrayfun) konstruieren wir eine
% zweite (nx1)-Matrix v_2. Jedes ihrer zufälligen Einträge wird als 
% y-Koordinate interpretiert (bei der Konstruktion von
% inner_y_coordinate wurde darauf geachtet, dass sich die Punkte im
% Inneren von Omega befinden). Schließlich werden v_1 und v_2 zu einer
% Matrix zusammmengesetzt.

function [ric] = random_inner_center(n)
v_1 = -1 + 2.*rand(n,1);
v_2 = arrayfun(@inner_y_coordinate,v_1);
ric = [v_1, v_2];
end


function [l] = inner_y_coordinate(x)
if -1 < x && x < 0
    l = -1 + 2.*rand(1,1);
elseif 0 <= x && x < 1
    l = -1 + rand(1,1);
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

function [rec] = random_edge_center(m)
A = 8.*rand(m,1);
B = arrayfun(@firstcoordinate,A);
C = arrayfun(@secondcoordinate,A);
rec = [B,C];
end

function [x] = firstcoordinate(k)
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

function [y] = secondcoordinate(k)
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