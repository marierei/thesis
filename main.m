global N;
global E;
global extC; 
global extF;
global gR;
sdflkjsldfho

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
     -1.008185 -1.018207 3.632980
     0.986484 0.983935 3.841092
     0.986484 -1.016066 3.841092
     -1.013515 0.983935 3.841092
     -1.013515 -1.016066 3.841092];

 
% Kobler sammen noder for å få struktur
global E;
E = [12 15
     11 16
     1 2
     8 7
     3 4
     5 6
     3 7
     1 3
     11 13
     7 5
     5 1
     9 15
     10 12
     9 10
     12 11
     11 9
     1 9
     11 5
     7 12
     10 3
     14 16
     13 14
     16 15
     15 13
     12 16
     14 10
     9 13
     15 11
     12 14
     10 16
     9 14
     10 13
     13 16
     9 12
     14 15
     10 11
     12 13
     9 16
     11 14
     10 15
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

global extC;
% Spesifiserer hvilke noder som er låst og i hvilke retninger
% 1 er fri og 0 er låst
extC = [1 1 1
    0 0 0
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
%figure(1);clf;plotMesh(N,E,'txt'); % Opprinnelig mesh

visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
hold on;plotMesh(N-visuellScale*dN,E, 'col',[1 0 0]); % Mesh med nodeforflytninger i rød farge
hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(N-visuellScale*dN,extF, 0.01);
%view([-120 10]);


% Finner nedbøyning av topplaten i z-planet
global nedBoy;
nedBoy = dN(13,3) + dN(14,3) + dN(15,3) + dN(16,3)

counter = 0;

% Finner ulåste noder
for i=1 : size(N,1)
    if extC(i,:) == [1 1 1]
        counter = counter + 1;
        noderFlytt(counter,:) = N(i,:);
    end
end

counter

nedover = @objFun1


% Running simulated annealing
lb = 0.1 * [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
ub = 0.1 * [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
[x,fval] = simulannealbnd(nedover, noderFlytt, lb, ub);


% New array for the truss
T = zeros(size(N));


T(1,:) = N(1,:) - x(1,:);
T(2,:) = N(2,:);
T(3,:) = N(3,:) - x(2,:);
T(4,:) = N(4,:);
T(5,:) = N(5,:) - x(3,:);
T(6,:) = N(6,:);
T(7,:) = N(7,:) - x(4,:);
T(8,:) = N(8,:);
T(9,:) = N(9,:) - x(5,:);
T(10,:) = N(10,:) - x(6,:);
T(11,:) = N(11,:) - x(7,:);
T(12,:) = N(11,:) - x(8,:);
T(13,:) = N(9,:) - x(9,:);
T(14,:) = N(10,:) - x(10,:);
T(15,:) = N(11,:) - x(11,:);
T(16,:) = N(11,:) - x(12,:);

[sE, dN] = FEM_truss(T,E, extF,extC);
nedBoy = dN(13,3) + dN(14,3) + dN(15,3) + dN(16,3)


% Forflytning for å få ny mest
%figure(2);clf;plotMesh(N,E); % Opprinnelig mesh

%visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
%figure(1);clf;plotMeshFext(N,E);

%hold on;plotMesh(N,E, 'col',[1 0 0],'txt'); % Mesh med nodeforflytninger i rød farge
%hold on;plotMeshCext(N,extC,100);
%hold on;plotMeshFext(N,extF, 0.01);
%[V,F] = mesh2poly2(N,E,0.015,20); % radius, antall plygonsider
%figure(1);clf;plotPoly(N,E,'edgeOff');
%view([-120 10]);sun1;
%view([-120 10]);



hold on;plotMesh(T,E, 'col',[1 0 0],'txt'); % Mesh med nodeforflytninger i rød farge
hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(N,extF, 0.01);
[V,F] = mesh2poly2(N,E,0.015,20); % radius, antall plygonsider
figure(2);clf;plotPoly(F,V,'edgeOff');
view([-120 10]);sun1;
view([-120 10]);




%hold on;plotMesh(T,E, 'col',[1 0 0],'txt'); % Mesh med nodeforflytninger i rød farge
%hold on;plotMeshCext(N,extC,100);
%hold on;plotMeshFext(T,extF, 0.01);
%[V,F] = mesh2poly2(T,E,0.015,20); % radius, antall plygonsider
%figure(2);clf;plotPoly(F,V,'edgeOff');
%view([-120 10]);sun1;
%view([-120 10]);
%saveFigToTurntableAnimGif('truss.gif','ant',50);
