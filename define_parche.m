function [vertices_parche,caras_parche]=define_parche(vertices,caras,normales,borde_hueco,entorno,Cmax)
nuevo_borde=borde_hueco;
vertices_parche=[];
caras_parche=[];
% caras_parche2=[];
indices1=[];
normales_borde=mean(normales(borde_hueco,:));

% [filu,colu]=find(Cmax>mean(Cmax)*3);
filu=[];

for indil=1:entorno
    contiguos=[];

    nuevo_borde=setdiff(nuevo_borde,filu);


    for iju=1:length(nuevo_borde)


        if(dot(norm(normales_borde),norm(normales(nuevo_borde(1,iju))))>0)
            [indifil,indicol]=find(caras==nuevo_borde(1,iju));


            %         [normal1,normalf1] = compute_normal(vertices,caras(indifil,:));

            % if(dot(mean(normalf1'),mean(normalf2'))<0)
            %     tri_copy=tri;
            %     tri(1,:)=tri_copy(2,:);
            %     tri(2,:)=tri_copy(1,:);
            % end


            %         [difecaras,indicaras]=setdiff(reshape(caras(indifil,:),1,3*length(indifil)),nuevo_borde);
            %         [unicaras,unifil]=unique(difecaras);
            %         contiguos=[contiguos unicaras];
            %         longitud=length(indifil);
            %         carassel=indicaras/longitud;
            %         carassel=carassel-fix(carassel);
            %         caras_a_anadir=(unique(uint64((carassel*longitud)+(longitud*(carassel==0)))));
            %         caras_parche2=[caras_parche2;caras(indifil(caras_a_anadir'),:)];
            caras_parche=[caras_parche;caras(indifil,:)];
            contiguos=[contiguos unique(setdiff(reshape(caras(indifil,:),1,3*length(indifil)),nuevo_borde))];
        end


    end
    %     [nuevo_borde,indice1]=(unique(contiguos));
    nuevo_borde=sort(unique(contiguos));


    vertices_parche=[vertices_parche nuevo_borde];

end

vertices_parche=sort(unique(vertices_parche));
% [ordenu,fffu]=unique(uint64(10000*(caras_parche(:,1).*caras_parche(:,2)./caras_parche(:,3))));
[ordenu,fffu]=unique(caras_parche,'rows');

caras_parche=caras_parche(fffu,:);
ff=0;
