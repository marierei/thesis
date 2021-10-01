global N;
global E;
global extC;
global extF;
global gR;

M = [0 0 0
     0 0 1
     0 1 0
     0 1 1
     1 0 0
     1 0 1
     1 1 0
     1 1 1];

F = [1 2
     3 4
     4 1
     2 3
     3 5
     4 7
     4 6
     7 8];

% 1 er fri og 0 er låst
xtC = [0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0];

% Krefter
xtF = [0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0
        0 0 0];



% Spesifiserer arealtverrsnitt og stivhet matrisen for E
radius = 0.003;       % Meter
E(:,3) = pi*radius^2;  % Arealer

% Kjører FEM-simulator med stress på gitte noder
% Får stress edge array og displacement node array som brukes til videre
% plotting
[sE, dN] = FEM_truss(E,N, extF,extC);

% Sammenligner dN med N for å få forflytning
% Skalerer opp med 100 for å faktisk se forflytning
figure(1);clf;plotMesh(E,N,'txt'); % Opprinnelig mesh

%visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
%hold on;plotMesh(N-visuellScale*dN,E, 'col',[1 0 0]); % Mesh med nodeforflytninger i rød farge
%hold on;plotMeshCext(N,extC,100);
%hold on;plotMeshFext(N-visuellScale*dN,extF, 0.01);
%view([-120 10]);
