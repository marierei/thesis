function [vG, E] = mesh2voxCorner(vG, N, E, nrNcent, coStruct, varargin)

% nrNcent : er nummer på den noden vi her lager hjørne rundt (centerNode)

% Lager vG for å generere VOX hjørne i
% Gjør om dimensjoner fra mm/m til voxels
% Finner beste rotasjoner for support og roterer og sentrerer hele meshen slik at centerNode havner midt i vG
% Lager VOX kule rundt centerNode med radius tilsvarende max tilkoblet edge tykkelse
% Lager en hjelpe grid "vGholes" for å lage inverterte VOX hull i, lengden
%   på disse er fra centerNode til nabonoden slik at de matcher edgene
%   og man kan unngå å lage nye hull som kjrasjer i gamle hull eller edger
% ...
%
% varargin: "verb" - gir hull plott og litt info
% varargin: "bur" -  lager HP bur med nodenummer

verbose = 0;
bur = 0;
readVgrarginInput();

thiWall = coStruct.wallT;           % Veggtykkelse (mm)
lngHole = coStruct.holeLng;         % Hullengde (mm)
heiLay = coStruct.layerThickness;   % Priter laghøyde (mm)
radSup = coStruct.suportRadius;     % Radius på support vegg-framside (halparten av support veggtykelse) (voxels)
angMinSup = coStruct.minSuportAng;  % Min vinkel på edge mor xy-planet som ikke gir support (grader)
typeRot = coStruct.rotaType;        % 1 - Rotere slik at man får minst behov for suppert inne hull
radOfillet = coStruct.oFilletR;     % Rad på outerfillet (voxels)
radIfillet = coStruct.iFilletR;     % Rad på innerfillet (voxels)

% krever like sider på vG
dimVg = max(size(vG));
lngIniRodHole = dimVg/2 - 10; % Default hull lng for søk (voxels) ??

% lager liste over edger i kontakt med nrCent
matchTmp = (E(:,1:2) == nrNcent);
nrConnectedEdgesArray = find(matchTmp(:,1) | matchTmp(:,2) ); % Finner fra index

% Sorterer etter prioritetsliste
if nnz(E(:,4)) == 0 % ikke spesifisert prio, setter inn default verdier
    E(:,4) = [1:size(E,1)]';
end
nrConnectedEdgesArrayTmp = [E(nrConnectedEdgesArray,4)' ; nrConnectedEdgesArray']';
nrConnectedEdgesArrayTmp = sortrows(nrConnectedEdgesArrayTmp,1);
nrConnectedEdgesArray = nrConnectedEdgesArrayTmp(:,2);

