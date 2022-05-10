function sum = sum_edges(E,T)

sum_edge = 0;
for e = 1 : size(E,1) % size(E,1) gir antall rader/edger
    
    nodeNr1 = E(e,1); % nodenummer på første node i edge nummer e
    nodeNr2 = E(e,2); % nodenummer på andre node i edge nummer e
    xyzPosNode1 = T(nodeNr1,:); % xyz-pos til første node i edge nummer e
    xyzPosNode2 = T(nodeNr2,:); % xyz-pos til andre node i edge nummer e
    
    lN = norm(xyzPosNode2 - xyzPosNode1); % Lengde på edge nr e
    
    sum_edge = sum_edge + lN;
    
end
sum = sum_edge;