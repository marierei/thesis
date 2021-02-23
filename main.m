% Definerer plassering av noder
global M;
M = [-1.328697 -0.913028 0.000153
     -1.270642 -0.769445 1.666616
     -1.328697 1.086972 0.000153
     -1.335265 1.065808 2.030924
     0.671303 -0.913028 0.000153
     0.671303 -0.913028 2.000153
     0.671303 1.086972 0.000153
     0.635066 1.227270 1.746893
     -1.290071 1.024877 3.216047
     -1.160674 -0.718849 3.239838
     0.835423 -0.935186 3.297900
     0.578692 1.095527 3.306027]

 
% Kobler sammen noder for å få struktur
global E;
E = [1 2
     2 3
     3 4
     4 1
     3 11
     2 7
     
     5 9
     7 11
     9 11
     7 11

     11 12
     9 10
     5 11
     
     8 7
     5 7
     6 5
     1 5
     4 9
     
     1 7
     2 11
     4 7
     4 5
     3 9
     
     8 11
     9 12
     5 10
     5 8];



% Spesifiserer arealtverrsnitt og stivhet for E
radius = 0.003;       % Meter
E(:,3) = pi*radius^2;  % Arealer

global extC;
% Spesifiserer hvilke noder som er låst og i hvilke retninger
% 1 er fri og 0 er låst
extC = [0 0 0
    1 1 1
    0 0 0
    1 1 1
    
    1 1 1
    1 1 1
    0 0 0
    1 1 1
    
    0 0 0
    1 1 1
    1 1 1
    1 1 1];

global extF;
% Spesifiserer kreftene påført hver node og retning
% Her kun én node som blir påført en kraft, z-retningen
extF = [0 0 0
    0 0 0
    0 0 0
    0 0 0
    
    0 0 0
    0 0 12
    0 0 0
    0 0 0
    
    0 0 0
    0 0 0
    0 0 0
    0 0 0];

% Kjører FEM-simulator
% Får stress edge array og displacement node array som brukes til videre
% plotting
[sE, dN] = FEM_truss(N,E, extF,extC);

% Sammenligner dN med N for å få forflytning
% Skalerer opp med 100 for å faktisk se forflytning
figure(1);clf;plotMesh(N,E,'txt'); % Opprinnelig mesh
%view([-120 10]);