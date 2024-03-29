function plane = findPlane(T)

% Finner planet som inneholder punktene 5, 6 og 7 og ser om 8 er i det
% Finner en normal vektor til planet gitt ved [a,b,c]
norm_1 = cross(T(6,:) - T(5,:),T(7,:) - T(5,:));
% Bruker likningen til planet og setter inn det siste punktet
a_1 = norm_1(1);
b_1 = norm_1(2);
c_1 = norm_1(3);
d_1 = - (a_1 * T(5,1) + b_1 * T(5,2) + c_1 * T(5,3));
top_1 = a_1 * T(8,1) + b_1 * T(8,2) + c_1 * T(8,3) + d_1;
bottom_1 = sqrt(a_1^2 + b_1^2 + c_1^2);
q_1 = abs(top_1/bottom_1);

% Finner planet som inneholder punktene 5, 7 og 8 og ser om 6 er i det
norm_2 = cross(T(7,:) - T(5,:),T(8,:) - T(5,:));
a_2 = norm_2(1);
b_2 = norm_2(2);
c_2 = norm_2(3);
d_2 = - (a_2 * T(5,1) + b_2 * T(5,2) + c_2 * T(5,3));
top_2 = a_2 * T(6,1) + b_2 * T(6,2) + c_2 * T(6,3) + d_2;
bottom_2 = sqrt(a_2^2 + b_2^2 + c_2^2);
q_2 = abs(top_2/bottom_2);

% Finner planet som inneholder punktene 5, 6 og 8 og ser om 7 er i det
% Finner en normal vektor til planet gitt ved [a,b,c]
norm_3 = cross(T(6,:) - T(5,:),T(8,:) - T(5,:));
a_3 = norm_3(1);
b_3 = norm_3(2);
c_3 = norm_3(3);
d_3 = - (a_3 * T(5,1) + b_3 * T(5,2) + c_3 * T(5,3));
top_3 = a_3 * T(7,1) + b_3 * T(7,2) + c_3 * T(7,3) + d_3;
bottom_3 = sqrt(a_3^2 + b_3^2 + c_3^2);
q_3 = abs(top_3/bottom_3);

% Finner planet som inneholder punktene 6, 7 og 8 og ser om 5 er i det
% Finner en normal vektor til planet gitt ved [a,b,c]
norm_4 = cross(T(7,:) - T(6,:),T(8,:) - T(6,:));
a_4 = norm_4(1);
b_4 = norm_4(2);
c_4 = norm_4(3);
d_4 = - (a_4 * T(6,1) + b_4 * T(6,2) + c_4 * T(6,3));
top_4 = a_4 * T(5,1) + b_4 * T(5,2) + c_4 * T(5,3) + d_4;
bottom_4 = sqrt(a_4^2 + b_4^2 + c_4^2);
q_4 = abs(top_4/bottom_4);

distances = sort([q_1,q_2,q_3,q_4],2);

plane = distances(1);