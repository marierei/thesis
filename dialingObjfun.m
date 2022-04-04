function dial = dialingObjfun(E,T,extC,extF,ned,lengthEdges,maxE,equi,gold,silver,tri,mass,sym,plane)

ytre_trekanter = [1 5 6         % A
                  5 6 9         % B
                  6 9 10        % C
                  4 6 8         % D
                  6 8 12        % E
                  6 10 12       % F
                  3 7 8         % G
                  7 8 12        % H
                  7 11 12       % I
                  3 5 7         % J
                  5 7 9         % K
                  7 9 11];      % L

nedBoy = ned * findNedBoy(E,T,extC,extF);
sumEdge = lengthEdges * sum_edges(E,T);
maxEdge = maxE * maxEdgeLng(E,T);
equiTri = equi * findOffsetEquiTri(T,ytre_trekanter);
goldenTri = gold * findGoldenTriangle(T,ytre_trekanter);
silverTri = silver * findSilverTriangle(T,ytre_trekanter);
chooseTri = tri * chooseBestTriangle(T,ytre_trekanter);
centerofMass = mass * findCenterofMass(T);
symmetry = sym * findSymmetryOverMiddle(T);
closePlane = plane * findPlane(T);

maxTotEdgeLengde = 240; % mm
minNodeDistanse = 1.0; % mm
minEdgeDistanse = 0.005; % mm
minVinkelEdges = 15; % grader


% STRAFF: Max total edge lengde straffes ved >maxTotEdgeLengde (pris/miljø)
%sumE = sumEdgeLng(E, T);
%obj1 = pen1(sumE, 0, maxTotEdgeLengde, 900);

% STRAFF: Avstand mellom noder straffes ved lengder <minNodeDistanse (plundrete å montere)
%[distT, ~, ~] = minNodeDist(T);
%obj2 = pen1(distT, minNodeDistanse, 300, 100);

% STRAFF: Avstand mellom edger som ikke deler samme node straffes ved lengder <minEdgeDistanse (kollisjon)
[distE, ~, ~] = minDistBetweenEdges(E, T);
obj3 = pen1(distE, minEdgeDistanse, 300, 100);

% STRAFF: Vinkel mellom edger som deler samme node straffes ved <minVinkelEdges grader (vanskelig å montere)
[angMin, ~, ~, ~] = minAngleConnectedEdges(E, T);
obj4 = pen1(angMin, minVinkelEdges, 300, 100);


%dial = nedBoy + obj3 + obj4 + sumEdge + closePlane;
%dial = nedBoy + sumEdge + maxEdge;
dial = obj3 + obj4 + nedBoy + sumEdge + maxEdge + equiTri + goldenTri + silverTri + chooseTri + centerofMass + symmetry + closePlane;