function obj = objFun1(x)
% Følgende format er nødvendig på objektivfunksjonen for å kunne inludere
% den i flere av Matlabs optimaliseringsalgoritmer som vi kan bruke.

% x er en 1-dim vektor som inneholder alle xyz-posisjons-justeringer på de nodene som
% vi vil justere under optimaliseringen. 

% Resultatet fra funksjonen må kun være en skalar 
% Her er din kode som inneholder obj = 1*nedBoy + 0.001*maxE
% Definerer global variabel i dette scopet
global E;
global extF;
global extC;
global nedboyArray;
global T;
global arr;
global antNoder;

x = reshape(x, [antNoder,3])

%T(1,:) = x(1,:);
%T(2,:) = x(2,:);
%T(3,:) = x(3,:);
%T(4,:) = x(4,:);
%T(5,:) = x(5,:);
%T(6,:) = x(6,:);
%T(7,:) = x(7,:);
%T(8,:) = x(8,:);
%T(9,:) = x(9,:);
%T(10,:) = x(10,:);
%T(11,:) = x(11,:);
%T(12,:) = x(12,:);


T(7,:) = x(1,:);
T(8,:) = x(2,:);

% Finner stress og displacement for ny matrise
%[sE, dN] = FEM_truss(T,E, extF,extC);
[sE, dN] = FEM_frame(E, T, extC, extF);

maxE = maxEdgeLng(E,T);


sum_edge = 0;

for e = 1 : size(E,1) % size(E,1) gir antall rader/edger
    
    nodeNr1 = E(e,1); % nodenummer pÃ¥ fÃ¸rste node i edge nummer e
    nodeNr2 = E(e,2); % nodenummer pÃ¥ andre node i edge nummer e
    xyzPosNode1 = T(nodeNr1,:); % xyz-pos til fÃ¸rste node i edge nummer e
    xyzPosNode2 = T(nodeNr2,:); % xyz-pos til andre node i edge nummer e
    
    lN = norm(xyzPosNode2 - xyzPosNode1); % Lengde pÃ¥ edge nr e
    
    sum_edge = sum_edge + lN^2;
    
end

sum_edge;

arr = [arr sum_edge];

boyX = abs(dN(9,1)) + abs(dN(10,1)) + abs(dN(11,1)) + abs(dN(12,1));
boyY = abs(dN(9,2)) + abs(dN(10,2)) + abs(dN(11,2)) + abs(dN(12,2));
boyZ = abs(dN(9,3)) + abs(dN(10,3)) + abs(dN(11,3)) + abs(dN(12,3));
nedBoy = boyX + boyY + boyZ;

%nedboyArray = [nedboyArray nedBoy];
%obj = nedBoy;
% maxE virker som et tåpelig og begrensende mål
% Kanskje skrive om dette i oppgaven???
%obj = 1 - 1*nedBoy - 0.005*maxE;
obj = sum_edge;
%obj = nedBoy + 0.001 * sum_edge + 0.001 * nedBoy;

end