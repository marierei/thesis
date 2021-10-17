vG_1 = zeros(5,5,2,'int8')
vG_1(:,:,:) = 1   % Indekserer i de aktuelle dimensjonene

clf;    % Oppretter figurvindo og klarerer det
plotVg(vG_1);     % Legg til 'dark' som argument for å få mørkt vindu
plotVgBoundingBox(vG_1,'txt');    % 'txt' gir navn på akser

boxXlength = 5;
boxYlength = 5;
boxZlength = 2;
vG_2 = voxBox(boxXlength, boxYlength, boxZlength);

radius = 9;

vG_3 = voxSphere(radius);
clf;
plotVg(vG_3,'edgeOff');

nnz(vG_3)