function obj = objFun1(x)
% Følgende format er nødvendig på objektivfunksjonen for å kunne inludere
% den i flere av Matlabs optimaliseringsalgoritmer som vi kan bruke.

% x er en 1-dim vektor som inneholder alle xyz-posisjons-justeringer på de nodene som
% vi vil justere under optimaliseringen. 

% Resultatet fra funksjonen må kun være en skalar 
% Her er din kode som inneholder obj = 1*nedBoy + 0.001*maxE
% Definerer global variabel i dette scopet
global N;
global E;
global extF;
global extC;
global nedboyArray;
global T;


%T(1,:) = N(1,:);
%T(2,:) = N(2,:);
%T(3,:) = N(3,:);
%T(4,:) = N(4,:);
%T(5,:) = N(5,:);
%T(6,:) = N(6,:);
T(7,:) = x;
%T(8,:) = N(8,:);
%T(9,:) = N(9,:);
%T(10,:) = N(10,:);
%T(11,:) = N(11,:);
%T(12,:) = N(12,:);


% Finner stress og displacement for ny matrise
%[sE, dN] = FEM_truss(T,E, extF,extC);
[sE, dN] = FEM_frame(T, E, extF, extC);

maxE = maxEdgeLng(E,T);

nedBoy = dN(9,3) + dN(10,3) + dN(11,3) + dN(12,3);
nedboyArray = [nedboyArray nedBoy];
%obj = nedBoy;
%obj = maxE;
obj = 1*nedBoy + 0.001*maxE;

end