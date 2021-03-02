function obj = objFun1(x)

global N;
global E;
global extF;
global extC;


for i = 1 : size(x,1)
    x(i,:) = rand(1,3);
end

x = x / 100;


T = zeros(size(N));


add = [2 4 6 8 9 10 11 12];
T(1,:) = N(1,:);
T(2,:) = N(2,:) - x(1,:);
T(3,:) = N(3,:);
T(4,:) = N(4,:) - x(2,:);
T(5,:) = N(5,:)
T(6,:) = N(6,:) - x(3,:);
T(7,:) = N(7,:);
T(8,:) = N(8,:) - x(4,:);
T(9,:) = N(9,:) - x(5,:);
T(10,:) = N(10,:) - x(6,:);
T(11,:) = N(11,:) - x(7,:);
T(12,:) = N(11,:) - x(8,:);


% Finner stress og displacement for ny matrise
[sE, dN] = FEM_truss(T,E, extF,extC);

maxE = maxEdgeLng(E,T);

nedBoy = dN(9,3) + dN(10,3) + dN(11,3) + dN(12,3)
%nedBoy = dN(11,3) + dN(12,3);

%obj = nedBoy;
%obj = maxE;
obj = 1*nedBoy + 0.001*maxE;

end