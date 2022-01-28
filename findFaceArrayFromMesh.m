% Finds all triangle faces of the mesh structure
function faces = findFaceArrayFromMesh(E,N)

trekanter = [];

for node = 5 : size(N,1) % size(E,1) gir antall rader/edger % Finner nodenr
    vektorer = [];
    
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
    end
end

trekanter = sort(trekanter,2);
faces = unique(trekanter, 'rows');
