function chooseTriangle = chooseBestTriangle(T,ytre_trekanter)

sum_offset = 0;
phi = (1 + sqrt(5))/2;
sigma = 1 + sqrt(2);

for i = 1 : size(ytre_trekanter, 1)

    % Finner de tre punktene i trekanten
    a = T(ytre_trekanter(i,1),:);
    b = T(ytre_trekanter(i,2),:);
    c = T(ytre_trekanter(i,3),:);
    
    % Finner vektorene
    ab = norm(a-b);
    bc = norm(b-c);
    ac = norm(a-c);

    triangle = sort([ab,bc,ac],2);
    a1 = triangle(1);
    b1 = triangle(2);
    c1 = triangle(3);

    % findOffsetEquiTri
    equiTri = abs(ab-bc) + abs(bc-ac) + abs(ab-ac);

    % findGoldenTriangle
    goldenTri = abs(c1-b1) + abs(phi - c1/a1);

    % findSilverTriangle
    silverTri = abs(c1-b1) + abs(sigma - c1/a1);
    
    tri = sort([equiTri,goldenTri,silverTri],2);

        

    sum_offset = sum_offset + tri(1);

end

chooseTriangle = sum_offset;