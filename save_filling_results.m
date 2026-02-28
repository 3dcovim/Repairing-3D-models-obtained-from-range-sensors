function save_filling_results(vertices, caras, vertices_huecos, caras_huecos, path_intermedio, nombre_fichero, extension, automatico,path_mallas,parametros) 

    %%%% INICIO DEFINICION NOMBRE DE ARCHIVO
    if(automatico==0)
        nombre_archivo = input(['Nombre del archivo([ENTER] ' nombre_fichero '_rellena'   '):'],'s');
        if(isempty(nombre_archivo))
            nombre_archivo=[nombre_fichero];
        end
        nombre_archivo=[path_intermedio nombre_archivo];
        
    else
        nombre_archivo=[path_intermedio nombre_fichero];
        %%%% En modo automático se aplican los algoritmos de reparación de
        %%%% la malla antes de guardar los resultados.
        [vertices,caras]=Repara_malla(vertices,caras);
        %         [vertices_huecos,caras_huecos]=Repara_malla(vertices_huecos,caras_huecos);
        
    end
    cadena_mas=[num2str(parametros(1,1)) ' ' num2str(parametros(1,2)) ' ' num2str(parametros(1,3)) ' ' num2str(parametros(1,4))];
    %%%% FIN DEFINICION NOMBRE DE ARCHIVO
    if(~isdir([path_intermedio]))
        mkdir([path_intermedio]);
        
    end
    copyfile([path_mallas nombre_fichero extension],[path_intermedio nombre_fichero extension],'f');
    %%%% Se graban las mallas resultantes: malla total rellena y malla
    %%%% correspodiente sólamente a los huecos generados.
    if (strcmp(extension,'.wrl'))
        aresnew=indexedfaceset('vertices',vertices,'connectivity',caras);
        savevrml(aresnew,[nombre_archivo '_rellena_' cadena_mas '.wrl']);
        aresnew=indexedfaceset('vertices',vertices_huecos,'connectivity',caras_huecos);
        savevrml(aresnew,[nombre_archivo '_' cadena_mas '_huecos_' '.ply']);
    elseif (strcmp(extension,'.off'))
        %     options.method = 'slow';
        %     caras = perform_faces_reorientation(vertices,caras, options);
        %         carastempo=caras;
        %         caras=[carastempo(:,2) carastempo(:,1) carastempo(:,3)];
        saveoff(vertices,caras,[nombre_archivo '_rellena_' cadena_mas '.off']);
        saveoff(vertices_huecos,caras_huecos,[nombre_archivo '_' cadena_mas '_huecos_' '.ply']);
    elseif (strcmp(extension,'.asc'))
        saveasc(vertices,caras,[nombre_archivo '_rellena_' cadena_mas '.off']);
        saveasc(vertices_huecos,caras_huecos,[nombre_archivo '_' cadena_mas '_huecos_' '.ply']);
    elseif (strcmp(extension,'.ply'))
        write_ply(vertices,caras,[nombre_archivo '_rellena_' cadena_mas '.ply'], 'binary_big_endian');
        write_ply(vertices_huecos,caras_huecos,[nombre_archivo '_' cadena_mas '_huecos_' '.ply'], 'binary_big_endian');
    end