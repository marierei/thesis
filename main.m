% Initialiserer globale variabler
global N;
global T;
global E;
global extC;
global extF;
global antNoder;

% Noder
% Dimensjoner i meter, skalerer ned til desimeter senere
N = [2 2 2
     3 2 2
     2 3 2
     3 3 2
     
     2 2 3
     3 2 3
     2 3 3
     3 3 3
     
     2 2 4
     3 2 4
     2 3 4
     3 3 4];

N = N/10;

% Edges, kanter
 E = [5 1
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

radius = 0.03;  % Radius lik 3 mm
E(:,3) = pi*radius^2;

extC = [0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        0 0 0   0 0 0
        
        1 1 1   0 0 0
        1 1 1   0 0 0
        1 1 1   0 0 0
        1 1 1   0 0 0
        
        1 1 0   0 0 0
        1 1 0   0 0 0
        1 1 0   0 0 0
        1 1 0   0 0 0];

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
        0 12 20   0 0 0
        0 12 20   0 0 0];

% Plotter mesh med nodenr, edgenr, constrainede noder og eksterne krefter
%figure(1);
%clf;
%plotMesh(E, N, 'txt');
%hold on;
%plotMeshCext(N, extC, 'ballRadius', 100);   % Blå kuler for låste noder
%plotMeshFext(N, extF, 'vecPlotScale', 0.001); % Kraftvektorer, 0.001 skalerer ned vektorene for å passe grafen

% Kjøring av simulatoren
% sE - stress edge array, hvor mye stress/trykk det er på hver edge
% dN - displacement node array, hvor mye hver node har flyttet seg pga
% stresset, trekkes fra opprinnelige N-posisioner for nye posisjoner
[sE, dN] = FEM_frame(E, N, extC, extF);

% Plotter resultatet
visuellScale = 100;    % Skalerer opp forflytningen
%plotMesh(E, N-visuellScale*dN(:,1:3), 'txt', 'col',[1 0 0], 'lThick',2); % Mesh med nodeforflytninger i rød farge
%plotMeshCext(N, extC, 'ballRadius',100);
%plotMeshFext(N-visuellScale*dN(:,1:3), extF, 'vecPlotScale',0.001);
%hold on;

% Kode for å plotte 3D-figur
%noSec = 30;
%rad = 0.002; % Radius
%[Fp,Np] = mesh2openQuadPoly(E, N-visuellScale*dN(:,1:3), rad, noSec, 'scaleSphere', 1.2);
%clf; plotPoly(Fp,Np, 'edgeOff');

% Bruker ikke dette til noe per nå
global nedboyArray;
nedboyArray = [];

nedBoy = findNedBoy(E,N,extC,extF)
% Setter inn initiell nedbøy på første plass i array
nedboyArray(1) = nedBoy;



T = N;


% Setter inn noden som skal flyttes i et array
noderFlytt(1,:) = T(5,:);
noderFlytt(2,:) = T(6,:);
noderFlytt(3,:) = T(7,:);
noderFlytt(4,:) = T(8,:);
%noderFlytt(5,:) = T(1,:);
%noderFlytt(6,:) = T(1,:);
%noderFlytt(7,:) = T(3,:);
%noderFlytt(8,:) = T(4,:);

antNoder = size(noderFlytt, 1);


% Finne nodene som flyttes nedover
% Dette må kunne gjøres penere
ned = [N(9,:); N(10,:); N(11,:); N(12,:)];

grense = 0.05;


sum_edge = sum_edges(E,N);


global arr;
arr = [];
arr(1) = sum_edge;

options = optimoptions('simulannealbnd','PlotFcns',...
          {@saplotbestx,@saplotbestf,@saplotx,@saplotf});

% Finner grenseverdiene

lb = [];
ub = [];

for i = 1 : antNoder
    lb = [lb (noderFlytt(i,:) - grense)];
    ub = [ub (noderFlytt(i,:) + grense)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulated annealing - funker ikke
%[x1,fval] = simulannealbnd(nedover, noderFlytt, lb, ub);

%T1(5,:) = x1(1,:);
%T1(6,:) = x1(2,:);
%T1(7,:) = x1(3,:);
%T1(8,:) = x1(4,:);

%figure(2);
%clf;
%plotMesh(E, T1, 'txt', 'col',[0 0 1], 'lThick',2); % Mesh med nodeforflytninger i blå farge
%hold on;
%fprintf('The best function value found was : %g\n', fval);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% General algotithm - rød
nedover = @objFun1
T2 = N;
dim = antNoder * 3;
[x2, fval, ~, ~, ~, ~] = ga(nedover, dim, [], [], [], [], lb, ub);

x2 = reshape(x2, [antNoder,3])

T2(5,:) = x2(1,:);
T2(6,:) = x2(2,:);
T2(7,:) = x2(3,:);
T2(8,:) = x2(4,:);
%T2(1,1:2) = x2(5,1:2);
%T2(2,1:2) = x2(6,1:2);
%T2(3,1:2) = x2(7,1:2);
%T2(4,1:2) = x2(8,1:2);

figure(2);
plotMesh(E, T2, 'txt', 'col',[1 0 0], 'lThick',2); % Mesh med nodeforflytninger i rød farge
hold on;





figure(3);


nedboyArray

%plotMesh(E, N, 'txt');
%hold on;

% Kode for å plotte 3D-figur
noSec = 30;
rad = 0.002; % Radius
[Fp,Np] = mesh2openQuadPoly(E, T2, rad, noSec, 'scaleSphere', 1.2);
clf; plotPoly(Fp,Np, 'edgeOff');

