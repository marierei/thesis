function obj = objFun1(x)
% F�lgende format er n�dvendig p� objektivfunksjonen for � kunne inludere
% den i flere av Matlabs optimaliseringsalgoritmer som vi kan bruke.

% x er en 1-dim vektor som inneholder alle xyz-posisjons-justeringer p� de nodene som
% vi vil justere under optimaliseringen. 

% Resultatet fra funksjonen m� kun v�re en skalar 
% Her er din kode som inneholder obj = 1*nedBoy + 0.001*maxE
% Definerer global variabel i dette scopet
global E;
global extF;
global extC;
global nedboyArray;
global T;
global arr;

%forste = x(1,:)
%andre = x(2,:)


%T(1,:) = N(1,:);
%T(2,:) = N(2,:);
%T(3,:) = N(3,:);
%T(4,:) = N(4,:);
T(5,:) = x(3,:);
T(6,:) = x(4,:);
T(7,:) = x(1,:);
T(8,:) = x(2,:);
%T(9,:) = x(3,:);
%T(10,:) = x(4,:);
%T(11,:) = N(11,:);
%T(12,:) = N(12,:);


% Finner stress og displacement for ny matrise
%[sE, dN] = FEM_truss(T,E, extF,extC);
[sE, dN] = FEM_frame(T, E, extF, extC);

maxE = maxEdgeLng(E,T);
x;

sum_edge = 0;

for e = 1 : size(E,1) % size(E,1) gir antall rader/edger
    
    nodeNr1 = E(e,1); % nodenummer på første node i edge nummer e
    nodeNr2 = E(e,2); % nodenummer på andre node i edge nummer e
    xyzPosNode1 = T(nodeNr1,:); % xyz-pos til første node i edge nummer e
    xyzPosNode2 = T(nodeNr2,:); % xyz-pos til andre node i edge nummer e
    
    lN = norm( xyzPosNode2 - xyzPosNode1); % Lengde på edge nr e
    
    sum_edge = sum_edge + lN;
    
end

sum_edge;

arr = [arr sum_edge];

boyX = abs(dN(9,1)) + abs(dN(10,1)) + abs(dN(11,1)) + abs(dN(12,1));
boyY = abs(dN(9,2)) + abs(dN(10,2)) + abs(dN(11,2)) + abs(dN(12,2));
boyZ = abs(dN(9,3)) + abs(dN(10,3)) + abs(dN(11,3)) + abs(dN(12,3));
nedBoy = boyX + boyY + boyZ;

%nedBoy = dN(9,3) + dN(10,3) + dN(11,3) + dN(12,3);
%nedboyArray = [nedboyArray nedBoy];
%obj = nedBoy;
%obj = maxE;
% maxE virker som et t�pelig og begrensende m�l
% Kanskje skrive om dette i oppgaven???
%obj = 1 -1*nedBoy %- 0.005*maxE;
%obj = sum_edge;
obj = nedBoy + 0.00001 * sum_edge;

end