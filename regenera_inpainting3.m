function [verticesNew,carasNew,vertices_agujero,carastri,vertices_relleno,caras_relleno]=regenera_inpainting3(vertices,caras,ImagenRangoSin,celdasX,celdasY,mascarapol2,agujeros,agujero_actual,minimanew,foe,iteraciones)

%% Parte 1

%%%% valor_min es el minimo numero de pixels de un hueco para que sea
%%%% considerado como tal y se triangule
valor_min=3;

%%%% invierte indica si se invierte (=1) o no (=0) las normales de las
%%%% caras que genera la funcion triangulate
invierte=1;

refinamiento=0;

%%%% DOS METODOS DE TRIANGULACION: 1= triangulacion antigua; 2=nuevo metodo
%%%% de triangulacion.
triangulacion=2;


% holes=FindHoles(caras,vertices,0);
holes=agujeros;
% carastri=[];
% carastri2=[];


%%%%% APLICACION DEL ALGORITMO DE IMAGE INPAINTING


%%%% ImaNew almacena la Imagen de Rango con valor '0' en las celdas en que
%%%% no existia información 3D
%%%% Se le aplica un factor de escala a los valores Z de la Imagen de Rango
%%%% para que el algoritmo de image inpainting funciones con el menor
%%%% numero de iteraciones posible (ya que se intenta con esto "acercar"
%%%% los valores Z al nivel 0)

ImaNew=ImagenRangoSin;
minimanew=min(min(ImagenRangoSin));
ImaNew=(ImaNew-minimanew).*(ImaNew>0);
maximanew=max(max(ImaNew));
ImaNew2=ImaNew./maximanew;
factor_escala=250;
ImaNew3=ImaNew2.*factor_escala;



%%%% en BW2 se han de seleccionar mediante el raton las zonas de la Imagen
%%%% de Rango que no tienen información 3D y además no son huecos de la
%%%% malla (a los que se le quiere aplicar el algoritmo de relleno)
%%%% "Mascara" almacena las celdas de la Imagen de Rango que son huecos de
%%%% malla y sobre las que se va a aplicar el algortimo de inpainting.

%%%% BW2 = bwselect(~(ImaNew>0),8);


%%%%% NUEVOOOOOOOOOOOOOO  4-06-09
[filolo,cololo]=find((mascarapol2&(~(ImaNew>0)))>0);

BW3 = bwselect(~(ImaNew>0),cololo,filolo,8);
Mascara=BW3;

if(all(all(~Mascara)))
    if(any(any(mascarapol2)))
        Mascara=mascarapol2;
    end
end

% Mascara=mascarapol2;

%%%%% FIN NUEVOOOOOOOOOOOOOO  4-06-09



%%%%%% EDICION INTERACTIVA DEL HUECO
% figure(10);
% BW2 = bwselect(~(ImaNew>0),8);
% %%%% Mascara=(ImaNew>0)+BW2;
%
% Mascara=BW2;

%%%%%% FIN EDICION INTERACTIVA DEL HUECO

% Mascara=mascarapol2;


%%%% Mascara=~Mascara;
% figure,imshow(Mascara)
% mascas=bwselect(Mascara,8);
% Mascara=mascas;



%%%% el algoritmo de inpainting pide 4 datos de entrada: la Imagen de
%%%% Rango, la Mascara que almacena los datos que pertenecen a los huecos,
%%%% p que se calcula a partir de foe_3_8(), y , por ultimo, el numero de
%%%% iteraciones (que como se ha comentado estara relacionado con el factor
%%%% de escala que se haya elegido)


if(foe==1)
    p = foe_3_8();
else
    p = foe_5_24();
end

% load foe_pru.mat;

ImaNew=detecta_huecos_mask2(ImaNew3,Mascara,3);

ImaResul = inpaint_foe(ImaNew, Mascara, p, iteraciones);


% load ImaResultante


%%%% En "ImagenZNew" se almacena los valores que ha calculado el algoritmo,
%%%% pero solamente para las celdas que pertenecen a los huecos de la
%%%% malla. Se le aplicara el factor de escala invertido, para que se
%%%% vuelva a la escala de valores inicial, antes del algoritmo.

ImagenZNew =ImaResul.*Mascara;
% ImagenZNew= (ImagenZNew.*factor_escala)+minimanew;
ImagenZNew= ((ImagenZNew./factor_escala).*maximanew)+minimanew;


%%%% En "ImaComp" se almacenara la nueva imagen de rango resultando de la
%%%% suma de la anterior (con huecos) y la nueva (solo los huecos).

