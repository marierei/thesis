function [vG, EkappLngArr, NrotArr] = mesh2voxCorner(vG, E, N, EpriArr, EkappLngArr, NrotArr, hjorneNodeNr, PS, varargin)
    % N: inn, oppgitt i meter, men omformes til voxel her
    %    [x y z] (meter/vox)
    % E: inn/ut
    %    [n1 n2  areal(meter^2) prioritetsverdi edgeLengde (meter)]
    % vG, inn/ut, må være stor nok til å omslutte vokselhjørnet som blir generert
    % varargin: "verb" - gir hull plott og litt info
    % varargin: "bur" -  lager HP bur med nodenummer
    
    % Må oppgis inn:
    PS.tykkWall = mm2vox(PS.tykkWall, PS);             % Veggtykkelse (mm -> vox)
    PS.lngHole = mm2vox(PS.lngHole, PS);               % Hullengde (mm -> vox)
    PS.breddeSupport = mm2vox(PS.breddeSupport, PS);   % Radius på support vegg-framside, halparten av support veggtykelse (mm -> vox)
    PS.angMinSupport;                                  % Min vinkel på edge mor xy-planet som ikke gir support (grader)
    PS.typeRot;                                        % 1 - Rotere slik at man får minst behov for suppert inne hull
    PS.radOfillet = mm2vox(PS.radOfillet, PS);         % Rad på outerfillet (mm -> vox)
    PS.radIfillet = mm2vox(PS.radIfillet, PS);         % Rad på innerfillet (mm -> vox)
    PS.niCornerNode = hjorneNodeNr;                    % Index på corn node man vil lage hjørne rundt
    
    N = m2vox(N, PS);                                  % Mesh (meter -> vox), blir flyttet og rot slik at niCornerNode kommer midt i vG
    E;                                                 % [n1 n2  areal(meter^2) prioritetsverdi edgeLengde (meter)]
    
    % Genereres:
    PS.nCornerNode = N(PS.niCornerNode, 1:3);          % Node coorinater til cornerNode man vil lage hjørne rundt (vox)
    PS.eiConnectedEdges = [];                          % Liste over edger i kontakt med corn node, sortert etter prioritet
    PS.lngCornToHoleStartArray = zeros(size(E, 1), 1); % Leng fra corn node til start på hvert hull,
    % sortert etter Edge index, inneholder alle edgeNr i E, dvs det blir endel 0
    
    vGinvHoles = [];                                   % Voxelgrid, alle inv rods, samme dim som vG
    PS.lngInversRodHoleDef = [];                       % Default invers hull lng for krasj søk
    
    angBestRotX = [];                                  % Valgt rotering for support
    angBestRotY = [];                                  % Valgt rotering for support
    
    dimVg = [];                                        % vG inn må være stor nok til å omslutte vokselhjørnet som blir generert
    
    %% Info
    
    % Detaljer:
    % Finner beste rotasjoner for support og roterer og sentrerer hele meshen slik at centerNode havner midt i vG
    % Lager VOX kule rundt centerNode med radius tilsvarende max tilkoblet edge tykkelse
    % Lager en hjelpe grid "vGholes" for å lage inverterte VOX hull i, lengden
    %   på disse er fra centerNode til nabonoden slik at de matcher edgene
    %   og man kan unngå å lage nye hull som kjrasjer i gamle hull eller edger
    
    verbose = 0;
    bur = 0;
    readVgrarginInput();
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Format vG
    
    % Krever like sider på vG, lager vG på nytt
    dimVg = size(vG);
    if dimVg(1) ~= dimVg(2) || dimVg(1) ~= dimVg(3) || dimVg(2) ~= dimVg(3)
        fprintf("resizer vG til %d x %d x %d \n", max(dimVg), max(dimVg), max(dimVg));
        vG = zeros(max(dimVg), max(dimVg), max(dimVg), 'int8');
    end
    dimVg = max(dimVg);
    
    %% Lager liste over edger i kontakt med niCornerNode
    matchTmp = E(:, 1:2) == PS.niCornerNode;
    PS.eiConnectedEdges = find(matchTmp(:,1) | matchTmp(:,2) ); % Finner indexer
    
    % Fyller inn prioriteringer hvis ikke spesifisert
    if any(EpriArr) == 0
        EpriArr = [1:size(E,1)]';
    end
    
    % Sorterer eiConnectedEdges etter prio
    eConnectedEdgesArrayTmp = [EpriArr(PS.eiConnectedEdges)' ; PS.eiConnectedEdges']';
    eConnectedEdgesArrayTmp = sortrows(eConnectedEdgesArrayTmp, 1);
    PS.eiConnectedEdges = eConnectedEdgesArrayTmp(:, 2);
    
    %% N MESH - sentrere i vG
    
    % Coordinat centerNode orginal
    PS.nCornerNode = floor(N(PS.niCornerNode, :));
    
    % Flytt mesh slik at cornerNode kommer midt i postive kvadrant (midt i vG)
    N = N - [PS.nCornerNode(1) - dimVg/2, PS.nCornerNode(2) - dimVg/2, PS.nCornerNode(3) - dimVg/2];
    PS.nCornerNode = N(PS.niCornerNode, 1:3);
    % Coordinat på nCornerNodeVox skal nå havne i midten av vG, de andre nodene kan være uttafor
    
    % fig2;plotMesh(E, N, 'dark'); return
    
    %% MESH ROTERE
    
    % Finner beste ang for support rot
    if PS.typeRot == 1
        [angBestRotX, angBestRotY] = findRotV1(N, PS);
    else
        [angBestRotX, angBestRotY] = findRotV2(N, PS);
    end
    
    % Flytter nCentNode til origo for å kunne rotere for support
    N = N - PS.nCornerNode;
    N = (roty(angBestRotY) * rotx(angBestRotX) * N')';
    % flytter cooCentNode tilbake til vG senter
    N = N + PS.nCornerNode;
    
    % fig3; plotMesh(E, N, 'dark', 'txt') ; plotVgBoundingBox(vG); return;
    
    %% Lager VOX KULE i cornerNode
    
    radMaxEdge = squareM2vox( max(E(PS.eiConnectedEdges, 3)), PS); % Finner max edge tykkelse radius (vox)
    radKule = radMaxEdge + PS.tykkWall;
    
    r2 = radKule * radKule;
    
    dimVg2 = floor(dimVg/2);
    
    xyzMin = dimVg2 - radKule;
    xyzMax = dimVg2 + radKule;
    
    parfor x = xyzMin : xyzMax
        for y = xyzMin : xyzMax
            for z = xyzMin : xyzMax
                
                if (x - dimVg2)^2 + (y - dimVg2)^2 + (z - dimVg2)^2 < r2
                    vG(x, y, z) = 1;
                end
                
            end
        end
    end
    
    % fig3; plotVg(vG, 'dark', 'edgeOff'); plotVgBoundingBox(vG); return % treg plotter
    
    %% VOX ROD HULL (invertert)
    % Her lages alle inverterte rod hull
    
    vGinvHoles = zeros(dimVg, dimVg, dimVg, 'int8');
    
    PS.lngInversRodHoleDef = dimVg/2 - radKule - 5;
    
    % lager alle hullrods, adderer til vGholes
    for eiHoleEdge = PS.eiConnectedEdges'
        [vGinvHoles, PS] = makeInverseHoleRod(vGinvHoles, E, N, eiHoleEdge, PS);
        % nrEdge
        % lngCentToHoleStartArrayVox
    end
    
    if verbose
        fig3; plotVg(vGinvHoles, 'dark', 'edgeOff', 'col', [0.7 0.7 1]); tittle(['Hull node: ' num2str(PS.niCornerNode)]);
    end
    
    %% VOX ROD
    % Har lages alle rods
    % Her blir endelig kuttelengde modifisert
    
    if verbose
        fprintf("Lager VOX rods\n");
    end
    
    for eiEdge = PS.eiConnectedEdges'
        vG = makeRod(vG, E, N, eiEdge, PS);
    end
    
    % fig2; plotVg(vG, 'edgeOff', 'dark'); plotVgBoundingBox(vG); return
    
    %% VOX SUPPORT
    
    if PS.breddeSupport > 0
        if verbose
            fprintf("Lager support \n");
        end
        vG = addSuport(vG, E, N, dimVg, PS);
    end
    
    %figure(3);clf;plotVg(vGholes,'edgeOff');plotVgBoundingBox(vG);
    
    %% VOX FILLET
    
    if PS.radIfillet > 0
        if verbose
            fprintf("Lager iFillet \n");
        end
        vG = innerFillet(vG, PS.radIfillet);
    end
    
    if PS.radOfillet > 0
        if verbose
            fprintf("Lager oFillet \n");
        end
        vG = outerFillet(vG, PS.radOfillet);
    end
    
    %figure(3);clf;plotVg(vGholes,'edgeOff');scaleUpFig(1.6);plotVgBoundingBox(vG);
    
    %% VOX CUT HOLES
    % Her kuttes alle hull ut
    
    vG = int8((vG - vGinvHoles) > 0);
    
    if verbose
        fig4; plotVg(vG, 'edgeOff', 'dark'); plotVgBoundingBox(vG);
    end
    
    %% HP bur
    
    if bur
        hpBur();
    end
    
    %% Oppdater EkappLngArr og NrotArr 
    
    EkappLngArr = EkappLngArr - vox2m(PS.lngCornToHoleStartArray, PS);
    NrotArr(hjorneNodeNr, :) = [angBestRotX angBestRotY];
    
    %% readVgrarginInput( )
    function readVgrarginInput()
        while ~isempty(varargin)
            switch varargin{1}
                case 'verb'
                    verbose = 1; varargin(1:1) = [];
                case 'bur'
                    bur = 1; varargin(1:1) = [];
                otherwise
                    error(['Unexpected option: ' varargin{1}]);
            end
        end
    end
    
end


%% makeInverseHoleRod( )
function [vGinvHoles, PS] = makeInverseHoleRod(vGinvHoles, E, N, eiHoleEdge, PS)
    % Tar inn PS.lngCentToHoleStartArray og legger til:
    %   1 ny invertert rod til vGinverseHoles pluss
    %   oppdatere lngCentToHoleStartArray for denne rodden
    %
    % "naboNoden" er den andre noden på samme edge som cornerNode
    
    radHull = squareM2vox(E(eiHoleEdge, 3), PS);
    
    % finner nummer på naboNoden
    if E(eiHoleEdge, 1) == PS.niCornerNode
        niNnabo = E(eiHoleEdge,2);
    else
        niNnabo = E(eiHoleEdge,1);
    end
    
    nNabo = N(niNnabo, 1:3);
    vecCornTilNabo = nNabo - PS.nCornerNode;
    
    lngCentToHoleStart = findCrashLen(vGinvHoles, vecCornTilNabo, radHull, PS);
    PS.lngCornToHoleStartArray(eiHoleEdge) = lngCentToHoleStart;
      
    cooStart = PS.nCornerNode + lngCentToHoleStart * vecCornTilNabo/norm(vecCornTilNabo);
    cooEndUttafor = PS.nCornerNode + PS.lngInversRodHoleDef * vecCornTilNabo/norm(vecCornTilNabo);

    vGinvHoles = voxRodPointToPoint(cooStart, cooEndUttafor, radHull, 'vGin', vGinvHoles);
    
end

%% findCrashLen( )
function [lngCentHoleStart] = findCrashLen(vGinverseHoles, vecCentTilNabo, radHull, PS)
    % Finner lngCentHoleStart basert på å unngå krasj med tidligere genererte inv rods i vGholes
    % Lager en kortere edge å søke rundt for ikke å gå uttafor vG
    
    margin = 5; % til crasj
    
    % lager søkelinje med start retning nabonode mot centerNode
    % cooLineEnd er innafor vG
    
    cooLineEnd = PS.nCornerNode + PS.lngInversRodHoleDef * vecCentTilNabo/norm(vecCentTilNabo);
    vecLine = cooLineEnd - PS.nCornerNode; % axe
    
    n = [0 0 1];
    if vecLine(1) == 0 && vecLine(2) == 0 % MatteHack
       vecLine(1) = 0.000001; 
    end
    cro = cross(n, vecLine); % En vec normal på axe
    
    angRot = angVectVect3D(n, vecLine);
    
    % buelengde = R * ang(rad) = 0.9, mindre enn en voxel
    dA = 0.9/radHull;
    
    stop = 0;
    t = 0;
    lngCentHoleStart = 0; % Usikker på om trengs
    while t<1 && stop==0 % Increment langs axe inn mot corner
        p = cooLineEnd + (PS.nCornerNode - cooLineEnd)*t; % scanner fra cooLineEnd inn til PS.nCornerNode
        
        for a = 0 : dA : 2*pi % Rundt axe
            m = radHull * [cos(a) sin(a) 0];         % roterer punkt m først i 2D
            m2 = (radHull - 12) * [cos(a) sin(a) 0]; % denne skitt effekten av sirkeloverlapp i 3D
            
            % roterer m rundt normal (cross) til axe, med vinkel på axe mot [0 0 1]
            mR = rotPoiAroundVect(m, cro, angRot);
            mR2 = rotPoiAroundVect(m2, cro, angRot);
            % translaterer og cast til int
            mR = round(mR+p);
            mR2 = round(mR2+p);

            if vGinverseHoles(mR(1), mR(2), mR(3)) == 1 || vGinverseHoles(mR2(1), mR2(2), mR2(3)) == 1 % roterer 2 punkt
                stop = 1;
                lngCentHoleStart = norm(p - PS.nCornerNode) + margin; % fant lngCentHoleStart og stopper
            end
        end
        t = t + 1/norm(vecLine); % Increment nedover langs axe vecLine
    end
end

%% makeRod( )
function vG = makeRod(vG, E, N, eiEdge, PS)
    
    radInkludertWall = squareM2vox( E(eiEdge, 3), PS) + PS.tykkWall;
    
    if E(eiEdge, 1) == PS.niCornerNode
        nrNnabo = E(eiEdge, 2);
    else
        nrNnabo = E(eiEdge, 1);
    end
    
    cooNabo = N(nrNnabo, 1:3);
    vecCornNabo = cooNabo - PS.nCornerNode;
    
    %lngExtended = findCrashLen(vGinvHoles, vecCentNabo, radiWall); % Større enn radihull
    lngCent2holeStart = PS.lngCornToHoleStartArray(eiEdge);
    %lngEnd = max(lngCent2holeStart + lngHole, lngExtended); % Vil ikke slutte før veggene slipper
    
    lngEnd = lngCent2holeStart + PS.lngHole;
    
    cooStart = PS.nCornerNode;
    cooEnd = PS.nCornerNode + lngEnd * vecCornNabo/norm(vecCornNabo);
    
    vG = voxRodPointToPoint(cooStart, cooEnd, radInkludertWall, 'vGin', vG);
end

%% findRotV1( )
function [angBestRotX, angBestRotY] = findRotV1(N, PS)
    % maximaliserer min vinkel til xy planet
    angMin = -pi/2; % rad
    angBestRotX = 0; % deg
    angBestRotY = 0;
    
    N1 = (N - PS.nCornerNode)'; % Sentrerer ny N for å legge nCornerNodeVox til origo før rot
    
    for rx = 1:360 % deg
        N2 = rotx(rx) * N1;
        for ry = 1:360
            N3 = roty(ry) * N2;
            
            angMinRotXY = pi/2;
            % itererer alle rods
            for ni = 1:size(N3, 2)
                if ni ~= PS.niCornerNode
                    ang = real(asin( (N3(3, ni) - N3(3, PS.niCornerNode)) / norm(N3(:, ni) - N3(:, PS.niCornerNode)) ));
                    if ang < angMinRotXY
                        angMinRotXY = ang;
                    end
                end
            end
            if angMinRotXY > angMin
                angBestRotX = rx;
                angBestRotY = ry;
                angMin = angMinRotXY;
            end
            
        end
    end
end

%% findRotV2( )
function [angBestRotX, angBestRotY] = findRotV2(N, PS)
    % legger to av edgene ned i xy planet
    angBestRotX = 0;
    angBestRotY = 0;
    angLimit = deg2rad(2);
    
    N1 = (N - PS.nCornerNode)'; % Sentrerer ny N for å legge nCornerNodeVox til origo før rot
    
    for rx = 1:360 % deg
        N2 = rotx(rx) * N1;
        for ry = 1:360
            N3 = roty(ry) * N2;
            
            % itererer alle rods
            angMin = 0;
            
            antFunnetNullVinkelRods = 0;
            for nn = 1:size(N3, 2)
                if nn ~= PS.niCornerNode
                    % radian
                    ang = real(asin( (N3(3, nn) - N3(3, PS.niCornerNode)) / norm(N3(:, nn) - N3(:, PS.niCornerNode)) ));
                    if ang < angMin
                        angMin = ang;
                    end
                    if (ang > 0) && (ang < angLimit) % grader
                        antFunnetNullVinkelRods = antFunnetNullVinkelRods + 1;
                    end
                end
            end
            if antFunnetNullVinkelRods > 1
                if angMin >=0
                    angBestRotX = rx;
                    angBestRotY = ry;
                end
            end
            
        end
    end
end

%% addSuport( )
function vG = addSuport(vG, E, N, dimVg, PS)
    % må finne linje punkt fra cornerNode mot alle nabonoder som har vinkel
    % mindre enn 45grad. Linjepukt skal bare gå i lengde=rodlengde
    % linjepunkt gjøres om til vox og droppes ned helt til baseline
    
    angMinSupR = deg2rad(PS.angMinSupport); % oppgitt i deg
    
    radSup = floor(PS.breddeSupport/2);
    
    % 2D kulevindu, evt. hvis man vil bruke
    vindu = zeros(radSup*2 + 1, radSup*2 + 1, 1, 'int8');
    rr = radSup*radSup;
    for x = 1 : radSup*2 + 1
        for y = 1 : radSup*2 + 1
            xx = x - radSup - 1;
            yy = y - radSup - 1;
            if xx*xx + yy*yy < rr
                vindu(x, y, 1) = 1;
            end
        end
    end
    
    % finner min aktiv Z i vG
    minZ = 10000;
    for x = 1: dimVg
        for y = 1:dimVg
            for z = 1:dimVg
                if vG(x, y, z) == 1
                    if z < minZ
                        minZ = z;
                    end
                end
            end
        end
    end
    
    for nrEdg = PS.eiConnectedEdges'  
     
        % finner nummer på naboNoden - niNnabo
        if E(nrEdg, 1) == PS.niCornerNode
            niNnabo = E(nrEdg, 2);
        else
            niNnabo = E(nrEdg, 1);
        end
        
        cooNabo = N(niNnabo, 1:3);
        vecCornNabo = cooNabo - PS.nCornerNode;       
        
        ang = real( asin( vecCornNabo(3) / norm(vecCornNabo) ) );
        if ang < angMinSupR
            
            % normaliserer lengde før skalering
            vecCornNaboN = vecCornNabo/norm(vecCornNabo);
            lngCent2HoleStart = PS.lngCornToHoleStartArray(nrEdg);
            lngCent2RodEnd = lngCent2HoleStart + PS.lngHole;
            
            p1 = PS.nCornerNode;
            p2 = PS.nCornerNode + lngCent2RodEnd * vecCornNaboN;
            
            vDir = p2 - p1;
            
            for i = 0 : 0.003 : 1
                xP = floor( vDir(1)*i + p1(1) );
                yP = floor( vDir(2)*i + p1(2) );
                zP = floor( vDir(3)*i + p1(3) );
                %vG(xP-16:xP+16, yP-16:yP+16, minZ:zP) = 1;
                
                for zd = zP : -1 : minZ
                    vG(xP - radSup:xP+radSup, yP - radSup:yP + radSup, zd) = vindu | vG(xP - radSup:xP + radSup, yP - radSup:yP + radSup, zd);
                end
                vG = int8(vG);
            end
            % kutter overskytende rask
            %                 p3 = p2 + 20*vDir/norm(vDir);
            %                 radHole = 1000*sqrt(E(nrEdg,3)/pi)/heiLay + thiWallS;
            %                 vG = vGrodWithAngle(vG, p2,p3, radHole, 0); % margin pï¿½ 10
        end
        
    end
end

%% hpBur( )
function hpBur()
    stangRadius = 4;
    
    [minDimX,maxDimX, minDimY, maxDimY, minDimZ, maxDimZ, ~, ~] = findMinMaxVgCoordnates(vG);
    
    Nbur = zeros(8,3); % Bur noder, dim i voxels
    
    Nbur(1,:) = [minDimX-10 minDimY-10 minDimZ-10];
    Nbur(2,:) = [maxDimX+10 minDimY-10 minDimZ-10];
    Nbur(3,:) = [maxDimX+10 maxDimY+10 minDimZ-10];
    Nbur(4,:) = [minDimX-10 maxDimY+10 minDimZ-10];
    
    Nbur(5,:) = [minDimX-10 minDimY-10 maxDimZ+10];
    Nbur(6,:) = [maxDimX+10 minDimY-10 maxDimZ+10];
    Nbur(7,:) = [maxDimX+10 maxDimY+10 maxDimZ+10];
    Nbur(8,:) = [minDimX-10 maxDimY+10 maxDimZ+10];
    
    
    Ebur = zeros(12,2);
    
    Ebur(1,:) = [1 2];
    Ebur(2,:) = [2 3];
    Ebur(3,:) = [3 4];
    Ebur(4,:) = [4 1];
    
    Ebur(5,:) = [5 6];
    Ebur(6,:) = [6 7];
    Ebur(7,:) = [7 8];
    Ebur(8,:) = [8 5];
    
    Ebur(9,:) = [1 5];
    Ebur(10,:) = [2 6];
    Ebur(11,:) = [3 7];
    Ebur(12,:) = [4 8];
    
    for eee = 1 : size(Ebur,1)
        vG = vGrodWithAngle(vG,1, Nbur(Ebur(eee,1),:), Nbur(Ebur(eee,2),:), stangRadius);
    end
    
    for nnn = 1 : size(Nbur,1)
        vG = vGsphere(vG,Nbur(nnn,:),1, stangRadius-1);
    end
    
    % Nummer
    
    Nnummer = zeros(nrNcent*2,3);
    
    xIncr = (maxDimX - minDimX + 10*2) / (nrNcent+1);
    xPos = minDimX-10;
    for nNr = 1 : nrNcent
        xPos = xPos + xIncr;
        Nnummer(nNr,:) = [xPos minDimY-10 maxDimZ+10];
    end
    xPos = minDimX-10;
    for nNr = 1 : nrNcent
        xPos = xPos + xIncr;
        Nnummer(nNr+nrNcent,:) = [xPos maxDimY+10 maxDimZ+10];
    end
    
    Enummer = zeros(nrNcent,2);
    for eNr = 1 : nrNcent
        Enummer(eNr,:) = [eNr eNr+nrNcent];
    end
    
    for eee = 1 : nrNcent
        vG = vGrodWithAngle(vG,1, Nnummer(Enummer(eee,1),:), Nnummer(Enummer(eee,2),:), stangRadius);
    end
    
    % Skraa
    
    Eskraa = zeros(10,2);
    
    Eskraa(1,:) = [1 6];
    Eskraa(2,:) = [2 7];
    Eskraa(3,:) = [3 8];
    Eskraa(4,:) = [4 5];
    Eskraa(5,:) = [1 3];
    
    Eskraa(6,:) = [2 5];
    Eskraa(7,:) = [3 6];
    Eskraa(8,:) = [4 7];
    Eskraa(9,:) = [1 8];
    Eskraa(10,:) = [3 1];
    
    for eee = 1 : 10
        vG = vGrodWithAngle(vG,1, Nbur(Eskraa(eee,1),:), Nbur(Eskraa(eee,2),:), stangRadius);
    end
end

%% mm2vox( )
function [vox] = mm2vox(mm, PS)
    vox = floor(mm./PS.tykkLagPrinter);
end

%% m2vox( )
function [vox] = m2vox(m, PS)
    vox = floor(1000*m./PS.tykkLagPrinter);
end

%% vox2m( )
function [m] = vox2m(vox, PS)
    m = vox.*PS.tykkLagPrinter./1000;
end

%% squareM2vox( )
function [vox] = squareM2vox(m2, PS)
    vox = floor(1000*sqrt(m2/pi)./PS.tykkLagPrinter);
end

%% vox2squareM( )
function [m2] = vox2squareM(vox, PS)
    m2 = (vox.*PS.tykkLagPrinter./1000).^2 .* pi;
end


