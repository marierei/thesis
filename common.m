global N;
global E;
global extC;
global extF;
%global gR;

% Defining the Golden Ratio
% Using the lowest positive value
%gR = round(((1 + sqrt(5))/2));
gR =  (1 + sqrt(5))/2;

% Definerer plassering av noder
N = [1.000000 1.000000 2.014852
     1.000000 1.000000 0.014852
     1.000000 -1.000000 2.014852
     1.000000 -1.000000 0.014852
     -1.000000 1.000000 2.014852
     -1.000000 1.000000 0.014852
     -1.000000 -1.000000 2.014852
     -1.000000 -1.000000 0.014852
     0.991815 0.981793 3.632980
     0.991815 -1.018207 3.632980
     -1.008185 0.981793 3.632980
     -1.008185 -1.018207 3.632980
     0.986484 0.983935 3.841092
     0.986484 -1.016066 3.841092
     -1.013515 0.983935 3.841092
     -1.013515 -1.016066 3.841092];

 
% Kobler sammen noder for å få struktur
E = [1 2    % Heigths lowest level
     3 4
     5 6
     8 7
     
     3 7    % Widths lowest level
     7 5
     5 1
     1 3
     
     1 9    % Heights second level
     10 3
     7 12
     11 5
     
     9 10   % Widths second level
     11 9
     12 11
     10 12
     
     9 13   % Heights seat level
     15 11
     14 10
     12 16
     
     14 16  % Widths seat level
     16 15

     12 15  % Diagonal
     11 16 
     11 13
     9 15
     13 14
     15 13 
     12 14
     10 16
     9 14
     10 13
     13 16
     9 12
     14 15
     10 11
     12 13
     9 16
     11 14
     10 15
     3 9
     2 3
     2 5
     1 11
     3 11
     7 10
     4 7
     5 8
     7 11
     7 9
     1 8];


% Spesifiserer arealtverrsnitt og stivhet for E
radius = 0.003;       % Meter
E(:,3) = pi*radius^2;  % Arealer


% Spesifiserer hvilke noder som er låst og i hvilke retninger
% 1 er fri og 0 er låst
extC = [1 1 1
    0 0 0
    1 1 1
    0 0 0
    
    1 1 1
    0 0 0
    1 1 1
    0 0 0
    
    1 1 1
    1 1 1
    1 1 1
    1 1 1
    
    1 1 1
    1 1 1
    1 1 1
    1 1 1];



% Spesifiserer kreftene påført hver node og retning
% Her kun én node som blir påført en kraft, z-retningen
extF = [0 0 0
    0 0 0
    0 0 0
    0 0 0
    
    0 0 0
    0 0 0
    0 0 0
    0 0 0
    
    0 0 0
    0 0 0
    0 0 0
    0 0 0
    
    0 0 0
    0 0 0
    0 0 15
    0 0 15];