global N;
global E;
global extC; 
global extF;
global gR;


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
nedBoy = dN(13,3) + dN(14,3) + dN(15,3) + dN(16,3)
%nedBoy = dN(16,3);


counter = 0;

% Finner ulåste noder
for i=1 : size(N,1)
    if extC(i,:) == [1 1 1]
        counter = counter + 1;
        noderFlytt(counter,:) = N(i,:);
    end
end

counter

%noderFlytt

nedover = @objFun1


% Running sumulated annealing
%lb = 0.1 * [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
%ub = 0.1 * [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
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
%T(14,:) = N(10,:) - x(10,:);
%T(15,:) = N(11,:) - x(11,:);
%T(16,:) = N(11,:) - x(12,:);
T(14,:) = T(13,:);
T(15,:) = T(13,:);
T(16,:) = T(13,:);

[sE, dN] = FEM_truss(T,E, extF,extC);
nedBoy = dN(13,3) + dN(14,3) + dN(15,3) + dN(16,3)
%nedBoy = dN(16,3);


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

gR

%Optimization terminated: change in best function value less than options.FunctionTolerance.
