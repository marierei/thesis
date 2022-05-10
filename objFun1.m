function obj = objFun1(x)
global E;
global extF;
global extC;
global T;
global antNoder;

x = reshape(x, [antNoder,3]);

T(5,:) = x(1,:);
T(6,:) = x(2,:);
T(7,:) = x(3,:);
T(8,:) = x(4,:);
%T(1,1:2) = x(5,1:2);
%T(2,1:2) = x(6,1:2);
%T(3,1:2) = x(7,1:2);
%T(4,1:2) = x(8,1:2);

ned = 1;
lengthEdges = 0;
maxE = 0;

gold = 0;
silver = 1;
equi = 0;
tri = 0;

mass = 0;
sym = 1;
plane = 0;

% maxE virker som et tåpelig og begrensende mål alene
% Kanskje skrive om dette i oppgaven???
obj = dialingObjfun(E,T,extC,extF,ned,lengthEdges,maxE,equi,gold,silver,tri,mass,sym,plane);
%obj = findNedBoy(E,T,extC,extF);
end