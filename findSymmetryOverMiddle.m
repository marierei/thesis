function symmetry = findSymmetryOverMiddle(T)

topMiddle = (T(9,:) + T(10,:) + T(11,:) + T(12,:))/4;

sym_1x = abs(abs(T(6,1) - topMiddle(1)) - abs(T(7,1) - topMiddle(1)));
sym_1y = abs(abs(T(6,2) - topMiddle(2)) - abs(T(7,2) - topMiddle(2)));
sym_1z = abs(T(6,3) - T(7,3));

sym_2x = abs(abs(T(5,1) - topMiddle(1)) - abs(T(8,1) - topMiddle(1)));
sym_2y = abs(abs(T(5,2) - topMiddle(2)) - abs(T(8,2) - topMiddle(2)));
sym_2z = abs(T(5,3) - T(8,3));

symmetry = sym_1x + sym_1y + sym_1z + sym_2x + sym_2y + sym_2z;