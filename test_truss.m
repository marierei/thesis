% Noder
% Dimensjoner i meter, skalerer ned til desimeter senere
N = [2 2 2
     3 2 2
     2 3 2
     3 3 2
     
     2 2 3
     3 2 3
     2 3 3
     3 3 3];

N = N/10;

% Edges, kanter
 E = [2 1
      3 1
      4 3
      4 2
      4 1
      5 1
      5 3
      6 2
      6 1
      6 4
      6 5
      7 3
      7 5
      8 4
      8 3
      8 7
      8 6
      8 5];

radius = 0.003  % Radius lik 3 mm
E(:,3) = pi*radius^2;

% Contained noder, 1 1 1 kan flytte seg, 0 0 0 er låst
extC = [0 0 0
        0 0 0
        0 0 0
        0 0 0

        1 1 1
        1 1 1
        1 1 1
        1 1 1];

% Eksterne krefter i N
extF = [0 0 0
        0 0 0
        0 0 0
        0 0 0

        12 0.5 20
        20 0   20
        0  0   0
        0  0   0];

% Plotter mesh med nodenr, edgenr, constrainede noder og eksterne krefter
clf;
plotMesh(E, N, 'txt');
hold on;
plotMeshCext(N, extC, 'ballRadius', 100);   % Blå kuler for låste noder
plotMeshFext(N, extF, 'vecPlotScale', 0.001); % Kraftvektorer, 0.001 skalerer ned vektorene for å passe grafen
view(-8, 14);zoom(1.1);     % Forandrer perspektivet, forandre denne

% Kjøring av simulatoren
% sE - stress edge array, hvor mye stress/trykk det er på hver edge
% dN - displacement node array, hvor mye hver node har flyttet seg pga
% stresset, trekkes fra opprinnelige N-posisioner for nye posisjoner
[sE, dN] = FEM_truss(E, N, extF, extC)

% Plotter resultatet
clf;
plotMesh(E, N, 'lThick',1, 'col',[0.4 0.4 1]); % Opprinnelig mesh i blå farge, tynne linjer
visuellScale = 100;                                          % Vi vil visuelt skalere opp forflytningene for de er små
hold on;
plotMesh(E, N-visuellScale*dN, 'txt', 'col',[1 0 0], 'lThick',2); % Mesh med nodeforflytninger i rød farge
plotMeshCext(N, extC, 'ballRadius',100);
plotMeshFext(N-visuellScale*dN, extF, 'vecPlotScale',0.001);
view(-8,14);zoom(1.1);













