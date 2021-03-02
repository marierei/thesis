% Funksjon som finner lengste edge i figuren
function L = maxEdgeLng(E,N)
% Rett fram, lett å forstå løsning, kan forkortes og optimaliseres

maxL = 0;

for e = 1 : size(E,1) % size(E,1) gir antall rader/edger
    
    nodeNr1 = E(e,1); % nodenummer på første node i edge nummer e
    nodeNr2 = E(e,2); % nodenummer på andre node i edge nummer e
    xyzPosNode1 = N(nodeNr1,:); % xyz-pos til første node i edge nummer e
    xyzPosNode2 = N(nodeNr2,:); % xyz-pos til andre node i edge nummer e
    
    lN = norm( xyzPosNode2 - xyzPosNode1); % Lengde på edge nr e
    
    if lN > maxL
        maxL = lN;
    end
    
end

% Sender tilbake den lengste edgen
L = maxL;

end