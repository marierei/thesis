function dial = dialingObjfun(E, T, extC, extF, ned, lengthEdges, maxE, tri)

%nedBoy = ned * findNedBoy(E,T,extC,extF);
%sumEdge = lengthEdges * sum_edges(E,T);
maxEdge = maxE * maxEdgeLng(E,T);
equiTri = tri * findOffsetEquiTri(T);




dial =  maxEdge + equiTri;
%dial = nedBoy + sumEdge + maxEdge + equiTri;