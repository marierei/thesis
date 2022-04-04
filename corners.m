vG = zeros(800,800,800,'int8');

E3 = [5 1
      5 3
      6 2
      6 1
      6 4
      6 5
      7 3
      7 5
      8 4
      8 3
      8 7
      8 6
      8 5
      9 5
      9 6
      9 7
      9 10
      9 11
      10 6
      10 11
      10 12
      11 7
      11 12
      12 8
      12 6
      12 7];

 E =[5.0000    1.0000    0.0050  1
    5.0000    3.0000    0.0050  2
    6.0000    2.0000    0.0050  3
    6.0000    1.0000    0.0050  4
    6.0000    4.0000    0.0050  5
    6.0000    5.0000    0.0050  6
    7.0000    3.0000    0.0050  7
    7.0000    5.0000    0.0050  8
    8.0000    4.0000    0.0050  9
    8.0000    3.0000    0.0050  10
    8.0000    7.0000    0.0050  11
    8.0000    6.0000    0.0050  12
    8.0000    5.0000    0.0050  13
    9.0000    5.0000    0.0050  14
    9.0000    6.0000    0.0050  15
    9.0000    7.0000    0.0050  16
    9.0000   10.0000    0.0050  17
    9.0000   11.0000    0.0050  18
   10.0000    6.0000    0.0050  19
   10.0000   11.0000    0.0050  20
   10.0000   12.0000    0.0050  21
   11.0000    7.0000    0.0050  22
   11.0000   12.0000    0.0050  23
   12.0000    8.0000    0.0050  24
   12.0000    6.0000    0.0050  25
   12.0000    7.0000    0.0050  26]
  
  
radius = 0.04;  % Radius lik 3 mm
%E(:,3) = pi*radius^2;
%E(:,4) = [1,2,3,4,5,6,7,8,9,10,11,12);

N =[0.2000    0.2000    0.2000
    0.3000    0.2000    0.2000
    0.2000    0.3000    0.2000
    0.3000    0.3000    0.2000
    0.1798    0.2179    0.3198
    0.2127    0.2934    0.2999
    0.2594    0.2204    0.2763
    0.2939    0.3036    0.3061
    0.2000    0.2000    0.4000
    0.3000    0.2000    0.4000
    0.2000    0.3000    0.4000
    0.3000    0.3000    0.4000];


coStruct.wallT = 2;           % Veggtykkelse (mm)
coStruct.holeLng = 10;         % Hullengde (mm)
coStruct.layerThickness = 0.254;   % Priter laghøyde (mm)
coStruct.suportRadius = 2;     % Radius på support vegg-framside (halparten av support veggtykelse) (voxels)
coStruct.minSuportAng = 50;  % Min vinkel på edge mor xy-planet som ikke gir support (grader)
coStruct.rotaType = 1;        % 1 - Rotere slik at man får minst behov for suppert inne hull
coStruct.oFilletR = 0.5;     % Rad på outerfillet (voxels)
coStruct.iFilletR = 1;     % Rad på innerfillet (voxels)



[vG,E] = mesh2voxCorner(vG,N,E,nrNcent,coStruct);


