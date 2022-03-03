function goldenTriangle = findGoldenTriangle(T,ytre_trekanter)

sum_offset = 0;
phi = (1 + sqrt(5))/2;

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


    
    
    % Finner forskjellene
    offset = abs(c1-b1) + abs(phi - c1/a1);
    sum_offset = sum_offset + offset;

end

goldenTriangle = sum_offset;