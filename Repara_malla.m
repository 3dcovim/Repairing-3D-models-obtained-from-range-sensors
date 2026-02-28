function [vertices_sal,caras_sal]=Repara_malla(vertices_ent,caras_ent)
        disp('Se detectan las caras oscilantes del relleno generado');
        [vertices_ent,caras_ent]=meshcheckrepair(vertices_ent,caras_ent,'deep');
        caras_ent=EliminaOscilantes(caras_ent);
        
        [vertices_ent,caras_ent]=meshcheckrepair(vertices_ent,caras_ent,'isolated');
        [vertices_sal,caras_sal]=meshcheckrepair(vertices_ent,caras_ent,'duplicated');
        gruposcaras=finddisconnsurf(caras_sal);
        if (size(gruposcaras,2)>1)
            islotes=cellfun('length',gruposcaras);
            [islamax,indisla]=max(islotes);
            [filmax,colmax]=find(islotes<islamax*0.10);
            islasvalidas=setdiff(1:length(islotes),colmax);
            caras_sal=[];
            for indimax=1:(length(islasvalidas))
                caras_sal=[caras_sal;gruposcaras{1,islasvalidas(indimax)}];
            end

            disp(['Se han eliminado ' num2str((size(gruposcaras,2)-1)) ' grupos']);
        end