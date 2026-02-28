function [vertices,caras,normales,terminar,extension,nombre_fichero,path_mallas,path_intermedio]=load_mesh_to_fill(nombre_malla)


%%%% Directorio donde se encuentran las mallas a rellenar
path_mallas=['C:\Users\Emiliano\Documents\MATLAB\mallas_huecos\'];
%%%% DETECCION DE NOMBRE Y EXTENSION DEL FICHERO
extension=nombre_malla(1,end-3:end);
nombre_fichero=nombre_malla(1:end-length(extension));
if(strcmp(extension,'.mat'))
    nombre_fichero=nombre_malla(1:(find(nombre_malla=='_')-1));
end

%%%% Ruta de la carpeta que se creará con los datos de salida para una
%%%% malla concreta
path_intermedio=[path_mallas nombre_fichero '\'];

%%%% Inicio:  Carga de los datos de las mallas: vertices, caras y normales
%%%% La funcion compute_normal calcula las normales, si el fichero no las
%%%% incluia.
if (strcmp(extension,'.wrl'))
    malla=loadvrml([path_mallas nombre_malla]);
    vertices=malla.vertex_coords;
    caras=malla.face_vertices_m;
    normales=malla.vertex_normals;
    terminar=0;
elseif (strcmp(extension,'.off'))
    [vertices,caras]=readoff([path_mallas nombre_malla]);
    [normales,normalesf] = compute_normal(vertices,caras);
    normales=normales';
    terminar=0;
elseif (strcmp(extension,'.asc'))
    [vertices,caras]=readasc([path_mallas nombre_malla]);
    [normales,normalesf] = compute_normal(vertices,caras);
    normales=normales';
    terminar=0;
elseif (strcmp(extension,'.obj'))
    % [vertices,caras,normales] = read_obj([path_mallas nombre_malla]);
    obj = readObj([path_mallas nombre_malla]);
    vertices=obj.v;
    caras=obj.f;
    normales=obj.vn;
    terminar=0;
elseif(strcmp(extension,'.ply'))
    [vertices,caras] = read_ply([path_mallas nombre_malla]);
    [normales,normalesf] = compute_normal(vertices,caras);
    normales=normales';
    terminar=0;
elseif(strcmp(extension,'.stl'))
    [vertices,caras,tnormales]=STL_Import([path_mallas nombre_malla],1);
    [normales,normalesf] = compute_normal(vertices,caras);
    normales=normales';
    terminar=0;
elseif(strcmp(extension,'.mat'))
    load([path_intermedio nombre_malla]);
    if(size(vertices,1)~=size(normales,1))
        [normales,normalesf] = compute_normal(vertices,caras);
        normales=normales';
    end
    terminar=0;
    num_h_inicial=length(h_modify)-h_procesados;
else
    terminar=1;
    automatico=1;
    disp('Formato de archivo no admitido');
end
%%%% Fin:  Carga de los datos de las mallas