% Funksjon for å finne hvor langt unna trekantene er å være likesidede
function equilateralTriangle = findOffsetEquiTri(T,ytre_trekanter)

sum_offset = 0;

tre_trekanter = [1 4 6         % A
                  6 14 15       % B
                  15 17 19      % C
                  5 9 12        % D
                  12 24 25      % E
                  19 21 25      % F
                  7 10 11       % G
                  11 24 26      % H
                  22 23 26      % I
                  2 7 8         % J
                  8 14 16       % K
                  16 18 22];    % L


for i = 1 : size(ytre_trekanter, 1)

    % Finner de tre punktene i trekanten
    a = T(ytre_trekanter(i,1),:);
    b = T(ytre_trekanter(i,2),:);
    c = T(ytre_trekanter(i,3),:);
    
    % Finner vektorene
    ab = norm(a-b);
    bc = norm(b-c);
    ac = norm(a-c);
    
    % Finner forskjellene
    offset = abs(ab-bc) + abs(bc-ac) + abs(ab-ac);
    sum_offset = sum_offset + offset;

end

equilateralTriangle = sum_offset;






% Hvordan definere vinkler via vektorer
% Hvordan regne ut vinklene - Finnes i Kalkulus, evt spørre Jonas
hele_trekanter = [1 5 6
                  3 5 7
                  4 7 8
                  4 6 8
                  
                  5 7 9
                  5 6 9
                  6 9 10
                  6 8 12
                  6 10 12
                  7 8 12
                  7 11 12
                  7 9 11];

% Midterste node er hvor vinkelen går ut fra
enkeltvinkler = [1 5 3
                 1 6 2
                 2 6 4
                 3 8 4];