% Lengde, node center til start på hull
% Sortert på Edge nr, inneholder alle edgeNr i E, dvs det blir endel 0
lngCentToHoleStartArray = zeros(size(E,1), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH omforme alle dim til voxels / og sentrere i vG

% Skaler fra enhet i meter/mm, til voksel. forexempel: 0.1mm (sidevegg voxel / laghï¿½yde for printer)
N = 1000 * N(:,1:3) / heiLay; %  mesh org oppgitt i meter
lngHole = lngHole / heiLay; % ble oppgitt i mm

% Coordinat centerNode orginal
cooCentNodeOrg = floor( N(nrNcent,:) );
% Flytt mesh slik at centerNode kommer midt i postive kvadrant (midt i vG)
N = N - [cooCentNodeOrg(1)-dimVg/2 cooCentNodeOrg(2)-dimVg/2 cooCentNodeOrg(3)-dimVg/2];
% Coordinat centerNode skal nå havne i midten av vG
cooCentNode = floor( N(nrNcent,:) );
%figure(3);clf;plotMesh(Ns, E,'nodes',10);

thiWall = floor(thiWall/heiLay);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MESH ROTERE

% roterer mesh for support
if typeRot == 1
    [angBestRotX,angBestRotY] = findRotV1(N, nrNcent, cooCentNode);
else
    [angBestRotX,angBestRotY] = findRotV2(N, nrNcent, cooCentNode);
end

% flytter cooCentNode til origo for å kunne rotere
N = N - cooCentNode;
N = (roty(angBestRotY) * rotx(angBestRotX) * N')';
% flytter cooCentNode tilbake
N = N + cooCentNode;

% lagrer vinklene som ble funnet og brukt, i N colonne 4,5
N(nrNcent,4) = angBestRotX;
N(nrNcent,5) = angBestRotY;

%figure(4);clf;plotMesh(Ns, E, 'txt');plotVgBoundingBox(vG);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lager VOX KULE i centerNode

radMax = sqrt( max(E(nrConnectedEdgesArray,3)) / pi ); % Matcher max edge tykkelse
radMax = 1000 * radMax/heiLay; % Radius i voxels
radKule = floor(radMax + thiWall); % Runder av
vG = vGsphere(vG, cooCentNode,1, radKule);

%figure(2);clf;plotVg(vG,'edgeOff');scaleUpFig(1.6);plotVgBoundingBox(vG);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOX ROD HULL (invertert)
% Her lages alle inverterte hull

vGinvHoles = zeros(dimVg,dimVg,dimVg,'int8');

% lager alle hullrods, adderer til vGholes
for nrEdge = nrConnectedEdgesArray'
    [vGinvHoles, lngCentToHoleStartArray]  = makeInverseHoleRod(vGinvHoles, nrEdge, lngCentToHoleStartArray);
    %nrEdge
    %lngCentToHoleStartArray
end

if verbose
    figure(34);clf;plotVg(vGinvHoles,'edgeOff');plotVgBoundingBox(vG);title('Hull ');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOX ROD
% Har lages alle rods
% her blir endelig kuttelengde modifisert

if verbose
    fprintf("Lager VOX rods\n");
end

for nrEdge = nrConnectedEdgesArray'
    vG = makeRod(vG, nrEdge, lngCentToHoleStartArray);
end
%figure(2);plotVg(vG,'edgeOff');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOX SUPPORT

if radSup > 0
    vG = addSuport(vG, lngCentToHoleStartArray);
end

%figure(3);clf;plotVg(vGholes,'edgeOff');scaleUpFig(1.6);plotVgBoundingBox(vG);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOX FILLET

if radIfillet > 0
    vG = innerFillet(vG, radIfillet,'optim');
end
if radOfillet > 0
    vG = outerFillet(vG, radOfillet);
end

%figure(3);clf;plotVg(vGholes,'edgeOff');scaleUpFig(1.6);plotVgBoundingBox(vG);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOX CUT HOLES
% Her kuttes alle hull ut

vG =  (vG-vGinvHoles)>0;

%figure(4);clf;plotVg(vG,'edgeOff');scaleUpFig(1.6);

% oppdaterer kuttliste i mm
E(:,5) = E(:,5) - lngCentToHoleStartArray * coStruct.layerThickness / 1000;

if verbose
    fprintf("Rotasjoner (grader), rotX: %d , rotY: %d \n", N(nrNcent,4), N(nrNcent,5))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HP bur

if bur
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [vGinvHoles, lngCentToHoleStartArray]  = makeInverseHoleRod(vGinvHoles, nrEdge, lngCentToHoleStartArray)
        % Tar inn lngCentToHoleStartArray og legger til:
        %   en ny invertert rod til vGholes
        %   lngCentToHoleStart i array: lngCentToHoleStartArray
        %
        % "naboNoden" er den andre noden på samme edge som centerNoden

        radiHull = 1000*sqrt(E(nrEdge,3)/pi)/heiLay; % voxels

        % finner nummer på naboNoden
        if E(nrEdge,1) == nrNcent
            nrNnabo = E(nrEdge,2);
        else
            nrNnabo = E(nrEdge,1);
        end

        cooNabo = N(nrNnabo,1:3);
        vecCentNabo = cooNabo - cooCentNode;

        lngCentToHoleStart = findCrashLen(vGinvHoles, vecCentNabo, radiHull);
        lngCentToHoleStartArray(nrEdge) = lngCentToHoleStart;

        vecStart = cooCentNode + lngCentToHoleStart * vecCentNabo/norm(vecCentNabo);
        vecEndUttafor = cooCentNode + lngIniRodHole * vecCentNabo/norm(vecCentNabo);

        vGinvHoles = vGrodWithAngle(vGinvHoles, 1, vecStart,vecEndUttafor, radiHull);
        %figure(3);clf;plotVg(vGholes,'edgeOff');scaleUpFig(1.6);plotVgBoundingBox(vG);
    end

    function lngCentHoleStart = findCrashLen(vGinvHoles, vecCentNabo, radiHull)
        % Finner lngCentHoleStart basert på å unngå krasj med tidligere
        %   genererte inv rods i vGholes
        % lager en kortere edge å søke rundt for ikke å gå uttafor vG

        margin = 5;
        lenHoleDefault = dimVg/2-radiHull; % gammel 120

        % lager søkelinje med start retning nabonode mot centerNode
        % cooLineEnd er innafor vG
        cooLineEnd = cooCentNode + lenHoleDefault * vecCentNabo/norm(vecCentNabo);

        vecLine = cooLineEnd - cooCentNode;

        n = [0 0 1];
        cro = cross(n,vecLine);

        angRot = angVectVect3D(n,vecLine);

        % buelengde = R * ang(rad) = 0.9
        dA = 0.9/radiHull;

        lngCentHoleStart = 0;
        stop = 0;
        t = 0;
        while t<1 && stop==0
            p = cooLineEnd + (cooCentNode-cooLineEnd)*t; % scanner fra cooLineEnd inn til cooCentNode

            for a = 0 : dA : 2*pi
                m = radiHull * [cos(a) sin(a) 0];
                m2 = (radiHull-12) * [cos(a) sin(a) 0]; % denne skitt effekten av sirkeloverlapp i 3D

                % roterer m rundt cro
                mR = rotPoiAroundVect(m, cro, angRot);
                mR2 = rotPoiAroundVect(m2, cro, angRot);
                % translaterer og cast
                mR = round(mR+p);
                mR2 = round(mR2+p);
                if vGinvHoles(mR(1), mR(2), mR(3)) == 1 || vGinvHoles(mR2(1), mR2(2), mR2(3)) == 1
                    stop = 1;
                    lngCentHoleStart = norm(p-cooCentNode) + margin;
                end
            end
            t = t + 1/norm(vecLine);
        end
    end

    function vG = makeRod(vG, nrE, lngCentToHoleStartArray)

        radiWall = 1000*sqrt(E(nrE,3)/pi)/heiLay + thiWall*2;

        if E(nrE,1) == nrNcent
            nrNnabo = E(nrE,2);
        else
            nrNnabo = E(nrE,1);
        end

        cooNabo = N(nrNnabo,1:3);
        vecCentNabo = cooNabo - cooCentNode;

        %lngExtended = findCrashLen(vGinvHoles, vecCentNabo, radiWall); % Større enn radihull
        lngCent2holeStart = lngCentToHoleStartArray(nrE);
        %lngEnd = max(lngCent2holeStart + lngHole, lngExtended); % Vil ikke slutte før veggene slipper

        lngEnd = lngCent2holeStart + lngHole;

        vecStart = cooCentNode;
        vecEnd = cooCentNode + lngEnd * vecCentNabo/norm(vecCentNabo);

        vG = vGrodWithAngle(vG, 1, vecStart,vecEnd, radiWall-thiWall);
    end

    function [angBestRotX,angBestRotY, angMin] = findRotV1(N, nrNcent, vecCent)
        % maximaliserer min vinkel til xy planet
        angMin = -pi/2;
        angBestRotX = 0;
        angBestRotY = 0;

        N1 = (N - vecCent)'; % center til origo og translaterer for rot

        for rx=1:360
            N2 = rotx(rx) * N1;
            for ry=1:360
                N3 = roty(ry) * N2;

                angMinRotXY = pi/2;
                % itererer alle rods
                for nn=1:size(N3,2)
                    if nn ~= nrNcent
                        ang = real(asin( (N3(3,nn)-N3(3,nrNcent)) / norm(N3(:,nn)-N3(:,nrNcent)) ));
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

    function [angBestRotX,angBestRotY] = findRotV2(N, nrNCent, vecCent)
        % legger to av edgene ned i xy planet
        angBestRotX = 0;
        angBestRotY = 0;
        angLimit = deg2rad(2);

        N1 = (N - vecCent)'; % centrer til origo og translaterer for rot

        for rx=1:360 % deg
            N2 = rotx(rx) * N1;
            for ry=1:360
                N3 = roty(ry) * N2;

                % itererer alle rods
                angMin = 0;

                antFunnetNullVinkelRods = 0;
                for nn=1:size(N3,2)
                    if nn ~= nrNCent
                        % radian
                        ang = real(asin( (N3(3,nn)-N3(3,nrNCent)) / norm(N3(:,nn)-N3(:,nrNCent)) ));
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

    function vG = addSuport(vG, lngCentToHoleStartArray)
        % mï¿½ finne linje punkt fra meg mot alle nabonoder som har vinkel
        % mindre enn 45grad. Linjepukt skal bare gï¿½ i lengde=rodlengde
        % linjepunkt gjï¿½re som til vox og droppes ned helt til baseline
        % eller en annen vox

        angMinSupR = deg2rad(angMinSup); % oppgitt i deg

        % 2D kulevindu, evt. hvis man vil bruke
        vindu = zeros(radSup*2+1, radSup*2+1, 1,'int8');
        rr = radSup*radSup;
        for x = 1 : radSup*2+1
            for y = 1 : radSup*2+1
                xx = x - radSup -1;
                yy = y - radSup -1;
                if xx*xx + yy*yy < rr
                    vindu(x,y,1) = 1;
                end
            end
        end

        % finner min aktiv Z i vG
        minZ = 10000;
        for x=1:dimVg
            for y=1:dimVg
                for z=1:dimVg
                    if vG(x,y,z)== 1
                        if z < minZ
                            minZ = z;
                        end
                    end
                end
            end
        end

        for nrEdg = nrConnectedEdgesArray'   % nn = 1 : size(Npru,1)
            % nrNmeg er noden fra cent
            if E(nrEdg,1) == nrNcent
                nrNmeg = E(nrEdg,2);
            else
                nrNmeg = E(nrEdg,1);
            end

            vecMeg = N(nrNmeg,1:3);
            vecCen = N(nrNcent,1:3);
            vecCenMeg = vecMeg-vecCen;

            ang = real( asin( vecCenMeg(3) / norm(vecCenMeg) ) );
            if ang < angMinSupR

                % normaliserer lengde fï¿½r skalering
                vecCenMegN = vecCenMeg/norm(vecCenMeg);
                lngCent2HoleStart = lngCentToHoleStartArray(nrEdg);
                lngCent2RodEnd = lngCent2HoleStart + lngHole;

                p1 = cooCentNode;
                p2 = cooCentNode + lngCent2RodEnd * vecCenMegN;

                vDir = p2-p1;

                for i = 0 : 0.003 : 1
                    xP = floor( vDir(1)*i + p1(1) );
                    yP = floor( vDir(2)*i + p1(2) );
                    zP = floor( vDir(3)*i + p1(3) );
                    %vG(xP-16:xP+16, yP-16:yP+16, minZ:zP) = 1;

                    for zd = zP : -1 : minZ
                        vG(xP-radSup:xP+radSup, yP-radSup:yP+radSup, zd) = vindu | vG(xP-radSup:xP+radSup, yP-radSup:yP+radSup, zd);
                    end
                end
                % kutter overskytende rask
%                 p3 = p2 + 20*vDir/norm(vDir);
%                 radHole = 1000*sqrt(E(nrEdg,3)/pi)/heiLay + thiWallS;
%                 vG = vGrodWithAngle(vG, p2,p3, radHole, 0); % margin pï¿½ 10
            end

        end
    end

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
