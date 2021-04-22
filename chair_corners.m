global N;
global E;

N = [1.000000 1.000000 2.014852
     1.000000 1.000000 0.014852
     1.000000 -1.000000 2.014852
     1.000000 -1.000000 0.014852
     -1.000000 1.000000 2.014852
     -1.000000 1.000000 0.014852
     -1.000000 -1.000000 2.014852
     -1.000000 -1.000000 0.014852
     0.991815 0.981793 3.632980
     0.991815 -1.018207 3.632980
     -1.008185 0.981793 3.632980
     -1.008185 -1.018207 3.632980];

 
% Kobler sammen noder for å få struktur
E = [1 2
     8 7
     3 4
     5 6
     3 7
     1 3
     7 5
     5 1
     10 12
     9 10
     12 11
     11 9
     1 9
     11 5
     7 12
     10 3
     3 9
     2 3
     2 5
     1 11
     3 11
     7 10
     4 7
     5 8
     7 11
     7 9
     1 8];


% Spesifiserer arealtverrsnitt og stivhet for E
radius = 0.003;       % Meter
E(:,3) = pi*radius^2;  % Arealer


figure(1);clf;plotMesh(N,E,'txt'); % Opprinnelig mesh


coStruct = [];         % Lager corner strukt for å samle alle instillinger
coStruct.wallT = 2;    % mm, hjørne veggtykkelse
coStruct.holeLng = 10; % mm, dybde på hull i plasten
coStruct.Epri = [1     % Edge prioritets liste for avstand til noden
                 2
                 3
                 4
                 5
                 6
                 7
                 8
                 9
                 10
                 11
                 12]; 

coStruct.iFilletR = 0;        % Avrunding av indre kanter i voksler, tar tid, kan droppes ved å sette til 0
coStruct.oFilletR = 0;        % Avrunding av ytre kanter i voksler, tar tid, kan droppes ved å sette til 0    
coStruct.suportRadius = 15;   % Bredden på supportvegg under rør i voksler,  hvis = 0, ingen support
coStruct.minSuportAng = 80;   % Grader
coStruct.rotaType = 1;        % 1: gir max min edge vinkler mot XY planet (godt hulltak). 2: legger ned 2 edger i XY planet
coStruct.layerThickness = 0.2;% Oppgitt i mm, for printeren, gir vox sidekant dim
vGdim = 500;                  % Størrelse på vG rommet der hjørnet blir laget, må være stort nok, men ikke for stort (tregt)
                              % (Ingen forhåndssjekk på om det er stort nok)


% Lager første hjørne
vG = zeros(vGdim, vGdim, vGdim, 'int8');
nodeNr = 1; % Noden vi lager hjørne rundt
[vG, Ecut] = mesh2voxCorner(vG, N, E, nodeNr, coStruct);
figure(2); clf;plotVg_safe(vG, 'edgeOff');
plotVgBoundingBox(vG); % Sjekker om størrelsen på vG er fornuftig
EcutTotal(:,1) = Ecut;  % Avkortning mot hjørnet på alle edger, samles i 2d array

% Runder av hjørner og lager STL for hjørne 1
[F,V] = vox2quadPoly(vG);
[V] = smoothQuadVertex(F,V);
[V] = smoothQuadVertex(F,V); % Runder av enda engang
[fTri]= quadPoly2triPoly(F);
triPoly2stl(fTri,V, 'stol1.stl', .1);