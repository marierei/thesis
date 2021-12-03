% Initialiserer globale variabler
global N;
global E;
global extC;
global extF;
global T;
global nedboyArray;
global antNoder;

% Noder
% Dimensjoner i meter, skalerer ned til desimeter senere
N = [2 2 2
     3 2 2
     2 3 2
     3 3 2
     
     2 2 3
     3 2 3
     %2.2 2.5 3.6
     2 3 3
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
figure(1);
clf;
plotMesh(E, N, 'txt');
hold on;
%plotMeshCext(N, extC, 'ballRadius', 100);   % Blå kuler for låste noder
plotMeshFext(N, extF, 'vecPlotScale', 0.001); % Kraftvektorer, 0.001 skalerer ned vektorene for å passe grafen


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
noSec = 30;
rad = 0.002; % Radius
%[Fp,Np] = mesh2openQuadPoly(E, N-visuellScale*dN(:,1:3), rad, noSec, 'scaleSphere', 1.2);
%clf; plotPoly(Fp,Np, 'edgeOff');

% Bruker ikke dette til noe per nå
global nedboyArray;
nedboyArray = [];

% Finner total nedbøyning av topplaten i z-planet ved å bruke node displacement
% Ønsker å minimere denne
%global nedBoy;

boyX = abs(dN(9,1)) + abs(dN(10,1)) + abs(dN(11,1)) + abs(dN(12,1));
boyY = abs(dN(9,2)) + abs(dN(10,2)) + abs(dN(11,2)) + abs(dN(12,2));
boyZ = abs(dN(9,3)) + abs(dN(10,3)) + abs(dN(11,3)) + abs(dN(12,3));
nedBoy = boyX + boyY + boyZ

% Setter inn initiell nedbøy på første plass i array
nedboyArray(1) = nedBoy;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








T = N;



%noderFlytt(1,:) = T(1,:);
%noderFlytt(2,:) = T(2,:);
%noderFlytt(3,:) = T(3,:);
%noderFlytt(4,:) = T(4,:);
%noderFlytt(5,:) = T(5,:);
%noderFlytt(6,:) = T(6,:);
%noderFlytt(7,:) = T(7,:);
%noderFlytt(8,:) = T(8,:);
%noderFlytt(9,:) = T(9,:);
%noderFlytt(10,:) = T(10,:);
%noderFlytt(11,:) = T(11,:);
%noderFlytt(12,:) = T(12,:);




% Setter inn noden som skal flyttes i et array
noderFlytt(1,:) = T(7,:);
noderFlytt(2,:) = T(8,:);
%noderFlytt(3,:) = T(5,:);
%noderFlytt(4,:) = T(6,:);

antNoder = size(noderFlytt, 1);
grense = 0.05




% Finne nodene som flyttes nedover
% Dette må kunne gjøres penere
ned = [N(9,:); N(10,:); N(11,:); N(12,:)]

grense = 0.5;


%T = N;
nedover = @objFun1;










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum_edge = 0;

for e = 1 : size(E,1) % size(E,1) gir antall rader/edger
    
    nodeNr1 = E(e,1); % nodenummer pÃ¥ fÃ¸rste node i edge nummer e
    nodeNr2 = E(e,2); % nodenummer pÃ¥ andre node i edge nummer e
    xyzPosNode1 = T(nodeNr1,:); % xyz-pos til fÃ¸rste node i edge nummer e
    xyzPosNode2 = T(nodeNr2,:); % xyz-pos til andre node i edge nummer e
    
    lN = norm( xyzPosNode2 - xyzPosNode1); % Lengde pÃ¥ edge nr e
    
    sum_edge = sum_edge + lN;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





global arr;
arr = [];
arr(1) = sum_edge;


T1 = N;
options = optimoptions('simulannealbnd','PlotFcns',...
          {@saplotbestx,@saplotbestf,@saplotx,@saplotf});

% Finner grenseverdiene

lb = []
ub = []

for i = 1 : antNoder
    lb = [lb (noderFlytt(i,:) - grense)]
    ub = [ub (noderFlytt(i,:) + grense)]
end

[x1,fval] = simulannealbnd(nedover, noderFlytt, lb, ub);

%T(1,:) = x1(1,:);
%T(2,:) = x1(2,:);
%T(3,:) = x1(3,:);
%T(4,:) = x1(4,:);
%T(5,:) = x1(5,:);
%T(6,:) = x1(6,:);
%T(7,:) = x1(7,:);
%T(8,:) = x1(8,:);
%T(9,:) = x1(9,:);
%T(10,:) = x1(10,:);
%T(11,:) = x1(11,:);
%T(12,:) = x1(12,:);





T1(7,:) = x1(1,:);
T1(8,:) = x1(2,:);
%T(5,:) = x1(3,:);
%T(6,:) = x1(4,:);


figure(2);
clf;
plotMesh(E, T1, 'txt', 'col',[0 0 1], 'lThick',2); % Mesh med nodeforflytninger i blå farge
hold on;
fprintf('The best function value found was : %g\n', fval);







% General algotithm - rød
%T2 = N;

        % For én node, 3 dim
        %[x2, fval] = ga(nedover,3, [], [], [], [], lb, ub);

% For to noder, 6 dim
%dim = antNoder * 3;
%[x2, fval] = ga(nedover, dim, [], [], [], [], lb, ub);

%x2 = reshape(x2, [antNoder,3]);
%T2(7,:) = x2(1,:);
%T2(8,:) = x2(2,:);

%plotMesh(E, T2, 'txt', 'col',[1 0 0], 'lThick',2); % Mesh med nodeforflytninger i rød farge
%hold on;







%figure(3);
%clf;
%plot(arr);

nedboyArray



plotMesh(E, N, 'txt');
hold on;





% TODO: Lage vG og finne hva denne funksjonen egentlig gjør
%[E, N, vGvokselNr] = vox2mesh12(vG)

%[Fp,Np] = mesh2openQuadPoly(E, T, rad, noSec, 'scaleSphere', 1.2);
%clf; plotPoly(Fp,Np, 'edgeOff');


