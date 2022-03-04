function dial = dialingObjfun(E,T,extC,extF,ned,lengthEdges,maxE,equi,gold,silver,tri,mass)


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
%sumEdge = lengthEdges * sum_edges(E,T);
%maxEdge = maxE * maxEdgeLng(E,T);
%equiTri = equi * findOffsetEquiTri(T,ytre_trekanter);
%goldenTri = gold * findGoldenTriangle(T,ytre_trekanter);
%silverTri = silver * findSilverTriangle(T,ytre_trekanter);
%chooseTri = tri * chooseBestTriangle(T,ytre_trekanter);
centerofMass = mass * findCenterofMass(T);

dial = nedBoy + centerofMass;
%dial = nedBoy + sumEdge + maxEdge;
%dial = nedBoy + sumEdge + maxEdge + equiTri + goldenTri + silverTri + chooseTri;