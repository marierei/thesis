function nedBoy = findNedBoy(E,T)

global extC;
global extF;

% Finner stress og displacement for ny matrise
[sE, dN] = FEM_frame(E, T, extC, extF);

boyX = abs(dN(9,1)) + abs(dN(10,1)) + abs(dN(11,1)) + abs(dN(12,1));
boyY = abs(dN(9,2)) + abs(dN(10,2)) + abs(dN(11,2)) + abs(dN(12,2));
boyZ = abs(dN(9,3)) + abs(dN(10,3)) + abs(dN(11,3)) + abs(dN(12,3));
nedBoy = boyX + boyY + boyZ;