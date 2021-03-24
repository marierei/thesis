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
<<<<<<< HEAD
%add = [2 4 6 8 9 10 11 12];
=======


add = [2 4 6 8 9 10 11 12];
>>>>>>> d0626269ed739151e9a6ec80879687f7f53d5cad
T(1,:) = N(1,:) - x(1,:);
T(2,:) = N(2,:);
T(3,:) = N(3,:) - x(2,:);
T(4,:) = N(4,:);
T(5,:) = N(5,:) - x(3,:);
T(6,:) = N(6,:);
T(7,:) = N(7,:) - x(4,:);
T(8,:) = N(8,:);
T(9,:) = N(9,:) - x(5,:);
T(10,:) = N(10,:) - x(6,:);
T(11,:) = N(11,:) - x(7,:);
T(12,:) = N(11,:) - x(8,:);
T(13,:) = N(9,:) - x(9,:);
<<<<<<< HEAD
%T(14,:) = N(10,:) - x(10,:);
%T(15,:) = N(11,:) - x(11,:);
%T(16,:) = N(11,:) - x(12,:);
T(14,:) = T(13,:);
T(15,:) = T(13,:);
T(16,:) = T(13,:);
=======
T(14,:) = N(10,:) - x(10,:);
T(15,:) = N(11,:) - x(11,:);
T(16,:) = N(11,:) - x(12,:);
>>>>>>> d0626269ed739151e9a6ec80879687f7f53d5cad

% Finner stress og displacement for ny matrise
[sE, dN] = FEM_truss(T,E, extF,extC);

maxE = maxEdgeLng(E,T);

nedBoy = dN(13,3) + dN(14,3) + dN(15,3) + dN(16,3)
<<<<<<< HEAD
%nedBoy = dN(16,3);

%temp;
%if T(13:,3) == T(14:,3) == T(15:,3) == T(16:,3)
%    temp = 1*nedBoy + 0.001*maxE;
%else
%    temp = 1/(1*nedBoy + 0.001*maxE);
%end

=======
%nedBoy = dN(11,3) + dN(12,3);
>>>>>>> d0626269ed739151e9a6ec80879687f7f53d5cad

%obj = temp
obj = 1*nedBoy + 0.001*maxE;

end