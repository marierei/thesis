function [ ] = TUT_mesh2voxCorner( )
% Mesh til vokselhjørne - typisk for carbonfiber truss
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
% Normalstol [n1 n2  areal(meter^2)  
E = [ 5 1
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
  
% Normalstol (meter)      
N_1=[ 0.2000    0.2000    0.2000
    0.3000    0.2000    0.2000
    0.2000    0.3000    0.2000
    0.3000    0.3000    0.2000
    
    0.2000    0.2000    0.3000
    0.3000    0.2000    0.3000
    0.2000    0.3000    0.3000
    0.3000    0.3000    0.3000
    
    0.2000    0.2000    0.4000
    0.3000    0.2000    0.4000
    0.2000    0.3000    0.4000
    0.3000    0.3000    0.4000]; 

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

N = N * 2;

% Legger inn areal basert på rør med diam = 8mm, 0.4 margin 
E(:, 3) = pi*((8+0.6)/2000)^2; 

% Skjekker mesh 
fig1; plotMesh(E, N, 'dark', 'txt'); 
 
% Fyller inn parametre
paramStruct.tykkWall = 2;             % Tykkelse på hullhylse (mm)      
paramStruct.lngHole = 15;             % Overlapp rør og hullhylse (limområde) (mm)
paramStruct.tykkLagPrinter = 0.254;   % 3D printer laghøyde, (mm)  
paramStruct.breddeSupport = 4;        % Bredde permanent support vegger under (mm), 0 gir ingen support
paramStruct.angMinSupport = 80;       % Min vinkel på edge mot xy-planet som ikke gir support (grader)
paramStruct.typeRot = 1;              % 1 - Rotere slik at man får minst behov for suppert inne hull   
paramStruct.radOfillet = 0;         % Radius på outerfillet (mm), 0 gir ingen avrunding, 0.2 er ok
paramStruct.radIfillet = 0;           % Radius på innerrfillet (mm), 0 gir ingen avrunding, 1 er ok

dim = 400;                            % Må lage en vox grid som er stor nok til omslutter endelig hjørne
vG = zeros(dim, dim, dim, 'int8');    % Her kan man måtte prøve og feile for å finne min dim-størrelse  


EkappLngArr = edgeLength(E, N);       % Genererer orginale edgelengder (meter) fra mesh som blir kappet/minsket etter hver 
                                      % hjørnegenerering / kjøring av mesh2voxCorner(). Array for alle E edgder
                                      % Leveres inn/ut av mesh2voxCorner() og oppdateres hver gang den kjøres.

EpriArr = zeros(size(E, 1), 1);       % Prioritets array som spesifserer hvilke edger som skal stikke dypest inn i hullene 
                                      % Leveres inn til mesh2voxCorner() hver gang den
                                      % kjøres. Lar man denne være tom, blir den automatisk utfylt av mesh2voxCorner(). 
                                      % Eksempel på spesifisering: EpriArr = [2 ; 1 ; 3 ; 5 ; 4 ; 6] - edge nr.2 strikker 
                                      % nå dypere inn enn de andre
                                      
NrotArr = zeros(size(N, 1), 2);       % Leveres inn/ut av mesh2voxCorner(). Gir rotasjoner (vinkel i deg) som ble utført 
                                      % for å gi best support
                                      % Array for alle N noder (hjørner), format: [angX1 angY1 ; angX2 angY2 ; ... ; angXk angYk], 
                                      % der k er antall noder i N. Kan brukes for plotting ved behov. Skal ikke spesifiseres

% Kjører

for hjorneNodeNr = 1 : size(N, 1)
    hjorneNodeNr

    vG = zeros(dim, dim, dim, 'int8');
    [vG, EkappLngArr, NrotArr] = mesh2voxCorner(vG, E, N, EpriArr, EkappLngArr, NrotArr, hjorneNodeNr, paramStruct);  
    
    % fig2; plotVg(vG, 'dark','edgeOff'); plotVgBoundingBox(vG);
    
    % Lager unikt navn for stl lagring
    stlName = ['hjorne-' num2str(hjorneNodeNr) '.stl'];
    
    % Lager unikt navn for .mat lagring
    matName = ['vG-' num2str(hjorneNodeNr)];   
    
    save(matName,'vG');
    vox2stl(vG, stlName, paramStruct.tykkLagPrinter, 'smooth', 2);
end


% Husker å ta vare på resulterende kappelengder og evt vinkler
save EkappLngArr;
save NrotArr;

% Plotter alle hjørner i ett plott
fig1;
for hjorneNodeNr = 1 : size(N, 1)
    hjorneNodeNr

    % Lager .mat navn 
    matName = ['vG-' num2str(hjorneNodeNr) '.mat'];   
    
    load(matName, 'vG');
    
    [F, V] = vox2quadPoly(vG);
    V = smoothQuadVertex2(F, V, 'loop', 1);
    V = V - dim/2;
    V = ( rotx(-NrotArr(hjorneNodeNr, 1)) * roty(-NrotArr(hjorneNodeNr, 2)) * V')';
    Vm = V.*paramStruct.tykkLagPrinter./1000 + N(hjorneNodeNr, :);
    plotPoly(F, Vm, 'dark', 'edgeOff');  
end

% Plotter mesh
plotMesh(E, N, 'dark');

% Plotter rør
for ei = 1 : size(E, 1)
    start = N(E(ei, 1), :);
    slutt = N(E(ei, 2), :);
    [F, Vc] = polyQuadCylinderSemiClosed(4/1000, 50, 2, 2, start, slutt);
    plotPoly(F, Vc, 'dark', 'edgeOff', 'col', [0.8 0.8 1]);
end






end