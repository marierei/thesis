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
%global nedboyArray;
%global T;
%global arr;
global antNoder;

%E

x = reshape(x, [antNoder,3])
%x
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

T(5,:) = x(1,:);
T(6,:) = x(2,:);
T(7,:) = x(3,:);
T(8,:) = x(4,:);

%arr = [arr sum_edge];
%T

ned = 1;
lengthEdges = 0.001;
maxE = 0;
tri = 0.03;


%nedboyArray = [nedboyArray nedBoy];

% maxE virker som et tåpelig og begrensende mål
% Kanskje skrive om dette i oppgaven???
obj = dialingObjfun(E,T,extC,extF,ned,lengthEdges, maxE, tri);

end