ImaComp = ImagenRangoSin+ImagenZNew.*Mascara;


%%%% Se almacenan las filas y columnas en que se almacenan los valores de
%%%% relleno (antiguos huecos)
[filmas,colmas]=find(Mascara>0);

%%%%%%%%%%%%%%%%Mascara22=imdilate(Mascara ,strel('square',3));
%%%%%%%%%%%%%%%%[filmas22,colmas22]=find(Mascara22>0);

Mascara_copy=Mascara;
%%%%huecos=zeros(length(filmas),length(filmas));





%% Parte 2

tri_parche=[];
verticesNew=vertices;
carasNew=caras;
%verticesNew=[];
%carasNew=[];
todo_indices1=[];
todo_indices2=[];

coordenadas_tri=[];



close all;


%%%% A continuacion se añaden los valores de coordenadas X,Y y Z de los
%%%% puntos que se han obtenido como relleno del hueco. Ademas se
%%%% almacenaran los correspondientes indices a esos nuevos vertices en una
%%%% Matriz de Indices.


%%%% En "MatrizIndicesNew" se crea una unica matriz de indices que auna la
%%%% inicial (antes del relleno) y la creada con los puntos de relleno.
%%MatrizIndicesNew=MascaraIndi;



% MascaraIndi=zeros(size(Mascara));
for indimas=1:length(filmas)

%     verticesNew=[verticesNew;celdasX(colmas(indimas)) celdasY(filmas(indimas)) ImagenZNew(filmas(indimas),colmas(indimas))];
    coordenadas_tri=[coordenadas_tri;celdasX(colmas(indimas)) celdasY(filmas(indimas)) ImagenZNew(filmas(indimas),colmas(indimas))];

%     MascaraIndi(filmas(indimas),colmas(indimas))=indimas+length(vertices);
    todo_indices2=[todo_indices2;indimas+length(vertices)];

end

verticesNew=[verticesNew;coordenadas_tri];


% % % % MatrizIndicesNew=MascaraIndi+MatrizIndices;
% % % 
% % % 
% % % 
% % % % MatrizIndices_agu_l=cellfun('length',MatrizIndices_agu);
% % % % [filnos,colnos]=find(MatrizIndices_agu_l>0);
% % % % for indinos=1:length(filnos)
% % % %     for indoso=1:MatrizIndices_agu_l(filnos(indinos),colnos(indinos))
% % % %         coordenadas_tri=[coordenadas_tri;vertices(MatrizIndices_agu{filnos(indinos),colnos(indinos)}(indoso,1),:)];
% % % %         todo_indices1=[todo_indices1;MatrizIndices_agu{filnos(indinos),colnos(indinos)}(indoso,1)];
% % % %     end
% % % % 
% % % % end



todo_indices1=agujeros{agujero_actual}(1:end-1)';
coordenadas_tri=[coordenadas_tri;vertices(todo_indices1,:)];



todo_indices=[todo_indices2;todo_indices1];



coorx2=coordenadas_tri(:,1);
coory2=coordenadas_tri(:,2);
coorz2=coordenadas_tri(:,3);


coorx=coorx2;
coory=coory2;
coorz=coorz2;

num_puntos=length(filmas);


