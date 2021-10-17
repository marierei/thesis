N = [0 0 0 ; 0 1 0 ; 1 1 0 ; 1 0 0 ; 1 1 1];
E = [1 2 ; 2 3 ; 3 4 ; 4 1 ; 2 5 ; 3 5 ; 4 5];

clf;plotMesh(E,N,'dark','txt');

noSec = 30;
rad = 0.05; % Radius


[Fp,Np] = mesh2openQuadPoly(E, N, rad, noSec, 'scaleSphere', 1.2);

clf; plotPoly(Fp,Np, 'edgeOff', 'dark');











