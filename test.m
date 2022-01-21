% Noder
% Dimensjoner i meter, skalerer ned til desimeter senere
N = [2 2 2
     3 2 2
     2 3 2
     3 3 2
     
     2 2 3
     3 2 3
     %2.2 2.5 3.6
     2 3 3
     3 3 3
     
     2 2 4
     3 2 4
     2 3 4
     3 3 4];

N = N/10;

% Edges, kanter
 E = [5 1
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

trekanter = [];

tall = 0;
%nodes = []

for node = 5 : size(N,1) % size(E,1) gir antall rader/edger % Finner nodenr
    vektorer = [];
    
    %N(i,:)
    %denen = size(E,1)
    
    for edge = 1 : size(E,1)
        
        if E(edge,1) == node
            vektorer = [vektorer
                        E(edge,:)];
        elseif E(edge,2) == node
            vektorer = [vektorer
                        E(edge,:)];
        else
            vektorer = vektorer;
        end
            
    end
    
    % Søker etter endepunkter for vektorer for trekanter
    for u = 1 : size(vektorer,1) - 1
        
        % Finner noden den første vektoren går til
        if vektorer(u,1) ~= node
            pkt1 = vektorer(u,1);
        else
            pkt1 = vektorer(u,2);
        end
        
        for v = u+1 : size(vektorer,1)
            % Finner noden den andre vektoren går til
            if vektorer(v,1) ~= node
                pkt2 = vektorer(v,1);
            else
                pkt2 = vektorer(v,2);
            end
            
            if nnz(ismember(E, [pkt1, pkt2], 'rows') > 0)
                trekanter = [trekanter
                             node pkt1 pkt2];
            elseif nnz(ismember(E, [pkt2, pkt1], 'rows') > 0)
                trekanter = [trekanter
                             node pkt2 pkt1];
            else
                trekanter = trekanter;
            end
        end
        %I = ismember(vektorer, w
        
        
        %trekanter = [trekanter
         %            denne];
    
    end
    
    %vektorer = sort(vektorer,2)
    
end
%mesh2vox

trekanter = sort(trekanter,2);
faces = unique(trekanter, 'rows');

%N = N * 2500; % Increasing resulting vox resolution (size of vG)
%margin = 30; % Expanding vG to enclose all nodes i N with a margin of 100
% This value is a kind of inverse radius, and must be found by trial and error
% The smaller value - the more voxels will be made (thicker edges)
%rad = 0.08;
%vG = mesh2voxScalField(E,N, rad, margin, 'slim');
%plotVg(vG,'edgeOff','dark');plotVgBoundingBox(vG,'dark');