scale = 3 * max(max(abs([coorx2;coory2;coorz2])));
[temp,ind1] = sort(scale*scale*coorx2 + scale*coory2 + 1*coorz2);
coorx2 = coorx2(ind1);
coory2 = coory2(ind1);
coorz2 = coorz2(ind1);
%                 tri=triangulate([coorx2';coory2';coorz2'],distmedia/10);
if(triangulacion==1)
    tri=triangulate23([coorx2';coory2';coorz2']);
elseif(triangulacion==2)
    [tri]=Delaunay2_5D([coorx2 coory2 coorz2]);
    if(tri==123456)
        tri=triangulate23([coorx2';coory2';coorz2']);
    elseif(isempty(tri))
        tri=triangulate23([coorx2';coory2';coorz2']);
    else
        tri=tri';
    end
    options.method = 'slow';
    tri = perform_faces_reorientation([coorx2 coory2 coorz2],double(tri),options);
elseif(triangulacion==3)
    [puntos_struct,triangulos_struct]=StructTriMesh(1:size(Mascara,2),1:size(Mascara,1));
    tri=[];
    tri45=triangulos_struct;
    %     indi_trans=[];
    for indimas=1:length(filmas)
        punto_buscar=[filmas(indimas) colmas(indimas)];
        [filanu,colanu]=find(sum(abs(puntos_struct-punto_buscar(ones(size(puntos_struct,1),1),:)),2)==0);
        %          indi_trans=[indi_trans;filanu];
        tri45(triangulos_struct==filanu)=indimas;
        [filani,colani]=find(triangulos_struct==filanu);
        tri=[tri;tri45(filani,:)];

    end
    tri=tri';

  elseif(triangulacion==4)
  
    
    [tri]=MyCrustOpen([coorx2 coory2 coorz2]);
        tri=tri';

end

[normal1,normalf1] = compute_normal(vertices,caras);
[normal2,normalf2] = compute_normal([coorx2 coory2 coorz2],(tri'));
% if(dot(mean(normalf1'),mean(normalf2'))<0)
%     tri_copy=tri;
%     tri(1,:)=tri_copy(2,:);
%     tri(2,:)=tri_copy(1,:);
% end


% tri3=zeros(size(tri));
% for indice1=1:size(tri,2)
%     for indice2=1:3
%         tri3(indice2,indice1)=ind1(tri(indice2,indice1));
%     end
% end

tri3=ind1(tri);



coordenadas=[coorx coory coorz];





if(refinamiento==1)
    tri322=tri3;
    coordenadas2=coordenadas;
    FV.vertices=coordenadas2;
    FV.faces=tri322';
%     [FV2]=refinepatch(FV);
    [FV2]=refinarparche(FV);
    
    
    
    coordenadas2=FV2.vertices;
    tri322=FV2.faces;
    vertices_added=coordenadas2(size(coordenadas,1)+1:end,:);
    todo_indices=[todo_indices;[[1:size(vertices_added,1)]+todo_indices2(end)]'];
    
    verticesNew=[verticesNew;vertices_added];
    
    coordenadas=coordenadas2;
    tri3=tri322';
    
end




%%% PRUEBA  01-12-09
[fildo1,coldo1]=find(tri3>num_puntos);


triangulos_borde = tri3(:,coldo1)';
puntos_colindantes=setdiff(unique(reshape(triangulos_borde,length(fildo1)*3,1)),num_puntos+1:size(coordenadas,1));
coordenadas_colindantes=coordenadas(puntos_colindantes,:);
[triangulos_no_validos onaristas]=inpolygon(coordenadas_colindantes(:,1),coordenadas_colindantes(:,2),vertices(agujeros{agujero_actual}(1,1:end-1),1),vertices(agujeros{agujero_actual}(1,1:end-1),2));
tri8=tri3';

if(any(~triangulos_no_validos))
    [filana,coluna]=find(triangulos_no_validos==0);
    for indana=1:length(filana)
        [fildun,colun]=find(triangulos_borde==puntos_colindantes(1,filana(indana)));
%         tri8(coldo1(fildun),:)=[];
        tri8(setdiff(coldo1(fildun).*(coldo1(fildun)<size(tri8,1)),0),:)=[];
    end
end

tri6=tri8;

for indulio=num_puntos+1:size(coordenadas,1)-1

    [filulio,colulio]=find(tri6==indulio);
    [filulio2,colulio2]=find(tri6==indulio+1);

    [filulio3,colulio3]=find(tri6(filulio,:)==indulio+1);
    if((~isempty(filulio))&(isempty(filulio3)))
        interseccion=intersect(reshape(tri6(filulio,:),length(filulio)*3,1),reshape(tri6(filulio2,:),length(filulio2)*3,1));
        if(size(interseccion)==1)
            nueva_cara=[indulio indulio+1 interseccion];
            [nueva_normal nueva_normal_f]=compute_normal(coordenadas,[indulio indulio+1 interseccion]);
            if(dot(mean(normalf1'),nueva_normal_f')<0)
                
                tri6=[tri6;indulio indulio+1 interseccion];
            else
                tri6=[tri6;indulio+1 indulio interseccion];

            end
            
        end

    end


end




[filulio,colulio]=find(tri6==size(coordenadas,1));
    [filulio2,colulio2]=find(tri6==num_puntos+1);

    [filulio3,colulio3]=find(tri6(filulio,:)==num_puntos+1);
    if((~isempty(filulio))&(isempty(filulio3)))
        interseccion=intersect(reshape(tri6(filulio,:),length(filulio)*3,1),reshape(tri6(filulio2,:),length(filulio2)*3,1));
        if(size(interseccion)==1)
                    if(size(interseccion)==1)
            nueva_cara=[size(coordenadas,1) num_puntos+1 interseccion];
            [nueva_normal nueva_normal_f]=compute_normal(coordenadas,[size(coordenadas,1) num_puntos+1 interseccion]);
            if(dot(mean(normalf1'),nueva_normal_f')<0)
                
                tri6=[tri6;size(coordenadas,1) num_puntos+1 interseccion];
            else
                tri6=[tri6;num_puntos+1 size(coordenadas,1) interseccion];

            end
            
        end
            
            
        end

    end
    tri3=tri6';
%%% FIN PRUEBA  01-12-09













[fildo,coldo]=find(sum(tri3>num_puntos)==3);
tri6=tri3';

if(~isempty(fildo))
triangulos_borde = tri3(:,coldo)';


longitud=size(triangulos_borde,1);
coordenadas_medias=[];
for indulo=1:longitud
    coordenadas_medias=[coordenadas_medias;mean(coordenadas(triangulos_borde(indulo,:)',:))];
end

[triangulos_no_validos onaristas]=inpolygon(coordenadas_medias(:,1),coordenadas_medias(:,2),vertices(agujeros{agujero_actual}(1,1:end-1),1),vertices(agujeros{agujero_actual}(1,1:end-1),2));

if(any(~triangulos_no_validos))
    tri6(coldo(triangulos_no_validos==0),:)=[];
end
end






























% coordenadas_borde2D=coordenadas(num_puntos+1:end,1:2);
% coordenadas_borde2D=[coordenadas_borde2D;coordenadas_borde2D(1,:)];

% lista_aristas=[triangulos_borde(:,1:2);triangulos_borde(:,2:3);[triangulos_borde(:,3) triangulos_borde(:,1)]];
% coordenadas_medias=cat(3,coordenadas(lista_aristas(:,1),:),coordenadas(lista_aristas(:,2),:));
% pto_medio=mean(coordenadas_medias,3);
% [aristas_no_validas onaristas]=inpolygon(pto_medio(:,1),pto_medio(:,2),coordenadas_borde2D(:,1),coordenadas_borde2D(:,2));
% indices_no_validos=(lista_aristas(find(~aristas_no_validas),:))';
% cordenadas_no_validas=coordenadas(indices_no_validos(:),:);
% 
% tri_dist=elimina_aristas(tri3,coordenadas, coordenadas_borde2D);
% 
% eliminador=sort(unique([find(sum(tri_dist)>0) coldo(find(~aristas_no_validas)-length(coldo)*(ceil(find(~aristas_no_validas)/length(coldo))-1))]));
% tri4=tri3;
% tri4(:,coldo(find(~aristas_no_validas)-length(coldo)*(ceil(find(~aristas_no_validas)/length(coldo))-1)))=[];
% tri3=tri4;
% 
% tri=tri3;
% 
% tri=tri';




tri=tri6;


if (invierte==1)
    tritemp=tri;
    tri(:,2)=tritemp(:,3);
    tri(:,3)=tritemp(:,2);
end

% tri2=zeros(size(tri));
% for indice1=1:size(tri,1)
%     for indice2=1:3
% 
%         tri2(indice1,indice2)=todo_indices((tri(indice1,indice2)),1);
% 
%     end
% end
        tri2=todo_indices(tri);


% carastri=[carastri;tri2];
carastri=tri2;







%%%% Se pasa al siguiente hueco a triangular, a la vez que se elimina de la
%%%% mascara de partida el hueco que ya se ha triangulado.

% indicador=indicador+1;
% Mascara_copy=Mascara_copy-Masca1;




% %% Parte 3
%%%% Se constituye la matriz total de caras: las de partida, mas los huecos
%%%% que se han triangulado.


% carasNew=[carasNew;carastri];
if(all(size(carastri)==[3 1]))
    carastri=carastri';
end
carasNew=[carasNew;carastri];



%%%%%%%% ELIMINAR VERTICES DESCONECTADOS
% [conn,connnum,count]=meshconn(tri3',length(coordenadas));
% vertices_a_eliminar=cellfun('isempty',conn);
% [filelim,colelim]=find(vertices_a_eliminar==1);
% elimina=setdiff(filelim,(length(filmas)+1):size(coordenadas,1))
% coordenadas(elimina,:)=[];
% 
% 
% vertices_agujero=[(size(vertices,1)+1) size(vertices,1)+size(filmas,1)-length(elimina)];
%%%%%%%% ELIMINAR VERTICES DESCONECTADOS


%%%% Se graban en dos archivos VRML la nueva malla total, asi como una
%%%% malla que consta solamente de los huecos triangulados.

vertices_agujero=[(size(vertices,1)+1) size(verticesNew,1)];

vertices_relleno=coordenadas;
caras_relleno=tri;







