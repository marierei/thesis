% Initialiserer globale variabler
global N;
global E;
global extC;
global extF;
global T;
global nedboyArray;

% Noder
% Dimensjoner i meter, skalerer ned til desimeter senere
N = [2 2 2
     3 2 2
     2 3 2
     3 3 2
     
     2 2 3
     3 2 3
     2 3 3
     %2.2 3.1 2.8
     3 3 3
     
     2 2 4
     3 2 4
     2 3 4
     3 3 4];

N = N/10;

% Edges, kanter
 E = [%2 1
      %3 1
      %4 3
      %4 2
      %4 1
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
      8 5
      
      9 5
      9 6
      9 7
      9 10
      9 11
      10 6
      10 11
      10 12
      11 7
      11 12
      12 8
      12 6
      12 7];

radius = 0.03  % Radius lik 3 mm
E(:,3) = pi*radius^2;

extC = [0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        
        1 1 1   0 0 0
        1 1 1   0 0 0
        1 1 1   0 0 0
        1 1 1   0 0 0
        
        1 1 1   0 0 0
        1 1 1   0 0 0
        1 1 1   0 0 0
        1 1 1   0 0 0];

extF = [0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        
        0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        
        0 12 20   0 0 0
        0 12 20   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0];

% Plotter mesh med nodenr, edgenr, constrainede noder og eksterne krefter
clf;
plotMesh(E, N, 'txt');
hold on;
%plotMeshCext(N, extC, 'ballRadius', 100);   % Blå kuler for låste noder
%plotMeshFext(N, extF, 'vecPlotScale', 0.001); % Kraftvektorer, 0.001 skalerer ned vektorene for å passe grafen



% Kjøring av simulatoren
% sE - stress edge array, hvor mye stress/trykk det er på hver edge
% dN - displacement node array, hvor mye hver node har flyttet seg pga
% stresset, trekkes fra opprinnelige N-posisioner for nye posisjoner
[sE, dN] = FEM_frame(N, E, extF, extC);

% Plotter resultatet
%clf;
%plotMesh(E, N, 'lThick',1, 'col',[0.4 0.4 1], 'lThick', 2); % Opprinnelig mesh i blå farge, tynne linjer
visuellScale = 100;    % Skalerer opp forflytningen
%hold on;
%plotMesh(E, N-visuellScale*dN(:,1:3), 'txt', 'col',[1 0 0], 'lThick',2); % Mesh med nodeforflytninger i rød farge
%plotMeshCext(N, extC, 'ballRadius',100);
%plotMeshFext(N-visuellScale*dN(:,1:3), extF, 'vecPlotScale',0.001);
%hold on;

noSec = 30;
rad = 0.002; % Radius
%[Fp,Np] = mesh2openQuadPoly(E, N-visuellScale*dN(:,1:3), rad, noSec, 'scaleSphere', 1.2);
%clf; plotPoly(Fp,Np, 'edgeOff');


global nedboyArray;
nedboyArray = [];



% Finner total nedbøyning av topplaten i z-planet ved å bruke node displacement
% Ønsker å minimere denne
global nedBoy;
nedBoy = dN(9,3) + dN(10,3) + dN(11,3) + dN(12,3)

% Setter inn noden som skal flyttes i et array
noderFlytt(1,:) = N(7,:)

% Finne nodene som flyttes nedover
% Dette må gjøres penere
ned = [N(9,:); N(10,:)]
T = N;
nedover = @objFun1;

% Simulated annealing - blå
lb = [noderFlytt - 0.05];
ub = [noderFlytt + 0.05];
[x,fval] = simulannealbnd(nedover, noderFlytt, lb, ub);
plotMesh(E, T, 'txt', 'col',[0 0 1], 'lThick',2); % Mesh med nodeforflytninger i blå farge
hold on;

% General algotithm - rød
lb = [noderFlytt - 0.05];
ub = [noderFlytt + 0.05];
x = ga(nedover,3, [], [], [], [], lb, ub)
plotMesh(E, T, 'txt', 'col',[1 0 0], 'lThick',2); % Mesh med nodeforflytninger i rød farge
hold on;

nedboyArray

% TODO: Lage vG og finne hva denne funksjonen egentlig gjør
%[E, N, vGvokselNr] = vox2mesh12(vG)


