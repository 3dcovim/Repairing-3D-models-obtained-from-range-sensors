function [vertices_parche,caras_parche]=define_parche3(vertices,caras,normales,borde_hueco,entorno,Cmax,factor_limite,conn)


nuevo_borde=borde_hueco;
vertices_parche=[];
caras_parche=[];
caras_parche_ind=[];
% caras_parche2=[];
indices1=[];
normales_borde=mean(normales(borde_hueco,:));
if(factor_limite~=0)
    [filu,colu]=find(Cmax>mean(Cmax)*factor_limite);
else
    filu=[];
end

aristas3=[caras(:,1) ;caras(:,2); caras(:,3)];
for indil=1:entorno

    nuevo_borde=setdiff(nuevo_borde,filu);


    nuevo_borde=setdiff(cell2mat(conn(nuevo_borde,:)'),nuevo_borde);
%     pertenencia = ismember(caras, nuevo_borde);
%     [filun,colun]=find(pertenencia==1);
%     tri_borde=pertenencia(filun,:);
%     tri_borde2=caras(filun,:).*~tri_borde;
%     nuevo_borde=setdiff(unique([tri_borde2(:,1);tri_borde2(:,2);tri_borde2(:,3)]),0);




%     caras_parche_ind=[caras_parche_ind;filun];


    vertices_parche=[vertices_parche; nuevo_borde'];

end

vertices_parche=sort(unique(vertices_parche));
% [ordenu,fffu]=unique(uint64(10000*(caras_parche(:,1).*caras_parche(:,2)./caras_parche(:,3))));
% [ordenu,fffu]=unique(caras_parche,'rows');
pertenencia = ismember(caras, vertices_parche);
 [filun,colun]=find(pertenencia==1);
%     tri_borde=pertenencia(filun,:);
%     tri_borde2=caras(filun,:).*~tri_borde;
caras_parche=caras(unique(filun),:);
% vertices_parche=vertices_parche';

