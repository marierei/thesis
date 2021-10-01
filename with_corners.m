M = [0 0 1
     1 1 -1
     1 -1 -1
     -1 1 -1
     -1 -1 -1]/40 + 0.05;

N = [1 1 1
     1 1 -1
     0.4 -0.8 -0.9
     -0.2 1.1 -1
     -1 -1 -1];

E = [4 5
     2 4
     1 2
     5 3
     3 2
     1 3
     1 5
     1 4];

 
 
 
rodRadius = 8.0e-3;
rodArea = pi*rodRadius^2;   % Tverrsnittareal
E(:,3) = rodArea;

figure(1);clf;plotMesh(E,N,'txt');

coStruct = [];  % Corner struct for å samle alle instillinger
coStruct.wallT = 2; % mm, gjørne veggtykkelse
coStruct.holeLng = 10;  % mm, dybde på hull i plasten
coStruct.Epri = [1  % Edgeprioritet
                 2
                 3
                 4
                 5
                 6
                 7
                 8];
coStruct.iFilletR = 0;  % Avrunding indre kanter, droppes settes til null
coStruct.oFilletR = 0;  % Ytre kanter
coStruct.suportRadius = 15; % Bredde supportvegg, droppes ved 0
coStruct.minSuportAng = 80; % Grader
coStruct.rotaType = 1;  % 1: max-min edgevinkler mot XY-planet, 2: legger ned 2 edger i XY-planet
coStruct.layerThickness = 0.2;  % I mm, printer, vix sidekant dim

vGdim = 1000;    % Størrelse på vG-rommet der hjørnene blir laget



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
triPoly2stl(fTri,V, 'poly1.stl', .1);


% Andre hjørne
vG = zeros(vGdim, vGdim, vGdim, 'int8');
nodeNr = 2;
[vG,Ecut] = mesh2voxCorner(vG, N, E, nodeNr, coStruct);
figure(3);clf;plotVg_safe(vG, 'edgeOff');
plotVgBoundingBox(vG);
EcutTotal(:,2) = Ecut;

% Runder av hjørner og lager STL for hjørne 2
[F,V] = vox2quadPoly(vG);
[V] = smoothQuadVertex(F,V);
[V] = smoothQuadVertex(F,V); % Runder av enda engang
[fTri]= quadPoly2triPoly(F);
triPoly2stl(fTri,V, 'poly2.stl', .1);


% Tredje hjørne
vG = zeros(vGdim, vGdim, vGdim, 'int8');
nodeNr = 3; 
[vG,Ecut] = mesh2voxCorner(vG, N, E, nodeNr, coStruct); 
figure(4);clf;plotVg_safe(vG, 'edgeOff');
plotVgBoundingBox(vG);
EcutTotal(:,3) = Ecut;

% Runder av hjørner og lager STL for hjørne 3
[F,V] = vox2quadPoly(vG);
[V] = smoothQuadVertex(F,V);
[V] = smoothQuadVertex(F,V); % Runder av enda engang
[fTri]= quadPoly2triPoly(F);
triPoly2stl(fTri,V, 'poly3.stl', .1);


% Fjerde hjørne
vG = zeros(vGdim, vGdim, vGdim, 'int8');
nodeNr = 4; 
[vG,Ecut] = mesh2voxCorner(vG, N, E, nodeNr, coStruct); 
figure(5);clf;plotVg_safe(vG, 'edgeOff');
plotVgBoundingBox(vG);
EcutTotal(:,4) = Ecut;

% Runder av hjørner og lager STL for hjørne 4
[F,V] = vox2quadPoly(vG);
[V] = smoothQuadVertex(F,V);
[V] = smoothQuadVertex(F,V); % Runder av enda engang
[fTri]= quadPoly2triPoly(F);
triPoly2stl(fTri,V, 'poly4.stl', .1);


% Femte hjørne
vG = zeros(vGdim, vGdim, vGdim, 'int8');
nodeNr = 5; 
[vG,Ecut] = mesh2voxCorner(vG, N, E, nodeNr, coStruct); 
figure(6);clf;plotVg_safe(vG, 'edgeOff');
plotVgBoundingBox(vG);
EcutTotal(:,5) = Ecut;

% Runder av hjørner og lager STL for hjørne 5
[F,V] = vox2quadPoly(vG);
[V] = smoothQuadVertex(F,V);
[V] = smoothQuadVertex(F,V); % Runder av enda engang
[fTri]= quadPoly2triPoly(F);
triPoly2stl(fTri,V, 'poly5.stl', .1);


% Lager nye lengder for stag
for eNr = 1 : size(E,1)
     nodeCornerNr1 = E(eNr,1);
     nodeCornerNr2 = E(eNr,2);
     opprinneligLng = norm( N(nodeCornerNr1,:) - N(nodeCornerNr2,:) );     
     nyLng = opprinneligLng - EcutTotal(eNr,nodeCornerNr1) - EcutTotal(eNr,nodeCornerNr2);
     fprintf("EdgeNr: %d - NyLng: %3.0f mm    OrgLng: %3.0f mm \n", eNr, nyLng*1000, opprinneligLng*1000);
end
