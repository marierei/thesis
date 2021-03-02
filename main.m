% Definerer plassering av noder
global N;
N = [-1.328697 -0.913028 0.000153
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
     0.578692 1.095527 3.306027];

 
% Kobler sammen noder for å få struktur
global E;

F = [
     2 4
     4 8
     6 8
     2 6

     9 10
     10 11
     11 12
     9 12
     
     1 2
     3 4
     7 8
     5 6
     
     4 9
     2 10
     6 11
     8 12
     
     4 6
     2 12
     2 11
     11 8
     2 9
     8 9
     
     4 1
     4 7
     8 5
     5 2
     
     10 12
     ];

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
    
    0 0 0
    1 1 1
    0 0 0
    1 1 1
    
    1 1 1
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
    0 0 0
    0 0 0
    0 0 0
    
    0 0 15
    0 0 15
    0 0 15
    0 0 15];

% Kjører FEM-simulator med stress på gitte noder
% Får stress edge array og displacement node array som brukes til videre
% plotting
[sE, dN] = FEM_truss(N,E, extF,extC);

% Sammenligner dN med N for å få forflytning
% Skalerer opp med 100 for å faktisk se forflytning
figure(1);clf;plotMesh(N,E,'txt'); % Opprinnelig mesh

visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
hold on;plotMesh(N-visuellScale*dN,E, 'col',[1 0 0]); % Mesh med nodeforflytninger i rød farge
hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(N-visuellScale*dN,extF, 0.01);
%view([-120 10]);





% Finner nedbøyning av topplaten i z-planet
global nedBoy;
%nedBoy = dN(9,3) + dN(10,3) + dN(11,3) + dN(12,3)
nedBoy = dN(11,3) + dN(12,3);


counter = 0;

% Finner ulåste noder
for i=1 : size(N,1)
    if extC(i,:) == [1 1 1]
        counter = counter + 1
        noderFlytt(counter,:) = N(i,:);
    end
end


noderFlytt;

nedover = @objFun1


% Running sumulated annealing
lb = 0.1 * [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
ub = 0.1 * [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
[x,fval] = simulannealbnd(nedover, noderFlytt, lb, ub);


% New array for the truss
T = zeros(size(N));


T(1,:) = N(1,:);
T(2,:) = N(2,:) - x(1,:);
T(3,:) = N(3,:);
T(4,:) = N(4,:) - x(2,:);
T(5,:) = N(5,:);
T(6,:) = N(6,:) - x(3,:);
T(7,:) = N(7,:);
T(8,:) = N(8,:) - x(4,:);
T(9,:) = N(9,:) - x(5,:);
T(10,:) = N(10,:) - x(6,:);
T(11,:) = N(11,:) - x(7,:);
T(12,:) = N(11,:) - x(8,:);

[sE, dN] = FEM_truss(T,E, extF,extC);
%nedBoy = dN(9,3) + dN(10,3) + dN(11,3) + dN(12,3)
nedBoy = dN(11,3) + dN(12,3);


% Forflytning for å få ny mest
figure(2);clf;plotMesh(N,E); % Opprinnelig mesh
%visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
hold on;plotMesh(T,E, 'col',[1 0 0],'txt'); % Mesh med nodeforflytninger i rød farge
hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(T,extF, 0.01);
[V,F] = mesh2poly2(T,E,0.015,20); % radius, antall plygonsider
figure(2);clf;plotPoly(F,V,'edgeOff');
view([-120 10]);sun1;
view([-120 10]);

% Lager gif
%saveFigToTurntableAnimGif('truss.gif','ant',50);
