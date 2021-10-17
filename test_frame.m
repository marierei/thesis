N = [0 0 0
     1 0 1
     2 0 1];

N = N / 10;

E = [1 2
     2 3];

radius = 0.003;     % meter
E(:,3) = pi*radius^2;

% Spesifiserer både låste noder og råst rotasjon
%       x y z  rotX rotY rotZ
extC = [0 0 0  0 0 0
        1 1 1  1 1 1
        1 1 1  1 1 1];

% Eksterne krefter på nodene pluss vridningskrefter
%       Fx Fy Fz   roxX rotY rotZ
extF = [0 0 0      0 0 0
        0 0 0      0 0 0
        0 0.1 0.2  0 0 0];

% Plotter mesh me nodenummer, edgenummer, låst node og ekstern kraft
clf;
plotMesh(E, N, 'txt', 'coo', 0.1);
hold on;
plotMeshCext(N, extC, 'ballRadius', 100);
plotMeshFext(N, extF, 'vecPlotScale', 0.001);

% Kjører fametrussimulator og plotter resultatet i rødt
[sE, dN] = FEM_frame(N, E, extF, extC);

visuellScale = 100;
clf;
plotMesh(E, N, 'txt', 'coo', 0.1);
hold on;
plotMesh(E, N-100*dN(:,1:3), 'col', [1 0 0]);
plotMeshFext(N-100*dN(:,1:3), extF, 'vecPlotScale', 0.2);





[V,F] = mesh2poly2(N,E,0.015,20); % radius, antall plygonsider
figure(2);clf;plotPoly(F,V,'edgeOff');
